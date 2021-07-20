
vmm/guest/obj/user/primespipe:     formato del fichero elf64-x86-64


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
  80003c:	e8 d4 03 00 00       	callq  800415 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 cf 25 80 00 00 	movabs $0x8025cf,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 98 04 80 00 00 	movabs $0x800498,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf c1 41 80 00 00 	movabs $0x8041c1,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba d1 06 80 00 00 	movabs $0x8006d1,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba c5 41 80 00 00 	movabs $0x8041c5,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 98 04 80 00 00 	movabs $0x800498,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba ce 41 80 00 00 	movabs $0x8041ce,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 98 04 80 00 00 	movabs $0x800498,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 cf 25 80 00 00 	movabs $0x8025cf,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 50                	je     800228 <primeproc+0x1e5>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	48 83 ec 08          	sub    $0x8,%rsp
  8001f4:	52                   	push   %rdx
  8001f5:	41 89 f1             	mov    %esi,%r9d
  8001f8:	41 89 c8             	mov    %ecx,%r8d
  8001fb:	89 c1                	mov    %eax,%ecx
  8001fd:	48 ba d7 41 80 00 00 	movabs $0x8041d7,%rdx
  800204:	00 00 00 
  800207:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020c:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	49 ba 98 04 80 00 00 	movabs $0x800498,%r10
  800222:	00 00 00 
  800225:	41 ff d2             	callq  *%r10
		if (i%p)
  800228:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80022b:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022e:	99                   	cltd   
  80022f:	f7 f9                	idiv   %ecx
  800231:	89 d0                	mov    %edx,%eax
  800233:	85 c0                	test   %eax,%eax
  800235:	74 6e                	je     8002a5 <primeproc+0x262>
			if ((r=write(wfd, &i, 4)) != 4)
  800237:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  80023b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023e:	ba 04 00 00 00       	mov    $0x4,%edx
  800243:	48 89 ce             	mov    %rcx,%rsi
  800246:	89 c7                	mov    %eax,%edi
  800248:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  80024f:	00 00 00 
  800252:	ff d0                	callq  *%rax
  800254:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800257:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80025b:	74 48                	je     8002a5 <primeproc+0x262>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025d:	b8 00 00 00 00       	mov    $0x0,%eax
  800262:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800266:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80026a:	89 c1                	mov    %eax,%ecx
  80026c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800272:	41 89 c9             	mov    %ecx,%r9d
  800275:	41 89 d0             	mov    %edx,%r8d
  800278:	89 c1                	mov    %eax,%ecx
  80027a:	48 ba f3 41 80 00 00 	movabs $0x8041f3,%rdx
  800281:	00 00 00 
  800284:	be 2e 00 00 00       	mov    $0x2e,%esi
  800289:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	49 ba 98 04 80 00 00 	movabs $0x800498,%r10
  80029f:	00 00 00 
  8002a2:	41 ff d2             	callq  *%r10
	}
  8002a5:	e9 08 ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002aa <umain>:
}

void
umain(int argc, char **argv)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 83 ec 30          	sub    $0x30,%rsp
  8002b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8002b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002c0:	00 00 00 
  8002c3:	48 b9 0d 42 80 00 00 	movabs $0x80420d,%rcx
  8002ca:	00 00 00 
  8002cd:	48 89 08             	mov    %rcx,(%rax)

	if ((i=pipe(p)) < 0)
  8002d0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002e9:	85 c0                	test   %eax,%eax
  8002eb:	79 30                	jns    80031d <umain+0x73>
		panic("pipe: %e", i);
  8002ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f0:	89 c1                	mov    %eax,%ecx
  8002f2:	48 ba c5 41 80 00 00 	movabs $0x8041c5,%rdx
  8002f9:	00 00 00 
  8002fc:	be 3a 00 00 00       	mov    $0x3a,%esi
  800301:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  800308:	00 00 00 
  80030b:	b8 00 00 00 00       	mov    $0x0,%eax
  800310:	49 b8 98 04 80 00 00 	movabs $0x800498,%r8
  800317:	00 00 00 
  80031a:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031d:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
  800329:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80032c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800330:	79 30                	jns    800362 <umain+0xb8>
		panic("fork: %e", id);
  800332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800335:	89 c1                	mov    %eax,%ecx
  800337:	48 ba ce 41 80 00 00 	movabs $0x8041ce,%rdx
  80033e:	00 00 00 
  800341:	be 3e 00 00 00       	mov    $0x3e,%esi
  800346:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	49 b8 98 04 80 00 00 	movabs $0x800498,%r8
  80035c:	00 00 00 
  80035f:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800362:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800366:	75 22                	jne    80038a <umain+0xe0>
		close(p[1]);
  800368:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800379:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80037c:	89 c7                	mov    %eax,%edi
  80037e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax
	}

	close(p[0]);
  80038a:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80038d:	89 c7                	mov    %eax,%edi
  80038f:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  800396:	00 00 00 
  800399:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039b:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003a5:	48 8d 4d f4          	lea    -0xc(%rbp),%rcx
  8003a9:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ae:	48 89 ce             	mov    %rcx,%rsi
  8003b1:	89 c7                	mov    %eax,%edi
  8003b3:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  8003ba:	00 00 00 
  8003bd:	ff d0                	callq  *%rax
  8003bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003c2:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
  8003c6:	74 42                	je     80040a <umain+0x160>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8003d1:	0f 4e 45 f8          	cmovle -0x8(%rbp),%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003da:	41 89 d0             	mov    %edx,%r8d
  8003dd:	89 c1                	mov    %eax,%ecx
  8003df:	48 ba 18 42 80 00 00 	movabs $0x804218,%rdx
  8003e6:	00 00 00 
  8003e9:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ee:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  8003f5:	00 00 00 
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fd:	49 b9 98 04 80 00 00 	movabs $0x800498,%r9
  800404:	00 00 00 
  800407:	41 ff d1             	callq  *%r9
	for (i=2;; i++)
  80040a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80040d:	83 c0 01             	add    $0x1,%eax
  800410:	89 45 f4             	mov    %eax,-0xc(%rbp)
}
  800413:	eb 8d                	jmp    8003a2 <umain+0xf8>

0000000000800415 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
  800419:	48 83 ec 10          	sub    $0x10,%rsp
  80041d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800420:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800424:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80042b:	00 00 00 
  80042e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800435:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800439:	7e 14                	jle    80044f <libmain+0x3a>
		binaryname = argv[0];
  80043b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043f:	48 8b 10             	mov    (%rax),%rdx
  800442:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800449:	00 00 00 
  80044c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80044f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	48 89 d6             	mov    %rdx,%rsi
  800459:	89 c7                	mov    %eax,%edi
  80045b:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800467:	48 b8 75 04 80 00 00 	movabs $0x800475,%rax
  80046e:	00 00 00 
  800471:	ff d0                	callq  *%rax
}
  800473:	c9                   	leaveq 
  800474:	c3                   	retq   

0000000000800475 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800475:	55                   	push   %rbp
  800476:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800479:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  800480:	00 00 00 
  800483:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800485:	bf 00 00 00 00       	mov    $0x0,%edi
  80048a:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  800491:	00 00 00 
  800494:	ff d0                	callq  *%rax
}
  800496:	5d                   	pop    %rbp
  800497:	c3                   	retq   

0000000000800498 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800498:	55                   	push   %rbp
  800499:	48 89 e5             	mov    %rsp,%rbp
  80049c:	53                   	push   %rbx
  80049d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004a4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004ab:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004b1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004b8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004bf:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004c6:	84 c0                	test   %al,%al
  8004c8:	74 23                	je     8004ed <_panic+0x55>
  8004ca:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004d1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004d5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004d9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004dd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8004e1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8004e5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8004e9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8004ed:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004f4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004fb:	00 00 00 
  8004fe:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800505:	00 00 00 
  800508:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800513:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80051a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800521:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800528:	00 00 00 
  80052b:	48 8b 18             	mov    (%rax),%rbx
  80052e:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  800535:	00 00 00 
  800538:	ff d0                	callq  *%rax
  80053a:	89 c6                	mov    %eax,%esi
  80053c:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800542:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800549:	41 89 d0             	mov    %edx,%r8d
  80054c:	48 89 c1             	mov    %rax,%rcx
  80054f:	48 89 da             	mov    %rbx,%rdx
  800552:	48 bf 40 42 80 00 00 	movabs $0x804240,%rdi
  800559:	00 00 00 
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	49 b9 d1 06 80 00 00 	movabs $0x8006d1,%r9
  800568:	00 00 00 
  80056b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80056e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800575:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80057c:	48 89 d6             	mov    %rdx,%rsi
  80057f:	48 89 c7             	mov    %rax,%rdi
  800582:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800589:	00 00 00 
  80058c:	ff d0                	callq  *%rax
	cprintf("\n");
  80058e:	48 bf 63 42 80 00 00 	movabs $0x804263,%rdi
  800595:	00 00 00 
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	48 ba d1 06 80 00 00 	movabs $0x8006d1,%rdx
  8005a4:	00 00 00 
  8005a7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005a9:	cc                   	int3   
  8005aa:	eb fd                	jmp    8005a9 <_panic+0x111>

00000000008005ac <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005ac:	55                   	push   %rbp
  8005ad:	48 89 e5             	mov    %rsp,%rbp
  8005b0:	48 83 ec 10          	sub    $0x10,%rsp
  8005b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005bf:	8b 00                	mov    (%rax),%eax
  8005c1:	8d 48 01             	lea    0x1(%rax),%ecx
  8005c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005c8:	89 0a                	mov    %ecx,(%rdx)
  8005ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005cd:	89 d1                	mov    %edx,%ecx
  8005cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005d3:	48 98                	cltq   
  8005d5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8005d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005dd:	8b 00                	mov    (%rax),%eax
  8005df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e4:	75 2c                	jne    800612 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8005e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ea:	8b 00                	mov    (%rax),%eax
  8005ec:	48 98                	cltq   
  8005ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f2:	48 83 c2 08          	add    $0x8,%rdx
  8005f6:	48 89 c6             	mov    %rax,%rsi
  8005f9:	48 89 d7             	mov    %rdx,%rdi
  8005fc:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  800603:	00 00 00 
  800606:	ff d0                	callq  *%rax
        b->idx = 0;
  800608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800616:	8b 40 04             	mov    0x4(%rax),%eax
  800619:	8d 50 01             	lea    0x1(%rax),%edx
  80061c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800620:	89 50 04             	mov    %edx,0x4(%rax)
}
  800623:	c9                   	leaveq 
  800624:	c3                   	retq   

0000000000800625 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800625:	55                   	push   %rbp
  800626:	48 89 e5             	mov    %rsp,%rbp
  800629:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800630:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800637:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80063e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800645:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80064c:	48 8b 0a             	mov    (%rdx),%rcx
  80064f:	48 89 08             	mov    %rcx,(%rax)
  800652:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800656:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80065a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800662:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800669:	00 00 00 
    b.cnt = 0;
  80066c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800673:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800676:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80067d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800684:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80068b:	48 89 c6             	mov    %rax,%rsi
  80068e:	48 bf ac 05 80 00 00 	movabs $0x8005ac,%rdi
  800695:	00 00 00 
  800698:	48 b8 70 0a 80 00 00 	movabs $0x800a70,%rax
  80069f:	00 00 00 
  8006a2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006a4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006aa:	48 98                	cltq   
  8006ac:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006b3:	48 83 c2 08          	add    $0x8,%rdx
  8006b7:	48 89 c6             	mov    %rax,%rsi
  8006ba:	48 89 d7             	mov    %rdx,%rdi
  8006bd:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006cf:	c9                   	leaveq 
  8006d0:	c3                   	retq   

00000000008006d1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006d1:	55                   	push   %rbp
  8006d2:	48 89 e5             	mov    %rsp,%rbp
  8006d5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006dc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8006e3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8006ea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8006f1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006f8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006ff:	84 c0                	test   %al,%al
  800701:	74 20                	je     800723 <cprintf+0x52>
  800703:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800707:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80070b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80070f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800713:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800717:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80071b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80071f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800723:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80072a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800731:	00 00 00 
  800734:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80073b:	00 00 00 
  80073e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800742:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800749:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800750:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800757:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80075e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800765:	48 8b 0a             	mov    (%rdx),%rcx
  800768:	48 89 08             	mov    %rcx,(%rax)
  80076b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80076f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800773:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800777:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80077b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800782:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800789:	48 89 d6             	mov    %rdx,%rsi
  80078c:	48 89 c7             	mov    %rax,%rdi
  80078f:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800796:	00 00 00 
  800799:	ff d0                	callq  *%rax
  80079b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007a1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007a7:	c9                   	leaveq 
  8007a8:	c3                   	retq   

00000000008007a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a9:	55                   	push   %rbp
  8007aa:	48 89 e5             	mov    %rsp,%rbp
  8007ad:	48 83 ec 30          	sub    $0x30,%rsp
  8007b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8007b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8007b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8007bd:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8007c0:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8007c4:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007cb:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8007cf:	77 42                	ja     800813 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d1:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007d4:	8d 78 ff             	lea    -0x1(%rax),%edi
  8007d7:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	48 f7 f6             	div    %rsi
  8007e6:	49 89 c2             	mov    %rax,%r10
  8007e9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8007ec:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8007ef:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8007f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007f7:	41 89 c9             	mov    %ecx,%r9d
  8007fa:	41 89 f8             	mov    %edi,%r8d
  8007fd:	89 d1                	mov    %edx,%ecx
  8007ff:	4c 89 d2             	mov    %r10,%rdx
  800802:	48 89 c7             	mov    %rax,%rdi
  800805:	48 b8 a9 07 80 00 00 	movabs $0x8007a9,%rax
  80080c:	00 00 00 
  80080f:	ff d0                	callq  *%rax
  800811:	eb 1e                	jmp    800831 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800813:	eb 12                	jmp    800827 <printnum+0x7e>
			putch(padc, putdat);
  800815:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800819:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80081c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800820:	48 89 ce             	mov    %rcx,%rsi
  800823:	89 d7                	mov    %edx,%edi
  800825:	ff d0                	callq  *%rax
		while (--width > 0)
  800827:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80082b:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80082f:	7f e4                	jg     800815 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800831:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800838:	ba 00 00 00 00       	mov    $0x0,%edx
  80083d:	48 f7 f1             	div    %rcx
  800840:	48 b8 70 44 80 00 00 	movabs $0x804470,%rax
  800847:	00 00 00 
  80084a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80084e:	0f be d0             	movsbl %al,%edx
  800851:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800859:	48 89 ce             	mov    %rcx,%rsi
  80085c:	89 d7                	mov    %edx,%edi
  80085e:	ff d0                	callq  *%rax
}
  800860:	c9                   	leaveq 
  800861:	c3                   	retq   

0000000000800862 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	48 83 ec 20          	sub    $0x20,%rsp
  80086a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80086e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800871:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800875:	7e 4f                	jle    8008c6 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	83 f8 30             	cmp    $0x30,%eax
  800880:	73 24                	jae    8008a6 <getuint+0x44>
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088e:	8b 00                	mov    (%rax),%eax
  800890:	89 c0                	mov    %eax,%eax
  800892:	48 01 d0             	add    %rdx,%rax
  800895:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800899:	8b 12                	mov    (%rdx),%edx
  80089b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a2:	89 0a                	mov    %ecx,(%rdx)
  8008a4:	eb 14                	jmp    8008ba <getuint+0x58>
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008ae:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ba:	48 8b 00             	mov    (%rax),%rax
  8008bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c1:	e9 9d 00 00 00       	jmpq   800963 <getuint+0x101>
	else if (lflag)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008ca:	74 4c                	je     800918 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8008cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d0:	8b 00                	mov    (%rax),%eax
  8008d2:	83 f8 30             	cmp    $0x30,%eax
  8008d5:	73 24                	jae    8008fb <getuint+0x99>
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e3:	8b 00                	mov    (%rax),%eax
  8008e5:	89 c0                	mov    %eax,%eax
  8008e7:	48 01 d0             	add    %rdx,%rax
  8008ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ee:	8b 12                	mov    (%rdx),%edx
  8008f0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f7:	89 0a                	mov    %ecx,(%rdx)
  8008f9:	eb 14                	jmp    80090f <getuint+0xad>
  8008fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ff:	48 8b 40 08          	mov    0x8(%rax),%rax
  800903:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800907:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090f:	48 8b 00             	mov    (%rax),%rax
  800912:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800916:	eb 4b                	jmp    800963 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091c:	8b 00                	mov    (%rax),%eax
  80091e:	83 f8 30             	cmp    $0x30,%eax
  800921:	73 24                	jae    800947 <getuint+0xe5>
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092f:	8b 00                	mov    (%rax),%eax
  800931:	89 c0                	mov    %eax,%eax
  800933:	48 01 d0             	add    %rdx,%rax
  800936:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093a:	8b 12                	mov    (%rdx),%edx
  80093c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800943:	89 0a                	mov    %ecx,(%rdx)
  800945:	eb 14                	jmp    80095b <getuint+0xf9>
  800947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80094f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800953:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800957:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095b:	8b 00                	mov    (%rax),%eax
  80095d:	89 c0                	mov    %eax,%eax
  80095f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800967:	c9                   	leaveq 
  800968:	c3                   	retq   

0000000000800969 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800969:	55                   	push   %rbp
  80096a:	48 89 e5             	mov    %rsp,%rbp
  80096d:	48 83 ec 20          	sub    $0x20,%rsp
  800971:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800975:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800978:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80097c:	7e 4f                	jle    8009cd <getint+0x64>
		x=va_arg(*ap, long long);
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	8b 00                	mov    (%rax),%eax
  800984:	83 f8 30             	cmp    $0x30,%eax
  800987:	73 24                	jae    8009ad <getint+0x44>
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800995:	8b 00                	mov    (%rax),%eax
  800997:	89 c0                	mov    %eax,%eax
  800999:	48 01 d0             	add    %rdx,%rax
  80099c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a0:	8b 12                	mov    (%rdx),%edx
  8009a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a9:	89 0a                	mov    %ecx,(%rdx)
  8009ab:	eb 14                	jmp    8009c1 <getint+0x58>
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009b5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c1:	48 8b 00             	mov    (%rax),%rax
  8009c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c8:	e9 9d 00 00 00       	jmpq   800a6a <getint+0x101>
	else if (lflag)
  8009cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009d1:	74 4c                	je     800a1f <getint+0xb6>
		x=va_arg(*ap, long);
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	8b 00                	mov    (%rax),%eax
  8009d9:	83 f8 30             	cmp    $0x30,%eax
  8009dc:	73 24                	jae    800a02 <getint+0x99>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 01 d0             	add    %rdx,%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	8b 12                	mov    (%rdx),%edx
  8009f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 0a                	mov    %ecx,(%rdx)
  800a00:	eb 14                	jmp    800a16 <getint+0xad>
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a0a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a16:	48 8b 00             	mov    (%rax),%rax
  800a19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a1d:	eb 4b                	jmp    800a6a <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a23:	8b 00                	mov    (%rax),%eax
  800a25:	83 f8 30             	cmp    $0x30,%eax
  800a28:	73 24                	jae    800a4e <getint+0xe5>
  800a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a36:	8b 00                	mov    (%rax),%eax
  800a38:	89 c0                	mov    %eax,%eax
  800a3a:	48 01 d0             	add    %rdx,%rax
  800a3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a41:	8b 12                	mov    (%rdx),%edx
  800a43:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4a:	89 0a                	mov    %ecx,(%rdx)
  800a4c:	eb 14                	jmp    800a62 <getint+0xf9>
  800a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a52:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a56:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a62:	8b 00                	mov    (%rax),%eax
  800a64:	48 98                	cltq   
  800a66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a6e:	c9                   	leaveq 
  800a6f:	c3                   	retq   

