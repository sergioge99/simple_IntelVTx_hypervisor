
vmm/guest/obj/user/init:     formato del fichero elf64-x86-64


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
  80003c:	e8 69 06 00 00       	callq  8006aa <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf 90 4b 80 00 00 	movabs $0x804b90,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 66 09 80 00 00 	movabs $0x800966,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf c9 4b 80 00 00 	movabs $0x804bc9,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 40 90 80 00 00 	movabs $0x809040,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 0f 4c 80 00 00 	movabs $0x804c0f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be 25 4c 80 00 00 	movabs $0x804c25,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be 31 4c 80 00 00 	movabs $0x804c31,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be 34 4c 80 00 00 	movabs $0x804c34,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf 36 4c 80 00 00 	movabs $0x804c36,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf 3a 4c 80 00 00 	movabs $0x804c3a,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 b8 04 80 00 00 	movabs $0x8004b8,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba 4c 4c 80 00 00 	movabs $0x804c4c,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf 59 4c 80 00 00 	movabs $0x804c59,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba 65 4c 80 00 00 	movabs $0x804c65,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf 59 4c 80 00 00 	movabs $0x804c59,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 7f 4c 80 00 00 	movabs $0x804c7f,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf 59 4c 80 00 00 	movabs $0x804c59,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 87 4c 80 00 00 	movabs $0x804c87,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 9a 4c 80 00 00 	movabs $0x804c9a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 9d 4c 80 00 00 	movabs $0x804c9d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 0e 33 80 00 00 	movabs $0x80330e,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 22                	jns    8003c8 <umain+0x33b>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf a5 4c 80 00 00 	movabs $0x804ca5,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
		cprintf("init waiting\n");
		wait(r);
#ifdef VMM_GUEST
		break;
#endif
	}
  8003c6:	eb 90                	jmp    800358 <umain+0x2cb>
		cprintf("init waiting\n");
  8003c8:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  8003cf:	00 00 00 
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  8003de:	00 00 00 
  8003e1:	ff d2                	callq  *%rdx
		wait(r);
  8003e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e6:	89 c7                	mov    %eax,%edi
  8003e8:	48 b8 ef 47 80 00 00 	movabs $0x8047ef,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
		break;
  8003f4:	90                   	nop
}
  8003f5:	c9                   	leaveq 
  8003f6:	c3                   	retq   

00000000008003f7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003f7:	55                   	push   %rbp
  8003f8:	48 89 e5             	mov    %rsp,%rbp
  8003fb:	48 83 ec 20          	sub    $0x20,%rsp
  8003ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800402:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800405:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800408:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040c:	be 01 00 00 00       	mov    $0x1,%esi
  800411:	48 89 c7             	mov    %rax,%rdi
  800414:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
}
  800420:	c9                   	leaveq 
  800421:	c3                   	retq   

0000000000800422 <getchar>:

int
getchar(void)
{
  800422:	55                   	push   %rbp
  800423:	48 89 e5             	mov    %rsp,%rbp
  800426:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80042e:	ba 01 00 00 00       	mov    $0x1,%edx
  800433:	48 89 c6             	mov    %rax,%rsi
  800436:	bf 00 00 00 00       	mov    $0x0,%edi
  80043b:	48 b8 af 26 80 00 00 	movabs $0x8026af,%rax
  800442:	00 00 00 
  800445:	ff d0                	callq  *%rax
  800447:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044e:	79 05                	jns    800455 <getchar+0x33>
		return r;
  800450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800453:	eb 14                	jmp    800469 <getchar+0x47>
	if (r < 1)
  800455:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800459:	7f 07                	jg     800462 <getchar+0x40>
		return -E_EOF;
  80045b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800460:	eb 07                	jmp    800469 <getchar+0x47>
	return c;
  800462:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800466:	0f b6 c0             	movzbl %al,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 20          	sub    $0x20,%rsp
  800473:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800476:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80047d:	48 89 d6             	mov    %rdx,%rsi
  800480:	89 c7                	mov    %eax,%edi
  800482:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
  80048e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800491:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800495:	79 05                	jns    80049c <iscons+0x31>
		return r;
  800497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049a:	eb 1a                	jmp    8004b6 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 10                	mov    (%rax),%edx
  8004a2:	48 b8 80 87 80 00 00 	movabs $0x808780,%rax
  8004a9:	00 00 00 
  8004ac:	8b 00                	mov    (%rax),%eax
  8004ae:	39 c2                	cmp    %eax,%edx
  8004b0:	0f 94 c0             	sete   %al
  8004b3:	0f b6 c0             	movzbl %al,%eax
}
  8004b6:	c9                   	leaveq 
  8004b7:	c3                   	retq   

00000000008004b8 <opencons>:

int
opencons(void)
{
  8004b8:	55                   	push   %rbp
  8004b9:	48 89 e5             	mov    %rsp,%rbp
  8004bc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c4:	48 89 c7             	mov    %rax,%rdi
  8004c7:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  8004ce:	00 00 00 
  8004d1:	ff d0                	callq  *%rax
  8004d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004da:	79 05                	jns    8004e1 <opencons+0x29>
		return r;
  8004dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004df:	eb 5b                	jmp    80053c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ea:	48 89 c6             	mov    %rax,%rsi
  8004ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f2:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
  8004fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800501:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800505:	79 05                	jns    80050c <opencons+0x54>
		return r;
  800507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050a:	eb 30                	jmp    80053c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800510:	48 ba 80 87 80 00 00 	movabs $0x808780,%rdx
  800517:	00 00 00 
  80051a:	8b 12                	mov    (%rdx),%edx
  80051c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80051e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800522:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052d:	48 89 c7             	mov    %rax,%rdi
  800530:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  800537:	00 00 00 
  80053a:	ff d0                	callq  *%rax
}
  80053c:	c9                   	leaveq 
  80053d:	c3                   	retq   

000000000080053e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80053e:	55                   	push   %rbp
  80053f:	48 89 e5             	mov    %rsp,%rbp
  800542:	48 83 ec 30          	sub    $0x30,%rsp
  800546:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80054e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800552:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800557:	75 07                	jne    800560 <devcons_read+0x22>
		return 0;
  800559:	b8 00 00 00 00       	mov    $0x0,%eax
  80055e:	eb 4b                	jmp    8005ab <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800560:	eb 0c                	jmp    80056e <devcons_read+0x30>
		sys_yield();
  800562:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  80056e:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  800575:	00 00 00 
  800578:	ff d0                	callq  *%rax
  80057a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80057d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800581:	74 df                	je     800562 <devcons_read+0x24>
	if (c < 0)
  800583:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800587:	79 05                	jns    80058e <devcons_read+0x50>
		return c;
  800589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058c:	eb 1d                	jmp    8005ab <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80058e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800592:	75 07                	jne    80059b <devcons_read+0x5d>
		return 0;
  800594:	b8 00 00 00 00       	mov    $0x0,%eax
  800599:	eb 10                	jmp    8005ab <devcons_read+0x6d>
	*(char*)vbuf = c;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	89 c2                	mov    %eax,%edx
  8005a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a4:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ab:	c9                   	leaveq 
  8005ac:	c3                   	retq   

00000000008005ad <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005ad:	55                   	push   %rbp
  8005ae:	48 89 e5             	mov    %rsp,%rbp
  8005b1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005b8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005bf:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d4:	eb 76                	jmp    80064c <devcons_write+0x9f>
		m = n - tot;
  8005d6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005dd:	89 c2                	mov    %eax,%edx
  8005df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e2:	29 c2                	sub    %eax,%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ec:	83 f8 7f             	cmp    $0x7f,%eax
  8005ef:	76 07                	jbe    8005f8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fb:	48 63 d0             	movslq %eax,%rdx
  8005fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800601:	48 63 c8             	movslq %eax,%rcx
  800604:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060b:	48 01 c1             	add    %rax,%rcx
  80060e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800615:	48 89 ce             	mov    %rcx,%rsi
  800618:	48 89 c7             	mov    %rax,%rdi
  80061b:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  800622:	00 00 00 
  800625:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  800627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062a:	48 63 d0             	movslq %eax,%rdx
  80062d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800634:	48 89 d6             	mov    %rdx,%rsi
  800637:	48 89 c7             	mov    %rax,%rdi
  80063a:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  800641:	00 00 00 
  800644:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  800646:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800649:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80064f:	48 98                	cltq   
  800651:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800658:	0f 82 78 ff ff ff    	jb     8005d6 <devcons_write+0x29>
	}
	return tot;
  80065e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	48 83 ec 08          	sub    $0x8,%rsp
  80066b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800674:	c9                   	leaveq 
  800675:	c3                   	retq   

0000000000800676 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800676:	55                   	push   %rbp
  800677:	48 89 e5             	mov    %rsp,%rbp
  80067a:	48 83 ec 10          	sub    $0x10,%rsp
  80067e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800682:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068a:	48 be cc 4c 80 00 00 	movabs $0x804ccc,%rsi
  800691:	00 00 00 
  800694:	48 89 c7             	mov    %rax,%rdi
  800697:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  80069e:	00 00 00 
  8006a1:	ff d0                	callq  *%rax
	return 0;
  8006a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006a8:	c9                   	leaveq 
  8006a9:	c3                   	retq   

00000000008006aa <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006aa:	55                   	push   %rbp
  8006ab:	48 89 e5             	mov    %rsp,%rbp
  8006ae:	48 83 ec 10          	sub    $0x10,%rsp
  8006b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8006b9:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  8006c0:	00 00 00 
  8006c3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006ce:	7e 14                	jle    8006e4 <libmain+0x3a>
		binaryname = argv[0];
  8006d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d4:	48 8b 10             	mov    (%rax),%rdx
  8006d7:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8006de:	00 00 00 
  8006e1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8006e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006eb:	48 89 d6             	mov    %rdx,%rsi
  8006ee:	89 c7                	mov    %eax,%edi
  8006f0:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  8006f7:	00 00 00 
  8006fa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8006fc:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  800703:	00 00 00 
  800706:	ff d0                	callq  *%rax
}
  800708:	c9                   	leaveq 
  800709:	c3                   	retq   

000000000080070a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80070a:	55                   	push   %rbp
  80070b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80070e:	48 b8 d8 24 80 00 00 	movabs $0x8024d8,%rax
  800715:	00 00 00 
  800718:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80071a:	bf 00 00 00 00       	mov    $0x0,%edi
  80071f:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  800726:	00 00 00 
  800729:	ff d0                	callq  *%rax
}
  80072b:	5d                   	pop    %rbp
  80072c:	c3                   	retq   

000000000080072d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80072d:	55                   	push   %rbp
  80072e:	48 89 e5             	mov    %rsp,%rbp
  800731:	53                   	push   %rbx
  800732:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800739:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800740:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800746:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80074d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800754:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80075b:	84 c0                	test   %al,%al
  80075d:	74 23                	je     800782 <_panic+0x55>
  80075f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800766:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80076a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80076e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800772:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800776:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80077a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80077e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800782:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800789:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800790:	00 00 00 
  800793:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80079a:	00 00 00 
  80079d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007a1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007a8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007b6:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8007bd:	00 00 00 
  8007c0:	48 8b 18             	mov    (%rax),%rbx
  8007c3:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8007ca:	00 00 00 
  8007cd:	ff d0                	callq  *%rax
  8007cf:	89 c6                	mov    %eax,%esi
  8007d1:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8007d7:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8007de:	41 89 d0             	mov    %edx,%r8d
  8007e1:	48 89 c1             	mov    %rax,%rcx
  8007e4:	48 89 da             	mov    %rbx,%rdx
  8007e7:	48 bf e0 4c 80 00 00 	movabs $0x804ce0,%rdi
  8007ee:	00 00 00 
  8007f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f6:	49 b9 66 09 80 00 00 	movabs $0x800966,%r9
  8007fd:	00 00 00 
  800800:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800803:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80080a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800811:	48 89 d6             	mov    %rdx,%rsi
  800814:	48 89 c7             	mov    %rax,%rdi
  800817:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
	cprintf("\n");
  800823:	48 bf 03 4d 80 00 00 	movabs $0x804d03,%rdi
  80082a:	00 00 00 
  80082d:	b8 00 00 00 00       	mov    $0x0,%eax
  800832:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  800839:	00 00 00 
  80083c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80083e:	cc                   	int3   
  80083f:	eb fd                	jmp    80083e <_panic+0x111>

0000000000800841 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800841:	55                   	push   %rbp
  800842:	48 89 e5             	mov    %rsp,%rbp
  800845:	48 83 ec 10          	sub    $0x10,%rsp
  800849:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80084c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800854:	8b 00                	mov    (%rax),%eax
  800856:	8d 48 01             	lea    0x1(%rax),%ecx
  800859:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80085d:	89 0a                	mov    %ecx,(%rdx)
  80085f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800862:	89 d1                	mov    %edx,%ecx
  800864:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800868:	48 98                	cltq   
  80086a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80086e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800872:	8b 00                	mov    (%rax),%eax
  800874:	3d ff 00 00 00       	cmp    $0xff,%eax
  800879:	75 2c                	jne    8008a7 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80087b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80087f:	8b 00                	mov    (%rax),%eax
  800881:	48 98                	cltq   
  800883:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800887:	48 83 c2 08          	add    $0x8,%rdx
  80088b:	48 89 c6             	mov    %rax,%rsi
  80088e:	48 89 d7             	mov    %rdx,%rdi
  800891:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  800898:	00 00 00 
  80089b:	ff d0                	callq  *%rax
        b->idx = 0;
  80089d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ab:	8b 40 04             	mov    0x4(%rax),%eax
  8008ae:	8d 50 01             	lea    0x1(%rax),%edx
  8008b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008b8:	c9                   	leaveq 
  8008b9:	c3                   	retq   

00000000008008ba <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008ba:	55                   	push   %rbp
  8008bb:	48 89 e5             	mov    %rsp,%rbp
  8008be:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008c5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008cc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8008d3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8008da:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8008e1:	48 8b 0a             	mov    (%rdx),%rcx
  8008e4:	48 89 08             	mov    %rcx,(%rax)
  8008e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8008f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8008fe:	00 00 00 
    b.cnt = 0;
  800901:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800908:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80090b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800912:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800919:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800920:	48 89 c6             	mov    %rax,%rsi
  800923:	48 bf 41 08 80 00 00 	movabs $0x800841,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 05 0d 80 00 00 	movabs $0x800d05,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800939:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80093f:	48 98                	cltq   
  800941:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800948:	48 83 c2 08          	add    $0x8,%rdx
  80094c:	48 89 c6             	mov    %rax,%rsi
  80094f:	48 89 d7             	mov    %rdx,%rdi
  800952:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  800959:	00 00 00 
  80095c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80095e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800964:	c9                   	leaveq 
  800965:	c3                   	retq   

0000000000800966 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800966:	55                   	push   %rbp
  800967:	48 89 e5             	mov    %rsp,%rbp
  80096a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800971:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800978:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80097f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800986:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80098d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800994:	84 c0                	test   %al,%al
  800996:	74 20                	je     8009b8 <cprintf+0x52>
  800998:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80099c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009a0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009a4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009a8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009ac:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009b0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009b4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009b8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009bf:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009c6:	00 00 00 
  8009c9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009d0:	00 00 00 
  8009d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009d7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8009de:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8009e5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8009ec:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8009f3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8009fa:	48 8b 0a             	mov    (%rdx),%rcx
  8009fd:	48 89 08             	mov    %rcx,(%rax)
  800a00:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a04:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a08:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a0c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a10:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a17:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a1e:	48 89 d6             	mov    %rdx,%rsi
  800a21:	48 89 c7             	mov    %rax,%rdi
  800a24:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  800a2b:	00 00 00 
  800a2e:	ff d0                	callq  *%rax
  800a30:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a36:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a3c:	c9                   	leaveq 
  800a3d:	c3                   	retq   

0000000000800a3e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a3e:	55                   	push   %rbp
  800a3f:	48 89 e5             	mov    %rsp,%rbp
  800a42:	48 83 ec 30          	sub    $0x30,%rsp
  800a46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800a4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800a52:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800a55:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800a59:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a5d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800a60:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800a64:	77 42                	ja     800aa8 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a66:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800a69:	8d 78 ff             	lea    -0x1(%rax),%edi
  800a6c:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	ba 00 00 00 00       	mov    $0x0,%edx
  800a78:	48 f7 f6             	div    %rsi
  800a7b:	49 89 c2             	mov    %rax,%r10
  800a7e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800a81:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800a84:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a8c:	41 89 c9             	mov    %ecx,%r9d
  800a8f:	41 89 f8             	mov    %edi,%r8d
  800a92:	89 d1                	mov    %edx,%ecx
  800a94:	4c 89 d2             	mov    %r10,%rdx
  800a97:	48 89 c7             	mov    %rax,%rdi
  800a9a:	48 b8 3e 0a 80 00 00 	movabs $0x800a3e,%rax
  800aa1:	00 00 00 
  800aa4:	ff d0                	callq  *%rax
  800aa6:	eb 1e                	jmp    800ac6 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa8:	eb 12                	jmp    800abc <printnum+0x7e>
			putch(padc, putdat);
  800aaa:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800aae:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ab5:	48 89 ce             	mov    %rcx,%rsi
  800ab8:	89 d7                	mov    %edx,%edi
  800aba:	ff d0                	callq  *%rax
		while (--width > 0)
  800abc:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800ac0:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800ac4:	7f e4                	jg     800aaa <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ac6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad2:	48 f7 f1             	div    %rcx
  800ad5:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  800adc:	00 00 00 
  800adf:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800ae3:	0f be d0             	movsbl %al,%edx
  800ae6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800aea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800aee:	48 89 ce             	mov    %rcx,%rsi
  800af1:	89 d7                	mov    %edx,%edi
  800af3:	ff d0                	callq  *%rax
}
  800af5:	c9                   	leaveq 
  800af6:	c3                   	retq   

0000000000800af7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800af7:	55                   	push   %rbp
  800af8:	48 89 e5             	mov    %rsp,%rbp
  800afb:	48 83 ec 20          	sub    $0x20,%rsp
  800aff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b03:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b06:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b0a:	7e 4f                	jle    800b5b <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b10:	8b 00                	mov    (%rax),%eax
  800b12:	83 f8 30             	cmp    $0x30,%eax
  800b15:	73 24                	jae    800b3b <getuint+0x44>
  800b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b23:	8b 00                	mov    (%rax),%eax
  800b25:	89 c0                	mov    %eax,%eax
  800b27:	48 01 d0             	add    %rdx,%rax
  800b2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2e:	8b 12                	mov    (%rdx),%edx
  800b30:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b37:	89 0a                	mov    %ecx,(%rdx)
  800b39:	eb 14                	jmp    800b4f <getuint+0x58>
  800b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b43:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b4f:	48 8b 00             	mov    (%rax),%rax
  800b52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b56:	e9 9d 00 00 00       	jmpq   800bf8 <getuint+0x101>
	else if (lflag)
  800b5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b5f:	74 4c                	je     800bad <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b65:	8b 00                	mov    (%rax),%eax
  800b67:	83 f8 30             	cmp    $0x30,%eax
  800b6a:	73 24                	jae    800b90 <getuint+0x99>
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b78:	8b 00                	mov    (%rax),%eax
  800b7a:	89 c0                	mov    %eax,%eax
  800b7c:	48 01 d0             	add    %rdx,%rax
  800b7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b83:	8b 12                	mov    (%rdx),%edx
  800b85:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8c:	89 0a                	mov    %ecx,(%rdx)
  800b8e:	eb 14                	jmp    800ba4 <getuint+0xad>
  800b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b94:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b98:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ba4:	48 8b 00             	mov    (%rax),%rax
  800ba7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bab:	eb 4b                	jmp    800bf8 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb1:	8b 00                	mov    (%rax),%eax
  800bb3:	83 f8 30             	cmp    $0x30,%eax
  800bb6:	73 24                	jae    800bdc <getuint+0xe5>
  800bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc4:	8b 00                	mov    (%rax),%eax
  800bc6:	89 c0                	mov    %eax,%eax
  800bc8:	48 01 d0             	add    %rdx,%rax
  800bcb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcf:	8b 12                	mov    (%rdx),%edx
  800bd1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd8:	89 0a                	mov    %ecx,(%rdx)
  800bda:	eb 14                	jmp    800bf0 <getuint+0xf9>
  800bdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800be4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800be8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bf0:	8b 00                	mov    (%rax),%eax
  800bf2:	89 c0                	mov    %eax,%eax
  800bf4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bfc:	c9                   	leaveq 
  800bfd:	c3                   	retq   

0000000000800bfe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bfe:	55                   	push   %rbp
  800bff:	48 89 e5             	mov    %rsp,%rbp
  800c02:	48 83 ec 20          	sub    $0x20,%rsp
  800c06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c0a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c0d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c11:	7e 4f                	jle    800c62 <getint+0x64>
		x=va_arg(*ap, long long);
  800c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c17:	8b 00                	mov    (%rax),%eax
  800c19:	83 f8 30             	cmp    $0x30,%eax
  800c1c:	73 24                	jae    800c42 <getint+0x44>
  800c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c22:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2a:	8b 00                	mov    (%rax),%eax
  800c2c:	89 c0                	mov    %eax,%eax
  800c2e:	48 01 d0             	add    %rdx,%rax
  800c31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c35:	8b 12                	mov    (%rdx),%edx
  800c37:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c3e:	89 0a                	mov    %ecx,(%rdx)
  800c40:	eb 14                	jmp    800c56 <getint+0x58>
  800c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c46:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c4a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c52:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c5d:	e9 9d 00 00 00       	jmpq   800cff <getint+0x101>
	else if (lflag)
  800c62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c66:	74 4c                	je     800cb4 <getint+0xb6>
		x=va_arg(*ap, long);
  800c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6c:	8b 00                	mov    (%rax),%eax
  800c6e:	83 f8 30             	cmp    $0x30,%eax
  800c71:	73 24                	jae    800c97 <getint+0x99>
  800c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c77:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7f:	8b 00                	mov    (%rax),%eax
  800c81:	89 c0                	mov    %eax,%eax
  800c83:	48 01 d0             	add    %rdx,%rax
  800c86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c8a:	8b 12                	mov    (%rdx),%edx
  800c8c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c93:	89 0a                	mov    %ecx,(%rdx)
  800c95:	eb 14                	jmp    800cab <getint+0xad>
  800c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c9f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ca3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ca7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cab:	48 8b 00             	mov    (%rax),%rax
  800cae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cb2:	eb 4b                	jmp    800cff <getint+0x101>
	else
		x=va_arg(*ap, int);
  800cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb8:	8b 00                	mov    (%rax),%eax
  800cba:	83 f8 30             	cmp    $0x30,%eax
  800cbd:	73 24                	jae    800ce3 <getint+0xe5>
  800cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccb:	8b 00                	mov    (%rax),%eax
  800ccd:	89 c0                	mov    %eax,%eax
  800ccf:	48 01 d0             	add    %rdx,%rax
  800cd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd6:	8b 12                	mov    (%rdx),%edx
  800cd8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cdb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdf:	89 0a                	mov    %ecx,(%rdx)
  800ce1:	eb 14                	jmp    800cf7 <getint+0xf9>
  800ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ceb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800cef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cf7:	8b 00                	mov    (%rax),%eax
  800cf9:	48 98                	cltq   
  800cfb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d03:	c9                   	leaveq 
  800d04:	c3                   	retq   

