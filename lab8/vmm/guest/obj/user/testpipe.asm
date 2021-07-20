
vmm/guest/obj/user/testpipe:     formato del fichero elf64-x86-64


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
  80003c:	e8 c4 04 00 00       	callq  800505 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  80004e:	89 bd 7c ff ff ff    	mov    %edi,-0x84(%rbp)
  800054:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800062:	00 00 00 
  800065:	48 be 44 43 80 00 00 	movabs $0x804344,%rsi
  80006c:	00 00 00 
  80006f:	48 89 30             	mov    %rsi,(%rax)

	if ((i = pipe(p)) < 0)
  800072:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800076:	48 89 c7             	mov    %rax,%rdi
  800079:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80008c:	79 30                	jns    8000be <umain+0x7b>
		panic("pipe: %e", i);
  80008e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800091:	89 c1                	mov    %eax,%ecx
  800093:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  80009a:	00 00 00 
  80009d:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a2:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  8000b8:	00 00 00 
  8000bb:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000be:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("fork: %e", i);
  8000d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 69 43 80 00 00 	movabs $0x804369,%rdx
  8000df:	00 00 00 
  8000e2:	be 11 00 00 00       	mov    $0x11,%esi
  8000e7:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800103:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800107:	0f 85 50 01 00 00    	jne    80025d <umain+0x21a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  80010d:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800110:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800117:	00 00 00 
  80011a:	48 8b 00             	mov    (%rax),%rax
  80011d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800123:	89 c6                	mov    %eax,%esi
  800125:	48 bf 72 43 80 00 00 	movabs $0x804372,%rdi
  80012c:	00 00 00 
  80012f:	b8 00 00 00 00       	mov    $0x0,%eax
  800134:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  80013b:	00 00 00 
  80013e:	ff d1                	callq  *%rcx
		close(p[1]);
  800140:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800143:	89 c7                	mov    %eax,%edi
  800145:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  80014c:	00 00 00 
  80014f:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800151:	8b 55 80             	mov    -0x80(%rbp),%edx
  800154:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80015b:	00 00 00 
  80015e:	48 8b 00             	mov    (%rax),%rax
  800161:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800167:	89 c6                	mov    %eax,%esi
  800169:	48 bf 8f 43 80 00 00 	movabs $0x80438f,%rdi
  800170:	00 00 00 
  800173:	b8 00 00 00 00       	mov    $0x0,%eax
  800178:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  80017f:	00 00 00 
  800182:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800184:	8b 45 80             	mov    -0x80(%rbp),%eax
  800187:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  80018b:	ba 63 00 00 00       	mov    $0x63,%edx
  800190:	48 89 ce             	mov    %rcx,%rsi
  800193:	89 c7                	mov    %eax,%edi
  800195:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
  8001a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (i < 0)
  8001a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a8:	79 30                	jns    8001da <umain+0x197>
			panic("read: %e", i);
  8001aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ad:	89 c1                	mov    %eax,%ecx
  8001af:	48 ba ac 43 80 00 00 	movabs $0x8043ac,%rdx
  8001b6:	00 00 00 
  8001b9:	be 19 00 00 00       	mov    $0x19,%esi
  8001be:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  8001c5:	00 00 00 
  8001c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cd:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  8001d4:	00 00 00 
  8001d7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001dd:	48 98                	cltq   
  8001df:	c6 44 05 90 00       	movb   $0x0,-0x70(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001eb:	00 00 00 
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8001f5:	48 89 d6             	mov    %rdx,%rsi
  8001f8:	48 89 c7             	mov    %rax,%rdi
  8001fb:	48 b8 bd 14 80 00 00 	movabs $0x8014bd,%rax
  800202:	00 00 00 
  800205:	ff d0                	callq  *%rax
  800207:	85 c0                	test   %eax,%eax
  800209:	75 1d                	jne    800228 <umain+0x1e5>
			cprintf("\npipe read closed properly\n");
  80020b:	48 bf b5 43 80 00 00 	movabs $0x8043b5,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 24                	jmp    80024c <umain+0x209>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800228:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  80022c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022f:	89 c6                	mov    %eax,%esi
  800231:	48 bf d1 43 80 00 00 	movabs $0x8043d1,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		exit();
  80024c:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
  800258:	e9 1c 01 00 00       	jmpq   800379 <umain+0x336>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80025d:	8b 55 80             	mov    -0x80(%rbp),%edx
  800260:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800267:	00 00 00 
  80026a:	48 8b 00             	mov    (%rax),%rax
  80026d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800273:	89 c6                	mov    %eax,%esi
  800275:	48 bf 72 43 80 00 00 	movabs $0x804372,%rdi
  80027c:	00 00 00 
  80027f:	b8 00 00 00 00       	mov    $0x0,%eax
  800284:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  80028b:	00 00 00 
  80028e:	ff d1                	callq  *%rcx
		close(p[0]);
  800290:	8b 45 80             	mov    -0x80(%rbp),%eax
  800293:	89 c7                	mov    %eax,%edi
  800295:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002a1:	8b 55 84             	mov    -0x7c(%rbp),%edx
  8002a4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002b7:	89 c6                	mov    %eax,%esi
  8002b9:	48 bf e4 43 80 00 00 	movabs $0x8043e4,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  8002cf:	00 00 00 
  8002d2:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002d4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002db:	00 00 00 
  8002de:	48 8b 00             	mov    (%rax),%rax
  8002e1:	48 89 c7             	mov    %rax,%rdi
  8002e4:	48 b8 ef 12 80 00 00 	movabs $0x8012ef,%rax
  8002eb:	00 00 00 
  8002ee:	ff d0                	callq  *%rax
  8002f0:	48 63 d0             	movslq %eax,%rdx
  8002f3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002fa:	00 00 00 
  8002fd:	48 8b 08             	mov    (%rax),%rcx
  800300:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800303:	48 89 ce             	mov    %rcx,%rsi
  800306:	89 c7                	mov    %eax,%edi
  800308:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  80030f:	00 00 00 
  800312:	ff d0                	callq  *%rax
  800314:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800317:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80031e:	00 00 00 
  800321:	48 8b 00             	mov    (%rax),%rax
  800324:	48 89 c7             	mov    %rax,%rdi
  800327:	48 b8 ef 12 80 00 00 	movabs $0x8012ef,%rax
  80032e:	00 00 00 
  800331:	ff d0                	callq  *%rax
  800333:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800336:	74 30                	je     800368 <umain+0x325>
			panic("write: %e", i);
  800338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033b:	89 c1                	mov    %eax,%ecx
  80033d:	48 ba 01 44 80 00 00 	movabs $0x804401,%rdx
  800344:	00 00 00 
  800347:	be 25 00 00 00       	mov    $0x25,%esi
  80034c:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  800353:	00 00 00 
  800356:	b8 00 00 00 00       	mov    $0x0,%eax
  80035b:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  800362:	00 00 00 
  800365:	41 ff d0             	callq  *%r8
		close(p[1]);
  800368:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
	}
	wait(pid);
  800379:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037c:	89 c7                	mov    %eax,%edi
  80037e:	48 b8 c5 3c 80 00 00 	movabs $0x803cc5,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  80038a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800391:	00 00 00 
  800394:	48 be 0b 44 80 00 00 	movabs $0x80440b,%rsi
  80039b:	00 00 00 
  80039e:	48 89 30             	mov    %rsi,(%rax)
	if ((i = pipe(p)) < 0)
  8003a1:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003a5:	48 89 c7             	mov    %rax,%rdi
  8003a8:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  8003af:	00 00 00 
  8003b2:	ff d0                	callq  *%rax
  8003b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003bb:	79 30                	jns    8003ed <umain+0x3aa>
		panic("pipe: %e", i);
  8003bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c0:	89 c1                	mov    %eax,%ecx
  8003c2:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  8003c9:	00 00 00 
  8003cc:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003d1:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  8003d8:	00 00 00 
  8003db:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e0:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  8003e7:	00 00 00 
  8003ea:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8003ed:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800400:	79 30                	jns    800432 <umain+0x3ef>
		panic("fork: %e", i);
  800402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800405:	89 c1                	mov    %eax,%ecx
  800407:	48 ba 69 43 80 00 00 	movabs $0x804369,%rdx
  80040e:	00 00 00 
  800411:	be 2f 00 00 00       	mov    $0x2f,%esi
  800416:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  80041d:	00 00 00 
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  80042c:	00 00 00 
  80042f:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800432:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800436:	75 7d                	jne    8004b5 <umain+0x472>
		close(p[0]);
  800438:	8b 45 80             	mov    -0x80(%rbp),%eax
  80043b:	89 c7                	mov    %eax,%edi
  80043d:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  800444:	00 00 00 
  800447:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800449:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  800450:	00 00 00 
  800453:	b8 00 00 00 00       	mov    $0x0,%eax
  800458:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  80045f:	00 00 00 
  800462:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  800464:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800467:	ba 01 00 00 00       	mov    $0x1,%edx
  80046c:	48 be 1a 44 80 00 00 	movabs $0x80441a,%rsi
  800473:	00 00 00 
  800476:	89 c7                	mov    %eax,%edi
  800478:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  80047f:	00 00 00 
  800482:	ff d0                	callq  *%rax
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	74 2a                	je     8004b3 <umain+0x470>
				break;
  800489:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  80048a:	48 bf 1c 44 80 00 00 	movabs $0x80441c,%rdi
  800491:	00 00 00 
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  8004a0:	00 00 00 
  8004a3:	ff d2                	callq  *%rdx
		exit();
  8004a5:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8004ac:	00 00 00 
  8004af:	ff d0                	callq  *%rax
  8004b1:	eb 02                	jmp    8004b5 <umain+0x472>
		}
  8004b3:	eb 94                	jmp    800449 <umain+0x406>
	}
	close(p[0]);
  8004b5:	8b 45 80             	mov    -0x80(%rbp),%eax
  8004b8:	89 c7                	mov    %eax,%edi
  8004ba:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
	close(p[1]);
  8004c6:	8b 45 84             	mov    -0x7c(%rbp),%eax
  8004c9:	89 c7                	mov    %eax,%edi
  8004cb:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  8004d2:	00 00 00 
  8004d5:	ff d0                	callq  *%rax
	wait(pid);
  8004d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	48 b8 c5 3c 80 00 00 	movabs $0x803cc5,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  8004e8:	48 bf 39 44 80 00 00 	movabs $0x804439,%rdi
  8004ef:	00 00 00 
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  8004fe:	00 00 00 
  800501:	ff d2                	callq  *%rdx
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   

0000000000800505 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800505:	55                   	push   %rbp
  800506:	48 89 e5             	mov    %rsp,%rbp
  800509:	48 83 ec 10          	sub    $0x10,%rsp
  80050d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800510:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800514:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80051b:	00 00 00 
  80051e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800525:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800529:	7e 14                	jle    80053f <libmain+0x3a>
		binaryname = argv[0];
  80052b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052f:	48 8b 10             	mov    (%rax),%rdx
  800532:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800539:	00 00 00 
  80053c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80053f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800546:	48 89 d6             	mov    %rdx,%rsi
  800549:	89 c7                	mov    %eax,%edi
  80054b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800552:	00 00 00 
  800555:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800557:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  80055e:	00 00 00 
  800561:	ff d0                	callq  *%rax
}
  800563:	c9                   	leaveq 
  800564:	c3                   	retq   

0000000000800565 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800565:	55                   	push   %rbp
  800566:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800569:	48 b8 13 24 80 00 00 	movabs $0x802413,%rax
  800570:	00 00 00 
  800573:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800575:	bf 00 00 00 00       	mov    $0x0,%edi
  80057a:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  800581:	00 00 00 
  800584:	ff d0                	callq  *%rax
}
  800586:	5d                   	pop    %rbp
  800587:	c3                   	retq   

0000000000800588 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800588:	55                   	push   %rbp
  800589:	48 89 e5             	mov    %rsp,%rbp
  80058c:	53                   	push   %rbx
  80058d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800594:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80059b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005a1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005a8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005af:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005b6:	84 c0                	test   %al,%al
  8005b8:	74 23                	je     8005dd <_panic+0x55>
  8005ba:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005c1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005c5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005c9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005cd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8005d1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8005d5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8005d9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8005dd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8005e4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8005eb:	00 00 00 
  8005ee:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8005f5:	00 00 00 
  8005f8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005fc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800603:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80060a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800611:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800618:	00 00 00 
  80061b:	48 8b 18             	mov    (%rax),%rbx
  80061e:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
  80062a:	89 c6                	mov    %eax,%esi
  80062c:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800632:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800639:	41 89 d0             	mov    %edx,%r8d
  80063c:	48 89 c1             	mov    %rax,%rcx
  80063f:	48 89 da             	mov    %rbx,%rdx
  800642:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  800649:	00 00 00 
  80064c:	b8 00 00 00 00       	mov    $0x0,%eax
  800651:	49 b9 c1 07 80 00 00 	movabs $0x8007c1,%r9
  800658:	00 00 00 
  80065b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80065e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800665:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80066c:	48 89 d6             	mov    %rdx,%rsi
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 15 07 80 00 00 	movabs $0x800715,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
	cprintf("\n");
  80067e:	48 bf 7b 44 80 00 00 	movabs $0x80447b,%rdi
  800685:	00 00 00 
  800688:	b8 00 00 00 00       	mov    $0x0,%eax
  80068d:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  800694:	00 00 00 
  800697:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800699:	cc                   	int3   
  80069a:	eb fd                	jmp    800699 <_panic+0x111>

000000000080069c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80069c:	55                   	push   %rbp
  80069d:	48 89 e5             	mov    %rsp,%rbp
  8006a0:	48 83 ec 10          	sub    $0x10,%rsp
  8006a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006af:	8b 00                	mov    (%rax),%eax
  8006b1:	8d 48 01             	lea    0x1(%rax),%ecx
  8006b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006b8:	89 0a                	mov    %ecx,(%rdx)
  8006ba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006bd:	89 d1                	mov    %edx,%ecx
  8006bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006c3:	48 98                	cltq   
  8006c5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006cd:	8b 00                	mov    (%rax),%eax
  8006cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d4:	75 2c                	jne    800702 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	48 98                	cltq   
  8006de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e2:	48 83 c2 08          	add    $0x8,%rdx
  8006e6:	48 89 c6             	mov    %rax,%rsi
  8006e9:	48 89 d7             	mov    %rdx,%rdi
  8006ec:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8006f3:	00 00 00 
  8006f6:	ff d0                	callq  *%rax
        b->idx = 0;
  8006f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006fc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800706:	8b 40 04             	mov    0x4(%rax),%eax
  800709:	8d 50 01             	lea    0x1(%rax),%edx
  80070c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800710:	89 50 04             	mov    %edx,0x4(%rax)
}
  800713:	c9                   	leaveq 
  800714:	c3                   	retq   

0000000000800715 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800715:	55                   	push   %rbp
  800716:	48 89 e5             	mov    %rsp,%rbp
  800719:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800720:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800727:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80072e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800735:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80073c:	48 8b 0a             	mov    (%rdx),%rcx
  80073f:	48 89 08             	mov    %rcx,(%rax)
  800742:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800746:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80074a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80074e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800752:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800759:	00 00 00 
    b.cnt = 0;
  80075c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800763:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800766:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80076d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800774:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80077b:	48 89 c6             	mov    %rax,%rsi
  80077e:	48 bf 9c 06 80 00 00 	movabs $0x80069c,%rdi
  800785:	00 00 00 
  800788:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  80078f:	00 00 00 
  800792:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800794:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80079a:	48 98                	cltq   
  80079c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007a3:	48 83 c2 08          	add    $0x8,%rdx
  8007a7:	48 89 c6             	mov    %rax,%rsi
  8007aa:	48 89 d7             	mov    %rdx,%rdi
  8007ad:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8007b4:	00 00 00 
  8007b7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007bf:	c9                   	leaveq 
  8007c0:	c3                   	retq   

00000000008007c1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007c1:	55                   	push   %rbp
  8007c2:	48 89 e5             	mov    %rsp,%rbp
  8007c5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007cc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8007d3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8007da:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8007e1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8007e8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8007ef:	84 c0                	test   %al,%al
  8007f1:	74 20                	je     800813 <cprintf+0x52>
  8007f3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8007f7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8007fb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007ff:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800803:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800807:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80080b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80080f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800813:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80081a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800821:	00 00 00 
  800824:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80082b:	00 00 00 
  80082e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800832:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800839:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800840:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800847:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80084e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800855:	48 8b 0a             	mov    (%rdx),%rcx
  800858:	48 89 08             	mov    %rcx,(%rax)
  80085b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800863:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800867:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80086b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800872:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800879:	48 89 d6             	mov    %rdx,%rsi
  80087c:	48 89 c7             	mov    %rax,%rdi
  80087f:	48 b8 15 07 80 00 00 	movabs $0x800715,%rax
  800886:	00 00 00 
  800889:	ff d0                	callq  *%rax
  80088b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800891:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800897:	c9                   	leaveq 
  800898:	c3                   	retq   

0000000000800899 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800899:	55                   	push   %rbp
  80089a:	48 89 e5             	mov    %rsp,%rbp
  80089d:	48 83 ec 30          	sub    $0x30,%rsp
  8008a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ad:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008b0:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008b4:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8008bb:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8008bf:	77 42                	ja     800903 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008c1:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8008c4:	8d 78 ff             	lea    -0x1(%rax),%edi
  8008c7:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	48 f7 f6             	div    %rsi
  8008d6:	49 89 c2             	mov    %rax,%r10
  8008d9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8008dc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8008df:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8008e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008e7:	41 89 c9             	mov    %ecx,%r9d
  8008ea:	41 89 f8             	mov    %edi,%r8d
  8008ed:	89 d1                	mov    %edx,%ecx
  8008ef:	4c 89 d2             	mov    %r10,%rdx
  8008f2:	48 89 c7             	mov    %rax,%rdi
  8008f5:	48 b8 99 08 80 00 00 	movabs $0x800899,%rax
  8008fc:	00 00 00 
  8008ff:	ff d0                	callq  *%rax
  800901:	eb 1e                	jmp    800921 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800903:	eb 12                	jmp    800917 <printnum+0x7e>
			putch(padc, putdat);
  800905:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800909:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80090c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800910:	48 89 ce             	mov    %rcx,%rsi
  800913:	89 d7                	mov    %edx,%edi
  800915:	ff d0                	callq  *%rax
		while (--width > 0)
  800917:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80091b:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80091f:	7f e4                	jg     800905 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800921:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
  80092d:	48 f7 f1             	div    %rcx
  800930:	48 b8 70 46 80 00 00 	movabs $0x804670,%rax
  800937:	00 00 00 
  80093a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80093e:	0f be d0             	movsbl %al,%edx
  800941:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800945:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800949:	48 89 ce             	mov    %rcx,%rsi
  80094c:	89 d7                	mov    %edx,%edi
  80094e:	ff d0                	callq  *%rax
}
  800950:	c9                   	leaveq 
  800951:	c3                   	retq   

