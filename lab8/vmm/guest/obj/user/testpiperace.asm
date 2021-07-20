
vmm/guest/obj/user/testpiperace:     formato del fichero elf64-x86-64


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
  80003c:	e8 44 03 00 00       	callq  800385 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 44 38 80 00 00 	movabs $0x803844,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba d9 40 80 00 00 	movabs $0x8040d9,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf e2 40 80 00 00 	movabs $0x8040e2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba f6 40 80 00 00 	movabs $0x8040f6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf e2 40 80 00 00 	movabs $0x8040e2,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 08 3b 80 00 00 	movabs $0x803b08,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf ff 40 80 00 00 	movabs $0x8040ff,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 e5 03 80 00 00 	movabs $0x8003e5,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 1a 41 80 00 00 	movabs $0x80411a,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 98                	cltq   
  8001d0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001de:	00 00 00 
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f3:	00 00 00 
  8001f6:	48 29 c2             	sub    %rax,%rdx
  8001f9:	48 89 d0             	mov    %rdx,%rax
  8001fc:	48 c1 f8 03          	sar    $0x3,%rax
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	48 b8 a5 4f fa a4 4f 	movabs $0x4fa4fa4fa4fa4fa5,%rax
  80020a:	fa a4 4f 
  80020d:	48 0f af c2          	imul   %rdx,%rax
  800211:	48 89 c6             	mov    %rax,%rsi
  800214:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 fe 24 80 00 00 	movabs $0x8024fe,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 fe 24 80 00 00 	movabs $0x8024fe,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80025d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800261:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800267:	83 f8 02             	cmp    $0x2,%eax
  80026a:	74 db                	je     800247 <umain+0x204>

	cprintf("child done with loop\n");
  80026c:	48 bf 30 41 80 00 00 	movabs $0x804130,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 08 3b 80 00 00 	movabs $0x803b08,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba 48 41 80 00 00 	movabs $0x804148,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002ab:	48 bf e2 40 80 00 00 	movabs $0x8040e2,%rdi
  8002b2:	00 00 00 
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  8002c1:	00 00 00 
  8002c4:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002c9:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002cd:	48 89 d6             	mov    %rdx,%rsi
  8002d0:	89 c7                	mov    %eax,%edi
  8002d2:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba 72 41 80 00 00 	movabs $0x804172,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3c 00 00 00       	mov    $0x3c,%esi
  8002fb:	48 bf e2 40 80 00 00 	movabs $0x8040e2,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 ad 2f 80 00 00 	movabs $0x802fad,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf 8a 41 80 00 00 	movabs $0x80418a,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  80035c:	00 00 00 
  80035f:	ff d2                	callq  *%rdx
  800361:	eb 20                	jmp    800383 <umain+0x340>
	else
		cprintf("\nrace didn't happen\n", max);
  800363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
}
  800383:	c9                   	leaveq 
  800384:	c3                   	retq   

0000000000800385 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800385:	55                   	push   %rbp
  800386:	48 89 e5             	mov    %rsp,%rbp
  800389:	48 83 ec 10          	sub    $0x10,%rsp
  80038d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800390:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800394:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80039b:	00 00 00 
  80039e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a9:	7e 14                	jle    8003bf <libmain+0x3a>
		binaryname = argv[0];
  8003ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003af:	48 8b 10             	mov    (%rax),%rdx
  8003b2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003b9:	00 00 00 
  8003bc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c6:	48 89 d6             	mov    %rdx,%rsi
  8003c9:	89 c7                	mov    %eax,%edi
  8003cb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003d7:	48 b8 e5 03 80 00 00 	movabs $0x8003e5,%rax
  8003de:	00 00 00 
  8003e1:	ff d0                	callq  *%rax
}
  8003e3:	c9                   	leaveq 
  8003e4:	c3                   	retq   

00000000008003e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e5:	55                   	push   %rbp
  8003e6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003e9:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  8003f0:	00 00 00 
  8003f3:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8003fa:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
}
  800406:	5d                   	pop    %rbp
  800407:	c3                   	retq   

0000000000800408 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
  80040c:	53                   	push   %rbx
  80040d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800414:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80041b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800421:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800428:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80042f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800436:	84 c0                	test   %al,%al
  800438:	74 23                	je     80045d <_panic+0x55>
  80043a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800441:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800445:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800449:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80044d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800451:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800455:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800459:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80045d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800464:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80046b:	00 00 00 
  80046e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800475:	00 00 00 
  800478:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80047c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800483:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80048a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800491:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800498:	00 00 00 
  80049b:	48 8b 18             	mov    (%rax),%rbx
  80049e:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  8004a5:	00 00 00 
  8004a8:	ff d0                	callq  *%rax
  8004aa:	89 c6                	mov    %eax,%esi
  8004ac:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8004b2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004b9:	41 89 d0             	mov    %edx,%r8d
  8004bc:	48 89 c1             	mov    %rax,%rcx
  8004bf:	48 89 da             	mov    %rbx,%rdx
  8004c2:	48 bf c0 41 80 00 00 	movabs $0x8041c0,%rdi
  8004c9:	00 00 00 
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	49 b9 41 06 80 00 00 	movabs $0x800641,%r9
  8004d8:	00 00 00 
  8004db:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004de:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ec:	48 89 d6             	mov    %rdx,%rsi
  8004ef:	48 89 c7             	mov    %rax,%rdi
  8004f2:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
	cprintf("\n");
  8004fe:	48 bf e3 41 80 00 00 	movabs $0x8041e3,%rdi
  800505:	00 00 00 
  800508:	b8 00 00 00 00       	mov    $0x0,%eax
  80050d:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  800514:	00 00 00 
  800517:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800519:	cc                   	int3   
  80051a:	eb fd                	jmp    800519 <_panic+0x111>

000000000080051c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80051c:	55                   	push   %rbp
  80051d:	48 89 e5             	mov    %rsp,%rbp
  800520:	48 83 ec 10          	sub    $0x10,%rsp
  800524:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800527:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80052b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052f:	8b 00                	mov    (%rax),%eax
  800531:	8d 48 01             	lea    0x1(%rax),%ecx
  800534:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800538:	89 0a                	mov    %ecx,(%rdx)
  80053a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80053d:	89 d1                	mov    %edx,%ecx
  80053f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800543:	48 98                	cltq   
  800545:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054d:	8b 00                	mov    (%rax),%eax
  80054f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800554:	75 2c                	jne    800582 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055a:	8b 00                	mov    (%rax),%eax
  80055c:	48 98                	cltq   
  80055e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800562:	48 83 c2 08          	add    $0x8,%rdx
  800566:	48 89 c6             	mov    %rax,%rsi
  800569:	48 89 d7             	mov    %rdx,%rdi
  80056c:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  800573:	00 00 00 
  800576:	ff d0                	callq  *%rax
        b->idx = 0;
  800578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800586:	8b 40 04             	mov    0x4(%rax),%eax
  800589:	8d 50 01             	lea    0x1(%rax),%edx
  80058c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800590:	89 50 04             	mov    %edx,0x4(%rax)
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005a7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005ae:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005bc:	48 8b 0a             	mov    (%rdx),%rcx
  8005bf:	48 89 08             	mov    %rcx,(%rax)
  8005c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005d9:	00 00 00 
    b.cnt = 0;
  8005dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005e6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ed:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005fb:	48 89 c6             	mov    %rax,%rsi
  8005fe:	48 bf 1c 05 80 00 00 	movabs $0x80051c,%rdi
  800605:	00 00 00 
  800608:	48 b8 e0 09 80 00 00 	movabs $0x8009e0,%rax
  80060f:	00 00 00 
  800612:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800614:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80061a:	48 98                	cltq   
  80061c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800623:	48 83 c2 08          	add    $0x8,%rdx
  800627:	48 89 c6             	mov    %rax,%rsi
  80062a:	48 89 d7             	mov    %rdx,%rdi
  80062d:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  800634:	00 00 00 
  800637:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800639:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80063f:	c9                   	leaveq 
  800640:	c3                   	retq   

0000000000800641 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800641:	55                   	push   %rbp
  800642:	48 89 e5             	mov    %rsp,%rbp
  800645:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80064c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800653:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80065a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800661:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800668:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80066f:	84 c0                	test   %al,%al
  800671:	74 20                	je     800693 <cprintf+0x52>
  800673:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800677:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80067b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80067f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800683:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800687:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80068b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80068f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800693:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80069a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006a1:	00 00 00 
  8006a4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ab:	00 00 00 
  8006ae:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006b9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006c7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006ce:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d5:	48 8b 0a             	mov    (%rdx),%rcx
  8006d8:	48 89 08             	mov    %rcx,(%rax)
  8006db:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006df:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006eb:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006f2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006f9:	48 89 d6             	mov    %rdx,%rsi
  8006fc:	48 89 c7             	mov    %rax,%rdi
  8006ff:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800711:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800717:	c9                   	leaveq 
  800718:	c3                   	retq   

0000000000800719 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800719:	55                   	push   %rbp
  80071a:	48 89 e5             	mov    %rsp,%rbp
  80071d:	48 83 ec 30          	sub    $0x30,%rsp
  800721:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800725:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800729:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80072d:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800730:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800734:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800738:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80073b:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80073f:	77 42                	ja     800783 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800741:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800744:	8d 78 ff             	lea    -0x1(%rax),%edi
  800747:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
  800753:	48 f7 f6             	div    %rsi
  800756:	49 89 c2             	mov    %rax,%r10
  800759:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80075c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80075f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800767:	41 89 c9             	mov    %ecx,%r9d
  80076a:	41 89 f8             	mov    %edi,%r8d
  80076d:	89 d1                	mov    %edx,%ecx
  80076f:	4c 89 d2             	mov    %r10,%rdx
  800772:	48 89 c7             	mov    %rax,%rdi
  800775:	48 b8 19 07 80 00 00 	movabs $0x800719,%rax
  80077c:	00 00 00 
  80077f:	ff d0                	callq  *%rax
  800781:	eb 1e                	jmp    8007a1 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800783:	eb 12                	jmp    800797 <printnum+0x7e>
			putch(padc, putdat);
  800785:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800789:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80078c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800790:	48 89 ce             	mov    %rcx,%rsi
  800793:	89 d7                	mov    %edx,%edi
  800795:	ff d0                	callq  *%rax
		while (--width > 0)
  800797:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80079b:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80079f:	7f e4                	jg     800785 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	48 f7 f1             	div    %rcx
  8007b0:	48 b8 f0 43 80 00 00 	movabs $0x8043f0,%rax
  8007b7:	00 00 00 
  8007ba:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8007be:	0f be d0             	movsbl %al,%edx
  8007c1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007c9:	48 89 ce             	mov    %rcx,%rsi
  8007cc:	89 d7                	mov    %edx,%edi
  8007ce:	ff d0                	callq  *%rax
}
  8007d0:	c9                   	leaveq 
  8007d1:	c3                   	retq   

00000000008007d2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d2:	55                   	push   %rbp
  8007d3:	48 89 e5             	mov    %rsp,%rbp
  8007d6:	48 83 ec 20          	sub    $0x20,%rsp
  8007da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007de:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007e1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e5:	7e 4f                	jle    800836 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8007e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007eb:	8b 00                	mov    (%rax),%eax
  8007ed:	83 f8 30             	cmp    $0x30,%eax
  8007f0:	73 24                	jae    800816 <getuint+0x44>
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	8b 00                	mov    (%rax),%eax
  800800:	89 c0                	mov    %eax,%eax
  800802:	48 01 d0             	add    %rdx,%rax
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	8b 12                	mov    (%rdx),%edx
  80080b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800812:	89 0a                	mov    %ecx,(%rdx)
  800814:	eb 14                	jmp    80082a <getuint+0x58>
  800816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80081e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082a:	48 8b 00             	mov    (%rax),%rax
  80082d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800831:	e9 9d 00 00 00       	jmpq   8008d3 <getuint+0x101>
	else if (lflag)
  800836:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083a:	74 4c                	je     800888 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80083c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800840:	8b 00                	mov    (%rax),%eax
  800842:	83 f8 30             	cmp    $0x30,%eax
  800845:	73 24                	jae    80086b <getuint+0x99>
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800853:	8b 00                	mov    (%rax),%eax
  800855:	89 c0                	mov    %eax,%eax
  800857:	48 01 d0             	add    %rdx,%rax
  80085a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085e:	8b 12                	mov    (%rdx),%edx
  800860:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800867:	89 0a                	mov    %ecx,(%rdx)
  800869:	eb 14                	jmp    80087f <getuint+0xad>
  80086b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800873:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800877:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087f:	48 8b 00             	mov    (%rax),%rax
  800882:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800886:	eb 4b                	jmp    8008d3 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	8b 00                	mov    (%rax),%eax
  80088e:	83 f8 30             	cmp    $0x30,%eax
  800891:	73 24                	jae    8008b7 <getuint+0xe5>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	8b 00                	mov    (%rax),%eax
  8008a1:	89 c0                	mov    %eax,%eax
  8008a3:	48 01 d0             	add    %rdx,%rax
  8008a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008aa:	8b 12                	mov    (%rdx),%edx
  8008ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b3:	89 0a                	mov    %ecx,(%rdx)
  8008b5:	eb 14                	jmp    8008cb <getuint+0xf9>
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008bf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cb:	8b 00                	mov    (%rax),%eax
  8008cd:	89 c0                	mov    %eax,%eax
  8008cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d7:	c9                   	leaveq 
  8008d8:	c3                   	retq   

00000000008008d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d9:	55                   	push   %rbp
  8008da:	48 89 e5             	mov    %rsp,%rbp
  8008dd:	48 83 ec 20          	sub    $0x20,%rsp
  8008e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008e8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ec:	7e 4f                	jle    80093d <getint+0x64>
		x=va_arg(*ap, long long);
  8008ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f2:	8b 00                	mov    (%rax),%eax
  8008f4:	83 f8 30             	cmp    $0x30,%eax
  8008f7:	73 24                	jae    80091d <getint+0x44>
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	8b 00                	mov    (%rax),%eax
  800907:	89 c0                	mov    %eax,%eax
  800909:	48 01 d0             	add    %rdx,%rax
  80090c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800910:	8b 12                	mov    (%rdx),%edx
  800912:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800915:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800919:	89 0a                	mov    %ecx,(%rdx)
  80091b:	eb 14                	jmp    800931 <getint+0x58>
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	48 8b 40 08          	mov    0x8(%rax),%rax
  800925:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800929:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800931:	48 8b 00             	mov    (%rax),%rax
  800934:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800938:	e9 9d 00 00 00       	jmpq   8009da <getint+0x101>
	else if (lflag)
  80093d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800941:	74 4c                	je     80098f <getint+0xb6>
		x=va_arg(*ap, long);
  800943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800947:	8b 00                	mov    (%rax),%eax
  800949:	83 f8 30             	cmp    $0x30,%eax
  80094c:	73 24                	jae    800972 <getint+0x99>
  80094e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800952:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	8b 00                	mov    (%rax),%eax
  80095c:	89 c0                	mov    %eax,%eax
  80095e:	48 01 d0             	add    %rdx,%rax
  800961:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800965:	8b 12                	mov    (%rdx),%edx
  800967:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096e:	89 0a                	mov    %ecx,(%rdx)
  800970:	eb 14                	jmp    800986 <getint+0xad>
  800972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800976:	48 8b 40 08          	mov    0x8(%rax),%rax
  80097a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80097e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800982:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800986:	48 8b 00             	mov    (%rax),%rax
  800989:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80098d:	eb 4b                	jmp    8009da <getint+0x101>
	else
		x=va_arg(*ap, int);
  80098f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800993:	8b 00                	mov    (%rax),%eax
  800995:	83 f8 30             	cmp    $0x30,%eax
  800998:	73 24                	jae    8009be <getint+0xe5>
  80099a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	8b 00                	mov    (%rax),%eax
  8009a8:	89 c0                	mov    %eax,%eax
  8009aa:	48 01 d0             	add    %rdx,%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	8b 12                	mov    (%rdx),%edx
  8009b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ba:	89 0a                	mov    %ecx,(%rdx)
  8009bc:	eb 14                	jmp    8009d2 <getint+0xf9>
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d2:	8b 00                	mov    (%rax),%eax
  8009d4:	48 98                	cltq   
  8009d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009de:	c9                   	leaveq 
  8009df:	c3                   	retq   

