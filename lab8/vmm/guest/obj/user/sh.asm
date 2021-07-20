
vmm/guest/obj/user/sh:     formato del fichero elf64-x86-64


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
  80003c:	e8 25 12 00 00       	callq  801266 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf 48 5f 80 00 00 	movabs $0x805f48,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf 60 5f 80 00 00 	movabs $0x805f60,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 86 5f 80 00 00 	movabs $0x805f86,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf a0 5f 80 00 00 	movabs $0x805fa0,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf c6 5f 80 00 00 	movabs $0x805fc6,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 01 56 80 00 00 	movabs $0x805601,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf dc 5f 80 00 00 	movabs $0x805fdc,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf e5 5f 80 00 00 	movabs $0x805fe5,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 2f 2f 80 00 00 	movabs $0x802f2f,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf f2 5f 80 00 00 	movabs $0x805ff2,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba fb 5f 80 00 00 	movabs $0x805ffb,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			goto runit;
  80046e:	90                   	nop

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf 21 60 80 00 00 	movabs $0x806021,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 6c 3b 80 00 00 	movabs $0x803b6c,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
	for(i=0;i<npaths;i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf 30 60 80 00 00 	movabs $0x806030,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf 3e 60 80 00 00 	movabs $0x80603e,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
		cprintf("\n");
  80063a:	48 bf 42 60 80 00 00 	movabs $0x806042,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf 44 60 80 00 00 	movabs $0x806044,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 ad 35 80 00 00 	movabs $0x8035ad,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf 52 60 80 00 00 	movabs $0x806052,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 22 15 80 00 00 	movabs $0x801522,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 c8 5b 80 00 00 	movabs $0x805bc8,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf 67 60 80 00 00 	movabs $0x806067,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf 7d 60 80 00 00 	movabs $0x80607d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 c8 5b 80 00 00 	movabs $0x805bc8,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf 67 60 80 00 00 	movabs $0x806067,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 9a 60 80 00 00 	movabs $0x80609a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf a9 60 80 00 00 	movabs $0x8060a9,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf b7 60 80 00 00 	movabs $0x8060b7,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf bc 60 80 00 00 	movabs $0x8060bc,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf c1 60 80 00 00 	movabs $0x8060c1,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf c9 60 80 00 00 	movabs $0x8060c9,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf d1 60 80 00 00 	movabs $0x8060d1,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf dd 60 80 00 00 	movabs $0x8060dd,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3c                	je     800aae <gettoken+0x53>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800aa2:	00 00 00 
  800aa5:	89 10                	mov    %edx,(%rax)
		return 0;
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aac:	eb 76                	jmp    800b24 <gettoken+0xc9>
	}
	c = nc;
  800aae:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800ab5:	00 00 00 
  800ab8:	8b 10                	mov    (%rax),%edx
  800aba:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800ac1:	00 00 00 
  800ac4:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800acd:	00 00 00 
  800ad0:	48 8b 10             	mov    (%rax),%rdx
  800ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad7:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ada:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800ae1:	00 00 00 
  800ae4:	48 8b 00             	mov    (%rax),%rax
  800ae7:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800aee:	00 00 00 
  800af1:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800af8:	00 00 00 
  800afb:	48 89 c7             	mov    %rax,%rdi
  800afe:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b05:	00 00 00 
  800b08:	ff d0                	callq  *%rax
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800b13:	00 00 00 
  800b16:	89 10                	mov    %edx,(%rax)
	return c;
  800b18:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800b1f:	00 00 00 
  800b22:	8b 00                	mov    (%rax),%eax
}
  800b24:	c9                   	leaveq 
  800b25:	c3                   	retq   

0000000000800b26 <usage>:


void
usage(void)
{
  800b26:	55                   	push   %rbp
  800b27:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b2a:	48 bf e8 60 80 00 00 	movabs $0x8060e8,%rdi
  800b31:	00 00 00 
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
  800b39:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800b40:	00 00 00 
  800b43:	ff d2                	callq  *%rdx
	exit();
  800b45:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800b4c:	00 00 00 
  800b4f:	ff d0                	callq  *%rax
}
  800b51:	5d                   	pop    %rbp
  800b52:	c3                   	retq   

0000000000800b53 <umain>:

void
umain(int argc, char **argv)
{
  800b53:	55                   	push   %rbp
  800b54:	48 89 e5             	mov    %rsp,%rbp
  800b57:	48 83 ec 50          	sub    $0x50,%rsp
  800b5b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;
	bool auto_terminate = false;
  800b62:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
	interactive = '?';
  800b66:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b6d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b74:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b78:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b7c:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b80:	48 89 ce             	mov    %rcx,%rsi
  800b83:	48 89 c7             	mov    %rax,%rdi
  800b86:	48 b8 8b 2f 80 00 00 	movabs $0x802f8b,%rax
  800b8d:	00 00 00 
  800b90:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b92:	eb 4d                	jmp    800be1 <umain+0x8e>
		switch (r) {
  800b94:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800b97:	83 f8 69             	cmp    $0x69,%eax
  800b9a:	74 27                	je     800bc3 <umain+0x70>
  800b9c:	83 f8 78             	cmp    $0x78,%eax
  800b9f:	74 2b                	je     800bcc <umain+0x79>
  800ba1:	83 f8 64             	cmp    $0x64,%eax
  800ba4:	75 2f                	jne    800bd5 <umain+0x82>
		case 'd':
			debug++;
  800ba6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800bad:	00 00 00 
  800bb0:	8b 00                	mov    (%rax),%eax
  800bb2:	8d 50 01             	lea    0x1(%rax),%edx
  800bb5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800bbc:	00 00 00 
  800bbf:	89 10                	mov    %edx,(%rax)
			break;
  800bc1:	eb 1e                	jmp    800be1 <umain+0x8e>
		case 'i':
			interactive = 1;
  800bc3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bca:	eb 15                	jmp    800be1 <umain+0x8e>
		case 'x':
			echocmds = 1;
  800bcc:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bd3:	eb 0c                	jmp    800be1 <umain+0x8e>
		default:
			usage();
  800bd5:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  800bdc:	00 00 00 
  800bdf:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800be1:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800be5:	48 89 c7             	mov    %rax,%rdi
  800be8:	48 b8 ef 2f 80 00 00 	movabs $0x802fef,%rax
  800bef:	00 00 00 
  800bf2:	ff d0                	callq  *%rax
  800bf4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800bf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800bfb:	79 97                	jns    800b94 <umain+0x41>
		}
	close(0);
  800bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  800c02:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  800c09:	00 00 00 
  800c0c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800c0e:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  800c15:	00 00 00 
  800c18:	ff d0                	callq  *%rax
  800c1a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c21:	79 30                	jns    800c53 <umain+0x100>
		panic("opencons: %e", r);
  800c23:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c26:	89 c1                	mov    %eax,%ecx
  800c28:	48 ba 09 61 80 00 00 	movabs $0x806109,%rdx
  800c2f:	00 00 00 
  800c32:	be 27 01 00 00       	mov    $0x127,%esi
  800c37:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800c3e:	00 00 00 
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
  800c46:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800c4d:	00 00 00 
  800c50:	41 ff d0             	callq  *%r8
	if (r != 0)
  800c53:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c57:	74 30                	je     800c89 <umain+0x136>
		panic("first opencons used fd %d", r);
  800c59:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c5c:	89 c1                	mov    %eax,%ecx
  800c5e:	48 ba 16 61 80 00 00 	movabs $0x806116,%rdx
  800c65:	00 00 00 
  800c68:	be 29 01 00 00       	mov    $0x129,%esi
  800c6d:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800c74:	00 00 00 
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800c83:	00 00 00 
  800c86:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800c89:	be 01 00 00 00       	mov    $0x1,%esi
  800c8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c93:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  800c9a:	00 00 00 
  800c9d:	ff d0                	callq  *%rax
  800c9f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800ca2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800ca6:	79 30                	jns    800cd8 <umain+0x185>
		panic("dup: %e", r);
  800ca8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800cab:	89 c1                	mov    %eax,%ecx
  800cad:	48 ba 30 61 80 00 00 	movabs $0x806130,%rdx
  800cb4:	00 00 00 
  800cb7:	be 2b 01 00 00       	mov    $0x12b,%esi
  800cbc:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800cc3:	00 00 00 
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccb:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800cd2:	00 00 00 
  800cd5:	41 ff d0             	callq  *%r8
	if (argc > 2)
  800cd8:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800cdb:	83 f8 02             	cmp    $0x2,%eax
  800cde:	7e 0c                	jle    800cec <umain+0x199>
		usage();
  800ce0:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  800ce7:	00 00 00 
  800cea:	ff d0                	callq  *%rax
	if (argc == 2) {
  800cec:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800cef:	83 f8 02             	cmp    $0x2,%eax
  800cf2:	0f 85 b3 00 00 00    	jne    800dab <umain+0x258>
		close(0);
  800cf8:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfd:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800d09:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d0d:	48 83 c0 08          	add    $0x8,%rax
  800d11:	48 8b 00             	mov    (%rax),%rax
  800d14:	be 00 00 00 00       	mov    $0x0,%esi
  800d19:	48 89 c7             	mov    %rax,%rdi
  800d1c:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
  800d28:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800d2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d2f:	79 3f                	jns    800d70 <umain+0x21d>
			panic("open %s: %e", argv[1], r);
  800d31:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d35:	48 83 c0 08          	add    $0x8,%rax
  800d39:	48 8b 00             	mov    (%rax),%rax
  800d3c:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800d3f:	41 89 d0             	mov    %edx,%r8d
  800d42:	48 89 c1             	mov    %rax,%rcx
  800d45:	48 ba 38 61 80 00 00 	movabs $0x806138,%rdx
  800d4c:	00 00 00 
  800d4f:	be 31 01 00 00       	mov    $0x131,%esi
  800d54:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800d5b:	00 00 00 
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d63:	49 b9 e9 12 80 00 00 	movabs $0x8012e9,%r9
  800d6a:	00 00 00 
  800d6d:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d74:	74 35                	je     800dab <umain+0x258>
  800d76:	48 b9 44 61 80 00 00 	movabs $0x806144,%rcx
  800d7d:	00 00 00 
  800d80:	48 ba 4b 61 80 00 00 	movabs $0x80614b,%rdx
  800d87:	00 00 00 
  800d8a:	be 32 01 00 00       	mov    $0x132,%esi
  800d8f:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800d96:	00 00 00 
  800d99:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9e:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800da5:	00 00 00 
  800da8:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800dab:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800daf:	75 14                	jne    800dc5 <umain+0x272>
		interactive = iscons(0);
  800db1:	bf 00 00 00 00       	mov    $0x0,%edi
  800db6:	48 b8 27 10 80 00 00 	movabs $0x801027,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	callq  *%rax
  800dc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	while (1) {
		char *buf;
		#ifndef VMM_GUEST
		buf = readline(interactive ? "$ " : NULL);
		#else
		buf = readline(interactive ? "vm$ " : NULL);
  800dc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc9:	74 0c                	je     800dd7 <umain+0x284>
  800dcb:	48 b8 60 61 80 00 00 	movabs $0x806160,%rax
  800dd2:	00 00 00 
  800dd5:	eb 05                	jmp    800ddc <umain+0x289>
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddc:	48 89 c7             	mov    %rax,%rdi
  800ddf:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		#endif
		if (buf == NULL) {
  800def:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800df4:	75 37                	jne    800e2d <umain+0x2da>
			if (debug)
  800df6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800dfd:	00 00 00 
  800e00:	8b 00                	mov    (%rax),%eax
  800e02:	85 c0                	test   %eax,%eax
  800e04:	74 1b                	je     800e21 <umain+0x2ce>
				cprintf("EXITING\n");
  800e06:	48 bf 65 61 80 00 00 	movabs $0x806165,%rdi
  800e0d:	00 00 00 
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
  800e15:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800e1c:	00 00 00 
  800e1f:	ff d2                	callq  *%rdx
			exit();	// end of file
  800e21:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800e28:	00 00 00 
  800e2b:	ff d0                	callq  *%rax
		}
		#ifndef VMM_GUEST
		if(strcmp(buf, "vmmanager")==0)
			auto_terminate = true;
		#endif
		if(strcmp(buf, "quit")==0)
  800e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e31:	48 be 6e 61 80 00 00 	movabs $0x80616e,%rsi
  800e38:	00 00 00 
  800e3b:	48 89 c7             	mov    %rax,%rdi
  800e3e:	48 b8 78 23 80 00 00 	movabs $0x802378,%rax
  800e45:	00 00 00 
  800e48:	ff d0                	callq  *%rax
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	75 0c                	jne    800e5a <umain+0x307>
			exit();
  800e4e:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	callq  *%rax
		if (debug)
  800e5a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e61:	00 00 00 
  800e64:	8b 00                	mov    (%rax),%eax
  800e66:	85 c0                	test   %eax,%eax
  800e68:	74 22                	je     800e8c <umain+0x339>
			cprintf("LINE: %s\n", buf);
  800e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6e:	48 89 c6             	mov    %rax,%rsi
  800e71:	48 bf 73 61 80 00 00 	movabs $0x806173,%rdi
  800e78:	00 00 00 
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e80:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800e87:	00 00 00 
  800e8a:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	0f b6 00             	movzbl (%rax),%eax
  800e93:	3c 23                	cmp    $0x23,%al
  800e95:	75 05                	jne    800e9c <umain+0x349>
			continue;
  800e97:	e9 12 01 00 00       	jmpq   800fae <umain+0x45b>
		if (echocmds)
  800e9c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ea0:	74 22                	je     800ec4 <umain+0x371>
			printf("# %s\n", buf);
  800ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea6:	48 89 c6             	mov    %rax,%rsi
  800ea9:	48 bf 7d 61 80 00 00 	movabs $0x80617d,%rdi
  800eb0:	00 00 00 
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb8:	48 ba d8 42 80 00 00 	movabs $0x8042d8,%rdx
  800ebf:	00 00 00 
  800ec2:	ff d2                	callq  *%rdx
		if (debug)
  800ec4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ecb:	00 00 00 
  800ece:	8b 00                	mov    (%rax),%eax
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	74 1b                	je     800eef <umain+0x39c>
			cprintf("BEFORE FORK\n");
  800ed4:	48 bf 83 61 80 00 00 	movabs $0x806183,%rdi
  800edb:	00 00 00 
  800ede:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee3:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800eea:	00 00 00 
  800eed:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800eef:	48 b8 2f 2f 80 00 00 	movabs $0x802f2f,%rax
  800ef6:	00 00 00 
  800ef9:	ff d0                	callq  *%rax
  800efb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f02:	79 30                	jns    800f34 <umain+0x3e1>
			panic("fork: %e", r);
  800f04:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f07:	89 c1                	mov    %eax,%ecx
  800f09:	48 ba f2 5f 80 00 00 	movabs $0x805ff2,%rdx
  800f10:	00 00 00 
  800f13:	be 52 01 00 00       	mov    $0x152,%esi
  800f18:	48 bf 17 60 80 00 00 	movabs $0x806017,%rdi
  800f1f:	00 00 00 
  800f22:	b8 00 00 00 00       	mov    $0x0,%eax
  800f27:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800f2e:	00 00 00 
  800f31:	41 ff d0             	callq  *%r8
		if (debug)
  800f34:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800f3b:	00 00 00 
  800f3e:	8b 00                	mov    (%rax),%eax
  800f40:	85 c0                	test   %eax,%eax
  800f42:	74 20                	je     800f64 <umain+0x411>
			cprintf("FORK: %d\n", r);
  800f44:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f47:	89 c6                	mov    %eax,%esi
  800f49:	48 bf 90 61 80 00 00 	movabs $0x806190,%rdi
  800f50:	00 00 00 
  800f53:	b8 00 00 00 00       	mov    $0x0,%eax
  800f58:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  800f5f:	00 00 00 
  800f62:	ff d2                	callq  *%rdx
		if (r == 0) {
  800f64:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f68:	75 21                	jne    800f8b <umain+0x438>
			runcmd(buf);
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	48 89 c7             	mov    %rax,%rdi
  800f71:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800f78:	00 00 00 
  800f7b:	ff d0                	callq  *%rax
			exit();
  800f7d:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800f84:	00 00 00 
  800f87:	ff d0                	callq  *%rax
  800f89:	eb 23                	jmp    800fae <umain+0x45b>
		} else {
			wait(r);
  800f8b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f8e:	89 c7                	mov    %eax,%edi
  800f90:	48 b8 c8 5b 80 00 00 	movabs $0x805bc8,%rax
  800f97:	00 00 00 
  800f9a:	ff d0                	callq  *%rax
			if (auto_terminate)
  800f9c:	80 7d f7 00          	cmpb   $0x0,-0x9(%rbp)
  800fa0:	74 0c                	je     800fae <umain+0x45b>
				exit();
  800fa2:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  800fa9:	00 00 00 
  800fac:	ff d0                	callq  *%rax
		}
	}
  800fae:	e9 12 fe ff ff       	jmpq   800dc5 <umain+0x272>

0000000000800fb3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800fb3:	55                   	push   %rbp
  800fb4:	48 89 e5             	mov    %rsp,%rbp
  800fb7:	48 83 ec 20          	sub    $0x20,%rsp
  800fbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800fbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fc1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800fc4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800fc8:	be 01 00 00 00       	mov    $0x1,%esi
  800fcd:	48 89 c7             	mov    %rax,%rdi
  800fd0:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  800fd7:	00 00 00 
  800fda:	ff d0                	callq  *%rax
}
  800fdc:	c9                   	leaveq 
  800fdd:	c3                   	retq   

0000000000800fde <getchar>:

int
getchar(void)
{
  800fde:	55                   	push   %rbp
  800fdf:	48 89 e5             	mov    %rsp,%rbp
  800fe2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800fe6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800fea:	ba 01 00 00 00       	mov    $0x1,%edx
  800fef:	48 89 c6             	mov    %rax,%rsi
  800ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff7:	48 b8 84 37 80 00 00 	movabs $0x803784,%rax
  800ffe:	00 00 00 
  801001:	ff d0                	callq  *%rax
  801003:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801006:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80100a:	79 05                	jns    801011 <getchar+0x33>
		return r;
  80100c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80100f:	eb 14                	jmp    801025 <getchar+0x47>
	if (r < 1)
  801011:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801015:	7f 07                	jg     80101e <getchar+0x40>
		return -E_EOF;
  801017:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80101c:	eb 07                	jmp    801025 <getchar+0x47>
	return c;
  80101e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801022:	0f b6 c0             	movzbl %al,%eax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 83 ec 20          	sub    $0x20,%rsp
  80102f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801032:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801036:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801039:	48 89 d6             	mov    %rdx,%rsi
  80103c:	89 c7                	mov    %eax,%edi
  80103e:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  801045:	00 00 00 
  801048:	ff d0                	callq  *%rax
  80104a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80104d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801051:	79 05                	jns    801058 <iscons+0x31>
		return r;
  801053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801056:	eb 1a                	jmp    801072 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105c:	8b 10                	mov    (%rax),%edx
  80105e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  801065:	00 00 00 
  801068:	8b 00                	mov    (%rax),%eax
  80106a:	39 c2                	cmp    %eax,%edx
  80106c:	0f 94 c0             	sete   %al
  80106f:	0f b6 c0             	movzbl %al,%eax
}
  801072:	c9                   	leaveq 
  801073:	c3                   	retq   

0000000000801074 <opencons>:

int
opencons(void)
{
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80107c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801080:	48 89 c7             	mov    %rax,%rdi
  801083:	48 b8 b8 32 80 00 00 	movabs $0x8032b8,%rax
  80108a:	00 00 00 
  80108d:	ff d0                	callq  *%rax
  80108f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801092:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801096:	79 05                	jns    80109d <opencons+0x29>
		return r;
  801098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80109b:	eb 5b                	jmp    8010f8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80109d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a1:	ba 07 04 00 00       	mov    $0x407,%edx
  8010a6:	48 89 c6             	mov    %rax,%rsi
  8010a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ae:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  8010b5:	00 00 00 
  8010b8:	ff d0                	callq  *%rax
  8010ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c1:	79 05                	jns    8010c8 <opencons+0x54>
		return r;
  8010c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c6:	eb 30                	jmp    8010f8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8010c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cc:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8010d3:	00 00 00 
  8010d6:	8b 12                	mov    (%rdx),%edx
  8010d8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8010da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010de:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8010e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e9:	48 89 c7             	mov    %rax,%rdi
  8010ec:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  8010f3:	00 00 00 
  8010f6:	ff d0                	callq  *%rax
}
  8010f8:	c9                   	leaveq 
  8010f9:	c3                   	retq   

00000000008010fa <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 30          	sub    $0x30,%rsp
  801102:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801106:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80110e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801113:	75 07                	jne    80111c <devcons_read+0x22>
		return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	eb 4b                	jmp    801167 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80111c:	eb 0c                	jmp    80112a <devcons_read+0x30>
		sys_yield();
  80111e:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  801125:	00 00 00 
  801128:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  80112a:	48 b8 49 2a 80 00 00 	movabs $0x802a49,%rax
  801131:	00 00 00 
  801134:	ff d0                	callq  *%rax
  801136:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801139:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80113d:	74 df                	je     80111e <devcons_read+0x24>
	if (c < 0)
  80113f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801143:	79 05                	jns    80114a <devcons_read+0x50>
		return c;
  801145:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801148:	eb 1d                	jmp    801167 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80114a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80114e:	75 07                	jne    801157 <devcons_read+0x5d>
		return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
  801155:	eb 10                	jmp    801167 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801160:	88 10                	mov    %dl,(%rax)
	return 1;
  801162:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801167:	c9                   	leaveq 
  801168:	c3                   	retq   

0000000000801169 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801174:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80117b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801182:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801189:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801190:	eb 76                	jmp    801208 <devcons_write+0x9f>
		m = n - tot;
  801192:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80119e:	29 c2                	sub    %eax,%edx
  8011a0:	89 d0                	mov    %edx,%eax
  8011a2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8011a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011a8:	83 f8 7f             	cmp    $0x7f,%eax
  8011ab:	76 07                	jbe    8011b4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8011ad:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8011b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011b7:	48 63 d0             	movslq %eax,%rdx
  8011ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011bd:	48 63 c8             	movslq %eax,%rcx
  8011c0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8011c7:	48 01 c1             	add    %rax,%rcx
  8011ca:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8011d1:	48 89 ce             	mov    %rcx,%rsi
  8011d4:	48 89 c7             	mov    %rax,%rdi
  8011d7:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  8011de:	00 00 00 
  8011e1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8011e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011e6:	48 63 d0             	movslq %eax,%rdx
  8011e9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8011f0:	48 89 d6             	mov    %rdx,%rsi
  8011f3:	48 89 c7             	mov    %rax,%rdi
  8011f6:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  8011fd:	00 00 00 
  801200:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  801202:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801205:	01 45 fc             	add    %eax,-0x4(%rbp)
  801208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120b:	48 98                	cltq   
  80120d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801214:	0f 82 78 ff ff ff    	jb     801192 <devcons_write+0x29>
	}
	return tot;
  80121a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 83 ec 08          	sub    $0x8,%rsp
  801227:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80122b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801230:	c9                   	leaveq 
  801231:	c3                   	retq   

0000000000801232 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801232:	55                   	push   %rbp
  801233:	48 89 e5             	mov    %rsp,%rbp
  801236:	48 83 ec 10          	sub    $0x10,%rsp
  80123a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801246:	48 be 9f 61 80 00 00 	movabs $0x80619f,%rsi
  80124d:	00 00 00 
  801250:	48 89 c7             	mov    %rax,%rdi
  801253:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80125a:	00 00 00 
  80125d:	ff d0                	callq  *%rax
	return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801264:	c9                   	leaveq 
  801265:	c3                   	retq   

0000000000801266 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801266:	55                   	push   %rbp
  801267:	48 89 e5             	mov    %rsp,%rbp
  80126a:	48 83 ec 10          	sub    $0x10,%rsp
  80126e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801271:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  801275:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  80127c:	00 00 00 
  80127f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801286:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80128a:	7e 14                	jle    8012a0 <libmain+0x3a>
		binaryname = argv[0];
  80128c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801290:	48 8b 10             	mov    (%rax),%rdx
  801293:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  80129a:	00 00 00 
  80129d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8012a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a7:	48 89 d6             	mov    %rdx,%rsi
  8012aa:	89 c7                	mov    %eax,%edi
  8012ac:	48 b8 53 0b 80 00 00 	movabs $0x800b53,%rax
  8012b3:	00 00 00 
  8012b6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8012b8:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  8012bf:	00 00 00 
  8012c2:	ff d0                	callq  *%rax
}
  8012c4:	c9                   	leaveq 
  8012c5:	c3                   	retq   

00000000008012c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8012c6:	55                   	push   %rbp
  8012c7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8012ca:	48 b8 ad 35 80 00 00 	movabs $0x8035ad,%rax
  8012d1:	00 00 00 
  8012d4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8012d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8012db:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  8012e2:	00 00 00 
  8012e5:	ff d0                	callq  *%rax
}
  8012e7:	5d                   	pop    %rbp
  8012e8:	c3                   	retq   

00000000008012e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	53                   	push   %rbx
  8012ee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8012f5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8012fc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801302:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801309:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801310:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801317:	84 c0                	test   %al,%al
  801319:	74 23                	je     80133e <_panic+0x55>
  80131b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801322:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801326:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80132a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80132e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801332:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801336:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80133a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80133e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801345:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80134c:	00 00 00 
  80134f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801356:	00 00 00 
  801359:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80135d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801364:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80136b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801372:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  801379:	00 00 00 
  80137c:	48 8b 18             	mov    (%rax),%rbx
  80137f:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  801386:	00 00 00 
  801389:	ff d0                	callq  *%rax
  80138b:	89 c6                	mov    %eax,%esi
  80138d:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  801393:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80139a:	41 89 d0             	mov    %edx,%r8d
  80139d:	48 89 c1             	mov    %rax,%rcx
  8013a0:	48 89 da             	mov    %rbx,%rdx
  8013a3:	48 bf b0 61 80 00 00 	movabs $0x8061b0,%rdi
  8013aa:	00 00 00 
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b2:	49 b9 22 15 80 00 00 	movabs $0x801522,%r9
  8013b9:	00 00 00 
  8013bc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8013bf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8013c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8013cd:	48 89 d6             	mov    %rdx,%rsi
  8013d0:	48 89 c7             	mov    %rax,%rdi
  8013d3:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  8013da:	00 00 00 
  8013dd:	ff d0                	callq  *%rax
	cprintf("\n");
  8013df:	48 bf d3 61 80 00 00 	movabs $0x8061d3,%rdi
  8013e6:	00 00 00 
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ee:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  8013f5:	00 00 00 
  8013f8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8013fa:	cc                   	int3   
  8013fb:	eb fd                	jmp    8013fa <_panic+0x111>

00000000008013fd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8013fd:	55                   	push   %rbp
  8013fe:	48 89 e5             	mov    %rsp,%rbp
  801401:	48 83 ec 10          	sub    $0x10,%rsp
  801405:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801408:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	8b 00                	mov    (%rax),%eax
  801412:	8d 48 01             	lea    0x1(%rax),%ecx
  801415:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801419:	89 0a                	mov    %ecx,(%rdx)
  80141b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80141e:	89 d1                	mov    %edx,%ecx
  801420:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801424:	48 98                	cltq   
  801426:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80142a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142e:	8b 00                	mov    (%rax),%eax
  801430:	3d ff 00 00 00       	cmp    $0xff,%eax
  801435:	75 2c                	jne    801463 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143b:	8b 00                	mov    (%rax),%eax
  80143d:	48 98                	cltq   
  80143f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801443:	48 83 c2 08          	add    $0x8,%rdx
  801447:	48 89 c6             	mov    %rax,%rsi
  80144a:	48 89 d7             	mov    %rdx,%rdi
  80144d:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  801454:	00 00 00 
  801457:	ff d0                	callq  *%rax
        b->idx = 0;
  801459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801467:	8b 40 04             	mov    0x4(%rax),%eax
  80146a:	8d 50 01             	lea    0x1(%rax),%edx
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	89 50 04             	mov    %edx,0x4(%rax)
}
  801474:	c9                   	leaveq 
  801475:	c3                   	retq   