0000000000800a70 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a70:	55                   	push   %rbp
  800a71:	48 89 e5             	mov    %rsp,%rbp
  800a74:	41 54                	push   %r12
  800a76:	53                   	push   %rbx
  800a77:	48 83 ec 60          	sub    $0x60,%rsp
  800a7b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a7f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a83:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a87:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a8b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a8f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a93:	48 8b 0a             	mov    (%rdx),%rcx
  800a96:	48 89 08             	mov    %rcx,(%rax)
  800a99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aa1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aa5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa9:	eb 17                	jmp    800ac2 <vprintfmt+0x52>
			if (ch == '\0')
  800aab:	85 db                	test   %ebx,%ebx
  800aad:	0f 84 c5 04 00 00    	je     800f78 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800ab3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abb:	48 89 d6             	mov    %rdx,%rsi
  800abe:	89 df                	mov    %ebx,%edi
  800ac0:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ac2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aca:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ace:	0f b6 00             	movzbl (%rax),%eax
  800ad1:	0f b6 d8             	movzbl %al,%ebx
  800ad4:	83 fb 25             	cmp    $0x25,%ebx
  800ad7:	75 d2                	jne    800aab <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800ad9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800add:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800ae4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aeb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800af2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800af9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800afd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b01:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b05:	0f b6 00             	movzbl (%rax),%eax
  800b08:	0f b6 d8             	movzbl %al,%ebx
  800b0b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b0e:	83 f8 55             	cmp    $0x55,%eax
  800b11:	0f 87 2e 04 00 00    	ja     800f45 <vprintfmt+0x4d5>
  800b17:	89 c0                	mov    %eax,%eax
  800b19:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b20:	00 
  800b21:	48 b8 98 44 80 00 00 	movabs $0x804498,%rax
  800b28:	00 00 00 
  800b2b:	48 01 d0             	add    %rdx,%rax
  800b2e:	48 8b 00             	mov    (%rax),%rax
  800b31:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b33:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b37:	eb c0                	jmp    800af9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b39:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b3d:	eb ba                	jmp    800af9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b3f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b46:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	c1 e0 02             	shl    $0x2,%eax
  800b4e:	01 d0                	add    %edx,%eax
  800b50:	01 c0                	add    %eax,%eax
  800b52:	01 d8                	add    %ebx,%eax
  800b54:	83 e8 30             	sub    $0x30,%eax
  800b57:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b5a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5e:	0f b6 00             	movzbl (%rax),%eax
  800b61:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b64:	83 fb 2f             	cmp    $0x2f,%ebx
  800b67:	7e 0c                	jle    800b75 <vprintfmt+0x105>
  800b69:	83 fb 39             	cmp    $0x39,%ebx
  800b6c:	7f 07                	jg     800b75 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800b6e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800b73:	eb d1                	jmp    800b46 <vprintfmt+0xd6>
			goto process_precision;
  800b75:	eb 50                	jmp    800bc7 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800b77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7a:	83 f8 30             	cmp    $0x30,%eax
  800b7d:	73 17                	jae    800b96 <vprintfmt+0x126>
  800b7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b86:	89 d2                	mov    %edx,%edx
  800b88:	48 01 d0             	add    %rdx,%rax
  800b8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8e:	83 c2 08             	add    $0x8,%edx
  800b91:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b94:	eb 0c                	jmp    800ba2 <vprintfmt+0x132>
  800b96:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b9a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b9e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba2:	8b 00                	mov    (%rax),%eax
  800ba4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ba7:	eb 1e                	jmp    800bc7 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800ba9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bad:	79 07                	jns    800bb6 <vprintfmt+0x146>
				width = 0;
  800baf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bb6:	e9 3e ff ff ff       	jmpq   800af9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800bbb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800bc2:	e9 32 ff ff ff       	jmpq   800af9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800bc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bcb:	79 0d                	jns    800bda <vprintfmt+0x16a>
				width = precision, precision = -1;
  800bcd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bd0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800bd3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800bda:	e9 1a ff ff ff       	jmpq   800af9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bdf:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800be3:	e9 11 ff ff ff       	jmpq   800af9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800be8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800beb:	83 f8 30             	cmp    $0x30,%eax
  800bee:	73 17                	jae    800c07 <vprintfmt+0x197>
  800bf0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf7:	89 d2                	mov    %edx,%edx
  800bf9:	48 01 d0             	add    %rdx,%rax
  800bfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bff:	83 c2 08             	add    $0x8,%edx
  800c02:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c05:	eb 0c                	jmp    800c13 <vprintfmt+0x1a3>
  800c07:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c0b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c13:	8b 10                	mov    (%rax),%edx
  800c15:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1d:	48 89 ce             	mov    %rcx,%rsi
  800c20:	89 d7                	mov    %edx,%edi
  800c22:	ff d0                	callq  *%rax
			break;
  800c24:	e9 4a 03 00 00       	jmpq   800f73 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2c:	83 f8 30             	cmp    $0x30,%eax
  800c2f:	73 17                	jae    800c48 <vprintfmt+0x1d8>
  800c31:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c35:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c38:	89 d2                	mov    %edx,%edx
  800c3a:	48 01 d0             	add    %rdx,%rax
  800c3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c40:	83 c2 08             	add    $0x8,%edx
  800c43:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c46:	eb 0c                	jmp    800c54 <vprintfmt+0x1e4>
  800c48:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c4c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c50:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c54:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c56:	85 db                	test   %ebx,%ebx
  800c58:	79 02                	jns    800c5c <vprintfmt+0x1ec>
				err = -err;
  800c5a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c5c:	83 fb 15             	cmp    $0x15,%ebx
  800c5f:	7f 16                	jg     800c77 <vprintfmt+0x207>
  800c61:	48 b8 c0 43 80 00 00 	movabs $0x8043c0,%rax
  800c68:	00 00 00 
  800c6b:	48 63 d3             	movslq %ebx,%rdx
  800c6e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c72:	4d 85 e4             	test   %r12,%r12
  800c75:	75 2e                	jne    800ca5 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800c77:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7f:	89 d9                	mov    %ebx,%ecx
  800c81:	48 ba 81 44 80 00 00 	movabs $0x804481,%rdx
  800c88:	00 00 00 
  800c8b:	48 89 c7             	mov    %rax,%rdi
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c93:	49 b8 81 0f 80 00 00 	movabs $0x800f81,%r8
  800c9a:	00 00 00 
  800c9d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ca0:	e9 ce 02 00 00       	jmpq   800f73 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800ca5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ca9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cad:	4c 89 e1             	mov    %r12,%rcx
  800cb0:	48 ba 8a 44 80 00 00 	movabs $0x80448a,%rdx
  800cb7:	00 00 00 
  800cba:	48 89 c7             	mov    %rax,%rdi
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	49 b8 81 0f 80 00 00 	movabs $0x800f81,%r8
  800cc9:	00 00 00 
  800ccc:	41 ff d0             	callq  *%r8
			break;
  800ccf:	e9 9f 02 00 00       	jmpq   800f73 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800cd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd7:	83 f8 30             	cmp    $0x30,%eax
  800cda:	73 17                	jae    800cf3 <vprintfmt+0x283>
  800cdc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce3:	89 d2                	mov    %edx,%edx
  800ce5:	48 01 d0             	add    %rdx,%rax
  800ce8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ceb:	83 c2 08             	add    $0x8,%edx
  800cee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf1:	eb 0c                	jmp    800cff <vprintfmt+0x28f>
  800cf3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cf7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cfb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cff:	4c 8b 20             	mov    (%rax),%r12
  800d02:	4d 85 e4             	test   %r12,%r12
  800d05:	75 0a                	jne    800d11 <vprintfmt+0x2a1>
				p = "(null)";
  800d07:	49 bc 8d 44 80 00 00 	movabs $0x80448d,%r12
  800d0e:	00 00 00 
			if (width > 0 && padc != '-')
  800d11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d15:	7e 3f                	jle    800d56 <vprintfmt+0x2e6>
  800d17:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d1b:	74 39                	je     800d56 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d20:	48 98                	cltq   
  800d22:	48 89 c6             	mov    %rax,%rsi
  800d25:	4c 89 e7             	mov    %r12,%rdi
  800d28:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  800d2f:	00 00 00 
  800d32:	ff d0                	callq  *%rax
  800d34:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d37:	eb 17                	jmp    800d50 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800d39:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d3d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d45:	48 89 ce             	mov    %rcx,%rsi
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800d4c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d54:	7f e3                	jg     800d39 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d56:	eb 37                	jmp    800d8f <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800d58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d5c:	74 1e                	je     800d7c <vprintfmt+0x30c>
  800d5e:	83 fb 1f             	cmp    $0x1f,%ebx
  800d61:	7e 05                	jle    800d68 <vprintfmt+0x2f8>
  800d63:	83 fb 7e             	cmp    $0x7e,%ebx
  800d66:	7e 14                	jle    800d7c <vprintfmt+0x30c>
					putch('?', putdat);
  800d68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d70:	48 89 d6             	mov    %rdx,%rsi
  800d73:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d78:	ff d0                	callq  *%rax
  800d7a:	eb 0f                	jmp    800d8b <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800d7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d84:	48 89 d6             	mov    %rdx,%rsi
  800d87:	89 df                	mov    %ebx,%edi
  800d89:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d8f:	4c 89 e0             	mov    %r12,%rax
  800d92:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d96:	0f b6 00             	movzbl (%rax),%eax
  800d99:	0f be d8             	movsbl %al,%ebx
  800d9c:	85 db                	test   %ebx,%ebx
  800d9e:	74 10                	je     800db0 <vprintfmt+0x340>
  800da0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800da4:	78 b2                	js     800d58 <vprintfmt+0x2e8>
  800da6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800daa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dae:	79 a8                	jns    800d58 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800db0:	eb 16                	jmp    800dc8 <vprintfmt+0x358>
				putch(' ', putdat);
  800db2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dba:	48 89 d6             	mov    %rdx,%rsi
  800dbd:	bf 20 00 00 00       	mov    $0x20,%edi
  800dc2:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800dc4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dcc:	7f e4                	jg     800db2 <vprintfmt+0x342>
			break;
  800dce:	e9 a0 01 00 00       	jmpq   800f73 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800dd3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dd7:	be 03 00 00 00       	mov    $0x3,%esi
  800ddc:	48 89 c7             	mov    %rax,%rdi
  800ddf:	48 b8 69 09 80 00 00 	movabs $0x800969,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df3:	48 85 c0             	test   %rax,%rax
  800df6:	79 1d                	jns    800e15 <vprintfmt+0x3a5>
				putch('-', putdat);
  800df8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e00:	48 89 d6             	mov    %rdx,%rsi
  800e03:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e08:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0e:	48 f7 d8             	neg    %rax
  800e11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e15:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e1c:	e9 e5 00 00 00       	jmpq   800f06 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e25:	be 03 00 00 00       	mov    $0x3,%esi
  800e2a:	48 89 c7             	mov    %rax,%rdi
  800e2d:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800e34:	00 00 00 
  800e37:	ff d0                	callq  *%rax
  800e39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e3d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e44:	e9 bd 00 00 00       	jmpq   800f06 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e51:	48 89 d6             	mov    %rdx,%rsi
  800e54:	bf 58 00 00 00       	mov    $0x58,%edi
  800e59:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e63:	48 89 d6             	mov    %rdx,%rsi
  800e66:	bf 58 00 00 00       	mov    $0x58,%edi
  800e6b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e75:	48 89 d6             	mov    %rdx,%rsi
  800e78:	bf 58 00 00 00       	mov    $0x58,%edi
  800e7d:	ff d0                	callq  *%rax
			break;
  800e7f:	e9 ef 00 00 00       	jmpq   800f73 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800e84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8c:	48 89 d6             	mov    %rdx,%rsi
  800e8f:	bf 30 00 00 00       	mov    $0x30,%edi
  800e94:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9e:	48 89 d6             	mov    %rdx,%rsi
  800ea1:	bf 78 00 00 00       	mov    $0x78,%edi
  800ea6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ea8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eab:	83 f8 30             	cmp    $0x30,%eax
  800eae:	73 17                	jae    800ec7 <vprintfmt+0x457>
  800eb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eb7:	89 d2                	mov    %edx,%edx
  800eb9:	48 01 d0             	add    %rdx,%rax
  800ebc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ebf:	83 c2 08             	add    $0x8,%edx
  800ec2:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800ec5:	eb 0c                	jmp    800ed3 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800ec7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ecb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ecf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ed3:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800ed6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eda:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ee1:	eb 23                	jmp    800f06 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ee3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee7:	be 03 00 00 00       	mov    $0x3,%esi
  800eec:	48 89 c7             	mov    %rax,%rdi
  800eef:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800ef6:	00 00 00 
  800ef9:	ff d0                	callq  *%rax
  800efb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eff:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f06:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f0b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f0e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f15:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1d:	45 89 c1             	mov    %r8d,%r9d
  800f20:	41 89 f8             	mov    %edi,%r8d
  800f23:	48 89 c7             	mov    %rax,%rdi
  800f26:	48 b8 a9 07 80 00 00 	movabs $0x8007a9,%rax
  800f2d:	00 00 00 
  800f30:	ff d0                	callq  *%rax
			break;
  800f32:	eb 3f                	jmp    800f73 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3c:	48 89 d6             	mov    %rdx,%rsi
  800f3f:	89 df                	mov    %ebx,%edi
  800f41:	ff d0                	callq  *%rax
			break;
  800f43:	eb 2e                	jmp    800f73 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4d:	48 89 d6             	mov    %rdx,%rsi
  800f50:	bf 25 00 00 00       	mov    $0x25,%edi
  800f55:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f57:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f5c:	eb 05                	jmp    800f63 <vprintfmt+0x4f3>
  800f5e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f63:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f67:	48 83 e8 01          	sub    $0x1,%rax
  800f6b:	0f b6 00             	movzbl (%rax),%eax
  800f6e:	3c 25                	cmp    $0x25,%al
  800f70:	75 ec                	jne    800f5e <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800f72:	90                   	nop
		}
	}
  800f73:	e9 31 fb ff ff       	jmpq   800aa9 <vprintfmt+0x39>
	va_end(aq);
}
  800f78:	48 83 c4 60          	add    $0x60,%rsp
  800f7c:	5b                   	pop    %rbx
  800f7d:	41 5c                	pop    %r12
  800f7f:	5d                   	pop    %rbp
  800f80:	c3                   	retq   

0000000000800f81 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f81:	55                   	push   %rbp
  800f82:	48 89 e5             	mov    %rsp,%rbp
  800f85:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f8c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f93:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f9a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fa1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fa8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800faf:	84 c0                	test   %al,%al
  800fb1:	74 20                	je     800fd3 <printfmt+0x52>
  800fb3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fb7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fbb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fbf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fc3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fc7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fcb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fcf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fd3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fda:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fe1:	00 00 00 
  800fe4:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800feb:	00 00 00 
  800fee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ff2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ff9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801000:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801007:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80100e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801015:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80101c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801023:	48 89 c7             	mov    %rax,%rdi
  801026:	48 b8 70 0a 80 00 00 	movabs $0x800a70,%rax
  80102d:	00 00 00 
  801030:	ff d0                	callq  *%rax
	va_end(ap);
}
  801032:	c9                   	leaveq 
  801033:	c3                   	retq   

0000000000801034 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801034:	55                   	push   %rbp
  801035:	48 89 e5             	mov    %rsp,%rbp
  801038:	48 83 ec 10          	sub    $0x10,%rsp
  80103c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80103f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801047:	8b 40 10             	mov    0x10(%rax),%eax
  80104a:	8d 50 01             	lea    0x1(%rax),%edx
  80104d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801051:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801058:	48 8b 10             	mov    (%rax),%rdx
  80105b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801063:	48 39 c2             	cmp    %rax,%rdx
  801066:	73 17                	jae    80107f <sprintputch+0x4b>
		*b->buf++ = ch;
  801068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106c:	48 8b 00             	mov    (%rax),%rax
  80106f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801077:	48 89 0a             	mov    %rcx,(%rdx)
  80107a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80107d:	88 10                	mov    %dl,(%rax)
}
  80107f:	c9                   	leaveq 
  801080:	c3                   	retq   

0000000000801081 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801081:	55                   	push   %rbp
  801082:	48 89 e5             	mov    %rsp,%rbp
  801085:	48 83 ec 50          	sub    $0x50,%rsp
  801089:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80108d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801090:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801094:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801098:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80109c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010a0:	48 8b 0a             	mov    (%rdx),%rcx
  8010a3:	48 89 08             	mov    %rcx,(%rax)
  8010a6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010aa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010ae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010b2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010ba:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010be:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010c1:	48 98                	cltq   
  8010c3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010cb:	48 01 d0             	add    %rdx,%rax
  8010ce:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010d9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010de:	74 06                	je     8010e6 <vsnprintf+0x65>
  8010e0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010e4:	7f 07                	jg     8010ed <vsnprintf+0x6c>
		return -E_INVAL;
  8010e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010eb:	eb 2f                	jmp    80111c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010ed:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010f1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010f5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010f9:	48 89 c6             	mov    %rax,%rsi
  8010fc:	48 bf 34 10 80 00 00 	movabs $0x801034,%rdi
  801103:	00 00 00 
  801106:	48 b8 70 0a 80 00 00 	movabs $0x800a70,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801112:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801116:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801119:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80111c:	c9                   	leaveq 
  80111d:	c3                   	retq   

000000000080111e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80111e:	55                   	push   %rbp
  80111f:	48 89 e5             	mov    %rsp,%rbp
  801122:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801129:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801130:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801136:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80113d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801144:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80114b:	84 c0                	test   %al,%al
  80114d:	74 20                	je     80116f <snprintf+0x51>
  80114f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801153:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801157:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80115b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80115f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801163:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801167:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80116b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80116f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801176:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80117d:	00 00 00 
  801180:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801187:	00 00 00 
  80118a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80118e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801195:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80119c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011a3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011aa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011b1:	48 8b 0a             	mov    (%rdx),%rcx
  8011b4:	48 89 08             	mov    %rcx,(%rax)
  8011b7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011bb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011bf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011c3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011c7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011ce:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011d5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011db:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011e2:	48 89 c7             	mov    %rax,%rdi
  8011e5:	48 b8 81 10 80 00 00 	movabs $0x801081,%rax
  8011ec:	00 00 00 
  8011ef:	ff d0                	callq  *%rax
  8011f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011fd:	c9                   	leaveq 
  8011fe:	c3                   	retq   

00000000008011ff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011ff:	55                   	push   %rbp
  801200:	48 89 e5             	mov    %rsp,%rbp
  801203:	48 83 ec 18          	sub    $0x18,%rsp
  801207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801212:	eb 09                	jmp    80121d <strlen+0x1e>
		n++;
  801214:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801218:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801221:	0f b6 00             	movzbl (%rax),%eax
  801224:	84 c0                	test   %al,%al
  801226:	75 ec                	jne    801214 <strlen+0x15>
	return n;
  801228:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80122b:	c9                   	leaveq 
  80122c:	c3                   	retq   