00000000008009e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009e0:	55                   	push   %rbp
  8009e1:	48 89 e5             	mov    %rsp,%rbp
  8009e4:	41 54                	push   %r12
  8009e6:	53                   	push   %rbx
  8009e7:	48 83 ec 60          	sub    $0x60,%rsp
  8009eb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009ef:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009f3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009f7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ff:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a03:	48 8b 0a             	mov    (%rdx),%rcx
  800a06:	48 89 08             	mov    %rcx,(%rax)
  800a09:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a0d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a11:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a15:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a19:	eb 17                	jmp    800a32 <vprintfmt+0x52>
			if (ch == '\0')
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	0f 84 c5 04 00 00    	je     800ee8 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800a23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2b:	48 89 d6             	mov    %rdx,%rsi
  800a2e:	89 df                	mov    %ebx,%edi
  800a30:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a32:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a36:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a3a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a3e:	0f b6 00             	movzbl (%rax),%eax
  800a41:	0f b6 d8             	movzbl %al,%ebx
  800a44:	83 fb 25             	cmp    $0x25,%ebx
  800a47:	75 d2                	jne    800a1b <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800a49:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a4d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a54:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a62:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a75:	0f b6 00             	movzbl (%rax),%eax
  800a78:	0f b6 d8             	movzbl %al,%ebx
  800a7b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a7e:	83 f8 55             	cmp    $0x55,%eax
  800a81:	0f 87 2e 04 00 00    	ja     800eb5 <vprintfmt+0x4d5>
  800a87:	89 c0                	mov    %eax,%eax
  800a89:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a90:	00 
  800a91:	48 b8 18 44 80 00 00 	movabs $0x804418,%rax
  800a98:	00 00 00 
  800a9b:	48 01 d0             	add    %rdx,%rax
  800a9e:	48 8b 00             	mov    (%rax),%rax
  800aa1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aa3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aa7:	eb c0                	jmp    800a69 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aad:	eb ba                	jmp    800a69 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aaf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ab6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ab9:	89 d0                	mov    %edx,%eax
  800abb:	c1 e0 02             	shl    $0x2,%eax
  800abe:	01 d0                	add    %edx,%eax
  800ac0:	01 c0                	add    %eax,%eax
  800ac2:	01 d8                	add    %ebx,%eax
  800ac4:	83 e8 30             	sub    $0x30,%eax
  800ac7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800aca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ace:	0f b6 00             	movzbl (%rax),%eax
  800ad1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ad4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad7:	7e 0c                	jle    800ae5 <vprintfmt+0x105>
  800ad9:	83 fb 39             	cmp    $0x39,%ebx
  800adc:	7f 07                	jg     800ae5 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800ade:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800ae3:	eb d1                	jmp    800ab6 <vprintfmt+0xd6>
			goto process_precision;
  800ae5:	eb 50                	jmp    800b37 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800ae7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aea:	83 f8 30             	cmp    $0x30,%eax
  800aed:	73 17                	jae    800b06 <vprintfmt+0x126>
  800aef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af6:	89 d2                	mov    %edx,%edx
  800af8:	48 01 d0             	add    %rdx,%rax
  800afb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afe:	83 c2 08             	add    $0x8,%edx
  800b01:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b04:	eb 0c                	jmp    800b12 <vprintfmt+0x132>
  800b06:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b0a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b12:	8b 00                	mov    (%rax),%eax
  800b14:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b17:	eb 1e                	jmp    800b37 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800b19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1d:	79 07                	jns    800b26 <vprintfmt+0x146>
				width = 0;
  800b1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b26:	e9 3e ff ff ff       	jmpq   800a69 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b2b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b32:	e9 32 ff ff ff       	jmpq   800a69 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b37:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3b:	79 0d                	jns    800b4a <vprintfmt+0x16a>
				width = precision, precision = -1;
  800b3d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b40:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b43:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b4a:	e9 1a ff ff ff       	jmpq   800a69 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b4f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b53:	e9 11 ff ff ff       	jmpq   800a69 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5b:	83 f8 30             	cmp    $0x30,%eax
  800b5e:	73 17                	jae    800b77 <vprintfmt+0x197>
  800b60:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b67:	89 d2                	mov    %edx,%edx
  800b69:	48 01 d0             	add    %rdx,%rax
  800b6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b6f:	83 c2 08             	add    $0x8,%edx
  800b72:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b75:	eb 0c                	jmp    800b83 <vprintfmt+0x1a3>
  800b77:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b7b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b83:	8b 10                	mov    (%rax),%edx
  800b85:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	48 89 ce             	mov    %rcx,%rsi
  800b90:	89 d7                	mov    %edx,%edi
  800b92:	ff d0                	callq  *%rax
			break;
  800b94:	e9 4a 03 00 00       	jmpq   800ee3 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9c:	83 f8 30             	cmp    $0x30,%eax
  800b9f:	73 17                	jae    800bb8 <vprintfmt+0x1d8>
  800ba1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ba5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba8:	89 d2                	mov    %edx,%edx
  800baa:	48 01 d0             	add    %rdx,%rax
  800bad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb0:	83 c2 08             	add    $0x8,%edx
  800bb3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb6:	eb 0c                	jmp    800bc4 <vprintfmt+0x1e4>
  800bb8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bbc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bc0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	79 02                	jns    800bcc <vprintfmt+0x1ec>
				err = -err;
  800bca:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bcc:	83 fb 15             	cmp    $0x15,%ebx
  800bcf:	7f 16                	jg     800be7 <vprintfmt+0x207>
  800bd1:	48 b8 40 43 80 00 00 	movabs $0x804340,%rax
  800bd8:	00 00 00 
  800bdb:	48 63 d3             	movslq %ebx,%rdx
  800bde:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800be2:	4d 85 e4             	test   %r12,%r12
  800be5:	75 2e                	jne    800c15 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800be7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	89 d9                	mov    %ebx,%ecx
  800bf1:	48 ba 01 44 80 00 00 	movabs $0x804401,%rdx
  800bf8:	00 00 00 
  800bfb:	48 89 c7             	mov    %rax,%rdi
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	49 b8 f1 0e 80 00 00 	movabs $0x800ef1,%r8
  800c0a:	00 00 00 
  800c0d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c10:	e9 ce 02 00 00       	jmpq   800ee3 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800c15:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1d:	4c 89 e1             	mov    %r12,%rcx
  800c20:	48 ba 0a 44 80 00 00 	movabs $0x80440a,%rdx
  800c27:	00 00 00 
  800c2a:	48 89 c7             	mov    %rax,%rdi
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c32:	49 b8 f1 0e 80 00 00 	movabs $0x800ef1,%r8
  800c39:	00 00 00 
  800c3c:	41 ff d0             	callq  *%r8
			break;
  800c3f:	e9 9f 02 00 00       	jmpq   800ee3 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c47:	83 f8 30             	cmp    $0x30,%eax
  800c4a:	73 17                	jae    800c63 <vprintfmt+0x283>
  800c4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c53:	89 d2                	mov    %edx,%edx
  800c55:	48 01 d0             	add    %rdx,%rax
  800c58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c5b:	83 c2 08             	add    $0x8,%edx
  800c5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c61:	eb 0c                	jmp    800c6f <vprintfmt+0x28f>
  800c63:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c67:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6f:	4c 8b 20             	mov    (%rax),%r12
  800c72:	4d 85 e4             	test   %r12,%r12
  800c75:	75 0a                	jne    800c81 <vprintfmt+0x2a1>
				p = "(null)";
  800c77:	49 bc 0d 44 80 00 00 	movabs $0x80440d,%r12
  800c7e:	00 00 00 
			if (width > 0 && padc != '-')
  800c81:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c85:	7e 3f                	jle    800cc6 <vprintfmt+0x2e6>
  800c87:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c8b:	74 39                	je     800cc6 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c8d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c90:	48 98                	cltq   
  800c92:	48 89 c6             	mov    %rax,%rsi
  800c95:	4c 89 e7             	mov    %r12,%rdi
  800c98:	48 b8 9d 11 80 00 00 	movabs $0x80119d,%rax
  800c9f:	00 00 00 
  800ca2:	ff d0                	callq  *%rax
  800ca4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca7:	eb 17                	jmp    800cc0 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800ca9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb5:	48 89 ce             	mov    %rcx,%rsi
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc4:	7f e3                	jg     800ca9 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc6:	eb 37                	jmp    800cff <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ccc:	74 1e                	je     800cec <vprintfmt+0x30c>
  800cce:	83 fb 1f             	cmp    $0x1f,%ebx
  800cd1:	7e 05                	jle    800cd8 <vprintfmt+0x2f8>
  800cd3:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd6:	7e 14                	jle    800cec <vprintfmt+0x30c>
					putch('?', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce8:	ff d0                	callq  *%rax
  800cea:	eb 0f                	jmp    800cfb <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800cec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf4:	48 89 d6             	mov    %rdx,%rsi
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cff:	4c 89 e0             	mov    %r12,%rax
  800d02:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d06:	0f b6 00             	movzbl (%rax),%eax
  800d09:	0f be d8             	movsbl %al,%ebx
  800d0c:	85 db                	test   %ebx,%ebx
  800d0e:	74 10                	je     800d20 <vprintfmt+0x340>
  800d10:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d14:	78 b2                	js     800cc8 <vprintfmt+0x2e8>
  800d16:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d1a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d1e:	79 a8                	jns    800cc8 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800d20:	eb 16                	jmp    800d38 <vprintfmt+0x358>
				putch(' ', putdat);
  800d22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	48 89 d6             	mov    %rdx,%rsi
  800d2d:	bf 20 00 00 00       	mov    $0x20,%edi
  800d32:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800d34:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3c:	7f e4                	jg     800d22 <vprintfmt+0x342>
			break;
  800d3e:	e9 a0 01 00 00       	jmpq   800ee3 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d47:	be 03 00 00 00       	mov    $0x3,%esi
  800d4c:	48 89 c7             	mov    %rax,%rdi
  800d4f:	48 b8 d9 08 80 00 00 	movabs $0x8008d9,%rax
  800d56:	00 00 00 
  800d59:	ff d0                	callq  *%rax
  800d5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d63:	48 85 c0             	test   %rax,%rax
  800d66:	79 1d                	jns    800d85 <vprintfmt+0x3a5>
				putch('-', putdat);
  800d68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d70:	48 89 d6             	mov    %rdx,%rsi
  800d73:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d78:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7e:	48 f7 d8             	neg    %rax
  800d81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d85:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d8c:	e9 e5 00 00 00       	jmpq   800e76 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d91:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d95:	be 03 00 00 00       	mov    $0x3,%esi
  800d9a:	48 89 c7             	mov    %rax,%rdi
  800d9d:	48 b8 d2 07 80 00 00 	movabs $0x8007d2,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
  800da9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db4:	e9 bd 00 00 00       	jmpq   800e76 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800db9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dbd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc1:	48 89 d6             	mov    %rdx,%rsi
  800dc4:	bf 58 00 00 00       	mov    $0x58,%edi
  800dc9:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd3:	48 89 d6             	mov    %rdx,%rsi
  800dd6:	bf 58 00 00 00       	mov    $0x58,%edi
  800ddb:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ddd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de5:	48 89 d6             	mov    %rdx,%rsi
  800de8:	bf 58 00 00 00       	mov    $0x58,%edi
  800ded:	ff d0                	callq  *%rax
			break;
  800def:	e9 ef 00 00 00       	jmpq   800ee3 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800df4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfc:	48 89 d6             	mov    %rdx,%rsi
  800dff:	bf 30 00 00 00       	mov    $0x30,%edi
  800e04:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	48 89 d6             	mov    %rdx,%rsi
  800e11:	bf 78 00 00 00       	mov    $0x78,%edi
  800e16:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1b:	83 f8 30             	cmp    $0x30,%eax
  800e1e:	73 17                	jae    800e37 <vprintfmt+0x457>
  800e20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e27:	89 d2                	mov    %edx,%edx
  800e29:	48 01 d0             	add    %rdx,%rax
  800e2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e2f:	83 c2 08             	add    $0x8,%edx
  800e32:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800e35:	eb 0c                	jmp    800e43 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800e37:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e3b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e43:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800e46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e4a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e51:	eb 23                	jmp    800e76 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e57:	be 03 00 00 00       	mov    $0x3,%esi
  800e5c:	48 89 c7             	mov    %rax,%rdi
  800e5f:	48 b8 d2 07 80 00 00 	movabs $0x8007d2,%rax
  800e66:	00 00 00 
  800e69:	ff d0                	callq  *%rax
  800e6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e76:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e7b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e7e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e85:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8d:	45 89 c1             	mov    %r8d,%r9d
  800e90:	41 89 f8             	mov    %edi,%r8d
  800e93:	48 89 c7             	mov    %rax,%rdi
  800e96:	48 b8 19 07 80 00 00 	movabs $0x800719,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
			break;
  800ea2:	eb 3f                	jmp    800ee3 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eac:	48 89 d6             	mov    %rdx,%rsi
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	ff d0                	callq  *%rax
			break;
  800eb3:	eb 2e                	jmp    800ee3 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebd:	48 89 d6             	mov    %rdx,%rsi
  800ec0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ec5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ecc:	eb 05                	jmp    800ed3 <vprintfmt+0x4f3>
  800ece:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ed3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ed7:	48 83 e8 01          	sub    $0x1,%rax
  800edb:	0f b6 00             	movzbl (%rax),%eax
  800ede:	3c 25                	cmp    $0x25,%al
  800ee0:	75 ec                	jne    800ece <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800ee2:	90                   	nop
		}
	}
  800ee3:	e9 31 fb ff ff       	jmpq   800a19 <vprintfmt+0x39>
	va_end(aq);
}
  800ee8:	48 83 c4 60          	add    $0x60,%rsp
  800eec:	5b                   	pop    %rbx
  800eed:	41 5c                	pop    %r12
  800eef:	5d                   	pop    %rbp
  800ef0:	c3                   	retq   

0000000000800ef1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ef1:	55                   	push   %rbp
  800ef2:	48 89 e5             	mov    %rsp,%rbp
  800ef5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800efc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f03:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f0a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f11:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f18:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f1f:	84 c0                	test   %al,%al
  800f21:	74 20                	je     800f43 <printfmt+0x52>
  800f23:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f27:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f2b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f2f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f33:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f37:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f3b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f3f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f43:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f4a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f51:	00 00 00 
  800f54:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f5b:	00 00 00 
  800f5e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f62:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f69:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f70:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f77:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f7e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f85:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f8c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f93:	48 89 c7             	mov    %rax,%rdi
  800f96:	48 b8 e0 09 80 00 00 	movabs $0x8009e0,%rax
  800f9d:	00 00 00 
  800fa0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fa2:	c9                   	leaveq 
  800fa3:	c3                   	retq   

0000000000800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %rbp
  800fa5:	48 89 e5             	mov    %rsp,%rbp
  800fa8:	48 83 ec 10          	sub    $0x10,%rsp
  800fac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800faf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb7:	8b 40 10             	mov    0x10(%rax),%eax
  800fba:	8d 50 01             	lea    0x1(%rax),%edx
  800fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc8:	48 8b 10             	mov    (%rax),%rdx
  800fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcf:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fd3:	48 39 c2             	cmp    %rax,%rdx
  800fd6:	73 17                	jae    800fef <sprintputch+0x4b>
		*b->buf++ = ch;
  800fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdc:	48 8b 00             	mov    (%rax),%rax
  800fdf:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fe3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fe7:	48 89 0a             	mov    %rcx,(%rdx)
  800fea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fed:	88 10                	mov    %dl,(%rax)
}
  800fef:	c9                   	leaveq 
  800ff0:	c3                   	retq   

0000000000800ff1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ff1:	55                   	push   %rbp
  800ff2:	48 89 e5             	mov    %rsp,%rbp
  800ff5:	48 83 ec 50          	sub    $0x50,%rsp
  800ff9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ffd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801000:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801004:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801008:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80100c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801010:	48 8b 0a             	mov    (%rdx),%rcx
  801013:	48 89 08             	mov    %rcx,(%rax)
  801016:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80101a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801022:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801026:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80102e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801031:	48 98                	cltq   
  801033:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801037:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80103b:	48 01 d0             	add    %rdx,%rax
  80103e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801042:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801049:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80104e:	74 06                	je     801056 <vsnprintf+0x65>
  801050:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801054:	7f 07                	jg     80105d <vsnprintf+0x6c>
		return -E_INVAL;
  801056:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105b:	eb 2f                	jmp    80108c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80105d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801061:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801065:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801069:	48 89 c6             	mov    %rax,%rsi
  80106c:	48 bf a4 0f 80 00 00 	movabs $0x800fa4,%rdi
  801073:	00 00 00 
  801076:	48 b8 e0 09 80 00 00 	movabs $0x8009e0,%rax
  80107d:	00 00 00 
  801080:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801082:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801086:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801089:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80108c:	c9                   	leaveq 
  80108d:	c3                   	retq   

000000000080108e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108e:	55                   	push   %rbp
  80108f:	48 89 e5             	mov    %rsp,%rbp
  801092:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801099:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010a0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010a6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010ad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010bb:	84 c0                	test   %al,%al
  8010bd:	74 20                	je     8010df <snprintf+0x51>
  8010bf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010c3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010c7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010cb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010cf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010d3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010d7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010db:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010df:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010e6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010ed:	00 00 00 
  8010f0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010f7:	00 00 00 
  8010fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801105:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80110c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801113:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80111a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801121:	48 8b 0a             	mov    (%rdx),%rcx
  801124:	48 89 08             	mov    %rcx,(%rax)
  801127:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80112b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80112f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801133:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801137:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80113e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801145:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80114b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801152:	48 89 c7             	mov    %rax,%rdi
  801155:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  80115c:	00 00 00 
  80115f:	ff d0                	callq  *%rax
  801161:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801167:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80116d:	c9                   	leaveq 
  80116e:	c3                   	retq   

000000000080116f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	48 83 ec 18          	sub    $0x18,%rsp
  801177:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801182:	eb 09                	jmp    80118d <strlen+0x1e>
		n++;
  801184:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801188:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	84 c0                	test   %al,%al
  801196:	75 ec                	jne    801184 <strlen+0x15>
	return n;
  801198:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80119b:	c9                   	leaveq 
  80119c:	c3                   	retq   

000000000080119d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80119d:	55                   	push   %rbp
  80119e:	48 89 e5             	mov    %rsp,%rbp
  8011a1:	48 83 ec 20          	sub    $0x20,%rsp
  8011a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b4:	eb 0e                	jmp    8011c4 <strnlen+0x27>
		n++;
  8011b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ba:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011c9:	74 0b                	je     8011d6 <strnlen+0x39>
  8011cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	75 e0                	jne    8011b6 <strnlen+0x19>
	return n;
  8011d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d9:	c9                   	leaveq 
  8011da:	c3                   	retq   

00000000008011db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
  8011df:	48 83 ec 20          	sub    $0x20,%rsp
  8011e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011f3:	90                   	nop
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801200:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801204:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801208:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80120c:	0f b6 12             	movzbl (%rdx),%edx
  80120f:	88 10                	mov    %dl,(%rax)
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	84 c0                	test   %al,%al
  801216:	75 dc                	jne    8011f4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121c:	c9                   	leaveq 
  80121d:	c3                   	retq   

000000000080121e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80121e:	55                   	push   %rbp
  80121f:	48 89 e5             	mov    %rsp,%rbp
  801222:	48 83 ec 20          	sub    $0x20,%rsp
  801226:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80122e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801232:	48 89 c7             	mov    %rax,%rdi
  801235:	48 b8 6f 11 80 00 00 	movabs $0x80116f,%rax
  80123c:	00 00 00 
  80123f:	ff d0                	callq  *%rax
  801241:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801247:	48 63 d0             	movslq %eax,%rdx
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	48 01 c2             	add    %rax,%rdx
  801251:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801255:	48 89 c6             	mov    %rax,%rsi
  801258:	48 89 d7             	mov    %rdx,%rdi
  80125b:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  801262:	00 00 00 
  801265:	ff d0                	callq  *%rax
	return dst;
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80126b:	c9                   	leaveq 
  80126c:	c3                   	retq   

000000000080126d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80126d:	55                   	push   %rbp
  80126e:	48 89 e5             	mov    %rsp,%rbp
  801271:	48 83 ec 28          	sub    $0x28,%rsp
  801275:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801279:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801289:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801290:	00 
  801291:	eb 2a                	jmp    8012bd <strncpy+0x50>
		*dst++ = *src;
  801293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801297:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80129b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a3:	0f b6 12             	movzbl (%rdx),%edx
  8012a6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ac:	0f b6 00             	movzbl (%rax),%eax
  8012af:	84 c0                	test   %al,%al
  8012b1:	74 05                	je     8012b8 <strncpy+0x4b>
			src++;
  8012b3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8012b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012c5:	72 cc                	jb     801293 <strncpy+0x26>
	}
	return ret;
  8012c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012cb:	c9                   	leaveq 
  8012cc:	c3                   	retq   

