
vmm/guest/obj/user/ls:     formato del fichero elf64-x86-64


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
  80003c:	e8 d8 04 00 00       	callq  800519 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 e5 2b 80 00 00 	movabs $0x802be5,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 80 47 80 00 00 	movabs $0x804780,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 8c 47 80 00 00 	movabs $0x80478c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 9c 05 80 00 00 	movabs $0x80059c,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 d5 2c 80 00 00 	movabs $0x802cd5,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 96 47 80 00 00 	movabs $0x804796,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 8c 47 80 00 00 	movabs $0x80478c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 9c 05 80 00 00 	movabs $0x80059c,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 d2 28 80 00 00 	movabs $0x8028d2,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba a2 47 80 00 00 	movabs $0x8047a2,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 8c 47 80 00 00 	movabs $0x80478c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 9c 05 80 00 00 	movabs $0x80059c,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba c0 47 80 00 00 	movabs $0x8047c0,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 8c 47 80 00 00 	movabs $0x80478c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 9c 05 80 00 00 	movabs $0x80059c,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 32                	je     8002e6 <ls1+0x5e>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	ba 64 00 00 00       	mov    $0x64,%edx
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	ba 2d 00 00 00       	mov    $0x2d,%edx
  8002c6:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002c9:	89 c6                	mov    %eax,%esi
  8002cb:	48 bf df 47 80 00 00 	movabs $0x8047df,%rdi
  8002d2:	00 00 00 
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	48 b9 51 33 80 00 00 	movabs $0x803351,%rcx
  8002e1:	00 00 00 
  8002e4:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002eb:	74 76                	je     800363 <ls1+0xdb>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f1:	0f b6 00             	movzbl (%rax),%eax
  8002f4:	84 c0                	test   %al,%al
  8002f6:	74 37                	je     80032f <ls1+0xa7>
  8002f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fc:	48 89 c7             	mov    %rax,%rdi
  8002ff:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
  80030b:	48 98                	cltq   
  80030d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800315:	48 01 d0             	add    %rdx,%rax
  800318:	0f b6 00             	movzbl (%rax),%eax
  80031b:	3c 2f                	cmp    $0x2f,%al
  80031d:	74 10                	je     80032f <ls1+0xa7>
			sep = "/";
  80031f:	48 b8 e8 47 80 00 00 	movabs $0x8047e8,%rax
  800326:	00 00 00 
  800329:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032d:	eb 0e                	jmp    80033d <ls1+0xb5>
		else
			sep = "";
  80032f:	48 b8 ea 47 80 00 00 	movabs $0x8047ea,%rax
  800336:	00 00 00 
  800339:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800345:	48 89 c6             	mov    %rax,%rsi
  800348:	48 bf eb 47 80 00 00 	movabs $0x8047eb,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 b9 51 33 80 00 00 	movabs $0x803351,%rcx
  80035e:	00 00 00 
  800361:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800367:	48 89 c6             	mov    %rax,%rsi
  80036a:	48 bf f0 47 80 00 00 	movabs $0x8047f0,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba 51 33 80 00 00 	movabs $0x803351,%rdx
  800380:	00 00 00 
  800383:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800385:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  80038c:	00 00 00 
  80038f:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800395:	85 c0                	test   %eax,%eax
  800397:	74 21                	je     8003ba <ls1+0x132>
  800399:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039d:	74 1b                	je     8003ba <ls1+0x132>
		printf("/");
  80039f:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  8003a6:	00 00 00 
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	48 ba 51 33 80 00 00 	movabs $0x803351,%rdx
  8003b5:	00 00 00 
  8003b8:	ff d2                	callq  *%rdx
	printf("\n");
  8003ba:	48 bf f3 47 80 00 00 	movabs $0x8047f3,%rdi
  8003c1:	00 00 00 
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	48 ba 51 33 80 00 00 	movabs $0x803351,%rdx
  8003d0:	00 00 00 
  8003d3:	ff d2                	callq  *%rdx
}
  8003d5:	c9                   	leaveq 
  8003d6:	c3                   	retq   

00000000008003d7 <usage>:

void
usage(void)
{
  8003d7:	55                   	push   %rbp
  8003d8:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003db:	48 bf f5 47 80 00 00 	movabs $0x8047f5,%rdi
  8003e2:	00 00 00 
  8003e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ea:	48 ba 51 33 80 00 00 	movabs $0x803351,%rdx
  8003f1:	00 00 00 
  8003f4:	ff d2                	callq  *%rdx
	exit();
  8003f6:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  8003fd:	00 00 00 
  800400:	ff d0                	callq  *%rax
}
  800402:	5d                   	pop    %rbp
  800403:	c3                   	retq   

0000000000800404 <umain>:

void
umain(int argc, char **argv)
{
  800404:	55                   	push   %rbp
  800405:	48 89 e5             	mov    %rsp,%rbp
  800408:	48 83 ec 40          	sub    $0x40,%rsp
  80040c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80040f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800413:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800417:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041b:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  80041f:	48 89 ce             	mov    %rcx,%rsi
  800422:	48 89 c7             	mov    %rax,%rdi
  800425:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  80042c:	00 00 00 
  80042f:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800431:	eb 49                	jmp    80047c <umain+0x78>
		switch (i) {
  800433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800436:	83 f8 64             	cmp    $0x64,%eax
  800439:	74 0a                	je     800445 <umain+0x41>
  80043b:	83 f8 6c             	cmp    $0x6c,%eax
  80043e:	74 05                	je     800445 <umain+0x41>
  800440:	83 f8 46             	cmp    $0x46,%eax
  800443:	75 2b                	jne    800470 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800445:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  80044c:	00 00 00 
  80044f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800452:	48 63 d2             	movslq %edx,%rdx
  800455:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800458:	8d 48 01             	lea    0x1(%rax),%ecx
  80045b:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800462:	00 00 00 
  800465:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800468:	48 63 d2             	movslq %edx,%rdx
  80046b:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  80046e:	eb 0c                	jmp    80047c <umain+0x78>
		default:
			usage();
  800470:	48 b8 d7 03 80 00 00 	movabs $0x8003d7,%rax
  800477:	00 00 00 
  80047a:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  80047c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800480:	48 89 c7             	mov    %rax,%rdi
  800483:	48 b8 68 20 80 00 00 	movabs $0x802068,%rax
  80048a:	00 00 00 
  80048d:	ff d0                	callq  *%rax
  80048f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800496:	79 9b                	jns    800433 <umain+0x2f>
		}

	if (argc == 1)
  800498:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049b:	83 f8 01             	cmp    $0x1,%eax
  80049e:	75 22                	jne    8004c2 <umain+0xbe>
		ls("/", "");
  8004a0:	48 be ea 47 80 00 00 	movabs $0x8047ea,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  8004b1:	00 00 00 
  8004b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax
  8004c0:	eb 55                	jmp    800517 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004c9:	eb 44                	jmp    80050f <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ce:	48 98                	cltq   
  8004d0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d7:	00 
  8004d8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004dc:	48 01 d0             	add    %rdx,%rax
  8004df:	48 8b 10             	mov    (%rax),%rdx
  8004e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e5:	48 98                	cltq   
  8004e7:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004ee:	00 
  8004ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f3:	48 01 c8             	add    %rcx,%rax
  8004f6:	48 8b 00             	mov    (%rax),%rax
  8004f9:	48 89 d6             	mov    %rdx,%rsi
  8004fc:	48 89 c7             	mov    %rax,%rdi
  8004ff:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800506:	00 00 00 
  800509:	ff d0                	callq  *%rax
		for (i = 1; i < argc; i++)
  80050b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80050f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800512:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800515:	7c b4                	jl     8004cb <umain+0xc7>
	}
}
  800517:	c9                   	leaveq 
  800518:	c3                   	retq   

0000000000800519 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	48 83 ec 10          	sub    $0x10,%rsp
  800521:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800524:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800528:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  80052f:	00 00 00 
  800532:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80053d:	7e 14                	jle    800553 <libmain+0x3a>
		binaryname = argv[0];
  80053f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800543:	48 8b 10             	mov    (%rax),%rdx
  800546:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80054d:	00 00 00 
  800550:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800553:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80055a:	48 89 d6             	mov    %rdx,%rsi
  80055d:	89 c7                	mov    %eax,%edi
  80055f:	48 b8 04 04 80 00 00 	movabs $0x800404,%rax
  800566:	00 00 00 
  800569:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80056b:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  800572:	00 00 00 
  800575:	ff d0                	callq  *%rax
}
  800577:	c9                   	leaveq 
  800578:	c3                   	retq   

0000000000800579 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800579:	55                   	push   %rbp
  80057a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80057d:	48 b8 26 26 80 00 00 	movabs $0x802626,%rax
  800584:	00 00 00 
  800587:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800589:	bf 00 00 00 00       	mov    $0x0,%edi
  80058e:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  800595:	00 00 00 
  800598:	ff d0                	callq  *%rax
}
  80059a:	5d                   	pop    %rbp
  80059b:	c3                   	retq   

000000000080059c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80059c:	55                   	push   %rbp
  80059d:	48 89 e5             	mov    %rsp,%rbp
  8005a0:	53                   	push   %rbx
  8005a1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005a8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005af:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005b5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005bc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005c3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005ca:	84 c0                	test   %al,%al
  8005cc:	74 23                	je     8005f1 <_panic+0x55>
  8005ce:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005d5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005d9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005dd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005e1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8005e5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8005e9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8005ed:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8005f1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8005f8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8005ff:	00 00 00 
  800602:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800609:	00 00 00 
  80060c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800610:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800617:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80061e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800625:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80062c:	00 00 00 
  80062f:	48 8b 18             	mov    (%rax),%rbx
  800632:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  800639:	00 00 00 
  80063c:	ff d0                	callq  *%rax
  80063e:	89 c6                	mov    %eax,%esi
  800640:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800646:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80064d:	41 89 d0             	mov    %edx,%r8d
  800650:	48 89 c1             	mov    %rax,%rcx
  800653:	48 89 da             	mov    %rbx,%rdx
  800656:	48 bf 20 48 80 00 00 	movabs $0x804820,%rdi
  80065d:	00 00 00 
  800660:	b8 00 00 00 00       	mov    $0x0,%eax
  800665:	49 b9 d5 07 80 00 00 	movabs $0x8007d5,%r9
  80066c:	00 00 00 
  80066f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800672:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800679:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800680:	48 89 d6             	mov    %rdx,%rsi
  800683:	48 89 c7             	mov    %rax,%rdi
  800686:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  80068d:	00 00 00 
  800690:	ff d0                	callq  *%rax
	cprintf("\n");
  800692:	48 bf 43 48 80 00 00 	movabs $0x804843,%rdi
  800699:	00 00 00 
  80069c:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a1:	48 ba d5 07 80 00 00 	movabs $0x8007d5,%rdx
  8006a8:	00 00 00 
  8006ab:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006ad:	cc                   	int3   
  8006ae:	eb fd                	jmp    8006ad <_panic+0x111>

00000000008006b0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006b0:	55                   	push   %rbp
  8006b1:	48 89 e5             	mov    %rsp,%rbp
  8006b4:	48 83 ec 10          	sub    $0x10,%rsp
  8006b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c3:	8b 00                	mov    (%rax),%eax
  8006c5:	8d 48 01             	lea    0x1(%rax),%ecx
  8006c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006cc:	89 0a                	mov    %ecx,(%rdx)
  8006ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006d1:	89 d1                	mov    %edx,%ecx
  8006d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006d7:	48 98                	cltq   
  8006d9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e1:	8b 00                	mov    (%rax),%eax
  8006e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006e8:	75 2c                	jne    800716 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ee:	8b 00                	mov    (%rax),%eax
  8006f0:	48 98                	cltq   
  8006f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f6:	48 83 c2 08          	add    $0x8,%rdx
  8006fa:	48 89 c6             	mov    %rax,%rsi
  8006fd:	48 89 d7             	mov    %rdx,%rdi
  800700:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  800707:	00 00 00 
  80070a:	ff d0                	callq  *%rax
        b->idx = 0;
  80070c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800710:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071a:	8b 40 04             	mov    0x4(%rax),%eax
  80071d:	8d 50 01             	lea    0x1(%rax),%edx
  800720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800724:	89 50 04             	mov    %edx,0x4(%rax)
}
  800727:	c9                   	leaveq 
  800728:	c3                   	retq   

0000000000800729 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800729:	55                   	push   %rbp
  80072a:	48 89 e5             	mov    %rsp,%rbp
  80072d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800734:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80073b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800742:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800749:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800750:	48 8b 0a             	mov    (%rdx),%rcx
  800753:	48 89 08             	mov    %rcx,(%rax)
  800756:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80075a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80075e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800762:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800766:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80076d:	00 00 00 
    b.cnt = 0;
  800770:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800777:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80077a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800781:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800788:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80078f:	48 89 c6             	mov    %rax,%rsi
  800792:	48 bf b0 06 80 00 00 	movabs $0x8006b0,%rdi
  800799:	00 00 00 
  80079c:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  8007a3:	00 00 00 
  8007a6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007a8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007ae:	48 98                	cltq   
  8007b0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007b7:	48 83 c2 08          	add    $0x8,%rdx
  8007bb:	48 89 c6             	mov    %rax,%rsi
  8007be:	48 89 d7             	mov    %rdx,%rdi
  8007c1:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8007c8:	00 00 00 
  8007cb:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007d3:	c9                   	leaveq 
  8007d4:	c3                   	retq   

00000000008007d5 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007d5:	55                   	push   %rbp
  8007d6:	48 89 e5             	mov    %rsp,%rbp
  8007d9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007e0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8007e7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8007ee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8007f5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8007fc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800803:	84 c0                	test   %al,%al
  800805:	74 20                	je     800827 <cprintf+0x52>
  800807:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80080b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80080f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800813:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800817:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80081b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80081f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800823:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800827:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80082e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800835:	00 00 00 
  800838:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80083f:	00 00 00 
  800842:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800846:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80084d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800854:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80085b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800862:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800869:	48 8b 0a             	mov    (%rdx),%rcx
  80086c:	48 89 08             	mov    %rcx,(%rax)
  80086f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800873:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800877:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80087f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800886:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80088d:	48 89 d6             	mov    %rdx,%rsi
  800890:	48 89 c7             	mov    %rax,%rdi
  800893:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  80089a:	00 00 00 
  80089d:	ff d0                	callq  *%rax
  80089f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008ab:	c9                   	leaveq 
  8008ac:	c3                   	retq   

00000000008008ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008ad:	55                   	push   %rbp
  8008ae:	48 89 e5             	mov    %rsp,%rbp
  8008b1:	48 83 ec 30          	sub    $0x30,%rsp
  8008b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008c1:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008c4:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008c8:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008cc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8008cf:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8008d3:	77 42                	ja     800917 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008d5:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8008d8:	8d 78 ff             	lea    -0x1(%rax),%edi
  8008db:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8008de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	48 f7 f6             	div    %rsi
  8008ea:	49 89 c2             	mov    %rax,%r10
  8008ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8008f0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8008f3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8008f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008fb:	41 89 c9             	mov    %ecx,%r9d
  8008fe:	41 89 f8             	mov    %edi,%r8d
  800901:	89 d1                	mov    %edx,%ecx
  800903:	4c 89 d2             	mov    %r10,%rdx
  800906:	48 89 c7             	mov    %rax,%rdi
  800909:	48 b8 ad 08 80 00 00 	movabs $0x8008ad,%rax
  800910:	00 00 00 
  800913:	ff d0                	callq  *%rax
  800915:	eb 1e                	jmp    800935 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800917:	eb 12                	jmp    80092b <printnum+0x7e>
			putch(padc, putdat);
  800919:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80091d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800924:	48 89 ce             	mov    %rcx,%rsi
  800927:	89 d7                	mov    %edx,%edi
  800929:	ff d0                	callq  *%rax
		while (--width > 0)
  80092b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800933:	7f e4                	jg     800919 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800935:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093c:	ba 00 00 00 00       	mov    $0x0,%edx
  800941:	48 f7 f1             	div    %rcx
  800944:	48 b8 70 4a 80 00 00 	movabs $0x804a70,%rax
  80094b:	00 00 00 
  80094e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800952:	0f be d0             	movsbl %al,%edx
  800955:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800959:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80095d:	48 89 ce             	mov    %rcx,%rsi
  800960:	89 d7                	mov    %edx,%edi
  800962:	ff d0                	callq  *%rax
}
  800964:	c9                   	leaveq 
  800965:	c3                   	retq   

0000000000800966 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800966:	55                   	push   %rbp
  800967:	48 89 e5             	mov    %rsp,%rbp
  80096a:	48 83 ec 20          	sub    $0x20,%rsp
  80096e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800972:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800975:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800979:	7e 4f                	jle    8009ca <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80097b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097f:	8b 00                	mov    (%rax),%eax
  800981:	83 f8 30             	cmp    $0x30,%eax
  800984:	73 24                	jae    8009aa <getuint+0x44>
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80098e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800992:	8b 00                	mov    (%rax),%eax
  800994:	89 c0                	mov    %eax,%eax
  800996:	48 01 d0             	add    %rdx,%rax
  800999:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099d:	8b 12                	mov    (%rdx),%edx
  80099f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a6:	89 0a                	mov    %ecx,(%rdx)
  8009a8:	eb 14                	jmp    8009be <getuint+0x58>
  8009aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ae:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009b2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009be:	48 8b 00             	mov    (%rax),%rax
  8009c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c5:	e9 9d 00 00 00       	jmpq   800a67 <getuint+0x101>
	else if (lflag)
  8009ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009ce:	74 4c                	je     800a1c <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8009d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d4:	8b 00                	mov    (%rax),%eax
  8009d6:	83 f8 30             	cmp    $0x30,%eax
  8009d9:	73 24                	jae    8009ff <getuint+0x99>
  8009db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e7:	8b 00                	mov    (%rax),%eax
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 01 d0             	add    %rdx,%rax
  8009ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f2:	8b 12                	mov    (%rdx),%edx
  8009f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	89 0a                	mov    %ecx,(%rdx)
  8009fd:	eb 14                	jmp    800a13 <getuint+0xad>
  8009ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a03:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a07:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a13:	48 8b 00             	mov    (%rax),%rax
  800a16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a1a:	eb 4b                	jmp    800a67 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a20:	8b 00                	mov    (%rax),%eax
  800a22:	83 f8 30             	cmp    $0x30,%eax
  800a25:	73 24                	jae    800a4b <getuint+0xe5>
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a33:	8b 00                	mov    (%rax),%eax
  800a35:	89 c0                	mov    %eax,%eax
  800a37:	48 01 d0             	add    %rdx,%rax
  800a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3e:	8b 12                	mov    (%rdx),%edx
  800a40:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a47:	89 0a                	mov    %ecx,(%rdx)
  800a49:	eb 14                	jmp    800a5f <getuint+0xf9>
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a53:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a5f:	8b 00                	mov    (%rax),%eax
  800a61:	89 c0                	mov    %eax,%eax
  800a63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a6b:	c9                   	leaveq 
  800a6c:	c3                   	retq   

0000000000800a6d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a6d:	55                   	push   %rbp
  800a6e:	48 89 e5             	mov    %rsp,%rbp
  800a71:	48 83 ec 20          	sub    $0x20,%rsp
  800a75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a79:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a7c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a80:	7e 4f                	jle    800ad1 <getint+0x64>
		x=va_arg(*ap, long long);
  800a82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a86:	8b 00                	mov    (%rax),%eax
  800a88:	83 f8 30             	cmp    $0x30,%eax
  800a8b:	73 24                	jae    800ab1 <getint+0x44>
  800a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a91:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a99:	8b 00                	mov    (%rax),%eax
  800a9b:	89 c0                	mov    %eax,%eax
  800a9d:	48 01 d0             	add    %rdx,%rax
  800aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa4:	8b 12                	mov    (%rdx),%edx
  800aa6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aad:	89 0a                	mov    %ecx,(%rdx)
  800aaf:	eb 14                	jmp    800ac5 <getint+0x58>
  800ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ab9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800abd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac5:	48 8b 00             	mov    (%rax),%rax
  800ac8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800acc:	e9 9d 00 00 00       	jmpq   800b6e <getint+0x101>
	else if (lflag)
  800ad1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ad5:	74 4c                	je     800b23 <getint+0xb6>
		x=va_arg(*ap, long);
  800ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adb:	8b 00                	mov    (%rax),%eax
  800add:	83 f8 30             	cmp    $0x30,%eax
  800ae0:	73 24                	jae    800b06 <getint+0x99>
  800ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aee:	8b 00                	mov    (%rax),%eax
  800af0:	89 c0                	mov    %eax,%eax
  800af2:	48 01 d0             	add    %rdx,%rax
  800af5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af9:	8b 12                	mov    (%rdx),%edx
  800afb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800afe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b02:	89 0a                	mov    %ecx,(%rdx)
  800b04:	eb 14                	jmp    800b1a <getint+0xad>
  800b06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b0e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b16:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b1a:	48 8b 00             	mov    (%rax),%rax
  800b1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b21:	eb 4b                	jmp    800b6e <getint+0x101>
	else
		x=va_arg(*ap, int);
  800b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b27:	8b 00                	mov    (%rax),%eax
  800b29:	83 f8 30             	cmp    $0x30,%eax
  800b2c:	73 24                	jae    800b52 <getint+0xe5>
  800b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b32:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3a:	8b 00                	mov    (%rax),%eax
  800b3c:	89 c0                	mov    %eax,%eax
  800b3e:	48 01 d0             	add    %rdx,%rax
  800b41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b45:	8b 12                	mov    (%rdx),%edx
  800b47:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4e:	89 0a                	mov    %ecx,(%rdx)
  800b50:	eb 14                	jmp    800b66 <getint+0xf9>
  800b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b56:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b5a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b62:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b66:	8b 00                	mov    (%rax),%eax
  800b68:	48 98                	cltq   
  800b6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b72:	c9                   	leaveq 
  800b73:	c3                   	retq   