000000000080122d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80122d:	55                   	push   %rbp
  80122e:	48 89 e5             	mov    %rsp,%rbp
  801231:	48 83 ec 20          	sub    $0x20,%rsp
  801235:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801239:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80123d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801244:	eb 0e                	jmp    801254 <strnlen+0x27>
		n++;
  801246:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80124a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80124f:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801254:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801259:	74 0b                	je     801266 <strnlen+0x39>
  80125b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	75 e0                	jne    801246 <strnlen+0x19>
	return n;
  801266:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801269:	c9                   	leaveq 
  80126a:	c3                   	retq   

000000000080126b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80126b:	55                   	push   %rbp
  80126c:	48 89 e5             	mov    %rsp,%rbp
  80126f:	48 83 ec 20          	sub    $0x20,%rsp
  801273:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801277:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80127b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801283:	90                   	nop
  801284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801288:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801290:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801294:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801298:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80129c:	0f b6 12             	movzbl (%rdx),%edx
  80129f:	88 10                	mov    %dl,(%rax)
  8012a1:	0f b6 00             	movzbl (%rax),%eax
  8012a4:	84 c0                	test   %al,%al
  8012a6:	75 dc                	jne    801284 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ac:	c9                   	leaveq 
  8012ad:	c3                   	retq   

00000000008012ae <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012ae:	55                   	push   %rbp
  8012af:	48 89 e5             	mov    %rsp,%rbp
  8012b2:	48 83 ec 20          	sub    $0x20,%rsp
  8012b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	48 89 c7             	mov    %rax,%rdi
  8012c5:	48 b8 ff 11 80 00 00 	movabs $0x8011ff,%rax
  8012cc:	00 00 00 
  8012cf:	ff d0                	callq  *%rax
  8012d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012d7:	48 63 d0             	movslq %eax,%rdx
  8012da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012de:	48 01 c2             	add    %rax,%rdx
  8012e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e5:	48 89 c6             	mov    %rax,%rsi
  8012e8:	48 89 d7             	mov    %rdx,%rdi
  8012eb:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  8012f2:	00 00 00 
  8012f5:	ff d0                	callq  *%rax
	return dst;
  8012f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012fb:	c9                   	leaveq 
  8012fc:	c3                   	retq   

00000000008012fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
  801301:	48 83 ec 28          	sub    $0x28,%rsp
  801305:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801309:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80130d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801319:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801320:	00 
  801321:	eb 2a                	jmp    80134d <strncpy+0x50>
		*dst++ = *src;
  801323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801327:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80132f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801333:	0f b6 12             	movzbl (%rdx),%edx
  801336:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801338:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133c:	0f b6 00             	movzbl (%rax),%eax
  80133f:	84 c0                	test   %al,%al
  801341:	74 05                	je     801348 <strncpy+0x4b>
			src++;
  801343:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801348:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801355:	72 cc                	jb     801323 <strncpy+0x26>
	}
	return ret;
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80135b:	c9                   	leaveq 
  80135c:	c3                   	retq   

000000000080135d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80135d:	55                   	push   %rbp
  80135e:	48 89 e5             	mov    %rsp,%rbp
  801361:	48 83 ec 28          	sub    $0x28,%rsp
  801365:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801369:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80136d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801375:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801379:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80137e:	74 3d                	je     8013bd <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801380:	eb 1d                	jmp    80139f <strlcpy+0x42>
			*dst++ = *src++;
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80138a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80138e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801392:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801396:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80139a:	0f b6 12             	movzbl (%rdx),%edx
  80139d:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80139f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013a4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013a9:	74 0b                	je     8013b6 <strlcpy+0x59>
  8013ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 cc                	jne    801382 <strlcpy+0x25>
		*dst = '\0';
  8013b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ba:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c5:	48 29 c2             	sub    %rax,%rdx
  8013c8:	48 89 d0             	mov    %rdx,%rax
}
  8013cb:	c9                   	leaveq 
  8013cc:	c3                   	retq   

00000000008013cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	48 83 ec 10          	sub    $0x10,%rsp
  8013d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013dd:	eb 0a                	jmp    8013e9 <strcmp+0x1c>
		p++, q++;
  8013df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8013e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ed:	0f b6 00             	movzbl (%rax),%eax
  8013f0:	84 c0                	test   %al,%al
  8013f2:	74 12                	je     801406 <strcmp+0x39>
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	0f b6 10             	movzbl (%rax),%edx
  8013fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	38 c2                	cmp    %al,%dl
  801404:	74 d9                	je     8013df <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	0f b6 d0             	movzbl %al,%edx
  801410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	29 c2                	sub    %eax,%edx
  80141c:	89 d0                	mov    %edx,%eax
}
  80141e:	c9                   	leaveq 
  80141f:	c3                   	retq   

0000000000801420 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801420:	55                   	push   %rbp
  801421:	48 89 e5             	mov    %rsp,%rbp
  801424:	48 83 ec 18          	sub    $0x18,%rsp
  801428:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801430:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801434:	eb 0f                	jmp    801445 <strncmp+0x25>
		n--, p++, q++;
  801436:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80143b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801440:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801445:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80144a:	74 1d                	je     801469 <strncmp+0x49>
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	84 c0                	test   %al,%al
  801455:	74 12                	je     801469 <strncmp+0x49>
  801457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145b:	0f b6 10             	movzbl (%rax),%edx
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	0f b6 00             	movzbl (%rax),%eax
  801465:	38 c2                	cmp    %al,%dl
  801467:	74 cd                	je     801436 <strncmp+0x16>
	if (n == 0)
  801469:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80146e:	75 07                	jne    801477 <strncmp+0x57>
		return 0;
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 18                	jmp    80148f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	0f b6 00             	movzbl (%rax),%eax
  80147e:	0f b6 d0             	movzbl %al,%edx
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	0f b6 c0             	movzbl %al,%eax
  80148b:	29 c2                	sub    %eax,%edx
  80148d:	89 d0                	mov    %edx,%eax
}
  80148f:	c9                   	leaveq 
  801490:	c3                   	retq   

0000000000801491 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801491:	55                   	push   %rbp
  801492:	48 89 e5             	mov    %rsp,%rbp
  801495:	48 83 ec 10          	sub    $0x10,%rsp
  801499:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149d:	89 f0                	mov    %esi,%eax
  80149f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014a2:	eb 17                	jmp    8014bb <strchr+0x2a>
		if (*s == c)
  8014a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a8:	0f b6 00             	movzbl (%rax),%eax
  8014ab:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014ae:	75 06                	jne    8014b6 <strchr+0x25>
			return (char *) s;
  8014b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b4:	eb 15                	jmp    8014cb <strchr+0x3a>
	for (; *s; s++)
  8014b6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	0f b6 00             	movzbl (%rax),%eax
  8014c2:	84 c0                	test   %al,%al
  8014c4:	75 de                	jne    8014a4 <strchr+0x13>
	return 0;
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cb:	c9                   	leaveq 
  8014cc:	c3                   	retq   

00000000008014cd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014cd:	55                   	push   %rbp
  8014ce:	48 89 e5             	mov    %rsp,%rbp
  8014d1:	48 83 ec 10          	sub    $0x10,%rsp
  8014d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d9:	89 f0                	mov    %esi,%eax
  8014db:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014de:	eb 13                	jmp    8014f3 <strfind+0x26>
		if (*s == c)
  8014e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e4:	0f b6 00             	movzbl (%rax),%eax
  8014e7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014ea:	75 02                	jne    8014ee <strfind+0x21>
			break;
  8014ec:	eb 10                	jmp    8014fe <strfind+0x31>
	for (; *s; s++)
  8014ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	84 c0                	test   %al,%al
  8014fc:	75 e2                	jne    8014e0 <strfind+0x13>
	return (char *) s;
  8014fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801502:	c9                   	leaveq 
  801503:	c3                   	retq   

0000000000801504 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	48 83 ec 18          	sub    $0x18,%rsp
  80150c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801510:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801513:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801517:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80151c:	75 06                	jne    801524 <memset+0x20>
		return v;
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801522:	eb 69                	jmp    80158d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801528:	83 e0 03             	and    $0x3,%eax
  80152b:	48 85 c0             	test   %rax,%rax
  80152e:	75 48                	jne    801578 <memset+0x74>
  801530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801534:	83 e0 03             	and    $0x3,%eax
  801537:	48 85 c0             	test   %rax,%rax
  80153a:	75 3c                	jne    801578 <memset+0x74>
		c &= 0xFF;
  80153c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801543:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801546:	c1 e0 18             	shl    $0x18,%eax
  801549:	89 c2                	mov    %eax,%edx
  80154b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80154e:	c1 e0 10             	shl    $0x10,%eax
  801551:	09 c2                	or     %eax,%edx
  801553:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801556:	c1 e0 08             	shl    $0x8,%eax
  801559:	09 d0                	or     %edx,%eax
  80155b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80155e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801562:	48 c1 e8 02          	shr    $0x2,%rax
  801566:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801569:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801570:	48 89 d7             	mov    %rdx,%rdi
  801573:	fc                   	cld    
  801574:	f3 ab                	rep stos %eax,%es:(%rdi)
  801576:	eb 11                	jmp    801589 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801578:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80157c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80157f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801583:	48 89 d7             	mov    %rdx,%rdi
  801586:	fc                   	cld    
  801587:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158d:	c9                   	leaveq 
  80158e:	c3                   	retq   

000000000080158f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80158f:	55                   	push   %rbp
  801590:	48 89 e5             	mov    %rsp,%rbp
  801593:	48 83 ec 28          	sub    $0x28,%rsp
  801597:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80159f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015bb:	0f 83 88 00 00 00    	jae    801649 <memmove+0xba>
  8015c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	48 01 d0             	add    %rdx,%rax
  8015cc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015d0:	76 77                	jbe    801649 <memmove+0xba>
		s += n;
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e6:	83 e0 03             	and    $0x3,%eax
  8015e9:	48 85 c0             	test   %rax,%rax
  8015ec:	75 3b                	jne    801629 <memmove+0x9a>
  8015ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f2:	83 e0 03             	and    $0x3,%eax
  8015f5:	48 85 c0             	test   %rax,%rax
  8015f8:	75 2f                	jne    801629 <memmove+0x9a>
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	83 e0 03             	and    $0x3,%eax
  801601:	48 85 c0             	test   %rax,%rax
  801604:	75 23                	jne    801629 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	48 83 e8 04          	sub    $0x4,%rax
  80160e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801612:	48 83 ea 04          	sub    $0x4,%rdx
  801616:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80161a:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80161e:	48 89 c7             	mov    %rax,%rdi
  801621:	48 89 d6             	mov    %rdx,%rsi
  801624:	fd                   	std    
  801625:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801627:	eb 1d                	jmp    801646 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	48 89 d7             	mov    %rdx,%rdi
  801640:	48 89 c1             	mov    %rax,%rcx
  801643:	fd                   	std    
  801644:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801646:	fc                   	cld    
  801647:	eb 57                	jmp    8016a0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164d:	83 e0 03             	and    $0x3,%eax
  801650:	48 85 c0             	test   %rax,%rax
  801653:	75 36                	jne    80168b <memmove+0xfc>
  801655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801659:	83 e0 03             	and    $0x3,%eax
  80165c:	48 85 c0             	test   %rax,%rax
  80165f:	75 2a                	jne    80168b <memmove+0xfc>
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	83 e0 03             	and    $0x3,%eax
  801668:	48 85 c0             	test   %rax,%rax
  80166b:	75 1e                	jne    80168b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	48 c1 e8 02          	shr    $0x2,%rax
  801675:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801680:	48 89 c7             	mov    %rax,%rdi
  801683:	48 89 d6             	mov    %rdx,%rsi
  801686:	fc                   	cld    
  801687:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801689:	eb 15                	jmp    8016a0 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80168b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801693:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801697:	48 89 c7             	mov    %rax,%rdi
  80169a:	48 89 d6             	mov    %rdx,%rsi
  80169d:	fc                   	cld    
  80169e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016a4:	c9                   	leaveq 
  8016a5:	c3                   	retq   

00000000008016a6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016a6:	55                   	push   %rbp
  8016a7:	48 89 e5             	mov    %rsp,%rbp
  8016aa:	48 83 ec 18          	sub    $0x18,%rsp
  8016ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016be:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c6:	48 89 ce             	mov    %rcx,%rsi
  8016c9:	48 89 c7             	mov    %rax,%rdi
  8016cc:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8016d3:	00 00 00 
  8016d6:	ff d0                	callq  *%rax
}
  8016d8:	c9                   	leaveq 
  8016d9:	c3                   	retq   

00000000008016da <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016da:	55                   	push   %rbp
  8016db:	48 89 e5             	mov    %rsp,%rbp
  8016de:	48 83 ec 28          	sub    $0x28,%rsp
  8016e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016fe:	eb 36                	jmp    801736 <memcmp+0x5c>
		if (*s1 != *s2)
  801700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801704:	0f b6 10             	movzbl (%rax),%edx
  801707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170b:	0f b6 00             	movzbl (%rax),%eax
  80170e:	38 c2                	cmp    %al,%dl
  801710:	74 1a                	je     80172c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801712:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	0f b6 c0             	movzbl %al,%eax
  801726:	29 c2                	sub    %eax,%edx
  801728:	89 d0                	mov    %edx,%eax
  80172a:	eb 20                	jmp    80174c <memcmp+0x72>
		s1++, s2++;
  80172c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801731:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80173e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801742:	48 85 c0             	test   %rax,%rax
  801745:	75 b9                	jne    801700 <memcmp+0x26>
	}

	return 0;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174c:	c9                   	leaveq 
  80174d:	c3                   	retq   

000000000080174e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80174e:	55                   	push   %rbp
  80174f:	48 89 e5             	mov    %rsp,%rbp
  801752:	48 83 ec 28          	sub    $0x28,%rsp
  801756:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80175a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80175d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801761:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801769:	48 01 d0             	add    %rdx,%rax
  80176c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801770:	eb 15                	jmp    801787 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801776:	0f b6 00             	movzbl (%rax),%eax
  801779:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80177c:	38 d0                	cmp    %dl,%al
  80177e:	75 02                	jne    801782 <memfind+0x34>
			break;
  801780:	eb 0f                	jmp    801791 <memfind+0x43>
	for (; s < ends; s++)
  801782:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80178f:	72 e1                	jb     801772 <memfind+0x24>
	return (void *) s;
  801791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801795:	c9                   	leaveq 
  801796:	c3                   	retq   

0000000000801797 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801797:	55                   	push   %rbp
  801798:	48 89 e5             	mov    %rsp,%rbp
  80179b:	48 83 ec 38          	sub    $0x38,%rsp
  80179f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017a7:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017b1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017b8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b9:	eb 05                	jmp    8017c0 <strtol+0x29>
		s++;
  8017bb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	3c 20                	cmp    $0x20,%al
  8017c9:	74 f0                	je     8017bb <strtol+0x24>
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	3c 09                	cmp    $0x9,%al
  8017d4:	74 e5                	je     8017bb <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	3c 2b                	cmp    $0x2b,%al
  8017df:	75 07                	jne    8017e8 <strtol+0x51>
		s++;
  8017e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e6:	eb 17                	jmp    8017ff <strtol+0x68>
	else if (*s == '-')
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	3c 2d                	cmp    $0x2d,%al
  8017f1:	75 0c                	jne    8017ff <strtol+0x68>
		s++, neg = 1;
  8017f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801803:	74 06                	je     80180b <strtol+0x74>
  801805:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801809:	75 28                	jne    801833 <strtol+0x9c>
  80180b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	3c 30                	cmp    $0x30,%al
  801814:	75 1d                	jne    801833 <strtol+0x9c>
  801816:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181a:	48 83 c0 01          	add    $0x1,%rax
  80181e:	0f b6 00             	movzbl (%rax),%eax
  801821:	3c 78                	cmp    $0x78,%al
  801823:	75 0e                	jne    801833 <strtol+0x9c>
		s += 2, base = 16;
  801825:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80182a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801831:	eb 2c                	jmp    80185f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801833:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801837:	75 19                	jne    801852 <strtol+0xbb>
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	0f b6 00             	movzbl (%rax),%eax
  801840:	3c 30                	cmp    $0x30,%al
  801842:	75 0e                	jne    801852 <strtol+0xbb>
		s++, base = 8;
  801844:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801849:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801850:	eb 0d                	jmp    80185f <strtol+0xc8>
	else if (base == 0)
  801852:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801856:	75 07                	jne    80185f <strtol+0xc8>
		base = 10;
  801858:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80185f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801863:	0f b6 00             	movzbl (%rax),%eax
  801866:	3c 2f                	cmp    $0x2f,%al
  801868:	7e 1d                	jle    801887 <strtol+0xf0>
  80186a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186e:	0f b6 00             	movzbl (%rax),%eax
  801871:	3c 39                	cmp    $0x39,%al
  801873:	7f 12                	jg     801887 <strtol+0xf0>
			dig = *s - '0';
  801875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801879:	0f b6 00             	movzbl (%rax),%eax
  80187c:	0f be c0             	movsbl %al,%eax
  80187f:	83 e8 30             	sub    $0x30,%eax
  801882:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801885:	eb 4e                	jmp    8018d5 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188b:	0f b6 00             	movzbl (%rax),%eax
  80188e:	3c 60                	cmp    $0x60,%al
  801890:	7e 1d                	jle    8018af <strtol+0x118>
  801892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801896:	0f b6 00             	movzbl (%rax),%eax
  801899:	3c 7a                	cmp    $0x7a,%al
  80189b:	7f 12                	jg     8018af <strtol+0x118>
			dig = *s - 'a' + 10;
  80189d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a1:	0f b6 00             	movzbl (%rax),%eax
  8018a4:	0f be c0             	movsbl %al,%eax
  8018a7:	83 e8 57             	sub    $0x57,%eax
  8018aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018ad:	eb 26                	jmp    8018d5 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b3:	0f b6 00             	movzbl (%rax),%eax
  8018b6:	3c 40                	cmp    $0x40,%al
  8018b8:	7e 48                	jle    801902 <strtol+0x16b>
  8018ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	3c 5a                	cmp    $0x5a,%al
  8018c3:	7f 3d                	jg     801902 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8018c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	0f be c0             	movsbl %al,%eax
  8018cf:	83 e8 37             	sub    $0x37,%eax
  8018d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018d8:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018db:	7c 02                	jl     8018df <strtol+0x148>
			break;
  8018dd:	eb 23                	jmp    801902 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018e4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018e7:	48 98                	cltq   
  8018e9:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018ee:	48 89 c2             	mov    %rax,%rdx
  8018f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018f4:	48 98                	cltq   
  8018f6:	48 01 d0             	add    %rdx,%rax
  8018f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018fd:	e9 5d ff ff ff       	jmpq   80185f <strtol+0xc8>

	if (endptr)
  801902:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801907:	74 0b                	je     801914 <strtol+0x17d>
		*endptr = (char *) s;
  801909:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80190d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801911:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801918:	74 09                	je     801923 <strtol+0x18c>
  80191a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191e:	48 f7 d8             	neg    %rax
  801921:	eb 04                	jmp    801927 <strtol+0x190>
  801923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801927:	c9                   	leaveq 
  801928:	c3                   	retq   

0000000000801929 <strstr>:

