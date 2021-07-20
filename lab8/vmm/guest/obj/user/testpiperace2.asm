
vmm/guest/obj/user/testpiperace2:     formato del fichero elf64-x86-64


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
  80003c:	e8 e2 02 00 00       	callq  800323 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf 80 40 80 00 00 	movabs $0x804080,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 1c 35 80 00 00 	movabs $0x80351c,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba a2 40 80 00 00 	movabs $0x8040a2,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf ab 40 80 00 00 	movabs $0x8040ab,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 a6 03 80 00 00 	movabs $0x8003a6,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf ab 40 80 00 00 	movabs $0x8040ab,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 a6 03 80 00 00 	movabs $0x8003a6,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf c9 40 80 00 00 	movabs $0x8040c9,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
		}
		exit();
  8001bc:	48 b8 83 03 80 00 00 	movabs $0x800383,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 98                	cltq   
  8001d2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001e0:	00 00 00 
  8001e3:	48 01 d0             	add    %rdx,%rax
  8001e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001ea:	eb 4d                	jmp    800239 <umain+0x1f6>
		if (pipeisclosed(p[0]) != 0) {
  8001ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	48 b8 e0 37 80 00 00 	movabs $0x8037e0,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 38                	je     800239 <umain+0x1f6>
			cprintf("\nRACE: pipe appears closed\n");
  800201:	48 bf cd 40 80 00 00 	movabs $0x8040cd,%rdi
  800208:	00 00 00 
  80020b:	b8 00 00 00 00       	mov    $0x0,%eax
  800210:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  800217:	00 00 00 
  80021a:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  80021c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80021f:	89 c7                	mov    %eax,%edi
  800221:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
			exit();
  80022d:	48 b8 83 03 80 00 00 	movabs $0x800383,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800243:	83 f8 02             	cmp    $0x2,%eax
  800246:	74 a4                	je     8001ec <umain+0x1a9>
		}
	cprintf("child done with loop\n");
  800248:	48 bf e9 40 80 00 00 	movabs $0x8040e9,%rdi
  80024f:	00 00 00 
  800252:	b8 00 00 00 00       	mov    $0x0,%eax
  800257:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  80025e:	00 00 00 
  800261:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800263:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 e0 37 80 00 00 	movabs $0x8037e0,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
  800274:	85 c0                	test   %eax,%eax
  800276:	74 2a                	je     8002a2 <umain+0x25f>
		panic("somehow the other end of p[0] got closed!");
  800278:	48 ba 00 41 80 00 00 	movabs $0x804100,%rdx
  80027f:	00 00 00 
  800282:	be 40 00 00 00       	mov    $0x40,%esi
  800287:	48 bf ab 40 80 00 00 	movabs $0x8040ab,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  80029d:	00 00 00 
  8002a0:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002a2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002a5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002a9:	48 89 d6             	mov    %rdx,%rsi
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax
  8002ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c1:	79 30                	jns    8002f3 <umain+0x2b0>
		panic("cannot look up p[0]: %e", r);
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	89 c1                	mov    %eax,%ecx
  8002c8:	48 ba 2a 41 80 00 00 	movabs $0x80412a,%rdx
  8002cf:	00 00 00 
  8002d2:	be 42 00 00 00       	mov    $0x42,%esi
  8002d7:	48 bf ab 40 80 00 00 	movabs $0x8040ab,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b8 a6 03 80 00 00 	movabs $0x8003a6,%r8
  8002ed:	00 00 00 
  8002f0:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002f7:	48 89 c7             	mov    %rax,%rdi
  8002fa:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800306:	48 bf 42 41 80 00 00 	movabs $0x804142,%rdi
  80030d:	00 00 00 
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
  800315:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  80031c:	00 00 00 
  80031f:	ff d2                	callq  *%rdx
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 83 ec 10          	sub    $0x10,%rsp
  80032b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800332:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800339:	00 00 00 
  80033c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800343:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800347:	7e 14                	jle    80035d <libmain+0x3a>
		binaryname = argv[0];
  800349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034d:	48 8b 10             	mov    (%rax),%rdx
  800350:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800357:	00 00 00 
  80035a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80035d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800364:	48 89 d6             	mov    %rdx,%rsi
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800375:	48 b8 83 03 80 00 00 	movabs $0x800383,%rax
  80037c:	00 00 00 
  80037f:	ff d0                	callq  *%rax
}
  800381:	c9                   	leaveq 
  800382:	c3                   	retq   

0000000000800383 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800383:	55                   	push   %rbp
  800384:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800387:	48 b8 31 22 80 00 00 	movabs $0x802231,%rax
  80038e:	00 00 00 
  800391:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800393:	bf 00 00 00 00       	mov    $0x0,%edi
  800398:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
}
  8003a4:	5d                   	pop    %rbp
  8003a5:	c3                   	retq   

00000000008003a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003a6:	55                   	push   %rbp
  8003a7:	48 89 e5             	mov    %rsp,%rbp
  8003aa:	53                   	push   %rbx
  8003ab:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003b2:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003b9:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003bf:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003c6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003cd:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003d4:	84 c0                	test   %al,%al
  8003d6:	74 23                	je     8003fb <_panic+0x55>
  8003d8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003df:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003e3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003e7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003eb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003ef:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003f3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003f7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003fb:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800402:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800409:	00 00 00 
  80040c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800413:	00 00 00 
  800416:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80041a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800421:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800428:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80042f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800436:	00 00 00 
  800439:	48 8b 18             	mov    (%rax),%rbx
  80043c:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 c6                	mov    %eax,%esi
  80044a:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800450:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800457:	41 89 d0             	mov    %edx,%r8d
  80045a:	48 89 c1             	mov    %rax,%rcx
  80045d:	48 89 da             	mov    %rbx,%rdx
  800460:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  800467:	00 00 00 
  80046a:	b8 00 00 00 00       	mov    $0x0,%eax
  80046f:	49 b9 df 05 80 00 00 	movabs $0x8005df,%r9
  800476:	00 00 00 
  800479:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80047c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800483:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80048a:	48 89 d6             	mov    %rdx,%rsi
  80048d:	48 89 c7             	mov    %rax,%rdi
  800490:	48 b8 33 05 80 00 00 	movabs $0x800533,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
	cprintf("\n");
  80049c:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004b7:	cc                   	int3   
  8004b8:	eb fd                	jmp    8004b7 <_panic+0x111>

00000000008004ba <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	48 83 ec 10          	sub    $0x10,%rsp
  8004c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cd:	8b 00                	mov    (%rax),%eax
  8004cf:	8d 48 01             	lea    0x1(%rax),%ecx
  8004d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d6:	89 0a                	mov    %ecx,(%rdx)
  8004d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004db:	89 d1                	mov    %edx,%ecx
  8004dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e1:	48 98                	cltq   
  8004e3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004eb:	8b 00                	mov    (%rax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f8:	8b 00                	mov    (%rax),%eax
  8004fa:	48 98                	cltq   
  8004fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800500:	48 83 c2 08          	add    $0x8,%rdx
  800504:	48 89 c6             	mov    %rax,%rsi
  800507:	48 89 d7             	mov    %rdx,%rdi
  80050a:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  800511:	00 00 00 
  800514:	ff d0                	callq  *%rax
        b->idx = 0;
  800516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800524:	8b 40 04             	mov    0x4(%rax),%eax
  800527:	8d 50 01             	lea    0x1(%rax),%edx
  80052a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800531:	c9                   	leaveq 
  800532:	c3                   	retq   

0000000000800533 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800533:	55                   	push   %rbp
  800534:	48 89 e5             	mov    %rsp,%rbp
  800537:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80053e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800545:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80054c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800553:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80055a:	48 8b 0a             	mov    (%rdx),%rcx
  80055d:	48 89 08             	mov    %rcx,(%rax)
  800560:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800564:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800568:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80056c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800570:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800577:	00 00 00 
    b.cnt = 0;
  80057a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800581:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800584:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80058b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800592:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800599:	48 89 c6             	mov    %rax,%rsi
  80059c:	48 bf ba 04 80 00 00 	movabs $0x8004ba,%rdi
  8005a3:	00 00 00 
  8005a6:	48 b8 7e 09 80 00 00 	movabs $0x80097e,%rax
  8005ad:	00 00 00 
  8005b0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005b2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005b8:	48 98                	cltq   
  8005ba:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005c1:	48 83 c2 08          	add    $0x8,%rdx
  8005c5:	48 89 c6             	mov    %rax,%rsi
  8005c8:	48 89 d7             	mov    %rdx,%rdi
  8005cb:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8005d2:	00 00 00 
  8005d5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005dd:	c9                   	leaveq 
  8005de:	c3                   	retq   

00000000008005df <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005df:	55                   	push   %rbp
  8005e0:	48 89 e5             	mov    %rsp,%rbp
  8005e3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005ea:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005f1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005f8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005ff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800606:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80060d:	84 c0                	test   %al,%al
  80060f:	74 20                	je     800631 <cprintf+0x52>
  800611:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800615:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800619:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80061d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800621:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800625:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800629:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80062d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800631:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800638:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80063f:	00 00 00 
  800642:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800649:	00 00 00 
  80064c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800650:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800657:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80065e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800665:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80066c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800673:	48 8b 0a             	mov    (%rdx),%rcx
  800676:	48 89 08             	mov    %rcx,(%rax)
  800679:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80067d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800681:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800685:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800689:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800690:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800697:	48 89 d6             	mov    %rdx,%rsi
  80069a:	48 89 c7             	mov    %rax,%rdi
  80069d:	48 b8 33 05 80 00 00 	movabs $0x800533,%rax
  8006a4:	00 00 00 
  8006a7:	ff d0                	callq  *%rax
  8006a9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006af:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006b5:	c9                   	leaveq 
  8006b6:	c3                   	retq   

00000000008006b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b7:	55                   	push   %rbp
  8006b8:	48 89 e5             	mov    %rsp,%rbp
  8006bb:	48 83 ec 30          	sub    $0x30,%rsp
  8006bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006cb:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006ce:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006d2:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006d9:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006dd:	77 42                	ja     800721 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006df:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006e2:	8d 78 ff             	lea    -0x1(%rax),%edi
  8006e5:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f1:	48 f7 f6             	div    %rsi
  8006f4:	49 89 c2             	mov    %rax,%r10
  8006f7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8006fa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006fd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800705:	41 89 c9             	mov    %ecx,%r9d
  800708:	41 89 f8             	mov    %edi,%r8d
  80070b:	89 d1                	mov    %edx,%ecx
  80070d:	4c 89 d2             	mov    %r10,%rdx
  800710:	48 89 c7             	mov    %rax,%rdi
  800713:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
  80071f:	eb 1e                	jmp    80073f <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800721:	eb 12                	jmp    800735 <printnum+0x7e>
			putch(padc, putdat);
  800723:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800727:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80072a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80072e:	48 89 ce             	mov    %rcx,%rsi
  800731:	89 d7                	mov    %edx,%edi
  800733:	ff d0                	callq  *%rax
		while (--width > 0)
  800735:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800739:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80073d:	7f e4                	jg     800723 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80073f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	48 f7 f1             	div    %rcx
  80074e:	48 b8 b0 43 80 00 00 	movabs $0x8043b0,%rax
  800755:	00 00 00 
  800758:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80075c:	0f be d0             	movsbl %al,%edx
  80075f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800767:	48 89 ce             	mov    %rcx,%rsi
  80076a:	89 d7                	mov    %edx,%edi
  80076c:	ff d0                	callq  *%rax
}
  80076e:	c9                   	leaveq 
  80076f:	c3                   	retq   

0000000000800770 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800770:	55                   	push   %rbp
  800771:	48 89 e5             	mov    %rsp,%rbp
  800774:	48 83 ec 20          	sub    $0x20,%rsp
  800778:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80077c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80077f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800783:	7e 4f                	jle    8007d4 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	8b 00                	mov    (%rax),%eax
  80078b:	83 f8 30             	cmp    $0x30,%eax
  80078e:	73 24                	jae    8007b4 <getuint+0x44>
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	8b 00                	mov    (%rax),%eax
  80079e:	89 c0                	mov    %eax,%eax
  8007a0:	48 01 d0             	add    %rdx,%rax
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	8b 12                	mov    (%rdx),%edx
  8007a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b0:	89 0a                	mov    %ecx,(%rdx)
  8007b2:	eb 14                	jmp    8007c8 <getuint+0x58>
  8007b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007bc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c8:	48 8b 00             	mov    (%rax),%rax
  8007cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007cf:	e9 9d 00 00 00       	jmpq   800871 <getuint+0x101>
	else if (lflag)
  8007d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007d8:	74 4c                	je     800826 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	8b 00                	mov    (%rax),%eax
  8007e0:	83 f8 30             	cmp    $0x30,%eax
  8007e3:	73 24                	jae    800809 <getuint+0x99>
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	89 c0                	mov    %eax,%eax
  8007f5:	48 01 d0             	add    %rdx,%rax
  8007f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fc:	8b 12                	mov    (%rdx),%edx
  8007fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800805:	89 0a                	mov    %ecx,(%rdx)
  800807:	eb 14                	jmp    80081d <getuint+0xad>
  800809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800811:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800819:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081d:	48 8b 00             	mov    (%rax),%rax
  800820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800824:	eb 4b                	jmp    800871 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	83 f8 30             	cmp    $0x30,%eax
  80082f:	73 24                	jae    800855 <getuint+0xe5>
  800831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800835:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083d:	8b 00                	mov    (%rax),%eax
  80083f:	89 c0                	mov    %eax,%eax
  800841:	48 01 d0             	add    %rdx,%rax
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	8b 12                	mov    (%rdx),%edx
  80084a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800851:	89 0a                	mov    %ecx,(%rdx)
  800853:	eb 14                	jmp    800869 <getuint+0xf9>
  800855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800859:	48 8b 40 08          	mov    0x8(%rax),%rax
  80085d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800861:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800865:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800869:	8b 00                	mov    (%rax),%eax
  80086b:	89 c0                	mov    %eax,%eax
  80086d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800871:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800875:	c9                   	leaveq 
  800876:	c3                   	retq   

0000000000800877 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800877:	55                   	push   %rbp
  800878:	48 89 e5             	mov    %rsp,%rbp
  80087b:	48 83 ec 20          	sub    $0x20,%rsp
  80087f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800883:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800886:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80088a:	7e 4f                	jle    8008db <getint+0x64>
		x=va_arg(*ap, long long);
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	83 f8 30             	cmp    $0x30,%eax
  800895:	73 24                	jae    8008bb <getint+0x44>
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ae:	8b 12                	mov    (%rdx),%edx
  8008b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b7:	89 0a                	mov    %ecx,(%rdx)
  8008b9:	eb 14                	jmp    8008cf <getint+0x58>
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008c3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cf:	48 8b 00             	mov    (%rax),%rax
  8008d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008d6:	e9 9d 00 00 00       	jmpq   800978 <getint+0x101>
	else if (lflag)
  8008db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008df:	74 4c                	je     80092d <getint+0xb6>
		x=va_arg(*ap, long);
  8008e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e5:	8b 00                	mov    (%rax),%eax
  8008e7:	83 f8 30             	cmp    $0x30,%eax
  8008ea:	73 24                	jae    800910 <getint+0x99>
  8008ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	89 c0                	mov    %eax,%eax
  8008fc:	48 01 d0             	add    %rdx,%rax
  8008ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800903:	8b 12                	mov    (%rdx),%edx
  800905:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800908:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090c:	89 0a                	mov    %ecx,(%rdx)
  80090e:	eb 14                	jmp    800924 <getint+0xad>
  800910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800914:	48 8b 40 08          	mov    0x8(%rax),%rax
  800918:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80091c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800920:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800924:	48 8b 00             	mov    (%rax),%rax
  800927:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092b:	eb 4b                	jmp    800978 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80092d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800931:	8b 00                	mov    (%rax),%eax
  800933:	83 f8 30             	cmp    $0x30,%eax
  800936:	73 24                	jae    80095c <getint+0xe5>
  800938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800944:	8b 00                	mov    (%rax),%eax
  800946:	89 c0                	mov    %eax,%eax
  800948:	48 01 d0             	add    %rdx,%rax
  80094b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094f:	8b 12                	mov    (%rdx),%edx
  800951:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	89 0a                	mov    %ecx,(%rdx)
  80095a:	eb 14                	jmp    800970 <getint+0xf9>
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 8b 40 08          	mov    0x8(%rax),%rax
  800964:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800970:	8b 00                	mov    (%rax),%eax
  800972:	48 98                	cltq   
  800974:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800978:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80097c:	c9                   	leaveq 
  80097d:	c3                   	retq   