0000000000800b74 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b74:	55                   	push   %rbp
  800b75:	48 89 e5             	mov    %rsp,%rbp
  800b78:	41 54                	push   %r12
  800b7a:	53                   	push   %rbx
  800b7b:	48 83 ec 60          	sub    $0x60,%rsp
  800b7f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b83:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b87:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b8b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b93:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b97:	48 8b 0a             	mov    (%rdx),%rcx
  800b9a:	48 89 08             	mov    %rcx,(%rax)
  800b9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ba1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ba5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ba9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bad:	eb 17                	jmp    800bc6 <vprintfmt+0x52>
			if (ch == '\0')
  800baf:	85 db                	test   %ebx,%ebx
  800bb1:	0f 84 c5 04 00 00    	je     80107c <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800bb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbf:	48 89 d6             	mov    %rdx,%rsi
  800bc2:	89 df                	mov    %ebx,%edi
  800bc4:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bce:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bd2:	0f b6 00             	movzbl (%rax),%eax
  800bd5:	0f b6 d8             	movzbl %al,%ebx
  800bd8:	83 fb 25             	cmp    $0x25,%ebx
  800bdb:	75 d2                	jne    800baf <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800bdd:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800be1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800be8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800bef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800bf6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bfd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c01:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c05:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c09:	0f b6 00             	movzbl (%rax),%eax
  800c0c:	0f b6 d8             	movzbl %al,%ebx
  800c0f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c12:	83 f8 55             	cmp    $0x55,%eax
  800c15:	0f 87 2e 04 00 00    	ja     801049 <vprintfmt+0x4d5>
  800c1b:	89 c0                	mov    %eax,%eax
  800c1d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c24:	00 
  800c25:	48 b8 98 4a 80 00 00 	movabs $0x804a98,%rax
  800c2c:	00 00 00 
  800c2f:	48 01 d0             	add    %rdx,%rax
  800c32:	48 8b 00             	mov    (%rax),%rax
  800c35:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c37:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c3b:	eb c0                	jmp    800bfd <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c3d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c41:	eb ba                	jmp    800bfd <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c43:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c4a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c4d:	89 d0                	mov    %edx,%eax
  800c4f:	c1 e0 02             	shl    $0x2,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	01 d8                	add    %ebx,%eax
  800c58:	83 e8 30             	sub    $0x30,%eax
  800c5b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c5e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c62:	0f b6 00             	movzbl (%rax),%eax
  800c65:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c68:	83 fb 2f             	cmp    $0x2f,%ebx
  800c6b:	7e 0c                	jle    800c79 <vprintfmt+0x105>
  800c6d:	83 fb 39             	cmp    $0x39,%ebx
  800c70:	7f 07                	jg     800c79 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800c72:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800c77:	eb d1                	jmp    800c4a <vprintfmt+0xd6>
			goto process_precision;
  800c79:	eb 50                	jmp    800ccb <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800c7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7e:	83 f8 30             	cmp    $0x30,%eax
  800c81:	73 17                	jae    800c9a <vprintfmt+0x126>
  800c83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8a:	89 d2                	mov    %edx,%edx
  800c8c:	48 01 d0             	add    %rdx,%rax
  800c8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c92:	83 c2 08             	add    $0x8,%edx
  800c95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c98:	eb 0c                	jmp    800ca6 <vprintfmt+0x132>
  800c9a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c9e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ca2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca6:	8b 00                	mov    (%rax),%eax
  800ca8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cab:	eb 1e                	jmp    800ccb <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800cad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb1:	79 07                	jns    800cba <vprintfmt+0x146>
				width = 0;
  800cb3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cba:	e9 3e ff ff ff       	jmpq   800bfd <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cbf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cc6:	e9 32 ff ff ff       	jmpq   800bfd <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ccb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ccf:	79 0d                	jns    800cde <vprintfmt+0x16a>
				width = precision, precision = -1;
  800cd1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cd4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cd7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cde:	e9 1a ff ff ff       	jmpq   800bfd <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ce7:	e9 11 ff ff ff       	jmpq   800bfd <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800cec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cef:	83 f8 30             	cmp    $0x30,%eax
  800cf2:	73 17                	jae    800d0b <vprintfmt+0x197>
  800cf4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfb:	89 d2                	mov    %edx,%edx
  800cfd:	48 01 d0             	add    %rdx,%rax
  800d00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d03:	83 c2 08             	add    $0x8,%edx
  800d06:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d09:	eb 0c                	jmp    800d17 <vprintfmt+0x1a3>
  800d0b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d0f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d17:	8b 10                	mov    (%rax),%edx
  800d19:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 ce             	mov    %rcx,%rsi
  800d24:	89 d7                	mov    %edx,%edi
  800d26:	ff d0                	callq  *%rax
			break;
  800d28:	e9 4a 03 00 00       	jmpq   801077 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d30:	83 f8 30             	cmp    $0x30,%eax
  800d33:	73 17                	jae    800d4c <vprintfmt+0x1d8>
  800d35:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3c:	89 d2                	mov    %edx,%edx
  800d3e:	48 01 d0             	add    %rdx,%rax
  800d41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d44:	83 c2 08             	add    $0x8,%edx
  800d47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d4a:	eb 0c                	jmp    800d58 <vprintfmt+0x1e4>
  800d4c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d50:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d54:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d58:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d5a:	85 db                	test   %ebx,%ebx
  800d5c:	79 02                	jns    800d60 <vprintfmt+0x1ec>
				err = -err;
  800d5e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d60:	83 fb 15             	cmp    $0x15,%ebx
  800d63:	7f 16                	jg     800d7b <vprintfmt+0x207>
  800d65:	48 b8 c0 49 80 00 00 	movabs $0x8049c0,%rax
  800d6c:	00 00 00 
  800d6f:	48 63 d3             	movslq %ebx,%rdx
  800d72:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d76:	4d 85 e4             	test   %r12,%r12
  800d79:	75 2e                	jne    800da9 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800d7b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d83:	89 d9                	mov    %ebx,%ecx
  800d85:	48 ba 81 4a 80 00 00 	movabs $0x804a81,%rdx
  800d8c:	00 00 00 
  800d8f:	48 89 c7             	mov    %rax,%rdi
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	49 b8 85 10 80 00 00 	movabs $0x801085,%r8
  800d9e:	00 00 00 
  800da1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800da4:	e9 ce 02 00 00       	jmpq   801077 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800da9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db1:	4c 89 e1             	mov    %r12,%rcx
  800db4:	48 ba 8a 4a 80 00 00 	movabs $0x804a8a,%rdx
  800dbb:	00 00 00 
  800dbe:	48 89 c7             	mov    %rax,%rdi
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	49 b8 85 10 80 00 00 	movabs $0x801085,%r8
  800dcd:	00 00 00 
  800dd0:	41 ff d0             	callq  *%r8
			break;
  800dd3:	e9 9f 02 00 00       	jmpq   801077 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800dd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ddb:	83 f8 30             	cmp    $0x30,%eax
  800dde:	73 17                	jae    800df7 <vprintfmt+0x283>
  800de0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800de4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800de7:	89 d2                	mov    %edx,%edx
  800de9:	48 01 d0             	add    %rdx,%rax
  800dec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800def:	83 c2 08             	add    $0x8,%edx
  800df2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800df5:	eb 0c                	jmp    800e03 <vprintfmt+0x28f>
  800df7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800dfb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800dff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e03:	4c 8b 20             	mov    (%rax),%r12
  800e06:	4d 85 e4             	test   %r12,%r12
  800e09:	75 0a                	jne    800e15 <vprintfmt+0x2a1>
				p = "(null)";
  800e0b:	49 bc 8d 4a 80 00 00 	movabs $0x804a8d,%r12
  800e12:	00 00 00 
			if (width > 0 && padc != '-')
  800e15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e19:	7e 3f                	jle    800e5a <vprintfmt+0x2e6>
  800e1b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e1f:	74 39                	je     800e5a <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e21:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e24:	48 98                	cltq   
  800e26:	48 89 c6             	mov    %rax,%rsi
  800e29:	4c 89 e7             	mov    %r12,%rdi
  800e2c:	48 b8 31 13 80 00 00 	movabs $0x801331,%rax
  800e33:	00 00 00 
  800e36:	ff d0                	callq  *%rax
  800e38:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e3b:	eb 17                	jmp    800e54 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800e3d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e41:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e49:	48 89 ce             	mov    %rcx,%rsi
  800e4c:	89 d7                	mov    %edx,%edi
  800e4e:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800e50:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e54:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e58:	7f e3                	jg     800e3d <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e5a:	eb 37                	jmp    800e93 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800e5c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e60:	74 1e                	je     800e80 <vprintfmt+0x30c>
  800e62:	83 fb 1f             	cmp    $0x1f,%ebx
  800e65:	7e 05                	jle    800e6c <vprintfmt+0x2f8>
  800e67:	83 fb 7e             	cmp    $0x7e,%ebx
  800e6a:	7e 14                	jle    800e80 <vprintfmt+0x30c>
					putch('?', putdat);
  800e6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e74:	48 89 d6             	mov    %rdx,%rsi
  800e77:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e7c:	ff d0                	callq  *%rax
  800e7e:	eb 0f                	jmp    800e8f <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800e80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e88:	48 89 d6             	mov    %rdx,%rsi
  800e8b:	89 df                	mov    %ebx,%edi
  800e8d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e93:	4c 89 e0             	mov    %r12,%rax
  800e96:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e9a:	0f b6 00             	movzbl (%rax),%eax
  800e9d:	0f be d8             	movsbl %al,%ebx
  800ea0:	85 db                	test   %ebx,%ebx
  800ea2:	74 10                	je     800eb4 <vprintfmt+0x340>
  800ea4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ea8:	78 b2                	js     800e5c <vprintfmt+0x2e8>
  800eaa:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800eae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eb2:	79 a8                	jns    800e5c <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800eb4:	eb 16                	jmp    800ecc <vprintfmt+0x358>
				putch(' ', putdat);
  800eb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebe:	48 89 d6             	mov    %rdx,%rsi
  800ec1:	bf 20 00 00 00       	mov    $0x20,%edi
  800ec6:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800ec8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ecc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed0:	7f e4                	jg     800eb6 <vprintfmt+0x342>
			break;
  800ed2:	e9 a0 01 00 00       	jmpq   801077 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ed7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800edb:	be 03 00 00 00       	mov    $0x3,%esi
  800ee0:	48 89 c7             	mov    %rax,%rdi
  800ee3:	48 b8 6d 0a 80 00 00 	movabs $0x800a6d,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	callq  *%rax
  800eef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef7:	48 85 c0             	test   %rax,%rax
  800efa:	79 1d                	jns    800f19 <vprintfmt+0x3a5>
				putch('-', putdat);
  800efc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f04:	48 89 d6             	mov    %rdx,%rsi
  800f07:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f0c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f12:	48 f7 d8             	neg    %rax
  800f15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f19:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f20:	e9 e5 00 00 00       	jmpq   80100a <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f25:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f29:	be 03 00 00 00       	mov    $0x3,%esi
  800f2e:	48 89 c7             	mov    %rax,%rdi
  800f31:	48 b8 66 09 80 00 00 	movabs $0x800966,%rax
  800f38:	00 00 00 
  800f3b:	ff d0                	callq  *%rax
  800f3d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f41:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f48:	e9 bd 00 00 00       	jmpq   80100a <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f55:	48 89 d6             	mov    %rdx,%rsi
  800f58:	bf 58 00 00 00       	mov    $0x58,%edi
  800f5d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f67:	48 89 d6             	mov    %rdx,%rsi
  800f6a:	bf 58 00 00 00       	mov    $0x58,%edi
  800f6f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f79:	48 89 d6             	mov    %rdx,%rsi
  800f7c:	bf 58 00 00 00       	mov    $0x58,%edi
  800f81:	ff d0                	callq  *%rax
			break;
  800f83:	e9 ef 00 00 00       	jmpq   801077 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800f88:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f90:	48 89 d6             	mov    %rdx,%rsi
  800f93:	bf 30 00 00 00       	mov    $0x30,%edi
  800f98:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa2:	48 89 d6             	mov    %rdx,%rsi
  800fa5:	bf 78 00 00 00       	mov    $0x78,%edi
  800faa:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800faf:	83 f8 30             	cmp    $0x30,%eax
  800fb2:	73 17                	jae    800fcb <vprintfmt+0x457>
  800fb4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fb8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fbb:	89 d2                	mov    %edx,%edx
  800fbd:	48 01 d0             	add    %rdx,%rax
  800fc0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fc3:	83 c2 08             	add    $0x8,%edx
  800fc6:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800fc9:	eb 0c                	jmp    800fd7 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800fcb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fcf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fd3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fd7:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800fda:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fde:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fe5:	eb 23                	jmp    80100a <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fe7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800feb:	be 03 00 00 00       	mov    $0x3,%esi
  800ff0:	48 89 c7             	mov    %rax,%rdi
  800ff3:	48 b8 66 09 80 00 00 	movabs $0x800966,%rax
  800ffa:	00 00 00 
  800ffd:	ff d0                	callq  *%rax
  800fff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801003:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80100f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801012:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801015:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801019:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80101d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801021:	45 89 c1             	mov    %r8d,%r9d
  801024:	41 89 f8             	mov    %edi,%r8d
  801027:	48 89 c7             	mov    %rax,%rdi
  80102a:	48 b8 ad 08 80 00 00 	movabs $0x8008ad,%rax
  801031:	00 00 00 
  801034:	ff d0                	callq  *%rax
			break;
  801036:	eb 3f                	jmp    801077 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801038:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80103c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801040:	48 89 d6             	mov    %rdx,%rsi
  801043:	89 df                	mov    %ebx,%edi
  801045:	ff d0                	callq  *%rax
			break;
  801047:	eb 2e                	jmp    801077 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801049:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80104d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801051:	48 89 d6             	mov    %rdx,%rsi
  801054:	bf 25 00 00 00       	mov    $0x25,%edi
  801059:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801060:	eb 05                	jmp    801067 <vprintfmt+0x4f3>
  801062:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801067:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80106b:	48 83 e8 01          	sub    $0x1,%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	3c 25                	cmp    $0x25,%al
  801074:	75 ec                	jne    801062 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801076:	90                   	nop
		}
	}
  801077:	e9 31 fb ff ff       	jmpq   800bad <vprintfmt+0x39>
	va_end(aq);
}
  80107c:	48 83 c4 60          	add    $0x60,%rsp
  801080:	5b                   	pop    %rbx
  801081:	41 5c                	pop    %r12
  801083:	5d                   	pop    %rbp
  801084:	c3                   	retq   

0000000000801085 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801090:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801097:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80109e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010a5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010b3:	84 c0                	test   %al,%al
  8010b5:	74 20                	je     8010d7 <printfmt+0x52>
  8010b7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010bb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010bf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010c3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010c7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010cb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010cf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010d3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010d7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010de:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010e5:	00 00 00 
  8010e8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010ef:	00 00 00 
  8010f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010fd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801104:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80110b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801112:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801119:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801120:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801127:	48 89 c7             	mov    %rax,%rdi
  80112a:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  801131:	00 00 00 
  801134:	ff d0                	callq  *%rax
	va_end(ap);
}
  801136:	c9                   	leaveq 
  801137:	c3                   	retq   

0000000000801138 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801138:	55                   	push   %rbp
  801139:	48 89 e5             	mov    %rsp,%rbp
  80113c:	48 83 ec 10          	sub    $0x10,%rsp
  801140:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801143:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114b:	8b 40 10             	mov    0x10(%rax),%eax
  80114e:	8d 50 01             	lea    0x1(%rax),%edx
  801151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801155:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115c:	48 8b 10             	mov    (%rax),%rdx
  80115f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801163:	48 8b 40 08          	mov    0x8(%rax),%rax
  801167:	48 39 c2             	cmp    %rax,%rdx
  80116a:	73 17                	jae    801183 <sprintputch+0x4b>
		*b->buf++ = ch;
  80116c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801170:	48 8b 00             	mov    (%rax),%rax
  801173:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801177:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80117b:	48 89 0a             	mov    %rcx,(%rdx)
  80117e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801181:	88 10                	mov    %dl,(%rax)
}
  801183:	c9                   	leaveq 
  801184:	c3                   	retq   

0000000000801185 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801185:	55                   	push   %rbp
  801186:	48 89 e5             	mov    %rsp,%rbp
  801189:	48 83 ec 50          	sub    $0x50,%rsp
  80118d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801191:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801194:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801198:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80119c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011a0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011a4:	48 8b 0a             	mov    (%rdx),%rcx
  8011a7:	48 89 08             	mov    %rcx,(%rax)
  8011aa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011ae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011b2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011b6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011be:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011c2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011c5:	48 98                	cltq   
  8011c7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011cf:	48 01 d0             	add    %rdx,%rax
  8011d2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011dd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011e2:	74 06                	je     8011ea <vsnprintf+0x65>
  8011e4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011e8:	7f 07                	jg     8011f1 <vsnprintf+0x6c>
		return -E_INVAL;
  8011ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ef:	eb 2f                	jmp    801220 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011f1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011f5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011f9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011fd:	48 89 c6             	mov    %rax,%rsi
  801200:	48 bf 38 11 80 00 00 	movabs $0x801138,%rdi
  801207:	00 00 00 
  80120a:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  801211:	00 00 00 
  801214:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801216:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80121a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80121d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801220:	c9                   	leaveq 
  801221:	c3                   	retq   

0000000000801222 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801222:	55                   	push   %rbp
  801223:	48 89 e5             	mov    %rsp,%rbp
  801226:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80122d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801234:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80123a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801241:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801248:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80124f:	84 c0                	test   %al,%al
  801251:	74 20                	je     801273 <snprintf+0x51>
  801253:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801257:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80125b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80125f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801263:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801267:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80126b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80126f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801273:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80127a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801281:	00 00 00 
  801284:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80128b:	00 00 00 
  80128e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801292:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801299:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012a0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012a7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012ae:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012b5:	48 8b 0a             	mov    (%rdx),%rcx
  8012b8:	48 89 08             	mov    %rcx,(%rax)
  8012bb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012bf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012c3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012c7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012cb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012d2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012d9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012df:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012e6:	48 89 c7             	mov    %rax,%rdi
  8012e9:	48 b8 85 11 80 00 00 	movabs $0x801185,%rax
  8012f0:	00 00 00 
  8012f3:	ff d0                	callq  *%rax
  8012f5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012fb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 18          	sub    $0x18,%rsp
  80130b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80130f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801316:	eb 09                	jmp    801321 <strlen+0x1e>
		n++;
  801318:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80131c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	84 c0                	test   %al,%al
  80132a:	75 ec                	jne    801318 <strlen+0x15>
	return n;
  80132c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80132f:	c9                   	leaveq 
  801330:	c3                   	retq   

0000000000801331 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801331:	55                   	push   %rbp
  801332:	48 89 e5             	mov    %rsp,%rbp
  801335:	48 83 ec 20          	sub    $0x20,%rsp
  801339:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801348:	eb 0e                	jmp    801358 <strnlen+0x27>
		n++;
  80134a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80134e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801353:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801358:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80135d:	74 0b                	je     80136a <strnlen+0x39>
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801363:	0f b6 00             	movzbl (%rax),%eax
  801366:	84 c0                	test   %al,%al
  801368:	75 e0                	jne    80134a <strnlen+0x19>
	return n;
  80136a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 20          	sub    $0x20,%rsp
  801377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80137f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801383:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801387:	90                   	nop
  801388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801390:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801394:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801398:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80139c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013a0:	0f b6 12             	movzbl (%rdx),%edx
  8013a3:	88 10                	mov    %dl,(%rax)
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	84 c0                	test   %al,%al
  8013aa:	75 dc                	jne    801388 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b0:	c9                   	leaveq 
  8013b1:	c3                   	retq   