char * strstr(const char *in, const char *str)
{
  801929:	55                   	push   %rbp
  80192a:	48 89 e5             	mov    %rsp,%rbp
  80192d:	48 83 ec 30          	sub    $0x30,%rsp
  801931:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801935:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801939:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80193d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801941:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801945:	0f b6 00             	movzbl (%rax),%eax
  801948:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80194b:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80194f:	75 06                	jne    801957 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	eb 6b                	jmp    8019c2 <strstr+0x99>

	len = strlen(str);
  801957:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80195b:	48 89 c7             	mov    %rax,%rdi
  80195e:	48 b8 ff 11 80 00 00 	movabs $0x8011ff,%rax
  801965:	00 00 00 
  801968:	ff d0                	callq  *%rax
  80196a:	48 98                	cltq   
  80196c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801974:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801978:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80197c:	0f b6 00             	movzbl (%rax),%eax
  80197f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801982:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801986:	75 07                	jne    80198f <strstr+0x66>
				return (char *) 0;
  801988:	b8 00 00 00 00       	mov    $0x0,%eax
  80198d:	eb 33                	jmp    8019c2 <strstr+0x99>
		} while (sc != c);
  80198f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801993:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801996:	75 d8                	jne    801970 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a4:	48 89 ce             	mov    %rcx,%rsi
  8019a7:	48 89 c7             	mov    %rax,%rdi
  8019aa:	48 b8 20 14 80 00 00 	movabs $0x801420,%rax
  8019b1:	00 00 00 
  8019b4:	ff d0                	callq  *%rax
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	75 b6                	jne    801970 <strstr+0x47>

	return (char *) (in - 1);
  8019ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019be:	48 83 e8 01          	sub    $0x1,%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	53                   	push   %rbx
  8019c9:	48 83 ec 48          	sub    $0x48,%rsp
  8019cd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019d0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019d3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019d7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019db:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019df:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019ea:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019ee:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019f2:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019f6:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019fa:	4c 89 c3             	mov    %r8,%rbx
  8019fd:	cd 30                	int    $0x30
  8019ff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a03:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a07:	74 3e                	je     801a47 <syscall+0x83>
  801a09:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a0e:	7e 37                	jle    801a47 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a14:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a17:	49 89 d0             	mov    %rdx,%r8
  801a1a:	89 c1                	mov    %eax,%ecx
  801a1c:	48 ba 48 47 80 00 00 	movabs $0x804748,%rdx
  801a23:	00 00 00 
  801a26:	be 23 00 00 00       	mov    $0x23,%esi
  801a2b:	48 bf 65 47 80 00 00 	movabs $0x804765,%rdi
  801a32:	00 00 00 
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3a:	49 b9 98 04 80 00 00 	movabs $0x800498,%r9
  801a41:	00 00 00 
  801a44:	41 ff d1             	callq  *%r9

	return ret;
  801a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a4b:	48 83 c4 48          	add    $0x48,%rsp
  801a4f:	5b                   	pop    %rbx
  801a50:	5d                   	pop    %rbp
  801a51:	c3                   	retq   

0000000000801a52 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a52:	55                   	push   %rbp
  801a53:	48 89 e5             	mov    %rsp,%rbp
  801a56:	48 83 ec 10          	sub    $0x10,%rsp
  801a5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6a:	48 83 ec 08          	sub    $0x8,%rsp
  801a6e:	6a 00                	pushq  $0x0
  801a70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7c:	48 89 d1             	mov    %rdx,%rcx
  801a7f:	48 89 c2             	mov    %rax,%rdx
  801a82:	be 00 00 00 00       	mov    $0x0,%esi
  801a87:	bf 00 00 00 00       	mov    $0x0,%edi
  801a8c:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801a93:	00 00 00 
  801a96:	ff d0                	callq  *%rax
  801a98:	48 83 c4 10          	add    $0x10,%rsp
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801aa2:	48 83 ec 08          	sub    $0x8,%rsp
  801aa6:	6a 00                	pushq  $0x0
  801aa8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab9:	ba 00 00 00 00       	mov    $0x0,%edx
  801abe:	be 00 00 00 00       	mov    $0x0,%esi
  801ac3:	bf 01 00 00 00       	mov    $0x1,%edi
  801ac8:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801acf:	00 00 00 
  801ad2:	ff d0                	callq  *%rax
  801ad4:	48 83 c4 10          	add    $0x10,%rsp
}
  801ad8:	c9                   	leaveq 
  801ad9:	c3                   	retq   

0000000000801ada <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	48 83 ec 10          	sub    $0x10,%rsp
  801ae2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae8:	48 98                	cltq   
  801aea:	48 83 ec 08          	sub    $0x8,%rsp
  801aee:	6a 00                	pushq  $0x0
  801af0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b01:	48 89 c2             	mov    %rax,%rdx
  801b04:	be 01 00 00 00       	mov    $0x1,%esi
  801b09:	bf 03 00 00 00       	mov    $0x3,%edi
  801b0e:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801b15:	00 00 00 
  801b18:	ff d0                	callq  *%rax
  801b1a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b24:	48 83 ec 08          	sub    $0x8,%rsp
  801b28:	6a 00                	pushq  $0x0
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	be 00 00 00 00       	mov    $0x0,%esi
  801b45:	bf 02 00 00 00       	mov    $0x2,%edi
  801b4a:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
  801b56:	48 83 c4 10          	add    $0x10,%rsp
}
  801b5a:	c9                   	leaveq 
  801b5b:	c3                   	retq   

0000000000801b5c <sys_yield>:

void
sys_yield(void)
{
  801b5c:	55                   	push   %rbp
  801b5d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b60:	48 83 ec 08          	sub    $0x8,%rsp
  801b64:	6a 00                	pushq  $0x0
  801b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b72:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b77:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7c:	be 00 00 00 00       	mov    $0x0,%esi
  801b81:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b86:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801b8d:	00 00 00 
  801b90:	ff d0                	callq  *%rax
  801b92:	48 83 c4 10          	add    $0x10,%rsp
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 10          	sub    $0x10,%rsp
  801ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801baa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bad:	48 63 c8             	movslq %eax,%rcx
  801bb0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb7:	48 98                	cltq   
  801bb9:	48 83 ec 08          	sub    $0x8,%rsp
  801bbd:	6a 00                	pushq  $0x0
  801bbf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc5:	49 89 c8             	mov    %rcx,%r8
  801bc8:	48 89 d1             	mov    %rdx,%rcx
  801bcb:	48 89 c2             	mov    %rax,%rdx
  801bce:	be 01 00 00 00       	mov    $0x1,%esi
  801bd3:	bf 04 00 00 00       	mov    $0x4,%edi
  801bd8:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
  801be4:	48 83 c4 10          	add    $0x10,%rsp
}
  801be8:	c9                   	leaveq 
  801be9:	c3                   	retq   

0000000000801bea <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	48 83 ec 20          	sub    $0x20,%rsp
  801bf2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bfc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c00:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c04:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c07:	48 63 c8             	movslq %eax,%rcx
  801c0a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c11:	48 63 f0             	movslq %eax,%rsi
  801c14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1b:	48 98                	cltq   
  801c1d:	48 83 ec 08          	sub    $0x8,%rsp
  801c21:	51                   	push   %rcx
  801c22:	49 89 f9             	mov    %rdi,%r9
  801c25:	49 89 f0             	mov    %rsi,%r8
  801c28:	48 89 d1             	mov    %rdx,%rcx
  801c2b:	48 89 c2             	mov    %rax,%rdx
  801c2e:	be 01 00 00 00       	mov    $0x1,%esi
  801c33:	bf 05 00 00 00       	mov    $0x5,%edi
  801c38:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
  801c44:	48 83 c4 10          	add    $0x10,%rsp
}
  801c48:	c9                   	leaveq 
  801c49:	c3                   	retq   

0000000000801c4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c4a:	55                   	push   %rbp
  801c4b:	48 89 e5             	mov    %rsp,%rbp
  801c4e:	48 83 ec 10          	sub    $0x10,%rsp
  801c52:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c60:	48 98                	cltq   
  801c62:	48 83 ec 08          	sub    $0x8,%rsp
  801c66:	6a 00                	pushq  $0x0
  801c68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c74:	48 89 d1             	mov    %rdx,%rcx
  801c77:	48 89 c2             	mov    %rax,%rdx
  801c7a:	be 01 00 00 00       	mov    $0x1,%esi
  801c7f:	bf 06 00 00 00       	mov    $0x6,%edi
  801c84:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
  801c90:	48 83 c4 10          	add    $0x10,%rsp
}
  801c94:	c9                   	leaveq 
  801c95:	c3                   	retq   

0000000000801c96 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c96:	55                   	push   %rbp
  801c97:	48 89 e5             	mov    %rsp,%rbp
  801c9a:	48 83 ec 10          	sub    $0x10,%rsp
  801c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ca4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca7:	48 63 d0             	movslq %eax,%rdx
  801caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cad:	48 98                	cltq   
  801caf:	48 83 ec 08          	sub    $0x8,%rsp
  801cb3:	6a 00                	pushq  $0x0
  801cb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc1:	48 89 d1             	mov    %rdx,%rcx
  801cc4:	48 89 c2             	mov    %rax,%rdx
  801cc7:	be 01 00 00 00       	mov    $0x1,%esi
  801ccc:	bf 08 00 00 00       	mov    $0x8,%edi
  801cd1:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
  801cdd:	48 83 c4 10          	add    $0x10,%rsp
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   

0000000000801ce3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	48 83 ec 10          	sub    $0x10,%rsp
  801ceb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf9:	48 98                	cltq   
  801cfb:	48 83 ec 08          	sub    $0x8,%rsp
  801cff:	6a 00                	pushq  $0x0
  801d01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0d:	48 89 d1             	mov    %rdx,%rcx
  801d10:	48 89 c2             	mov    %rax,%rdx
  801d13:	be 01 00 00 00       	mov    $0x1,%esi
  801d18:	bf 09 00 00 00       	mov    $0x9,%edi
  801d1d:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801d24:	00 00 00 
  801d27:	ff d0                	callq  *%rax
  801d29:	48 83 c4 10          	add    $0x10,%rsp
}
  801d2d:	c9                   	leaveq 
  801d2e:	c3                   	retq   

0000000000801d2f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	48 83 ec 10          	sub    $0x10,%rsp
  801d37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d45:	48 98                	cltq   
  801d47:	48 83 ec 08          	sub    $0x8,%rsp
  801d4b:	6a 00                	pushq  $0x0
  801d4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d59:	48 89 d1             	mov    %rdx,%rcx
  801d5c:	48 89 c2             	mov    %rax,%rdx
  801d5f:	be 01 00 00 00       	mov    $0x1,%esi
  801d64:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d69:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	callq  *%rax
  801d75:	48 83 c4 10          	add    $0x10,%rsp
}
  801d79:	c9                   	leaveq 
  801d7a:	c3                   	retq   

0000000000801d7b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d7b:	55                   	push   %rbp
  801d7c:	48 89 e5             	mov    %rsp,%rbp
  801d7f:	48 83 ec 20          	sub    $0x20,%rsp
  801d83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d8a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d8e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d94:	48 63 f0             	movslq %eax,%rsi
  801d97:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9e:	48 98                	cltq   
  801da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da4:	48 83 ec 08          	sub    $0x8,%rsp
  801da8:	6a 00                	pushq  $0x0
  801daa:	49 89 f1             	mov    %rsi,%r9
  801dad:	49 89 c8             	mov    %rcx,%r8
  801db0:	48 89 d1             	mov    %rdx,%rcx
  801db3:	48 89 c2             	mov    %rax,%rdx
  801db6:	be 00 00 00 00       	mov    $0x0,%esi
  801dbb:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dc0:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	callq  *%rax
  801dcc:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd0:	c9                   	leaveq 
  801dd1:	c3                   	retq   

0000000000801dd2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801dd2:	55                   	push   %rbp
  801dd3:	48 89 e5             	mov    %rsp,%rbp
  801dd6:	48 83 ec 10          	sub    $0x10,%rsp
  801dda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de2:	48 83 ec 08          	sub    $0x8,%rsp
  801de6:	6a 00                	pushq  $0x0
  801de8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801df9:	48 89 c2             	mov    %rax,%rdx
  801dfc:	be 01 00 00 00       	mov    $0x1,%esi
  801e01:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e06:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801e0d:	00 00 00 
  801e10:	ff d0                	callq  *%rax
  801e12:	48 83 c4 10          	add    $0x10,%rsp
}
  801e16:	c9                   	leaveq 
  801e17:	c3                   	retq   

0000000000801e18 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e18:	55                   	push   %rbp
  801e19:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e1c:	48 83 ec 08          	sub    $0x8,%rsp
  801e20:	6a 00                	pushq  $0x0
  801e22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e33:	ba 00 00 00 00       	mov    $0x0,%edx
  801e38:	be 00 00 00 00       	mov    $0x0,%esi
  801e3d:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e42:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	callq  *%rax
  801e4e:	48 83 c4 10          	add    $0x10,%rsp
}
  801e52:	c9                   	leaveq 
  801e53:	c3                   	retq   

0000000000801e54 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e54:	55                   	push   %rbp
  801e55:	48 89 e5             	mov    %rsp,%rbp
  801e58:	48 83 ec 20          	sub    $0x20,%rsp
  801e5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e63:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e66:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e6a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e6e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e71:	48 63 c8             	movslq %eax,%rcx
  801e74:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e7b:	48 63 f0             	movslq %eax,%rsi
  801e7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e85:	48 98                	cltq   
  801e87:	48 83 ec 08          	sub    $0x8,%rsp
  801e8b:	51                   	push   %rcx
  801e8c:	49 89 f9             	mov    %rdi,%r9
  801e8f:	49 89 f0             	mov    %rsi,%r8
  801e92:	48 89 d1             	mov    %rdx,%rcx
  801e95:	48 89 c2             	mov    %rax,%rdx
  801e98:	be 00 00 00 00       	mov    $0x0,%esi
  801e9d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ea2:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	callq  *%rax
  801eae:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801eb2:	c9                   	leaveq 
  801eb3:	c3                   	retq   

0000000000801eb4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801eb4:	55                   	push   %rbp
  801eb5:	48 89 e5             	mov    %rsp,%rbp
  801eb8:	48 83 ec 10          	sub    $0x10,%rsp
  801ebc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ec0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ec4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecc:	48 83 ec 08          	sub    $0x8,%rsp
  801ed0:	6a 00                	pushq  $0x0
  801ed2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ede:	48 89 d1             	mov    %rdx,%rcx
  801ee1:	48 89 c2             	mov    %rax,%rdx
  801ee4:	be 00 00 00 00       	mov    $0x0,%esi
  801ee9:	bf 10 00 00 00       	mov    $0x10,%edi
  801eee:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801ef5:	00 00 00 
  801ef8:	ff d0                	callq  *%rax
  801efa:	48 83 c4 10          	add    $0x10,%rsp
}
  801efe:	c9                   	leaveq 
  801eff:	c3                   	retq   

0000000000801f00 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f00:	55                   	push   %rbp
  801f01:	48 89 e5             	mov    %rsp,%rbp
  801f04:	48 83 ec 20          	sub    $0x20,%rsp
  801f08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f10:	48 8b 00             	mov    (%rax),%rax
  801f13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f1f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801f22:	48 ba 73 47 80 00 00 	movabs $0x804773,%rdx
  801f29:	00 00 00 
  801f2c:	be 26 00 00 00       	mov    $0x26,%esi
  801f31:	48 bf 8b 47 80 00 00 	movabs $0x80478b,%rdi
  801f38:	00 00 00 
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f40:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801f47:	00 00 00 
  801f4a:	ff d1                	callq  *%rcx

0000000000801f4c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f4c:	55                   	push   %rbp
  801f4d:	48 89 e5             	mov    %rsp,%rbp
  801f50:	48 83 ec 10          	sub    $0x10,%rsp
  801f54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f57:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801f5a:	48 ba 96 47 80 00 00 	movabs $0x804796,%rdx
  801f61:	00 00 00 
  801f64:	be 3a 00 00 00       	mov    $0x3a,%esi
  801f69:	48 bf 8b 47 80 00 00 	movabs $0x80478b,%rdi
  801f70:	00 00 00 
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801f7f:	00 00 00 
  801f82:	ff d1                	callq  *%rcx

0000000000801f84 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f84:	55                   	push   %rbp
  801f85:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801f88:	48 ba ae 47 80 00 00 	movabs $0x8047ae,%rdx
  801f8f:	00 00 00 
  801f92:	be 52 00 00 00       	mov    $0x52,%esi
  801f97:	48 bf 8b 47 80 00 00 	movabs $0x80478b,%rdi
  801f9e:	00 00 00 
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801fad:	00 00 00 
  801fb0:	ff d1                	callq  *%rcx

0000000000801fb2 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801fb2:	55                   	push   %rbp
  801fb3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801fb6:	48 ba c3 47 80 00 00 	movabs $0x8047c3,%rdx
  801fbd:	00 00 00 
  801fc0:	be 59 00 00 00       	mov    $0x59,%esi
  801fc5:	48 bf 8b 47 80 00 00 	movabs $0x80478b,%rdi
  801fcc:	00 00 00 
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  801fdb:	00 00 00 
  801fde:	ff d1                	callq  *%rcx

0000000000801fe0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801fe0:	55                   	push   %rbp
  801fe1:	48 89 e5             	mov    %rsp,%rbp
  801fe4:	48 83 ec 08          	sub    $0x8,%rsp
  801fe8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ff0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ff7:	ff ff ff 
  801ffa:	48 01 d0             	add    %rdx,%rax
  801ffd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802001:	c9                   	leaveq 
  802002:	c3                   	retq   

0000000000802003 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802003:	55                   	push   %rbp
  802004:	48 89 e5             	mov    %rsp,%rbp
  802007:	48 83 ec 08          	sub    $0x8,%rsp
  80200b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80200f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802013:	48 89 c7             	mov    %rax,%rdi
  802016:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
  802022:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802028:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80202c:	c9                   	leaveq 
  80202d:	c3                   	retq   

000000000080202e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80202e:	55                   	push   %rbp
  80202f:	48 89 e5             	mov    %rsp,%rbp
  802032:	48 83 ec 18          	sub    $0x18,%rsp
  802036:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80203a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802041:	eb 6b                	jmp    8020ae <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802046:	48 98                	cltq   
  802048:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80204e:	48 c1 e0 0c          	shl    $0xc,%rax
  802052:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80205a:	48 c1 e8 15          	shr    $0x15,%rax
  80205e:	48 89 c2             	mov    %rax,%rdx
  802061:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802068:	01 00 00 
  80206b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206f:	83 e0 01             	and    $0x1,%eax
  802072:	48 85 c0             	test   %rax,%rax
  802075:	74 21                	je     802098 <fd_alloc+0x6a>
  802077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207b:	48 c1 e8 0c          	shr    $0xc,%rax
  80207f:	48 89 c2             	mov    %rax,%rdx
  802082:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802089:	01 00 00 
  80208c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802090:	83 e0 01             	and    $0x1,%eax
  802093:	48 85 c0             	test   %rax,%rax
  802096:	75 12                	jne    8020aa <fd_alloc+0x7c>
			*fd_store = fd;
  802098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020a0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a8:	eb 1a                	jmp    8020c4 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  8020aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020ae:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020b2:	7e 8f                	jle    802043 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  8020b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020bf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020c4:	c9                   	leaveq 
  8020c5:	c3                   	retq   