000000000080097e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097e:	55                   	push   %rbp
  80097f:	48 89 e5             	mov    %rsp,%rbp
  800982:	41 54                	push   %r12
  800984:	53                   	push   %rbx
  800985:	48 83 ec 60          	sub    $0x60,%rsp
  800989:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80098d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800991:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800995:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800999:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80099d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009a1:	48 8b 0a             	mov    (%rdx),%rcx
  8009a4:	48 89 08             	mov    %rcx,(%rax)
  8009a7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009ab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009af:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009b3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b7:	eb 17                	jmp    8009d0 <vprintfmt+0x52>
			if (ch == '\0')
  8009b9:	85 db                	test   %ebx,%ebx
  8009bb:	0f 84 c5 04 00 00    	je     800e86 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8009c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c9:	48 89 d6             	mov    %rdx,%rsi
  8009cc:	89 df                	mov    %ebx,%edi
  8009ce:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009dc:	0f b6 00             	movzbl (%rax),%eax
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	83 fb 25             	cmp    $0x25,%ebx
  8009e5:	75 d2                	jne    8009b9 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009eb:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a00:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a13:	0f b6 00             	movzbl (%rax),%eax
  800a16:	0f b6 d8             	movzbl %al,%ebx
  800a19:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a1c:	83 f8 55             	cmp    $0x55,%eax
  800a1f:	0f 87 2e 04 00 00    	ja     800e53 <vprintfmt+0x4d5>
  800a25:	89 c0                	mov    %eax,%eax
  800a27:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a2e:	00 
  800a2f:	48 b8 d8 43 80 00 00 	movabs $0x8043d8,%rax
  800a36:	00 00 00 
  800a39:	48 01 d0             	add    %rdx,%rax
  800a3c:	48 8b 00             	mov    (%rax),%rax
  800a3f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a41:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a45:	eb c0                	jmp    800a07 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a47:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a4b:	eb ba                	jmp    800a07 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a54:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a57:	89 d0                	mov    %edx,%eax
  800a59:	c1 e0 02             	shl    $0x2,%eax
  800a5c:	01 d0                	add    %edx,%eax
  800a5e:	01 c0                	add    %eax,%eax
  800a60:	01 d8                	add    %ebx,%eax
  800a62:	83 e8 30             	sub    $0x30,%eax
  800a65:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a68:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6c:	0f b6 00             	movzbl (%rax),%eax
  800a6f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a72:	83 fb 2f             	cmp    $0x2f,%ebx
  800a75:	7e 0c                	jle    800a83 <vprintfmt+0x105>
  800a77:	83 fb 39             	cmp    $0x39,%ebx
  800a7a:	7f 07                	jg     800a83 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800a7c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800a81:	eb d1                	jmp    800a54 <vprintfmt+0xd6>
			goto process_precision;
  800a83:	eb 50                	jmp    800ad5 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800a85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a88:	83 f8 30             	cmp    $0x30,%eax
  800a8b:	73 17                	jae    800aa4 <vprintfmt+0x126>
  800a8d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a94:	89 d2                	mov    %edx,%edx
  800a96:	48 01 d0             	add    %rdx,%rax
  800a99:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9c:	83 c2 08             	add    $0x8,%edx
  800a9f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa2:	eb 0c                	jmp    800ab0 <vprintfmt+0x132>
  800aa4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800aa8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800aac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab0:	8b 00                	mov    (%rax),%eax
  800ab2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ab5:	eb 1e                	jmp    800ad5 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800ab7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abb:	79 07                	jns    800ac4 <vprintfmt+0x146>
				width = 0;
  800abd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ac4:	e9 3e ff ff ff       	jmpq   800a07 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ac9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ad0:	e9 32 ff ff ff       	jmpq   800a07 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ad5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad9:	79 0d                	jns    800ae8 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800adb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ade:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ae1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ae8:	e9 1a ff ff ff       	jmpq   800a07 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aed:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800af1:	e9 11 ff ff ff       	jmpq   800a07 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800af6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af9:	83 f8 30             	cmp    $0x30,%eax
  800afc:	73 17                	jae    800b15 <vprintfmt+0x197>
  800afe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b05:	89 d2                	mov    %edx,%edx
  800b07:	48 01 d0             	add    %rdx,%rax
  800b0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0d:	83 c2 08             	add    $0x8,%edx
  800b10:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b13:	eb 0c                	jmp    800b21 <vprintfmt+0x1a3>
  800b15:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b19:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b1d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b21:	8b 10                	mov    (%rax),%edx
  800b23:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2b:	48 89 ce             	mov    %rcx,%rsi
  800b2e:	89 d7                	mov    %edx,%edi
  800b30:	ff d0                	callq  *%rax
			break;
  800b32:	e9 4a 03 00 00       	jmpq   800e81 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3a:	83 f8 30             	cmp    $0x30,%eax
  800b3d:	73 17                	jae    800b56 <vprintfmt+0x1d8>
  800b3f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b46:	89 d2                	mov    %edx,%edx
  800b48:	48 01 d0             	add    %rdx,%rax
  800b4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4e:	83 c2 08             	add    $0x8,%edx
  800b51:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b54:	eb 0c                	jmp    800b62 <vprintfmt+0x1e4>
  800b56:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b5a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b5e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b62:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b64:	85 db                	test   %ebx,%ebx
  800b66:	79 02                	jns    800b6a <vprintfmt+0x1ec>
				err = -err;
  800b68:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b6a:	83 fb 15             	cmp    $0x15,%ebx
  800b6d:	7f 16                	jg     800b85 <vprintfmt+0x207>
  800b6f:	48 b8 00 43 80 00 00 	movabs $0x804300,%rax
  800b76:	00 00 00 
  800b79:	48 63 d3             	movslq %ebx,%rdx
  800b7c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b80:	4d 85 e4             	test   %r12,%r12
  800b83:	75 2e                	jne    800bb3 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800b85:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	89 d9                	mov    %ebx,%ecx
  800b8f:	48 ba c1 43 80 00 00 	movabs $0x8043c1,%rdx
  800b96:	00 00 00 
  800b99:	48 89 c7             	mov    %rax,%rdi
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba1:	49 b8 8f 0e 80 00 00 	movabs $0x800e8f,%r8
  800ba8:	00 00 00 
  800bab:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bae:	e9 ce 02 00 00       	jmpq   800e81 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800bb3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbb:	4c 89 e1             	mov    %r12,%rcx
  800bbe:	48 ba ca 43 80 00 00 	movabs $0x8043ca,%rdx
  800bc5:	00 00 00 
  800bc8:	48 89 c7             	mov    %rax,%rdi
  800bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd0:	49 b8 8f 0e 80 00 00 	movabs $0x800e8f,%r8
  800bd7:	00 00 00 
  800bda:	41 ff d0             	callq  *%r8
			break;
  800bdd:	e9 9f 02 00 00       	jmpq   800e81 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800be2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be5:	83 f8 30             	cmp    $0x30,%eax
  800be8:	73 17                	jae    800c01 <vprintfmt+0x283>
  800bea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf1:	89 d2                	mov    %edx,%edx
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf9:	83 c2 08             	add    $0x8,%edx
  800bfc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bff:	eb 0c                	jmp    800c0d <vprintfmt+0x28f>
  800c01:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c05:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0d:	4c 8b 20             	mov    (%rax),%r12
  800c10:	4d 85 e4             	test   %r12,%r12
  800c13:	75 0a                	jne    800c1f <vprintfmt+0x2a1>
				p = "(null)";
  800c15:	49 bc cd 43 80 00 00 	movabs $0x8043cd,%r12
  800c1c:	00 00 00 
			if (width > 0 && padc != '-')
  800c1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c23:	7e 3f                	jle    800c64 <vprintfmt+0x2e6>
  800c25:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c29:	74 39                	je     800c64 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c2e:	48 98                	cltq   
  800c30:	48 89 c6             	mov    %rax,%rsi
  800c33:	4c 89 e7             	mov    %r12,%rdi
  800c36:	48 b8 3b 11 80 00 00 	movabs $0x80113b,%rax
  800c3d:	00 00 00 
  800c40:	ff d0                	callq  *%rax
  800c42:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c45:	eb 17                	jmp    800c5e <vprintfmt+0x2e0>
					putch(padc, putdat);
  800c47:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c4b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c53:	48 89 ce             	mov    %rcx,%rsi
  800c56:	89 d7                	mov    %edx,%edi
  800c58:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c62:	7f e3                	jg     800c47 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c64:	eb 37                	jmp    800c9d <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800c66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c6a:	74 1e                	je     800c8a <vprintfmt+0x30c>
  800c6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c6f:	7e 05                	jle    800c76 <vprintfmt+0x2f8>
  800c71:	83 fb 7e             	cmp    $0x7e,%ebx
  800c74:	7e 14                	jle    800c8a <vprintfmt+0x30c>
					putch('?', putdat);
  800c76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7e:	48 89 d6             	mov    %rdx,%rsi
  800c81:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c86:	ff d0                	callq  *%rax
  800c88:	eb 0f                	jmp    800c99 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800c8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c92:	48 89 d6             	mov    %rdx,%rsi
  800c95:	89 df                	mov    %ebx,%edi
  800c97:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c99:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c9d:	4c 89 e0             	mov    %r12,%rax
  800ca0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ca4:	0f b6 00             	movzbl (%rax),%eax
  800ca7:	0f be d8             	movsbl %al,%ebx
  800caa:	85 db                	test   %ebx,%ebx
  800cac:	74 10                	je     800cbe <vprintfmt+0x340>
  800cae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cb2:	78 b2                	js     800c66 <vprintfmt+0x2e8>
  800cb4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cbc:	79 a8                	jns    800c66 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800cbe:	eb 16                	jmp    800cd6 <vprintfmt+0x358>
				putch(' ', putdat);
  800cc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc8:	48 89 d6             	mov    %rdx,%rsi
  800ccb:	bf 20 00 00 00       	mov    $0x20,%edi
  800cd0:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800cd2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cda:	7f e4                	jg     800cc0 <vprintfmt+0x342>
			break;
  800cdc:	e9 a0 01 00 00       	jmpq   800e81 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ce1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce5:	be 03 00 00 00       	mov    $0x3,%esi
  800cea:	48 89 c7             	mov    %rax,%rdi
  800ced:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800cf4:	00 00 00 
  800cf7:	ff d0                	callq  *%rax
  800cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d01:	48 85 c0             	test   %rax,%rax
  800d04:	79 1d                	jns    800d23 <vprintfmt+0x3a5>
				putch('-', putdat);
  800d06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0e:	48 89 d6             	mov    %rdx,%rsi
  800d11:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d16:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1c:	48 f7 d8             	neg    %rax
  800d1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d23:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2a:	e9 e5 00 00 00       	jmpq   800e14 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d33:	be 03 00 00 00       	mov    $0x3,%esi
  800d38:	48 89 c7             	mov    %rax,%rdi
  800d3b:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800d42:	00 00 00 
  800d45:	ff d0                	callq  *%rax
  800d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d4b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d52:	e9 bd 00 00 00       	jmpq   800e14 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5f:	48 89 d6             	mov    %rdx,%rsi
  800d62:	bf 58 00 00 00       	mov    $0x58,%edi
  800d67:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d71:	48 89 d6             	mov    %rdx,%rsi
  800d74:	bf 58 00 00 00       	mov    $0x58,%edi
  800d79:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d83:	48 89 d6             	mov    %rdx,%rsi
  800d86:	bf 58 00 00 00       	mov    $0x58,%edi
  800d8b:	ff d0                	callq  *%rax
			break;
  800d8d:	e9 ef 00 00 00       	jmpq   800e81 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800d92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9a:	48 89 d6             	mov    %rdx,%rsi
  800d9d:	bf 30 00 00 00       	mov    $0x30,%edi
  800da2:	ff d0                	callq  *%rax
			putch('x', putdat);
  800da4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dac:	48 89 d6             	mov    %rdx,%rsi
  800daf:	bf 78 00 00 00       	mov    $0x78,%edi
  800db4:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800db6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db9:	83 f8 30             	cmp    $0x30,%eax
  800dbc:	73 17                	jae    800dd5 <vprintfmt+0x457>
  800dbe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dc2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc5:	89 d2                	mov    %edx,%edx
  800dc7:	48 01 d0             	add    %rdx,%rax
  800dca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dcd:	83 c2 08             	add    $0x8,%edx
  800dd0:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800dd3:	eb 0c                	jmp    800de1 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800dd5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800dd9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ddd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800de1:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800de4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800de8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800def:	eb 23                	jmp    800e14 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800df1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df5:	be 03 00 00 00       	mov    $0x3,%esi
  800dfa:	48 89 c7             	mov    %rax,%rdi
  800dfd:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800e04:	00 00 00 
  800e07:	ff d0                	callq  *%rax
  800e09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e0d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e14:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e19:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e1c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2b:	45 89 c1             	mov    %r8d,%r9d
  800e2e:	41 89 f8             	mov    %edi,%r8d
  800e31:	48 89 c7             	mov    %rax,%rdi
  800e34:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  800e3b:	00 00 00 
  800e3e:	ff d0                	callq  *%rax
			break;
  800e40:	eb 3f                	jmp    800e81 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4a:	48 89 d6             	mov    %rdx,%rsi
  800e4d:	89 df                	mov    %ebx,%edi
  800e4f:	ff d0                	callq  *%rax
			break;
  800e51:	eb 2e                	jmp    800e81 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5b:	48 89 d6             	mov    %rdx,%rsi
  800e5e:	bf 25 00 00 00       	mov    $0x25,%edi
  800e63:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e65:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e6a:	eb 05                	jmp    800e71 <vprintfmt+0x4f3>
  800e6c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e71:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e75:	48 83 e8 01          	sub    $0x1,%rax
  800e79:	0f b6 00             	movzbl (%rax),%eax
  800e7c:	3c 25                	cmp    $0x25,%al
  800e7e:	75 ec                	jne    800e6c <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800e80:	90                   	nop
		}
	}
  800e81:	e9 31 fb ff ff       	jmpq   8009b7 <vprintfmt+0x39>
	va_end(aq);
}
  800e86:	48 83 c4 60          	add    $0x60,%rsp
  800e8a:	5b                   	pop    %rbx
  800e8b:	41 5c                	pop    %r12
  800e8d:	5d                   	pop    %rbp
  800e8e:	c3                   	retq   

0000000000800e8f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8f:	55                   	push   %rbp
  800e90:	48 89 e5             	mov    %rsp,%rbp
  800e93:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e9a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ea1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ea8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eaf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eb6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ebd:	84 c0                	test   %al,%al
  800ebf:	74 20                	je     800ee1 <printfmt+0x52>
  800ec1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ec9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ecd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ed1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ed9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800edd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ee1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ee8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eef:	00 00 00 
  800ef2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ef9:	00 00 00 
  800efc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f00:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f07:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f0e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f15:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f1c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f23:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f2a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f31:	48 89 c7             	mov    %rax,%rdi
  800f34:	48 b8 7e 09 80 00 00 	movabs $0x80097e,%rax
  800f3b:	00 00 00 
  800f3e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f40:	c9                   	leaveq 
  800f41:	c3                   	retq   

0000000000800f42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f42:	55                   	push   %rbp
  800f43:	48 89 e5             	mov    %rsp,%rbp
  800f46:	48 83 ec 10          	sub    $0x10,%rsp
  800f4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f55:	8b 40 10             	mov    0x10(%rax),%eax
  800f58:	8d 50 01             	lea    0x1(%rax),%edx
  800f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f66:	48 8b 10             	mov    (%rax),%rdx
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f71:	48 39 c2             	cmp    %rax,%rdx
  800f74:	73 17                	jae    800f8d <sprintputch+0x4b>
		*b->buf++ = ch;
  800f76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7a:	48 8b 00             	mov    (%rax),%rax
  800f7d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f85:	48 89 0a             	mov    %rcx,(%rdx)
  800f88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f8b:	88 10                	mov    %dl,(%rax)
}
  800f8d:	c9                   	leaveq 
  800f8e:	c3                   	retq   

0000000000800f8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f8f:	55                   	push   %rbp
  800f90:	48 89 e5             	mov    %rsp,%rbp
  800f93:	48 83 ec 50          	sub    $0x50,%rsp
  800f97:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f9b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f9e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fa2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fa6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800faa:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fae:	48 8b 0a             	mov    (%rdx),%rcx
  800fb1:	48 89 08             	mov    %rcx,(%rax)
  800fb4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fbc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fcc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fcf:	48 98                	cltq   
  800fd1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd9:	48 01 d0             	add    %rdx,%rax
  800fdc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fe0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fe7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fec:	74 06                	je     800ff4 <vsnprintf+0x65>
  800fee:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ff2:	7f 07                	jg     800ffb <vsnprintf+0x6c>
		return -E_INVAL;
  800ff4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff9:	eb 2f                	jmp    80102a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ffb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fff:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801003:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801007:	48 89 c6             	mov    %rax,%rsi
  80100a:	48 bf 42 0f 80 00 00 	movabs $0x800f42,%rdi
  801011:	00 00 00 
  801014:	48 b8 7e 09 80 00 00 	movabs $0x80097e,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801020:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801024:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801027:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80102a:	c9                   	leaveq 
  80102b:	c3                   	retq   

000000000080102c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801037:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80103e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801044:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801052:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801059:	84 c0                	test   %al,%al
  80105b:	74 20                	je     80107d <snprintf+0x51>
  80105d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801061:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801065:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801069:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80106d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801071:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801075:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801079:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80107d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801084:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80108b:	00 00 00 
  80108e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801095:	00 00 00 
  801098:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80109c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010b1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010bf:	48 8b 0a             	mov    (%rdx),%rcx
  8010c2:	48 89 08             	mov    %rcx,(%rax)
  8010c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010dc:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010e3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010e9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010f0:	48 89 c7             	mov    %rax,%rdi
  8010f3:	48 b8 8f 0f 80 00 00 	movabs $0x800f8f,%rax
  8010fa:	00 00 00 
  8010fd:	ff d0                	callq  *%rax
  8010ff:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801105:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80110b:	c9                   	leaveq 
  80110c:	c3                   	retq   

000000000080110d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80110d:	55                   	push   %rbp
  80110e:	48 89 e5             	mov    %rsp,%rbp
  801111:	48 83 ec 18          	sub    $0x18,%rsp
  801115:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801120:	eb 09                	jmp    80112b <strlen+0x1e>
		n++;
  801122:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801126:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80112b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112f:	0f b6 00             	movzbl (%rax),%eax
  801132:	84 c0                	test   %al,%al
  801134:	75 ec                	jne    801122 <strlen+0x15>
	return n;
  801136:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801139:	c9                   	leaveq 
  80113a:	c3                   	retq   

000000000080113b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 20          	sub    $0x20,%rsp
  801143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801147:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801152:	eb 0e                	jmp    801162 <strnlen+0x27>
		n++;
  801154:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801158:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80115d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801162:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801167:	74 0b                	je     801174 <strnlen+0x39>
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116d:	0f b6 00             	movzbl (%rax),%eax
  801170:	84 c0                	test   %al,%al
  801172:	75 e0                	jne    801154 <strnlen+0x19>
	return n;
  801174:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801177:	c9                   	leaveq 
  801178:	c3                   	retq   

0000000000801179 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801179:	55                   	push   %rbp
  80117a:	48 89 e5             	mov    %rsp,%rbp
  80117d:	48 83 ec 20          	sub    $0x20,%rsp
  801181:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801185:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801191:	90                   	nop
  801192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801196:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011aa:	0f b6 12             	movzbl (%rdx),%edx
  8011ad:	88 10                	mov    %dl,(%rax)
  8011af:	0f b6 00             	movzbl (%rax),%eax
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 dc                	jne    801192 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ba:	c9                   	leaveq 
  8011bb:	c3                   	retq   