0000000000800952 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800952:	55                   	push   %rbp
  800953:	48 89 e5             	mov    %rsp,%rbp
  800956:	48 83 ec 20          	sub    $0x20,%rsp
  80095a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80095e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800961:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800965:	7e 4f                	jle    8009b6 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	8b 00                	mov    (%rax),%eax
  80096d:	83 f8 30             	cmp    $0x30,%eax
  800970:	73 24                	jae    800996 <getuint+0x44>
  800972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800976:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80097a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097e:	8b 00                	mov    (%rax),%eax
  800980:	89 c0                	mov    %eax,%eax
  800982:	48 01 d0             	add    %rdx,%rax
  800985:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800989:	8b 12                	mov    (%rdx),%edx
  80098b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80098e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800992:	89 0a                	mov    %ecx,(%rdx)
  800994:	eb 14                	jmp    8009aa <getuint+0x58>
  800996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80099e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009aa:	48 8b 00             	mov    (%rax),%rax
  8009ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b1:	e9 9d 00 00 00       	jmpq   800a53 <getuint+0x101>
	else if (lflag)
  8009b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009ba:	74 4c                	je     800a08 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8009bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c0:	8b 00                	mov    (%rax),%eax
  8009c2:	83 f8 30             	cmp    $0x30,%eax
  8009c5:	73 24                	jae    8009eb <getuint+0x99>
  8009c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d3:	8b 00                	mov    (%rax),%eax
  8009d5:	89 c0                	mov    %eax,%eax
  8009d7:	48 01 d0             	add    %rdx,%rax
  8009da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009de:	8b 12                	mov    (%rdx),%edx
  8009e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e7:	89 0a                	mov    %ecx,(%rdx)
  8009e9:	eb 14                	jmp    8009ff <getuint+0xad>
  8009eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ef:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009f3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ff:	48 8b 00             	mov    (%rax),%rax
  800a02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a06:	eb 4b                	jmp    800a53 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0c:	8b 00                	mov    (%rax),%eax
  800a0e:	83 f8 30             	cmp    $0x30,%eax
  800a11:	73 24                	jae    800a37 <getuint+0xe5>
  800a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a17:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1f:	8b 00                	mov    (%rax),%eax
  800a21:	89 c0                	mov    %eax,%eax
  800a23:	48 01 d0             	add    %rdx,%rax
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	8b 12                	mov    (%rdx),%edx
  800a2c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a33:	89 0a                	mov    %ecx,(%rdx)
  800a35:	eb 14                	jmp    800a4b <getuint+0xf9>
  800a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a3f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a47:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4b:	8b 00                	mov    (%rax),%eax
  800a4d:	89 c0                	mov    %eax,%eax
  800a4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a57:	c9                   	leaveq 
  800a58:	c3                   	retq   

0000000000800a59 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a59:	55                   	push   %rbp
  800a5a:	48 89 e5             	mov    %rsp,%rbp
  800a5d:	48 83 ec 20          	sub    $0x20,%rsp
  800a61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a65:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a68:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a6c:	7e 4f                	jle    800abd <getint+0x64>
		x=va_arg(*ap, long long);
  800a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a72:	8b 00                	mov    (%rax),%eax
  800a74:	83 f8 30             	cmp    $0x30,%eax
  800a77:	73 24                	jae    800a9d <getint+0x44>
  800a79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a85:	8b 00                	mov    (%rax),%eax
  800a87:	89 c0                	mov    %eax,%eax
  800a89:	48 01 d0             	add    %rdx,%rax
  800a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a90:	8b 12                	mov    (%rdx),%edx
  800a92:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a99:	89 0a                	mov    %ecx,(%rdx)
  800a9b:	eb 14                	jmp    800ab1 <getint+0x58>
  800a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800aa5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800aa9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab1:	48 8b 00             	mov    (%rax),%rax
  800ab4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab8:	e9 9d 00 00 00       	jmpq   800b5a <getint+0x101>
	else if (lflag)
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ac1:	74 4c                	je     800b0f <getint+0xb6>
		x=va_arg(*ap, long);
  800ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac7:	8b 00                	mov    (%rax),%eax
  800ac9:	83 f8 30             	cmp    $0x30,%eax
  800acc:	73 24                	jae    800af2 <getint+0x99>
  800ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ada:	8b 00                	mov    (%rax),%eax
  800adc:	89 c0                	mov    %eax,%eax
  800ade:	48 01 d0             	add    %rdx,%rax
  800ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae5:	8b 12                	mov    (%rdx),%edx
  800ae7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aee:	89 0a                	mov    %ecx,(%rdx)
  800af0:	eb 14                	jmp    800b06 <getint+0xad>
  800af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800afa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800afe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b02:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b06:	48 8b 00             	mov    (%rax),%rax
  800b09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b0d:	eb 4b                	jmp    800b5a <getint+0x101>
	else
		x=va_arg(*ap, int);
  800b0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b13:	8b 00                	mov    (%rax),%eax
  800b15:	83 f8 30             	cmp    $0x30,%eax
  800b18:	73 24                	jae    800b3e <getint+0xe5>
  800b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b26:	8b 00                	mov    (%rax),%eax
  800b28:	89 c0                	mov    %eax,%eax
  800b2a:	48 01 d0             	add    %rdx,%rax
  800b2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b31:	8b 12                	mov    (%rdx),%edx
  800b33:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3a:	89 0a                	mov    %ecx,(%rdx)
  800b3c:	eb 14                	jmp    800b52 <getint+0xf9>
  800b3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b42:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b46:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b52:	8b 00                	mov    (%rax),%eax
  800b54:	48 98                	cltq   
  800b56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b5e:	c9                   	leaveq 
  800b5f:	c3                   	retq   

0000000000800b60 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b60:	55                   	push   %rbp
  800b61:	48 89 e5             	mov    %rsp,%rbp
  800b64:	41 54                	push   %r12
  800b66:	53                   	push   %rbx
  800b67:	48 83 ec 60          	sub    $0x60,%rsp
  800b6b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b6f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b73:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b77:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b7b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b7f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b83:	48 8b 0a             	mov    (%rdx),%rcx
  800b86:	48 89 08             	mov    %rcx,(%rax)
  800b89:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b8d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b91:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b95:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b99:	eb 17                	jmp    800bb2 <vprintfmt+0x52>
			if (ch == '\0')
  800b9b:	85 db                	test   %ebx,%ebx
  800b9d:	0f 84 c5 04 00 00    	je     801068 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800ba3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bab:	48 89 d6             	mov    %rdx,%rsi
  800bae:	89 df                	mov    %ebx,%edi
  800bb0:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bb6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bba:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bbe:	0f b6 00             	movzbl (%rax),%eax
  800bc1:	0f b6 d8             	movzbl %al,%ebx
  800bc4:	83 fb 25             	cmp    $0x25,%ebx
  800bc7:	75 d2                	jne    800b9b <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800bc9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bcd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800bd4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800bdb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800be2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800be9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bf1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bf5:	0f b6 00             	movzbl (%rax),%eax
  800bf8:	0f b6 d8             	movzbl %al,%ebx
  800bfb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bfe:	83 f8 55             	cmp    $0x55,%eax
  800c01:	0f 87 2e 04 00 00    	ja     801035 <vprintfmt+0x4d5>
  800c07:	89 c0                	mov    %eax,%eax
  800c09:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c10:	00 
  800c11:	48 b8 98 46 80 00 00 	movabs $0x804698,%rax
  800c18:	00 00 00 
  800c1b:	48 01 d0             	add    %rdx,%rax
  800c1e:	48 8b 00             	mov    (%rax),%rax
  800c21:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c27:	eb c0                	jmp    800be9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c2d:	eb ba                	jmp    800be9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c4a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c4e:	0f b6 00             	movzbl (%rax),%eax
  800c51:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c54:	83 fb 2f             	cmp    $0x2f,%ebx
  800c57:	7e 0c                	jle    800c65 <vprintfmt+0x105>
  800c59:	83 fb 39             	cmp    $0x39,%ebx
  800c5c:	7f 07                	jg     800c65 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800c5e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800c63:	eb d1                	jmp    800c36 <vprintfmt+0xd6>
			goto process_precision;
  800c65:	eb 50                	jmp    800cb7 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800c67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6a:	83 f8 30             	cmp    $0x30,%eax
  800c6d:	73 17                	jae    800c86 <vprintfmt+0x126>
  800c6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c76:	89 d2                	mov    %edx,%edx
  800c78:	48 01 d0             	add    %rdx,%rax
  800c7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7e:	83 c2 08             	add    $0x8,%edx
  800c81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c84:	eb 0c                	jmp    800c92 <vprintfmt+0x132>
  800c86:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c8a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c92:	8b 00                	mov    (%rax),%eax
  800c94:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c97:	eb 1e                	jmp    800cb7 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800c99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c9d:	79 07                	jns    800ca6 <vprintfmt+0x146>
				width = 0;
  800c9f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ca6:	e9 3e ff ff ff       	jmpq   800be9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cab:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cb2:	e9 32 ff ff ff       	jmpq   800be9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800cb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbb:	79 0d                	jns    800cca <vprintfmt+0x16a>
				width = precision, precision = -1;
  800cbd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cc0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cc3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cca:	e9 1a ff ff ff       	jmpq   800be9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ccf:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800cd3:	e9 11 ff ff ff       	jmpq   800be9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800cd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdb:	83 f8 30             	cmp    $0x30,%eax
  800cde:	73 17                	jae    800cf7 <vprintfmt+0x197>
  800ce0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce7:	89 d2                	mov    %edx,%edx
  800ce9:	48 01 d0             	add    %rdx,%rax
  800cec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cef:	83 c2 08             	add    $0x8,%edx
  800cf2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf5:	eb 0c                	jmp    800d03 <vprintfmt+0x1a3>
  800cf7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cfb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d03:	8b 10                	mov    (%rax),%edx
  800d05:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0d:	48 89 ce             	mov    %rcx,%rsi
  800d10:	89 d7                	mov    %edx,%edi
  800d12:	ff d0                	callq  *%rax
			break;
  800d14:	e9 4a 03 00 00       	jmpq   801063 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1c:	83 f8 30             	cmp    $0x30,%eax
  800d1f:	73 17                	jae    800d38 <vprintfmt+0x1d8>
  800d21:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d25:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d28:	89 d2                	mov    %edx,%edx
  800d2a:	48 01 d0             	add    %rdx,%rax
  800d2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d30:	83 c2 08             	add    $0x8,%edx
  800d33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d36:	eb 0c                	jmp    800d44 <vprintfmt+0x1e4>
  800d38:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d3c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d44:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d46:	85 db                	test   %ebx,%ebx
  800d48:	79 02                	jns    800d4c <vprintfmt+0x1ec>
				err = -err;
  800d4a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d4c:	83 fb 15             	cmp    $0x15,%ebx
  800d4f:	7f 16                	jg     800d67 <vprintfmt+0x207>
  800d51:	48 b8 c0 45 80 00 00 	movabs $0x8045c0,%rax
  800d58:	00 00 00 
  800d5b:	48 63 d3             	movslq %ebx,%rdx
  800d5e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d62:	4d 85 e4             	test   %r12,%r12
  800d65:	75 2e                	jne    800d95 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800d67:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6f:	89 d9                	mov    %ebx,%ecx
  800d71:	48 ba 81 46 80 00 00 	movabs $0x804681,%rdx
  800d78:	00 00 00 
  800d7b:	48 89 c7             	mov    %rax,%rdi
  800d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d83:	49 b8 71 10 80 00 00 	movabs $0x801071,%r8
  800d8a:	00 00 00 
  800d8d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d90:	e9 ce 02 00 00       	jmpq   801063 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800d95:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9d:	4c 89 e1             	mov    %r12,%rcx
  800da0:	48 ba 8a 46 80 00 00 	movabs $0x80468a,%rdx
  800da7:	00 00 00 
  800daa:	48 89 c7             	mov    %rax,%rdi
  800dad:	b8 00 00 00 00       	mov    $0x0,%eax
  800db2:	49 b8 71 10 80 00 00 	movabs $0x801071,%r8
  800db9:	00 00 00 
  800dbc:	41 ff d0             	callq  *%r8
			break;
  800dbf:	e9 9f 02 00 00       	jmpq   801063 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800dc4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc7:	83 f8 30             	cmp    $0x30,%eax
  800dca:	73 17                	jae    800de3 <vprintfmt+0x283>
  800dcc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dd3:	89 d2                	mov    %edx,%edx
  800dd5:	48 01 d0             	add    %rdx,%rax
  800dd8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ddb:	83 c2 08             	add    $0x8,%edx
  800dde:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800de1:	eb 0c                	jmp    800def <vprintfmt+0x28f>
  800de3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800de7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800deb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800def:	4c 8b 20             	mov    (%rax),%r12
  800df2:	4d 85 e4             	test   %r12,%r12
  800df5:	75 0a                	jne    800e01 <vprintfmt+0x2a1>
				p = "(null)";
  800df7:	49 bc 8d 46 80 00 00 	movabs $0x80468d,%r12
  800dfe:	00 00 00 
			if (width > 0 && padc != '-')
  800e01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e05:	7e 3f                	jle    800e46 <vprintfmt+0x2e6>
  800e07:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e0b:	74 39                	je     800e46 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e10:	48 98                	cltq   
  800e12:	48 89 c6             	mov    %rax,%rsi
  800e15:	4c 89 e7             	mov    %r12,%rdi
  800e18:	48 b8 1d 13 80 00 00 	movabs $0x80131d,%rax
  800e1f:	00 00 00 
  800e22:	ff d0                	callq  *%rax
  800e24:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e27:	eb 17                	jmp    800e40 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800e29:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e2d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e35:	48 89 ce             	mov    %rcx,%rsi
  800e38:	89 d7                	mov    %edx,%edi
  800e3a:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800e3c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e44:	7f e3                	jg     800e29 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	eb 37                	jmp    800e7f <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800e48:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e4c:	74 1e                	je     800e6c <vprintfmt+0x30c>
  800e4e:	83 fb 1f             	cmp    $0x1f,%ebx
  800e51:	7e 05                	jle    800e58 <vprintfmt+0x2f8>
  800e53:	83 fb 7e             	cmp    $0x7e,%ebx
  800e56:	7e 14                	jle    800e6c <vprintfmt+0x30c>
					putch('?', putdat);
  800e58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e60:	48 89 d6             	mov    %rdx,%rsi
  800e63:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e68:	ff d0                	callq  *%rax
  800e6a:	eb 0f                	jmp    800e7b <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800e6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e74:	48 89 d6             	mov    %rdx,%rsi
  800e77:	89 df                	mov    %ebx,%edi
  800e79:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e7f:	4c 89 e0             	mov    %r12,%rax
  800e82:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e86:	0f b6 00             	movzbl (%rax),%eax
  800e89:	0f be d8             	movsbl %al,%ebx
  800e8c:	85 db                	test   %ebx,%ebx
  800e8e:	74 10                	je     800ea0 <vprintfmt+0x340>
  800e90:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e94:	78 b2                	js     800e48 <vprintfmt+0x2e8>
  800e96:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e9e:	79 a8                	jns    800e48 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800ea0:	eb 16                	jmp    800eb8 <vprintfmt+0x358>
				putch(' ', putdat);
  800ea2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eaa:	48 89 d6             	mov    %rdx,%rsi
  800ead:	bf 20 00 00 00       	mov    $0x20,%edi
  800eb2:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800eb4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eb8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ebc:	7f e4                	jg     800ea2 <vprintfmt+0x342>
			break;
  800ebe:	e9 a0 01 00 00       	jmpq   801063 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ec3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec7:	be 03 00 00 00       	mov    $0x3,%esi
  800ecc:	48 89 c7             	mov    %rax,%rdi
  800ecf:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800ed6:	00 00 00 
  800ed9:	ff d0                	callq  *%rax
  800edb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 85 c0             	test   %rax,%rax
  800ee6:	79 1d                	jns    800f05 <vprintfmt+0x3a5>
				putch('-', putdat);
  800ee8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef0:	48 89 d6             	mov    %rdx,%rsi
  800ef3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ef8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800efa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efe:	48 f7 d8             	neg    %rax
  800f01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f05:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f0c:	e9 e5 00 00 00       	jmpq   800ff6 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f11:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f15:	be 03 00 00 00       	mov    $0x3,%esi
  800f1a:	48 89 c7             	mov    %rax,%rdi
  800f1d:	48 b8 52 09 80 00 00 	movabs $0x800952,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	callq  *%rax
  800f29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f2d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f34:	e9 bd 00 00 00       	jmpq   800ff6 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f41:	48 89 d6             	mov    %rdx,%rsi
  800f44:	bf 58 00 00 00       	mov    $0x58,%edi
  800f49:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f53:	48 89 d6             	mov    %rdx,%rsi
  800f56:	bf 58 00 00 00       	mov    $0x58,%edi
  800f5b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f65:	48 89 d6             	mov    %rdx,%rsi
  800f68:	bf 58 00 00 00       	mov    $0x58,%edi
  800f6d:	ff d0                	callq  *%rax
			break;
  800f6f:	e9 ef 00 00 00       	jmpq   801063 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800f74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7c:	48 89 d6             	mov    %rdx,%rsi
  800f7f:	bf 30 00 00 00       	mov    $0x30,%edi
  800f84:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8e:	48 89 d6             	mov    %rdx,%rsi
  800f91:	bf 78 00 00 00       	mov    $0x78,%edi
  800f96:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f9b:	83 f8 30             	cmp    $0x30,%eax
  800f9e:	73 17                	jae    800fb7 <vprintfmt+0x457>
  800fa0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fa7:	89 d2                	mov    %edx,%edx
  800fa9:	48 01 d0             	add    %rdx,%rax
  800fac:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800faf:	83 c2 08             	add    $0x8,%edx
  800fb2:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800fb5:	eb 0c                	jmp    800fc3 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800fb7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fbb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fbf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fc3:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800fc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fca:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fd1:	eb 23                	jmp    800ff6 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fd3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fd7:	be 03 00 00 00       	mov    $0x3,%esi
  800fdc:	48 89 c7             	mov    %rax,%rdi
  800fdf:	48 b8 52 09 80 00 00 	movabs $0x800952,%rax
  800fe6:	00 00 00 
  800fe9:	ff d0                	callq  *%rax
  800feb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fef:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ff6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ffb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ffe:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801001:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801005:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801009:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80100d:	45 89 c1             	mov    %r8d,%r9d
  801010:	41 89 f8             	mov    %edi,%r8d
  801013:	48 89 c7             	mov    %rax,%rdi
  801016:	48 b8 99 08 80 00 00 	movabs $0x800899,%rax
  80101d:	00 00 00 
  801020:	ff d0                	callq  *%rax
			break;
  801022:	eb 3f                	jmp    801063 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801024:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801028:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80102c:	48 89 d6             	mov    %rdx,%rsi
  80102f:	89 df                	mov    %ebx,%edi
  801031:	ff d0                	callq  *%rax
			break;
  801033:	eb 2e                	jmp    801063 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801035:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801039:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103d:	48 89 d6             	mov    %rdx,%rsi
  801040:	bf 25 00 00 00       	mov    $0x25,%edi
  801045:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801047:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80104c:	eb 05                	jmp    801053 <vprintfmt+0x4f3>
  80104e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801053:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801057:	48 83 e8 01          	sub    $0x1,%rax
  80105b:	0f b6 00             	movzbl (%rax),%eax
  80105e:	3c 25                	cmp    $0x25,%al
  801060:	75 ec                	jne    80104e <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801062:	90                   	nop
		}
	}
  801063:	e9 31 fb ff ff       	jmpq   800b99 <vprintfmt+0x39>
	va_end(aq);
}
  801068:	48 83 c4 60          	add    $0x60,%rsp
  80106c:	5b                   	pop    %rbx
  80106d:	41 5c                	pop    %r12
  80106f:	5d                   	pop    %rbp
  801070:	c3                   	retq   

0000000000801071 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80107c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801083:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80108a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801091:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801098:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80109f:	84 c0                	test   %al,%al
  8010a1:	74 20                	je     8010c3 <printfmt+0x52>
  8010a3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010a7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010ab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010af:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010b3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010b7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010bb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010bf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010c3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010ca:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010d1:	00 00 00 
  8010d4:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010db:	00 00 00 
  8010de:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010e9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010f0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010f7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010fe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801105:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80110c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801113:	48 89 c7             	mov    %rax,%rdi
  801116:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  80111d:	00 00 00 
  801120:	ff d0                	callq  *%rax
	va_end(ap);
}
  801122:	c9                   	leaveq 
  801123:	c3                   	retq   