00000000008013b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013b2:	55                   	push   %rbp
  8013b3:	48 89 e5             	mov    %rsp,%rbp
  8013b6:	48 83 ec 20          	sub    $0x20,%rsp
  8013ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c6:	48 89 c7             	mov    %rax,%rdi
  8013c9:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  8013d0:	00 00 00 
  8013d3:	ff d0                	callq  *%rax
  8013d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013db:	48 63 d0             	movslq %eax,%rdx
  8013de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e2:	48 01 c2             	add    %rax,%rdx
  8013e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e9:	48 89 c6             	mov    %rax,%rsi
  8013ec:	48 89 d7             	mov    %rdx,%rdi
  8013ef:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  8013f6:	00 00 00 
  8013f9:	ff d0                	callq  *%rax
	return dst;
  8013fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 28          	sub    $0x28,%rsp
  801409:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801411:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801419:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80141d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801424:	00 
  801425:	eb 2a                	jmp    801451 <strncpy+0x50>
		*dst++ = *src;
  801427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80142f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801433:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801437:	0f b6 12             	movzbl (%rdx),%edx
  80143a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80143c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	84 c0                	test   %al,%al
  801445:	74 05                	je     80144c <strncpy+0x4b>
			src++;
  801447:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80144c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801455:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801459:	72 cc                	jb     801427 <strncpy+0x26>
	}
	return ret;
  80145b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 28          	sub    $0x28,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80147d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801482:	74 3d                	je     8014c1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801484:	eb 1d                	jmp    8014a3 <strlcpy+0x42>
			*dst++ = *src++;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80148e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801492:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801496:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80149a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80149e:	0f b6 12             	movzbl (%rdx),%edx
  8014a1:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8014a3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014ad:	74 0b                	je     8014ba <strlcpy+0x59>
  8014af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b3:	0f b6 00             	movzbl (%rax),%eax
  8014b6:	84 c0                	test   %al,%al
  8014b8:	75 cc                	jne    801486 <strlcpy+0x25>
		*dst = '\0';
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014be:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	48 29 c2             	sub    %rax,%rdx
  8014cc:	48 89 d0             	mov    %rdx,%rax
}
  8014cf:	c9                   	leaveq 
  8014d0:	c3                   	retq   

00000000008014d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	48 83 ec 10          	sub    $0x10,%rsp
  8014d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014e1:	eb 0a                	jmp    8014ed <strcmp+0x1c>
		p++, q++;
  8014e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	84 c0                	test   %al,%al
  8014f6:	74 12                	je     80150a <strcmp+0x39>
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 10             	movzbl (%rax),%edx
  8014ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	38 c2                	cmp    %al,%dl
  801508:	74 d9                	je     8014e3 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80150a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150e:	0f b6 00             	movzbl (%rax),%eax
  801511:	0f b6 d0             	movzbl %al,%edx
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	0f b6 c0             	movzbl %al,%eax
  80151e:	29 c2                	sub    %eax,%edx
  801520:	89 d0                	mov    %edx,%eax
}
  801522:	c9                   	leaveq 
  801523:	c3                   	retq   

0000000000801524 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801524:	55                   	push   %rbp
  801525:	48 89 e5             	mov    %rsp,%rbp
  801528:	48 83 ec 18          	sub    $0x18,%rsp
  80152c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801530:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801534:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801538:	eb 0f                	jmp    801549 <strncmp+0x25>
		n--, p++, q++;
  80153a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80153f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801544:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801549:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80154e:	74 1d                	je     80156d <strncmp+0x49>
  801550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801554:	0f b6 00             	movzbl (%rax),%eax
  801557:	84 c0                	test   %al,%al
  801559:	74 12                	je     80156d <strncmp+0x49>
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	0f b6 10             	movzbl (%rax),%edx
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801566:	0f b6 00             	movzbl (%rax),%eax
  801569:	38 c2                	cmp    %al,%dl
  80156b:	74 cd                	je     80153a <strncmp+0x16>
	if (n == 0)
  80156d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801572:	75 07                	jne    80157b <strncmp+0x57>
		return 0;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
  801579:	eb 18                	jmp    801593 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157f:	0f b6 00             	movzbl (%rax),%eax
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	0f b6 c0             	movzbl %al,%eax
  80158f:	29 c2                	sub    %eax,%edx
  801591:	89 d0                	mov    %edx,%eax
}
  801593:	c9                   	leaveq 
  801594:	c3                   	retq   

0000000000801595 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801595:	55                   	push   %rbp
  801596:	48 89 e5             	mov    %rsp,%rbp
  801599:	48 83 ec 10          	sub    $0x10,%rsp
  80159d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a1:	89 f0                	mov    %esi,%eax
  8015a3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015a6:	eb 17                	jmp    8015bf <strchr+0x2a>
		if (*s == c)
  8015a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015b2:	75 06                	jne    8015ba <strchr+0x25>
			return (char *) s;
  8015b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b8:	eb 15                	jmp    8015cf <strchr+0x3a>
	for (; *s; s++)
  8015ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	84 c0                	test   %al,%al
  8015c8:	75 de                	jne    8015a8 <strchr+0x13>
	return 0;
  8015ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cf:	c9                   	leaveq 
  8015d0:	c3                   	retq   

00000000008015d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d1:	55                   	push   %rbp
  8015d2:	48 89 e5             	mov    %rsp,%rbp
  8015d5:	48 83 ec 10          	sub    $0x10,%rsp
  8015d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015dd:	89 f0                	mov    %esi,%eax
  8015df:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015e2:	eb 13                	jmp    8015f7 <strfind+0x26>
		if (*s == c)
  8015e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015ee:	75 02                	jne    8015f2 <strfind+0x21>
			break;
  8015f0:	eb 10                	jmp    801602 <strfind+0x31>
	for (; *s; s++)
  8015f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	84 c0                	test   %al,%al
  801600:	75 e2                	jne    8015e4 <strfind+0x13>
	return (char *) s;
  801602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801606:	c9                   	leaveq 
  801607:	c3                   	retq   

0000000000801608 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	48 83 ec 18          	sub    $0x18,%rsp
  801610:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801614:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801617:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80161b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801620:	75 06                	jne    801628 <memset+0x20>
		return v;
  801622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801626:	eb 69                	jmp    801691 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162c:	83 e0 03             	and    $0x3,%eax
  80162f:	48 85 c0             	test   %rax,%rax
  801632:	75 48                	jne    80167c <memset+0x74>
  801634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801638:	83 e0 03             	and    $0x3,%eax
  80163b:	48 85 c0             	test   %rax,%rax
  80163e:	75 3c                	jne    80167c <memset+0x74>
		c &= 0xFF;
  801640:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801647:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80164a:	c1 e0 18             	shl    $0x18,%eax
  80164d:	89 c2                	mov    %eax,%edx
  80164f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801652:	c1 e0 10             	shl    $0x10,%eax
  801655:	09 c2                	or     %eax,%edx
  801657:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80165a:	c1 e0 08             	shl    $0x8,%eax
  80165d:	09 d0                	or     %edx,%eax
  80165f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801666:	48 c1 e8 02          	shr    $0x2,%rax
  80166a:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80166d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801671:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801674:	48 89 d7             	mov    %rdx,%rdi
  801677:	fc                   	cld    
  801678:	f3 ab                	rep stos %eax,%es:(%rdi)
  80167a:	eb 11                	jmp    80168d <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80167c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801680:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801683:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801687:	48 89 d7             	mov    %rdx,%rdi
  80168a:	fc                   	cld    
  80168b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80168d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801691:	c9                   	leaveq 
  801692:	c3                   	retq   

0000000000801693 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801693:	55                   	push   %rbp
  801694:	48 89 e5             	mov    %rsp,%rbp
  801697:	48 83 ec 28          	sub    $0x28,%rsp
  80169b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80169f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016bf:	0f 83 88 00 00 00    	jae    80174d <memmove+0xba>
  8016c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	48 01 d0             	add    %rdx,%rax
  8016d0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016d4:	76 77                	jbe    80174d <memmove+0xba>
		s += n;
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ea:	83 e0 03             	and    $0x3,%eax
  8016ed:	48 85 c0             	test   %rax,%rax
  8016f0:	75 3b                	jne    80172d <memmove+0x9a>
  8016f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f6:	83 e0 03             	and    $0x3,%eax
  8016f9:	48 85 c0             	test   %rax,%rax
  8016fc:	75 2f                	jne    80172d <memmove+0x9a>
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	83 e0 03             	and    $0x3,%eax
  801705:	48 85 c0             	test   %rax,%rax
  801708:	75 23                	jne    80172d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80170a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170e:	48 83 e8 04          	sub    $0x4,%rax
  801712:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801716:	48 83 ea 04          	sub    $0x4,%rdx
  80171a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80171e:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801722:	48 89 c7             	mov    %rax,%rdi
  801725:	48 89 d6             	mov    %rdx,%rsi
  801728:	fd                   	std    
  801729:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80172b:	eb 1d                	jmp    80174a <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80172d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801731:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801739:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80173d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801741:	48 89 d7             	mov    %rdx,%rdi
  801744:	48 89 c1             	mov    %rax,%rcx
  801747:	fd                   	std    
  801748:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80174a:	fc                   	cld    
  80174b:	eb 57                	jmp    8017a4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80174d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801751:	83 e0 03             	and    $0x3,%eax
  801754:	48 85 c0             	test   %rax,%rax
  801757:	75 36                	jne    80178f <memmove+0xfc>
  801759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175d:	83 e0 03             	and    $0x3,%eax
  801760:	48 85 c0             	test   %rax,%rax
  801763:	75 2a                	jne    80178f <memmove+0xfc>
  801765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801769:	83 e0 03             	and    $0x3,%eax
  80176c:	48 85 c0             	test   %rax,%rax
  80176f:	75 1e                	jne    80178f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	48 c1 e8 02          	shr    $0x2,%rax
  801779:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80177c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801780:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801784:	48 89 c7             	mov    %rax,%rdi
  801787:	48 89 d6             	mov    %rdx,%rsi
  80178a:	fc                   	cld    
  80178b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80178d:	eb 15                	jmp    8017a4 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80178f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801793:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801797:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80179b:	48 89 c7             	mov    %rax,%rdi
  80179e:	48 89 d6             	mov    %rdx,%rsi
  8017a1:	fc                   	cld    
  8017a2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017a8:	c9                   	leaveq 
  8017a9:	c3                   	retq   

00000000008017aa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017aa:	55                   	push   %rbp
  8017ab:	48 89 e5             	mov    %rsp,%rbp
  8017ae:	48 83 ec 18          	sub    $0x18,%rsp
  8017b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ca:	48 89 ce             	mov    %rcx,%rsi
  8017cd:	48 89 c7             	mov    %rax,%rdi
  8017d0:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
}
  8017dc:	c9                   	leaveq 
  8017dd:	c3                   	retq   

00000000008017de <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 28          	sub    $0x28,%rsp
  8017e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801802:	eb 36                	jmp    80183a <memcmp+0x5c>
		if (*s1 != *s2)
  801804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801808:	0f b6 10             	movzbl (%rax),%edx
  80180b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	38 c2                	cmp    %al,%dl
  801814:	74 1a                	je     801830 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181a:	0f b6 00             	movzbl (%rax),%eax
  80181d:	0f b6 d0             	movzbl %al,%edx
  801820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801824:	0f b6 00             	movzbl (%rax),%eax
  801827:	0f b6 c0             	movzbl %al,%eax
  80182a:	29 c2                	sub    %eax,%edx
  80182c:	89 d0                	mov    %edx,%eax
  80182e:	eb 20                	jmp    801850 <memcmp+0x72>
		s1++, s2++;
  801830:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801835:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  80183a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801842:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801846:	48 85 c0             	test   %rax,%rax
  801849:	75 b9                	jne    801804 <memcmp+0x26>
	}

	return 0;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801850:	c9                   	leaveq 
  801851:	c3                   	retq   

0000000000801852 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801852:	55                   	push   %rbp
  801853:	48 89 e5             	mov    %rsp,%rbp
  801856:	48 83 ec 28          	sub    $0x28,%rsp
  80185a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80185e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801861:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801869:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186d:	48 01 d0             	add    %rdx,%rax
  801870:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801874:	eb 15                	jmp    80188b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801880:	38 d0                	cmp    %dl,%al
  801882:	75 02                	jne    801886 <memfind+0x34>
			break;
  801884:	eb 0f                	jmp    801895 <memfind+0x43>
	for (; s < ends; s++)
  801886:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80188b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801893:	72 e1                	jb     801876 <memfind+0x24>
	return (void *) s;
  801895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801899:	c9                   	leaveq 
  80189a:	c3                   	retq   

000000000080189b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80189b:	55                   	push   %rbp
  80189c:	48 89 e5             	mov    %rsp,%rbp
  80189f:	48 83 ec 38          	sub    $0x38,%rsp
  8018a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018ab:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018b5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018bc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018bd:	eb 05                	jmp    8018c4 <strtol+0x29>
		s++;
  8018bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8018c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	3c 20                	cmp    $0x20,%al
  8018cd:	74 f0                	je     8018bf <strtol+0x24>
  8018cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	3c 09                	cmp    $0x9,%al
  8018d8:	74 e5                	je     8018bf <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	3c 2b                	cmp    $0x2b,%al
  8018e3:	75 07                	jne    8018ec <strtol+0x51>
		s++;
  8018e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ea:	eb 17                	jmp    801903 <strtol+0x68>
	else if (*s == '-')
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	3c 2d                	cmp    $0x2d,%al
  8018f5:	75 0c                	jne    801903 <strtol+0x68>
		s++, neg = 1;
  8018f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801903:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801907:	74 06                	je     80190f <strtol+0x74>
  801909:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80190d:	75 28                	jne    801937 <strtol+0x9c>
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	0f b6 00             	movzbl (%rax),%eax
  801916:	3c 30                	cmp    $0x30,%al
  801918:	75 1d                	jne    801937 <strtol+0x9c>
  80191a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191e:	48 83 c0 01          	add    $0x1,%rax
  801922:	0f b6 00             	movzbl (%rax),%eax
  801925:	3c 78                	cmp    $0x78,%al
  801927:	75 0e                	jne    801937 <strtol+0x9c>
		s += 2, base = 16;
  801929:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80192e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801935:	eb 2c                	jmp    801963 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801937:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80193b:	75 19                	jne    801956 <strtol+0xbb>
  80193d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801941:	0f b6 00             	movzbl (%rax),%eax
  801944:	3c 30                	cmp    $0x30,%al
  801946:	75 0e                	jne    801956 <strtol+0xbb>
		s++, base = 8;
  801948:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801954:	eb 0d                	jmp    801963 <strtol+0xc8>
	else if (base == 0)
  801956:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80195a:	75 07                	jne    801963 <strtol+0xc8>
		base = 10;
  80195c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801967:	0f b6 00             	movzbl (%rax),%eax
  80196a:	3c 2f                	cmp    $0x2f,%al
  80196c:	7e 1d                	jle    80198b <strtol+0xf0>
  80196e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801972:	0f b6 00             	movzbl (%rax),%eax
  801975:	3c 39                	cmp    $0x39,%al
  801977:	7f 12                	jg     80198b <strtol+0xf0>
			dig = *s - '0';
  801979:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197d:	0f b6 00             	movzbl (%rax),%eax
  801980:	0f be c0             	movsbl %al,%eax
  801983:	83 e8 30             	sub    $0x30,%eax
  801986:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801989:	eb 4e                	jmp    8019d9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80198b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198f:	0f b6 00             	movzbl (%rax),%eax
  801992:	3c 60                	cmp    $0x60,%al
  801994:	7e 1d                	jle    8019b3 <strtol+0x118>
  801996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199a:	0f b6 00             	movzbl (%rax),%eax
  80199d:	3c 7a                	cmp    $0x7a,%al
  80199f:	7f 12                	jg     8019b3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a5:	0f b6 00             	movzbl (%rax),%eax
  8019a8:	0f be c0             	movsbl %al,%eax
  8019ab:	83 e8 57             	sub    $0x57,%eax
  8019ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019b1:	eb 26                	jmp    8019d9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b7:	0f b6 00             	movzbl (%rax),%eax
  8019ba:	3c 40                	cmp    $0x40,%al
  8019bc:	7e 48                	jle    801a06 <strtol+0x16b>
  8019be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c2:	0f b6 00             	movzbl (%rax),%eax
  8019c5:	3c 5a                	cmp    $0x5a,%al
  8019c7:	7f 3d                	jg     801a06 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8019c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cd:	0f b6 00             	movzbl (%rax),%eax
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	83 e8 37             	sub    $0x37,%eax
  8019d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019dc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019df:	7c 02                	jl     8019e3 <strtol+0x148>
			break;
  8019e1:	eb 23                	jmp    801a06 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8019e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019e8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019eb:	48 98                	cltq   
  8019ed:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019f2:	48 89 c2             	mov    %rax,%rdx
  8019f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019f8:	48 98                	cltq   
  8019fa:	48 01 d0             	add    %rdx,%rax
  8019fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a01:	e9 5d ff ff ff       	jmpq   801963 <strtol+0xc8>

	if (endptr)
  801a06:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a0b:	74 0b                	je     801a18 <strtol+0x17d>
		*endptr = (char *) s;
  801a0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a11:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a15:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a1c:	74 09                	je     801a27 <strtol+0x18c>
  801a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a22:	48 f7 d8             	neg    %rax
  801a25:	eb 04                	jmp    801a2b <strtol+0x190>
  801a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <strstr>:

char * strstr(const char *in, const char *str)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 30          	sub    $0x30,%rsp
  801a35:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a39:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a45:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a49:	0f b6 00             	movzbl (%rax),%eax
  801a4c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a4f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a53:	75 06                	jne    801a5b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	eb 6b                	jmp    801ac6 <strstr+0x99>

	len = strlen(str);
  801a5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a5f:	48 89 c7             	mov    %rax,%rdi
  801a62:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  801a69:	00 00 00 
  801a6c:	ff d0                	callq  *%rax
  801a6e:	48 98                	cltq   
  801a70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a78:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a80:	0f b6 00             	movzbl (%rax),%eax
  801a83:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a86:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a8a:	75 07                	jne    801a93 <strstr+0x66>
				return (char *) 0;
  801a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a91:	eb 33                	jmp    801ac6 <strstr+0x99>
		} while (sc != c);
  801a93:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a97:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a9a:	75 d8                	jne    801a74 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa8:	48 89 ce             	mov    %rcx,%rsi
  801aab:	48 89 c7             	mov    %rax,%rdi
  801aae:	48 b8 24 15 80 00 00 	movabs $0x801524,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
  801aba:	85 c0                	test   %eax,%eax
  801abc:	75 b6                	jne    801a74 <strstr+0x47>

	return (char *) (in - 1);
  801abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac2:	48 83 e8 01          	sub    $0x1,%rax
}
  801ac6:	c9                   	leaveq 
  801ac7:	c3                   	retq   

0000000000801ac8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	53                   	push   %rbx
  801acd:	48 83 ec 48          	sub    $0x48,%rsp
  801ad1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ad4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ad7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801adb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801adf:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ae3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801aea:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801aee:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801af2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801af6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801afa:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801afe:	4c 89 c3             	mov    %r8,%rbx
  801b01:	cd 30                	int    $0x30
  801b03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b07:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b0b:	74 3e                	je     801b4b <syscall+0x83>
  801b0d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b12:	7e 37                	jle    801b4b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b1b:	49 89 d0             	mov    %rdx,%r8
  801b1e:	89 c1                	mov    %eax,%ecx
  801b20:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  801b27:	00 00 00 
  801b2a:	be 23 00 00 00       	mov    $0x23,%esi
  801b2f:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  801b36:	00 00 00 
  801b39:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3e:	49 b9 9c 05 80 00 00 	movabs $0x80059c,%r9
  801b45:	00 00 00 
  801b48:	41 ff d1             	callq  *%r9

	return ret;
  801b4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b4f:	48 83 c4 48          	add    $0x48,%rsp
  801b53:	5b                   	pop    %rbx
  801b54:	5d                   	pop    %rbp
  801b55:	c3                   	retq   

0000000000801b56 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b56:	55                   	push   %rbp
  801b57:	48 89 e5             	mov    %rsp,%rbp
  801b5a:	48 83 ec 10          	sub    $0x10,%rsp
  801b5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6e:	48 83 ec 08          	sub    $0x8,%rsp
  801b72:	6a 00                	pushq  $0x0
  801b74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b80:	48 89 d1             	mov    %rdx,%rcx
  801b83:	48 89 c2             	mov    %rax,%rdx
  801b86:	be 00 00 00 00       	mov    $0x0,%esi
  801b8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b90:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	callq  *%rax
  801b9c:	48 83 c4 10          	add    $0x10,%rsp
}
  801ba0:	c9                   	leaveq 
  801ba1:	c3                   	retq   

0000000000801ba2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ba2:	55                   	push   %rbp
  801ba3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ba6:	48 83 ec 08          	sub    $0x8,%rsp
  801baa:	6a 00                	pushq  $0x0
  801bac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc2:	be 00 00 00 00       	mov    $0x0,%esi
  801bc7:	bf 01 00 00 00       	mov    $0x1,%edi
  801bcc:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801bd3:	00 00 00 
  801bd6:	ff d0                	callq  *%rax
  801bd8:	48 83 c4 10          	add    $0x10,%rsp
}
  801bdc:	c9                   	leaveq 
  801bdd:	c3                   	retq   

0000000000801bde <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bde:	55                   	push   %rbp
  801bdf:	48 89 e5             	mov    %rsp,%rbp
  801be2:	48 83 ec 10          	sub    $0x10,%rsp
  801be6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bec:	48 98                	cltq   
  801bee:	48 83 ec 08          	sub    $0x8,%rsp
  801bf2:	6a 00                	pushq  $0x0
  801bf4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c00:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c05:	48 89 c2             	mov    %rax,%rdx
  801c08:	be 01 00 00 00       	mov    $0x1,%esi
  801c0d:	bf 03 00 00 00       	mov    $0x3,%edi
  801c12:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801c19:	00 00 00 
  801c1c:	ff d0                	callq  *%rax
  801c1e:	48 83 c4 10          	add    $0x10,%rsp
}
  801c22:	c9                   	leaveq 
  801c23:	c3                   	retq   