00000000008020c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020c6:	55                   	push   %rbp
  8020c7:	48 89 e5             	mov    %rsp,%rbp
  8020ca:	48 83 ec 20          	sub    $0x20,%rsp
  8020ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020d9:	78 06                	js     8020e1 <fd_lookup+0x1b>
  8020db:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8020df:	7e 07                	jle    8020e8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e6:	eb 6c                	jmp    802154 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020eb:	48 98                	cltq   
  8020ed:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020f3:	48 c1 e0 0c          	shl    $0xc,%rax
  8020f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ff:	48 c1 e8 15          	shr    $0x15,%rax
  802103:	48 89 c2             	mov    %rax,%rdx
  802106:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80210d:	01 00 00 
  802110:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802114:	83 e0 01             	and    $0x1,%eax
  802117:	48 85 c0             	test   %rax,%rax
  80211a:	74 21                	je     80213d <fd_lookup+0x77>
  80211c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802120:	48 c1 e8 0c          	shr    $0xc,%rax
  802124:	48 89 c2             	mov    %rax,%rdx
  802127:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80212e:	01 00 00 
  802131:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802135:	83 e0 01             	and    $0x1,%eax
  802138:	48 85 c0             	test   %rax,%rax
  80213b:	75 07                	jne    802144 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80213d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802142:	eb 10                	jmp    802154 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802144:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802148:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80214c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802154:	c9                   	leaveq 
  802155:	c3                   	retq   

0000000000802156 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802156:	55                   	push   %rbp
  802157:	48 89 e5             	mov    %rsp,%rbp
  80215a:	48 83 ec 30          	sub    $0x30,%rsp
  80215e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802162:	89 f0                	mov    %esi,%eax
  802164:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216b:	48 89 c7             	mov    %rax,%rdi
  80216e:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	89 c2                	mov    %eax,%edx
  80217c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802180:	48 89 c6             	mov    %rax,%rsi
  802183:	89 d7                	mov    %edx,%edi
  802185:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	callq  *%rax
  802191:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802198:	78 0a                	js     8021a4 <fd_close+0x4e>
	    || fd != fd2)
  80219a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021a2:	74 12                	je     8021b6 <fd_close+0x60>
		return (must_exist ? r : 0);
  8021a4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021a8:	74 05                	je     8021af <fd_close+0x59>
  8021aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ad:	eb 70                	jmp    80221f <fd_close+0xc9>
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	eb 69                	jmp    80221f <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	8b 00                	mov    (%rax),%eax
  8021bc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021c0:	48 89 d6             	mov    %rdx,%rsi
  8021c3:	89 c7                	mov    %eax,%edi
  8021c5:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
  8021d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d8:	78 2a                	js     802204 <fd_close+0xae>
		if (dev->dev_close)
  8021da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021de:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021e2:	48 85 c0             	test   %rax,%rax
  8021e5:	74 16                	je     8021fd <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8021e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021eb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021f3:	48 89 d7             	mov    %rdx,%rdi
  8021f6:	ff d0                	callq  *%rax
  8021f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021fb:	eb 07                	jmp    802204 <fd_close+0xae>
		else
			r = 0;
  8021fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802204:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802208:	48 89 c6             	mov    %rax,%rsi
  80220b:	bf 00 00 00 00       	mov    $0x0,%edi
  802210:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  802217:	00 00 00 
  80221a:	ff d0                	callq  *%rax
	return r;
  80221c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80221f:	c9                   	leaveq 
  802220:	c3                   	retq   

0000000000802221 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802221:	55                   	push   %rbp
  802222:	48 89 e5             	mov    %rsp,%rbp
  802225:	48 83 ec 20          	sub    $0x20,%rsp
  802229:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80222c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802237:	eb 41                	jmp    80227a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802239:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802240:	00 00 00 
  802243:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802246:	48 63 d2             	movslq %edx,%rdx
  802249:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224d:	8b 00                	mov    (%rax),%eax
  80224f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802252:	75 22                	jne    802276 <dev_lookup+0x55>
			*dev = devtab[i];
  802254:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80225b:	00 00 00 
  80225e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802261:	48 63 d2             	movslq %edx,%rdx
  802264:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802268:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80226c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	eb 60                	jmp    8022d6 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802276:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80227a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802281:	00 00 00 
  802284:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802287:	48 63 d2             	movslq %edx,%rdx
  80228a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228e:	48 85 c0             	test   %rax,%rax
  802291:	75 a6                	jne    802239 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802293:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80229a:	00 00 00 
  80229d:	48 8b 00             	mov    (%rax),%rax
  8022a0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022a6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022a9:	89 c6                	mov    %eax,%esi
  8022ab:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
  8022b2:	00 00 00 
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	48 b9 d1 06 80 00 00 	movabs $0x8006d1,%rcx
  8022c1:	00 00 00 
  8022c4:	ff d1                	callq  *%rcx
	*dev = 0;
  8022c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ca:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022d6:	c9                   	leaveq 
  8022d7:	c3                   	retq   

00000000008022d8 <close>:

int
close(int fdnum)
{
  8022d8:	55                   	push   %rbp
  8022d9:	48 89 e5             	mov    %rsp,%rbp
  8022dc:	48 83 ec 20          	sub    $0x20,%rsp
  8022e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ea:	48 89 d6             	mov    %rdx,%rsi
  8022ed:	89 c7                	mov    %eax,%edi
  8022ef:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	callq  *%rax
  8022fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802302:	79 05                	jns    802309 <close+0x31>
		return r;
  802304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802307:	eb 18                	jmp    802321 <close+0x49>
	else
		return fd_close(fd, 1);
  802309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230d:	be 01 00 00 00       	mov    $0x1,%esi
  802312:	48 89 c7             	mov    %rax,%rdi
  802315:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
}
  802321:	c9                   	leaveq 
  802322:	c3                   	retq   

0000000000802323 <close_all>:

void
close_all(void)
{
  802323:	55                   	push   %rbp
  802324:	48 89 e5             	mov    %rsp,%rbp
  802327:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80232b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802332:	eb 15                	jmp    802349 <close_all+0x26>
		close(i);
  802334:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802337:	89 c7                	mov    %eax,%edi
  802339:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802345:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802349:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80234d:	7e e5                	jle    802334 <close_all+0x11>
}
  80234f:	c9                   	leaveq 
  802350:	c3                   	retq   

0000000000802351 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802351:	55                   	push   %rbp
  802352:	48 89 e5             	mov    %rsp,%rbp
  802355:	48 83 ec 40          	sub    $0x40,%rsp
  802359:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80235c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80235f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802363:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802366:	48 89 d6             	mov    %rdx,%rsi
  802369:	89 c7                	mov    %eax,%edi
  80236b:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
  802377:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237e:	79 08                	jns    802388 <dup+0x37>
		return r;
  802380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802383:	e9 70 01 00 00       	jmpq   8024f8 <dup+0x1a7>
	close(newfdnum);
  802388:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80238b:	89 c7                	mov    %eax,%edi
  80238d:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802394:	00 00 00 
  802397:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802399:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80239c:	48 98                	cltq   
  80239e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023a4:	48 c1 e0 0c          	shl    $0xc,%rax
  8023a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023b0:	48 89 c7             	mov    %rax,%rdi
  8023b3:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
  8023bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c7:	48 89 c7             	mov    %rax,%rdi
  8023ca:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  8023d1:	00 00 00 
  8023d4:	ff d0                	callq  *%rax
  8023d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023de:	48 c1 e8 15          	shr    $0x15,%rax
  8023e2:	48 89 c2             	mov    %rax,%rdx
  8023e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023ec:	01 00 00 
  8023ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f3:	83 e0 01             	and    $0x1,%eax
  8023f6:	48 85 c0             	test   %rax,%rax
  8023f9:	74 73                	je     80246e <dup+0x11d>
  8023fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ff:	48 c1 e8 0c          	shr    $0xc,%rax
  802403:	48 89 c2             	mov    %rax,%rdx
  802406:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80240d:	01 00 00 
  802410:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802414:	83 e0 01             	and    $0x1,%eax
  802417:	48 85 c0             	test   %rax,%rax
  80241a:	74 52                	je     80246e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80241c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802420:	48 c1 e8 0c          	shr    $0xc,%rax
  802424:	48 89 c2             	mov    %rax,%rdx
  802427:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80242e:	01 00 00 
  802431:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802435:	25 07 0e 00 00       	and    $0xe07,%eax
  80243a:	89 c1                	mov    %eax,%ecx
  80243c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802444:	41 89 c8             	mov    %ecx,%r8d
  802447:	48 89 d1             	mov    %rdx,%rcx
  80244a:	ba 00 00 00 00       	mov    $0x0,%edx
  80244f:	48 89 c6             	mov    %rax,%rsi
  802452:	bf 00 00 00 00       	mov    $0x0,%edi
  802457:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  80245e:	00 00 00 
  802461:	ff d0                	callq  *%rax
  802463:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802466:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246a:	79 02                	jns    80246e <dup+0x11d>
			goto err;
  80246c:	eb 57                	jmp    8024c5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80246e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802472:	48 c1 e8 0c          	shr    $0xc,%rax
  802476:	48 89 c2             	mov    %rax,%rdx
  802479:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802480:	01 00 00 
  802483:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802487:	25 07 0e 00 00       	and    $0xe07,%eax
  80248c:	89 c1                	mov    %eax,%ecx
  80248e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802492:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802496:	41 89 c8             	mov    %ecx,%r8d
  802499:	48 89 d1             	mov    %rdx,%rcx
  80249c:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a1:	48 89 c6             	mov    %rax,%rsi
  8024a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a9:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8024b0:	00 00 00 
  8024b3:	ff d0                	callq  *%rax
  8024b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bc:	79 02                	jns    8024c0 <dup+0x16f>
		goto err;
  8024be:	eb 05                	jmp    8024c5 <dup+0x174>

	return newfdnum;
  8024c0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024c3:	eb 33                	jmp    8024f8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c9:	48 89 c6             	mov    %rax,%rsi
  8024cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d1:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8024d8:	00 00 00 
  8024db:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024e1:	48 89 c6             	mov    %rax,%rsi
  8024e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e9:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8024f0:	00 00 00 
  8024f3:	ff d0                	callq  *%rax
	return r;
  8024f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024f8:	c9                   	leaveq 
  8024f9:	c3                   	retq   

00000000008024fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024fa:	55                   	push   %rbp
  8024fb:	48 89 e5             	mov    %rsp,%rbp
  8024fe:	48 83 ec 40          	sub    $0x40,%rsp
  802502:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802505:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802509:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80250d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802511:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802514:	48 89 d6             	mov    %rdx,%rsi
  802517:	89 c7                	mov    %eax,%edi
  802519:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  802520:	00 00 00 
  802523:	ff d0                	callq  *%rax
  802525:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802528:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252c:	78 24                	js     802552 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80252e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802532:	8b 00                	mov    (%rax),%eax
  802534:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802538:	48 89 d6             	mov    %rdx,%rsi
  80253b:	89 c7                	mov    %eax,%edi
  80253d:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  802544:	00 00 00 
  802547:	ff d0                	callq  *%rax
  802549:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802550:	79 05                	jns    802557 <read+0x5d>
		return r;
  802552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802555:	eb 76                	jmp    8025cd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255b:	8b 40 08             	mov    0x8(%rax),%eax
  80255e:	83 e0 03             	and    $0x3,%eax
  802561:	83 f8 01             	cmp    $0x1,%eax
  802564:	75 3a                	jne    8025a0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802566:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80256d:	00 00 00 
  802570:	48 8b 00             	mov    (%rax),%rax
  802573:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802579:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80257c:	89 c6                	mov    %eax,%esi
  80257e:	48 bf ff 47 80 00 00 	movabs $0x8047ff,%rdi
  802585:	00 00 00 
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	48 b9 d1 06 80 00 00 	movabs $0x8006d1,%rcx
  802594:	00 00 00 
  802597:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802599:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80259e:	eb 2d                	jmp    8025cd <read+0xd3>
	}
	if (!dev->dev_read)
  8025a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025a8:	48 85 c0             	test   %rax,%rax
  8025ab:	75 07                	jne    8025b4 <read+0xba>
		return -E_NOT_SUPP;
  8025ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025b2:	eb 19                	jmp    8025cd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025bc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025c0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025c4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025c8:	48 89 cf             	mov    %rcx,%rdi
  8025cb:	ff d0                	callq  *%rax
}
  8025cd:	c9                   	leaveq 
  8025ce:	c3                   	retq   

00000000008025cf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025cf:	55                   	push   %rbp
  8025d0:	48 89 e5             	mov    %rsp,%rbp
  8025d3:	48 83 ec 30          	sub    $0x30,%rsp
  8025d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025e9:	eb 49                	jmp    802634 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	48 98                	cltq   
  8025f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025f4:	48 29 c2             	sub    %rax,%rdx
  8025f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fa:	48 63 c8             	movslq %eax,%rcx
  8025fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802601:	48 01 c1             	add    %rax,%rcx
  802604:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802607:	48 89 ce             	mov    %rcx,%rsi
  80260a:	89 c7                	mov    %eax,%edi
  80260c:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80261b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80261f:	79 05                	jns    802626 <readn+0x57>
			return m;
  802621:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802624:	eb 1c                	jmp    802642 <readn+0x73>
		if (m == 0)
  802626:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80262a:	75 02                	jne    80262e <readn+0x5f>
			break;
  80262c:	eb 11                	jmp    80263f <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80262e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802631:	01 45 fc             	add    %eax,-0x4(%rbp)
  802634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802637:	48 98                	cltq   
  802639:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80263d:	72 ac                	jb     8025eb <readn+0x1c>
	}
	return tot;
  80263f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802642:	c9                   	leaveq 
  802643:	c3                   	retq   

0000000000802644 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802644:	55                   	push   %rbp
  802645:	48 89 e5             	mov    %rsp,%rbp
  802648:	48 83 ec 40          	sub    $0x40,%rsp
  80264c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80264f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802653:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802657:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80265b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80265e:	48 89 d6             	mov    %rdx,%rsi
  802661:	89 c7                	mov    %eax,%edi
  802663:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  80266a:	00 00 00 
  80266d:	ff d0                	callq  *%rax
  80266f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802676:	78 24                	js     80269c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267c:	8b 00                	mov    (%rax),%eax
  80267e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802682:	48 89 d6             	mov    %rdx,%rsi
  802685:	89 c7                	mov    %eax,%edi
  802687:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  80268e:	00 00 00 
  802691:	ff d0                	callq  *%rax
  802693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802696:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269a:	79 05                	jns    8026a1 <write+0x5d>
		return r;
  80269c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269f:	eb 75                	jmp    802716 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a5:	8b 40 08             	mov    0x8(%rax),%eax
  8026a8:	83 e0 03             	and    $0x3,%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	75 3a                	jne    8026e9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026b6:	00 00 00 
  8026b9:	48 8b 00             	mov    (%rax),%rax
  8026bc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026c5:	89 c6                	mov    %eax,%esi
  8026c7:	48 bf 1b 48 80 00 00 	movabs $0x80481b,%rdi
  8026ce:	00 00 00 
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	48 b9 d1 06 80 00 00 	movabs $0x8006d1,%rcx
  8026dd:	00 00 00 
  8026e0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e7:	eb 2d                	jmp    802716 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ed:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026f1:	48 85 c0             	test   %rax,%rax
  8026f4:	75 07                	jne    8026fd <write+0xb9>
		return -E_NOT_SUPP;
  8026f6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026fb:	eb 19                	jmp    802716 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802701:	48 8b 40 18          	mov    0x18(%rax),%rax
  802705:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802709:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80270d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802711:	48 89 cf             	mov    %rcx,%rdi
  802714:	ff d0                	callq  *%rax
}
  802716:	c9                   	leaveq 
  802717:	c3                   	retq   

0000000000802718 <seek>:

int
seek(int fdnum, off_t offset)
{
  802718:	55                   	push   %rbp
  802719:	48 89 e5             	mov    %rsp,%rbp
  80271c:	48 83 ec 18          	sub    $0x18,%rsp
  802720:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802723:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802726:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80272a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80272d:	48 89 d6             	mov    %rdx,%rsi
  802730:	89 c7                	mov    %eax,%edi
  802732:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax
  80273e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802741:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802745:	79 05                	jns    80274c <seek+0x34>
		return r;
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274a:	eb 0f                	jmp    80275b <seek+0x43>
	fd->fd_offset = offset;
  80274c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802750:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802753:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275b:	c9                   	leaveq 
  80275c:	c3                   	retq   

000000000080275d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80275d:	55                   	push   %rbp
  80275e:	48 89 e5             	mov    %rsp,%rbp
  802761:	48 83 ec 30          	sub    $0x30,%rsp
  802765:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802768:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80276b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80276f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802772:	48 89 d6             	mov    %rdx,%rsi
  802775:	89 c7                	mov    %eax,%edi
  802777:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278a:	78 24                	js     8027b0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80278c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802790:	8b 00                	mov    (%rax),%eax
  802792:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802796:	48 89 d6             	mov    %rdx,%rsi
  802799:	89 c7                	mov    %eax,%edi
  80279b:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  8027a2:	00 00 00 
  8027a5:	ff d0                	callq  *%rax
  8027a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ae:	79 05                	jns    8027b5 <ftruncate+0x58>
		return r;
  8027b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b3:	eb 72                	jmp    802827 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b9:	8b 40 08             	mov    0x8(%rax),%eax
  8027bc:	83 e0 03             	and    $0x3,%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	75 3a                	jne    8027fd <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027c3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027ca:	00 00 00 
  8027cd:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027d0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027d6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027d9:	89 c6                	mov    %eax,%esi
  8027db:	48 bf 38 48 80 00 00 	movabs $0x804838,%rdi
  8027e2:	00 00 00 
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ea:	48 b9 d1 06 80 00 00 	movabs $0x8006d1,%rcx
  8027f1:	00 00 00 
  8027f4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027fb:	eb 2a                	jmp    802827 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802801:	48 8b 40 30          	mov    0x30(%rax),%rax
  802805:	48 85 c0             	test   %rax,%rax
  802808:	75 07                	jne    802811 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80280a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80280f:	eb 16                	jmp    802827 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802815:	48 8b 40 30          	mov    0x30(%rax),%rax
  802819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80281d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802820:	89 ce                	mov    %ecx,%esi
  802822:	48 89 d7             	mov    %rdx,%rdi
  802825:	ff d0                	callq  *%rax
}
  802827:	c9                   	leaveq 
  802828:	c3                   	retq   

0000000000802829 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802829:	55                   	push   %rbp
  80282a:	48 89 e5             	mov    %rsp,%rbp
  80282d:	48 83 ec 30          	sub    $0x30,%rsp
  802831:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802834:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802838:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80283c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80283f:	48 89 d6             	mov    %rdx,%rsi
  802842:	89 c7                	mov    %eax,%edi
  802844:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  80284b:	00 00 00 
  80284e:	ff d0                	callq  *%rax
  802850:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802853:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802857:	78 24                	js     80287d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285d:	8b 00                	mov    (%rax),%eax
  80285f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802863:	48 89 d6             	mov    %rdx,%rsi
  802866:	89 c7                	mov    %eax,%edi
  802868:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802877:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287b:	79 05                	jns    802882 <fstat+0x59>
		return r;
  80287d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802880:	eb 5e                	jmp    8028e0 <fstat+0xb7>
	if (!dev->dev_stat)
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	48 8b 40 28          	mov    0x28(%rax),%rax
  80288a:	48 85 c0             	test   %rax,%rax
  80288d:	75 07                	jne    802896 <fstat+0x6d>
		return -E_NOT_SUPP;
  80288f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802894:	eb 4a                	jmp    8028e0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802896:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80289a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80289d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028a8:	00 00 00 
	stat->st_isdir = 0;
  8028ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028af:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028b6:	00 00 00 
	stat->st_dev = dev;
  8028b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028c1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028d4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028d8:	48 89 ce             	mov    %rcx,%rsi
  8028db:	48 89 d7             	mov    %rdx,%rdi
  8028de:	ff d0                	callq  *%rax
}
  8028e0:	c9                   	leaveq 
  8028e1:	c3                   	retq   