00000000008011bc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011bc:	55                   	push   %rbp
  8011bd:	48 89 e5             	mov    %rsp,%rbp
  8011c0:	48 83 ec 20          	sub    $0x20,%rsp
  8011c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d0:	48 89 c7             	mov    %rax,%rdi
  8011d3:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  8011da:	00 00 00 
  8011dd:	ff d0                	callq  *%rax
  8011df:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e5:	48 63 d0             	movslq %eax,%rdx
  8011e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ec:	48 01 c2             	add    %rax,%rdx
  8011ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f3:	48 89 c6             	mov    %rax,%rsi
  8011f6:	48 89 d7             	mov    %rdx,%rdi
  8011f9:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  801200:	00 00 00 
  801203:	ff d0                	callq  *%rax
	return dst;
  801205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 28          	sub    $0x28,%rsp
  801213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801217:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80121f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801223:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801227:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80122e:	00 
  80122f:	eb 2a                	jmp    80125b <strncpy+0x50>
		*dst++ = *src;
  801231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801235:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801239:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801241:	0f b6 12             	movzbl (%rdx),%edx
  801244:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801246:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124a:	0f b6 00             	movzbl (%rax),%eax
  80124d:	84 c0                	test   %al,%al
  80124f:	74 05                	je     801256 <strncpy+0x4b>
			src++;
  801251:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801263:	72 cc                	jb     801231 <strncpy+0x26>
	}
	return ret;
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801269:	c9                   	leaveq 
  80126a:	c3                   	retq   

000000000080126b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80126b:	55                   	push   %rbp
  80126c:	48 89 e5             	mov    %rsp,%rbp
  80126f:	48 83 ec 28          	sub    $0x28,%rsp
  801273:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801277:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801287:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80128c:	74 3d                	je     8012cb <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80128e:	eb 1d                	jmp    8012ad <strlcpy+0x42>
			*dst++ = *src++;
  801290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801294:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801298:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012a4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012a8:	0f b6 12             	movzbl (%rdx),%edx
  8012ab:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8012ad:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b7:	74 0b                	je     8012c4 <strlcpy+0x59>
  8012b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	84 c0                	test   %al,%al
  8012c2:	75 cc                	jne    801290 <strlcpy+0x25>
		*dst = '\0';
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	48 29 c2             	sub    %rax,%rdx
  8012d6:	48 89 d0             	mov    %rdx,%rax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 10          	sub    $0x10,%rsp
  8012e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012eb:	eb 0a                	jmp    8012f7 <strcmp+0x1c>
		p++, q++;
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	74 12                	je     801314 <strcmp+0x39>
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	0f b6 10             	movzbl (%rax),%edx
  801309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	38 c2                	cmp    %al,%dl
  801312:	74 d9                	je     8012ed <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	0f b6 d0             	movzbl %al,%edx
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	0f b6 c0             	movzbl %al,%eax
  801328:	29 c2                	sub    %eax,%edx
  80132a:	89 d0                	mov    %edx,%eax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 18          	sub    $0x18,%rsp
  801336:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80133e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801342:	eb 0f                	jmp    801353 <strncmp+0x25>
		n--, p++, q++;
  801344:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801353:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801358:	74 1d                	je     801377 <strncmp+0x49>
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	84 c0                	test   %al,%al
  801363:	74 12                	je     801377 <strncmp+0x49>
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 10             	movzbl (%rax),%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 cd                	je     801344 <strncmp+0x16>
	if (n == 0)
  801377:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80137c:	75 07                	jne    801385 <strncmp+0x57>
		return 0;
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
  801383:	eb 18                	jmp    80139d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	0f b6 c0             	movzbl %al,%eax
  801399:	29 c2                	sub    %eax,%edx
  80139b:	89 d0                	mov    %edx,%eax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 10          	sub    $0x10,%rsp
  8013a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b0:	eb 17                	jmp    8013c9 <strchr+0x2a>
		if (*s == c)
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013bc:	75 06                	jne    8013c4 <strchr+0x25>
			return (char *) s;
  8013be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c2:	eb 15                	jmp    8013d9 <strchr+0x3a>
	for (; *s; s++)
  8013c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cd:	0f b6 00             	movzbl (%rax),%eax
  8013d0:	84 c0                	test   %al,%al
  8013d2:	75 de                	jne    8013b2 <strchr+0x13>
	return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d9:	c9                   	leaveq 
  8013da:	c3                   	retq   

00000000008013db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013db:	55                   	push   %rbp
  8013dc:	48 89 e5             	mov    %rsp,%rbp
  8013df:	48 83 ec 10          	sub    $0x10,%rsp
  8013e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e7:	89 f0                	mov    %esi,%eax
  8013e9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ec:	eb 13                	jmp    801401 <strfind+0x26>
		if (*s == c)
  8013ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f8:	75 02                	jne    8013fc <strfind+0x21>
			break;
  8013fa:	eb 10                	jmp    80140c <strfind+0x31>
	for (; *s; s++)
  8013fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	84 c0                	test   %al,%al
  80140a:	75 e2                	jne    8013ee <strfind+0x13>
	return (char *) s;
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 18          	sub    $0x18,%rsp
  80141a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801425:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142a:	75 06                	jne    801432 <memset+0x20>
		return v;
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	eb 69                	jmp    80149b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 48                	jne    801486 <memset+0x74>
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	83 e0 03             	and    $0x3,%eax
  801445:	48 85 c0             	test   %rax,%rax
  801448:	75 3c                	jne    801486 <memset+0x74>
		c &= 0xFF;
  80144a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801451:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801454:	c1 e0 18             	shl    $0x18,%eax
  801457:	89 c2                	mov    %eax,%edx
  801459:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145c:	c1 e0 10             	shl    $0x10,%eax
  80145f:	09 c2                	or     %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801464:	c1 e0 08             	shl    $0x8,%eax
  801467:	09 d0                	or     %edx,%eax
  801469:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80146c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801470:	48 c1 e8 02          	shr    $0x2,%rax
  801474:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801477:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80147e:	48 89 d7             	mov    %rdx,%rdi
  801481:	fc                   	cld    
  801482:	f3 ab                	rep stos %eax,%es:(%rdi)
  801484:	eb 11                	jmp    801497 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801486:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80148d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801491:	48 89 d7             	mov    %rdx,%rdi
  801494:	fc                   	cld    
  801495:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 28          	sub    $0x28,%rsp
  8014a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014c9:	0f 83 88 00 00 00    	jae    801557 <memmove+0xba>
  8014cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	48 01 d0             	add    %rdx,%rax
  8014da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014de:	76 77                	jbe    801557 <memmove+0xba>
		s += n;
  8014e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	83 e0 03             	and    $0x3,%eax
  8014f7:	48 85 c0             	test   %rax,%rax
  8014fa:	75 3b                	jne    801537 <memmove+0x9a>
  8014fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801500:	83 e0 03             	and    $0x3,%eax
  801503:	48 85 c0             	test   %rax,%rax
  801506:	75 2f                	jne    801537 <memmove+0x9a>
  801508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150c:	83 e0 03             	and    $0x3,%eax
  80150f:	48 85 c0             	test   %rax,%rax
  801512:	75 23                	jne    801537 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	48 83 e8 04          	sub    $0x4,%rax
  80151c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801520:	48 83 ea 04          	sub    $0x4,%rdx
  801524:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801528:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80152c:	48 89 c7             	mov    %rax,%rdi
  80152f:	48 89 d6             	mov    %rdx,%rsi
  801532:	fd                   	std    
  801533:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801535:	eb 1d                	jmp    801554 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801543:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 89 d7             	mov    %rdx,%rdi
  80154e:	48 89 c1             	mov    %rax,%rcx
  801551:	fd                   	std    
  801552:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801554:	fc                   	cld    
  801555:	eb 57                	jmp    8015ae <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	83 e0 03             	and    $0x3,%eax
  80155e:	48 85 c0             	test   %rax,%rax
  801561:	75 36                	jne    801599 <memmove+0xfc>
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801567:	83 e0 03             	and    $0x3,%eax
  80156a:	48 85 c0             	test   %rax,%rax
  80156d:	75 2a                	jne    801599 <memmove+0xfc>
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	83 e0 03             	and    $0x3,%eax
  801576:	48 85 c0             	test   %rax,%rax
  801579:	75 1e                	jne    801599 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 c1 e8 02          	shr    $0x2,%rax
  801583:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158e:	48 89 c7             	mov    %rax,%rdi
  801591:	48 89 d6             	mov    %rdx,%rsi
  801594:	fc                   	cld    
  801595:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801597:	eb 15                	jmp    8015ae <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a5:	48 89 c7             	mov    %rax,%rdi
  8015a8:	48 89 d6             	mov    %rdx,%rsi
  8015ab:	fc                   	cld    
  8015ac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b2:	c9                   	leaveq 
  8015b3:	c3                   	retq   

00000000008015b4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015b4:	55                   	push   %rbp
  8015b5:	48 89 e5             	mov    %rsp,%rbp
  8015b8:	48 83 ec 18          	sub    $0x18,%rsp
  8015bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d4:	48 89 ce             	mov    %rcx,%rsi
  8015d7:	48 89 c7             	mov    %rax,%rdi
  8015da:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	callq  *%rax
}
  8015e6:	c9                   	leaveq 
  8015e7:	c3                   	retq   

00000000008015e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 83 ec 28          	sub    $0x28,%rsp
  8015f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801600:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801604:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801608:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80160c:	eb 36                	jmp    801644 <memcmp+0x5c>
		if (*s1 != *s2)
  80160e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801612:	0f b6 10             	movzbl (%rax),%edx
  801615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	38 c2                	cmp    %al,%dl
  80161e:	74 1a                	je     80163a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	0f b6 d0             	movzbl %al,%edx
  80162a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	0f b6 c0             	movzbl %al,%eax
  801634:	29 c2                	sub    %eax,%edx
  801636:	89 d0                	mov    %edx,%eax
  801638:	eb 20                	jmp    80165a <memcmp+0x72>
		s1++, s2++;
  80163a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80164c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801650:	48 85 c0             	test   %rax,%rax
  801653:	75 b9                	jne    80160e <memcmp+0x26>
	}

	return 0;
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165a:	c9                   	leaveq 
  80165b:	c3                   	retq   

000000000080165c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80165c:	55                   	push   %rbp
  80165d:	48 89 e5             	mov    %rsp,%rbp
  801660:	48 83 ec 28          	sub    $0x28,%rsp
  801664:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801668:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80166b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80166f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	48 01 d0             	add    %rdx,%rax
  80167a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80167e:	eb 15                	jmp    801695 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80168a:	38 d0                	cmp    %dl,%al
  80168c:	75 02                	jne    801690 <memfind+0x34>
			break;
  80168e:	eb 0f                	jmp    80169f <memfind+0x43>
	for (; s < ends; s++)
  801690:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801699:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80169d:	72 e1                	jb     801680 <memfind+0x24>
	return (void *) s;
  80169f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016a3:	c9                   	leaveq 
  8016a4:	c3                   	retq   

00000000008016a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a5:	55                   	push   %rbp
  8016a6:	48 89 e5             	mov    %rsp,%rbp
  8016a9:	48 83 ec 38          	sub    $0x38,%rsp
  8016ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016bf:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016c6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c7:	eb 05                	jmp    8016ce <strtol+0x29>
		s++;
  8016c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8016ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	3c 20                	cmp    $0x20,%al
  8016d7:	74 f0                	je     8016c9 <strtol+0x24>
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	3c 09                	cmp    $0x9,%al
  8016e2:	74 e5                	je     8016c9 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 2b                	cmp    $0x2b,%al
  8016ed:	75 07                	jne    8016f6 <strtol+0x51>
		s++;
  8016ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f4:	eb 17                	jmp    80170d <strtol+0x68>
	else if (*s == '-')
  8016f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fa:	0f b6 00             	movzbl (%rax),%eax
  8016fd:	3c 2d                	cmp    $0x2d,%al
  8016ff:	75 0c                	jne    80170d <strtol+0x68>
		s++, neg = 1;
  801701:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801706:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80170d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801711:	74 06                	je     801719 <strtol+0x74>
  801713:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801717:	75 28                	jne    801741 <strtol+0x9c>
  801719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171d:	0f b6 00             	movzbl (%rax),%eax
  801720:	3c 30                	cmp    $0x30,%al
  801722:	75 1d                	jne    801741 <strtol+0x9c>
  801724:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801728:	48 83 c0 01          	add    $0x1,%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	3c 78                	cmp    $0x78,%al
  801731:	75 0e                	jne    801741 <strtol+0x9c>
		s += 2, base = 16;
  801733:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801738:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80173f:	eb 2c                	jmp    80176d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801741:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801745:	75 19                	jne    801760 <strtol+0xbb>
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	0f b6 00             	movzbl (%rax),%eax
  80174e:	3c 30                	cmp    $0x30,%al
  801750:	75 0e                	jne    801760 <strtol+0xbb>
		s++, base = 8;
  801752:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801757:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80175e:	eb 0d                	jmp    80176d <strtol+0xc8>
	else if (base == 0)
  801760:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801764:	75 07                	jne    80176d <strtol+0xc8>
		base = 10;
  801766:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	3c 2f                	cmp    $0x2f,%al
  801776:	7e 1d                	jle    801795 <strtol+0xf0>
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	3c 39                	cmp    $0x39,%al
  801781:	7f 12                	jg     801795 <strtol+0xf0>
			dig = *s - '0';
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	0f b6 00             	movzbl (%rax),%eax
  80178a:	0f be c0             	movsbl %al,%eax
  80178d:	83 e8 30             	sub    $0x30,%eax
  801790:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801793:	eb 4e                	jmp    8017e3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 60                	cmp    $0x60,%al
  80179e:	7e 1d                	jle    8017bd <strtol+0x118>
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	0f b6 00             	movzbl (%rax),%eax
  8017a7:	3c 7a                	cmp    $0x7a,%al
  8017a9:	7f 12                	jg     8017bd <strtol+0x118>
			dig = *s - 'a' + 10;
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	0f be c0             	movsbl %al,%eax
  8017b5:	83 e8 57             	sub    $0x57,%eax
  8017b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017bb:	eb 26                	jmp    8017e3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c1:	0f b6 00             	movzbl (%rax),%eax
  8017c4:	3c 40                	cmp    $0x40,%al
  8017c6:	7e 48                	jle    801810 <strtol+0x16b>
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	0f b6 00             	movzbl (%rax),%eax
  8017cf:	3c 5a                	cmp    $0x5a,%al
  8017d1:	7f 3d                	jg     801810 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	0f b6 00             	movzbl (%rax),%eax
  8017da:	0f be c0             	movsbl %al,%eax
  8017dd:	83 e8 37             	sub    $0x37,%eax
  8017e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017e9:	7c 02                	jl     8017ed <strtol+0x148>
			break;
  8017eb:	eb 23                	jmp    801810 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f5:	48 98                	cltq   
  8017f7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017fc:	48 89 c2             	mov    %rax,%rdx
  8017ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801802:	48 98                	cltq   
  801804:	48 01 d0             	add    %rdx,%rax
  801807:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80180b:	e9 5d ff ff ff       	jmpq   80176d <strtol+0xc8>

	if (endptr)
  801810:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801815:	74 0b                	je     801822 <strtol+0x17d>
		*endptr = (char *) s;
  801817:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80181f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801822:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801826:	74 09                	je     801831 <strtol+0x18c>
  801828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182c:	48 f7 d8             	neg    %rax
  80182f:	eb 04                	jmp    801835 <strtol+0x190>
  801831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801835:	c9                   	leaveq 
  801836:	c3                   	retq   

0000000000801837 <strstr>:

char * strstr(const char *in, const char *str)
{
  801837:	55                   	push   %rbp
  801838:	48 89 e5             	mov    %rsp,%rbp
  80183b:	48 83 ec 30          	sub    $0x30,%rsp
  80183f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801843:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801847:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80184f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801853:	0f b6 00             	movzbl (%rax),%eax
  801856:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801859:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80185d:	75 06                	jne    801865 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80185f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801863:	eb 6b                	jmp    8018d0 <strstr+0x99>

	len = strlen(str);
  801865:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
  801878:	48 98                	cltq   
  80187a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801886:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801890:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801894:	75 07                	jne    80189d <strstr+0x66>
				return (char *) 0;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
  80189b:	eb 33                	jmp    8018d0 <strstr+0x99>
		} while (sc != c);
  80189d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018a1:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a4:	75 d8                	jne    80187e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018aa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b2:	48 89 ce             	mov    %rcx,%rsi
  8018b5:	48 89 c7             	mov    %rax,%rdi
  8018b8:	48 b8 2e 13 80 00 00 	movabs $0x80132e,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	callq  *%rax
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 b6                	jne    80187e <strstr+0x47>

	return (char *) (in - 1);
  8018c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cc:	48 83 e8 01          	sub    $0x1,%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	53                   	push   %rbx
  8018d7:	48 83 ec 48          	sub    $0x48,%rsp
  8018db:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018de:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018e1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018e9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018ed:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018f8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018fc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801900:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801904:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801908:	4c 89 c3             	mov    %r8,%rbx
  80190b:	cd 30                	int    $0x30
  80190d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801911:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801915:	74 3e                	je     801955 <syscall+0x83>
  801917:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80191c:	7e 37                	jle    801955 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80191e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801922:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801925:	49 89 d0             	mov    %rdx,%r8
  801928:	89 c1                	mov    %eax,%ecx
  80192a:	48 ba 88 46 80 00 00 	movabs $0x804688,%rdx
  801931:	00 00 00 
  801934:	be 23 00 00 00       	mov    $0x23,%esi
  801939:	48 bf a5 46 80 00 00 	movabs $0x8046a5,%rdi
  801940:	00 00 00 
  801943:	b8 00 00 00 00       	mov    $0x0,%eax
  801948:	49 b9 a6 03 80 00 00 	movabs $0x8003a6,%r9
  80194f:	00 00 00 
  801952:	41 ff d1             	callq  *%r9

	return ret;
  801955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801959:	48 83 c4 48          	add    $0x48,%rsp
  80195d:	5b                   	pop    %rbx
  80195e:	5d                   	pop    %rbp
  80195f:	c3                   	retq   