0000000000801476 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801481:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801488:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80148f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801496:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80149d:	48 8b 0a             	mov    (%rdx),%rcx
  8014a0:	48 89 08             	mov    %rcx,(%rax)
  8014a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014af:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8014b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8014ba:	00 00 00 
    b.cnt = 0;
  8014bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8014c4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8014c7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8014ce:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8014d5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8014dc:	48 89 c6             	mov    %rax,%rsi
  8014df:	48 bf fd 13 80 00 00 	movabs $0x8013fd,%rdi
  8014e6:	00 00 00 
  8014e9:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  8014f0:	00 00 00 
  8014f3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8014f5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8014fb:	48 98                	cltq   
  8014fd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801504:	48 83 c2 08          	add    $0x8,%rdx
  801508:	48 89 c6             	mov    %rax,%rsi
  80150b:	48 89 d7             	mov    %rdx,%rdi
  80150e:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  801515:	00 00 00 
  801518:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80151a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801520:	c9                   	leaveq 
  801521:	c3                   	retq   

0000000000801522 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801522:	55                   	push   %rbp
  801523:	48 89 e5             	mov    %rsp,%rbp
  801526:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80152d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801534:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80153b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801542:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801549:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801550:	84 c0                	test   %al,%al
  801552:	74 20                	je     801574 <cprintf+0x52>
  801554:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801558:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80155c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801560:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801564:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801568:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80156c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801570:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801574:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80157b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801582:	00 00 00 
  801585:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80158c:	00 00 00 
  80158f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801593:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80159a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015a1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8015a8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8015af:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8015b6:	48 8b 0a             	mov    (%rdx),%rcx
  8015b9:	48 89 08             	mov    %rcx,(%rax)
  8015bc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8015c0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8015c4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8015c8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8015cc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8015d3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8015da:	48 89 d6             	mov    %rdx,%rsi
  8015dd:	48 89 c7             	mov    %rax,%rdi
  8015e0:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	callq  *%rax
  8015ec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8015f2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8015f8:	c9                   	leaveq 
  8015f9:	c3                   	retq   

00000000008015fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015fa:	55                   	push   %rbp
  8015fb:	48 89 e5             	mov    %rsp,%rbp
  8015fe:	48 83 ec 30          	sub    $0x30,%rsp
  801602:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801606:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80160a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80160e:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  801611:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  801615:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801619:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80161c:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  801620:	77 42                	ja     801664 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801622:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801625:	8d 78 ff             	lea    -0x1(%rax),%edi
  801628:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80162b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	48 f7 f6             	div    %rsi
  801637:	49 89 c2             	mov    %rax,%r10
  80163a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80163d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801640:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	41 89 c9             	mov    %ecx,%r9d
  80164b:	41 89 f8             	mov    %edi,%r8d
  80164e:	89 d1                	mov    %edx,%ecx
  801650:	4c 89 d2             	mov    %r10,%rdx
  801653:	48 89 c7             	mov    %rax,%rdi
  801656:	48 b8 fa 15 80 00 00 	movabs $0x8015fa,%rax
  80165d:	00 00 00 
  801660:	ff d0                	callq  *%rax
  801662:	eb 1e                	jmp    801682 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801664:	eb 12                	jmp    801678 <printnum+0x7e>
			putch(padc, putdat);
  801666:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80166a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80166d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801671:	48 89 ce             	mov    %rcx,%rsi
  801674:	89 d7                	mov    %edx,%edi
  801676:	ff d0                	callq  *%rax
		while (--width > 0)
  801678:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80167c:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  801680:	7f e4                	jg     801666 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801682:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801689:	ba 00 00 00 00       	mov    $0x0,%edx
  80168e:	48 f7 f1             	div    %rcx
  801691:	48 b8 f0 63 80 00 00 	movabs $0x8063f0,%rax
  801698:	00 00 00 
  80169b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80169f:	0f be d0             	movsbl %al,%edx
  8016a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016aa:	48 89 ce             	mov    %rcx,%rsi
  8016ad:	89 d7                	mov    %edx,%edi
  8016af:	ff d0                	callq  *%rax
}
  8016b1:	c9                   	leaveq 
  8016b2:	c3                   	retq   

00000000008016b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8016b3:	55                   	push   %rbp
  8016b4:	48 89 e5             	mov    %rsp,%rbp
  8016b7:	48 83 ec 20          	sub    $0x20,%rsp
  8016bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8016c2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8016c6:	7e 4f                	jle    801717 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8016c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cc:	8b 00                	mov    (%rax),%eax
  8016ce:	83 f8 30             	cmp    $0x30,%eax
  8016d1:	73 24                	jae    8016f7 <getuint+0x44>
  8016d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016df:	8b 00                	mov    (%rax),%eax
  8016e1:	89 c0                	mov    %eax,%eax
  8016e3:	48 01 d0             	add    %rdx,%rax
  8016e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ea:	8b 12                	mov    (%rdx),%edx
  8016ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f3:	89 0a                	mov    %ecx,(%rdx)
  8016f5:	eb 14                	jmp    80170b <getuint+0x58>
  8016f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016ff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801703:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801707:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80170b:	48 8b 00             	mov    (%rax),%rax
  80170e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801712:	e9 9d 00 00 00       	jmpq   8017b4 <getuint+0x101>
	else if (lflag)
  801717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80171b:	74 4c                	je     801769 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80171d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801721:	8b 00                	mov    (%rax),%eax
  801723:	83 f8 30             	cmp    $0x30,%eax
  801726:	73 24                	jae    80174c <getuint+0x99>
  801728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	8b 00                	mov    (%rax),%eax
  801736:	89 c0                	mov    %eax,%eax
  801738:	48 01 d0             	add    %rdx,%rax
  80173b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80173f:	8b 12                	mov    (%rdx),%edx
  801741:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801744:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801748:	89 0a                	mov    %ecx,(%rdx)
  80174a:	eb 14                	jmp    801760 <getuint+0xad>
  80174c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801750:	48 8b 40 08          	mov    0x8(%rax),%rax
  801754:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801758:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801760:	48 8b 00             	mov    (%rax),%rax
  801763:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801767:	eb 4b                	jmp    8017b4 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  801769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176d:	8b 00                	mov    (%rax),%eax
  80176f:	83 f8 30             	cmp    $0x30,%eax
  801772:	73 24                	jae    801798 <getuint+0xe5>
  801774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801778:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80177c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801780:	8b 00                	mov    (%rax),%eax
  801782:	89 c0                	mov    %eax,%eax
  801784:	48 01 d0             	add    %rdx,%rax
  801787:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80178b:	8b 12                	mov    (%rdx),%edx
  80178d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801794:	89 0a                	mov    %ecx,(%rdx)
  801796:	eb 14                	jmp    8017ac <getuint+0xf9>
  801798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8017a0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8017a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017ac:	8b 00                	mov    (%rax),%eax
  8017ae:	89 c0                	mov    %eax,%eax
  8017b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8017b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017b8:	c9                   	leaveq 
  8017b9:	c3                   	retq   

00000000008017ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017ba:	55                   	push   %rbp
  8017bb:	48 89 e5             	mov    %rsp,%rbp
  8017be:	48 83 ec 20          	sub    $0x20,%rsp
  8017c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8017c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8017cd:	7e 4f                	jle    80181e <getint+0x64>
		x=va_arg(*ap, long long);
  8017cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d3:	8b 00                	mov    (%rax),%eax
  8017d5:	83 f8 30             	cmp    $0x30,%eax
  8017d8:	73 24                	jae    8017fe <getint+0x44>
  8017da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e6:	8b 00                	mov    (%rax),%eax
  8017e8:	89 c0                	mov    %eax,%eax
  8017ea:	48 01 d0             	add    %rdx,%rax
  8017ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f1:	8b 12                	mov    (%rdx),%edx
  8017f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fa:	89 0a                	mov    %ecx,(%rdx)
  8017fc:	eb 14                	jmp    801812 <getint+0x58>
  8017fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801802:	48 8b 40 08          	mov    0x8(%rax),%rax
  801806:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80180a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801812:	48 8b 00             	mov    (%rax),%rax
  801815:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801819:	e9 9d 00 00 00       	jmpq   8018bb <getint+0x101>
	else if (lflag)
  80181e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801822:	74 4c                	je     801870 <getint+0xb6>
		x=va_arg(*ap, long);
  801824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801828:	8b 00                	mov    (%rax),%eax
  80182a:	83 f8 30             	cmp    $0x30,%eax
  80182d:	73 24                	jae    801853 <getint+0x99>
  80182f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801833:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183b:	8b 00                	mov    (%rax),%eax
  80183d:	89 c0                	mov    %eax,%eax
  80183f:	48 01 d0             	add    %rdx,%rax
  801842:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801846:	8b 12                	mov    (%rdx),%edx
  801848:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80184b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184f:	89 0a                	mov    %ecx,(%rdx)
  801851:	eb 14                	jmp    801867 <getint+0xad>
  801853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801857:	48 8b 40 08          	mov    0x8(%rax),%rax
  80185b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80185f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801863:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801867:	48 8b 00             	mov    (%rax),%rax
  80186a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80186e:	eb 4b                	jmp    8018bb <getint+0x101>
	else
		x=va_arg(*ap, int);
  801870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801874:	8b 00                	mov    (%rax),%eax
  801876:	83 f8 30             	cmp    $0x30,%eax
  801879:	73 24                	jae    80189f <getint+0xe5>
  80187b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801887:	8b 00                	mov    (%rax),%eax
  801889:	89 c0                	mov    %eax,%eax
  80188b:	48 01 d0             	add    %rdx,%rax
  80188e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801892:	8b 12                	mov    (%rdx),%edx
  801894:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801897:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80189b:	89 0a                	mov    %ecx,(%rdx)
  80189d:	eb 14                	jmp    8018b3 <getint+0xf9>
  80189f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018a7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8018ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8018b3:	8b 00                	mov    (%rax),%eax
  8018b5:	48 98                	cltq   
  8018b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8018bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018bf:	c9                   	leaveq 
  8018c0:	c3                   	retq   

00000000008018c1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018c1:	55                   	push   %rbp
  8018c2:	48 89 e5             	mov    %rsp,%rbp
  8018c5:	41 54                	push   %r12
  8018c7:	53                   	push   %rbx
  8018c8:	48 83 ec 60          	sub    $0x60,%rsp
  8018cc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8018d0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8018d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8018d8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8018dc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8018e0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8018e4:	48 8b 0a             	mov    (%rdx),%rcx
  8018e7:	48 89 08             	mov    %rcx,(%rax)
  8018ea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8018ee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8018f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8018f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018fa:	eb 17                	jmp    801913 <vprintfmt+0x52>
			if (ch == '\0')
  8018fc:	85 db                	test   %ebx,%ebx
  8018fe:	0f 84 c5 04 00 00    	je     801dc9 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  801904:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801908:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80190c:	48 89 d6             	mov    %rdx,%rsi
  80190f:	89 df                	mov    %ebx,%edi
  801911:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801913:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801917:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80191b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	0f b6 d8             	movzbl %al,%ebx
  801925:	83 fb 25             	cmp    $0x25,%ebx
  801928:	75 d2                	jne    8018fc <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  80192a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80192e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801935:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80193c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801943:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80194a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80194e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801952:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	0f b6 d8             	movzbl %al,%ebx
  80195c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80195f:	83 f8 55             	cmp    $0x55,%eax
  801962:	0f 87 2e 04 00 00    	ja     801d96 <vprintfmt+0x4d5>
  801968:	89 c0                	mov    %eax,%eax
  80196a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801971:	00 
  801972:	48 b8 18 64 80 00 00 	movabs $0x806418,%rax
  801979:	00 00 00 
  80197c:	48 01 d0             	add    %rdx,%rax
  80197f:	48 8b 00             	mov    (%rax),%rax
  801982:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801984:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801988:	eb c0                	jmp    80194a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80198a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80198e:	eb ba                	jmp    80194a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801990:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  801997:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80199a:	89 d0                	mov    %edx,%eax
  80199c:	c1 e0 02             	shl    $0x2,%eax
  80199f:	01 d0                	add    %edx,%eax
  8019a1:	01 c0                	add    %eax,%eax
  8019a3:	01 d8                	add    %ebx,%eax
  8019a5:	83 e8 30             	sub    $0x30,%eax
  8019a8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8019ab:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8019b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8019b8:	7e 0c                	jle    8019c6 <vprintfmt+0x105>
  8019ba:	83 fb 39             	cmp    $0x39,%ebx
  8019bd:	7f 07                	jg     8019c6 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  8019bf:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8019c4:	eb d1                	jmp    801997 <vprintfmt+0xd6>
			goto process_precision;
  8019c6:	eb 50                	jmp    801a18 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8019c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019cb:	83 f8 30             	cmp    $0x30,%eax
  8019ce:	73 17                	jae    8019e7 <vprintfmt+0x126>
  8019d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8019d4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019d7:	89 d2                	mov    %edx,%edx
  8019d9:	48 01 d0             	add    %rdx,%rax
  8019dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019df:	83 c2 08             	add    $0x8,%edx
  8019e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019e5:	eb 0c                	jmp    8019f3 <vprintfmt+0x132>
  8019e7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8019eb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8019ef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019f3:	8b 00                	mov    (%rax),%eax
  8019f5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8019f8:	eb 1e                	jmp    801a18 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8019fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8019fe:	79 07                	jns    801a07 <vprintfmt+0x146>
				width = 0;
  801a00:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801a07:	e9 3e ff ff ff       	jmpq   80194a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801a0c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801a13:	e9 32 ff ff ff       	jmpq   80194a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801a18:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a1c:	79 0d                	jns    801a2b <vprintfmt+0x16a>
				width = precision, precision = -1;
  801a1e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801a21:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801a24:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801a2b:	e9 1a ff ff ff       	jmpq   80194a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a30:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801a34:	e9 11 ff ff ff       	jmpq   80194a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801a39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a3c:	83 f8 30             	cmp    $0x30,%eax
  801a3f:	73 17                	jae    801a58 <vprintfmt+0x197>
  801a41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a48:	89 d2                	mov    %edx,%edx
  801a4a:	48 01 d0             	add    %rdx,%rax
  801a4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a50:	83 c2 08             	add    $0x8,%edx
  801a53:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a56:	eb 0c                	jmp    801a64 <vprintfmt+0x1a3>
  801a58:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801a5c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801a60:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a64:	8b 10                	mov    (%rax),%edx
  801a66:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801a6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a6e:	48 89 ce             	mov    %rcx,%rsi
  801a71:	89 d7                	mov    %edx,%edi
  801a73:	ff d0                	callq  *%rax
			break;
  801a75:	e9 4a 03 00 00       	jmpq   801dc4 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801a7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a7d:	83 f8 30             	cmp    $0x30,%eax
  801a80:	73 17                	jae    801a99 <vprintfmt+0x1d8>
  801a82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a86:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a89:	89 d2                	mov    %edx,%edx
  801a8b:	48 01 d0             	add    %rdx,%rax
  801a8e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a91:	83 c2 08             	add    $0x8,%edx
  801a94:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a97:	eb 0c                	jmp    801aa5 <vprintfmt+0x1e4>
  801a99:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801a9d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801aa1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801aa5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801aa7:	85 db                	test   %ebx,%ebx
  801aa9:	79 02                	jns    801aad <vprintfmt+0x1ec>
				err = -err;
  801aab:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801aad:	83 fb 15             	cmp    $0x15,%ebx
  801ab0:	7f 16                	jg     801ac8 <vprintfmt+0x207>
  801ab2:	48 b8 40 63 80 00 00 	movabs $0x806340,%rax
  801ab9:	00 00 00 
  801abc:	48 63 d3             	movslq %ebx,%rdx
  801abf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801ac3:	4d 85 e4             	test   %r12,%r12
  801ac6:	75 2e                	jne    801af6 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  801ac8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801acc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ad0:	89 d9                	mov    %ebx,%ecx
  801ad2:	48 ba 01 64 80 00 00 	movabs $0x806401,%rdx
  801ad9:	00 00 00 
  801adc:	48 89 c7             	mov    %rax,%rdi
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae4:	49 b8 d2 1d 80 00 00 	movabs $0x801dd2,%r8
  801aeb:	00 00 00 
  801aee:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801af1:	e9 ce 02 00 00       	jmpq   801dc4 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  801af6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801afa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801afe:	4c 89 e1             	mov    %r12,%rcx
  801b01:	48 ba 0a 64 80 00 00 	movabs $0x80640a,%rdx
  801b08:	00 00 00 
  801b0b:	48 89 c7             	mov    %rax,%rdi
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b13:	49 b8 d2 1d 80 00 00 	movabs $0x801dd2,%r8
  801b1a:	00 00 00 
  801b1d:	41 ff d0             	callq  *%r8
			break;
  801b20:	e9 9f 02 00 00       	jmpq   801dc4 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801b25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b28:	83 f8 30             	cmp    $0x30,%eax
  801b2b:	73 17                	jae    801b44 <vprintfmt+0x283>
  801b2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b34:	89 d2                	mov    %edx,%edx
  801b36:	48 01 d0             	add    %rdx,%rax
  801b39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b3c:	83 c2 08             	add    $0x8,%edx
  801b3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801b42:	eb 0c                	jmp    801b50 <vprintfmt+0x28f>
  801b44:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b48:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801b4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801b50:	4c 8b 20             	mov    (%rax),%r12
  801b53:	4d 85 e4             	test   %r12,%r12
  801b56:	75 0a                	jne    801b62 <vprintfmt+0x2a1>
				p = "(null)";
  801b58:	49 bc 0d 64 80 00 00 	movabs $0x80640d,%r12
  801b5f:	00 00 00 
			if (width > 0 && padc != '-')
  801b62:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b66:	7e 3f                	jle    801ba7 <vprintfmt+0x2e6>
  801b68:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801b6c:	74 39                	je     801ba7 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801b6e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801b71:	48 98                	cltq   
  801b73:	48 89 c6             	mov    %rax,%rsi
  801b76:	4c 89 e7             	mov    %r12,%rdi
  801b79:	48 b8 d8 21 80 00 00 	movabs $0x8021d8,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	callq  *%rax
  801b85:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801b88:	eb 17                	jmp    801ba1 <vprintfmt+0x2e0>
					putch(padc, putdat);
  801b8a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801b8e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801b92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b96:	48 89 ce             	mov    %rcx,%rsi
  801b99:	89 d7                	mov    %edx,%edi
  801b9b:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  801b9d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801ba1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801ba5:	7f e3                	jg     801b8a <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ba7:	eb 37                	jmp    801be0 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  801ba9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801bad:	74 1e                	je     801bcd <vprintfmt+0x30c>
  801baf:	83 fb 1f             	cmp    $0x1f,%ebx
  801bb2:	7e 05                	jle    801bb9 <vprintfmt+0x2f8>
  801bb4:	83 fb 7e             	cmp    $0x7e,%ebx
  801bb7:	7e 14                	jle    801bcd <vprintfmt+0x30c>
					putch('?', putdat);
  801bb9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bbd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bc1:	48 89 d6             	mov    %rdx,%rsi
  801bc4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801bc9:	ff d0                	callq  *%rax
  801bcb:	eb 0f                	jmp    801bdc <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  801bcd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bd5:	48 89 d6             	mov    %rdx,%rsi
  801bd8:	89 df                	mov    %ebx,%edi
  801bda:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bdc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801be0:	4c 89 e0             	mov    %r12,%rax
  801be3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801be7:	0f b6 00             	movzbl (%rax),%eax
  801bea:	0f be d8             	movsbl %al,%ebx
  801bed:	85 db                	test   %ebx,%ebx
  801bef:	74 10                	je     801c01 <vprintfmt+0x340>
  801bf1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bf5:	78 b2                	js     801ba9 <vprintfmt+0x2e8>
  801bf7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801bfb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bff:	79 a8                	jns    801ba9 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  801c01:	eb 16                	jmp    801c19 <vprintfmt+0x358>
				putch(' ', putdat);
  801c03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c0b:	48 89 d6             	mov    %rdx,%rsi
  801c0e:	bf 20 00 00 00       	mov    $0x20,%edi
  801c13:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  801c15:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c1d:	7f e4                	jg     801c03 <vprintfmt+0x342>
			break;
  801c1f:	e9 a0 01 00 00       	jmpq   801dc4 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801c24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c28:	be 03 00 00 00       	mov    $0x3,%esi
  801c2d:	48 89 c7             	mov    %rax,%rdi
  801c30:	48 b8 ba 17 80 00 00 	movabs $0x8017ba,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
  801c3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c44:	48 85 c0             	test   %rax,%rax
  801c47:	79 1d                	jns    801c66 <vprintfmt+0x3a5>
				putch('-', putdat);
  801c49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c51:	48 89 d6             	mov    %rdx,%rsi
  801c54:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801c59:	ff d0                	callq  *%rax
				num = -(long long) num;
  801c5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5f:	48 f7 d8             	neg    %rax
  801c62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801c66:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801c6d:	e9 e5 00 00 00       	jmpq   801d57 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801c72:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c76:	be 03 00 00 00       	mov    $0x3,%esi
  801c7b:	48 89 c7             	mov    %rax,%rdi
  801c7e:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
  801c8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801c8e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801c95:	e9 bd 00 00 00       	jmpq   801d57 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801c9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ca2:	48 89 d6             	mov    %rdx,%rsi
  801ca5:	bf 58 00 00 00       	mov    $0x58,%edi
  801caa:	ff d0                	callq  *%rax
			putch('X', putdat);
  801cac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cb4:	48 89 d6             	mov    %rdx,%rsi
  801cb7:	bf 58 00 00 00       	mov    $0x58,%edi
  801cbc:	ff d0                	callq  *%rax
			putch('X', putdat);
  801cbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cc6:	48 89 d6             	mov    %rdx,%rsi
  801cc9:	bf 58 00 00 00       	mov    $0x58,%edi
  801cce:	ff d0                	callq  *%rax
			break;
  801cd0:	e9 ef 00 00 00       	jmpq   801dc4 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  801cd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cdd:	48 89 d6             	mov    %rdx,%rsi
  801ce0:	bf 30 00 00 00       	mov    $0x30,%edi
  801ce5:	ff d0                	callq  *%rax
			putch('x', putdat);
  801ce7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801ceb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cef:	48 89 d6             	mov    %rdx,%rsi
  801cf2:	bf 78 00 00 00       	mov    $0x78,%edi
  801cf7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801cf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801cfc:	83 f8 30             	cmp    $0x30,%eax
  801cff:	73 17                	jae    801d18 <vprintfmt+0x457>
  801d01:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d05:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d08:	89 d2                	mov    %edx,%edx
  801d0a:	48 01 d0             	add    %rdx,%rax
  801d0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d10:	83 c2 08             	add    $0x8,%edx
  801d13:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  801d16:	eb 0c                	jmp    801d24 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  801d18:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801d1c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801d20:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801d24:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  801d27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801d2b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801d32:	eb 23                	jmp    801d57 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801d34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d38:	be 03 00 00 00       	mov    $0x3,%esi
  801d3d:	48 89 c7             	mov    %rax,%rdi
  801d40:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
  801d4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801d50:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d57:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801d5c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801d5f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801d62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d66:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801d6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d6e:	45 89 c1             	mov    %r8d,%r9d
  801d71:	41 89 f8             	mov    %edi,%r8d
  801d74:	48 89 c7             	mov    %rax,%rdi
  801d77:	48 b8 fa 15 80 00 00 	movabs $0x8015fa,%rax
  801d7e:	00 00 00 
  801d81:	ff d0                	callq  *%rax
			break;
  801d83:	eb 3f                	jmp    801dc4 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d8d:	48 89 d6             	mov    %rdx,%rsi
  801d90:	89 df                	mov    %ebx,%edi
  801d92:	ff d0                	callq  *%rax
			break;
  801d94:	eb 2e                	jmp    801dc4 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d9e:	48 89 d6             	mov    %rdx,%rsi
  801da1:	bf 25 00 00 00       	mov    $0x25,%edi
  801da6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801da8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801dad:	eb 05                	jmp    801db4 <vprintfmt+0x4f3>
  801daf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801db4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801db8:	48 83 e8 01          	sub    $0x1,%rax
  801dbc:	0f b6 00             	movzbl (%rax),%eax
  801dbf:	3c 25                	cmp    $0x25,%al
  801dc1:	75 ec                	jne    801daf <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801dc3:	90                   	nop
		}
	}
  801dc4:	e9 31 fb ff ff       	jmpq   8018fa <vprintfmt+0x39>
	va_end(aq);
}
  801dc9:	48 83 c4 60          	add    $0x60,%rsp
  801dcd:	5b                   	pop    %rbx
  801dce:	41 5c                	pop    %r12
  801dd0:	5d                   	pop    %rbp
  801dd1:	c3                   	retq   

0000000000801dd2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801dd2:	55                   	push   %rbp
  801dd3:	48 89 e5             	mov    %rsp,%rbp
  801dd6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801ddd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801de4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801deb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801df2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801df9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e00:	84 c0                	test   %al,%al
  801e02:	74 20                	je     801e24 <printfmt+0x52>
  801e04:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e08:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e0c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e10:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e14:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e18:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e1c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e20:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801e24:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e2b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801e32:	00 00 00 
  801e35:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801e3c:	00 00 00 
  801e3f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801e4a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801e51:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801e58:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801e5f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801e66:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801e6d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801e74:	48 89 c7             	mov    %rax,%rdi
  801e77:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	callq  *%rax
	va_end(ap);
}
  801e83:	c9                   	leaveq 
  801e84:	c3                   	retq   

0000000000801e85 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e85:	55                   	push   %rbp
  801e86:	48 89 e5             	mov    %rsp,%rbp
  801e89:	48 83 ec 10          	sub    $0x10,%rsp
  801e8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e98:	8b 40 10             	mov    0x10(%rax),%eax
  801e9b:	8d 50 01             	lea    0x1(%rax),%edx
  801e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea9:	48 8b 10             	mov    (%rax),%rdx
  801eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eb4:	48 39 c2             	cmp    %rax,%rdx
  801eb7:	73 17                	jae    801ed0 <sprintputch+0x4b>
		*b->buf++ = ch;
  801eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ebd:	48 8b 00             	mov    (%rax),%rax
  801ec0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801ec4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec8:	48 89 0a             	mov    %rcx,(%rdx)
  801ecb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ece:	88 10                	mov    %dl,(%rax)
}
  801ed0:	c9                   	leaveq 
  801ed1:	c3                   	retq   

0000000000801ed2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	48 83 ec 50          	sub    $0x50,%rsp
  801eda:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801ede:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801ee1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801ee5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801ee9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801eed:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801ef1:	48 8b 0a             	mov    (%rdx),%rcx
  801ef4:	48 89 08             	mov    %rcx,(%rax)
  801ef7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801efb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801eff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f03:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f07:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f0b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801f0f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801f12:	48 98                	cltq   
  801f14:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f1c:	48 01 d0             	add    %rdx,%rax
  801f1f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801f23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801f2a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801f2f:	74 06                	je     801f37 <vsnprintf+0x65>
  801f31:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801f35:	7f 07                	jg     801f3e <vsnprintf+0x6c>
		return -E_INVAL;
  801f37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f3c:	eb 2f                	jmp    801f6d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801f3e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801f42:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801f46:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f4a:	48 89 c6             	mov    %rax,%rsi
  801f4d:	48 bf 85 1e 80 00 00 	movabs $0x801e85,%rdi
  801f54:	00 00 00 
  801f57:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801f63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f67:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801f6a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801f6d:	c9                   	leaveq 
  801f6e:	c3                   	retq   

0000000000801f6f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f6f:	55                   	push   %rbp
  801f70:	48 89 e5             	mov    %rsp,%rbp
  801f73:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801f7a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801f81:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801f87:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801f8e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801f95:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801f9c:	84 c0                	test   %al,%al
  801f9e:	74 20                	je     801fc0 <snprintf+0x51>
  801fa0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801fa4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801fa8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801fac:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801fb0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801fb4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801fb8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801fbc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801fc0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801fc7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801fce:	00 00 00 
  801fd1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801fd8:	00 00 00 
  801fdb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801fdf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801fe6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801fed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801ff4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801ffb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802002:	48 8b 0a             	mov    (%rdx),%rcx
  802005:	48 89 08             	mov    %rcx,(%rax)
  802008:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80200c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802010:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802014:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802018:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80201f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802026:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80202c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802033:	48 89 c7             	mov    %rax,%rdi
  802036:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
  802042:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802048:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80204e:	c9                   	leaveq 
  80204f:	c3                   	retq   