00000000008028e2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028e2:	55                   	push   %rbp
  8028e3:	48 89 e5             	mov    %rsp,%rbp
  8028e6:	48 83 ec 20          	sub    $0x20,%rsp
  8028ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f6:	be 00 00 00 00       	mov    $0x0,%esi
  8028fb:	48 89 c7             	mov    %rax,%rdi
  8028fe:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802905:	00 00 00 
  802908:	ff d0                	callq  *%rax
  80290a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802911:	79 05                	jns    802918 <stat+0x36>
		return fd;
  802913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802916:	eb 2f                	jmp    802947 <stat+0x65>
	r = fstat(fd, stat);
  802918:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80291c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291f:	48 89 d6             	mov    %rdx,%rsi
  802922:	89 c7                	mov    %eax,%edi
  802924:	48 b8 29 28 80 00 00 	movabs $0x802829,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	callq  *%rax
  802930:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802933:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802936:	89 c7                	mov    %eax,%edi
  802938:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  80293f:	00 00 00 
  802942:	ff d0                	callq  *%rax
	return r;
  802944:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802947:	c9                   	leaveq 
  802948:	c3                   	retq   

0000000000802949 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802949:	55                   	push   %rbp
  80294a:	48 89 e5             	mov    %rsp,%rbp
  80294d:	48 83 ec 10          	sub    $0x10,%rsp
  802951:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802954:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802958:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80295f:	00 00 00 
  802962:	8b 00                	mov    (%rax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	75 1f                	jne    802987 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802968:	bf 01 00 00 00       	mov    $0x1,%edi
  80296d:	48 b8 53 40 80 00 00 	movabs $0x804053,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	89 c2                	mov    %eax,%edx
  80297b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802982:	00 00 00 
  802985:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802987:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80298e:	00 00 00 
  802991:	8b 00                	mov    (%rax),%eax
  802993:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802996:	b9 07 00 00 00       	mov    $0x7,%ecx
  80299b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8029a2:	00 00 00 
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029bc:	48 89 c6             	mov    %rax,%rsi
  8029bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c4:	48 b8 88 3e 80 00 00 	movabs $0x803e88,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
}
  8029d0:	c9                   	leaveq 
  8029d1:	c3                   	retq   

00000000008029d2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029d2:	55                   	push   %rbp
  8029d3:	48 89 e5             	mov    %rsp,%rbp
  8029d6:	48 83 ec 10          	sub    $0x10,%rsp
  8029da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029de:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8029e1:	48 ba 5e 48 80 00 00 	movabs $0x80485e,%rdx
  8029e8:	00 00 00 
  8029eb:	be 4c 00 00 00       	mov    $0x4c,%esi
  8029f0:	48 bf 73 48 80 00 00 	movabs $0x804873,%rdi
  8029f7:	00 00 00 
  8029fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ff:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  802a06:	00 00 00 
  802a09:	ff d1                	callq  *%rcx

0000000000802a0b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a0b:	55                   	push   %rbp
  802a0c:	48 89 e5             	mov    %rsp,%rbp
  802a0f:	48 83 ec 10          	sub    $0x10,%rsp
  802a13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a1b:	8b 50 0c             	mov    0xc(%rax),%edx
  802a1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a25:	00 00 00 
  802a28:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a2a:	be 00 00 00 00       	mov    $0x0,%esi
  802a2f:	bf 06 00 00 00       	mov    $0x6,%edi
  802a34:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax
}
  802a40:	c9                   	leaveq 
  802a41:	c3                   	retq   

0000000000802a42 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a42:	55                   	push   %rbp
  802a43:	48 89 e5             	mov    %rsp,%rbp
  802a46:	48 83 ec 20          	sub    $0x20,%rsp
  802a4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802a52:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802a56:	48 ba 7e 48 80 00 00 	movabs $0x80487e,%rdx
  802a5d:	00 00 00 
  802a60:	be 6b 00 00 00       	mov    $0x6b,%esi
  802a65:	48 bf 73 48 80 00 00 	movabs $0x804873,%rdi
  802a6c:	00 00 00 
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  802a7b:	00 00 00 
  802a7e:	ff d1                	callq  *%rcx

0000000000802a80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a80:	55                   	push   %rbp
  802a81:	48 89 e5             	mov    %rsp,%rbp
  802a84:	48 83 ec 20          	sub    $0x20,%rsp
  802a88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802a90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802a94:	48 ba 9b 48 80 00 00 	movabs $0x80489b,%rdx
  802a9b:	00 00 00 
  802a9e:	be 7b 00 00 00       	mov    $0x7b,%esi
  802aa3:	48 bf 73 48 80 00 00 	movabs $0x804873,%rdi
  802aaa:	00 00 00 
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab2:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  802ab9:	00 00 00 
  802abc:	ff d1                	callq  *%rcx

0000000000802abe <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802abe:	55                   	push   %rbp
  802abf:	48 89 e5             	mov    %rsp,%rbp
  802ac2:	48 83 ec 20          	sub    $0x20,%rsp
  802ac6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802adc:	00 00 00 
  802adf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ae1:	be 00 00 00 00       	mov    $0x0,%esi
  802ae6:	bf 05 00 00 00       	mov    $0x5,%edi
  802aeb:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afe:	79 05                	jns    802b05 <devfile_stat+0x47>
		return r;
  802b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b03:	eb 56                	jmp    802b5b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b09:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b10:	00 00 00 
  802b13:	48 89 c7             	mov    %rax,%rdi
  802b16:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b22:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b29:	00 00 00 
  802b2c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b36:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b3c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b43:	00 00 00 
  802b46:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b50:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5b:	c9                   	leaveq 
  802b5c:	c3                   	retq   

0000000000802b5d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b5d:	55                   	push   %rbp
  802b5e:	48 89 e5             	mov    %rsp,%rbp
  802b61:	48 83 ec 10          	sub    $0x10,%rsp
  802b65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b69:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b70:	8b 50 0c             	mov    0xc(%rax),%edx
  802b73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b7a:	00 00 00 
  802b7d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b7f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b86:	00 00 00 
  802b89:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b8c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b8f:	be 00 00 00 00       	mov    $0x0,%esi
  802b94:	bf 02 00 00 00       	mov    $0x2,%edi
  802b99:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
}
  802ba5:	c9                   	leaveq 
  802ba6:	c3                   	retq   

0000000000802ba7 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
  802bab:	48 83 ec 10          	sub    $0x10,%rsp
  802baf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb7:	48 89 c7             	mov    %rax,%rdi
  802bba:	48 b8 ff 11 80 00 00 	movabs $0x8011ff,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
  802bc6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bcb:	7e 07                	jle    802bd4 <remove+0x2d>
		return -E_BAD_PATH;
  802bcd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bd2:	eb 33                	jmp    802c07 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd8:	48 89 c6             	mov    %rax,%rsi
  802bdb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802be2:	00 00 00 
  802be5:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bf1:	be 00 00 00 00       	mov    $0x0,%esi
  802bf6:	bf 07 00 00 00       	mov    $0x7,%edi
  802bfb:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
}
  802c07:	c9                   	leaveq 
  802c08:	c3                   	retq   

0000000000802c09 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c09:	55                   	push   %rbp
  802c0a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c0d:	be 00 00 00 00       	mov    $0x0,%esi
  802c12:	bf 08 00 00 00       	mov    $0x8,%edi
  802c17:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
}
  802c23:	5d                   	pop    %rbp
  802c24:	c3                   	retq   

0000000000802c25 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c30:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c37:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c3e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c45:	be 00 00 00 00       	mov    $0x0,%esi
  802c4a:	48 89 c7             	mov    %rax,%rdi
  802c4d:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802c54:	00 00 00 
  802c57:	ff d0                	callq  *%rax
  802c59:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c60:	79 28                	jns    802c8a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c65:	89 c6                	mov    %eax,%esi
  802c67:	48 bf b9 48 80 00 00 	movabs $0x8048b9,%rdi
  802c6e:	00 00 00 
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
  802c76:	48 ba d1 06 80 00 00 	movabs $0x8006d1,%rdx
  802c7d:	00 00 00 
  802c80:	ff d2                	callq  *%rdx
		return fd_src;
  802c82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c85:	e9 74 01 00 00       	jmpq   802dfe <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c8a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c91:	be 01 01 00 00       	mov    $0x101,%esi
  802c96:	48 89 c7             	mov    %rax,%rdi
  802c99:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802ca0:	00 00 00 
  802ca3:	ff d0                	callq  *%rax
  802ca5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ca8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cac:	79 39                	jns    802ce7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb1:	89 c6                	mov    %eax,%esi
  802cb3:	48 bf cf 48 80 00 00 	movabs $0x8048cf,%rdi
  802cba:	00 00 00 
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc2:	48 ba d1 06 80 00 00 	movabs $0x8006d1,%rdx
  802cc9:	00 00 00 
  802ccc:	ff d2                	callq  *%rdx
		close(fd_src);
  802cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802cda:	00 00 00 
  802cdd:	ff d0                	callq  *%rax
		return fd_dest;
  802cdf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce2:	e9 17 01 00 00       	jmpq   802dfe <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ce7:	eb 74                	jmp    802d5d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ce9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cec:	48 63 d0             	movslq %eax,%rdx
  802cef:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf9:	48 89 ce             	mov    %rcx,%rsi
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
  802d0a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d11:	79 4a                	jns    802d5d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d13:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d16:	89 c6                	mov    %eax,%esi
  802d18:	48 bf e9 48 80 00 00 	movabs $0x8048e9,%rdi
  802d1f:	00 00 00 
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
  802d27:	48 ba d1 06 80 00 00 	movabs $0x8006d1,%rdx
  802d2e:	00 00 00 
  802d31:	ff d2                	callq  *%rdx
			close(fd_src);
  802d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d36:	89 c7                	mov    %eax,%edi
  802d38:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
			close(fd_dest);
  802d44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d47:	89 c7                	mov    %eax,%edi
  802d49:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
			return write_size;
  802d55:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d58:	e9 a1 00 00 00       	jmpq   802dfe <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d5d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	ba 00 02 00 00       	mov    $0x200,%edx
  802d6c:	48 89 ce             	mov    %rcx,%rsi
  802d6f:	89 c7                	mov    %eax,%edi
  802d71:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802d78:	00 00 00 
  802d7b:	ff d0                	callq  *%rax
  802d7d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d84:	0f 8f 5f ff ff ff    	jg     802ce9 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802d8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d8e:	79 47                	jns    802dd7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d90:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d93:	89 c6                	mov    %eax,%esi
  802d95:	48 bf fc 48 80 00 00 	movabs $0x8048fc,%rdi
  802d9c:	00 00 00 
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802da4:	48 ba d1 06 80 00 00 	movabs $0x8006d1,%rdx
  802dab:	00 00 00 
  802dae:	ff d2                	callq  *%rdx
		close(fd_src);
  802db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db3:	89 c7                	mov    %eax,%edi
  802db5:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
		close(fd_dest);
  802dc1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc4:	89 c7                	mov    %eax,%edi
  802dc6:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
		return read_size;
  802dd2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dd5:	eb 27                	jmp    802dfe <copy+0x1d9>
	}
	close(fd_src);
  802dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dda:	89 c7                	mov    %eax,%edi
  802ddc:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	callq  *%rax
	close(fd_dest);
  802de8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802deb:	89 c7                	mov    %eax,%edi
  802ded:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
	return 0;
  802df9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802dfe:	c9                   	leaveq 
  802dff:	c3                   	retq   

0000000000802e00 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e00:	55                   	push   %rbp
  802e01:	48 89 e5             	mov    %rsp,%rbp
  802e04:	48 83 ec 20          	sub    $0x20,%rsp
  802e08:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e12:	48 89 d6             	mov    %rdx,%rsi
  802e15:	89 c7                	mov    %eax,%edi
  802e17:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  802e1e:	00 00 00 
  802e21:	ff d0                	callq  *%rax
  802e23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2a:	79 05                	jns    802e31 <fd2sockid+0x31>
		return r;
  802e2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2f:	eb 24                	jmp    802e55 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e35:	8b 10                	mov    (%rax),%edx
  802e37:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802e3e:	00 00 00 
  802e41:	8b 00                	mov    (%rax),%eax
  802e43:	39 c2                	cmp    %eax,%edx
  802e45:	74 07                	je     802e4e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e47:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e4c:	eb 07                	jmp    802e55 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e52:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e55:	c9                   	leaveq 
  802e56:	c3                   	retq   

0000000000802e57 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e57:	55                   	push   %rbp
  802e58:	48 89 e5             	mov    %rsp,%rbp
  802e5b:	48 83 ec 20          	sub    $0x20,%rsp
  802e5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e62:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e66:	48 89 c7             	mov    %rax,%rdi
  802e69:	48 b8 2e 20 80 00 00 	movabs $0x80202e,%rax
  802e70:	00 00 00 
  802e73:	ff d0                	callq  *%rax
  802e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7c:	78 26                	js     802ea4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e82:	ba 07 04 00 00       	mov    $0x407,%edx
  802e87:	48 89 c6             	mov    %rax,%rsi
  802e8a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e8f:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802e96:	00 00 00 
  802e99:	ff d0                	callq  *%rax
  802e9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea2:	79 16                	jns    802eba <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802ea4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea7:	89 c7                	mov    %eax,%edi
  802ea9:	48 b8 66 33 80 00 00 	movabs $0x803366,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
		return r;
  802eb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb8:	eb 3a                	jmp    802ef4 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebe:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802ec5:	00 00 00 
  802ec8:	8b 12                	mov    (%rdx),%edx
  802eca:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ede:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee5:	48 89 c7             	mov    %rax,%rdi
  802ee8:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
}
  802ef4:	c9                   	leaveq 
  802ef5:	c3                   	retq   

0000000000802ef6 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ef6:	55                   	push   %rbp
  802ef7:	48 89 e5             	mov    %rsp,%rbp
  802efa:	48 83 ec 30          	sub    $0x30,%rsp
  802efe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f05:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0c:	89 c7                	mov    %eax,%edi
  802f0e:	48 b8 00 2e 80 00 00 	movabs $0x802e00,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f21:	79 05                	jns    802f28 <accept+0x32>
		return r;
  802f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f26:	eb 3b                	jmp    802f63 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f28:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f2c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f33:	48 89 ce             	mov    %rcx,%rsi
  802f36:	89 c7                	mov    %eax,%edi
  802f38:	48 b8 43 32 80 00 00 	movabs $0x803243,%rax
  802f3f:	00 00 00 
  802f42:	ff d0                	callq  *%rax
  802f44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4b:	79 05                	jns    802f52 <accept+0x5c>
		return r;
  802f4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f50:	eb 11                	jmp    802f63 <accept+0x6d>
	return alloc_sockfd(r);
  802f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f55:	89 c7                	mov    %eax,%edi
  802f57:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  802f5e:	00 00 00 
  802f61:	ff d0                	callq  *%rax
}
  802f63:	c9                   	leaveq 
  802f64:	c3                   	retq   

0000000000802f65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f65:	55                   	push   %rbp
  802f66:	48 89 e5             	mov    %rsp,%rbp
  802f69:	48 83 ec 20          	sub    $0x20,%rsp
  802f6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f74:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f7a:	89 c7                	mov    %eax,%edi
  802f7c:	48 b8 00 2e 80 00 00 	movabs $0x802e00,%rax
  802f83:	00 00 00 
  802f86:	ff d0                	callq  *%rax
  802f88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8f:	79 05                	jns    802f96 <bind+0x31>
		return r;
  802f91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f94:	eb 1b                	jmp    802fb1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f96:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f99:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa0:	48 89 ce             	mov    %rcx,%rsi
  802fa3:	89 c7                	mov    %eax,%edi
  802fa5:	48 b8 c2 32 80 00 00 	movabs $0x8032c2,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
}
  802fb1:	c9                   	leaveq 
  802fb2:	c3                   	retq   

0000000000802fb3 <shutdown>:

int
shutdown(int s, int how)
{
  802fb3:	55                   	push   %rbp
  802fb4:	48 89 e5             	mov    %rsp,%rbp
  802fb7:	48 83 ec 20          	sub    $0x20,%rsp
  802fbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fbe:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc4:	89 c7                	mov    %eax,%edi
  802fc6:	48 b8 00 2e 80 00 00 	movabs $0x802e00,%rax
  802fcd:	00 00 00 
  802fd0:	ff d0                	callq  *%rax
  802fd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd9:	79 05                	jns    802fe0 <shutdown+0x2d>
		return r;
  802fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fde:	eb 16                	jmp    802ff6 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fe0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fe3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe6:	89 d6                	mov    %edx,%esi
  802fe8:	89 c7                	mov    %eax,%edi
  802fea:	48 b8 26 33 80 00 00 	movabs $0x803326,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
}
  802ff6:	c9                   	leaveq 
  802ff7:	c3                   	retq   

0000000000802ff8 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ff8:	55                   	push   %rbp
  802ff9:	48 89 e5             	mov    %rsp,%rbp
  802ffc:	48 83 ec 10          	sub    $0x10,%rsp
  803000:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803008:	48 89 c7             	mov    %rax,%rdi
  80300b:	48 b8 c5 40 80 00 00 	movabs $0x8040c5,%rax
  803012:	00 00 00 
  803015:	ff d0                	callq  *%rax
  803017:	83 f8 01             	cmp    $0x1,%eax
  80301a:	75 17                	jne    803033 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80301c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803020:	8b 40 0c             	mov    0xc(%rax),%eax
  803023:	89 c7                	mov    %eax,%edi
  803025:	48 b8 66 33 80 00 00 	movabs $0x803366,%rax
  80302c:	00 00 00 
  80302f:	ff d0                	callq  *%rax
  803031:	eb 05                	jmp    803038 <devsock_close+0x40>
	else
		return 0;
  803033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803038:	c9                   	leaveq 
  803039:	c3                   	retq   

000000000080303a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80303a:	55                   	push   %rbp
  80303b:	48 89 e5             	mov    %rsp,%rbp
  80303e:	48 83 ec 20          	sub    $0x20,%rsp
  803042:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803049:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80304c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304f:	89 c7                	mov    %eax,%edi
  803051:	48 b8 00 2e 80 00 00 	movabs $0x802e00,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
  80305d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803064:	79 05                	jns    80306b <connect+0x31>
		return r;
  803066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803069:	eb 1b                	jmp    803086 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80306b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80306e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803075:	48 89 ce             	mov    %rcx,%rsi
  803078:	89 c7                	mov    %eax,%edi
  80307a:	48 b8 93 33 80 00 00 	movabs $0x803393,%rax
  803081:	00 00 00 
  803084:	ff d0                	callq  *%rax
}
  803086:	c9                   	leaveq 
  803087:	c3                   	retq   

0000000000803088 <listen>:

int
listen(int s, int backlog)
{
  803088:	55                   	push   %rbp
  803089:	48 89 e5             	mov    %rsp,%rbp
  80308c:	48 83 ec 20          	sub    $0x20,%rsp
  803090:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803093:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803096:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803099:	89 c7                	mov    %eax,%edi
  80309b:	48 b8 00 2e 80 00 00 	movabs $0x802e00,%rax
  8030a2:	00 00 00 
  8030a5:	ff d0                	callq  *%rax
  8030a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ae:	79 05                	jns    8030b5 <listen+0x2d>
		return r;
  8030b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b3:	eb 16                	jmp    8030cb <listen+0x43>
	return nsipc_listen(r, backlog);
  8030b5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bb:	89 d6                	mov    %edx,%esi
  8030bd:	89 c7                	mov    %eax,%edi
  8030bf:	48 b8 f7 33 80 00 00 	movabs $0x8033f7,%rax
  8030c6:	00 00 00 
  8030c9:	ff d0                	callq  *%rax
}
  8030cb:	c9                   	leaveq 
  8030cc:	c3                   	retq   