00000000008012cd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012cd:	55                   	push   %rbp
  8012ce:	48 89 e5             	mov    %rsp,%rbp
  8012d1:	48 83 ec 28          	sub    $0x28,%rsp
  8012d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012ee:	74 3d                	je     80132d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012f0:	eb 1d                	jmp    80130f <strlcpy+0x42>
			*dst++ = *src++;
  8012f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801302:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801306:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80130a:	0f b6 12             	movzbl (%rdx),%edx
  80130d:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80130f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801314:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801319:	74 0b                	je     801326 <strlcpy+0x59>
  80131b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131f:	0f b6 00             	movzbl (%rax),%eax
  801322:	84 c0                	test   %al,%al
  801324:	75 cc                	jne    8012f2 <strlcpy+0x25>
		*dst = '\0';
  801326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80132d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801335:	48 29 c2             	sub    %rax,%rdx
  801338:	48 89 d0             	mov    %rdx,%rax
}
  80133b:	c9                   	leaveq 
  80133c:	c3                   	retq   

000000000080133d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 10          	sub    $0x10,%rsp
  801345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801349:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80134d:	eb 0a                	jmp    801359 <strcmp+0x1c>
		p++, q++;
  80134f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801354:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135d:	0f b6 00             	movzbl (%rax),%eax
  801360:	84 c0                	test   %al,%al
  801362:	74 12                	je     801376 <strcmp+0x39>
  801364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801368:	0f b6 10             	movzbl (%rax),%edx
  80136b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	38 c2                	cmp    %al,%dl
  801374:	74 d9                	je     80134f <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	0f b6 d0             	movzbl %al,%edx
  801380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	0f b6 c0             	movzbl %al,%eax
  80138a:	29 c2                	sub    %eax,%edx
  80138c:	89 d0                	mov    %edx,%eax
}
  80138e:	c9                   	leaveq 
  80138f:	c3                   	retq   

0000000000801390 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801390:	55                   	push   %rbp
  801391:	48 89 e5             	mov    %rsp,%rbp
  801394:	48 83 ec 18          	sub    $0x18,%rsp
  801398:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013a4:	eb 0f                	jmp    8013b5 <strncmp+0x25>
		n--, p++, q++;
  8013a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8013b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ba:	74 1d                	je     8013d9 <strncmp+0x49>
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c0:	0f b6 00             	movzbl (%rax),%eax
  8013c3:	84 c0                	test   %al,%al
  8013c5:	74 12                	je     8013d9 <strncmp+0x49>
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cb:	0f b6 10             	movzbl (%rax),%edx
  8013ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d2:	0f b6 00             	movzbl (%rax),%eax
  8013d5:	38 c2                	cmp    %al,%dl
  8013d7:	74 cd                	je     8013a6 <strncmp+0x16>
	if (n == 0)
  8013d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013de:	75 07                	jne    8013e7 <strncmp+0x57>
		return 0;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	eb 18                	jmp    8013ff <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	0f b6 d0             	movzbl %al,%edx
  8013f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	0f b6 c0             	movzbl %al,%eax
  8013fb:	29 c2                	sub    %eax,%edx
  8013fd:	89 d0                	mov    %edx,%eax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 10          	sub    $0x10,%rsp
  801409:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80140d:	89 f0                	mov    %esi,%eax
  80140f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801412:	eb 17                	jmp    80142b <strchr+0x2a>
		if (*s == c)
  801414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80141e:	75 06                	jne    801426 <strchr+0x25>
			return (char *) s;
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801424:	eb 15                	jmp    80143b <strchr+0x3a>
	for (; *s; s++)
  801426:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80142b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142f:	0f b6 00             	movzbl (%rax),%eax
  801432:	84 c0                	test   %al,%al
  801434:	75 de                	jne    801414 <strchr+0x13>
	return 0;
  801436:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143b:	c9                   	leaveq 
  80143c:	c3                   	retq   

000000000080143d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80143d:	55                   	push   %rbp
  80143e:	48 89 e5             	mov    %rsp,%rbp
  801441:	48 83 ec 10          	sub    $0x10,%rsp
  801445:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801449:	89 f0                	mov    %esi,%eax
  80144b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144e:	eb 13                	jmp    801463 <strfind+0x26>
		if (*s == c)
  801450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801454:	0f b6 00             	movzbl (%rax),%eax
  801457:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80145a:	75 02                	jne    80145e <strfind+0x21>
			break;
  80145c:	eb 10                	jmp    80146e <strfind+0x31>
	for (; *s; s++)
  80145e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	84 c0                	test   %al,%al
  80146c:	75 e2                	jne    801450 <strfind+0x13>
	return (char *) s;
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801472:	c9                   	leaveq 
  801473:	c3                   	retq   

0000000000801474 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801474:	55                   	push   %rbp
  801475:	48 89 e5             	mov    %rsp,%rbp
  801478:	48 83 ec 18          	sub    $0x18,%rsp
  80147c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801480:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801483:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801487:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80148c:	75 06                	jne    801494 <memset+0x20>
		return v;
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	eb 69                	jmp    8014fd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801498:	83 e0 03             	and    $0x3,%eax
  80149b:	48 85 c0             	test   %rax,%rax
  80149e:	75 48                	jne    8014e8 <memset+0x74>
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a4:	83 e0 03             	and    $0x3,%eax
  8014a7:	48 85 c0             	test   %rax,%rax
  8014aa:	75 3c                	jne    8014e8 <memset+0x74>
		c &= 0xFF;
  8014ac:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b6:	c1 e0 18             	shl    $0x18,%eax
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014be:	c1 e0 10             	shl    $0x10,%eax
  8014c1:	09 c2                	or     %eax,%edx
  8014c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c6:	c1 e0 08             	shl    $0x8,%eax
  8014c9:	09 d0                	or     %edx,%eax
  8014cb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d2:	48 c1 e8 02          	shr    $0x2,%rax
  8014d6:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8014d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e0:	48 89 d7             	mov    %rdx,%rdi
  8014e3:	fc                   	cld    
  8014e4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014e6:	eb 11                	jmp    8014f9 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014f3:	48 89 d7             	mov    %rdx,%rdi
  8014f6:	fc                   	cld    
  8014f7:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014fd:	c9                   	leaveq 
  8014fe:	c3                   	retq   

00000000008014ff <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014ff:	55                   	push   %rbp
  801500:	48 89 e5             	mov    %rsp,%rbp
  801503:	48 83 ec 28          	sub    $0x28,%rsp
  801507:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80150f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801513:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801517:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801527:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80152b:	0f 83 88 00 00 00    	jae    8015b9 <memmove+0xba>
  801531:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801539:	48 01 d0             	add    %rdx,%rax
  80153c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801540:	76 77                	jbe    8015b9 <memmove+0xba>
		s += n;
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80154a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	83 e0 03             	and    $0x3,%eax
  801559:	48 85 c0             	test   %rax,%rax
  80155c:	75 3b                	jne    801599 <memmove+0x9a>
  80155e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801562:	83 e0 03             	and    $0x3,%eax
  801565:	48 85 c0             	test   %rax,%rax
  801568:	75 2f                	jne    801599 <memmove+0x9a>
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	83 e0 03             	and    $0x3,%eax
  801571:	48 85 c0             	test   %rax,%rax
  801574:	75 23                	jne    801599 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157a:	48 83 e8 04          	sub    $0x4,%rax
  80157e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801582:	48 83 ea 04          	sub    $0x4,%rdx
  801586:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80158a:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80158e:	48 89 c7             	mov    %rax,%rdi
  801591:	48 89 d6             	mov    %rdx,%rsi
  801594:	fd                   	std    
  801595:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801597:	eb 1d                	jmp    8015b6 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8015a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ad:	48 89 d7             	mov    %rdx,%rdi
  8015b0:	48 89 c1             	mov    %rax,%rcx
  8015b3:	fd                   	std    
  8015b4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015b6:	fc                   	cld    
  8015b7:	eb 57                	jmp    801610 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bd:	83 e0 03             	and    $0x3,%eax
  8015c0:	48 85 c0             	test   %rax,%rax
  8015c3:	75 36                	jne    8015fb <memmove+0xfc>
  8015c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c9:	83 e0 03             	and    $0x3,%eax
  8015cc:	48 85 c0             	test   %rax,%rax
  8015cf:	75 2a                	jne    8015fb <memmove+0xfc>
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	83 e0 03             	and    $0x3,%eax
  8015d8:	48 85 c0             	test   %rax,%rax
  8015db:	75 1e                	jne    8015fb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	48 c1 e8 02          	shr    $0x2,%rax
  8015e5:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8015e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f0:	48 89 c7             	mov    %rax,%rdi
  8015f3:	48 89 d6             	mov    %rdx,%rsi
  8015f6:	fc                   	cld    
  8015f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015f9:	eb 15                	jmp    801610 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8015fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801603:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801607:	48 89 c7             	mov    %rax,%rdi
  80160a:	48 89 d6             	mov    %rdx,%rsi
  80160d:	fc                   	cld    
  80160e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 18          	sub    $0x18,%rsp
  80161e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801622:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801626:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80162a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80162e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801636:	48 89 ce             	mov    %rcx,%rsi
  801639:	48 89 c7             	mov    %rax,%rdi
  80163c:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  801643:	00 00 00 
  801646:	ff d0                	callq  *%rax
}
  801648:	c9                   	leaveq 
  801649:	c3                   	retq   

000000000080164a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	48 83 ec 28          	sub    $0x28,%rsp
  801652:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801656:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80165a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80165e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801662:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801666:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80166a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80166e:	eb 36                	jmp    8016a6 <memcmp+0x5c>
		if (*s1 != *s2)
  801670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801674:	0f b6 10             	movzbl (%rax),%edx
  801677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	38 c2                	cmp    %al,%dl
  801680:	74 1a                	je     80169c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801686:	0f b6 00             	movzbl (%rax),%eax
  801689:	0f b6 d0             	movzbl %al,%edx
  80168c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	0f b6 c0             	movzbl %al,%eax
  801696:	29 c2                	sub    %eax,%edx
  801698:	89 d0                	mov    %edx,%eax
  80169a:	eb 20                	jmp    8016bc <memcmp+0x72>
		s1++, s2++;
  80169c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016b2:	48 85 c0             	test   %rax,%rax
  8016b5:	75 b9                	jne    801670 <memcmp+0x26>
	}

	return 0;
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bc:	c9                   	leaveq 
  8016bd:	c3                   	retq   

00000000008016be <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016be:	55                   	push   %rbp
  8016bf:	48 89 e5             	mov    %rsp,%rbp
  8016c2:	48 83 ec 28          	sub    $0x28,%rsp
  8016c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d9:	48 01 d0             	add    %rdx,%rax
  8016dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016e0:	eb 15                	jmp    8016f7 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8016ec:	38 d0                	cmp    %dl,%al
  8016ee:	75 02                	jne    8016f2 <memfind+0x34>
			break;
  8016f0:	eb 0f                	jmp    801701 <memfind+0x43>
	for (; s < ends; s++)
  8016f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016ff:	72 e1                	jb     8016e2 <memfind+0x24>
	return (void *) s;
  801701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801705:	c9                   	leaveq 
  801706:	c3                   	retq   

0000000000801707 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801707:	55                   	push   %rbp
  801708:	48 89 e5             	mov    %rsp,%rbp
  80170b:	48 83 ec 38          	sub    $0x38,%rsp
  80170f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801713:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801717:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80171a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801721:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801728:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801729:	eb 05                	jmp    801730 <strtol+0x29>
		s++;
  80172b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	3c 20                	cmp    $0x20,%al
  801739:	74 f0                	je     80172b <strtol+0x24>
  80173b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	3c 09                	cmp    $0x9,%al
  801744:	74 e5                	je     80172b <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	0f b6 00             	movzbl (%rax),%eax
  80174d:	3c 2b                	cmp    $0x2b,%al
  80174f:	75 07                	jne    801758 <strtol+0x51>
		s++;
  801751:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801756:	eb 17                	jmp    80176f <strtol+0x68>
	else if (*s == '-')
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	3c 2d                	cmp    $0x2d,%al
  801761:	75 0c                	jne    80176f <strtol+0x68>
		s++, neg = 1;
  801763:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801768:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80176f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801773:	74 06                	je     80177b <strtol+0x74>
  801775:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801779:	75 28                	jne    8017a3 <strtol+0x9c>
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	3c 30                	cmp    $0x30,%al
  801784:	75 1d                	jne    8017a3 <strtol+0x9c>
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	48 83 c0 01          	add    $0x1,%rax
  80178e:	0f b6 00             	movzbl (%rax),%eax
  801791:	3c 78                	cmp    $0x78,%al
  801793:	75 0e                	jne    8017a3 <strtol+0x9c>
		s += 2, base = 16;
  801795:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80179a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017a1:	eb 2c                	jmp    8017cf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a7:	75 19                	jne    8017c2 <strtol+0xbb>
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	3c 30                	cmp    $0x30,%al
  8017b2:	75 0e                	jne    8017c2 <strtol+0xbb>
		s++, base = 8;
  8017b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017c0:	eb 0d                	jmp    8017cf <strtol+0xc8>
	else if (base == 0)
  8017c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c6:	75 07                	jne    8017cf <strtol+0xc8>
		base = 10;
  8017c8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d3:	0f b6 00             	movzbl (%rax),%eax
  8017d6:	3c 2f                	cmp    $0x2f,%al
  8017d8:	7e 1d                	jle    8017f7 <strtol+0xf0>
  8017da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017de:	0f b6 00             	movzbl (%rax),%eax
  8017e1:	3c 39                	cmp    $0x39,%al
  8017e3:	7f 12                	jg     8017f7 <strtol+0xf0>
			dig = *s - '0';
  8017e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e9:	0f b6 00             	movzbl (%rax),%eax
  8017ec:	0f be c0             	movsbl %al,%eax
  8017ef:	83 e8 30             	sub    $0x30,%eax
  8017f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017f5:	eb 4e                	jmp    801845 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	3c 60                	cmp    $0x60,%al
  801800:	7e 1d                	jle    80181f <strtol+0x118>
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 12                	jg     80181f <strtol+0x118>
			dig = *s - 'a' + 10;
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	0f b6 00             	movzbl (%rax),%eax
  801814:	0f be c0             	movsbl %al,%eax
  801817:	83 e8 57             	sub    $0x57,%eax
  80181a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80181d:	eb 26                	jmp    801845 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80181f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801823:	0f b6 00             	movzbl (%rax),%eax
  801826:	3c 40                	cmp    $0x40,%al
  801828:	7e 48                	jle    801872 <strtol+0x16b>
  80182a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182e:	0f b6 00             	movzbl (%rax),%eax
  801831:	3c 5a                	cmp    $0x5a,%al
  801833:	7f 3d                	jg     801872 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	0f be c0             	movsbl %al,%eax
  80183f:	83 e8 37             	sub    $0x37,%eax
  801842:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801845:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801848:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80184b:	7c 02                	jl     80184f <strtol+0x148>
			break;
  80184d:	eb 23                	jmp    801872 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80184f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801854:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801857:	48 98                	cltq   
  801859:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80185e:	48 89 c2             	mov    %rax,%rdx
  801861:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801864:	48 98                	cltq   
  801866:	48 01 d0             	add    %rdx,%rax
  801869:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80186d:	e9 5d ff ff ff       	jmpq   8017cf <strtol+0xc8>

	if (endptr)
  801872:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801877:	74 0b                	je     801884 <strtol+0x17d>
		*endptr = (char *) s;
  801879:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801881:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801888:	74 09                	je     801893 <strtol+0x18c>
  80188a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188e:	48 f7 d8             	neg    %rax
  801891:	eb 04                	jmp    801897 <strtol+0x190>
  801893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801897:	c9                   	leaveq 
  801898:	c3                   	retq   

0000000000801899 <strstr>:

char * strstr(const char *in, const char *str)
{
  801899:	55                   	push   %rbp
  80189a:	48 89 e5             	mov    %rsp,%rbp
  80189d:	48 83 ec 30          	sub    $0x30,%rsp
  8018a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b5:	0f b6 00             	movzbl (%rax),%eax
  8018b8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018bb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018bf:	75 06                	jne    8018c7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c5:	eb 6b                	jmp    801932 <strstr+0x99>

	len = strlen(str);
  8018c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018cb:	48 89 c7             	mov    %rax,%rdi
  8018ce:	48 b8 6f 11 80 00 00 	movabs $0x80116f,%rax
  8018d5:	00 00 00 
  8018d8:	ff d0                	callq  *%rax
  8018da:	48 98                	cltq   
  8018dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018f2:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018f6:	75 07                	jne    8018ff <strstr+0x66>
				return (char *) 0;
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fd:	eb 33                	jmp    801932 <strstr+0x99>
		} while (sc != c);
  8018ff:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801903:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801906:	75 d8                	jne    8018e0 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801908:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	48 89 ce             	mov    %rcx,%rsi
  801917:	48 89 c7             	mov    %rax,%rdi
  80191a:	48 b8 90 13 80 00 00 	movabs $0x801390,%rax
  801921:	00 00 00 
  801924:	ff d0                	callq  *%rax
  801926:	85 c0                	test   %eax,%eax
  801928:	75 b6                	jne    8018e0 <strstr+0x47>

	return (char *) (in - 1);
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	48 83 e8 01          	sub    $0x1,%rax
}
  801932:	c9                   	leaveq 
  801933:	c3                   	retq   

0000000000801934 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	53                   	push   %rbx
  801939:	48 83 ec 48          	sub    $0x48,%rsp
  80193d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801940:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801943:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801947:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80194b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80194f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801953:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801956:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80195a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80195e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801962:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801966:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80196a:	4c 89 c3             	mov    %r8,%rbx
  80196d:	cd 30                	int    $0x30
  80196f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801973:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801977:	74 3e                	je     8019b7 <syscall+0x83>
  801979:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80197e:	7e 37                	jle    8019b7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801984:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801987:	49 89 d0             	mov    %rdx,%r8
  80198a:	89 c1                	mov    %eax,%ecx
  80198c:	48 ba c8 46 80 00 00 	movabs $0x8046c8,%rdx
  801993:	00 00 00 
  801996:	be 23 00 00 00       	mov    $0x23,%esi
  80199b:	48 bf e5 46 80 00 00 	movabs $0x8046e5,%rdi
  8019a2:	00 00 00 
  8019a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019aa:	49 b9 08 04 80 00 00 	movabs $0x800408,%r9
  8019b1:	00 00 00 
  8019b4:	41 ff d1             	callq  *%r9

	return ret;
  8019b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019bb:	48 83 c4 48          	add    $0x48,%rsp
  8019bf:	5b                   	pop    %rbx
  8019c0:	5d                   	pop    %rbp
  8019c1:	c3                   	retq   