0000000000802050 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  802050:	55                   	push   %rbp
  802051:	48 89 e5             	mov    %rsp,%rbp
  802054:	48 83 ec 20          	sub    $0x20,%rsp
  802058:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80205c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802061:	74 27                	je     80208a <readline+0x3a>
		fprintf(1, "%s", prompt);
  802063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802067:	48 89 c2             	mov    %rax,%rdx
  80206a:	48 be c8 66 80 00 00 	movabs $0x8066c8,%rsi
  802071:	00 00 00 
  802074:	bf 01 00 00 00       	mov    $0x1,%edi
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	48 b9 20 42 80 00 00 	movabs $0x804220,%rcx
  802085:	00 00 00 
  802088:	ff d1                	callq  *%rcx
#endif

	i = 0;
  80208a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  802091:	bf 00 00 00 00       	mov    $0x0,%edi
  802096:	48 b8 27 10 80 00 00 	movabs $0x801027,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
  8020a2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8020a5:	48 b8 de 0f 80 00 00 	movabs $0x800fde,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
  8020b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8020b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020b8:	79 30                	jns    8020ea <readline+0x9a>
			if (c != -E_EOF)
  8020ba:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  8020be:	74 20                	je     8020e0 <readline+0x90>
				cprintf("read error: %e\n", c);
  8020c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c3:	89 c6                	mov    %eax,%esi
  8020c5:	48 bf cb 66 80 00 00 	movabs $0x8066cb,%rdi
  8020cc:	00 00 00 
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d4:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  8020db:	00 00 00 
  8020de:	ff d2                	callq  *%rdx
			return NULL;
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e5:	e9 be 00 00 00       	jmpq   8021a8 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8020ea:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  8020ee:	74 06                	je     8020f6 <readline+0xa6>
  8020f0:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8020f4:	75 26                	jne    80211c <readline+0xcc>
  8020f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fa:	7e 20                	jle    80211c <readline+0xcc>
			if (echoing)
  8020fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802100:	74 11                	je     802113 <readline+0xc3>
				cputchar('\b');
  802102:	bf 08 00 00 00       	mov    $0x8,%edi
  802107:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  80210e:	00 00 00 
  802111:	ff d0                	callq  *%rax
			i--;
  802113:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802117:	e9 87 00 00 00       	jmpq   8021a3 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80211c:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802120:	7e 3f                	jle    802161 <readline+0x111>
  802122:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  802129:	7f 36                	jg     802161 <readline+0x111>
			if (echoing)
  80212b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80212f:	74 11                	je     802142 <readline+0xf2>
				cputchar(c);
  802131:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802134:	89 c7                	mov    %eax,%edi
  802136:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax
			buf[i++] = c;
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802145:	8d 50 01             	lea    0x1(%rax),%edx
  802148:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80214b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80214e:	89 d1                	mov    %edx,%ecx
  802150:	48 ba 40 90 80 00 00 	movabs $0x809040,%rdx
  802157:	00 00 00 
  80215a:	48 98                	cltq   
  80215c:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  80215f:	eb 42                	jmp    8021a3 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  802161:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  802165:	74 06                	je     80216d <readline+0x11d>
  802167:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80216b:	75 36                	jne    8021a3 <readline+0x153>
			if (echoing)
  80216d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802171:	74 11                	je     802184 <readline+0x134>
				cputchar('\n');
  802173:	bf 0a 00 00 00       	mov    $0xa,%edi
  802178:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  80217f:	00 00 00 
  802182:	ff d0                	callq  *%rax
			buf[i] = 0;
  802184:	48 ba 40 90 80 00 00 	movabs $0x809040,%rdx
  80218b:	00 00 00 
  80218e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802191:	48 98                	cltq   
  802193:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  802197:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  80219e:	00 00 00 
  8021a1:	eb 05                	jmp    8021a8 <readline+0x158>
		}
	}
  8021a3:	e9 fd fe ff ff       	jmpq   8020a5 <readline+0x55>
}
  8021a8:	c9                   	leaveq 
  8021a9:	c3                   	retq   

00000000008021aa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8021aa:	55                   	push   %rbp
  8021ab:	48 89 e5             	mov    %rsp,%rbp
  8021ae:	48 83 ec 18          	sub    $0x18,%rsp
  8021b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8021b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021bd:	eb 09                	jmp    8021c8 <strlen+0x1e>
		n++;
  8021bf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8021c3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8021c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cc:	0f b6 00             	movzbl (%rax),%eax
  8021cf:	84 c0                	test   %al,%al
  8021d1:	75 ec                	jne    8021bf <strlen+0x15>
	return n;
  8021d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021d6:	c9                   	leaveq 
  8021d7:	c3                   	retq   

00000000008021d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8021d8:	55                   	push   %rbp
  8021d9:	48 89 e5             	mov    %rsp,%rbp
  8021dc:	48 83 ec 20          	sub    $0x20,%rsp
  8021e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8021e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021ef:	eb 0e                	jmp    8021ff <strnlen+0x27>
		n++;
  8021f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8021f5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8021fa:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8021ff:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802204:	74 0b                	je     802211 <strnlen+0x39>
  802206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220a:	0f b6 00             	movzbl (%rax),%eax
  80220d:	84 c0                	test   %al,%al
  80220f:	75 e0                	jne    8021f1 <strnlen+0x19>
	return n;
  802211:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802214:	c9                   	leaveq 
  802215:	c3                   	retq   

0000000000802216 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	48 83 ec 20          	sub    $0x20,%rsp
  80221e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802222:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80222e:	90                   	nop
  80222f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802233:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802237:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80223b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80223f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802243:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802247:	0f b6 12             	movzbl (%rdx),%edx
  80224a:	88 10                	mov    %dl,(%rax)
  80224c:	0f b6 00             	movzbl (%rax),%eax
  80224f:	84 c0                	test   %al,%al
  802251:	75 dc                	jne    80222f <strcpy+0x19>
		/* do nothing */;
	return ret;
  802253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802257:	c9                   	leaveq 
  802258:	c3                   	retq   

0000000000802259 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802259:	55                   	push   %rbp
  80225a:	48 89 e5             	mov    %rsp,%rbp
  80225d:	48 83 ec 20          	sub    $0x20,%rsp
  802261:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802265:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226d:	48 89 c7             	mov    %rax,%rdi
  802270:	48 b8 aa 21 80 00 00 	movabs $0x8021aa,%rax
  802277:	00 00 00 
  80227a:	ff d0                	callq  *%rax
  80227c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802282:	48 63 d0             	movslq %eax,%rdx
  802285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802289:	48 01 c2             	add    %rax,%rdx
  80228c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802290:	48 89 c6             	mov    %rax,%rsi
  802293:	48 89 d7             	mov    %rdx,%rdi
  802296:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
	return dst;
  8022a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022a6:	c9                   	leaveq 
  8022a7:	c3                   	retq   

00000000008022a8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8022a8:	55                   	push   %rbp
  8022a9:	48 89 e5             	mov    %rsp,%rbp
  8022ac:	48 83 ec 28          	sub    $0x28,%rsp
  8022b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8022bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8022c4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8022cb:	00 
  8022cc:	eb 2a                	jmp    8022f8 <strncpy+0x50>
		*dst++ = *src;
  8022ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8022d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8022da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022de:	0f b6 12             	movzbl (%rdx),%edx
  8022e1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8022e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022e7:	0f b6 00             	movzbl (%rax),%eax
  8022ea:	84 c0                	test   %al,%al
  8022ec:	74 05                	je     8022f3 <strncpy+0x4b>
			src++;
  8022ee:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8022f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802300:	72 cc                	jb     8022ce <strncpy+0x26>
	}
	return ret;
  802302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802306:	c9                   	leaveq 
  802307:	c3                   	retq   

0000000000802308 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802308:	55                   	push   %rbp
  802309:	48 89 e5             	mov    %rsp,%rbp
  80230c:	48 83 ec 28          	sub    $0x28,%rsp
  802310:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802314:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802318:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80231c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802320:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802324:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802329:	74 3d                	je     802368 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80232b:	eb 1d                	jmp    80234a <strlcpy+0x42>
			*dst++ = *src++;
  80232d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802331:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802335:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802339:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80233d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802341:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802345:	0f b6 12             	movzbl (%rdx),%edx
  802348:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80234a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80234f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802354:	74 0b                	je     802361 <strlcpy+0x59>
  802356:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80235a:	0f b6 00             	movzbl (%rax),%eax
  80235d:	84 c0                	test   %al,%al
  80235f:	75 cc                	jne    80232d <strlcpy+0x25>
		*dst = '\0';
  802361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802365:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802368:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80236c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802370:	48 29 c2             	sub    %rax,%rdx
  802373:	48 89 d0             	mov    %rdx,%rax
}
  802376:	c9                   	leaveq 
  802377:	c3                   	retq   

0000000000802378 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802378:	55                   	push   %rbp
  802379:	48 89 e5             	mov    %rsp,%rbp
  80237c:	48 83 ec 10          	sub    $0x10,%rsp
  802380:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802384:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802388:	eb 0a                	jmp    802394 <strcmp+0x1c>
		p++, q++;
  80238a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80238f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  802394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802398:	0f b6 00             	movzbl (%rax),%eax
  80239b:	84 c0                	test   %al,%al
  80239d:	74 12                	je     8023b1 <strcmp+0x39>
  80239f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a3:	0f b6 10             	movzbl (%rax),%edx
  8023a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023aa:	0f b6 00             	movzbl (%rax),%eax
  8023ad:	38 c2                	cmp    %al,%dl
  8023af:	74 d9                	je     80238a <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b5:	0f b6 00             	movzbl (%rax),%eax
  8023b8:	0f b6 d0             	movzbl %al,%edx
  8023bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023bf:	0f b6 00             	movzbl (%rax),%eax
  8023c2:	0f b6 c0             	movzbl %al,%eax
  8023c5:	29 c2                	sub    %eax,%edx
  8023c7:	89 d0                	mov    %edx,%eax
}
  8023c9:	c9                   	leaveq 
  8023ca:	c3                   	retq   

00000000008023cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8023cb:	55                   	push   %rbp
  8023cc:	48 89 e5             	mov    %rsp,%rbp
  8023cf:	48 83 ec 18          	sub    $0x18,%rsp
  8023d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8023df:	eb 0f                	jmp    8023f0 <strncmp+0x25>
		n--, p++, q++;
  8023e1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8023e6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023eb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8023f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023f5:	74 1d                	je     802414 <strncmp+0x49>
  8023f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fb:	0f b6 00             	movzbl (%rax),%eax
  8023fe:	84 c0                	test   %al,%al
  802400:	74 12                	je     802414 <strncmp+0x49>
  802402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802406:	0f b6 10             	movzbl (%rax),%edx
  802409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240d:	0f b6 00             	movzbl (%rax),%eax
  802410:	38 c2                	cmp    %al,%dl
  802412:	74 cd                	je     8023e1 <strncmp+0x16>
	if (n == 0)
  802414:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802419:	75 07                	jne    802422 <strncmp+0x57>
		return 0;
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	eb 18                	jmp    80243a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802426:	0f b6 00             	movzbl (%rax),%eax
  802429:	0f b6 d0             	movzbl %al,%edx
  80242c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802430:	0f b6 00             	movzbl (%rax),%eax
  802433:	0f b6 c0             	movzbl %al,%eax
  802436:	29 c2                	sub    %eax,%edx
  802438:	89 d0                	mov    %edx,%eax
}
  80243a:	c9                   	leaveq 
  80243b:	c3                   	retq   

000000000080243c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80243c:	55                   	push   %rbp
  80243d:	48 89 e5             	mov    %rsp,%rbp
  802440:	48 83 ec 10          	sub    $0x10,%rsp
  802444:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802448:	89 f0                	mov    %esi,%eax
  80244a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80244d:	eb 17                	jmp    802466 <strchr+0x2a>
		if (*s == c)
  80244f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802453:	0f b6 00             	movzbl (%rax),%eax
  802456:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802459:	75 06                	jne    802461 <strchr+0x25>
			return (char *) s;
  80245b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245f:	eb 15                	jmp    802476 <strchr+0x3a>
	for (; *s; s++)
  802461:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246a:	0f b6 00             	movzbl (%rax),%eax
  80246d:	84 c0                	test   %al,%al
  80246f:	75 de                	jne    80244f <strchr+0x13>
	return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leaveq 
  802477:	c3                   	retq   

0000000000802478 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802478:	55                   	push   %rbp
  802479:	48 89 e5             	mov    %rsp,%rbp
  80247c:	48 83 ec 10          	sub    $0x10,%rsp
  802480:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802484:	89 f0                	mov    %esi,%eax
  802486:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802489:	eb 13                	jmp    80249e <strfind+0x26>
		if (*s == c)
  80248b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248f:	0f b6 00             	movzbl (%rax),%eax
  802492:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802495:	75 02                	jne    802499 <strfind+0x21>
			break;
  802497:	eb 10                	jmp    8024a9 <strfind+0x31>
	for (; *s; s++)
  802499:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80249e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a2:	0f b6 00             	movzbl (%rax),%eax
  8024a5:	84 c0                	test   %al,%al
  8024a7:	75 e2                	jne    80248b <strfind+0x13>
	return (char *) s;
  8024a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024ad:	c9                   	leaveq 
  8024ae:	c3                   	retq   

00000000008024af <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8024af:	55                   	push   %rbp
  8024b0:	48 89 e5             	mov    %rsp,%rbp
  8024b3:	48 83 ec 18          	sub    $0x18,%rsp
  8024b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024bb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8024be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8024c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8024c7:	75 06                	jne    8024cf <memset+0x20>
		return v;
  8024c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024cd:	eb 69                	jmp    802538 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8024cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d3:	83 e0 03             	and    $0x3,%eax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	75 48                	jne    802523 <memset+0x74>
  8024db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024df:	83 e0 03             	and    $0x3,%eax
  8024e2:	48 85 c0             	test   %rax,%rax
  8024e5:	75 3c                	jne    802523 <memset+0x74>
		c &= 0xFF;
  8024e7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8024ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024f1:	c1 e0 18             	shl    $0x18,%eax
  8024f4:	89 c2                	mov    %eax,%edx
  8024f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024f9:	c1 e0 10             	shl    $0x10,%eax
  8024fc:	09 c2                	or     %eax,%edx
  8024fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802501:	c1 e0 08             	shl    $0x8,%eax
  802504:	09 d0                	or     %edx,%eax
  802506:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250d:	48 c1 e8 02          	shr    $0x2,%rax
  802511:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  802514:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802518:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80251b:	48 89 d7             	mov    %rdx,%rdi
  80251e:	fc                   	cld    
  80251f:	f3 ab                	rep stos %eax,%es:(%rdi)
  802521:	eb 11                	jmp    802534 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802523:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802527:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80252a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80252e:	48 89 d7             	mov    %rdx,%rdi
  802531:	fc                   	cld    
  802532:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802538:	c9                   	leaveq 
  802539:	c3                   	retq   

000000000080253a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	48 83 ec 28          	sub    $0x28,%rsp
  802542:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802546:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80254a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80254e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80255e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802562:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802566:	0f 83 88 00 00 00    	jae    8025f4 <memmove+0xba>
  80256c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802574:	48 01 d0             	add    %rdx,%rax
  802577:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80257b:	76 77                	jbe    8025f4 <memmove+0xba>
		s += n;
  80257d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802581:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802589:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80258d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802591:	83 e0 03             	and    $0x3,%eax
  802594:	48 85 c0             	test   %rax,%rax
  802597:	75 3b                	jne    8025d4 <memmove+0x9a>
  802599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259d:	83 e0 03             	and    $0x3,%eax
  8025a0:	48 85 c0             	test   %rax,%rax
  8025a3:	75 2f                	jne    8025d4 <memmove+0x9a>
  8025a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a9:	83 e0 03             	and    $0x3,%eax
  8025ac:	48 85 c0             	test   %rax,%rax
  8025af:	75 23                	jne    8025d4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8025b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b5:	48 83 e8 04          	sub    $0x4,%rax
  8025b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025bd:	48 83 ea 04          	sub    $0x4,%rdx
  8025c1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8025c5:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8025c9:	48 89 c7             	mov    %rax,%rdi
  8025cc:	48 89 d6             	mov    %rdx,%rsi
  8025cf:	fd                   	std    
  8025d0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8025d2:	eb 1d                	jmp    8025f1 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8025d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8025dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8025e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e8:	48 89 d7             	mov    %rdx,%rdi
  8025eb:	48 89 c1             	mov    %rax,%rcx
  8025ee:	fd                   	std    
  8025ef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8025f1:	fc                   	cld    
  8025f2:	eb 57                	jmp    80264b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8025f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025f8:	83 e0 03             	and    $0x3,%eax
  8025fb:	48 85 c0             	test   %rax,%rax
  8025fe:	75 36                	jne    802636 <memmove+0xfc>
  802600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802604:	83 e0 03             	and    $0x3,%eax
  802607:	48 85 c0             	test   %rax,%rax
  80260a:	75 2a                	jne    802636 <memmove+0xfc>
  80260c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802610:	83 e0 03             	and    $0x3,%eax
  802613:	48 85 c0             	test   %rax,%rax
  802616:	75 1e                	jne    802636 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261c:	48 c1 e8 02          	shr    $0x2,%rax
  802620:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  802623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802627:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80262b:	48 89 c7             	mov    %rax,%rdi
  80262e:	48 89 d6             	mov    %rdx,%rsi
  802631:	fc                   	cld    
  802632:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802634:	eb 15                	jmp    80264b <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  802636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80263e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802642:	48 89 c7             	mov    %rax,%rdi
  802645:	48 89 d6             	mov    %rdx,%rsi
  802648:	fc                   	cld    
  802649:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80264b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80264f:	c9                   	leaveq 
  802650:	c3                   	retq   

0000000000802651 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802651:	55                   	push   %rbp
  802652:	48 89 e5             	mov    %rsp,%rbp
  802655:	48 83 ec 18          	sub    $0x18,%rsp
  802659:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80265d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802661:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802669:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80266d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802671:	48 89 ce             	mov    %rcx,%rsi
  802674:	48 89 c7             	mov    %rax,%rdi
  802677:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  80267e:	00 00 00 
  802681:	ff d0                	callq  *%rax
}
  802683:	c9                   	leaveq 
  802684:	c3                   	retq   

0000000000802685 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802685:	55                   	push   %rbp
  802686:	48 89 e5             	mov    %rsp,%rbp
  802689:	48 83 ec 28          	sub    $0x28,%rsp
  80268d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802691:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802695:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8026a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8026a9:	eb 36                	jmp    8026e1 <memcmp+0x5c>
		if (*s1 != *s2)
  8026ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026af:	0f b6 10             	movzbl (%rax),%edx
  8026b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b6:	0f b6 00             	movzbl (%rax),%eax
  8026b9:	38 c2                	cmp    %al,%dl
  8026bb:	74 1a                	je     8026d7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8026bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026c1:	0f b6 00             	movzbl (%rax),%eax
  8026c4:	0f b6 d0             	movzbl %al,%edx
  8026c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cb:	0f b6 00             	movzbl (%rax),%eax
  8026ce:	0f b6 c0             	movzbl %al,%eax
  8026d1:	29 c2                	sub    %eax,%edx
  8026d3:	89 d0                	mov    %edx,%eax
  8026d5:	eb 20                	jmp    8026f7 <memcmp+0x72>
		s1++, s2++;
  8026d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8026dc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8026e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8026e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8026ed:	48 85 c0             	test   %rax,%rax
  8026f0:	75 b9                	jne    8026ab <memcmp+0x26>
	}

	return 0;
  8026f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f7:	c9                   	leaveq 
  8026f8:	c3                   	retq   

00000000008026f9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8026f9:	55                   	push   %rbp
  8026fa:	48 89 e5             	mov    %rsp,%rbp
  8026fd:	48 83 ec 28          	sub    $0x28,%rsp
  802701:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802705:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802708:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80270c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802714:	48 01 d0             	add    %rdx,%rax
  802717:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80271b:	eb 15                	jmp    802732 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80271d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802721:	0f b6 00             	movzbl (%rax),%eax
  802724:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802727:	38 d0                	cmp    %dl,%al
  802729:	75 02                	jne    80272d <memfind+0x34>
			break;
  80272b:	eb 0f                	jmp    80273c <memfind+0x43>
	for (; s < ends; s++)
  80272d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802736:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80273a:	72 e1                	jb     80271d <memfind+0x24>
	return (void *) s;
  80273c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802740:	c9                   	leaveq 
  802741:	c3                   	retq   

0000000000802742 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802742:	55                   	push   %rbp
  802743:	48 89 e5             	mov    %rsp,%rbp
  802746:	48 83 ec 38          	sub    $0x38,%rsp
  80274a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80274e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802752:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802755:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80275c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802763:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802764:	eb 05                	jmp    80276b <strtol+0x29>
		s++;
  802766:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  80276b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276f:	0f b6 00             	movzbl (%rax),%eax
  802772:	3c 20                	cmp    $0x20,%al
  802774:	74 f0                	je     802766 <strtol+0x24>
  802776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277a:	0f b6 00             	movzbl (%rax),%eax
  80277d:	3c 09                	cmp    $0x9,%al
  80277f:	74 e5                	je     802766 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  802781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802785:	0f b6 00             	movzbl (%rax),%eax
  802788:	3c 2b                	cmp    $0x2b,%al
  80278a:	75 07                	jne    802793 <strtol+0x51>
		s++;
  80278c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802791:	eb 17                	jmp    8027aa <strtol+0x68>
	else if (*s == '-')
  802793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802797:	0f b6 00             	movzbl (%rax),%eax
  80279a:	3c 2d                	cmp    $0x2d,%al
  80279c:	75 0c                	jne    8027aa <strtol+0x68>
		s++, neg = 1;
  80279e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027a3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8027ae:	74 06                	je     8027b6 <strtol+0x74>
  8027b0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8027b4:	75 28                	jne    8027de <strtol+0x9c>
  8027b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ba:	0f b6 00             	movzbl (%rax),%eax
  8027bd:	3c 30                	cmp    $0x30,%al
  8027bf:	75 1d                	jne    8027de <strtol+0x9c>
  8027c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c5:	48 83 c0 01          	add    $0x1,%rax
  8027c9:	0f b6 00             	movzbl (%rax),%eax
  8027cc:	3c 78                	cmp    $0x78,%al
  8027ce:	75 0e                	jne    8027de <strtol+0x9c>
		s += 2, base = 16;
  8027d0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8027d5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8027dc:	eb 2c                	jmp    80280a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8027de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8027e2:	75 19                	jne    8027fd <strtol+0xbb>
  8027e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e8:	0f b6 00             	movzbl (%rax),%eax
  8027eb:	3c 30                	cmp    $0x30,%al
  8027ed:	75 0e                	jne    8027fd <strtol+0xbb>
		s++, base = 8;
  8027ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027f4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8027fb:	eb 0d                	jmp    80280a <strtol+0xc8>
	else if (base == 0)
  8027fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802801:	75 07                	jne    80280a <strtol+0xc8>
		base = 10;
  802803:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80280a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80280e:	0f b6 00             	movzbl (%rax),%eax
  802811:	3c 2f                	cmp    $0x2f,%al
  802813:	7e 1d                	jle    802832 <strtol+0xf0>
  802815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802819:	0f b6 00             	movzbl (%rax),%eax
  80281c:	3c 39                	cmp    $0x39,%al
  80281e:	7f 12                	jg     802832 <strtol+0xf0>
			dig = *s - '0';
  802820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802824:	0f b6 00             	movzbl (%rax),%eax
  802827:	0f be c0             	movsbl %al,%eax
  80282a:	83 e8 30             	sub    $0x30,%eax
  80282d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802830:	eb 4e                	jmp    802880 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802836:	0f b6 00             	movzbl (%rax),%eax
  802839:	3c 60                	cmp    $0x60,%al
  80283b:	7e 1d                	jle    80285a <strtol+0x118>
  80283d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802841:	0f b6 00             	movzbl (%rax),%eax
  802844:	3c 7a                	cmp    $0x7a,%al
  802846:	7f 12                	jg     80285a <strtol+0x118>
			dig = *s - 'a' + 10;
  802848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284c:	0f b6 00             	movzbl (%rax),%eax
  80284f:	0f be c0             	movsbl %al,%eax
  802852:	83 e8 57             	sub    $0x57,%eax
  802855:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802858:	eb 26                	jmp    802880 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80285a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285e:	0f b6 00             	movzbl (%rax),%eax
  802861:	3c 40                	cmp    $0x40,%al
  802863:	7e 48                	jle    8028ad <strtol+0x16b>
  802865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802869:	0f b6 00             	movzbl (%rax),%eax
  80286c:	3c 5a                	cmp    $0x5a,%al
  80286e:	7f 3d                	jg     8028ad <strtol+0x16b>
			dig = *s - 'A' + 10;
  802870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802874:	0f b6 00             	movzbl (%rax),%eax
  802877:	0f be c0             	movsbl %al,%eax
  80287a:	83 e8 37             	sub    $0x37,%eax
  80287d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802880:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802883:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802886:	7c 02                	jl     80288a <strtol+0x148>
			break;
  802888:	eb 23                	jmp    8028ad <strtol+0x16b>
		s++, val = (val * base) + dig;
  80288a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80288f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802892:	48 98                	cltq   
  802894:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802899:	48 89 c2             	mov    %rax,%rdx
  80289c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80289f:	48 98                	cltq   
  8028a1:	48 01 d0             	add    %rdx,%rax
  8028a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8028a8:	e9 5d ff ff ff       	jmpq   80280a <strtol+0xc8>

	if (endptr)
  8028ad:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8028b2:	74 0b                	je     8028bf <strtol+0x17d>
		*endptr = (char *) s;
  8028b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028b8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028bc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8028bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c3:	74 09                	je     8028ce <strtol+0x18c>
  8028c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c9:	48 f7 d8             	neg    %rax
  8028cc:	eb 04                	jmp    8028d2 <strtol+0x190>
  8028ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 30          	sub    $0x30,%rsp
  8028dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8028e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8028ec:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028f0:	0f b6 00             	movzbl (%rax),%eax
  8028f3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8028f6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8028fa:	75 06                	jne    802902 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8028fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802900:	eb 6b                	jmp    80296d <strstr+0x99>

	len = strlen(str);
  802902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802906:	48 89 c7             	mov    %rax,%rdi
  802909:	48 b8 aa 21 80 00 00 	movabs $0x8021aa,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
  802915:	48 98                	cltq   
  802917:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80291b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802923:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802927:	0f b6 00             	movzbl (%rax),%eax
  80292a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80292d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802931:	75 07                	jne    80293a <strstr+0x66>
				return (char *) 0;
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
  802938:	eb 33                	jmp    80296d <strstr+0x99>
		} while (sc != c);
  80293a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80293e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802941:	75 d8                	jne    80291b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802943:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802947:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80294b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80294f:	48 89 ce             	mov    %rcx,%rsi
  802952:	48 89 c7             	mov    %rax,%rdi
  802955:	48 b8 cb 23 80 00 00 	movabs $0x8023cb,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax
  802961:	85 c0                	test   %eax,%eax
  802963:	75 b6                	jne    80291b <strstr+0x47>

	return (char *) (in - 1);
  802965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802969:	48 83 e8 01          	sub    $0x1,%rax
}
  80296d:	c9                   	leaveq 
  80296e:	c3                   	retq   