0000000000800d05 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d05:	55                   	push   %rbp
  800d06:	48 89 e5             	mov    %rsp,%rbp
  800d09:	41 54                	push   %r12
  800d0b:	53                   	push   %rbx
  800d0c:	48 83 ec 60          	sub    $0x60,%rsp
  800d10:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d14:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d18:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d1c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d24:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d28:	48 8b 0a             	mov    (%rdx),%rcx
  800d2b:	48 89 08             	mov    %rcx,(%rax)
  800d2e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d32:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d36:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d3a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d3e:	eb 17                	jmp    800d57 <vprintfmt+0x52>
			if (ch == '\0')
  800d40:	85 db                	test   %ebx,%ebx
  800d42:	0f 84 c5 04 00 00    	je     80120d <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800d48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d50:	48 89 d6             	mov    %rdx,%rsi
  800d53:	89 df                	mov    %ebx,%edi
  800d55:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d57:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d5b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d5f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d63:	0f b6 00             	movzbl (%rax),%eax
  800d66:	0f b6 d8             	movzbl %al,%ebx
  800d69:	83 fb 25             	cmp    $0x25,%ebx
  800d6c:	75 d2                	jne    800d40 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800d6e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800d72:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800d79:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800d80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800d87:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d92:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d96:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d9a:	0f b6 00             	movzbl (%rax),%eax
  800d9d:	0f b6 d8             	movzbl %al,%ebx
  800da0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800da3:	83 f8 55             	cmp    $0x55,%eax
  800da6:	0f 87 2e 04 00 00    	ja     8011da <vprintfmt+0x4d5>
  800dac:	89 c0                	mov    %eax,%eax
  800dae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800db5:	00 
  800db6:	48 b8 58 4f 80 00 00 	movabs $0x804f58,%rax
  800dbd:	00 00 00 
  800dc0:	48 01 d0             	add    %rdx,%rax
  800dc3:	48 8b 00             	mov    (%rax),%rax
  800dc6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800dc8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800dcc:	eb c0                	jmp    800d8e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dce:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800dd2:	eb ba                	jmp    800d8e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ddb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	c1 e0 02             	shl    $0x2,%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	01 c0                	add    %eax,%eax
  800de7:	01 d8                	add    %ebx,%eax
  800de9:	83 e8 30             	sub    $0x30,%eax
  800dec:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800def:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800df3:	0f b6 00             	movzbl (%rax),%eax
  800df6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800df9:	83 fb 2f             	cmp    $0x2f,%ebx
  800dfc:	7e 0c                	jle    800e0a <vprintfmt+0x105>
  800dfe:	83 fb 39             	cmp    $0x39,%ebx
  800e01:	7f 07                	jg     800e0a <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800e03:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800e08:	eb d1                	jmp    800ddb <vprintfmt+0xd6>
			goto process_precision;
  800e0a:	eb 50                	jmp    800e5c <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800e0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0f:	83 f8 30             	cmp    $0x30,%eax
  800e12:	73 17                	jae    800e2b <vprintfmt+0x126>
  800e14:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1b:	89 d2                	mov    %edx,%edx
  800e1d:	48 01 d0             	add    %rdx,%rax
  800e20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e23:	83 c2 08             	add    $0x8,%edx
  800e26:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e29:	eb 0c                	jmp    800e37 <vprintfmt+0x132>
  800e2b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e2f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e37:	8b 00                	mov    (%rax),%eax
  800e39:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e3c:	eb 1e                	jmp    800e5c <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800e3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e42:	79 07                	jns    800e4b <vprintfmt+0x146>
				width = 0;
  800e44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e4b:	e9 3e ff ff ff       	jmpq   800d8e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e50:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e57:	e9 32 ff ff ff       	jmpq   800d8e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800e5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e60:	79 0d                	jns    800e6f <vprintfmt+0x16a>
				width = precision, precision = -1;
  800e62:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e65:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e6f:	e9 1a ff ff ff       	jmpq   800d8e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e74:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800e78:	e9 11 ff ff ff       	jmpq   800d8e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800e7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e80:	83 f8 30             	cmp    $0x30,%eax
  800e83:	73 17                	jae    800e9c <vprintfmt+0x197>
  800e85:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e8c:	89 d2                	mov    %edx,%edx
  800e8e:	48 01 d0             	add    %rdx,%rax
  800e91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e94:	83 c2 08             	add    $0x8,%edx
  800e97:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e9a:	eb 0c                	jmp    800ea8 <vprintfmt+0x1a3>
  800e9c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ea0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ea4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ea8:	8b 10                	mov    (%rax),%edx
  800eaa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800eae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb2:	48 89 ce             	mov    %rcx,%rsi
  800eb5:	89 d7                	mov    %edx,%edi
  800eb7:	ff d0                	callq  *%rax
			break;
  800eb9:	e9 4a 03 00 00       	jmpq   801208 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ebe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec1:	83 f8 30             	cmp    $0x30,%eax
  800ec4:	73 17                	jae    800edd <vprintfmt+0x1d8>
  800ec6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ecd:	89 d2                	mov    %edx,%edx
  800ecf:	48 01 d0             	add    %rdx,%rax
  800ed2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ed5:	83 c2 08             	add    $0x8,%edx
  800ed8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800edb:	eb 0c                	jmp    800ee9 <vprintfmt+0x1e4>
  800edd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ee1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ee5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ee9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800eeb:	85 db                	test   %ebx,%ebx
  800eed:	79 02                	jns    800ef1 <vprintfmt+0x1ec>
				err = -err;
  800eef:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ef1:	83 fb 15             	cmp    $0x15,%ebx
  800ef4:	7f 16                	jg     800f0c <vprintfmt+0x207>
  800ef6:	48 b8 80 4e 80 00 00 	movabs $0x804e80,%rax
  800efd:	00 00 00 
  800f00:	48 63 d3             	movslq %ebx,%rdx
  800f03:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f07:	4d 85 e4             	test   %r12,%r12
  800f0a:	75 2e                	jne    800f3a <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800f0c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f14:	89 d9                	mov    %ebx,%ecx
  800f16:	48 ba 41 4f 80 00 00 	movabs $0x804f41,%rdx
  800f1d:	00 00 00 
  800f20:	48 89 c7             	mov    %rax,%rdi
  800f23:	b8 00 00 00 00       	mov    $0x0,%eax
  800f28:	49 b8 16 12 80 00 00 	movabs $0x801216,%r8
  800f2f:	00 00 00 
  800f32:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f35:	e9 ce 02 00 00       	jmpq   801208 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800f3a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f42:	4c 89 e1             	mov    %r12,%rcx
  800f45:	48 ba 4a 4f 80 00 00 	movabs $0x804f4a,%rdx
  800f4c:	00 00 00 
  800f4f:	48 89 c7             	mov    %rax,%rdi
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	49 b8 16 12 80 00 00 	movabs $0x801216,%r8
  800f5e:	00 00 00 
  800f61:	41 ff d0             	callq  *%r8
			break;
  800f64:	e9 9f 02 00 00       	jmpq   801208 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800f69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f6c:	83 f8 30             	cmp    $0x30,%eax
  800f6f:	73 17                	jae    800f88 <vprintfmt+0x283>
  800f71:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f78:	89 d2                	mov    %edx,%edx
  800f7a:	48 01 d0             	add    %rdx,%rax
  800f7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f80:	83 c2 08             	add    $0x8,%edx
  800f83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f86:	eb 0c                	jmp    800f94 <vprintfmt+0x28f>
  800f88:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f8c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f90:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f94:	4c 8b 20             	mov    (%rax),%r12
  800f97:	4d 85 e4             	test   %r12,%r12
  800f9a:	75 0a                	jne    800fa6 <vprintfmt+0x2a1>
				p = "(null)";
  800f9c:	49 bc 4d 4f 80 00 00 	movabs $0x804f4d,%r12
  800fa3:	00 00 00 
			if (width > 0 && padc != '-')
  800fa6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800faa:	7e 3f                	jle    800feb <vprintfmt+0x2e6>
  800fac:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800fb0:	74 39                	je     800feb <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800fb5:	48 98                	cltq   
  800fb7:	48 89 c6             	mov    %rax,%rsi
  800fba:	4c 89 e7             	mov    %r12,%rdi
  800fbd:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
  800fc9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800fcc:	eb 17                	jmp    800fe5 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800fce:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800fd2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800fd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fda:	48 89 ce             	mov    %rcx,%rsi
  800fdd:	89 d7                	mov    %edx,%edi
  800fdf:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fe5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fe9:	7f e3                	jg     800fce <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800feb:	eb 37                	jmp    801024 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800fed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ff1:	74 1e                	je     801011 <vprintfmt+0x30c>
  800ff3:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff6:	7e 05                	jle    800ffd <vprintfmt+0x2f8>
  800ff8:	83 fb 7e             	cmp    $0x7e,%ebx
  800ffb:	7e 14                	jle    801011 <vprintfmt+0x30c>
					putch('?', putdat);
  800ffd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801001:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801005:	48 89 d6             	mov    %rdx,%rsi
  801008:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80100d:	ff d0                	callq  *%rax
  80100f:	eb 0f                	jmp    801020 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  801011:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801015:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801019:	48 89 d6             	mov    %rdx,%rsi
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801020:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801024:	4c 89 e0             	mov    %r12,%rax
  801027:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80102b:	0f b6 00             	movzbl (%rax),%eax
  80102e:	0f be d8             	movsbl %al,%ebx
  801031:	85 db                	test   %ebx,%ebx
  801033:	74 10                	je     801045 <vprintfmt+0x340>
  801035:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801039:	78 b2                	js     800fed <vprintfmt+0x2e8>
  80103b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80103f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801043:	79 a8                	jns    800fed <vprintfmt+0x2e8>
			for (; width > 0; width--)
  801045:	eb 16                	jmp    80105d <vprintfmt+0x358>
				putch(' ', putdat);
  801047:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80104b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80104f:	48 89 d6             	mov    %rdx,%rsi
  801052:	bf 20 00 00 00       	mov    $0x20,%edi
  801057:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  801059:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80105d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801061:	7f e4                	jg     801047 <vprintfmt+0x342>
			break;
  801063:	e9 a0 01 00 00       	jmpq   801208 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801068:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80106c:	be 03 00 00 00       	mov    $0x3,%esi
  801071:	48 89 c7             	mov    %rax,%rdi
  801074:	48 b8 fe 0b 80 00 00 	movabs $0x800bfe,%rax
  80107b:	00 00 00 
  80107e:	ff d0                	callq  *%rax
  801080:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801088:	48 85 c0             	test   %rax,%rax
  80108b:	79 1d                	jns    8010aa <vprintfmt+0x3a5>
				putch('-', putdat);
  80108d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801091:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801095:	48 89 d6             	mov    %rdx,%rsi
  801098:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80109d:	ff d0                	callq  *%rax
				num = -(long long) num;
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	48 f7 d8             	neg    %rax
  8010a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8010aa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010b1:	e9 e5 00 00 00       	jmpq   80119b <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8010b6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010ba:	be 03 00 00 00       	mov    $0x3,%esi
  8010bf:	48 89 c7             	mov    %rax,%rdi
  8010c2:	48 b8 f7 0a 80 00 00 	movabs $0x800af7,%rax
  8010c9:	00 00 00 
  8010cc:	ff d0                	callq  *%rax
  8010ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8010d2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010d9:	e9 bd 00 00 00       	jmpq   80119b <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e6:	48 89 d6             	mov    %rdx,%rsi
  8010e9:	bf 58 00 00 00       	mov    $0x58,%edi
  8010ee:	ff d0                	callq  *%rax
			putch('X', putdat);
  8010f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f8:	48 89 d6             	mov    %rdx,%rsi
  8010fb:	bf 58 00 00 00       	mov    $0x58,%edi
  801100:	ff d0                	callq  *%rax
			putch('X', putdat);
  801102:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801106:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80110a:	48 89 d6             	mov    %rdx,%rsi
  80110d:	bf 58 00 00 00       	mov    $0x58,%edi
  801112:	ff d0                	callq  *%rax
			break;
  801114:	e9 ef 00 00 00       	jmpq   801208 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  801119:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80111d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801121:	48 89 d6             	mov    %rdx,%rsi
  801124:	bf 30 00 00 00       	mov    $0x30,%edi
  801129:	ff d0                	callq  *%rax
			putch('x', putdat);
  80112b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80112f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801133:	48 89 d6             	mov    %rdx,%rsi
  801136:	bf 78 00 00 00       	mov    $0x78,%edi
  80113b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80113d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801140:	83 f8 30             	cmp    $0x30,%eax
  801143:	73 17                	jae    80115c <vprintfmt+0x457>
  801145:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801149:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80114c:	89 d2                	mov    %edx,%edx
  80114e:	48 01 d0             	add    %rdx,%rax
  801151:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801154:	83 c2 08             	add    $0x8,%edx
  801157:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  80115a:	eb 0c                	jmp    801168 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  80115c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801160:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801164:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801168:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  80116b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80116f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801176:	eb 23                	jmp    80119b <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801178:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80117c:	be 03 00 00 00       	mov    $0x3,%esi
  801181:	48 89 c7             	mov    %rax,%rdi
  801184:	48 b8 f7 0a 80 00 00 	movabs $0x800af7,%rax
  80118b:	00 00 00 
  80118e:	ff d0                	callq  *%rax
  801190:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801194:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80119b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011a0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011a3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011aa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011b2:	45 89 c1             	mov    %r8d,%r9d
  8011b5:	41 89 f8             	mov    %edi,%r8d
  8011b8:	48 89 c7             	mov    %rax,%rdi
  8011bb:	48 b8 3e 0a 80 00 00 	movabs $0x800a3e,%rax
  8011c2:	00 00 00 
  8011c5:	ff d0                	callq  *%rax
			break;
  8011c7:	eb 3f                	jmp    801208 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011d1:	48 89 d6             	mov    %rdx,%rsi
  8011d4:	89 df                	mov    %ebx,%edi
  8011d6:	ff d0                	callq  *%rax
			break;
  8011d8:	eb 2e                	jmp    801208 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011e2:	48 89 d6             	mov    %rdx,%rsi
  8011e5:	bf 25 00 00 00       	mov    $0x25,%edi
  8011ea:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011ec:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011f1:	eb 05                	jmp    8011f8 <vprintfmt+0x4f3>
  8011f3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011f8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011fc:	48 83 e8 01          	sub    $0x1,%rax
  801200:	0f b6 00             	movzbl (%rax),%eax
  801203:	3c 25                	cmp    $0x25,%al
  801205:	75 ec                	jne    8011f3 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801207:	90                   	nop
		}
	}
  801208:	e9 31 fb ff ff       	jmpq   800d3e <vprintfmt+0x39>
	va_end(aq);
}
  80120d:	48 83 c4 60          	add    $0x60,%rsp
  801211:	5b                   	pop    %rbx
  801212:	41 5c                	pop    %r12
  801214:	5d                   	pop    %rbp
  801215:	c3                   	retq   

0000000000801216 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801216:	55                   	push   %rbp
  801217:	48 89 e5             	mov    %rsp,%rbp
  80121a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801221:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801228:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80122f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801236:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80123d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801244:	84 c0                	test   %al,%al
  801246:	74 20                	je     801268 <printfmt+0x52>
  801248:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80124c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801250:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801254:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801258:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80125c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801260:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801264:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801268:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80126f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801276:	00 00 00 
  801279:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801280:	00 00 00 
  801283:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801287:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80128e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801295:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80129c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012a3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012aa:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012b1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012b8:	48 89 c7             	mov    %rax,%rdi
  8012bb:	48 b8 05 0d 80 00 00 	movabs $0x800d05,%rax
  8012c2:	00 00 00 
  8012c5:	ff d0                	callq  *%rax
	va_end(ap);
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 10          	sub    $0x10,%rsp
  8012d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8012d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	8b 40 10             	mov    0x10(%rax),%eax
  8012df:	8d 50 01             	lea    0x1(%rax),%edx
  8012e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8012e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ed:	48 8b 10             	mov    (%rax),%rdx
  8012f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8012f8:	48 39 c2             	cmp    %rax,%rdx
  8012fb:	73 17                	jae    801314 <sprintputch+0x4b>
		*b->buf++ = ch;
  8012fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801301:	48 8b 00             	mov    (%rax),%rax
  801304:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801308:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80130c:	48 89 0a             	mov    %rcx,(%rdx)
  80130f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801312:	88 10                	mov    %dl,(%rax)
}
  801314:	c9                   	leaveq 
  801315:	c3                   	retq   

0000000000801316 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801316:	55                   	push   %rbp
  801317:	48 89 e5             	mov    %rsp,%rbp
  80131a:	48 83 ec 50          	sub    $0x50,%rsp
  80131e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801322:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801325:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801329:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80132d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801331:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801335:	48 8b 0a             	mov    (%rdx),%rcx
  801338:	48 89 08             	mov    %rcx,(%rax)
  80133b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80133f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801343:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801347:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80134b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80134f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801353:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801356:	48 98                	cltq   
  801358:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80135c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801360:	48 01 d0             	add    %rdx,%rax
  801363:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801367:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80136e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801373:	74 06                	je     80137b <vsnprintf+0x65>
  801375:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801379:	7f 07                	jg     801382 <vsnprintf+0x6c>
		return -E_INVAL;
  80137b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801380:	eb 2f                	jmp    8013b1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801382:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801386:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80138a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80138e:	48 89 c6             	mov    %rax,%rsi
  801391:	48 bf c9 12 80 00 00 	movabs $0x8012c9,%rdi
  801398:	00 00 00 
  80139b:	48 b8 05 0d 80 00 00 	movabs $0x800d05,%rax
  8013a2:	00 00 00 
  8013a5:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013ab:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013ae:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013be:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8013c5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8013cb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013d2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013d9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 20                	je     801404 <snprintf+0x51>
  8013e4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8013e8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8013ec:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8013f0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8013f4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8013f8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8013fc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801400:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801404:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80140b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801412:	00 00 00 
  801415:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80141c:	00 00 00 
  80141f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801423:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80142a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801431:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801438:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80143f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801446:	48 8b 0a             	mov    (%rdx),%rcx
  801449:	48 89 08             	mov    %rcx,(%rax)
  80144c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801450:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801454:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801458:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80145c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801463:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80146a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801470:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801477:	48 89 c7             	mov    %rax,%rdi
  80147a:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  801481:	00 00 00 
  801484:	ff d0                	callq  *%rax
  801486:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80148c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801492:	c9                   	leaveq 
  801493:	c3                   	retq   

0000000000801494 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801494:	55                   	push   %rbp
  801495:	48 89 e5             	mov    %rsp,%rbp
  801498:	48 83 ec 18          	sub    $0x18,%rsp
  80149c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014a7:	eb 09                	jmp    8014b2 <strlen+0x1e>
		n++;
  8014a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8014ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	84 c0                	test   %al,%al
  8014bb:	75 ec                	jne    8014a9 <strlen+0x15>
	return n;
  8014bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014c0:	c9                   	leaveq 
  8014c1:	c3                   	retq   

00000000008014c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8014c2:	55                   	push   %rbp
  8014c3:	48 89 e5             	mov    %rsp,%rbp
  8014c6:	48 83 ec 20          	sub    $0x20,%rsp
  8014ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014d9:	eb 0e                	jmp    8014e9 <strnlen+0x27>
		n++;
  8014db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014df:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014e4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8014e9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8014ee:	74 0b                	je     8014fb <strnlen+0x39>
  8014f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	84 c0                	test   %al,%al
  8014f9:	75 e0                	jne    8014db <strnlen+0x19>
	return n;
  8014fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014fe:	c9                   	leaveq 
  8014ff:	c3                   	retq   

0000000000801500 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801500:	55                   	push   %rbp
  801501:	48 89 e5             	mov    %rsp,%rbp
  801504:	48 83 ec 20          	sub    $0x20,%rsp
  801508:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801514:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801518:	90                   	nop
  801519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801521:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801525:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801529:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80152d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801531:	0f b6 12             	movzbl (%rdx),%edx
  801534:	88 10                	mov    %dl,(%rax)
  801536:	0f b6 00             	movzbl (%rax),%eax
  801539:	84 c0                	test   %al,%al
  80153b:	75 dc                	jne    801519 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801541:	c9                   	leaveq 
  801542:	c3                   	retq   

0000000000801543 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	48 83 ec 20          	sub    $0x20,%rsp
  80154b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801557:	48 89 c7             	mov    %rax,%rdi
  80155a:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  801561:	00 00 00 
  801564:	ff d0                	callq  *%rax
  801566:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801569:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80156c:	48 63 d0             	movslq %eax,%rdx
  80156f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801573:	48 01 c2             	add    %rax,%rdx
  801576:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157a:	48 89 c6             	mov    %rax,%rsi
  80157d:	48 89 d7             	mov    %rdx,%rdi
  801580:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  801587:	00 00 00 
  80158a:	ff d0                	callq  *%rax
	return dst;
  80158c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 28          	sub    $0x28,%rsp
  80159a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015ae:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015b5:	00 
  8015b6:	eb 2a                	jmp    8015e2 <strncpy+0x50>
		*dst++ = *src;
  8015b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015c4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015c8:	0f b6 12             	movzbl (%rdx),%edx
  8015cb:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8015cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	84 c0                	test   %al,%al
  8015d6:	74 05                	je     8015dd <strncpy+0x4b>
			src++;
  8015d8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8015dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8015ea:	72 cc                	jb     8015b8 <strncpy+0x26>
	}
	return ret;
  8015ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015f0:	c9                   	leaveq 
  8015f1:	c3                   	retq   