0000000000801124 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801124:	55                   	push   %rbp
  801125:	48 89 e5             	mov    %rsp,%rbp
  801128:	48 83 ec 10          	sub    $0x10,%rsp
  80112c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80112f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801137:	8b 40 10             	mov    0x10(%rax),%eax
  80113a:	8d 50 01             	lea    0x1(%rax),%edx
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801141:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801148:	48 8b 10             	mov    (%rax),%rdx
  80114b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801153:	48 39 c2             	cmp    %rax,%rdx
  801156:	73 17                	jae    80116f <sprintputch+0x4b>
		*b->buf++ = ch;
  801158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115c:	48 8b 00             	mov    (%rax),%rax
  80115f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801163:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801167:	48 89 0a             	mov    %rcx,(%rdx)
  80116a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80116d:	88 10                	mov    %dl,(%rax)
}
  80116f:	c9                   	leaveq 
  801170:	c3                   	retq   

0000000000801171 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801171:	55                   	push   %rbp
  801172:	48 89 e5             	mov    %rsp,%rbp
  801175:	48 83 ec 50          	sub    $0x50,%rsp
  801179:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80117d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801180:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801184:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801188:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80118c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801190:	48 8b 0a             	mov    (%rdx),%rcx
  801193:	48 89 08             	mov    %rcx,(%rax)
  801196:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80119a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80119e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011a2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011aa:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011ae:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011b1:	48 98                	cltq   
  8011b3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011bb:	48 01 d0             	add    %rdx,%rax
  8011be:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011c9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011ce:	74 06                	je     8011d6 <vsnprintf+0x65>
  8011d0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011d4:	7f 07                	jg     8011dd <vsnprintf+0x6c>
		return -E_INVAL;
  8011d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011db:	eb 2f                	jmp    80120c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011dd:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011e1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011e5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011e9:	48 89 c6             	mov    %rax,%rsi
  8011ec:	48 bf 24 11 80 00 00 	movabs $0x801124,%rdi
  8011f3:	00 00 00 
  8011f6:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  8011fd:	00 00 00 
  801200:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801202:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801206:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801209:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80120c:	c9                   	leaveq 
  80120d:	c3                   	retq   

000000000080120e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120e:	55                   	push   %rbp
  80120f:	48 89 e5             	mov    %rsp,%rbp
  801212:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801219:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801220:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801226:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80122d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801234:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80123b:	84 c0                	test   %al,%al
  80123d:	74 20                	je     80125f <snprintf+0x51>
  80123f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801243:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801247:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80124b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80124f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801253:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801257:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80125b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80125f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801266:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80126d:	00 00 00 
  801270:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801277:	00 00 00 
  80127a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80127e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801285:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80128c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801293:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80129a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012a1:	48 8b 0a             	mov    (%rdx),%rcx
  8012a4:	48 89 08             	mov    %rcx,(%rax)
  8012a7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012ab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012af:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012b3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012b7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012be:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012c5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012d2:	48 89 c7             	mov    %rax,%rdi
  8012d5:	48 b8 71 11 80 00 00 	movabs $0x801171,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
  8012e1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012e7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012ed:	c9                   	leaveq 
  8012ee:	c3                   	retq   

00000000008012ef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012ef:	55                   	push   %rbp
  8012f0:	48 89 e5             	mov    %rsp,%rbp
  8012f3:	48 83 ec 18          	sub    $0x18,%rsp
  8012f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801302:	eb 09                	jmp    80130d <strlen+0x1e>
		n++;
  801304:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801308:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80130d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	84 c0                	test   %al,%al
  801316:	75 ec                	jne    801304 <strlen+0x15>
	return n;
  801318:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80131b:	c9                   	leaveq 
  80131c:	c3                   	retq   

000000000080131d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80131d:	55                   	push   %rbp
  80131e:	48 89 e5             	mov    %rsp,%rbp
  801321:	48 83 ec 20          	sub    $0x20,%rsp
  801325:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801329:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80132d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801334:	eb 0e                	jmp    801344 <strnlen+0x27>
		n++;
  801336:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80133a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80133f:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801344:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801349:	74 0b                	je     801356 <strnlen+0x39>
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	75 e0                	jne    801336 <strnlen+0x19>
	return n;
  801356:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   

000000000080135b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80135b:	55                   	push   %rbp
  80135c:	48 89 e5             	mov    %rsp,%rbp
  80135f:	48 83 ec 20          	sub    $0x20,%rsp
  801363:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801367:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801373:	90                   	nop
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80137c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801380:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801384:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801388:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80138c:	0f b6 12             	movzbl (%rdx),%edx
  80138f:	88 10                	mov    %dl,(%rax)
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	84 c0                	test   %al,%al
  801396:	75 dc                	jne    801374 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 20          	sub    $0x20,%rsp
  8013a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b2:	48 89 c7             	mov    %rax,%rdi
  8013b5:	48 b8 ef 12 80 00 00 	movabs $0x8012ef,%rax
  8013bc:	00 00 00 
  8013bf:	ff d0                	callq  *%rax
  8013c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c7:	48 63 d0             	movslq %eax,%rdx
  8013ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ce:	48 01 c2             	add    %rax,%rdx
  8013d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d5:	48 89 c6             	mov    %rax,%rsi
  8013d8:	48 89 d7             	mov    %rdx,%rdi
  8013db:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  8013e2:	00 00 00 
  8013e5:	ff d0                	callq  *%rax
	return dst;
  8013e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013eb:	c9                   	leaveq 
  8013ec:	c3                   	retq   

00000000008013ed <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013ed:	55                   	push   %rbp
  8013ee:	48 89 e5             	mov    %rsp,%rbp
  8013f1:	48 83 ec 28          	sub    $0x28,%rsp
  8013f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801409:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801410:	00 
  801411:	eb 2a                	jmp    80143d <strncpy+0x50>
		*dst++ = *src;
  801413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801417:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80141b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80141f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801423:	0f b6 12             	movzbl (%rdx),%edx
  801426:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801428:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	84 c0                	test   %al,%al
  801431:	74 05                	je     801438 <strncpy+0x4b>
			src++;
  801433:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801438:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80143d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801441:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801445:	72 cc                	jb     801413 <strncpy+0x26>
	}
	return ret;
  801447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80144b:	c9                   	leaveq 
  80144c:	c3                   	retq   

000000000080144d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80144d:	55                   	push   %rbp
  80144e:	48 89 e5             	mov    %rsp,%rbp
  801451:	48 83 ec 28          	sub    $0x28,%rsp
  801455:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801459:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80145d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801465:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801469:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80146e:	74 3d                	je     8014ad <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801470:	eb 1d                	jmp    80148f <strlcpy+0x42>
			*dst++ = *src++;
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80147a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80147e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801482:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801486:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80148a:	0f b6 12             	movzbl (%rdx),%edx
  80148d:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80148f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801494:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801499:	74 0b                	je     8014a6 <strlcpy+0x59>
  80149b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	84 c0                	test   %al,%al
  8014a4:	75 cc                	jne    801472 <strlcpy+0x25>
		*dst = '\0';
  8014a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014aa:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	48 29 c2             	sub    %rax,%rdx
  8014b8:	48 89 d0             	mov    %rdx,%rax
}
  8014bb:	c9                   	leaveq 
  8014bc:	c3                   	retq   

00000000008014bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014bd:	55                   	push   %rbp
  8014be:	48 89 e5             	mov    %rsp,%rbp
  8014c1:	48 83 ec 10          	sub    $0x10,%rsp
  8014c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014cd:	eb 0a                	jmp    8014d9 <strcmp+0x1c>
		p++, q++;
  8014cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8014d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	84 c0                	test   %al,%al
  8014e2:	74 12                	je     8014f6 <strcmp+0x39>
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	0f b6 10             	movzbl (%rax),%edx
  8014eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ef:	0f b6 00             	movzbl (%rax),%eax
  8014f2:	38 c2                	cmp    %al,%dl
  8014f4:	74 d9                	je     8014cf <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fa:	0f b6 00             	movzbl (%rax),%eax
  8014fd:	0f b6 d0             	movzbl %al,%edx
  801500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	0f b6 c0             	movzbl %al,%eax
  80150a:	29 c2                	sub    %eax,%edx
  80150c:	89 d0                	mov    %edx,%eax
}
  80150e:	c9                   	leaveq 
  80150f:	c3                   	retq   

0000000000801510 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801510:	55                   	push   %rbp
  801511:	48 89 e5             	mov    %rsp,%rbp
  801514:	48 83 ec 18          	sub    $0x18,%rsp
  801518:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801520:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801524:	eb 0f                	jmp    801535 <strncmp+0x25>
		n--, p++, q++;
  801526:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80152b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801530:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801535:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80153a:	74 1d                	je     801559 <strncmp+0x49>
  80153c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801540:	0f b6 00             	movzbl (%rax),%eax
  801543:	84 c0                	test   %al,%al
  801545:	74 12                	je     801559 <strncmp+0x49>
  801547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154b:	0f b6 10             	movzbl (%rax),%edx
  80154e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801552:	0f b6 00             	movzbl (%rax),%eax
  801555:	38 c2                	cmp    %al,%dl
  801557:	74 cd                	je     801526 <strncmp+0x16>
	if (n == 0)
  801559:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80155e:	75 07                	jne    801567 <strncmp+0x57>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 18                	jmp    80157f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156b:	0f b6 00             	movzbl (%rax),%eax
  80156e:	0f b6 d0             	movzbl %al,%edx
  801571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 83 ec 10          	sub    $0x10,%rsp
  801589:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158d:	89 f0                	mov    %esi,%eax
  80158f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801592:	eb 17                	jmp    8015ab <strchr+0x2a>
		if (*s == c)
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80159e:	75 06                	jne    8015a6 <strchr+0x25>
			return (char *) s;
  8015a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a4:	eb 15                	jmp    8015bb <strchr+0x3a>
	for (; *s; s++)
  8015a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015af:	0f b6 00             	movzbl (%rax),%eax
  8015b2:	84 c0                	test   %al,%al
  8015b4:	75 de                	jne    801594 <strchr+0x13>
	return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bb:	c9                   	leaveq 
  8015bc:	c3                   	retq   

00000000008015bd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015bd:	55                   	push   %rbp
  8015be:	48 89 e5             	mov    %rsp,%rbp
  8015c1:	48 83 ec 10          	sub    $0x10,%rsp
  8015c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c9:	89 f0                	mov    %esi,%eax
  8015cb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ce:	eb 13                	jmp    8015e3 <strfind+0x26>
		if (*s == c)
  8015d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015da:	75 02                	jne    8015de <strfind+0x21>
			break;
  8015dc:	eb 10                	jmp    8015ee <strfind+0x31>
	for (; *s; s++)
  8015de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	84 c0                	test   %al,%al
  8015ec:	75 e2                	jne    8015d0 <strfind+0x13>
	return (char *) s;
  8015ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 18          	sub    $0x18,%rsp
  8015fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801600:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801603:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801607:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80160c:	75 06                	jne    801614 <memset+0x20>
		return v;
  80160e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801612:	eb 69                	jmp    80167d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801614:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801618:	83 e0 03             	and    $0x3,%eax
  80161b:	48 85 c0             	test   %rax,%rax
  80161e:	75 48                	jne    801668 <memset+0x74>
  801620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801624:	83 e0 03             	and    $0x3,%eax
  801627:	48 85 c0             	test   %rax,%rax
  80162a:	75 3c                	jne    801668 <memset+0x74>
		c &= 0xFF;
  80162c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801633:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801636:	c1 e0 18             	shl    $0x18,%eax
  801639:	89 c2                	mov    %eax,%edx
  80163b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80163e:	c1 e0 10             	shl    $0x10,%eax
  801641:	09 c2                	or     %eax,%edx
  801643:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801646:	c1 e0 08             	shl    $0x8,%eax
  801649:	09 d0                	or     %edx,%eax
  80164b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801652:	48 c1 e8 02          	shr    $0x2,%rax
  801656:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801659:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801660:	48 89 d7             	mov    %rdx,%rdi
  801663:	fc                   	cld    
  801664:	f3 ab                	rep stos %eax,%es:(%rdi)
  801666:	eb 11                	jmp    801679 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801668:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80166f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801673:	48 89 d7             	mov    %rdx,%rdi
  801676:	fc                   	cld    
  801677:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801679:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80167d:	c9                   	leaveq 
  80167e:	c3                   	retq   

000000000080167f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80167f:	55                   	push   %rbp
  801680:	48 89 e5             	mov    %rsp,%rbp
  801683:	48 83 ec 28          	sub    $0x28,%rsp
  801687:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80168f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801693:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801697:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80169b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016ab:	0f 83 88 00 00 00    	jae    801739 <memmove+0xba>
  8016b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	48 01 d0             	add    %rdx,%rax
  8016bc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016c0:	76 77                	jbe    801739 <memmove+0xba>
		s += n;
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ce:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d6:	83 e0 03             	and    $0x3,%eax
  8016d9:	48 85 c0             	test   %rax,%rax
  8016dc:	75 3b                	jne    801719 <memmove+0x9a>
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e2:	83 e0 03             	and    $0x3,%eax
  8016e5:	48 85 c0             	test   %rax,%rax
  8016e8:	75 2f                	jne    801719 <memmove+0x9a>
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	83 e0 03             	and    $0x3,%eax
  8016f1:	48 85 c0             	test   %rax,%rax
  8016f4:	75 23                	jne    801719 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fa:	48 83 e8 04          	sub    $0x4,%rax
  8016fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801702:	48 83 ea 04          	sub    $0x4,%rdx
  801706:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80170a:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80170e:	48 89 c7             	mov    %rax,%rdi
  801711:	48 89 d6             	mov    %rdx,%rsi
  801714:	fd                   	std    
  801715:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801717:	eb 1d                	jmp    801736 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801725:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	48 89 d7             	mov    %rdx,%rdi
  801730:	48 89 c1             	mov    %rax,%rcx
  801733:	fd                   	std    
  801734:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801736:	fc                   	cld    
  801737:	eb 57                	jmp    801790 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173d:	83 e0 03             	and    $0x3,%eax
  801740:	48 85 c0             	test   %rax,%rax
  801743:	75 36                	jne    80177b <memmove+0xfc>
  801745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801749:	83 e0 03             	and    $0x3,%eax
  80174c:	48 85 c0             	test   %rax,%rax
  80174f:	75 2a                	jne    80177b <memmove+0xfc>
  801751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801755:	83 e0 03             	and    $0x3,%eax
  801758:	48 85 c0             	test   %rax,%rax
  80175b:	75 1e                	jne    80177b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	48 c1 e8 02          	shr    $0x2,%rax
  801765:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801770:	48 89 c7             	mov    %rax,%rdi
  801773:	48 89 d6             	mov    %rdx,%rsi
  801776:	fc                   	cld    
  801777:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801779:	eb 15                	jmp    801790 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80177b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801783:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801787:	48 89 c7             	mov    %rax,%rdi
  80178a:	48 89 d6             	mov    %rdx,%rsi
  80178d:	fc                   	cld    
  80178e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801794:	c9                   	leaveq 
  801795:	c3                   	retq   

0000000000801796 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801796:	55                   	push   %rbp
  801797:	48 89 e5             	mov    %rsp,%rbp
  80179a:	48 83 ec 18          	sub    $0x18,%rsp
  80179e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b6:	48 89 ce             	mov    %rcx,%rsi
  8017b9:	48 89 c7             	mov    %rax,%rdi
  8017bc:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8017c3:	00 00 00 
  8017c6:	ff d0                	callq  *%rax
}
  8017c8:	c9                   	leaveq 
  8017c9:	c3                   	retq   

00000000008017ca <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017ca:	55                   	push   %rbp
  8017cb:	48 89 e5             	mov    %rsp,%rbp
  8017ce:	48 83 ec 28          	sub    $0x28,%rsp
  8017d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017ee:	eb 36                	jmp    801826 <memcmp+0x5c>
		if (*s1 != *s2)
  8017f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f4:	0f b6 10             	movzbl (%rax),%edx
  8017f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	38 c2                	cmp    %al,%dl
  801800:	74 1a                	je     80181c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801802:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	0f b6 d0             	movzbl %al,%edx
  80180c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801810:	0f b6 00             	movzbl (%rax),%eax
  801813:	0f b6 c0             	movzbl %al,%eax
  801816:	29 c2                	sub    %eax,%edx
  801818:	89 d0                	mov    %edx,%eax
  80181a:	eb 20                	jmp    80183c <memcmp+0x72>
		s1++, s2++;
  80181c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801821:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80182e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801832:	48 85 c0             	test   %rax,%rax
  801835:	75 b9                	jne    8017f0 <memcmp+0x26>
	}

	return 0;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	48 83 ec 28          	sub    $0x28,%rsp
  801846:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80184d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801851:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801859:	48 01 d0             	add    %rdx,%rax
  80185c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801860:	eb 15                	jmp    801877 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80186c:	38 d0                	cmp    %dl,%al
  80186e:	75 02                	jne    801872 <memfind+0x34>
			break;
  801870:	eb 0f                	jmp    801881 <memfind+0x43>
	for (; s < ends; s++)
  801872:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80187f:	72 e1                	jb     801862 <memfind+0x24>
	return (void *) s;
  801881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 38          	sub    $0x38,%rsp
  80188f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801893:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801897:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80189a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018a1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018a8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018a9:	eb 05                	jmp    8018b0 <strtol+0x29>
		s++;
  8018ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8018b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b4:	0f b6 00             	movzbl (%rax),%eax
  8018b7:	3c 20                	cmp    $0x20,%al
  8018b9:	74 f0                	je     8018ab <strtol+0x24>
  8018bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bf:	0f b6 00             	movzbl (%rax),%eax
  8018c2:	3c 09                	cmp    $0x9,%al
  8018c4:	74 e5                	je     8018ab <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	0f b6 00             	movzbl (%rax),%eax
  8018cd:	3c 2b                	cmp    $0x2b,%al
  8018cf:	75 07                	jne    8018d8 <strtol+0x51>
		s++;
  8018d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d6:	eb 17                	jmp    8018ef <strtol+0x68>
	else if (*s == '-')
  8018d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018dc:	0f b6 00             	movzbl (%rax),%eax
  8018df:	3c 2d                	cmp    $0x2d,%al
  8018e1:	75 0c                	jne    8018ef <strtol+0x68>
		s++, neg = 1;
  8018e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018f3:	74 06                	je     8018fb <strtol+0x74>
  8018f5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018f9:	75 28                	jne    801923 <strtol+0x9c>
  8018fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	3c 30                	cmp    $0x30,%al
  801904:	75 1d                	jne    801923 <strtol+0x9c>
  801906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190a:	48 83 c0 01          	add    $0x1,%rax
  80190e:	0f b6 00             	movzbl (%rax),%eax
  801911:	3c 78                	cmp    $0x78,%al
  801913:	75 0e                	jne    801923 <strtol+0x9c>
		s += 2, base = 16;
  801915:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80191a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801921:	eb 2c                	jmp    80194f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801923:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801927:	75 19                	jne    801942 <strtol+0xbb>
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	0f b6 00             	movzbl (%rax),%eax
  801930:	3c 30                	cmp    $0x30,%al
  801932:	75 0e                	jne    801942 <strtol+0xbb>
		s++, base = 8;
  801934:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801939:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801940:	eb 0d                	jmp    80194f <strtol+0xc8>
	else if (base == 0)
  801942:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801946:	75 07                	jne    80194f <strtol+0xc8>
		base = 10;
  801948:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80194f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801953:	0f b6 00             	movzbl (%rax),%eax
  801956:	3c 2f                	cmp    $0x2f,%al
  801958:	7e 1d                	jle    801977 <strtol+0xf0>
  80195a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195e:	0f b6 00             	movzbl (%rax),%eax
  801961:	3c 39                	cmp    $0x39,%al
  801963:	7f 12                	jg     801977 <strtol+0xf0>
			dig = *s - '0';
  801965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801969:	0f b6 00             	movzbl (%rax),%eax
  80196c:	0f be c0             	movsbl %al,%eax
  80196f:	83 e8 30             	sub    $0x30,%eax
  801972:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801975:	eb 4e                	jmp    8019c5 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197b:	0f b6 00             	movzbl (%rax),%eax
  80197e:	3c 60                	cmp    $0x60,%al
  801980:	7e 1d                	jle    80199f <strtol+0x118>
  801982:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801986:	0f b6 00             	movzbl (%rax),%eax
  801989:	3c 7a                	cmp    $0x7a,%al
  80198b:	7f 12                	jg     80199f <strtol+0x118>
			dig = *s - 'a' + 10;
  80198d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801991:	0f b6 00             	movzbl (%rax),%eax
  801994:	0f be c0             	movsbl %al,%eax
  801997:	83 e8 57             	sub    $0x57,%eax
  80199a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80199d:	eb 26                	jmp    8019c5 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80199f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a3:	0f b6 00             	movzbl (%rax),%eax
  8019a6:	3c 40                	cmp    $0x40,%al
  8019a8:	7e 48                	jle    8019f2 <strtol+0x16b>
  8019aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ae:	0f b6 00             	movzbl (%rax),%eax
  8019b1:	3c 5a                	cmp    $0x5a,%al
  8019b3:	7f 3d                	jg     8019f2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8019b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b9:	0f b6 00             	movzbl (%rax),%eax
  8019bc:	0f be c0             	movsbl %al,%eax
  8019bf:	83 e8 37             	sub    $0x37,%eax
  8019c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019c8:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019cb:	7c 02                	jl     8019cf <strtol+0x148>
			break;
  8019cd:	eb 23                	jmp    8019f2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8019cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019d4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019d7:	48 98                	cltq   
  8019d9:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019de:	48 89 c2             	mov    %rax,%rdx
  8019e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019e4:	48 98                	cltq   
  8019e6:	48 01 d0             	add    %rdx,%rax
  8019e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019ed:	e9 5d ff ff ff       	jmpq   80194f <strtol+0xc8>

	if (endptr)
  8019f2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019f7:	74 0b                	je     801a04 <strtol+0x17d>
		*endptr = (char *) s;
  8019f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a01:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a08:	74 09                	je     801a13 <strtol+0x18c>
  801a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a0e:	48 f7 d8             	neg    %rax
  801a11:	eb 04                	jmp    801a17 <strtol+0x190>
  801a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a17:	c9                   	leaveq 
  801a18:	c3                   	retq   