0000000000801960 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 10          	sub    $0x10,%rsp
  801968:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801970:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801974:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801978:	48 83 ec 08          	sub    $0x8,%rsp
  80197c:	6a 00                	pushq  $0x0
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	48 89 d1             	mov    %rdx,%rcx
  80198d:	48 89 c2             	mov    %rax,%rdx
  801990:	be 00 00 00 00       	mov    $0x0,%esi
  801995:	bf 00 00 00 00       	mov    $0x0,%edi
  80199a:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	callq  *%rax
  8019a6:	48 83 c4 10          	add    $0x10,%rsp
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019b0:	48 83 ec 08          	sub    $0x8,%rsp
  8019b4:	6a 00                	pushq  $0x0
  8019b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cc:	be 00 00 00 00       	mov    $0x0,%esi
  8019d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8019d6:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	callq  *%rax
  8019e2:	48 83 c4 10          	add    $0x10,%rsp
}
  8019e6:	c9                   	leaveq 
  8019e7:	c3                   	retq   

00000000008019e8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	48 83 ec 10          	sub    $0x10,%rsp
  8019f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f6:	48 98                	cltq   
  8019f8:	48 83 ec 08          	sub    $0x8,%rsp
  8019fc:	6a 00                	pushq  $0x0
  8019fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 01 00 00 00       	mov    $0x1,%esi
  801a17:	bf 03 00 00 00       	mov    $0x3,%edi
  801a1c:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	48 83 c4 10          	add    $0x10,%rsp
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a32:	48 83 ec 08          	sub    $0x8,%rsp
  801a36:	6a 00                	pushq  $0x0
  801a38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a49:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4e:	be 00 00 00 00       	mov    $0x0,%esi
  801a53:	bf 02 00 00 00       	mov    $0x2,%edi
  801a58:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	callq  *%rax
  801a64:	48 83 c4 10          	add    $0x10,%rsp
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <sys_yield>:

void
sys_yield(void)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a6e:	48 83 ec 08          	sub    $0x8,%rsp
  801a72:	6a 00                	pushq  $0x0
  801a74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a85:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8a:	be 00 00 00 00       	mov    $0x0,%esi
  801a8f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a94:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801a9b:	00 00 00 
  801a9e:	ff d0                	callq  *%rax
  801aa0:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa4:	c9                   	leaveq 
  801aa5:	c3                   	retq   

0000000000801aa6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aa6:	55                   	push   %rbp
  801aa7:	48 89 e5             	mov    %rsp,%rbp
  801aaa:	48 83 ec 10          	sub    $0x10,%rsp
  801aae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ab8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abb:	48 63 c8             	movslq %eax,%rcx
  801abe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac5:	48 98                	cltq   
  801ac7:	48 83 ec 08          	sub    $0x8,%rsp
  801acb:	6a 00                	pushq  $0x0
  801acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad3:	49 89 c8             	mov    %rcx,%r8
  801ad6:	48 89 d1             	mov    %rdx,%rcx
  801ad9:	48 89 c2             	mov    %rax,%rdx
  801adc:	be 01 00 00 00       	mov    $0x1,%esi
  801ae1:	bf 04 00 00 00       	mov    $0x4,%edi
  801ae6:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801aed:	00 00 00 
  801af0:	ff d0                	callq  *%rax
  801af2:	48 83 c4 10          	add    $0x10,%rsp
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 20          	sub    $0x20,%rsp
  801b00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b07:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b0a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b0e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b12:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b15:	48 63 c8             	movslq %eax,%rcx
  801b18:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1f:	48 63 f0             	movslq %eax,%rsi
  801b22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b29:	48 98                	cltq   
  801b2b:	48 83 ec 08          	sub    $0x8,%rsp
  801b2f:	51                   	push   %rcx
  801b30:	49 89 f9             	mov    %rdi,%r9
  801b33:	49 89 f0             	mov    %rsi,%r8
  801b36:	48 89 d1             	mov    %rdx,%rcx
  801b39:	48 89 c2             	mov    %rax,%rdx
  801b3c:	be 01 00 00 00       	mov    $0x1,%esi
  801b41:	bf 05 00 00 00       	mov    $0x5,%edi
  801b46:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
  801b52:	48 83 c4 10          	add    $0x10,%rsp
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 10          	sub    $0x10,%rsp
  801b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6e:	48 98                	cltq   
  801b70:	48 83 ec 08          	sub    $0x8,%rsp
  801b74:	6a 00                	pushq  $0x0
  801b76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b82:	48 89 d1             	mov    %rdx,%rcx
  801b85:	48 89 c2             	mov    %rax,%rdx
  801b88:	be 01 00 00 00       	mov    $0x1,%esi
  801b8d:	bf 06 00 00 00       	mov    $0x6,%edi
  801b92:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	callq  *%rax
  801b9e:	48 83 c4 10          	add    $0x10,%rsp
}
  801ba2:	c9                   	leaveq 
  801ba3:	c3                   	retq   

0000000000801ba4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ba4:	55                   	push   %rbp
  801ba5:	48 89 e5             	mov    %rsp,%rbp
  801ba8:	48 83 ec 10          	sub    $0x10,%rsp
  801bac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801baf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb5:	48 63 d0             	movslq %eax,%rdx
  801bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbb:	48 98                	cltq   
  801bbd:	48 83 ec 08          	sub    $0x8,%rsp
  801bc1:	6a 00                	pushq  $0x0
  801bc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcf:	48 89 d1             	mov    %rdx,%rcx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 01 00 00 00       	mov    $0x1,%esi
  801bda:	bf 08 00 00 00       	mov    $0x8,%edi
  801bdf:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
  801beb:	48 83 c4 10          	add    $0x10,%rsp
}
  801bef:	c9                   	leaveq 
  801bf0:	c3                   	retq   

0000000000801bf1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bf1:	55                   	push   %rbp
  801bf2:	48 89 e5             	mov    %rsp,%rbp
  801bf5:	48 83 ec 10          	sub    $0x10,%rsp
  801bf9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c07:	48 98                	cltq   
  801c09:	48 83 ec 08          	sub    $0x8,%rsp
  801c0d:	6a 00                	pushq  $0x0
  801c0f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c15:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1b:	48 89 d1             	mov    %rdx,%rcx
  801c1e:	48 89 c2             	mov    %rax,%rdx
  801c21:	be 01 00 00 00       	mov    $0x1,%esi
  801c26:	bf 09 00 00 00       	mov    $0x9,%edi
  801c2b:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801c32:	00 00 00 
  801c35:	ff d0                	callq  *%rax
  801c37:	48 83 c4 10          	add    $0x10,%rsp
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
  801c45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c53:	48 98                	cltq   
  801c55:	48 83 ec 08          	sub    $0x8,%rsp
  801c59:	6a 00                	pushq  $0x0
  801c5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c67:	48 89 d1             	mov    %rdx,%rcx
  801c6a:	48 89 c2             	mov    %rax,%rdx
  801c6d:	be 01 00 00 00       	mov    $0x1,%esi
  801c72:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c77:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
  801c83:	48 83 c4 10          	add    $0x10,%rsp
}
  801c87:	c9                   	leaveq 
  801c88:	c3                   	retq   

0000000000801c89 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c89:	55                   	push   %rbp
  801c8a:	48 89 e5             	mov    %rsp,%rbp
  801c8d:	48 83 ec 20          	sub    $0x20,%rsp
  801c91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c98:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c9c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca2:	48 63 f0             	movslq %eax,%rsi
  801ca5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cac:	48 98                	cltq   
  801cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb2:	48 83 ec 08          	sub    $0x8,%rsp
  801cb6:	6a 00                	pushq  $0x0
  801cb8:	49 89 f1             	mov    %rsi,%r9
  801cbb:	49 89 c8             	mov    %rcx,%r8
  801cbe:	48 89 d1             	mov    %rdx,%rcx
  801cc1:	48 89 c2             	mov    %rax,%rdx
  801cc4:	be 00 00 00 00       	mov    $0x0,%esi
  801cc9:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cce:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801cd5:	00 00 00 
  801cd8:	ff d0                	callq  *%rax
  801cda:	48 83 c4 10          	add    $0x10,%rsp
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 10          	sub    $0x10,%rsp
  801ce8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf0:	48 83 ec 08          	sub    $0x8,%rsp
  801cf4:	6a 00                	pushq  $0x0
  801cf6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d07:	48 89 c2             	mov    %rax,%rdx
  801d0a:	be 01 00 00 00       	mov    $0x1,%esi
  801d0f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d14:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801d1b:	00 00 00 
  801d1e:	ff d0                	callq  *%rax
  801d20:	48 83 c4 10          	add    $0x10,%rsp
}
  801d24:	c9                   	leaveq 
  801d25:	c3                   	retq   

0000000000801d26 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d2a:	48 83 ec 08          	sub    $0x8,%rsp
  801d2e:	6a 00                	pushq  $0x0
  801d30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d41:	ba 00 00 00 00       	mov    $0x0,%edx
  801d46:	be 00 00 00 00       	mov    $0x0,%esi
  801d4b:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d50:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	callq  *%rax
  801d5c:	48 83 c4 10          	add    $0x10,%rsp
}
  801d60:	c9                   	leaveq 
  801d61:	c3                   	retq   

0000000000801d62 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d62:	55                   	push   %rbp
  801d63:	48 89 e5             	mov    %rsp,%rbp
  801d66:	48 83 ec 20          	sub    $0x20,%rsp
  801d6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d71:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d74:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d78:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d7c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d7f:	48 63 c8             	movslq %eax,%rcx
  801d82:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d89:	48 63 f0             	movslq %eax,%rsi
  801d8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d93:	48 98                	cltq   
  801d95:	48 83 ec 08          	sub    $0x8,%rsp
  801d99:	51                   	push   %rcx
  801d9a:	49 89 f9             	mov    %rdi,%r9
  801d9d:	49 89 f0             	mov    %rsi,%r8
  801da0:	48 89 d1             	mov    %rdx,%rcx
  801da3:	48 89 c2             	mov    %rax,%rdx
  801da6:	be 00 00 00 00       	mov    $0x0,%esi
  801dab:	bf 0f 00 00 00       	mov    $0xf,%edi
  801db0:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
  801dbc:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 10          	sub    $0x10,%rsp
  801dca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dda:	48 83 ec 08          	sub    $0x8,%rsp
  801dde:	6a 00                	pushq  $0x0
  801de0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dec:	48 89 d1             	mov    %rdx,%rcx
  801def:	48 89 c2             	mov    %rax,%rdx
  801df2:	be 00 00 00 00       	mov    $0x0,%esi
  801df7:	bf 10 00 00 00       	mov    $0x10,%edi
  801dfc:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	callq  *%rax
  801e08:	48 83 c4 10          	add    $0x10,%rsp
}
  801e0c:	c9                   	leaveq 
  801e0d:	c3                   	retq   

0000000000801e0e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e0e:	55                   	push   %rbp
  801e0f:	48 89 e5             	mov    %rsp,%rbp
  801e12:	48 83 ec 20          	sub    $0x20,%rsp
  801e16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1e:	48 8b 00             	mov    (%rax),%rax
  801e21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e29:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801e30:	48 ba b3 46 80 00 00 	movabs $0x8046b3,%rdx
  801e37:	00 00 00 
  801e3a:	be 26 00 00 00       	mov    $0x26,%esi
  801e3f:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  801e46:	00 00 00 
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  801e55:	00 00 00 
  801e58:	ff d1                	callq  *%rcx

0000000000801e5a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
  801e5e:	48 83 ec 10          	sub    $0x10,%rsp
  801e62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e65:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801e68:	48 ba d6 46 80 00 00 	movabs $0x8046d6,%rdx
  801e6f:	00 00 00 
  801e72:	be 3a 00 00 00       	mov    $0x3a,%esi
  801e77:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  801e7e:	00 00 00 
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  801e8d:	00 00 00 
  801e90:	ff d1                	callq  *%rcx

0000000000801e92 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e92:	55                   	push   %rbp
  801e93:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801e96:	48 ba ee 46 80 00 00 	movabs $0x8046ee,%rdx
  801e9d:	00 00 00 
  801ea0:	be 52 00 00 00       	mov    $0x52,%esi
  801ea5:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  801eac:	00 00 00 
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  801ebb:	00 00 00 
  801ebe:	ff d1                	callq  *%rcx

0000000000801ec0 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801ec0:	55                   	push   %rbp
  801ec1:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801ec4:	48 ba 03 47 80 00 00 	movabs $0x804703,%rdx
  801ecb:	00 00 00 
  801ece:	be 59 00 00 00       	mov    $0x59,%esi
  801ed3:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  801eda:	00 00 00 
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee2:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  801ee9:	00 00 00 
  801eec:	ff d1                	callq  *%rcx

0000000000801eee <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801eee:	55                   	push   %rbp
  801eef:	48 89 e5             	mov    %rsp,%rbp
  801ef2:	48 83 ec 08          	sub    $0x8,%rsp
  801ef6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801efa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801efe:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f05:	ff ff ff 
  801f08:	48 01 d0             	add    %rdx,%rax
  801f0b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f0f:	c9                   	leaveq 
  801f10:	c3                   	retq   

0000000000801f11 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f11:	55                   	push   %rbp
  801f12:	48 89 e5             	mov    %rsp,%rbp
  801f15:	48 83 ec 08          	sub    $0x8,%rsp
  801f19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f21:	48 89 c7             	mov    %rax,%rdi
  801f24:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
  801f30:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f36:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f3a:	c9                   	leaveq 
  801f3b:	c3                   	retq   

0000000000801f3c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f3c:	55                   	push   %rbp
  801f3d:	48 89 e5             	mov    %rsp,%rbp
  801f40:	48 83 ec 18          	sub    $0x18,%rsp
  801f44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4f:	eb 6b                	jmp    801fbc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f54:	48 98                	cltq   
  801f56:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f5c:	48 c1 e0 0c          	shl    $0xc,%rax
  801f60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f68:	48 c1 e8 15          	shr    $0x15,%rax
  801f6c:	48 89 c2             	mov    %rax,%rdx
  801f6f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f76:	01 00 00 
  801f79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7d:	83 e0 01             	and    $0x1,%eax
  801f80:	48 85 c0             	test   %rax,%rax
  801f83:	74 21                	je     801fa6 <fd_alloc+0x6a>
  801f85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f89:	48 c1 e8 0c          	shr    $0xc,%rax
  801f8d:	48 89 c2             	mov    %rax,%rdx
  801f90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f97:	01 00 00 
  801f9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9e:	83 e0 01             	and    $0x1,%eax
  801fa1:	48 85 c0             	test   %rax,%rax
  801fa4:	75 12                	jne    801fb8 <fd_alloc+0x7c>
			*fd_store = fd;
  801fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801faa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fae:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	eb 1a                	jmp    801fd2 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801fb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fbc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fc0:	7e 8f                	jle    801f51 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fcd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fd2:	c9                   	leaveq 
  801fd3:	c3                   	retq   

0000000000801fd4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fd4:	55                   	push   %rbp
  801fd5:	48 89 e5             	mov    %rsp,%rbp
  801fd8:	48 83 ec 20          	sub    $0x20,%rsp
  801fdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fe3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fe7:	78 06                	js     801fef <fd_lookup+0x1b>
  801fe9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fed:	7e 07                	jle    801ff6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ff4:	eb 6c                	jmp    802062 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ff6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff9:	48 98                	cltq   
  801ffb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802001:	48 c1 e0 0c          	shl    $0xc,%rax
  802005:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200d:	48 c1 e8 15          	shr    $0x15,%rax
  802011:	48 89 c2             	mov    %rax,%rdx
  802014:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80201b:	01 00 00 
  80201e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802022:	83 e0 01             	and    $0x1,%eax
  802025:	48 85 c0             	test   %rax,%rax
  802028:	74 21                	je     80204b <fd_lookup+0x77>
  80202a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202e:	48 c1 e8 0c          	shr    $0xc,%rax
  802032:	48 89 c2             	mov    %rax,%rdx
  802035:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80203c:	01 00 00 
  80203f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802043:	83 e0 01             	and    $0x1,%eax
  802046:	48 85 c0             	test   %rax,%rax
  802049:	75 07                	jne    802052 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80204b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802050:	eb 10                	jmp    802062 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802056:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80205a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802062:	c9                   	leaveq 
  802063:	c3                   	retq   

0000000000802064 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802064:	55                   	push   %rbp
  802065:	48 89 e5             	mov    %rsp,%rbp
  802068:	48 83 ec 30          	sub    $0x30,%rsp
  80206c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802070:	89 f0                	mov    %esi,%eax
  802072:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802079:	48 89 c7             	mov    %rax,%rdi
  80207c:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  802083:	00 00 00 
  802086:	ff d0                	callq  *%rax
  802088:	89 c2                	mov    %eax,%edx
  80208a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80208e:	48 89 c6             	mov    %rax,%rsi
  802091:	89 d7                	mov    %edx,%edi
  802093:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
  80209f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a6:	78 0a                	js     8020b2 <fd_close+0x4e>
	    || fd != fd2)
  8020a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ac:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020b0:	74 12                	je     8020c4 <fd_close+0x60>
		return (must_exist ? r : 0);
  8020b2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020b6:	74 05                	je     8020bd <fd_close+0x59>
  8020b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bb:	eb 70                	jmp    80212d <fd_close+0xc9>
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	eb 69                	jmp    80212d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c8:	8b 00                	mov    (%rax),%eax
  8020ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020ce:	48 89 d6             	mov    %rdx,%rsi
  8020d1:	89 c7                	mov    %eax,%edi
  8020d3:	48 b8 2f 21 80 00 00 	movabs $0x80212f,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
  8020df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e6:	78 2a                	js     802112 <fd_close+0xae>
		if (dev->dev_close)
  8020e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ec:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020f0:	48 85 c0             	test   %rax,%rax
  8020f3:	74 16                	je     80210b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8020f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802101:	48 89 d7             	mov    %rdx,%rdi
  802104:	ff d0                	callq  *%rax
  802106:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802109:	eb 07                	jmp    802112 <fd_close+0xae>
		else
			r = 0;
  80210b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802116:	48 89 c6             	mov    %rax,%rsi
  802119:	bf 00 00 00 00       	mov    $0x0,%edi
  80211e:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  802125:	00 00 00 
  802128:	ff d0                	callq  *%rax
	return r;
  80212a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80212d:	c9                   	leaveq 
  80212e:	c3                   	retq   