00000000008019c2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	48 83 ec 10          	sub    $0x10,%rsp
  8019ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019da:	48 83 ec 08          	sub    $0x8,%rsp
  8019de:	6a 00                	pushq  $0x0
  8019e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ec:	48 89 d1             	mov    %rdx,%rcx
  8019ef:	48 89 c2             	mov    %rax,%rdx
  8019f2:	be 00 00 00 00       	mov    $0x0,%esi
  8019f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8019fc:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801a03:	00 00 00 
  801a06:	ff d0                	callq  *%rax
  801a08:	48 83 c4 10          	add    $0x10,%rsp
}
  801a0c:	c9                   	leaveq 
  801a0d:	c3                   	retq   

0000000000801a0e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a0e:	55                   	push   %rbp
  801a0f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a12:	48 83 ec 08          	sub    $0x8,%rsp
  801a16:	6a 00                	pushq  $0x0
  801a18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a29:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2e:	be 00 00 00 00       	mov    $0x0,%esi
  801a33:	bf 01 00 00 00       	mov    $0x1,%edi
  801a38:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	callq  *%rax
  801a44:	48 83 c4 10          	add    $0x10,%rsp
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 10          	sub    $0x10,%rsp
  801a52:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a58:	48 98                	cltq   
  801a5a:	48 83 ec 08          	sub    $0x8,%rsp
  801a5e:	6a 00                	pushq  $0x0
  801a60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a71:	48 89 c2             	mov    %rax,%rdx
  801a74:	be 01 00 00 00       	mov    $0x1,%esi
  801a79:	bf 03 00 00 00       	mov    $0x3,%edi
  801a7e:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	callq  *%rax
  801a8a:	48 83 c4 10          	add    $0x10,%rsp
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a94:	48 83 ec 08          	sub    $0x8,%rsp
  801a98:	6a 00                	pushq  $0x0
  801a9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	be 00 00 00 00       	mov    $0x0,%esi
  801ab5:	bf 02 00 00 00       	mov    $0x2,%edi
  801aba:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801ac1:	00 00 00 
  801ac4:	ff d0                	callq  *%rax
  801ac6:	48 83 c4 10          	add    $0x10,%rsp
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_yield>:

void
sys_yield(void)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ad0:	48 83 ec 08          	sub    $0x8,%rsp
  801ad4:	6a 00                	pushq  $0x0
  801ad6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	be 00 00 00 00       	mov    $0x0,%esi
  801af1:	bf 0b 00 00 00       	mov    $0xb,%edi
  801af6:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
  801b02:	48 83 c4 10          	add    $0x10,%rsp
}
  801b06:	c9                   	leaveq 
  801b07:	c3                   	retq   

0000000000801b08 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b08:	55                   	push   %rbp
  801b09:	48 89 e5             	mov    %rsp,%rbp
  801b0c:	48 83 ec 10          	sub    $0x10,%rsp
  801b10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b17:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1d:	48 63 c8             	movslq %eax,%rcx
  801b20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 83 ec 08          	sub    $0x8,%rsp
  801b2d:	6a 00                	pushq  $0x0
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	49 89 c8             	mov    %rcx,%r8
  801b38:	48 89 d1             	mov    %rdx,%rcx
  801b3b:	48 89 c2             	mov    %rax,%rdx
  801b3e:	be 01 00 00 00       	mov    $0x1,%esi
  801b43:	bf 04 00 00 00       	mov    $0x4,%edi
  801b48:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
  801b54:	48 83 c4 10          	add    $0x10,%rsp
}
  801b58:	c9                   	leaveq 
  801b59:	c3                   	retq   

0000000000801b5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b5a:	55                   	push   %rbp
  801b5b:	48 89 e5             	mov    %rsp,%rbp
  801b5e:	48 83 ec 20          	sub    $0x20,%rsp
  801b62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b69:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b6c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b70:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b77:	48 63 c8             	movslq %eax,%rcx
  801b7a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b81:	48 63 f0             	movslq %eax,%rsi
  801b84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8b:	48 98                	cltq   
  801b8d:	48 83 ec 08          	sub    $0x8,%rsp
  801b91:	51                   	push   %rcx
  801b92:	49 89 f9             	mov    %rdi,%r9
  801b95:	49 89 f0             	mov    %rsi,%r8
  801b98:	48 89 d1             	mov    %rdx,%rcx
  801b9b:	48 89 c2             	mov    %rax,%rdx
  801b9e:	be 01 00 00 00       	mov    $0x1,%esi
  801ba3:	bf 05 00 00 00       	mov    $0x5,%edi
  801ba8:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
  801bb4:	48 83 c4 10          	add    $0x10,%rsp
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 10          	sub    $0x10,%rsp
  801bc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd0:	48 98                	cltq   
  801bd2:	48 83 ec 08          	sub    $0x8,%rsp
  801bd6:	6a 00                	pushq  $0x0
  801bd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be4:	48 89 d1             	mov    %rdx,%rcx
  801be7:	48 89 c2             	mov    %rax,%rdx
  801bea:	be 01 00 00 00       	mov    $0x1,%esi
  801bef:	bf 06 00 00 00       	mov    $0x6,%edi
  801bf4:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
  801c00:	48 83 c4 10          	add    $0x10,%rsp
}
  801c04:	c9                   	leaveq 
  801c05:	c3                   	retq   

0000000000801c06 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	48 83 ec 10          	sub    $0x10,%rsp
  801c0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c11:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c17:	48 63 d0             	movslq %eax,%rdx
  801c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1d:	48 98                	cltq   
  801c1f:	48 83 ec 08          	sub    $0x8,%rsp
  801c23:	6a 00                	pushq  $0x0
  801c25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c31:	48 89 d1             	mov    %rdx,%rcx
  801c34:	48 89 c2             	mov    %rax,%rdx
  801c37:	be 01 00 00 00       	mov    $0x1,%esi
  801c3c:	bf 08 00 00 00       	mov    $0x8,%edi
  801c41:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
  801c4d:	48 83 c4 10          	add    $0x10,%rsp
}
  801c51:	c9                   	leaveq 
  801c52:	c3                   	retq   

0000000000801c53 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c53:	55                   	push   %rbp
  801c54:	48 89 e5             	mov    %rsp,%rbp
  801c57:	48 83 ec 10          	sub    $0x10,%rsp
  801c5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c69:	48 98                	cltq   
  801c6b:	48 83 ec 08          	sub    $0x8,%rsp
  801c6f:	6a 00                	pushq  $0x0
  801c71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7d:	48 89 d1             	mov    %rdx,%rcx
  801c80:	48 89 c2             	mov    %rax,%rdx
  801c83:	be 01 00 00 00       	mov    $0x1,%esi
  801c88:	bf 09 00 00 00       	mov    $0x9,%edi
  801c8d:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	callq  *%rax
  801c99:	48 83 c4 10          	add    $0x10,%rsp
}
  801c9d:	c9                   	leaveq 
  801c9e:	c3                   	retq   

0000000000801c9f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c9f:	55                   	push   %rbp
  801ca0:	48 89 e5             	mov    %rsp,%rbp
  801ca3:	48 83 ec 10          	sub    $0x10,%rsp
  801ca7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801caa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb5:	48 98                	cltq   
  801cb7:	48 83 ec 08          	sub    $0x8,%rsp
  801cbb:	6a 00                	pushq  $0x0
  801cbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc9:	48 89 d1             	mov    %rdx,%rcx
  801ccc:	48 89 c2             	mov    %rax,%rdx
  801ccf:	be 01 00 00 00       	mov    $0x1,%esi
  801cd4:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cd9:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	callq  *%rax
  801ce5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ce9:	c9                   	leaveq 
  801cea:	c3                   	retq   

0000000000801ceb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ceb:	55                   	push   %rbp
  801cec:	48 89 e5             	mov    %rsp,%rbp
  801cef:	48 83 ec 20          	sub    $0x20,%rsp
  801cf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cfe:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d04:	48 63 f0             	movslq %eax,%rsi
  801d07:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0e:	48 98                	cltq   
  801d10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d14:	48 83 ec 08          	sub    $0x8,%rsp
  801d18:	6a 00                	pushq  $0x0
  801d1a:	49 89 f1             	mov    %rsi,%r9
  801d1d:	49 89 c8             	mov    %rcx,%r8
  801d20:	48 89 d1             	mov    %rdx,%rcx
  801d23:	48 89 c2             	mov    %rax,%rdx
  801d26:	be 00 00 00 00       	mov    $0x0,%esi
  801d2b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d30:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	callq  *%rax
  801d3c:	48 83 c4 10          	add    $0x10,%rsp
}
  801d40:	c9                   	leaveq 
  801d41:	c3                   	retq   

0000000000801d42 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d42:	55                   	push   %rbp
  801d43:	48 89 e5             	mov    %rsp,%rbp
  801d46:	48 83 ec 10          	sub    $0x10,%rsp
  801d4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d52:	48 83 ec 08          	sub    $0x8,%rsp
  801d56:	6a 00                	pushq  $0x0
  801d58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d64:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d69:	48 89 c2             	mov    %rax,%rdx
  801d6c:	be 01 00 00 00       	mov    $0x1,%esi
  801d71:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d76:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
  801d82:	48 83 c4 10          	add    $0x10,%rsp
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d8c:	48 83 ec 08          	sub    $0x8,%rsp
  801d90:	6a 00                	pushq  $0x0
  801d92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	be 00 00 00 00       	mov    $0x0,%esi
  801dad:	bf 0e 00 00 00       	mov    $0xe,%edi
  801db2:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
  801dbe:	48 83 c4 10          	add    $0x10,%rsp
}
  801dc2:	c9                   	leaveq 
  801dc3:	c3                   	retq   

0000000000801dc4 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801dc4:	55                   	push   %rbp
  801dc5:	48 89 e5             	mov    %rsp,%rbp
  801dc8:	48 83 ec 20          	sub    $0x20,%rsp
  801dcc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dd3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dd6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dda:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dde:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de1:	48 63 c8             	movslq %eax,%rcx
  801de4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801de8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801deb:	48 63 f0             	movslq %eax,%rsi
  801dee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df5:	48 98                	cltq   
  801df7:	48 83 ec 08          	sub    $0x8,%rsp
  801dfb:	51                   	push   %rcx
  801dfc:	49 89 f9             	mov    %rdi,%r9
  801dff:	49 89 f0             	mov    %rsi,%r8
  801e02:	48 89 d1             	mov    %rdx,%rcx
  801e05:	48 89 c2             	mov    %rax,%rdx
  801e08:	be 00 00 00 00       	mov    $0x0,%esi
  801e0d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e12:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e22:	c9                   	leaveq 
  801e23:	c3                   	retq   

0000000000801e24 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
  801e28:	48 83 ec 10          	sub    $0x10,%rsp
  801e2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e3c:	48 83 ec 08          	sub    $0x8,%rsp
  801e40:	6a 00                	pushq  $0x0
  801e42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4e:	48 89 d1             	mov    %rdx,%rcx
  801e51:	48 89 c2             	mov    %rax,%rdx
  801e54:	be 00 00 00 00       	mov    $0x0,%esi
  801e59:	bf 10 00 00 00       	mov    $0x10,%edi
  801e5e:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	callq  *%rax
  801e6a:	48 83 c4 10          	add    $0x10,%rsp
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 20          	sub    $0x20,%rsp
  801e78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e80:	48 8b 00             	mov    (%rax),%rax
  801e83:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e8f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801e92:	48 ba f3 46 80 00 00 	movabs $0x8046f3,%rdx
  801e99:	00 00 00 
  801e9c:	be 26 00 00 00       	mov    $0x26,%esi
  801ea1:	48 bf 0b 47 80 00 00 	movabs $0x80470b,%rdi
  801ea8:	00 00 00 
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801eb7:	00 00 00 
  801eba:	ff d1                	callq  *%rcx

0000000000801ebc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ebc:	55                   	push   %rbp
  801ebd:	48 89 e5             	mov    %rsp,%rbp
  801ec0:	48 83 ec 10          	sub    $0x10,%rsp
  801ec4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801eca:	48 ba 16 47 80 00 00 	movabs $0x804716,%rdx
  801ed1:	00 00 00 
  801ed4:	be 3a 00 00 00       	mov    $0x3a,%esi
  801ed9:	48 bf 0b 47 80 00 00 	movabs $0x80470b,%rdi
  801ee0:	00 00 00 
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee8:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801eef:	00 00 00 
  801ef2:	ff d1                	callq  *%rcx

0000000000801ef4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ef4:	55                   	push   %rbp
  801ef5:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801ef8:	48 ba 2e 47 80 00 00 	movabs $0x80472e,%rdx
  801eff:	00 00 00 
  801f02:	be 52 00 00 00       	mov    $0x52,%esi
  801f07:	48 bf 0b 47 80 00 00 	movabs $0x80470b,%rdi
  801f0e:	00 00 00 
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801f1d:	00 00 00 
  801f20:	ff d1                	callq  *%rcx

0000000000801f22 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801f22:	55                   	push   %rbp
  801f23:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801f26:	48 ba 43 47 80 00 00 	movabs $0x804743,%rdx
  801f2d:	00 00 00 
  801f30:	be 59 00 00 00       	mov    $0x59,%esi
  801f35:	48 bf 0b 47 80 00 00 	movabs $0x80470b,%rdi
  801f3c:	00 00 00 
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f44:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801f4b:	00 00 00 
  801f4e:	ff d1                	callq  *%rcx

0000000000801f50 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f50:	55                   	push   %rbp
  801f51:	48 89 e5             	mov    %rsp,%rbp
  801f54:	48 83 ec 20          	sub    $0x20,%rsp
  801f58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f60:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801f64:	48 ba 60 47 80 00 00 	movabs $0x804760,%rdx
  801f6b:	00 00 00 
  801f6e:	be 1d 00 00 00       	mov    $0x1d,%esi
  801f73:	48 bf 79 47 80 00 00 	movabs $0x804779,%rdi
  801f7a:	00 00 00 
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f82:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801f89:	00 00 00 
  801f8c:	ff d1                	callq  *%rcx

0000000000801f8e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f8e:	55                   	push   %rbp
  801f8f:	48 89 e5             	mov    %rsp,%rbp
  801f92:	48 83 ec 20          	sub    $0x20,%rsp
  801f96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f99:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801f9c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  801fa0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801fa3:	48 ba 83 47 80 00 00 	movabs $0x804783,%rdx
  801faa:	00 00 00 
  801fad:	be 2d 00 00 00       	mov    $0x2d,%esi
  801fb2:	48 bf 79 47 80 00 00 	movabs $0x804779,%rdi
  801fb9:	00 00 00 
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801fc8:	00 00 00 
  801fcb:	ff d1                	callq  *%rcx

0000000000801fcd <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  801fcd:	55                   	push   %rbp
  801fce:	48 89 e5             	mov    %rsp,%rbp
  801fd1:	53                   	push   %rbx
  801fd2:	48 83 ec 48          	sub    $0x48,%rsp
  801fd6:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  801fda:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  801fe1:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  801fe8:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  801fed:	75 0e                	jne    801ffd <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  801fef:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  801ff6:	00 00 00 
  801ff9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  801ffd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802001:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  802005:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80200c:	00 
	a3 = (uint64_t) 0;
  80200d:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802014:	00 
	a4 = (uint64_t) 0;
  802015:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80201c:	00 
	a5 = 0;
  80201d:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  802024:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  802025:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802028:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80202c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802030:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  802034:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802038:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80203c:	4c 89 c3             	mov    %r8,%rbx
  80203f:	0f 01 c1             	vmcall 
  802042:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  802045:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802049:	7e 36                	jle    802081 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  80204b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80204e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802051:	41 89 d0             	mov    %edx,%r8d
  802054:	89 c1                	mov    %eax,%ecx
  802056:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  80205d:	00 00 00 
  802060:	be 54 00 00 00       	mov    $0x54,%esi
  802065:	48 bf 79 47 80 00 00 	movabs $0x804779,%rdi
  80206c:	00 00 00 
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	49 b9 08 04 80 00 00 	movabs $0x800408,%r9
  80207b:	00 00 00 
  80207e:	41 ff d1             	callq  *%r9
	return ret;
  802081:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802084:	48 83 c4 48          	add    $0x48,%rsp
  802088:	5b                   	pop    %rbx
  802089:	5d                   	pop    %rbp
  80208a:	c3                   	retq   

000000000080208b <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	53                   	push   %rbx
  802090:	48 83 ec 58          	sub    $0x58,%rsp
  802094:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  802097:	89 75 b0             	mov    %esi,-0x50(%rbp)
  80209a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80209e:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8020a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8020a8:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8020af:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8020b4:	75 0e                	jne    8020c4 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8020b6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8020bd:	00 00 00 
  8020c0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8020c4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8020c7:	48 98                	cltq   
  8020c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8020cd:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8020d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8020d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8020d8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8020dc:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8020df:	48 98                	cltq   
  8020e1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8020e5:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8020ec:	00 

	int r = -E_IPC_NOT_RECV;
  8020ed:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8020f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8020f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020fb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8020ff:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  802103:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802107:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80210b:	4c 89 c3             	mov    %r8,%rbx
  80210e:	0f 01 c1             	vmcall 
  802111:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  802114:	48 83 c4 58          	add    $0x58,%rsp
  802118:	5b                   	pop    %rbx
  802119:	5d                   	pop    %rbp
  80211a:	c3                   	retq   

000000000080211b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80211b:	55                   	push   %rbp
  80211c:	48 89 e5             	mov    %rsp,%rbp
  80211f:	48 83 ec 18          	sub    $0x18,%rsp
  802123:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802126:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212d:	eb 4e                	jmp    80217d <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80212f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802136:	00 00 00 
  802139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213c:	48 98                	cltq   
  80213e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802145:	48 01 d0             	add    %rdx,%rax
  802148:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80214e:	8b 00                	mov    (%rax),%eax
  802150:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802153:	75 24                	jne    802179 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802155:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80215c:	00 00 00 
  80215f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802162:	48 98                	cltq   
  802164:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80216b:	48 01 d0             	add    %rdx,%rax
  80216e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802174:	8b 40 08             	mov    0x8(%rax),%eax
  802177:	eb 12                	jmp    80218b <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  802179:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80217d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802184:	7e a9                	jle    80212f <ipc_find_env+0x14>
	}
	return 0;
  802186:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218b:	c9                   	leaveq 
  80218c:	c3                   	retq   