0000000000801a19 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a19:	55                   	push   %rbp
  801a1a:	48 89 e5             	mov    %rsp,%rbp
  801a1d:	48 83 ec 30          	sub    $0x30,%rsp
  801a21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a2d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a31:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a35:	0f b6 00             	movzbl (%rax),%eax
  801a38:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a3b:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a3f:	75 06                	jne    801a47 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	eb 6b                	jmp    801ab2 <strstr+0x99>

	len = strlen(str);
  801a47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a4b:	48 89 c7             	mov    %rax,%rdi
  801a4e:	48 b8 ef 12 80 00 00 	movabs $0x8012ef,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
  801a5a:	48 98                	cltq   
  801a5c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a6c:	0f b6 00             	movzbl (%rax),%eax
  801a6f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a72:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a76:	75 07                	jne    801a7f <strstr+0x66>
				return (char *) 0;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7d:	eb 33                	jmp    801ab2 <strstr+0x99>
		} while (sc != c);
  801a7f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a83:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a86:	75 d8                	jne    801a60 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a94:	48 89 ce             	mov    %rcx,%rsi
  801a97:	48 89 c7             	mov    %rax,%rdi
  801a9a:	48 b8 10 15 80 00 00 	movabs $0x801510,%rax
  801aa1:	00 00 00 
  801aa4:	ff d0                	callq  *%rax
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	75 b6                	jne    801a60 <strstr+0x47>

	return (char *) (in - 1);
  801aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aae:	48 83 e8 01          	sub    $0x1,%rax
}
  801ab2:	c9                   	leaveq 
  801ab3:	c3                   	retq   

0000000000801ab4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ab4:	55                   	push   %rbp
  801ab5:	48 89 e5             	mov    %rsp,%rbp
  801ab8:	53                   	push   %rbx
  801ab9:	48 83 ec 48          	sub    $0x48,%rsp
  801abd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ac0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ac3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ac7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801acb:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801acf:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ad3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ad6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ada:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ade:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ae2:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ae6:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801aea:	4c 89 c3             	mov    %r8,%rbx
  801aed:	cd 30                	int    $0x30
  801aef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801af3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801af7:	74 3e                	je     801b37 <syscall+0x83>
  801af9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801afe:	7e 37                	jle    801b37 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b04:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b07:	49 89 d0             	mov    %rdx,%r8
  801b0a:	89 c1                	mov    %eax,%ecx
  801b0c:	48 ba 48 49 80 00 00 	movabs $0x804948,%rdx
  801b13:	00 00 00 
  801b16:	be 23 00 00 00       	mov    $0x23,%esi
  801b1b:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
  801b22:	00 00 00 
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2a:	49 b9 88 05 80 00 00 	movabs $0x800588,%r9
  801b31:	00 00 00 
  801b34:	41 ff d1             	callq  *%r9

	return ret;
  801b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b3b:	48 83 c4 48          	add    $0x48,%rsp
  801b3f:	5b                   	pop    %rbx
  801b40:	5d                   	pop    %rbp
  801b41:	c3                   	retq   

0000000000801b42 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 10          	sub    $0x10,%rsp
  801b4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5a:	48 83 ec 08          	sub    $0x8,%rsp
  801b5e:	6a 00                	pushq  $0x0
  801b60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6c:	48 89 d1             	mov    %rdx,%rcx
  801b6f:	48 89 c2             	mov    %rax,%rdx
  801b72:	be 00 00 00 00       	mov    $0x0,%esi
  801b77:	bf 00 00 00 00       	mov    $0x0,%edi
  801b7c:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	callq  *%rax
  801b88:	48 83 c4 10          	add    $0x10,%rsp
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b92:	48 83 ec 08          	sub    $0x8,%rsp
  801b96:	6a 00                	pushq  $0x0
  801b98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bae:	be 00 00 00 00       	mov    $0x0,%esi
  801bb3:	bf 01 00 00 00       	mov    $0x1,%edi
  801bb8:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
  801bc4:	48 83 c4 10          	add    $0x10,%rsp
}
  801bc8:	c9                   	leaveq 
  801bc9:	c3                   	retq   

0000000000801bca <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	48 83 ec 10          	sub    $0x10,%rsp
  801bd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd8:	48 98                	cltq   
  801bda:	48 83 ec 08          	sub    $0x8,%rsp
  801bde:	6a 00                	pushq  $0x0
  801be0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bf1:	48 89 c2             	mov    %rax,%rdx
  801bf4:	be 01 00 00 00       	mov    $0x1,%esi
  801bf9:	bf 03 00 00 00       	mov    $0x3,%edi
  801bfe:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
  801c0a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c0e:	c9                   	leaveq 
  801c0f:	c3                   	retq   

0000000000801c10 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c10:	55                   	push   %rbp
  801c11:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c14:	48 83 ec 08          	sub    $0x8,%rsp
  801c18:	6a 00                	pushq  $0x0
  801c1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c30:	be 00 00 00 00       	mov    $0x0,%esi
  801c35:	bf 02 00 00 00       	mov    $0x2,%edi
  801c3a:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
  801c46:	48 83 c4 10          	add    $0x10,%rsp
}
  801c4a:	c9                   	leaveq 
  801c4b:	c3                   	retq   

0000000000801c4c <sys_yield>:

void
sys_yield(void)
{
  801c4c:	55                   	push   %rbp
  801c4d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c50:	48 83 ec 08          	sub    $0x8,%rsp
  801c54:	6a 00                	pushq  $0x0
  801c56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c62:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c67:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6c:	be 00 00 00 00       	mov    $0x0,%esi
  801c71:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c76:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
  801c82:	48 83 c4 10          	add    $0x10,%rsp
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 10          	sub    $0x10,%rsp
  801c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c97:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c9d:	48 63 c8             	movslq %eax,%rcx
  801ca0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca7:	48 98                	cltq   
  801ca9:	48 83 ec 08          	sub    $0x8,%rsp
  801cad:	6a 00                	pushq  $0x0
  801caf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb5:	49 89 c8             	mov    %rcx,%r8
  801cb8:	48 89 d1             	mov    %rdx,%rcx
  801cbb:	48 89 c2             	mov    %rax,%rdx
  801cbe:	be 01 00 00 00       	mov    $0x1,%esi
  801cc3:	bf 04 00 00 00       	mov    $0x4,%edi
  801cc8:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801ccf:	00 00 00 
  801cd2:	ff d0                	callq  *%rax
  801cd4:	48 83 c4 10          	add    $0x10,%rsp
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 20          	sub    $0x20,%rsp
  801ce2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ce9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cec:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cf0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801cf4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cf7:	48 63 c8             	movslq %eax,%rcx
  801cfa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d01:	48 63 f0             	movslq %eax,%rsi
  801d04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0b:	48 98                	cltq   
  801d0d:	48 83 ec 08          	sub    $0x8,%rsp
  801d11:	51                   	push   %rcx
  801d12:	49 89 f9             	mov    %rdi,%r9
  801d15:	49 89 f0             	mov    %rsi,%r8
  801d18:	48 89 d1             	mov    %rdx,%rcx
  801d1b:	48 89 c2             	mov    %rax,%rdx
  801d1e:	be 01 00 00 00       	mov    $0x1,%esi
  801d23:	bf 05 00 00 00       	mov    $0x5,%edi
  801d28:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801d2f:	00 00 00 
  801d32:	ff d0                	callq  *%rax
  801d34:	48 83 c4 10          	add    $0x10,%rsp
}
  801d38:	c9                   	leaveq 
  801d39:	c3                   	retq   

0000000000801d3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	48 83 ec 10          	sub    $0x10,%rsp
  801d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d50:	48 98                	cltq   
  801d52:	48 83 ec 08          	sub    $0x8,%rsp
  801d56:	6a 00                	pushq  $0x0
  801d58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d64:	48 89 d1             	mov    %rdx,%rcx
  801d67:	48 89 c2             	mov    %rax,%rdx
  801d6a:	be 01 00 00 00       	mov    $0x1,%esi
  801d6f:	bf 06 00 00 00       	mov    $0x6,%edi
  801d74:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	callq  *%rax
  801d80:	48 83 c4 10          	add    $0x10,%rsp
}
  801d84:	c9                   	leaveq 
  801d85:	c3                   	retq   

0000000000801d86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d86:	55                   	push   %rbp
  801d87:	48 89 e5             	mov    %rsp,%rbp
  801d8a:	48 83 ec 10          	sub    $0x10,%rsp
  801d8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d91:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d97:	48 63 d0             	movslq %eax,%rdx
  801d9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9d:	48 98                	cltq   
  801d9f:	48 83 ec 08          	sub    $0x8,%rsp
  801da3:	6a 00                	pushq  $0x0
  801da5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db1:	48 89 d1             	mov    %rdx,%rcx
  801db4:	48 89 c2             	mov    %rax,%rdx
  801db7:	be 01 00 00 00       	mov    $0x1,%esi
  801dbc:	bf 08 00 00 00       	mov    $0x8,%edi
  801dc1:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801dc8:	00 00 00 
  801dcb:	ff d0                	callq  *%rax
  801dcd:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd1:	c9                   	leaveq 
  801dd2:	c3                   	retq   

0000000000801dd3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801dd3:	55                   	push   %rbp
  801dd4:	48 89 e5             	mov    %rsp,%rbp
  801dd7:	48 83 ec 10          	sub    $0x10,%rsp
  801ddb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801de2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de9:	48 98                	cltq   
  801deb:	48 83 ec 08          	sub    $0x8,%rsp
  801def:	6a 00                	pushq  $0x0
  801df1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfd:	48 89 d1             	mov    %rdx,%rcx
  801e00:	48 89 c2             	mov    %rax,%rdx
  801e03:	be 01 00 00 00       	mov    $0x1,%esi
  801e08:	bf 09 00 00 00       	mov    $0x9,%edi
  801e0d:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	callq  *%rax
  801e19:	48 83 c4 10          	add    $0x10,%rsp
}
  801e1d:	c9                   	leaveq 
  801e1e:	c3                   	retq   

0000000000801e1f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e1f:	55                   	push   %rbp
  801e20:	48 89 e5             	mov    %rsp,%rbp
  801e23:	48 83 ec 10          	sub    $0x10,%rsp
  801e27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e35:	48 98                	cltq   
  801e37:	48 83 ec 08          	sub    $0x8,%rsp
  801e3b:	6a 00                	pushq  $0x0
  801e3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e49:	48 89 d1             	mov    %rdx,%rcx
  801e4c:	48 89 c2             	mov    %rax,%rdx
  801e4f:	be 01 00 00 00       	mov    $0x1,%esi
  801e54:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e59:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801e60:	00 00 00 
  801e63:	ff d0                	callq  *%rax
  801e65:	48 83 c4 10          	add    $0x10,%rsp
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	48 83 ec 20          	sub    $0x20,%rsp
  801e73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e7e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e81:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e84:	48 63 f0             	movslq %eax,%rsi
  801e87:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8e:	48 98                	cltq   
  801e90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e94:	48 83 ec 08          	sub    $0x8,%rsp
  801e98:	6a 00                	pushq  $0x0
  801e9a:	49 89 f1             	mov    %rsi,%r9
  801e9d:	49 89 c8             	mov    %rcx,%r8
  801ea0:	48 89 d1             	mov    %rdx,%rcx
  801ea3:	48 89 c2             	mov    %rax,%rdx
  801ea6:	be 00 00 00 00       	mov    $0x0,%esi
  801eab:	bf 0c 00 00 00       	mov    $0xc,%edi
  801eb0:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
  801ebc:	48 83 c4 10          	add    $0x10,%rsp
}
  801ec0:	c9                   	leaveq 
  801ec1:	c3                   	retq   

0000000000801ec2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
  801ec6:	48 83 ec 10          	sub    $0x10,%rsp
  801eca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed2:	48 83 ec 08          	sub    $0x8,%rsp
  801ed6:	6a 00                	pushq  $0x0
  801ed8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ede:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ee9:	48 89 c2             	mov    %rax,%rdx
  801eec:	be 01 00 00 00       	mov    $0x1,%esi
  801ef1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ef6:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	48 83 c4 10          	add    $0x10,%rsp
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f0c:	48 83 ec 08          	sub    $0x8,%rsp
  801f10:	6a 00                	pushq  $0x0
  801f12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f23:	ba 00 00 00 00       	mov    $0x0,%edx
  801f28:	be 00 00 00 00       	mov    $0x0,%esi
  801f2d:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f32:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
  801f3e:	48 83 c4 10          	add    $0x10,%rsp
}
  801f42:	c9                   	leaveq 
  801f43:	c3                   	retq   

0000000000801f44 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f44:	55                   	push   %rbp
  801f45:	48 89 e5             	mov    %rsp,%rbp
  801f48:	48 83 ec 20          	sub    $0x20,%rsp
  801f4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f53:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f56:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f5a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801f5e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f61:	48 63 c8             	movslq %eax,%rcx
  801f64:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f6b:	48 63 f0             	movslq %eax,%rsi
  801f6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f75:	48 98                	cltq   
  801f77:	48 83 ec 08          	sub    $0x8,%rsp
  801f7b:	51                   	push   %rcx
  801f7c:	49 89 f9             	mov    %rdi,%r9
  801f7f:	49 89 f0             	mov    %rsi,%r8
  801f82:	48 89 d1             	mov    %rdx,%rcx
  801f85:	48 89 c2             	mov    %rax,%rdx
  801f88:	be 00 00 00 00       	mov    $0x0,%esi
  801f8d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f92:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801f99:	00 00 00 
  801f9c:	ff d0                	callq  *%rax
  801f9e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801fa2:	c9                   	leaveq 
  801fa3:	c3                   	retq   

0000000000801fa4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801fa4:	55                   	push   %rbp
  801fa5:	48 89 e5             	mov    %rsp,%rbp
  801fa8:	48 83 ec 10          	sub    $0x10,%rsp
  801fac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801fb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbc:	48 83 ec 08          	sub    $0x8,%rsp
  801fc0:	6a 00                	pushq  $0x0
  801fc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fce:	48 89 d1             	mov    %rdx,%rcx
  801fd1:	48 89 c2             	mov    %rax,%rdx
  801fd4:	be 00 00 00 00       	mov    $0x0,%esi
  801fd9:	bf 10 00 00 00       	mov    $0x10,%edi
  801fde:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	callq  *%rax
  801fea:	48 83 c4 10          	add    $0x10,%rsp
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
  801ff4:	48 83 ec 20          	sub    $0x20,%rsp
  801ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802000:	48 8b 00             	mov    (%rax),%rax
  802003:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80200f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  802012:	48 ba 73 49 80 00 00 	movabs $0x804973,%rdx
  802019:	00 00 00 
  80201c:	be 26 00 00 00       	mov    $0x26,%esi
  802021:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  802028:	00 00 00 
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  802037:	00 00 00 
  80203a:	ff d1                	callq  *%rcx

000000000080203c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80203c:	55                   	push   %rbp
  80203d:	48 89 e5             	mov    %rsp,%rbp
  802040:	48 83 ec 10          	sub    $0x10,%rsp
  802044:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802047:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  80204a:	48 ba 96 49 80 00 00 	movabs $0x804996,%rdx
  802051:	00 00 00 
  802054:	be 3a 00 00 00       	mov    $0x3a,%esi
  802059:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  802060:	00 00 00 
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  80206f:	00 00 00 
  802072:	ff d1                	callq  *%rcx

0000000000802074 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802074:	55                   	push   %rbp
  802075:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  802078:	48 ba ae 49 80 00 00 	movabs $0x8049ae,%rdx
  80207f:	00 00 00 
  802082:	be 52 00 00 00       	mov    $0x52,%esi
  802087:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  80208e:	00 00 00 
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  80209d:	00 00 00 
  8020a0:	ff d1                	callq  *%rcx

00000000008020a2 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8020a2:	55                   	push   %rbp
  8020a3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020a6:	48 ba c3 49 80 00 00 	movabs $0x8049c3,%rdx
  8020ad:	00 00 00 
  8020b0:	be 59 00 00 00       	mov    $0x59,%esi
  8020b5:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  8020bc:	00 00 00 
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  8020cb:	00 00 00 
  8020ce:	ff d1                	callq  *%rcx

00000000008020d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020d0:	55                   	push   %rbp
  8020d1:	48 89 e5             	mov    %rsp,%rbp
  8020d4:	48 83 ec 08          	sub    $0x8,%rsp
  8020d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020e0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020e7:	ff ff ff 
  8020ea:	48 01 d0             	add    %rdx,%rax
  8020ed:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020f1:	c9                   	leaveq 
  8020f2:	c3                   	retq   

00000000008020f3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020f3:	55                   	push   %rbp
  8020f4:	48 89 e5             	mov    %rsp,%rbp
  8020f7:	48 83 ec 08          	sub    $0x8,%rsp
  8020fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802103:	48 89 c7             	mov    %rax,%rdi
  802106:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  80210d:	00 00 00 
  802110:	ff d0                	callq  *%rax
  802112:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802118:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80211c:	c9                   	leaveq 
  80211d:	c3                   	retq   

000000000080211e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
  802122:	48 83 ec 18          	sub    $0x18,%rsp
  802126:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80212a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802131:	eb 6b                	jmp    80219e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802133:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802136:	48 98                	cltq   
  802138:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80213e:	48 c1 e0 0c          	shl    $0xc,%rax
  802142:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214a:	48 c1 e8 15          	shr    $0x15,%rax
  80214e:	48 89 c2             	mov    %rax,%rdx
  802151:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802158:	01 00 00 
  80215b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215f:	83 e0 01             	and    $0x1,%eax
  802162:	48 85 c0             	test   %rax,%rax
  802165:	74 21                	je     802188 <fd_alloc+0x6a>
  802167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80216b:	48 c1 e8 0c          	shr    $0xc,%rax
  80216f:	48 89 c2             	mov    %rax,%rdx
  802172:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802179:	01 00 00 
  80217c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802180:	83 e0 01             	and    $0x1,%eax
  802183:	48 85 c0             	test   %rax,%rax
  802186:	75 12                	jne    80219a <fd_alloc+0x7c>
			*fd_store = fd;
  802188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802190:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	eb 1a                	jmp    8021b4 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  80219a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80219e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021a2:	7e 8f                	jle    802133 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021af:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021b4:	c9                   	leaveq 
  8021b5:	c3                   	retq   