00000000008015f2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8015f2:	55                   	push   %rbp
  8015f3:	48 89 e5             	mov    %rsp,%rbp
  8015f6:	48 83 ec 28          	sub    $0x28,%rsp
  8015fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801602:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80160e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801613:	74 3d                	je     801652 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801615:	eb 1d                	jmp    801634 <strlcpy+0x42>
			*dst++ = *src++;
  801617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80161f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801623:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801627:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80162b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80162f:	0f b6 12             	movzbl (%rdx),%edx
  801632:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801634:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801639:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80163e:	74 0b                	je     80164b <strlcpy+0x59>
  801640:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801644:	0f b6 00             	movzbl (%rax),%eax
  801647:	84 c0                	test   %al,%al
  801649:	75 cc                	jne    801617 <strlcpy+0x25>
		*dst = '\0';
  80164b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801656:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165a:	48 29 c2             	sub    %rax,%rdx
  80165d:	48 89 d0             	mov    %rdx,%rax
}
  801660:	c9                   	leaveq 
  801661:	c3                   	retq   

0000000000801662 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801662:	55                   	push   %rbp
  801663:	48 89 e5             	mov    %rsp,%rbp
  801666:	48 83 ec 10          	sub    $0x10,%rsp
  80166a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80166e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801672:	eb 0a                	jmp    80167e <strcmp+0x1c>
		p++, q++;
  801674:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801679:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	84 c0                	test   %al,%al
  801687:	74 12                	je     80169b <strcmp+0x39>
  801689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168d:	0f b6 10             	movzbl (%rax),%edx
  801690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	38 c2                	cmp    %al,%dl
  801699:	74 d9                	je     801674 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80169b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	0f b6 d0             	movzbl %al,%edx
  8016a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	0f b6 c0             	movzbl %al,%eax
  8016af:	29 c2                	sub    %eax,%edx
  8016b1:	89 d0                	mov    %edx,%eax
}
  8016b3:	c9                   	leaveq 
  8016b4:	c3                   	retq   

00000000008016b5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016b5:	55                   	push   %rbp
  8016b6:	48 89 e5             	mov    %rsp,%rbp
  8016b9:	48 83 ec 18          	sub    $0x18,%rsp
  8016bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8016c9:	eb 0f                	jmp    8016da <strncmp+0x25>
		n--, p++, q++;
  8016cb:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8016d0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8016da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016df:	74 1d                	je     8016fe <strncmp+0x49>
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	84 c0                	test   %al,%al
  8016ea:	74 12                	je     8016fe <strncmp+0x49>
  8016ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f0:	0f b6 10             	movzbl (%rax),%edx
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	38 c2                	cmp    %al,%dl
  8016fc:	74 cd                	je     8016cb <strncmp+0x16>
	if (n == 0)
  8016fe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801703:	75 07                	jne    80170c <strncmp+0x57>
		return 0;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
  80170a:	eb 18                	jmp    801724 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80170c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	0f b6 c0             	movzbl %al,%eax
  801720:	29 c2                	sub    %eax,%edx
  801722:	89 d0                	mov    %edx,%eax
}
  801724:	c9                   	leaveq 
  801725:	c3                   	retq   

0000000000801726 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801726:	55                   	push   %rbp
  801727:	48 89 e5             	mov    %rsp,%rbp
  80172a:	48 83 ec 10          	sub    $0x10,%rsp
  80172e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801732:	89 f0                	mov    %esi,%eax
  801734:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801737:	eb 17                	jmp    801750 <strchr+0x2a>
		if (*s == c)
  801739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173d:	0f b6 00             	movzbl (%rax),%eax
  801740:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801743:	75 06                	jne    80174b <strchr+0x25>
			return (char *) s;
  801745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801749:	eb 15                	jmp    801760 <strchr+0x3a>
	for (; *s; s++)
  80174b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	84 c0                	test   %al,%al
  801759:	75 de                	jne    801739 <strchr+0x13>
	return 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801760:	c9                   	leaveq 
  801761:	c3                   	retq   

0000000000801762 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801762:	55                   	push   %rbp
  801763:	48 89 e5             	mov    %rsp,%rbp
  801766:	48 83 ec 10          	sub    $0x10,%rsp
  80176a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80176e:	89 f0                	mov    %esi,%eax
  801770:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801773:	eb 13                	jmp    801788 <strfind+0x26>
		if (*s == c)
  801775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80177f:	75 02                	jne    801783 <strfind+0x21>
			break;
  801781:	eb 10                	jmp    801793 <strfind+0x31>
	for (; *s; s++)
  801783:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	84 c0                	test   %al,%al
  801791:	75 e2                	jne    801775 <strfind+0x13>
	return (char *) s;
  801793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801797:	c9                   	leaveq 
  801798:	c3                   	retq   

0000000000801799 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801799:	55                   	push   %rbp
  80179a:	48 89 e5             	mov    %rsp,%rbp
  80179d:	48 83 ec 18          	sub    $0x18,%rsp
  8017a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017a5:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017b1:	75 06                	jne    8017b9 <memset+0x20>
		return v;
  8017b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b7:	eb 69                	jmp    801822 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bd:	83 e0 03             	and    $0x3,%eax
  8017c0:	48 85 c0             	test   %rax,%rax
  8017c3:	75 48                	jne    80180d <memset+0x74>
  8017c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c9:	83 e0 03             	and    $0x3,%eax
  8017cc:	48 85 c0             	test   %rax,%rax
  8017cf:	75 3c                	jne    80180d <memset+0x74>
		c &= 0xFF;
  8017d1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8017d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017db:	c1 e0 18             	shl    $0x18,%eax
  8017de:	89 c2                	mov    %eax,%edx
  8017e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017e3:	c1 e0 10             	shl    $0x10,%eax
  8017e6:	09 c2                	or     %eax,%edx
  8017e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017eb:	c1 e0 08             	shl    $0x8,%eax
  8017ee:	09 d0                	or     %edx,%eax
  8017f0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8017f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f7:	48 c1 e8 02          	shr    $0x2,%rax
  8017fb:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8017fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801802:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801805:	48 89 d7             	mov    %rdx,%rdi
  801808:	fc                   	cld    
  801809:	f3 ab                	rep stos %eax,%es:(%rdi)
  80180b:	eb 11                	jmp    80181e <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80180d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801811:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801814:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801818:	48 89 d7             	mov    %rdx,%rdi
  80181b:	fc                   	cld    
  80181c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80181e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801822:	c9                   	leaveq 
  801823:	c3                   	retq   

0000000000801824 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 83 ec 28          	sub    $0x28,%rsp
  80182c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801830:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801834:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801838:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80183c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801844:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801850:	0f 83 88 00 00 00    	jae    8018de <memmove+0xba>
  801856:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	48 01 d0             	add    %rdx,%rax
  801861:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801865:	76 77                	jbe    8018de <memmove+0xba>
		s += n;
  801867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80186f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801873:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187b:	83 e0 03             	and    $0x3,%eax
  80187e:	48 85 c0             	test   %rax,%rax
  801881:	75 3b                	jne    8018be <memmove+0x9a>
  801883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801887:	83 e0 03             	and    $0x3,%eax
  80188a:	48 85 c0             	test   %rax,%rax
  80188d:	75 2f                	jne    8018be <memmove+0x9a>
  80188f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801893:	83 e0 03             	and    $0x3,%eax
  801896:	48 85 c0             	test   %rax,%rax
  801899:	75 23                	jne    8018be <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80189b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189f:	48 83 e8 04          	sub    $0x4,%rax
  8018a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018a7:	48 83 ea 04          	sub    $0x4,%rdx
  8018ab:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018af:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8018b3:	48 89 c7             	mov    %rax,%rdi
  8018b6:	48 89 d6             	mov    %rdx,%rsi
  8018b9:	fd                   	std    
  8018ba:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018bc:	eb 1d                	jmp    8018db <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ca:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8018ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d2:	48 89 d7             	mov    %rdx,%rdi
  8018d5:	48 89 c1             	mov    %rax,%rcx
  8018d8:	fd                   	std    
  8018d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018db:	fc                   	cld    
  8018dc:	eb 57                	jmp    801935 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e2:	83 e0 03             	and    $0x3,%eax
  8018e5:	48 85 c0             	test   %rax,%rax
  8018e8:	75 36                	jne    801920 <memmove+0xfc>
  8018ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ee:	83 e0 03             	and    $0x3,%eax
  8018f1:	48 85 c0             	test   %rax,%rax
  8018f4:	75 2a                	jne    801920 <memmove+0xfc>
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	83 e0 03             	and    $0x3,%eax
  8018fd:	48 85 c0             	test   %rax,%rax
  801900:	75 1e                	jne    801920 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	48 c1 e8 02          	shr    $0x2,%rax
  80190a:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80190d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801911:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801915:	48 89 c7             	mov    %rax,%rdi
  801918:	48 89 d6             	mov    %rdx,%rsi
  80191b:	fc                   	cld    
  80191c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80191e:	eb 15                	jmp    801935 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801924:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801928:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80192c:	48 89 c7             	mov    %rax,%rdi
  80192f:	48 89 d6             	mov    %rdx,%rsi
  801932:	fc                   	cld    
  801933:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801939:	c9                   	leaveq 
  80193a:	c3                   	retq   

000000000080193b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80193b:	55                   	push   %rbp
  80193c:	48 89 e5             	mov    %rsp,%rbp
  80193f:	48 83 ec 18          	sub    $0x18,%rsp
  801943:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801947:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80194b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80194f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801953:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195b:	48 89 ce             	mov    %rcx,%rsi
  80195e:	48 89 c7             	mov    %rax,%rdi
  801961:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  801968:	00 00 00 
  80196b:	ff d0                	callq  *%rax
}
  80196d:	c9                   	leaveq 
  80196e:	c3                   	retq   

000000000080196f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80196f:	55                   	push   %rbp
  801970:	48 89 e5             	mov    %rsp,%rbp
  801973:	48 83 ec 28          	sub    $0x28,%rsp
  801977:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80197b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80197f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801987:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80198b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80198f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801993:	eb 36                	jmp    8019cb <memcmp+0x5c>
		if (*s1 != *s2)
  801995:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801999:	0f b6 10             	movzbl (%rax),%edx
  80199c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a0:	0f b6 00             	movzbl (%rax),%eax
  8019a3:	38 c2                	cmp    %al,%dl
  8019a5:	74 1a                	je     8019c1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ab:	0f b6 00             	movzbl (%rax),%eax
  8019ae:	0f b6 d0             	movzbl %al,%edx
  8019b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b5:	0f b6 00             	movzbl (%rax),%eax
  8019b8:	0f b6 c0             	movzbl %al,%eax
  8019bb:	29 c2                	sub    %eax,%edx
  8019bd:	89 d0                	mov    %edx,%eax
  8019bf:	eb 20                	jmp    8019e1 <memcmp+0x72>
		s1++, s2++;
  8019c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019c6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8019cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8019d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019d7:	48 85 c0             	test   %rax,%rax
  8019da:	75 b9                	jne    801995 <memcmp+0x26>
	}

	return 0;
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e1:	c9                   	leaveq 
  8019e2:	c3                   	retq   

00000000008019e3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8019e3:	55                   	push   %rbp
  8019e4:	48 89 e5             	mov    %rsp,%rbp
  8019e7:	48 83 ec 28          	sub    $0x28,%rsp
  8019eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8019f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8019f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fe:	48 01 d0             	add    %rdx,%rax
  801a01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a05:	eb 15                	jmp    801a1c <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a0b:	0f b6 00             	movzbl (%rax),%eax
  801a0e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801a11:	38 d0                	cmp    %dl,%al
  801a13:	75 02                	jne    801a17 <memfind+0x34>
			break;
  801a15:	eb 0f                	jmp    801a26 <memfind+0x43>
	for (; s < ends; s++)
  801a17:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a20:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a24:	72 e1                	jb     801a07 <memfind+0x24>
	return (void *) s;
  801a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a2a:	c9                   	leaveq 
  801a2b:	c3                   	retq   

0000000000801a2c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a2c:	55                   	push   %rbp
  801a2d:	48 89 e5             	mov    %rsp,%rbp
  801a30:	48 83 ec 38          	sub    $0x38,%rsp
  801a34:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a38:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a3c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a46:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a4d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a4e:	eb 05                	jmp    801a55 <strtol+0x29>
		s++;
  801a50:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	3c 20                	cmp    $0x20,%al
  801a5e:	74 f0                	je     801a50 <strtol+0x24>
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	3c 09                	cmp    $0x9,%al
  801a69:	74 e5                	je     801a50 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801a6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6f:	0f b6 00             	movzbl (%rax),%eax
  801a72:	3c 2b                	cmp    $0x2b,%al
  801a74:	75 07                	jne    801a7d <strtol+0x51>
		s++;
  801a76:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a7b:	eb 17                	jmp    801a94 <strtol+0x68>
	else if (*s == '-')
  801a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a81:	0f b6 00             	movzbl (%rax),%eax
  801a84:	3c 2d                	cmp    $0x2d,%al
  801a86:	75 0c                	jne    801a94 <strtol+0x68>
		s++, neg = 1;
  801a88:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a94:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a98:	74 06                	je     801aa0 <strtol+0x74>
  801a9a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a9e:	75 28                	jne    801ac8 <strtol+0x9c>
  801aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa4:	0f b6 00             	movzbl (%rax),%eax
  801aa7:	3c 30                	cmp    $0x30,%al
  801aa9:	75 1d                	jne    801ac8 <strtol+0x9c>
  801aab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aaf:	48 83 c0 01          	add    $0x1,%rax
  801ab3:	0f b6 00             	movzbl (%rax),%eax
  801ab6:	3c 78                	cmp    $0x78,%al
  801ab8:	75 0e                	jne    801ac8 <strtol+0x9c>
		s += 2, base = 16;
  801aba:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801abf:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801ac6:	eb 2c                	jmp    801af4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ac8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801acc:	75 19                	jne    801ae7 <strtol+0xbb>
  801ace:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad2:	0f b6 00             	movzbl (%rax),%eax
  801ad5:	3c 30                	cmp    $0x30,%al
  801ad7:	75 0e                	jne    801ae7 <strtol+0xbb>
		s++, base = 8;
  801ad9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ade:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ae5:	eb 0d                	jmp    801af4 <strtol+0xc8>
	else if (base == 0)
  801ae7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801aeb:	75 07                	jne    801af4 <strtol+0xc8>
		base = 10;
  801aed:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	0f b6 00             	movzbl (%rax),%eax
  801afb:	3c 2f                	cmp    $0x2f,%al
  801afd:	7e 1d                	jle    801b1c <strtol+0xf0>
  801aff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b03:	0f b6 00             	movzbl (%rax),%eax
  801b06:	3c 39                	cmp    $0x39,%al
  801b08:	7f 12                	jg     801b1c <strtol+0xf0>
			dig = *s - '0';
  801b0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0e:	0f b6 00             	movzbl (%rax),%eax
  801b11:	0f be c0             	movsbl %al,%eax
  801b14:	83 e8 30             	sub    $0x30,%eax
  801b17:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b1a:	eb 4e                	jmp    801b6a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b20:	0f b6 00             	movzbl (%rax),%eax
  801b23:	3c 60                	cmp    $0x60,%al
  801b25:	7e 1d                	jle    801b44 <strtol+0x118>
  801b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2b:	0f b6 00             	movzbl (%rax),%eax
  801b2e:	3c 7a                	cmp    $0x7a,%al
  801b30:	7f 12                	jg     801b44 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b36:	0f b6 00             	movzbl (%rax),%eax
  801b39:	0f be c0             	movsbl %al,%eax
  801b3c:	83 e8 57             	sub    $0x57,%eax
  801b3f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b42:	eb 26                	jmp    801b6a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b48:	0f b6 00             	movzbl (%rax),%eax
  801b4b:	3c 40                	cmp    $0x40,%al
  801b4d:	7e 48                	jle    801b97 <strtol+0x16b>
  801b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b53:	0f b6 00             	movzbl (%rax),%eax
  801b56:	3c 5a                	cmp    $0x5a,%al
  801b58:	7f 3d                	jg     801b97 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801b5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5e:	0f b6 00             	movzbl (%rax),%eax
  801b61:	0f be c0             	movsbl %al,%eax
  801b64:	83 e8 37             	sub    $0x37,%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b6d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b70:	7c 02                	jl     801b74 <strtol+0x148>
			break;
  801b72:	eb 23                	jmp    801b97 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801b74:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b79:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b7c:	48 98                	cltq   
  801b7e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801b83:	48 89 c2             	mov    %rax,%rdx
  801b86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b89:	48 98                	cltq   
  801b8b:	48 01 d0             	add    %rdx,%rax
  801b8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b92:	e9 5d ff ff ff       	jmpq   801af4 <strtol+0xc8>

	if (endptr)
  801b97:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b9c:	74 0b                	je     801ba9 <strtol+0x17d>
		*endptr = (char *) s;
  801b9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ba2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ba6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bad:	74 09                	je     801bb8 <strtol+0x18c>
  801baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb3:	48 f7 d8             	neg    %rax
  801bb6:	eb 04                	jmp    801bbc <strtol+0x190>
  801bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bbc:	c9                   	leaveq 
  801bbd:	c3                   	retq   

0000000000801bbe <strstr>:

char * strstr(const char *in, const char *str)
{
  801bbe:	55                   	push   %rbp
  801bbf:	48 89 e5             	mov    %rsp,%rbp
  801bc2:	48 83 ec 30          	sub    $0x30,%rsp
  801bc6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801bce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bd2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bd6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bda:	0f b6 00             	movzbl (%rax),%eax
  801bdd:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801be0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801be4:	75 06                	jne    801bec <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801be6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bea:	eb 6b                	jmp    801c57 <strstr+0x99>

	len = strlen(str);
  801bec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf0:	48 89 c7             	mov    %rax,%rdi
  801bf3:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
  801bff:	48 98                	cltq   
  801c01:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c09:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c11:	0f b6 00             	movzbl (%rax),%eax
  801c14:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c17:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c1b:	75 07                	jne    801c24 <strstr+0x66>
				return (char *) 0;
  801c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c22:	eb 33                	jmp    801c57 <strstr+0x99>
		} while (sc != c);
  801c24:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c28:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c2b:	75 d8                	jne    801c05 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c31:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	48 89 ce             	mov    %rcx,%rsi
  801c3c:	48 89 c7             	mov    %rax,%rdi
  801c3f:	48 b8 b5 16 80 00 00 	movabs $0x8016b5,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	callq  *%rax
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	75 b6                	jne    801c05 <strstr+0x47>

	return (char *) (in - 1);
  801c4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c53:	48 83 e8 01          	sub    $0x1,%rax
}
  801c57:	c9                   	leaveq 
  801c58:	c3                   	retq   

0000000000801c59 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c59:	55                   	push   %rbp
  801c5a:	48 89 e5             	mov    %rsp,%rbp
  801c5d:	53                   	push   %rbx
  801c5e:	48 83 ec 48          	sub    $0x48,%rsp
  801c62:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c65:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c68:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c6c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c70:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c74:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c78:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c7b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c7f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c83:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c87:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c8b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c8f:	4c 89 c3             	mov    %r8,%rbx
  801c92:	cd 30                	int    $0x30
  801c94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801c98:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c9c:	74 3e                	je     801cdc <syscall+0x83>
  801c9e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ca3:	7e 37                	jle    801cdc <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ca5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ca9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cac:	49 89 d0             	mov    %rdx,%r8
  801caf:	89 c1                	mov    %eax,%ecx
  801cb1:	48 ba 08 52 80 00 00 	movabs $0x805208,%rdx
  801cb8:	00 00 00 
  801cbb:	be 23 00 00 00       	mov    $0x23,%esi
  801cc0:	48 bf 25 52 80 00 00 	movabs $0x805225,%rdi
  801cc7:	00 00 00 
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	49 b9 2d 07 80 00 00 	movabs $0x80072d,%r9
  801cd6:	00 00 00 
  801cd9:	41 ff d1             	callq  *%r9

	return ret;
  801cdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ce0:	48 83 c4 48          	add    $0x48,%rsp
  801ce4:	5b                   	pop    %rbx
  801ce5:	5d                   	pop    %rbp
  801ce6:	c3                   	retq   

0000000000801ce7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ce7:	55                   	push   %rbp
  801ce8:	48 89 e5             	mov    %rsp,%rbp
  801ceb:	48 83 ec 10          	sub    $0x10,%rsp
  801cef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cff:	48 83 ec 08          	sub    $0x8,%rsp
  801d03:	6a 00                	pushq  $0x0
  801d05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d11:	48 89 d1             	mov    %rdx,%rcx
  801d14:	48 89 c2             	mov    %rax,%rdx
  801d17:	be 00 00 00 00       	mov    $0x0,%esi
  801d1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d21:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
  801d2d:	48 83 c4 10          	add    $0x10,%rsp
}
  801d31:	c9                   	leaveq 
  801d32:	c3                   	retq   

0000000000801d33 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d33:	55                   	push   %rbp
  801d34:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d37:	48 83 ec 08          	sub    $0x8,%rsp
  801d3b:	6a 00                	pushq  $0x0
  801d3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	bf 01 00 00 00       	mov    $0x1,%edi
  801d5d:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
  801d69:	48 83 c4 10          	add    $0x10,%rsp
}
  801d6d:	c9                   	leaveq 
  801d6e:	c3                   	retq   

0000000000801d6f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d6f:	55                   	push   %rbp
  801d70:	48 89 e5             	mov    %rsp,%rbp
  801d73:	48 83 ec 10          	sub    $0x10,%rsp
  801d77:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7d:	48 98                	cltq   
  801d7f:	48 83 ec 08          	sub    $0x8,%rsp
  801d83:	6a 00                	pushq  $0x0
  801d85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d91:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d96:	48 89 c2             	mov    %rax,%rdx
  801d99:	be 01 00 00 00       	mov    $0x1,%esi
  801d9e:	bf 03 00 00 00       	mov    $0x3,%edi
  801da3:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	callq  *%rax
  801daf:	48 83 c4 10          	add    $0x10,%rsp
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801db9:	48 83 ec 08          	sub    $0x8,%rsp
  801dbd:	6a 00                	pushq  $0x0
  801dbf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd5:	be 00 00 00 00       	mov    $0x0,%esi
  801dda:	bf 02 00 00 00       	mov    $0x2,%edi
  801ddf:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801de6:	00 00 00 
  801de9:	ff d0                	callq  *%rax
  801deb:	48 83 c4 10          	add    $0x10,%rsp
}
  801def:	c9                   	leaveq 
  801df0:	c3                   	retq   