000000000080296f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80296f:	55                   	push   %rbp
  802970:	48 89 e5             	mov    %rsp,%rbp
  802973:	53                   	push   %rbx
  802974:	48 83 ec 48          	sub    $0x48,%rsp
  802978:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80297b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80297e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802982:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802986:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80298a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80298e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802991:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802995:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802999:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80299d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8029a1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8029a5:	4c 89 c3             	mov    %r8,%rbx
  8029a8:	cd 30                	int    $0x30
  8029aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8029ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8029b2:	74 3e                	je     8029f2 <syscall+0x83>
  8029b4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029b9:	7e 37                	jle    8029f2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029c2:	49 89 d0             	mov    %rdx,%r8
  8029c5:	89 c1                	mov    %eax,%ecx
  8029c7:	48 ba db 66 80 00 00 	movabs $0x8066db,%rdx
  8029ce:	00 00 00 
  8029d1:	be 23 00 00 00       	mov    $0x23,%esi
  8029d6:	48 bf f8 66 80 00 00 	movabs $0x8066f8,%rdi
  8029dd:	00 00 00 
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	49 b9 e9 12 80 00 00 	movabs $0x8012e9,%r9
  8029ec:	00 00 00 
  8029ef:	41 ff d1             	callq  *%r9

	return ret;
  8029f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8029f6:	48 83 c4 48          	add    $0x48,%rsp
  8029fa:	5b                   	pop    %rbx
  8029fb:	5d                   	pop    %rbp
  8029fc:	c3                   	retq   

00000000008029fd <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 10          	sub    $0x10,%rsp
  802a05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802a0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a15:	48 83 ec 08          	sub    $0x8,%rsp
  802a19:	6a 00                	pushq  $0x0
  802a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a27:	48 89 d1             	mov    %rdx,%rcx
  802a2a:	48 89 c2             	mov    %rax,%rdx
  802a2d:	be 00 00 00 00       	mov    $0x0,%esi
  802a32:	bf 00 00 00 00       	mov    $0x0,%edi
  802a37:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
  802a43:	48 83 c4 10          	add    $0x10,%rsp
}
  802a47:	c9                   	leaveq 
  802a48:	c3                   	retq   

0000000000802a49 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a49:	55                   	push   %rbp
  802a4a:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802a4d:	48 83 ec 08          	sub    $0x8,%rsp
  802a51:	6a 00                	pushq  $0x0
  802a53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a64:	ba 00 00 00 00       	mov    $0x0,%edx
  802a69:	be 00 00 00 00       	mov    $0x0,%esi
  802a6e:	bf 01 00 00 00       	mov    $0x1,%edi
  802a73:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802a7a:	00 00 00 
  802a7d:	ff d0                	callq  *%rax
  802a7f:	48 83 c4 10          	add    $0x10,%rsp
}
  802a83:	c9                   	leaveq 
  802a84:	c3                   	retq   

0000000000802a85 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802a85:	55                   	push   %rbp
  802a86:	48 89 e5             	mov    %rsp,%rbp
  802a89:	48 83 ec 10          	sub    $0x10,%rsp
  802a8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a93:	48 98                	cltq   
  802a95:	48 83 ec 08          	sub    $0x8,%rsp
  802a99:	6a 00                	pushq  $0x0
  802a9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802aa1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802aa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  802aac:	48 89 c2             	mov    %rax,%rdx
  802aaf:	be 01 00 00 00       	mov    $0x1,%esi
  802ab4:	bf 03 00 00 00       	mov    $0x3,%edi
  802ab9:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
  802ac5:	48 83 c4 10          	add    $0x10,%rsp
}
  802ac9:	c9                   	leaveq 
  802aca:	c3                   	retq   

0000000000802acb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802acb:	55                   	push   %rbp
  802acc:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802acf:	48 83 ec 08          	sub    $0x8,%rsp
  802ad3:	6a 00                	pushq  $0x0
  802ad5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802adb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ae1:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  802aeb:	be 00 00 00 00       	mov    $0x0,%esi
  802af0:	bf 02 00 00 00       	mov    $0x2,%edi
  802af5:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802afc:	00 00 00 
  802aff:	ff d0                	callq  *%rax
  802b01:	48 83 c4 10          	add    $0x10,%rsp
}
  802b05:	c9                   	leaveq 
  802b06:	c3                   	retq   

0000000000802b07 <sys_yield>:

void
sys_yield(void)
{
  802b07:	55                   	push   %rbp
  802b08:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802b0b:	48 83 ec 08          	sub    $0x8,%rsp
  802b0f:	6a 00                	pushq  $0x0
  802b11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b22:	ba 00 00 00 00       	mov    $0x0,%edx
  802b27:	be 00 00 00 00       	mov    $0x0,%esi
  802b2c:	bf 0b 00 00 00       	mov    $0xb,%edi
  802b31:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
  802b3d:	48 83 c4 10          	add    $0x10,%rsp
}
  802b41:	c9                   	leaveq 
  802b42:	c3                   	retq   

0000000000802b43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
  802b47:	48 83 ec 10          	sub    $0x10,%rsp
  802b4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b52:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802b55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b58:	48 63 c8             	movslq %eax,%rcx
  802b5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b62:	48 98                	cltq   
  802b64:	48 83 ec 08          	sub    $0x8,%rsp
  802b68:	6a 00                	pushq  $0x0
  802b6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b70:	49 89 c8             	mov    %rcx,%r8
  802b73:	48 89 d1             	mov    %rdx,%rcx
  802b76:	48 89 c2             	mov    %rax,%rdx
  802b79:	be 01 00 00 00       	mov    $0x1,%esi
  802b7e:	bf 04 00 00 00       	mov    $0x4,%edi
  802b83:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802b8a:	00 00 00 
  802b8d:	ff d0                	callq  *%rax
  802b8f:	48 83 c4 10          	add    $0x10,%rsp
}
  802b93:	c9                   	leaveq 
  802b94:	c3                   	retq   

0000000000802b95 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802b95:	55                   	push   %rbp
  802b96:	48 89 e5             	mov    %rsp,%rbp
  802b99:	48 83 ec 20          	sub    $0x20,%rsp
  802b9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ba0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ba4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802ba7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802bab:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802baf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802bb2:	48 63 c8             	movslq %eax,%rcx
  802bb5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802bb9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bbc:	48 63 f0             	movslq %eax,%rsi
  802bbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc6:	48 98                	cltq   
  802bc8:	48 83 ec 08          	sub    $0x8,%rsp
  802bcc:	51                   	push   %rcx
  802bcd:	49 89 f9             	mov    %rdi,%r9
  802bd0:	49 89 f0             	mov    %rsi,%r8
  802bd3:	48 89 d1             	mov    %rdx,%rcx
  802bd6:	48 89 c2             	mov    %rax,%rdx
  802bd9:	be 01 00 00 00       	mov    $0x1,%esi
  802bde:	bf 05 00 00 00       	mov    $0x5,%edi
  802be3:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
  802bef:	48 83 c4 10          	add    $0x10,%rsp
}
  802bf3:	c9                   	leaveq 
  802bf4:	c3                   	retq   

0000000000802bf5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802bf5:	55                   	push   %rbp
  802bf6:	48 89 e5             	mov    %rsp,%rbp
  802bf9:	48 83 ec 10          	sub    $0x10,%rsp
  802bfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802c04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0b:	48 98                	cltq   
  802c0d:	48 83 ec 08          	sub    $0x8,%rsp
  802c11:	6a 00                	pushq  $0x0
  802c13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c1f:	48 89 d1             	mov    %rdx,%rcx
  802c22:	48 89 c2             	mov    %rax,%rdx
  802c25:	be 01 00 00 00       	mov    $0x1,%esi
  802c2a:	bf 06 00 00 00       	mov    $0x6,%edi
  802c2f:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	callq  *%rax
  802c3b:	48 83 c4 10          	add    $0x10,%rsp
}
  802c3f:	c9                   	leaveq 
  802c40:	c3                   	retq   

0000000000802c41 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802c41:	55                   	push   %rbp
  802c42:	48 89 e5             	mov    %rsp,%rbp
  802c45:	48 83 ec 10          	sub    $0x10,%rsp
  802c49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c4c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802c4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c52:	48 63 d0             	movslq %eax,%rdx
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c58:	48 98                	cltq   
  802c5a:	48 83 ec 08          	sub    $0x8,%rsp
  802c5e:	6a 00                	pushq  $0x0
  802c60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c6c:	48 89 d1             	mov    %rdx,%rcx
  802c6f:	48 89 c2             	mov    %rax,%rdx
  802c72:	be 01 00 00 00       	mov    $0x1,%esi
  802c77:	bf 08 00 00 00       	mov    $0x8,%edi
  802c7c:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
  802c88:	48 83 c4 10          	add    $0x10,%rsp
}
  802c8c:	c9                   	leaveq 
  802c8d:	c3                   	retq   

0000000000802c8e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802c8e:	55                   	push   %rbp
  802c8f:	48 89 e5             	mov    %rsp,%rbp
  802c92:	48 83 ec 10          	sub    $0x10,%rsp
  802c96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802c9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ca1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca4:	48 98                	cltq   
  802ca6:	48 83 ec 08          	sub    $0x8,%rsp
  802caa:	6a 00                	pushq  $0x0
  802cac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802cb8:	48 89 d1             	mov    %rdx,%rcx
  802cbb:	48 89 c2             	mov    %rax,%rdx
  802cbe:	be 01 00 00 00       	mov    $0x1,%esi
  802cc3:	bf 09 00 00 00       	mov    $0x9,%edi
  802cc8:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	48 83 c4 10          	add    $0x10,%rsp
}
  802cd8:	c9                   	leaveq 
  802cd9:	c3                   	retq   

0000000000802cda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802cda:	55                   	push   %rbp
  802cdb:	48 89 e5             	mov    %rsp,%rbp
  802cde:	48 83 ec 10          	sub    $0x10,%rsp
  802ce2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ce5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802ce9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf0:	48 98                	cltq   
  802cf2:	48 83 ec 08          	sub    $0x8,%rsp
  802cf6:	6a 00                	pushq  $0x0
  802cf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d04:	48 89 d1             	mov    %rdx,%rcx
  802d07:	48 89 c2             	mov    %rax,%rdx
  802d0a:	be 01 00 00 00       	mov    $0x1,%esi
  802d0f:	bf 0a 00 00 00       	mov    $0xa,%edi
  802d14:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax
  802d20:	48 83 c4 10          	add    $0x10,%rsp
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 20          	sub    $0x20,%rsp
  802d2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d35:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d39:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802d3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3f:	48 63 f0             	movslq %eax,%rsi
  802d42:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d49:	48 98                	cltq   
  802d4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d4f:	48 83 ec 08          	sub    $0x8,%rsp
  802d53:	6a 00                	pushq  $0x0
  802d55:	49 89 f1             	mov    %rsi,%r9
  802d58:	49 89 c8             	mov    %rcx,%r8
  802d5b:	48 89 d1             	mov    %rdx,%rcx
  802d5e:	48 89 c2             	mov    %rax,%rdx
  802d61:	be 00 00 00 00       	mov    $0x0,%esi
  802d66:	bf 0c 00 00 00       	mov    $0xc,%edi
  802d6b:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
  802d77:	48 83 c4 10          	add    $0x10,%rsp
}
  802d7b:	c9                   	leaveq 
  802d7c:	c3                   	retq   

0000000000802d7d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802d7d:	55                   	push   %rbp
  802d7e:	48 89 e5             	mov    %rsp,%rbp
  802d81:	48 83 ec 10          	sub    $0x10,%rsp
  802d85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802d89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8d:	48 83 ec 08          	sub    $0x8,%rsp
  802d91:	6a 00                	pushq  $0x0
  802d93:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d99:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802da4:	48 89 c2             	mov    %rax,%rdx
  802da7:	be 01 00 00 00       	mov    $0x1,%esi
  802dac:	bf 0d 00 00 00       	mov    $0xd,%edi
  802db1:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	callq  *%rax
  802dbd:	48 83 c4 10          	add    $0x10,%rsp
}
  802dc1:	c9                   	leaveq 
  802dc2:	c3                   	retq   

0000000000802dc3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802dc3:	55                   	push   %rbp
  802dc4:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802dc7:	48 83 ec 08          	sub    $0x8,%rsp
  802dcb:	6a 00                	pushq  $0x0
  802dcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802dd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  802dde:	ba 00 00 00 00       	mov    $0x0,%edx
  802de3:	be 00 00 00 00       	mov    $0x0,%esi
  802de8:	bf 0e 00 00 00       	mov    $0xe,%edi
  802ded:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
  802df9:	48 83 c4 10          	add    $0x10,%rsp
}
  802dfd:	c9                   	leaveq 
  802dfe:	c3                   	retq   

0000000000802dff <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802dff:	55                   	push   %rbp
  802e00:	48 89 e5             	mov    %rsp,%rbp
  802e03:	48 83 ec 20          	sub    $0x20,%rsp
  802e07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e0a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e0e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802e11:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802e15:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802e19:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e1c:	48 63 c8             	movslq %eax,%rcx
  802e1f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802e23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e26:	48 63 f0             	movslq %eax,%rsi
  802e29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	48 98                	cltq   
  802e32:	48 83 ec 08          	sub    $0x8,%rsp
  802e36:	51                   	push   %rcx
  802e37:	49 89 f9             	mov    %rdi,%r9
  802e3a:	49 89 f0             	mov    %rsi,%r8
  802e3d:	48 89 d1             	mov    %rdx,%rcx
  802e40:	48 89 c2             	mov    %rax,%rdx
  802e43:	be 00 00 00 00       	mov    $0x0,%esi
  802e48:	bf 0f 00 00 00       	mov    $0xf,%edi
  802e4d:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
  802e59:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802e5d:	c9                   	leaveq 
  802e5e:	c3                   	retq   

0000000000802e5f <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802e5f:	55                   	push   %rbp
  802e60:	48 89 e5             	mov    %rsp,%rbp
  802e63:	48 83 ec 10          	sub    $0x10,%rsp
  802e67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802e6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e77:	48 83 ec 08          	sub    $0x8,%rsp
  802e7b:	6a 00                	pushq  $0x0
  802e7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e89:	48 89 d1             	mov    %rdx,%rcx
  802e8c:	48 89 c2             	mov    %rax,%rdx
  802e8f:	be 00 00 00 00       	mov    $0x0,%esi
  802e94:	bf 10 00 00 00       	mov    $0x10,%edi
  802e99:	48 b8 6f 29 80 00 00 	movabs $0x80296f,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	48 83 c4 10          	add    $0x10,%rsp
}
  802ea9:	c9                   	leaveq 
  802eaa:	c3                   	retq   

0000000000802eab <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802eab:	55                   	push   %rbp
  802eac:	48 89 e5             	mov    %rsp,%rbp
  802eaf:	48 83 ec 20          	sub    $0x20,%rsp
  802eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebb:	48 8b 00             	mov    (%rax),%rax
  802ebe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec6:	48 8b 40 08          	mov    0x8(%rax),%rax
  802eca:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  802ecd:	48 ba 06 67 80 00 00 	movabs $0x806706,%rdx
  802ed4:	00 00 00 
  802ed7:	be 26 00 00 00       	mov    $0x26,%esi
  802edc:	48 bf 1e 67 80 00 00 	movabs $0x80671e,%rdi
  802ee3:	00 00 00 
  802ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eeb:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  802ef2:	00 00 00 
  802ef5:	ff d1                	callq  *%rcx

0000000000802ef7 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802ef7:	55                   	push   %rbp
  802ef8:	48 89 e5             	mov    %rsp,%rbp
  802efb:	48 83 ec 10          	sub    $0x10,%rsp
  802eff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f02:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  802f05:	48 ba 29 67 80 00 00 	movabs $0x806729,%rdx
  802f0c:	00 00 00 
  802f0f:	be 3a 00 00 00       	mov    $0x3a,%esi
  802f14:	48 bf 1e 67 80 00 00 	movabs $0x80671e,%rdi
  802f1b:	00 00 00 
  802f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f23:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  802f2a:	00 00 00 
  802f2d:	ff d1                	callq  *%rcx

0000000000802f2f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802f2f:	55                   	push   %rbp
  802f30:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  802f33:	48 ba 41 67 80 00 00 	movabs $0x806741,%rdx
  802f3a:	00 00 00 
  802f3d:	be 52 00 00 00       	mov    $0x52,%esi
  802f42:	48 bf 1e 67 80 00 00 	movabs $0x80671e,%rdi
  802f49:	00 00 00 
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  802f58:	00 00 00 
  802f5b:	ff d1                	callq  *%rcx

0000000000802f5d <sfork>:
}

// Challenge!
int
sfork(void)
{
  802f5d:	55                   	push   %rbp
  802f5e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802f61:	48 ba 56 67 80 00 00 	movabs $0x806756,%rdx
  802f68:	00 00 00 
  802f6b:	be 59 00 00 00       	mov    $0x59,%esi
  802f70:	48 bf 1e 67 80 00 00 	movabs $0x80671e,%rdi
  802f77:	00 00 00 
  802f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f7f:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  802f86:	00 00 00 
  802f89:	ff d1                	callq  *%rcx

0000000000802f8b <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  802f8b:	55                   	push   %rbp
  802f8c:	48 89 e5             	mov    %rsp,%rbp
  802f8f:	48 83 ec 18          	sub    $0x18,%rsp
  802f93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f9b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fa7:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  802faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fb2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fba:	8b 00                	mov    (%rax),%eax
  802fbc:	83 f8 01             	cmp    $0x1,%eax
  802fbf:	7e 13                	jle    802fd4 <argstart+0x49>
  802fc1:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  802fc6:	74 0c                	je     802fd4 <argstart+0x49>
  802fc8:	48 b8 6c 67 80 00 00 	movabs $0x80676c,%rax
  802fcf:	00 00 00 
  802fd2:	eb 05                	jmp    802fd9 <argstart+0x4e>
  802fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fdd:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe5:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802fec:	00 
}
  802fed:	c9                   	leaveq 
  802fee:	c3                   	retq   

0000000000802fef <argnext>:

int
argnext(struct Argstate *args)
{
  802fef:	55                   	push   %rbp
  802ff0:	48 89 e5             	mov    %rsp,%rbp
  802ff3:	48 83 ec 20          	sub    $0x20,%rsp
  802ff7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  802ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fff:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803006:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80300f:	48 85 c0             	test   %rax,%rax
  803012:	75 0a                	jne    80301e <argnext+0x2f>
		return -1;
  803014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803019:	e9 25 01 00 00       	jmpq   803143 <argnext+0x154>

	if (!*args->curarg) {
  80301e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803022:	48 8b 40 10          	mov    0x10(%rax),%rax
  803026:	0f b6 00             	movzbl (%rax),%eax
  803029:	84 c0                	test   %al,%al
  80302b:	0f 85 d7 00 00 00    	jne    803108 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  803031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803035:	48 8b 00             	mov    (%rax),%rax
  803038:	8b 00                	mov    (%rax),%eax
  80303a:	83 f8 01             	cmp    $0x1,%eax
  80303d:	0f 84 ef 00 00 00    	je     803132 <argnext+0x143>
		    || args->argv[1][0] != '-'
  803043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803047:	48 8b 40 08          	mov    0x8(%rax),%rax
  80304b:	48 83 c0 08          	add    $0x8,%rax
  80304f:	48 8b 00             	mov    (%rax),%rax
  803052:	0f b6 00             	movzbl (%rax),%eax
  803055:	3c 2d                	cmp    $0x2d,%al
  803057:	0f 85 d5 00 00 00    	jne    803132 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80305d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803061:	48 8b 40 08          	mov    0x8(%rax),%rax
  803065:	48 83 c0 08          	add    $0x8,%rax
  803069:	48 8b 00             	mov    (%rax),%rax
  80306c:	48 83 c0 01          	add    $0x1,%rax
  803070:	0f b6 00             	movzbl (%rax),%eax
  803073:	84 c0                	test   %al,%al
  803075:	0f 84 b7 00 00 00    	je     803132 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80307b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307f:	48 8b 40 08          	mov    0x8(%rax),%rax
  803083:	48 83 c0 08          	add    $0x8,%rax
  803087:	48 8b 00             	mov    (%rax),%rax
  80308a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80308e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803092:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309a:	48 8b 00             	mov    (%rax),%rax
  80309d:	8b 00                	mov    (%rax),%eax
  80309f:	83 e8 01             	sub    $0x1,%eax
  8030a2:	48 98                	cltq   
  8030a4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030ab:	00 
  8030ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8030b4:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8030b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8030c0:	48 83 c0 08          	add    $0x8,%rax
  8030c4:	48 89 ce             	mov    %rcx,%rsi
  8030c7:	48 89 c7             	mov    %rax,%rdi
  8030ca:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
		(*args->argc)--;
  8030d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030da:	48 8b 00             	mov    (%rax),%rax
  8030dd:	8b 10                	mov    (%rax),%edx
  8030df:	83 ea 01             	sub    $0x1,%edx
  8030e2:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8030e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030ec:	0f b6 00             	movzbl (%rax),%eax
  8030ef:	3c 2d                	cmp    $0x2d,%al
  8030f1:	75 15                	jne    803108 <argnext+0x119>
  8030f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030fb:	48 83 c0 01          	add    $0x1,%rax
  8030ff:	0f b6 00             	movzbl (%rax),%eax
  803102:	84 c0                	test   %al,%al
  803104:	75 02                	jne    803108 <argnext+0x119>
			goto endofargs;
  803106:	eb 2a                	jmp    803132 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803110:	0f b6 00             	movzbl (%rax),%eax
  803113:	0f b6 c0             	movzbl %al,%eax
  803116:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803121:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803129:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80312d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803130:	eb 11                	jmp    803143 <argnext+0x154>

endofargs:
	args->curarg = 0;
  803132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803136:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80313d:	00 
	return -1;
  80313e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803143:	c9                   	leaveq 
  803144:	c3                   	retq   

0000000000803145 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803145:	55                   	push   %rbp
  803146:	48 89 e5             	mov    %rsp,%rbp
  803149:	48 83 ec 10          	sub    $0x10,%rsp
  80314d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  803151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803155:	48 8b 40 18          	mov    0x18(%rax),%rax
  803159:	48 85 c0             	test   %rax,%rax
  80315c:	74 0a                	je     803168 <argvalue+0x23>
  80315e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803162:	48 8b 40 18          	mov    0x18(%rax),%rax
  803166:	eb 13                	jmp    80317b <argvalue+0x36>
  803168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80316c:	48 89 c7             	mov    %rax,%rdi
  80316f:	48 b8 7d 31 80 00 00 	movabs $0x80317d,%rax
  803176:	00 00 00 
  803179:	ff d0                	callq  *%rax
}
  80317b:	c9                   	leaveq 
  80317c:	c3                   	retq   

000000000080317d <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80317d:	55                   	push   %rbp
  80317e:	48 89 e5             	mov    %rsp,%rbp
  803181:	48 83 ec 10          	sub    $0x10,%rsp
  803185:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  803189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803191:	48 85 c0             	test   %rax,%rax
  803194:	75 0a                	jne    8031a0 <argnextvalue+0x23>
		return 0;
  803196:	b8 00 00 00 00       	mov    $0x0,%eax
  80319b:	e9 c8 00 00 00       	jmpq   803268 <argnextvalue+0xeb>
	if (*args->curarg) {
  8031a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8031a8:	0f b6 00             	movzbl (%rax),%eax
  8031ab:	84 c0                	test   %al,%al
  8031ad:	74 27                	je     8031d6 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8031af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8031b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bb:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8031bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c3:	48 be 6c 67 80 00 00 	movabs $0x80676c,%rsi
  8031ca:	00 00 00 
  8031cd:	48 89 70 10          	mov    %rsi,0x10(%rax)
  8031d1:	e9 8a 00 00 00       	jmpq   803260 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  8031d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031da:	48 8b 00             	mov    (%rax),%rax
  8031dd:	8b 00                	mov    (%rax),%eax
  8031df:	83 f8 01             	cmp    $0x1,%eax
  8031e2:	7e 64                	jle    803248 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  8031e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031e8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8031ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8031f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f4:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8031f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031fc:	48 8b 00             	mov    (%rax),%rax
  8031ff:	8b 00                	mov    (%rax),%eax
  803201:	83 e8 01             	sub    $0x1,%eax
  803204:	48 98                	cltq   
  803206:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80320d:	00 
  80320e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803212:	48 8b 40 08          	mov    0x8(%rax),%rax
  803216:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80321a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80321e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803222:	48 83 c0 08          	add    $0x8,%rax
  803226:	48 89 ce             	mov    %rcx,%rsi
  803229:	48 89 c7             	mov    %rax,%rdi
  80322c:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
		(*args->argc)--;
  803238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323c:	48 8b 00             	mov    (%rax),%rax
  80323f:	8b 10                	mov    (%rax),%edx
  803241:	83 ea 01             	sub    $0x1,%edx
  803244:	89 10                	mov    %edx,(%rax)
  803246:	eb 18                	jmp    803260 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  803248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324c:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803253:	00 
		args->curarg = 0;
  803254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803258:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80325f:	00 
	}
	return (char*) args->argvalue;
  803260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803264:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803268:	c9                   	leaveq 
  803269:	c3                   	retq   

000000000080326a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80326a:	55                   	push   %rbp
  80326b:	48 89 e5             	mov    %rsp,%rbp
  80326e:	48 83 ec 08          	sub    $0x8,%rsp
  803272:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803276:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80327a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803281:	ff ff ff 
  803284:	48 01 d0             	add    %rdx,%rax
  803287:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80328b:	c9                   	leaveq 
  80328c:	c3                   	retq   

000000000080328d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80328d:	55                   	push   %rbp
  80328e:	48 89 e5             	mov    %rsp,%rbp
  803291:	48 83 ec 08          	sub    $0x8,%rsp
  803295:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  803299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
  8032ac:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8032b2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8032b6:	c9                   	leaveq 
  8032b7:	c3                   	retq   

00000000008032b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8032b8:	55                   	push   %rbp
  8032b9:	48 89 e5             	mov    %rsp,%rbp
  8032bc:	48 83 ec 18          	sub    $0x18,%rsp
  8032c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8032c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032cb:	eb 6b                	jmp    803338 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8032cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d0:	48 98                	cltq   
  8032d2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8032d8:	48 c1 e0 0c          	shl    $0xc,%rax
  8032dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8032e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e4:	48 c1 e8 15          	shr    $0x15,%rax
  8032e8:	48 89 c2             	mov    %rax,%rdx
  8032eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8032f2:	01 00 00 
  8032f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032f9:	83 e0 01             	and    $0x1,%eax
  8032fc:	48 85 c0             	test   %rax,%rax
  8032ff:	74 21                	je     803322 <fd_alloc+0x6a>
  803301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803305:	48 c1 e8 0c          	shr    $0xc,%rax
  803309:	48 89 c2             	mov    %rax,%rdx
  80330c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803313:	01 00 00 
  803316:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80331a:	83 e0 01             	and    $0x1,%eax
  80331d:	48 85 c0             	test   %rax,%rax
  803320:	75 12                	jne    803334 <fd_alloc+0x7c>
			*fd_store = fd;
  803322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803326:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80332a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80332d:	b8 00 00 00 00       	mov    $0x0,%eax
  803332:	eb 1a                	jmp    80334e <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  803334:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803338:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80333c:	7e 8f                	jle    8032cd <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  80333e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803342:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803349:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80334e:	c9                   	leaveq 
  80334f:	c3                   	retq   

0000000000803350 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803350:	55                   	push   %rbp
  803351:	48 89 e5             	mov    %rsp,%rbp
  803354:	48 83 ec 20          	sub    $0x20,%rsp
  803358:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80335b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80335f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803363:	78 06                	js     80336b <fd_lookup+0x1b>
  803365:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803369:	7e 07                	jle    803372 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80336b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803370:	eb 6c                	jmp    8033de <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803372:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803375:	48 98                	cltq   
  803377:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80337d:	48 c1 e0 0c          	shl    $0xc,%rax
  803381:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803389:	48 c1 e8 15          	shr    $0x15,%rax
  80338d:	48 89 c2             	mov    %rax,%rdx
  803390:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803397:	01 00 00 
  80339a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80339e:	83 e0 01             	and    $0x1,%eax
  8033a1:	48 85 c0             	test   %rax,%rax
  8033a4:	74 21                	je     8033c7 <fd_lookup+0x77>
  8033a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8033ae:	48 89 c2             	mov    %rax,%rdx
  8033b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033b8:	01 00 00 
  8033bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033bf:	83 e0 01             	and    $0x1,%eax
  8033c2:	48 85 c0             	test   %rax,%rax
  8033c5:	75 07                	jne    8033ce <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8033c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033cc:	eb 10                	jmp    8033de <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8033ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033d6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8033d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033de:	c9                   	leaveq 
  8033df:	c3                   	retq   

00000000008033e0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8033e0:	55                   	push   %rbp
  8033e1:	48 89 e5             	mov    %rsp,%rbp
  8033e4:	48 83 ec 30          	sub    $0x30,%rsp
  8033e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033ec:	89 f0                	mov    %esi,%eax
  8033ee:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8033f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f5:	48 89 c7             	mov    %rax,%rdi
  8033f8:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
  803404:	89 c2                	mov    %eax,%edx
  803406:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80340a:	48 89 c6             	mov    %rax,%rsi
  80340d:	89 d7                	mov    %edx,%edi
  80340f:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
  80341b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803422:	78 0a                	js     80342e <fd_close+0x4e>
	    || fd != fd2)
  803424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803428:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80342c:	74 12                	je     803440 <fd_close+0x60>
		return (must_exist ? r : 0);
  80342e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803432:	74 05                	je     803439 <fd_close+0x59>
  803434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803437:	eb 70                	jmp    8034a9 <fd_close+0xc9>
  803439:	b8 00 00 00 00       	mov    $0x0,%eax
  80343e:	eb 69                	jmp    8034a9 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803444:	8b 00                	mov    (%rax),%eax
  803446:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80344a:	48 89 d6             	mov    %rdx,%rsi
  80344d:	89 c7                	mov    %eax,%edi
  80344f:	48 b8 ab 34 80 00 00 	movabs $0x8034ab,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
  80345b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803462:	78 2a                	js     80348e <fd_close+0xae>
		if (dev->dev_close)
  803464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803468:	48 8b 40 20          	mov    0x20(%rax),%rax
  80346c:	48 85 c0             	test   %rax,%rax
  80346f:	74 16                	je     803487 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  803471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803475:	48 8b 40 20          	mov    0x20(%rax),%rax
  803479:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80347d:	48 89 d7             	mov    %rdx,%rdi
  803480:	ff d0                	callq  *%rax
  803482:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803485:	eb 07                	jmp    80348e <fd_close+0xae>
		else
			r = 0;
  803487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80348e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803492:	48 89 c6             	mov    %rax,%rsi
  803495:	bf 00 00 00 00       	mov    $0x0,%edi
  80349a:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
	return r;
  8034a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034a9:	c9                   	leaveq 
  8034aa:	c3                   	retq   