000000000080212f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80212f:	55                   	push   %rbp
  802130:	48 89 e5             	mov    %rsp,%rbp
  802133:	48 83 ec 20          	sub    $0x20,%rsp
  802137:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80213a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80213e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802145:	eb 41                	jmp    802188 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802147:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80214e:	00 00 00 
  802151:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802154:	48 63 d2             	movslq %edx,%rdx
  802157:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215b:	8b 00                	mov    (%rax),%eax
  80215d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802160:	75 22                	jne    802184 <dev_lookup+0x55>
			*dev = devtab[i];
  802162:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802169:	00 00 00 
  80216c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80216f:	48 63 d2             	movslq %edx,%rdx
  802172:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
  802182:	eb 60                	jmp    8021e4 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802184:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802188:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80218f:	00 00 00 
  802192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802195:	48 63 d2             	movslq %edx,%rdx
  802198:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219c:	48 85 c0             	test   %rax,%rax
  80219f:	75 a6                	jne    802147 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021a8:	00 00 00 
  8021ab:	48 8b 00             	mov    (%rax),%rax
  8021ae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021b7:	89 c6                	mov    %eax,%esi
  8021b9:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  8021c0:	00 00 00 
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	48 b9 df 05 80 00 00 	movabs $0x8005df,%rcx
  8021cf:	00 00 00 
  8021d2:	ff d1                	callq  *%rcx
	*dev = 0;
  8021d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <close>:

int
close(int fdnum)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 20          	sub    $0x20,%rsp
  8021ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f8:	48 89 d6             	mov    %rdx,%rsi
  8021fb:	89 c7                	mov    %eax,%edi
  8021fd:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802204:	00 00 00 
  802207:	ff d0                	callq  *%rax
  802209:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802210:	79 05                	jns    802217 <close+0x31>
		return r;
  802212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802215:	eb 18                	jmp    80222f <close+0x49>
	else
		return fd_close(fd, 1);
  802217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80221b:	be 01 00 00 00       	mov    $0x1,%esi
  802220:	48 89 c7             	mov    %rax,%rdi
  802223:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  80222a:	00 00 00 
  80222d:	ff d0                	callq  *%rax
}
  80222f:	c9                   	leaveq 
  802230:	c3                   	retq   

0000000000802231 <close_all>:

void
close_all(void)
{
  802231:	55                   	push   %rbp
  802232:	48 89 e5             	mov    %rsp,%rbp
  802235:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802239:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802240:	eb 15                	jmp    802257 <close_all+0x26>
		close(i);
  802242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802245:	89 c7                	mov    %eax,%edi
  802247:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  80224e:	00 00 00 
  802251:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802253:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802257:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80225b:	7e e5                	jle    802242 <close_all+0x11>
}
  80225d:	c9                   	leaveq 
  80225e:	c3                   	retq   

000000000080225f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80225f:	55                   	push   %rbp
  802260:	48 89 e5             	mov    %rsp,%rbp
  802263:	48 83 ec 40          	sub    $0x40,%rsp
  802267:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80226a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80226d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802271:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802274:	48 89 d6             	mov    %rdx,%rsi
  802277:	89 c7                	mov    %eax,%edi
  802279:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
  802285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228c:	79 08                	jns    802296 <dup+0x37>
		return r;
  80228e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802291:	e9 70 01 00 00       	jmpq   802406 <dup+0x1a7>
	close(newfdnum);
  802296:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802299:	89 c7                	mov    %eax,%edi
  80229b:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022aa:	48 98                	cltq   
  8022ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8022b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022be:	48 89 c7             	mov    %rax,%rdi
  8022c1:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  8022c8:	00 00 00 
  8022cb:	ff d0                	callq  *%rax
  8022cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d5:	48 89 c7             	mov    %rax,%rdi
  8022d8:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax
  8022e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ec:	48 c1 e8 15          	shr    $0x15,%rax
  8022f0:	48 89 c2             	mov    %rax,%rdx
  8022f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022fa:	01 00 00 
  8022fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802301:	83 e0 01             	and    $0x1,%eax
  802304:	48 85 c0             	test   %rax,%rax
  802307:	74 73                	je     80237c <dup+0x11d>
  802309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230d:	48 c1 e8 0c          	shr    $0xc,%rax
  802311:	48 89 c2             	mov    %rax,%rdx
  802314:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80231b:	01 00 00 
  80231e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802322:	83 e0 01             	and    $0x1,%eax
  802325:	48 85 c0             	test   %rax,%rax
  802328:	74 52                	je     80237c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80232a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232e:	48 c1 e8 0c          	shr    $0xc,%rax
  802332:	48 89 c2             	mov    %rax,%rdx
  802335:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80233c:	01 00 00 
  80233f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802343:	25 07 0e 00 00       	and    $0xe07,%eax
  802348:	89 c1                	mov    %eax,%ecx
  80234a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80234e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802352:	41 89 c8             	mov    %ecx,%r8d
  802355:	48 89 d1             	mov    %rdx,%rcx
  802358:	ba 00 00 00 00       	mov    $0x0,%edx
  80235d:	48 89 c6             	mov    %rax,%rsi
  802360:	bf 00 00 00 00       	mov    $0x0,%edi
  802365:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80236c:	00 00 00 
  80236f:	ff d0                	callq  *%rax
  802371:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802374:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802378:	79 02                	jns    80237c <dup+0x11d>
			goto err;
  80237a:	eb 57                	jmp    8023d3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80237c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802380:	48 c1 e8 0c          	shr    $0xc,%rax
  802384:	48 89 c2             	mov    %rax,%rdx
  802387:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80238e:	01 00 00 
  802391:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802395:	25 07 0e 00 00       	and    $0xe07,%eax
  80239a:	89 c1                	mov    %eax,%ecx
  80239c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a4:	41 89 c8             	mov    %ecx,%r8d
  8023a7:	48 89 d1             	mov    %rdx,%rcx
  8023aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8023af:	48 89 c6             	mov    %rax,%rsi
  8023b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b7:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	callq  *%rax
  8023c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ca:	79 02                	jns    8023ce <dup+0x16f>
		goto err;
  8023cc:	eb 05                	jmp    8023d3 <dup+0x174>

	return newfdnum;
  8023ce:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023d1:	eb 33                	jmp    802406 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8023d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d7:	48 89 c6             	mov    %rax,%rsi
  8023da:	bf 00 00 00 00       	mov    $0x0,%edi
  8023df:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ef:	48 89 c6             	mov    %rax,%rsi
  8023f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f7:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
	return r;
  802403:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802406:	c9                   	leaveq 
  802407:	c3                   	retq   

0000000000802408 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802408:	55                   	push   %rbp
  802409:	48 89 e5             	mov    %rsp,%rbp
  80240c:	48 83 ec 40          	sub    $0x40,%rsp
  802410:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802413:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802417:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80241b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80241f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802422:	48 89 d6             	mov    %rdx,%rsi
  802425:	89 c7                	mov    %eax,%edi
  802427:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  80242e:	00 00 00 
  802431:	ff d0                	callq  *%rax
  802433:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802436:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80243a:	78 24                	js     802460 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80243c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802440:	8b 00                	mov    (%rax),%eax
  802442:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802446:	48 89 d6             	mov    %rdx,%rsi
  802449:	89 c7                	mov    %eax,%edi
  80244b:	48 b8 2f 21 80 00 00 	movabs $0x80212f,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax
  802457:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245e:	79 05                	jns    802465 <read+0x5d>
		return r;
  802460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802463:	eb 76                	jmp    8024db <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802469:	8b 40 08             	mov    0x8(%rax),%eax
  80246c:	83 e0 03             	and    $0x3,%eax
  80246f:	83 f8 01             	cmp    $0x1,%eax
  802472:	75 3a                	jne    8024ae <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802474:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80247b:	00 00 00 
  80247e:	48 8b 00             	mov    (%rax),%rax
  802481:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802487:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80248a:	89 c6                	mov    %eax,%esi
  80248c:	48 bf 3f 47 80 00 00 	movabs $0x80473f,%rdi
  802493:	00 00 00 
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
  80249b:	48 b9 df 05 80 00 00 	movabs $0x8005df,%rcx
  8024a2:	00 00 00 
  8024a5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ac:	eb 2d                	jmp    8024db <read+0xd3>
	}
	if (!dev->dev_read)
  8024ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024b6:	48 85 c0             	test   %rax,%rax
  8024b9:	75 07                	jne    8024c2 <read+0xba>
		return -E_NOT_SUPP;
  8024bb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024c0:	eb 19                	jmp    8024db <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024ca:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024ce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024d2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024d6:	48 89 cf             	mov    %rcx,%rdi
  8024d9:	ff d0                	callq  *%rax
}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 30          	sub    $0x30,%rsp
  8024e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024f7:	eb 49                	jmp    802542 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fc:	48 98                	cltq   
  8024fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802502:	48 29 c2             	sub    %rax,%rdx
  802505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802508:	48 63 c8             	movslq %eax,%rcx
  80250b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80250f:	48 01 c1             	add    %rax,%rcx
  802512:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802515:	48 89 ce             	mov    %rcx,%rsi
  802518:	89 c7                	mov    %eax,%edi
  80251a:	48 b8 08 24 80 00 00 	movabs $0x802408,%rax
  802521:	00 00 00 
  802524:	ff d0                	callq  *%rax
  802526:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802529:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80252d:	79 05                	jns    802534 <readn+0x57>
			return m;
  80252f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802532:	eb 1c                	jmp    802550 <readn+0x73>
		if (m == 0)
  802534:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802538:	75 02                	jne    80253c <readn+0x5f>
			break;
  80253a:	eb 11                	jmp    80254d <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80253c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80253f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802545:	48 98                	cltq   
  802547:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80254b:	72 ac                	jb     8024f9 <readn+0x1c>
	}
	return tot;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802550:	c9                   	leaveq 
  802551:	c3                   	retq   

0000000000802552 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802552:	55                   	push   %rbp
  802553:	48 89 e5             	mov    %rsp,%rbp
  802556:	48 83 ec 40          	sub    $0x40,%rsp
  80255a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80255d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802561:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802565:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802569:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	78 24                	js     8025aa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258a:	8b 00                	mov    (%rax),%eax
  80258c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802590:	48 89 d6             	mov    %rdx,%rsi
  802593:	89 c7                	mov    %eax,%edi
  802595:	48 b8 2f 21 80 00 00 	movabs $0x80212f,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	callq  *%rax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a8:	79 05                	jns    8025af <write+0x5d>
		return r;
  8025aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ad:	eb 75                	jmp    802624 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b3:	8b 40 08             	mov    0x8(%rax),%eax
  8025b6:	83 e0 03             	and    $0x3,%eax
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	75 3a                	jne    8025f7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025c4:	00 00 00 
  8025c7:	48 8b 00             	mov    (%rax),%rax
  8025ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025d3:	89 c6                	mov    %eax,%esi
  8025d5:	48 bf 5b 47 80 00 00 	movabs $0x80475b,%rdi
  8025dc:	00 00 00 
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	48 b9 df 05 80 00 00 	movabs $0x8005df,%rcx
  8025eb:	00 00 00 
  8025ee:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f5:	eb 2d                	jmp    802624 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025ff:	48 85 c0             	test   %rax,%rax
  802602:	75 07                	jne    80260b <write+0xb9>
		return -E_NOT_SUPP;
  802604:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802609:	eb 19                	jmp    802624 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80260b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802613:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802617:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80261b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80261f:	48 89 cf             	mov    %rcx,%rdi
  802622:	ff d0                	callq  *%rax
}
  802624:	c9                   	leaveq 
  802625:	c3                   	retq   

0000000000802626 <seek>:

int
seek(int fdnum, off_t offset)
{
  802626:	55                   	push   %rbp
  802627:	48 89 e5             	mov    %rsp,%rbp
  80262a:	48 83 ec 18          	sub    $0x18,%rsp
  80262e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802631:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802634:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802638:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80263b:	48 89 d6             	mov    %rdx,%rsi
  80263e:	89 c7                	mov    %eax,%edi
  802640:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802647:	00 00 00 
  80264a:	ff d0                	callq  *%rax
  80264c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802653:	79 05                	jns    80265a <seek+0x34>
		return r;
  802655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802658:	eb 0f                	jmp    802669 <seek+0x43>
	fd->fd_offset = offset;
  80265a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802661:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802669:	c9                   	leaveq 
  80266a:	c3                   	retq   

000000000080266b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80266b:	55                   	push   %rbp
  80266c:	48 89 e5             	mov    %rsp,%rbp
  80266f:	48 83 ec 30          	sub    $0x30,%rsp
  802673:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802676:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802679:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80267d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802680:	48 89 d6             	mov    %rdx,%rsi
  802683:	89 c7                	mov    %eax,%edi
  802685:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	78 24                	js     8026be <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80269a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269e:	8b 00                	mov    (%rax),%eax
  8026a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a4:	48 89 d6             	mov    %rdx,%rsi
  8026a7:	89 c7                	mov    %eax,%edi
  8026a9:	48 b8 2f 21 80 00 00 	movabs $0x80212f,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	callq  *%rax
  8026b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bc:	79 05                	jns    8026c3 <ftruncate+0x58>
		return r;
  8026be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c1:	eb 72                	jmp    802735 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c7:	8b 40 08             	mov    0x8(%rax),%eax
  8026ca:	83 e0 03             	and    $0x3,%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	75 3a                	jne    80270b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026d8:	00 00 00 
  8026db:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026e4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026e7:	89 c6                	mov    %eax,%esi
  8026e9:	48 bf 78 47 80 00 00 	movabs $0x804778,%rdi
  8026f0:	00 00 00 
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	48 b9 df 05 80 00 00 	movabs $0x8005df,%rcx
  8026ff:	00 00 00 
  802702:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802704:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802709:	eb 2a                	jmp    802735 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80270b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802713:	48 85 c0             	test   %rax,%rax
  802716:	75 07                	jne    80271f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802718:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80271d:	eb 16                	jmp    802735 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80271f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802723:	48 8b 40 30          	mov    0x30(%rax),%rax
  802727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80272b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80272e:	89 ce                	mov    %ecx,%esi
  802730:	48 89 d7             	mov    %rdx,%rdi
  802733:	ff d0                	callq  *%rax
}
  802735:	c9                   	leaveq 
  802736:	c3                   	retq   

0000000000802737 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802737:	55                   	push   %rbp
  802738:	48 89 e5             	mov    %rsp,%rbp
  80273b:	48 83 ec 30          	sub    $0x30,%rsp
  80273f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802742:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802746:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80274a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80274d:	48 89 d6             	mov    %rdx,%rsi
  802750:	89 c7                	mov    %eax,%edi
  802752:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802759:	00 00 00 
  80275c:	ff d0                	callq  *%rax
  80275e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802765:	78 24                	js     80278b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276b:	8b 00                	mov    (%rax),%eax
  80276d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802771:	48 89 d6             	mov    %rdx,%rsi
  802774:	89 c7                	mov    %eax,%edi
  802776:	48 b8 2f 21 80 00 00 	movabs $0x80212f,%rax
  80277d:	00 00 00 
  802780:	ff d0                	callq  *%rax
  802782:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802785:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802789:	79 05                	jns    802790 <fstat+0x59>
		return r;
  80278b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278e:	eb 5e                	jmp    8027ee <fstat+0xb7>
	if (!dev->dev_stat)
  802790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802794:	48 8b 40 28          	mov    0x28(%rax),%rax
  802798:	48 85 c0             	test   %rax,%rax
  80279b:	75 07                	jne    8027a4 <fstat+0x6d>
		return -E_NOT_SUPP;
  80279d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a2:	eb 4a                	jmp    8027ee <fstat+0xb7>
	stat->st_name[0] = 0;
  8027a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027a8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027af:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027b6:	00 00 00 
	stat->st_isdir = 0;
  8027b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027bd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027c4:	00 00 00 
	stat->st_dev = dev;
  8027c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027cf:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027da:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027e2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027e6:	48 89 ce             	mov    %rcx,%rsi
  8027e9:	48 89 d7             	mov    %rdx,%rdi
  8027ec:	ff d0                	callq  *%rax
}
  8027ee:	c9                   	leaveq 
  8027ef:	c3                   	retq   

00000000008027f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027f0:	55                   	push   %rbp
  8027f1:	48 89 e5             	mov    %rsp,%rbp
  8027f4:	48 83 ec 20          	sub    $0x20,%rsp
  8027f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802804:	be 00 00 00 00       	mov    $0x0,%esi
  802809:	48 89 c7             	mov    %rax,%rdi
  80280c:	48 b8 e0 28 80 00 00 	movabs $0x8028e0,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
  802818:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281f:	79 05                	jns    802826 <stat+0x36>
		return fd;
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802824:	eb 2f                	jmp    802855 <stat+0x65>
	r = fstat(fd, stat);
  802826:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80282a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282d:	48 89 d6             	mov    %rdx,%rsi
  802830:	89 c7                	mov    %eax,%edi
  802832:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802839:	00 00 00 
  80283c:	ff d0                	callq  *%rax
  80283e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802844:	89 c7                	mov    %eax,%edi
  802846:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
	return r;
  802852:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802855:	c9                   	leaveq 
  802856:	c3                   	retq   