0000000000801df1 <sys_yield>:

void
sys_yield(void)
{
  801df1:	55                   	push   %rbp
  801df2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801df5:	48 83 ec 08          	sub    $0x8,%rsp
  801df9:	6a 00                	pushq  $0x0
  801dfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
  801e16:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e1b:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax
  801e27:	48 83 c4 10          	add    $0x10,%rsp
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 10          	sub    $0x10,%rsp
  801e35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e42:	48 63 c8             	movslq %eax,%rcx
  801e45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4c:	48 98                	cltq   
  801e4e:	48 83 ec 08          	sub    $0x8,%rsp
  801e52:	6a 00                	pushq  $0x0
  801e54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5a:	49 89 c8             	mov    %rcx,%r8
  801e5d:	48 89 d1             	mov    %rdx,%rcx
  801e60:	48 89 c2             	mov    %rax,%rdx
  801e63:	be 01 00 00 00       	mov    $0x1,%esi
  801e68:	bf 04 00 00 00       	mov    $0x4,%edi
  801e6d:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
  801e79:	48 83 c4 10          	add    $0x10,%rsp
}
  801e7d:	c9                   	leaveq 
  801e7e:	c3                   	retq   

0000000000801e7f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e7f:	55                   	push   %rbp
  801e80:	48 89 e5             	mov    %rsp,%rbp
  801e83:	48 83 ec 20          	sub    $0x20,%rsp
  801e87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e8e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e91:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e95:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e99:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e9c:	48 63 c8             	movslq %eax,%rcx
  801e9f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ea3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ea6:	48 63 f0             	movslq %eax,%rsi
  801ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb0:	48 98                	cltq   
  801eb2:	48 83 ec 08          	sub    $0x8,%rsp
  801eb6:	51                   	push   %rcx
  801eb7:	49 89 f9             	mov    %rdi,%r9
  801eba:	49 89 f0             	mov    %rsi,%r8
  801ebd:	48 89 d1             	mov    %rdx,%rcx
  801ec0:	48 89 c2             	mov    %rax,%rdx
  801ec3:	be 01 00 00 00       	mov    $0x1,%esi
  801ec8:	bf 05 00 00 00       	mov    $0x5,%edi
  801ecd:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
  801ed9:	48 83 c4 10          	add    $0x10,%rsp
}
  801edd:	c9                   	leaveq 
  801ede:	c3                   	retq   

0000000000801edf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801edf:	55                   	push   %rbp
  801ee0:	48 89 e5             	mov    %rsp,%rbp
  801ee3:	48 83 ec 10          	sub    $0x10,%rsp
  801ee7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801eee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef5:	48 98                	cltq   
  801ef7:	48 83 ec 08          	sub    $0x8,%rsp
  801efb:	6a 00                	pushq  $0x0
  801efd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f09:	48 89 d1             	mov    %rdx,%rcx
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	be 01 00 00 00       	mov    $0x1,%esi
  801f14:	bf 06 00 00 00       	mov    $0x6,%edi
  801f19:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
  801f25:	48 83 c4 10          	add    $0x10,%rsp
}
  801f29:	c9                   	leaveq 
  801f2a:	c3                   	retq   

0000000000801f2b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	48 83 ec 10          	sub    $0x10,%rsp
  801f33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f36:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f3c:	48 63 d0             	movslq %eax,%rdx
  801f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f42:	48 98                	cltq   
  801f44:	48 83 ec 08          	sub    $0x8,%rsp
  801f48:	6a 00                	pushq  $0x0
  801f4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f56:	48 89 d1             	mov    %rdx,%rcx
  801f59:	48 89 c2             	mov    %rax,%rdx
  801f5c:	be 01 00 00 00       	mov    $0x1,%esi
  801f61:	bf 08 00 00 00       	mov    $0x8,%edi
  801f66:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	callq  *%rax
  801f72:	48 83 c4 10          	add    $0x10,%rsp
}
  801f76:	c9                   	leaveq 
  801f77:	c3                   	retq   

0000000000801f78 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f78:	55                   	push   %rbp
  801f79:	48 89 e5             	mov    %rsp,%rbp
  801f7c:	48 83 ec 10          	sub    $0x10,%rsp
  801f80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8e:	48 98                	cltq   
  801f90:	48 83 ec 08          	sub    $0x8,%rsp
  801f94:	6a 00                	pushq  $0x0
  801f96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa2:	48 89 d1             	mov    %rdx,%rcx
  801fa5:	48 89 c2             	mov    %rax,%rdx
  801fa8:	be 01 00 00 00       	mov    $0x1,%esi
  801fad:	bf 09 00 00 00       	mov    $0x9,%edi
  801fb2:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  801fb9:	00 00 00 
  801fbc:	ff d0                	callq  *%rax
  801fbe:	48 83 c4 10          	add    $0x10,%rsp
}
  801fc2:	c9                   	leaveq 
  801fc3:	c3                   	retq   

0000000000801fc4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801fc4:	55                   	push   %rbp
  801fc5:	48 89 e5             	mov    %rsp,%rbp
  801fc8:	48 83 ec 10          	sub    $0x10,%rsp
  801fcc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801fd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fda:	48 98                	cltq   
  801fdc:	48 83 ec 08          	sub    $0x8,%rsp
  801fe0:	6a 00                	pushq  $0x0
  801fe2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fee:	48 89 d1             	mov    %rdx,%rcx
  801ff1:	48 89 c2             	mov    %rax,%rdx
  801ff4:	be 01 00 00 00       	mov    $0x1,%esi
  801ff9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ffe:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  802005:	00 00 00 
  802008:	ff d0                	callq  *%rax
  80200a:	48 83 c4 10          	add    $0x10,%rsp
}
  80200e:	c9                   	leaveq 
  80200f:	c3                   	retq   

0000000000802010 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802010:	55                   	push   %rbp
  802011:	48 89 e5             	mov    %rsp,%rbp
  802014:	48 83 ec 20          	sub    $0x20,%rsp
  802018:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80201b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80201f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802023:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802026:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802029:	48 63 f0             	movslq %eax,%rsi
  80202c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802030:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802033:	48 98                	cltq   
  802035:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802039:	48 83 ec 08          	sub    $0x8,%rsp
  80203d:	6a 00                	pushq  $0x0
  80203f:	49 89 f1             	mov    %rsi,%r9
  802042:	49 89 c8             	mov    %rcx,%r8
  802045:	48 89 d1             	mov    %rdx,%rcx
  802048:	48 89 c2             	mov    %rax,%rdx
  80204b:	be 00 00 00 00       	mov    $0x0,%esi
  802050:	bf 0c 00 00 00       	mov    $0xc,%edi
  802055:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  80205c:	00 00 00 
  80205f:	ff d0                	callq  *%rax
  802061:	48 83 c4 10          	add    $0x10,%rsp
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 10          	sub    $0x10,%rsp
  80206f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802077:	48 83 ec 08          	sub    $0x8,%rsp
  80207b:	6a 00                	pushq  $0x0
  80207d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802083:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802089:	b9 00 00 00 00       	mov    $0x0,%ecx
  80208e:	48 89 c2             	mov    %rax,%rdx
  802091:	be 01 00 00 00       	mov    $0x1,%esi
  802096:	bf 0d 00 00 00       	mov    $0xd,%edi
  80209b:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
  8020a7:	48 83 c4 10          	add    $0x10,%rsp
}
  8020ab:	c9                   	leaveq 
  8020ac:	c3                   	retq   

00000000008020ad <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8020ad:	55                   	push   %rbp
  8020ae:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020b1:	48 83 ec 08          	sub    $0x8,%rsp
  8020b5:	6a 00                	pushq  $0x0
  8020b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020cd:	be 00 00 00 00       	mov    $0x0,%esi
  8020d2:	bf 0e 00 00 00       	mov    $0xe,%edi
  8020d7:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  8020de:	00 00 00 
  8020e1:	ff d0                	callq  *%rax
  8020e3:	48 83 c4 10          	add    $0x10,%rsp
}
  8020e7:	c9                   	leaveq 
  8020e8:	c3                   	retq   

00000000008020e9 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8020e9:	55                   	push   %rbp
  8020ea:	48 89 e5             	mov    %rsp,%rbp
  8020ed:	48 83 ec 20          	sub    $0x20,%rsp
  8020f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020ff:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802103:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802106:	48 63 c8             	movslq %eax,%rcx
  802109:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80210d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802110:	48 63 f0             	movslq %eax,%rsi
  802113:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211a:	48 98                	cltq   
  80211c:	48 83 ec 08          	sub    $0x8,%rsp
  802120:	51                   	push   %rcx
  802121:	49 89 f9             	mov    %rdi,%r9
  802124:	49 89 f0             	mov    %rsi,%r8
  802127:	48 89 d1             	mov    %rdx,%rcx
  80212a:	48 89 c2             	mov    %rax,%rdx
  80212d:	be 00 00 00 00       	mov    $0x0,%esi
  802132:	bf 0f 00 00 00       	mov    $0xf,%edi
  802137:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
  802143:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802147:	c9                   	leaveq 
  802148:	c3                   	retq   

0000000000802149 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802149:	55                   	push   %rbp
  80214a:	48 89 e5             	mov    %rsp,%rbp
  80214d:	48 83 ec 10          	sub    $0x10,%rsp
  802151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802155:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802159:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80215d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802161:	48 83 ec 08          	sub    $0x8,%rsp
  802165:	6a 00                	pushq  $0x0
  802167:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80216d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802173:	48 89 d1             	mov    %rdx,%rcx
  802176:	48 89 c2             	mov    %rax,%rdx
  802179:	be 00 00 00 00       	mov    $0x0,%esi
  80217e:	bf 10 00 00 00       	mov    $0x10,%edi
  802183:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  80218a:	00 00 00 
  80218d:	ff d0                	callq  *%rax
  80218f:	48 83 c4 10          	add    $0x10,%rsp
}
  802193:	c9                   	leaveq 
  802194:	c3                   	retq   

0000000000802195 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802195:	55                   	push   %rbp
  802196:	48 89 e5             	mov    %rsp,%rbp
  802199:	48 83 ec 08          	sub    $0x8,%rsp
  80219d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021a5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021ac:	ff ff ff 
  8021af:	48 01 d0             	add    %rdx,%rax
  8021b2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021b6:	c9                   	leaveq 
  8021b7:	c3                   	retq   

00000000008021b8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021b8:	55                   	push   %rbp
  8021b9:	48 89 e5             	mov    %rsp,%rbp
  8021bc:	48 83 ec 08          	sub    $0x8,%rsp
  8021c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c8:	48 89 c7             	mov    %rax,%rdi
  8021cb:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	callq  *%rax
  8021d7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021dd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021e1:	c9                   	leaveq 
  8021e2:	c3                   	retq   

00000000008021e3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021e3:	55                   	push   %rbp
  8021e4:	48 89 e5             	mov    %rsp,%rbp
  8021e7:	48 83 ec 18          	sub    $0x18,%rsp
  8021eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f6:	eb 6b                	jmp    802263 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fb:	48 98                	cltq   
  8021fd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802203:	48 c1 e0 0c          	shl    $0xc,%rax
  802207:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80220b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220f:	48 c1 e8 15          	shr    $0x15,%rax
  802213:	48 89 c2             	mov    %rax,%rdx
  802216:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80221d:	01 00 00 
  802220:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802224:	83 e0 01             	and    $0x1,%eax
  802227:	48 85 c0             	test   %rax,%rax
  80222a:	74 21                	je     80224d <fd_alloc+0x6a>
  80222c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802230:	48 c1 e8 0c          	shr    $0xc,%rax
  802234:	48 89 c2             	mov    %rax,%rdx
  802237:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80223e:	01 00 00 
  802241:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802245:	83 e0 01             	and    $0x1,%eax
  802248:	48 85 c0             	test   %rax,%rax
  80224b:	75 12                	jne    80225f <fd_alloc+0x7c>
			*fd_store = fd;
  80224d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802251:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802255:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	eb 1a                	jmp    802279 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  80225f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802263:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802267:	7e 8f                	jle    8021f8 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802274:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802279:	c9                   	leaveq 
  80227a:	c3                   	retq   

000000000080227b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80227b:	55                   	push   %rbp
  80227c:	48 89 e5             	mov    %rsp,%rbp
  80227f:	48 83 ec 20          	sub    $0x20,%rsp
  802283:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802286:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80228a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80228e:	78 06                	js     802296 <fd_lookup+0x1b>
  802290:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802294:	7e 07                	jle    80229d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802296:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80229b:	eb 6c                	jmp    802309 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80229d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022a0:	48 98                	cltq   
  8022a2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022a8:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b4:	48 c1 e8 15          	shr    $0x15,%rax
  8022b8:	48 89 c2             	mov    %rax,%rdx
  8022bb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022c2:	01 00 00 
  8022c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c9:	83 e0 01             	and    $0x1,%eax
  8022cc:	48 85 c0             	test   %rax,%rax
  8022cf:	74 21                	je     8022f2 <fd_lookup+0x77>
  8022d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d5:	48 c1 e8 0c          	shr    $0xc,%rax
  8022d9:	48 89 c2             	mov    %rax,%rdx
  8022dc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022e3:	01 00 00 
  8022e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ea:	83 e0 01             	and    $0x1,%eax
  8022ed:	48 85 c0             	test   %rax,%rax
  8022f0:	75 07                	jne    8022f9 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022f7:	eb 10                	jmp    802309 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802301:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802309:	c9                   	leaveq 
  80230a:	c3                   	retq   

000000000080230b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80230b:	55                   	push   %rbp
  80230c:	48 89 e5             	mov    %rsp,%rbp
  80230f:	48 83 ec 30          	sub    $0x30,%rsp
  802313:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802317:	89 f0                	mov    %esi,%eax
  802319:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80231c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802320:	48 89 c7             	mov    %rax,%rdi
  802323:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  80232a:	00 00 00 
  80232d:	ff d0                	callq  *%rax
  80232f:	89 c2                	mov    %eax,%edx
  802331:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802335:	48 89 c6             	mov    %rax,%rsi
  802338:	89 d7                	mov    %edx,%edi
  80233a:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax
  802346:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802349:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234d:	78 0a                	js     802359 <fd_close+0x4e>
	    || fd != fd2)
  80234f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802353:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802357:	74 12                	je     80236b <fd_close+0x60>
		return (must_exist ? r : 0);
  802359:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80235d:	74 05                	je     802364 <fd_close+0x59>
  80235f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802362:	eb 70                	jmp    8023d4 <fd_close+0xc9>
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	eb 69                	jmp    8023d4 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80236b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236f:	8b 00                	mov    (%rax),%eax
  802371:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802375:	48 89 d6             	mov    %rdx,%rsi
  802378:	89 c7                	mov    %eax,%edi
  80237a:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
  802386:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802389:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238d:	78 2a                	js     8023b9 <fd_close+0xae>
		if (dev->dev_close)
  80238f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802393:	48 8b 40 20          	mov    0x20(%rax),%rax
  802397:	48 85 c0             	test   %rax,%rax
  80239a:	74 16                	je     8023b2 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80239c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023a8:	48 89 d7             	mov    %rdx,%rdi
  8023ab:	ff d0                	callq  *%rax
  8023ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b0:	eb 07                	jmp    8023b9 <fd_close+0xae>
		else
			r = 0;
  8023b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023bd:	48 89 c6             	mov    %rax,%rsi
  8023c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c5:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8023cc:	00 00 00 
  8023cf:	ff d0                	callq  *%rax
	return r;
  8023d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023d4:	c9                   	leaveq 
  8023d5:	c3                   	retq   

00000000008023d6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023d6:	55                   	push   %rbp
  8023d7:	48 89 e5             	mov    %rsp,%rbp
  8023da:	48 83 ec 20          	sub    $0x20,%rsp
  8023de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023ec:	eb 41                	jmp    80242f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023ee:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8023f5:	00 00 00 
  8023f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023fb:	48 63 d2             	movslq %edx,%rdx
  8023fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802402:	8b 00                	mov    (%rax),%eax
  802404:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802407:	75 22                	jne    80242b <dev_lookup+0x55>
			*dev = devtab[i];
  802409:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  802410:	00 00 00 
  802413:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802416:	48 63 d2             	movslq %edx,%rdx
  802419:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80241d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802421:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
  802429:	eb 60                	jmp    80248b <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  80242b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80242f:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  802436:	00 00 00 
  802439:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80243c:	48 63 d2             	movslq %edx,%rdx
  80243f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802443:	48 85 c0             	test   %rax,%rax
  802446:	75 a6                	jne    8023ee <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802448:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  80244f:	00 00 00 
  802452:	48 8b 00             	mov    (%rax),%rax
  802455:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80245b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80245e:	89 c6                	mov    %eax,%esi
  802460:	48 bf 38 52 80 00 00 	movabs $0x805238,%rdi
  802467:	00 00 00 
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	48 b9 66 09 80 00 00 	movabs $0x800966,%rcx
  802476:	00 00 00 
  802479:	ff d1                	callq  *%rcx
	*dev = 0;
  80247b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802486:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80248b:	c9                   	leaveq 
  80248c:	c3                   	retq   

000000000080248d <close>:

int
close(int fdnum)
{
  80248d:	55                   	push   %rbp
  80248e:	48 89 e5             	mov    %rsp,%rbp
  802491:	48 83 ec 20          	sub    $0x20,%rsp
  802495:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802498:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80249c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249f:	48 89 d6             	mov    %rdx,%rsi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b7:	79 05                	jns    8024be <close+0x31>
		return r;
  8024b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bc:	eb 18                	jmp    8024d6 <close+0x49>
	else
		return fd_close(fd, 1);
  8024be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c2:	be 01 00 00 00       	mov    $0x1,%esi
  8024c7:	48 89 c7             	mov    %rax,%rdi
  8024ca:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
}
  8024d6:	c9                   	leaveq 
  8024d7:	c3                   	retq   

00000000008024d8 <close_all>:

void
close_all(void)
{
  8024d8:	55                   	push   %rbp
  8024d9:	48 89 e5             	mov    %rsp,%rbp
  8024dc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024e7:	eb 15                	jmp    8024fe <close_all+0x26>
		close(i);
  8024e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ec:	89 c7                	mov    %eax,%edi
  8024ee:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  8024f5:	00 00 00 
  8024f8:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8024fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024fe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802502:	7e e5                	jle    8024e9 <close_all+0x11>
}
  802504:	c9                   	leaveq 
  802505:	c3                   	retq   

0000000000802506 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802506:	55                   	push   %rbp
  802507:	48 89 e5             	mov    %rsp,%rbp
  80250a:	48 83 ec 40          	sub    $0x40,%rsp
  80250e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802511:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802514:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802518:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 08                	jns    80253d <dup+0x37>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	e9 70 01 00 00       	jmpq   8026ad <dup+0x1a7>
	close(newfdnum);
  80253d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802540:	89 c7                	mov    %eax,%edi
  802542:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802549:	00 00 00 
  80254c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80254e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802551:	48 98                	cltq   
  802553:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802559:	48 c1 e0 0c          	shl    $0xc,%rax
  80255d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802565:	48 89 c7             	mov    %rax,%rdi
  802568:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  80256f:	00 00 00 
  802572:	ff d0                	callq  *%rax
  802574:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257c:	48 89 c7             	mov    %rax,%rdi
  80257f:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
  80258b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80258f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802593:	48 c1 e8 15          	shr    $0x15,%rax
  802597:	48 89 c2             	mov    %rax,%rdx
  80259a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025a1:	01 00 00 
  8025a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a8:	83 e0 01             	and    $0x1,%eax
  8025ab:	48 85 c0             	test   %rax,%rax
  8025ae:	74 73                	je     802623 <dup+0x11d>
  8025b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b8:	48 89 c2             	mov    %rax,%rdx
  8025bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c2:	01 00 00 
  8025c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c9:	83 e0 01             	and    $0x1,%eax
  8025cc:	48 85 c0             	test   %rax,%rax
  8025cf:	74 52                	je     802623 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d5:	48 c1 e8 0c          	shr    $0xc,%rax
  8025d9:	48 89 c2             	mov    %rax,%rdx
  8025dc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025e3:	01 00 00 
  8025e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8025ef:	89 c1                	mov    %eax,%ecx
  8025f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f9:	41 89 c8             	mov    %ecx,%r8d
  8025fc:	48 89 d1             	mov    %rdx,%rcx
  8025ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802604:	48 89 c6             	mov    %rax,%rsi
  802607:	bf 00 00 00 00       	mov    $0x0,%edi
  80260c:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261f:	79 02                	jns    802623 <dup+0x11d>
			goto err;
  802621:	eb 57                	jmp    80267a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802627:	48 c1 e8 0c          	shr    $0xc,%rax
  80262b:	48 89 c2             	mov    %rax,%rdx
  80262e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802635:	01 00 00 
  802638:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80263c:	25 07 0e 00 00       	and    $0xe07,%eax
  802641:	89 c1                	mov    %eax,%ecx
  802643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802647:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80264b:	41 89 c8             	mov    %ecx,%r8d
  80264e:	48 89 d1             	mov    %rdx,%rcx
  802651:	ba 00 00 00 00       	mov    $0x0,%edx
  802656:	48 89 c6             	mov    %rax,%rsi
  802659:	bf 00 00 00 00       	mov    $0x0,%edi
  80265e:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
  80266a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802671:	79 02                	jns    802675 <dup+0x16f>
		goto err;
  802673:	eb 05                	jmp    80267a <dup+0x174>

	return newfdnum;
  802675:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802678:	eb 33                	jmp    8026ad <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80267a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267e:	48 89 c6             	mov    %rax,%rsi
  802681:	bf 00 00 00 00       	mov    $0x0,%edi
  802686:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802692:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802696:	48 89 c6             	mov    %rax,%rsi
  802699:	bf 00 00 00 00       	mov    $0x0,%edi
  80269e:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
	return r;
  8026aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026ad:	c9                   	leaveq 
  8026ae:	c3                   	retq   