0000000000801c24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c24:	55                   	push   %rbp
  801c25:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c28:	48 83 ec 08          	sub    $0x8,%rsp
  801c2c:	6a 00                	pushq  $0x0
  801c2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c44:	be 00 00 00 00       	mov    $0x0,%esi
  801c49:	bf 02 00 00 00       	mov    $0x2,%edi
  801c4e:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	callq  *%rax
  801c5a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c5e:	c9                   	leaveq 
  801c5f:	c3                   	retq   

0000000000801c60 <sys_yield>:

void
sys_yield(void)
{
  801c60:	55                   	push   %rbp
  801c61:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c64:	48 83 ec 08          	sub    $0x8,%rsp
  801c68:	6a 00                	pushq  $0x0
  801c6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c76:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c80:	be 00 00 00 00       	mov    $0x0,%esi
  801c85:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c8a:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	callq  *%rax
  801c96:	48 83 c4 10          	add    $0x10,%rsp
}
  801c9a:	c9                   	leaveq 
  801c9b:	c3                   	retq   

0000000000801c9c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	48 83 ec 10          	sub    $0x10,%rsp
  801ca4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cab:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cb1:	48 63 c8             	movslq %eax,%rcx
  801cb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbb:	48 98                	cltq   
  801cbd:	48 83 ec 08          	sub    $0x8,%rsp
  801cc1:	6a 00                	pushq  $0x0
  801cc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc9:	49 89 c8             	mov    %rcx,%r8
  801ccc:	48 89 d1             	mov    %rdx,%rcx
  801ccf:	48 89 c2             	mov    %rax,%rdx
  801cd2:	be 01 00 00 00       	mov    $0x1,%esi
  801cd7:	bf 04 00 00 00       	mov    $0x4,%edi
  801cdc:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801ce3:	00 00 00 
  801ce6:	ff d0                	callq  *%rax
  801ce8:	48 83 c4 10          	add    $0x10,%rsp
}
  801cec:	c9                   	leaveq 
  801ced:	c3                   	retq   

0000000000801cee <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	48 83 ec 20          	sub    $0x20,%rsp
  801cf6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d00:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d04:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d08:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d0b:	48 63 c8             	movslq %eax,%rcx
  801d0e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d15:	48 63 f0             	movslq %eax,%rsi
  801d18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1f:	48 98                	cltq   
  801d21:	48 83 ec 08          	sub    $0x8,%rsp
  801d25:	51                   	push   %rcx
  801d26:	49 89 f9             	mov    %rdi,%r9
  801d29:	49 89 f0             	mov    %rsi,%r8
  801d2c:	48 89 d1             	mov    %rdx,%rcx
  801d2f:	48 89 c2             	mov    %rax,%rdx
  801d32:	be 01 00 00 00       	mov    $0x1,%esi
  801d37:	bf 05 00 00 00       	mov    $0x5,%edi
  801d3c:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	callq  *%rax
  801d48:	48 83 c4 10          	add    $0x10,%rsp
}
  801d4c:	c9                   	leaveq 
  801d4d:	c3                   	retq   

0000000000801d4e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d4e:	55                   	push   %rbp
  801d4f:	48 89 e5             	mov    %rsp,%rbp
  801d52:	48 83 ec 10          	sub    $0x10,%rsp
  801d56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d64:	48 98                	cltq   
  801d66:	48 83 ec 08          	sub    $0x8,%rsp
  801d6a:	6a 00                	pushq  $0x0
  801d6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d78:	48 89 d1             	mov    %rdx,%rcx
  801d7b:	48 89 c2             	mov    %rax,%rdx
  801d7e:	be 01 00 00 00       	mov    $0x1,%esi
  801d83:	bf 06 00 00 00       	mov    $0x6,%edi
  801d88:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
  801d94:	48 83 c4 10          	add    $0x10,%rsp
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 10          	sub    $0x10,%rsp
  801da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801da8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dab:	48 63 d0             	movslq %eax,%rdx
  801dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db1:	48 98                	cltq   
  801db3:	48 83 ec 08          	sub    $0x8,%rsp
  801db7:	6a 00                	pushq  $0x0
  801db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc5:	48 89 d1             	mov    %rdx,%rcx
  801dc8:	48 89 c2             	mov    %rax,%rdx
  801dcb:	be 01 00 00 00       	mov    $0x1,%esi
  801dd0:	bf 08 00 00 00       	mov    $0x8,%edi
  801dd5:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801ddc:	00 00 00 
  801ddf:	ff d0                	callq  *%rax
  801de1:	48 83 c4 10          	add    $0x10,%rsp
}
  801de5:	c9                   	leaveq 
  801de6:	c3                   	retq   

0000000000801de7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801de7:	55                   	push   %rbp
  801de8:	48 89 e5             	mov    %rsp,%rbp
  801deb:	48 83 ec 10          	sub    $0x10,%rsp
  801def:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801df6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfd:	48 98                	cltq   
  801dff:	48 83 ec 08          	sub    $0x8,%rsp
  801e03:	6a 00                	pushq  $0x0
  801e05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e11:	48 89 d1             	mov    %rdx,%rcx
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	be 01 00 00 00       	mov    $0x1,%esi
  801e1c:	bf 09 00 00 00       	mov    $0x9,%edi
  801e21:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	callq  *%rax
  801e2d:	48 83 c4 10          	add    $0x10,%rsp
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 10          	sub    $0x10,%rsp
  801e3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e49:	48 98                	cltq   
  801e4b:	48 83 ec 08          	sub    $0x8,%rsp
  801e4f:	6a 00                	pushq  $0x0
  801e51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5d:	48 89 d1             	mov    %rdx,%rcx
  801e60:	48 89 c2             	mov    %rax,%rdx
  801e63:	be 01 00 00 00       	mov    $0x1,%esi
  801e68:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e6d:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
  801e79:	48 83 c4 10          	add    $0x10,%rsp
}
  801e7d:	c9                   	leaveq 
  801e7e:	c3                   	retq   

0000000000801e7f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e7f:	55                   	push   %rbp
  801e80:	48 89 e5             	mov    %rsp,%rbp
  801e83:	48 83 ec 20          	sub    $0x20,%rsp
  801e87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e8e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e92:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e98:	48 63 f0             	movslq %eax,%rsi
  801e9b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea2:	48 98                	cltq   
  801ea4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea8:	48 83 ec 08          	sub    $0x8,%rsp
  801eac:	6a 00                	pushq  $0x0
  801eae:	49 89 f1             	mov    %rsi,%r9
  801eb1:	49 89 c8             	mov    %rcx,%r8
  801eb4:	48 89 d1             	mov    %rdx,%rcx
  801eb7:	48 89 c2             	mov    %rax,%rdx
  801eba:	be 00 00 00 00       	mov    $0x0,%esi
  801ebf:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ec4:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801ecb:	00 00 00 
  801ece:	ff d0                	callq  *%rax
  801ed0:	48 83 c4 10          	add    $0x10,%rsp
}
  801ed4:	c9                   	leaveq 
  801ed5:	c3                   	retq   

0000000000801ed6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ed6:	55                   	push   %rbp
  801ed7:	48 89 e5             	mov    %rsp,%rbp
  801eda:	48 83 ec 10          	sub    $0x10,%rsp
  801ede:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee6:	48 83 ec 08          	sub    $0x8,%rsp
  801eea:	6a 00                	pushq  $0x0
  801eec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801efd:	48 89 c2             	mov    %rax,%rdx
  801f00:	be 01 00 00 00       	mov    $0x1,%esi
  801f05:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f0a:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	48 83 c4 10          	add    $0x10,%rsp
}
  801f1a:	c9                   	leaveq 
  801f1b:	c3                   	retq   

0000000000801f1c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f1c:	55                   	push   %rbp
  801f1d:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f20:	48 83 ec 08          	sub    $0x8,%rsp
  801f24:	6a 00                	pushq  $0x0
  801f26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f32:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f37:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3c:	be 00 00 00 00       	mov    $0x0,%esi
  801f41:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f46:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801f4d:	00 00 00 
  801f50:	ff d0                	callq  *%rax
  801f52:	48 83 c4 10          	add    $0x10,%rsp
}
  801f56:	c9                   	leaveq 
  801f57:	c3                   	retq   

0000000000801f58 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f58:	55                   	push   %rbp
  801f59:	48 89 e5             	mov    %rsp,%rbp
  801f5c:	48 83 ec 20          	sub    $0x20,%rsp
  801f60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f67:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f6a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f6e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801f72:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f75:	48 63 c8             	movslq %eax,%rcx
  801f78:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7f:	48 63 f0             	movslq %eax,%rsi
  801f82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f89:	48 98                	cltq   
  801f8b:	48 83 ec 08          	sub    $0x8,%rsp
  801f8f:	51                   	push   %rcx
  801f90:	49 89 f9             	mov    %rdi,%r9
  801f93:	49 89 f0             	mov    %rsi,%r8
  801f96:	48 89 d1             	mov    %rdx,%rcx
  801f99:	48 89 c2             	mov    %rax,%rdx
  801f9c:	be 00 00 00 00       	mov    $0x0,%esi
  801fa1:	bf 0f 00 00 00       	mov    $0xf,%edi
  801fa6:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
  801fb2:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801fb6:	c9                   	leaveq 
  801fb7:	c3                   	retq   

0000000000801fb8 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	48 83 ec 10          	sub    $0x10,%rsp
  801fc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801fc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd0:	48 83 ec 08          	sub    $0x8,%rsp
  801fd4:	6a 00                	pushq  $0x0
  801fd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fdc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe2:	48 89 d1             	mov    %rdx,%rcx
  801fe5:	48 89 c2             	mov    %rax,%rdx
  801fe8:	be 00 00 00 00       	mov    $0x0,%esi
  801fed:	bf 10 00 00 00       	mov    $0x10,%edi
  801ff2:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	48 83 c4 10          	add    $0x10,%rsp
}
  802002:	c9                   	leaveq 
  802003:	c3                   	retq   

0000000000802004 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  802004:	55                   	push   %rbp
  802005:	48 89 e5             	mov    %rsp,%rbp
  802008:	48 83 ec 18          	sub    $0x18,%rsp
  80200c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802010:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802014:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802020:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  802023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802027:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80202b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80202f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802033:	8b 00                	mov    (%rax),%eax
  802035:	83 f8 01             	cmp    $0x1,%eax
  802038:	7e 13                	jle    80204d <argstart+0x49>
  80203a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80203f:	74 0c                	je     80204d <argstart+0x49>
  802041:	48 b8 73 4d 80 00 00 	movabs $0x804d73,%rax
  802048:	00 00 00 
  80204b:	eb 05                	jmp    802052 <argstart+0x4e>
  80204d:	b8 00 00 00 00       	mov    $0x0,%eax
  802052:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802056:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  80205a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802065:	00 
}
  802066:	c9                   	leaveq 
  802067:	c3                   	retq   

0000000000802068 <argnext>:

int
argnext(struct Argstate *args)
{
  802068:	55                   	push   %rbp
  802069:	48 89 e5             	mov    %rsp,%rbp
  80206c:	48 83 ec 20          	sub    $0x20,%rsp
  802070:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  802074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802078:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80207f:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	48 8b 40 10          	mov    0x10(%rax),%rax
  802088:	48 85 c0             	test   %rax,%rax
  80208b:	75 0a                	jne    802097 <argnext+0x2f>
		return -1;
  80208d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802092:	e9 25 01 00 00       	jmpq   8021bc <argnext+0x154>

	if (!*args->curarg) {
  802097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80209f:	0f b6 00             	movzbl (%rax),%eax
  8020a2:	84 c0                	test   %al,%al
  8020a4:	0f 85 d7 00 00 00    	jne    802181 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8020aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ae:	48 8b 00             	mov    (%rax),%rax
  8020b1:	8b 00                	mov    (%rax),%eax
  8020b3:	83 f8 01             	cmp    $0x1,%eax
  8020b6:	0f 84 ef 00 00 00    	je     8021ab <argnext+0x143>
		    || args->argv[1][0] != '-'
  8020bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020c4:	48 83 c0 08          	add    $0x8,%rax
  8020c8:	48 8b 00             	mov    (%rax),%rax
  8020cb:	0f b6 00             	movzbl (%rax),%eax
  8020ce:	3c 2d                	cmp    $0x2d,%al
  8020d0:	0f 85 d5 00 00 00    	jne    8021ab <argnext+0x143>
		    || args->argv[1][1] == '\0')
  8020d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020da:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020de:	48 83 c0 08          	add    $0x8,%rax
  8020e2:	48 8b 00             	mov    (%rax),%rax
  8020e5:	48 83 c0 01          	add    $0x1,%rax
  8020e9:	0f b6 00             	movzbl (%rax),%eax
  8020ec:	84 c0                	test   %al,%al
  8020ee:	0f 84 b7 00 00 00    	je     8021ab <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8020f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020fc:	48 83 c0 08          	add    $0x8,%rax
  802100:	48 8b 00             	mov    (%rax),%rax
  802103:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210b:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80210f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802113:	48 8b 00             	mov    (%rax),%rax
  802116:	8b 00                	mov    (%rax),%eax
  802118:	83 e8 01             	sub    $0x1,%eax
  80211b:	48 98                	cltq   
  80211d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802124:	00 
  802125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802129:	48 8b 40 08          	mov    0x8(%rax),%rax
  80212d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802131:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802135:	48 8b 40 08          	mov    0x8(%rax),%rax
  802139:	48 83 c0 08          	add    $0x8,%rax
  80213d:	48 89 ce             	mov    %rcx,%rsi
  802140:	48 89 c7             	mov    %rax,%rdi
  802143:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
		(*args->argc)--;
  80214f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802153:	48 8b 00             	mov    (%rax),%rax
  802156:	8b 10                	mov    (%rax),%edx
  802158:	83 ea 01             	sub    $0x1,%edx
  80215b:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80215d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802161:	48 8b 40 10          	mov    0x10(%rax),%rax
  802165:	0f b6 00             	movzbl (%rax),%eax
  802168:	3c 2d                	cmp    $0x2d,%al
  80216a:	75 15                	jne    802181 <argnext+0x119>
  80216c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802170:	48 8b 40 10          	mov    0x10(%rax),%rax
  802174:	48 83 c0 01          	add    $0x1,%rax
  802178:	0f b6 00             	movzbl (%rax),%eax
  80217b:	84 c0                	test   %al,%al
  80217d:	75 02                	jne    802181 <argnext+0x119>
			goto endofargs;
  80217f:	eb 2a                	jmp    8021ab <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  802181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802185:	48 8b 40 10          	mov    0x10(%rax),%rax
  802189:	0f b6 00             	movzbl (%rax),%eax
  80218c:	0f b6 c0             	movzbl %al,%eax
  80218f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	48 8b 40 10          	mov    0x10(%rax),%rax
  80219a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80219e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8021a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a9:	eb 11                	jmp    8021bc <argnext+0x154>

endofargs:
	args->curarg = 0;
  8021ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021af:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8021b6:	00 
	return -1;
  8021b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8021bc:	c9                   	leaveq 
  8021bd:	c3                   	retq   

00000000008021be <argvalue>:

char *
argvalue(struct Argstate *args)
{
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	48 83 ec 10          	sub    $0x10,%rsp
  8021c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8021ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021d2:	48 85 c0             	test   %rax,%rax
  8021d5:	74 0a                	je     8021e1 <argvalue+0x23>
  8021d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021db:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021df:	eb 13                	jmp    8021f4 <argvalue+0x36>
  8021e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e5:	48 89 c7             	mov    %rax,%rdi
  8021e8:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
}
  8021f4:	c9                   	leaveq 
  8021f5:	c3                   	retq   

00000000008021f6 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  8021f6:	55                   	push   %rbp
  8021f7:	48 89 e5             	mov    %rsp,%rbp
  8021fa:	48 83 ec 10          	sub    $0x10,%rsp
  8021fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  802202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802206:	48 8b 40 10          	mov    0x10(%rax),%rax
  80220a:	48 85 c0             	test   %rax,%rax
  80220d:	75 0a                	jne    802219 <argnextvalue+0x23>
		return 0;
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	e9 c8 00 00 00       	jmpq   8022e1 <argnextvalue+0xeb>
	if (*args->curarg) {
  802219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802221:	0f b6 00             	movzbl (%rax),%eax
  802224:	84 c0                	test   %al,%al
  802226:	74 27                	je     80224f <argnextvalue+0x59>
		args->argvalue = args->curarg;
  802228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802234:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  802238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223c:	48 be 73 4d 80 00 00 	movabs $0x804d73,%rsi
  802243:	00 00 00 
  802246:	48 89 70 10          	mov    %rsi,0x10(%rax)
  80224a:	e9 8a 00 00 00       	jmpq   8022d9 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  80224f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802253:	48 8b 00             	mov    (%rax),%rax
  802256:	8b 00                	mov    (%rax),%eax
  802258:	83 f8 01             	cmp    $0x1,%eax
  80225b:	7e 64                	jle    8022c1 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  80225d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802261:	48 8b 40 08          	mov    0x8(%rax),%rax
  802265:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80226d:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802275:	48 8b 00             	mov    (%rax),%rax
  802278:	8b 00                	mov    (%rax),%eax
  80227a:	83 e8 01             	sub    $0x1,%eax
  80227d:	48 98                	cltq   
  80227f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802286:	00 
  802287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80228f:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802297:	48 8b 40 08          	mov    0x8(%rax),%rax
  80229b:	48 83 c0 08          	add    $0x8,%rax
  80229f:	48 89 ce             	mov    %rcx,%rsi
  8022a2:	48 89 c7             	mov    %rax,%rdi
  8022a5:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
		(*args->argc)--;
  8022b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b5:	48 8b 00             	mov    (%rax),%rax
  8022b8:	8b 10                	mov    (%rax),%edx
  8022ba:	83 ea 01             	sub    $0x1,%edx
  8022bd:	89 10                	mov    %edx,(%rax)
  8022bf:	eb 18                	jmp    8022d9 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  8022c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c5:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8022cc:	00 
		args->curarg = 0;
  8022cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d1:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8022d8:	00 
	}
	return (char*) args->argvalue;
  8022d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022dd:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  8022e1:	c9                   	leaveq 
  8022e2:	c3                   	retq   

00000000008022e3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022e3:	55                   	push   %rbp
  8022e4:	48 89 e5             	mov    %rsp,%rbp
  8022e7:	48 83 ec 08          	sub    $0x8,%rsp
  8022eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022f3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8022fa:	ff ff ff 
  8022fd:	48 01 d0             	add    %rdx,%rax
  802300:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802304:	c9                   	leaveq 
  802305:	c3                   	retq   

0000000000802306 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802306:	55                   	push   %rbp
  802307:	48 89 e5             	mov    %rsp,%rbp
  80230a:	48 83 ec 08          	sub    $0x8,%rsp
  80230e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802316:	48 89 c7             	mov    %rax,%rdi
  802319:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  802320:	00 00 00 
  802323:	ff d0                	callq  *%rax
  802325:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80232b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80232f:	c9                   	leaveq 
  802330:	c3                   	retq   

0000000000802331 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802331:	55                   	push   %rbp
  802332:	48 89 e5             	mov    %rsp,%rbp
  802335:	48 83 ec 18          	sub    $0x18,%rsp
  802339:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80233d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802344:	eb 6b                	jmp    8023b1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802349:	48 98                	cltq   
  80234b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802351:	48 c1 e0 0c          	shl    $0xc,%rax
  802355:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235d:	48 c1 e8 15          	shr    $0x15,%rax
  802361:	48 89 c2             	mov    %rax,%rdx
  802364:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80236b:	01 00 00 
  80236e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802372:	83 e0 01             	and    $0x1,%eax
  802375:	48 85 c0             	test   %rax,%rax
  802378:	74 21                	je     80239b <fd_alloc+0x6a>
  80237a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237e:	48 c1 e8 0c          	shr    $0xc,%rax
  802382:	48 89 c2             	mov    %rax,%rdx
  802385:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80238c:	01 00 00 
  80238f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802393:	83 e0 01             	and    $0x1,%eax
  802396:	48 85 c0             	test   %rax,%rax
  802399:	75 12                	jne    8023ad <fd_alloc+0x7c>
			*fd_store = fd;
  80239b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ab:	eb 1a                	jmp    8023c7 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  8023ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023b5:	7e 8f                	jle    802346 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023c2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023c7:	c9                   	leaveq 
  8023c8:	c3                   	retq   

00000000008023c9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023c9:	55                   	push   %rbp
  8023ca:	48 89 e5             	mov    %rsp,%rbp
  8023cd:	48 83 ec 20          	sub    $0x20,%rsp
  8023d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023dc:	78 06                	js     8023e4 <fd_lookup+0x1b>
  8023de:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023e2:	7e 07                	jle    8023eb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023e9:	eb 6c                	jmp    802457 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ee:	48 98                	cltq   
  8023f0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023f6:	48 c1 e0 0c          	shl    $0xc,%rax
  8023fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8023fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802402:	48 c1 e8 15          	shr    $0x15,%rax
  802406:	48 89 c2             	mov    %rax,%rdx
  802409:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802410:	01 00 00 
  802413:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802417:	83 e0 01             	and    $0x1,%eax
  80241a:	48 85 c0             	test   %rax,%rax
  80241d:	74 21                	je     802440 <fd_lookup+0x77>
  80241f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802423:	48 c1 e8 0c          	shr    $0xc,%rax
  802427:	48 89 c2             	mov    %rax,%rdx
  80242a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802431:	01 00 00 
  802434:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802438:	83 e0 01             	and    $0x1,%eax
  80243b:	48 85 c0             	test   %rax,%rax
  80243e:	75 07                	jne    802447 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802440:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802445:	eb 10                	jmp    802457 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80244b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80244f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802457:	c9                   	leaveq 
  802458:	c3                   	retq   

0000000000802459 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802459:	55                   	push   %rbp
  80245a:	48 89 e5             	mov    %rsp,%rbp
  80245d:	48 83 ec 30          	sub    $0x30,%rsp
  802461:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802465:	89 f0                	mov    %esi,%eax
  802467:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80246a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80246e:	48 89 c7             	mov    %rax,%rdi
  802471:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	89 c2                	mov    %eax,%edx
  80247f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802483:	48 89 c6             	mov    %rax,%rsi
  802486:	89 d7                	mov    %edx,%edi
  802488:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  80248f:	00 00 00 
  802492:	ff d0                	callq  *%rax
  802494:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802497:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249b:	78 0a                	js     8024a7 <fd_close+0x4e>
	    || fd != fd2)
  80249d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024a5:	74 12                	je     8024b9 <fd_close+0x60>
		return (must_exist ? r : 0);
  8024a7:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024ab:	74 05                	je     8024b2 <fd_close+0x59>
  8024ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b0:	eb 70                	jmp    802522 <fd_close+0xc9>
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	eb 69                	jmp    802522 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024bd:	8b 00                	mov    (%rax),%eax
  8024bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024c3:	48 89 d6             	mov    %rdx,%rsi
  8024c6:	89 c7                	mov    %eax,%edi
  8024c8:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  8024cf:	00 00 00 
  8024d2:	ff d0                	callq  *%rax
  8024d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024db:	78 2a                	js     802507 <fd_close+0xae>
		if (dev->dev_close)
  8024dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024e5:	48 85 c0             	test   %rax,%rax
  8024e8:	74 16                	je     802500 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8024ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ee:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024f6:	48 89 d7             	mov    %rdx,%rdi
  8024f9:	ff d0                	callq  *%rax
  8024fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024fe:	eb 07                	jmp    802507 <fd_close+0xae>
		else
			r = 0;
  802500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80250b:	48 89 c6             	mov    %rax,%rsi
  80250e:	bf 00 00 00 00       	mov    $0x0,%edi
  802513:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  80251a:	00 00 00 
  80251d:	ff d0                	callq  *%rax
	return r;
  80251f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802522:	c9                   	leaveq 
  802523:	c3                   	retq   