0000000000802857 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802857:	55                   	push   %rbp
  802858:	48 89 e5             	mov    %rsp,%rbp
  80285b:	48 83 ec 10          	sub    $0x10,%rsp
  80285f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802862:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802866:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80286d:	00 00 00 
  802870:	8b 00                	mov    (%rax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	75 1f                	jne    802895 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802876:	bf 01 00 00 00       	mov    $0x1,%edi
  80287b:	48 b8 61 3f 80 00 00 	movabs $0x803f61,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	89 c2                	mov    %eax,%edx
  802889:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802890:	00 00 00 
  802893:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802895:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80289c:	00 00 00 
  80289f:	8b 00                	mov    (%rax),%eax
  8028a1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028a4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028a9:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8028b0:	00 00 00 
  8028b3:	89 c7                	mov    %eax,%edi
  8028b5:	48 b8 d4 3d 80 00 00 	movabs $0x803dd4,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ca:	48 89 c6             	mov    %rax,%rsi
  8028cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d2:	48 b8 96 3d 80 00 00 	movabs $0x803d96,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
}
  8028de:	c9                   	leaveq 
  8028df:	c3                   	retq   

00000000008028e0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028e0:	55                   	push   %rbp
  8028e1:	48 89 e5             	mov    %rsp,%rbp
  8028e4:	48 83 ec 10          	sub    $0x10,%rsp
  8028e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028ec:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8028ef:	48 ba 9e 47 80 00 00 	movabs $0x80479e,%rdx
  8028f6:	00 00 00 
  8028f9:	be 4c 00 00 00       	mov    $0x4c,%esi
  8028fe:	48 bf b3 47 80 00 00 	movabs $0x8047b3,%rdi
  802905:	00 00 00 
  802908:	b8 00 00 00 00       	mov    $0x0,%eax
  80290d:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  802914:	00 00 00 
  802917:	ff d1                	callq  *%rcx

0000000000802919 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	48 83 ec 10          	sub    $0x10,%rsp
  802921:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802925:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802929:	8b 50 0c             	mov    0xc(%rax),%edx
  80292c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802933:	00 00 00 
  802936:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802938:	be 00 00 00 00       	mov    $0x0,%esi
  80293d:	bf 06 00 00 00       	mov    $0x6,%edi
  802942:	48 b8 57 28 80 00 00 	movabs $0x802857,%rax
  802949:	00 00 00 
  80294c:	ff d0                	callq  *%rax
}
  80294e:	c9                   	leaveq 
  80294f:	c3                   	retq   

0000000000802950 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802950:	55                   	push   %rbp
  802951:	48 89 e5             	mov    %rsp,%rbp
  802954:	48 83 ec 20          	sub    $0x20,%rsp
  802958:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80295c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802960:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802964:	48 ba be 47 80 00 00 	movabs $0x8047be,%rdx
  80296b:	00 00 00 
  80296e:	be 6b 00 00 00       	mov    $0x6b,%esi
  802973:	48 bf b3 47 80 00 00 	movabs $0x8047b3,%rdi
  80297a:	00 00 00 
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
  802982:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  802989:	00 00 00 
  80298c:	ff d1                	callq  *%rcx

000000000080298e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80298e:	55                   	push   %rbp
  80298f:	48 89 e5             	mov    %rsp,%rbp
  802992:	48 83 ec 20          	sub    $0x20,%rsp
  802996:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80299a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80299e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8029a2:	48 ba db 47 80 00 00 	movabs $0x8047db,%rdx
  8029a9:	00 00 00 
  8029ac:	be 7b 00 00 00       	mov    $0x7b,%esi
  8029b1:	48 bf b3 47 80 00 00 	movabs $0x8047b3,%rdi
  8029b8:	00 00 00 
  8029bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c0:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  8029c7:	00 00 00 
  8029ca:	ff d1                	callq  *%rcx

00000000008029cc <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 20          	sub    $0x20,%rsp
  8029d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ea:	00 00 00 
  8029ed:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029ef:	be 00 00 00 00       	mov    $0x0,%esi
  8029f4:	bf 05 00 00 00       	mov    $0x5,%edi
  8029f9:	48 b8 57 28 80 00 00 	movabs $0x802857,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
  802a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0c:	79 05                	jns    802a13 <devfile_stat+0x47>
		return r;
  802a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a11:	eb 56                	jmp    802a69 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a17:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a1e:	00 00 00 
  802a21:	48 89 c7             	mov    %rax,%rdi
  802a24:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a30:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a37:	00 00 00 
  802a3a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a44:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a51:	00 00 00 
  802a54:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a69:	c9                   	leaveq 
  802a6a:	c3                   	retq   

0000000000802a6b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a6b:	55                   	push   %rbp
  802a6c:	48 89 e5             	mov    %rsp,%rbp
  802a6f:	48 83 ec 10          	sub    $0x10,%rsp
  802a73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a77:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a7e:	8b 50 0c             	mov    0xc(%rax),%edx
  802a81:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a88:	00 00 00 
  802a8b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a8d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a94:	00 00 00 
  802a97:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a9a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a9d:	be 00 00 00 00       	mov    $0x0,%esi
  802aa2:	bf 02 00 00 00       	mov    $0x2,%edi
  802aa7:	48 b8 57 28 80 00 00 	movabs $0x802857,%rax
  802aae:	00 00 00 
  802ab1:	ff d0                	callq  *%rax
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 10          	sub    $0x10,%rsp
  802abd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac5:	48 89 c7             	mov    %rax,%rdi
  802ac8:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ad9:	7e 07                	jle    802ae2 <remove+0x2d>
		return -E_BAD_PATH;
  802adb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ae0:	eb 33                	jmp    802b15 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ae2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae6:	48 89 c6             	mov    %rax,%rsi
  802ae9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802af0:	00 00 00 
  802af3:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aff:	be 00 00 00 00       	mov    $0x0,%esi
  802b04:	bf 07 00 00 00       	mov    $0x7,%edi
  802b09:	48 b8 57 28 80 00 00 	movabs $0x802857,%rax
  802b10:	00 00 00 
  802b13:	ff d0                	callq  *%rax
}
  802b15:	c9                   	leaveq 
  802b16:	c3                   	retq   

0000000000802b17 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b17:	55                   	push   %rbp
  802b18:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b1b:	be 00 00 00 00       	mov    $0x0,%esi
  802b20:	bf 08 00 00 00       	mov    $0x8,%edi
  802b25:	48 b8 57 28 80 00 00 	movabs $0x802857,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
}
  802b31:	5d                   	pop    %rbp
  802b32:	c3                   	retq   

0000000000802b33 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b3e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b45:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b4c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b53:	be 00 00 00 00       	mov    $0x0,%esi
  802b58:	48 89 c7             	mov    %rax,%rdi
  802b5b:	48 b8 e0 28 80 00 00 	movabs $0x8028e0,%rax
  802b62:	00 00 00 
  802b65:	ff d0                	callq  *%rax
  802b67:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6e:	79 28                	jns    802b98 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b73:	89 c6                	mov    %eax,%esi
  802b75:	48 bf f9 47 80 00 00 	movabs $0x8047f9,%rdi
  802b7c:	00 00 00 
  802b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b84:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  802b8b:	00 00 00 
  802b8e:	ff d2                	callq  *%rdx
		return fd_src;
  802b90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b93:	e9 74 01 00 00       	jmpq   802d0c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b98:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b9f:	be 01 01 00 00       	mov    $0x101,%esi
  802ba4:	48 89 c7             	mov    %rax,%rdi
  802ba7:	48 b8 e0 28 80 00 00 	movabs $0x8028e0,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
  802bb3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bb6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bba:	79 39                	jns    802bf5 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bbf:	89 c6                	mov    %eax,%esi
  802bc1:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  802bc8:	00 00 00 
  802bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd0:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  802bd7:	00 00 00 
  802bda:	ff d2                	callq  *%rdx
		close(fd_src);
  802bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
		return fd_dest;
  802bed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf0:	e9 17 01 00 00       	jmpq   802d0c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bf5:	eb 74                	jmp    802c6b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bf7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bfa:	48 63 d0             	movslq %eax,%rdx
  802bfd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c07:	48 89 ce             	mov    %rcx,%rsi
  802c0a:	89 c7                	mov    %eax,%edi
  802c0c:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
  802c18:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c1f:	79 4a                	jns    802c6b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c21:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c24:	89 c6                	mov    %eax,%esi
  802c26:	48 bf 29 48 80 00 00 	movabs $0x804829,%rdi
  802c2d:	00 00 00 
  802c30:	b8 00 00 00 00       	mov    $0x0,%eax
  802c35:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  802c3c:	00 00 00 
  802c3f:	ff d2                	callq  *%rdx
			close(fd_src);
  802c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c44:	89 c7                	mov    %eax,%edi
  802c46:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
			close(fd_dest);
  802c52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c55:	89 c7                	mov    %eax,%edi
  802c57:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
			return write_size;
  802c63:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c66:	e9 a1 00 00 00       	jmpq   802d0c <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c6b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c75:	ba 00 02 00 00       	mov    $0x200,%edx
  802c7a:	48 89 ce             	mov    %rcx,%rsi
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	48 b8 08 24 80 00 00 	movabs $0x802408,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
  802c8b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c92:	0f 8f 5f ff ff ff    	jg     802bf7 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c9c:	79 47                	jns    802ce5 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ca1:	89 c6                	mov    %eax,%esi
  802ca3:	48 bf 3c 48 80 00 00 	movabs $0x80483c,%rdi
  802caa:	00 00 00 
  802cad:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb2:	48 ba df 05 80 00 00 	movabs $0x8005df,%rdx
  802cb9:	00 00 00 
  802cbc:	ff d2                	callq  *%rdx
		close(fd_src);
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	89 c7                	mov    %eax,%edi
  802cc3:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
		close(fd_dest);
  802ccf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
		return read_size;
  802ce0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce3:	eb 27                	jmp    802d0c <copy+0x1d9>
	}
	close(fd_src);
  802ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce8:	89 c7                	mov    %eax,%edi
  802cea:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
	close(fd_dest);
  802cf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
	return 0;
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 20          	sub    $0x20,%rsp
  802d16:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d20:	48 89 d6             	mov    %rdx,%rsi
  802d23:	89 c7                	mov    %eax,%edi
  802d25:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
  802d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d38:	79 05                	jns    802d3f <fd2sockid+0x31>
		return r;
  802d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3d:	eb 24                	jmp    802d63 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d43:	8b 10                	mov    (%rax),%edx
  802d45:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d4c:	00 00 00 
  802d4f:	8b 00                	mov    (%rax),%eax
  802d51:	39 c2                	cmp    %eax,%edx
  802d53:	74 07                	je     802d5c <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d55:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d5a:	eb 07                	jmp    802d63 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d60:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d63:	c9                   	leaveq 
  802d64:	c3                   	retq   

0000000000802d65 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d65:	55                   	push   %rbp
  802d66:	48 89 e5             	mov    %rsp,%rbp
  802d69:	48 83 ec 20          	sub    $0x20,%rsp
  802d6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d70:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d74:	48 89 c7             	mov    %rax,%rdi
  802d77:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8a:	78 26                	js     802db2 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d90:	ba 07 04 00 00       	mov    $0x407,%edx
  802d95:	48 89 c6             	mov    %rax,%rsi
  802d98:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9d:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db0:	79 16                	jns    802dc8 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802db2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802db5:	89 c7                	mov    %eax,%edi
  802db7:	48 b8 74 32 80 00 00 	movabs $0x803274,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
		return r;
  802dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc6:	eb 3a                	jmp    802e02 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcc:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802dd3:	00 00 00 
  802dd6:	8b 12                	mov    (%rdx),%edx
  802dd8:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dde:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dec:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df3:	48 89 c7             	mov    %rax,%rdi
  802df6:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
}
  802e02:	c9                   	leaveq 
  802e03:	c3                   	retq   

0000000000802e04 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e04:	55                   	push   %rbp
  802e05:	48 89 e5             	mov    %rsp,%rbp
  802e08:	48 83 ec 30          	sub    $0x30,%rsp
  802e0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e1a:	89 c7                	mov    %eax,%edi
  802e1c:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
  802e28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2f:	79 05                	jns    802e36 <accept+0x32>
		return r;
  802e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e34:	eb 3b                	jmp    802e71 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e36:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e3a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e41:	48 89 ce             	mov    %rcx,%rsi
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 51 31 80 00 00 	movabs $0x803151,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
  802e52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e59:	79 05                	jns    802e60 <accept+0x5c>
		return r;
  802e5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5e:	eb 11                	jmp    802e71 <accept+0x6d>
	return alloc_sockfd(r);
  802e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 20          	sub    $0x20,%rsp
  802e7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e82:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e88:	89 c7                	mov    %eax,%edi
  802e8a:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
  802e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9d:	79 05                	jns    802ea4 <bind+0x31>
		return r;
  802e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea2:	eb 1b                	jmp    802ebf <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ea4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ea7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	48 89 ce             	mov    %rcx,%rsi
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
}
  802ebf:	c9                   	leaveq 
  802ec0:	c3                   	retq   

0000000000802ec1 <shutdown>:

int
shutdown(int s, int how)
{
  802ec1:	55                   	push   %rbp
  802ec2:	48 89 e5             	mov    %rsp,%rbp
  802ec5:	48 83 ec 20          	sub    $0x20,%rsp
  802ec9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ecc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ecf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed2:	89 c7                	mov    %eax,%edi
  802ed4:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee7:	79 05                	jns    802eee <shutdown+0x2d>
		return r;
  802ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eec:	eb 16                	jmp    802f04 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802eee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef4:	89 d6                	mov    %edx,%esi
  802ef6:	89 c7                	mov    %eax,%edi
  802ef8:	48 b8 34 32 80 00 00 	movabs $0x803234,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
}
  802f04:	c9                   	leaveq 
  802f05:	c3                   	retq   

0000000000802f06 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f06:	55                   	push   %rbp
  802f07:	48 89 e5             	mov    %rsp,%rbp
  802f0a:	48 83 ec 10          	sub    $0x10,%rsp
  802f0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f16:	48 89 c7             	mov    %rax,%rdi
  802f19:	48 b8 d3 3f 80 00 00 	movabs $0x803fd3,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
  802f25:	83 f8 01             	cmp    $0x1,%eax
  802f28:	75 17                	jne    802f41 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2e:	8b 40 0c             	mov    0xc(%rax),%eax
  802f31:	89 c7                	mov    %eax,%edi
  802f33:	48 b8 74 32 80 00 00 	movabs $0x803274,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
  802f3f:	eb 05                	jmp    802f46 <devsock_close+0x40>
	else
		return 0;
  802f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 20          	sub    $0x20,%rsp
  802f50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f57:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f5d:	89 c7                	mov    %eax,%edi
  802f5f:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802f66:	00 00 00 
  802f69:	ff d0                	callq  *%rax
  802f6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f72:	79 05                	jns    802f79 <connect+0x31>
		return r;
  802f74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f77:	eb 1b                	jmp    802f94 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f79:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f7c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f83:	48 89 ce             	mov    %rcx,%rsi
  802f86:	89 c7                	mov    %eax,%edi
  802f88:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
}
  802f94:	c9                   	leaveq 
  802f95:	c3                   	retq   

0000000000802f96 <listen>:

int
listen(int s, int backlog)
{
  802f96:	55                   	push   %rbp
  802f97:	48 89 e5             	mov    %rsp,%rbp
  802f9a:	48 83 ec 20          	sub    $0x20,%rsp
  802f9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fa1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa7:	89 c7                	mov    %eax,%edi
  802fa9:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
  802fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbc:	79 05                	jns    802fc3 <listen+0x2d>
		return r;
  802fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc1:	eb 16                	jmp    802fd9 <listen+0x43>
	return nsipc_listen(r, backlog);
  802fc3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc9:	89 d6                	mov    %edx,%esi
  802fcb:	89 c7                	mov    %eax,%edi
  802fcd:	48 b8 05 33 80 00 00 	movabs $0x803305,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
}
  802fd9:	c9                   	leaveq 
  802fda:	c3                   	retq   

0000000000802fdb <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802fdb:	55                   	push   %rbp
  802fdc:	48 89 e5             	mov    %rsp,%rbp
  802fdf:	48 83 ec 20          	sub    $0x20,%rsp
  802fe3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fe7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802feb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff3:	89 c2                	mov    %eax,%edx
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	8b 40 0c             	mov    0xc(%rax),%eax
  802ffc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803000:	b9 00 00 00 00       	mov    $0x0,%ecx
  803005:	89 c7                	mov    %eax,%edi
  803007:	48 b8 45 33 80 00 00 	movabs $0x803345,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
}
  803013:	c9                   	leaveq 
  803014:	c3                   	retq   

0000000000803015 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	48 83 ec 20          	sub    $0x20,%rsp
  80301d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803021:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803025:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302d:	89 c2                	mov    %eax,%edx
  80302f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803033:	8b 40 0c             	mov    0xc(%rax),%eax
  803036:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80303a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80303f:	89 c7                	mov    %eax,%edi
  803041:	48 b8 11 34 80 00 00 	movabs $0x803411,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
}
  80304d:	c9                   	leaveq 
  80304e:	c3                   	retq   

000000000080304f <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80304f:	55                   	push   %rbp
  803050:	48 89 e5             	mov    %rsp,%rbp
  803053:	48 83 ec 10          	sub    $0x10,%rsp
  803057:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80305f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803063:	48 be 57 48 80 00 00 	movabs $0x804857,%rsi
  80306a:	00 00 00 
  80306d:	48 89 c7             	mov    %rax,%rdi
  803070:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
	return 0;
  80307c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803081:	c9                   	leaveq 
  803082:	c3                   	retq   

0000000000803083 <socket>:

int
socket(int domain, int type, int protocol)
{
  803083:	55                   	push   %rbp
  803084:	48 89 e5             	mov    %rsp,%rbp
  803087:	48 83 ec 20          	sub    $0x20,%rsp
  80308b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80308e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803091:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803094:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803097:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80309a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80309d:	89 ce                	mov    %ecx,%esi
  80309f:	89 c7                	mov    %eax,%edi
  8030a1:	48 b8 c9 34 80 00 00 	movabs $0x8034c9,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b4:	79 05                	jns    8030bb <socket+0x38>
		return r;
  8030b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b9:	eb 11                	jmp    8030cc <socket+0x49>
	return alloc_sockfd(r);
  8030bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030be:	89 c7                	mov    %eax,%edi
  8030c0:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
}
  8030cc:	c9                   	leaveq 
  8030cd:	c3                   	retq   