00000000008026af <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026af:	55                   	push   %rbp
  8026b0:	48 89 e5             	mov    %rsp,%rbp
  8026b3:	48 83 ec 40          	sub    $0x40,%rsp
  8026b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026be:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026c9:	48 89 d6             	mov    %rdx,%rsi
  8026cc:	89 c7                	mov    %eax,%edi
  8026ce:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
  8026da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e1:	78 24                	js     802707 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e7:	8b 00                	mov    (%rax),%eax
  8026e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ed:	48 89 d6             	mov    %rdx,%rsi
  8026f0:	89 c7                	mov    %eax,%edi
  8026f2:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
  8026fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802705:	79 05                	jns    80270c <read+0x5d>
		return r;
  802707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270a:	eb 76                	jmp    802782 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80270c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802710:	8b 40 08             	mov    0x8(%rax),%eax
  802713:	83 e0 03             	and    $0x3,%eax
  802716:	83 f8 01             	cmp    $0x1,%eax
  802719:	75 3a                	jne    802755 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80271b:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  802722:	00 00 00 
  802725:	48 8b 00             	mov    (%rax),%rax
  802728:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80272e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802731:	89 c6                	mov    %eax,%esi
  802733:	48 bf 57 52 80 00 00 	movabs $0x805257,%rdi
  80273a:	00 00 00 
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	48 b9 66 09 80 00 00 	movabs $0x800966,%rcx
  802749:	00 00 00 
  80274c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80274e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802753:	eb 2d                	jmp    802782 <read+0xd3>
	}
	if (!dev->dev_read)
  802755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802759:	48 8b 40 10          	mov    0x10(%rax),%rax
  80275d:	48 85 c0             	test   %rax,%rax
  802760:	75 07                	jne    802769 <read+0xba>
		return -E_NOT_SUPP;
  802762:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802767:	eb 19                	jmp    802782 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802771:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802775:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802779:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80277d:	48 89 cf             	mov    %rcx,%rdi
  802780:	ff d0                	callq  *%rax
}
  802782:	c9                   	leaveq 
  802783:	c3                   	retq   

0000000000802784 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802784:	55                   	push   %rbp
  802785:	48 89 e5             	mov    %rsp,%rbp
  802788:	48 83 ec 30          	sub    $0x30,%rsp
  80278c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80278f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802793:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802797:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80279e:	eb 49                	jmp    8027e9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a3:	48 98                	cltq   
  8027a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027a9:	48 29 c2             	sub    %rax,%rdx
  8027ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027af:	48 63 c8             	movslq %eax,%rcx
  8027b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b6:	48 01 c1             	add    %rax,%rcx
  8027b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027bc:	48 89 ce             	mov    %rcx,%rsi
  8027bf:	89 c7                	mov    %eax,%edi
  8027c1:	48 b8 af 26 80 00 00 	movabs $0x8026af,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
  8027cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027d4:	79 05                	jns    8027db <readn+0x57>
			return m;
  8027d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027d9:	eb 1c                	jmp    8027f7 <readn+0x73>
		if (m == 0)
  8027db:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027df:	75 02                	jne    8027e3 <readn+0x5f>
			break;
  8027e1:	eb 11                	jmp    8027f4 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8027e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027e6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ec:	48 98                	cltq   
  8027ee:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027f2:	72 ac                	jb     8027a0 <readn+0x1c>
	}
	return tot;
  8027f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027f7:	c9                   	leaveq 
  8027f8:	c3                   	retq   

00000000008027f9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027f9:	55                   	push   %rbp
  8027fa:	48 89 e5             	mov    %rsp,%rbp
  8027fd:	48 83 ec 40          	sub    $0x40,%rsp
  802801:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802804:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802808:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80280c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802810:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802813:	48 89 d6             	mov    %rdx,%rsi
  802816:	89 c7                	mov    %eax,%edi
  802818:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
  802824:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802827:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282b:	78 24                	js     802851 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80282d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802831:	8b 00                	mov    (%rax),%eax
  802833:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802837:	48 89 d6             	mov    %rdx,%rsi
  80283a:	89 c7                	mov    %eax,%edi
  80283c:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
  802848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284f:	79 05                	jns    802856 <write+0x5d>
		return r;
  802851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802854:	eb 75                	jmp    8028cb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285a:	8b 40 08             	mov    0x8(%rax),%eax
  80285d:	83 e0 03             	and    $0x3,%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	75 3a                	jne    80289e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802864:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  80286b:	00 00 00 
  80286e:	48 8b 00             	mov    (%rax),%rax
  802871:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802877:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80287a:	89 c6                	mov    %eax,%esi
  80287c:	48 bf 73 52 80 00 00 	movabs $0x805273,%rdi
  802883:	00 00 00 
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
  80288b:	48 b9 66 09 80 00 00 	movabs $0x800966,%rcx
  802892:	00 00 00 
  802895:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802897:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80289c:	eb 2d                	jmp    8028cb <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80289e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028a6:	48 85 c0             	test   %rax,%rax
  8028a9:	75 07                	jne    8028b2 <write+0xb9>
		return -E_NOT_SUPP;
  8028ab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b0:	eb 19                	jmp    8028cb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028be:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028c2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028c6:	48 89 cf             	mov    %rcx,%rdi
  8028c9:	ff d0                	callq  *%rax
}
  8028cb:	c9                   	leaveq 
  8028cc:	c3                   	retq   

00000000008028cd <seek>:

int
seek(int fdnum, off_t offset)
{
  8028cd:	55                   	push   %rbp
  8028ce:	48 89 e5             	mov    %rsp,%rbp
  8028d1:	48 83 ec 18          	sub    $0x18,%rsp
  8028d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e2:	48 89 d6             	mov    %rdx,%rsi
  8028e5:	89 c7                	mov    %eax,%edi
  8028e7:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	callq  *%rax
  8028f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fa:	79 05                	jns    802901 <seek+0x34>
		return r;
  8028fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ff:	eb 0f                	jmp    802910 <seek+0x43>
	fd->fd_offset = offset;
  802901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802905:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802908:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 83 ec 30          	sub    $0x30,%rsp
  80291a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80291d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802920:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802924:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802927:	48 89 d6             	mov    %rdx,%rsi
  80292a:	89 c7                	mov    %eax,%edi
  80292c:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
  802938:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293f:	78 24                	js     802965 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802945:	8b 00                	mov    (%rax),%eax
  802947:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80294b:	48 89 d6             	mov    %rdx,%rsi
  80294e:	89 c7                	mov    %eax,%edi
  802950:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  802957:	00 00 00 
  80295a:	ff d0                	callq  *%rax
  80295c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802963:	79 05                	jns    80296a <ftruncate+0x58>
		return r;
  802965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802968:	eb 72                	jmp    8029dc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80296a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296e:	8b 40 08             	mov    0x8(%rax),%eax
  802971:	83 e0 03             	and    $0x3,%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	75 3a                	jne    8029b2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802978:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  80297f:	00 00 00 
  802982:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802985:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80298b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80298e:	89 c6                	mov    %eax,%esi
  802990:	48 bf 90 52 80 00 00 	movabs $0x805290,%rdi
  802997:	00 00 00 
  80299a:	b8 00 00 00 00       	mov    $0x0,%eax
  80299f:	48 b9 66 09 80 00 00 	movabs $0x800966,%rcx
  8029a6:	00 00 00 
  8029a9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b0:	eb 2a                	jmp    8029dc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029ba:	48 85 c0             	test   %rax,%rax
  8029bd:	75 07                	jne    8029c6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029bf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029c4:	eb 16                	jmp    8029dc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ca:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029d2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029d5:	89 ce                	mov    %ecx,%esi
  8029d7:	48 89 d7             	mov    %rdx,%rdi
  8029da:	ff d0                	callq  *%rax
}
  8029dc:	c9                   	leaveq 
  8029dd:	c3                   	retq   

00000000008029de <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029de:	55                   	push   %rbp
  8029df:	48 89 e5             	mov    %rsp,%rbp
  8029e2:	48 83 ec 30          	sub    $0x30,%rsp
  8029e6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f4:	48 89 d6             	mov    %rdx,%rsi
  8029f7:	89 c7                	mov    %eax,%edi
  8029f9:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
  802a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0c:	78 24                	js     802a32 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a12:	8b 00                	mov    (%rax),%eax
  802a14:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a18:	48 89 d6             	mov    %rdx,%rsi
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 d6 23 80 00 00 	movabs $0x8023d6,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
  802a29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a30:	79 05                	jns    802a37 <fstat+0x59>
		return r;
  802a32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a35:	eb 5e                	jmp    802a95 <fstat+0xb7>
	if (!dev->dev_stat)
  802a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a3f:	48 85 c0             	test   %rax,%rax
  802a42:	75 07                	jne    802a4b <fstat+0x6d>
		return -E_NOT_SUPP;
  802a44:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a49:	eb 4a                	jmp    802a95 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a4f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a56:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a5d:	00 00 00 
	stat->st_isdir = 0;
  802a60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a64:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a6b:	00 00 00 
	stat->st_dev = dev;
  802a6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a76:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a81:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a89:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a8d:	48 89 ce             	mov    %rcx,%rsi
  802a90:	48 89 d7             	mov    %rdx,%rdi
  802a93:	ff d0                	callq  *%rax
}
  802a95:	c9                   	leaveq 
  802a96:	c3                   	retq   

0000000000802a97 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a97:	55                   	push   %rbp
  802a98:	48 89 e5             	mov    %rsp,%rbp
  802a9b:	48 83 ec 20          	sub    $0x20,%rsp
  802a9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	48 89 c7             	mov    %rax,%rdi
  802ab3:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  802aba:	00 00 00 
  802abd:	ff d0                	callq  *%rax
  802abf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac6:	79 05                	jns    802acd <stat+0x36>
		return fd;
  802ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acb:	eb 2f                	jmp    802afc <stat+0x65>
	r = fstat(fd, stat);
  802acd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	48 89 d6             	mov    %rdx,%rsi
  802ad7:	89 c7                	mov    %eax,%edi
  802ad9:	48 b8 de 29 80 00 00 	movabs $0x8029de,%rax
  802ae0:	00 00 00 
  802ae3:	ff d0                	callq  *%rax
  802ae5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aeb:	89 c7                	mov    %eax,%edi
  802aed:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
	return r;
  802af9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802afc:	c9                   	leaveq 
  802afd:	c3                   	retq   

0000000000802afe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802afe:	55                   	push   %rbp
  802aff:	48 89 e5             	mov    %rsp,%rbp
  802b02:	48 83 ec 10          	sub    $0x10,%rsp
  802b06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b0d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b14:	00 00 00 
  802b17:	8b 00                	mov    (%rax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	75 1f                	jne    802b3c <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b1d:	bf 01 00 00 00       	mov    $0x1,%edi
  802b22:	48 b8 4f 4a 80 00 00 	movabs $0x804a4f,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
  802b2e:	89 c2                	mov    %eax,%edx
  802b30:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b37:	00 00 00 
  802b3a:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b3c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b43:	00 00 00 
  802b46:	8b 00                	mov    (%rax),%eax
  802b48:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b4b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b50:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  802b57:	00 00 00 
  802b5a:	89 c7                	mov    %eax,%edi
  802b5c:	48 b8 c2 48 80 00 00 	movabs $0x8048c2,%rax
  802b63:	00 00 00 
  802b66:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b71:	48 89 c6             	mov    %rax,%rsi
  802b74:	bf 00 00 00 00       	mov    $0x0,%edi
  802b79:	48 b8 84 48 80 00 00 	movabs $0x804884,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 10          	sub    $0x10,%rsp
  802b8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b93:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802b96:	48 ba b6 52 80 00 00 	movabs $0x8052b6,%rdx
  802b9d:	00 00 00 
  802ba0:	be 4c 00 00 00       	mov    $0x4c,%esi
  802ba5:	48 bf cb 52 80 00 00 	movabs $0x8052cb,%rdi
  802bac:	00 00 00 
  802baf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb4:	48 b9 2d 07 80 00 00 	movabs $0x80072d,%rcx
  802bbb:	00 00 00 
  802bbe:	ff d1                	callq  *%rcx

0000000000802bc0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 10          	sub    $0x10,%rsp
  802bc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd0:	8b 50 0c             	mov    0xc(%rax),%edx
  802bd3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802bda:	00 00 00 
  802bdd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bdf:	be 00 00 00 00       	mov    $0x0,%esi
  802be4:	bf 06 00 00 00       	mov    $0x6,%edi
  802be9:	48 b8 fe 2a 80 00 00 	movabs $0x802afe,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
}
  802bf5:	c9                   	leaveq 
  802bf6:	c3                   	retq   

0000000000802bf7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802bf7:	55                   	push   %rbp
  802bf8:	48 89 e5             	mov    %rsp,%rbp
  802bfb:	48 83 ec 20          	sub    $0x20,%rsp
  802bff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c07:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802c0b:	48 ba d6 52 80 00 00 	movabs $0x8052d6,%rdx
  802c12:	00 00 00 
  802c15:	be 6b 00 00 00       	mov    $0x6b,%esi
  802c1a:	48 bf cb 52 80 00 00 	movabs $0x8052cb,%rdi
  802c21:	00 00 00 
  802c24:	b8 00 00 00 00       	mov    $0x0,%eax
  802c29:	48 b9 2d 07 80 00 00 	movabs $0x80072d,%rcx
  802c30:	00 00 00 
  802c33:	ff d1                	callq  *%rcx

0000000000802c35 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c35:	55                   	push   %rbp
  802c36:	48 89 e5             	mov    %rsp,%rbp
  802c39:	48 83 ec 20          	sub    $0x20,%rsp
  802c3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c45:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802c49:	48 ba f3 52 80 00 00 	movabs $0x8052f3,%rdx
  802c50:	00 00 00 
  802c53:	be 7b 00 00 00       	mov    $0x7b,%esi
  802c58:	48 bf cb 52 80 00 00 	movabs $0x8052cb,%rdi
  802c5f:	00 00 00 
  802c62:	b8 00 00 00 00       	mov    $0x0,%eax
  802c67:	48 b9 2d 07 80 00 00 	movabs $0x80072d,%rcx
  802c6e:	00 00 00 
  802c71:	ff d1                	callq  *%rcx

0000000000802c73 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c73:	55                   	push   %rbp
  802c74:	48 89 e5             	mov    %rsp,%rbp
  802c77:	48 83 ec 20          	sub    $0x20,%rsp
  802c7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c87:	8b 50 0c             	mov    0xc(%rax),%edx
  802c8a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802c91:	00 00 00 
  802c94:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c96:	be 00 00 00 00       	mov    $0x0,%esi
  802c9b:	bf 05 00 00 00       	mov    $0x5,%edi
  802ca0:	48 b8 fe 2a 80 00 00 	movabs $0x802afe,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
  802cac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802caf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb3:	79 05                	jns    802cba <devfile_stat+0x47>
		return r;
  802cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb8:	eb 56                	jmp    802d10 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802cba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbe:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802cc5:	00 00 00 
  802cc8:	48 89 c7             	mov    %rax,%rdi
  802ccb:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802cd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cde:	00 00 00 
  802ce1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ce7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ceb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802cf1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cf8:	00 00 00 
  802cfb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d05:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d10:	c9                   	leaveq 
  802d11:	c3                   	retq   

0000000000802d12 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d12:	55                   	push   %rbp
  802d13:	48 89 e5             	mov    %rsp,%rbp
  802d16:	48 83 ec 10          	sub    $0x10,%rsp
  802d1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d1e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d25:	8b 50 0c             	mov    0xc(%rax),%edx
  802d28:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d2f:	00 00 00 
  802d32:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802d34:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d3b:	00 00 00 
  802d3e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802d41:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d44:	be 00 00 00 00       	mov    $0x0,%esi
  802d49:	bf 02 00 00 00       	mov    $0x2,%edi
  802d4e:	48 b8 fe 2a 80 00 00 	movabs $0x802afe,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
}
  802d5a:	c9                   	leaveq 
  802d5b:	c3                   	retq   

0000000000802d5c <remove>:

// Delete a file
int
remove(const char *path)
{
  802d5c:	55                   	push   %rbp
  802d5d:	48 89 e5             	mov    %rsp,%rbp
  802d60:	48 83 ec 10          	sub    $0x10,%rsp
  802d64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d6c:	48 89 c7             	mov    %rax,%rdi
  802d6f:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	callq  *%rax
  802d7b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d80:	7e 07                	jle    802d89 <remove+0x2d>
		return -E_BAD_PATH;
  802d82:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d87:	eb 33                	jmp    802dbc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8d:	48 89 c6             	mov    %rax,%rsi
  802d90:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802d97:	00 00 00 
  802d9a:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802da6:	be 00 00 00 00       	mov    $0x0,%esi
  802dab:	bf 07 00 00 00       	mov    $0x7,%edi
  802db0:	48 b8 fe 2a 80 00 00 	movabs $0x802afe,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
}
  802dbc:	c9                   	leaveq 
  802dbd:	c3                   	retq   

0000000000802dbe <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802dbe:	55                   	push   %rbp
  802dbf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802dc2:	be 00 00 00 00       	mov    $0x0,%esi
  802dc7:	bf 08 00 00 00       	mov    $0x8,%edi
  802dcc:	48 b8 fe 2a 80 00 00 	movabs $0x802afe,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
}
  802dd8:	5d                   	pop    %rbp
  802dd9:	c3                   	retq   

0000000000802dda <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802dda:	55                   	push   %rbp
  802ddb:	48 89 e5             	mov    %rsp,%rbp
  802dde:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802de5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802dec:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802df3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802dfa:	be 00 00 00 00       	mov    $0x0,%esi
  802dff:	48 89 c7             	mov    %rax,%rdi
  802e02:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e15:	79 28                	jns    802e3f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1a:	89 c6                	mov    %eax,%esi
  802e1c:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  802e23:	00 00 00 
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2b:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  802e32:	00 00 00 
  802e35:	ff d2                	callq  *%rdx
		return fd_src;
  802e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3a:	e9 74 01 00 00       	jmpq   802fb3 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802e3f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802e46:	be 01 01 00 00       	mov    $0x101,%esi
  802e4b:	48 89 c7             	mov    %rax,%rdi
  802e4e:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  802e55:	00 00 00 
  802e58:	ff d0                	callq  *%rax
  802e5a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e5d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e61:	79 39                	jns    802e9c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e66:	89 c6                	mov    %eax,%esi
  802e68:	48 bf 27 53 80 00 00 	movabs $0x805327,%rdi
  802e6f:	00 00 00 
  802e72:	b8 00 00 00 00       	mov    $0x0,%eax
  802e77:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  802e7e:	00 00 00 
  802e81:	ff d2                	callq  *%rdx
		close(fd_src);
  802e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e86:	89 c7                	mov    %eax,%edi
  802e88:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
		return fd_dest;
  802e94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e97:	e9 17 01 00 00       	jmpq   802fb3 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e9c:	eb 74                	jmp    802f12 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802e9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ea1:	48 63 d0             	movslq %eax,%rdx
  802ea4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802eab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eae:	48 89 ce             	mov    %rcx,%rsi
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
  802ebf:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ec2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802ec6:	79 4a                	jns    802f12 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802ec8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ecb:	89 c6                	mov    %eax,%esi
  802ecd:	48 bf 41 53 80 00 00 	movabs $0x805341,%rdi
  802ed4:	00 00 00 
  802ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  802edc:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  802ee3:	00 00 00 
  802ee6:	ff d2                	callq  *%rdx
			close(fd_src);
  802ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eeb:	89 c7                	mov    %eax,%edi
  802eed:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
			close(fd_dest);
  802ef9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802efc:	89 c7                	mov    %eax,%edi
  802efe:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
			return write_size;
  802f0a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f0d:	e9 a1 00 00 00       	jmpq   802fb3 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f12:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1c:	ba 00 02 00 00       	mov    $0x200,%edx
  802f21:	48 89 ce             	mov    %rcx,%rsi
  802f24:	89 c7                	mov    %eax,%edi
  802f26:	48 b8 af 26 80 00 00 	movabs $0x8026af,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f39:	0f 8f 5f ff ff ff    	jg     802e9e <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f43:	79 47                	jns    802f8c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802f45:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f48:	89 c6                	mov    %eax,%esi
  802f4a:	48 bf 54 53 80 00 00 	movabs $0x805354,%rdi
  802f51:	00 00 00 
  802f54:	b8 00 00 00 00       	mov    $0x0,%eax
  802f59:	48 ba 66 09 80 00 00 	movabs $0x800966,%rdx
  802f60:	00 00 00 
  802f63:	ff d2                	callq  *%rdx
		close(fd_src);
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f68:	89 c7                	mov    %eax,%edi
  802f6a:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802f71:	00 00 00 
  802f74:	ff d0                	callq  *%rax
		close(fd_dest);
  802f76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f79:	89 c7                	mov    %eax,%edi
  802f7b:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
		return read_size;
  802f87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f8a:	eb 27                	jmp    802fb3 <copy+0x1d9>
	}
	close(fd_src);
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	89 c7                	mov    %eax,%edi
  802f91:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
	close(fd_dest);
  802f9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa0:	89 c7                	mov    %eax,%edi
  802fa2:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
	return 0;
  802fae:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802fb3:	c9                   	leaveq 
  802fb4:	c3                   	retq   