0000000000802524 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802524:	55                   	push   %rbp
  802525:	48 89 e5             	mov    %rsp,%rbp
  802528:	48 83 ec 20          	sub    $0x20,%rsp
  80252c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80252f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802533:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80253a:	eb 41                	jmp    80257d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80253c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802543:	00 00 00 
  802546:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802549:	48 63 d2             	movslq %edx,%rdx
  80254c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802550:	8b 00                	mov    (%rax),%eax
  802552:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802555:	75 22                	jne    802579 <dev_lookup+0x55>
			*dev = devtab[i];
  802557:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80255e:	00 00 00 
  802561:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802564:	48 63 d2             	movslq %edx,%rdx
  802567:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80256b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802572:	b8 00 00 00 00       	mov    $0x0,%eax
  802577:	eb 60                	jmp    8025d9 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802579:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80257d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802584:	00 00 00 
  802587:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80258a:	48 63 d2             	movslq %edx,%rdx
  80258d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802591:	48 85 c0             	test   %rax,%rax
  802594:	75 a6                	jne    80253c <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802596:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  80259d:	00 00 00 
  8025a0:	48 8b 00             	mov    (%rax),%rax
  8025a3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025a9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025ac:	89 c6                	mov    %eax,%esi
  8025ae:	48 bf 78 4d 80 00 00 	movabs $0x804d78,%rdi
  8025b5:	00 00 00 
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bd:	48 b9 d5 07 80 00 00 	movabs $0x8007d5,%rcx
  8025c4:	00 00 00 
  8025c7:	ff d1                	callq  *%rcx
	*dev = 0;
  8025c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025cd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025d9:	c9                   	leaveq 
  8025da:	c3                   	retq   

00000000008025db <close>:

int
close(int fdnum)
{
  8025db:	55                   	push   %rbp
  8025dc:	48 89 e5             	mov    %rsp,%rbp
  8025df:	48 83 ec 20          	sub    $0x20,%rsp
  8025e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ed:	48 89 d6             	mov    %rdx,%rsi
  8025f0:	89 c7                	mov    %eax,%edi
  8025f2:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax
  8025fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802605:	79 05                	jns    80260c <close+0x31>
		return r;
  802607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260a:	eb 18                	jmp    802624 <close+0x49>
	else
		return fd_close(fd, 1);
  80260c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802610:	be 01 00 00 00       	mov    $0x1,%esi
  802615:	48 89 c7             	mov    %rax,%rdi
  802618:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  80261f:	00 00 00 
  802622:	ff d0                	callq  *%rax
}
  802624:	c9                   	leaveq 
  802625:	c3                   	retq   

0000000000802626 <close_all>:

void
close_all(void)
{
  802626:	55                   	push   %rbp
  802627:	48 89 e5             	mov    %rsp,%rbp
  80262a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80262e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802635:	eb 15                	jmp    80264c <close_all+0x26>
		close(i);
  802637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263a:	89 c7                	mov    %eax,%edi
  80263c:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802648:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80264c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802650:	7e e5                	jle    802637 <close_all+0x11>
}
  802652:	c9                   	leaveq 
  802653:	c3                   	retq   

0000000000802654 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	48 83 ec 40          	sub    $0x40,%rsp
  80265c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80265f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802662:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802666:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802669:	48 89 d6             	mov    %rdx,%rsi
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802681:	79 08                	jns    80268b <dup+0x37>
		return r;
  802683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802686:	e9 70 01 00 00       	jmpq   8027fb <dup+0x1a7>
	close(newfdnum);
  80268b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80268e:	89 c7                	mov    %eax,%edi
  802690:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802697:	00 00 00 
  80269a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80269c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80269f:	48 98                	cltq   
  8026a1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026a7:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b3:	48 89 c7             	mov    %rax,%rdi
  8026b6:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ca:	48 89 c7             	mov    %rax,%rdi
  8026cd:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
  8026d9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e1:	48 c1 e8 15          	shr    $0x15,%rax
  8026e5:	48 89 c2             	mov    %rax,%rdx
  8026e8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026ef:	01 00 00 
  8026f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f6:	83 e0 01             	and    $0x1,%eax
  8026f9:	48 85 c0             	test   %rax,%rax
  8026fc:	74 73                	je     802771 <dup+0x11d>
  8026fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802702:	48 c1 e8 0c          	shr    $0xc,%rax
  802706:	48 89 c2             	mov    %rax,%rdx
  802709:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802710:	01 00 00 
  802713:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802717:	83 e0 01             	and    $0x1,%eax
  80271a:	48 85 c0             	test   %rax,%rax
  80271d:	74 52                	je     802771 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80271f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802723:	48 c1 e8 0c          	shr    $0xc,%rax
  802727:	48 89 c2             	mov    %rax,%rdx
  80272a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802731:	01 00 00 
  802734:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802738:	25 07 0e 00 00       	and    $0xe07,%eax
  80273d:	89 c1                	mov    %eax,%ecx
  80273f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802747:	41 89 c8             	mov    %ecx,%r8d
  80274a:	48 89 d1             	mov    %rdx,%rcx
  80274d:	ba 00 00 00 00       	mov    $0x0,%edx
  802752:	48 89 c6             	mov    %rax,%rsi
  802755:	bf 00 00 00 00       	mov    $0x0,%edi
  80275a:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  802761:	00 00 00 
  802764:	ff d0                	callq  *%rax
  802766:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276d:	79 02                	jns    802771 <dup+0x11d>
			goto err;
  80276f:	eb 57                	jmp    8027c8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802775:	48 c1 e8 0c          	shr    $0xc,%rax
  802779:	48 89 c2             	mov    %rax,%rdx
  80277c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802783:	01 00 00 
  802786:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278a:	25 07 0e 00 00       	and    $0xe07,%eax
  80278f:	89 c1                	mov    %eax,%ecx
  802791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802795:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802799:	41 89 c8             	mov    %ecx,%r8d
  80279c:	48 89 d1             	mov    %rdx,%rcx
  80279f:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a4:	48 89 c6             	mov    %rax,%rsi
  8027a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ac:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
  8027b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bf:	79 02                	jns    8027c3 <dup+0x16f>
		goto err;
  8027c1:	eb 05                	jmp    8027c8 <dup+0x174>

	return newfdnum;
  8027c3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027c6:	eb 33                	jmp    8027fb <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cc:	48 89 c6             	mov    %rax,%rsi
  8027cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d4:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e4:	48 89 c6             	mov    %rax,%rsi
  8027e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ec:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
	return r;
  8027f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027fb:	c9                   	leaveq 
  8027fc:	c3                   	retq   

00000000008027fd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8027fd:	55                   	push   %rbp
  8027fe:	48 89 e5             	mov    %rsp,%rbp
  802801:	48 83 ec 40          	sub    $0x40,%rsp
  802805:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802808:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80280c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802810:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802814:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802817:	48 89 d6             	mov    %rdx,%rsi
  80281a:	89 c7                	mov    %eax,%edi
  80281c:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802823:	00 00 00 
  802826:	ff d0                	callq  *%rax
  802828:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282f:	78 24                	js     802855 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802835:	8b 00                	mov    (%rax),%eax
  802837:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80283b:	48 89 d6             	mov    %rdx,%rsi
  80283e:	89 c7                	mov    %eax,%edi
  802840:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
  80284c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802853:	79 05                	jns    80285a <read+0x5d>
		return r;
  802855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802858:	eb 76                	jmp    8028d0 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80285a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285e:	8b 40 08             	mov    0x8(%rax),%eax
  802861:	83 e0 03             	and    $0x3,%eax
  802864:	83 f8 01             	cmp    $0x1,%eax
  802867:	75 3a                	jne    8028a3 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802869:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  802870:	00 00 00 
  802873:	48 8b 00             	mov    (%rax),%rax
  802876:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80287c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80287f:	89 c6                	mov    %eax,%esi
  802881:	48 bf 97 4d 80 00 00 	movabs $0x804d97,%rdi
  802888:	00 00 00 
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
  802890:	48 b9 d5 07 80 00 00 	movabs $0x8007d5,%rcx
  802897:	00 00 00 
  80289a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80289c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a1:	eb 2d                	jmp    8028d0 <read+0xd3>
	}
	if (!dev->dev_read)
  8028a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028ab:	48 85 c0             	test   %rax,%rax
  8028ae:	75 07                	jne    8028b7 <read+0xba>
		return -E_NOT_SUPP;
  8028b0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b5:	eb 19                	jmp    8028d0 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028bf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028c3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028c7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028cb:	48 89 cf             	mov    %rcx,%rdi
  8028ce:	ff d0                	callq  *%rax
}
  8028d0:	c9                   	leaveq 
  8028d1:	c3                   	retq   

00000000008028d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028d2:	55                   	push   %rbp
  8028d3:	48 89 e5             	mov    %rsp,%rbp
  8028d6:	48 83 ec 30          	sub    $0x30,%rsp
  8028da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028ec:	eb 49                	jmp    802937 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f1:	48 98                	cltq   
  8028f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f7:	48 29 c2             	sub    %rax,%rdx
  8028fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fd:	48 63 c8             	movslq %eax,%rcx
  802900:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802904:	48 01 c1             	add    %rax,%rcx
  802907:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80290a:	48 89 ce             	mov    %rcx,%rsi
  80290d:	89 c7                	mov    %eax,%edi
  80290f:	48 b8 fd 27 80 00 00 	movabs $0x8027fd,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80291e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802922:	79 05                	jns    802929 <readn+0x57>
			return m;
  802924:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802927:	eb 1c                	jmp    802945 <readn+0x73>
		if (m == 0)
  802929:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80292d:	75 02                	jne    802931 <readn+0x5f>
			break;
  80292f:	eb 11                	jmp    802942 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802931:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802934:	01 45 fc             	add    %eax,-0x4(%rbp)
  802937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293a:	48 98                	cltq   
  80293c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802940:	72 ac                	jb     8028ee <readn+0x1c>
	}
	return tot;
  802942:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802945:	c9                   	leaveq 
  802946:	c3                   	retq   

0000000000802947 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802947:	55                   	push   %rbp
  802948:	48 89 e5             	mov    %rsp,%rbp
  80294b:	48 83 ec 40          	sub    $0x40,%rsp
  80294f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802952:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802956:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80295a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80295e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802961:	48 89 d6             	mov    %rdx,%rsi
  802964:	89 c7                	mov    %eax,%edi
  802966:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  80296d:	00 00 00 
  802970:	ff d0                	callq  *%rax
  802972:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802975:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802979:	78 24                	js     80299f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297f:	8b 00                	mov    (%rax),%eax
  802981:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802985:	48 89 d6             	mov    %rdx,%rsi
  802988:	89 c7                	mov    %eax,%edi
  80298a:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  802991:	00 00 00 
  802994:	ff d0                	callq  *%rax
  802996:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802999:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299d:	79 05                	jns    8029a4 <write+0x5d>
		return r;
  80299f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a2:	eb 75                	jmp    802a19 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a8:	8b 40 08             	mov    0x8(%rax),%eax
  8029ab:	83 e0 03             	and    $0x3,%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	75 3a                	jne    8029ec <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029b2:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  8029b9:	00 00 00 
  8029bc:	48 8b 00             	mov    (%rax),%rax
  8029bf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029c8:	89 c6                	mov    %eax,%esi
  8029ca:	48 bf b3 4d 80 00 00 	movabs $0x804db3,%rdi
  8029d1:	00 00 00 
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d9:	48 b9 d5 07 80 00 00 	movabs $0x8007d5,%rcx
  8029e0:	00 00 00 
  8029e3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ea:	eb 2d                	jmp    802a19 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029f4:	48 85 c0             	test   %rax,%rax
  8029f7:	75 07                	jne    802a00 <write+0xb9>
		return -E_NOT_SUPP;
  8029f9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029fe:	eb 19                	jmp    802a19 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a04:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a08:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a0c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a10:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a14:	48 89 cf             	mov    %rcx,%rdi
  802a17:	ff d0                	callq  *%rax
}
  802a19:	c9                   	leaveq 
  802a1a:	c3                   	retq   

0000000000802a1b <seek>:

int
seek(int fdnum, off_t offset)
{
  802a1b:	55                   	push   %rbp
  802a1c:	48 89 e5             	mov    %rsp,%rbp
  802a1f:	48 83 ec 18          	sub    $0x18,%rsp
  802a23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a26:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a29:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a30:	48 89 d6             	mov    %rdx,%rsi
  802a33:	89 c7                	mov    %eax,%edi
  802a35:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	callq  *%rax
  802a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a48:	79 05                	jns    802a4f <seek+0x34>
		return r;
  802a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4d:	eb 0f                	jmp    802a5e <seek+0x43>
	fd->fd_offset = offset;
  802a4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a53:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a5e:	c9                   	leaveq 
  802a5f:	c3                   	retq   

0000000000802a60 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a60:	55                   	push   %rbp
  802a61:	48 89 e5             	mov    %rsp,%rbp
  802a64:	48 83 ec 30          	sub    $0x30,%rsp
  802a68:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a6b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a6e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a75:	48 89 d6             	mov    %rdx,%rsi
  802a78:	89 c7                	mov    %eax,%edi
  802a7a:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
  802a86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8d:	78 24                	js     802ab3 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a93:	8b 00                	mov    (%rax),%eax
  802a95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a99:	48 89 d6             	mov    %rdx,%rsi
  802a9c:	89 c7                	mov    %eax,%edi
  802a9e:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab1:	79 05                	jns    802ab8 <ftruncate+0x58>
		return r;
  802ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab6:	eb 72                	jmp    802b2a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abc:	8b 40 08             	mov    0x8(%rax),%eax
  802abf:	83 e0 03             	and    $0x3,%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	75 3a                	jne    802b00 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ac6:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  802acd:	00 00 00 
  802ad0:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ad3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ad9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802adc:	89 c6                	mov    %eax,%esi
  802ade:	48 bf d0 4d 80 00 00 	movabs $0x804dd0,%rdi
  802ae5:	00 00 00 
  802ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  802aed:	48 b9 d5 07 80 00 00 	movabs $0x8007d5,%rcx
  802af4:	00 00 00 
  802af7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802af9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802afe:	eb 2a                	jmp    802b2a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b04:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b08:	48 85 c0             	test   %rax,%rax
  802b0b:	75 07                	jne    802b14 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b0d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b12:	eb 16                	jmp    802b2a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b18:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b20:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b23:	89 ce                	mov    %ecx,%esi
  802b25:	48 89 d7             	mov    %rdx,%rdi
  802b28:	ff d0                	callq  *%rax
}
  802b2a:	c9                   	leaveq 
  802b2b:	c3                   	retq   

0000000000802b2c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b2c:	55                   	push   %rbp
  802b2d:	48 89 e5             	mov    %rsp,%rbp
  802b30:	48 83 ec 30          	sub    $0x30,%rsp
  802b34:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b37:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b3f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b42:	48 89 d6             	mov    %rdx,%rsi
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5a:	78 24                	js     802b80 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b60:	8b 00                	mov    (%rax),%eax
  802b62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b66:	48 89 d6             	mov    %rdx,%rsi
  802b69:	89 c7                	mov    %eax,%edi
  802b6b:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
  802b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7e:	79 05                	jns    802b85 <fstat+0x59>
		return r;
  802b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b83:	eb 5e                	jmp    802be3 <fstat+0xb7>
	if (!dev->dev_stat)
  802b85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b89:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b8d:	48 85 c0             	test   %rax,%rax
  802b90:	75 07                	jne    802b99 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b92:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b97:	eb 4a                	jmp    802be3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b9d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ba0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bab:	00 00 00 
	stat->st_isdir = 0;
  802bae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bb2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bb9:	00 00 00 
	stat->st_dev = dev;
  802bbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcf:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bdb:	48 89 ce             	mov    %rcx,%rsi
  802bde:	48 89 d7             	mov    %rdx,%rdi
  802be1:	ff d0                	callq  *%rax
}
  802be3:	c9                   	leaveq 
  802be4:	c3                   	retq   

0000000000802be5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802be5:	55                   	push   %rbp
  802be6:	48 89 e5             	mov    %rsp,%rbp
  802be9:	48 83 ec 20          	sub    $0x20,%rsp
  802bed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf9:	be 00 00 00 00       	mov    $0x0,%esi
  802bfe:	48 89 c7             	mov    %rax,%rdi
  802c01:	48 b8 d5 2c 80 00 00 	movabs $0x802cd5,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c14:	79 05                	jns    802c1b <stat+0x36>
		return fd;
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c19:	eb 2f                	jmp    802c4a <stat+0x65>
	r = fstat(fd, stat);
  802c1b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c22:	48 89 d6             	mov    %rdx,%rsi
  802c25:	89 c7                	mov    %eax,%edi
  802c27:	48 b8 2c 2b 80 00 00 	movabs $0x802b2c,%rax
  802c2e:	00 00 00 
  802c31:	ff d0                	callq  *%rax
  802c33:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c39:	89 c7                	mov    %eax,%edi
  802c3b:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
	return r;
  802c47:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c4a:	c9                   	leaveq 
  802c4b:	c3                   	retq   

0000000000802c4c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c4c:	55                   	push   %rbp
  802c4d:	48 89 e5             	mov    %rsp,%rbp
  802c50:	48 83 ec 10          	sub    $0x10,%rsp
  802c54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c5b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c62:	00 00 00 
  802c65:	8b 00                	mov    (%rax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	75 1f                	jne    802c8a <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c6b:	bf 01 00 00 00       	mov    $0x1,%edi
  802c70:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  802c77:	00 00 00 
  802c7a:	ff d0                	callq  *%rax
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c85:	00 00 00 
  802c88:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c8a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c91:	00 00 00 
  802c94:	8b 00                	mov    (%rax),%eax
  802c96:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c99:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c9e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ca5:	00 00 00 
  802ca8:	89 c7                	mov    %eax,%edi
  802caa:	48 b8 cd 44 80 00 00 	movabs $0x8044cd,%rax
  802cb1:	00 00 00 
  802cb4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cba:	ba 00 00 00 00       	mov    $0x0,%edx
  802cbf:	48 89 c6             	mov    %rax,%rsi
  802cc2:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc7:	48 b8 8f 44 80 00 00 	movabs $0x80448f,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
}
  802cd3:	c9                   	leaveq 
  802cd4:	c3                   	retq   

0000000000802cd5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cd5:	55                   	push   %rbp
  802cd6:	48 89 e5             	mov    %rsp,%rbp
  802cd9:	48 83 ec 10          	sub    $0x10,%rsp
  802cdd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ce1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802ce4:	48 ba f6 4d 80 00 00 	movabs $0x804df6,%rdx
  802ceb:	00 00 00 
  802cee:	be 4c 00 00 00       	mov    $0x4c,%esi
  802cf3:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  802cfa:	00 00 00 
  802cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802d02:	48 b9 9c 05 80 00 00 	movabs $0x80059c,%rcx
  802d09:	00 00 00 
  802d0c:	ff d1                	callq  *%rcx