00000000008030cd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030cd:	55                   	push   %rbp
  8030ce:	48 89 e5             	mov    %rsp,%rbp
  8030d1:	48 83 ec 20          	sub    $0x20,%rsp
  8030d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e5:	89 c2                	mov    %eax,%edx
  8030e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030eb:	8b 40 0c             	mov    0xc(%rax),%eax
  8030ee:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030f7:	89 c7                	mov    %eax,%edi
  8030f9:	48 b8 37 34 80 00 00 	movabs $0x803437,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
}
  803105:	c9                   	leaveq 
  803106:	c3                   	retq   

0000000000803107 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803107:	55                   	push   %rbp
  803108:	48 89 e5             	mov    %rsp,%rbp
  80310b:	48 83 ec 20          	sub    $0x20,%rsp
  80310f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803113:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803117:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80311b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311f:	89 c2                	mov    %eax,%edx
  803121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803125:	8b 40 0c             	mov    0xc(%rax),%eax
  803128:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80312c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803131:	89 c7                	mov    %eax,%edi
  803133:	48 b8 03 35 80 00 00 	movabs $0x803503,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
}
  80313f:	c9                   	leaveq 
  803140:	c3                   	retq   

0000000000803141 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803141:	55                   	push   %rbp
  803142:	48 89 e5             	mov    %rsp,%rbp
  803145:	48 83 ec 10          	sub    $0x10,%rsp
  803149:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80314d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803155:	48 be 17 49 80 00 00 	movabs $0x804917,%rsi
  80315c:	00 00 00 
  80315f:	48 89 c7             	mov    %rax,%rdi
  803162:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
	return 0;
  80316e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803173:	c9                   	leaveq 
  803174:	c3                   	retq   

0000000000803175 <socket>:

int
socket(int domain, int type, int protocol)
{
  803175:	55                   	push   %rbp
  803176:	48 89 e5             	mov    %rsp,%rbp
  803179:	48 83 ec 20          	sub    $0x20,%rsp
  80317d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803180:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803183:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803186:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803189:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80318c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318f:	89 ce                	mov    %ecx,%esi
  803191:	89 c7                	mov    %eax,%edi
  803193:	48 b8 bb 35 80 00 00 	movabs $0x8035bb,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
  80319f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a6:	79 05                	jns    8031ad <socket+0x38>
		return r;
  8031a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ab:	eb 11                	jmp    8031be <socket+0x49>
	return alloc_sockfd(r);
  8031ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b0:	89 c7                	mov    %eax,%edi
  8031b2:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
}
  8031be:	c9                   	leaveq 
  8031bf:	c3                   	retq   

00000000008031c0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8031c0:	55                   	push   %rbp
  8031c1:	48 89 e5             	mov    %rsp,%rbp
  8031c4:	48 83 ec 10          	sub    $0x10,%rsp
  8031c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031cb:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031d2:	00 00 00 
  8031d5:	8b 00                	mov    (%rax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	75 1f                	jne    8031fa <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031db:	bf 02 00 00 00       	mov    $0x2,%edi
  8031e0:	48 b8 53 40 80 00 00 	movabs $0x804053,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
  8031ec:	89 c2                	mov    %eax,%edx
  8031ee:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031f5:	00 00 00 
  8031f8:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8031fa:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803201:	00 00 00 
  803204:	8b 00                	mov    (%rax),%eax
  803206:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803209:	b9 07 00 00 00       	mov    $0x7,%ecx
  80320e:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803215:	00 00 00 
  803218:	89 c7                	mov    %eax,%edi
  80321a:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  803221:	00 00 00 
  803224:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803226:	ba 00 00 00 00       	mov    $0x0,%edx
  80322b:	be 00 00 00 00       	mov    $0x0,%esi
  803230:	bf 00 00 00 00       	mov    $0x0,%edi
  803235:	48 b8 88 3e 80 00 00 	movabs $0x803e88,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
}
  803241:	c9                   	leaveq 
  803242:	c3                   	retq   

0000000000803243 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803243:	55                   	push   %rbp
  803244:	48 89 e5             	mov    %rsp,%rbp
  803247:	48 83 ec 30          	sub    $0x30,%rsp
  80324b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80324e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803252:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803256:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80325d:	00 00 00 
  803260:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803263:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803265:	bf 01 00 00 00       	mov    $0x1,%edi
  80326a:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  803271:	00 00 00 
  803274:	ff d0                	callq  *%rax
  803276:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803279:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327d:	78 3e                	js     8032bd <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80327f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803286:	00 00 00 
  803289:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80328d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803291:	8b 40 10             	mov    0x10(%rax),%eax
  803294:	89 c2                	mov    %eax,%edx
  803296:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80329a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329e:	48 89 ce             	mov    %rcx,%rsi
  8032a1:	48 89 c7             	mov    %rax,%rdi
  8032a4:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8032ab:	00 00 00 
  8032ae:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8032b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b4:	8b 50 10             	mov    0x10(%rax),%edx
  8032b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032bb:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8032bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032c0:	c9                   	leaveq 
  8032c1:	c3                   	retq   

00000000008032c2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032c2:	55                   	push   %rbp
  8032c3:	48 89 e5             	mov    %rsp,%rbp
  8032c6:	48 83 ec 10          	sub    $0x10,%rsp
  8032ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032d1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032db:	00 00 00 
  8032de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032e1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032e3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ea:	48 89 c6             	mov    %rax,%rsi
  8032ed:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032f4:	00 00 00 
  8032f7:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803303:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80330a:	00 00 00 
  80330d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803310:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803313:	bf 02 00 00 00       	mov    $0x2,%edi
  803318:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
}
  803324:	c9                   	leaveq 
  803325:	c3                   	retq   

0000000000803326 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803326:	55                   	push   %rbp
  803327:	48 89 e5             	mov    %rsp,%rbp
  80332a:	48 83 ec 10          	sub    $0x10,%rsp
  80332e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803331:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803334:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80333b:	00 00 00 
  80333e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803341:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803343:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80334a:	00 00 00 
  80334d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803350:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803353:	bf 03 00 00 00       	mov    $0x3,%edi
  803358:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  80335f:	00 00 00 
  803362:	ff d0                	callq  *%rax
}
  803364:	c9                   	leaveq 
  803365:	c3                   	retq   

0000000000803366 <nsipc_close>:

int
nsipc_close(int s)
{
  803366:	55                   	push   %rbp
  803367:	48 89 e5             	mov    %rsp,%rbp
  80336a:	48 83 ec 10          	sub    $0x10,%rsp
  80336e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803371:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803378:	00 00 00 
  80337b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80337e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803380:	bf 04 00 00 00       	mov    $0x4,%edi
  803385:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
}
  803391:	c9                   	leaveq 
  803392:	c3                   	retq   

0000000000803393 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803393:	55                   	push   %rbp
  803394:	48 89 e5             	mov    %rsp,%rbp
  803397:	48 83 ec 10          	sub    $0x10,%rsp
  80339b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80339e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033a2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8033a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ac:	00 00 00 
  8033af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033b2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033b4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033bb:	48 89 c6             	mov    %rax,%rsi
  8033be:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033c5:	00 00 00 
  8033c8:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033db:	00 00 00 
  8033de:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033e1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033e4:	bf 05 00 00 00       	mov    $0x5,%edi
  8033e9:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
}
  8033f5:	c9                   	leaveq 
  8033f6:	c3                   	retq   

00000000008033f7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033f7:	55                   	push   %rbp
  8033f8:	48 89 e5             	mov    %rsp,%rbp
  8033fb:	48 83 ec 10          	sub    $0x10,%rsp
  8033ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803402:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803405:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340c:	00 00 00 
  80340f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803412:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803414:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80341b:	00 00 00 
  80341e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803421:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803424:	bf 06 00 00 00       	mov    $0x6,%edi
  803429:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
}
  803435:	c9                   	leaveq 
  803436:	c3                   	retq   

0000000000803437 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803437:	55                   	push   %rbp
  803438:	48 89 e5             	mov    %rsp,%rbp
  80343b:	48 83 ec 30          	sub    $0x30,%rsp
  80343f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803442:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803446:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803449:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80344c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803453:	00 00 00 
  803456:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803459:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80345b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803462:	00 00 00 
  803465:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803468:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80346b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803472:	00 00 00 
  803475:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803478:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80347b:	bf 07 00 00 00       	mov    $0x7,%edi
  803480:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  803487:	00 00 00 
  80348a:	ff d0                	callq  *%rax
  80348c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80348f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803493:	78 69                	js     8034fe <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803495:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80349c:	7f 08                	jg     8034a6 <nsipc_recv+0x6f>
  80349e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a1:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8034a4:	7e 35                	jle    8034db <nsipc_recv+0xa4>
  8034a6:	48 b9 1e 49 80 00 00 	movabs $0x80491e,%rcx
  8034ad:	00 00 00 
  8034b0:	48 ba 33 49 80 00 00 	movabs $0x804933,%rdx
  8034b7:	00 00 00 
  8034ba:	be 61 00 00 00       	mov    $0x61,%esi
  8034bf:	48 bf 48 49 80 00 00 	movabs $0x804948,%rdi
  8034c6:	00 00 00 
  8034c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ce:	49 b8 98 04 80 00 00 	movabs $0x800498,%r8
  8034d5:	00 00 00 
  8034d8:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034de:	48 63 d0             	movslq %eax,%rdx
  8034e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8034ec:	00 00 00 
  8034ef:	48 89 c7             	mov    %rax,%rdi
  8034f2:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
	}

	return r;
  8034fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803501:	c9                   	leaveq 
  803502:	c3                   	retq   

0000000000803503 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803503:	55                   	push   %rbp
  803504:	48 89 e5             	mov    %rsp,%rbp
  803507:	48 83 ec 20          	sub    $0x20,%rsp
  80350b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80350e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803512:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803515:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803518:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80351f:	00 00 00 
  803522:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803525:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803527:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80352e:	7e 35                	jle    803565 <nsipc_send+0x62>
  803530:	48 b9 54 49 80 00 00 	movabs $0x804954,%rcx
  803537:	00 00 00 
  80353a:	48 ba 33 49 80 00 00 	movabs $0x804933,%rdx
  803541:	00 00 00 
  803544:	be 6c 00 00 00       	mov    $0x6c,%esi
  803549:	48 bf 48 49 80 00 00 	movabs $0x804948,%rdi
  803550:	00 00 00 
  803553:	b8 00 00 00 00       	mov    $0x0,%eax
  803558:	49 b8 98 04 80 00 00 	movabs $0x800498,%r8
  80355f:	00 00 00 
  803562:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803565:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803568:	48 63 d0             	movslq %eax,%rdx
  80356b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356f:	48 89 c6             	mov    %rax,%rsi
  803572:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803579:	00 00 00 
  80357c:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803588:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80358f:	00 00 00 
  803592:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803595:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803598:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359f:	00 00 00 
  8035a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035a5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8035a8:	bf 08 00 00 00       	mov    $0x8,%edi
  8035ad:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
}
  8035b9:	c9                   	leaveq 
  8035ba:	c3                   	retq   

00000000008035bb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8035bb:	55                   	push   %rbp
  8035bc:	48 89 e5             	mov    %rsp,%rbp
  8035bf:	48 83 ec 10          	sub    $0x10,%rsp
  8035c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035c6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035c9:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035d3:	00 00 00 
  8035d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035d9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035e2:	00 00 00 
  8035e5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035e8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f2:	00 00 00 
  8035f5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035f8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8035fb:	bf 09 00 00 00       	mov    $0x9,%edi
  803600:	48 b8 c0 31 80 00 00 	movabs $0x8031c0,%rax
  803607:	00 00 00 
  80360a:	ff d0                	callq  *%rax
}
  80360c:	c9                   	leaveq 
  80360d:	c3                   	retq   

000000000080360e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80360e:	55                   	push   %rbp
  80360f:	48 89 e5             	mov    %rsp,%rbp
  803612:	53                   	push   %rbx
  803613:	48 83 ec 38          	sub    $0x38,%rsp
  803617:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80361b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80361f:	48 89 c7             	mov    %rax,%rdi
  803622:	48 b8 2e 20 80 00 00 	movabs $0x80202e,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
  80362e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803631:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803635:	0f 88 bf 01 00 00    	js     8037fa <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80363b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363f:	ba 07 04 00 00       	mov    $0x407,%edx
  803644:	48 89 c6             	mov    %rax,%rsi
  803647:	bf 00 00 00 00       	mov    $0x0,%edi
  80364c:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
  803658:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80365f:	0f 88 95 01 00 00    	js     8037fa <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803665:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803669:	48 89 c7             	mov    %rax,%rdi
  80366c:	48 b8 2e 20 80 00 00 	movabs $0x80202e,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
  803678:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80367b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80367f:	0f 88 5d 01 00 00    	js     8037e2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803685:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803689:	ba 07 04 00 00       	mov    $0x407,%edx
  80368e:	48 89 c6             	mov    %rax,%rsi
  803691:	bf 00 00 00 00       	mov    $0x0,%edi
  803696:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
  8036a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036a9:	0f 88 33 01 00 00    	js     8037e2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b3:	48 89 c7             	mov    %rax,%rdi
  8036b6:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ca:	ba 07 04 00 00       	mov    $0x407,%edx
  8036cf:	48 89 c6             	mov    %rax,%rsi
  8036d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d7:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	callq  *%rax
  8036e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ea:	79 05                	jns    8036f1 <pipe+0xe3>
		goto err2;
  8036ec:	e9 d9 00 00 00       	jmpq   8037ca <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f5:	48 89 c7             	mov    %rax,%rdi
  8036f8:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
  803704:	48 89 c2             	mov    %rax,%rdx
  803707:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80370b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803711:	48 89 d1             	mov    %rdx,%rcx
  803714:	ba 00 00 00 00       	mov    $0x0,%edx
  803719:	48 89 c6             	mov    %rax,%rsi
  80371c:	bf 00 00 00 00       	mov    $0x0,%edi
  803721:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803728:	00 00 00 
  80372b:	ff d0                	callq  *%rax
  80372d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803730:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803734:	79 1b                	jns    803751 <pipe+0x143>
		goto err3;
  803736:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803737:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80373b:	48 89 c6             	mov    %rax,%rsi
  80373e:	bf 00 00 00 00       	mov    $0x0,%edi
  803743:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  80374a:	00 00 00 
  80374d:	ff d0                	callq  *%rax
  80374f:	eb 79                	jmp    8037ca <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803755:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80375c:	00 00 00 
  80375f:	8b 12                	mov    (%rdx),%edx
  803761:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803767:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80376e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803772:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803779:	00 00 00 
  80377c:	8b 12                	mov    (%rdx),%edx
  80377e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803784:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80378b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378f:	48 89 c7             	mov    %rax,%rdi
  803792:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  803799:	00 00 00 
  80379c:	ff d0                	callq  *%rax
  80379e:	89 c2                	mov    %eax,%edx
  8037a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037a4:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8037a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037aa:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8037ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037b2:	48 89 c7             	mov    %rax,%rdi
  8037b5:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  8037bc:	00 00 00 
  8037bf:	ff d0                	callq  *%rax
  8037c1:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c8:	eb 33                	jmp    8037fd <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8037ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ce:	48 89 c6             	mov    %rax,%rsi
  8037d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d6:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e6:	48 89 c6             	mov    %rax,%rsi
  8037e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ee:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
err:
	return r;
  8037fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037fd:	48 83 c4 38          	add    $0x38,%rsp
  803801:	5b                   	pop    %rbx
  803802:	5d                   	pop    %rbp
  803803:	c3                   	retq   

0000000000803804 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803804:	55                   	push   %rbp
  803805:	48 89 e5             	mov    %rsp,%rbp
  803808:	53                   	push   %rbx
  803809:	48 83 ec 28          	sub    $0x28,%rsp
  80380d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803811:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803815:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80381c:	00 00 00 
  80381f:	48 8b 00             	mov    (%rax),%rax
  803822:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803828:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80382b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382f:	48 89 c7             	mov    %rax,%rdi
  803832:	48 b8 c5 40 80 00 00 	movabs $0x8040c5,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	89 c3                	mov    %eax,%ebx
  803840:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803844:	48 89 c7             	mov    %rax,%rdi
  803847:	48 b8 c5 40 80 00 00 	movabs $0x8040c5,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
  803853:	39 c3                	cmp    %eax,%ebx
  803855:	0f 94 c0             	sete   %al
  803858:	0f b6 c0             	movzbl %al,%eax
  80385b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80385e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803865:	00 00 00 
  803868:	48 8b 00             	mov    (%rax),%rax
  80386b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803871:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803874:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803877:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80387a:	75 05                	jne    803881 <_pipeisclosed+0x7d>
			return ret;
  80387c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80387f:	eb 4a                	jmp    8038cb <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803881:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803884:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803887:	74 3d                	je     8038c6 <_pipeisclosed+0xc2>
  803889:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80388d:	75 37                	jne    8038c6 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80388f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803896:	00 00 00 
  803899:	48 8b 00             	mov    (%rax),%rax
  80389c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038a2:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a8:	89 c6                	mov    %eax,%esi
  8038aa:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
  8038b1:	00 00 00 
  8038b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b9:	49 b8 d1 06 80 00 00 	movabs $0x8006d1,%r8
  8038c0:	00 00 00 
  8038c3:	41 ff d0             	callq  *%r8
	}
  8038c6:	e9 4a ff ff ff       	jmpq   803815 <_pipeisclosed+0x11>
}
  8038cb:	48 83 c4 28          	add    $0x28,%rsp
  8038cf:	5b                   	pop    %rbx
  8038d0:	5d                   	pop    %rbp
  8038d1:	c3                   	retq   

00000000008038d2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038d2:	55                   	push   %rbp
  8038d3:	48 89 e5             	mov    %rsp,%rbp
  8038d6:	48 83 ec 30          	sub    $0x30,%rsp
  8038da:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038e4:	48 89 d6             	mov    %rdx,%rsi
  8038e7:	89 c7                	mov    %eax,%edi
  8038e9:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
  8038f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fc:	79 05                	jns    803903 <pipeisclosed+0x31>
		return r;
  8038fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803901:	eb 31                	jmp    803934 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803907:	48 89 c7             	mov    %rax,%rdi
  80390a:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
  803916:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80391a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803922:	48 89 d6             	mov    %rdx,%rsi
  803925:	48 89 c7             	mov    %rax,%rdi
  803928:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
}
  803934:	c9                   	leaveq 
  803935:	c3                   	retq   