00000000008021b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021b6:	55                   	push   %rbp
  8021b7:	48 89 e5             	mov    %rsp,%rbp
  8021ba:	48 83 ec 20          	sub    $0x20,%rsp
  8021be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c9:	78 06                	js     8021d1 <fd_lookup+0x1b>
  8021cb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021cf:	7e 07                	jle    8021d8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021d6:	eb 6c                	jmp    802244 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021db:	48 98                	cltq   
  8021dd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021e3:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ef:	48 c1 e8 15          	shr    $0x15,%rax
  8021f3:	48 89 c2             	mov    %rax,%rdx
  8021f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021fd:	01 00 00 
  802200:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802204:	83 e0 01             	and    $0x1,%eax
  802207:	48 85 c0             	test   %rax,%rax
  80220a:	74 21                	je     80222d <fd_lookup+0x77>
  80220c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802210:	48 c1 e8 0c          	shr    $0xc,%rax
  802214:	48 89 c2             	mov    %rax,%rdx
  802217:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80221e:	01 00 00 
  802221:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802225:	83 e0 01             	and    $0x1,%eax
  802228:	48 85 c0             	test   %rax,%rax
  80222b:	75 07                	jne    802234 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80222d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802232:	eb 10                	jmp    802244 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802234:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802238:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80223c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802244:	c9                   	leaveq 
  802245:	c3                   	retq   

0000000000802246 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802246:	55                   	push   %rbp
  802247:	48 89 e5             	mov    %rsp,%rbp
  80224a:	48 83 ec 30          	sub    $0x30,%rsp
  80224e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802252:	89 f0                	mov    %esi,%eax
  802254:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225b:	48 89 c7             	mov    %rax,%rdi
  80225e:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802265:	00 00 00 
  802268:	ff d0                	callq  *%rax
  80226a:	89 c2                	mov    %eax,%edx
  80226c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802270:	48 89 c6             	mov    %rax,%rsi
  802273:	89 d7                	mov    %edx,%edi
  802275:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax
  802281:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802284:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802288:	78 0a                	js     802294 <fd_close+0x4e>
	    || fd != fd2)
  80228a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802292:	74 12                	je     8022a6 <fd_close+0x60>
		return (must_exist ? r : 0);
  802294:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802298:	74 05                	je     80229f <fd_close+0x59>
  80229a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229d:	eb 70                	jmp    80230f <fd_close+0xc9>
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a4:	eb 69                	jmp    80230f <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022aa:	8b 00                	mov    (%rax),%eax
  8022ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022b0:	48 89 d6             	mov    %rdx,%rsi
  8022b3:	89 c7                	mov    %eax,%edi
  8022b5:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
  8022c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c8:	78 2a                	js     8022f4 <fd_close+0xae>
		if (dev->dev_close)
  8022ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022d2:	48 85 c0             	test   %rax,%rax
  8022d5:	74 16                	je     8022ed <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8022d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022db:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022e3:	48 89 d7             	mov    %rdx,%rdi
  8022e6:	ff d0                	callq  *%rax
  8022e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022eb:	eb 07                	jmp    8022f4 <fd_close+0xae>
		else
			r = 0;
  8022ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f8:	48 89 c6             	mov    %rax,%rsi
  8022fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802300:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  802307:	00 00 00 
  80230a:	ff d0                	callq  *%rax
	return r;
  80230c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80230f:	c9                   	leaveq 
  802310:	c3                   	retq   

0000000000802311 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802311:	55                   	push   %rbp
  802312:	48 89 e5             	mov    %rsp,%rbp
  802315:	48 83 ec 20          	sub    $0x20,%rsp
  802319:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80231c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802320:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802327:	eb 41                	jmp    80236a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802329:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802330:	00 00 00 
  802333:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802336:	48 63 d2             	movslq %edx,%rdx
  802339:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233d:	8b 00                	mov    (%rax),%eax
  80233f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802342:	75 22                	jne    802366 <dev_lookup+0x55>
			*dev = devtab[i];
  802344:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80234b:	00 00 00 
  80234e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802351:	48 63 d2             	movslq %edx,%rdx
  802354:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802358:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80235c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	eb 60                	jmp    8023c6 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802366:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80236a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802371:	00 00 00 
  802374:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802377:	48 63 d2             	movslq %edx,%rdx
  80237a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237e:	48 85 c0             	test   %rax,%rax
  802381:	75 a6                	jne    802329 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802383:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80238a:	00 00 00 
  80238d:	48 8b 00             	mov    (%rax),%rax
  802390:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802396:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802399:	89 c6                	mov    %eax,%esi
  80239b:	48 bf e0 49 80 00 00 	movabs $0x8049e0,%rdi
  8023a2:	00 00 00 
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023aa:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  8023b1:	00 00 00 
  8023b4:	ff d1                	callq  *%rcx
	*dev = 0;
  8023b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023c6:	c9                   	leaveq 
  8023c7:	c3                   	retq   

00000000008023c8 <close>:

int
close(int fdnum)
{
  8023c8:	55                   	push   %rbp
  8023c9:	48 89 e5             	mov    %rsp,%rbp
  8023cc:	48 83 ec 20          	sub    $0x20,%rsp
  8023d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023da:	48 89 d6             	mov    %rdx,%rsi
  8023dd:	89 c7                	mov    %eax,%edi
  8023df:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
  8023eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f2:	79 05                	jns    8023f9 <close+0x31>
		return r;
  8023f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f7:	eb 18                	jmp    802411 <close+0x49>
	else
		return fd_close(fd, 1);
  8023f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fd:	be 01 00 00 00       	mov    $0x1,%esi
  802402:	48 89 c7             	mov    %rax,%rdi
  802405:	48 b8 46 22 80 00 00 	movabs $0x802246,%rax
  80240c:	00 00 00 
  80240f:	ff d0                	callq  *%rax
}
  802411:	c9                   	leaveq 
  802412:	c3                   	retq   

0000000000802413 <close_all>:

void
close_all(void)
{
  802413:	55                   	push   %rbp
  802414:	48 89 e5             	mov    %rsp,%rbp
  802417:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80241b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802422:	eb 15                	jmp    802439 <close_all+0x26>
		close(i);
  802424:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802427:	89 c7                	mov    %eax,%edi
  802429:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802430:	00 00 00 
  802433:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802435:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802439:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80243d:	7e e5                	jle    802424 <close_all+0x11>
}
  80243f:	c9                   	leaveq 
  802440:	c3                   	retq   

0000000000802441 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802441:	55                   	push   %rbp
  802442:	48 89 e5             	mov    %rsp,%rbp
  802445:	48 83 ec 40          	sub    $0x40,%rsp
  802449:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80244c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80244f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802453:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802456:	48 89 d6             	mov    %rdx,%rsi
  802459:	89 c7                	mov    %eax,%edi
  80245b:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  802462:	00 00 00 
  802465:	ff d0                	callq  *%rax
  802467:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246e:	79 08                	jns    802478 <dup+0x37>
		return r;
  802470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802473:	e9 70 01 00 00       	jmpq   8025e8 <dup+0x1a7>
	close(newfdnum);
  802478:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80247b:	89 c7                	mov    %eax,%edi
  80247d:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802484:	00 00 00 
  802487:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802489:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80248c:	48 98                	cltq   
  80248e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802494:	48 c1 e0 0c          	shl    $0xc,%rax
  802498:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80249c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a0:	48 89 c7             	mov    %rax,%rdi
  8024a3:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
  8024af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b7:	48 89 c7             	mov    %rax,%rdi
  8024ba:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8024c1:	00 00 00 
  8024c4:	ff d0                	callq  *%rax
  8024c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ce:	48 c1 e8 15          	shr    $0x15,%rax
  8024d2:	48 89 c2             	mov    %rax,%rdx
  8024d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024dc:	01 00 00 
  8024df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e3:	83 e0 01             	and    $0x1,%eax
  8024e6:	48 85 c0             	test   %rax,%rax
  8024e9:	74 73                	je     80255e <dup+0x11d>
  8024eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8024f3:	48 89 c2             	mov    %rax,%rdx
  8024f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024fd:	01 00 00 
  802500:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802504:	83 e0 01             	and    $0x1,%eax
  802507:	48 85 c0             	test   %rax,%rax
  80250a:	74 52                	je     80255e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80250c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802510:	48 c1 e8 0c          	shr    $0xc,%rax
  802514:	48 89 c2             	mov    %rax,%rdx
  802517:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80251e:	01 00 00 
  802521:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802525:	25 07 0e 00 00       	and    $0xe07,%eax
  80252a:	89 c1                	mov    %eax,%ecx
  80252c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802534:	41 89 c8             	mov    %ecx,%r8d
  802537:	48 89 d1             	mov    %rdx,%rcx
  80253a:	ba 00 00 00 00       	mov    $0x0,%edx
  80253f:	48 89 c6             	mov    %rax,%rsi
  802542:	bf 00 00 00 00       	mov    $0x0,%edi
  802547:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80254e:	00 00 00 
  802551:	ff d0                	callq  *%rax
  802553:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802556:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255a:	79 02                	jns    80255e <dup+0x11d>
			goto err;
  80255c:	eb 57                	jmp    8025b5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80255e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802562:	48 c1 e8 0c          	shr    $0xc,%rax
  802566:	48 89 c2             	mov    %rax,%rdx
  802569:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802570:	01 00 00 
  802573:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802577:	25 07 0e 00 00       	and    $0xe07,%eax
  80257c:	89 c1                	mov    %eax,%ecx
  80257e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802582:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802586:	41 89 c8             	mov    %ecx,%r8d
  802589:	48 89 d1             	mov    %rdx,%rcx
  80258c:	ba 00 00 00 00       	mov    $0x0,%edx
  802591:	48 89 c6             	mov    %rax,%rsi
  802594:	bf 00 00 00 00       	mov    $0x0,%edi
  802599:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  8025a0:	00 00 00 
  8025a3:	ff d0                	callq  *%rax
  8025a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ac:	79 02                	jns    8025b0 <dup+0x16f>
		goto err;
  8025ae:	eb 05                	jmp    8025b5 <dup+0x174>

	return newfdnum;
  8025b0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025b3:	eb 33                	jmp    8025e8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b9:	48 89 c6             	mov    %rax,%rsi
  8025bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c1:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d1:	48 89 c6             	mov    %rax,%rsi
  8025d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d9:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8025e0:	00 00 00 
  8025e3:	ff d0                	callq  *%rax
	return r;
  8025e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025e8:	c9                   	leaveq 
  8025e9:	c3                   	retq   

00000000008025ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025ea:	55                   	push   %rbp
  8025eb:	48 89 e5             	mov    %rsp,%rbp
  8025ee:	48 83 ec 40          	sub    $0x40,%rsp
  8025f2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025f9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802601:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802604:	48 89 d6             	mov    %rdx,%rsi
  802607:	89 c7                	mov    %eax,%edi
  802609:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
  802615:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802618:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261c:	78 24                	js     802642 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80261e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802622:	8b 00                	mov    (%rax),%eax
  802624:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802628:	48 89 d6             	mov    %rdx,%rsi
  80262b:	89 c7                	mov    %eax,%edi
  80262d:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  802634:	00 00 00 
  802637:	ff d0                	callq  *%rax
  802639:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802640:	79 05                	jns    802647 <read+0x5d>
		return r;
  802642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802645:	eb 76                	jmp    8026bd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264b:	8b 40 08             	mov    0x8(%rax),%eax
  80264e:	83 e0 03             	and    $0x3,%eax
  802651:	83 f8 01             	cmp    $0x1,%eax
  802654:	75 3a                	jne    802690 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802656:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80265d:	00 00 00 
  802660:	48 8b 00             	mov    (%rax),%rax
  802663:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802669:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80266c:	89 c6                	mov    %eax,%esi
  80266e:	48 bf ff 49 80 00 00 	movabs $0x8049ff,%rdi
  802675:	00 00 00 
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  802684:	00 00 00 
  802687:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802689:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80268e:	eb 2d                	jmp    8026bd <read+0xd3>
	}
	if (!dev->dev_read)
  802690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802694:	48 8b 40 10          	mov    0x10(%rax),%rax
  802698:	48 85 c0             	test   %rax,%rax
  80269b:	75 07                	jne    8026a4 <read+0xba>
		return -E_NOT_SUPP;
  80269d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a2:	eb 19                	jmp    8026bd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8026a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026ac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026b4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026b8:	48 89 cf             	mov    %rcx,%rdi
  8026bb:	ff d0                	callq  *%rax
}
  8026bd:	c9                   	leaveq 
  8026be:	c3                   	retq   

00000000008026bf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026bf:	55                   	push   %rbp
  8026c0:	48 89 e5             	mov    %rsp,%rbp
  8026c3:	48 83 ec 30          	sub    $0x30,%rsp
  8026c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d9:	eb 49                	jmp    802724 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026de:	48 98                	cltq   
  8026e0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026e4:	48 29 c2             	sub    %rax,%rdx
  8026e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ea:	48 63 c8             	movslq %eax,%rcx
  8026ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f1:	48 01 c1             	add    %rax,%rcx
  8026f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026f7:	48 89 ce             	mov    %rcx,%rsi
  8026fa:	89 c7                	mov    %eax,%edi
  8026fc:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
  802708:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80270b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80270f:	79 05                	jns    802716 <readn+0x57>
			return m;
  802711:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802714:	eb 1c                	jmp    802732 <readn+0x73>
		if (m == 0)
  802716:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80271a:	75 02                	jne    80271e <readn+0x5f>
			break;
  80271c:	eb 11                	jmp    80272f <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80271e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802721:	01 45 fc             	add    %eax,-0x4(%rbp)
  802724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802727:	48 98                	cltq   
  802729:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80272d:	72 ac                	jb     8026db <readn+0x1c>
	}
	return tot;
  80272f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802732:	c9                   	leaveq 
  802733:	c3                   	retq   

0000000000802734 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802734:	55                   	push   %rbp
  802735:	48 89 e5             	mov    %rsp,%rbp
  802738:	48 83 ec 40          	sub    $0x40,%rsp
  80273c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80273f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802743:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802747:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80274b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80274e:	48 89 d6             	mov    %rdx,%rsi
  802751:	89 c7                	mov    %eax,%edi
  802753:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
  80275f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802762:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802766:	78 24                	js     80278c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276c:	8b 00                	mov    (%rax),%eax
  80276e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802772:	48 89 d6             	mov    %rdx,%rsi
  802775:	89 c7                	mov    %eax,%edi
  802777:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278a:	79 05                	jns    802791 <write+0x5d>
		return r;
  80278c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278f:	eb 75                	jmp    802806 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802795:	8b 40 08             	mov    0x8(%rax),%eax
  802798:	83 e0 03             	and    $0x3,%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	75 3a                	jne    8027d9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80279f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027a6:	00 00 00 
  8027a9:	48 8b 00             	mov    (%rax),%rax
  8027ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027b5:	89 c6                	mov    %eax,%esi
  8027b7:	48 bf 1b 4a 80 00 00 	movabs $0x804a1b,%rdi
  8027be:	00 00 00 
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c6:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  8027cd:	00 00 00 
  8027d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027d7:	eb 2d                	jmp    802806 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027e1:	48 85 c0             	test   %rax,%rax
  8027e4:	75 07                	jne    8027ed <write+0xb9>
		return -E_NOT_SUPP;
  8027e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027eb:	eb 19                	jmp    802806 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802801:	48 89 cf             	mov    %rcx,%rdi
  802804:	ff d0                	callq  *%rax
}
  802806:	c9                   	leaveq 
  802807:	c3                   	retq   

0000000000802808 <seek>:

int
seek(int fdnum, off_t offset)
{
  802808:	55                   	push   %rbp
  802809:	48 89 e5             	mov    %rsp,%rbp
  80280c:	48 83 ec 18          	sub    $0x18,%rsp
  802810:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802813:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802816:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80281a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80281d:	48 89 d6             	mov    %rdx,%rsi
  802820:	89 c7                	mov    %eax,%edi
  802822:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
  80282e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802831:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802835:	79 05                	jns    80283c <seek+0x34>
		return r;
  802837:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283a:	eb 0f                	jmp    80284b <seek+0x43>
	fd->fd_offset = offset;
  80283c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802840:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802843:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284b:	c9                   	leaveq 
  80284c:	c3                   	retq   

000000000080284d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80284d:	55                   	push   %rbp
  80284e:	48 89 e5             	mov    %rsp,%rbp
  802851:	48 83 ec 30          	sub    $0x30,%rsp
  802855:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802858:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80285b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80285f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802862:	48 89 d6             	mov    %rdx,%rsi
  802865:	89 c7                	mov    %eax,%edi
  802867:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  80286e:	00 00 00 
  802871:	ff d0                	callq  *%rax
  802873:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802876:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287a:	78 24                	js     8028a0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802880:	8b 00                	mov    (%rax),%eax
  802882:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802886:	48 89 d6             	mov    %rdx,%rsi
  802889:	89 c7                	mov    %eax,%edi
  80288b:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
  802897:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289e:	79 05                	jns    8028a5 <ftruncate+0x58>
		return r;
  8028a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a3:	eb 72                	jmp    802917 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a9:	8b 40 08             	mov    0x8(%rax),%eax
  8028ac:	83 e0 03             	and    $0x3,%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	75 3a                	jne    8028ed <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028b3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028ba:	00 00 00 
  8028bd:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028c9:	89 c6                	mov    %eax,%esi
  8028cb:	48 bf 38 4a 80 00 00 	movabs $0x804a38,%rdi
  8028d2:	00 00 00 
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028da:	48 b9 c1 07 80 00 00 	movabs $0x8007c1,%rcx
  8028e1:	00 00 00 
  8028e4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028eb:	eb 2a                	jmp    802917 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028f5:	48 85 c0             	test   %rax,%rax
  8028f8:	75 07                	jne    802901 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028ff:	eb 16                	jmp    802917 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802905:	48 8b 40 30          	mov    0x30(%rax),%rax
  802909:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80290d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802910:	89 ce                	mov    %ecx,%esi
  802912:	48 89 d7             	mov    %rdx,%rdi
  802915:	ff d0                	callq  *%rax
}
  802917:	c9                   	leaveq 
  802918:	c3                   	retq   

0000000000802919 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	48 83 ec 30          	sub    $0x30,%rsp
  802921:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802924:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802928:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80292c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80292f:	48 89 d6             	mov    %rdx,%rsi
  802932:	89 c7                	mov    %eax,%edi
  802934:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
  802940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802947:	78 24                	js     80296d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294d:	8b 00                	mov    (%rax),%eax
  80294f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802953:	48 89 d6             	mov    %rdx,%rsi
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296b:	79 05                	jns    802972 <fstat+0x59>
		return r;
  80296d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802970:	eb 5e                	jmp    8029d0 <fstat+0xb7>
	if (!dev->dev_stat)
  802972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802976:	48 8b 40 28          	mov    0x28(%rax),%rax
  80297a:	48 85 c0             	test   %rax,%rax
  80297d:	75 07                	jne    802986 <fstat+0x6d>
		return -E_NOT_SUPP;
  80297f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802984:	eb 4a                	jmp    8029d0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802986:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80298a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80298d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802991:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802998:	00 00 00 
	stat->st_isdir = 0;
  80299b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80299f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8029a6:	00 00 00 
	stat->st_dev = dev;
  8029a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029b1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029c4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029c8:	48 89 ce             	mov    %rcx,%rsi
  8029cb:	48 89 d7             	mov    %rdx,%rdi
  8029ce:	ff d0                	callq  *%rax
}
  8029d0:	c9                   	leaveq 
  8029d1:	c3                   	retq   