0000000000802d0e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 10          	sub    $0x10,%rsp
  802d16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1e:	8b 50 0c             	mov    0xc(%rax),%edx
  802d21:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d28:	00 00 00 
  802d2b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d2d:	be 00 00 00 00       	mov    $0x0,%esi
  802d32:	bf 06 00 00 00       	mov    $0x6,%edi
  802d37:	48 b8 4c 2c 80 00 00 	movabs $0x802c4c,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
}
  802d43:	c9                   	leaveq 
  802d44:	c3                   	retq   

0000000000802d45 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d45:	55                   	push   %rbp
  802d46:	48 89 e5             	mov    %rsp,%rbp
  802d49:	48 83 ec 20          	sub    $0x20,%rsp
  802d4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802d59:	48 ba 16 4e 80 00 00 	movabs $0x804e16,%rdx
  802d60:	00 00 00 
  802d63:	be 6b 00 00 00       	mov    $0x6b,%esi
  802d68:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  802d6f:	00 00 00 
  802d72:	b8 00 00 00 00       	mov    $0x0,%eax
  802d77:	48 b9 9c 05 80 00 00 	movabs $0x80059c,%rcx
  802d7e:	00 00 00 
  802d81:	ff d1                	callq  *%rcx

0000000000802d83 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d83:	55                   	push   %rbp
  802d84:	48 89 e5             	mov    %rsp,%rbp
  802d87:	48 83 ec 20          	sub    $0x20,%rsp
  802d8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802d97:	48 ba 33 4e 80 00 00 	movabs $0x804e33,%rdx
  802d9e:	00 00 00 
  802da1:	be 7b 00 00 00       	mov    $0x7b,%esi
  802da6:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  802dad:	00 00 00 
  802db0:	b8 00 00 00 00       	mov    $0x0,%eax
  802db5:	48 b9 9c 05 80 00 00 	movabs $0x80059c,%rcx
  802dbc:	00 00 00 
  802dbf:	ff d1                	callq  *%rcx

0000000000802dc1 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802dc1:	55                   	push   %rbp
  802dc2:	48 89 e5             	mov    %rsp,%rbp
  802dc5:	48 83 ec 20          	sub    $0x20,%rsp
  802dc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd5:	8b 50 0c             	mov    0xc(%rax),%edx
  802dd8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ddf:	00 00 00 
  802de2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802de4:	be 00 00 00 00       	mov    $0x0,%esi
  802de9:	bf 05 00 00 00       	mov    $0x5,%edi
  802dee:	48 b8 4c 2c 80 00 00 	movabs $0x802c4c,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
  802dfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e01:	79 05                	jns    802e08 <devfile_stat+0x47>
		return r;
  802e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e06:	eb 56                	jmp    802e5e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e0c:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802e13:	00 00 00 
  802e16:	48 89 c7             	mov    %rax,%rdi
  802e19:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e25:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e2c:	00 00 00 
  802e2f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e39:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e3f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e46:	00 00 00 
  802e49:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e53:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e5e:	c9                   	leaveq 
  802e5f:	c3                   	retq   

0000000000802e60 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e60:	55                   	push   %rbp
  802e61:	48 89 e5             	mov    %rsp,%rbp
  802e64:	48 83 ec 10          	sub    $0x10,%rsp
  802e68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e6c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e73:	8b 50 0c             	mov    0xc(%rax),%edx
  802e76:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e7d:	00 00 00 
  802e80:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e82:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e89:	00 00 00 
  802e8c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e92:	be 00 00 00 00       	mov    $0x0,%esi
  802e97:	bf 02 00 00 00       	mov    $0x2,%edi
  802e9c:	48 b8 4c 2c 80 00 00 	movabs $0x802c4c,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
}
  802ea8:	c9                   	leaveq 
  802ea9:	c3                   	retq   

0000000000802eaa <remove>:

// Delete a file
int
remove(const char *path)
{
  802eaa:	55                   	push   %rbp
  802eab:	48 89 e5             	mov    %rsp,%rbp
  802eae:	48 83 ec 10          	sub    $0x10,%rsp
  802eb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eba:	48 89 c7             	mov    %rax,%rdi
  802ebd:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
  802ec9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ece:	7e 07                	jle    802ed7 <remove+0x2d>
		return -E_BAD_PATH;
  802ed0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ed5:	eb 33                	jmp    802f0a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edb:	48 89 c6             	mov    %rax,%rsi
  802ede:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ee5:	00 00 00 
  802ee8:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ef4:	be 00 00 00 00       	mov    $0x0,%esi
  802ef9:	bf 07 00 00 00       	mov    $0x7,%edi
  802efe:	48 b8 4c 2c 80 00 00 	movabs $0x802c4c,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
}
  802f0a:	c9                   	leaveq 
  802f0b:	c3                   	retq   

0000000000802f0c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f0c:	55                   	push   %rbp
  802f0d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f10:	be 00 00 00 00       	mov    $0x0,%esi
  802f15:	bf 08 00 00 00       	mov    $0x8,%edi
  802f1a:	48 b8 4c 2c 80 00 00 	movabs $0x802c4c,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
}
  802f26:	5d                   	pop    %rbp
  802f27:	c3                   	retq   

0000000000802f28 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802f28:	55                   	push   %rbp
  802f29:	48 89 e5             	mov    %rsp,%rbp
  802f2c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802f33:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f3a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f41:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f48:	be 00 00 00 00       	mov    $0x0,%esi
  802f4d:	48 89 c7             	mov    %rax,%rdi
  802f50:	48 b8 d5 2c 80 00 00 	movabs $0x802cd5,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f63:	79 28                	jns    802f8d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f68:	89 c6                	mov    %eax,%esi
  802f6a:	48 bf 51 4e 80 00 00 	movabs $0x804e51,%rdi
  802f71:	00 00 00 
  802f74:	b8 00 00 00 00       	mov    $0x0,%eax
  802f79:	48 ba d5 07 80 00 00 	movabs $0x8007d5,%rdx
  802f80:	00 00 00 
  802f83:	ff d2                	callq  *%rdx
		return fd_src;
  802f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f88:	e9 74 01 00 00       	jmpq   803101 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f8d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f94:	be 01 01 00 00       	mov    $0x101,%esi
  802f99:	48 89 c7             	mov    %rax,%rdi
  802f9c:	48 b8 d5 2c 80 00 00 	movabs $0x802cd5,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
  802fa8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802fab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802faf:	79 39                	jns    802fea <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802fb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fb4:	89 c6                	mov    %eax,%esi
  802fb6:	48 bf 67 4e 80 00 00 	movabs $0x804e67,%rdi
  802fbd:	00 00 00 
  802fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc5:	48 ba d5 07 80 00 00 	movabs $0x8007d5,%rdx
  802fcc:	00 00 00 
  802fcf:	ff d2                	callq  *%rdx
		close(fd_src);
  802fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd4:	89 c7                	mov    %eax,%edi
  802fd6:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
		return fd_dest;
  802fe2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fe5:	e9 17 01 00 00       	jmpq   803101 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fea:	eb 74                	jmp    803060 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fef:	48 63 d0             	movslq %eax,%rdx
  802ff2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ff9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ffc:	48 89 ce             	mov    %rcx,%rsi
  802fff:	89 c7                	mov    %eax,%edi
  803001:	48 b8 47 29 80 00 00 	movabs $0x802947,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax
  80300d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803010:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803014:	79 4a                	jns    803060 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803016:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803019:	89 c6                	mov    %eax,%esi
  80301b:	48 bf 81 4e 80 00 00 	movabs $0x804e81,%rdi
  803022:	00 00 00 
  803025:	b8 00 00 00 00       	mov    $0x0,%eax
  80302a:	48 ba d5 07 80 00 00 	movabs $0x8007d5,%rdx
  803031:	00 00 00 
  803034:	ff d2                	callq  *%rdx
			close(fd_src);
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803039:	89 c7                	mov    %eax,%edi
  80303b:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
			close(fd_dest);
  803047:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80304a:	89 c7                	mov    %eax,%edi
  80304c:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
			return write_size;
  803058:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80305b:	e9 a1 00 00 00       	jmpq   803101 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803060:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306a:	ba 00 02 00 00       	mov    $0x200,%edx
  80306f:	48 89 ce             	mov    %rcx,%rsi
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 fd 27 80 00 00 	movabs $0x8027fd,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
  803080:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803083:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803087:	0f 8f 5f ff ff ff    	jg     802fec <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  80308d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803091:	79 47                	jns    8030da <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803093:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803096:	89 c6                	mov    %eax,%esi
  803098:	48 bf 94 4e 80 00 00 	movabs $0x804e94,%rdi
  80309f:	00 00 00 
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a7:	48 ba d5 07 80 00 00 	movabs $0x8007d5,%rdx
  8030ae:	00 00 00 
  8030b1:	ff d2                	callq  *%rdx
		close(fd_src);
  8030b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b6:	89 c7                	mov    %eax,%edi
  8030b8:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
		close(fd_dest);
  8030c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c7:	89 c7                	mov    %eax,%edi
  8030c9:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  8030d0:	00 00 00 
  8030d3:	ff d0                	callq  *%rax
		return read_size;
  8030d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030d8:	eb 27                	jmp    803101 <copy+0x1d9>
	}
	close(fd_src);
  8030da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030dd:	89 c7                	mov    %eax,%edi
  8030df:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
	close(fd_dest);
  8030eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030ee:	89 c7                	mov    %eax,%edi
  8030f0:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
	return 0;
  8030fc:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803101:	c9                   	leaveq 
  803102:	c3                   	retq   

0000000000803103 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803103:	55                   	push   %rbp
  803104:	48 89 e5             	mov    %rsp,%rbp
  803107:	48 83 ec 20          	sub    $0x20,%rsp
  80310b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80310f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803113:	8b 40 0c             	mov    0xc(%rax),%eax
  803116:	85 c0                	test   %eax,%eax
  803118:	7e 67                	jle    803181 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80311a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311e:	8b 40 04             	mov    0x4(%rax),%eax
  803121:	48 63 d0             	movslq %eax,%rdx
  803124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803128:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80312c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803130:	8b 00                	mov    (%rax),%eax
  803132:	48 89 ce             	mov    %rcx,%rsi
  803135:	89 c7                	mov    %eax,%edi
  803137:	48 b8 47 29 80 00 00 	movabs $0x802947,%rax
  80313e:	00 00 00 
  803141:	ff d0                	callq  *%rax
  803143:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314a:	7e 13                	jle    80315f <writebuf+0x5c>
			b->result += result;
  80314c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803150:	8b 50 08             	mov    0x8(%rax),%edx
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	01 c2                	add    %eax,%edx
  803158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315c:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80315f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803163:	8b 40 04             	mov    0x4(%rax),%eax
  803166:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803169:	74 16                	je     803181 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80316b:	b8 00 00 00 00       	mov    $0x0,%eax
  803170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803174:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803178:	89 c2                	mov    %eax,%edx
  80317a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317e:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803181:	c9                   	leaveq 
  803182:	c3                   	retq   

0000000000803183 <putch>:

static void
putch(int ch, void *thunk)
{
  803183:	55                   	push   %rbp
  803184:	48 89 e5             	mov    %rsp,%rbp
  803187:	48 83 ec 20          	sub    $0x20,%rsp
  80318b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80318e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803192:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803196:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80319a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80319e:	8b 40 04             	mov    0x4(%rax),%eax
  8031a1:	8d 48 01             	lea    0x1(%rax),%ecx
  8031a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031a8:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8031ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031ae:	89 d1                	mov    %edx,%ecx
  8031b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031b4:	48 98                	cltq   
  8031b6:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8031ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031be:	8b 40 04             	mov    0x4(%rax),%eax
  8031c1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8031c6:	75 1e                	jne    8031e6 <putch+0x63>
		writebuf(b);
  8031c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031cc:	48 89 c7             	mov    %rax,%rdi
  8031cf:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
		b->idx = 0;
  8031db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8031e6:	c9                   	leaveq 
  8031e7:	c3                   	retq   

00000000008031e8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8031e8:	55                   	push   %rbp
  8031e9:	48 89 e5             	mov    %rsp,%rbp
  8031ec:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8031f3:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8031f9:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803200:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803207:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80320d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803213:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80321a:	00 00 00 
	b.result = 0;
  80321d:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803224:	00 00 00 
	b.error = 1;
  803227:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80322e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803231:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803238:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80323f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803246:	48 89 c6             	mov    %rax,%rsi
  803249:	48 bf 83 31 80 00 00 	movabs $0x803183,%rdi
  803250:	00 00 00 
  803253:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80325f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	7e 16                	jle    80327f <vfprintf+0x97>
		writebuf(&b);
  803269:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803270:	48 89 c7             	mov    %rax,%rdi
  803273:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  80327a:	00 00 00 
  80327d:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80327f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 08                	je     803291 <vfprintf+0xa9>
  803289:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80328f:	eb 06                	jmp    803297 <vfprintf+0xaf>
  803291:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803297:	c9                   	leaveq 
  803298:	c3                   	retq   

0000000000803299 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803299:	55                   	push   %rbp
  80329a:	48 89 e5             	mov    %rsp,%rbp
  80329d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8032a4:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8032aa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8032b1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8032b8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032bf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032c6:	84 c0                	test   %al,%al
  8032c8:	74 20                	je     8032ea <fprintf+0x51>
  8032ca:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032ce:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032d2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032d6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032da:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032de:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032e2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032e6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032ea:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8032f1:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8032f8:	00 00 00 
  8032fb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803302:	00 00 00 
  803305:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803309:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803310:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803317:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80331e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803325:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80332c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803332:	48 89 ce             	mov    %rcx,%rsi
  803335:	89 c7                	mov    %eax,%edi
  803337:	48 b8 e8 31 80 00 00 	movabs $0x8031e8,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
  803343:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803349:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80334f:	c9                   	leaveq 
  803350:	c3                   	retq   

0000000000803351 <printf>:

int
printf(const char *fmt, ...)
{
  803351:	55                   	push   %rbp
  803352:	48 89 e5             	mov    %rsp,%rbp
  803355:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80335c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803363:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80336a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803371:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803378:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80337f:	84 c0                	test   %al,%al
  803381:	74 20                	je     8033a3 <printf+0x52>
  803383:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803387:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80338b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80338f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803393:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803397:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80339b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80339f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033a3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8033aa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8033b1:	00 00 00 
  8033b4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033bb:	00 00 00 
  8033be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033c9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033d0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8033d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033de:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033e5:	48 89 c6             	mov    %rax,%rsi
  8033e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8033ed:	48 b8 e8 31 80 00 00 	movabs $0x8031e8,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
  8033f9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033ff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803405:	c9                   	leaveq 
  803406:	c3                   	retq   

0000000000803407 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803407:	55                   	push   %rbp
  803408:	48 89 e5             	mov    %rsp,%rbp
  80340b:	48 83 ec 20          	sub    $0x20,%rsp
  80340f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803412:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803416:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803419:	48 89 d6             	mov    %rdx,%rsi
  80341c:	89 c7                	mov    %eax,%edi
  80341e:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  803425:	00 00 00 
  803428:	ff d0                	callq  *%rax
  80342a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803431:	79 05                	jns    803438 <fd2sockid+0x31>
		return r;
  803433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803436:	eb 24                	jmp    80345c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343c:	8b 10                	mov    (%rax),%edx
  80343e:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803445:	00 00 00 
  803448:	8b 00                	mov    (%rax),%eax
  80344a:	39 c2                	cmp    %eax,%edx
  80344c:	74 07                	je     803455 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80344e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803453:	eb 07                	jmp    80345c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803459:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80345c:	c9                   	leaveq 
  80345d:	c3                   	retq   

000000000080345e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 20          	sub    $0x20,%rsp
  803466:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803469:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80346d:	48 89 c7             	mov    %rax,%rdi
  803470:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803483:	78 26                	js     8034ab <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803489:	ba 07 04 00 00       	mov    $0x407,%edx
  80348e:	48 89 c6             	mov    %rax,%rsi
  803491:	bf 00 00 00 00       	mov    $0x0,%edi
  803496:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
  8034a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a9:	79 16                	jns    8034c1 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8034ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ae:	89 c7                	mov    %eax,%edi
  8034b0:	48 b8 6d 39 80 00 00 	movabs $0x80396d,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
		return r;
  8034bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bf:	eb 3a                	jmp    8034fb <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8034c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c5:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8034cc:	00 00 00 
  8034cf:	8b 12                	mov    (%rdx),%edx
  8034d1:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8034d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8034de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034e5:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ec:	48 89 c7             	mov    %rax,%rdi
  8034ef:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
}
  8034fb:	c9                   	leaveq 
  8034fc:	c3                   	retq   

00000000008034fd <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034fd:	55                   	push   %rbp
  8034fe:	48 89 e5             	mov    %rsp,%rbp
  803501:	48 83 ec 30          	sub    $0x30,%rsp
  803505:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803508:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803513:	89 c7                	mov    %eax,%edi
  803515:	48 b8 07 34 80 00 00 	movabs $0x803407,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
  803521:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803524:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803528:	79 05                	jns    80352f <accept+0x32>
		return r;
  80352a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352d:	eb 3b                	jmp    80356a <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80352f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803533:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803537:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353a:	48 89 ce             	mov    %rcx,%rsi
  80353d:	89 c7                	mov    %eax,%edi
  80353f:	48 b8 4a 38 80 00 00 	movabs $0x80384a,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
  80354b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803552:	79 05                	jns    803559 <accept+0x5c>
		return r;
  803554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803557:	eb 11                	jmp    80356a <accept+0x6d>
	return alloc_sockfd(r);
  803559:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355c:	89 c7                	mov    %eax,%edi
  80355e:	48 b8 5e 34 80 00 00 	movabs $0x80345e,%rax
  803565:	00 00 00 
  803568:	ff d0                	callq  *%rax
}
  80356a:	c9                   	leaveq 
  80356b:	c3                   	retq   

000000000080356c <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80356c:	55                   	push   %rbp
  80356d:	48 89 e5             	mov    %rsp,%rbp
  803570:	48 83 ec 20          	sub    $0x20,%rsp
  803574:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803577:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80357b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80357e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803581:	89 c7                	mov    %eax,%edi
  803583:	48 b8 07 34 80 00 00 	movabs $0x803407,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803596:	79 05                	jns    80359d <bind+0x31>
		return r;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359b:	eb 1b                	jmp    8035b8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80359d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a7:	48 89 ce             	mov    %rcx,%rsi
  8035aa:	89 c7                	mov    %eax,%edi
  8035ac:	48 b8 c9 38 80 00 00 	movabs $0x8038c9,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
}
  8035b8:	c9                   	leaveq 
  8035b9:	c3                   	retq   

00000000008035ba <shutdown>:

int
shutdown(int s, int how)
{
  8035ba:	55                   	push   %rbp
  8035bb:	48 89 e5             	mov    %rsp,%rbp
  8035be:	48 83 ec 20          	sub    $0x20,%rsp
  8035c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035c5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	48 b8 07 34 80 00 00 	movabs $0x803407,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
  8035d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e0:	79 05                	jns    8035e7 <shutdown+0x2d>
		return r;
  8035e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e5:	eb 16                	jmp    8035fd <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8035e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ed:	89 d6                	mov    %edx,%esi
  8035ef:	89 c7                	mov    %eax,%edi
  8035f1:	48 b8 2d 39 80 00 00 	movabs $0x80392d,%rax
  8035f8:	00 00 00 
  8035fb:	ff d0                	callq  *%rax
}
  8035fd:	c9                   	leaveq 
  8035fe:	c3                   	retq   

00000000008035ff <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8035ff:	55                   	push   %rbp
  803600:	48 89 e5             	mov    %rsp,%rbp
  803603:	48 83 ec 10          	sub    $0x10,%rsp
  803607:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80360b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360f:	48 89 c7             	mov    %rax,%rdi
  803612:	48 b8 cc 46 80 00 00 	movabs $0x8046cc,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
  80361e:	83 f8 01             	cmp    $0x1,%eax
  803621:	75 17                	jne    80363a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803627:	8b 40 0c             	mov    0xc(%rax),%eax
  80362a:	89 c7                	mov    %eax,%edi
  80362c:	48 b8 6d 39 80 00 00 	movabs $0x80396d,%rax
  803633:	00 00 00 
  803636:	ff d0                	callq  *%rax
  803638:	eb 05                	jmp    80363f <devsock_close+0x40>
	else
		return 0;
  80363a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80363f:	c9                   	leaveq 
  803640:	c3                   	retq   

0000000000803641 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803641:	55                   	push   %rbp
  803642:	48 89 e5             	mov    %rsp,%rbp
  803645:	48 83 ec 20          	sub    $0x20,%rsp
  803649:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80364c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803650:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803653:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803656:	89 c7                	mov    %eax,%edi
  803658:	48 b8 07 34 80 00 00 	movabs $0x803407,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
  803664:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803667:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366b:	79 05                	jns    803672 <connect+0x31>
		return r;
  80366d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803670:	eb 1b                	jmp    80368d <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803672:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803675:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367c:	48 89 ce             	mov    %rcx,%rsi
  80367f:	89 c7                	mov    %eax,%edi
  803681:	48 b8 9a 39 80 00 00 	movabs $0x80399a,%rax
  803688:	00 00 00 
  80368b:	ff d0                	callq  *%rax
}
  80368d:	c9                   	leaveq 
  80368e:	c3                   	retq   