0000000000802fb5 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802fb5:	55                   	push   %rbp
  802fb6:	48 89 e5             	mov    %rsp,%rbp
  802fb9:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802fc0:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802fc7:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802fce:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802fd5:	be 00 00 00 00       	mov    $0x0,%esi
  802fda:	48 89 c7             	mov    %rax,%rdi
  802fdd:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	callq  *%rax
  802fe9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fec:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ff0:	79 08                	jns    802ffa <spawn+0x45>
		return r;
  802ff2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ff5:	e9 12 03 00 00       	jmpq   80330c <spawn+0x357>
	fd = r;
  802ffa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ffd:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803000:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803007:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80300b:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803012:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803015:	ba 00 02 00 00       	mov    $0x200,%edx
  80301a:	48 89 ce             	mov    %rcx,%rsi
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
  80302b:	3d 00 02 00 00       	cmp    $0x200,%eax
  803030:	75 0d                	jne    80303f <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803032:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803036:	8b 00                	mov    (%rax),%eax
  803038:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80303d:	74 43                	je     803082 <spawn+0xcd>
		close(fd);
  80303f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803042:	89 c7                	mov    %eax,%edi
  803044:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803054:	8b 00                	mov    (%rax),%eax
  803056:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80305b:	89 c6                	mov    %eax,%esi
  80305d:	48 bf 70 53 80 00 00 	movabs $0x805370,%rdi
  803064:	00 00 00 
  803067:	b8 00 00 00 00       	mov    $0x0,%eax
  80306c:	48 b9 66 09 80 00 00 	movabs $0x800966,%rcx
  803073:	00 00 00 
  803076:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803078:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80307d:	e9 8a 02 00 00       	jmpq   80330c <spawn+0x357>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803082:	b8 07 00 00 00       	mov    $0x7,%eax
  803087:	cd 30                	int    $0x30
  803089:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80308c:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80308f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803092:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803096:	79 08                	jns    8030a0 <spawn+0xeb>
		return r;
  803098:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80309b:	e9 6c 02 00 00       	jmpq   80330c <spawn+0x357>
	child = r;
  8030a0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030a3:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8030a6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030a9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8030ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8030b5:	00 00 00 
  8030b8:	48 98                	cltq   
  8030ba:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8030c1:	48 01 c2             	add    %rax,%rdx
  8030c4:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8030cb:	48 89 d6             	mov    %rdx,%rsi
  8030ce:	ba 18 00 00 00       	mov    $0x18,%edx
  8030d3:	48 89 c7             	mov    %rax,%rdi
  8030d6:	48 89 d1             	mov    %rdx,%rcx
  8030d9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8030dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030e4:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8030eb:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8030f2:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8030f9:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803100:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803103:	48 89 ce             	mov    %rcx,%rsi
  803106:	89 c7                	mov    %eax,%edi
  803108:	48 b8 70 35 80 00 00 	movabs $0x803570,%rax
  80310f:	00 00 00 
  803112:	ff d0                	callq  *%rax
  803114:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803117:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80311b:	79 08                	jns    803125 <spawn+0x170>
		return r;
  80311d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803120:	e9 e7 01 00 00       	jmpq   80330c <spawn+0x357>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803125:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803129:	48 8b 40 20          	mov    0x20(%rax),%rax
  80312d:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803134:	48 01 d0             	add    %rdx,%rax
  803137:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80313b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803142:	e9 a9 00 00 00       	jmpq   8031f0 <spawn+0x23b>
		if (ph->p_type != ELF_PROG_LOAD)
  803147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80314b:	8b 00                	mov    (%rax),%eax
  80314d:	83 f8 01             	cmp    $0x1,%eax
  803150:	74 05                	je     803157 <spawn+0x1a2>
			continue;
  803152:	e9 90 00 00 00       	jmpq   8031e7 <spawn+0x232>
		perm = PTE_P | PTE_U;
  803157:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80315e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803162:	8b 40 04             	mov    0x4(%rax),%eax
  803165:	83 e0 02             	and    $0x2,%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 04                	je     803170 <spawn+0x1bb>
			perm |= PTE_W;
  80316c:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803174:	48 8b 40 08          	mov    0x8(%rax),%rax
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803178:	41 89 c1             	mov    %eax,%r9d
  80317b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317f:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803187:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80318b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318f:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803193:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803196:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803199:	48 83 ec 08          	sub    $0x8,%rsp
  80319d:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8031a0:	57                   	push   %rdi
  8031a1:	89 c7                	mov    %eax,%edi
  8031a3:	48 b8 1c 38 80 00 00 	movabs $0x80381c,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	48 83 c4 10          	add    $0x10,%rsp
  8031b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031ba:	79 2b                	jns    8031e7 <spawn+0x232>
			goto error;
  8031bc:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8031bd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8031c0:	89 c7                	mov    %eax,%edi
  8031c2:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
	close(fd);
  8031ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031d1:	89 c7                	mov    %eax,%edi
  8031d3:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
	return r;
  8031df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031e2:	e9 25 01 00 00       	jmpq   80330c <spawn+0x357>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8031e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8031eb:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8031f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f4:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8031f8:	0f b7 c0             	movzwl %ax,%eax
  8031fb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8031fe:	0f 8f 43 ff ff ff    	jg     803147 <spawn+0x192>
	close(fd);
  803204:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803207:	89 c7                	mov    %eax,%edi
  803209:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  803210:	00 00 00 
  803213:	ff d0                	callq  *%rax
	fd = -1;
  803215:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
	if ((r = copy_shared_pages(child)) < 0)
  80321c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80321f:	89 c7                	mov    %eax,%edi
  803221:	48 b8 08 3a 80 00 00 	movabs $0x803a08,%rax
  803228:	00 00 00 
  80322b:	ff d0                	callq  *%rax
  80322d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803230:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803234:	79 30                	jns    803266 <spawn+0x2b1>
		panic("copy_shared_pages: %e", r);
  803236:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803239:	89 c1                	mov    %eax,%ecx
  80323b:	48 ba 8a 53 80 00 00 	movabs $0x80538a,%rdx
  803242:	00 00 00 
  803245:	be 82 00 00 00       	mov    $0x82,%esi
  80324a:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  803251:	00 00 00 
  803254:	b8 00 00 00 00       	mov    $0x0,%eax
  803259:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  803260:	00 00 00 
  803263:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803266:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80326d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803270:	48 89 d6             	mov    %rdx,%rsi
  803273:	89 c7                	mov    %eax,%edi
  803275:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
  803281:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803284:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803288:	79 30                	jns    8032ba <spawn+0x305>
		panic("sys_env_set_trapframe: %e", r);
  80328a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80328d:	89 c1                	mov    %eax,%ecx
  80328f:	48 ba ac 53 80 00 00 	movabs $0x8053ac,%rdx
  803296:	00 00 00 
  803299:	be 85 00 00 00       	mov    $0x85,%esi
  80329e:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  8032a5:	00 00 00 
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  8032b4:	00 00 00 
  8032b7:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8032ba:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032bd:	be 02 00 00 00       	mov    $0x2,%esi
  8032c2:	89 c7                	mov    %eax,%edi
  8032c4:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
  8032d0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032d7:	79 30                	jns    803309 <spawn+0x354>
		panic("sys_env_set_status: %e", r);
  8032d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032dc:	89 c1                	mov    %eax,%ecx
  8032de:	48 ba c6 53 80 00 00 	movabs $0x8053c6,%rdx
  8032e5:	00 00 00 
  8032e8:	be 88 00 00 00       	mov    $0x88,%esi
  8032ed:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  8032f4:	00 00 00 
  8032f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fc:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  803303:	00 00 00 
  803306:	41 ff d0             	callq  *%r8
	return child;
  803309:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  80330c:	c9                   	leaveq 
  80330d:	c3                   	retq   

000000000080330e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80330e:	55                   	push   %rbp
  80330f:	48 89 e5             	mov    %rsp,%rbp
  803312:	41 55                	push   %r13
  803314:	41 54                	push   %r12
  803316:	53                   	push   %rbx
  803317:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80331e:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803325:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80332c:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803333:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80333a:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803341:	84 c0                	test   %al,%al
  803343:	74 26                	je     80336b <spawnl+0x5d>
  803345:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80334c:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803353:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803357:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80335b:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80335f:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803363:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803367:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  80336b:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803372:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803379:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80337c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803383:	00 00 00 
  803386:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80338d:	00 00 00 
  803390:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803394:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80339b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8033a2:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8033a9:	eb 07                	jmp    8033b2 <spawnl+0xa4>
		argc++;
  8033ab:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	while(va_arg(vl, void *) != NULL)
  8033b2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8033b8:	83 f8 30             	cmp    $0x30,%eax
  8033bb:	73 23                	jae    8033e0 <spawnl+0xd2>
  8033bd:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8033c4:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8033ca:	89 d2                	mov    %edx,%edx
  8033cc:	48 01 d0             	add    %rdx,%rax
  8033cf:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8033d5:	83 c2 08             	add    $0x8,%edx
  8033d8:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8033de:	eb 12                	jmp    8033f2 <spawnl+0xe4>
  8033e0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033e7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8033eb:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8033f2:	48 8b 00             	mov    (%rax),%rax
  8033f5:	48 85 c0             	test   %rax,%rax
  8033f8:	75 b1                	jne    8033ab <spawnl+0x9d>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8033fa:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803400:	83 c0 02             	add    $0x2,%eax
  803403:	48 89 e2             	mov    %rsp,%rdx
  803406:	48 89 d3             	mov    %rdx,%rbx
  803409:	48 63 d0             	movslq %eax,%rdx
  80340c:	48 83 ea 01          	sub    $0x1,%rdx
  803410:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803417:	48 63 d0             	movslq %eax,%rdx
  80341a:	49 89 d4             	mov    %rdx,%r12
  80341d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803423:	48 63 d0             	movslq %eax,%rdx
  803426:	49 89 d2             	mov    %rdx,%r10
  803429:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80342f:	48 98                	cltq   
  803431:	48 c1 e0 03          	shl    $0x3,%rax
  803435:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803439:	b8 10 00 00 00       	mov    $0x10,%eax
  80343e:	48 83 e8 01          	sub    $0x1,%rax
  803442:	48 01 d0             	add    %rdx,%rax
  803445:	be 10 00 00 00       	mov    $0x10,%esi
  80344a:	ba 00 00 00 00       	mov    $0x0,%edx
  80344f:	48 f7 f6             	div    %rsi
  803452:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803456:	48 29 c4             	sub    %rax,%rsp
  803459:	48 89 e0             	mov    %rsp,%rax
  80345c:	48 83 c0 07          	add    $0x7,%rax
  803460:	48 c1 e8 03          	shr    $0x3,%rax
  803464:	48 c1 e0 03          	shl    $0x3,%rax
  803468:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80346f:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803476:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80347d:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803480:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803486:	8d 50 01             	lea    0x1(%rax),%edx
  803489:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803490:	48 63 d2             	movslq %edx,%rdx
  803493:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80349a:	00 

	va_start(vl, arg0);
  80349b:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8034a2:	00 00 00 
  8034a5:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8034ac:	00 00 00 
  8034af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8034b3:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8034ba:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8034c1:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8034c8:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8034cf:	00 00 00 
  8034d2:	eb 60                	jmp    803534 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8034d4:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8034da:	8d 48 01             	lea    0x1(%rax),%ecx
  8034dd:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8034e3:	83 f8 30             	cmp    $0x30,%eax
  8034e6:	73 23                	jae    80350b <spawnl+0x1fd>
  8034e8:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8034ef:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8034f5:	89 d2                	mov    %edx,%edx
  8034f7:	48 01 d0             	add    %rdx,%rax
  8034fa:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803500:	83 c2 08             	add    $0x8,%edx
  803503:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803509:	eb 12                	jmp    80351d <spawnl+0x20f>
  80350b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803512:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803516:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80351d:	48 8b 10             	mov    (%rax),%rdx
  803520:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803527:	89 c9                	mov    %ecx,%ecx
  803529:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	for(i=0;i<argc;i++)
  80352d:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803534:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80353a:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803540:	77 92                	ja     8034d4 <spawnl+0x1c6>
	va_end(vl);
	return spawn(prog, argv);
  803542:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803549:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803550:	48 89 d6             	mov    %rdx,%rsi
  803553:	48 89 c7             	mov    %rax,%rdi
  803556:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  80355d:	00 00 00 
  803560:	ff d0                	callq  *%rax
  803562:	48 89 dc             	mov    %rbx,%rsp
}
  803565:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803569:	5b                   	pop    %rbx
  80356a:	41 5c                	pop    %r12
  80356c:	41 5d                	pop    %r13
  80356e:	5d                   	pop    %rbp
  80356f:	c3                   	retq   

0000000000803570 <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  803570:	55                   	push   %rbp
  803571:	48 89 e5             	mov    %rsp,%rbp
  803574:	48 83 ec 50          	sub    $0x50,%rsp
  803578:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80357b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80357f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803583:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80358a:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80358b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803592:	eb 33                	jmp    8035c7 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803594:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803597:	48 98                	cltq   
  803599:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035a0:	00 
  8035a1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8035a5:	48 01 d0             	add    %rdx,%rax
  8035a8:	48 8b 00             	mov    (%rax),%rax
  8035ab:	48 89 c7             	mov    %rax,%rdi
  8035ae:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
  8035ba:	83 c0 01             	add    $0x1,%eax
  8035bd:	48 98                	cltq   
  8035bf:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	for (argc = 0; argv[argc] != 0; argc++)
  8035c3:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8035c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035ca:	48 98                	cltq   
  8035cc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035d3:	00 
  8035d4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8035d8:	48 01 d0             	add    %rdx,%rax
  8035db:	48 8b 00             	mov    (%rax),%rax
  8035de:	48 85 c0             	test   %rax,%rax
  8035e1:	75 b1                	jne    803594 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8035e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e7:	48 f7 d8             	neg    %rax
  8035ea:	48 05 00 10 40 00    	add    $0x401000,%rax
  8035f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8035f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8035fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803600:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803604:	48 89 c2             	mov    %rax,%rdx
  803607:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80360a:	83 c0 01             	add    $0x1,%eax
  80360d:	c1 e0 03             	shl    $0x3,%eax
  803610:	48 98                	cltq   
  803612:	48 f7 d8             	neg    %rax
  803615:	48 01 d0             	add    %rdx,%rax
  803618:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80361c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803620:	48 83 e8 10          	sub    $0x10,%rax
  803624:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80362a:	77 0a                	ja     803636 <init_stack+0xc6>
		return -E_NO_MEM;
  80362c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803631:	e9 e4 01 00 00       	jmpq   80381a <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803636:	ba 07 00 00 00       	mov    $0x7,%edx
  80363b:	be 00 00 40 00       	mov    $0x400000,%esi
  803640:	bf 00 00 00 00       	mov    $0x0,%edi
  803645:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803654:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803658:	79 08                	jns    803662 <init_stack+0xf2>
		return r;
  80365a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80365d:	e9 b8 01 00 00       	jmpq   80381a <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803662:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803669:	e9 8a 00 00 00       	jmpq   8036f8 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  80366e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803671:	48 98                	cltq   
  803673:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80367a:	00 
  80367b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367f:	48 01 d0             	add    %rdx,%rax
  803682:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803687:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80368b:	48 01 ca             	add    %rcx,%rdx
  80368e:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803695:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803698:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80369b:	48 98                	cltq   
  80369d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8036a4:	00 
  8036a5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8036a9:	48 01 d0             	add    %rdx,%rax
  8036ac:	48 8b 10             	mov    (%rax),%rdx
  8036af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b3:	48 89 d6             	mov    %rdx,%rsi
  8036b6:	48 89 c7             	mov    %rax,%rdi
  8036b9:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  8036c0:	00 00 00 
  8036c3:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8036c5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036c8:	48 98                	cltq   
  8036ca:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8036d1:	00 
  8036d2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8036d6:	48 01 d0             	add    %rdx,%rax
  8036d9:	48 8b 00             	mov    (%rax),%rax
  8036dc:	48 89 c7             	mov    %rax,%rdi
  8036df:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  8036e6:	00 00 00 
  8036e9:	ff d0                	callq  *%rax
  8036eb:	83 c0 01             	add    $0x1,%eax
  8036ee:	48 98                	cltq   
  8036f0:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	for (i = 0; i < argc; i++) {
  8036f4:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8036f8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036fb:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8036fe:	0f 8c 6a ff ff ff    	jl     80366e <init_stack+0xfe>
	}
	argv_store[argc] = 0;
  803704:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803707:	48 98                	cltq   
  803709:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803710:	00 
  803711:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803715:	48 01 d0             	add    %rdx,%rax
  803718:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80371f:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803726:	00 
  803727:	74 35                	je     80375e <init_stack+0x1ee>
  803729:	48 b9 e0 53 80 00 00 	movabs $0x8053e0,%rcx
  803730:	00 00 00 
  803733:	48 ba 06 54 80 00 00 	movabs $0x805406,%rdx
  80373a:	00 00 00 
  80373d:	be f1 00 00 00       	mov    $0xf1,%esi
  803742:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  803749:	00 00 00 
  80374c:	b8 00 00 00 00       	mov    $0x0,%eax
  803751:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  803758:	00 00 00 
  80375b:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80375e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803762:	48 83 e8 08          	sub    $0x8,%rax
  803766:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80376b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80376f:	48 01 ca             	add    %rcx,%rdx
  803772:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803779:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  80377c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803780:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803784:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803787:	48 98                	cltq   
  803789:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  80378c:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803791:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803795:	48 01 d0             	add    %rdx,%rax
  803798:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80379e:	48 89 c2             	mov    %rax,%rdx
  8037a1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8037a5:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8037a8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8037ab:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8037b1:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8037b6:	89 c2                	mov    %eax,%edx
  8037b8:	be 00 00 40 00       	mov    $0x400000,%esi
  8037bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c2:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
  8037ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037d5:	79 02                	jns    8037d9 <init_stack+0x269>
		goto error;
  8037d7:	eb 28                	jmp    803801 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8037d9:	be 00 00 40 00       	mov    $0x400000,%esi
  8037de:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e3:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8037ea:	00 00 00 
  8037ed:	ff d0                	callq  *%rax
  8037ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037f6:	79 02                	jns    8037fa <init_stack+0x28a>
		goto error;
  8037f8:	eb 07                	jmp    803801 <init_stack+0x291>

	return 0;
  8037fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ff:	eb 19                	jmp    80381a <init_stack+0x2aa>

error:
	sys_page_unmap(0, UTEMP);
  803801:	be 00 00 40 00       	mov    $0x400000,%esi
  803806:	bf 00 00 00 00       	mov    $0x0,%edi
  80380b:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
	return r;
  803817:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80381a:	c9                   	leaveq 
  80381b:	c3                   	retq   

000000000080381c <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80381c:	55                   	push   %rbp
  80381d:	48 89 e5             	mov    %rsp,%rbp
  803820:	48 83 ec 50          	sub    $0x50,%rsp
  803824:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803827:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80382b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80382f:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803832:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803836:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80383a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80383e:	25 ff 0f 00 00       	and    $0xfff,%eax
  803843:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384a:	74 21                	je     80386d <map_segment+0x51>
		va -= i;
  80384c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384f:	48 98                	cltq   
  803851:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803858:	48 98                	cltq   
  80385a:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80385e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803861:	48 98                	cltq   
  803863:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386a:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80386d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803874:	e9 79 01 00 00       	jmpq   8039f2 <map_segment+0x1d6>
		if (i >= filesz) {
  803879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387c:	48 98                	cltq   
  80387e:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803882:	72 3c                	jb     8038c0 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803887:	48 63 d0             	movslq %eax,%rdx
  80388a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80388e:	48 01 d0             	add    %rdx,%rax
  803891:	48 89 c1             	mov    %rax,%rcx
  803894:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803897:	8b 55 10             	mov    0x10(%rbp),%edx
  80389a:	48 89 ce             	mov    %rcx,%rsi
  80389d:	89 c7                	mov    %eax,%edi
  80389f:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
  8038ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8038ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038b2:	0f 89 33 01 00 00    	jns    8039eb <map_segment+0x1cf>
				return r;
  8038b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038bb:	e9 46 01 00 00       	jmpq   803a06 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8038c0:	ba 07 00 00 00       	mov    $0x7,%edx
  8038c5:	be 00 00 40 00       	mov    $0x400000,%esi
  8038ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8038cf:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8038de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038e2:	79 08                	jns    8038ec <map_segment+0xd0>
				return r;
  8038e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038e7:	e9 1a 01 00 00       	jmpq   803a06 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8038ec:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8038ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f2:	01 c2                	add    %eax,%edx
  8038f4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8038f7:	89 d6                	mov    %edx,%esi
  8038f9:	89 c7                	mov    %eax,%edi
  8038fb:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  803902:	00 00 00 
  803905:	ff d0                	callq  *%rax
  803907:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80390a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80390e:	79 08                	jns    803918 <map_segment+0xfc>
				return r;
  803910:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803913:	e9 ee 00 00 00       	jmpq   803a06 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803918:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80391f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803922:	48 98                	cltq   
  803924:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803928:	48 29 c2             	sub    %rax,%rdx
  80392b:	48 89 d0             	mov    %rdx,%rax
  80392e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803932:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803935:	48 63 d0             	movslq %eax,%rdx
  803938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80393c:	48 39 c2             	cmp    %rax,%rdx
  80393f:	48 0f 47 d0          	cmova  %rax,%rdx
  803943:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803946:	be 00 00 40 00       	mov    $0x400000,%esi
  80394b:	89 c7                	mov    %eax,%edi
  80394d:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  803954:	00 00 00 
  803957:	ff d0                	callq  *%rax
  803959:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80395c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803960:	79 08                	jns    80396a <map_segment+0x14e>
				return r;
  803962:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803965:	e9 9c 00 00 00       	jmpq   803a06 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80396a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396d:	48 63 d0             	movslq %eax,%rdx
  803970:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803974:	48 01 d0             	add    %rdx,%rax
  803977:	48 89 c2             	mov    %rax,%rdx
  80397a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80397d:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803981:	48 89 d1             	mov    %rdx,%rcx
  803984:	89 c2                	mov    %eax,%edx
  803986:	be 00 00 40 00       	mov    $0x400000,%esi
  80398b:	bf 00 00 00 00       	mov    $0x0,%edi
  803990:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  803997:	00 00 00 
  80399a:	ff d0                	callq  *%rax
  80399c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80399f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8039a3:	79 30                	jns    8039d5 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8039a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039a8:	89 c1                	mov    %eax,%ecx
  8039aa:	48 ba 1b 54 80 00 00 	movabs $0x80541b,%rdx
  8039b1:	00 00 00 
  8039b4:	be 24 01 00 00       	mov    $0x124,%esi
  8039b9:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  8039c0:	00 00 00 
  8039c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c8:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  8039cf:	00 00 00 
  8039d2:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8039d5:	be 00 00 40 00       	mov    $0x400000,%esi
  8039da:	bf 00 00 00 00       	mov    $0x0,%edi
  8039df:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8039e6:	00 00 00 
  8039e9:	ff d0                	callq  *%rax
	for (i = 0; i < memsz; i += PGSIZE) {
  8039eb:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8039f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f5:	48 98                	cltq   
  8039f7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039fb:	0f 82 78 fe ff ff    	jb     803879 <map_segment+0x5d>
		}
	}
	return 0;
  803a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a06:	c9                   	leaveq 
  803a07:	c3                   	retq   

0000000000803a08 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803a08:	55                   	push   %rbp
  803a09:	48 89 e5             	mov    %rsp,%rbp
  803a0c:	48 83 ec 08          	sub    $0x8,%rsp
  803a10:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  803a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a18:	c9                   	leaveq 
  803a19:	c3                   	retq   