00000000008034ab <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8034ab:	55                   	push   %rbp
  8034ac:	48 89 e5             	mov    %rsp,%rbp
  8034af:	48 83 ec 20          	sub    $0x20,%rsp
  8034b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8034ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034c1:	eb 41                	jmp    803504 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8034c3:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8034ca:	00 00 00 
  8034cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034d0:	48 63 d2             	movslq %edx,%rdx
  8034d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034d7:	8b 00                	mov    (%rax),%eax
  8034d9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8034dc:	75 22                	jne    803500 <dev_lookup+0x55>
			*dev = devtab[i];
  8034de:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8034e5:	00 00 00 
  8034e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034eb:	48 63 d2             	movslq %edx,%rdx
  8034ee:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8034f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8034f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fe:	eb 60                	jmp    803560 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  803500:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803504:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80350b:	00 00 00 
  80350e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803511:	48 63 d2             	movslq %edx,%rdx
  803514:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803518:	48 85 c0             	test   %rax,%rax
  80351b:	75 a6                	jne    8034c3 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80351d:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803524:	00 00 00 
  803527:	48 8b 00             	mov    (%rax),%rax
  80352a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803530:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803533:	89 c6                	mov    %eax,%esi
  803535:	48 bf 70 67 80 00 00 	movabs $0x806770,%rdi
  80353c:	00 00 00 
  80353f:	b8 00 00 00 00       	mov    $0x0,%eax
  803544:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  80354b:	00 00 00 
  80354e:	ff d1                	callq  *%rcx
	*dev = 0;
  803550:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803554:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80355b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803560:	c9                   	leaveq 
  803561:	c3                   	retq   

0000000000803562 <close>:

int
close(int fdnum)
{
  803562:	55                   	push   %rbp
  803563:	48 89 e5             	mov    %rsp,%rbp
  803566:	48 83 ec 20          	sub    $0x20,%rsp
  80356a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80356d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803571:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803574:	48 89 d6             	mov    %rdx,%rsi
  803577:	89 c7                	mov    %eax,%edi
  803579:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  803580:	00 00 00 
  803583:	ff d0                	callq  *%rax
  803585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80358c:	79 05                	jns    803593 <close+0x31>
		return r;
  80358e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803591:	eb 18                	jmp    8035ab <close+0x49>
	else
		return fd_close(fd, 1);
  803593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803597:	be 01 00 00 00       	mov    $0x1,%esi
  80359c:	48 89 c7             	mov    %rax,%rdi
  80359f:	48 b8 e0 33 80 00 00 	movabs $0x8033e0,%rax
  8035a6:	00 00 00 
  8035a9:	ff d0                	callq  *%rax
}
  8035ab:	c9                   	leaveq 
  8035ac:	c3                   	retq   

00000000008035ad <close_all>:

void
close_all(void)
{
  8035ad:	55                   	push   %rbp
  8035ae:	48 89 e5             	mov    %rsp,%rbp
  8035b1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8035b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035bc:	eb 15                	jmp    8035d3 <close_all+0x26>
		close(i);
  8035be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c1:	89 c7                	mov    %eax,%edi
  8035c3:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8035cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8035d3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8035d7:	7e e5                	jle    8035be <close_all+0x11>
}
  8035d9:	c9                   	leaveq 
  8035da:	c3                   	retq   

00000000008035db <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8035db:	55                   	push   %rbp
  8035dc:	48 89 e5             	mov    %rsp,%rbp
  8035df:	48 83 ec 40          	sub    $0x40,%rsp
  8035e3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8035e6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8035e9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8035ed:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8035f0:	48 89 d6             	mov    %rdx,%rsi
  8035f3:	89 c7                	mov    %eax,%edi
  8035f5:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  8035fc:	00 00 00 
  8035ff:	ff d0                	callq  *%rax
  803601:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803604:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803608:	79 08                	jns    803612 <dup+0x37>
		return r;
  80360a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360d:	e9 70 01 00 00       	jmpq   803782 <dup+0x1a7>
	close(newfdnum);
  803612:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803615:	89 c7                	mov    %eax,%edi
  803617:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803623:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803626:	48 98                	cltq   
  803628:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80362e:	48 c1 e0 0c          	shl    $0xc,%rax
  803632:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363a:	48 89 c7             	mov    %rax,%rdi
  80363d:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80364d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803651:	48 89 c7             	mov    %rax,%rdi
  803654:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  80365b:	00 00 00 
  80365e:	ff d0                	callq  *%rax
  803660:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803668:	48 c1 e8 15          	shr    $0x15,%rax
  80366c:	48 89 c2             	mov    %rax,%rdx
  80366f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803676:	01 00 00 
  803679:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80367d:	83 e0 01             	and    $0x1,%eax
  803680:	48 85 c0             	test   %rax,%rax
  803683:	74 73                	je     8036f8 <dup+0x11d>
  803685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803689:	48 c1 e8 0c          	shr    $0xc,%rax
  80368d:	48 89 c2             	mov    %rax,%rdx
  803690:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803697:	01 00 00 
  80369a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80369e:	83 e0 01             	and    $0x1,%eax
  8036a1:	48 85 c0             	test   %rax,%rax
  8036a4:	74 52                	je     8036f8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8036a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8036ae:	48 89 c2             	mov    %rax,%rdx
  8036b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036b8:	01 00 00 
  8036bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8036c4:	89 c1                	mov    %eax,%ecx
  8036c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ce:	41 89 c8             	mov    %ecx,%r8d
  8036d1:	48 89 d1             	mov    %rdx,%rcx
  8036d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8036d9:	48 89 c6             	mov    %rax,%rsi
  8036dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e1:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	callq  *%rax
  8036ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f4:	79 02                	jns    8036f8 <dup+0x11d>
			goto err;
  8036f6:	eb 57                	jmp    80374f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8036f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036fc:	48 c1 e8 0c          	shr    $0xc,%rax
  803700:	48 89 c2             	mov    %rax,%rdx
  803703:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80370a:	01 00 00 
  80370d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803711:	25 07 0e 00 00       	and    $0xe07,%eax
  803716:	89 c1                	mov    %eax,%ecx
  803718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803720:	41 89 c8             	mov    %ecx,%r8d
  803723:	48 89 d1             	mov    %rdx,%rcx
  803726:	ba 00 00 00 00       	mov    $0x0,%edx
  80372b:	48 89 c6             	mov    %rax,%rsi
  80372e:	bf 00 00 00 00       	mov    $0x0,%edi
  803733:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
  80373f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803746:	79 02                	jns    80374a <dup+0x16f>
		goto err;
  803748:	eb 05                	jmp    80374f <dup+0x174>

	return newfdnum;
  80374a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80374d:	eb 33                	jmp    803782 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80374f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803753:	48 89 c6             	mov    %rax,%rsi
  803756:	bf 00 00 00 00       	mov    $0x0,%edi
  80375b:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803767:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80376b:	48 89 c6             	mov    %rax,%rsi
  80376e:	bf 00 00 00 00       	mov    $0x0,%edi
  803773:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  80377a:	00 00 00 
  80377d:	ff d0                	callq  *%rax
	return r;
  80377f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803782:	c9                   	leaveq 
  803783:	c3                   	retq   

0000000000803784 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803784:	55                   	push   %rbp
  803785:	48 89 e5             	mov    %rsp,%rbp
  803788:	48 83 ec 40          	sub    $0x40,%rsp
  80378c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80378f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803793:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803797:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80379b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80379e:	48 89 d6             	mov    %rdx,%rsi
  8037a1:	89 c7                	mov    %eax,%edi
  8037a3:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  8037aa:	00 00 00 
  8037ad:	ff d0                	callq  *%rax
  8037af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b6:	78 24                	js     8037dc <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8037b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bc:	8b 00                	mov    (%rax),%eax
  8037be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037c2:	48 89 d6             	mov    %rdx,%rsi
  8037c5:	89 c7                	mov    %eax,%edi
  8037c7:	48 b8 ab 34 80 00 00 	movabs $0x8034ab,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
  8037d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037da:	79 05                	jns    8037e1 <read+0x5d>
		return r;
  8037dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037df:	eb 76                	jmp    803857 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8037e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e5:	8b 40 08             	mov    0x8(%rax),%eax
  8037e8:	83 e0 03             	and    $0x3,%eax
  8037eb:	83 f8 01             	cmp    $0x1,%eax
  8037ee:	75 3a                	jne    80382a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8037f0:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8037f7:	00 00 00 
  8037fa:	48 8b 00             	mov    (%rax),%rax
  8037fd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803803:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803806:	89 c6                	mov    %eax,%esi
  803808:	48 bf 8f 67 80 00 00 	movabs $0x80678f,%rdi
  80380f:	00 00 00 
  803812:	b8 00 00 00 00       	mov    $0x0,%eax
  803817:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  80381e:	00 00 00 
  803821:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803828:	eb 2d                	jmp    803857 <read+0xd3>
	}
	if (!dev->dev_read)
  80382a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382e:	48 8b 40 10          	mov    0x10(%rax),%rax
  803832:	48 85 c0             	test   %rax,%rax
  803835:	75 07                	jne    80383e <read+0xba>
		return -E_NOT_SUPP;
  803837:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80383c:	eb 19                	jmp    803857 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80383e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803842:	48 8b 40 10          	mov    0x10(%rax),%rax
  803846:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80384a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80384e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803852:	48 89 cf             	mov    %rcx,%rdi
  803855:	ff d0                	callq  *%rax
}
  803857:	c9                   	leaveq 
  803858:	c3                   	retq   

0000000000803859 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803859:	55                   	push   %rbp
  80385a:	48 89 e5             	mov    %rsp,%rbp
  80385d:	48 83 ec 30          	sub    $0x30,%rsp
  803861:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803864:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803868:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80386c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803873:	eb 49                	jmp    8038be <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	48 98                	cltq   
  80387a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80387e:	48 29 c2             	sub    %rax,%rdx
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803884:	48 63 c8             	movslq %eax,%rcx
  803887:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388b:	48 01 c1             	add    %rax,%rcx
  80388e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803891:	48 89 ce             	mov    %rcx,%rsi
  803894:	89 c7                	mov    %eax,%edi
  803896:	48 b8 84 37 80 00 00 	movabs $0x803784,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
  8038a2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8038a5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038a9:	79 05                	jns    8038b0 <readn+0x57>
			return m;
  8038ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ae:	eb 1c                	jmp    8038cc <readn+0x73>
		if (m == 0)
  8038b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038b4:	75 02                	jne    8038b8 <readn+0x5f>
			break;
  8038b6:	eb 11                	jmp    8038c9 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8038b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038bb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c1:	48 98                	cltq   
  8038c3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8038c7:	72 ac                	jb     803875 <readn+0x1c>
	}
	return tot;
  8038c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038cc:	c9                   	leaveq 
  8038cd:	c3                   	retq   

00000000008038ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8038ce:	55                   	push   %rbp
  8038cf:	48 89 e5             	mov    %rsp,%rbp
  8038d2:	48 83 ec 40          	sub    $0x40,%rsp
  8038d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8038d9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038dd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8038e1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038e8:	48 89 d6             	mov    %rdx,%rsi
  8038eb:	89 c7                	mov    %eax,%edi
  8038ed:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
  8038f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803900:	78 24                	js     803926 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803906:	8b 00                	mov    (%rax),%eax
  803908:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80390c:	48 89 d6             	mov    %rdx,%rsi
  80390f:	89 c7                	mov    %eax,%edi
  803911:	48 b8 ab 34 80 00 00 	movabs $0x8034ab,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803924:	79 05                	jns    80392b <write+0x5d>
		return r;
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	eb 75                	jmp    8039a0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80392b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392f:	8b 40 08             	mov    0x8(%rax),%eax
  803932:	83 e0 03             	and    $0x3,%eax
  803935:	85 c0                	test   %eax,%eax
  803937:	75 3a                	jne    803973 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803939:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803940:	00 00 00 
  803943:	48 8b 00             	mov    (%rax),%rax
  803946:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80394c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80394f:	89 c6                	mov    %eax,%esi
  803951:	48 bf ab 67 80 00 00 	movabs $0x8067ab,%rdi
  803958:	00 00 00 
  80395b:	b8 00 00 00 00       	mov    $0x0,%eax
  803960:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  803967:	00 00 00 
  80396a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80396c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803971:	eb 2d                	jmp    8039a0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803977:	48 8b 40 18          	mov    0x18(%rax),%rax
  80397b:	48 85 c0             	test   %rax,%rax
  80397e:	75 07                	jne    803987 <write+0xb9>
		return -E_NOT_SUPP;
  803980:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803985:	eb 19                	jmp    8039a0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80398f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803993:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803997:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80399b:	48 89 cf             	mov    %rcx,%rdi
  80399e:	ff d0                	callq  *%rax
}
  8039a0:	c9                   	leaveq 
  8039a1:	c3                   	retq   

00000000008039a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8039a2:	55                   	push   %rbp
  8039a3:	48 89 e5             	mov    %rsp,%rbp
  8039a6:	48 83 ec 18          	sub    $0x18,%rsp
  8039aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039ad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b7:	48 89 d6             	mov    %rdx,%rsi
  8039ba:	89 c7                	mov    %eax,%edi
  8039bc:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  8039c3:	00 00 00 
  8039c6:	ff d0                	callq  *%rax
  8039c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cf:	79 05                	jns    8039d6 <seek+0x34>
		return r;
  8039d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d4:	eb 0f                	jmp    8039e5 <seek+0x43>
	fd->fd_offset = offset;
  8039d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039dd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8039e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e5:	c9                   	leaveq 
  8039e6:	c3                   	retq   

00000000008039e7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8039e7:	55                   	push   %rbp
  8039e8:	48 89 e5             	mov    %rsp,%rbp
  8039eb:	48 83 ec 30          	sub    $0x30,%rsp
  8039ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039f2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8039f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039fc:	48 89 d6             	mov    %rdx,%rsi
  8039ff:	89 c7                	mov    %eax,%edi
  803a01:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
  803a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a14:	78 24                	js     803a3a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a1a:	8b 00                	mov    (%rax),%eax
  803a1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a20:	48 89 d6             	mov    %rdx,%rsi
  803a23:	89 c7                	mov    %eax,%edi
  803a25:	48 b8 ab 34 80 00 00 	movabs $0x8034ab,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
  803a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a38:	79 05                	jns    803a3f <ftruncate+0x58>
		return r;
  803a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3d:	eb 72                	jmp    803ab1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a43:	8b 40 08             	mov    0x8(%rax),%eax
  803a46:	83 e0 03             	and    $0x3,%eax
  803a49:	85 c0                	test   %eax,%eax
  803a4b:	75 3a                	jne    803a87 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803a4d:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803a54:	00 00 00 
  803a57:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803a5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a63:	89 c6                	mov    %eax,%esi
  803a65:	48 bf c8 67 80 00 00 	movabs $0x8067c8,%rdi
  803a6c:	00 00 00 
  803a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a74:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  803a7b:	00 00 00 
  803a7e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803a80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803a85:	eb 2a                	jmp    803ab1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8b:	48 8b 40 30          	mov    0x30(%rax),%rax
  803a8f:	48 85 c0             	test   %rax,%rax
  803a92:	75 07                	jne    803a9b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803a94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803a99:	eb 16                	jmp    803ab1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803a9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aa7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803aaa:	89 ce                	mov    %ecx,%esi
  803aac:	48 89 d7             	mov    %rdx,%rdi
  803aaf:	ff d0                	callq  *%rax
}
  803ab1:	c9                   	leaveq 
  803ab2:	c3                   	retq   

0000000000803ab3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803ab3:	55                   	push   %rbp
  803ab4:	48 89 e5             	mov    %rsp,%rbp
  803ab7:	48 83 ec 30          	sub    $0x30,%rsp
  803abb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803abe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803ac2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ac6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ac9:	48 89 d6             	mov    %rdx,%rsi
  803acc:	89 c7                	mov    %eax,%edi
  803ace:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
  803ada:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803add:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae1:	78 24                	js     803b07 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae7:	8b 00                	mov    (%rax),%eax
  803ae9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803aed:	48 89 d6             	mov    %rdx,%rsi
  803af0:	89 c7                	mov    %eax,%edi
  803af2:	48 b8 ab 34 80 00 00 	movabs $0x8034ab,%rax
  803af9:	00 00 00 
  803afc:	ff d0                	callq  *%rax
  803afe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b05:	79 05                	jns    803b0c <fstat+0x59>
		return r;
  803b07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0a:	eb 5e                	jmp    803b6a <fstat+0xb7>
	if (!dev->dev_stat)
  803b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b10:	48 8b 40 28          	mov    0x28(%rax),%rax
  803b14:	48 85 c0             	test   %rax,%rax
  803b17:	75 07                	jne    803b20 <fstat+0x6d>
		return -E_NOT_SUPP;
  803b19:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b1e:	eb 4a                	jmp    803b6a <fstat+0xb7>
	stat->st_name[0] = 0;
  803b20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b24:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803b27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803b32:	00 00 00 
	stat->st_isdir = 0;
  803b35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b40:	00 00 00 
	stat->st_dev = dev;
  803b43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b4b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b56:	48 8b 40 28          	mov    0x28(%rax),%rax
  803b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b5e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803b62:	48 89 ce             	mov    %rcx,%rsi
  803b65:	48 89 d7             	mov    %rdx,%rdi
  803b68:	ff d0                	callq  *%rax
}
  803b6a:	c9                   	leaveq 
  803b6b:	c3                   	retq   

0000000000803b6c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803b6c:	55                   	push   %rbp
  803b6d:	48 89 e5             	mov    %rsp,%rbp
  803b70:	48 83 ec 20          	sub    $0x20,%rsp
  803b74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b80:	be 00 00 00 00       	mov    $0x0,%esi
  803b85:	48 89 c7             	mov    %rax,%rdi
  803b88:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  803b8f:	00 00 00 
  803b92:	ff d0                	callq  *%rax
  803b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b9b:	79 05                	jns    803ba2 <stat+0x36>
		return fd;
  803b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba0:	eb 2f                	jmp    803bd1 <stat+0x65>
	r = fstat(fd, stat);
  803ba2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba9:	48 89 d6             	mov    %rdx,%rsi
  803bac:	89 c7                	mov    %eax,%edi
  803bae:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803bb5:	00 00 00 
  803bb8:	ff d0                	callq  *%rax
  803bba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc0:	89 c7                	mov    %eax,%edi
  803bc2:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
	return r;
  803bce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803bd1:	c9                   	leaveq 
  803bd2:	c3                   	retq   

0000000000803bd3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803bd3:	55                   	push   %rbp
  803bd4:	48 89 e5             	mov    %rsp,%rbp
  803bd7:	48 83 ec 10          	sub    $0x10,%rsp
  803bdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803be2:	48 b8 40 94 80 00 00 	movabs $0x809440,%rax
  803be9:	00 00 00 
  803bec:	8b 00                	mov    (%rax),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	75 1f                	jne    803c11 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803bf2:	bf 01 00 00 00       	mov    $0x1,%edi
  803bf7:	48 b8 28 5e 80 00 00 	movabs $0x805e28,%rax
  803bfe:	00 00 00 
  803c01:	ff d0                	callq  *%rax
  803c03:	89 c2                	mov    %eax,%edx
  803c05:	48 b8 40 94 80 00 00 	movabs $0x809440,%rax
  803c0c:	00 00 00 
  803c0f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803c11:	48 b8 40 94 80 00 00 	movabs $0x809440,%rax
  803c18:	00 00 00 
  803c1b:	8b 00                	mov    (%rax),%eax
  803c1d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803c20:	b9 07 00 00 00       	mov    $0x7,%ecx
  803c25:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803c2c:	00 00 00 
  803c2f:	89 c7                	mov    %eax,%edi
  803c31:	48 b8 9b 5c 80 00 00 	movabs $0x805c9b,%rax
  803c38:	00 00 00 
  803c3b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c41:	ba 00 00 00 00       	mov    $0x0,%edx
  803c46:	48 89 c6             	mov    %rax,%rsi
  803c49:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4e:	48 b8 5d 5c 80 00 00 	movabs $0x805c5d,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
}
  803c5a:	c9                   	leaveq 
  803c5b:	c3                   	retq   

0000000000803c5c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803c5c:	55                   	push   %rbp
  803c5d:	48 89 e5             	mov    %rsp,%rbp
  803c60:	48 83 ec 10          	sub    $0x10,%rsp
  803c64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c68:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  803c6b:	48 ba ee 67 80 00 00 	movabs $0x8067ee,%rdx
  803c72:	00 00 00 
  803c75:	be 4c 00 00 00       	mov    $0x4c,%esi
  803c7a:	48 bf 03 68 80 00 00 	movabs $0x806803,%rdi
  803c81:	00 00 00 
  803c84:	b8 00 00 00 00       	mov    $0x0,%eax
  803c89:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  803c90:	00 00 00 
  803c93:	ff d1                	callq  *%rcx

0000000000803c95 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803c95:	55                   	push   %rbp
  803c96:	48 89 e5             	mov    %rsp,%rbp
  803c99:	48 83 ec 10          	sub    $0x10,%rsp
  803c9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca5:	8b 50 0c             	mov    0xc(%rax),%edx
  803ca8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803caf:	00 00 00 
  803cb2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803cb4:	be 00 00 00 00       	mov    $0x0,%esi
  803cb9:	bf 06 00 00 00       	mov    $0x6,%edi
  803cbe:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  803cc5:	00 00 00 
  803cc8:	ff d0                	callq  *%rax
}
  803cca:	c9                   	leaveq 
  803ccb:	c3                   	retq   

0000000000803ccc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803ccc:	55                   	push   %rbp
  803ccd:	48 89 e5             	mov    %rsp,%rbp
  803cd0:	48 83 ec 20          	sub    $0x20,%rsp
  803cd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cdc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  803ce0:	48 ba 0e 68 80 00 00 	movabs $0x80680e,%rdx
  803ce7:	00 00 00 
  803cea:	be 6b 00 00 00       	mov    $0x6b,%esi
  803cef:	48 bf 03 68 80 00 00 	movabs $0x806803,%rdi
  803cf6:	00 00 00 
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfe:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  803d05:	00 00 00 
  803d08:	ff d1                	callq  *%rcx

0000000000803d0a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803d0a:	55                   	push   %rbp
  803d0b:	48 89 e5             	mov    %rsp,%rbp
  803d0e:	48 83 ec 20          	sub    $0x20,%rsp
  803d12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  803d1e:	48 ba 2b 68 80 00 00 	movabs $0x80682b,%rdx
  803d25:	00 00 00 
  803d28:	be 7b 00 00 00       	mov    $0x7b,%esi
  803d2d:	48 bf 03 68 80 00 00 	movabs $0x806803,%rdi
  803d34:	00 00 00 
  803d37:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3c:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  803d43:	00 00 00 
  803d46:	ff d1                	callq  *%rcx

0000000000803d48 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803d48:	55                   	push   %rbp
  803d49:	48 89 e5             	mov    %rsp,%rbp
  803d4c:	48 83 ec 20          	sub    $0x20,%rsp
  803d50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5c:	8b 50 0c             	mov    0xc(%rax),%edx
  803d5f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d66:	00 00 00 
  803d69:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803d6b:	be 00 00 00 00       	mov    $0x0,%esi
  803d70:	bf 05 00 00 00       	mov    $0x5,%edi
  803d75:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  803d7c:	00 00 00 
  803d7f:	ff d0                	callq  *%rax
  803d81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d88:	79 05                	jns    803d8f <devfile_stat+0x47>
		return r;
  803d8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8d:	eb 56                	jmp    803de5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803d8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d93:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803d9a:	00 00 00 
  803d9d:	48 89 c7             	mov    %rax,%rdi
  803da0:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  803da7:	00 00 00 
  803daa:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803dac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803db3:	00 00 00 
  803db6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803dbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803dc6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803dcd:	00 00 00 
  803dd0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803dd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dda:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803de5:	c9                   	leaveq 
  803de6:	c3                   	retq   

0000000000803de7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803de7:	55                   	push   %rbp
  803de8:	48 89 e5             	mov    %rsp,%rbp
  803deb:	48 83 ec 10          	sub    $0x10,%rsp
  803def:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803df3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803df6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dfa:	8b 50 0c             	mov    0xc(%rax),%edx
  803dfd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803e04:	00 00 00 
  803e07:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803e09:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803e10:	00 00 00 
  803e13:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e16:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803e19:	be 00 00 00 00       	mov    $0x0,%esi
  803e1e:	bf 02 00 00 00       	mov    $0x2,%edi
  803e23:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  803e2a:	00 00 00 
  803e2d:	ff d0                	callq  *%rax
}
  803e2f:	c9                   	leaveq 
  803e30:	c3                   	retq   

0000000000803e31 <remove>:

// Delete a file
int
remove(const char *path)
{
  803e31:	55                   	push   %rbp
  803e32:	48 89 e5             	mov    %rsp,%rbp
  803e35:	48 83 ec 10          	sub    $0x10,%rsp
  803e39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e41:	48 89 c7             	mov    %rax,%rdi
  803e44:	48 b8 aa 21 80 00 00 	movabs $0x8021aa,%rax
  803e4b:	00 00 00 
  803e4e:	ff d0                	callq  *%rax
  803e50:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803e55:	7e 07                	jle    803e5e <remove+0x2d>
		return -E_BAD_PATH;
  803e57:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803e5c:	eb 33                	jmp    803e91 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e62:	48 89 c6             	mov    %rax,%rsi
  803e65:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803e6c:	00 00 00 
  803e6f:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  803e76:	00 00 00 
  803e79:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803e7b:	be 00 00 00 00       	mov    $0x0,%esi
  803e80:	bf 07 00 00 00       	mov    $0x7,%edi
  803e85:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  803e8c:	00 00 00 
  803e8f:	ff d0                	callq  *%rax
}
  803e91:	c9                   	leaveq 
  803e92:	c3                   	retq   

0000000000803e93 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803e93:	55                   	push   %rbp
  803e94:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803e97:	be 00 00 00 00       	mov    $0x0,%esi
  803e9c:	bf 08 00 00 00       	mov    $0x8,%edi
  803ea1:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
}
  803ead:	5d                   	pop    %rbp
  803eae:	c3                   	retq   