00000000008029d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029d2:	55                   	push   %rbp
  8029d3:	48 89 e5             	mov    %rsp,%rbp
  8029d6:	48 83 ec 20          	sub    $0x20,%rsp
  8029da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e6:	be 00 00 00 00       	mov    $0x0,%esi
  8029eb:	48 89 c7             	mov    %rax,%rdi
  8029ee:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	callq  *%rax
  8029fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a01:	79 05                	jns    802a08 <stat+0x36>
		return fd;
  802a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a06:	eb 2f                	jmp    802a37 <stat+0x65>
	r = fstat(fd, stat);
  802a08:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0f:	48 89 d6             	mov    %rdx,%rsi
  802a12:	89 c7                	mov    %eax,%edi
  802a14:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  802a1b:	00 00 00 
  802a1e:	ff d0                	callq  *%rax
  802a20:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a26:	89 c7                	mov    %eax,%edi
  802a28:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
	return r;
  802a34:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a37:	c9                   	leaveq 
  802a38:	c3                   	retq   

0000000000802a39 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a39:	55                   	push   %rbp
  802a3a:	48 89 e5             	mov    %rsp,%rbp
  802a3d:	48 83 ec 10          	sub    $0x10,%rsp
  802a41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a4f:	00 00 00 
  802a52:	8b 00                	mov    (%rax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	75 1f                	jne    802a77 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a58:	bf 01 00 00 00       	mov    $0x1,%edi
  802a5d:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 c2                	mov    %eax,%edx
  802a6b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a72:	00 00 00 
  802a75:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a77:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a7e:	00 00 00 
  802a81:	8b 00                	mov    (%rax),%eax
  802a83:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a86:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a8b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a92:	00 00 00 
  802a95:	89 c7                	mov    %eax,%edi
  802a97:	48 b8 4b 40 80 00 00 	movabs $0x80404b,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802aa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  802aac:	48 89 c6             	mov    %rax,%rsi
  802aaf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab4:	48 b8 0d 40 80 00 00 	movabs $0x80400d,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
}
  802ac0:	c9                   	leaveq 
  802ac1:	c3                   	retq   

0000000000802ac2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ac2:	55                   	push   %rbp
  802ac3:	48 89 e5             	mov    %rsp,%rbp
  802ac6:	48 83 ec 10          	sub    $0x10,%rsp
  802aca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ace:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802ad1:	48 ba 5e 4a 80 00 00 	movabs $0x804a5e,%rdx
  802ad8:	00 00 00 
  802adb:	be 4c 00 00 00       	mov    $0x4c,%esi
  802ae0:	48 bf 73 4a 80 00 00 	movabs $0x804a73,%rdi
  802ae7:	00 00 00 
  802aea:	b8 00 00 00 00       	mov    $0x0,%eax
  802aef:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  802af6:	00 00 00 
  802af9:	ff d1                	callq  *%rcx

0000000000802afb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802afb:	55                   	push   %rbp
  802afc:	48 89 e5             	mov    %rsp,%rbp
  802aff:	48 83 ec 10          	sub    $0x10,%rsp
  802b03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0b:	8b 50 0c             	mov    0xc(%rax),%edx
  802b0e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b15:	00 00 00 
  802b18:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b1a:	be 00 00 00 00       	mov    $0x0,%esi
  802b1f:	bf 06 00 00 00       	mov    $0x6,%edi
  802b24:	48 b8 39 2a 80 00 00 	movabs $0x802a39,%rax
  802b2b:	00 00 00 
  802b2e:	ff d0                	callq  *%rax
}
  802b30:	c9                   	leaveq 
  802b31:	c3                   	retq   

0000000000802b32 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b32:	55                   	push   %rbp
  802b33:	48 89 e5             	mov    %rsp,%rbp
  802b36:	48 83 ec 20          	sub    $0x20,%rsp
  802b3a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b42:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802b46:	48 ba 7e 4a 80 00 00 	movabs $0x804a7e,%rdx
  802b4d:	00 00 00 
  802b50:	be 6b 00 00 00       	mov    $0x6b,%esi
  802b55:	48 bf 73 4a 80 00 00 	movabs $0x804a73,%rdi
  802b5c:	00 00 00 
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b64:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  802b6b:	00 00 00 
  802b6e:	ff d1                	callq  *%rcx

0000000000802b70 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b70:	55                   	push   %rbp
  802b71:	48 89 e5             	mov    %rsp,%rbp
  802b74:	48 83 ec 20          	sub    $0x20,%rsp
  802b78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b80:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802b84:	48 ba 9b 4a 80 00 00 	movabs $0x804a9b,%rdx
  802b8b:	00 00 00 
  802b8e:	be 7b 00 00 00       	mov    $0x7b,%esi
  802b93:	48 bf 73 4a 80 00 00 	movabs $0x804a73,%rdi
  802b9a:	00 00 00 
  802b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba2:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  802ba9:	00 00 00 
  802bac:	ff d1                	callq  *%rcx

0000000000802bae <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802bae:	55                   	push   %rbp
  802baf:	48 89 e5             	mov    %rsp,%rbp
  802bb2:	48 83 ec 20          	sub    $0x20,%rsp
  802bb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc2:	8b 50 0c             	mov    0xc(%rax),%edx
  802bc5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bcc:	00 00 00 
  802bcf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bd1:	be 00 00 00 00       	mov    $0x0,%esi
  802bd6:	bf 05 00 00 00       	mov    $0x5,%edi
  802bdb:	48 b8 39 2a 80 00 00 	movabs $0x802a39,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bee:	79 05                	jns    802bf5 <devfile_stat+0x47>
		return r;
  802bf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf3:	eb 56                	jmp    802c4b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c00:	00 00 00 
  802c03:	48 89 c7             	mov    %rax,%rdi
  802c06:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  802c0d:	00 00 00 
  802c10:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c12:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c19:	00 00 00 
  802c1c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c26:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c2c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c33:	00 00 00 
  802c36:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c40:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c4b:	c9                   	leaveq 
  802c4c:	c3                   	retq   

0000000000802c4d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c4d:	55                   	push   %rbp
  802c4e:	48 89 e5             	mov    %rsp,%rbp
  802c51:	48 83 ec 10          	sub    $0x10,%rsp
  802c55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c59:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c60:	8b 50 0c             	mov    0xc(%rax),%edx
  802c63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c6a:	00 00 00 
  802c6d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c76:	00 00 00 
  802c79:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c7c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c7f:	be 00 00 00 00       	mov    $0x0,%esi
  802c84:	bf 02 00 00 00       	mov    $0x2,%edi
  802c89:	48 b8 39 2a 80 00 00 	movabs $0x802a39,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
}
  802c95:	c9                   	leaveq 
  802c96:	c3                   	retq   

0000000000802c97 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c97:	55                   	push   %rbp
  802c98:	48 89 e5             	mov    %rsp,%rbp
  802c9b:	48 83 ec 10          	sub    $0x10,%rsp
  802c9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ca3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca7:	48 89 c7             	mov    %rax,%rdi
  802caa:	48 b8 ef 12 80 00 00 	movabs $0x8012ef,%rax
  802cb1:	00 00 00 
  802cb4:	ff d0                	callq  *%rax
  802cb6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cbb:	7e 07                	jle    802cc4 <remove+0x2d>
		return -E_BAD_PATH;
  802cbd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cc2:	eb 33                	jmp    802cf7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc8:	48 89 c6             	mov    %rax,%rsi
  802ccb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cd2:	00 00 00 
  802cd5:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ce1:	be 00 00 00 00       	mov    $0x0,%esi
  802ce6:	bf 07 00 00 00       	mov    $0x7,%edi
  802ceb:	48 b8 39 2a 80 00 00 	movabs $0x802a39,%rax
  802cf2:	00 00 00 
  802cf5:	ff d0                	callq  *%rax
}
  802cf7:	c9                   	leaveq 
  802cf8:	c3                   	retq   

0000000000802cf9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802cf9:	55                   	push   %rbp
  802cfa:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802cfd:	be 00 00 00 00       	mov    $0x0,%esi
  802d02:	bf 08 00 00 00       	mov    $0x8,%edi
  802d07:	48 b8 39 2a 80 00 00 	movabs $0x802a39,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
}
  802d13:	5d                   	pop    %rbp
  802d14:	c3                   	retq   

0000000000802d15 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d15:	55                   	push   %rbp
  802d16:	48 89 e5             	mov    %rsp,%rbp
  802d19:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d20:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d27:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d2e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d35:	be 00 00 00 00       	mov    $0x0,%esi
  802d3a:	48 89 c7             	mov    %rax,%rdi
  802d3d:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
  802d49:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d50:	79 28                	jns    802d7a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d55:	89 c6                	mov    %eax,%esi
  802d57:	48 bf b9 4a 80 00 00 	movabs $0x804ab9,%rdi
  802d5e:	00 00 00 
  802d61:	b8 00 00 00 00       	mov    $0x0,%eax
  802d66:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  802d6d:	00 00 00 
  802d70:	ff d2                	callq  *%rdx
		return fd_src;
  802d72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d75:	e9 74 01 00 00       	jmpq   802eee <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d7a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d81:	be 01 01 00 00       	mov    $0x101,%esi
  802d86:	48 89 c7             	mov    %rax,%rdi
  802d89:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  802d90:	00 00 00 
  802d93:	ff d0                	callq  *%rax
  802d95:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d98:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d9c:	79 39                	jns    802dd7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da1:	89 c6                	mov    %eax,%esi
  802da3:	48 bf cf 4a 80 00 00 	movabs $0x804acf,%rdi
  802daa:	00 00 00 
  802dad:	b8 00 00 00 00       	mov    $0x0,%eax
  802db2:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  802db9:	00 00 00 
  802dbc:	ff d2                	callq  *%rdx
		close(fd_src);
  802dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc1:	89 c7                	mov    %eax,%edi
  802dc3:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
		return fd_dest;
  802dcf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd2:	e9 17 01 00 00       	jmpq   802eee <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dd7:	eb 74                	jmp    802e4d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802dd9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ddc:	48 63 d0             	movslq %eax,%rdx
  802ddf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802de6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de9:	48 89 ce             	mov    %rcx,%rsi
  802dec:	89 c7                	mov    %eax,%edi
  802dee:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
  802dfa:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e01:	79 4a                	jns    802e4d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802e03:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e06:	89 c6                	mov    %eax,%esi
  802e08:	48 bf e9 4a 80 00 00 	movabs $0x804ae9,%rdi
  802e0f:	00 00 00 
  802e12:	b8 00 00 00 00       	mov    $0x0,%eax
  802e17:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  802e1e:	00 00 00 
  802e21:	ff d2                	callq  *%rdx
			close(fd_src);
  802e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e26:	89 c7                	mov    %eax,%edi
  802e28:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
			close(fd_dest);
  802e34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e37:	89 c7                	mov    %eax,%edi
  802e39:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802e40:	00 00 00 
  802e43:	ff d0                	callq  *%rax
			return write_size;
  802e45:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e48:	e9 a1 00 00 00       	jmpq   802eee <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e4d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e57:	ba 00 02 00 00       	mov    $0x200,%edx
  802e5c:	48 89 ce             	mov    %rcx,%rsi
  802e5f:	89 c7                	mov    %eax,%edi
  802e61:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	callq  *%rax
  802e6d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e74:	0f 8f 5f ff ff ff    	jg     802dd9 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e7e:	79 47                	jns    802ec7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e80:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e83:	89 c6                	mov    %eax,%esi
  802e85:	48 bf fc 4a 80 00 00 	movabs $0x804afc,%rdi
  802e8c:	00 00 00 
  802e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e94:	48 ba c1 07 80 00 00 	movabs $0x8007c1,%rdx
  802e9b:	00 00 00 
  802e9e:	ff d2                	callq  *%rdx
		close(fd_src);
  802ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea3:	89 c7                	mov    %eax,%edi
  802ea5:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
		close(fd_dest);
  802eb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eb4:	89 c7                	mov    %eax,%edi
  802eb6:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802ebd:	00 00 00 
  802ec0:	ff d0                	callq  *%rax
		return read_size;
  802ec2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ec5:	eb 27                	jmp    802eee <copy+0x1d9>
	}
	close(fd_src);
  802ec7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eca:	89 c7                	mov    %eax,%edi
  802ecc:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
	close(fd_dest);
  802ed8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802edb:	89 c7                	mov    %eax,%edi
  802edd:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802ee4:	00 00 00 
  802ee7:	ff d0                	callq  *%rax
	return 0;
  802ee9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802eee:	c9                   	leaveq 
  802eef:	c3                   	retq   

0000000000802ef0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ef0:	55                   	push   %rbp
  802ef1:	48 89 e5             	mov    %rsp,%rbp
  802ef4:	48 83 ec 20          	sub    $0x20,%rsp
  802ef8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802efb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f02:	48 89 d6             	mov    %rdx,%rsi
  802f05:	89 c7                	mov    %eax,%edi
  802f07:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
  802f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1a:	79 05                	jns    802f21 <fd2sockid+0x31>
		return r;
  802f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1f:	eb 24                	jmp    802f45 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f25:	8b 10                	mov    (%rax),%edx
  802f27:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f2e:	00 00 00 
  802f31:	8b 00                	mov    (%rax),%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	74 07                	je     802f3e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f37:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f3c:	eb 07                	jmp    802f45 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f42:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f45:	c9                   	leaveq 
  802f46:	c3                   	retq   

0000000000802f47 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f47:	55                   	push   %rbp
  802f48:	48 89 e5             	mov    %rsp,%rbp
  802f4b:	48 83 ec 20          	sub    $0x20,%rsp
  802f4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f52:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f56:	48 89 c7             	mov    %rax,%rdi
  802f59:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
  802f65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6c:	78 26                	js     802f94 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f72:	ba 07 04 00 00       	mov    $0x407,%edx
  802f77:	48 89 c6             	mov    %rax,%rsi
  802f7a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f7f:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  802f86:	00 00 00 
  802f89:	ff d0                	callq  *%rax
  802f8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f92:	79 16                	jns    802faa <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f97:	89 c7                	mov    %eax,%edi
  802f99:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
		return r;
  802fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa8:	eb 3a                	jmp    802fe4 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fae:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802fb5:	00 00 00 
  802fb8:	8b 12                	mov    (%rdx),%edx
  802fba:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fce:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd5:	48 89 c7             	mov    %rax,%rdi
  802fd8:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802fdf:	00 00 00 
  802fe2:	ff d0                	callq  *%rax
}
  802fe4:	c9                   	leaveq 
  802fe5:	c3                   	retq   

0000000000802fe6 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fe6:	55                   	push   %rbp
  802fe7:	48 89 e5             	mov    %rsp,%rbp
  802fea:	48 83 ec 30          	sub    $0x30,%rsp
  802fee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ff1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ff9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ffc:	89 c7                	mov    %eax,%edi
  802ffe:	48 b8 f0 2e 80 00 00 	movabs $0x802ef0,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
  80300a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803011:	79 05                	jns    803018 <accept+0x32>
		return r;
  803013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803016:	eb 3b                	jmp    803053 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803018:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80301c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803023:	48 89 ce             	mov    %rcx,%rsi
  803026:	89 c7                	mov    %eax,%edi
  803028:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303b:	79 05                	jns    803042 <accept+0x5c>
		return r;
  80303d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803040:	eb 11                	jmp    803053 <accept+0x6d>
	return alloc_sockfd(r);
  803042:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803045:	89 c7                	mov    %eax,%edi
  803047:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  80304e:	00 00 00 
  803051:	ff d0                	callq  *%rax
}
  803053:	c9                   	leaveq 
  803054:	c3                   	retq   

0000000000803055 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803055:	55                   	push   %rbp
  803056:	48 89 e5             	mov    %rsp,%rbp
  803059:	48 83 ec 20          	sub    $0x20,%rsp
  80305d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803060:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803064:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803067:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80306a:	89 c7                	mov    %eax,%edi
  80306c:	48 b8 f0 2e 80 00 00 	movabs $0x802ef0,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
  803078:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307f:	79 05                	jns    803086 <bind+0x31>
		return r;
  803081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803084:	eb 1b                	jmp    8030a1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803086:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803089:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80308d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803090:	48 89 ce             	mov    %rcx,%rsi
  803093:	89 c7                	mov    %eax,%edi
  803095:	48 b8 b2 33 80 00 00 	movabs $0x8033b2,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
}
  8030a1:	c9                   	leaveq 
  8030a2:	c3                   	retq   

00000000008030a3 <shutdown>:

int
shutdown(int s, int how)
{
  8030a3:	55                   	push   %rbp
  8030a4:	48 89 e5             	mov    %rsp,%rbp
  8030a7:	48 83 ec 20          	sub    $0x20,%rsp
  8030ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b4:	89 c7                	mov    %eax,%edi
  8030b6:	48 b8 f0 2e 80 00 00 	movabs $0x802ef0,%rax
  8030bd:	00 00 00 
  8030c0:	ff d0                	callq  *%rax
  8030c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c9:	79 05                	jns    8030d0 <shutdown+0x2d>
		return r;
  8030cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ce:	eb 16                	jmp    8030e6 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8030d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d6:	89 d6                	mov    %edx,%esi
  8030d8:	89 c7                	mov    %eax,%edi
  8030da:	48 b8 16 34 80 00 00 	movabs $0x803416,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
}
  8030e6:	c9                   	leaveq 
  8030e7:	c3                   	retq   

00000000008030e8 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8030e8:	55                   	push   %rbp
  8030e9:	48 89 e5             	mov    %rsp,%rbp
  8030ec:	48 83 ec 10          	sub    $0x10,%rsp
  8030f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f8:	48 89 c7             	mov    %rax,%rdi
  8030fb:	48 b8 4a 42 80 00 00 	movabs $0x80424a,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax
  803107:	83 f8 01             	cmp    $0x1,%eax
  80310a:	75 17                	jne    803123 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80310c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803110:	8b 40 0c             	mov    0xc(%rax),%eax
  803113:	89 c7                	mov    %eax,%edi
  803115:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
  803121:	eb 05                	jmp    803128 <devsock_close+0x40>
	else
		return 0;
  803123:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803128:	c9                   	leaveq 
  803129:	c3                   	retq   

000000000080312a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80312a:	55                   	push   %rbp
  80312b:	48 89 e5             	mov    %rsp,%rbp
  80312e:	48 83 ec 20          	sub    $0x20,%rsp
  803132:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803135:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803139:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80313c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80313f:	89 c7                	mov    %eax,%edi
  803141:	48 b8 f0 2e 80 00 00 	movabs $0x802ef0,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
  80314d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803150:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803154:	79 05                	jns    80315b <connect+0x31>
		return r;
  803156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803159:	eb 1b                	jmp    803176 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80315b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80315e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803162:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803165:	48 89 ce             	mov    %rcx,%rsi
  803168:	89 c7                	mov    %eax,%edi
  80316a:	48 b8 83 34 80 00 00 	movabs $0x803483,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
}
  803176:	c9                   	leaveq 
  803177:	c3                   	retq   

0000000000803178 <listen>:

int
listen(int s, int backlog)
{
  803178:	55                   	push   %rbp
  803179:	48 89 e5             	mov    %rsp,%rbp
  80317c:	48 83 ec 20          	sub    $0x20,%rsp
  803180:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803183:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803186:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803189:	89 c7                	mov    %eax,%edi
  80318b:	48 b8 f0 2e 80 00 00 	movabs $0x802ef0,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
  803197:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80319e:	79 05                	jns    8031a5 <listen+0x2d>
		return r;
  8031a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a3:	eb 16                	jmp    8031bb <listen+0x43>
	return nsipc_listen(r, backlog);
  8031a5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ab:	89 d6                	mov    %edx,%esi
  8031ad:	89 c7                	mov    %eax,%edi
  8031af:	48 b8 e7 34 80 00 00 	movabs $0x8034e7,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
}
  8031bb:	c9                   	leaveq 
  8031bc:	c3                   	retq   