000000000080368f <listen>:

int
listen(int s, int backlog)
{
  80368f:	55                   	push   %rbp
  803690:	48 89 e5             	mov    %rsp,%rbp
  803693:	48 83 ec 20          	sub    $0x20,%rsp
  803697:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80369a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80369d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a0:	89 c7                	mov    %eax,%edi
  8036a2:	48 b8 07 34 80 00 00 	movabs $0x803407,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
  8036ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b5:	79 05                	jns    8036bc <listen+0x2d>
		return r;
  8036b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ba:	eb 16                	jmp    8036d2 <listen+0x43>
	return nsipc_listen(r, backlog);
  8036bc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c2:	89 d6                	mov    %edx,%esi
  8036c4:	89 c7                	mov    %eax,%edi
  8036c6:	48 b8 fe 39 80 00 00 	movabs $0x8039fe,%rax
  8036cd:	00 00 00 
  8036d0:	ff d0                	callq  *%rax
}
  8036d2:	c9                   	leaveq 
  8036d3:	c3                   	retq   

00000000008036d4 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8036d4:	55                   	push   %rbp
  8036d5:	48 89 e5             	mov    %rsp,%rbp
  8036d8:	48 83 ec 20          	sub    $0x20,%rsp
  8036dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ec:	89 c2                	mov    %eax,%edx
  8036ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f2:	8b 40 0c             	mov    0xc(%rax),%eax
  8036f5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036fe:	89 c7                	mov    %eax,%edi
  803700:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803707:	00 00 00 
  80370a:	ff d0                	callq  *%rax
}
  80370c:	c9                   	leaveq 
  80370d:	c3                   	retq   

000000000080370e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80370e:	55                   	push   %rbp
  80370f:	48 89 e5             	mov    %rsp,%rbp
  803712:	48 83 ec 20          	sub    $0x20,%rsp
  803716:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80371e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803726:	89 c2                	mov    %eax,%edx
  803728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372c:	8b 40 0c             	mov    0xc(%rax),%eax
  80372f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803733:	b9 00 00 00 00       	mov    $0x0,%ecx
  803738:	89 c7                	mov    %eax,%edi
  80373a:	48 b8 0a 3b 80 00 00 	movabs $0x803b0a,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
}
  803746:	c9                   	leaveq 
  803747:	c3                   	retq   

0000000000803748 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803748:	55                   	push   %rbp
  803749:	48 89 e5             	mov    %rsp,%rbp
  80374c:	48 83 ec 10          	sub    $0x10,%rsp
  803750:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803754:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803758:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375c:	48 be af 4e 80 00 00 	movabs $0x804eaf,%rsi
  803763:	00 00 00 
  803766:	48 89 c7             	mov    %rax,%rdi
  803769:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
	return 0;
  803775:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80377a:	c9                   	leaveq 
  80377b:	c3                   	retq   

000000000080377c <socket>:

int
socket(int domain, int type, int protocol)
{
  80377c:	55                   	push   %rbp
  80377d:	48 89 e5             	mov    %rsp,%rbp
  803780:	48 83 ec 20          	sub    $0x20,%rsp
  803784:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803787:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80378a:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80378d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803790:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803793:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803796:	89 ce                	mov    %ecx,%esi
  803798:	89 c7                	mov    %eax,%edi
  80379a:	48 b8 c2 3b 80 00 00 	movabs $0x803bc2,%rax
  8037a1:	00 00 00 
  8037a4:	ff d0                	callq  *%rax
  8037a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ad:	79 05                	jns    8037b4 <socket+0x38>
		return r;
  8037af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b2:	eb 11                	jmp    8037c5 <socket+0x49>
	return alloc_sockfd(r);
  8037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b7:	89 c7                	mov    %eax,%edi
  8037b9:	48 b8 5e 34 80 00 00 	movabs $0x80345e,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
}
  8037c5:	c9                   	leaveq 
  8037c6:	c3                   	retq   

00000000008037c7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8037c7:	55                   	push   %rbp
  8037c8:	48 89 e5             	mov    %rsp,%rbp
  8037cb:	48 83 ec 10          	sub    $0x10,%rsp
  8037cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8037d2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8037d9:	00 00 00 
  8037dc:	8b 00                	mov    (%rax),%eax
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	75 1f                	jne    803801 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8037e2:	bf 02 00 00 00       	mov    $0x2,%edi
  8037e7:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  8037ee:	00 00 00 
  8037f1:	ff d0                	callq  *%rax
  8037f3:	89 c2                	mov    %eax,%edx
  8037f5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8037fc:	00 00 00 
  8037ff:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803801:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803808:	00 00 00 
  80380b:	8b 00                	mov    (%rax),%eax
  80380d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803810:	b9 07 00 00 00       	mov    $0x7,%ecx
  803815:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80381c:	00 00 00 
  80381f:	89 c7                	mov    %eax,%edi
  803821:	48 b8 cd 44 80 00 00 	movabs $0x8044cd,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80382d:	ba 00 00 00 00       	mov    $0x0,%edx
  803832:	be 00 00 00 00       	mov    $0x0,%esi
  803837:	bf 00 00 00 00       	mov    $0x0,%edi
  80383c:	48 b8 8f 44 80 00 00 	movabs $0x80448f,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
}
  803848:	c9                   	leaveq 
  803849:	c3                   	retq   

000000000080384a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80384a:	55                   	push   %rbp
  80384b:	48 89 e5             	mov    %rsp,%rbp
  80384e:	48 83 ec 30          	sub    $0x30,%rsp
  803852:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803855:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803859:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80385d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803864:	00 00 00 
  803867:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80386a:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80386c:	bf 01 00 00 00       	mov    $0x1,%edi
  803871:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
  80387d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803884:	78 3e                	js     8038c4 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803886:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80388d:	00 00 00 
  803890:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803898:	8b 40 10             	mov    0x10(%rax),%eax
  80389b:	89 c2                	mov    %eax,%edx
  80389d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8038a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a5:	48 89 ce             	mov    %rcx,%rsi
  8038a8:	48 89 c7             	mov    %rax,%rdi
  8038ab:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8038b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bb:	8b 50 10             	mov    0x10(%rax),%edx
  8038be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c2:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8038c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038c7:	c9                   	leaveq 
  8038c8:	c3                   	retq   

00000000008038c9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038c9:	55                   	push   %rbp
  8038ca:	48 89 e5             	mov    %rsp,%rbp
  8038cd:	48 83 ec 10          	sub    $0x10,%rsp
  8038d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038d8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8038db:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038e2:	00 00 00 
  8038e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038e8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f1:	48 89 c6             	mov    %rax,%rsi
  8038f4:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8038fb:	00 00 00 
  8038fe:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80390a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803911:	00 00 00 
  803914:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803917:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80391a:	bf 02 00 00 00       	mov    $0x2,%edi
  80391f:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
}
  80392b:	c9                   	leaveq 
  80392c:	c3                   	retq   

000000000080392d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80392d:	55                   	push   %rbp
  80392e:	48 89 e5             	mov    %rsp,%rbp
  803931:	48 83 ec 10          	sub    $0x10,%rsp
  803935:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803938:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80393b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803942:	00 00 00 
  803945:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803948:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80394a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803951:	00 00 00 
  803954:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803957:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80395a:	bf 03 00 00 00       	mov    $0x3,%edi
  80395f:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803966:	00 00 00 
  803969:	ff d0                	callq  *%rax
}
  80396b:	c9                   	leaveq 
  80396c:	c3                   	retq   

000000000080396d <nsipc_close>:

int
nsipc_close(int s)
{
  80396d:	55                   	push   %rbp
  80396e:	48 89 e5             	mov    %rsp,%rbp
  803971:	48 83 ec 10          	sub    $0x10,%rsp
  803975:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803978:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80397f:	00 00 00 
  803982:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803985:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803987:	bf 04 00 00 00       	mov    $0x4,%edi
  80398c:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
}
  803998:	c9                   	leaveq 
  803999:	c3                   	retq   

000000000080399a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80399a:	55                   	push   %rbp
  80399b:	48 89 e5             	mov    %rsp,%rbp
  80399e:	48 83 ec 10          	sub    $0x10,%rsp
  8039a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039a9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8039ac:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039b3:	00 00 00 
  8039b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039b9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8039bb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c2:	48 89 c6             	mov    %rax,%rsi
  8039c5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039cc:	00 00 00 
  8039cf:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8039db:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e2:	00 00 00 
  8039e5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039e8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039eb:	bf 05 00 00 00       	mov    $0x5,%edi
  8039f0:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  8039f7:	00 00 00 
  8039fa:	ff d0                	callq  *%rax
}
  8039fc:	c9                   	leaveq 
  8039fd:	c3                   	retq   

00000000008039fe <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039fe:	55                   	push   %rbp
  8039ff:	48 89 e5             	mov    %rsp,%rbp
  803a02:	48 83 ec 10          	sub    $0x10,%rsp
  803a06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a09:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a0c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a13:	00 00 00 
  803a16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a19:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a1b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a22:	00 00 00 
  803a25:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a28:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a2b:	bf 06 00 00 00       	mov    $0x6,%edi
  803a30:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
}
  803a3c:	c9                   	leaveq 
  803a3d:	c3                   	retq   

0000000000803a3e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a3e:	55                   	push   %rbp
  803a3f:	48 89 e5             	mov    %rsp,%rbp
  803a42:	48 83 ec 30          	sub    $0x30,%rsp
  803a46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a4d:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a50:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a5a:	00 00 00 
  803a5d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a60:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a62:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a69:	00 00 00 
  803a6c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a6f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a79:	00 00 00 
  803a7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a7f:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a82:	bf 07 00 00 00       	mov    $0x7,%edi
  803a87:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
  803a93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a9a:	78 69                	js     803b05 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a9c:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803aa3:	7f 08                	jg     803aad <nsipc_recv+0x6f>
  803aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803aab:	7e 35                	jle    803ae2 <nsipc_recv+0xa4>
  803aad:	48 b9 b6 4e 80 00 00 	movabs $0x804eb6,%rcx
  803ab4:	00 00 00 
  803ab7:	48 ba cb 4e 80 00 00 	movabs $0x804ecb,%rdx
  803abe:	00 00 00 
  803ac1:	be 61 00 00 00       	mov    $0x61,%esi
  803ac6:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  803acd:	00 00 00 
  803ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad5:	49 b8 9c 05 80 00 00 	movabs $0x80059c,%r8
  803adc:	00 00 00 
  803adf:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae5:	48 63 d0             	movslq %eax,%rdx
  803ae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aec:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803af3:	00 00 00 
  803af6:	48 89 c7             	mov    %rax,%rdi
  803af9:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
	}

	return r;
  803b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b08:	c9                   	leaveq 
  803b09:	c3                   	retq   

0000000000803b0a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b0a:	55                   	push   %rbp
  803b0b:	48 89 e5             	mov    %rsp,%rbp
  803b0e:	48 83 ec 20          	sub    $0x20,%rsp
  803b12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b19:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b1c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b26:	00 00 00 
  803b29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2c:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b2e:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b35:	7e 35                	jle    803b6c <nsipc_send+0x62>
  803b37:	48 b9 ec 4e 80 00 00 	movabs $0x804eec,%rcx
  803b3e:	00 00 00 
  803b41:	48 ba cb 4e 80 00 00 	movabs $0x804ecb,%rdx
  803b48:	00 00 00 
  803b4b:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b50:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  803b57:	00 00 00 
  803b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b5f:	49 b8 9c 05 80 00 00 	movabs $0x80059c,%r8
  803b66:	00 00 00 
  803b69:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b6f:	48 63 d0             	movslq %eax,%rdx
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	48 89 c6             	mov    %rax,%rsi
  803b79:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803b80:	00 00 00 
  803b83:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  803b8a:	00 00 00 
  803b8d:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b8f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b96:	00 00 00 
  803b99:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b9c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ba6:	00 00 00 
  803ba9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bac:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803baf:	bf 08 00 00 00       	mov    $0x8,%edi
  803bb4:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803bbb:	00 00 00 
  803bbe:	ff d0                	callq  *%rax
}
  803bc0:	c9                   	leaveq 
  803bc1:	c3                   	retq   

0000000000803bc2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803bc2:	55                   	push   %rbp
  803bc3:	48 89 e5             	mov    %rsp,%rbp
  803bc6:	48 83 ec 10          	sub    $0x10,%rsp
  803bca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bcd:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803bd0:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803bd3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bda:	00 00 00 
  803bdd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803be0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803be2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be9:	00 00 00 
  803bec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bef:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803bf2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf9:	00 00 00 
  803bfc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bff:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c02:	bf 09 00 00 00       	mov    $0x9,%edi
  803c07:	48 b8 c7 37 80 00 00 	movabs $0x8037c7,%rax
  803c0e:	00 00 00 
  803c11:	ff d0                	callq  *%rax
}
  803c13:	c9                   	leaveq 
  803c14:	c3                   	retq   

0000000000803c15 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c15:	55                   	push   %rbp
  803c16:	48 89 e5             	mov    %rsp,%rbp
  803c19:	53                   	push   %rbx
  803c1a:	48 83 ec 38          	sub    $0x38,%rsp
  803c1e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c22:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c26:	48 89 c7             	mov    %rax,%rdi
  803c29:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
  803c35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3c:	0f 88 bf 01 00 00    	js     803e01 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c46:	ba 07 04 00 00       	mov    $0x407,%edx
  803c4b:	48 89 c6             	mov    %rax,%rsi
  803c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c53:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  803c5a:	00 00 00 
  803c5d:	ff d0                	callq  *%rax
  803c5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c62:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c66:	0f 88 95 01 00 00    	js     803e01 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c6c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c70:	48 89 c7             	mov    %rax,%rdi
  803c73:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  803c7a:	00 00 00 
  803c7d:	ff d0                	callq  *%rax
  803c7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c86:	0f 88 5d 01 00 00    	js     803de9 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c90:	ba 07 04 00 00       	mov    $0x407,%edx
  803c95:	48 89 c6             	mov    %rax,%rsi
  803c98:	bf 00 00 00 00       	mov    $0x0,%edi
  803c9d:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  803ca4:	00 00 00 
  803ca7:	ff d0                	callq  *%rax
  803ca9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb0:	0f 88 33 01 00 00    	js     803de9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803cb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cba:	48 89 c7             	mov    %rax,%rdi
  803cbd:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  803cc4:	00 00 00 
  803cc7:	ff d0                	callq  *%rax
  803cc9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ccd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd1:	ba 07 04 00 00       	mov    $0x407,%edx
  803cd6:	48 89 c6             	mov    %rax,%rsi
  803cd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cde:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
  803cea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ced:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cf1:	79 05                	jns    803cf8 <pipe+0xe3>
		goto err2;
  803cf3:	e9 d9 00 00 00       	jmpq   803dd1 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cf8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cfc:	48 89 c7             	mov    %rax,%rdi
  803cff:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  803d06:	00 00 00 
  803d09:	ff d0                	callq  *%rax
  803d0b:	48 89 c2             	mov    %rax,%rdx
  803d0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d12:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d18:	48 89 d1             	mov    %rdx,%rcx
  803d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  803d20:	48 89 c6             	mov    %rax,%rsi
  803d23:	bf 00 00 00 00       	mov    $0x0,%edi
  803d28:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
  803d34:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d37:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d3b:	79 1b                	jns    803d58 <pipe+0x143>
		goto err3;
  803d3d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803d3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d42:	48 89 c6             	mov    %rax,%rsi
  803d45:	bf 00 00 00 00       	mov    $0x0,%edi
  803d4a:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  803d51:	00 00 00 
  803d54:	ff d0                	callq  *%rax
  803d56:	eb 79                	jmp    803dd1 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803d63:	00 00 00 
  803d66:	8b 12                	mov    (%rdx),%edx
  803d68:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803d75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d79:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803d80:	00 00 00 
  803d83:	8b 12                	mov    (%rdx),%edx
  803d85:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d8b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803d92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d96:	48 89 c7             	mov    %rax,%rdi
  803d99:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  803da0:	00 00 00 
  803da3:	ff d0                	callq  *%rax
  803da5:	89 c2                	mov    %eax,%edx
  803da7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dab:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803dad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803db1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803db5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db9:	48 89 c7             	mov    %rax,%rdi
  803dbc:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  803dc3:	00 00 00 
  803dc6:	ff d0                	callq  *%rax
  803dc8:	89 03                	mov    %eax,(%rbx)
	return 0;
  803dca:	b8 00 00 00 00       	mov    $0x0,%eax
  803dcf:	eb 33                	jmp    803e04 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803dd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dd5:	48 89 c6             	mov    %rax,%rsi
  803dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ddd:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  803de4:	00 00 00 
  803de7:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ded:	48 89 c6             	mov    %rax,%rsi
  803df0:	bf 00 00 00 00       	mov    $0x0,%edi
  803df5:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  803dfc:	00 00 00 
  803dff:	ff d0                	callq  *%rax
err:
	return r;
  803e01:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e04:	48 83 c4 38          	add    $0x38,%rsp
  803e08:	5b                   	pop    %rbx
  803e09:	5d                   	pop    %rbp
  803e0a:	c3                   	retq   

0000000000803e0b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e0b:	55                   	push   %rbp
  803e0c:	48 89 e5             	mov    %rsp,%rbp
  803e0f:	53                   	push   %rbx
  803e10:	48 83 ec 28          	sub    $0x28,%rsp
  803e14:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e18:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e1c:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  803e23:	00 00 00 
  803e26:	48 8b 00             	mov    (%rax),%rax
  803e29:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e36:	48 89 c7             	mov    %rax,%rdi
  803e39:	48 b8 cc 46 80 00 00 	movabs $0x8046cc,%rax
  803e40:	00 00 00 
  803e43:	ff d0                	callq  *%rax
  803e45:	89 c3                	mov    %eax,%ebx
  803e47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4b:	48 89 c7             	mov    %rax,%rdi
  803e4e:	48 b8 cc 46 80 00 00 	movabs $0x8046cc,%rax
  803e55:	00 00 00 
  803e58:	ff d0                	callq  *%rax
  803e5a:	39 c3                	cmp    %eax,%ebx
  803e5c:	0f 94 c0             	sete   %al
  803e5f:	0f b6 c0             	movzbl %al,%eax
  803e62:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e65:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  803e6c:	00 00 00 
  803e6f:	48 8b 00             	mov    (%rax),%rax
  803e72:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e78:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e7e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e81:	75 05                	jne    803e88 <_pipeisclosed+0x7d>
			return ret;
  803e83:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e86:	eb 4a                	jmp    803ed2 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803e88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e8b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e8e:	74 3d                	je     803ecd <_pipeisclosed+0xc2>
  803e90:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e94:	75 37                	jne    803ecd <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e96:	48 b8 40 84 80 00 00 	movabs $0x808440,%rax
  803e9d:	00 00 00 
  803ea0:	48 8b 00             	mov    (%rax),%rax
  803ea3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ea9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803eac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eaf:	89 c6                	mov    %eax,%esi
  803eb1:	48 bf fd 4e 80 00 00 	movabs $0x804efd,%rdi
  803eb8:	00 00 00 
  803ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec0:	49 b8 d5 07 80 00 00 	movabs $0x8007d5,%r8
  803ec7:	00 00 00 
  803eca:	41 ff d0             	callq  *%r8
	}
  803ecd:	e9 4a ff ff ff       	jmpq   803e1c <_pipeisclosed+0x11>
}
  803ed2:	48 83 c4 28          	add    $0x28,%rsp
  803ed6:	5b                   	pop    %rbx
  803ed7:	5d                   	pop    %rbp
  803ed8:	c3                   	retq   

0000000000803ed9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ed9:	55                   	push   %rbp
  803eda:	48 89 e5             	mov    %rsp,%rbp
  803edd:	48 83 ec 30          	sub    $0x30,%rsp
  803ee1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ee4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ee8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803eeb:	48 89 d6             	mov    %rdx,%rsi
  803eee:	89 c7                	mov    %eax,%edi
  803ef0:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  803ef7:	00 00 00 
  803efa:	ff d0                	callq  *%rax
  803efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f03:	79 05                	jns    803f0a <pipeisclosed+0x31>
		return r;
  803f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f08:	eb 31                	jmp    803f3b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f0e:	48 89 c7             	mov    %rax,%rdi
  803f11:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  803f18:	00 00 00 
  803f1b:	ff d0                	callq  *%rax
  803f1d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f29:	48 89 d6             	mov    %rdx,%rsi
  803f2c:	48 89 c7             	mov    %rax,%rdi
  803f2f:	48 b8 0b 3e 80 00 00 	movabs $0x803e0b,%rax
  803f36:	00 00 00 
  803f39:	ff d0                	callq  *%rax
}
  803f3b:	c9                   	leaveq 
  803f3c:	c3                   	retq   