0000000000803eaf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803eaf:	55                   	push   %rbp
  803eb0:	48 89 e5             	mov    %rsp,%rbp
  803eb3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803eba:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803ec1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803ec8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803ecf:	be 00 00 00 00       	mov    $0x0,%esi
  803ed4:	48 89 c7             	mov    %rax,%rdi
  803ed7:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  803ede:	00 00 00 
  803ee1:	ff d0                	callq  *%rax
  803ee3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803ee6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eea:	79 28                	jns    803f14 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eef:	89 c6                	mov    %eax,%esi
  803ef1:	48 bf 49 68 80 00 00 	movabs $0x806849,%rdi
  803ef8:	00 00 00 
  803efb:	b8 00 00 00 00       	mov    $0x0,%eax
  803f00:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  803f07:	00 00 00 
  803f0a:	ff d2                	callq  *%rdx
		return fd_src;
  803f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0f:	e9 74 01 00 00       	jmpq   804088 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803f14:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803f1b:	be 01 01 00 00       	mov    $0x101,%esi
  803f20:	48 89 c7             	mov    %rax,%rdi
  803f23:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  803f2a:	00 00 00 
  803f2d:	ff d0                	callq  *%rax
  803f2f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803f32:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803f36:	79 39                	jns    803f71 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803f38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f3b:	89 c6                	mov    %eax,%esi
  803f3d:	48 bf 5f 68 80 00 00 	movabs $0x80685f,%rdi
  803f44:	00 00 00 
  803f47:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4c:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  803f53:	00 00 00 
  803f56:	ff d2                	callq  *%rdx
		close(fd_src);
  803f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5b:	89 c7                	mov    %eax,%edi
  803f5d:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  803f64:	00 00 00 
  803f67:	ff d0                	callq  *%rax
		return fd_dest;
  803f69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f6c:	e9 17 01 00 00       	jmpq   804088 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803f71:	eb 74                	jmp    803fe7 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803f73:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f76:	48 63 d0             	movslq %eax,%rdx
  803f79:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803f80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f83:	48 89 ce             	mov    %rcx,%rsi
  803f86:	89 c7                	mov    %eax,%edi
  803f88:	48 b8 ce 38 80 00 00 	movabs $0x8038ce,%rax
  803f8f:	00 00 00 
  803f92:	ff d0                	callq  *%rax
  803f94:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803f9b:	79 4a                	jns    803fe7 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803f9d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803fa0:	89 c6                	mov    %eax,%esi
  803fa2:	48 bf 79 68 80 00 00 	movabs $0x806879,%rdi
  803fa9:	00 00 00 
  803fac:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb1:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  803fb8:	00 00 00 
  803fbb:	ff d2                	callq  *%rdx
			close(fd_src);
  803fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc0:	89 c7                	mov    %eax,%edi
  803fc2:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  803fc9:	00 00 00 
  803fcc:	ff d0                	callq  *%rax
			close(fd_dest);
  803fce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fd1:	89 c7                	mov    %eax,%edi
  803fd3:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  803fda:	00 00 00 
  803fdd:	ff d0                	callq  *%rax
			return write_size;
  803fdf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803fe2:	e9 a1 00 00 00       	jmpq   804088 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803fe7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff1:	ba 00 02 00 00       	mov    $0x200,%edx
  803ff6:	48 89 ce             	mov    %rcx,%rsi
  803ff9:	89 c7                	mov    %eax,%edi
  803ffb:	48 b8 84 37 80 00 00 	movabs $0x803784,%rax
  804002:	00 00 00 
  804005:	ff d0                	callq  *%rax
  804007:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80400a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80400e:	0f 8f 5f ff ff ff    	jg     803f73 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  804014:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804018:	79 47                	jns    804061 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80401a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80401d:	89 c6                	mov    %eax,%esi
  80401f:	48 bf 8c 68 80 00 00 	movabs $0x80688c,%rdi
  804026:	00 00 00 
  804029:	b8 00 00 00 00       	mov    $0x0,%eax
  80402e:	48 ba 22 15 80 00 00 	movabs $0x801522,%rdx
  804035:	00 00 00 
  804038:	ff d2                	callq  *%rdx
		close(fd_src);
  80403a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403d:	89 c7                	mov    %eax,%edi
  80403f:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
		close(fd_dest);
  80404b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80404e:	89 c7                	mov    %eax,%edi
  804050:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  804057:	00 00 00 
  80405a:	ff d0                	callq  *%rax
		return read_size;
  80405c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80405f:	eb 27                	jmp    804088 <copy+0x1d9>
	}
	close(fd_src);
  804061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804064:	89 c7                	mov    %eax,%edi
  804066:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  80406d:	00 00 00 
  804070:	ff d0                	callq  *%rax
	close(fd_dest);
  804072:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804075:	89 c7                	mov    %eax,%edi
  804077:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  80407e:	00 00 00 
  804081:	ff d0                	callq  *%rax
	return 0;
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  804088:	c9                   	leaveq 
  804089:	c3                   	retq   

000000000080408a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80408a:	55                   	push   %rbp
  80408b:	48 89 e5             	mov    %rsp,%rbp
  80408e:	48 83 ec 20          	sub    $0x20,%rsp
  804092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  804096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80409a:	8b 40 0c             	mov    0xc(%rax),%eax
  80409d:	85 c0                	test   %eax,%eax
  80409f:	7e 67                	jle    804108 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8040a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a5:	8b 40 04             	mov    0x4(%rax),%eax
  8040a8:	48 63 d0             	movslq %eax,%rdx
  8040ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040af:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8040b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040b7:	8b 00                	mov    (%rax),%eax
  8040b9:	48 89 ce             	mov    %rcx,%rsi
  8040bc:	89 c7                	mov    %eax,%edi
  8040be:	48 b8 ce 38 80 00 00 	movabs $0x8038ce,%rax
  8040c5:	00 00 00 
  8040c8:	ff d0                	callq  *%rax
  8040ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8040cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d1:	7e 13                	jle    8040e6 <writebuf+0x5c>
			b->result += result;
  8040d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d7:	8b 50 08             	mov    0x8(%rax),%edx
  8040da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040dd:	01 c2                	add    %eax,%edx
  8040df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e3:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8040e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ea:	8b 40 04             	mov    0x4(%rax),%eax
  8040ed:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8040f0:	74 16                	je     804108 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8040f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040fb:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8040ff:	89 c2                	mov    %eax,%edx
  804101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804105:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  804108:	c9                   	leaveq 
  804109:	c3                   	retq   

000000000080410a <putch>:

static void
putch(int ch, void *thunk)
{
  80410a:	55                   	push   %rbp
  80410b:	48 89 e5             	mov    %rsp,%rbp
  80410e:	48 83 ec 20          	sub    $0x20,%rsp
  804112:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804115:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  804119:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80411d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  804121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804125:	8b 40 04             	mov    0x4(%rax),%eax
  804128:	8d 48 01             	lea    0x1(%rax),%ecx
  80412b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80412f:	89 4a 04             	mov    %ecx,0x4(%rdx)
  804132:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804135:	89 d1                	mov    %edx,%ecx
  804137:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80413b:	48 98                	cltq   
  80413d:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  804141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804145:	8b 40 04             	mov    0x4(%rax),%eax
  804148:	3d 00 01 00 00       	cmp    $0x100,%eax
  80414d:	75 1e                	jne    80416d <putch+0x63>
		writebuf(b);
  80414f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804153:	48 89 c7             	mov    %rax,%rdi
  804156:	48 b8 8a 40 80 00 00 	movabs $0x80408a,%rax
  80415d:	00 00 00 
  804160:	ff d0                	callq  *%rax
		b->idx = 0;
  804162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80416d:	c9                   	leaveq 
  80416e:	c3                   	retq   

000000000080416f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80416f:	55                   	push   %rbp
  804170:	48 89 e5             	mov    %rsp,%rbp
  804173:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80417a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804180:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804187:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80418e:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804194:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80419a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8041a1:	00 00 00 
	b.result = 0;
  8041a4:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8041ab:	00 00 00 
	b.error = 1;
  8041ae:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8041b5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8041b8:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8041bf:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8041c6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8041cd:	48 89 c6             	mov    %rax,%rsi
  8041d0:	48 bf 0a 41 80 00 00 	movabs $0x80410a,%rdi
  8041d7:	00 00 00 
  8041da:	48 b8 c1 18 80 00 00 	movabs $0x8018c1,%rax
  8041e1:	00 00 00 
  8041e4:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8041e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8041ec:	85 c0                	test   %eax,%eax
  8041ee:	7e 16                	jle    804206 <vfprintf+0x97>
		writebuf(&b);
  8041f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8041f7:	48 89 c7             	mov    %rax,%rdi
  8041fa:	48 b8 8a 40 80 00 00 	movabs $0x80408a,%rax
  804201:	00 00 00 
  804204:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  804206:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80420c:	85 c0                	test   %eax,%eax
  80420e:	74 08                	je     804218 <vfprintf+0xa9>
  804210:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804216:	eb 06                	jmp    80421e <vfprintf+0xaf>
  804218:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80421e:	c9                   	leaveq 
  80421f:	c3                   	retq   

0000000000804220 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804220:	55                   	push   %rbp
  804221:	48 89 e5             	mov    %rsp,%rbp
  804224:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80422b:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804231:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804238:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80423f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804246:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80424d:	84 c0                	test   %al,%al
  80424f:	74 20                	je     804271 <fprintf+0x51>
  804251:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804255:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804259:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80425d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804261:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804265:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804269:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80426d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804271:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804278:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80427f:	00 00 00 
  804282:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804289:	00 00 00 
  80428c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804290:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804297:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80429e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8042a5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8042ac:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8042b3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8042b9:	48 89 ce             	mov    %rcx,%rsi
  8042bc:	89 c7                	mov    %eax,%edi
  8042be:	48 b8 6f 41 80 00 00 	movabs $0x80416f,%rax
  8042c5:	00 00 00 
  8042c8:	ff d0                	callq  *%rax
  8042ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8042d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8042d6:	c9                   	leaveq 
  8042d7:	c3                   	retq   

00000000008042d8 <printf>:

int
printf(const char *fmt, ...)
{
  8042d8:	55                   	push   %rbp
  8042d9:	48 89 e5             	mov    %rsp,%rbp
  8042dc:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8042e3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8042ea:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8042f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8042f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8042ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804306:	84 c0                	test   %al,%al
  804308:	74 20                	je     80432a <printf+0x52>
  80430a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80430e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804312:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804316:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80431a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80431e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804322:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804326:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80432a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804331:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804338:	00 00 00 
  80433b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804342:	00 00 00 
  804345:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804349:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804350:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804357:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80435e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804365:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80436c:	48 89 c6             	mov    %rax,%rsi
  80436f:	bf 01 00 00 00       	mov    $0x1,%edi
  804374:	48 b8 6f 41 80 00 00 	movabs $0x80416f,%rax
  80437b:	00 00 00 
  80437e:	ff d0                	callq  *%rax
  804380:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804386:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80438c:	c9                   	leaveq 
  80438d:	c3                   	retq   

000000000080438e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80438e:	55                   	push   %rbp
  80438f:	48 89 e5             	mov    %rsp,%rbp
  804392:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  804399:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8043a0:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8043a7:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8043ae:	be 00 00 00 00       	mov    $0x0,%esi
  8043b3:	48 89 c7             	mov    %rax,%rdi
  8043b6:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  8043bd:	00 00 00 
  8043c0:	ff d0                	callq  *%rax
  8043c2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8043c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8043c9:	79 08                	jns    8043d3 <spawn+0x45>
		return r;
  8043cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8043ce:	e9 12 03 00 00       	jmpq   8046e5 <spawn+0x357>
	fd = r;
  8043d3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8043d6:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8043d9:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8043e0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8043e4:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8043eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8043ee:	ba 00 02 00 00       	mov    $0x200,%edx
  8043f3:	48 89 ce             	mov    %rcx,%rsi
  8043f6:	89 c7                	mov    %eax,%edi
  8043f8:	48 b8 59 38 80 00 00 	movabs $0x803859,%rax
  8043ff:	00 00 00 
  804402:	ff d0                	callq  *%rax
  804404:	3d 00 02 00 00       	cmp    $0x200,%eax
  804409:	75 0d                	jne    804418 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80440b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440f:	8b 00                	mov    (%rax),%eax
  804411:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804416:	74 43                	je     80445b <spawn+0xcd>
		close(fd);
  804418:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80441b:	89 c7                	mov    %eax,%edi
  80441d:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  804424:	00 00 00 
  804427:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80442d:	8b 00                	mov    (%rax),%eax
  80442f:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804434:	89 c6                	mov    %eax,%esi
  804436:	48 bf a8 68 80 00 00 	movabs $0x8068a8,%rdi
  80443d:	00 00 00 
  804440:	b8 00 00 00 00       	mov    $0x0,%eax
  804445:	48 b9 22 15 80 00 00 	movabs $0x801522,%rcx
  80444c:	00 00 00 
  80444f:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804451:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804456:	e9 8a 02 00 00       	jmpq   8046e5 <spawn+0x357>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80445b:	b8 07 00 00 00       	mov    $0x7,%eax
  804460:	cd 30                	int    $0x30
  804462:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804465:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804468:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80446b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80446f:	79 08                	jns    804479 <spawn+0xeb>
		return r;
  804471:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804474:	e9 6c 02 00 00       	jmpq   8046e5 <spawn+0x357>
	child = r;
  804479:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80447c:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80447f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804482:	25 ff 03 00 00       	and    $0x3ff,%eax
  804487:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80448e:	00 00 00 
  804491:	48 98                	cltq   
  804493:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80449a:	48 01 c2             	add    %rax,%rdx
  80449d:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8044a4:	48 89 d6             	mov    %rdx,%rsi
  8044a7:	ba 18 00 00 00       	mov    $0x18,%edx
  8044ac:	48 89 c7             	mov    %rax,%rdi
  8044af:	48 89 d1             	mov    %rdx,%rcx
  8044b2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8044b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8044bd:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8044c4:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8044cb:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8044d2:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8044d9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8044dc:	48 89 ce             	mov    %rcx,%rsi
  8044df:	89 c7                	mov    %eax,%edi
  8044e1:	48 b8 49 49 80 00 00 	movabs $0x804949,%rax
  8044e8:	00 00 00 
  8044eb:	ff d0                	callq  *%rax
  8044ed:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8044f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8044f4:	79 08                	jns    8044fe <spawn+0x170>
		return r;
  8044f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8044f9:	e9 e7 01 00 00       	jmpq   8046e5 <spawn+0x357>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8044fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804502:	48 8b 40 20          	mov    0x20(%rax),%rax
  804506:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80450d:	48 01 d0             	add    %rdx,%rax
  804510:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80451b:	e9 a9 00 00 00       	jmpq   8045c9 <spawn+0x23b>
		if (ph->p_type != ELF_PROG_LOAD)
  804520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804524:	8b 00                	mov    (%rax),%eax
  804526:	83 f8 01             	cmp    $0x1,%eax
  804529:	74 05                	je     804530 <spawn+0x1a2>
			continue;
  80452b:	e9 90 00 00 00       	jmpq   8045c0 <spawn+0x232>
		perm = PTE_P | PTE_U;
  804530:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80453b:	8b 40 04             	mov    0x4(%rax),%eax
  80453e:	83 e0 02             	and    $0x2,%eax
  804541:	85 c0                	test   %eax,%eax
  804543:	74 04                	je     804549 <spawn+0x1bb>
			perm |= PTE_W;
  804545:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454d:	48 8b 40 08          	mov    0x8(%rax),%rax
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804551:	41 89 c1             	mov    %eax,%r9d
  804554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804558:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80455c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804560:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804568:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80456c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80456f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804572:	48 83 ec 08          	sub    $0x8,%rsp
  804576:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804579:	57                   	push   %rdi
  80457a:	89 c7                	mov    %eax,%edi
  80457c:	48 b8 f5 4b 80 00 00 	movabs $0x804bf5,%rax
  804583:	00 00 00 
  804586:	ff d0                	callq  *%rax
  804588:	48 83 c4 10          	add    $0x10,%rsp
  80458c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80458f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804593:	79 2b                	jns    8045c0 <spawn+0x232>
			goto error;
  804595:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804596:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804599:	89 c7                	mov    %eax,%edi
  80459b:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  8045a2:	00 00 00 
  8045a5:	ff d0                	callq  *%rax
	close(fd);
  8045a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8045aa:	89 c7                	mov    %eax,%edi
  8045ac:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8045b3:	00 00 00 
  8045b6:	ff d0                	callq  *%rax
	return r;
  8045b8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8045bb:	e9 25 01 00 00       	jmpq   8046e5 <spawn+0x357>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8045c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8045c4:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8045c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045cd:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8045d1:	0f b7 c0             	movzwl %ax,%eax
  8045d4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8045d7:	0f 8f 43 ff ff ff    	jg     804520 <spawn+0x192>
	close(fd);
  8045dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8045e0:	89 c7                	mov    %eax,%edi
  8045e2:	48 b8 62 35 80 00 00 	movabs $0x803562,%rax
  8045e9:	00 00 00 
  8045ec:	ff d0                	callq  *%rax
	fd = -1;
  8045ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
	if ((r = copy_shared_pages(child)) < 0)
  8045f5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8045f8:	89 c7                	mov    %eax,%edi
  8045fa:	48 b8 e1 4d 80 00 00 	movabs $0x804de1,%rax
  804601:	00 00 00 
  804604:	ff d0                	callq  *%rax
  804606:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804609:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80460d:	79 30                	jns    80463f <spawn+0x2b1>
		panic("copy_shared_pages: %e", r);
  80460f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804612:	89 c1                	mov    %eax,%ecx
  804614:	48 ba c2 68 80 00 00 	movabs $0x8068c2,%rdx
  80461b:	00 00 00 
  80461e:	be 82 00 00 00       	mov    $0x82,%esi
  804623:	48 bf d8 68 80 00 00 	movabs $0x8068d8,%rdi
  80462a:	00 00 00 
  80462d:	b8 00 00 00 00       	mov    $0x0,%eax
  804632:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  804639:	00 00 00 
  80463c:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80463f:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804646:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804649:	48 89 d6             	mov    %rdx,%rsi
  80464c:	89 c7                	mov    %eax,%edi
  80464e:	48 b8 8e 2c 80 00 00 	movabs $0x802c8e,%rax
  804655:	00 00 00 
  804658:	ff d0                	callq  *%rax
  80465a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80465d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804661:	79 30                	jns    804693 <spawn+0x305>
		panic("sys_env_set_trapframe: %e", r);
  804663:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804666:	89 c1                	mov    %eax,%ecx
  804668:	48 ba e4 68 80 00 00 	movabs $0x8068e4,%rdx
  80466f:	00 00 00 
  804672:	be 85 00 00 00       	mov    $0x85,%esi
  804677:	48 bf d8 68 80 00 00 	movabs $0x8068d8,%rdi
  80467e:	00 00 00 
  804681:	b8 00 00 00 00       	mov    $0x0,%eax
  804686:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  80468d:	00 00 00 
  804690:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804693:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804696:	be 02 00 00 00       	mov    $0x2,%esi
  80469b:	89 c7                	mov    %eax,%edi
  80469d:	48 b8 41 2c 80 00 00 	movabs $0x802c41,%rax
  8046a4:	00 00 00 
  8046a7:	ff d0                	callq  *%rax
  8046a9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8046ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8046b0:	79 30                	jns    8046e2 <spawn+0x354>
		panic("sys_env_set_status: %e", r);
  8046b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8046b5:	89 c1                	mov    %eax,%ecx
  8046b7:	48 ba fe 68 80 00 00 	movabs $0x8068fe,%rdx
  8046be:	00 00 00 
  8046c1:	be 88 00 00 00       	mov    $0x88,%esi
  8046c6:	48 bf d8 68 80 00 00 	movabs $0x8068d8,%rdi
  8046cd:	00 00 00 
  8046d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d5:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  8046dc:	00 00 00 
  8046df:	41 ff d0             	callq  *%r8
	return child;
  8046e2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8046e5:	c9                   	leaveq 
  8046e6:	c3                   	retq   

00000000008046e7 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8046e7:	55                   	push   %rbp
  8046e8:	48 89 e5             	mov    %rsp,%rbp
  8046eb:	41 55                	push   %r13
  8046ed:	41 54                	push   %r12
  8046ef:	53                   	push   %rbx
  8046f0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8046f7:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8046fe:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804705:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  80470c:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804713:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80471a:	84 c0                	test   %al,%al
  80471c:	74 26                	je     804744 <spawnl+0x5d>
  80471e:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804725:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  80472c:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804730:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804734:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804738:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  80473c:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804740:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804744:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80474b:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804752:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804755:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80475c:	00 00 00 
  80475f:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804766:	00 00 00 
  804769:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80476d:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804774:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80477b:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804782:	eb 07                	jmp    80478b <spawnl+0xa4>
		argc++;
  804784:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	while(va_arg(vl, void *) != NULL)
  80478b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804791:	83 f8 30             	cmp    $0x30,%eax
  804794:	73 23                	jae    8047b9 <spawnl+0xd2>
  804796:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80479d:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8047a3:	89 d2                	mov    %edx,%edx
  8047a5:	48 01 d0             	add    %rdx,%rax
  8047a8:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8047ae:	83 c2 08             	add    $0x8,%edx
  8047b1:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8047b7:	eb 12                	jmp    8047cb <spawnl+0xe4>
  8047b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8047c0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8047c4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8047cb:	48 8b 00             	mov    (%rax),%rax
  8047ce:	48 85 c0             	test   %rax,%rax
  8047d1:	75 b1                	jne    804784 <spawnl+0x9d>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8047d3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8047d9:	83 c0 02             	add    $0x2,%eax
  8047dc:	48 89 e2             	mov    %rsp,%rdx
  8047df:	48 89 d3             	mov    %rdx,%rbx
  8047e2:	48 63 d0             	movslq %eax,%rdx
  8047e5:	48 83 ea 01          	sub    $0x1,%rdx
  8047e9:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8047f0:	48 63 d0             	movslq %eax,%rdx
  8047f3:	49 89 d4             	mov    %rdx,%r12
  8047f6:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8047fc:	48 63 d0             	movslq %eax,%rdx
  8047ff:	49 89 d2             	mov    %rdx,%r10
  804802:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804808:	48 98                	cltq   
  80480a:	48 c1 e0 03          	shl    $0x3,%rax
  80480e:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804812:	b8 10 00 00 00       	mov    $0x10,%eax
  804817:	48 83 e8 01          	sub    $0x1,%rax
  80481b:	48 01 d0             	add    %rdx,%rax
  80481e:	be 10 00 00 00       	mov    $0x10,%esi
  804823:	ba 00 00 00 00       	mov    $0x0,%edx
  804828:	48 f7 f6             	div    %rsi
  80482b:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80482f:	48 29 c4             	sub    %rax,%rsp
  804832:	48 89 e0             	mov    %rsp,%rax
  804835:	48 83 c0 07          	add    $0x7,%rax
  804839:	48 c1 e8 03          	shr    $0x3,%rax
  80483d:	48 c1 e0 03          	shl    $0x3,%rax
  804841:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804848:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80484f:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804856:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804859:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80485f:	8d 50 01             	lea    0x1(%rax),%edx
  804862:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804869:	48 63 d2             	movslq %edx,%rdx
  80486c:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804873:	00 

	va_start(vl, arg0);
  804874:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80487b:	00 00 00 
  80487e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804885:	00 00 00 
  804888:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80488c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804893:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80489a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8048a1:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8048a8:	00 00 00 
  8048ab:	eb 60                	jmp    80490d <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8048ad:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8048b3:	8d 48 01             	lea    0x1(%rax),%ecx
  8048b6:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8048bc:	83 f8 30             	cmp    $0x30,%eax
  8048bf:	73 23                	jae    8048e4 <spawnl+0x1fd>
  8048c1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8048c8:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8048ce:	89 d2                	mov    %edx,%edx
  8048d0:	48 01 d0             	add    %rdx,%rax
  8048d3:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8048d9:	83 c2 08             	add    $0x8,%edx
  8048dc:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8048e2:	eb 12                	jmp    8048f6 <spawnl+0x20f>
  8048e4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8048eb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8048ef:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8048f6:	48 8b 10             	mov    (%rax),%rdx
  8048f9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804900:	89 c9                	mov    %ecx,%ecx
  804902:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	for(i=0;i<argc;i++)
  804906:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80490d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804913:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804919:	77 92                	ja     8048ad <spawnl+0x1c6>
	va_end(vl);
	return spawn(prog, argv);
  80491b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804922:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804929:	48 89 d6             	mov    %rdx,%rsi
  80492c:	48 89 c7             	mov    %rax,%rdi
  80492f:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  804936:	00 00 00 
  804939:	ff d0                	callq  *%rax
  80493b:	48 89 dc             	mov    %rbx,%rsp
}
  80493e:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  804942:	5b                   	pop    %rbx
  804943:	41 5c                	pop    %r12
  804945:	41 5d                	pop    %r13
  804947:	5d                   	pop    %rbp
  804948:	c3                   	retq   

0000000000804949 <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  804949:	55                   	push   %rbp
  80494a:	48 89 e5             	mov    %rsp,%rbp
  80494d:	48 83 ec 50          	sub    $0x50,%rsp
  804951:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804954:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804958:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80495c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804963:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804964:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80496b:	eb 33                	jmp    8049a0 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80496d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804970:	48 98                	cltq   
  804972:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804979:	00 
  80497a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80497e:	48 01 d0             	add    %rdx,%rax
  804981:	48 8b 00             	mov    (%rax),%rax
  804984:	48 89 c7             	mov    %rax,%rdi
  804987:	48 b8 aa 21 80 00 00 	movabs $0x8021aa,%rax
  80498e:	00 00 00 
  804991:	ff d0                	callq  *%rax
  804993:	83 c0 01             	add    $0x1,%eax
  804996:	48 98                	cltq   
  804998:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	for (argc = 0; argv[argc] != 0; argc++)
  80499c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8049a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8049a3:	48 98                	cltq   
  8049a5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8049ac:	00 
  8049ad:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8049b1:	48 01 d0             	add    %rdx,%rax
  8049b4:	48 8b 00             	mov    (%rax),%rax
  8049b7:	48 85 c0             	test   %rax,%rax
  8049ba:	75 b1                	jne    80496d <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8049bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049c0:	48 f7 d8             	neg    %rax
  8049c3:	48 05 00 10 40 00    	add    $0x401000,%rax
  8049c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8049cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049d1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8049d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049d9:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8049dd:	48 89 c2             	mov    %rax,%rdx
  8049e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8049e3:	83 c0 01             	add    $0x1,%eax
  8049e6:	c1 e0 03             	shl    $0x3,%eax
  8049e9:	48 98                	cltq   
  8049eb:	48 f7 d8             	neg    %rax
  8049ee:	48 01 d0             	add    %rdx,%rax
  8049f1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8049f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049f9:	48 83 e8 10          	sub    $0x10,%rax
  8049fd:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804a03:	77 0a                	ja     804a0f <init_stack+0xc6>
		return -E_NO_MEM;
  804a05:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804a0a:	e9 e4 01 00 00       	jmpq   804bf3 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804a0f:	ba 07 00 00 00       	mov    $0x7,%edx
  804a14:	be 00 00 40 00       	mov    $0x400000,%esi
  804a19:	bf 00 00 00 00       	mov    $0x0,%edi
  804a1e:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  804a25:	00 00 00 
  804a28:	ff d0                	callq  *%rax
  804a2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804a2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804a31:	79 08                	jns    804a3b <init_stack+0xf2>
		return r;
  804a33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a36:	e9 b8 01 00 00       	jmpq   804bf3 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804a3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804a42:	e9 8a 00 00 00       	jmpq   804ad1 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  804a47:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804a4a:	48 98                	cltq   
  804a4c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804a53:	00 
  804a54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a58:	48 01 d0             	add    %rdx,%rax
  804a5b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804a60:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a64:	48 01 ca             	add    %rcx,%rdx
  804a67:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  804a6e:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  804a71:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804a74:	48 98                	cltq   
  804a76:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804a7d:	00 
  804a7e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804a82:	48 01 d0             	add    %rdx,%rax
  804a85:	48 8b 10             	mov    (%rax),%rdx
  804a88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a8c:	48 89 d6             	mov    %rdx,%rsi
  804a8f:	48 89 c7             	mov    %rax,%rdi
  804a92:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  804a99:	00 00 00 
  804a9c:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804a9e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804aa1:	48 98                	cltq   
  804aa3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804aaa:	00 
  804aab:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804aaf:	48 01 d0             	add    %rdx,%rax
  804ab2:	48 8b 00             	mov    (%rax),%rax
  804ab5:	48 89 c7             	mov    %rax,%rdi
  804ab8:	48 b8 aa 21 80 00 00 	movabs $0x8021aa,%rax
  804abf:	00 00 00 
  804ac2:	ff d0                	callq  *%rax
  804ac4:	83 c0 01             	add    $0x1,%eax
  804ac7:	48 98                	cltq   
  804ac9:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	for (i = 0; i < argc; i++) {
  804acd:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804ad1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ad4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804ad7:	0f 8c 6a ff ff ff    	jl     804a47 <init_stack+0xfe>
	}
	argv_store[argc] = 0;
  804add:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804ae0:	48 98                	cltq   
  804ae2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804ae9:	00 
  804aea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804aee:	48 01 d0             	add    %rdx,%rax
  804af1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804af8:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804aff:	00 
  804b00:	74 35                	je     804b37 <init_stack+0x1ee>
  804b02:	48 b9 18 69 80 00 00 	movabs $0x806918,%rcx
  804b09:	00 00 00 
  804b0c:	48 ba 3e 69 80 00 00 	movabs $0x80693e,%rdx
  804b13:	00 00 00 
  804b16:	be f1 00 00 00       	mov    $0xf1,%esi
  804b1b:	48 bf d8 68 80 00 00 	movabs $0x8068d8,%rdi
  804b22:	00 00 00 
  804b25:	b8 00 00 00 00       	mov    $0x0,%eax
  804b2a:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  804b31:	00 00 00 
  804b34:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804b37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b3b:	48 83 e8 08          	sub    $0x8,%rax
  804b3f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804b44:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804b48:	48 01 ca             	add    %rcx,%rdx
  804b4b:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  804b52:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  804b55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b59:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804b5d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804b60:	48 98                	cltq   
  804b62:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  804b65:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804b6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b6e:	48 01 d0             	add    %rdx,%rax
  804b71:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804b77:	48 89 c2             	mov    %rax,%rdx
  804b7a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804b7e:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804b81:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804b84:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804b8a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804b8f:	89 c2                	mov    %eax,%edx
  804b91:	be 00 00 40 00       	mov    $0x400000,%esi
  804b96:	bf 00 00 00 00       	mov    $0x0,%edi
  804b9b:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  804ba2:	00 00 00 
  804ba5:	ff d0                	callq  *%rax
  804ba7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bae:	79 02                	jns    804bb2 <init_stack+0x269>
		goto error;
  804bb0:	eb 28                	jmp    804bda <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804bb2:	be 00 00 40 00       	mov    $0x400000,%esi
  804bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  804bbc:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  804bc3:	00 00 00 
  804bc6:	ff d0                	callq  *%rax
  804bc8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804bcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bcf:	79 02                	jns    804bd3 <init_stack+0x28a>
		goto error;
  804bd1:	eb 07                	jmp    804bda <init_stack+0x291>

	return 0;
  804bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  804bd8:	eb 19                	jmp    804bf3 <init_stack+0x2aa>

error:
	sys_page_unmap(0, UTEMP);
  804bda:	be 00 00 40 00       	mov    $0x400000,%esi
  804bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  804be4:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  804beb:	00 00 00 
  804bee:	ff d0                	callq  *%rax
	return r;
  804bf0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804bf3:	c9                   	leaveq 
  804bf4:	c3                   	retq   

0000000000804bf5 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804bf5:	55                   	push   %rbp
  804bf6:	48 89 e5             	mov    %rsp,%rbp
  804bf9:	48 83 ec 50          	sub    $0x50,%rsp
  804bfd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804c00:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804c04:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804c08:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804c0b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804c0f:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804c13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c17:	25 ff 0f 00 00       	and    $0xfff,%eax
  804c1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c23:	74 21                	je     804c46 <map_segment+0x51>
		va -= i;
  804c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c28:	48 98                	cltq   
  804c2a:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  804c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c31:	48 98                	cltq   
  804c33:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c3a:	48 98                	cltq   
  804c3c:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  804c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c43:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804c46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c4d:	e9 79 01 00 00       	jmpq   804dcb <map_segment+0x1d6>
		if (i >= filesz) {
  804c52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c55:	48 98                	cltq   
  804c57:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  804c5b:	72 3c                	jb     804c99 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  804c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c60:	48 63 d0             	movslq %eax,%rdx
  804c63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c67:	48 01 d0             	add    %rdx,%rax
  804c6a:	48 89 c1             	mov    %rax,%rcx
  804c6d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804c70:	8b 55 10             	mov    0x10(%rbp),%edx
  804c73:	48 89 ce             	mov    %rcx,%rsi
  804c76:	89 c7                	mov    %eax,%edi
  804c78:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  804c7f:	00 00 00 
  804c82:	ff d0                	callq  *%rax
  804c84:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804c87:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804c8b:	0f 89 33 01 00 00    	jns    804dc4 <map_segment+0x1cf>
				return r;
  804c91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c94:	e9 46 01 00 00       	jmpq   804ddf <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804c99:	ba 07 00 00 00       	mov    $0x7,%edx
  804c9e:	be 00 00 40 00       	mov    $0x400000,%esi
  804ca3:	bf 00 00 00 00       	mov    $0x0,%edi
  804ca8:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  804caf:	00 00 00 
  804cb2:	ff d0                	callq  *%rax
  804cb4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804cb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804cbb:	79 08                	jns    804cc5 <map_segment+0xd0>
				return r;
  804cbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cc0:	e9 1a 01 00 00       	jmpq   804ddf <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804cc5:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ccb:	01 c2                	add    %eax,%edx
  804ccd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804cd0:	89 d6                	mov    %edx,%esi
  804cd2:	89 c7                	mov    %eax,%edi
  804cd4:	48 b8 a2 39 80 00 00 	movabs $0x8039a2,%rax
  804cdb:	00 00 00 
  804cde:	ff d0                	callq  *%rax
  804ce0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804ce3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804ce7:	79 08                	jns    804cf1 <map_segment+0xfc>
				return r;
  804ce9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cec:	e9 ee 00 00 00       	jmpq   804ddf <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804cf1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cfb:	48 98                	cltq   
  804cfd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804d01:	48 29 c2             	sub    %rax,%rdx
  804d04:	48 89 d0             	mov    %rdx,%rax
  804d07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804d0b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d0e:	48 63 d0             	movslq %eax,%rdx
  804d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d15:	48 39 c2             	cmp    %rax,%rdx
  804d18:	48 0f 47 d0          	cmova  %rax,%rdx
  804d1c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804d1f:	be 00 00 40 00       	mov    $0x400000,%esi
  804d24:	89 c7                	mov    %eax,%edi
  804d26:	48 b8 59 38 80 00 00 	movabs $0x803859,%rax
  804d2d:	00 00 00 
  804d30:	ff d0                	callq  *%rax
  804d32:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804d35:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804d39:	79 08                	jns    804d43 <map_segment+0x14e>
				return r;
  804d3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d3e:	e9 9c 00 00 00       	jmpq   804ddf <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  804d43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d46:	48 63 d0             	movslq %eax,%rdx
  804d49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804d4d:	48 01 d0             	add    %rdx,%rax
  804d50:	48 89 c2             	mov    %rax,%rdx
  804d53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804d56:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  804d5a:	48 89 d1             	mov    %rdx,%rcx
  804d5d:	89 c2                	mov    %eax,%edx
  804d5f:	be 00 00 40 00       	mov    $0x400000,%esi
  804d64:	bf 00 00 00 00       	mov    $0x0,%edi
  804d69:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  804d70:	00 00 00 
  804d73:	ff d0                	callq  *%rax
  804d75:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804d78:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804d7c:	79 30                	jns    804dae <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804d7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d81:	89 c1                	mov    %eax,%ecx
  804d83:	48 ba 53 69 80 00 00 	movabs $0x806953,%rdx
  804d8a:	00 00 00 
  804d8d:	be 24 01 00 00       	mov    $0x124,%esi
  804d92:	48 bf d8 68 80 00 00 	movabs $0x8068d8,%rdi
  804d99:	00 00 00 
  804d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  804da1:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  804da8:	00 00 00 
  804dab:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804dae:	be 00 00 40 00       	mov    $0x400000,%esi
  804db3:	bf 00 00 00 00       	mov    $0x0,%edi
  804db8:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  804dbf:	00 00 00 
  804dc2:	ff d0                	callq  *%rax
	for (i = 0; i < memsz; i += PGSIZE) {
  804dc4:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dce:	48 98                	cltq   
  804dd0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804dd4:	0f 82 78 fe ff ff    	jb     804c52 <map_segment+0x5d>
		}
	}
	return 0;
  804dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ddf:	c9                   	leaveq 
  804de0:	c3                   	retq   

0000000000804de1 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804de1:	55                   	push   %rbp
  804de2:	48 89 e5             	mov    %rsp,%rbp
  804de5:	48 83 ec 08          	sub    $0x8,%rsp
  804de9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  804dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804df1:	c9                   	leaveq 
  804df2:	c3                   	retq   

0000000000804df3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  804df3:	55                   	push   %rbp
  804df4:	48 89 e5             	mov    %rsp,%rbp
  804df7:	48 83 ec 20          	sub    $0x20,%rsp
  804dfb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804dfe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804e02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e05:	48 89 d6             	mov    %rdx,%rsi
  804e08:	89 c7                	mov    %eax,%edi
  804e0a:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  804e11:	00 00 00 
  804e14:	ff d0                	callq  *%rax
  804e16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e1d:	79 05                	jns    804e24 <fd2sockid+0x31>
		return r;
  804e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e22:	eb 24                	jmp    804e48 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  804e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e28:	8b 10                	mov    (%rax),%edx
  804e2a:	48 b8 e0 80 80 00 00 	movabs $0x8080e0,%rax
  804e31:	00 00 00 
  804e34:	8b 00                	mov    (%rax),%eax
  804e36:	39 c2                	cmp    %eax,%edx
  804e38:	74 07                	je     804e41 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  804e3a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804e3f:	eb 07                	jmp    804e48 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  804e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e45:	8b 40 0c             	mov    0xc(%rax),%eax
}
  804e48:	c9                   	leaveq 
  804e49:	c3                   	retq   