0000000000803a1a <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803a1a:	55                   	push   %rbp
  803a1b:	48 89 e5             	mov    %rsp,%rbp
  803a1e:	48 83 ec 20          	sub    $0x20,%rsp
  803a22:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803a25:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a2c:	48 89 d6             	mov    %rdx,%rsi
  803a2f:	89 c7                	mov    %eax,%edi
  803a31:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  803a38:	00 00 00 
  803a3b:	ff d0                	callq  *%rax
  803a3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a44:	79 05                	jns    803a4b <fd2sockid+0x31>
		return r;
  803a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a49:	eb 24                	jmp    803a6f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4f:	8b 10                	mov    (%rax),%edx
  803a51:	48 b8 40 88 80 00 00 	movabs $0x808840,%rax
  803a58:	00 00 00 
  803a5b:	8b 00                	mov    (%rax),%eax
  803a5d:	39 c2                	cmp    %eax,%edx
  803a5f:	74 07                	je     803a68 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803a61:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803a66:	eb 07                	jmp    803a6f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a6c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803a6f:	c9                   	leaveq 
  803a70:	c3                   	retq   

0000000000803a71 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803a71:	55                   	push   %rbp
  803a72:	48 89 e5             	mov    %rsp,%rbp
  803a75:	48 83 ec 20          	sub    $0x20,%rsp
  803a79:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803a7c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a80:	48 89 c7             	mov    %rax,%rdi
  803a83:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
  803a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a96:	78 26                	js     803abe <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9c:	ba 07 04 00 00       	mov    $0x407,%edx
  803aa1:	48 89 c6             	mov    %rax,%rsi
  803aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa9:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
  803ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abc:	79 16                	jns    803ad4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803abe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac1:	89 c7                	mov    %eax,%edi
  803ac3:	48 b8 80 3f 80 00 00 	movabs $0x803f80,%rax
  803aca:	00 00 00 
  803acd:	ff d0                	callq  *%rax
		return r;
  803acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad2:	eb 3a                	jmp    803b0e <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803ad4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad8:	48 ba 40 88 80 00 00 	movabs $0x808840,%rdx
  803adf:	00 00 00 
  803ae2:	8b 12                	mov    (%rdx),%edx
  803ae4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aea:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803af8:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aff:	48 89 c7             	mov    %rax,%rdi
  803b02:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
}
  803b0e:	c9                   	leaveq 
  803b0f:	c3                   	retq   

0000000000803b10 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b10:	55                   	push   %rbp
  803b11:	48 89 e5             	mov    %rsp,%rbp
  803b14:	48 83 ec 30          	sub    $0x30,%rsp
  803b18:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b26:	89 c7                	mov    %eax,%edi
  803b28:	48 b8 1a 3a 80 00 00 	movabs $0x803a1a,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3b:	79 05                	jns    803b42 <accept+0x32>
		return r;
  803b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b40:	eb 3b                	jmp    803b7d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803b42:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b46:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4d:	48 89 ce             	mov    %rcx,%rsi
  803b50:	89 c7                	mov    %eax,%edi
  803b52:	48 b8 5d 3e 80 00 00 	movabs $0x803e5d,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
  803b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b65:	79 05                	jns    803b6c <accept+0x5c>
		return r;
  803b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6a:	eb 11                	jmp    803b7d <accept+0x6d>
	return alloc_sockfd(r);
  803b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6f:	89 c7                	mov    %eax,%edi
  803b71:	48 b8 71 3a 80 00 00 	movabs $0x803a71,%rax
  803b78:	00 00 00 
  803b7b:	ff d0                	callq  *%rax
}
  803b7d:	c9                   	leaveq 
  803b7e:	c3                   	retq   

0000000000803b7f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b7f:	55                   	push   %rbp
  803b80:	48 89 e5             	mov    %rsp,%rbp
  803b83:	48 83 ec 20          	sub    $0x20,%rsp
  803b87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b8e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b94:	89 c7                	mov    %eax,%edi
  803b96:	48 b8 1a 3a 80 00 00 	movabs $0x803a1a,%rax
  803b9d:	00 00 00 
  803ba0:	ff d0                	callq  *%rax
  803ba2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba9:	79 05                	jns    803bb0 <bind+0x31>
		return r;
  803bab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bae:	eb 1b                	jmp    803bcb <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803bb0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bb3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bba:	48 89 ce             	mov    %rcx,%rsi
  803bbd:	89 c7                	mov    %eax,%edi
  803bbf:	48 b8 dc 3e 80 00 00 	movabs $0x803edc,%rax
  803bc6:	00 00 00 
  803bc9:	ff d0                	callq  *%rax
}
  803bcb:	c9                   	leaveq 
  803bcc:	c3                   	retq   

0000000000803bcd <shutdown>:

int
shutdown(int s, int how)
{
  803bcd:	55                   	push   %rbp
  803bce:	48 89 e5             	mov    %rsp,%rbp
  803bd1:	48 83 ec 20          	sub    $0x20,%rsp
  803bd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bd8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bdb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bde:	89 c7                	mov    %eax,%edi
  803be0:	48 b8 1a 3a 80 00 00 	movabs $0x803a1a,%rax
  803be7:	00 00 00 
  803bea:	ff d0                	callq  *%rax
  803bec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf3:	79 05                	jns    803bfa <shutdown+0x2d>
		return r;
  803bf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf8:	eb 16                	jmp    803c10 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803bfa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c00:	89 d6                	mov    %edx,%esi
  803c02:	89 c7                	mov    %eax,%edi
  803c04:	48 b8 40 3f 80 00 00 	movabs $0x803f40,%rax
  803c0b:	00 00 00 
  803c0e:	ff d0                	callq  *%rax
}
  803c10:	c9                   	leaveq 
  803c11:	c3                   	retq   

0000000000803c12 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803c12:	55                   	push   %rbp
  803c13:	48 89 e5             	mov    %rsp,%rbp
  803c16:	48 83 ec 10          	sub    $0x10,%rsp
  803c1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c22:	48 89 c7             	mov    %rax,%rdi
  803c25:	48 b8 c1 4a 80 00 00 	movabs $0x804ac1,%rax
  803c2c:	00 00 00 
  803c2f:	ff d0                	callq  *%rax
  803c31:	83 f8 01             	cmp    $0x1,%eax
  803c34:	75 17                	jne    803c4d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803c36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3a:	8b 40 0c             	mov    0xc(%rax),%eax
  803c3d:	89 c7                	mov    %eax,%edi
  803c3f:	48 b8 80 3f 80 00 00 	movabs $0x803f80,%rax
  803c46:	00 00 00 
  803c49:	ff d0                	callq  *%rax
  803c4b:	eb 05                	jmp    803c52 <devsock_close+0x40>
	else
		return 0;
  803c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c52:	c9                   	leaveq 
  803c53:	c3                   	retq   

0000000000803c54 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c54:	55                   	push   %rbp
  803c55:	48 89 e5             	mov    %rsp,%rbp
  803c58:	48 83 ec 20          	sub    $0x20,%rsp
  803c5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c63:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c69:	89 c7                	mov    %eax,%edi
  803c6b:	48 b8 1a 3a 80 00 00 	movabs $0x803a1a,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7e:	79 05                	jns    803c85 <connect+0x31>
		return r;
  803c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c83:	eb 1b                	jmp    803ca0 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803c85:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c88:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8f:	48 89 ce             	mov    %rcx,%rsi
  803c92:	89 c7                	mov    %eax,%edi
  803c94:	48 b8 ad 3f 80 00 00 	movabs $0x803fad,%rax
  803c9b:	00 00 00 
  803c9e:	ff d0                	callq  *%rax
}
  803ca0:	c9                   	leaveq 
  803ca1:	c3                   	retq   

0000000000803ca2 <listen>:

int
listen(int s, int backlog)
{
  803ca2:	55                   	push   %rbp
  803ca3:	48 89 e5             	mov    %rsp,%rbp
  803ca6:	48 83 ec 20          	sub    $0x20,%rsp
  803caa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb3:	89 c7                	mov    %eax,%edi
  803cb5:	48 b8 1a 3a 80 00 00 	movabs $0x803a1a,%rax
  803cbc:	00 00 00 
  803cbf:	ff d0                	callq  *%rax
  803cc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc8:	79 05                	jns    803ccf <listen+0x2d>
		return r;
  803cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccd:	eb 16                	jmp    803ce5 <listen+0x43>
	return nsipc_listen(r, backlog);
  803ccf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd5:	89 d6                	mov    %edx,%esi
  803cd7:	89 c7                	mov    %eax,%edi
  803cd9:	48 b8 11 40 80 00 00 	movabs $0x804011,%rax
  803ce0:	00 00 00 
  803ce3:	ff d0                	callq  *%rax
}
  803ce5:	c9                   	leaveq 
  803ce6:	c3                   	retq   

0000000000803ce7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803ce7:	55                   	push   %rbp
  803ce8:	48 89 e5             	mov    %rsp,%rbp
  803ceb:	48 83 ec 20          	sub    $0x20,%rsp
  803cef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cf7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cff:	89 c2                	mov    %eax,%edx
  803d01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d05:	8b 40 0c             	mov    0xc(%rax),%eax
  803d08:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d11:	89 c7                	mov    %eax,%edi
  803d13:	48 b8 51 40 80 00 00 	movabs $0x804051,%rax
  803d1a:	00 00 00 
  803d1d:	ff d0                	callq  *%rax
}
  803d1f:	c9                   	leaveq 
  803d20:	c3                   	retq   

0000000000803d21 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803d21:	55                   	push   %rbp
  803d22:	48 89 e5             	mov    %rsp,%rbp
  803d25:	48 83 ec 20          	sub    $0x20,%rsp
  803d29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d31:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803d35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d39:	89 c2                	mov    %eax,%edx
  803d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3f:	8b 40 0c             	mov    0xc(%rax),%eax
  803d42:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d46:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d4b:	89 c7                	mov    %eax,%edi
  803d4d:	48 b8 1d 41 80 00 00 	movabs $0x80411d,%rax
  803d54:	00 00 00 
  803d57:	ff d0                	callq  *%rax
}
  803d59:	c9                   	leaveq 
  803d5a:	c3                   	retq   

0000000000803d5b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803d5b:	55                   	push   %rbp
  803d5c:	48 89 e5             	mov    %rsp,%rbp
  803d5f:	48 83 ec 10          	sub    $0x10,%rsp
  803d63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6f:	48 be 3d 54 80 00 00 	movabs $0x80543d,%rsi
  803d76:	00 00 00 
  803d79:	48 89 c7             	mov    %rax,%rdi
  803d7c:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  803d83:	00 00 00 
  803d86:	ff d0                	callq  *%rax
	return 0;
  803d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d8d:	c9                   	leaveq 
  803d8e:	c3                   	retq   

0000000000803d8f <socket>:

int
socket(int domain, int type, int protocol)
{
  803d8f:	55                   	push   %rbp
  803d90:	48 89 e5             	mov    %rsp,%rbp
  803d93:	48 83 ec 20          	sub    $0x20,%rsp
  803d97:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d9a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d9d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803da0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803da3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803da6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803da9:	89 ce                	mov    %ecx,%esi
  803dab:	89 c7                	mov    %eax,%edi
  803dad:	48 b8 d5 41 80 00 00 	movabs $0x8041d5,%rax
  803db4:	00 00 00 
  803db7:	ff d0                	callq  *%rax
  803db9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc0:	79 05                	jns    803dc7 <socket+0x38>
		return r;
  803dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc5:	eb 11                	jmp    803dd8 <socket+0x49>
	return alloc_sockfd(r);
  803dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dca:	89 c7                	mov    %eax,%edi
  803dcc:	48 b8 71 3a 80 00 00 	movabs $0x803a71,%rax
  803dd3:	00 00 00 
  803dd6:	ff d0                	callq  *%rax
}
  803dd8:	c9                   	leaveq 
  803dd9:	c3                   	retq   

0000000000803dda <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803dda:	55                   	push   %rbp
  803ddb:	48 89 e5             	mov    %rsp,%rbp
  803dde:	48 83 ec 10          	sub    $0x10,%rsp
  803de2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803de5:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803dec:	00 00 00 
  803def:	8b 00                	mov    (%rax),%eax
  803df1:	85 c0                	test   %eax,%eax
  803df3:	75 1f                	jne    803e14 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803df5:	bf 02 00 00 00       	mov    $0x2,%edi
  803dfa:	48 b8 4f 4a 80 00 00 	movabs $0x804a4f,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
  803e06:	89 c2                	mov    %eax,%edx
  803e08:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803e0f:	00 00 00 
  803e12:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803e14:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803e1b:	00 00 00 
  803e1e:	8b 00                	mov    (%rax),%eax
  803e20:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803e23:	b9 07 00 00 00       	mov    $0x7,%ecx
  803e28:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  803e2f:	00 00 00 
  803e32:	89 c7                	mov    %eax,%edi
  803e34:	48 b8 c2 48 80 00 00 	movabs $0x8048c2,%rax
  803e3b:	00 00 00 
  803e3e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803e40:	ba 00 00 00 00       	mov    $0x0,%edx
  803e45:	be 00 00 00 00       	mov    $0x0,%esi
  803e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4f:	48 b8 84 48 80 00 00 	movabs $0x804884,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
}
  803e5b:	c9                   	leaveq 
  803e5c:	c3                   	retq   

0000000000803e5d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803e5d:	55                   	push   %rbp
  803e5e:	48 89 e5             	mov    %rsp,%rbp
  803e61:	48 83 ec 30          	sub    $0x30,%rsp
  803e65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e6c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803e70:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803e77:	00 00 00 
  803e7a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e7d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803e7f:	bf 01 00 00 00       	mov    $0x1,%edi
  803e84:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  803e8b:	00 00 00 
  803e8e:	ff d0                	callq  *%rax
  803e90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e97:	78 3e                	js     803ed7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803e99:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803ea0:	00 00 00 
  803ea3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eab:	8b 40 10             	mov    0x10(%rax),%eax
  803eae:	89 c2                	mov    %eax,%edx
  803eb0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803eb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb8:	48 89 ce             	mov    %rcx,%rsi
  803ebb:	48 89 c7             	mov    %rax,%rdi
  803ebe:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  803ec5:	00 00 00 
  803ec8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ece:	8b 50 10             	mov    0x10(%rax),%edx
  803ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803eda:	c9                   	leaveq 
  803edb:	c3                   	retq   

0000000000803edc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803edc:	55                   	push   %rbp
  803edd:	48 89 e5             	mov    %rsp,%rbp
  803ee0:	48 83 ec 10          	sub    $0x10,%rsp
  803ee4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ee7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803eeb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803eee:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803ef5:	00 00 00 
  803ef8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803efb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803efd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f04:	48 89 c6             	mov    %rax,%rsi
  803f07:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  803f0e:	00 00 00 
  803f11:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  803f18:	00 00 00 
  803f1b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803f1d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f24:	00 00 00 
  803f27:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f2a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803f2d:	bf 02 00 00 00       	mov    $0x2,%edi
  803f32:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  803f39:	00 00 00 
  803f3c:	ff d0                	callq  *%rax
}
  803f3e:	c9                   	leaveq 
  803f3f:	c3                   	retq   

0000000000803f40 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803f40:	55                   	push   %rbp
  803f41:	48 89 e5             	mov    %rsp,%rbp
  803f44:	48 83 ec 10          	sub    $0x10,%rsp
  803f48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f4b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803f4e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f55:	00 00 00 
  803f58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f5b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803f5d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f64:	00 00 00 
  803f67:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f6a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803f6d:	bf 03 00 00 00       	mov    $0x3,%edi
  803f72:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  803f79:	00 00 00 
  803f7c:	ff d0                	callq  *%rax
}
  803f7e:	c9                   	leaveq 
  803f7f:	c3                   	retq   

0000000000803f80 <nsipc_close>:

int
nsipc_close(int s)
{
  803f80:	55                   	push   %rbp
  803f81:	48 89 e5             	mov    %rsp,%rbp
  803f84:	48 83 ec 10          	sub    $0x10,%rsp
  803f88:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803f8b:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f92:	00 00 00 
  803f95:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f98:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803f9a:	bf 04 00 00 00       	mov    $0x4,%edi
  803f9f:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
}
  803fab:	c9                   	leaveq 
  803fac:	c3                   	retq   

0000000000803fad <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fad:	55                   	push   %rbp
  803fae:	48 89 e5             	mov    %rsp,%rbp
  803fb1:	48 83 ec 10          	sub    $0x10,%rsp
  803fb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fbc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803fbf:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803fc6:	00 00 00 
  803fc9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fcc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803fce:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd5:	48 89 c6             	mov    %rax,%rsi
  803fd8:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  803fdf:	00 00 00 
  803fe2:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  803fe9:	00 00 00 
  803fec:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803fee:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803ff5:	00 00 00 
  803ff8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ffb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803ffe:	bf 05 00 00 00       	mov    $0x5,%edi
  804003:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  80400a:	00 00 00 
  80400d:	ff d0                	callq  *%rax
}
  80400f:	c9                   	leaveq 
  804010:	c3                   	retq   

0000000000804011 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804011:	55                   	push   %rbp
  804012:	48 89 e5             	mov    %rsp,%rbp
  804015:	48 83 ec 10          	sub    $0x10,%rsp
  804019:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80401c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80401f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804026:	00 00 00 
  804029:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80402c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80402e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804035:	00 00 00 
  804038:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80403b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80403e:	bf 06 00 00 00       	mov    $0x6,%edi
  804043:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  80404a:	00 00 00 
  80404d:	ff d0                	callq  *%rax
}
  80404f:	c9                   	leaveq 
  804050:	c3                   	retq   

0000000000804051 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804051:	55                   	push   %rbp
  804052:	48 89 e5             	mov    %rsp,%rbp
  804055:	48 83 ec 30          	sub    $0x30,%rsp
  804059:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80405c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804060:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804063:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804066:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80406d:	00 00 00 
  804070:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804073:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804075:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80407c:	00 00 00 
  80407f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804082:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804085:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80408c:	00 00 00 
  80408f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804092:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804095:	bf 07 00 00 00       	mov    $0x7,%edi
  80409a:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  8040a1:	00 00 00 
  8040a4:	ff d0                	callq  *%rax
  8040a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ad:	78 69                	js     804118 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8040af:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8040b6:	7f 08                	jg     8040c0 <nsipc_recv+0x6f>
  8040b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8040be:	7e 35                	jle    8040f5 <nsipc_recv+0xa4>
  8040c0:	48 b9 44 54 80 00 00 	movabs $0x805444,%rcx
  8040c7:	00 00 00 
  8040ca:	48 ba 59 54 80 00 00 	movabs $0x805459,%rdx
  8040d1:	00 00 00 
  8040d4:	be 61 00 00 00       	mov    $0x61,%esi
  8040d9:	48 bf 6e 54 80 00 00 	movabs $0x80546e,%rdi
  8040e0:	00 00 00 
  8040e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e8:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  8040ef:	00 00 00 
  8040f2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8040f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f8:	48 63 d0             	movslq %eax,%rdx
  8040fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ff:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  804106:	00 00 00 
  804109:	48 89 c7             	mov    %rax,%rdi
  80410c:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  804113:	00 00 00 
  804116:	ff d0                	callq  *%rax
	}

	return r;
  804118:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80411b:	c9                   	leaveq 
  80411c:	c3                   	retq   

000000000080411d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80411d:	55                   	push   %rbp
  80411e:	48 89 e5             	mov    %rsp,%rbp
  804121:	48 83 ec 20          	sub    $0x20,%rsp
  804125:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804128:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80412c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80412f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804132:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804139:	00 00 00 
  80413c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80413f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804141:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804148:	7e 35                	jle    80417f <nsipc_send+0x62>
  80414a:	48 b9 7a 54 80 00 00 	movabs $0x80547a,%rcx
  804151:	00 00 00 
  804154:	48 ba 59 54 80 00 00 	movabs $0x805459,%rdx
  80415b:	00 00 00 
  80415e:	be 6c 00 00 00       	mov    $0x6c,%esi
  804163:	48 bf 6e 54 80 00 00 	movabs $0x80546e,%rdi
  80416a:	00 00 00 
  80416d:	b8 00 00 00 00       	mov    $0x0,%eax
  804172:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  804179:	00 00 00 
  80417c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80417f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804182:	48 63 d0             	movslq %eax,%rdx
  804185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804189:	48 89 c6             	mov    %rax,%rsi
  80418c:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  804193:	00 00 00 
  804196:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  80419d:	00 00 00 
  8041a0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8041a2:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041a9:	00 00 00 
  8041ac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041af:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8041b2:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041b9:	00 00 00 
  8041bc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8041bf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8041c2:	bf 08 00 00 00       	mov    $0x8,%edi
  8041c7:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  8041ce:	00 00 00 
  8041d1:	ff d0                	callq  *%rax
}
  8041d3:	c9                   	leaveq 
  8041d4:	c3                   	retq   

00000000008041d5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8041d5:	55                   	push   %rbp
  8041d6:	48 89 e5             	mov    %rsp,%rbp
  8041d9:	48 83 ec 10          	sub    $0x10,%rsp
  8041dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041e0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8041e3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8041e6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041ed:	00 00 00 
  8041f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8041f5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041fc:	00 00 00 
  8041ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804202:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804205:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80420c:	00 00 00 
  80420f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804212:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804215:	bf 09 00 00 00       	mov    $0x9,%edi
  80421a:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  804221:	00 00 00 
  804224:	ff d0                	callq  *%rax
}
  804226:	c9                   	leaveq 
  804227:	c3                   	retq   