000000000080218d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80218d:	55                   	push   %rbp
  80218e:	48 89 e5             	mov    %rsp,%rbp
  802191:	48 83 ec 08          	sub    $0x8,%rsp
  802195:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802199:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80219d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021a4:	ff ff ff 
  8021a7:	48 01 d0             	add    %rdx,%rax
  8021aa:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021ae:	c9                   	leaveq 
  8021af:	c3                   	retq   

00000000008021b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021b0:	55                   	push   %rbp
  8021b1:	48 89 e5             	mov    %rsp,%rbp
  8021b4:	48 83 ec 08          	sub    $0x8,%rsp
  8021b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c0:	48 89 c7             	mov    %rax,%rdi
  8021c3:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  8021ca:	00 00 00 
  8021cd:	ff d0                	callq  *%rax
  8021cf:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021d5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021d9:	c9                   	leaveq 
  8021da:	c3                   	retq   

00000000008021db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021db:	55                   	push   %rbp
  8021dc:	48 89 e5             	mov    %rsp,%rbp
  8021df:	48 83 ec 18          	sub    $0x18,%rsp
  8021e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021ee:	eb 6b                	jmp    80225b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f3:	48 98                	cltq   
  8021f5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021fb:	48 c1 e0 0c          	shl    $0xc,%rax
  8021ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802207:	48 c1 e8 15          	shr    $0x15,%rax
  80220b:	48 89 c2             	mov    %rax,%rdx
  80220e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802215:	01 00 00 
  802218:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221c:	83 e0 01             	and    $0x1,%eax
  80221f:	48 85 c0             	test   %rax,%rax
  802222:	74 21                	je     802245 <fd_alloc+0x6a>
  802224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802228:	48 c1 e8 0c          	shr    $0xc,%rax
  80222c:	48 89 c2             	mov    %rax,%rdx
  80222f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802236:	01 00 00 
  802239:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223d:	83 e0 01             	and    $0x1,%eax
  802240:	48 85 c0             	test   %rax,%rax
  802243:	75 12                	jne    802257 <fd_alloc+0x7c>
			*fd_store = fd;
  802245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802249:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
  802255:	eb 1a                	jmp    802271 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  802257:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80225b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80225f:	7e 8f                	jle    8021f0 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802265:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80226c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802271:	c9                   	leaveq 
  802272:	c3                   	retq   

0000000000802273 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802273:	55                   	push   %rbp
  802274:	48 89 e5             	mov    %rsp,%rbp
  802277:	48 83 ec 20          	sub    $0x20,%rsp
  80227b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80227e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802282:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802286:	78 06                	js     80228e <fd_lookup+0x1b>
  802288:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80228c:	7e 07                	jle    802295 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80228e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802293:	eb 6c                	jmp    802301 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802295:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802298:	48 98                	cltq   
  80229a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022a0:	48 c1 e0 0c          	shl    $0xc,%rax
  8022a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ac:	48 c1 e8 15          	shr    $0x15,%rax
  8022b0:	48 89 c2             	mov    %rax,%rdx
  8022b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ba:	01 00 00 
  8022bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	48 85 c0             	test   %rax,%rax
  8022c7:	74 21                	je     8022ea <fd_lookup+0x77>
  8022c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8022d1:	48 89 c2             	mov    %rax,%rdx
  8022d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022db:	01 00 00 
  8022de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e2:	83 e0 01             	and    $0x1,%eax
  8022e5:	48 85 c0             	test   %rax,%rax
  8022e8:	75 07                	jne    8022f1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ef:	eb 10                	jmp    802301 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022f9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802301:	c9                   	leaveq 
  802302:	c3                   	retq   

0000000000802303 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
  802307:	48 83 ec 30          	sub    $0x30,%rsp
  80230b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80230f:	89 f0                	mov    %esi,%eax
  802311:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802318:	48 89 c7             	mov    %rax,%rdi
  80231b:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  802322:	00 00 00 
  802325:	ff d0                	callq  *%rax
  802327:	89 c2                	mov    %eax,%edx
  802329:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80232d:	48 89 c6             	mov    %rax,%rsi
  802330:	89 d7                	mov    %edx,%edi
  802332:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  802339:	00 00 00 
  80233c:	ff d0                	callq  *%rax
  80233e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802341:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802345:	78 0a                	js     802351 <fd_close+0x4e>
	    || fd != fd2)
  802347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80234f:	74 12                	je     802363 <fd_close+0x60>
		return (must_exist ? r : 0);
  802351:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802355:	74 05                	je     80235c <fd_close+0x59>
  802357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235a:	eb 70                	jmp    8023cc <fd_close+0xc9>
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	eb 69                	jmp    8023cc <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802367:	8b 00                	mov    (%rax),%eax
  802369:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80236d:	48 89 d6             	mov    %rdx,%rsi
  802370:	89 c7                	mov    %eax,%edi
  802372:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
  80237e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802381:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802385:	78 2a                	js     8023b1 <fd_close+0xae>
		if (dev->dev_close)
  802387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80238f:	48 85 c0             	test   %rax,%rax
  802392:	74 16                	je     8023aa <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802398:	48 8b 40 20          	mov    0x20(%rax),%rax
  80239c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023a0:	48 89 d7             	mov    %rdx,%rdi
  8023a3:	ff d0                	callq  *%rax
  8023a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a8:	eb 07                	jmp    8023b1 <fd_close+0xae>
		else
			r = 0;
  8023aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023b5:	48 89 c6             	mov    %rax,%rsi
  8023b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023bd:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	callq  *%rax
	return r;
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 20          	sub    $0x20,%rsp
  8023d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e4:	eb 41                	jmp    802427 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023e6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023ed:	00 00 00 
  8023f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023f3:	48 63 d2             	movslq %edx,%rdx
  8023f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023fa:	8b 00                	mov    (%rax),%eax
  8023fc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023ff:	75 22                	jne    802423 <dev_lookup+0x55>
			*dev = devtab[i];
  802401:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802408:	00 00 00 
  80240b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80240e:	48 63 d2             	movslq %edx,%rdx
  802411:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802415:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802419:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	eb 60                	jmp    802483 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802423:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802427:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80242e:	00 00 00 
  802431:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802434:	48 63 d2             	movslq %edx,%rdx
  802437:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243b:	48 85 c0             	test   %rax,%rax
  80243e:	75 a6                	jne    8023e6 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802440:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802447:	00 00 00 
  80244a:	48 8b 00             	mov    (%rax),%rax
  80244d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802453:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802456:	89 c6                	mov    %eax,%esi
  802458:	48 bf d0 47 80 00 00 	movabs $0x8047d0,%rdi
  80245f:	00 00 00 
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	48 b9 41 06 80 00 00 	movabs $0x800641,%rcx
  80246e:	00 00 00 
  802471:	ff d1                	callq  *%rcx
	*dev = 0;
  802473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802477:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80247e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802483:	c9                   	leaveq 
  802484:	c3                   	retq   

0000000000802485 <close>:

int
close(int fdnum)
{
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	48 83 ec 20          	sub    $0x20,%rsp
  80248d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802490:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802494:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802497:	48 89 d6             	mov    %rdx,%rsi
  80249a:	89 c7                	mov    %eax,%edi
  80249c:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	callq  *%rax
  8024a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024af:	79 05                	jns    8024b6 <close+0x31>
		return r;
  8024b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b4:	eb 18                	jmp    8024ce <close+0x49>
	else
		return fd_close(fd, 1);
  8024b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ba:	be 01 00 00 00       	mov    $0x1,%esi
  8024bf:	48 89 c7             	mov    %rax,%rdi
  8024c2:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  8024c9:	00 00 00 
  8024cc:	ff d0                	callq  *%rax
}
  8024ce:	c9                   	leaveq 
  8024cf:	c3                   	retq   

00000000008024d0 <close_all>:

void
close_all(void)
{
  8024d0:	55                   	push   %rbp
  8024d1:	48 89 e5             	mov    %rsp,%rbp
  8024d4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024df:	eb 15                	jmp    8024f6 <close_all+0x26>
		close(i);
  8024e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e4:	89 c7                	mov    %eax,%edi
  8024e6:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8024ed:	00 00 00 
  8024f0:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8024f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024f6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024fa:	7e e5                	jle    8024e1 <close_all+0x11>
}
  8024fc:	c9                   	leaveq 
  8024fd:	c3                   	retq   

00000000008024fe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024fe:	55                   	push   %rbp
  8024ff:	48 89 e5             	mov    %rsp,%rbp
  802502:	48 83 ec 40          	sub    $0x40,%rsp
  802506:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802509:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80250c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802510:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802513:	48 89 d6             	mov    %rdx,%rsi
  802516:	89 c7                	mov    %eax,%edi
  802518:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
  802524:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252b:	79 08                	jns    802535 <dup+0x37>
		return r;
  80252d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802530:	e9 70 01 00 00       	jmpq   8026a5 <dup+0x1a7>
	close(newfdnum);
  802535:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802538:	89 c7                	mov    %eax,%edi
  80253a:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802541:	00 00 00 
  802544:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802546:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802549:	48 98                	cltq   
  80254b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802551:	48 c1 e0 0c          	shl    $0xc,%rax
  802555:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80255d:	48 89 c7             	mov    %rax,%rdi
  802560:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802567:	00 00 00 
  80256a:	ff d0                	callq  *%rax
  80256c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802574:	48 89 c7             	mov    %rax,%rdi
  802577:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
  802583:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258b:	48 c1 e8 15          	shr    $0x15,%rax
  80258f:	48 89 c2             	mov    %rax,%rdx
  802592:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802599:	01 00 00 
  80259c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a0:	83 e0 01             	and    $0x1,%eax
  8025a3:	48 85 c0             	test   %rax,%rax
  8025a6:	74 73                	je     80261b <dup+0x11d>
  8025a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b0:	48 89 c2             	mov    %rax,%rdx
  8025b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ba:	01 00 00 
  8025bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c1:	83 e0 01             	and    $0x1,%eax
  8025c4:	48 85 c0             	test   %rax,%rax
  8025c7:	74 52                	je     80261b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8025d1:	48 89 c2             	mov    %rax,%rdx
  8025d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025db:	01 00 00 
  8025de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8025e7:	89 c1                	mov    %eax,%ecx
  8025e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f1:	41 89 c8             	mov    %ecx,%r8d
  8025f4:	48 89 d1             	mov    %rdx,%rcx
  8025f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fc:	48 89 c6             	mov    %rax,%rsi
  8025ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802604:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  80260b:	00 00 00 
  80260e:	ff d0                	callq  *%rax
  802610:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802613:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802617:	79 02                	jns    80261b <dup+0x11d>
			goto err;
  802619:	eb 57                	jmp    802672 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80261b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261f:	48 c1 e8 0c          	shr    $0xc,%rax
  802623:	48 89 c2             	mov    %rax,%rdx
  802626:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80262d:	01 00 00 
  802630:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802634:	25 07 0e 00 00       	and    $0xe07,%eax
  802639:	89 c1                	mov    %eax,%ecx
  80263b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80263f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802643:	41 89 c8             	mov    %ecx,%r8d
  802646:	48 89 d1             	mov    %rdx,%rcx
  802649:	ba 00 00 00 00       	mov    $0x0,%edx
  80264e:	48 89 c6             	mov    %rax,%rsi
  802651:	bf 00 00 00 00       	mov    $0x0,%edi
  802656:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
  802662:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802665:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802669:	79 02                	jns    80266d <dup+0x16f>
		goto err;
  80266b:	eb 05                	jmp    802672 <dup+0x174>

	return newfdnum;
  80266d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802670:	eb 33                	jmp    8026a5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802676:	48 89 c6             	mov    %rax,%rsi
  802679:	bf 00 00 00 00       	mov    $0x0,%edi
  80267e:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80268a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268e:	48 89 c6             	mov    %rax,%rsi
  802691:	bf 00 00 00 00       	mov    $0x0,%edi
  802696:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	callq  *%rax
	return r;
  8026a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026a5:	c9                   	leaveq 
  8026a6:	c3                   	retq   

00000000008026a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026a7:	55                   	push   %rbp
  8026a8:	48 89 e5             	mov    %rsp,%rbp
  8026ab:	48 83 ec 40          	sub    $0x40,%rsp
  8026af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026c1:	48 89 d6             	mov    %rdx,%rsi
  8026c4:	89 c7                	mov    %eax,%edi
  8026c6:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d9:	78 24                	js     8026ff <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	8b 00                	mov    (%rax),%eax
  8026e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e5:	48 89 d6             	mov    %rdx,%rsi
  8026e8:	89 c7                	mov    %eax,%edi
  8026ea:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fd:	79 05                	jns    802704 <read+0x5d>
		return r;
  8026ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802702:	eb 76                	jmp    80277a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802708:	8b 40 08             	mov    0x8(%rax),%eax
  80270b:	83 e0 03             	and    $0x3,%eax
  80270e:	83 f8 01             	cmp    $0x1,%eax
  802711:	75 3a                	jne    80274d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802713:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80271a:	00 00 00 
  80271d:	48 8b 00             	mov    (%rax),%rax
  802720:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802726:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802729:	89 c6                	mov    %eax,%esi
  80272b:	48 bf ef 47 80 00 00 	movabs $0x8047ef,%rdi
  802732:	00 00 00 
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	48 b9 41 06 80 00 00 	movabs $0x800641,%rcx
  802741:	00 00 00 
  802744:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80274b:	eb 2d                	jmp    80277a <read+0xd3>
	}
	if (!dev->dev_read)
  80274d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802751:	48 8b 40 10          	mov    0x10(%rax),%rax
  802755:	48 85 c0             	test   %rax,%rax
  802758:	75 07                	jne    802761 <read+0xba>
		return -E_NOT_SUPP;
  80275a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80275f:	eb 19                	jmp    80277a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802765:	48 8b 40 10          	mov    0x10(%rax),%rax
  802769:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80276d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802771:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802775:	48 89 cf             	mov    %rcx,%rdi
  802778:	ff d0                	callq  *%rax
}
  80277a:	c9                   	leaveq 
  80277b:	c3                   	retq   

000000000080277c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80277c:	55                   	push   %rbp
  80277d:	48 89 e5             	mov    %rsp,%rbp
  802780:	48 83 ec 30          	sub    $0x30,%rsp
  802784:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80278b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80278f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802796:	eb 49                	jmp    8027e1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279b:	48 98                	cltq   
  80279d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027a1:	48 29 c2             	sub    %rax,%rdx
  8027a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a7:	48 63 c8             	movslq %eax,%rcx
  8027aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ae:	48 01 c1             	add    %rax,%rcx
  8027b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027b4:	48 89 ce             	mov    %rcx,%rsi
  8027b7:	89 c7                	mov    %eax,%edi
  8027b9:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
  8027c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027cc:	79 05                	jns    8027d3 <readn+0x57>
			return m;
  8027ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027d1:	eb 1c                	jmp    8027ef <readn+0x73>
		if (m == 0)
  8027d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027d7:	75 02                	jne    8027db <readn+0x5f>
			break;
  8027d9:	eb 11                	jmp    8027ec <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8027db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027de:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e4:	48 98                	cltq   
  8027e6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027ea:	72 ac                	jb     802798 <readn+0x1c>
	}
	return tot;
  8027ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027ef:	c9                   	leaveq 
  8027f0:	c3                   	retq   

00000000008027f1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027f1:	55                   	push   %rbp
  8027f2:	48 89 e5             	mov    %rsp,%rbp
  8027f5:	48 83 ec 40          	sub    $0x40,%rsp
  8027f9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802800:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802804:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802808:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80280b:	48 89 d6             	mov    %rdx,%rsi
  80280e:	89 c7                	mov    %eax,%edi
  802810:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
  80281c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802823:	78 24                	js     802849 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802829:	8b 00                	mov    (%rax),%eax
  80282b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80282f:	48 89 d6             	mov    %rdx,%rsi
  802832:	89 c7                	mov    %eax,%edi
  802834:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80283b:	00 00 00 
  80283e:	ff d0                	callq  *%rax
  802840:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802843:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802847:	79 05                	jns    80284e <write+0x5d>
		return r;
  802849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284c:	eb 75                	jmp    8028c3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80284e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802852:	8b 40 08             	mov    0x8(%rax),%eax
  802855:	83 e0 03             	and    $0x3,%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	75 3a                	jne    802896 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80285c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802863:	00 00 00 
  802866:	48 8b 00             	mov    (%rax),%rax
  802869:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80286f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802872:	89 c6                	mov    %eax,%esi
  802874:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  80287b:	00 00 00 
  80287e:	b8 00 00 00 00       	mov    $0x0,%eax
  802883:	48 b9 41 06 80 00 00 	movabs $0x800641,%rcx
  80288a:	00 00 00 
  80288d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80288f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802894:	eb 2d                	jmp    8028c3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80289e:	48 85 c0             	test   %rax,%rax
  8028a1:	75 07                	jne    8028aa <write+0xb9>
		return -E_NOT_SUPP;
  8028a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028a8:	eb 19                	jmp    8028c3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ae:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028b6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028ba:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028be:	48 89 cf             	mov    %rcx,%rdi
  8028c1:	ff d0                	callq  *%rax
}
  8028c3:	c9                   	leaveq 
  8028c4:	c3                   	retq   

00000000008028c5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028c5:	55                   	push   %rbp
  8028c6:	48 89 e5             	mov    %rsp,%rbp
  8028c9:	48 83 ec 18          	sub    $0x18,%rsp
  8028cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028da:	48 89 d6             	mov    %rdx,%rsi
  8028dd:	89 c7                	mov    %eax,%edi
  8028df:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	callq  *%rax
  8028eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f2:	79 05                	jns    8028f9 <seek+0x34>
		return r;
  8028f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f7:	eb 0f                	jmp    802908 <seek+0x43>
	fd->fd_offset = offset;
  8028f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802900:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802908:	c9                   	leaveq 
  802909:	c3                   	retq   