0000000000803f3d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f3d:	55                   	push   %rbp
  803f3e:	48 89 e5             	mov    %rsp,%rbp
  803f41:	48 83 ec 40          	sub    $0x40,%rsp
  803f45:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f49:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f4d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f55:	48 89 c7             	mov    %rax,%rdi
  803f58:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  803f5f:	00 00 00 
  803f62:	ff d0                	callq  *%rax
  803f64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f70:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f77:	00 
  803f78:	e9 92 00 00 00       	jmpq   80400f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f7d:	eb 41                	jmp    803fc0 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f7f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f84:	74 09                	je     803f8f <devpipe_read+0x52>
				return i;
  803f86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8a:	e9 92 00 00 00       	jmpq   804021 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f97:	48 89 d6             	mov    %rdx,%rsi
  803f9a:	48 89 c7             	mov    %rax,%rdi
  803f9d:	48 b8 0b 3e 80 00 00 	movabs $0x803e0b,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
  803fa9:	85 c0                	test   %eax,%eax
  803fab:	74 07                	je     803fb4 <devpipe_read+0x77>
				return 0;
  803fad:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb2:	eb 6d                	jmp    804021 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803fb4:	48 b8 60 1c 80 00 00 	movabs $0x801c60,%rax
  803fbb:	00 00 00 
  803fbe:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc4:	8b 10                	mov    (%rax),%edx
  803fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fca:	8b 40 04             	mov    0x4(%rax),%eax
  803fcd:	39 c2                	cmp    %eax,%edx
  803fcf:	74 ae                	je     803f7f <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803fd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd9:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe1:	8b 00                	mov    (%rax),%eax
  803fe3:	99                   	cltd   
  803fe4:	c1 ea 1b             	shr    $0x1b,%edx
  803fe7:	01 d0                	add    %edx,%eax
  803fe9:	83 e0 1f             	and    $0x1f,%eax
  803fec:	29 d0                	sub    %edx,%eax
  803fee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ff2:	48 98                	cltq   
  803ff4:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803ff9:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fff:	8b 00                	mov    (%rax),%eax
  804001:	8d 50 01             	lea    0x1(%rax),%edx
  804004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804008:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  80400a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80400f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804013:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804017:	0f 82 60 ff ff ff    	jb     803f7d <devpipe_read+0x40>
	}
	return i;
  80401d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804021:	c9                   	leaveq 
  804022:	c3                   	retq   

0000000000804023 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804023:	55                   	push   %rbp
  804024:	48 89 e5             	mov    %rsp,%rbp
  804027:	48 83 ec 40          	sub    $0x40,%rsp
  80402b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80402f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804033:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804037:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403b:	48 89 c7             	mov    %rax,%rdi
  80403e:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  804045:	00 00 00 
  804048:	ff d0                	callq  *%rax
  80404a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80404e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804052:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804056:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80405d:	00 
  80405e:	e9 91 00 00 00       	jmpq   8040f4 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804063:	eb 31                	jmp    804096 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804065:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80406d:	48 89 d6             	mov    %rdx,%rsi
  804070:	48 89 c7             	mov    %rax,%rdi
  804073:	48 b8 0b 3e 80 00 00 	movabs $0x803e0b,%rax
  80407a:	00 00 00 
  80407d:	ff d0                	callq  *%rax
  80407f:	85 c0                	test   %eax,%eax
  804081:	74 07                	je     80408a <devpipe_write+0x67>
				return 0;
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
  804088:	eb 7c                	jmp    804106 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80408a:	48 b8 60 1c 80 00 00 	movabs $0x801c60,%rax
  804091:	00 00 00 
  804094:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409a:	8b 40 04             	mov    0x4(%rax),%eax
  80409d:	48 63 d0             	movslq %eax,%rdx
  8040a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a4:	8b 00                	mov    (%rax),%eax
  8040a6:	48 98                	cltq   
  8040a8:	48 83 c0 20          	add    $0x20,%rax
  8040ac:	48 39 c2             	cmp    %rax,%rdx
  8040af:	73 b4                	jae    804065 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8040b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b5:	8b 40 04             	mov    0x4(%rax),%eax
  8040b8:	99                   	cltd   
  8040b9:	c1 ea 1b             	shr    $0x1b,%edx
  8040bc:	01 d0                	add    %edx,%eax
  8040be:	83 e0 1f             	and    $0x1f,%eax
  8040c1:	29 d0                	sub    %edx,%eax
  8040c3:	89 c6                	mov    %eax,%esi
  8040c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040cd:	48 01 d0             	add    %rdx,%rax
  8040d0:	0f b6 08             	movzbl (%rax),%ecx
  8040d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040d7:	48 63 c6             	movslq %esi,%rax
  8040da:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e2:	8b 40 04             	mov    0x4(%rax),%eax
  8040e5:	8d 50 01             	lea    0x1(%rax),%edx
  8040e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ec:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8040ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040fc:	0f 82 61 ff ff ff    	jb     804063 <devpipe_write+0x40>
	}

	return i;
  804102:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804106:	c9                   	leaveq 
  804107:	c3                   	retq   

0000000000804108 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804108:	55                   	push   %rbp
  804109:	48 89 e5             	mov    %rsp,%rbp
  80410c:	48 83 ec 20          	sub    $0x20,%rsp
  804110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80411c:	48 89 c7             	mov    %rax,%rdi
  80411f:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  804126:	00 00 00 
  804129:	ff d0                	callq  *%rax
  80412b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80412f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804133:	48 be 10 4f 80 00 00 	movabs $0x804f10,%rsi
  80413a:	00 00 00 
  80413d:	48 89 c7             	mov    %rax,%rdi
  804140:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  804147:	00 00 00 
  80414a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80414c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804150:	8b 50 04             	mov    0x4(%rax),%edx
  804153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804157:	8b 00                	mov    (%rax),%eax
  804159:	29 c2                	sub    %eax,%edx
  80415b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80415f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804165:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804169:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804170:	00 00 00 
	stat->st_dev = &devpipe;
  804173:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804177:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80417e:	00 00 00 
  804181:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80418d:	c9                   	leaveq 
  80418e:	c3                   	retq   

000000000080418f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80418f:	55                   	push   %rbp
  804190:	48 89 e5             	mov    %rsp,%rbp
  804193:	48 83 ec 10          	sub    $0x10,%rsp
  804197:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80419b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80419f:	48 89 c6             	mov    %rax,%rsi
  8041a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8041a7:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8041ae:	00 00 00 
  8041b1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8041b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b7:	48 89 c7             	mov    %rax,%rdi
  8041ba:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  8041c1:	00 00 00 
  8041c4:	ff d0                	callq  *%rax
  8041c6:	48 89 c6             	mov    %rax,%rsi
  8041c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8041ce:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8041d5:	00 00 00 
  8041d8:	ff d0                	callq  *%rax
}
  8041da:	c9                   	leaveq 
  8041db:	c3                   	retq   

00000000008041dc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8041dc:	55                   	push   %rbp
  8041dd:	48 89 e5             	mov    %rsp,%rbp
  8041e0:	48 83 ec 20          	sub    $0x20,%rsp
  8041e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8041e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041ea:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8041ed:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8041f1:	be 01 00 00 00       	mov    $0x1,%esi
  8041f6:	48 89 c7             	mov    %rax,%rdi
  8041f9:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  804200:	00 00 00 
  804203:	ff d0                	callq  *%rax
}
  804205:	c9                   	leaveq 
  804206:	c3                   	retq   

0000000000804207 <getchar>:

int
getchar(void)
{
  804207:	55                   	push   %rbp
  804208:	48 89 e5             	mov    %rsp,%rbp
  80420b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80420f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804213:	ba 01 00 00 00       	mov    $0x1,%edx
  804218:	48 89 c6             	mov    %rax,%rsi
  80421b:	bf 00 00 00 00       	mov    $0x0,%edi
  804220:	48 b8 fd 27 80 00 00 	movabs $0x8027fd,%rax
  804227:	00 00 00 
  80422a:	ff d0                	callq  *%rax
  80422c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80422f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804233:	79 05                	jns    80423a <getchar+0x33>
		return r;
  804235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804238:	eb 14                	jmp    80424e <getchar+0x47>
	if (r < 1)
  80423a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80423e:	7f 07                	jg     804247 <getchar+0x40>
		return -E_EOF;
  804240:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804245:	eb 07                	jmp    80424e <getchar+0x47>
	return c;
  804247:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80424b:	0f b6 c0             	movzbl %al,%eax
}
  80424e:	c9                   	leaveq 
  80424f:	c3                   	retq   

0000000000804250 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804250:	55                   	push   %rbp
  804251:	48 89 e5             	mov    %rsp,%rbp
  804254:	48 83 ec 20          	sub    $0x20,%rsp
  804258:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80425b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80425f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804262:	48 89 d6             	mov    %rdx,%rsi
  804265:	89 c7                	mov    %eax,%edi
  804267:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  80426e:	00 00 00 
  804271:	ff d0                	callq  *%rax
  804273:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80427a:	79 05                	jns    804281 <iscons+0x31>
		return r;
  80427c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427f:	eb 1a                	jmp    80429b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804285:	8b 10                	mov    (%rax),%edx
  804287:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80428e:	00 00 00 
  804291:	8b 00                	mov    (%rax),%eax
  804293:	39 c2                	cmp    %eax,%edx
  804295:	0f 94 c0             	sete   %al
  804298:	0f b6 c0             	movzbl %al,%eax
}
  80429b:	c9                   	leaveq 
  80429c:	c3                   	retq   

000000000080429d <opencons>:

int
opencons(void)
{
  80429d:	55                   	push   %rbp
  80429e:	48 89 e5             	mov    %rsp,%rbp
  8042a1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8042a5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8042a9:	48 89 c7             	mov    %rax,%rdi
  8042ac:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  8042b3:	00 00 00 
  8042b6:	ff d0                	callq  *%rax
  8042b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042bf:	79 05                	jns    8042c6 <opencons+0x29>
		return r;
  8042c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c4:	eb 5b                	jmp    804321 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8042c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ca:	ba 07 04 00 00       	mov    $0x407,%edx
  8042cf:	48 89 c6             	mov    %rax,%rsi
  8042d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8042d7:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8042de:	00 00 00 
  8042e1:	ff d0                	callq  *%rax
  8042e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ea:	79 05                	jns    8042f1 <opencons+0x54>
		return r;
  8042ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ef:	eb 30                	jmp    804321 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8042f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f5:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8042fc:	00 00 00 
  8042ff:	8b 12                	mov    (%rdx),%edx
  804301:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804307:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80430e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804312:	48 89 c7             	mov    %rax,%rdi
  804315:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  80431c:	00 00 00 
  80431f:	ff d0                	callq  *%rax
}
  804321:	c9                   	leaveq 
  804322:	c3                   	retq   

0000000000804323 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804323:	55                   	push   %rbp
  804324:	48 89 e5             	mov    %rsp,%rbp
  804327:	48 83 ec 30          	sub    $0x30,%rsp
  80432b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80432f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804333:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804337:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80433c:	75 07                	jne    804345 <devcons_read+0x22>
		return 0;
  80433e:	b8 00 00 00 00       	mov    $0x0,%eax
  804343:	eb 4b                	jmp    804390 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804345:	eb 0c                	jmp    804353 <devcons_read+0x30>
		sys_yield();
  804347:	48 b8 60 1c 80 00 00 	movabs $0x801c60,%rax
  80434e:	00 00 00 
  804351:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  804353:	48 b8 a2 1b 80 00 00 	movabs $0x801ba2,%rax
  80435a:	00 00 00 
  80435d:	ff d0                	callq  *%rax
  80435f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804362:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804366:	74 df                	je     804347 <devcons_read+0x24>
	if (c < 0)
  804368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80436c:	79 05                	jns    804373 <devcons_read+0x50>
		return c;
  80436e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804371:	eb 1d                	jmp    804390 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804373:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804377:	75 07                	jne    804380 <devcons_read+0x5d>
		return 0;
  804379:	b8 00 00 00 00       	mov    $0x0,%eax
  80437e:	eb 10                	jmp    804390 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804383:	89 c2                	mov    %eax,%edx
  804385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804389:	88 10                	mov    %dl,(%rax)
	return 1;
  80438b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   

0000000000804392 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804392:	55                   	push   %rbp
  804393:	48 89 e5             	mov    %rsp,%rbp
  804396:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80439d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8043a4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8043ab:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8043b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043b9:	eb 76                	jmp    804431 <devcons_write+0x9f>
		m = n - tot;
  8043bb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8043c2:	89 c2                	mov    %eax,%edx
  8043c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c7:	29 c2                	sub    %eax,%edx
  8043c9:	89 d0                	mov    %edx,%eax
  8043cb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8043ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043d1:	83 f8 7f             	cmp    $0x7f,%eax
  8043d4:	76 07                	jbe    8043dd <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8043d6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8043dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043e0:	48 63 d0             	movslq %eax,%rdx
  8043e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e6:	48 63 c8             	movslq %eax,%rcx
  8043e9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8043f0:	48 01 c1             	add    %rax,%rcx
  8043f3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8043fa:	48 89 ce             	mov    %rcx,%rsi
  8043fd:	48 89 c7             	mov    %rax,%rdi
  804400:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  804407:	00 00 00 
  80440a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80440c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80440f:	48 63 d0             	movslq %eax,%rdx
  804412:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804419:	48 89 d6             	mov    %rdx,%rsi
  80441c:	48 89 c7             	mov    %rax,%rdi
  80441f:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  804426:	00 00 00 
  804429:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  80442b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80442e:	01 45 fc             	add    %eax,-0x4(%rbp)
  804431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804434:	48 98                	cltq   
  804436:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80443d:	0f 82 78 ff ff ff    	jb     8043bb <devcons_write+0x29>
	}
	return tot;
  804443:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804446:	c9                   	leaveq 
  804447:	c3                   	retq   

0000000000804448 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804448:	55                   	push   %rbp
  804449:	48 89 e5             	mov    %rsp,%rbp
  80444c:	48 83 ec 08          	sub    $0x8,%rsp
  804450:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804459:	c9                   	leaveq 
  80445a:	c3                   	retq   

000000000080445b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80445b:	55                   	push   %rbp
  80445c:	48 89 e5             	mov    %rsp,%rbp
  80445f:	48 83 ec 10          	sub    $0x10,%rsp
  804463:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804467:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80446b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80446f:	48 be 1c 4f 80 00 00 	movabs $0x804f1c,%rsi
  804476:	00 00 00 
  804479:	48 89 c7             	mov    %rax,%rdi
  80447c:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  804483:	00 00 00 
  804486:	ff d0                	callq  *%rax
	return 0;
  804488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80448d:	c9                   	leaveq 
  80448e:	c3                   	retq   

000000000080448f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80448f:	55                   	push   %rbp
  804490:	48 89 e5             	mov    %rsp,%rbp
  804493:	48 83 ec 20          	sub    $0x20,%rsp
  804497:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80449b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80449f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  8044a3:	48 ba 28 4f 80 00 00 	movabs $0x804f28,%rdx
  8044aa:	00 00 00 
  8044ad:	be 1d 00 00 00       	mov    $0x1d,%esi
  8044b2:	48 bf 41 4f 80 00 00 	movabs $0x804f41,%rdi
  8044b9:	00 00 00 
  8044bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c1:	48 b9 9c 05 80 00 00 	movabs $0x80059c,%rcx
  8044c8:	00 00 00 
  8044cb:	ff d1                	callq  *%rcx

00000000008044cd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8044cd:	55                   	push   %rbp
  8044ce:	48 89 e5             	mov    %rsp,%rbp
  8044d1:	48 83 ec 20          	sub    $0x20,%rsp
  8044d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044d8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8044db:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8044df:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8044e2:	48 ba 4b 4f 80 00 00 	movabs $0x804f4b,%rdx
  8044e9:	00 00 00 
  8044ec:	be 2d 00 00 00       	mov    $0x2d,%esi
  8044f1:	48 bf 41 4f 80 00 00 	movabs $0x804f41,%rdi
  8044f8:	00 00 00 
  8044fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804500:	48 b9 9c 05 80 00 00 	movabs $0x80059c,%rcx
  804507:	00 00 00 
  80450a:	ff d1                	callq  *%rcx

000000000080450c <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80450c:	55                   	push   %rbp
  80450d:	48 89 e5             	mov    %rsp,%rbp
  804510:	53                   	push   %rbx
  804511:	48 83 ec 48          	sub    $0x48,%rsp
  804515:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804519:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  804520:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804527:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  80452c:	75 0e                	jne    80453c <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  80452e:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804535:	00 00 00 
  804538:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  80453c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804540:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804544:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80454b:	00 
	a3 = (uint64_t) 0;
  80454c:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804553:	00 
	a4 = (uint64_t) 0;
  804554:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80455b:	00 
	a5 = 0;
  80455c:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804563:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  804564:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804567:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80456b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80456f:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  804573:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804577:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80457b:	4c 89 c3             	mov    %r8,%rbx
  80457e:	0f 01 c1             	vmcall 
  804581:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804584:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804588:	7e 36                	jle    8045c0 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  80458a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80458d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804590:	41 89 d0             	mov    %edx,%r8d
  804593:	89 c1                	mov    %eax,%ecx
  804595:	48 ba 68 4f 80 00 00 	movabs $0x804f68,%rdx
  80459c:	00 00 00 
  80459f:	be 54 00 00 00       	mov    $0x54,%esi
  8045a4:	48 bf 41 4f 80 00 00 	movabs $0x804f41,%rdi
  8045ab:	00 00 00 
  8045ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b3:	49 b9 9c 05 80 00 00 	movabs $0x80059c,%r9
  8045ba:	00 00 00 
  8045bd:	41 ff d1             	callq  *%r9
	return ret;
  8045c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8045c3:	48 83 c4 48          	add    $0x48,%rsp
  8045c7:	5b                   	pop    %rbx
  8045c8:	5d                   	pop    %rbp
  8045c9:	c3                   	retq   

00000000008045ca <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045ca:	55                   	push   %rbp
  8045cb:	48 89 e5             	mov    %rsp,%rbp
  8045ce:	53                   	push   %rbx
  8045cf:	48 83 ec 58          	sub    $0x58,%rsp
  8045d3:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  8045d6:	89 75 b0             	mov    %esi,-0x50(%rbp)
  8045d9:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8045dd:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8045e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8045e7:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8045ee:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8045f3:	75 0e                	jne    804603 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8045f5:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8045fc:	00 00 00 
  8045ff:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804603:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804606:	48 98                	cltq   
  804608:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  80460c:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80460f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804613:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804617:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  80461b:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80461e:	48 98                	cltq   
  804620:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  804624:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80462b:	00 

	int r = -E_IPC_NOT_RECV;
  80462c:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  804633:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80463a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80463e:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  804642:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804646:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80464a:	4c 89 c3             	mov    %r8,%rbx
  80464d:	0f 01 c1             	vmcall 
  804650:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804653:	48 83 c4 58          	add    $0x58,%rsp
  804657:	5b                   	pop    %rbx
  804658:	5d                   	pop    %rbp
  804659:	c3                   	retq   

000000000080465a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80465a:	55                   	push   %rbp
  80465b:	48 89 e5             	mov    %rsp,%rbp
  80465e:	48 83 ec 18          	sub    $0x18,%rsp
  804662:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804665:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80466c:	eb 4e                	jmp    8046bc <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80466e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804675:	00 00 00 
  804678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80467b:	48 98                	cltq   
  80467d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804684:	48 01 d0             	add    %rdx,%rax
  804687:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80468d:	8b 00                	mov    (%rax),%eax
  80468f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804692:	75 24                	jne    8046b8 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804694:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80469b:	00 00 00 
  80469e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a1:	48 98                	cltq   
  8046a3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8046aa:	48 01 d0             	add    %rdx,%rax
  8046ad:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046b3:	8b 40 08             	mov    0x8(%rax),%eax
  8046b6:	eb 12                	jmp    8046ca <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  8046b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046bc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046c3:	7e a9                	jle    80466e <ipc_find_env+0x14>
	}
	return 0;
  8046c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046ca:	c9                   	leaveq 
  8046cb:	c3                   	retq   

00000000008046cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8046cc:	55                   	push   %rbp
  8046cd:	48 89 e5             	mov    %rsp,%rbp
  8046d0:	48 83 ec 18          	sub    $0x18,%rsp
  8046d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046dc:	48 c1 e8 15          	shr    $0x15,%rax
  8046e0:	48 89 c2             	mov    %rax,%rdx
  8046e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046ea:	01 00 00 
  8046ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046f1:	83 e0 01             	and    $0x1,%eax
  8046f4:	48 85 c0             	test   %rax,%rax
  8046f7:	75 07                	jne    804700 <pageref+0x34>
		return 0;
  8046f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fe:	eb 53                	jmp    804753 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804704:	48 c1 e8 0c          	shr    $0xc,%rax
  804708:	48 89 c2             	mov    %rax,%rdx
  80470b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804712:	01 00 00 
  804715:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80471d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804721:	83 e0 01             	and    $0x1,%eax
  804724:	48 85 c0             	test   %rax,%rax
  804727:	75 07                	jne    804730 <pageref+0x64>
		return 0;
  804729:	b8 00 00 00 00       	mov    $0x0,%eax
  80472e:	eb 23                	jmp    804753 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804734:	48 c1 e8 0c          	shr    $0xc,%rax
  804738:	48 89 c2             	mov    %rax,%rdx
  80473b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804742:	00 00 00 
  804745:	48 c1 e2 04          	shl    $0x4,%rdx
  804749:	48 01 d0             	add    %rdx,%rax
  80474c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804750:	0f b7 c0             	movzwl %ax,%eax
}
  804753:	c9                   	leaveq 
  804754:	c3                   	retq   