0000000000804228 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804228:	55                   	push   %rbp
  804229:	48 89 e5             	mov    %rsp,%rbp
  80422c:	53                   	push   %rbx
  80422d:	48 83 ec 38          	sub    $0x38,%rsp
  804231:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804235:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804239:	48 89 c7             	mov    %rax,%rdi
  80423c:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  804243:	00 00 00 
  804246:	ff d0                	callq  *%rax
  804248:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80424b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80424f:	0f 88 bf 01 00 00    	js     804414 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804255:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804259:	ba 07 04 00 00       	mov    $0x407,%edx
  80425e:	48 89 c6             	mov    %rax,%rsi
  804261:	bf 00 00 00 00       	mov    $0x0,%edi
  804266:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  80426d:	00 00 00 
  804270:	ff d0                	callq  *%rax
  804272:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804275:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804279:	0f 88 95 01 00 00    	js     804414 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80427f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804283:	48 89 c7             	mov    %rax,%rdi
  804286:	48 b8 e3 21 80 00 00 	movabs $0x8021e3,%rax
  80428d:	00 00 00 
  804290:	ff d0                	callq  *%rax
  804292:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804295:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804299:	0f 88 5d 01 00 00    	js     8043fc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80429f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042a3:	ba 07 04 00 00       	mov    $0x407,%edx
  8042a8:	48 89 c6             	mov    %rax,%rsi
  8042ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8042b0:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  8042b7:	00 00 00 
  8042ba:	ff d0                	callq  *%rax
  8042bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042c3:	0f 88 33 01 00 00    	js     8043fc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8042c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042cd:	48 89 c7             	mov    %rax,%rdi
  8042d0:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  8042d7:	00 00 00 
  8042da:	ff d0                	callq  *%rax
  8042dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042e4:	ba 07 04 00 00       	mov    $0x407,%edx
  8042e9:	48 89 c6             	mov    %rax,%rsi
  8042ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f1:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  8042f8:	00 00 00 
  8042fb:	ff d0                	callq  *%rax
  8042fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804300:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804304:	79 05                	jns    80430b <pipe+0xe3>
		goto err2;
  804306:	e9 d9 00 00 00       	jmpq   8043e4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80430b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80430f:	48 89 c7             	mov    %rax,%rdi
  804312:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
  80431e:	48 89 c2             	mov    %rax,%rdx
  804321:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804325:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80432b:	48 89 d1             	mov    %rdx,%rcx
  80432e:	ba 00 00 00 00       	mov    $0x0,%edx
  804333:	48 89 c6             	mov    %rax,%rsi
  804336:	bf 00 00 00 00       	mov    $0x0,%edi
  80433b:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  804342:	00 00 00 
  804345:	ff d0                	callq  *%rax
  804347:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80434a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80434e:	79 1b                	jns    80436b <pipe+0x143>
		goto err3;
  804350:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804351:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804355:	48 89 c6             	mov    %rax,%rsi
  804358:	bf 00 00 00 00       	mov    $0x0,%edi
  80435d:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  804364:	00 00 00 
  804367:	ff d0                	callq  *%rax
  804369:	eb 79                	jmp    8043e4 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  80436b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80436f:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  804376:	00 00 00 
  804379:	8b 12                	mov    (%rdx),%edx
  80437b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80437d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804381:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  804388:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80438c:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  804393:	00 00 00 
  804396:	8b 12                	mov    (%rdx),%edx
  804398:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80439a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80439e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  8043a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a9:	48 89 c7             	mov    %rax,%rdi
  8043ac:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  8043b3:	00 00 00 
  8043b6:	ff d0                	callq  *%rax
  8043b8:	89 c2                	mov    %eax,%edx
  8043ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043be:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8043c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043c4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8043c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043cc:	48 89 c7             	mov    %rax,%rdi
  8043cf:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
  8043db:	89 03                	mov    %eax,(%rbx)
	return 0;
  8043dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e2:	eb 33                	jmp    804417 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8043e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043e8:	48 89 c6             	mov    %rax,%rsi
  8043eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8043f0:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8043f7:	00 00 00 
  8043fa:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8043fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804400:	48 89 c6             	mov    %rax,%rsi
  804403:	bf 00 00 00 00       	mov    $0x0,%edi
  804408:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  80440f:	00 00 00 
  804412:	ff d0                	callq  *%rax
err:
	return r;
  804414:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804417:	48 83 c4 38          	add    $0x38,%rsp
  80441b:	5b                   	pop    %rbx
  80441c:	5d                   	pop    %rbp
  80441d:	c3                   	retq   

000000000080441e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80441e:	55                   	push   %rbp
  80441f:	48 89 e5             	mov    %rsp,%rbp
  804422:	53                   	push   %rbx
  804423:	48 83 ec 28          	sub    $0x28,%rsp
  804427:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80442b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80442f:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  804436:	00 00 00 
  804439:	48 8b 00             	mov    (%rax),%rax
  80443c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804442:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804449:	48 89 c7             	mov    %rax,%rdi
  80444c:	48 b8 c1 4a 80 00 00 	movabs $0x804ac1,%rax
  804453:	00 00 00 
  804456:	ff d0                	callq  *%rax
  804458:	89 c3                	mov    %eax,%ebx
  80445a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80445e:	48 89 c7             	mov    %rax,%rdi
  804461:	48 b8 c1 4a 80 00 00 	movabs $0x804ac1,%rax
  804468:	00 00 00 
  80446b:	ff d0                	callq  *%rax
  80446d:	39 c3                	cmp    %eax,%ebx
  80446f:	0f 94 c0             	sete   %al
  804472:	0f b6 c0             	movzbl %al,%eax
  804475:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804478:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  80447f:	00 00 00 
  804482:	48 8b 00             	mov    (%rax),%rax
  804485:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80448b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80448e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804491:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804494:	75 05                	jne    80449b <_pipeisclosed+0x7d>
			return ret;
  804496:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804499:	eb 4a                	jmp    8044e5 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80449b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80449e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044a1:	74 3d                	je     8044e0 <_pipeisclosed+0xc2>
  8044a3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8044a7:	75 37                	jne    8044e0 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8044a9:	48 b8 b0 a7 80 00 00 	movabs $0x80a7b0,%rax
  8044b0:	00 00 00 
  8044b3:	48 8b 00             	mov    (%rax),%rax
  8044b6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8044bc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8044bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044c2:	89 c6                	mov    %eax,%esi
  8044c4:	48 bf 8b 54 80 00 00 	movabs $0x80548b,%rdi
  8044cb:	00 00 00 
  8044ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8044d3:	49 b8 66 09 80 00 00 	movabs $0x800966,%r8
  8044da:	00 00 00 
  8044dd:	41 ff d0             	callq  *%r8
	}
  8044e0:	e9 4a ff ff ff       	jmpq   80442f <_pipeisclosed+0x11>
}
  8044e5:	48 83 c4 28          	add    $0x28,%rsp
  8044e9:	5b                   	pop    %rbx
  8044ea:	5d                   	pop    %rbp
  8044eb:	c3                   	retq   

00000000008044ec <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8044ec:	55                   	push   %rbp
  8044ed:	48 89 e5             	mov    %rsp,%rbp
  8044f0:	48 83 ec 30          	sub    $0x30,%rsp
  8044f4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044f7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8044fb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8044fe:	48 89 d6             	mov    %rdx,%rsi
  804501:	89 c7                	mov    %eax,%edi
  804503:	48 b8 7b 22 80 00 00 	movabs $0x80227b,%rax
  80450a:	00 00 00 
  80450d:	ff d0                	callq  *%rax
  80450f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804512:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804516:	79 05                	jns    80451d <pipeisclosed+0x31>
		return r;
  804518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80451b:	eb 31                	jmp    80454e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80451d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804521:	48 89 c7             	mov    %rax,%rdi
  804524:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  80452b:	00 00 00 
  80452e:	ff d0                	callq  *%rax
  804530:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804538:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80453c:	48 89 d6             	mov    %rdx,%rsi
  80453f:	48 89 c7             	mov    %rax,%rdi
  804542:	48 b8 1e 44 80 00 00 	movabs $0x80441e,%rax
  804549:	00 00 00 
  80454c:	ff d0                	callq  *%rax
}
  80454e:	c9                   	leaveq 
  80454f:	c3                   	retq   

0000000000804550 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804550:	55                   	push   %rbp
  804551:	48 89 e5             	mov    %rsp,%rbp
  804554:	48 83 ec 40          	sub    $0x40,%rsp
  804558:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80455c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804560:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804568:	48 89 c7             	mov    %rax,%rdi
  80456b:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  804572:	00 00 00 
  804575:	ff d0                	callq  *%rax
  804577:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80457b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80457f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804583:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80458a:	00 
  80458b:	e9 92 00 00 00       	jmpq   804622 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804590:	eb 41                	jmp    8045d3 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804592:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804597:	74 09                	je     8045a2 <devpipe_read+0x52>
				return i;
  804599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80459d:	e9 92 00 00 00       	jmpq   804634 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8045a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045aa:	48 89 d6             	mov    %rdx,%rsi
  8045ad:	48 89 c7             	mov    %rax,%rdi
  8045b0:	48 b8 1e 44 80 00 00 	movabs $0x80441e,%rax
  8045b7:	00 00 00 
  8045ba:	ff d0                	callq  *%rax
  8045bc:	85 c0                	test   %eax,%eax
  8045be:	74 07                	je     8045c7 <devpipe_read+0x77>
				return 0;
  8045c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c5:	eb 6d                	jmp    804634 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8045c7:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  8045ce:	00 00 00 
  8045d1:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8045d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045d7:	8b 10                	mov    (%rax),%edx
  8045d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045dd:	8b 40 04             	mov    0x4(%rax),%eax
  8045e0:	39 c2                	cmp    %eax,%edx
  8045e2:	74 ae                	je     804592 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8045e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8045e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ec:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8045f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f4:	8b 00                	mov    (%rax),%eax
  8045f6:	99                   	cltd   
  8045f7:	c1 ea 1b             	shr    $0x1b,%edx
  8045fa:	01 d0                	add    %edx,%eax
  8045fc:	83 e0 1f             	and    $0x1f,%eax
  8045ff:	29 d0                	sub    %edx,%eax
  804601:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804605:	48 98                	cltq   
  804607:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80460c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80460e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804612:	8b 00                	mov    (%rax),%eax
  804614:	8d 50 01             	lea    0x1(%rax),%edx
  804617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80461b:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  80461d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804626:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80462a:	0f 82 60 ff ff ff    	jb     804590 <devpipe_read+0x40>
	}
	return i;
  804630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804634:	c9                   	leaveq 
  804635:	c3                   	retq   

0000000000804636 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804636:	55                   	push   %rbp
  804637:	48 89 e5             	mov    %rsp,%rbp
  80463a:	48 83 ec 40          	sub    $0x40,%rsp
  80463e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804642:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804646:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80464a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80464e:	48 89 c7             	mov    %rax,%rdi
  804651:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  804658:	00 00 00 
  80465b:	ff d0                	callq  *%rax
  80465d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804661:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804665:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804669:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804670:	00 
  804671:	e9 91 00 00 00       	jmpq   804707 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804676:	eb 31                	jmp    8046a9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804678:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80467c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804680:	48 89 d6             	mov    %rdx,%rsi
  804683:	48 89 c7             	mov    %rax,%rdi
  804686:	48 b8 1e 44 80 00 00 	movabs $0x80441e,%rax
  80468d:	00 00 00 
  804690:	ff d0                	callq  *%rax
  804692:	85 c0                	test   %eax,%eax
  804694:	74 07                	je     80469d <devpipe_write+0x67>
				return 0;
  804696:	b8 00 00 00 00       	mov    $0x0,%eax
  80469b:	eb 7c                	jmp    804719 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80469d:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  8046a4:	00 00 00 
  8046a7:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8046a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ad:	8b 40 04             	mov    0x4(%rax),%eax
  8046b0:	48 63 d0             	movslq %eax,%rdx
  8046b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b7:	8b 00                	mov    (%rax),%eax
  8046b9:	48 98                	cltq   
  8046bb:	48 83 c0 20          	add    $0x20,%rax
  8046bf:	48 39 c2             	cmp    %rax,%rdx
  8046c2:	73 b4                	jae    804678 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8046c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c8:	8b 40 04             	mov    0x4(%rax),%eax
  8046cb:	99                   	cltd   
  8046cc:	c1 ea 1b             	shr    $0x1b,%edx
  8046cf:	01 d0                	add    %edx,%eax
  8046d1:	83 e0 1f             	and    $0x1f,%eax
  8046d4:	29 d0                	sub    %edx,%eax
  8046d6:	89 c6                	mov    %eax,%esi
  8046d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046e0:	48 01 d0             	add    %rdx,%rax
  8046e3:	0f b6 08             	movzbl (%rax),%ecx
  8046e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046ea:	48 63 c6             	movslq %esi,%rax
  8046ed:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8046f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f5:	8b 40 04             	mov    0x4(%rax),%eax
  8046f8:	8d 50 01             	lea    0x1(%rax),%edx
  8046fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ff:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  804702:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80470b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80470f:	0f 82 61 ff ff ff    	jb     804676 <devpipe_write+0x40>
	}

	return i;
  804715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804719:	c9                   	leaveq 
  80471a:	c3                   	retq   

000000000080471b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80471b:	55                   	push   %rbp
  80471c:	48 89 e5             	mov    %rsp,%rbp
  80471f:	48 83 ec 20          	sub    $0x20,%rsp
  804723:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804727:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80472b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80472f:	48 89 c7             	mov    %rax,%rdi
  804732:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  804739:	00 00 00 
  80473c:	ff d0                	callq  *%rax
  80473e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804742:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804746:	48 be 9e 54 80 00 00 	movabs $0x80549e,%rsi
  80474d:	00 00 00 
  804750:	48 89 c7             	mov    %rax,%rdi
  804753:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  80475a:	00 00 00 
  80475d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80475f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804763:	8b 50 04             	mov    0x4(%rax),%edx
  804766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476a:	8b 00                	mov    (%rax),%eax
  80476c:	29 c2                	sub    %eax,%edx
  80476e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804772:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804778:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80477c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804783:	00 00 00 
	stat->st_dev = &devpipe;
  804786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80478a:	48 b9 80 88 80 00 00 	movabs $0x808880,%rcx
  804791:	00 00 00 
  804794:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80479b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047a0:	c9                   	leaveq 
  8047a1:	c3                   	retq   

00000000008047a2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8047a2:	55                   	push   %rbp
  8047a3:	48 89 e5             	mov    %rsp,%rbp
  8047a6:	48 83 ec 10          	sub    $0x10,%rsp
  8047aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8047ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047b2:	48 89 c6             	mov    %rax,%rsi
  8047b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ba:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8047c1:	00 00 00 
  8047c4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8047c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047ca:	48 89 c7             	mov    %rax,%rdi
  8047cd:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  8047d4:	00 00 00 
  8047d7:	ff d0                	callq  *%rax
  8047d9:	48 89 c6             	mov    %rax,%rsi
  8047dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8047e1:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  8047e8:	00 00 00 
  8047eb:	ff d0                	callq  *%rax
}
  8047ed:	c9                   	leaveq 
  8047ee:	c3                   	retq   

00000000008047ef <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8047ef:	55                   	push   %rbp
  8047f0:	48 89 e5             	mov    %rsp,%rbp
  8047f3:	48 83 ec 20          	sub    $0x20,%rsp
  8047f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8047fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047fe:	75 35                	jne    804835 <wait+0x46>
  804800:	48 b9 a5 54 80 00 00 	movabs $0x8054a5,%rcx
  804807:	00 00 00 
  80480a:	48 ba b0 54 80 00 00 	movabs $0x8054b0,%rdx
  804811:	00 00 00 
  804814:	be 09 00 00 00       	mov    $0x9,%esi
  804819:	48 bf c5 54 80 00 00 	movabs $0x8054c5,%rdi
  804820:	00 00 00 
  804823:	b8 00 00 00 00       	mov    $0x0,%eax
  804828:	49 b8 2d 07 80 00 00 	movabs $0x80072d,%r8
  80482f:	00 00 00 
  804832:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804835:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804838:	25 ff 03 00 00       	and    $0x3ff,%eax
  80483d:	48 98                	cltq   
  80483f:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804846:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80484d:	00 00 00 
  804850:	48 01 d0             	add    %rdx,%rax
  804853:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804857:	eb 0c                	jmp    804865 <wait+0x76>
		sys_yield();
  804859:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  804860:	00 00 00 
  804863:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804869:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80486f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804872:	75 0e                	jne    804882 <wait+0x93>
  804874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804878:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80487e:	85 c0                	test   %eax,%eax
  804880:	75 d7                	jne    804859 <wait+0x6a>
}
  804882:	c9                   	leaveq 
  804883:	c3                   	retq   

0000000000804884 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804884:	55                   	push   %rbp
  804885:	48 89 e5             	mov    %rsp,%rbp
  804888:	48 83 ec 20          	sub    $0x20,%rsp
  80488c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804890:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804894:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804898:	48 ba d0 54 80 00 00 	movabs $0x8054d0,%rdx
  80489f:	00 00 00 
  8048a2:	be 1d 00 00 00       	mov    $0x1d,%esi
  8048a7:	48 bf e9 54 80 00 00 	movabs $0x8054e9,%rdi
  8048ae:	00 00 00 
  8048b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b6:	48 b9 2d 07 80 00 00 	movabs $0x80072d,%rcx
  8048bd:	00 00 00 
  8048c0:	ff d1                	callq  *%rcx

00000000008048c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8048c2:	55                   	push   %rbp
  8048c3:	48 89 e5             	mov    %rsp,%rbp
  8048c6:	48 83 ec 20          	sub    $0x20,%rsp
  8048ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048cd:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8048d0:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8048d4:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8048d7:	48 ba f3 54 80 00 00 	movabs $0x8054f3,%rdx
  8048de:	00 00 00 
  8048e1:	be 2d 00 00 00       	mov    $0x2d,%esi
  8048e6:	48 bf e9 54 80 00 00 	movabs $0x8054e9,%rdi
  8048ed:	00 00 00 
  8048f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f5:	48 b9 2d 07 80 00 00 	movabs $0x80072d,%rcx
  8048fc:	00 00 00 
  8048ff:	ff d1                	callq  *%rcx

0000000000804901 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804901:	55                   	push   %rbp
  804902:	48 89 e5             	mov    %rsp,%rbp
  804905:	53                   	push   %rbx
  804906:	48 83 ec 48          	sub    $0x48,%rsp
  80490a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80490e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  804915:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  80491c:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  804921:	75 0e                	jne    804931 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  804923:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80492a:	00 00 00 
  80492d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  804931:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804935:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804939:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804940:	00 
	a3 = (uint64_t) 0;
  804941:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804948:	00 
	a4 = (uint64_t) 0;
  804949:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804950:	00 
	a5 = 0;
  804951:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804958:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  804959:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80495c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804960:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804964:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  804968:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80496c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804970:	4c 89 c3             	mov    %r8,%rbx
  804973:	0f 01 c1             	vmcall 
  804976:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804979:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80497d:	7e 36                	jle    8049b5 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  80497f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804982:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804985:	41 89 d0             	mov    %edx,%r8d
  804988:	89 c1                	mov    %eax,%ecx
  80498a:	48 ba 10 55 80 00 00 	movabs $0x805510,%rdx
  804991:	00 00 00 
  804994:	be 54 00 00 00       	mov    $0x54,%esi
  804999:	48 bf e9 54 80 00 00 	movabs $0x8054e9,%rdi
  8049a0:	00 00 00 
  8049a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8049a8:	49 b9 2d 07 80 00 00 	movabs $0x80072d,%r9
  8049af:	00 00 00 
  8049b2:	41 ff d1             	callq  *%r9
	return ret;
  8049b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8049b8:	48 83 c4 48          	add    $0x48,%rsp
  8049bc:	5b                   	pop    %rbx
  8049bd:	5d                   	pop    %rbp
  8049be:	c3                   	retq   

00000000008049bf <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8049bf:	55                   	push   %rbp
  8049c0:	48 89 e5             	mov    %rsp,%rbp
  8049c3:	53                   	push   %rbx
  8049c4:	48 83 ec 58          	sub    $0x58,%rsp
  8049c8:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  8049cb:	89 75 b0             	mov    %esi,-0x50(%rbp)
  8049ce:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8049d2:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8049d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8049dc:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8049e3:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8049e8:	75 0e                	jne    8049f8 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8049ea:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8049f1:	00 00 00 
  8049f4:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8049f8:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8049fb:	48 98                	cltq   
  8049fd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804a01:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804a04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804a08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804a0c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804a10:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  804a13:	48 98                	cltq   
  804a15:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  804a19:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804a20:	00 

	int r = -E_IPC_NOT_RECV;
  804a21:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  804a28:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a2f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804a33:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  804a37:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804a3b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804a3f:	4c 89 c3             	mov    %r8,%rbx
  804a42:	0f 01 c1             	vmcall 
  804a45:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804a48:	48 83 c4 58          	add    $0x58,%rsp
  804a4c:	5b                   	pop    %rbx
  804a4d:	5d                   	pop    %rbp
  804a4e:	c3                   	retq   

0000000000804a4f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a4f:	55                   	push   %rbp
  804a50:	48 89 e5             	mov    %rsp,%rbp
  804a53:	48 83 ec 18          	sub    $0x18,%rsp
  804a57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a61:	eb 4e                	jmp    804ab1 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804a63:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a6a:	00 00 00 
  804a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a70:	48 98                	cltq   
  804a72:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a79:	48 01 d0             	add    %rdx,%rax
  804a7c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a82:	8b 00                	mov    (%rax),%eax
  804a84:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a87:	75 24                	jne    804aad <ipc_find_env+0x5e>
			return envs[i].env_id;
  804a89:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a90:	00 00 00 
  804a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a96:	48 98                	cltq   
  804a98:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a9f:	48 01 d0             	add    %rdx,%rax
  804aa2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804aa8:	8b 40 08             	mov    0x8(%rax),%eax
  804aab:	eb 12                	jmp    804abf <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804aad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ab1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804ab8:	7e a9                	jle    804a63 <ipc_find_env+0x14>
	}
	return 0;
  804aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804abf:	c9                   	leaveq 
  804ac0:	c3                   	retq   

0000000000804ac1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804ac1:	55                   	push   %rbp
  804ac2:	48 89 e5             	mov    %rsp,%rbp
  804ac5:	48 83 ec 18          	sub    $0x18,%rsp
  804ac9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804acd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ad1:	48 c1 e8 15          	shr    $0x15,%rax
  804ad5:	48 89 c2             	mov    %rax,%rdx
  804ad8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804adf:	01 00 00 
  804ae2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ae6:	83 e0 01             	and    $0x1,%eax
  804ae9:	48 85 c0             	test   %rax,%rax
  804aec:	75 07                	jne    804af5 <pageref+0x34>
		return 0;
  804aee:	b8 00 00 00 00       	mov    $0x0,%eax
  804af3:	eb 53                	jmp    804b48 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804af9:	48 c1 e8 0c          	shr    $0xc,%rax
  804afd:	48 89 c2             	mov    %rax,%rdx
  804b00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b07:	01 00 00 
  804b0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b16:	83 e0 01             	and    $0x1,%eax
  804b19:	48 85 c0             	test   %rax,%rax
  804b1c:	75 07                	jne    804b25 <pageref+0x64>
		return 0;
  804b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  804b23:	eb 23                	jmp    804b48 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b29:	48 c1 e8 0c          	shr    $0xc,%rax
  804b2d:	48 89 c2             	mov    %rax,%rdx
  804b30:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b37:	00 00 00 
  804b3a:	48 c1 e2 04          	shl    $0x4,%rdx
  804b3e:	48 01 d0             	add    %rdx,%rax
  804b41:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804b45:	0f b7 c0             	movzwl %ax,%eax
}
  804b48:	c9                   	leaveq 
  804b49:	c3                   	retq   