000000000080290a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80290a:	55                   	push   %rbp
  80290b:	48 89 e5             	mov    %rsp,%rbp
  80290e:	48 83 ec 30          	sub    $0x30,%rsp
  802912:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802915:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802918:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80291c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80291f:	48 89 d6             	mov    %rdx,%rsi
  802922:	89 c7                	mov    %eax,%edi
  802924:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	callq  *%rax
  802930:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802937:	78 24                	js     80295d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802939:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293d:	8b 00                	mov    (%rax),%eax
  80293f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802943:	48 89 d6             	mov    %rdx,%rsi
  802946:	89 c7                	mov    %eax,%edi
  802948:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
  802954:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802957:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295b:	79 05                	jns    802962 <ftruncate+0x58>
		return r;
  80295d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802960:	eb 72                	jmp    8029d4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802966:	8b 40 08             	mov    0x8(%rax),%eax
  802969:	83 e0 03             	and    $0x3,%eax
  80296c:	85 c0                	test   %eax,%eax
  80296e:	75 3a                	jne    8029aa <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802970:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802977:	00 00 00 
  80297a:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80297d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802983:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802986:	89 c6                	mov    %eax,%esi
  802988:	48 bf 28 48 80 00 00 	movabs $0x804828,%rdi
  80298f:	00 00 00 
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	48 b9 41 06 80 00 00 	movabs $0x800641,%rcx
  80299e:	00 00 00 
  8029a1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a8:	eb 2a                	jmp    8029d4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ae:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029b2:	48 85 c0             	test   %rax,%rax
  8029b5:	75 07                	jne    8029be <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029bc:	eb 16                	jmp    8029d4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ca:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029cd:	89 ce                	mov    %ecx,%esi
  8029cf:	48 89 d7             	mov    %rdx,%rdi
  8029d2:	ff d0                	callq  *%rax
}
  8029d4:	c9                   	leaveq 
  8029d5:	c3                   	retq   

00000000008029d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029d6:	55                   	push   %rbp
  8029d7:	48 89 e5             	mov    %rsp,%rbp
  8029da:	48 83 ec 30          	sub    $0x30,%rsp
  8029de:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029ec:	48 89 d6             	mov    %rdx,%rsi
  8029ef:	89 c7                	mov    %eax,%edi
  8029f1:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
  8029fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a04:	78 24                	js     802a2a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0a:	8b 00                	mov    (%rax),%eax
  802a0c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a10:	48 89 d6             	mov    %rdx,%rsi
  802a13:	89 c7                	mov    %eax,%edi
  802a15:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
  802a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a28:	79 05                	jns    802a2f <fstat+0x59>
		return r;
  802a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2d:	eb 5e                	jmp    802a8d <fstat+0xb7>
	if (!dev->dev_stat)
  802a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a33:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a37:	48 85 c0             	test   %rax,%rax
  802a3a:	75 07                	jne    802a43 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a3c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a41:	eb 4a                	jmp    802a8d <fstat+0xb7>
	stat->st_name[0] = 0;
  802a43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a47:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a4e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a55:	00 00 00 
	stat->st_isdir = 0;
  802a58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a5c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a63:	00 00 00 
	stat->st_dev = dev;
  802a66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a6e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a79:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a81:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a85:	48 89 ce             	mov    %rcx,%rsi
  802a88:	48 89 d7             	mov    %rdx,%rdi
  802a8b:	ff d0                	callq  *%rax
}
  802a8d:	c9                   	leaveq 
  802a8e:	c3                   	retq   

0000000000802a8f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a8f:	55                   	push   %rbp
  802a90:	48 89 e5             	mov    %rsp,%rbp
  802a93:	48 83 ec 20          	sub    $0x20,%rsp
  802a97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa3:	be 00 00 00 00       	mov    $0x0,%esi
  802aa8:	48 89 c7             	mov    %rax,%rdi
  802aab:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	callq  *%rax
  802ab7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abe:	79 05                	jns    802ac5 <stat+0x36>
		return fd;
  802ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac3:	eb 2f                	jmp    802af4 <stat+0x65>
	r = fstat(fd, stat);
  802ac5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acc:	48 89 d6             	mov    %rdx,%rsi
  802acf:	89 c7                	mov    %eax,%edi
  802ad1:	48 b8 d6 29 80 00 00 	movabs $0x8029d6,%rax
  802ad8:	00 00 00 
  802adb:	ff d0                	callq  *%rax
  802add:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	89 c7                	mov    %eax,%edi
  802ae5:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
	return r;
  802af1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802af4:	c9                   	leaveq 
  802af5:	c3                   	retq   

0000000000802af6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802af6:	55                   	push   %rbp
  802af7:	48 89 e5             	mov    %rsp,%rbp
  802afa:	48 83 ec 10          	sub    $0x10,%rsp
  802afe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b05:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b0c:	00 00 00 
  802b0f:	8b 00                	mov    (%rax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	75 1f                	jne    802b34 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b15:	bf 01 00 00 00       	mov    $0x1,%edi
  802b1a:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
  802b26:	89 c2                	mov    %eax,%edx
  802b28:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b2f:	00 00 00 
  802b32:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b34:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b3b:	00 00 00 
  802b3e:	8b 00                	mov    (%rax),%eax
  802b40:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b43:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b48:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b4f:	00 00 00 
  802b52:	89 c7                	mov    %eax,%edi
  802b54:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b64:	ba 00 00 00 00       	mov    $0x0,%edx
  802b69:	48 89 c6             	mov    %rax,%rsi
  802b6c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b71:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  802b78:	00 00 00 
  802b7b:	ff d0                	callq  *%rax
}
  802b7d:	c9                   	leaveq 
  802b7e:	c3                   	retq   

0000000000802b7f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b7f:	55                   	push   %rbp
  802b80:	48 89 e5             	mov    %rsp,%rbp
  802b83:	48 83 ec 10          	sub    $0x10,%rsp
  802b87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b8b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802b8e:	48 ba 4e 48 80 00 00 	movabs $0x80484e,%rdx
  802b95:	00 00 00 
  802b98:	be 4c 00 00 00       	mov    $0x4c,%esi
  802b9d:	48 bf 63 48 80 00 00 	movabs $0x804863,%rdi
  802ba4:	00 00 00 
  802ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bac:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  802bb3:	00 00 00 
  802bb6:	ff d1                	callq  *%rcx

0000000000802bb8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bb8:	55                   	push   %rbp
  802bb9:	48 89 e5             	mov    %rsp,%rbp
  802bbc:	48 83 ec 10          	sub    $0x10,%rsp
  802bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc8:	8b 50 0c             	mov    0xc(%rax),%edx
  802bcb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd2:	00 00 00 
  802bd5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bd7:	be 00 00 00 00       	mov    $0x0,%esi
  802bdc:	bf 06 00 00 00       	mov    $0x6,%edi
  802be1:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
}
  802bed:	c9                   	leaveq 
  802bee:	c3                   	retq   

0000000000802bef <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802bef:	55                   	push   %rbp
  802bf0:	48 89 e5             	mov    %rsp,%rbp
  802bf3:	48 83 ec 20          	sub    $0x20,%rsp
  802bf7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802c03:	48 ba 6e 48 80 00 00 	movabs $0x80486e,%rdx
  802c0a:	00 00 00 
  802c0d:	be 6b 00 00 00       	mov    $0x6b,%esi
  802c12:	48 bf 63 48 80 00 00 	movabs $0x804863,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  802c28:	00 00 00 
  802c2b:	ff d1                	callq  *%rcx

0000000000802c2d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c2d:	55                   	push   %rbp
  802c2e:	48 89 e5             	mov    %rsp,%rbp
  802c31:	48 83 ec 20          	sub    $0x20,%rsp
  802c35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c3d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802c41:	48 ba 8b 48 80 00 00 	movabs $0x80488b,%rdx
  802c48:	00 00 00 
  802c4b:	be 7b 00 00 00       	mov    $0x7b,%esi
  802c50:	48 bf 63 48 80 00 00 	movabs $0x804863,%rdi
  802c57:	00 00 00 
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5f:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  802c66:	00 00 00 
  802c69:	ff d1                	callq  *%rcx

0000000000802c6b <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c6b:	55                   	push   %rbp
  802c6c:	48 89 e5             	mov    %rsp,%rbp
  802c6f:	48 83 ec 20          	sub    $0x20,%rsp
  802c73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7f:	8b 50 0c             	mov    0xc(%rax),%edx
  802c82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c89:	00 00 00 
  802c8c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c8e:	be 00 00 00 00       	mov    $0x0,%esi
  802c93:	bf 05 00 00 00       	mov    $0x5,%edi
  802c98:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802c9f:	00 00 00 
  802ca2:	ff d0                	callq  *%rax
  802ca4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cab:	79 05                	jns    802cb2 <devfile_stat+0x47>
		return r;
  802cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb0:	eb 56                	jmp    802d08 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802cb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802cbd:	00 00 00 
  802cc0:	48 89 c7             	mov    %rax,%rdi
  802cc3:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ccf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd6:	00 00 00 
  802cd9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802cdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ce9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cf0:	00 00 00 
  802cf3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802cf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cfd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d08:	c9                   	leaveq 
  802d09:	c3                   	retq   

0000000000802d0a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d0a:	55                   	push   %rbp
  802d0b:	48 89 e5             	mov    %rsp,%rbp
  802d0e:	48 83 ec 10          	sub    $0x10,%rsp
  802d12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d16:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d20:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d27:	00 00 00 
  802d2a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802d2c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d33:	00 00 00 
  802d36:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802d39:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d3c:	be 00 00 00 00       	mov    $0x0,%esi
  802d41:	bf 02 00 00 00       	mov    $0x2,%edi
  802d46:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
}
  802d52:	c9                   	leaveq 
  802d53:	c3                   	retq   

0000000000802d54 <remove>:

// Delete a file
int
remove(const char *path)
{
  802d54:	55                   	push   %rbp
  802d55:	48 89 e5             	mov    %rsp,%rbp
  802d58:	48 83 ec 10          	sub    $0x10,%rsp
  802d5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d64:	48 89 c7             	mov    %rax,%rdi
  802d67:	48 b8 6f 11 80 00 00 	movabs $0x80116f,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
  802d73:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d78:	7e 07                	jle    802d81 <remove+0x2d>
		return -E_BAD_PATH;
  802d7a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d7f:	eb 33                	jmp    802db4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d85:	48 89 c6             	mov    %rax,%rsi
  802d88:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d8f:	00 00 00 
  802d92:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d9e:	be 00 00 00 00       	mov    $0x0,%esi
  802da3:	bf 07 00 00 00       	mov    $0x7,%edi
  802da8:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
}
  802db4:	c9                   	leaveq 
  802db5:	c3                   	retq   

0000000000802db6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802db6:	55                   	push   %rbp
  802db7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802dba:	be 00 00 00 00       	mov    $0x0,%esi
  802dbf:	bf 08 00 00 00       	mov    $0x8,%edi
  802dc4:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
}
  802dd0:	5d                   	pop    %rbp
  802dd1:	c3                   	retq   

0000000000802dd2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ddd:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802de4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802deb:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802df2:	be 00 00 00 00       	mov    $0x0,%esi
  802df7:	48 89 c7             	mov    %rax,%rdi
  802dfa:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
  802e06:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802e09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0d:	79 28                	jns    802e37 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e12:	89 c6                	mov    %eax,%esi
  802e14:	48 bf a9 48 80 00 00 	movabs $0x8048a9,%rdi
  802e1b:	00 00 00 
  802e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e23:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  802e2a:	00 00 00 
  802e2d:	ff d2                	callq  *%rdx
		return fd_src;
  802e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e32:	e9 74 01 00 00       	jmpq   802fab <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802e37:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802e3e:	be 01 01 00 00       	mov    $0x101,%esi
  802e43:	48 89 c7             	mov    %rax,%rdi
  802e46:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
  802e52:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e55:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e59:	79 39                	jns    802e94 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e5e:	89 c6                	mov    %eax,%esi
  802e60:	48 bf bf 48 80 00 00 	movabs $0x8048bf,%rdi
  802e67:	00 00 00 
  802e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6f:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  802e76:	00 00 00 
  802e79:	ff d2                	callq  *%rdx
		close(fd_src);
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7e:	89 c7                	mov    %eax,%edi
  802e80:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802e87:	00 00 00 
  802e8a:	ff d0                	callq  *%rax
		return fd_dest;
  802e8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e8f:	e9 17 01 00 00       	jmpq   802fab <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e94:	eb 74                	jmp    802f0a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802e96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e99:	48 63 d0             	movslq %eax,%rdx
  802e9c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ea3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea6:	48 89 ce             	mov    %rcx,%rsi
  802ea9:	89 c7                	mov    %eax,%edi
  802eab:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802eba:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802ebe:	79 4a                	jns    802f0a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802ec0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ec3:	89 c6                	mov    %eax,%esi
  802ec5:	48 bf d9 48 80 00 00 	movabs $0x8048d9,%rdi
  802ecc:	00 00 00 
  802ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed4:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  802edb:	00 00 00 
  802ede:	ff d2                	callq  *%rdx
			close(fd_src);
  802ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee3:	89 c7                	mov    %eax,%edi
  802ee5:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
			close(fd_dest);
  802ef1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef4:	89 c7                	mov    %eax,%edi
  802ef6:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
			return write_size;
  802f02:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f05:	e9 a1 00 00 00       	jmpq   802fab <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f0a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	ba 00 02 00 00       	mov    $0x200,%edx
  802f19:	48 89 ce             	mov    %rcx,%rsi
  802f1c:	89 c7                	mov    %eax,%edi
  802f1e:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
  802f2a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f31:	0f 8f 5f ff ff ff    	jg     802e96 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f3b:	79 47                	jns    802f84 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802f3d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f40:	89 c6                	mov    %eax,%esi
  802f42:	48 bf ec 48 80 00 00 	movabs $0x8048ec,%rdi
  802f49:	00 00 00 
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	48 ba 41 06 80 00 00 	movabs $0x800641,%rdx
  802f58:	00 00 00 
  802f5b:	ff d2                	callq  *%rdx
		close(fd_src);
  802f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f60:	89 c7                	mov    %eax,%edi
  802f62:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
		close(fd_dest);
  802f6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
		return read_size;
  802f7f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f82:	eb 27                	jmp    802fab <copy+0x1d9>
	}
	close(fd_src);
  802f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f87:	89 c7                	mov    %eax,%edi
  802f89:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
	close(fd_dest);
  802f95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f98:	89 c7                	mov    %eax,%edi
  802f9a:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802fa1:	00 00 00 
  802fa4:	ff d0                	callq  *%rax
	return 0;
  802fa6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802fab:	c9                   	leaveq 
  802fac:	c3                   	retq   

0000000000802fad <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fad:	55                   	push   %rbp
  802fae:	48 89 e5             	mov    %rsp,%rbp
  802fb1:	48 83 ec 18          	sub    $0x18,%rsp
  802fb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  802fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbd:	48 c1 e8 15          	shr    $0x15,%rax
  802fc1:	48 89 c2             	mov    %rax,%rdx
  802fc4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802fcb:	01 00 00 
  802fce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fd2:	83 e0 01             	and    $0x1,%eax
  802fd5:	48 85 c0             	test   %rax,%rax
  802fd8:	75 07                	jne    802fe1 <pageref+0x34>
		return 0;
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdf:	eb 53                	jmp    803034 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  802fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe5:	48 c1 e8 0c          	shr    $0xc,%rax
  802fe9:	48 89 c2             	mov    %rax,%rdx
  802fec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ff3:	01 00 00 
  802ff6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ffa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  802ffe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803002:	83 e0 01             	and    $0x1,%eax
  803005:	48 85 c0             	test   %rax,%rax
  803008:	75 07                	jne    803011 <pageref+0x64>
		return 0;
  80300a:	b8 00 00 00 00       	mov    $0x0,%eax
  80300f:	eb 23                	jmp    803034 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803011:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803015:	48 c1 e8 0c          	shr    $0xc,%rax
  803019:	48 89 c2             	mov    %rax,%rdx
  80301c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803023:	00 00 00 
  803026:	48 c1 e2 04          	shl    $0x4,%rdx
  80302a:	48 01 d0             	add    %rdx,%rax
  80302d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803031:	0f b7 c0             	movzwl %ax,%eax
}
  803034:	c9                   	leaveq 
  803035:	c3                   	retq   

0000000000803036 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803036:	55                   	push   %rbp
  803037:	48 89 e5             	mov    %rsp,%rbp
  80303a:	48 83 ec 20          	sub    $0x20,%rsp
  80303e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803041:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803045:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803048:	48 89 d6             	mov    %rdx,%rsi
  80304b:	89 c7                	mov    %eax,%edi
  80304d:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803054:	00 00 00 
  803057:	ff d0                	callq  *%rax
  803059:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803060:	79 05                	jns    803067 <fd2sockid+0x31>
		return r;
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	eb 24                	jmp    80308b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306b:	8b 10                	mov    (%rax),%edx
  80306d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803074:	00 00 00 
  803077:	8b 00                	mov    (%rax),%eax
  803079:	39 c2                	cmp    %eax,%edx
  80307b:	74 07                	je     803084 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80307d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803082:	eb 07                	jmp    80308b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803088:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80308b:	c9                   	leaveq 
  80308c:	c3                   	retq   

000000000080308d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80308d:	55                   	push   %rbp
  80308e:	48 89 e5             	mov    %rsp,%rbp
  803091:	48 83 ec 20          	sub    $0x20,%rsp
  803095:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803098:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80309c:	48 89 c7             	mov    %rax,%rdi
  80309f:	48 b8 db 21 80 00 00 	movabs $0x8021db,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
  8030ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b2:	78 26                	js     8030da <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8030b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b8:	ba 07 04 00 00       	mov    $0x407,%edx
  8030bd:	48 89 c6             	mov    %rax,%rsi
  8030c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c5:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
  8030d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d8:	79 16                	jns    8030f0 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8030da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030dd:	89 c7                	mov    %eax,%edi
  8030df:	48 b8 9c 35 80 00 00 	movabs $0x80359c,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
		return r;
  8030eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ee:	eb 3a                	jmp    80312a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8030f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f4:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8030fb:	00 00 00 
  8030fe:	8b 12                	mov    (%rdx),%edx
  803100:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803102:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803106:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80310d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803111:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803114:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311b:	48 89 c7             	mov    %rax,%rdi
  80311e:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  803125:	00 00 00 
  803128:	ff d0                	callq  *%rax
}
  80312a:	c9                   	leaveq 
  80312b:	c3                   	retq   

000000000080312c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80312c:	55                   	push   %rbp
  80312d:	48 89 e5             	mov    %rsp,%rbp
  803130:	48 83 ec 30          	sub    $0x30,%rsp
  803134:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80313b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80313f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803142:	89 c7                	mov    %eax,%edi
  803144:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  80314b:	00 00 00 
  80314e:	ff d0                	callq  *%rax
  803150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803157:	79 05                	jns    80315e <accept+0x32>
		return r;
  803159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315c:	eb 3b                	jmp    803199 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80315e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803162:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803169:	48 89 ce             	mov    %rcx,%rsi
  80316c:	89 c7                	mov    %eax,%edi
  80316e:	48 b8 79 34 80 00 00 	movabs $0x803479,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
  80317a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803181:	79 05                	jns    803188 <accept+0x5c>
		return r;
  803183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803186:	eb 11                	jmp    803199 <accept+0x6d>
	return alloc_sockfd(r);
  803188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 8d 30 80 00 00 	movabs $0x80308d,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
}
  803199:	c9                   	leaveq 
  80319a:	c3                   	retq   