0000000000803936 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803936:	55                   	push   %rbp
  803937:	48 89 e5             	mov    %rsp,%rbp
  80393a:	48 83 ec 40          	sub    $0x40,%rsp
  80393e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803942:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803946:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80394a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80394e:	48 89 c7             	mov    %rax,%rdi
  803951:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
  80395d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803961:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803965:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803969:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803970:	00 
  803971:	e9 92 00 00 00       	jmpq   803a08 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803976:	eb 41                	jmp    8039b9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803978:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80397d:	74 09                	je     803988 <devpipe_read+0x52>
				return i;
  80397f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803983:	e9 92 00 00 00       	jmpq   803a1a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80398c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803990:	48 89 d6             	mov    %rdx,%rsi
  803993:	48 89 c7             	mov    %rax,%rdi
  803996:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	74 07                	je     8039ad <devpipe_read+0x77>
				return 0;
  8039a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ab:	eb 6d                	jmp    803a1a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039ad:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  8039b4:	00 00 00 
  8039b7:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8039b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bd:	8b 10                	mov    (%rax),%edx
  8039bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c3:	8b 40 04             	mov    0x4(%rax),%eax
  8039c6:	39 c2                	cmp    %eax,%edx
  8039c8:	74 ae                	je     803978 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039da:	8b 00                	mov    (%rax),%eax
  8039dc:	99                   	cltd   
  8039dd:	c1 ea 1b             	shr    $0x1b,%edx
  8039e0:	01 d0                	add    %edx,%eax
  8039e2:	83 e0 1f             	and    $0x1f,%eax
  8039e5:	29 d0                	sub    %edx,%eax
  8039e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039eb:	48 98                	cltq   
  8039ed:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039f2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f8:	8b 00                	mov    (%rax),%eax
  8039fa:	8d 50 01             	lea    0x1(%rax),%edx
  8039fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a01:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803a03:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a10:	0f 82 60 ff ff ff    	jb     803976 <devpipe_read+0x40>
	}
	return i;
  803a16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a1a:	c9                   	leaveq 
  803a1b:	c3                   	retq   

0000000000803a1c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a1c:	55                   	push   %rbp
  803a1d:	48 89 e5             	mov    %rsp,%rbp
  803a20:	48 83 ec 40          	sub    $0x40,%rsp
  803a24:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a2c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a34:	48 89 c7             	mov    %rax,%rdi
  803a37:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  803a3e:	00 00 00 
  803a41:	ff d0                	callq  *%rax
  803a43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a4f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a56:	00 
  803a57:	e9 91 00 00 00       	jmpq   803aed <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a5c:	eb 31                	jmp    803a8f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a66:	48 89 d6             	mov    %rdx,%rsi
  803a69:	48 89 c7             	mov    %rax,%rdi
  803a6c:	48 b8 04 38 80 00 00 	movabs $0x803804,%rax
  803a73:	00 00 00 
  803a76:	ff d0                	callq  *%rax
  803a78:	85 c0                	test   %eax,%eax
  803a7a:	74 07                	je     803a83 <devpipe_write+0x67>
				return 0;
  803a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a81:	eb 7c                	jmp    803aff <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a83:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a93:	8b 40 04             	mov    0x4(%rax),%eax
  803a96:	48 63 d0             	movslq %eax,%rdx
  803a99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9d:	8b 00                	mov    (%rax),%eax
  803a9f:	48 98                	cltq   
  803aa1:	48 83 c0 20          	add    $0x20,%rax
  803aa5:	48 39 c2             	cmp    %rax,%rdx
  803aa8:	73 b4                	jae    803a5e <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aae:	8b 40 04             	mov    0x4(%rax),%eax
  803ab1:	99                   	cltd   
  803ab2:	c1 ea 1b             	shr    $0x1b,%edx
  803ab5:	01 d0                	add    %edx,%eax
  803ab7:	83 e0 1f             	and    $0x1f,%eax
  803aba:	29 d0                	sub    %edx,%eax
  803abc:	89 c6                	mov    %eax,%esi
  803abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac6:	48 01 d0             	add    %rdx,%rax
  803ac9:	0f b6 08             	movzbl (%rax),%ecx
  803acc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ad0:	48 63 c6             	movslq %esi,%rax
  803ad3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803adb:	8b 40 04             	mov    0x4(%rax),%eax
  803ade:	8d 50 01             	lea    0x1(%rax),%edx
  803ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae5:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803ae8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803af5:	0f 82 61 ff ff ff    	jb     803a5c <devpipe_write+0x40>
	}

	return i;
  803afb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803aff:	c9                   	leaveq 
  803b00:	c3                   	retq   

0000000000803b01 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b01:	55                   	push   %rbp
  803b02:	48 89 e5             	mov    %rsp,%rbp
  803b05:	48 83 ec 20          	sub    $0x20,%rsp
  803b09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b15:	48 89 c7             	mov    %rax,%rdi
  803b18:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
  803b24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2c:	48 be 78 49 80 00 00 	movabs $0x804978,%rsi
  803b33:	00 00 00 
  803b36:	48 89 c7             	mov    %rax,%rdi
  803b39:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b49:	8b 50 04             	mov    0x4(%rax),%edx
  803b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b50:	8b 00                	mov    (%rax),%eax
  803b52:	29 c2                	sub    %eax,%edx
  803b54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b58:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b62:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b69:	00 00 00 
	stat->st_dev = &devpipe;
  803b6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b70:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b77:	00 00 00 
  803b7a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b86:	c9                   	leaveq 
  803b87:	c3                   	retq   

0000000000803b88 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b88:	55                   	push   %rbp
  803b89:	48 89 e5             	mov    %rsp,%rbp
  803b8c:	48 83 ec 10          	sub    $0x10,%rsp
  803b90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b98:	48 89 c6             	mov    %rax,%rsi
  803b9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba0:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  803ba7:	00 00 00 
  803baa:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb0:	48 89 c7             	mov    %rax,%rdi
  803bb3:	48 b8 03 20 80 00 00 	movabs $0x802003,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
  803bbf:	48 89 c6             	mov    %rax,%rsi
  803bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc7:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  803bce:	00 00 00 
  803bd1:	ff d0                	callq  *%rax
}
  803bd3:	c9                   	leaveq 
  803bd4:	c3                   	retq   

0000000000803bd5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bd5:	55                   	push   %rbp
  803bd6:	48 89 e5             	mov    %rsp,%rbp
  803bd9:	48 83 ec 20          	sub    $0x20,%rsp
  803bdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803be0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803be3:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803be6:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bea:	be 01 00 00 00       	mov    $0x1,%esi
  803bef:	48 89 c7             	mov    %rax,%rdi
  803bf2:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
}
  803bfe:	c9                   	leaveq 
  803bff:	c3                   	retq   

0000000000803c00 <getchar>:

int
getchar(void)
{
  803c00:	55                   	push   %rbp
  803c01:	48 89 e5             	mov    %rsp,%rbp
  803c04:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c08:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c0c:	ba 01 00 00 00       	mov    $0x1,%edx
  803c11:	48 89 c6             	mov    %rax,%rsi
  803c14:	bf 00 00 00 00       	mov    $0x0,%edi
  803c19:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  803c20:	00 00 00 
  803c23:	ff d0                	callq  *%rax
  803c25:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2c:	79 05                	jns    803c33 <getchar+0x33>
		return r;
  803c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c31:	eb 14                	jmp    803c47 <getchar+0x47>
	if (r < 1)
  803c33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c37:	7f 07                	jg     803c40 <getchar+0x40>
		return -E_EOF;
  803c39:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c3e:	eb 07                	jmp    803c47 <getchar+0x47>
	return c;
  803c40:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c44:	0f b6 c0             	movzbl %al,%eax
}
  803c47:	c9                   	leaveq 
  803c48:	c3                   	retq   

0000000000803c49 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c49:	55                   	push   %rbp
  803c4a:	48 89 e5             	mov    %rsp,%rbp
  803c4d:	48 83 ec 20          	sub    $0x20,%rsp
  803c51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c5b:	48 89 d6             	mov    %rdx,%rsi
  803c5e:	89 c7                	mov    %eax,%edi
  803c60:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  803c67:	00 00 00 
  803c6a:	ff d0                	callq  *%rax
  803c6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c73:	79 05                	jns    803c7a <iscons+0x31>
		return r;
  803c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c78:	eb 1a                	jmp    803c94 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7e:	8b 10                	mov    (%rax),%edx
  803c80:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c87:	00 00 00 
  803c8a:	8b 00                	mov    (%rax),%eax
  803c8c:	39 c2                	cmp    %eax,%edx
  803c8e:	0f 94 c0             	sete   %al
  803c91:	0f b6 c0             	movzbl %al,%eax
}
  803c94:	c9                   	leaveq 
  803c95:	c3                   	retq   

0000000000803c96 <opencons>:

int
opencons(void)
{
  803c96:	55                   	push   %rbp
  803c97:	48 89 e5             	mov    %rsp,%rbp
  803c9a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c9e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ca2:	48 89 c7             	mov    %rax,%rdi
  803ca5:	48 b8 2e 20 80 00 00 	movabs $0x80202e,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
  803cb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb8:	79 05                	jns    803cbf <opencons+0x29>
		return r;
  803cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbd:	eb 5b                	jmp    803d1a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc3:	ba 07 04 00 00       	mov    $0x407,%edx
  803cc8:	48 89 c6             	mov    %rax,%rsi
  803ccb:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd0:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  803cd7:	00 00 00 
  803cda:	ff d0                	callq  *%rax
  803cdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce3:	79 05                	jns    803cea <opencons+0x54>
		return r;
  803ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce8:	eb 30                	jmp    803d1a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cee:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803cf5:	00 00 00 
  803cf8:	8b 12                	mov    (%rdx),%edx
  803cfa:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d00:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0b:	48 89 c7             	mov    %rax,%rdi
  803d0e:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  803d15:	00 00 00 
  803d18:	ff d0                	callq  *%rax
}
  803d1a:	c9                   	leaveq 
  803d1b:	c3                   	retq   

0000000000803d1c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d1c:	55                   	push   %rbp
  803d1d:	48 89 e5             	mov    %rsp,%rbp
  803d20:	48 83 ec 30          	sub    $0x30,%rsp
  803d24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d30:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d35:	75 07                	jne    803d3e <devcons_read+0x22>
		return 0;
  803d37:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3c:	eb 4b                	jmp    803d89 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d3e:	eb 0c                	jmp    803d4c <devcons_read+0x30>
		sys_yield();
  803d40:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  803d47:	00 00 00 
  803d4a:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803d4c:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  803d53:	00 00 00 
  803d56:	ff d0                	callq  *%rax
  803d58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d5f:	74 df                	je     803d40 <devcons_read+0x24>
	if (c < 0)
  803d61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d65:	79 05                	jns    803d6c <devcons_read+0x50>
		return c;
  803d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6a:	eb 1d                	jmp    803d89 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d6c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d70:	75 07                	jne    803d79 <devcons_read+0x5d>
		return 0;
  803d72:	b8 00 00 00 00       	mov    $0x0,%eax
  803d77:	eb 10                	jmp    803d89 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7c:	89 c2                	mov    %eax,%edx
  803d7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d82:	88 10                	mov    %dl,(%rax)
	return 1;
  803d84:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d89:	c9                   	leaveq 
  803d8a:	c3                   	retq   

0000000000803d8b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d8b:	55                   	push   %rbp
  803d8c:	48 89 e5             	mov    %rsp,%rbp
  803d8f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d96:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d9d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803da4:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803db2:	eb 76                	jmp    803e2a <devcons_write+0x9f>
		m = n - tot;
  803db4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dbb:	89 c2                	mov    %eax,%edx
  803dbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc0:	29 c2                	sub    %eax,%edx
  803dc2:	89 d0                	mov    %edx,%eax
  803dc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dca:	83 f8 7f             	cmp    $0x7f,%eax
  803dcd:	76 07                	jbe    803dd6 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dcf:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803dd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd9:	48 63 d0             	movslq %eax,%rdx
  803ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddf:	48 63 c8             	movslq %eax,%rcx
  803de2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803de9:	48 01 c1             	add    %rax,%rcx
  803dec:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803df3:	48 89 ce             	mov    %rcx,%rsi
  803df6:	48 89 c7             	mov    %rax,%rdi
  803df9:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  803e00:	00 00 00 
  803e03:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e08:	48 63 d0             	movslq %eax,%rdx
  803e0b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e12:	48 89 d6             	mov    %rdx,%rsi
  803e15:	48 89 c7             	mov    %rax,%rdi
  803e18:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803e1f:	00 00 00 
  803e22:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803e24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e27:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2d:	48 98                	cltq   
  803e2f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e36:	0f 82 78 ff ff ff    	jb     803db4 <devcons_write+0x29>
	}
	return tot;
  803e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e3f:	c9                   	leaveq 
  803e40:	c3                   	retq   

0000000000803e41 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e41:	55                   	push   %rbp
  803e42:	48 89 e5             	mov    %rsp,%rbp
  803e45:	48 83 ec 08          	sub    $0x8,%rsp
  803e49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e52:	c9                   	leaveq 
  803e53:	c3                   	retq   

0000000000803e54 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e54:	55                   	push   %rbp
  803e55:	48 89 e5             	mov    %rsp,%rbp
  803e58:	48 83 ec 10          	sub    $0x10,%rsp
  803e5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e68:	48 be 84 49 80 00 00 	movabs $0x804984,%rsi
  803e6f:	00 00 00 
  803e72:	48 89 c7             	mov    %rax,%rdi
  803e75:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
	return 0;
  803e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e86:	c9                   	leaveq 
  803e87:	c3                   	retq   

0000000000803e88 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e88:	55                   	push   %rbp
  803e89:	48 89 e5             	mov    %rsp,%rbp
  803e8c:	48 83 ec 20          	sub    $0x20,%rsp
  803e90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e98:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803e9c:	48 ba 90 49 80 00 00 	movabs $0x804990,%rdx
  803ea3:	00 00 00 
  803ea6:	be 1d 00 00 00       	mov    $0x1d,%esi
  803eab:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  803eb2:	00 00 00 
  803eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eba:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  803ec1:	00 00 00 
  803ec4:	ff d1                	callq  *%rcx

0000000000803ec6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ec6:	55                   	push   %rbp
  803ec7:	48 89 e5             	mov    %rsp,%rbp
  803eca:	48 83 ec 20          	sub    $0x20,%rsp
  803ece:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ed1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ed4:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803ed8:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803edb:	48 ba b3 49 80 00 00 	movabs $0x8049b3,%rdx
  803ee2:	00 00 00 
  803ee5:	be 2d 00 00 00       	mov    $0x2d,%esi
  803eea:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  803ef1:	00 00 00 
  803ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef9:	48 b9 98 04 80 00 00 	movabs $0x800498,%rcx
  803f00:	00 00 00 
  803f03:	ff d1                	callq  *%rcx

0000000000803f05 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803f05:	55                   	push   %rbp
  803f06:	48 89 e5             	mov    %rsp,%rbp
  803f09:	53                   	push   %rbx
  803f0a:	48 83 ec 48          	sub    $0x48,%rsp
  803f0e:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803f12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803f19:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803f20:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803f25:	75 0e                	jne    803f35 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803f27:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803f2e:	00 00 00 
  803f31:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803f35:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f39:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803f3d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803f44:	00 
	a3 = (uint64_t) 0;
  803f45:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803f4c:	00 
	a4 = (uint64_t) 0;
  803f4d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803f54:	00 
	a5 = 0;
  803f55:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803f5c:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803f5d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f60:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f64:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803f68:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803f6c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803f70:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803f74:	4c 89 c3             	mov    %r8,%rbx
  803f77:	0f 01 c1             	vmcall 
  803f7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803f7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f81:	7e 36                	jle    803fb9 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803f83:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f86:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f89:	41 89 d0             	mov    %edx,%r8d
  803f8c:	89 c1                	mov    %eax,%ecx
  803f8e:	48 ba d0 49 80 00 00 	movabs $0x8049d0,%rdx
  803f95:	00 00 00 
  803f98:	be 54 00 00 00       	mov    $0x54,%esi
  803f9d:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  803fa4:	00 00 00 
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fac:	49 b9 98 04 80 00 00 	movabs $0x800498,%r9
  803fb3:	00 00 00 
  803fb6:	41 ff d1             	callq  *%r9
	return ret;
  803fb9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803fbc:	48 83 c4 48          	add    $0x48,%rsp
  803fc0:	5b                   	pop    %rbx
  803fc1:	5d                   	pop    %rbp
  803fc2:	c3                   	retq   

0000000000803fc3 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fc3:	55                   	push   %rbp
  803fc4:	48 89 e5             	mov    %rsp,%rbp
  803fc7:	53                   	push   %rbx
  803fc8:	48 83 ec 58          	sub    $0x58,%rsp
  803fcc:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803fcf:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803fd2:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803fd6:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803fd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803fe0:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803fe7:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803fec:	75 0e                	jne    803ffc <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803fee:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ff5:	00 00 00 
  803ff8:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803ffc:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803fff:	48 98                	cltq   
  804001:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804005:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804008:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  80400c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804010:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804014:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  804017:	48 98                	cltq   
  804019:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  80401d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804024:	00 

	int r = -E_IPC_NOT_RECV;
  804025:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  80402c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80402f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804033:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804037:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  80403b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80403f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804043:	4c 89 c3             	mov    %r8,%rbx
  804046:	0f 01 c1             	vmcall 
  804049:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  80404c:	48 83 c4 58          	add    $0x58,%rsp
  804050:	5b                   	pop    %rbx
  804051:	5d                   	pop    %rbp
  804052:	c3                   	retq   

0000000000804053 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804053:	55                   	push   %rbp
  804054:	48 89 e5             	mov    %rsp,%rbp
  804057:	48 83 ec 18          	sub    $0x18,%rsp
  80405b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80405e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804065:	eb 4e                	jmp    8040b5 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804067:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80406e:	00 00 00 
  804071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804074:	48 98                	cltq   
  804076:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80407d:	48 01 d0             	add    %rdx,%rax
  804080:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804086:	8b 00                	mov    (%rax),%eax
  804088:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80408b:	75 24                	jne    8040b1 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80408d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804094:	00 00 00 
  804097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409a:	48 98                	cltq   
  80409c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8040a3:	48 01 d0             	add    %rdx,%rax
  8040a6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040ac:	8b 40 08             	mov    0x8(%rax),%eax
  8040af:	eb 12                	jmp    8040c3 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  8040b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040b5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040bc:	7e a9                	jle    804067 <ipc_find_env+0x14>
	}
	return 0;
  8040be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c3:	c9                   	leaveq 
  8040c4:	c3                   	retq   

00000000008040c5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040c5:	55                   	push   %rbp
  8040c6:	48 89 e5             	mov    %rsp,%rbp
  8040c9:	48 83 ec 18          	sub    $0x18,%rsp
  8040cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d5:	48 c1 e8 15          	shr    $0x15,%rax
  8040d9:	48 89 c2             	mov    %rax,%rdx
  8040dc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040e3:	01 00 00 
  8040e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040ea:	83 e0 01             	and    $0x1,%eax
  8040ed:	48 85 c0             	test   %rax,%rax
  8040f0:	75 07                	jne    8040f9 <pageref+0x34>
		return 0;
  8040f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f7:	eb 53                	jmp    80414c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040fd:	48 c1 e8 0c          	shr    $0xc,%rax
  804101:	48 89 c2             	mov    %rax,%rdx
  804104:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80410b:	01 00 00 
  80410e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804112:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411a:	83 e0 01             	and    $0x1,%eax
  80411d:	48 85 c0             	test   %rax,%rax
  804120:	75 07                	jne    804129 <pageref+0x64>
		return 0;
  804122:	b8 00 00 00 00       	mov    $0x0,%eax
  804127:	eb 23                	jmp    80414c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412d:	48 c1 e8 0c          	shr    $0xc,%rax
  804131:	48 89 c2             	mov    %rax,%rdx
  804134:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80413b:	00 00 00 
  80413e:	48 c1 e2 04          	shl    $0x4,%rdx
  804142:	48 01 d0             	add    %rdx,%rax
  804145:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804149:	0f b7 c0             	movzwl %ax,%eax
}
  80414c:	c9                   	leaveq 
  80414d:	c3                   	retq   