0000000000804e4a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  804e4a:	55                   	push   %rbp
  804e4b:	48 89 e5             	mov    %rsp,%rbp
  804e4e:	48 83 ec 20          	sub    $0x20,%rsp
  804e52:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  804e55:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804e59:	48 89 c7             	mov    %rax,%rdi
  804e5c:	48 b8 b8 32 80 00 00 	movabs $0x8032b8,%rax
  804e63:	00 00 00 
  804e66:	ff d0                	callq  *%rax
  804e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e6f:	78 26                	js     804e97 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  804e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e75:	ba 07 04 00 00       	mov    $0x407,%edx
  804e7a:	48 89 c6             	mov    %rax,%rsi
  804e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  804e82:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  804e89:	00 00 00 
  804e8c:	ff d0                	callq  *%rax
  804e8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e95:	79 16                	jns    804ead <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804e97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e9a:	89 c7                	mov    %eax,%edi
  804e9c:	48 b8 59 53 80 00 00 	movabs $0x805359,%rax
  804ea3:	00 00 00 
  804ea6:	ff d0                	callq  *%rax
		return r;
  804ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804eab:	eb 3a                	jmp    804ee7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804eb1:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  804eb8:	00 00 00 
  804ebb:	8b 12                	mov    (%rdx),%edx
  804ebd:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  804ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ec3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ece:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804ed1:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  804ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ed8:	48 89 c7             	mov    %rax,%rdi
  804edb:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  804ee2:	00 00 00 
  804ee5:	ff d0                	callq  *%rax
}
  804ee7:	c9                   	leaveq 
  804ee8:	c3                   	retq   

0000000000804ee9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804ee9:	55                   	push   %rbp
  804eea:	48 89 e5             	mov    %rsp,%rbp
  804eed:	48 83 ec 30          	sub    $0x30,%rsp
  804ef1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804ef4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ef8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804efc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804eff:	89 c7                	mov    %eax,%edi
  804f01:	48 b8 f3 4d 80 00 00 	movabs $0x804df3,%rax
  804f08:	00 00 00 
  804f0b:	ff d0                	callq  *%rax
  804f0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f14:	79 05                	jns    804f1b <accept+0x32>
		return r;
  804f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f19:	eb 3b                	jmp    804f56 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804f1b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804f1f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f26:	48 89 ce             	mov    %rcx,%rsi
  804f29:	89 c7                	mov    %eax,%edi
  804f2b:	48 b8 36 52 80 00 00 	movabs $0x805236,%rax
  804f32:	00 00 00 
  804f35:	ff d0                	callq  *%rax
  804f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f3e:	79 05                	jns    804f45 <accept+0x5c>
		return r;
  804f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f43:	eb 11                	jmp    804f56 <accept+0x6d>
	return alloc_sockfd(r);
  804f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f48:	89 c7                	mov    %eax,%edi
  804f4a:	48 b8 4a 4e 80 00 00 	movabs $0x804e4a,%rax
  804f51:	00 00 00 
  804f54:	ff d0                	callq  *%rax
}
  804f56:	c9                   	leaveq 
  804f57:	c3                   	retq   

0000000000804f58 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804f58:	55                   	push   %rbp
  804f59:	48 89 e5             	mov    %rsp,%rbp
  804f5c:	48 83 ec 20          	sub    $0x20,%rsp
  804f60:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804f63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804f67:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804f6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f6d:	89 c7                	mov    %eax,%edi
  804f6f:	48 b8 f3 4d 80 00 00 	movabs $0x804df3,%rax
  804f76:	00 00 00 
  804f79:	ff d0                	callq  *%rax
  804f7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f82:	79 05                	jns    804f89 <bind+0x31>
		return r;
  804f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f87:	eb 1b                	jmp    804fa4 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804f89:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804f8c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f93:	48 89 ce             	mov    %rcx,%rsi
  804f96:	89 c7                	mov    %eax,%edi
  804f98:	48 b8 b5 52 80 00 00 	movabs $0x8052b5,%rax
  804f9f:	00 00 00 
  804fa2:	ff d0                	callq  *%rax
}
  804fa4:	c9                   	leaveq 
  804fa5:	c3                   	retq   

0000000000804fa6 <shutdown>:

int
shutdown(int s, int how)
{
  804fa6:	55                   	push   %rbp
  804fa7:	48 89 e5             	mov    %rsp,%rbp
  804faa:	48 83 ec 20          	sub    $0x20,%rsp
  804fae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804fb1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804fb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fb7:	89 c7                	mov    %eax,%edi
  804fb9:	48 b8 f3 4d 80 00 00 	movabs $0x804df3,%rax
  804fc0:	00 00 00 
  804fc3:	ff d0                	callq  *%rax
  804fc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fcc:	79 05                	jns    804fd3 <shutdown+0x2d>
		return r;
  804fce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fd1:	eb 16                	jmp    804fe9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  804fd3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804fd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fd9:	89 d6                	mov    %edx,%esi
  804fdb:	89 c7                	mov    %eax,%edi
  804fdd:	48 b8 19 53 80 00 00 	movabs $0x805319,%rax
  804fe4:	00 00 00 
  804fe7:	ff d0                	callq  *%rax
}
  804fe9:	c9                   	leaveq 
  804fea:	c3                   	retq   

0000000000804feb <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804feb:	55                   	push   %rbp
  804fec:	48 89 e5             	mov    %rsp,%rbp
  804fef:	48 83 ec 10          	sub    $0x10,%rsp
  804ff3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804ff7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ffb:	48 89 c7             	mov    %rax,%rdi
  804ffe:	48 b8 9a 5e 80 00 00 	movabs $0x805e9a,%rax
  805005:	00 00 00 
  805008:	ff d0                	callq  *%rax
  80500a:	83 f8 01             	cmp    $0x1,%eax
  80500d:	75 17                	jne    805026 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80500f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805013:	8b 40 0c             	mov    0xc(%rax),%eax
  805016:	89 c7                	mov    %eax,%edi
  805018:	48 b8 59 53 80 00 00 	movabs $0x805359,%rax
  80501f:	00 00 00 
  805022:	ff d0                	callq  *%rax
  805024:	eb 05                	jmp    80502b <devsock_close+0x40>
	else
		return 0;
  805026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80502b:	c9                   	leaveq 
  80502c:	c3                   	retq   

000000000080502d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80502d:	55                   	push   %rbp
  80502e:	48 89 e5             	mov    %rsp,%rbp
  805031:	48 83 ec 20          	sub    $0x20,%rsp
  805035:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805038:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80503c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80503f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805042:	89 c7                	mov    %eax,%edi
  805044:	48 b8 f3 4d 80 00 00 	movabs $0x804df3,%rax
  80504b:	00 00 00 
  80504e:	ff d0                	callq  *%rax
  805050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805057:	79 05                	jns    80505e <connect+0x31>
		return r;
  805059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80505c:	eb 1b                	jmp    805079 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80505e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805061:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805068:	48 89 ce             	mov    %rcx,%rsi
  80506b:	89 c7                	mov    %eax,%edi
  80506d:	48 b8 86 53 80 00 00 	movabs $0x805386,%rax
  805074:	00 00 00 
  805077:	ff d0                	callq  *%rax
}
  805079:	c9                   	leaveq 
  80507a:	c3                   	retq   

000000000080507b <listen>:

int
listen(int s, int backlog)
{
  80507b:	55                   	push   %rbp
  80507c:	48 89 e5             	mov    %rsp,%rbp
  80507f:	48 83 ec 20          	sub    $0x20,%rsp
  805083:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805086:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805089:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80508c:	89 c7                	mov    %eax,%edi
  80508e:	48 b8 f3 4d 80 00 00 	movabs $0x804df3,%rax
  805095:	00 00 00 
  805098:	ff d0                	callq  *%rax
  80509a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80509d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050a1:	79 05                	jns    8050a8 <listen+0x2d>
		return r;
  8050a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050a6:	eb 16                	jmp    8050be <listen+0x43>
	return nsipc_listen(r, backlog);
  8050a8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8050ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050ae:	89 d6                	mov    %edx,%esi
  8050b0:	89 c7                	mov    %eax,%edi
  8050b2:	48 b8 ea 53 80 00 00 	movabs $0x8053ea,%rax
  8050b9:	00 00 00 
  8050bc:	ff d0                	callq  *%rax
}
  8050be:	c9                   	leaveq 
  8050bf:	c3                   	retq   

00000000008050c0 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8050c0:	55                   	push   %rbp
  8050c1:	48 89 e5             	mov    %rsp,%rbp
  8050c4:	48 83 ec 20          	sub    $0x20,%rsp
  8050c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8050cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8050d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8050d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050d8:	89 c2                	mov    %eax,%edx
  8050da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050de:	8b 40 0c             	mov    0xc(%rax),%eax
  8050e1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8050e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8050ea:	89 c7                	mov    %eax,%edi
  8050ec:	48 b8 2a 54 80 00 00 	movabs $0x80542a,%rax
  8050f3:	00 00 00 
  8050f6:	ff d0                	callq  *%rax
}
  8050f8:	c9                   	leaveq 
  8050f9:	c3                   	retq   

00000000008050fa <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8050fa:	55                   	push   %rbp
  8050fb:	48 89 e5             	mov    %rsp,%rbp
  8050fe:	48 83 ec 20          	sub    $0x20,%rsp
  805102:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80510a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80510e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805112:	89 c2                	mov    %eax,%edx
  805114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805118:	8b 40 0c             	mov    0xc(%rax),%eax
  80511b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80511f:	b9 00 00 00 00       	mov    $0x0,%ecx
  805124:	89 c7                	mov    %eax,%edi
  805126:	48 b8 f6 54 80 00 00 	movabs $0x8054f6,%rax
  80512d:	00 00 00 
  805130:	ff d0                	callq  *%rax
}
  805132:	c9                   	leaveq 
  805133:	c3                   	retq   

0000000000805134 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  805134:	55                   	push   %rbp
  805135:	48 89 e5             	mov    %rsp,%rbp
  805138:	48 83 ec 10          	sub    $0x10,%rsp
  80513c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805140:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  805144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805148:	48 be 75 69 80 00 00 	movabs $0x806975,%rsi
  80514f:	00 00 00 
  805152:	48 89 c7             	mov    %rax,%rdi
  805155:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80515c:	00 00 00 
  80515f:	ff d0                	callq  *%rax
	return 0;
  805161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805166:	c9                   	leaveq 
  805167:	c3                   	retq   

0000000000805168 <socket>:

int
socket(int domain, int type, int protocol)
{
  805168:	55                   	push   %rbp
  805169:	48 89 e5             	mov    %rsp,%rbp
  80516c:	48 83 ec 20          	sub    $0x20,%rsp
  805170:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805173:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805176:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  805179:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80517c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80517f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805182:	89 ce                	mov    %ecx,%esi
  805184:	89 c7                	mov    %eax,%edi
  805186:	48 b8 ae 55 80 00 00 	movabs $0x8055ae,%rax
  80518d:	00 00 00 
  805190:	ff d0                	callq  *%rax
  805192:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805195:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805199:	79 05                	jns    8051a0 <socket+0x38>
		return r;
  80519b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80519e:	eb 11                	jmp    8051b1 <socket+0x49>
	return alloc_sockfd(r);
  8051a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051a3:	89 c7                	mov    %eax,%edi
  8051a5:	48 b8 4a 4e 80 00 00 	movabs $0x804e4a,%rax
  8051ac:	00 00 00 
  8051af:	ff d0                	callq  *%rax
}
  8051b1:	c9                   	leaveq 
  8051b2:	c3                   	retq   

00000000008051b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8051b3:	55                   	push   %rbp
  8051b4:	48 89 e5             	mov    %rsp,%rbp
  8051b7:	48 83 ec 10          	sub    $0x10,%rsp
  8051bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8051be:	48 b8 44 94 80 00 00 	movabs $0x809444,%rax
  8051c5:	00 00 00 
  8051c8:	8b 00                	mov    (%rax),%eax
  8051ca:	85 c0                	test   %eax,%eax
  8051cc:	75 1f                	jne    8051ed <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8051ce:	bf 02 00 00 00       	mov    $0x2,%edi
  8051d3:	48 b8 28 5e 80 00 00 	movabs $0x805e28,%rax
  8051da:	00 00 00 
  8051dd:	ff d0                	callq  *%rax
  8051df:	89 c2                	mov    %eax,%edx
  8051e1:	48 b8 44 94 80 00 00 	movabs $0x809444,%rax
  8051e8:	00 00 00 
  8051eb:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8051ed:	48 b8 44 94 80 00 00 	movabs $0x809444,%rax
  8051f4:	00 00 00 
  8051f7:	8b 00                	mov    (%rax),%eax
  8051f9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8051fc:	b9 07 00 00 00       	mov    $0x7,%ecx
  805201:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  805208:	00 00 00 
  80520b:	89 c7                	mov    %eax,%edi
  80520d:	48 b8 9b 5c 80 00 00 	movabs $0x805c9b,%rax
  805214:	00 00 00 
  805217:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  805219:	ba 00 00 00 00       	mov    $0x0,%edx
  80521e:	be 00 00 00 00       	mov    $0x0,%esi
  805223:	bf 00 00 00 00       	mov    $0x0,%edi
  805228:	48 b8 5d 5c 80 00 00 	movabs $0x805c5d,%rax
  80522f:	00 00 00 
  805232:	ff d0                	callq  *%rax
}
  805234:	c9                   	leaveq 
  805235:	c3                   	retq   

0000000000805236 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805236:	55                   	push   %rbp
  805237:	48 89 e5             	mov    %rsp,%rbp
  80523a:	48 83 ec 30          	sub    $0x30,%rsp
  80523e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805241:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805245:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805249:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805250:	00 00 00 
  805253:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805256:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805258:	bf 01 00 00 00       	mov    $0x1,%edi
  80525d:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  805264:	00 00 00 
  805267:	ff d0                	callq  *%rax
  805269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80526c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805270:	78 3e                	js     8052b0 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805272:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805279:	00 00 00 
  80527c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  805280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805284:	8b 40 10             	mov    0x10(%rax),%eax
  805287:	89 c2                	mov    %eax,%edx
  805289:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80528d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805291:	48 89 ce             	mov    %rcx,%rsi
  805294:	48 89 c7             	mov    %rax,%rdi
  805297:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  80529e:	00 00 00 
  8052a1:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8052a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8052a7:	8b 50 10             	mov    0x10(%rax),%edx
  8052aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052ae:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8052b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8052b3:	c9                   	leaveq 
  8052b4:	c3                   	retq   

00000000008052b5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8052b5:	55                   	push   %rbp
  8052b6:	48 89 e5             	mov    %rsp,%rbp
  8052b9:	48 83 ec 10          	sub    $0x10,%rsp
  8052bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8052c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8052c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8052c7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8052ce:	00 00 00 
  8052d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8052d4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8052d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8052d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8052dd:	48 89 c6             	mov    %rax,%rsi
  8052e0:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8052e7:	00 00 00 
  8052ea:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  8052f1:	00 00 00 
  8052f4:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8052f6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8052fd:	00 00 00 
  805300:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805303:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  805306:	bf 02 00 00 00       	mov    $0x2,%edi
  80530b:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  805312:	00 00 00 
  805315:	ff d0                	callq  *%rax
}
  805317:	c9                   	leaveq 
  805318:	c3                   	retq   

0000000000805319 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  805319:	55                   	push   %rbp
  80531a:	48 89 e5             	mov    %rsp,%rbp
  80531d:	48 83 ec 10          	sub    $0x10,%rsp
  805321:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805324:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  805327:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80532e:	00 00 00 
  805331:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805334:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  805336:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80533d:	00 00 00 
  805340:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805343:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805346:	bf 03 00 00 00       	mov    $0x3,%edi
  80534b:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  805352:	00 00 00 
  805355:	ff d0                	callq  *%rax
}
  805357:	c9                   	leaveq 
  805358:	c3                   	retq   

0000000000805359 <nsipc_close>:

int
nsipc_close(int s)
{
  805359:	55                   	push   %rbp
  80535a:	48 89 e5             	mov    %rsp,%rbp
  80535d:	48 83 ec 10          	sub    $0x10,%rsp
  805361:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805364:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80536b:	00 00 00 
  80536e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805371:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805373:	bf 04 00 00 00       	mov    $0x4,%edi
  805378:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  80537f:	00 00 00 
  805382:	ff d0                	callq  *%rax
}
  805384:	c9                   	leaveq 
  805385:	c3                   	retq   

0000000000805386 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805386:	55                   	push   %rbp
  805387:	48 89 e5             	mov    %rsp,%rbp
  80538a:	48 83 ec 10          	sub    $0x10,%rsp
  80538e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805391:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805395:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805398:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80539f:	00 00 00 
  8053a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8053a5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8053a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8053aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053ae:	48 89 c6             	mov    %rax,%rsi
  8053b1:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8053b8:	00 00 00 
  8053bb:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  8053c2:	00 00 00 
  8053c5:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8053c7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8053ce:	00 00 00 
  8053d1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8053d4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8053d7:	bf 05 00 00 00       	mov    $0x5,%edi
  8053dc:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  8053e3:	00 00 00 
  8053e6:	ff d0                	callq  *%rax
}
  8053e8:	c9                   	leaveq 
  8053e9:	c3                   	retq   

00000000008053ea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8053ea:	55                   	push   %rbp
  8053eb:	48 89 e5             	mov    %rsp,%rbp
  8053ee:	48 83 ec 10          	sub    $0x10,%rsp
  8053f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8053f5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8053f8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8053ff:	00 00 00 
  805402:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805405:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  805407:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80540e:	00 00 00 
  805411:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805414:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  805417:	bf 06 00 00 00       	mov    $0x6,%edi
  80541c:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  805423:	00 00 00 
  805426:	ff d0                	callq  *%rax
}
  805428:	c9                   	leaveq 
  805429:	c3                   	retq   