00000000008030ce <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030ce:	55                   	push   %rbp
  8030cf:	48 89 e5             	mov    %rsp,%rbp
  8030d2:	48 83 ec 10          	sub    $0x10,%rsp
  8030d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030d9:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030e0:	00 00 00 
  8030e3:	8b 00                	mov    (%rax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	75 1f                	jne    803108 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8030e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8030ee:	48 b8 61 3f 80 00 00 	movabs $0x803f61,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	89 c2                	mov    %eax,%edx
  8030fc:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803103:	00 00 00 
  803106:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803108:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80310f:	00 00 00 
  803112:	8b 00                	mov    (%rax),%eax
  803114:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803117:	b9 07 00 00 00       	mov    $0x7,%ecx
  80311c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803123:	00 00 00 
  803126:	89 c7                	mov    %eax,%edi
  803128:	48 b8 d4 3d 80 00 00 	movabs $0x803dd4,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803134:	ba 00 00 00 00       	mov    $0x0,%edx
  803139:	be 00 00 00 00       	mov    $0x0,%esi
  80313e:	bf 00 00 00 00       	mov    $0x0,%edi
  803143:	48 b8 96 3d 80 00 00 	movabs $0x803d96,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
}
  80314f:	c9                   	leaveq 
  803150:	c3                   	retq   

0000000000803151 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803151:	55                   	push   %rbp
  803152:	48 89 e5             	mov    %rsp,%rbp
  803155:	48 83 ec 30          	sub    $0x30,%rsp
  803159:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80315c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803160:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803164:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80316b:	00 00 00 
  80316e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803171:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803173:	bf 01 00 00 00       	mov    $0x1,%edi
  803178:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
  803184:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318b:	78 3e                	js     8031cb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80318d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803194:	00 00 00 
  803197:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80319b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319f:	8b 40 10             	mov    0x10(%rax),%eax
  8031a2:	89 c2                	mov    %eax,%edx
  8031a4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ac:	48 89 ce             	mov    %rcx,%rsi
  8031af:	48 89 c7             	mov    %rax,%rdi
  8031b2:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c2:	8b 50 10             	mov    0x10(%rax),%edx
  8031c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031ce:	c9                   	leaveq 
  8031cf:	c3                   	retq   

00000000008031d0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031d0:	55                   	push   %rbp
  8031d1:	48 89 e5             	mov    %rsp,%rbp
  8031d4:	48 83 ec 10          	sub    $0x10,%rsp
  8031d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031df:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e9:	00 00 00 
  8031ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031ef:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8031f1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f8:	48 89 c6             	mov    %rax,%rsi
  8031fb:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803202:	00 00 00 
  803205:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  80320c:	00 00 00 
  80320f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803211:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803218:	00 00 00 
  80321b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80321e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803221:	bf 02 00 00 00       	mov    $0x2,%edi
  803226:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
}
  803232:	c9                   	leaveq 
  803233:	c3                   	retq   

0000000000803234 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803234:	55                   	push   %rbp
  803235:	48 89 e5             	mov    %rsp,%rbp
  803238:	48 83 ec 10          	sub    $0x10,%rsp
  80323c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80323f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803242:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803249:	00 00 00 
  80324c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80324f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803251:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803258:	00 00 00 
  80325b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803261:	bf 03 00 00 00       	mov    $0x3,%edi
  803266:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <nsipc_close>:

int
nsipc_close(int s)
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	48 83 ec 10          	sub    $0x10,%rsp
  80327c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80327f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803286:	00 00 00 
  803289:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80328c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80328e:	bf 04 00 00 00       	mov    $0x4,%edi
  803293:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
}
  80329f:	c9                   	leaveq 
  8032a0:	c3                   	retq   

00000000008032a1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032a1:	55                   	push   %rbp
  8032a2:	48 89 e5             	mov    %rsp,%rbp
  8032a5:	48 83 ec 10          	sub    $0x10,%rsp
  8032a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032ba:	00 00 00 
  8032bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032c2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c9:	48 89 c6             	mov    %rax,%rsi
  8032cc:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032d3:	00 00 00 
  8032d6:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e9:	00 00 00 
  8032ec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ef:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8032f2:	bf 05 00 00 00       	mov    $0x5,%edi
  8032f7:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
}
  803303:	c9                   	leaveq 
  803304:	c3                   	retq   

0000000000803305 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803305:	55                   	push   %rbp
  803306:	48 89 e5             	mov    %rsp,%rbp
  803309:	48 83 ec 10          	sub    $0x10,%rsp
  80330d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803310:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803313:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80331a:	00 00 00 
  80331d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803320:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803322:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803329:	00 00 00 
  80332c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803332:	bf 06 00 00 00       	mov    $0x6,%edi
  803337:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
}
  803343:	c9                   	leaveq 
  803344:	c3                   	retq   

0000000000803345 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803345:	55                   	push   %rbp
  803346:	48 89 e5             	mov    %rsp,%rbp
  803349:	48 83 ec 30          	sub    $0x30,%rsp
  80334d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803350:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803354:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803357:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80335a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803361:	00 00 00 
  803364:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803367:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803369:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803370:	00 00 00 
  803373:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803376:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803379:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803380:	00 00 00 
  803383:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803386:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803389:	bf 07 00 00 00       	mov    $0x7,%edi
  80338e:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  803395:	00 00 00 
  803398:	ff d0                	callq  *%rax
  80339a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a1:	78 69                	js     80340c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033a3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033aa:	7f 08                	jg     8033b4 <nsipc_recv+0x6f>
  8033ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033af:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033b2:	7e 35                	jle    8033e9 <nsipc_recv+0xa4>
  8033b4:	48 b9 5e 48 80 00 00 	movabs $0x80485e,%rcx
  8033bb:	00 00 00 
  8033be:	48 ba 73 48 80 00 00 	movabs $0x804873,%rdx
  8033c5:	00 00 00 
  8033c8:	be 61 00 00 00       	mov    $0x61,%esi
  8033cd:	48 bf 88 48 80 00 00 	movabs $0x804888,%rdi
  8033d4:	00 00 00 
  8033d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033dc:	49 b8 a6 03 80 00 00 	movabs $0x8003a6,%r8
  8033e3:	00 00 00 
  8033e6:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ec:	48 63 d0             	movslq %eax,%rdx
  8033ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f3:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8033fa:	00 00 00 
  8033fd:	48 89 c7             	mov    %rax,%rdi
  803400:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
	}

	return r;
  80340c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80340f:	c9                   	leaveq 
  803410:	c3                   	retq   

0000000000803411 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803411:	55                   	push   %rbp
  803412:	48 89 e5             	mov    %rsp,%rbp
  803415:	48 83 ec 20          	sub    $0x20,%rsp
  803419:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80341c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803420:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803423:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803426:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342d:	00 00 00 
  803430:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803433:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803435:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80343c:	7e 35                	jle    803473 <nsipc_send+0x62>
  80343e:	48 b9 94 48 80 00 00 	movabs $0x804894,%rcx
  803445:	00 00 00 
  803448:	48 ba 73 48 80 00 00 	movabs $0x804873,%rdx
  80344f:	00 00 00 
  803452:	be 6c 00 00 00       	mov    $0x6c,%esi
  803457:	48 bf 88 48 80 00 00 	movabs $0x804888,%rdi
  80345e:	00 00 00 
  803461:	b8 00 00 00 00       	mov    $0x0,%eax
  803466:	49 b8 a6 03 80 00 00 	movabs $0x8003a6,%r8
  80346d:	00 00 00 
  803470:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803473:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803476:	48 63 d0             	movslq %eax,%rdx
  803479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347d:	48 89 c6             	mov    %rax,%rsi
  803480:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803487:	00 00 00 
  80348a:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803496:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80349d:	00 00 00 
  8034a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034a3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ad:	00 00 00 
  8034b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034b3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8034bb:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
}
  8034c7:	c9                   	leaveq 
  8034c8:	c3                   	retq   

00000000008034c9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034c9:	55                   	push   %rbp
  8034ca:	48 89 e5             	mov    %rsp,%rbp
  8034cd:	48 83 ec 10          	sub    $0x10,%rsp
  8034d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034d4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034d7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e1:	00 00 00 
  8034e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034e7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8034e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034f0:	00 00 00 
  8034f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8034f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803500:	00 00 00 
  803503:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803506:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803509:	bf 09 00 00 00       	mov    $0x9,%edi
  80350e:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
}
  80351a:	c9                   	leaveq 
  80351b:	c3                   	retq   

000000000080351c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80351c:	55                   	push   %rbp
  80351d:	48 89 e5             	mov    %rsp,%rbp
  803520:	53                   	push   %rbx
  803521:	48 83 ec 38          	sub    $0x38,%rsp
  803525:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803529:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80352d:	48 89 c7             	mov    %rax,%rdi
  803530:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80353f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803543:	0f 88 bf 01 00 00    	js     803708 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354d:	ba 07 04 00 00       	mov    $0x407,%edx
  803552:	48 89 c6             	mov    %rax,%rsi
  803555:	bf 00 00 00 00       	mov    $0x0,%edi
  80355a:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803569:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80356d:	0f 88 95 01 00 00    	js     803708 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803573:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803577:	48 89 c7             	mov    %rax,%rdi
  80357a:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803589:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80358d:	0f 88 5d 01 00 00    	js     8036f0 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803593:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803597:	ba 07 04 00 00       	mov    $0x407,%edx
  80359c:	48 89 c6             	mov    %rax,%rsi
  80359f:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a4:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  8035ab:	00 00 00 
  8035ae:	ff d0                	callq  *%rax
  8035b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b7:	0f 88 33 01 00 00    	js     8036f0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c1:	48 89 c7             	mov    %rax,%rdi
  8035c4:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
  8035d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d8:	ba 07 04 00 00       	mov    $0x407,%edx
  8035dd:	48 89 c6             	mov    %rax,%rsi
  8035e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e5:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
  8035f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f8:	79 05                	jns    8035ff <pipe+0xe3>
		goto err2;
  8035fa:	e9 d9 00 00 00       	jmpq   8036d8 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803603:	48 89 c7             	mov    %rax,%rdi
  803606:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
  803612:	48 89 c2             	mov    %rax,%rdx
  803615:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803619:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80361f:	48 89 d1             	mov    %rdx,%rcx
  803622:	ba 00 00 00 00       	mov    $0x0,%edx
  803627:	48 89 c6             	mov    %rax,%rsi
  80362a:	bf 00 00 00 00       	mov    $0x0,%edi
  80362f:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  803636:	00 00 00 
  803639:	ff d0                	callq  *%rax
  80363b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803642:	79 1b                	jns    80365f <pipe+0x143>
		goto err3;
  803644:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803645:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803649:	48 89 c6             	mov    %rax,%rsi
  80364c:	bf 00 00 00 00       	mov    $0x0,%edi
  803651:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803658:	00 00 00 
  80365b:	ff d0                	callq  *%rax
  80365d:	eb 79                	jmp    8036d8 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  80365f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803663:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80366a:	00 00 00 
  80366d:	8b 12                	mov    (%rdx),%edx
  80366f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803675:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80367c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803680:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803687:	00 00 00 
  80368a:	8b 12                	mov    (%rdx),%edx
  80368c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80368e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803692:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80369d:	48 89 c7             	mov    %rax,%rdi
  8036a0:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  8036a7:	00 00 00 
  8036aa:	ff d0                	callq  *%rax
  8036ac:	89 c2                	mov    %eax,%edx
  8036ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036b2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036b8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c0:	48 89 c7             	mov    %rax,%rdi
  8036c3:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  8036ca:	00 00 00 
  8036cd:	ff d0                	callq  *%rax
  8036cf:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d6:	eb 33                	jmp    80370b <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8036d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036dc:	48 89 c6             	mov    %rax,%rsi
  8036df:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e4:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  8036eb:	00 00 00 
  8036ee:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f4:	48 89 c6             	mov    %rax,%rsi
  8036f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fc:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
err:
	return r;
  803708:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80370b:	48 83 c4 38          	add    $0x38,%rsp
  80370f:	5b                   	pop    %rbx
  803710:	5d                   	pop    %rbp
  803711:	c3                   	retq   

0000000000803712 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803712:	55                   	push   %rbp
  803713:	48 89 e5             	mov    %rsp,%rbp
  803716:	53                   	push   %rbx
  803717:	48 83 ec 28          	sub    $0x28,%rsp
  80371b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80371f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803723:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80372a:	00 00 00 
  80372d:	48 8b 00             	mov    (%rax),%rax
  803730:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803736:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373d:	48 89 c7             	mov    %rax,%rdi
  803740:	48 b8 d3 3f 80 00 00 	movabs $0x803fd3,%rax
  803747:	00 00 00 
  80374a:	ff d0                	callq  *%rax
  80374c:	89 c3                	mov    %eax,%ebx
  80374e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803752:	48 89 c7             	mov    %rax,%rdi
  803755:	48 b8 d3 3f 80 00 00 	movabs $0x803fd3,%rax
  80375c:	00 00 00 
  80375f:	ff d0                	callq  *%rax
  803761:	39 c3                	cmp    %eax,%ebx
  803763:	0f 94 c0             	sete   %al
  803766:	0f b6 c0             	movzbl %al,%eax
  803769:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80376c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803773:	00 00 00 
  803776:	48 8b 00             	mov    (%rax),%rax
  803779:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80377f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803782:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803785:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803788:	75 05                	jne    80378f <_pipeisclosed+0x7d>
			return ret;
  80378a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80378d:	eb 4a                	jmp    8037d9 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80378f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803792:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803795:	74 3d                	je     8037d4 <_pipeisclosed+0xc2>
  803797:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80379b:	75 37                	jne    8037d4 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80379d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037a4:	00 00 00 
  8037a7:	48 8b 00             	mov    (%rax),%rax
  8037aa:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037b0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b6:	89 c6                	mov    %eax,%esi
  8037b8:	48 bf a5 48 80 00 00 	movabs $0x8048a5,%rdi
  8037bf:	00 00 00 
  8037c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c7:	49 b8 df 05 80 00 00 	movabs $0x8005df,%r8
  8037ce:	00 00 00 
  8037d1:	41 ff d0             	callq  *%r8
	}
  8037d4:	e9 4a ff ff ff       	jmpq   803723 <_pipeisclosed+0x11>
}
  8037d9:	48 83 c4 28          	add    $0x28,%rsp
  8037dd:	5b                   	pop    %rbx
  8037de:	5d                   	pop    %rbp
  8037df:	c3                   	retq   

00000000008037e0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037e0:	55                   	push   %rbp
  8037e1:	48 89 e5             	mov    %rsp,%rbp
  8037e4:	48 83 ec 30          	sub    $0x30,%rsp
  8037e8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037eb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037f2:	48 89 d6             	mov    %rdx,%rsi
  8037f5:	89 c7                	mov    %eax,%edi
  8037f7:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
  803803:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803806:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380a:	79 05                	jns    803811 <pipeisclosed+0x31>
		return r;
  80380c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380f:	eb 31                	jmp    803842 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803815:	48 89 c7             	mov    %rax,%rdi
  803818:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803830:	48 89 d6             	mov    %rdx,%rsi
  803833:	48 89 c7             	mov    %rax,%rdi
  803836:	48 b8 12 37 80 00 00 	movabs $0x803712,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
}
  803842:	c9                   	leaveq 
  803843:	c3                   	retq   

0000000000803844 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803844:	55                   	push   %rbp
  803845:	48 89 e5             	mov    %rsp,%rbp
  803848:	48 83 ec 40          	sub    $0x40,%rsp
  80384c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803850:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803854:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385c:	48 89 c7             	mov    %rax,%rdi
  80385f:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  803866:	00 00 00 
  803869:	ff d0                	callq  *%rax
  80386b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80386f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803873:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803877:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80387e:	00 
  80387f:	e9 92 00 00 00       	jmpq   803916 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803884:	eb 41                	jmp    8038c7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803886:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80388b:	74 09                	je     803896 <devpipe_read+0x52>
				return i;
  80388d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803891:	e9 92 00 00 00       	jmpq   803928 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803896:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80389a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389e:	48 89 d6             	mov    %rdx,%rsi
  8038a1:	48 89 c7             	mov    %rax,%rdi
  8038a4:	48 b8 12 37 80 00 00 	movabs $0x803712,%rax
  8038ab:	00 00 00 
  8038ae:	ff d0                	callq  *%rax
  8038b0:	85 c0                	test   %eax,%eax
  8038b2:	74 07                	je     8038bb <devpipe_read+0x77>
				return 0;
  8038b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b9:	eb 6d                	jmp    803928 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038bb:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  8038c2:	00 00 00 
  8038c5:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8038c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cb:	8b 10                	mov    (%rax),%edx
  8038cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d1:	8b 40 04             	mov    0x4(%rax),%eax
  8038d4:	39 c2                	cmp    %eax,%edx
  8038d6:	74 ae                	je     803886 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038e0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e8:	8b 00                	mov    (%rax),%eax
  8038ea:	99                   	cltd   
  8038eb:	c1 ea 1b             	shr    $0x1b,%edx
  8038ee:	01 d0                	add    %edx,%eax
  8038f0:	83 e0 1f             	and    $0x1f,%eax
  8038f3:	29 d0                	sub    %edx,%eax
  8038f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038f9:	48 98                	cltq   
  8038fb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803900:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803902:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803906:	8b 00                	mov    (%rax),%eax
  803908:	8d 50 01             	lea    0x1(%rax),%edx
  80390b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390f:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803911:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803916:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80391e:	0f 82 60 ff ff ff    	jb     803884 <devpipe_read+0x40>
	}
	return i;
  803924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803928:	c9                   	leaveq 
  803929:	c3                   	retq   