00000000008031bd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031bd:	55                   	push   %rbp
  8031be:	48 89 e5             	mov    %rsp,%rbp
  8031c1:	48 83 ec 20          	sub    $0x20,%rsp
  8031c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d5:	89 c2                	mov    %eax,%edx
  8031d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031db:	8b 40 0c             	mov    0xc(%rax),%eax
  8031de:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031e7:	89 c7                	mov    %eax,%edi
  8031e9:	48 b8 27 35 80 00 00 	movabs $0x803527,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
}
  8031f5:	c9                   	leaveq 
  8031f6:	c3                   	retq   

00000000008031f7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031f7:	55                   	push   %rbp
  8031f8:	48 89 e5             	mov    %rsp,%rbp
  8031fb:	48 83 ec 20          	sub    $0x20,%rsp
  8031ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803203:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803207:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80320b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320f:	89 c2                	mov    %eax,%edx
  803211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803215:	8b 40 0c             	mov    0xc(%rax),%eax
  803218:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80321c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803221:	89 c7                	mov    %eax,%edi
  803223:	48 b8 f3 35 80 00 00 	movabs $0x8035f3,%rax
  80322a:	00 00 00 
  80322d:	ff d0                	callq  *%rax
}
  80322f:	c9                   	leaveq 
  803230:	c3                   	retq   

0000000000803231 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803231:	55                   	push   %rbp
  803232:	48 89 e5             	mov    %rsp,%rbp
  803235:	48 83 ec 10          	sub    $0x10,%rsp
  803239:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80323d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803245:	48 be 17 4b 80 00 00 	movabs $0x804b17,%rsi
  80324c:	00 00 00 
  80324f:	48 89 c7             	mov    %rax,%rdi
  803252:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
	return 0;
  80325e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803263:	c9                   	leaveq 
  803264:	c3                   	retq   

0000000000803265 <socket>:

int
socket(int domain, int type, int protocol)
{
  803265:	55                   	push   %rbp
  803266:	48 89 e5             	mov    %rsp,%rbp
  803269:	48 83 ec 20          	sub    $0x20,%rsp
  80326d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803270:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803273:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803276:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803279:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80327c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327f:	89 ce                	mov    %ecx,%esi
  803281:	89 c7                	mov    %eax,%edi
  803283:	48 b8 ab 36 80 00 00 	movabs $0x8036ab,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
  80328f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803296:	79 05                	jns    80329d <socket+0x38>
		return r;
  803298:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329b:	eb 11                	jmp    8032ae <socket+0x49>
	return alloc_sockfd(r);
  80329d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a0:	89 c7                	mov    %eax,%edi
  8032a2:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
}
  8032ae:	c9                   	leaveq 
  8032af:	c3                   	retq   

00000000008032b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032b0:	55                   	push   %rbp
  8032b1:	48 89 e5             	mov    %rsp,%rbp
  8032b4:	48 83 ec 10          	sub    $0x10,%rsp
  8032b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8032bb:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8032c2:	00 00 00 
  8032c5:	8b 00                	mov    (%rax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	75 1f                	jne    8032ea <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032cb:	bf 02 00 00 00       	mov    $0x2,%edi
  8032d0:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
  8032dc:	89 c2                	mov    %eax,%edx
  8032de:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8032e5:	00 00 00 
  8032e8:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032ea:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8032f1:	00 00 00 
  8032f4:	8b 00                	mov    (%rax),%eax
  8032f6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032f9:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032fe:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803305:	00 00 00 
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 4b 40 80 00 00 	movabs $0x80404b,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803316:	ba 00 00 00 00       	mov    $0x0,%edx
  80331b:	be 00 00 00 00       	mov    $0x0,%esi
  803320:	bf 00 00 00 00       	mov    $0x0,%edi
  803325:	48 b8 0d 40 80 00 00 	movabs $0x80400d,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
}
  803331:	c9                   	leaveq 
  803332:	c3                   	retq   

0000000000803333 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803333:	55                   	push   %rbp
  803334:	48 89 e5             	mov    %rsp,%rbp
  803337:	48 83 ec 30          	sub    $0x30,%rsp
  80333b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80333e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803342:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803346:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80334d:	00 00 00 
  803350:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803353:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803355:	bf 01 00 00 00       	mov    $0x1,%edi
  80335a:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
  803366:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803369:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336d:	78 3e                	js     8033ad <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80336f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803376:	00 00 00 
  803379:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80337d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803381:	8b 40 10             	mov    0x10(%rax),%eax
  803384:	89 c2                	mov    %eax,%edx
  803386:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80338a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80338e:	48 89 ce             	mov    %rcx,%rsi
  803391:	48 89 c7             	mov    %rax,%rdi
  803394:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8033a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a4:	8b 50 10             	mov    0x10(%rax),%edx
  8033a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ab:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8033ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033b0:	c9                   	leaveq 
  8033b1:	c3                   	retq   

00000000008033b2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033b2:	55                   	push   %rbp
  8033b3:	48 89 e5             	mov    %rsp,%rbp
  8033b6:	48 83 ec 10          	sub    $0x10,%rsp
  8033ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033c1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8033c4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033cb:	00 00 00 
  8033ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033d1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8033d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033da:	48 89 c6             	mov    %rax,%rsi
  8033dd:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033e4:	00 00 00 
  8033e7:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8033f3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033fa:	00 00 00 
  8033fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803400:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803403:	bf 02 00 00 00       	mov    $0x2,%edi
  803408:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  80340f:	00 00 00 
  803412:	ff d0                	callq  *%rax
}
  803414:	c9                   	leaveq 
  803415:	c3                   	retq   

0000000000803416 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803416:	55                   	push   %rbp
  803417:	48 89 e5             	mov    %rsp,%rbp
  80341a:	48 83 ec 10          	sub    $0x10,%rsp
  80341e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803421:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803424:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342b:	00 00 00 
  80342e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803431:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803433:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80343a:	00 00 00 
  80343d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803440:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803443:	bf 03 00 00 00       	mov    $0x3,%edi
  803448:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
}
  803454:	c9                   	leaveq 
  803455:	c3                   	retq   

0000000000803456 <nsipc_close>:

int
nsipc_close(int s)
{
  803456:	55                   	push   %rbp
  803457:	48 89 e5             	mov    %rsp,%rbp
  80345a:	48 83 ec 10          	sub    $0x10,%rsp
  80345e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803461:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803468:	00 00 00 
  80346b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80346e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803470:	bf 04 00 00 00       	mov    $0x4,%edi
  803475:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
}
  803481:	c9                   	leaveq 
  803482:	c3                   	retq   

0000000000803483 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803483:	55                   	push   %rbp
  803484:	48 89 e5             	mov    %rsp,%rbp
  803487:	48 83 ec 10          	sub    $0x10,%rsp
  80348b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80348e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803492:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803495:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80349c:	00 00 00 
  80349f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034a2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8034a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ab:	48 89 c6             	mov    %rax,%rsi
  8034ae:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8034b5:	00 00 00 
  8034b8:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8034bf:	00 00 00 
  8034c2:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8034c4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034cb:	00 00 00 
  8034ce:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034d1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8034d4:	bf 05 00 00 00       	mov    $0x5,%edi
  8034d9:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   

00000000008034e7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 10          	sub    $0x10,%rsp
  8034ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034f2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8034f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fc:	00 00 00 
  8034ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803502:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803504:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80350b:	00 00 00 
  80350e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803511:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803514:	bf 06 00 00 00       	mov    $0x6,%edi
  803519:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  803520:	00 00 00 
  803523:	ff d0                	callq  *%rax
}
  803525:	c9                   	leaveq 
  803526:	c3                   	retq   

0000000000803527 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803527:	55                   	push   %rbp
  803528:	48 89 e5             	mov    %rsp,%rbp
  80352b:	48 83 ec 30          	sub    $0x30,%rsp
  80352f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803532:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803536:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803539:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80353c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803543:	00 00 00 
  803546:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803549:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80354b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803552:	00 00 00 
  803555:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803558:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80355b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803562:	00 00 00 
  803565:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803568:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80356b:	bf 07 00 00 00       	mov    $0x7,%edi
  803570:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
  80357c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803583:	78 69                	js     8035ee <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803585:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80358c:	7f 08                	jg     803596 <nsipc_recv+0x6f>
  80358e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803591:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803594:	7e 35                	jle    8035cb <nsipc_recv+0xa4>
  803596:	48 b9 1e 4b 80 00 00 	movabs $0x804b1e,%rcx
  80359d:	00 00 00 
  8035a0:	48 ba 33 4b 80 00 00 	movabs $0x804b33,%rdx
  8035a7:	00 00 00 
  8035aa:	be 61 00 00 00       	mov    $0x61,%esi
  8035af:	48 bf 48 4b 80 00 00 	movabs $0x804b48,%rdi
  8035b6:	00 00 00 
  8035b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035be:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  8035c5:	00 00 00 
  8035c8:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ce:	48 63 d0             	movslq %eax,%rdx
  8035d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035dc:	00 00 00 
  8035df:	48 89 c7             	mov    %rax,%rdi
  8035e2:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8035e9:	00 00 00 
  8035ec:	ff d0                	callq  *%rax
	}

	return r;
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035f1:	c9                   	leaveq 
  8035f2:	c3                   	retq   

00000000008035f3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035f3:	55                   	push   %rbp
  8035f4:	48 89 e5             	mov    %rsp,%rbp
  8035f7:	48 83 ec 20          	sub    $0x20,%rsp
  8035fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803602:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803605:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803608:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360f:	00 00 00 
  803612:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803615:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803617:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80361e:	7e 35                	jle    803655 <nsipc_send+0x62>
  803620:	48 b9 54 4b 80 00 00 	movabs $0x804b54,%rcx
  803627:	00 00 00 
  80362a:	48 ba 33 4b 80 00 00 	movabs $0x804b33,%rdx
  803631:	00 00 00 
  803634:	be 6c 00 00 00       	mov    $0x6c,%esi
  803639:	48 bf 48 4b 80 00 00 	movabs $0x804b48,%rdi
  803640:	00 00 00 
  803643:	b8 00 00 00 00       	mov    $0x0,%eax
  803648:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  80364f:	00 00 00 
  803652:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803655:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803658:	48 63 d0             	movslq %eax,%rdx
  80365b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365f:	48 89 c6             	mov    %rax,%rsi
  803662:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803669:	00 00 00 
  80366c:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803678:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80367f:	00 00 00 
  803682:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803685:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803688:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80368f:	00 00 00 
  803692:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803695:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803698:	bf 08 00 00 00       	mov    $0x8,%edi
  80369d:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  8036a4:	00 00 00 
  8036a7:	ff d0                	callq  *%rax
}
  8036a9:	c9                   	leaveq 
  8036aa:	c3                   	retq   

00000000008036ab <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8036ab:	55                   	push   %rbp
  8036ac:	48 89 e5             	mov    %rsp,%rbp
  8036af:	48 83 ec 10          	sub    $0x10,%rsp
  8036b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036b6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8036b9:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8036bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c3:	00 00 00 
  8036c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036c9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8036cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d2:	00 00 00 
  8036d5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036d8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8036db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e2:	00 00 00 
  8036e5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8036e8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8036eb:	bf 09 00 00 00       	mov    $0x9,%edi
  8036f0:	48 b8 b0 32 80 00 00 	movabs $0x8032b0,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
}
  8036fc:	c9                   	leaveq 
  8036fd:	c3                   	retq   

00000000008036fe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036fe:	55                   	push   %rbp
  8036ff:	48 89 e5             	mov    %rsp,%rbp
  803702:	53                   	push   %rbx
  803703:	48 83 ec 38          	sub    $0x38,%rsp
  803707:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80370b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80370f:	48 89 c7             	mov    %rax,%rdi
  803712:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  803719:	00 00 00 
  80371c:	ff d0                	callq  *%rax
  80371e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803721:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803725:	0f 88 bf 01 00 00    	js     8038ea <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80372b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372f:	ba 07 04 00 00       	mov    $0x407,%edx
  803734:	48 89 c6             	mov    %rax,%rsi
  803737:	bf 00 00 00 00       	mov    $0x0,%edi
  80373c:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80374b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80374f:	0f 88 95 01 00 00    	js     8038ea <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803755:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
  803768:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80376b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80376f:	0f 88 5d 01 00 00    	js     8038d2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803775:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803779:	ba 07 04 00 00       	mov    $0x407,%edx
  80377e:	48 89 c6             	mov    %rax,%rsi
  803781:	bf 00 00 00 00       	mov    $0x0,%edi
  803786:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
  803792:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803795:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803799:	0f 88 33 01 00 00    	js     8038d2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80379f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a3:	48 89 c7             	mov    %rax,%rdi
  8037a6:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
  8037b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8037bf:	48 89 c6             	mov    %rax,%rsi
  8037c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c7:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
  8037d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037da:	79 05                	jns    8037e1 <pipe+0xe3>
		goto err2;
  8037dc:	e9 d9 00 00 00       	jmpq   8038ba <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e5:	48 89 c7             	mov    %rax,%rdi
  8037e8:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8037ef:	00 00 00 
  8037f2:	ff d0                	callq  *%rax
  8037f4:	48 89 c2             	mov    %rax,%rdx
  8037f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803801:	48 89 d1             	mov    %rdx,%rcx
  803804:	ba 00 00 00 00       	mov    $0x0,%edx
  803809:	48 89 c6             	mov    %rax,%rsi
  80380c:	bf 00 00 00 00       	mov    $0x0,%edi
  803811:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803820:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803824:	79 1b                	jns    803841 <pipe+0x143>
		goto err3;
  803826:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803827:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80382b:	48 89 c6             	mov    %rax,%rsi
  80382e:	bf 00 00 00 00       	mov    $0x0,%edi
  803833:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	eb 79                	jmp    8038ba <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803845:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80384c:	00 00 00 
  80384f:	8b 12                	mov    (%rdx),%edx
  803851:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803857:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80385e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803862:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803869:	00 00 00 
  80386c:	8b 12                	mov    (%rdx),%edx
  80386e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803870:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803874:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80387b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80387f:	48 89 c7             	mov    %rax,%rdi
  803882:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  803889:	00 00 00 
  80388c:	ff d0                	callq  *%rax
  80388e:	89 c2                	mov    %eax,%edx
  803890:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803894:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803896:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80389a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80389e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a2:	48 89 c7             	mov    %rax,%rdi
  8038a5:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b8:	eb 33                	jmp    8038ed <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8038ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038be:	48 89 c6             	mov    %rax,%rsi
  8038c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c6:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8038d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d6:	48 89 c6             	mov    %rax,%rsi
  8038d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038de:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8038e5:	00 00 00 
  8038e8:	ff d0                	callq  *%rax
err:
	return r;
  8038ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038ed:	48 83 c4 38          	add    $0x38,%rsp
  8038f1:	5b                   	pop    %rbx
  8038f2:	5d                   	pop    %rbp
  8038f3:	c3                   	retq   

00000000008038f4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038f4:	55                   	push   %rbp
  8038f5:	48 89 e5             	mov    %rsp,%rbp
  8038f8:	53                   	push   %rbx
  8038f9:	48 83 ec 28          	sub    $0x28,%rsp
  8038fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803901:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803905:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80390c:	00 00 00 
  80390f:	48 8b 00             	mov    (%rax),%rax
  803912:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803918:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80391b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391f:	48 89 c7             	mov    %rax,%rdi
  803922:	48 b8 4a 42 80 00 00 	movabs $0x80424a,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	89 c3                	mov    %eax,%ebx
  803930:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803934:	48 89 c7             	mov    %rax,%rdi
  803937:	48 b8 4a 42 80 00 00 	movabs $0x80424a,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
  803943:	39 c3                	cmp    %eax,%ebx
  803945:	0f 94 c0             	sete   %al
  803948:	0f b6 c0             	movzbl %al,%eax
  80394b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80394e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803955:	00 00 00 
  803958:	48 8b 00             	mov    (%rax),%rax
  80395b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803961:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803964:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803967:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80396a:	75 05                	jne    803971 <_pipeisclosed+0x7d>
			return ret;
  80396c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80396f:	eb 4a                	jmp    8039bb <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803971:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803974:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803977:	74 3d                	je     8039b6 <_pipeisclosed+0xc2>
  803979:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80397d:	75 37                	jne    8039b6 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80397f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803986:	00 00 00 
  803989:	48 8b 00             	mov    (%rax),%rax
  80398c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803992:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803995:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803998:	89 c6                	mov    %eax,%esi
  80399a:	48 bf 65 4b 80 00 00 	movabs $0x804b65,%rdi
  8039a1:	00 00 00 
  8039a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a9:	49 b8 c1 07 80 00 00 	movabs $0x8007c1,%r8
  8039b0:	00 00 00 
  8039b3:	41 ff d0             	callq  *%r8
	}
  8039b6:	e9 4a ff ff ff       	jmpq   803905 <_pipeisclosed+0x11>
}
  8039bb:	48 83 c4 28          	add    $0x28,%rsp
  8039bf:	5b                   	pop    %rbx
  8039c0:	5d                   	pop    %rbp
  8039c1:	c3                   	retq   

00000000008039c2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8039c2:	55                   	push   %rbp
  8039c3:	48 89 e5             	mov    %rsp,%rbp
  8039c6:	48 83 ec 30          	sub    $0x30,%rsp
  8039ca:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039d4:	48 89 d6             	mov    %rdx,%rsi
  8039d7:	89 c7                	mov    %eax,%edi
  8039d9:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
  8039e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ec:	79 05                	jns    8039f3 <pipeisclosed+0x31>
		return r;
  8039ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f1:	eb 31                	jmp    803a24 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f7:	48 89 c7             	mov    %rax,%rdi
  8039fa:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803a01:	00 00 00 
  803a04:	ff d0                	callq  *%rax
  803a06:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a12:	48 89 d6             	mov    %rdx,%rsi
  803a15:	48 89 c7             	mov    %rax,%rdi
  803a18:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
}
  803a24:	c9                   	leaveq 
  803a25:	c3                   	retq   

0000000000803a26 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a26:	55                   	push   %rbp
  803a27:	48 89 e5             	mov    %rsp,%rbp
  803a2a:	48 83 ec 40          	sub    $0x40,%rsp
  803a2e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a32:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a36:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3e:	48 89 c7             	mov    %rax,%rdi
  803a41:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803a48:	00 00 00 
  803a4b:	ff d0                	callq  *%rax
  803a4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a59:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a60:	00 
  803a61:	e9 92 00 00 00       	jmpq   803af8 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803a66:	eb 41                	jmp    803aa9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a68:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a6d:	74 09                	je     803a78 <devpipe_read+0x52>
				return i;
  803a6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a73:	e9 92 00 00 00       	jmpq   803b0a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a80:	48 89 d6             	mov    %rdx,%rsi
  803a83:	48 89 c7             	mov    %rax,%rdi
  803a86:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
  803a92:	85 c0                	test   %eax,%eax
  803a94:	74 07                	je     803a9d <devpipe_read+0x77>
				return 0;
  803a96:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9b:	eb 6d                	jmp    803b0a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a9d:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803aa4:	00 00 00 
  803aa7:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aad:	8b 10                	mov    (%rax),%edx
  803aaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab3:	8b 40 04             	mov    0x4(%rax),%eax
  803ab6:	39 c2                	cmp    %eax,%edx
  803ab8:	74 ae                	je     803a68 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803aba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ac6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aca:	8b 00                	mov    (%rax),%eax
  803acc:	99                   	cltd   
  803acd:	c1 ea 1b             	shr    $0x1b,%edx
  803ad0:	01 d0                	add    %edx,%eax
  803ad2:	83 e0 1f             	and    $0x1f,%eax
  803ad5:	29 d0                	sub    %edx,%eax
  803ad7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803adb:	48 98                	cltq   
  803add:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803ae2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae8:	8b 00                	mov    (%rax),%eax
  803aea:	8d 50 01             	lea    0x1(%rax),%edx
  803aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af1:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803af3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803af8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803afc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b00:	0f 82 60 ff ff ff    	jb     803a66 <devpipe_read+0x40>
	}
	return i;
  803b06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b0a:	c9                   	leaveq 
  803b0b:	c3                   	retq   