000000000080542a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80542a:	55                   	push   %rbp
  80542b:	48 89 e5             	mov    %rsp,%rbp
  80542e:	48 83 ec 30          	sub    $0x30,%rsp
  805432:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805435:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805439:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80543c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80543f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805446:	00 00 00 
  805449:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80544c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80544e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805455:	00 00 00 
  805458:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80545b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80545e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805465:	00 00 00 
  805468:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80546b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80546e:	bf 07 00 00 00       	mov    $0x7,%edi
  805473:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  80547a:	00 00 00 
  80547d:	ff d0                	callq  *%rax
  80547f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805486:	78 69                	js     8054f1 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805488:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80548f:	7f 08                	jg     805499 <nsipc_recv+0x6f>
  805491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805494:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805497:	7e 35                	jle    8054ce <nsipc_recv+0xa4>
  805499:	48 b9 7c 69 80 00 00 	movabs $0x80697c,%rcx
  8054a0:	00 00 00 
  8054a3:	48 ba 91 69 80 00 00 	movabs $0x806991,%rdx
  8054aa:	00 00 00 
  8054ad:	be 61 00 00 00       	mov    $0x61,%esi
  8054b2:	48 bf a6 69 80 00 00 	movabs $0x8069a6,%rdi
  8054b9:	00 00 00 
  8054bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8054c1:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  8054c8:	00 00 00 
  8054cb:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8054ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054d1:	48 63 d0             	movslq %eax,%rdx
  8054d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8054d8:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  8054df:	00 00 00 
  8054e2:	48 89 c7             	mov    %rax,%rdi
  8054e5:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  8054ec:	00 00 00 
  8054ef:	ff d0                	callq  *%rax
	}

	return r;
  8054f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8054f4:	c9                   	leaveq 
  8054f5:	c3                   	retq   

00000000008054f6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8054f6:	55                   	push   %rbp
  8054f7:	48 89 e5             	mov    %rsp,%rbp
  8054fa:	48 83 ec 20          	sub    $0x20,%rsp
  8054fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805501:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805505:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805508:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80550b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805512:	00 00 00 
  805515:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805518:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80551a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805521:	7e 35                	jle    805558 <nsipc_send+0x62>
  805523:	48 b9 b2 69 80 00 00 	movabs $0x8069b2,%rcx
  80552a:	00 00 00 
  80552d:	48 ba 91 69 80 00 00 	movabs $0x806991,%rdx
  805534:	00 00 00 
  805537:	be 6c 00 00 00       	mov    $0x6c,%esi
  80553c:	48 bf a6 69 80 00 00 	movabs $0x8069a6,%rdi
  805543:	00 00 00 
  805546:	b8 00 00 00 00       	mov    $0x0,%eax
  80554b:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  805552:	00 00 00 
  805555:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805558:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80555b:	48 63 d0             	movslq %eax,%rdx
  80555e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805562:	48 89 c6             	mov    %rax,%rsi
  805565:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  80556c:	00 00 00 
  80556f:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  805576:	00 00 00 
  805579:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80557b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805582:	00 00 00 
  805585:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805588:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80558b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805592:	00 00 00 
  805595:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805598:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80559b:	bf 08 00 00 00       	mov    $0x8,%edi
  8055a0:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  8055a7:	00 00 00 
  8055aa:	ff d0                	callq  *%rax
}
  8055ac:	c9                   	leaveq 
  8055ad:	c3                   	retq   

00000000008055ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8055ae:	55                   	push   %rbp
  8055af:	48 89 e5             	mov    %rsp,%rbp
  8055b2:	48 83 ec 10          	sub    $0x10,%rsp
  8055b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8055b9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8055bc:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8055bf:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8055c6:	00 00 00 
  8055c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8055cc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8055ce:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8055d5:	00 00 00 
  8055d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8055db:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8055de:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8055e5:	00 00 00 
  8055e8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8055eb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8055ee:	bf 09 00 00 00       	mov    $0x9,%edi
  8055f3:	48 b8 b3 51 80 00 00 	movabs $0x8051b3,%rax
  8055fa:	00 00 00 
  8055fd:	ff d0                	callq  *%rax
}
  8055ff:	c9                   	leaveq 
  805600:	c3                   	retq   

0000000000805601 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805601:	55                   	push   %rbp
  805602:	48 89 e5             	mov    %rsp,%rbp
  805605:	53                   	push   %rbx
  805606:	48 83 ec 38          	sub    $0x38,%rsp
  80560a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80560e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805612:	48 89 c7             	mov    %rax,%rdi
  805615:	48 b8 b8 32 80 00 00 	movabs $0x8032b8,%rax
  80561c:	00 00 00 
  80561f:	ff d0                	callq  *%rax
  805621:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805624:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805628:	0f 88 bf 01 00 00    	js     8057ed <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80562e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805632:	ba 07 04 00 00       	mov    $0x407,%edx
  805637:	48 89 c6             	mov    %rax,%rsi
  80563a:	bf 00 00 00 00       	mov    $0x0,%edi
  80563f:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  805646:	00 00 00 
  805649:	ff d0                	callq  *%rax
  80564b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80564e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805652:	0f 88 95 01 00 00    	js     8057ed <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805658:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80565c:	48 89 c7             	mov    %rax,%rdi
  80565f:	48 b8 b8 32 80 00 00 	movabs $0x8032b8,%rax
  805666:	00 00 00 
  805669:	ff d0                	callq  *%rax
  80566b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80566e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805672:	0f 88 5d 01 00 00    	js     8057d5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80567c:	ba 07 04 00 00       	mov    $0x407,%edx
  805681:	48 89 c6             	mov    %rax,%rsi
  805684:	bf 00 00 00 00       	mov    $0x0,%edi
  805689:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  805690:	00 00 00 
  805693:	ff d0                	callq  *%rax
  805695:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805698:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80569c:	0f 88 33 01 00 00    	js     8057d5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8056a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056a6:	48 89 c7             	mov    %rax,%rdi
  8056a9:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  8056b0:	00 00 00 
  8056b3:	ff d0                	callq  *%rax
  8056b5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8056b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8056bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8056c2:	48 89 c6             	mov    %rax,%rsi
  8056c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8056ca:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  8056d1:	00 00 00 
  8056d4:	ff d0                	callq  *%rax
  8056d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8056d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8056dd:	79 05                	jns    8056e4 <pipe+0xe3>
		goto err2;
  8056df:	e9 d9 00 00 00       	jmpq   8057bd <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8056e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056e8:	48 89 c7             	mov    %rax,%rdi
  8056eb:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  8056f2:	00 00 00 
  8056f5:	ff d0                	callq  *%rax
  8056f7:	48 89 c2             	mov    %rax,%rdx
  8056fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8056fe:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805704:	48 89 d1             	mov    %rdx,%rcx
  805707:	ba 00 00 00 00       	mov    $0x0,%edx
  80570c:	48 89 c6             	mov    %rax,%rsi
  80570f:	bf 00 00 00 00       	mov    $0x0,%edi
  805714:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  80571b:	00 00 00 
  80571e:	ff d0                	callq  *%rax
  805720:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805723:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805727:	79 1b                	jns    805744 <pipe+0x143>
		goto err3;
  805729:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80572a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80572e:	48 89 c6             	mov    %rax,%rsi
  805731:	bf 00 00 00 00       	mov    $0x0,%edi
  805736:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  80573d:	00 00 00 
  805740:	ff d0                	callq  *%rax
  805742:	eb 79                	jmp    8057bd <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  805744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805748:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  80574f:	00 00 00 
  805752:	8b 12                	mov    (%rdx),%edx
  805754:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80575a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  805761:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805765:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  80576c:	00 00 00 
  80576f:	8b 12                	mov    (%rdx),%edx
  805771:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805773:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805777:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80577e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805782:	48 89 c7             	mov    %rax,%rdi
  805785:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  80578c:	00 00 00 
  80578f:	ff d0                	callq  *%rax
  805791:	89 c2                	mov    %eax,%edx
  805793:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805797:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805799:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80579d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8057a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057a5:	48 89 c7             	mov    %rax,%rdi
  8057a8:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  8057af:	00 00 00 
  8057b2:	ff d0                	callq  *%rax
  8057b4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8057b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8057bb:	eb 33                	jmp    8057f0 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8057bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057c1:	48 89 c6             	mov    %rax,%rsi
  8057c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8057c9:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  8057d0:	00 00 00 
  8057d3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8057d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057d9:	48 89 c6             	mov    %rax,%rsi
  8057dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8057e1:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  8057e8:	00 00 00 
  8057eb:	ff d0                	callq  *%rax
err:
	return r;
  8057ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8057f0:	48 83 c4 38          	add    $0x38,%rsp
  8057f4:	5b                   	pop    %rbx
  8057f5:	5d                   	pop    %rbp
  8057f6:	c3                   	retq   

00000000008057f7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8057f7:	55                   	push   %rbp
  8057f8:	48 89 e5             	mov    %rsp,%rbp
  8057fb:	53                   	push   %rbx
  8057fc:	48 83 ec 28          	sub    $0x28,%rsp
  805800:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805804:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805808:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  80580f:	00 00 00 
  805812:	48 8b 00             	mov    (%rax),%rax
  805815:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80581b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80581e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805822:	48 89 c7             	mov    %rax,%rdi
  805825:	48 b8 9a 5e 80 00 00 	movabs $0x805e9a,%rax
  80582c:	00 00 00 
  80582f:	ff d0                	callq  *%rax
  805831:	89 c3                	mov    %eax,%ebx
  805833:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805837:	48 89 c7             	mov    %rax,%rdi
  80583a:	48 b8 9a 5e 80 00 00 	movabs $0x805e9a,%rax
  805841:	00 00 00 
  805844:	ff d0                	callq  *%rax
  805846:	39 c3                	cmp    %eax,%ebx
  805848:	0f 94 c0             	sete   %al
  80584b:	0f b6 c0             	movzbl %al,%eax
  80584e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  805851:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805858:	00 00 00 
  80585b:	48 8b 00             	mov    (%rax),%rax
  80585e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805864:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805867:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80586a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80586d:	75 05                	jne    805874 <_pipeisclosed+0x7d>
			return ret;
  80586f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805872:	eb 4a                	jmp    8058be <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  805874:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805877:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80587a:	74 3d                	je     8058b9 <_pipeisclosed+0xc2>
  80587c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805880:	75 37                	jne    8058b9 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805882:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805889:	00 00 00 
  80588c:	48 8b 00             	mov    (%rax),%rax
  80588f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805895:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805898:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80589b:	89 c6                	mov    %eax,%esi
  80589d:	48 bf c3 69 80 00 00 	movabs $0x8069c3,%rdi
  8058a4:	00 00 00 
  8058a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8058ac:	49 b8 22 15 80 00 00 	movabs $0x801522,%r8
  8058b3:	00 00 00 
  8058b6:	41 ff d0             	callq  *%r8
	}
  8058b9:	e9 4a ff ff ff       	jmpq   805808 <_pipeisclosed+0x11>
}
  8058be:	48 83 c4 28          	add    $0x28,%rsp
  8058c2:	5b                   	pop    %rbx
  8058c3:	5d                   	pop    %rbp
  8058c4:	c3                   	retq   

00000000008058c5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8058c5:	55                   	push   %rbp
  8058c6:	48 89 e5             	mov    %rsp,%rbp
  8058c9:	48 83 ec 30          	sub    $0x30,%rsp
  8058cd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8058d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8058d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8058d7:	48 89 d6             	mov    %rdx,%rsi
  8058da:	89 c7                	mov    %eax,%edi
  8058dc:	48 b8 50 33 80 00 00 	movabs $0x803350,%rax
  8058e3:	00 00 00 
  8058e6:	ff d0                	callq  *%rax
  8058e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058ef:	79 05                	jns    8058f6 <pipeisclosed+0x31>
		return r;
  8058f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058f4:	eb 31                	jmp    805927 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8058f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058fa:	48 89 c7             	mov    %rax,%rdi
  8058fd:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  805904:	00 00 00 
  805907:	ff d0                	callq  *%rax
  805909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80590d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805911:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805915:	48 89 d6             	mov    %rdx,%rsi
  805918:	48 89 c7             	mov    %rax,%rdi
  80591b:	48 b8 f7 57 80 00 00 	movabs $0x8057f7,%rax
  805922:	00 00 00 
  805925:	ff d0                	callq  *%rax
}
  805927:	c9                   	leaveq 
  805928:	c3                   	retq   

0000000000805929 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805929:	55                   	push   %rbp
  80592a:	48 89 e5             	mov    %rsp,%rbp
  80592d:	48 83 ec 40          	sub    $0x40,%rsp
  805931:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805935:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805939:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80593d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805941:	48 89 c7             	mov    %rax,%rdi
  805944:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  80594b:	00 00 00 
  80594e:	ff d0                	callq  *%rax
  805950:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805954:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805958:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80595c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805963:	00 
  805964:	e9 92 00 00 00       	jmpq   8059fb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  805969:	eb 41                	jmp    8059ac <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80596b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805970:	74 09                	je     80597b <devpipe_read+0x52>
				return i;
  805972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805976:	e9 92 00 00 00       	jmpq   805a0d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80597b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80597f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805983:	48 89 d6             	mov    %rdx,%rsi
  805986:	48 89 c7             	mov    %rax,%rdi
  805989:	48 b8 f7 57 80 00 00 	movabs $0x8057f7,%rax
  805990:	00 00 00 
  805993:	ff d0                	callq  *%rax
  805995:	85 c0                	test   %eax,%eax
  805997:	74 07                	je     8059a0 <devpipe_read+0x77>
				return 0;
  805999:	b8 00 00 00 00       	mov    $0x0,%eax
  80599e:	eb 6d                	jmp    805a0d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8059a0:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  8059a7:	00 00 00 
  8059aa:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8059ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059b0:	8b 10                	mov    (%rax),%edx
  8059b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059b6:	8b 40 04             	mov    0x4(%rax),%eax
  8059b9:	39 c2                	cmp    %eax,%edx
  8059bb:	74 ae                	je     80596b <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8059bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8059c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8059c5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8059c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059cd:	8b 00                	mov    (%rax),%eax
  8059cf:	99                   	cltd   
  8059d0:	c1 ea 1b             	shr    $0x1b,%edx
  8059d3:	01 d0                	add    %edx,%eax
  8059d5:	83 e0 1f             	and    $0x1f,%eax
  8059d8:	29 d0                	sub    %edx,%eax
  8059da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8059de:	48 98                	cltq   
  8059e0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8059e5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8059e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059eb:	8b 00                	mov    (%rax),%eax
  8059ed:	8d 50 01             	lea    0x1(%rax),%edx
  8059f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059f4:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8059f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8059fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8059ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805a03:	0f 82 60 ff ff ff    	jb     805969 <devpipe_read+0x40>
	}
	return i;
  805a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805a0d:	c9                   	leaveq 
  805a0e:	c3                   	retq   

0000000000805a0f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805a0f:	55                   	push   %rbp
  805a10:	48 89 e5             	mov    %rsp,%rbp
  805a13:	48 83 ec 40          	sub    $0x40,%rsp
  805a17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805a1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805a1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a27:	48 89 c7             	mov    %rax,%rdi
  805a2a:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  805a31:	00 00 00 
  805a34:	ff d0                	callq  *%rax
  805a36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805a3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805a42:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805a49:	00 
  805a4a:	e9 91 00 00 00       	jmpq   805ae0 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805a4f:	eb 31                	jmp    805a82 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  805a51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a59:	48 89 d6             	mov    %rdx,%rsi
  805a5c:	48 89 c7             	mov    %rax,%rdi
  805a5f:	48 b8 f7 57 80 00 00 	movabs $0x8057f7,%rax
  805a66:	00 00 00 
  805a69:	ff d0                	callq  *%rax
  805a6b:	85 c0                	test   %eax,%eax
  805a6d:	74 07                	je     805a76 <devpipe_write+0x67>
				return 0;
  805a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  805a74:	eb 7c                	jmp    805af2 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805a76:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  805a7d:	00 00 00 
  805a80:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a86:	8b 40 04             	mov    0x4(%rax),%eax
  805a89:	48 63 d0             	movslq %eax,%rdx
  805a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a90:	8b 00                	mov    (%rax),%eax
  805a92:	48 98                	cltq   
  805a94:	48 83 c0 20          	add    $0x20,%rax
  805a98:	48 39 c2             	cmp    %rax,%rdx
  805a9b:	73 b4                	jae    805a51 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805aa1:	8b 40 04             	mov    0x4(%rax),%eax
  805aa4:	99                   	cltd   
  805aa5:	c1 ea 1b             	shr    $0x1b,%edx
  805aa8:	01 d0                	add    %edx,%eax
  805aaa:	83 e0 1f             	and    $0x1f,%eax
  805aad:	29 d0                	sub    %edx,%eax
  805aaf:	89 c6                	mov    %eax,%esi
  805ab1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805ab5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ab9:	48 01 d0             	add    %rdx,%rax
  805abc:	0f b6 08             	movzbl (%rax),%ecx
  805abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805ac3:	48 63 c6             	movslq %esi,%rax
  805ac6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ace:	8b 40 04             	mov    0x4(%rax),%eax
  805ad1:	8d 50 01             	lea    0x1(%rax),%edx
  805ad4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ad8:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  805adb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ae4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805ae8:	0f 82 61 ff ff ff    	jb     805a4f <devpipe_write+0x40>
	}

	return i;
  805aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805af2:	c9                   	leaveq 
  805af3:	c3                   	retq   

0000000000805af4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805af4:	55                   	push   %rbp
  805af5:	48 89 e5             	mov    %rsp,%rbp
  805af8:	48 83 ec 20          	sub    $0x20,%rsp
  805afc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b08:	48 89 c7             	mov    %rax,%rdi
  805b0b:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  805b12:	00 00 00 
  805b15:	ff d0                	callq  *%rax
  805b17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805b1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b1f:	48 be d6 69 80 00 00 	movabs $0x8069d6,%rsi
  805b26:	00 00 00 
  805b29:	48 89 c7             	mov    %rax,%rdi
  805b2c:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  805b33:	00 00 00 
  805b36:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b3c:	8b 50 04             	mov    0x4(%rax),%edx
  805b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b43:	8b 00                	mov    (%rax),%eax
  805b45:	29 c2                	sub    %eax,%edx
  805b47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b4b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  805b51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b55:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805b5c:	00 00 00 
	stat->st_dev = &devpipe;
  805b5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b63:	48 b9 20 81 80 00 00 	movabs $0x808120,%rcx
  805b6a:	00 00 00 
  805b6d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805b79:	c9                   	leaveq 
  805b7a:	c3                   	retq   

0000000000805b7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805b7b:	55                   	push   %rbp
  805b7c:	48 89 e5             	mov    %rsp,%rbp
  805b7f:	48 83 ec 10          	sub    $0x10,%rsp
  805b83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  805b87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b8b:	48 89 c6             	mov    %rax,%rsi
  805b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  805b93:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  805b9a:	00 00 00 
  805b9d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  805b9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ba3:	48 89 c7             	mov    %rax,%rdi
  805ba6:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  805bad:	00 00 00 
  805bb0:	ff d0                	callq  *%rax
  805bb2:	48 89 c6             	mov    %rax,%rsi
  805bb5:	bf 00 00 00 00       	mov    $0x0,%edi
  805bba:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  805bc1:	00 00 00 
  805bc4:	ff d0                	callq  *%rax
}
  805bc6:	c9                   	leaveq 
  805bc7:	c3                   	retq   

0000000000805bc8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805bc8:	55                   	push   %rbp
  805bc9:	48 89 e5             	mov    %rsp,%rbp
  805bcc:	48 83 ec 20          	sub    $0x20,%rsp
  805bd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805bd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805bd7:	75 35                	jne    805c0e <wait+0x46>
  805bd9:	48 b9 dd 69 80 00 00 	movabs $0x8069dd,%rcx
  805be0:	00 00 00 
  805be3:	48 ba e8 69 80 00 00 	movabs $0x8069e8,%rdx
  805bea:	00 00 00 
  805bed:	be 09 00 00 00       	mov    $0x9,%esi
  805bf2:	48 bf fd 69 80 00 00 	movabs $0x8069fd,%rdi
  805bf9:	00 00 00 
  805bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  805c01:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  805c08:	00 00 00 
  805c0b:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805c0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805c11:	25 ff 03 00 00       	and    $0x3ff,%eax
  805c16:	48 98                	cltq   
  805c18:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  805c1f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805c26:	00 00 00 
  805c29:	48 01 d0             	add    %rdx,%rax
  805c2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805c30:	eb 0c                	jmp    805c3e <wait+0x76>
		sys_yield();
  805c32:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  805c39:	00 00 00 
  805c3c:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805c3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c42:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805c48:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805c4b:	75 0e                	jne    805c5b <wait+0x93>
  805c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c51:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805c57:	85 c0                	test   %eax,%eax
  805c59:	75 d7                	jne    805c32 <wait+0x6a>
}
  805c5b:	c9                   	leaveq 
  805c5c:	c3                   	retq   

0000000000805c5d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805c5d:	55                   	push   %rbp
  805c5e:	48 89 e5             	mov    %rsp,%rbp
  805c61:	48 83 ec 20          	sub    $0x20,%rsp
  805c65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805c69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805c6d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  805c71:	48 ba 08 6a 80 00 00 	movabs $0x806a08,%rdx
  805c78:	00 00 00 
  805c7b:	be 1d 00 00 00       	mov    $0x1d,%esi
  805c80:	48 bf 21 6a 80 00 00 	movabs $0x806a21,%rdi
  805c87:	00 00 00 
  805c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  805c8f:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  805c96:	00 00 00 
  805c99:	ff d1                	callq  *%rcx

0000000000805c9b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805c9b:	55                   	push   %rbp
  805c9c:	48 89 e5             	mov    %rsp,%rbp
  805c9f:	48 83 ec 20          	sub    $0x20,%rsp
  805ca3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ca6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805ca9:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  805cad:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  805cb0:	48 ba 2b 6a 80 00 00 	movabs $0x806a2b,%rdx
  805cb7:	00 00 00 
  805cba:	be 2d 00 00 00       	mov    $0x2d,%esi
  805cbf:	48 bf 21 6a 80 00 00 	movabs $0x806a21,%rdi
  805cc6:	00 00 00 
  805cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  805cce:	48 b9 e9 12 80 00 00 	movabs $0x8012e9,%rcx
  805cd5:	00 00 00 
  805cd8:	ff d1                	callq  *%rcx

0000000000805cda <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  805cda:	55                   	push   %rbp
  805cdb:	48 89 e5             	mov    %rsp,%rbp
  805cde:	53                   	push   %rbx
  805cdf:	48 83 ec 48          	sub    $0x48,%rsp
  805ce3:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  805ce7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  805cee:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  805cf5:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  805cfa:	75 0e                	jne    805d0a <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  805cfc:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  805d03:	00 00 00 
  805d06:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  805d0a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  805d0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  805d12:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  805d19:	00 
	a3 = (uint64_t) 0;
  805d1a:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  805d21:	00 
	a4 = (uint64_t) 0;
  805d22:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  805d29:	00 
	a5 = 0;
  805d2a:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  805d31:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  805d32:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805d35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805d39:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  805d3d:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  805d41:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  805d45:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  805d49:	4c 89 c3             	mov    %r8,%rbx
  805d4c:	0f 01 c1             	vmcall 
  805d4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  805d52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805d56:	7e 36                	jle    805d8e <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  805d58:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805d5b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805d5e:	41 89 d0             	mov    %edx,%r8d
  805d61:	89 c1                	mov    %eax,%ecx
  805d63:	48 ba 48 6a 80 00 00 	movabs $0x806a48,%rdx
  805d6a:	00 00 00 
  805d6d:	be 54 00 00 00       	mov    $0x54,%esi
  805d72:	48 bf 21 6a 80 00 00 	movabs $0x806a21,%rdi
  805d79:	00 00 00 
  805d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  805d81:	49 b9 e9 12 80 00 00 	movabs $0x8012e9,%r9
  805d88:	00 00 00 
  805d8b:	41 ff d1             	callq  *%r9
	return ret;
  805d8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805d91:	48 83 c4 48          	add    $0x48,%rsp
  805d95:	5b                   	pop    %rbx
  805d96:	5d                   	pop    %rbp
  805d97:	c3                   	retq   

0000000000805d98 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805d98:	55                   	push   %rbp
  805d99:	48 89 e5             	mov    %rsp,%rbp
  805d9c:	53                   	push   %rbx
  805d9d:	48 83 ec 58          	sub    $0x58,%rsp
  805da1:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  805da4:	89 75 b0             	mov    %esi,-0x50(%rbp)
  805da7:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  805dab:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  805dae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  805db5:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  805dbc:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  805dc1:	75 0e                	jne    805dd1 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  805dc3:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  805dca:	00 00 00 
  805dcd:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  805dd1:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  805dd4:	48 98                	cltq   
  805dd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  805dda:	8b 45 b0             	mov    -0x50(%rbp),%eax
  805ddd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  805de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  805de5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  805de9:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  805dec:	48 98                	cltq   
  805dee:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  805df2:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  805df9:	00 

	int r = -E_IPC_NOT_RECV;
  805dfa:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  805e01:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805e04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805e08:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805e0c:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  805e10:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  805e14:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  805e18:	4c 89 c3             	mov    %r8,%rbx
  805e1b:	0f 01 c1             	vmcall 
  805e1e:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  805e21:	48 83 c4 58          	add    $0x58,%rsp
  805e25:	5b                   	pop    %rbx
  805e26:	5d                   	pop    %rbp
  805e27:	c3                   	retq   

0000000000805e28 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805e28:	55                   	push   %rbp
  805e29:	48 89 e5             	mov    %rsp,%rbp
  805e2c:	48 83 ec 18          	sub    $0x18,%rsp
  805e30:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805e3a:	eb 4e                	jmp    805e8a <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  805e3c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805e43:	00 00 00 
  805e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e49:	48 98                	cltq   
  805e4b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805e52:	48 01 d0             	add    %rdx,%rax
  805e55:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805e5b:	8b 00                	mov    (%rax),%eax
  805e5d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805e60:	75 24                	jne    805e86 <ipc_find_env+0x5e>
			return envs[i].env_id;
  805e62:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805e69:	00 00 00 
  805e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e6f:	48 98                	cltq   
  805e71:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805e78:	48 01 d0             	add    %rdx,%rax
  805e7b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805e81:	8b 40 08             	mov    0x8(%rax),%eax
  805e84:	eb 12                	jmp    805e98 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  805e86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805e8a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805e91:	7e a9                	jle    805e3c <ipc_find_env+0x14>
	}
	return 0;
  805e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805e98:	c9                   	leaveq 
  805e99:	c3                   	retq   

0000000000805e9a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805e9a:	55                   	push   %rbp
  805e9b:	48 89 e5             	mov    %rsp,%rbp
  805e9e:	48 83 ec 18          	sub    $0x18,%rsp
  805ea2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805eaa:	48 c1 e8 15          	shr    $0x15,%rax
  805eae:	48 89 c2             	mov    %rax,%rdx
  805eb1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805eb8:	01 00 00 
  805ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805ebf:	83 e0 01             	and    $0x1,%eax
  805ec2:	48 85 c0             	test   %rax,%rax
  805ec5:	75 07                	jne    805ece <pageref+0x34>
		return 0;
  805ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  805ecc:	eb 53                	jmp    805f21 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805ece:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ed2:	48 c1 e8 0c          	shr    $0xc,%rax
  805ed6:	48 89 c2             	mov    %rax,%rdx
  805ed9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805ee0:	01 00 00 
  805ee3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805ee7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805eeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805eef:	83 e0 01             	and    $0x1,%eax
  805ef2:	48 85 c0             	test   %rax,%rax
  805ef5:	75 07                	jne    805efe <pageref+0x64>
		return 0;
  805ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  805efc:	eb 23                	jmp    805f21 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f02:	48 c1 e8 0c          	shr    $0xc,%rax
  805f06:	48 89 c2             	mov    %rax,%rdx
  805f09:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805f10:	00 00 00 
  805f13:	48 c1 e2 04          	shl    $0x4,%rdx
  805f17:	48 01 d0             	add    %rdx,%rax
  805f1a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805f1e:	0f b7 c0             	movzwl %ax,%eax
}
  805f21:	c9                   	leaveq 
  805f22:	c3                   	retq   