000000000080319b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80319b:	55                   	push   %rbp
  80319c:	48 89 e5             	mov    %rsp,%rbp
  80319f:	48 83 ec 20          	sub    $0x20,%rsp
  8031a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031aa:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031b0:	89 c7                	mov    %eax,%edi
  8031b2:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
  8031be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c5:	79 05                	jns    8031cc <bind+0x31>
		return r;
  8031c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ca:	eb 1b                	jmp    8031e7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8031cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031cf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d6:	48 89 ce             	mov    %rcx,%rsi
  8031d9:	89 c7                	mov    %eax,%edi
  8031db:	48 b8 f8 34 80 00 00 	movabs $0x8034f8,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
}
  8031e7:	c9                   	leaveq 
  8031e8:	c3                   	retq   

00000000008031e9 <shutdown>:

int
shutdown(int s, int how)
{
  8031e9:	55                   	push   %rbp
  8031ea:	48 89 e5             	mov    %rsp,%rbp
  8031ed:	48 83 ec 20          	sub    $0x20,%rsp
  8031f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031fa:	89 c7                	mov    %eax,%edi
  8031fc:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
  803208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80320b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80320f:	79 05                	jns    803216 <shutdown+0x2d>
		return r;
  803211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803214:	eb 16                	jmp    80322c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803216:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321c:	89 d6                	mov    %edx,%esi
  80321e:	89 c7                	mov    %eax,%edi
  803220:	48 b8 5c 35 80 00 00 	movabs $0x80355c,%rax
  803227:	00 00 00 
  80322a:	ff d0                	callq  *%rax
}
  80322c:	c9                   	leaveq 
  80322d:	c3                   	retq   

000000000080322e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80322e:	55                   	push   %rbp
  80322f:	48 89 e5             	mov    %rsp,%rbp
  803232:	48 83 ec 10          	sub    $0x10,%rsp
  803236:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80323a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323e:	48 89 c7             	mov    %rax,%rdi
  803241:	48 b8 ad 2f 80 00 00 	movabs $0x802fad,%rax
  803248:	00 00 00 
  80324b:	ff d0                	callq  *%rax
  80324d:	83 f8 01             	cmp    $0x1,%eax
  803250:	75 17                	jne    803269 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803256:	8b 40 0c             	mov    0xc(%rax),%eax
  803259:	89 c7                	mov    %eax,%edi
  80325b:	48 b8 9c 35 80 00 00 	movabs $0x80359c,%rax
  803262:	00 00 00 
  803265:	ff d0                	callq  *%rax
  803267:	eb 05                	jmp    80326e <devsock_close+0x40>
	else
		return 0;
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326e:	c9                   	leaveq 
  80326f:	c3                   	retq   

0000000000803270 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803270:	55                   	push   %rbp
  803271:	48 89 e5             	mov    %rsp,%rbp
  803274:	48 83 ec 20          	sub    $0x20,%rsp
  803278:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80327b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80327f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803282:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803285:	89 c7                	mov    %eax,%edi
  803287:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803296:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329a:	79 05                	jns    8032a1 <connect+0x31>
		return r;
  80329c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329f:	eb 1b                	jmp    8032bc <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8032a1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ab:	48 89 ce             	mov    %rcx,%rsi
  8032ae:	89 c7                	mov    %eax,%edi
  8032b0:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
}
  8032bc:	c9                   	leaveq 
  8032bd:	c3                   	retq   

00000000008032be <listen>:

int
listen(int s, int backlog)
{
  8032be:	55                   	push   %rbp
  8032bf:	48 89 e5             	mov    %rsp,%rbp
  8032c2:	48 83 ec 20          	sub    $0x20,%rsp
  8032c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032c9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032cf:	89 c7                	mov    %eax,%edi
  8032d1:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
  8032dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e4:	79 05                	jns    8032eb <listen+0x2d>
		return r;
  8032e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e9:	eb 16                	jmp    803301 <listen+0x43>
	return nsipc_listen(r, backlog);
  8032eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f1:	89 d6                	mov    %edx,%esi
  8032f3:	89 c7                	mov    %eax,%edi
  8032f5:	48 b8 2d 36 80 00 00 	movabs $0x80362d,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
}
  803301:	c9                   	leaveq 
  803302:	c3                   	retq   

0000000000803303 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803303:	55                   	push   %rbp
  803304:	48 89 e5             	mov    %rsp,%rbp
  803307:	48 83 ec 20          	sub    $0x20,%rsp
  80330b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80330f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803313:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331b:	89 c2                	mov    %eax,%edx
  80331d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803321:	8b 40 0c             	mov    0xc(%rax),%eax
  803324:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803328:	b9 00 00 00 00       	mov    $0x0,%ecx
  80332d:	89 c7                	mov    %eax,%edi
  80332f:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
}
  80333b:	c9                   	leaveq 
  80333c:	c3                   	retq   

000000000080333d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80333d:	55                   	push   %rbp
  80333e:	48 89 e5             	mov    %rsp,%rbp
  803341:	48 83 ec 20          	sub    $0x20,%rsp
  803345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803349:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80334d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803355:	89 c2                	mov    %eax,%edx
  803357:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80335b:	8b 40 0c             	mov    0xc(%rax),%eax
  80335e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803362:	b9 00 00 00 00       	mov    $0x0,%ecx
  803367:	89 c7                	mov    %eax,%edi
  803369:	48 b8 39 37 80 00 00 	movabs $0x803739,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
}
  803375:	c9                   	leaveq 
  803376:	c3                   	retq   

0000000000803377 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803377:	55                   	push   %rbp
  803378:	48 89 e5             	mov    %rsp,%rbp
  80337b:	48 83 ec 10          	sub    $0x10,%rsp
  80337f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803383:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338b:	48 be 07 49 80 00 00 	movabs $0x804907,%rsi
  803392:	00 00 00 
  803395:	48 89 c7             	mov    %rax,%rdi
  803398:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
	return 0;
  8033a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033a9:	c9                   	leaveq 
  8033aa:	c3                   	retq   

00000000008033ab <socket>:

int
socket(int domain, int type, int protocol)
{
  8033ab:	55                   	push   %rbp
  8033ac:	48 89 e5             	mov    %rsp,%rbp
  8033af:	48 83 ec 20          	sub    $0x20,%rsp
  8033b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033b9:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033bc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033bf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033c5:	89 ce                	mov    %ecx,%esi
  8033c7:	89 c7                	mov    %eax,%edi
  8033c9:	48 b8 f1 37 80 00 00 	movabs $0x8037f1,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
  8033d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033dc:	79 05                	jns    8033e3 <socket+0x38>
		return r;
  8033de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e1:	eb 11                	jmp    8033f4 <socket+0x49>
	return alloc_sockfd(r);
  8033e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 8d 30 80 00 00 	movabs $0x80308d,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 10          	sub    $0x10,%rsp
  8033fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803401:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803408:	00 00 00 
  80340b:	8b 00                	mov    (%rax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	75 1f                	jne    803430 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803411:	bf 02 00 00 00       	mov    $0x2,%edi
  803416:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
  803422:	89 c2                	mov    %eax,%edx
  803424:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80342b:	00 00 00 
  80342e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803430:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803437:	00 00 00 
  80343a:	8b 00                	mov    (%rax),%eax
  80343c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80343f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803444:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80344b:	00 00 00 
  80344e:	89 c7                	mov    %eax,%edi
  803450:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80345c:	ba 00 00 00 00       	mov    $0x0,%edx
  803461:	be 00 00 00 00       	mov    $0x0,%esi
  803466:	bf 00 00 00 00       	mov    $0x0,%edi
  80346b:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
}
  803477:	c9                   	leaveq 
  803478:	c3                   	retq   

0000000000803479 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803479:	55                   	push   %rbp
  80347a:	48 89 e5             	mov    %rsp,%rbp
  80347d:	48 83 ec 30          	sub    $0x30,%rsp
  803481:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803484:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803488:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80348c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803493:	00 00 00 
  803496:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803499:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80349b:	bf 01 00 00 00       	mov    $0x1,%edi
  8034a0:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b3:	78 3e                	js     8034f3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8034b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034bc:	00 00 00 
  8034bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c7:	8b 40 10             	mov    0x10(%rax),%eax
  8034ca:	89 c2                	mov    %eax,%edx
  8034cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d4:	48 89 ce             	mov    %rcx,%rsi
  8034d7:	48 89 c7             	mov    %rax,%rdi
  8034da:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  8034e1:	00 00 00 
  8034e4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8034e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ea:	8b 50 10             	mov    0x10(%rax),%edx
  8034ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8034f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034f6:	c9                   	leaveq 
  8034f7:	c3                   	retq   

00000000008034f8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034f8:	55                   	push   %rbp
  8034f9:	48 89 e5             	mov    %rsp,%rbp
  8034fc:	48 83 ec 10          	sub    $0x10,%rsp
  803500:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803503:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803507:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80350a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803511:	00 00 00 
  803514:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803517:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803519:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80351c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803520:	48 89 c6             	mov    %rax,%rsi
  803523:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80352a:	00 00 00 
  80352d:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803539:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803540:	00 00 00 
  803543:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803546:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803549:	bf 02 00 00 00       	mov    $0x2,%edi
  80354e:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
}
  80355a:	c9                   	leaveq 
  80355b:	c3                   	retq   

000000000080355c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80355c:	55                   	push   %rbp
  80355d:	48 89 e5             	mov    %rsp,%rbp
  803560:	48 83 ec 10          	sub    $0x10,%rsp
  803564:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803567:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80356a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803571:	00 00 00 
  803574:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803577:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803579:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803580:	00 00 00 
  803583:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803586:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803589:	bf 03 00 00 00       	mov    $0x3,%edi
  80358e:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
}
  80359a:	c9                   	leaveq 
  80359b:	c3                   	retq   

000000000080359c <nsipc_close>:

int
nsipc_close(int s)
{
  80359c:	55                   	push   %rbp
  80359d:	48 89 e5             	mov    %rsp,%rbp
  8035a0:	48 83 ec 10          	sub    $0x10,%rsp
  8035a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8035a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ae:	00 00 00 
  8035b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035b4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8035b6:	bf 04 00 00 00       	mov    $0x4,%edi
  8035bb:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  8035c2:	00 00 00 
  8035c5:	ff d0                	callq  *%rax
}
  8035c7:	c9                   	leaveq 
  8035c8:	c3                   	retq   

00000000008035c9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035c9:	55                   	push   %rbp
  8035ca:	48 89 e5             	mov    %rsp,%rbp
  8035cd:	48 83 ec 10          	sub    $0x10,%rsp
  8035d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035d8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8035db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035e2:	00 00 00 
  8035e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035e8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8035ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f1:	48 89 c6             	mov    %rax,%rsi
  8035f4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8035fb:	00 00 00 
  8035fe:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80360a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803611:	00 00 00 
  803614:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803617:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80361a:	bf 05 00 00 00       	mov    $0x5,%edi
  80361f:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  803626:	00 00 00 
  803629:	ff d0                	callq  *%rax
}
  80362b:	c9                   	leaveq 
  80362c:	c3                   	retq   

000000000080362d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80362d:	55                   	push   %rbp
  80362e:	48 89 e5             	mov    %rsp,%rbp
  803631:	48 83 ec 10          	sub    $0x10,%rsp
  803635:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803638:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80363b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803642:	00 00 00 
  803645:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803648:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80364a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803651:	00 00 00 
  803654:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803657:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80365a:	bf 06 00 00 00       	mov    $0x6,%edi
  80365f:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
}
  80366b:	c9                   	leaveq 
  80366c:	c3                   	retq   

000000000080366d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80366d:	55                   	push   %rbp
  80366e:	48 89 e5             	mov    %rsp,%rbp
  803671:	48 83 ec 30          	sub    $0x30,%rsp
  803675:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803678:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80367c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80367f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803682:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803689:	00 00 00 
  80368c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80368f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803691:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803698:	00 00 00 
  80369b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80369e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8036a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036a8:	00 00 00 
  8036ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8036ae:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8036b1:	bf 07 00 00 00       	mov    $0x7,%edi
  8036b6:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c9:	78 69                	js     803734 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8036cb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8036d2:	7f 08                	jg     8036dc <nsipc_recv+0x6f>
  8036d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8036da:	7e 35                	jle    803711 <nsipc_recv+0xa4>
  8036dc:	48 b9 0e 49 80 00 00 	movabs $0x80490e,%rcx
  8036e3:	00 00 00 
  8036e6:	48 ba 23 49 80 00 00 	movabs $0x804923,%rdx
  8036ed:	00 00 00 
  8036f0:	be 61 00 00 00       	mov    $0x61,%esi
  8036f5:	48 bf 38 49 80 00 00 	movabs $0x804938,%rdi
  8036fc:	00 00 00 
  8036ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803704:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  80370b:	00 00 00 
  80370e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803711:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803714:	48 63 d0             	movslq %eax,%rdx
  803717:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803722:	00 00 00 
  803725:	48 89 c7             	mov    %rax,%rdi
  803728:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  80372f:	00 00 00 
  803732:	ff d0                	callq  *%rax
	}

	return r;
  803734:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803737:	c9                   	leaveq 
  803738:	c3                   	retq   

0000000000803739 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803739:	55                   	push   %rbp
  80373a:	48 89 e5             	mov    %rsp,%rbp
  80373d:	48 83 ec 20          	sub    $0x20,%rsp
  803741:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803744:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803748:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80374b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80374e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803755:	00 00 00 
  803758:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80375b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80375d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803764:	7e 35                	jle    80379b <nsipc_send+0x62>
  803766:	48 b9 44 49 80 00 00 	movabs $0x804944,%rcx
  80376d:	00 00 00 
  803770:	48 ba 23 49 80 00 00 	movabs $0x804923,%rdx
  803777:	00 00 00 
  80377a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80377f:	48 bf 38 49 80 00 00 	movabs $0x804938,%rdi
  803786:	00 00 00 
  803789:	b8 00 00 00 00       	mov    $0x0,%eax
  80378e:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  803795:	00 00 00 
  803798:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80379b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80379e:	48 63 d0             	movslq %eax,%rdx
  8037a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a5:	48 89 c6             	mov    %rax,%rsi
  8037a8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8037af:	00 00 00 
  8037b2:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8037be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037c5:	00 00 00 
  8037c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037cb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8037ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d5:	00 00 00 
  8037d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037db:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8037de:	bf 08 00 00 00       	mov    $0x8,%edi
  8037e3:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  8037ea:	00 00 00 
  8037ed:	ff d0                	callq  *%rax
}
  8037ef:	c9                   	leaveq 
  8037f0:	c3                   	retq   

00000000008037f1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8037f1:	55                   	push   %rbp
  8037f2:	48 89 e5             	mov    %rsp,%rbp
  8037f5:	48 83 ec 10          	sub    $0x10,%rsp
  8037f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8037ff:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803802:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803809:	00 00 00 
  80380c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80380f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803811:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803818:	00 00 00 
  80381b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80381e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803821:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803828:	00 00 00 
  80382b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80382e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803831:	bf 09 00 00 00       	mov    $0x9,%edi
  803836:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
}
  803842:	c9                   	leaveq 
  803843:	c3                   	retq   

0000000000803844 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803844:	55                   	push   %rbp
  803845:	48 89 e5             	mov    %rsp,%rbp
  803848:	53                   	push   %rbx
  803849:	48 83 ec 38          	sub    $0x38,%rsp
  80384d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803851:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803855:	48 89 c7             	mov    %rax,%rdi
  803858:	48 b8 db 21 80 00 00 	movabs $0x8021db,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803867:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80386b:	0f 88 bf 01 00 00    	js     803a30 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803875:	ba 07 04 00 00       	mov    $0x407,%edx
  80387a:	48 89 c6             	mov    %rax,%rsi
  80387d:	bf 00 00 00 00       	mov    $0x0,%edi
  803882:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  803889:	00 00 00 
  80388c:	ff d0                	callq  *%rax
  80388e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803891:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803895:	0f 88 95 01 00 00    	js     803a30 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80389b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80389f:	48 89 c7             	mov    %rax,%rdi
  8038a2:	48 b8 db 21 80 00 00 	movabs $0x8021db,%rax
  8038a9:	00 00 00 
  8038ac:	ff d0                	callq  *%rax
  8038ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038b5:	0f 88 5d 01 00 00    	js     803a18 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038bf:	ba 07 04 00 00       	mov    $0x407,%edx
  8038c4:	48 89 c6             	mov    %rax,%rsi
  8038c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8038cc:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  8038d3:	00 00 00 
  8038d6:	ff d0                	callq  *%rax
  8038d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038df:	0f 88 33 01 00 00    	js     803a18 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e9:	48 89 c7             	mov    %rax,%rdi
  8038ec:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  8038f3:	00 00 00 
  8038f6:	ff d0                	callq  *%rax
  8038f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803900:	ba 07 04 00 00       	mov    $0x407,%edx
  803905:	48 89 c6             	mov    %rax,%rsi
  803908:	bf 00 00 00 00       	mov    $0x0,%edi
  80390d:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  803914:	00 00 00 
  803917:	ff d0                	callq  *%rax
  803919:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80391c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803920:	79 05                	jns    803927 <pipe+0xe3>
		goto err2;
  803922:	e9 d9 00 00 00       	jmpq   803a00 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803927:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80392b:	48 89 c7             	mov    %rax,%rdi
  80392e:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803935:	00 00 00 
  803938:	ff d0                	callq  *%rax
  80393a:	48 89 c2             	mov    %rax,%rdx
  80393d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803941:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803947:	48 89 d1             	mov    %rdx,%rcx
  80394a:	ba 00 00 00 00       	mov    $0x0,%edx
  80394f:	48 89 c6             	mov    %rax,%rsi
  803952:	bf 00 00 00 00       	mov    $0x0,%edi
  803957:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  80395e:	00 00 00 
  803961:	ff d0                	callq  *%rax
  803963:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803966:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80396a:	79 1b                	jns    803987 <pipe+0x143>
		goto err3;
  80396c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80396d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803971:	48 89 c6             	mov    %rax,%rsi
  803974:	bf 00 00 00 00       	mov    $0x0,%edi
  803979:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803980:	00 00 00 
  803983:	ff d0                	callq  *%rax
  803985:	eb 79                	jmp    803a00 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803987:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803992:	00 00 00 
  803995:	8b 12                	mov    (%rdx),%edx
  803997:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803999:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  8039a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039af:	00 00 00 
  8039b2:	8b 12                	mov    (%rdx),%edx
  8039b4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  8039c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c5:	48 89 c7             	mov    %rax,%rdi
  8039c8:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  8039cf:	00 00 00 
  8039d2:	ff d0                	callq  *%rax
  8039d4:	89 c2                	mov    %eax,%edx
  8039d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039da:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039e0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e8:	48 89 c7             	mov    %rax,%rdi
  8039eb:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  8039f2:	00 00 00 
  8039f5:	ff d0                	callq  *%rax
  8039f7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8039f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fe:	eb 33                	jmp    803a33 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803a00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a04:	48 89 c6             	mov    %rax,%rsi
  803a07:	bf 00 00 00 00       	mov    $0x0,%edi
  803a0c:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803a13:	00 00 00 
  803a16:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a1c:	48 89 c6             	mov    %rax,%rsi
  803a1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803a24:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