000000000080392a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80392a:	55                   	push   %rbp
  80392b:	48 89 e5             	mov    %rsp,%rbp
  80392e:	48 83 ec 40          	sub    $0x40,%rsp
  803932:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803936:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80393a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80393e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803942:	48 89 c7             	mov    %rax,%rdi
  803945:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
  803951:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803955:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803959:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80395d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803964:	00 
  803965:	e9 91 00 00 00       	jmpq   8039fb <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80396a:	eb 31                	jmp    80399d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80396c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803974:	48 89 d6             	mov    %rdx,%rsi
  803977:	48 89 c7             	mov    %rax,%rdi
  80397a:	48 b8 12 37 80 00 00 	movabs $0x803712,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
  803986:	85 c0                	test   %eax,%eax
  803988:	74 07                	je     803991 <devpipe_write+0x67>
				return 0;
  80398a:	b8 00 00 00 00       	mov    $0x0,%eax
  80398f:	eb 7c                	jmp    803a0d <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803991:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80399d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a1:	8b 40 04             	mov    0x4(%rax),%eax
  8039a4:	48 63 d0             	movslq %eax,%rdx
  8039a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ab:	8b 00                	mov    (%rax),%eax
  8039ad:	48 98                	cltq   
  8039af:	48 83 c0 20          	add    $0x20,%rax
  8039b3:	48 39 c2             	cmp    %rax,%rdx
  8039b6:	73 b4                	jae    80396c <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bc:	8b 40 04             	mov    0x4(%rax),%eax
  8039bf:	99                   	cltd   
  8039c0:	c1 ea 1b             	shr    $0x1b,%edx
  8039c3:	01 d0                	add    %edx,%eax
  8039c5:	83 e0 1f             	and    $0x1f,%eax
  8039c8:	29 d0                	sub    %edx,%eax
  8039ca:	89 c6                	mov    %eax,%esi
  8039cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d4:	48 01 d0             	add    %rdx,%rax
  8039d7:	0f b6 08             	movzbl (%rax),%ecx
  8039da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039de:	48 63 c6             	movslq %esi,%rax
  8039e1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e9:	8b 40 04             	mov    0x4(%rax),%eax
  8039ec:	8d 50 01             	lea    0x1(%rax),%edx
  8039ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f3:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8039f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a03:	0f 82 61 ff ff ff    	jb     80396a <devpipe_write+0x40>
	}

	return i;
  803a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a0d:	c9                   	leaveq 
  803a0e:	c3                   	retq   

0000000000803a0f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a0f:	55                   	push   %rbp
  803a10:	48 89 e5             	mov    %rsp,%rbp
  803a13:	48 83 ec 20          	sub    $0x20,%rsp
  803a17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a23:	48 89 c7             	mov    %rax,%rdi
  803a26:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3a:	48 be b8 48 80 00 00 	movabs $0x8048b8,%rsi
  803a41:	00 00 00 
  803a44:	48 89 c7             	mov    %rax,%rdi
  803a47:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a57:	8b 50 04             	mov    0x4(%rax),%edx
  803a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5e:	8b 00                	mov    (%rax),%eax
  803a60:	29 c2                	sub    %eax,%edx
  803a62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a66:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a70:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a77:	00 00 00 
	stat->st_dev = &devpipe;
  803a7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7e:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a85:	00 00 00 
  803a88:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a94:	c9                   	leaveq 
  803a95:	c3                   	retq   

0000000000803a96 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a96:	55                   	push   %rbp
  803a97:	48 89 e5             	mov    %rsp,%rbp
  803a9a:	48 83 ec 10          	sub    $0x10,%rsp
  803a9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803aa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa6:	48 89 c6             	mov    %rax,%rsi
  803aa9:	bf 00 00 00 00       	mov    $0x0,%edi
  803aae:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803aba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abe:	48 89 c7             	mov    %rax,%rdi
  803ac1:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
  803acd:	48 89 c6             	mov    %rax,%rsi
  803ad0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad5:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
}
  803ae1:	c9                   	leaveq 
  803ae2:	c3                   	retq   

0000000000803ae3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ae3:	55                   	push   %rbp
  803ae4:	48 89 e5             	mov    %rsp,%rbp
  803ae7:	48 83 ec 20          	sub    $0x20,%rsp
  803aeb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803aee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803af4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803af8:	be 01 00 00 00       	mov    $0x1,%esi
  803afd:	48 89 c7             	mov    %rax,%rdi
  803b00:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  803b07:	00 00 00 
  803b0a:	ff d0                	callq  *%rax
}
  803b0c:	c9                   	leaveq 
  803b0d:	c3                   	retq   

0000000000803b0e <getchar>:

int
getchar(void)
{
  803b0e:	55                   	push   %rbp
  803b0f:	48 89 e5             	mov    %rsp,%rbp
  803b12:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b16:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b1a:	ba 01 00 00 00       	mov    $0x1,%edx
  803b1f:	48 89 c6             	mov    %rax,%rsi
  803b22:	bf 00 00 00 00       	mov    $0x0,%edi
  803b27:	48 b8 08 24 80 00 00 	movabs $0x802408,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3a:	79 05                	jns    803b41 <getchar+0x33>
		return r;
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	eb 14                	jmp    803b55 <getchar+0x47>
	if (r < 1)
  803b41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b45:	7f 07                	jg     803b4e <getchar+0x40>
		return -E_EOF;
  803b47:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b4c:	eb 07                	jmp    803b55 <getchar+0x47>
	return c;
  803b4e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b52:	0f b6 c0             	movzbl %al,%eax
}
  803b55:	c9                   	leaveq 
  803b56:	c3                   	retq   

0000000000803b57 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b57:	55                   	push   %rbp
  803b58:	48 89 e5             	mov    %rsp,%rbp
  803b5b:	48 83 ec 20          	sub    $0x20,%rsp
  803b5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b69:	48 89 d6             	mov    %rdx,%rsi
  803b6c:	89 c7                	mov    %eax,%edi
  803b6e:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
  803b7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b81:	79 05                	jns    803b88 <iscons+0x31>
		return r;
  803b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b86:	eb 1a                	jmp    803ba2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8c:	8b 10                	mov    (%rax),%edx
  803b8e:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b95:	00 00 00 
  803b98:	8b 00                	mov    (%rax),%eax
  803b9a:	39 c2                	cmp    %eax,%edx
  803b9c:	0f 94 c0             	sete   %al
  803b9f:	0f b6 c0             	movzbl %al,%eax
}
  803ba2:	c9                   	leaveq 
  803ba3:	c3                   	retq   

0000000000803ba4 <opencons>:

int
opencons(void)
{
  803ba4:	55                   	push   %rbp
  803ba5:	48 89 e5             	mov    %rsp,%rbp
  803ba8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803bac:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bb0:	48 89 c7             	mov    %rax,%rdi
  803bb3:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
  803bbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc6:	79 05                	jns    803bcd <opencons+0x29>
		return r;
  803bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcb:	eb 5b                	jmp    803c28 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd1:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd6:	48 89 c6             	mov    %rax,%rsi
  803bd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803bde:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  803be5:	00 00 00 
  803be8:	ff d0                	callq  *%rax
  803bea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf1:	79 05                	jns    803bf8 <opencons+0x54>
		return r;
  803bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf6:	eb 30                	jmp    803c28 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfc:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c03:	00 00 00 
  803c06:	8b 12                	mov    (%rdx),%edx
  803c08:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c19:	48 89 c7             	mov    %rax,%rdi
  803c1c:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
}
  803c28:	c9                   	leaveq 
  803c29:	c3                   	retq   

0000000000803c2a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c2a:	55                   	push   %rbp
  803c2b:	48 89 e5             	mov    %rsp,%rbp
  803c2e:	48 83 ec 30          	sub    $0x30,%rsp
  803c32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c36:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c3a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c3e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c43:	75 07                	jne    803c4c <devcons_read+0x22>
		return 0;
  803c45:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4a:	eb 4b                	jmp    803c97 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c4c:	eb 0c                	jmp    803c5a <devcons_read+0x30>
		sys_yield();
  803c4e:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803c5a:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  803c61:	00 00 00 
  803c64:	ff d0                	callq  *%rax
  803c66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6d:	74 df                	je     803c4e <devcons_read+0x24>
	if (c < 0)
  803c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c73:	79 05                	jns    803c7a <devcons_read+0x50>
		return c;
  803c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c78:	eb 1d                	jmp    803c97 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c7e:	75 07                	jne    803c87 <devcons_read+0x5d>
		return 0;
  803c80:	b8 00 00 00 00       	mov    $0x0,%eax
  803c85:	eb 10                	jmp    803c97 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8a:	89 c2                	mov    %eax,%edx
  803c8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c90:	88 10                	mov    %dl,(%rax)
	return 1;
  803c92:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c97:	c9                   	leaveq 
  803c98:	c3                   	retq   

0000000000803c99 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c99:	55                   	push   %rbp
  803c9a:	48 89 e5             	mov    %rsp,%rbp
  803c9d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ca4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803cab:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803cb2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cc0:	eb 76                	jmp    803d38 <devcons_write+0x9f>
		m = n - tot;
  803cc2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803cc9:	89 c2                	mov    %eax,%edx
  803ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cce:	29 c2                	sub    %eax,%edx
  803cd0:	89 d0                	mov    %edx,%eax
  803cd2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd8:	83 f8 7f             	cmp    $0x7f,%eax
  803cdb:	76 07                	jbe    803ce4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803cdd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ce4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ce7:	48 63 d0             	movslq %eax,%rdx
  803cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ced:	48 63 c8             	movslq %eax,%rcx
  803cf0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cf7:	48 01 c1             	add    %rax,%rcx
  803cfa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d01:	48 89 ce             	mov    %rcx,%rsi
  803d04:	48 89 c7             	mov    %rax,%rdi
  803d07:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d16:	48 63 d0             	movslq %eax,%rdx
  803d19:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d20:	48 89 d6             	mov    %rdx,%rsi
  803d23:	48 89 c7             	mov    %rax,%rdi
  803d26:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  803d2d:	00 00 00 
  803d30:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d35:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3b:	48 98                	cltq   
  803d3d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d44:	0f 82 78 ff ff ff    	jb     803cc2 <devcons_write+0x29>
	}
	return tot;
  803d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d4d:	c9                   	leaveq 
  803d4e:	c3                   	retq   

0000000000803d4f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d4f:	55                   	push   %rbp
  803d50:	48 89 e5             	mov    %rsp,%rbp
  803d53:	48 83 ec 08          	sub    $0x8,%rsp
  803d57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d60:	c9                   	leaveq 
  803d61:	c3                   	retq   

0000000000803d62 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d62:	55                   	push   %rbp
  803d63:	48 89 e5             	mov    %rsp,%rbp
  803d66:	48 83 ec 10          	sub    $0x10,%rsp
  803d6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d76:	48 be c4 48 80 00 00 	movabs $0x8048c4,%rsi
  803d7d:	00 00 00 
  803d80:	48 89 c7             	mov    %rax,%rdi
  803d83:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
	return 0;
  803d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d94:	c9                   	leaveq 
  803d95:	c3                   	retq   

0000000000803d96 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d96:	55                   	push   %rbp
  803d97:	48 89 e5             	mov    %rsp,%rbp
  803d9a:	48 83 ec 20          	sub    $0x20,%rsp
  803d9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803da2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803da6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803daa:	48 ba d0 48 80 00 00 	movabs $0x8048d0,%rdx
  803db1:	00 00 00 
  803db4:	be 1d 00 00 00       	mov    $0x1d,%esi
  803db9:	48 bf e9 48 80 00 00 	movabs $0x8048e9,%rdi
  803dc0:	00 00 00 
  803dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc8:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  803dcf:	00 00 00 
  803dd2:	ff d1                	callq  *%rcx

0000000000803dd4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803dd4:	55                   	push   %rbp
  803dd5:	48 89 e5             	mov    %rsp,%rbp
  803dd8:	48 83 ec 20          	sub    $0x20,%rsp
  803ddc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ddf:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803de2:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803de6:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803de9:	48 ba f3 48 80 00 00 	movabs $0x8048f3,%rdx
  803df0:	00 00 00 
  803df3:	be 2d 00 00 00       	mov    $0x2d,%esi
  803df8:	48 bf e9 48 80 00 00 	movabs $0x8048e9,%rdi
  803dff:	00 00 00 
  803e02:	b8 00 00 00 00       	mov    $0x0,%eax
  803e07:	48 b9 a6 03 80 00 00 	movabs $0x8003a6,%rcx
  803e0e:	00 00 00 
  803e11:	ff d1                	callq  *%rcx

0000000000803e13 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803e13:	55                   	push   %rbp
  803e14:	48 89 e5             	mov    %rsp,%rbp
  803e17:	53                   	push   %rbx
  803e18:	48 83 ec 48          	sub    $0x48,%rsp
  803e1c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803e20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803e27:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803e2e:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803e33:	75 0e                	jne    803e43 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803e35:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e3c:	00 00 00 
  803e3f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803e43:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803e47:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803e4b:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803e52:	00 
	a3 = (uint64_t) 0;
  803e53:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803e5a:	00 
	a4 = (uint64_t) 0;
  803e5b:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803e62:	00 
	a5 = 0;
  803e63:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803e6a:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803e6b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e6e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e72:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803e76:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803e7a:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803e7e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803e82:	4c 89 c3             	mov    %r8,%rbx
  803e85:	0f 01 c1             	vmcall 
  803e88:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803e8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e8f:	7e 36                	jle    803ec7 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803e91:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e94:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e97:	41 89 d0             	mov    %edx,%r8d
  803e9a:	89 c1                	mov    %eax,%ecx
  803e9c:	48 ba 10 49 80 00 00 	movabs $0x804910,%rdx
  803ea3:	00 00 00 
  803ea6:	be 54 00 00 00       	mov    $0x54,%esi
  803eab:	48 bf e9 48 80 00 00 	movabs $0x8048e9,%rdi
  803eb2:	00 00 00 
  803eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eba:	49 b9 a6 03 80 00 00 	movabs $0x8003a6,%r9
  803ec1:	00 00 00 
  803ec4:	41 ff d1             	callq  *%r9
	return ret;
  803ec7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803eca:	48 83 c4 48          	add    $0x48,%rsp
  803ece:	5b                   	pop    %rbx
  803ecf:	5d                   	pop    %rbp
  803ed0:	c3                   	retq   

0000000000803ed1 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ed1:	55                   	push   %rbp
  803ed2:	48 89 e5             	mov    %rsp,%rbp
  803ed5:	53                   	push   %rbx
  803ed6:	48 83 ec 58          	sub    $0x58,%rsp
  803eda:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803edd:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803ee0:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803ee4:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803ee7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803eee:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803ef5:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803efa:	75 0e                	jne    803f0a <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803efc:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803f03:	00 00 00 
  803f06:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803f0a:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803f0d:	48 98                	cltq   
  803f0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803f13:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803f16:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803f1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f1e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803f22:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803f25:	48 98                	cltq   
  803f27:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803f2b:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803f32:	00 

	int r = -E_IPC_NOT_RECV;
  803f33:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803f3a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803f3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f41:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f45:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803f49:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803f4d:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803f51:	4c 89 c3             	mov    %r8,%rbx
  803f54:	0f 01 c1             	vmcall 
  803f57:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803f5a:	48 83 c4 58          	add    $0x58,%rsp
  803f5e:	5b                   	pop    %rbx
  803f5f:	5d                   	pop    %rbp
  803f60:	c3                   	retq   

0000000000803f61 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f61:	55                   	push   %rbp
  803f62:	48 89 e5             	mov    %rsp,%rbp
  803f65:	48 83 ec 18          	sub    $0x18,%rsp
  803f69:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f73:	eb 4e                	jmp    803fc3 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803f75:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f7c:	00 00 00 
  803f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f82:	48 98                	cltq   
  803f84:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f8b:	48 01 d0             	add    %rdx,%rax
  803f8e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f94:	8b 00                	mov    (%rax),%eax
  803f96:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f99:	75 24                	jne    803fbf <ipc_find_env+0x5e>
			return envs[i].env_id;
  803f9b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803fa2:	00 00 00 
  803fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa8:	48 98                	cltq   
  803faa:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803fb1:	48 01 d0             	add    %rdx,%rax
  803fb4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803fba:	8b 40 08             	mov    0x8(%rax),%eax
  803fbd:	eb 12                	jmp    803fd1 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803fbf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803fc3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803fca:	7e a9                	jle    803f75 <ipc_find_env+0x14>
	}
	return 0;
  803fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fd1:	c9                   	leaveq 
  803fd2:	c3                   	retq   

0000000000803fd3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803fd3:	55                   	push   %rbp
  803fd4:	48 89 e5             	mov    %rsp,%rbp
  803fd7:	48 83 ec 18          	sub    $0x18,%rsp
  803fdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fe3:	48 c1 e8 15          	shr    $0x15,%rax
  803fe7:	48 89 c2             	mov    %rax,%rdx
  803fea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ff1:	01 00 00 
  803ff4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ff8:	83 e0 01             	and    $0x1,%eax
  803ffb:	48 85 c0             	test   %rax,%rax
  803ffe:	75 07                	jne    804007 <pageref+0x34>
		return 0;
  804000:	b8 00 00 00 00       	mov    $0x0,%eax
  804005:	eb 53                	jmp    80405a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80400b:	48 c1 e8 0c          	shr    $0xc,%rax
  80400f:	48 89 c2             	mov    %rax,%rdx
  804012:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804019:	01 00 00 
  80401c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804020:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804028:	83 e0 01             	and    $0x1,%eax
  80402b:	48 85 c0             	test   %rax,%rax
  80402e:	75 07                	jne    804037 <pageref+0x64>
		return 0;
  804030:	b8 00 00 00 00       	mov    $0x0,%eax
  804035:	eb 23                	jmp    80405a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80403b:	48 c1 e8 0c          	shr    $0xc,%rax
  80403f:	48 89 c2             	mov    %rax,%rdx
  804042:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804049:	00 00 00 
  80404c:	48 c1 e2 04          	shl    $0x4,%rdx
  804050:	48 01 d0             	add    %rdx,%rax
  804053:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804057:	0f b7 c0             	movzwl %ax,%eax
}
  80405a:	c9                   	leaveq 
  80405b:	c3                   	retq   