0000000000803b0c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b0c:	55                   	push   %rbp
  803b0d:	48 89 e5             	mov    %rsp,%rbp
  803b10:	48 83 ec 40          	sub    $0x40,%rsp
  803b14:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b18:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b1c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b24:	48 89 c7             	mov    %rax,%rdi
  803b27:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b3f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b46:	00 
  803b47:	e9 91 00 00 00       	jmpq   803bdd <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b4c:	eb 31                	jmp    803b7f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b56:	48 89 d6             	mov    %rdx,%rsi
  803b59:	48 89 c7             	mov    %rax,%rdi
  803b5c:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803b63:	00 00 00 
  803b66:	ff d0                	callq  *%rax
  803b68:	85 c0                	test   %eax,%eax
  803b6a:	74 07                	je     803b73 <devpipe_write+0x67>
				return 0;
  803b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b71:	eb 7c                	jmp    803bef <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b73:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b83:	8b 40 04             	mov    0x4(%rax),%eax
  803b86:	48 63 d0             	movslq %eax,%rdx
  803b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8d:	8b 00                	mov    (%rax),%eax
  803b8f:	48 98                	cltq   
  803b91:	48 83 c0 20          	add    $0x20,%rax
  803b95:	48 39 c2             	cmp    %rax,%rdx
  803b98:	73 b4                	jae    803b4e <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9e:	8b 40 04             	mov    0x4(%rax),%eax
  803ba1:	99                   	cltd   
  803ba2:	c1 ea 1b             	shr    $0x1b,%edx
  803ba5:	01 d0                	add    %edx,%eax
  803ba7:	83 e0 1f             	and    $0x1f,%eax
  803baa:	29 d0                	sub    %edx,%eax
  803bac:	89 c6                	mov    %eax,%esi
  803bae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb6:	48 01 d0             	add    %rdx,%rax
  803bb9:	0f b6 08             	movzbl (%rax),%ecx
  803bbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bc0:	48 63 c6             	movslq %esi,%rax
  803bc3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcb:	8b 40 04             	mov    0x4(%rax),%eax
  803bce:	8d 50 01             	lea    0x1(%rax),%edx
  803bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd5:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803bd8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803be5:	0f 82 61 ff ff ff    	jb     803b4c <devpipe_write+0x40>
	}

	return i;
  803beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bef:	c9                   	leaveq 
  803bf0:	c3                   	retq   

0000000000803bf1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803bf1:	55                   	push   %rbp
  803bf2:	48 89 e5             	mov    %rsp,%rbp
  803bf5:	48 83 ec 20          	sub    $0x20,%rsp
  803bf9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c05:	48 89 c7             	mov    %rax,%rdi
  803c08:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
  803c14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c1c:	48 be 78 4b 80 00 00 	movabs $0x804b78,%rsi
  803c23:	00 00 00 
  803c26:	48 89 c7             	mov    %rax,%rdi
  803c29:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c39:	8b 50 04             	mov    0x4(%rax),%edx
  803c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c40:	8b 00                	mov    (%rax),%eax
  803c42:	29 c2                	sub    %eax,%edx
  803c44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c48:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c52:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c59:	00 00 00 
	stat->st_dev = &devpipe;
  803c5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c60:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803c67:	00 00 00 
  803c6a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c76:	c9                   	leaveq 
  803c77:	c3                   	retq   

0000000000803c78 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c78:	55                   	push   %rbp
  803c79:	48 89 e5             	mov    %rsp,%rbp
  803c7c:	48 83 ec 10          	sub    $0x10,%rsp
  803c80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c88:	48 89 c6             	mov    %rax,%rsi
  803c8b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c90:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803c97:	00 00 00 
  803c9a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca0:	48 89 c7             	mov    %rax,%rdi
  803ca3:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	48 89 c6             	mov    %rax,%rsi
  803cb2:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb7:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803cbe:	00 00 00 
  803cc1:	ff d0                	callq  *%rax
}
  803cc3:	c9                   	leaveq 
  803cc4:	c3                   	retq   

0000000000803cc5 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 83 ec 20          	sub    $0x20,%rsp
  803ccd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803cd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd4:	75 35                	jne    803d0b <wait+0x46>
  803cd6:	48 b9 7f 4b 80 00 00 	movabs $0x804b7f,%rcx
  803cdd:	00 00 00 
  803ce0:	48 ba 8a 4b 80 00 00 	movabs $0x804b8a,%rdx
  803ce7:	00 00 00 
  803cea:	be 09 00 00 00       	mov    $0x9,%esi
  803cef:	48 bf 9f 4b 80 00 00 	movabs $0x804b9f,%rdi
  803cf6:	00 00 00 
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfe:	49 b8 88 05 80 00 00 	movabs $0x800588,%r8
  803d05:	00 00 00 
  803d08:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803d0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d0e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d13:	48 98                	cltq   
  803d15:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803d1c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d23:	00 00 00 
  803d26:	48 01 d0             	add    %rdx,%rax
  803d29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803d2d:	eb 0c                	jmp    803d3b <wait+0x76>
		sys_yield();
  803d2f:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803d36:	00 00 00 
  803d39:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d45:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d48:	75 0e                	jne    803d58 <wait+0x93>
  803d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d4e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d54:	85 c0                	test   %eax,%eax
  803d56:	75 d7                	jne    803d2f <wait+0x6a>
}
  803d58:	c9                   	leaveq 
  803d59:	c3                   	retq   

0000000000803d5a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d5a:	55                   	push   %rbp
  803d5b:	48 89 e5             	mov    %rsp,%rbp
  803d5e:	48 83 ec 20          	sub    $0x20,%rsp
  803d62:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d68:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d6b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d6f:	be 01 00 00 00       	mov    $0x1,%esi
  803d74:	48 89 c7             	mov    %rax,%rdi
  803d77:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803d7e:	00 00 00 
  803d81:	ff d0                	callq  *%rax
}
  803d83:	c9                   	leaveq 
  803d84:	c3                   	retq   

0000000000803d85 <getchar>:

int
getchar(void)
{
  803d85:	55                   	push   %rbp
  803d86:	48 89 e5             	mov    %rsp,%rbp
  803d89:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d8d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d91:	ba 01 00 00 00       	mov    $0x1,%edx
  803d96:	48 89 c6             	mov    %rax,%rsi
  803d99:	bf 00 00 00 00       	mov    $0x0,%edi
  803d9e:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
  803daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db1:	79 05                	jns    803db8 <getchar+0x33>
		return r;
  803db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db6:	eb 14                	jmp    803dcc <getchar+0x47>
	if (r < 1)
  803db8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dbc:	7f 07                	jg     803dc5 <getchar+0x40>
		return -E_EOF;
  803dbe:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803dc3:	eb 07                	jmp    803dcc <getchar+0x47>
	return c;
  803dc5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803dc9:	0f b6 c0             	movzbl %al,%eax
}
  803dcc:	c9                   	leaveq 
  803dcd:	c3                   	retq   

0000000000803dce <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803dce:	55                   	push   %rbp
  803dcf:	48 89 e5             	mov    %rsp,%rbp
  803dd2:	48 83 ec 20          	sub    $0x20,%rsp
  803dd6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dd9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ddd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803de0:	48 89 d6             	mov    %rdx,%rsi
  803de3:	89 c7                	mov    %eax,%edi
  803de5:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
  803df1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df8:	79 05                	jns    803dff <iscons+0x31>
		return r;
  803dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfd:	eb 1a                	jmp    803e19 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e03:	8b 10                	mov    (%rax),%edx
  803e05:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803e0c:	00 00 00 
  803e0f:	8b 00                	mov    (%rax),%eax
  803e11:	39 c2                	cmp    %eax,%edx
  803e13:	0f 94 c0             	sete   %al
  803e16:	0f b6 c0             	movzbl %al,%eax
}
  803e19:	c9                   	leaveq 
  803e1a:	c3                   	retq   

0000000000803e1b <opencons>:

int
opencons(void)
{
  803e1b:	55                   	push   %rbp
  803e1c:	48 89 e5             	mov    %rsp,%rbp
  803e1f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e23:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e27:	48 89 c7             	mov    %rax,%rdi
  803e2a:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  803e31:	00 00 00 
  803e34:	ff d0                	callq  *%rax
  803e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e3d:	79 05                	jns    803e44 <opencons+0x29>
		return r;
  803e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e42:	eb 5b                	jmp    803e9f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e48:	ba 07 04 00 00       	mov    $0x407,%edx
  803e4d:	48 89 c6             	mov    %rax,%rsi
  803e50:	bf 00 00 00 00       	mov    $0x0,%edi
  803e55:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  803e5c:	00 00 00 
  803e5f:	ff d0                	callq  *%rax
  803e61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e68:	79 05                	jns    803e6f <opencons+0x54>
		return r;
  803e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6d:	eb 30                	jmp    803e9f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e73:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e7a:	00 00 00 
  803e7d:	8b 12                	mov    (%rdx),%edx
  803e7f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e85:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e90:	48 89 c7             	mov    %rax,%rdi
  803e93:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  803e9a:	00 00 00 
  803e9d:	ff d0                	callq  *%rax
}
  803e9f:	c9                   	leaveq 
  803ea0:	c3                   	retq   

0000000000803ea1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ea1:	55                   	push   %rbp
  803ea2:	48 89 e5             	mov    %rsp,%rbp
  803ea5:	48 83 ec 30          	sub    $0x30,%rsp
  803ea9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ead:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803eb1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803eb5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803eba:	75 07                	jne    803ec3 <devcons_read+0x22>
		return 0;
  803ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec1:	eb 4b                	jmp    803f0e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803ec3:	eb 0c                	jmp    803ed1 <devcons_read+0x30>
		sys_yield();
  803ec5:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  803ecc:	00 00 00 
  803ecf:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803ed1:	48 b8 8e 1b 80 00 00 	movabs $0x801b8e,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
  803edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee4:	74 df                	je     803ec5 <devcons_read+0x24>
	if (c < 0)
  803ee6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eea:	79 05                	jns    803ef1 <devcons_read+0x50>
		return c;
  803eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eef:	eb 1d                	jmp    803f0e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ef1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ef5:	75 07                	jne    803efe <devcons_read+0x5d>
		return 0;
  803ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  803efc:	eb 10                	jmp    803f0e <devcons_read+0x6d>
	*(char*)vbuf = c;
  803efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f01:	89 c2                	mov    %eax,%edx
  803f03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f07:	88 10                	mov    %dl,(%rax)
	return 1;
  803f09:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f0e:	c9                   	leaveq 
  803f0f:	c3                   	retq   

0000000000803f10 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f10:	55                   	push   %rbp
  803f11:	48 89 e5             	mov    %rsp,%rbp
  803f14:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f1b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f22:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f29:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f37:	eb 76                	jmp    803faf <devcons_write+0x9f>
		m = n - tot;
  803f39:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f40:	89 c2                	mov    %eax,%edx
  803f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f45:	29 c2                	sub    %eax,%edx
  803f47:	89 d0                	mov    %edx,%eax
  803f49:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f4f:	83 f8 7f             	cmp    $0x7f,%eax
  803f52:	76 07                	jbe    803f5b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f54:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f5e:	48 63 d0             	movslq %eax,%rdx
  803f61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f64:	48 63 c8             	movslq %eax,%rcx
  803f67:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f6e:	48 01 c1             	add    %rax,%rcx
  803f71:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f78:	48 89 ce             	mov    %rcx,%rsi
  803f7b:	48 89 c7             	mov    %rax,%rdi
  803f7e:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  803f85:	00 00 00 
  803f88:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f8d:	48 63 d0             	movslq %eax,%rdx
  803f90:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f97:	48 89 d6             	mov    %rdx,%rsi
  803f9a:	48 89 c7             	mov    %rax,%rdi
  803f9d:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803fa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fac:	01 45 fc             	add    %eax,-0x4(%rbp)
  803faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb2:	48 98                	cltq   
  803fb4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803fbb:	0f 82 78 ff ff ff    	jb     803f39 <devcons_write+0x29>
	}
	return tot;
  803fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fc4:	c9                   	leaveq 
  803fc5:	c3                   	retq   

0000000000803fc6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803fc6:	55                   	push   %rbp
  803fc7:	48 89 e5             	mov    %rsp,%rbp
  803fca:	48 83 ec 08          	sub    $0x8,%rsp
  803fce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fd7:	c9                   	leaveq 
  803fd8:	c3                   	retq   

0000000000803fd9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fd9:	55                   	push   %rbp
  803fda:	48 89 e5             	mov    %rsp,%rbp
  803fdd:	48 83 ec 10          	sub    $0x10,%rsp
  803fe1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fe5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fed:	48 be af 4b 80 00 00 	movabs $0x804baf,%rsi
  803ff4:	00 00 00 
  803ff7:	48 89 c7             	mov    %rax,%rdi
  803ffa:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
	return 0;
  804006:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80400b:	c9                   	leaveq 
  80400c:	c3                   	retq   

000000000080400d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80400d:	55                   	push   %rbp
  80400e:	48 89 e5             	mov    %rsp,%rbp
  804011:	48 83 ec 20          	sub    $0x20,%rsp
  804015:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804019:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80401d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804021:	48 ba b8 4b 80 00 00 	movabs $0x804bb8,%rdx
  804028:	00 00 00 
  80402b:	be 1d 00 00 00       	mov    $0x1d,%esi
  804030:	48 bf d1 4b 80 00 00 	movabs $0x804bd1,%rdi
  804037:	00 00 00 
  80403a:	b8 00 00 00 00       	mov    $0x0,%eax
  80403f:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  804046:	00 00 00 
  804049:	ff d1                	callq  *%rcx

000000000080404b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80404b:	55                   	push   %rbp
  80404c:	48 89 e5             	mov    %rsp,%rbp
  80404f:	48 83 ec 20          	sub    $0x20,%rsp
  804053:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804056:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804059:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80405d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  804060:	48 ba db 4b 80 00 00 	movabs $0x804bdb,%rdx
  804067:	00 00 00 
  80406a:	be 2d 00 00 00       	mov    $0x2d,%esi
  80406f:	48 bf d1 4b 80 00 00 	movabs $0x804bd1,%rdi
  804076:	00 00 00 
  804079:	b8 00 00 00 00       	mov    $0x0,%eax
  80407e:	48 b9 88 05 80 00 00 	movabs $0x800588,%rcx
  804085:	00 00 00 
  804088:	ff d1                	callq  *%rcx

000000000080408a <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80408a:	55                   	push   %rbp
  80408b:	48 89 e5             	mov    %rsp,%rbp
  80408e:	53                   	push   %rbx
  80408f:	48 83 ec 48          	sub    $0x48,%rsp
  804093:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804097:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  80409e:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8040a5:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8040aa:	75 0e                	jne    8040ba <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8040ac:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8040b3:	00 00 00 
  8040b6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8040ba:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8040be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  8040c2:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8040c9:	00 
	a3 = (uint64_t) 0;
  8040ca:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8040d1:	00 
	a4 = (uint64_t) 0;
  8040d2:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8040d9:	00 
	a5 = 0;
  8040da:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8040e1:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  8040e2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040e9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8040ed:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  8040f1:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8040f5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8040f9:	4c 89 c3             	mov    %r8,%rbx
  8040fc:	0f 01 c1             	vmcall 
  8040ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804102:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804106:	7e 36                	jle    80413e <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804108:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80410b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80410e:	41 89 d0             	mov    %edx,%r8d
  804111:	89 c1                	mov    %eax,%ecx
  804113:	48 ba f8 4b 80 00 00 	movabs $0x804bf8,%rdx
  80411a:	00 00 00 
  80411d:	be 54 00 00 00       	mov    $0x54,%esi
  804122:	48 bf d1 4b 80 00 00 	movabs $0x804bd1,%rdi
  804129:	00 00 00 
  80412c:	b8 00 00 00 00       	mov    $0x0,%eax
  804131:	49 b9 88 05 80 00 00 	movabs $0x800588,%r9
  804138:	00 00 00 
  80413b:	41 ff d1             	callq  *%r9
	return ret;
  80413e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804141:	48 83 c4 48          	add    $0x48,%rsp
  804145:	5b                   	pop    %rbx
  804146:	5d                   	pop    %rbp
  804147:	c3                   	retq   

0000000000804148 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804148:	55                   	push   %rbp
  804149:	48 89 e5             	mov    %rsp,%rbp
  80414c:	53                   	push   %rbx
  80414d:	48 83 ec 58          	sub    $0x58,%rsp
  804151:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804154:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804157:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80415b:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80415e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804165:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  80416c:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  804171:	75 0e                	jne    804181 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  804173:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80417a:	00 00 00 
  80417d:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804181:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804184:	48 98                	cltq   
  804186:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  80418a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80418d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804191:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804195:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804199:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80419c:	48 98                	cltq   
  80419e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8041a2:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8041a9:	00 

	int r = -E_IPC_NOT_RECV;
  8041aa:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8041b1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8041b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8041bc:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8041c0:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8041c4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041c8:	4c 89 c3             	mov    %r8,%rbx
  8041cb:	0f 01 c1             	vmcall 
  8041ce:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  8041d1:	48 83 c4 58          	add    $0x58,%rsp
  8041d5:	5b                   	pop    %rbx
  8041d6:	5d                   	pop    %rbp
  8041d7:	c3                   	retq   

00000000008041d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041d8:	55                   	push   %rbp
  8041d9:	48 89 e5             	mov    %rsp,%rbp
  8041dc:	48 83 ec 18          	sub    $0x18,%rsp
  8041e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041ea:	eb 4e                	jmp    80423a <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8041ec:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041f3:	00 00 00 
  8041f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f9:	48 98                	cltq   
  8041fb:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804202:	48 01 d0             	add    %rdx,%rax
  804205:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80420b:	8b 00                	mov    (%rax),%eax
  80420d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804210:	75 24                	jne    804236 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804212:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804219:	00 00 00 
  80421c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421f:	48 98                	cltq   
  804221:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804228:	48 01 d0             	add    %rdx,%rax
  80422b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804231:	8b 40 08             	mov    0x8(%rax),%eax
  804234:	eb 12                	jmp    804248 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804236:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80423a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804241:	7e a9                	jle    8041ec <ipc_find_env+0x14>
	}
	return 0;
  804243:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804248:	c9                   	leaveq 
  804249:	c3                   	retq   

000000000080424a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80424a:	55                   	push   %rbp
  80424b:	48 89 e5             	mov    %rsp,%rbp
  80424e:	48 83 ec 18          	sub    $0x18,%rsp
  804252:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80425a:	48 c1 e8 15          	shr    $0x15,%rax
  80425e:	48 89 c2             	mov    %rax,%rdx
  804261:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804268:	01 00 00 
  80426b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80426f:	83 e0 01             	and    $0x1,%eax
  804272:	48 85 c0             	test   %rax,%rax
  804275:	75 07                	jne    80427e <pageref+0x34>
		return 0;
  804277:	b8 00 00 00 00       	mov    $0x0,%eax
  80427c:	eb 53                	jmp    8042d1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80427e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804282:	48 c1 e8 0c          	shr    $0xc,%rax
  804286:	48 89 c2             	mov    %rax,%rdx
  804289:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804290:	01 00 00 
  804293:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804297:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80429b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429f:	83 e0 01             	and    $0x1,%eax
  8042a2:	48 85 c0             	test   %rax,%rax
  8042a5:	75 07                	jne    8042ae <pageref+0x64>
		return 0;
  8042a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ac:	eb 23                	jmp    8042d1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b2:	48 c1 e8 0c          	shr    $0xc,%rax
  8042b6:	48 89 c2             	mov    %rax,%rdx
  8042b9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042c0:	00 00 00 
  8042c3:	48 c1 e2 04          	shl    $0x4,%rdx
  8042c7:	48 01 d0             	add    %rdx,%rax
  8042ca:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042ce:	0f b7 c0             	movzwl %ax,%eax
}
  8042d1:	c9                   	leaveq 
  8042d2:	c3                   	retq   