err:
	return r;
  803a30:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a33:	48 83 c4 38          	add    $0x38,%rsp
  803a37:	5b                   	pop    %rbx
  803a38:	5d                   	pop    %rbp
  803a39:	c3                   	retq   

0000000000803a3a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a3a:	55                   	push   %rbp
  803a3b:	48 89 e5             	mov    %rsp,%rbp
  803a3e:	53                   	push   %rbx
  803a3f:	48 83 ec 28          	sub    $0x28,%rsp
  803a43:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a47:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a4b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a52:	00 00 00 
  803a55:	48 8b 00             	mov    (%rax),%rax
  803a58:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a5e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a65:	48 89 c7             	mov    %rax,%rdi
  803a68:	48 b8 ad 2f 80 00 00 	movabs $0x802fad,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	89 c3                	mov    %eax,%ebx
  803a76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7a:	48 89 c7             	mov    %rax,%rdi
  803a7d:	48 b8 ad 2f 80 00 00 	movabs $0x802fad,%rax
  803a84:	00 00 00 
  803a87:	ff d0                	callq  *%rax
  803a89:	39 c3                	cmp    %eax,%ebx
  803a8b:	0f 94 c0             	sete   %al
  803a8e:	0f b6 c0             	movzbl %al,%eax
  803a91:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a94:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a9b:	00 00 00 
  803a9e:	48 8b 00             	mov    (%rax),%rax
  803aa1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803aa7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803aaa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aad:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ab0:	75 05                	jne    803ab7 <_pipeisclosed+0x7d>
			return ret;
  803ab2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ab5:	eb 4a                	jmp    803b01 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803ab7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803abd:	74 3d                	je     803afc <_pipeisclosed+0xc2>
  803abf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ac3:	75 37                	jne    803afc <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ac5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803acc:	00 00 00 
  803acf:	48 8b 00             	mov    (%rax),%rax
  803ad2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ad8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803adb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ade:	89 c6                	mov    %eax,%esi
  803ae0:	48 bf 55 49 80 00 00 	movabs $0x804955,%rdi
  803ae7:	00 00 00 
  803aea:	b8 00 00 00 00       	mov    $0x0,%eax
  803aef:	49 b8 41 06 80 00 00 	movabs $0x800641,%r8
  803af6:	00 00 00 
  803af9:	41 ff d0             	callq  *%r8
	}
  803afc:	e9 4a ff ff ff       	jmpq   803a4b <_pipeisclosed+0x11>
}
  803b01:	48 83 c4 28          	add    $0x28,%rsp
  803b05:	5b                   	pop    %rbx
  803b06:	5d                   	pop    %rbp
  803b07:	c3                   	retq   

0000000000803b08 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b08:	55                   	push   %rbp
  803b09:	48 89 e5             	mov    %rsp,%rbp
  803b0c:	48 83 ec 30          	sub    $0x30,%rsp
  803b10:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b13:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b17:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b1a:	48 89 d6             	mov    %rdx,%rsi
  803b1d:	89 c7                	mov    %eax,%edi
  803b1f:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
  803b2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b32:	79 05                	jns    803b39 <pipeisclosed+0x31>
		return r;
  803b34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b37:	eb 31                	jmp    803b6a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b3d:	48 89 c7             	mov    %rax,%rdi
  803b40:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803b47:	00 00 00 
  803b4a:	ff d0                	callq  *%rax
  803b4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b58:	48 89 d6             	mov    %rdx,%rsi
  803b5b:	48 89 c7             	mov    %rax,%rdi
  803b5e:	48 b8 3a 3a 80 00 00 	movabs $0x803a3a,%rax
  803b65:	00 00 00 
  803b68:	ff d0                	callq  *%rax
}
  803b6a:	c9                   	leaveq 
  803b6b:	c3                   	retq   

0000000000803b6c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b6c:	55                   	push   %rbp
  803b6d:	48 89 e5             	mov    %rsp,%rbp
  803b70:	48 83 ec 40          	sub    $0x40,%rsp
  803b74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b78:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b7c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b84:	48 89 c7             	mov    %rax,%rdi
  803b87:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
  803b93:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b9f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ba6:	00 
  803ba7:	e9 92 00 00 00       	jmpq   803c3e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803bac:	eb 41                	jmp    803bef <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bae:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bb3:	74 09                	je     803bbe <devpipe_read+0x52>
				return i;
  803bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb9:	e9 92 00 00 00       	jmpq   803c50 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803bbe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc6:	48 89 d6             	mov    %rdx,%rsi
  803bc9:	48 89 c7             	mov    %rax,%rdi
  803bcc:	48 b8 3a 3a 80 00 00 	movabs $0x803a3a,%rax
  803bd3:	00 00 00 
  803bd6:	ff d0                	callq  *%rax
  803bd8:	85 c0                	test   %eax,%eax
  803bda:	74 07                	je     803be3 <devpipe_read+0x77>
				return 0;
  803bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803be1:	eb 6d                	jmp    803c50 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803be3:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803bea:	00 00 00 
  803bed:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf3:	8b 10                	mov    (%rax),%edx
  803bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf9:	8b 40 04             	mov    0x4(%rax),%eax
  803bfc:	39 c2                	cmp    %eax,%edx
  803bfe:	74 ae                	je     803bae <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c08:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c10:	8b 00                	mov    (%rax),%eax
  803c12:	99                   	cltd   
  803c13:	c1 ea 1b             	shr    $0x1b,%edx
  803c16:	01 d0                	add    %edx,%eax
  803c18:	83 e0 1f             	and    $0x1f,%eax
  803c1b:	29 d0                	sub    %edx,%eax
  803c1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c21:	48 98                	cltq   
  803c23:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c28:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2e:	8b 00                	mov    (%rax),%eax
  803c30:	8d 50 01             	lea    0x1(%rax),%edx
  803c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c37:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803c39:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c42:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c46:	0f 82 60 ff ff ff    	jb     803bac <devpipe_read+0x40>
	}
	return i;
  803c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c50:	c9                   	leaveq 
  803c51:	c3                   	retq   

0000000000803c52 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c52:	55                   	push   %rbp
  803c53:	48 89 e5             	mov    %rsp,%rbp
  803c56:	48 83 ec 40          	sub    $0x40,%rsp
  803c5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c62:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c6a:	48 89 c7             	mov    %rax,%rdi
  803c6d:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803c74:	00 00 00 
  803c77:	ff d0                	callq  *%rax
  803c79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c85:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c8c:	00 
  803c8d:	e9 91 00 00 00       	jmpq   803d23 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c92:	eb 31                	jmp    803cc5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c9c:	48 89 d6             	mov    %rdx,%rsi
  803c9f:	48 89 c7             	mov    %rax,%rdi
  803ca2:	48 b8 3a 3a 80 00 00 	movabs $0x803a3a,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	74 07                	je     803cb9 <devpipe_write+0x67>
				return 0;
  803cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb7:	eb 7c                	jmp    803d35 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cb9:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803cc0:	00 00 00 
  803cc3:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc9:	8b 40 04             	mov    0x4(%rax),%eax
  803ccc:	48 63 d0             	movslq %eax,%rdx
  803ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd3:	8b 00                	mov    (%rax),%eax
  803cd5:	48 98                	cltq   
  803cd7:	48 83 c0 20          	add    $0x20,%rax
  803cdb:	48 39 c2             	cmp    %rax,%rdx
  803cde:	73 b4                	jae    803c94 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce4:	8b 40 04             	mov    0x4(%rax),%eax
  803ce7:	99                   	cltd   
  803ce8:	c1 ea 1b             	shr    $0x1b,%edx
  803ceb:	01 d0                	add    %edx,%eax
  803ced:	83 e0 1f             	and    $0x1f,%eax
  803cf0:	29 d0                	sub    %edx,%eax
  803cf2:	89 c6                	mov    %eax,%esi
  803cf4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cfc:	48 01 d0             	add    %rdx,%rax
  803cff:	0f b6 08             	movzbl (%rax),%ecx
  803d02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d06:	48 63 c6             	movslq %esi,%rax
  803d09:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d11:	8b 40 04             	mov    0x4(%rax),%eax
  803d14:	8d 50 01             	lea    0x1(%rax),%edx
  803d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1b:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803d1e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d27:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d2b:	0f 82 61 ff ff ff    	jb     803c92 <devpipe_write+0x40>
	}

	return i;
  803d31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d35:	c9                   	leaveq 
  803d36:	c3                   	retq   

0000000000803d37 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d37:	55                   	push   %rbp
  803d38:	48 89 e5             	mov    %rsp,%rbp
  803d3b:	48 83 ec 20          	sub    $0x20,%rsp
  803d3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d4b:	48 89 c7             	mov    %rax,%rdi
  803d4e:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803d55:	00 00 00 
  803d58:	ff d0                	callq  *%rax
  803d5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d62:	48 be 68 49 80 00 00 	movabs $0x804968,%rsi
  803d69:	00 00 00 
  803d6c:	48 89 c7             	mov    %rax,%rdi
  803d6f:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d7f:	8b 50 04             	mov    0x4(%rax),%edx
  803d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d86:	8b 00                	mov    (%rax),%eax
  803d88:	29 c2                	sub    %eax,%edx
  803d8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d8e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d98:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d9f:	00 00 00 
	stat->st_dev = &devpipe;
  803da2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da6:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803dad:	00 00 00 
  803db0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dbc:	c9                   	leaveq 
  803dbd:	c3                   	retq   

0000000000803dbe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803dbe:	55                   	push   %rbp
  803dbf:	48 89 e5             	mov    %rsp,%rbp
  803dc2:	48 83 ec 10          	sub    $0x10,%rsp
  803dc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803dca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dce:	48 89 c6             	mov    %rax,%rsi
  803dd1:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd6:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803ddd:	00 00 00 
  803de0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803de2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de6:	48 89 c7             	mov    %rax,%rdi
  803de9:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803df0:	00 00 00 
  803df3:	ff d0                	callq  *%rax
  803df5:	48 89 c6             	mov    %rax,%rsi
  803df8:	bf 00 00 00 00       	mov    $0x0,%edi
  803dfd:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803e04:	00 00 00 
  803e07:	ff d0                	callq  *%rax
}
  803e09:	c9                   	leaveq 
  803e0a:	c3                   	retq   

0000000000803e0b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e0b:	55                   	push   %rbp
  803e0c:	48 89 e5             	mov    %rsp,%rbp
  803e0f:	48 83 ec 20          	sub    $0x20,%rsp
  803e13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e19:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e1c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e20:	be 01 00 00 00       	mov    $0x1,%esi
  803e25:	48 89 c7             	mov    %rax,%rdi
  803e28:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  803e2f:	00 00 00 
  803e32:	ff d0                	callq  *%rax
}
  803e34:	c9                   	leaveq 
  803e35:	c3                   	retq   

0000000000803e36 <getchar>:

int
getchar(void)
{
  803e36:	55                   	push   %rbp
  803e37:	48 89 e5             	mov    %rsp,%rbp
  803e3a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e3e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e42:	ba 01 00 00 00       	mov    $0x1,%edx
  803e47:	48 89 c6             	mov    %rax,%rsi
  803e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4f:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
  803e5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e62:	79 05                	jns    803e69 <getchar+0x33>
		return r;
  803e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e67:	eb 14                	jmp    803e7d <getchar+0x47>
	if (r < 1)
  803e69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e6d:	7f 07                	jg     803e76 <getchar+0x40>
		return -E_EOF;
  803e6f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e74:	eb 07                	jmp    803e7d <getchar+0x47>
	return c;
  803e76:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e7a:	0f b6 c0             	movzbl %al,%eax
}
  803e7d:	c9                   	leaveq 
  803e7e:	c3                   	retq   

0000000000803e7f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e7f:	55                   	push   %rbp
  803e80:	48 89 e5             	mov    %rsp,%rbp
  803e83:	48 83 ec 20          	sub    $0x20,%rsp
  803e87:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e91:	48 89 d6             	mov    %rdx,%rsi
  803e94:	89 c7                	mov    %eax,%edi
  803e96:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803e9d:	00 00 00 
  803ea0:	ff d0                	callq  *%rax
  803ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea9:	79 05                	jns    803eb0 <iscons+0x31>
		return r;
  803eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eae:	eb 1a                	jmp    803eca <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb4:	8b 10                	mov    (%rax),%edx
  803eb6:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ebd:	00 00 00 
  803ec0:	8b 00                	mov    (%rax),%eax
  803ec2:	39 c2                	cmp    %eax,%edx
  803ec4:	0f 94 c0             	sete   %al
  803ec7:	0f b6 c0             	movzbl %al,%eax
}
  803eca:	c9                   	leaveq 
  803ecb:	c3                   	retq   

0000000000803ecc <opencons>:

int
opencons(void)
{
  803ecc:	55                   	push   %rbp
  803ecd:	48 89 e5             	mov    %rsp,%rbp
  803ed0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ed4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ed8:	48 89 c7             	mov    %rax,%rdi
  803edb:	48 b8 db 21 80 00 00 	movabs $0x8021db,%rax
  803ee2:	00 00 00 
  803ee5:	ff d0                	callq  *%rax
  803ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eee:	79 05                	jns    803ef5 <opencons+0x29>
		return r;
  803ef0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef3:	eb 5b                	jmp    803f50 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ef5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef9:	ba 07 04 00 00       	mov    $0x407,%edx
  803efe:	48 89 c6             	mov    %rax,%rsi
  803f01:	bf 00 00 00 00       	mov    $0x0,%edi
  803f06:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  803f0d:	00 00 00 
  803f10:	ff d0                	callq  *%rax
  803f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f19:	79 05                	jns    803f20 <opencons+0x54>
		return r;
  803f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1e:	eb 30                	jmp    803f50 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f24:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f2b:	00 00 00 
  803f2e:	8b 12                	mov    (%rdx),%edx
  803f30:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f36:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f41:	48 89 c7             	mov    %rax,%rdi
  803f44:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
}
  803f50:	c9                   	leaveq 
  803f51:	c3                   	retq   

0000000000803f52 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f52:	55                   	push   %rbp
  803f53:	48 89 e5             	mov    %rsp,%rbp
  803f56:	48 83 ec 30          	sub    $0x30,%rsp
  803f5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f66:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f6b:	75 07                	jne    803f74 <devcons_read+0x22>
		return 0;
  803f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f72:	eb 4b                	jmp    803fbf <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f74:	eb 0c                	jmp    803f82 <devcons_read+0x30>
		sys_yield();
  803f76:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803f82:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  803f89:	00 00 00 
  803f8c:	ff d0                	callq  *%rax
  803f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f95:	74 df                	je     803f76 <devcons_read+0x24>
	if (c < 0)
  803f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9b:	79 05                	jns    803fa2 <devcons_read+0x50>
		return c;
  803f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa0:	eb 1d                	jmp    803fbf <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803fa2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fa6:	75 07                	jne    803faf <devcons_read+0x5d>
		return 0;
  803fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  803fad:	eb 10                	jmp    803fbf <devcons_read+0x6d>
	*(char*)vbuf = c;
  803faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb2:	89 c2                	mov    %eax,%edx
  803fb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb8:	88 10                	mov    %dl,(%rax)
	return 1;
  803fba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803fbf:	c9                   	leaveq 
  803fc0:	c3                   	retq   

0000000000803fc1 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fc1:	55                   	push   %rbp
  803fc2:	48 89 e5             	mov    %rsp,%rbp
  803fc5:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803fcc:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803fd3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fda:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fe1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fe8:	eb 76                	jmp    804060 <devcons_write+0x9f>
		m = n - tot;
  803fea:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ff1:	89 c2                	mov    %eax,%edx
  803ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff6:	29 c2                	sub    %eax,%edx
  803ff8:	89 d0                	mov    %edx,%eax
  803ffa:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803ffd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804000:	83 f8 7f             	cmp    $0x7f,%eax
  804003:	76 07                	jbe    80400c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804005:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80400c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80400f:	48 63 d0             	movslq %eax,%rdx
  804012:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804015:	48 63 c8             	movslq %eax,%rcx
  804018:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80401f:	48 01 c1             	add    %rax,%rcx
  804022:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804029:	48 89 ce             	mov    %rcx,%rsi
  80402c:	48 89 c7             	mov    %rax,%rdi
  80402f:	48 b8 ff 14 80 00 00 	movabs $0x8014ff,%rax
  804036:	00 00 00 
  804039:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80403b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80403e:	48 63 d0             	movslq %eax,%rdx
  804041:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804048:	48 89 d6             	mov    %rdx,%rsi
  80404b:	48 89 c7             	mov    %rax,%rdi
  80404e:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  80405a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80405d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804060:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804063:	48 98                	cltq   
  804065:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80406c:	0f 82 78 ff ff ff    	jb     803fea <devcons_write+0x29>
	}
	return tot;
  804072:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804075:	c9                   	leaveq 
  804076:	c3                   	retq   

0000000000804077 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804077:	55                   	push   %rbp
  804078:	48 89 e5             	mov    %rsp,%rbp
  80407b:	48 83 ec 08          	sub    $0x8,%rsp
  80407f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804088:	c9                   	leaveq 
  804089:	c3                   	retq   

000000000080408a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80408a:	55                   	push   %rbp
  80408b:	48 89 e5             	mov    %rsp,%rbp
  80408e:	48 83 ec 10          	sub    $0x10,%rsp
  804092:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804096:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80409a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409e:	48 be 74 49 80 00 00 	movabs $0x804974,%rsi
  8040a5:	00 00 00 
  8040a8:	48 89 c7             	mov    %rax,%rdi
  8040ab:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  8040b2:	00 00 00 
  8040b5:	ff d0                	callq  *%rax
	return 0;
  8040b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040bc:	c9                   	leaveq 
  8040bd:	c3                   	retq   
