
vmm/guest/obj/user/echotest:     formato del fichero elf64-x86-64


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
  80003c:	e8 d9 02 00 00       	callq  80031a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  80004f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800053:	48 89 c6             	mov    %rax,%rsi
  800056:	48 bf 4e 44 80 00 00 	movabs $0x80444e,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 7a 03 80 00 00 	movabs $0x80037a,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <umain>:

void umain(int argc, char **argv)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 50          	sub    $0x50,%rsp
  800087:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80008a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80008e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("Connecting to:\n");
  800095:	48 bf 52 44 80 00 00 	movabs $0x804452,%rdi
  80009c:	00 00 00 
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  8000ab:	00 00 00 
  8000ae:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b0:	48 bf 62 44 80 00 00 	movabs $0x804462,%rdi
  8000b7:	00 00 00 
  8000ba:	48 b8 73 3f 80 00 00 	movabs $0x803f73,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	48 be 62 44 80 00 00 	movabs $0x804462,%rsi
  8000cf:	00 00 00 
  8000d2:	48 bf 6c 44 80 00 00 	movabs $0x80446c,%rdi
  8000d9:	00 00 00 
  8000dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e1:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8000e8:	00 00 00 
  8000eb:	ff d1                	callq  *%rcx

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ed:	ba 06 00 00 00       	mov    $0x6,%edx
  8000f2:	be 01 00 00 00       	mov    $0x1,%esi
  8000f7:	bf 02 00 00 00       	mov    $0x2,%edi
  8000fc:	48 b8 86 2e 80 00 00 	movabs $0x802e86,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax
  800108:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80010f:	79 16                	jns    800127 <umain+0xa8>
		die("Failed to create socket");
  800111:	48 bf 81 44 80 00 00 	movabs $0x804481,%rdi
  800118:	00 00 00 
  80011b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800127:	48 bf 99 44 80 00 00 	movabs $0x804499,%rdi
  80012e:	00 00 00 
  800131:	b8 00 00 00 00       	mov    $0x0,%eax
  800136:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  80013d:	00 00 00 
  800140:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800142:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800146:	ba 10 00 00 00       	mov    $0x10,%edx
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
  800150:	48 89 c7             	mov    %rax,%rdi
  800153:	48 b8 f5 12 80 00 00 	movabs $0x8012f5,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80015f:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  800163:	48 bf 62 44 80 00 00 	movabs $0x804462,%rdi
  80016a:	00 00 00 
  80016d:	48 b8 73 3f 80 00 00 	movabs $0x803f73,%rax
  800174:	00 00 00 
  800177:	ff d0                	callq  *%rax
  800179:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017c:	bf 10 27 00 00       	mov    $0x2710,%edi
  800181:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  800188:	00 00 00 
  80018b:	ff d0                	callq  *%rax
  80018d:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800191:	48 bf a8 44 80 00 00 	movabs $0x8044a8,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  8001a7:	00 00 00 
  8001aa:	ff d2                	callq  *%rdx

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8001ac:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8001b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b3:	ba 10 00 00 00       	mov    $0x10,%edx
  8001b8:	48 89 ce             	mov    %rcx,%rsi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 4b 2d 80 00 00 	movabs $0x802d4b,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	79 16                	jns    8001e3 <umain+0x164>
		die("Failed to connect with server");
  8001cd:	48 bf c5 44 80 00 00 	movabs $0x8044c5,%rdi
  8001d4:	00 00 00 
  8001d7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e3:	48 bf e3 44 80 00 00 	movabs $0x8044e3,%rdi
  8001ea:	00 00 00 
  8001ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f2:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  8001f9:	00 00 00 
  8001fc:	ff d2                	callq  *%rdx

	// Send the word to the server
	echolen = strlen(msg);
  8001fe:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800205:	00 00 00 
  800208:	48 8b 00             	mov    (%rax),%rax
  80020b:	48 89 c7             	mov    %rax,%rdi
  80020e:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
  80021a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(sock, msg, echolen) != echolen)
  80021d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800220:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800227:	00 00 00 
  80022a:	48 8b 08             	mov    (%rax),%rcx
  80022d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800230:	48 89 ce             	mov    %rcx,%rsi
  800233:	89 c7                	mov    %eax,%edi
  800235:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
  800241:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800244:	74 16                	je     80025c <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800246:	48 bf f8 44 80 00 00 	movabs $0x8044f8,%rdi
  80024d:	00 00 00 
  800250:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025c:	48 bf 19 45 80 00 00 	movabs $0x804519,%rdi
  800263:	00 00 00 
  800266:	b8 00 00 00 00       	mov    $0x0,%eax
  80026b:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  800272:	00 00 00 
  800275:	ff d2                	callq  *%rdx
	while (received < echolen) {
  800277:	eb 6b                	jmp    8002e4 <umain+0x265>
		int bytes = 0;
  800279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800280:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800284:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800287:	ba 1f 00 00 00       	mov    $0x1f,%edx
  80028c:	48 89 ce             	mov    %rcx,%rsi
  80028f:	89 c7                	mov    %eax,%edi
  800291:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
  80029d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a4:	7f 16                	jg     8002bc <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a6:	48 bf 28 45 80 00 00 	movabs $0x804528,%rdi
  8002ad:	00 00 00 
  8002b0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002b7:	00 00 00 
  8002ba:	ff d0                	callq  *%rax
		}
		received += bytes;
  8002bc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002bf:	01 45 fc             	add    %eax,-0x4(%rbp)
		buffer[bytes] = '\0';        // Assure null terminated string
  8002c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c5:	48 98                	cltq   
  8002c7:	c6 44 05 c0 00       	movb   $0x0,-0x40(%rbp,%rax,1)
		cprintf(buffer);
  8002cc:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8002d0:	48 89 c7             	mov    %rax,%rdi
  8002d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d8:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  8002df:	00 00 00 
  8002e2:	ff d2                	callq  *%rdx
	while (received < echolen) {
  8002e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002ea:	72 8d                	jb     800279 <umain+0x1fa>
	}
	cprintf("\n");
  8002ec:	48 bf 4c 45 80 00 00 	movabs $0x80454c,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  800302:	00 00 00 
  800305:	ff d2                	callq  *%rdx

	close(sock);
  800307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030a:	89 c7                	mov    %eax,%edi
  80030c:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 83 ec 10          	sub    $0x10,%rsp
  800322:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800325:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800329:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800330:	00 00 00 
  800333:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80033e:	7e 14                	jle    800354 <libmain+0x3a>
		binaryname = argv[0];
  800340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800344:	48 8b 10             	mov    (%rax),%rdx
  800347:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80034e:	00 00 00 
  800351:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800354:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035b:	48 89 d6             	mov    %rdx,%rsi
  80035e:	89 c7                	mov    %eax,%edi
  800360:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  800367:	00 00 00 
  80036a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80036c:	48 b8 7a 03 80 00 00 	movabs $0x80037a,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
}
  800378:	c9                   	leaveq 
  800379:	c3                   	retq   

000000000080037a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80037a:	55                   	push   %rbp
  80037b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80037e:	48 b8 34 20 80 00 00 	movabs $0x802034,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80038a:	bf 00 00 00 00       	mov    $0x0,%edi
  80038f:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  800396:	00 00 00 
  800399:	ff d0                	callq  *%rax
}
  80039b:	5d                   	pop    %rbp
  80039c:	c3                   	retq   

000000000080039d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80039d:	55                   	push   %rbp
  80039e:	48 89 e5             	mov    %rsp,%rbp
  8003a1:	48 83 ec 10          	sub    $0x10,%rsp
  8003a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b0:	8b 00                	mov    (%rax),%eax
  8003b2:	8d 48 01             	lea    0x1(%rax),%ecx
  8003b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b9:	89 0a                	mov    %ecx,(%rdx)
  8003bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c4:	48 98                	cltq   
  8003c6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ce:	8b 00                	mov    (%rax),%eax
  8003d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d5:	75 2c                	jne    800403 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	8b 00                	mov    (%rax),%eax
  8003dd:	48 98                	cltq   
  8003df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e3:	48 83 c2 08          	add    $0x8,%rdx
  8003e7:	48 89 c6             	mov    %rax,%rsi
  8003ea:	48 89 d7             	mov    %rdx,%rdi
  8003ed:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
        b->idx = 0;
  8003f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800407:	8b 40 04             	mov    0x4(%rax),%eax
  80040a:	8d 50 01             	lea    0x1(%rax),%edx
  80040d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800411:	89 50 04             	mov    %edx,0x4(%rax)
}
  800414:	c9                   	leaveq 
  800415:	c3                   	retq   

0000000000800416 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800416:	55                   	push   %rbp
  800417:	48 89 e5             	mov    %rsp,%rbp
  80041a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800421:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800428:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80042f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800436:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80043d:	48 8b 0a             	mov    (%rdx),%rcx
  800440:	48 89 08             	mov    %rcx,(%rax)
  800443:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800447:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80044b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80044f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800453:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80045a:	00 00 00 
    b.cnt = 0;
  80045d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800464:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800467:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80046e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800475:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80047c:	48 89 c6             	mov    %rax,%rsi
  80047f:	48 bf 9d 03 80 00 00 	movabs $0x80039d,%rdi
  800486:	00 00 00 
  800489:	48 b8 61 08 80 00 00 	movabs $0x800861,%rax
  800490:	00 00 00 
  800493:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800495:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80049b:	48 98                	cltq   
  80049d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004a4:	48 83 c2 08          	add    $0x8,%rdx
  8004a8:	48 89 c6             	mov    %rax,%rsi
  8004ab:	48 89 d7             	mov    %rdx,%rdi
  8004ae:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  8004b5:	00 00 00 
  8004b8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004c0:	c9                   	leaveq 
  8004c1:	c3                   	retq   

00000000008004c2 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004c2:	55                   	push   %rbp
  8004c3:	48 89 e5             	mov    %rsp,%rbp
  8004c6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004cd:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004d4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004f0:	84 c0                	test   %al,%al
  8004f2:	74 20                	je     800514 <cprintf+0x52>
  8004f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800500:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800504:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800508:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80050c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800510:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800514:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80051b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800522:	00 00 00 
  800525:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80052c:	00 00 00 
  80052f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800533:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80053a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800541:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800548:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80054f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800556:	48 8b 0a             	mov    (%rdx),%rcx
  800559:	48 89 08             	mov    %rcx,(%rax)
  80055c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800560:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800564:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800568:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80056c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800573:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80057a:	48 89 d6             	mov    %rdx,%rsi
  80057d:	48 89 c7             	mov    %rax,%rdi
  800580:	48 b8 16 04 80 00 00 	movabs $0x800416,%rax
  800587:	00 00 00 
  80058a:	ff d0                	callq  *%rax
  80058c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800592:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800598:	c9                   	leaveq 
  800599:	c3                   	retq   

000000000080059a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	48 83 ec 30          	sub    $0x30,%rsp
  8005a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005ae:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005b1:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005b5:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005bc:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005c0:	77 42                	ja     800604 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005c5:	8d 78 ff             	lea    -0x1(%rax),%edi
  8005c8:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8005cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d4:	48 f7 f6             	div    %rsi
  8005d7:	49 89 c2             	mov    %rax,%r10
  8005da:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005dd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005e0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e8:	41 89 c9             	mov    %ecx,%r9d
  8005eb:	41 89 f8             	mov    %edi,%r8d
  8005ee:	89 d1                	mov    %edx,%ecx
  8005f0:	4c 89 d2             	mov    %r10,%rdx
  8005f3:	48 89 c7             	mov    %rax,%rdi
  8005f6:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8005fd:	00 00 00 
  800600:	ff d0                	callq  *%rax
  800602:	eb 1e                	jmp    800622 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800604:	eb 12                	jmp    800618 <printnum+0x7e>
			putch(padc, putdat);
  800606:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80060a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80060d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800611:	48 89 ce             	mov    %rcx,%rsi
  800614:	89 d7                	mov    %edx,%edi
  800616:	ff d0                	callq  *%rax
		while (--width > 0)
  800618:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80061c:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800620:	7f e4                	jg     800606 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800622:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	ba 00 00 00 00       	mov    $0x0,%edx
  80062e:	48 f7 f1             	div    %rcx
  800631:	48 b8 70 47 80 00 00 	movabs $0x804770,%rax
  800638:	00 00 00 
  80063b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80063f:	0f be d0             	movsbl %al,%edx
  800642:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064a:	48 89 ce             	mov    %rcx,%rsi
  80064d:	89 d7                	mov    %edx,%edi
  80064f:	ff d0                	callq  *%rax
}
  800651:	c9                   	leaveq 
  800652:	c3                   	retq   

0000000000800653 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800653:	55                   	push   %rbp
  800654:	48 89 e5             	mov    %rsp,%rbp
  800657:	48 83 ec 20          	sub    $0x20,%rsp
  80065b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80065f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800662:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800666:	7e 4f                	jle    8006b7 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	83 f8 30             	cmp    $0x30,%eax
  800671:	73 24                	jae    800697 <getuint+0x44>
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067f:	8b 00                	mov    (%rax),%eax
  800681:	89 c0                	mov    %eax,%eax
  800683:	48 01 d0             	add    %rdx,%rax
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	8b 12                	mov    (%rdx),%edx
  80068c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80068f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800693:	89 0a                	mov    %ecx,(%rdx)
  800695:	eb 14                	jmp    8006ab <getuint+0x58>
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80069f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ab:	48 8b 00             	mov    (%rax),%rax
  8006ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b2:	e9 9d 00 00 00       	jmpq   800754 <getuint+0x101>
	else if (lflag)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006bb:	74 4c                	je     800709 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8006bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c1:	8b 00                	mov    (%rax),%eax
  8006c3:	83 f8 30             	cmp    $0x30,%eax
  8006c6:	73 24                	jae    8006ec <getuint+0x99>
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	89 c0                	mov    %eax,%eax
  8006d8:	48 01 d0             	add    %rdx,%rax
  8006db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006df:	8b 12                	mov    (%rdx),%edx
  8006e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e8:	89 0a                	mov    %ecx,(%rdx)
  8006ea:	eb 14                	jmp    800700 <getuint+0xad>
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006f4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800700:	48 8b 00             	mov    (%rax),%rax
  800703:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800707:	eb 4b                	jmp    800754 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	83 f8 30             	cmp    $0x30,%eax
  800712:	73 24                	jae    800738 <getuint+0xe5>
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	89 c0                	mov    %eax,%eax
  800724:	48 01 d0             	add    %rdx,%rax
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	8b 12                	mov    (%rdx),%edx
  80072d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800730:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800734:	89 0a                	mov    %ecx,(%rdx)
  800736:	eb 14                	jmp    80074c <getuint+0xf9>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800740:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800744:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800748:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	89 c0                	mov    %eax,%eax
  800750:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800758:	c9                   	leaveq 
  800759:	c3                   	retq   

000000000080075a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075a:	55                   	push   %rbp
  80075b:	48 89 e5             	mov    %rsp,%rbp
  80075e:	48 83 ec 20          	sub    $0x20,%rsp
  800762:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800766:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800769:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076d:	7e 4f                	jle    8007be <getint+0x64>
		x=va_arg(*ap, long long);
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	8b 00                	mov    (%rax),%eax
  800775:	83 f8 30             	cmp    $0x30,%eax
  800778:	73 24                	jae    80079e <getint+0x44>
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	8b 00                	mov    (%rax),%eax
  800788:	89 c0                	mov    %eax,%eax
  80078a:	48 01 d0             	add    %rdx,%rax
  80078d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800791:	8b 12                	mov    (%rdx),%edx
  800793:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800796:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079a:	89 0a                	mov    %ecx,(%rdx)
  80079c:	eb 14                	jmp    8007b2 <getint+0x58>
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007a6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b2:	48 8b 00             	mov    (%rax),%rax
  8007b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b9:	e9 9d 00 00 00       	jmpq   80085b <getint+0x101>
	else if (lflag)
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c2:	74 4c                	je     800810 <getint+0xb6>
		x=va_arg(*ap, long);
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	83 f8 30             	cmp    $0x30,%eax
  8007cd:	73 24                	jae    8007f3 <getint+0x99>
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	8b 00                	mov    (%rax),%eax
  8007dd:	89 c0                	mov    %eax,%eax
  8007df:	48 01 d0             	add    %rdx,%rax
  8007e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e6:	8b 12                	mov    (%rdx),%edx
  8007e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	89 0a                	mov    %ecx,(%rdx)
  8007f1:	eb 14                	jmp    800807 <getint+0xad>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007fb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800807:	48 8b 00             	mov    (%rax),%rax
  80080a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080e:	eb 4b                	jmp    80085b <getint+0x101>
	else
		x=va_arg(*ap, int);
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	8b 00                	mov    (%rax),%eax
  800816:	83 f8 30             	cmp    $0x30,%eax
  800819:	73 24                	jae    80083f <getint+0xe5>
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	8b 00                	mov    (%rax),%eax
  800829:	89 c0                	mov    %eax,%eax
  80082b:	48 01 d0             	add    %rdx,%rax
  80082e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800832:	8b 12                	mov    (%rdx),%edx
  800834:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	89 0a                	mov    %ecx,(%rdx)
  80083d:	eb 14                	jmp    800853 <getint+0xf9>
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	48 8b 40 08          	mov    0x8(%rax),%rax
  800847:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80084b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800853:	8b 00                	mov    (%rax),%eax
  800855:	48 98                	cltq   
  800857:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80085f:	c9                   	leaveq 
  800860:	c3                   	retq   

0000000000800861 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800861:	55                   	push   %rbp
  800862:	48 89 e5             	mov    %rsp,%rbp
  800865:	41 54                	push   %r12
  800867:	53                   	push   %rbx
  800868:	48 83 ec 60          	sub    $0x60,%rsp
  80086c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800870:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800874:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800878:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800880:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800884:	48 8b 0a             	mov    (%rdx),%rcx
  800887:	48 89 08             	mov    %rcx,(%rax)
  80088a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800892:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800896:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089a:	eb 17                	jmp    8008b3 <vprintfmt+0x52>
			if (ch == '\0')
  80089c:	85 db                	test   %ebx,%ebx
  80089e:	0f 84 c5 04 00 00    	je     800d69 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8008a4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ac:	48 89 d6             	mov    %rdx,%rsi
  8008af:	89 df                	mov    %ebx,%edi
  8008b1:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008bb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008bf:	0f b6 00             	movzbl (%rax),%eax
  8008c2:	0f b6 d8             	movzbl %al,%ebx
  8008c5:	83 fb 25             	cmp    $0x25,%ebx
  8008c8:	75 d2                	jne    80089c <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ca:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008ce:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ea:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f6:	0f b6 00             	movzbl (%rax),%eax
  8008f9:	0f b6 d8             	movzbl %al,%ebx
  8008fc:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ff:	83 f8 55             	cmp    $0x55,%eax
  800902:	0f 87 2e 04 00 00    	ja     800d36 <vprintfmt+0x4d5>
  800908:	89 c0                	mov    %eax,%eax
  80090a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800911:	00 
  800912:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  800919:	00 00 00 
  80091c:	48 01 d0             	add    %rdx,%rax
  80091f:	48 8b 00             	mov    (%rax),%rax
  800922:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800924:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800928:	eb c0                	jmp    8008ea <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80092a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80092e:	eb ba                	jmp    8008ea <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800930:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800937:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80093a:	89 d0                	mov    %edx,%eax
  80093c:	c1 e0 02             	shl    $0x2,%eax
  80093f:	01 d0                	add    %edx,%eax
  800941:	01 c0                	add    %eax,%eax
  800943:	01 d8                	add    %ebx,%eax
  800945:	83 e8 30             	sub    $0x30,%eax
  800948:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80094b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094f:	0f b6 00             	movzbl (%rax),%eax
  800952:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800955:	83 fb 2f             	cmp    $0x2f,%ebx
  800958:	7e 0c                	jle    800966 <vprintfmt+0x105>
  80095a:	83 fb 39             	cmp    $0x39,%ebx
  80095d:	7f 07                	jg     800966 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  80095f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800964:	eb d1                	jmp    800937 <vprintfmt+0xd6>
			goto process_precision;
  800966:	eb 50                	jmp    8009b8 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800968:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096b:	83 f8 30             	cmp    $0x30,%eax
  80096e:	73 17                	jae    800987 <vprintfmt+0x126>
  800970:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800974:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800977:	89 d2                	mov    %edx,%edx
  800979:	48 01 d0             	add    %rdx,%rax
  80097c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097f:	83 c2 08             	add    $0x8,%edx
  800982:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800985:	eb 0c                	jmp    800993 <vprintfmt+0x132>
  800987:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80098b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80098f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800993:	8b 00                	mov    (%rax),%eax
  800995:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800998:	eb 1e                	jmp    8009b8 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  80099a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099e:	79 07                	jns    8009a7 <vprintfmt+0x146>
				width = 0;
  8009a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009a7:	e9 3e ff ff ff       	jmpq   8008ea <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009ac:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009b3:	e9 32 ff ff ff       	jmpq   8008ea <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009bc:	79 0d                	jns    8009cb <vprintfmt+0x16a>
				width = precision, precision = -1;
  8009be:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009c1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009cb:	e9 1a ff ff ff       	jmpq   8008ea <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009d0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009d4:	e9 11 ff ff ff       	jmpq   8008ea <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dc:	83 f8 30             	cmp    $0x30,%eax
  8009df:	73 17                	jae    8009f8 <vprintfmt+0x197>
  8009e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e8:	89 d2                	mov    %edx,%edx
  8009ea:	48 01 d0             	add    %rdx,%rax
  8009ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f0:	83 c2 08             	add    $0x8,%edx
  8009f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f6:	eb 0c                	jmp    800a04 <vprintfmt+0x1a3>
  8009f8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009fc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a00:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a04:	8b 10                	mov    (%rax),%edx
  800a06:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0e:	48 89 ce             	mov    %rcx,%rsi
  800a11:	89 d7                	mov    %edx,%edi
  800a13:	ff d0                	callq  *%rax
			break;
  800a15:	e9 4a 03 00 00       	jmpq   800d64 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1d:	83 f8 30             	cmp    $0x30,%eax
  800a20:	73 17                	jae    800a39 <vprintfmt+0x1d8>
  800a22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a29:	89 d2                	mov    %edx,%edx
  800a2b:	48 01 d0             	add    %rdx,%rax
  800a2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a31:	83 c2 08             	add    $0x8,%edx
  800a34:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a37:	eb 0c                	jmp    800a45 <vprintfmt+0x1e4>
  800a39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a3d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a45:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	79 02                	jns    800a4d <vprintfmt+0x1ec>
				err = -err;
  800a4b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a4d:	83 fb 15             	cmp    $0x15,%ebx
  800a50:	7f 16                	jg     800a68 <vprintfmt+0x207>
  800a52:	48 b8 c0 46 80 00 00 	movabs $0x8046c0,%rax
  800a59:	00 00 00 
  800a5c:	48 63 d3             	movslq %ebx,%rdx
  800a5f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a63:	4d 85 e4             	test   %r12,%r12
  800a66:	75 2e                	jne    800a96 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800a68:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a70:	89 d9                	mov    %ebx,%ecx
  800a72:	48 ba 81 47 80 00 00 	movabs $0x804781,%rdx
  800a79:	00 00 00 
  800a7c:	48 89 c7             	mov    %rax,%rdi
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a84:	49 b8 72 0d 80 00 00 	movabs $0x800d72,%r8
  800a8b:	00 00 00 
  800a8e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a91:	e9 ce 02 00 00       	jmpq   800d64 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800a96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9e:	4c 89 e1             	mov    %r12,%rcx
  800aa1:	48 ba 8a 47 80 00 00 	movabs $0x80478a,%rdx
  800aa8:	00 00 00 
  800aab:	48 89 c7             	mov    %rax,%rdi
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	49 b8 72 0d 80 00 00 	movabs $0x800d72,%r8
  800aba:	00 00 00 
  800abd:	41 ff d0             	callq  *%r8
			break;
  800ac0:	e9 9f 02 00 00       	jmpq   800d64 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac8:	83 f8 30             	cmp    $0x30,%eax
  800acb:	73 17                	jae    800ae4 <vprintfmt+0x283>
  800acd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ad1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad4:	89 d2                	mov    %edx,%edx
  800ad6:	48 01 d0             	add    %rdx,%rax
  800ad9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800adc:	83 c2 08             	add    $0x8,%edx
  800adf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae2:	eb 0c                	jmp    800af0 <vprintfmt+0x28f>
  800ae4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ae8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800aec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af0:	4c 8b 20             	mov    (%rax),%r12
  800af3:	4d 85 e4             	test   %r12,%r12
  800af6:	75 0a                	jne    800b02 <vprintfmt+0x2a1>
				p = "(null)";
  800af8:	49 bc 8d 47 80 00 00 	movabs $0x80478d,%r12
  800aff:	00 00 00 
			if (width > 0 && padc != '-')
  800b02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b06:	7e 3f                	jle    800b47 <vprintfmt+0x2e6>
  800b08:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b0c:	74 39                	je     800b47 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b11:	48 98                	cltq   
  800b13:	48 89 c6             	mov    %rax,%rsi
  800b16:	4c 89 e7             	mov    %r12,%rdi
  800b19:	48 b8 1e 10 80 00 00 	movabs $0x80101e,%rax
  800b20:	00 00 00 
  800b23:	ff d0                	callq  *%rax
  800b25:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b28:	eb 17                	jmp    800b41 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800b2a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b2e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b36:	48 89 ce             	mov    %rcx,%rsi
  800b39:	89 d7                	mov    %edx,%edi
  800b3b:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b45:	7f e3                	jg     800b2a <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 37                	jmp    800b80 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b4d:	74 1e                	je     800b6d <vprintfmt+0x30c>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x2f8>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 14                	jle    800b6d <vprintfmt+0x30c>
					putch('?', putdat);
  800b59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b61:	48 89 d6             	mov    %rdx,%rsi
  800b64:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b69:	ff d0                	callq  *%rax
  800b6b:	eb 0f                	jmp    800b7c <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800b6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b75:	48 89 d6             	mov    %rdx,%rsi
  800b78:	89 df                	mov    %ebx,%edi
  800b7a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b80:	4c 89 e0             	mov    %r12,%rax
  800b83:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b87:	0f b6 00             	movzbl (%rax),%eax
  800b8a:	0f be d8             	movsbl %al,%ebx
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	74 10                	je     800ba1 <vprintfmt+0x340>
  800b91:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b95:	78 b2                	js     800b49 <vprintfmt+0x2e8>
  800b97:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9f:	79 a8                	jns    800b49 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800ba1:	eb 16                	jmp    800bb9 <vprintfmt+0x358>
				putch(' ', putdat);
  800ba3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bab:	48 89 d6             	mov    %rdx,%rsi
  800bae:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb3:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800bb5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bbd:	7f e4                	jg     800ba3 <vprintfmt+0x342>
			break;
  800bbf:	e9 a0 01 00 00       	jmpq   800d64 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc8:	be 03 00 00 00       	mov    $0x3,%esi
  800bcd:	48 89 c7             	mov    %rax,%rdi
  800bd0:	48 b8 5a 07 80 00 00 	movabs $0x80075a,%rax
  800bd7:	00 00 00 
  800bda:	ff d0                	callq  *%rax
  800bdc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be4:	48 85 c0             	test   %rax,%rax
  800be7:	79 1d                	jns    800c06 <vprintfmt+0x3a5>
				putch('-', putdat);
  800be9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf1:	48 89 d6             	mov    %rdx,%rsi
  800bf4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bf9:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bff:	48 f7 d8             	neg    %rax
  800c02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c06:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c0d:	e9 e5 00 00 00       	jmpq   800cf7 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c16:	be 03 00 00 00       	mov    $0x3,%esi
  800c1b:	48 89 c7             	mov    %rax,%rdi
  800c1e:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800c25:	00 00 00 
  800c28:	ff d0                	callq  *%rax
  800c2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c2e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c35:	e9 bd 00 00 00       	jmpq   800cf7 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c42:	48 89 d6             	mov    %rdx,%rsi
  800c45:	bf 58 00 00 00       	mov    $0x58,%edi
  800c4a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c54:	48 89 d6             	mov    %rdx,%rsi
  800c57:	bf 58 00 00 00       	mov    $0x58,%edi
  800c5c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c66:	48 89 d6             	mov    %rdx,%rsi
  800c69:	bf 58 00 00 00       	mov    $0x58,%edi
  800c6e:	ff d0                	callq  *%rax
			break;
  800c70:	e9 ef 00 00 00       	jmpq   800d64 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800c75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7d:	48 89 d6             	mov    %rdx,%rsi
  800c80:	bf 30 00 00 00       	mov    $0x30,%edi
  800c85:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8f:	48 89 d6             	mov    %rdx,%rsi
  800c92:	bf 78 00 00 00       	mov    $0x78,%edi
  800c97:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9c:	83 f8 30             	cmp    $0x30,%eax
  800c9f:	73 17                	jae    800cb8 <vprintfmt+0x457>
  800ca1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ca5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca8:	89 d2                	mov    %edx,%edx
  800caa:	48 01 d0             	add    %rdx,%rax
  800cad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb0:	83 c2 08             	add    $0x8,%edx
  800cb3:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800cb6:	eb 0c                	jmp    800cc4 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800cb8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cbc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cc0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc4:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800cc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ccb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cd2:	eb 23                	jmp    800cf7 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cd4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd8:	be 03 00 00 00       	mov    $0x3,%esi
  800cdd:	48 89 c7             	mov    %rax,%rdi
  800ce0:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800ce7:	00 00 00 
  800cea:	ff d0                	callq  *%rax
  800cec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cfc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cff:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0e:	45 89 c1             	mov    %r8d,%r9d
  800d11:	41 89 f8             	mov    %edi,%r8d
  800d14:	48 89 c7             	mov    %rax,%rdi
  800d17:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  800d1e:	00 00 00 
  800d21:	ff d0                	callq  *%rax
			break;
  800d23:	eb 3f                	jmp    800d64 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	89 df                	mov    %ebx,%edi
  800d32:	ff d0                	callq  *%rax
			break;
  800d34:	eb 2e                	jmp    800d64 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3e:	48 89 d6             	mov    %rdx,%rsi
  800d41:	bf 25 00 00 00       	mov    $0x25,%edi
  800d46:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d48:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d4d:	eb 05                	jmp    800d54 <vprintfmt+0x4f3>
  800d4f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d58:	48 83 e8 01          	sub    $0x1,%rax
  800d5c:	0f b6 00             	movzbl (%rax),%eax
  800d5f:	3c 25                	cmp    $0x25,%al
  800d61:	75 ec                	jne    800d4f <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800d63:	90                   	nop
		}
	}
  800d64:	e9 31 fb ff ff       	jmpq   80089a <vprintfmt+0x39>
	va_end(aq);
}
  800d69:	48 83 c4 60          	add    $0x60,%rsp
  800d6d:	5b                   	pop    %rbx
  800d6e:	41 5c                	pop    %r12
  800d70:	5d                   	pop    %rbp
  800d71:	c3                   	retq   

0000000000800d72 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d72:	55                   	push   %rbp
  800d73:	48 89 e5             	mov    %rsp,%rbp
  800d76:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d7d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d84:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d8b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d92:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d99:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da0:	84 c0                	test   %al,%al
  800da2:	74 20                	je     800dc4 <printfmt+0x52>
  800da4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800da8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800db4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800db8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dbc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dc4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dcb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dd2:	00 00 00 
  800dd5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ddc:	00 00 00 
  800ddf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800df8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dff:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e06:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e0d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e14:	48 89 c7             	mov    %rax,%rdi
  800e17:	48 b8 61 08 80 00 00 	movabs $0x800861,%rax
  800e1e:	00 00 00 
  800e21:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e23:	c9                   	leaveq 
  800e24:	c3                   	retq   

0000000000800e25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e25:	55                   	push   %rbp
  800e26:	48 89 e5             	mov    %rsp,%rbp
  800e29:	48 83 ec 10          	sub    $0x10,%rsp
  800e2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e38:	8b 40 10             	mov    0x10(%rax),%eax
  800e3b:	8d 50 01             	lea    0x1(%rax),%edx
  800e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e42:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e49:	48 8b 10             	mov    (%rax),%rdx
  800e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e50:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e54:	48 39 c2             	cmp    %rax,%rdx
  800e57:	73 17                	jae    800e70 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5d:	48 8b 00             	mov    (%rax),%rax
  800e60:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e68:	48 89 0a             	mov    %rcx,(%rdx)
  800e6b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e6e:	88 10                	mov    %dl,(%rax)
}
  800e70:	c9                   	leaveq 
  800e71:	c3                   	retq   

0000000000800e72 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e72:	55                   	push   %rbp
  800e73:	48 89 e5             	mov    %rsp,%rbp
  800e76:	48 83 ec 50          	sub    $0x50,%rsp
  800e7a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e7e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e81:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e85:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e89:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e8d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e91:	48 8b 0a             	mov    (%rdx),%rcx
  800e94:	48 89 08             	mov    %rcx,(%rax)
  800e97:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e9b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e9f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eab:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eaf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eb2:	48 98                	cltq   
  800eb4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eb8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebc:	48 01 d0             	add    %rdx,%rax
  800ebf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ec3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eca:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ecf:	74 06                	je     800ed7 <vsnprintf+0x65>
  800ed1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ed5:	7f 07                	jg     800ede <vsnprintf+0x6c>
		return -E_INVAL;
  800ed7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800edc:	eb 2f                	jmp    800f0d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ede:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ee2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ee6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eea:	48 89 c6             	mov    %rax,%rsi
  800eed:	48 bf 25 0e 80 00 00 	movabs $0x800e25,%rdi
  800ef4:	00 00 00 
  800ef7:	48 b8 61 08 80 00 00 	movabs $0x800861,%rax
  800efe:	00 00 00 
  800f01:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f07:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f0a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f0d:	c9                   	leaveq 
  800f0e:	c3                   	retq   

0000000000800f0f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f0f:	55                   	push   %rbp
  800f10:	48 89 e5             	mov    %rsp,%rbp
  800f13:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f1a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f21:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f27:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f35:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3c:	84 c0                	test   %al,%al
  800f3e:	74 20                	je     800f60 <snprintf+0x51>
  800f40:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f44:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f48:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f50:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f54:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f58:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f60:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f67:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f6e:	00 00 00 
  800f71:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f78:	00 00 00 
  800f7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f7f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f86:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f94:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f9b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fa2:	48 8b 0a             	mov    (%rdx),%rcx
  800fa5:	48 89 08             	mov    %rcx,(%rax)
  800fa8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fb8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fbf:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fc6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fcc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fd3:	48 89 c7             	mov    %rax,%rdi
  800fd6:	48 b8 72 0e 80 00 00 	movabs $0x800e72,%rax
  800fdd:	00 00 00 
  800fe0:	ff d0                	callq  *%rax
  800fe2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fe8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 18          	sub    $0x18,%rsp
  800ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801003:	eb 09                	jmp    80100e <strlen+0x1e>
		n++;
  801005:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801009:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80100e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801012:	0f b6 00             	movzbl (%rax),%eax
  801015:	84 c0                	test   %al,%al
  801017:	75 ec                	jne    801005 <strlen+0x15>
	return n;
  801019:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101c:	c9                   	leaveq 
  80101d:	c3                   	retq   

000000000080101e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80101e:	55                   	push   %rbp
  80101f:	48 89 e5             	mov    %rsp,%rbp
  801022:	48 83 ec 20          	sub    $0x20,%rsp
  801026:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801035:	eb 0e                	jmp    801045 <strnlen+0x27>
		n++;
  801037:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801040:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801045:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80104a:	74 0b                	je     801057 <strnlen+0x39>
  80104c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801050:	0f b6 00             	movzbl (%rax),%eax
  801053:	84 c0                	test   %al,%al
  801055:	75 e0                	jne    801037 <strnlen+0x19>
	return n;
  801057:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80105a:	c9                   	leaveq 
  80105b:	c3                   	retq   

000000000080105c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 20          	sub    $0x20,%rsp
  801064:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801068:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80106c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801070:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801074:	90                   	nop
  801075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801079:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80107d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801081:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801085:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801089:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80108d:	0f b6 12             	movzbl (%rdx),%edx
  801090:	88 10                	mov    %dl,(%rax)
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	84 c0                	test   %al,%al
  801097:	75 dc                	jne    801075 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	48 83 ec 20          	sub    $0x20,%rsp
  8010a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b3:	48 89 c7             	mov    %rax,%rdi
  8010b6:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	callq  *%rax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c8:	48 63 d0             	movslq %eax,%rdx
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	48 01 c2             	add    %rax,%rdx
  8010d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d6:	48 89 c6             	mov    %rax,%rsi
  8010d9:	48 89 d7             	mov    %rdx,%rdi
  8010dc:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  8010e3:	00 00 00 
  8010e6:	ff d0                	callq  *%rax
	return dst;
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ec:	c9                   	leaveq 
  8010ed:	c3                   	retq   

00000000008010ee <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010ee:	55                   	push   %rbp
  8010ef:	48 89 e5             	mov    %rsp,%rbp
  8010f2:	48 83 ec 28          	sub    $0x28,%rsp
  8010f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801106:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80110a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801111:	00 
  801112:	eb 2a                	jmp    80113e <strncpy+0x50>
		*dst++ = *src;
  801114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801118:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801120:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801124:	0f b6 12             	movzbl (%rdx),%edx
  801127:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801129:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80112d:	0f b6 00             	movzbl (%rax),%eax
  801130:	84 c0                	test   %al,%al
  801132:	74 05                	je     801139 <strncpy+0x4b>
			src++;
  801134:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801139:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801142:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801146:	72 cc                	jb     801114 <strncpy+0x26>
	}
	return ret;
  801148:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80114c:	c9                   	leaveq 
  80114d:	c3                   	retq   

000000000080114e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80114e:	55                   	push   %rbp
  80114f:	48 89 e5             	mov    %rsp,%rbp
  801152:	48 83 ec 28          	sub    $0x28,%rsp
  801156:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801162:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801166:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80116a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80116f:	74 3d                	je     8011ae <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801171:	eb 1d                	jmp    801190 <strlcpy+0x42>
			*dst++ = *src++;
  801173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801177:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80117b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80117f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801183:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801187:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80118b:	0f b6 12             	movzbl (%rdx),%edx
  80118e:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801190:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801195:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80119a:	74 0b                	je     8011a7 <strlcpy+0x59>
  80119c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a0:	0f b6 00             	movzbl (%rax),%eax
  8011a3:	84 c0                	test   %al,%al
  8011a5:	75 cc                	jne    801173 <strlcpy+0x25>
		*dst = '\0';
  8011a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ab:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	48 29 c2             	sub    %rax,%rdx
  8011b9:	48 89 d0             	mov    %rdx,%rax
}
  8011bc:	c9                   	leaveq 
  8011bd:	c3                   	retq   

00000000008011be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011be:	55                   	push   %rbp
  8011bf:	48 89 e5             	mov    %rsp,%rbp
  8011c2:	48 83 ec 10          	sub    $0x10,%rsp
  8011c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ce:	eb 0a                	jmp    8011da <strcmp+0x1c>
		p++, q++;
  8011d0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8011da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011de:	0f b6 00             	movzbl (%rax),%eax
  8011e1:	84 c0                	test   %al,%al
  8011e3:	74 12                	je     8011f7 <strcmp+0x39>
  8011e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e9:	0f b6 10             	movzbl (%rax),%edx
  8011ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	38 c2                	cmp    %al,%dl
  8011f5:	74 d9                	je     8011d0 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fb:	0f b6 00             	movzbl (%rax),%eax
  8011fe:	0f b6 d0             	movzbl %al,%edx
  801201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	0f b6 c0             	movzbl %al,%eax
  80120b:	29 c2                	sub    %eax,%edx
  80120d:	89 d0                	mov    %edx,%eax
}
  80120f:	c9                   	leaveq 
  801210:	c3                   	retq   

0000000000801211 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	48 83 ec 18          	sub    $0x18,%rsp
  801219:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80121d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801221:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801225:	eb 0f                	jmp    801236 <strncmp+0x25>
		n--, p++, q++;
  801227:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80122c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801231:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801236:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123b:	74 1d                	je     80125a <strncmp+0x49>
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	0f b6 00             	movzbl (%rax),%eax
  801244:	84 c0                	test   %al,%al
  801246:	74 12                	je     80125a <strncmp+0x49>
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	0f b6 10             	movzbl (%rax),%edx
  80124f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801253:	0f b6 00             	movzbl (%rax),%eax
  801256:	38 c2                	cmp    %al,%dl
  801258:	74 cd                	je     801227 <strncmp+0x16>
	if (n == 0)
  80125a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80125f:	75 07                	jne    801268 <strncmp+0x57>
		return 0;
  801261:	b8 00 00 00 00       	mov    $0x0,%eax
  801266:	eb 18                	jmp    801280 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126c:	0f b6 00             	movzbl (%rax),%eax
  80126f:	0f b6 d0             	movzbl %al,%edx
  801272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801276:	0f b6 00             	movzbl (%rax),%eax
  801279:	0f b6 c0             	movzbl %al,%eax
  80127c:	29 c2                	sub    %eax,%edx
  80127e:	89 d0                	mov    %edx,%eax
}
  801280:	c9                   	leaveq 
  801281:	c3                   	retq   

0000000000801282 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801282:	55                   	push   %rbp
  801283:	48 89 e5             	mov    %rsp,%rbp
  801286:	48 83 ec 10          	sub    $0x10,%rsp
  80128a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128e:	89 f0                	mov    %esi,%eax
  801290:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801293:	eb 17                	jmp    8012ac <strchr+0x2a>
		if (*s == c)
  801295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80129f:	75 06                	jne    8012a7 <strchr+0x25>
			return (char *) s;
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	eb 15                	jmp    8012bc <strchr+0x3a>
	for (; *s; s++)
  8012a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b0:	0f b6 00             	movzbl (%rax),%eax
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 de                	jne    801295 <strchr+0x13>
	return 0;
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 83 ec 10          	sub    $0x10,%rsp
  8012c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ca:	89 f0                	mov    %esi,%eax
  8012cc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012cf:	eb 13                	jmp    8012e4 <strfind+0x26>
		if (*s == c)
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 00             	movzbl (%rax),%eax
  8012d8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012db:	75 02                	jne    8012df <strfind+0x21>
			break;
  8012dd:	eb 10                	jmp    8012ef <strfind+0x31>
	for (; *s; s++)
  8012df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	84 c0                	test   %al,%al
  8012ed:	75 e2                	jne    8012d1 <strfind+0x13>
	return (char *) s;
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f3:	c9                   	leaveq 
  8012f4:	c3                   	retq   

00000000008012f5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f5:	55                   	push   %rbp
  8012f6:	48 89 e5             	mov    %rsp,%rbp
  8012f9:	48 83 ec 18          	sub    $0x18,%rsp
  8012fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801301:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801304:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801308:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80130d:	75 06                	jne    801315 <memset+0x20>
		return v;
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	eb 69                	jmp    80137e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801319:	83 e0 03             	and    $0x3,%eax
  80131c:	48 85 c0             	test   %rax,%rax
  80131f:	75 48                	jne    801369 <memset+0x74>
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	83 e0 03             	and    $0x3,%eax
  801328:	48 85 c0             	test   %rax,%rax
  80132b:	75 3c                	jne    801369 <memset+0x74>
		c &= 0xFF;
  80132d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801334:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801337:	c1 e0 18             	shl    $0x18,%eax
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133f:	c1 e0 10             	shl    $0x10,%eax
  801342:	09 c2                	or     %eax,%edx
  801344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801347:	c1 e0 08             	shl    $0x8,%eax
  80134a:	09 d0                	or     %edx,%eax
  80134c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80134f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801353:	48 c1 e8 02          	shr    $0x2,%rax
  801357:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80135a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801361:	48 89 d7             	mov    %rdx,%rdi
  801364:	fc                   	cld    
  801365:	f3 ab                	rep stos %eax,%es:(%rdi)
  801367:	eb 11                	jmp    80137a <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801369:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801370:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801374:	48 89 d7             	mov    %rdx,%rdi
  801377:	fc                   	cld    
  801378:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137e:	c9                   	leaveq 
  80137f:	c3                   	retq   

0000000000801380 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	48 83 ec 28          	sub    $0x28,%rsp
  801388:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801390:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801394:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801398:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80139c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ac:	0f 83 88 00 00 00    	jae    80143a <memmove+0xba>
  8013b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ba:	48 01 d0             	add    %rdx,%rax
  8013bd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c1:	76 77                	jbe    80143a <memmove+0xba>
		s += n;
  8013c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cf:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d7:	83 e0 03             	and    $0x3,%eax
  8013da:	48 85 c0             	test   %rax,%rax
  8013dd:	75 3b                	jne    80141a <memmove+0x9a>
  8013df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e3:	83 e0 03             	and    $0x3,%eax
  8013e6:	48 85 c0             	test   %rax,%rax
  8013e9:	75 2f                	jne    80141a <memmove+0x9a>
  8013eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ef:	83 e0 03             	and    $0x3,%eax
  8013f2:	48 85 c0             	test   %rax,%rax
  8013f5:	75 23                	jne    80141a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fb:	48 83 e8 04          	sub    $0x4,%rax
  8013ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801403:	48 83 ea 04          	sub    $0x4,%rdx
  801407:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80140b:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80140f:	48 89 c7             	mov    %rax,%rdi
  801412:	48 89 d6             	mov    %rdx,%rsi
  801415:	fd                   	std    
  801416:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801418:	eb 1d                	jmp    801437 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80141a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801426:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	48 89 d7             	mov    %rdx,%rdi
  801431:	48 89 c1             	mov    %rax,%rcx
  801434:	fd                   	std    
  801435:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801437:	fc                   	cld    
  801438:	eb 57                	jmp    801491 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80143a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143e:	83 e0 03             	and    $0x3,%eax
  801441:	48 85 c0             	test   %rax,%rax
  801444:	75 36                	jne    80147c <memmove+0xfc>
  801446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144a:	83 e0 03             	and    $0x3,%eax
  80144d:	48 85 c0             	test   %rax,%rax
  801450:	75 2a                	jne    80147c <memmove+0xfc>
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	83 e0 03             	and    $0x3,%eax
  801459:	48 85 c0             	test   %rax,%rax
  80145c:	75 1e                	jne    80147c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80145e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801462:	48 c1 e8 02          	shr    $0x2,%rax
  801466:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801471:	48 89 c7             	mov    %rax,%rdi
  801474:	48 89 d6             	mov    %rdx,%rsi
  801477:	fc                   	cld    
  801478:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80147a:	eb 15                	jmp    801491 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80147c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801484:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801488:	48 89 c7             	mov    %rax,%rdi
  80148b:	48 89 d6             	mov    %rdx,%rsi
  80148e:	fc                   	cld    
  80148f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801495:	c9                   	leaveq 
  801496:	c3                   	retq   

0000000000801497 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801497:	55                   	push   %rbp
  801498:	48 89 e5             	mov    %rsp,%rbp
  80149b:	48 83 ec 18          	sub    $0x18,%rsp
  80149f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014af:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b7:	48 89 ce             	mov    %rcx,%rsi
  8014ba:	48 89 c7             	mov    %rax,%rdi
  8014bd:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  8014c4:	00 00 00 
  8014c7:	ff d0                	callq  *%rax
}
  8014c9:	c9                   	leaveq 
  8014ca:	c3                   	retq   

00000000008014cb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014cb:	55                   	push   %rbp
  8014cc:	48 89 e5             	mov    %rsp,%rbp
  8014cf:	48 83 ec 28          	sub    $0x28,%rsp
  8014d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014ef:	eb 36                	jmp    801527 <memcmp+0x5c>
		if (*s1 != *s2)
  8014f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f5:	0f b6 10             	movzbl (%rax),%edx
  8014f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	38 c2                	cmp    %al,%dl
  801501:	74 1a                	je     80151d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	0f b6 d0             	movzbl %al,%edx
  80150d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
  80151b:	eb 20                	jmp    80153d <memcmp+0x72>
		s1++, s2++;
  80151d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801522:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80152f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801533:	48 85 c0             	test   %rax,%rax
  801536:	75 b9                	jne    8014f1 <memcmp+0x26>
	}

	return 0;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 83 ec 28          	sub    $0x28,%rsp
  801547:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80154e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801552:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155a:	48 01 d0             	add    %rdx,%rax
  80155d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801561:	eb 15                	jmp    801578 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801563:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80156d:	38 d0                	cmp    %dl,%al
  80156f:	75 02                	jne    801573 <memfind+0x34>
			break;
  801571:	eb 0f                	jmp    801582 <memfind+0x43>
	for (; s < ends; s++)
  801573:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801580:	72 e1                	jb     801563 <memfind+0x24>
	return (void *) s;
  801582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801586:	c9                   	leaveq 
  801587:	c3                   	retq   

0000000000801588 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801588:	55                   	push   %rbp
  801589:	48 89 e5             	mov    %rsp,%rbp
  80158c:	48 83 ec 38          	sub    $0x38,%rsp
  801590:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801594:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801598:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80159b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015a2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015a9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015aa:	eb 05                	jmp    8015b1 <strtol+0x29>
		s++;
  8015ac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 20                	cmp    $0x20,%al
  8015ba:	74 f0                	je     8015ac <strtol+0x24>
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	3c 09                	cmp    $0x9,%al
  8015c5:	74 e5                	je     8015ac <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3c 2b                	cmp    $0x2b,%al
  8015d0:	75 07                	jne    8015d9 <strtol+0x51>
		s++;
  8015d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d7:	eb 17                	jmp    8015f0 <strtol+0x68>
	else if (*s == '-')
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0c                	jne    8015f0 <strtol+0x68>
		s++, neg = 1;
  8015e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f4:	74 06                	je     8015fc <strtol+0x74>
  8015f6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015fa:	75 28                	jne    801624 <strtol+0x9c>
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	3c 30                	cmp    $0x30,%al
  801605:	75 1d                	jne    801624 <strtol+0x9c>
  801607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160b:	48 83 c0 01          	add    $0x1,%rax
  80160f:	0f b6 00             	movzbl (%rax),%eax
  801612:	3c 78                	cmp    $0x78,%al
  801614:	75 0e                	jne    801624 <strtol+0x9c>
		s += 2, base = 16;
  801616:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80161b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801622:	eb 2c                	jmp    801650 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801624:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801628:	75 19                	jne    801643 <strtol+0xbb>
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	3c 30                	cmp    $0x30,%al
  801633:	75 0e                	jne    801643 <strtol+0xbb>
		s++, base = 8;
  801635:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801641:	eb 0d                	jmp    801650 <strtol+0xc8>
	else if (base == 0)
  801643:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801647:	75 07                	jne    801650 <strtol+0xc8>
		base = 10;
  801649:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 2f                	cmp    $0x2f,%al
  801659:	7e 1d                	jle    801678 <strtol+0xf0>
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	3c 39                	cmp    $0x39,%al
  801664:	7f 12                	jg     801678 <strtol+0xf0>
			dig = *s - '0';
  801666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166a:	0f b6 00             	movzbl (%rax),%eax
  80166d:	0f be c0             	movsbl %al,%eax
  801670:	83 e8 30             	sub    $0x30,%eax
  801673:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801676:	eb 4e                	jmp    8016c6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 60                	cmp    $0x60,%al
  801681:	7e 1d                	jle    8016a0 <strtol+0x118>
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	3c 7a                	cmp    $0x7a,%al
  80168c:	7f 12                	jg     8016a0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	0f be c0             	movsbl %al,%eax
  801698:	83 e8 57             	sub    $0x57,%eax
  80169b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169e:	eb 26                	jmp    8016c6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 40                	cmp    $0x40,%al
  8016a9:	7e 48                	jle    8016f3 <strtol+0x16b>
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	3c 5a                	cmp    $0x5a,%al
  8016b4:	7f 3d                	jg     8016f3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016cc:	7c 02                	jl     8016d0 <strtol+0x148>
			break;
  8016ce:	eb 23                	jmp    8016f3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016d8:	48 98                	cltq   
  8016da:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016df:	48 89 c2             	mov    %rax,%rdx
  8016e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e5:	48 98                	cltq   
  8016e7:	48 01 d0             	add    %rdx,%rax
  8016ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016ee:	e9 5d ff ff ff       	jmpq   801650 <strtol+0xc8>

	if (endptr)
  8016f3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016f8:	74 0b                	je     801705 <strtol+0x17d>
		*endptr = (char *) s;
  8016fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801702:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801709:	74 09                	je     801714 <strtol+0x18c>
  80170b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170f:	48 f7 d8             	neg    %rax
  801712:	eb 04                	jmp    801718 <strtol+0x190>
  801714:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801718:	c9                   	leaveq 
  801719:	c3                   	retq   

000000000080171a <strstr>:

char * strstr(const char *in, const char *str)
{
  80171a:	55                   	push   %rbp
  80171b:	48 89 e5             	mov    %rsp,%rbp
  80171e:	48 83 ec 30          	sub    $0x30,%rsp
  801722:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801726:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80172a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801732:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80173c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801740:	75 06                	jne    801748 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	eb 6b                	jmp    8017b3 <strstr+0x99>

	len = strlen(str);
  801748:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174c:	48 89 c7             	mov    %rax,%rdi
  80174f:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
  80175b:	48 98                	cltq   
  80175d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801765:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801769:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80176d:	0f b6 00             	movzbl (%rax),%eax
  801770:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801773:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801777:	75 07                	jne    801780 <strstr+0x66>
				return (char *) 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
  80177e:	eb 33                	jmp    8017b3 <strstr+0x99>
		} while (sc != c);
  801780:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801784:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801787:	75 d8                	jne    801761 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801789:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	48 89 ce             	mov    %rcx,%rsi
  801798:	48 89 c7             	mov    %rax,%rdi
  80179b:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8017a2:	00 00 00 
  8017a5:	ff d0                	callq  *%rax
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	75 b6                	jne    801761 <strstr+0x47>

	return (char *) (in - 1);
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	48 83 e8 01          	sub    $0x1,%rax
}
  8017b3:	c9                   	leaveq 
  8017b4:	c3                   	retq   

00000000008017b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017b5:	55                   	push   %rbp
  8017b6:	48 89 e5             	mov    %rsp,%rbp
  8017b9:	53                   	push   %rbx
  8017ba:	48 83 ec 48          	sub    $0x48,%rsp
  8017be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017c1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017c4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017c8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017cc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017d0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017db:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017df:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017e3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017e7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017eb:	4c 89 c3             	mov    %r8,%rbx
  8017ee:	cd 30                	int    $0x30
  8017f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017f8:	74 3e                	je     801838 <syscall+0x83>
  8017fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ff:	7e 37                	jle    801838 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801805:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801808:	49 89 d0             	mov    %rdx,%r8
  80180b:	89 c1                	mov    %eax,%ecx
  80180d:	48 ba 48 4a 80 00 00 	movabs $0x804a48,%rdx
  801814:	00 00 00 
  801817:	be 23 00 00 00       	mov    $0x23,%esi
  80181c:	48 bf 65 4a 80 00 00 	movabs $0x804a65,%rdi
  801823:	00 00 00 
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
  80182b:	49 b9 99 3b 80 00 00 	movabs $0x803b99,%r9
  801832:	00 00 00 
  801835:	41 ff d1             	callq  *%r9

	return ret;
  801838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183c:	48 83 c4 48          	add    $0x48,%rsp
  801840:	5b                   	pop    %rbx
  801841:	5d                   	pop    %rbp
  801842:	c3                   	retq   

0000000000801843 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801843:	55                   	push   %rbp
  801844:	48 89 e5             	mov    %rsp,%rbp
  801847:	48 83 ec 10          	sub    $0x10,%rsp
  80184b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80184f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801853:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801857:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185b:	48 83 ec 08          	sub    $0x8,%rsp
  80185f:	6a 00                	pushq  $0x0
  801861:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801867:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186d:	48 89 d1             	mov    %rdx,%rcx
  801870:	48 89 c2             	mov    %rax,%rdx
  801873:	be 00 00 00 00       	mov    $0x0,%esi
  801878:	bf 00 00 00 00       	mov    $0x0,%edi
  80187d:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801884:	00 00 00 
  801887:	ff d0                	callq  *%rax
  801889:	48 83 c4 10          	add    $0x10,%rsp
}
  80188d:	c9                   	leaveq 
  80188e:	c3                   	retq   

000000000080188f <sys_cgetc>:

int
sys_cgetc(void)
{
  80188f:	55                   	push   %rbp
  801890:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801893:	48 83 ec 08          	sub    $0x8,%rsp
  801897:	6a 00                	pushq  $0x0
  801899:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018af:	be 00 00 00 00       	mov    $0x0,%esi
  8018b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b9:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
  8018c5:	48 83 c4 10          	add    $0x10,%rsp
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 10          	sub    $0x10,%rsp
  8018d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d9:	48 98                	cltq   
  8018db:	48 83 ec 08          	sub    $0x8,%rsp
  8018df:	6a 00                	pushq  $0x0
  8018e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f2:	48 89 c2             	mov    %rax,%rdx
  8018f5:	be 01 00 00 00       	mov    $0x1,%esi
  8018fa:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ff:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
  80190b:	48 83 c4 10          	add    $0x10,%rsp
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801915:	48 83 ec 08          	sub    $0x8,%rsp
  801919:	6a 00                	pushq  $0x0
  80191b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801921:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801927:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192c:	ba 00 00 00 00       	mov    $0x0,%edx
  801931:	be 00 00 00 00       	mov    $0x0,%esi
  801936:	bf 02 00 00 00       	mov    $0x2,%edi
  80193b:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801942:	00 00 00 
  801945:	ff d0                	callq  *%rax
  801947:	48 83 c4 10          	add    $0x10,%rsp
}
  80194b:	c9                   	leaveq 
  80194c:	c3                   	retq   

000000000080194d <sys_yield>:

void
sys_yield(void)
{
  80194d:	55                   	push   %rbp
  80194e:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801951:	48 83 ec 08          	sub    $0x8,%rsp
  801955:	6a 00                	pushq  $0x0
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801963:	b9 00 00 00 00       	mov    $0x0,%ecx
  801968:	ba 00 00 00 00       	mov    $0x0,%edx
  80196d:	be 00 00 00 00       	mov    $0x0,%esi
  801972:	bf 0b 00 00 00       	mov    $0xb,%edi
  801977:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  80197e:	00 00 00 
  801981:	ff d0                	callq  *%rax
  801983:	48 83 c4 10          	add    $0x10,%rsp
}
  801987:	c9                   	leaveq 
  801988:	c3                   	retq   

0000000000801989 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801989:	55                   	push   %rbp
  80198a:	48 89 e5             	mov    %rsp,%rbp
  80198d:	48 83 ec 10          	sub    $0x10,%rsp
  801991:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801994:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801998:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80199b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199e:	48 63 c8             	movslq %eax,%rcx
  8019a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a8:	48 98                	cltq   
  8019aa:	48 83 ec 08          	sub    $0x8,%rsp
  8019ae:	6a 00                	pushq  $0x0
  8019b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b6:	49 89 c8             	mov    %rcx,%r8
  8019b9:	48 89 d1             	mov    %rdx,%rcx
  8019bc:	48 89 c2             	mov    %rax,%rdx
  8019bf:	be 01 00 00 00       	mov    $0x1,%esi
  8019c4:	bf 04 00 00 00       	mov    $0x4,%edi
  8019c9:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
  8019d5:	48 83 c4 10          	add    $0x10,%rsp
}
  8019d9:	c9                   	leaveq 
  8019da:	c3                   	retq   

00000000008019db <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019db:	55                   	push   %rbp
  8019dc:	48 89 e5             	mov    %rsp,%rbp
  8019df:	48 83 ec 20          	sub    $0x20,%rsp
  8019e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ea:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019ed:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019f5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019f8:	48 63 c8             	movslq %eax,%rcx
  8019fb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a02:	48 63 f0             	movslq %eax,%rsi
  801a05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0c:	48 98                	cltq   
  801a0e:	48 83 ec 08          	sub    $0x8,%rsp
  801a12:	51                   	push   %rcx
  801a13:	49 89 f9             	mov    %rdi,%r9
  801a16:	49 89 f0             	mov    %rsi,%r8
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 01 00 00 00       	mov    $0x1,%esi
  801a24:	bf 05 00 00 00       	mov    $0x5,%edi
  801a29:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
  801a35:	48 83 c4 10          	add    $0x10,%rsp
}
  801a39:	c9                   	leaveq 
  801a3a:	c3                   	retq   

0000000000801a3b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a3b:	55                   	push   %rbp
  801a3c:	48 89 e5             	mov    %rsp,%rbp
  801a3f:	48 83 ec 10          	sub    $0x10,%rsp
  801a43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a51:	48 98                	cltq   
  801a53:	48 83 ec 08          	sub    $0x8,%rsp
  801a57:	6a 00                	pushq  $0x0
  801a59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a65:	48 89 d1             	mov    %rdx,%rcx
  801a68:	48 89 c2             	mov    %rax,%rdx
  801a6b:	be 01 00 00 00       	mov    $0x1,%esi
  801a70:	bf 06 00 00 00       	mov    $0x6,%edi
  801a75:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801a7c:	00 00 00 
  801a7f:	ff d0                	callq  *%rax
  801a81:	48 83 c4 10          	add    $0x10,%rsp
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	48 83 ec 10          	sub    $0x10,%rsp
  801a8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a92:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a98:	48 63 d0             	movslq %eax,%rdx
  801a9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9e:	48 98                	cltq   
  801aa0:	48 83 ec 08          	sub    $0x8,%rsp
  801aa4:	6a 00                	pushq  $0x0
  801aa6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab2:	48 89 d1             	mov    %rdx,%rcx
  801ab5:	48 89 c2             	mov    %rax,%rdx
  801ab8:	be 01 00 00 00       	mov    $0x1,%esi
  801abd:	bf 08 00 00 00       	mov    $0x8,%edi
  801ac2:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
  801ace:	48 83 c4 10          	add    $0x10,%rsp
}
  801ad2:	c9                   	leaveq 
  801ad3:	c3                   	retq   

0000000000801ad4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ad4:	55                   	push   %rbp
  801ad5:	48 89 e5             	mov    %rsp,%rbp
  801ad8:	48 83 ec 10          	sub    $0x10,%rsp
  801adc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801adf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ae3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aea:	48 98                	cltq   
  801aec:	48 83 ec 08          	sub    $0x8,%rsp
  801af0:	6a 00                	pushq  $0x0
  801af2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afe:	48 89 d1             	mov    %rdx,%rcx
  801b01:	48 89 c2             	mov    %rax,%rdx
  801b04:	be 01 00 00 00       	mov    $0x1,%esi
  801b09:	bf 09 00 00 00       	mov    $0x9,%edi
  801b0e:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801b15:	00 00 00 
  801b18:	ff d0                	callq  *%rax
  801b1a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	48 83 ec 10          	sub    $0x10,%rsp
  801b28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b36:	48 98                	cltq   
  801b38:	48 83 ec 08          	sub    $0x8,%rsp
  801b3c:	6a 00                	pushq  $0x0
  801b3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4a:	48 89 d1             	mov    %rdx,%rcx
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	be 01 00 00 00       	mov    $0x1,%esi
  801b55:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b5a:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
  801b66:	48 83 c4 10          	add    $0x10,%rsp
}
  801b6a:	c9                   	leaveq 
  801b6b:	c3                   	retq   

0000000000801b6c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b6c:	55                   	push   %rbp
  801b6d:	48 89 e5             	mov    %rsp,%rbp
  801b70:	48 83 ec 20          	sub    $0x20,%rsp
  801b74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b7b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b7f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b85:	48 63 f0             	movslq %eax,%rsi
  801b88:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8f:	48 98                	cltq   
  801b91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b95:	48 83 ec 08          	sub    $0x8,%rsp
  801b99:	6a 00                	pushq  $0x0
  801b9b:	49 89 f1             	mov    %rsi,%r9
  801b9e:	49 89 c8             	mov    %rcx,%r8
  801ba1:	48 89 d1             	mov    %rdx,%rcx
  801ba4:	48 89 c2             	mov    %rax,%rdx
  801ba7:	be 00 00 00 00       	mov    $0x0,%esi
  801bac:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bb1:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	callq  *%rax
  801bbd:	48 83 c4 10          	add    $0x10,%rsp
}
  801bc1:	c9                   	leaveq 
  801bc2:	c3                   	retq   

0000000000801bc3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bc3:	55                   	push   %rbp
  801bc4:	48 89 e5             	mov    %rsp,%rbp
  801bc7:	48 83 ec 10          	sub    $0x10,%rsp
  801bcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd3:	48 83 ec 08          	sub    $0x8,%rsp
  801bd7:	6a 00                	pushq  $0x0
  801bd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bea:	48 89 c2             	mov    %rax,%rdx
  801bed:	be 01 00 00 00       	mov    $0x1,%esi
  801bf2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bf7:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	callq  *%rax
  801c03:	48 83 c4 10          	add    $0x10,%rsp
}
  801c07:	c9                   	leaveq 
  801c08:	c3                   	retq   

0000000000801c09 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c09:	55                   	push   %rbp
  801c0a:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c0d:	48 83 ec 08          	sub    $0x8,%rsp
  801c11:	6a 00                	pushq  $0x0
  801c13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	be 00 00 00 00       	mov    $0x0,%esi
  801c2e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c33:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
  801c3f:	48 83 c4 10          	add    $0x10,%rsp
}
  801c43:	c9                   	leaveq 
  801c44:	c3                   	retq   

0000000000801c45 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c45:	55                   	push   %rbp
  801c46:	48 89 e5             	mov    %rsp,%rbp
  801c49:	48 83 ec 20          	sub    $0x20,%rsp
  801c4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c54:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c57:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c5b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c5f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c62:	48 63 c8             	movslq %eax,%rcx
  801c65:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c6c:	48 63 f0             	movslq %eax,%rsi
  801c6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c76:	48 98                	cltq   
  801c78:	48 83 ec 08          	sub    $0x8,%rsp
  801c7c:	51                   	push   %rcx
  801c7d:	49 89 f9             	mov    %rdi,%r9
  801c80:	49 89 f0             	mov    %rsi,%r8
  801c83:	48 89 d1             	mov    %rdx,%rcx
  801c86:	48 89 c2             	mov    %rax,%rdx
  801c89:	be 00 00 00 00       	mov    $0x0,%esi
  801c8e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c93:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	callq  *%rax
  801c9f:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 10          	sub    $0x10,%rsp
  801cad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801cb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbd:	48 83 ec 08          	sub    $0x8,%rsp
  801cc1:	6a 00                	pushq  $0x0
  801cc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ccf:	48 89 d1             	mov    %rdx,%rcx
  801cd2:	48 89 c2             	mov    %rax,%rdx
  801cd5:	be 00 00 00 00       	mov    $0x0,%esi
  801cda:	bf 10 00 00 00       	mov    $0x10,%edi
  801cdf:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	48 83 c4 10          	add    $0x10,%rsp
}
  801cef:	c9                   	leaveq 
  801cf0:	c3                   	retq   

0000000000801cf1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cf1:	55                   	push   %rbp
  801cf2:	48 89 e5             	mov    %rsp,%rbp
  801cf5:	48 83 ec 08          	sub    $0x8,%rsp
  801cf9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cfd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d01:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d08:	ff ff ff 
  801d0b:	48 01 d0             	add    %rdx,%rax
  801d0e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d12:	c9                   	leaveq 
  801d13:	c3                   	retq   

0000000000801d14 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d14:	55                   	push   %rbp
  801d15:	48 89 e5             	mov    %rsp,%rbp
  801d18:	48 83 ec 08          	sub    $0x8,%rsp
  801d1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d24:	48 89 c7             	mov    %rax,%rdi
  801d27:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  801d2e:	00 00 00 
  801d31:	ff d0                	callq  *%rax
  801d33:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d39:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d3d:	c9                   	leaveq 
  801d3e:	c3                   	retq   

0000000000801d3f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d3f:	55                   	push   %rbp
  801d40:	48 89 e5             	mov    %rsp,%rbp
  801d43:	48 83 ec 18          	sub    $0x18,%rsp
  801d47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d52:	eb 6b                	jmp    801dbf <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d57:	48 98                	cltq   
  801d59:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d5f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d63:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6b:	48 c1 e8 15          	shr    $0x15,%rax
  801d6f:	48 89 c2             	mov    %rax,%rdx
  801d72:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d79:	01 00 00 
  801d7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d80:	83 e0 01             	and    $0x1,%eax
  801d83:	48 85 c0             	test   %rax,%rax
  801d86:	74 21                	je     801da9 <fd_alloc+0x6a>
  801d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d90:	48 89 c2             	mov    %rax,%rdx
  801d93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d9a:	01 00 00 
  801d9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da1:	83 e0 01             	and    $0x1,%eax
  801da4:	48 85 c0             	test   %rax,%rax
  801da7:	75 12                	jne    801dbb <fd_alloc+0x7c>
			*fd_store = fd;
  801da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	eb 1a                	jmp    801dd5 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801dbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dbf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dc3:	7e 8f                	jle    801d54 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dd0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dd5:	c9                   	leaveq 
  801dd6:	c3                   	retq   

0000000000801dd7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 83 ec 20          	sub    $0x20,%rsp
  801ddf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801de6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dea:	78 06                	js     801df2 <fd_lookup+0x1b>
  801dec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801df0:	7e 07                	jle    801df9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801df7:	eb 6c                	jmp    801e65 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801df9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dfc:	48 98                	cltq   
  801dfe:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e04:	48 c1 e0 0c          	shl    $0xc,%rax
  801e08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e10:	48 c1 e8 15          	shr    $0x15,%rax
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e1e:	01 00 00 
  801e21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e25:	83 e0 01             	and    $0x1,%eax
  801e28:	48 85 c0             	test   %rax,%rax
  801e2b:	74 21                	je     801e4e <fd_lookup+0x77>
  801e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e31:	48 c1 e8 0c          	shr    $0xc,%rax
  801e35:	48 89 c2             	mov    %rax,%rdx
  801e38:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3f:	01 00 00 
  801e42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e46:	83 e0 01             	and    $0x1,%eax
  801e49:	48 85 c0             	test   %rax,%rax
  801e4c:	75 07                	jne    801e55 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e53:	eb 10                	jmp    801e65 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e5d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e65:	c9                   	leaveq 
  801e66:	c3                   	retq   

0000000000801e67 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	48 83 ec 30          	sub    $0x30,%rsp
  801e6f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7c:	48 89 c7             	mov    %rax,%rdi
  801e7f:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  801e86:	00 00 00 
  801e89:	ff d0                	callq  *%rax
  801e8b:	89 c2                	mov    %eax,%edx
  801e8d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801e91:	48 89 c6             	mov    %rax,%rsi
  801e94:	89 d7                	mov    %edx,%edi
  801e96:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  801e9d:	00 00 00 
  801ea0:	ff d0                	callq  *%rax
  801ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea9:	78 0a                	js     801eb5 <fd_close+0x4e>
	    || fd != fd2)
  801eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eaf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eb3:	74 12                	je     801ec7 <fd_close+0x60>
		return (must_exist ? r : 0);
  801eb5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801eb9:	74 05                	je     801ec0 <fd_close+0x59>
  801ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ebe:	eb 70                	jmp    801f30 <fd_close+0xc9>
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec5:	eb 69                	jmp    801f30 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ec7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecb:	8b 00                	mov    (%rax),%eax
  801ecd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ed1:	48 89 d6             	mov    %rdx,%rsi
  801ed4:	89 c7                	mov    %eax,%edi
  801ed6:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  801edd:	00 00 00 
  801ee0:	ff d0                	callq  *%rax
  801ee2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ee5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ee9:	78 2a                	js     801f15 <fd_close+0xae>
		if (dev->dev_close)
  801eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eef:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ef3:	48 85 c0             	test   %rax,%rax
  801ef6:	74 16                	je     801f0e <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801efc:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f00:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f04:	48 89 d7             	mov    %rdx,%rdi
  801f07:	ff d0                	callq  *%rax
  801f09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f0c:	eb 07                	jmp    801f15 <fd_close+0xae>
		else
			r = 0;
  801f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f19:	48 89 c6             	mov    %rax,%rsi
  801f1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f21:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  801f28:	00 00 00 
  801f2b:	ff d0                	callq  *%rax
	return r;
  801f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f30:	c9                   	leaveq 
  801f31:	c3                   	retq   

0000000000801f32 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f32:	55                   	push   %rbp
  801f33:	48 89 e5             	mov    %rsp,%rbp
  801f36:	48 83 ec 20          	sub    $0x20,%rsp
  801f3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f3d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f48:	eb 41                	jmp    801f8b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f4a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f51:	00 00 00 
  801f54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f57:	48 63 d2             	movslq %edx,%rdx
  801f5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5e:	8b 00                	mov    (%rax),%eax
  801f60:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f63:	75 22                	jne    801f87 <dev_lookup+0x55>
			*dev = devtab[i];
  801f65:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f6c:	00 00 00 
  801f6f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f72:	48 63 d2             	movslq %edx,%rdx
  801f75:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f7d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	eb 60                	jmp    801fe7 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801f87:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f8b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f92:	00 00 00 
  801f95:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f98:	48 63 d2             	movslq %edx,%rdx
  801f9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9f:	48 85 c0             	test   %rax,%rax
  801fa2:	75 a6                	jne    801f4a <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fa4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fab:	00 00 00 
  801fae:	48 8b 00             	mov    (%rax),%rax
  801fb1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fb7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fba:	89 c6                	mov    %eax,%esi
  801fbc:	48 bf 78 4a 80 00 00 	movabs $0x804a78,%rdi
  801fc3:	00 00 00 
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801fd2:	00 00 00 
  801fd5:	ff d1                	callq  *%rcx
	*dev = 0;
  801fd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fe2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <close>:

int
close(int fdnum)
{
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
  801fed:	48 83 ec 20          	sub    $0x20,%rsp
  801ff1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ff8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ffb:	48 89 d6             	mov    %rdx,%rsi
  801ffe:	89 c7                	mov    %eax,%edi
  802000:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802007:	00 00 00 
  80200a:	ff d0                	callq  *%rax
  80200c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802013:	79 05                	jns    80201a <close+0x31>
		return r;
  802015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802018:	eb 18                	jmp    802032 <close+0x49>
	else
		return fd_close(fd, 1);
  80201a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201e:	be 01 00 00 00       	mov    $0x1,%esi
  802023:	48 89 c7             	mov    %rax,%rdi
  802026:	48 b8 67 1e 80 00 00 	movabs $0x801e67,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
}
  802032:	c9                   	leaveq 
  802033:	c3                   	retq   

0000000000802034 <close_all>:

void
close_all(void)
{
  802034:	55                   	push   %rbp
  802035:	48 89 e5             	mov    %rsp,%rbp
  802038:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80203c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802043:	eb 15                	jmp    80205a <close_all+0x26>
		close(i);
  802045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802048:	89 c7                	mov    %eax,%edi
  80204a:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802051:	00 00 00 
  802054:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802056:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80205e:	7e e5                	jle    802045 <close_all+0x11>
}
  802060:	c9                   	leaveq 
  802061:	c3                   	retq   

0000000000802062 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802062:	55                   	push   %rbp
  802063:	48 89 e5             	mov    %rsp,%rbp
  802066:	48 83 ec 40          	sub    $0x40,%rsp
  80206a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80206d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802070:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802074:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802077:	48 89 d6             	mov    %rdx,%rsi
  80207a:	89 c7                	mov    %eax,%edi
  80207c:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802083:	00 00 00 
  802086:	ff d0                	callq  *%rax
  802088:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80208b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208f:	79 08                	jns    802099 <dup+0x37>
		return r;
  802091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802094:	e9 70 01 00 00       	jmpq   802209 <dup+0x1a7>
	close(newfdnum);
  802099:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80209c:	89 c7                	mov    %eax,%edi
  80209e:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020aa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ad:	48 98                	cltq   
  8020af:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020b5:	48 c1 e0 0c          	shl    $0xc,%rax
  8020b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c1:	48 89 c7             	mov    %rax,%rdi
  8020c4:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8020cb:	00 00 00 
  8020ce:	ff d0                	callq  *%rax
  8020d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d8:	48 89 c7             	mov    %rax,%rdi
  8020db:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
  8020e7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ef:	48 c1 e8 15          	shr    $0x15,%rax
  8020f3:	48 89 c2             	mov    %rax,%rdx
  8020f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020fd:	01 00 00 
  802100:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802104:	83 e0 01             	and    $0x1,%eax
  802107:	48 85 c0             	test   %rax,%rax
  80210a:	74 73                	je     80217f <dup+0x11d>
  80210c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802110:	48 c1 e8 0c          	shr    $0xc,%rax
  802114:	48 89 c2             	mov    %rax,%rdx
  802117:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80211e:	01 00 00 
  802121:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802125:	83 e0 01             	and    $0x1,%eax
  802128:	48 85 c0             	test   %rax,%rax
  80212b:	74 52                	je     80217f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80212d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802131:	48 c1 e8 0c          	shr    $0xc,%rax
  802135:	48 89 c2             	mov    %rax,%rdx
  802138:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213f:	01 00 00 
  802142:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802146:	25 07 0e 00 00       	and    $0xe07,%eax
  80214b:	89 c1                	mov    %eax,%ecx
  80214d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802155:	41 89 c8             	mov    %ecx,%r8d
  802158:	48 89 d1             	mov    %rdx,%rcx
  80215b:	ba 00 00 00 00       	mov    $0x0,%edx
  802160:	48 89 c6             	mov    %rax,%rsi
  802163:	bf 00 00 00 00       	mov    $0x0,%edi
  802168:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  80216f:	00 00 00 
  802172:	ff d0                	callq  *%rax
  802174:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802177:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217b:	79 02                	jns    80217f <dup+0x11d>
			goto err;
  80217d:	eb 57                	jmp    8021d6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80217f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802183:	48 c1 e8 0c          	shr    $0xc,%rax
  802187:	48 89 c2             	mov    %rax,%rdx
  80218a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802191:	01 00 00 
  802194:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802198:	25 07 0e 00 00       	and    $0xe07,%eax
  80219d:	89 c1                	mov    %eax,%ecx
  80219f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021a7:	41 89 c8             	mov    %ecx,%r8d
  8021aa:	48 89 d1             	mov    %rdx,%rcx
  8021ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b2:	48 89 c6             	mov    %rax,%rsi
  8021b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ba:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	callq  *%rax
  8021c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cd:	79 02                	jns    8021d1 <dup+0x16f>
		goto err;
  8021cf:	eb 05                	jmp    8021d6 <dup+0x174>

	return newfdnum;
  8021d1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d4:	eb 33                	jmp    802209 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021da:	48 89 c6             	mov    %rax,%rsi
  8021dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e2:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f2:	48 89 c6             	mov    %rax,%rsi
  8021f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fa:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  802201:	00 00 00 
  802204:	ff d0                	callq  *%rax
	return r;
  802206:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802209:	c9                   	leaveq 
  80220a:	c3                   	retq   

000000000080220b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	48 83 ec 40          	sub    $0x40,%rsp
  802213:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802216:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80221a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80221e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802222:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802225:	48 89 d6             	mov    %rdx,%rsi
  802228:	89 c7                	mov    %eax,%edi
  80222a:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax
  802236:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802239:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223d:	78 24                	js     802263 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80223f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802243:	8b 00                	mov    (%rax),%eax
  802245:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802249:	48 89 d6             	mov    %rdx,%rsi
  80224c:	89 c7                	mov    %eax,%edi
  80224e:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
  80225a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802261:	79 05                	jns    802268 <read+0x5d>
		return r;
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802266:	eb 76                	jmp    8022de <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226c:	8b 40 08             	mov    0x8(%rax),%eax
  80226f:	83 e0 03             	and    $0x3,%eax
  802272:	83 f8 01             	cmp    $0x1,%eax
  802275:	75 3a                	jne    8022b1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802277:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80227e:	00 00 00 
  802281:	48 8b 00             	mov    (%rax),%rax
  802284:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80228a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80228d:	89 c6                	mov    %eax,%esi
  80228f:	48 bf 97 4a 80 00 00 	movabs $0x804a97,%rdi
  802296:	00 00 00 
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
  80229e:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8022a5:	00 00 00 
  8022a8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022af:	eb 2d                	jmp    8022de <read+0xd3>
	}
	if (!dev->dev_read)
  8022b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022b9:	48 85 c0             	test   %rax,%rax
  8022bc:	75 07                	jne    8022c5 <read+0xba>
		return -E_NOT_SUPP;
  8022be:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022c3:	eb 19                	jmp    8022de <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022cd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022d1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022d5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022d9:	48 89 cf             	mov    %rcx,%rdi
  8022dc:	ff d0                	callq  *%rax
}
  8022de:	c9                   	leaveq 
  8022df:	c3                   	retq   

00000000008022e0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022e0:	55                   	push   %rbp
  8022e1:	48 89 e5             	mov    %rsp,%rbp
  8022e4:	48 83 ec 30          	sub    $0x30,%rsp
  8022e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022fa:	eb 49                	jmp    802345 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ff:	48 98                	cltq   
  802301:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802305:	48 29 c2             	sub    %rax,%rdx
  802308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230b:	48 63 c8             	movslq %eax,%rcx
  80230e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802312:	48 01 c1             	add    %rax,%rcx
  802315:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802318:	48 89 ce             	mov    %rcx,%rsi
  80231b:	89 c7                	mov    %eax,%edi
  80231d:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  802324:	00 00 00 
  802327:	ff d0                	callq  *%rax
  802329:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80232c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802330:	79 05                	jns    802337 <readn+0x57>
			return m;
  802332:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802335:	eb 1c                	jmp    802353 <readn+0x73>
		if (m == 0)
  802337:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80233b:	75 02                	jne    80233f <readn+0x5f>
			break;
  80233d:	eb 11                	jmp    802350 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80233f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802342:	01 45 fc             	add    %eax,-0x4(%rbp)
  802345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802348:	48 98                	cltq   
  80234a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80234e:	72 ac                	jb     8022fc <readn+0x1c>
	}
	return tot;
  802350:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802353:	c9                   	leaveq 
  802354:	c3                   	retq   

0000000000802355 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802355:	55                   	push   %rbp
  802356:	48 89 e5             	mov    %rsp,%rbp
  802359:	48 83 ec 40          	sub    $0x40,%rsp
  80235d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802360:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802364:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802368:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80236c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80236f:	48 89 d6             	mov    %rdx,%rsi
  802372:	89 c7                	mov    %eax,%edi
  802374:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80237b:	00 00 00 
  80237e:	ff d0                	callq  *%rax
  802380:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802383:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802387:	78 24                	js     8023ad <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238d:	8b 00                	mov    (%rax),%eax
  80238f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802393:	48 89 d6             	mov    %rdx,%rsi
  802396:	89 c7                	mov    %eax,%edi
  802398:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
  8023a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ab:	79 05                	jns    8023b2 <write+0x5d>
		return r;
  8023ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b0:	eb 75                	jmp    802427 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b6:	8b 40 08             	mov    0x8(%rax),%eax
  8023b9:	83 e0 03             	and    $0x3,%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	75 3a                	jne    8023fa <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023c0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8023c7:	00 00 00 
  8023ca:	48 8b 00             	mov    (%rax),%rax
  8023cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023d6:	89 c6                	mov    %eax,%esi
  8023d8:	48 bf b3 4a 80 00 00 	movabs $0x804ab3,%rdi
  8023df:	00 00 00 
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e7:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8023ee:	00 00 00 
  8023f1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023f8:	eb 2d                	jmp    802427 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802402:	48 85 c0             	test   %rax,%rax
  802405:	75 07                	jne    80240e <write+0xb9>
		return -E_NOT_SUPP;
  802407:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80240c:	eb 19                	jmp    802427 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80240e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802412:	48 8b 40 18          	mov    0x18(%rax),%rax
  802416:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80241a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80241e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802422:	48 89 cf             	mov    %rcx,%rdi
  802425:	ff d0                	callq  *%rax
}
  802427:	c9                   	leaveq 
  802428:	c3                   	retq   

0000000000802429 <seek>:

int
seek(int fdnum, off_t offset)
{
  802429:	55                   	push   %rbp
  80242a:	48 89 e5             	mov    %rsp,%rbp
  80242d:	48 83 ec 18          	sub    $0x18,%rsp
  802431:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802434:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802437:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80243e:	48 89 d6             	mov    %rdx,%rsi
  802441:	89 c7                	mov    %eax,%edi
  802443:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80244a:	00 00 00 
  80244d:	ff d0                	callq  *%rax
  80244f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802452:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802456:	79 05                	jns    80245d <seek+0x34>
		return r;
  802458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245b:	eb 0f                	jmp    80246c <seek+0x43>
	fd->fd_offset = offset;
  80245d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802461:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802464:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246c:	c9                   	leaveq 
  80246d:	c3                   	retq   

000000000080246e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80246e:	55                   	push   %rbp
  80246f:	48 89 e5             	mov    %rsp,%rbp
  802472:	48 83 ec 30          	sub    $0x30,%rsp
  802476:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802479:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80247c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802480:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802483:	48 89 d6             	mov    %rdx,%rsi
  802486:	89 c7                	mov    %eax,%edi
  802488:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80248f:	00 00 00 
  802492:	ff d0                	callq  *%rax
  802494:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802497:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249b:	78 24                	js     8024c1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80249d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a1:	8b 00                	mov    (%rax),%eax
  8024a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a7:	48 89 d6             	mov    %rdx,%rsi
  8024aa:	89 c7                	mov    %eax,%edi
  8024ac:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  8024b3:	00 00 00 
  8024b6:	ff d0                	callq  *%rax
  8024b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bf:	79 05                	jns    8024c6 <ftruncate+0x58>
		return r;
  8024c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c4:	eb 72                	jmp    802538 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ca:	8b 40 08             	mov    0x8(%rax),%eax
  8024cd:	83 e0 03             	and    $0x3,%eax
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	75 3a                	jne    80250e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024d4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024db:	00 00 00 
  8024de:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024e7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ea:	89 c6                	mov    %eax,%esi
  8024ec:	48 bf d0 4a 80 00 00 	movabs $0x804ad0,%rdi
  8024f3:	00 00 00 
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802502:	00 00 00 
  802505:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80250c:	eb 2a                	jmp    802538 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80250e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802512:	48 8b 40 30          	mov    0x30(%rax),%rax
  802516:	48 85 c0             	test   %rax,%rax
  802519:	75 07                	jne    802522 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80251b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802520:	eb 16                	jmp    802538 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802526:	48 8b 40 30          	mov    0x30(%rax),%rax
  80252a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80252e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802531:	89 ce                	mov    %ecx,%esi
  802533:	48 89 d7             	mov    %rdx,%rdi
  802536:	ff d0                	callq  *%rax
}
  802538:	c9                   	leaveq 
  802539:	c3                   	retq   

000000000080253a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	48 83 ec 30          	sub    $0x30,%rsp
  802542:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802545:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802549:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80254d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802550:	48 89 d6             	mov    %rdx,%rsi
  802553:	89 c7                	mov    %eax,%edi
  802555:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80255c:	00 00 00 
  80255f:	ff d0                	callq  *%rax
  802561:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802564:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802568:	78 24                	js     80258e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256e:	8b 00                	mov    (%rax),%eax
  802570:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802574:	48 89 d6             	mov    %rdx,%rsi
  802577:	89 c7                	mov    %eax,%edi
  802579:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  802580:	00 00 00 
  802583:	ff d0                	callq  *%rax
  802585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258c:	79 05                	jns    802593 <fstat+0x59>
		return r;
  80258e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802591:	eb 5e                	jmp    8025f1 <fstat+0xb7>
	if (!dev->dev_stat)
  802593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802597:	48 8b 40 28          	mov    0x28(%rax),%rax
  80259b:	48 85 c0             	test   %rax,%rax
  80259e:	75 07                	jne    8025a7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a5:	eb 4a                	jmp    8025f1 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ab:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025b9:	00 00 00 
	stat->st_isdir = 0;
  8025bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025c7:	00 00 00 
	stat->st_dev = dev;
  8025ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dd:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025e9:	48 89 ce             	mov    %rcx,%rsi
  8025ec:	48 89 d7             	mov    %rdx,%rdi
  8025ef:	ff d0                	callq  *%rax
}
  8025f1:	c9                   	leaveq 
  8025f2:	c3                   	retq   

00000000008025f3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025f3:	55                   	push   %rbp
  8025f4:	48 89 e5             	mov    %rsp,%rbp
  8025f7:	48 83 ec 20          	sub    $0x20,%rsp
  8025fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802607:	be 00 00 00 00       	mov    $0x0,%esi
  80260c:	48 89 c7             	mov    %rax,%rdi
  80260f:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
  80261b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802622:	79 05                	jns    802629 <stat+0x36>
		return fd;
  802624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802627:	eb 2f                	jmp    802658 <stat+0x65>
	r = fstat(fd, stat);
  802629:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80262d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802630:	48 89 d6             	mov    %rdx,%rsi
  802633:	89 c7                	mov    %eax,%edi
  802635:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
  802641:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802644:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802647:	89 c7                	mov    %eax,%edi
  802649:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802650:	00 00 00 
  802653:	ff d0                	callq  *%rax
	return r;
  802655:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802658:	c9                   	leaveq 
  802659:	c3                   	retq   

000000000080265a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80265a:	55                   	push   %rbp
  80265b:	48 89 e5             	mov    %rsp,%rbp
  80265e:	48 83 ec 10          	sub    $0x10,%rsp
  802662:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802665:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802669:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802670:	00 00 00 
  802673:	8b 00                	mov    (%rax),%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	75 1f                	jne    802698 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802679:	bf 01 00 00 00       	mov    $0x1,%edi
  80267e:	48 b8 78 3e 80 00 00 	movabs $0x803e78,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	89 c2                	mov    %eax,%edx
  80268c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802693:	00 00 00 
  802696:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802698:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80269f:	00 00 00 
  8026a2:	8b 00                	mov    (%rax),%eax
  8026a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026ac:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026b3:	00 00 00 
  8026b6:	89 c7                	mov    %eax,%edi
  8026b8:	48 b8 eb 3c 80 00 00 	movabs $0x803ceb,%rax
  8026bf:	00 00 00 
  8026c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cd:	48 89 c6             	mov    %rax,%rsi
  8026d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d5:	48 b8 ad 3c 80 00 00 	movabs $0x803cad,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
}
  8026e1:	c9                   	leaveq 
  8026e2:	c3                   	retq   

00000000008026e3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026e3:	55                   	push   %rbp
  8026e4:	48 89 e5             	mov    %rsp,%rbp
  8026e7:	48 83 ec 10          	sub    $0x10,%rsp
  8026eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026ef:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8026f2:	48 ba f6 4a 80 00 00 	movabs $0x804af6,%rdx
  8026f9:	00 00 00 
  8026fc:	be 4c 00 00 00       	mov    $0x4c,%esi
  802701:	48 bf 0b 4b 80 00 00 	movabs $0x804b0b,%rdi
  802708:	00 00 00 
  80270b:	b8 00 00 00 00       	mov    $0x0,%eax
  802710:	48 b9 99 3b 80 00 00 	movabs $0x803b99,%rcx
  802717:	00 00 00 
  80271a:	ff d1                	callq  *%rcx

000000000080271c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80271c:	55                   	push   %rbp
  80271d:	48 89 e5             	mov    %rsp,%rbp
  802720:	48 83 ec 10          	sub    $0x10,%rsp
  802724:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80272c:	8b 50 0c             	mov    0xc(%rax),%edx
  80272f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802736:	00 00 00 
  802739:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80273b:	be 00 00 00 00       	mov    $0x0,%esi
  802740:	bf 06 00 00 00       	mov    $0x6,%edi
  802745:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  80274c:	00 00 00 
  80274f:	ff d0                	callq  *%rax
}
  802751:	c9                   	leaveq 
  802752:	c3                   	retq   

0000000000802753 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802753:	55                   	push   %rbp
  802754:	48 89 e5             	mov    %rsp,%rbp
  802757:	48 83 ec 20          	sub    $0x20,%rsp
  80275b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80275f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802763:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802767:	48 ba 16 4b 80 00 00 	movabs $0x804b16,%rdx
  80276e:	00 00 00 
  802771:	be 6b 00 00 00       	mov    $0x6b,%esi
  802776:	48 bf 0b 4b 80 00 00 	movabs $0x804b0b,%rdi
  80277d:	00 00 00 
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	48 b9 99 3b 80 00 00 	movabs $0x803b99,%rcx
  80278c:	00 00 00 
  80278f:	ff d1                	callq  *%rcx

0000000000802791 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802791:	55                   	push   %rbp
  802792:	48 89 e5             	mov    %rsp,%rbp
  802795:	48 83 ec 20          	sub    $0x20,%rsp
  802799:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80279d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8027a5:	48 ba 33 4b 80 00 00 	movabs $0x804b33,%rdx
  8027ac:	00 00 00 
  8027af:	be 7b 00 00 00       	mov    $0x7b,%esi
  8027b4:	48 bf 0b 4b 80 00 00 	movabs $0x804b0b,%rdi
  8027bb:	00 00 00 
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c3:	48 b9 99 3b 80 00 00 	movabs $0x803b99,%rcx
  8027ca:	00 00 00 
  8027cd:	ff d1                	callq  *%rcx

00000000008027cf <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027cf:	55                   	push   %rbp
  8027d0:	48 89 e5             	mov    %rsp,%rbp
  8027d3:	48 83 ec 20          	sub    $0x20,%rsp
  8027d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8027e6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ed:	00 00 00 
  8027f0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027f2:	be 00 00 00 00       	mov    $0x0,%esi
  8027f7:	bf 05 00 00 00       	mov    $0x5,%edi
  8027fc:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  802803:	00 00 00 
  802806:	ff d0                	callq  *%rax
  802808:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280f:	79 05                	jns    802816 <devfile_stat+0x47>
		return r;
  802811:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802814:	eb 56                	jmp    80286c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802816:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802821:	00 00 00 
  802824:	48 89 c7             	mov    %rax,%rdi
  802827:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  80282e:	00 00 00 
  802831:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802833:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80283a:	00 00 00 
  80283d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802843:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802847:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80284d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802854:	00 00 00 
  802857:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80285d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802861:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286c:	c9                   	leaveq 
  80286d:	c3                   	retq   

000000000080286e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80286e:	55                   	push   %rbp
  80286f:	48 89 e5             	mov    %rsp,%rbp
  802872:	48 83 ec 10          	sub    $0x10,%rsp
  802876:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80287a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80287d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802881:	8b 50 0c             	mov    0xc(%rax),%edx
  802884:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80288b:	00 00 00 
  80288e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802890:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802897:	00 00 00 
  80289a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80289d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028a0:	be 00 00 00 00       	mov    $0x0,%esi
  8028a5:	bf 02 00 00 00       	mov    $0x2,%edi
  8028aa:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  8028b1:	00 00 00 
  8028b4:	ff d0                	callq  *%rax
}
  8028b6:	c9                   	leaveq 
  8028b7:	c3                   	retq   

00000000008028b8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8028b8:	55                   	push   %rbp
  8028b9:	48 89 e5             	mov    %rsp,%rbp
  8028bc:	48 83 ec 10          	sub    $0x10,%rsp
  8028c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8028c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c8:	48 89 c7             	mov    %rax,%rdi
  8028cb:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
  8028d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028dc:	7e 07                	jle    8028e5 <remove+0x2d>
		return -E_BAD_PATH;
  8028de:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028e3:	eb 33                	jmp    802918 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8028e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028e9:	48 89 c6             	mov    %rax,%rsi
  8028ec:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028f3:	00 00 00 
  8028f6:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802902:	be 00 00 00 00       	mov    $0x0,%esi
  802907:	bf 07 00 00 00       	mov    $0x7,%edi
  80290c:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  802913:	00 00 00 
  802916:	ff d0                	callq  *%rax
}
  802918:	c9                   	leaveq 
  802919:	c3                   	retq   

000000000080291a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80291a:	55                   	push   %rbp
  80291b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80291e:	be 00 00 00 00       	mov    $0x0,%esi
  802923:	bf 08 00 00 00       	mov    $0x8,%edi
  802928:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  80292f:	00 00 00 
  802932:	ff d0                	callq  *%rax
}
  802934:	5d                   	pop    %rbp
  802935:	c3                   	retq   

0000000000802936 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802936:	55                   	push   %rbp
  802937:	48 89 e5             	mov    %rsp,%rbp
  80293a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802941:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802948:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80294f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802956:	be 00 00 00 00       	mov    $0x0,%esi
  80295b:	48 89 c7             	mov    %rax,%rdi
  80295e:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
  80296a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80296d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802971:	79 28                	jns    80299b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802976:	89 c6                	mov    %eax,%esi
  802978:	48 bf 51 4b 80 00 00 	movabs $0x804b51,%rdi
  80297f:	00 00 00 
  802982:	b8 00 00 00 00       	mov    $0x0,%eax
  802987:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  80298e:	00 00 00 
  802991:	ff d2                	callq  *%rdx
		return fd_src;
  802993:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802996:	e9 74 01 00 00       	jmpq   802b0f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80299b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8029a2:	be 01 01 00 00       	mov    $0x101,%esi
  8029a7:	48 89 c7             	mov    %rax,%rdi
  8029aa:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	callq  *%rax
  8029b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8029b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029bd:	79 39                	jns    8029f8 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8029bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029c2:	89 c6                	mov    %eax,%esi
  8029c4:	48 bf 67 4b 80 00 00 	movabs $0x804b67,%rdi
  8029cb:	00 00 00 
  8029ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d3:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  8029da:	00 00 00 
  8029dd:	ff d2                	callq  *%rdx
		close(fd_src);
  8029df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e2:	89 c7                	mov    %eax,%edi
  8029e4:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8029eb:	00 00 00 
  8029ee:	ff d0                	callq  *%rax
		return fd_dest;
  8029f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029f3:	e9 17 01 00 00       	jmpq   802b0f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029f8:	eb 74                	jmp    802a6e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8029fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029fd:	48 63 d0             	movslq %eax,%rdx
  802a00:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a0a:	48 89 ce             	mov    %rcx,%rsi
  802a0d:	89 c7                	mov    %eax,%edi
  802a0f:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  802a16:	00 00 00 
  802a19:	ff d0                	callq  *%rax
  802a1b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a22:	79 4a                	jns    802a6e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a24:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a27:	89 c6                	mov    %eax,%esi
  802a29:	48 bf 81 4b 80 00 00 	movabs $0x804b81,%rdi
  802a30:	00 00 00 
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  802a3f:	00 00 00 
  802a42:	ff d2                	callq  *%rdx
			close(fd_src);
  802a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
			close(fd_dest);
  802a55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a58:	89 c7                	mov    %eax,%edi
  802a5a:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	callq  *%rax
			return write_size;
  802a66:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a69:	e9 a1 00 00 00       	jmpq   802b0f <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a6e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a78:	ba 00 02 00 00       	mov    $0x200,%edx
  802a7d:	48 89 ce             	mov    %rcx,%rsi
  802a80:	89 c7                	mov    %eax,%edi
  802a82:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  802a89:	00 00 00 
  802a8c:	ff d0                	callq  *%rax
  802a8e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a91:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a95:	0f 8f 5f ff ff ff    	jg     8029fa <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a9f:	79 47                	jns    802ae8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802aa1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802aa4:	89 c6                	mov    %eax,%esi
  802aa6:	48 bf 94 4b 80 00 00 	movabs $0x804b94,%rdi
  802aad:	00 00 00 
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  802abc:	00 00 00 
  802abf:	ff d2                	callq  *%rdx
		close(fd_src);
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
		close(fd_dest);
  802ad2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad5:	89 c7                	mov    %eax,%edi
  802ad7:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	callq  *%rax
		return read_size;
  802ae3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ae6:	eb 27                	jmp    802b0f <copy+0x1d9>
	}
	close(fd_src);
  802ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aeb:	89 c7                	mov    %eax,%edi
  802aed:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
	close(fd_dest);
  802af9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802afc:	89 c7                	mov    %eax,%edi
  802afe:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	callq  *%rax
	return 0;
  802b0a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 20          	sub    $0x20,%rsp
  802b19:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802b1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b23:	48 89 d6             	mov    %rdx,%rsi
  802b26:	89 c7                	mov    %eax,%edi
  802b28:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	callq  *%rax
  802b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3b:	79 05                	jns    802b42 <fd2sockid+0x31>
		return r;
  802b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b40:	eb 24                	jmp    802b66 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b46:	8b 10                	mov    (%rax),%edx
  802b48:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802b4f:	00 00 00 
  802b52:	8b 00                	mov    (%rax),%eax
  802b54:	39 c2                	cmp    %eax,%edx
  802b56:	74 07                	je     802b5f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802b58:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b5d:	eb 07                	jmp    802b66 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b63:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802b66:	c9                   	leaveq 
  802b67:	c3                   	retq   

0000000000802b68 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
  802b6c:	48 83 ec 20          	sub    $0x20,%rsp
  802b70:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802b73:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b77:	48 89 c7             	mov    %rax,%rdi
  802b7a:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	callq  *%rax
  802b86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8d:	78 26                	js     802bb5 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802b8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b93:	ba 07 04 00 00       	mov    $0x407,%edx
  802b98:	48 89 c6             	mov    %rax,%rsi
  802b9b:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba0:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802ba7:	00 00 00 
  802baa:	ff d0                	callq  *%rax
  802bac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802baf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb3:	79 16                	jns    802bcb <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802bb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb8:	89 c7                	mov    %eax,%edi
  802bba:	48 b8 77 30 80 00 00 	movabs $0x803077,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
		return r;
  802bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc9:	eb 3a                	jmp    802c05 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcf:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802bd6:	00 00 00 
  802bd9:	8b 12                	mov    (%rdx),%edx
  802bdb:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802bdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802be8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bef:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802bf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf6:	48 89 c7             	mov    %rax,%rdi
  802bf9:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
}
  802c05:	c9                   	leaveq 
  802c06:	c3                   	retq   

0000000000802c07 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c07:	55                   	push   %rbp
  802c08:	48 89 e5             	mov    %rsp,%rbp
  802c0b:	48 83 ec 30          	sub    $0x30,%rsp
  802c0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c16:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c1d:	89 c7                	mov    %eax,%edi
  802c1f:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
  802c2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c32:	79 05                	jns    802c39 <accept+0x32>
		return r;
  802c34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c37:	eb 3b                	jmp    802c74 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c3d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c44:	48 89 ce             	mov    %rcx,%rsi
  802c47:	89 c7                	mov    %eax,%edi
  802c49:	48 b8 54 2f 80 00 00 	movabs $0x802f54,%rax
  802c50:	00 00 00 
  802c53:	ff d0                	callq  *%rax
  802c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5c:	79 05                	jns    802c63 <accept+0x5c>
		return r;
  802c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c61:	eb 11                	jmp    802c74 <accept+0x6d>
	return alloc_sockfd(r);
  802c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c66:	89 c7                	mov    %eax,%edi
  802c68:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	callq  *%rax
}
  802c74:	c9                   	leaveq 
  802c75:	c3                   	retq   

0000000000802c76 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c76:	55                   	push   %rbp
  802c77:	48 89 e5             	mov    %rsp,%rbp
  802c7a:	48 83 ec 20          	sub    $0x20,%rsp
  802c7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c85:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c8b:	89 c7                	mov    %eax,%edi
  802c8d:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
  802c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca0:	79 05                	jns    802ca7 <bind+0x31>
		return r;
  802ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca5:	eb 1b                	jmp    802cc2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ca7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802caa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb1:	48 89 ce             	mov    %rcx,%rsi
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 d3 2f 80 00 00 	movabs $0x802fd3,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <shutdown>:

int
shutdown(int s, int how)
{
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 20          	sub    $0x20,%rsp
  802ccc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ccf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd5:	89 c7                	mov    %eax,%edi
  802cd7:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802cde:	00 00 00 
  802ce1:	ff d0                	callq  *%rax
  802ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cea:	79 05                	jns    802cf1 <shutdown+0x2d>
		return r;
  802cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cef:	eb 16                	jmp    802d07 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802cf1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	89 d6                	mov    %edx,%esi
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 37 30 80 00 00 	movabs $0x803037,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
}
  802d07:	c9                   	leaveq 
  802d08:	c3                   	retq   

0000000000802d09 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802d09:	55                   	push   %rbp
  802d0a:	48 89 e5             	mov    %rsp,%rbp
  802d0d:	48 83 ec 10          	sub    $0x10,%rsp
  802d11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d19:	48 89 c7             	mov    %rax,%rdi
  802d1c:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  802d23:	00 00 00 
  802d26:	ff d0                	callq  *%rax
  802d28:	83 f8 01             	cmp    $0x1,%eax
  802d2b:	75 17                	jne    802d44 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d31:	8b 40 0c             	mov    0xc(%rax),%eax
  802d34:	89 c7                	mov    %eax,%edi
  802d36:	48 b8 77 30 80 00 00 	movabs $0x803077,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
  802d42:	eb 05                	jmp    802d49 <devsock_close+0x40>
	else
		return 0;
  802d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d49:	c9                   	leaveq 
  802d4a:	c3                   	retq   

0000000000802d4b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d4b:	55                   	push   %rbp
  802d4c:	48 89 e5             	mov    %rsp,%rbp
  802d4f:	48 83 ec 20          	sub    $0x20,%rsp
  802d53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d5a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d60:	89 c7                	mov    %eax,%edi
  802d62:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
  802d6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d75:	79 05                	jns    802d7c <connect+0x31>
		return r;
  802d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7a:	eb 1b                	jmp    802d97 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802d7c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d7f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d86:	48 89 ce             	mov    %rcx,%rsi
  802d89:	89 c7                	mov    %eax,%edi
  802d8b:	48 b8 a4 30 80 00 00 	movabs $0x8030a4,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
}
  802d97:	c9                   	leaveq 
  802d98:	c3                   	retq   

0000000000802d99 <listen>:

int
listen(int s, int backlog)
{
  802d99:	55                   	push   %rbp
  802d9a:	48 89 e5             	mov    %rsp,%rbp
  802d9d:	48 83 ec 20          	sub    $0x20,%rsp
  802da1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802da4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802da7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802daa:	89 c7                	mov    %eax,%edi
  802dac:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
  802db8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbf:	79 05                	jns    802dc6 <listen+0x2d>
		return r;
  802dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc4:	eb 16                	jmp    802ddc <listen+0x43>
	return nsipc_listen(r, backlog);
  802dc6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	89 d6                	mov    %edx,%esi
  802dce:	89 c7                	mov    %eax,%edi
  802dd0:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
}
  802ddc:	c9                   	leaveq 
  802ddd:	c3                   	retq   

0000000000802dde <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802dde:	55                   	push   %rbp
  802ddf:	48 89 e5             	mov    %rsp,%rbp
  802de2:	48 83 ec 20          	sub    $0x20,%rsp
  802de6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802df2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df6:	89 c2                	mov    %eax,%edx
  802df8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfc:	8b 40 0c             	mov    0xc(%rax),%eax
  802dff:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e03:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e08:	89 c7                	mov    %eax,%edi
  802e0a:	48 b8 48 31 80 00 00 	movabs $0x803148,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 20          	sub    $0x20,%rsp
  802e20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e28:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e30:	89 c2                	mov    %eax,%edx
  802e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e36:	8b 40 0c             	mov    0xc(%rax),%eax
  802e39:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e42:	89 c7                	mov    %eax,%edi
  802e44:	48 b8 14 32 80 00 00 	movabs $0x803214,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
  802e56:	48 83 ec 10          	sub    $0x10,%rsp
  802e5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e66:	48 be af 4b 80 00 00 	movabs $0x804baf,%rsi
  802e6d:	00 00 00 
  802e70:	48 89 c7             	mov    %rax,%rdi
  802e73:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
	return 0;
  802e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e84:	c9                   	leaveq 
  802e85:	c3                   	retq   

0000000000802e86 <socket>:

int
socket(int domain, int type, int protocol)
{
  802e86:	55                   	push   %rbp
  802e87:	48 89 e5             	mov    %rsp,%rbp
  802e8a:	48 83 ec 20          	sub    $0x20,%rsp
  802e8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e91:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802e94:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802e97:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e9a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea0:	89 ce                	mov    %ecx,%esi
  802ea2:	89 c7                	mov    %eax,%edi
  802ea4:	48 b8 cc 32 80 00 00 	movabs $0x8032cc,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
  802eb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb7:	79 05                	jns    802ebe <socket+0x38>
		return r;
  802eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebc:	eb 11                	jmp    802ecf <socket+0x49>
	return alloc_sockfd(r);
  802ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec1:	89 c7                	mov    %eax,%edi
  802ec3:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
}
  802ecf:	c9                   	leaveq 
  802ed0:	c3                   	retq   

0000000000802ed1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802ed1:	55                   	push   %rbp
  802ed2:	48 89 e5             	mov    %rsp,%rbp
  802ed5:	48 83 ec 10          	sub    $0x10,%rsp
  802ed9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802edc:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ee3:	00 00 00 
  802ee6:	8b 00                	mov    (%rax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	75 1f                	jne    802f0b <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802eec:	bf 02 00 00 00       	mov    $0x2,%edi
  802ef1:	48 b8 78 3e 80 00 00 	movabs $0x803e78,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
  802efd:	89 c2                	mov    %eax,%edx
  802eff:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f06:	00 00 00 
  802f09:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802f0b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f12:	00 00 00 
  802f15:	8b 00                	mov    (%rax),%eax
  802f17:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f1a:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f1f:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802f26:	00 00 00 
  802f29:	89 c7                	mov    %eax,%edi
  802f2b:	48 b8 eb 3c 80 00 00 	movabs $0x803ceb,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802f37:	ba 00 00 00 00       	mov    $0x0,%edx
  802f3c:	be 00 00 00 00       	mov    $0x0,%esi
  802f41:	bf 00 00 00 00       	mov    $0x0,%edi
  802f46:	48 b8 ad 3c 80 00 00 	movabs $0x803cad,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
}
  802f52:	c9                   	leaveq 
  802f53:	c3                   	retq   

0000000000802f54 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f54:	55                   	push   %rbp
  802f55:	48 89 e5             	mov    %rsp,%rbp
  802f58:	48 83 ec 30          	sub    $0x30,%rsp
  802f5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802f67:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f6e:	00 00 00 
  802f71:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f74:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802f76:	bf 01 00 00 00       	mov    $0x1,%edi
  802f7b:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8e:	78 3e                	js     802fce <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802f90:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f97:	00 00 00 
  802f9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa2:	8b 40 10             	mov    0x10(%rax),%eax
  802fa5:	89 c2                	mov    %eax,%edx
  802fa7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802faf:	48 89 ce             	mov    %rcx,%rsi
  802fb2:	48 89 c7             	mov    %rax,%rdi
  802fb5:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  802fbc:	00 00 00 
  802fbf:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc5:	8b 50 10             	mov    0x10(%rax),%edx
  802fc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcc:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802fce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fd1:	c9                   	leaveq 
  802fd2:	c3                   	retq   

0000000000802fd3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fd3:	55                   	push   %rbp
  802fd4:	48 89 e5             	mov    %rsp,%rbp
  802fd7:	48 83 ec 10          	sub    $0x10,%rsp
  802fdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fe2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802fe5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fec:	00 00 00 
  802fef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ff2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802ff4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffb:	48 89 c6             	mov    %rax,%rsi
  802ffe:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803005:	00 00 00 
  803008:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  80300f:	00 00 00 
  803012:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803014:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80301b:	00 00 00 
  80301e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803021:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803024:	bf 02 00 00 00       	mov    $0x2,%edi
  803029:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
}
  803035:	c9                   	leaveq 
  803036:	c3                   	retq   

0000000000803037 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803037:	55                   	push   %rbp
  803038:	48 89 e5             	mov    %rsp,%rbp
  80303b:	48 83 ec 10          	sub    $0x10,%rsp
  80303f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803042:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803045:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80304c:	00 00 00 
  80304f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803052:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803054:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80305b:	00 00 00 
  80305e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803061:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803064:	bf 03 00 00 00       	mov    $0x3,%edi
  803069:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  803070:	00 00 00 
  803073:	ff d0                	callq  *%rax
}
  803075:	c9                   	leaveq 
  803076:	c3                   	retq   

0000000000803077 <nsipc_close>:

int
nsipc_close(int s)
{
  803077:	55                   	push   %rbp
  803078:	48 89 e5             	mov    %rsp,%rbp
  80307b:	48 83 ec 10          	sub    $0x10,%rsp
  80307f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803082:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803089:	00 00 00 
  80308c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80308f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803091:	bf 04 00 00 00       	mov    $0x4,%edi
  803096:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
}
  8030a2:	c9                   	leaveq 
  8030a3:	c3                   	retq   

00000000008030a4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030a4:	55                   	push   %rbp
  8030a5:	48 89 e5             	mov    %rsp,%rbp
  8030a8:	48 83 ec 10          	sub    $0x10,%rsp
  8030ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8030b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030bd:	00 00 00 
  8030c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030c3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8030c5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cc:	48 89 c6             	mov    %rax,%rsi
  8030cf:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8030d6:	00 00 00 
  8030d9:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8030e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030ec:	00 00 00 
  8030ef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030f2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8030f5:	bf 05 00 00 00       	mov    $0x5,%edi
  8030fa:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
}
  803106:	c9                   	leaveq 
  803107:	c3                   	retq   

0000000000803108 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 83 ec 10          	sub    $0x10,%rsp
  803110:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803113:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803116:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80311d:	00 00 00 
  803120:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803123:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803125:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80312c:	00 00 00 
  80312f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803132:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803135:	bf 06 00 00 00       	mov    $0x6,%edi
  80313a:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
}
  803146:	c9                   	leaveq 
  803147:	c3                   	retq   

0000000000803148 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803148:	55                   	push   %rbp
  803149:	48 89 e5             	mov    %rsp,%rbp
  80314c:	48 83 ec 30          	sub    $0x30,%rsp
  803150:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803157:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80315a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80315d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803164:	00 00 00 
  803167:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80316a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80316c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803173:	00 00 00 
  803176:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803179:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80317c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803183:	00 00 00 
  803186:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803189:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80318c:	bf 07 00 00 00       	mov    $0x7,%edi
  803191:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
  80319d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a4:	78 69                	js     80320f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8031a6:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8031ad:	7f 08                	jg     8031b7 <nsipc_recv+0x6f>
  8031af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b2:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8031b5:	7e 35                	jle    8031ec <nsipc_recv+0xa4>
  8031b7:	48 b9 b6 4b 80 00 00 	movabs $0x804bb6,%rcx
  8031be:	00 00 00 
  8031c1:	48 ba cb 4b 80 00 00 	movabs $0x804bcb,%rdx
  8031c8:	00 00 00 
  8031cb:	be 61 00 00 00       	mov    $0x61,%esi
  8031d0:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
  8031d7:	00 00 00 
  8031da:	b8 00 00 00 00       	mov    $0x0,%eax
  8031df:	49 b8 99 3b 80 00 00 	movabs $0x803b99,%r8
  8031e6:	00 00 00 
  8031e9:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8031ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ef:	48 63 d0             	movslq %eax,%rdx
  8031f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f6:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8031fd:	00 00 00 
  803200:	48 89 c7             	mov    %rax,%rdi
  803203:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
	}

	return r;
  80320f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803212:	c9                   	leaveq 
  803213:	c3                   	retq   

0000000000803214 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803214:	55                   	push   %rbp
  803215:	48 89 e5             	mov    %rsp,%rbp
  803218:	48 83 ec 20          	sub    $0x20,%rsp
  80321c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80321f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803223:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803226:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803229:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803230:	00 00 00 
  803233:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803236:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803238:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80323f:	7e 35                	jle    803276 <nsipc_send+0x62>
  803241:	48 b9 ec 4b 80 00 00 	movabs $0x804bec,%rcx
  803248:	00 00 00 
  80324b:	48 ba cb 4b 80 00 00 	movabs $0x804bcb,%rdx
  803252:	00 00 00 
  803255:	be 6c 00 00 00       	mov    $0x6c,%esi
  80325a:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
  803261:	00 00 00 
  803264:	b8 00 00 00 00       	mov    $0x0,%eax
  803269:	49 b8 99 3b 80 00 00 	movabs $0x803b99,%r8
  803270:	00 00 00 
  803273:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803276:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803279:	48 63 d0             	movslq %eax,%rdx
  80327c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803280:	48 89 c6             	mov    %rax,%rsi
  803283:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80328a:	00 00 00 
  80328d:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803299:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a0:	00 00 00 
  8032a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032a6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8032a9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b0:	00 00 00 
  8032b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8032b9:	bf 08 00 00 00       	mov    $0x8,%edi
  8032be:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
}
  8032ca:	c9                   	leaveq 
  8032cb:	c3                   	retq   

00000000008032cc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8032cc:	55                   	push   %rbp
  8032cd:	48 89 e5             	mov    %rsp,%rbp
  8032d0:	48 83 ec 10          	sub    $0x10,%rsp
  8032d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032d7:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8032da:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8032dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e4:	00 00 00 
  8032e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032ea:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8032ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f3:	00 00 00 
  8032f6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8032fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803303:	00 00 00 
  803306:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803309:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80330c:	bf 09 00 00 00       	mov    $0x9,%edi
  803311:	48 b8 d1 2e 80 00 00 	movabs $0x802ed1,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
}
  80331d:	c9                   	leaveq 
  80331e:	c3                   	retq   

000000000080331f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80331f:	55                   	push   %rbp
  803320:	48 89 e5             	mov    %rsp,%rbp
  803323:	53                   	push   %rbx
  803324:	48 83 ec 38          	sub    $0x38,%rsp
  803328:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80332c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803330:	48 89 c7             	mov    %rax,%rdi
  803333:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
  80333f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803342:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803346:	0f 88 bf 01 00 00    	js     80350b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80334c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803350:	ba 07 04 00 00       	mov    $0x407,%edx
  803355:	48 89 c6             	mov    %rax,%rsi
  803358:	bf 00 00 00 00       	mov    $0x0,%edi
  80335d:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
  803369:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80336c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803370:	0f 88 95 01 00 00    	js     80350b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803376:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80337a:	48 89 c7             	mov    %rax,%rdi
  80337d:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax
  803389:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80338c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803390:	0f 88 5d 01 00 00    	js     8034f3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803396:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339a:	ba 07 04 00 00       	mov    $0x407,%edx
  80339f:	48 89 c6             	mov    %rax,%rsi
  8033a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a7:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
  8033b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033ba:	0f 88 33 01 00 00    	js     8034f3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c4:	48 89 c7             	mov    %rax,%rdi
  8033c7:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
  8033d3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033db:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e0:	48 89 c6             	mov    %rax,%rsi
  8033e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e8:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033fb:	79 05                	jns    803402 <pipe+0xe3>
		goto err2;
  8033fd:	e9 d9 00 00 00       	jmpq   8034db <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803402:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803406:	48 89 c7             	mov    %rax,%rdi
  803409:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	48 89 c2             	mov    %rax,%rdx
  803418:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803422:	48 89 d1             	mov    %rdx,%rcx
  803425:	ba 00 00 00 00       	mov    $0x0,%edx
  80342a:	48 89 c6             	mov    %rax,%rsi
  80342d:	bf 00 00 00 00       	mov    $0x0,%edi
  803432:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  803439:	00 00 00 
  80343c:	ff d0                	callq  *%rax
  80343e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803441:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803445:	79 1b                	jns    803462 <pipe+0x143>
		goto err3;
  803447:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344c:	48 89 c6             	mov    %rax,%rsi
  80344f:	bf 00 00 00 00       	mov    $0x0,%edi
  803454:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
  803460:	eb 79                	jmp    8034db <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803466:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80346d:	00 00 00 
  803470:	8b 12                	mov    (%rdx),%edx
  803472:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803478:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80347f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803483:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80348a:	00 00 00 
  80348d:	8b 12                	mov    (%rdx),%edx
  80348f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803491:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803495:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80349c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034a0:	48 89 c7             	mov    %rax,%rdi
  8034a3:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
  8034af:	89 c2                	mov    %eax,%edx
  8034b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034b5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034bb:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8034bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c3:	48 89 c7             	mov    %rax,%rdi
  8034c6:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  8034cd:	00 00 00 
  8034d0:	ff d0                	callq  *%rax
  8034d2:	89 03                	mov    %eax,(%rbx)
	return 0;
  8034d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d9:	eb 33                	jmp    80350e <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8034db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034df:	48 89 c6             	mov    %rax,%rsi
  8034e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e7:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8034f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f7:	48 89 c6             	mov    %rax,%rsi
  8034fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ff:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  803506:	00 00 00 
  803509:	ff d0                	callq  *%rax
err:
	return r;
  80350b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80350e:	48 83 c4 38          	add    $0x38,%rsp
  803512:	5b                   	pop    %rbx
  803513:	5d                   	pop    %rbp
  803514:	c3                   	retq   

0000000000803515 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	53                   	push   %rbx
  80351a:	48 83 ec 28          	sub    $0x28,%rsp
  80351e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803522:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803526:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80352d:	00 00 00 
  803530:	48 8b 00             	mov    (%rax),%rax
  803533:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803539:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80353c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803540:	48 89 c7             	mov    %rax,%rdi
  803543:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  80354a:	00 00 00 
  80354d:	ff d0                	callq  *%rax
  80354f:	89 c3                	mov    %eax,%ebx
  803551:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803555:	48 89 c7             	mov    %rax,%rdi
  803558:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	39 c3                	cmp    %eax,%ebx
  803566:	0f 94 c0             	sete   %al
  803569:	0f b6 c0             	movzbl %al,%eax
  80356c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80356f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803576:	00 00 00 
  803579:	48 8b 00             	mov    (%rax),%rax
  80357c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803582:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803585:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803588:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80358b:	75 05                	jne    803592 <_pipeisclosed+0x7d>
			return ret;
  80358d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803590:	eb 4a                	jmp    8035dc <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803592:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803595:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803598:	74 3d                	je     8035d7 <_pipeisclosed+0xc2>
  80359a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80359e:	75 37                	jne    8035d7 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8035a7:	00 00 00 
  8035aa:	48 8b 00             	mov    (%rax),%rax
  8035ad:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035b3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b9:	89 c6                	mov    %eax,%esi
  8035bb:	48 bf fd 4b 80 00 00 	movabs $0x804bfd,%rdi
  8035c2:	00 00 00 
  8035c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ca:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  8035d1:	00 00 00 
  8035d4:	41 ff d0             	callq  *%r8
	}
  8035d7:	e9 4a ff ff ff       	jmpq   803526 <_pipeisclosed+0x11>
}
  8035dc:	48 83 c4 28          	add    $0x28,%rsp
  8035e0:	5b                   	pop    %rbx
  8035e1:	5d                   	pop    %rbp
  8035e2:	c3                   	retq   

00000000008035e3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8035e3:	55                   	push   %rbp
  8035e4:	48 89 e5             	mov    %rsp,%rbp
  8035e7:	48 83 ec 30          	sub    $0x30,%rsp
  8035eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035f5:	48 89 d6             	mov    %rdx,%rsi
  8035f8:	89 c7                	mov    %eax,%edi
  8035fa:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803601:	00 00 00 
  803604:	ff d0                	callq  *%rax
  803606:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803609:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360d:	79 05                	jns    803614 <pipeisclosed+0x31>
		return r;
  80360f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803612:	eb 31                	jmp    803645 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803618:	48 89 c7             	mov    %rax,%rdi
  80361b:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
  803627:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80362b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803633:	48 89 d6             	mov    %rdx,%rsi
  803636:	48 89 c7             	mov    %rax,%rdi
  803639:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
}
  803645:	c9                   	leaveq 
  803646:	c3                   	retq   

0000000000803647 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803647:	55                   	push   %rbp
  803648:	48 89 e5             	mov    %rsp,%rbp
  80364b:	48 83 ec 40          	sub    $0x40,%rsp
  80364f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803653:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803657:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80365b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80365f:	48 89 c7             	mov    %rax,%rdi
  803662:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
  80366e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803672:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803676:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80367a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803681:	00 
  803682:	e9 92 00 00 00       	jmpq   803719 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803687:	eb 41                	jmp    8036ca <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803689:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80368e:	74 09                	je     803699 <devpipe_read+0x52>
				return i;
  803690:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803694:	e9 92 00 00 00       	jmpq   80372b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803699:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80369d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a1:	48 89 d6             	mov    %rdx,%rsi
  8036a4:	48 89 c7             	mov    %rax,%rdi
  8036a7:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 07                	je     8036be <devpipe_read+0x77>
				return 0;
  8036b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bc:	eb 6d                	jmp    80372b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8036be:	48 b8 4d 19 80 00 00 	movabs $0x80194d,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8036ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ce:	8b 10                	mov    (%rax),%edx
  8036d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d4:	8b 40 04             	mov    0x4(%rax),%eax
  8036d7:	39 c2                	cmp    %eax,%edx
  8036d9:	74 ae                	je     803689 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8036e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036eb:	8b 00                	mov    (%rax),%eax
  8036ed:	99                   	cltd   
  8036ee:	c1 ea 1b             	shr    $0x1b,%edx
  8036f1:	01 d0                	add    %edx,%eax
  8036f3:	83 e0 1f             	and    $0x1f,%eax
  8036f6:	29 d0                	sub    %edx,%eax
  8036f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036fc:	48 98                	cltq   
  8036fe:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803703:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803709:	8b 00                	mov    (%rax),%eax
  80370b:	8d 50 01             	lea    0x1(%rax),%edx
  80370e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803712:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803714:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803721:	0f 82 60 ff ff ff    	jb     803687 <devpipe_read+0x40>
	}
	return i;
  803727:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80372b:	c9                   	leaveq 
  80372c:	c3                   	retq   

000000000080372d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80372d:	55                   	push   %rbp
  80372e:	48 89 e5             	mov    %rsp,%rbp
  803731:	48 83 ec 40          	sub    $0x40,%rsp
  803735:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803739:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80373d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803745:	48 89 c7             	mov    %rax,%rdi
  803748:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803758:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803760:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803767:	00 
  803768:	e9 91 00 00 00       	jmpq   8037fe <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80376d:	eb 31                	jmp    8037a0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80376f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803777:	48 89 d6             	mov    %rdx,%rsi
  80377a:	48 89 c7             	mov    %rax,%rdi
  80377d:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  803784:	00 00 00 
  803787:	ff d0                	callq  *%rax
  803789:	85 c0                	test   %eax,%eax
  80378b:	74 07                	je     803794 <devpipe_write+0x67>
				return 0;
  80378d:	b8 00 00 00 00       	mov    $0x0,%eax
  803792:	eb 7c                	jmp    803810 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803794:	48 b8 4d 19 80 00 00 	movabs $0x80194d,%rax
  80379b:	00 00 00 
  80379e:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a4:	8b 40 04             	mov    0x4(%rax),%eax
  8037a7:	48 63 d0             	movslq %eax,%rdx
  8037aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ae:	8b 00                	mov    (%rax),%eax
  8037b0:	48 98                	cltq   
  8037b2:	48 83 c0 20          	add    $0x20,%rax
  8037b6:	48 39 c2             	cmp    %rax,%rdx
  8037b9:	73 b4                	jae    80376f <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8037bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037bf:	8b 40 04             	mov    0x4(%rax),%eax
  8037c2:	99                   	cltd   
  8037c3:	c1 ea 1b             	shr    $0x1b,%edx
  8037c6:	01 d0                	add    %edx,%eax
  8037c8:	83 e0 1f             	and    $0x1f,%eax
  8037cb:	29 d0                	sub    %edx,%eax
  8037cd:	89 c6                	mov    %eax,%esi
  8037cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d7:	48 01 d0             	add    %rdx,%rax
  8037da:	0f b6 08             	movzbl (%rax),%ecx
  8037dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037e1:	48 63 c6             	movslq %esi,%rax
  8037e4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8037e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ec:	8b 40 04             	mov    0x4(%rax),%eax
  8037ef:	8d 50 01             	lea    0x1(%rax),%edx
  8037f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f6:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8037f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803802:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803806:	0f 82 61 ff ff ff    	jb     80376d <devpipe_write+0x40>
	}

	return i;
  80380c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803810:	c9                   	leaveq 
  803811:	c3                   	retq   

0000000000803812 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803812:	55                   	push   %rbp
  803813:	48 89 e5             	mov    %rsp,%rbp
  803816:	48 83 ec 20          	sub    $0x20,%rsp
  80381a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80381e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803826:	48 89 c7             	mov    %rax,%rdi
  803829:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
  803835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803839:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80383d:	48 be 10 4c 80 00 00 	movabs $0x804c10,%rsi
  803844:	00 00 00 
  803847:	48 89 c7             	mov    %rax,%rdi
  80384a:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  803851:	00 00 00 
  803854:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385a:	8b 50 04             	mov    0x4(%rax),%edx
  80385d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803861:	8b 00                	mov    (%rax),%eax
  803863:	29 c2                	sub    %eax,%edx
  803865:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803869:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80386f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803873:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80387a:	00 00 00 
	stat->st_dev = &devpipe;
  80387d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803881:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803888:	00 00 00 
  80388b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803892:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803897:	c9                   	leaveq 
  803898:	c3                   	retq   

0000000000803899 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803899:	55                   	push   %rbp
  80389a:	48 89 e5             	mov    %rsp,%rbp
  80389d:	48 83 ec 10          	sub    $0x10,%rsp
  8038a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8038a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a9:	48 89 c6             	mov    %rax,%rsi
  8038ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b1:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8038bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c1:	48 89 c7             	mov    %rax,%rdi
  8038c4:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8038cb:	00 00 00 
  8038ce:	ff d0                	callq  *%rax
  8038d0:	48 89 c6             	mov    %rax,%rsi
  8038d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d8:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  8038df:	00 00 00 
  8038e2:	ff d0                	callq  *%rax
}
  8038e4:	c9                   	leaveq 
  8038e5:	c3                   	retq   

00000000008038e6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8038e6:	55                   	push   %rbp
  8038e7:	48 89 e5             	mov    %rsp,%rbp
  8038ea:	48 83 ec 20          	sub    $0x20,%rsp
  8038ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038f7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038fb:	be 01 00 00 00       	mov    $0x1,%esi
  803900:	48 89 c7             	mov    %rax,%rdi
  803903:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
}
  80390f:	c9                   	leaveq 
  803910:	c3                   	retq   

0000000000803911 <getchar>:

int
getchar(void)
{
  803911:	55                   	push   %rbp
  803912:	48 89 e5             	mov    %rsp,%rbp
  803915:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803919:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80391d:	ba 01 00 00 00       	mov    $0x1,%edx
  803922:	48 89 c6             	mov    %rax,%rsi
  803925:	bf 00 00 00 00       	mov    $0x0,%edi
  80392a:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  803931:	00 00 00 
  803934:	ff d0                	callq  *%rax
  803936:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803939:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393d:	79 05                	jns    803944 <getchar+0x33>
		return r;
  80393f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803942:	eb 14                	jmp    803958 <getchar+0x47>
	if (r < 1)
  803944:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803948:	7f 07                	jg     803951 <getchar+0x40>
		return -E_EOF;
  80394a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80394f:	eb 07                	jmp    803958 <getchar+0x47>
	return c;
  803951:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803955:	0f b6 c0             	movzbl %al,%eax
}
  803958:	c9                   	leaveq 
  803959:	c3                   	retq   

000000000080395a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80395a:	55                   	push   %rbp
  80395b:	48 89 e5             	mov    %rsp,%rbp
  80395e:	48 83 ec 20          	sub    $0x20,%rsp
  803962:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803965:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803969:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80396c:	48 89 d6             	mov    %rdx,%rsi
  80396f:	89 c7                	mov    %eax,%edi
  803971:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803978:	00 00 00 
  80397b:	ff d0                	callq  *%rax
  80397d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803984:	79 05                	jns    80398b <iscons+0x31>
		return r;
  803986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803989:	eb 1a                	jmp    8039a5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80398b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398f:	8b 10                	mov    (%rax),%edx
  803991:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803998:	00 00 00 
  80399b:	8b 00                	mov    (%rax),%eax
  80399d:	39 c2                	cmp    %eax,%edx
  80399f:	0f 94 c0             	sete   %al
  8039a2:	0f b6 c0             	movzbl %al,%eax
}
  8039a5:	c9                   	leaveq 
  8039a6:	c3                   	retq   

00000000008039a7 <opencons>:

int
opencons(void)
{
  8039a7:	55                   	push   %rbp
  8039a8:	48 89 e5             	mov    %rsp,%rbp
  8039ab:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039af:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039b3:	48 89 c7             	mov    %rax,%rdi
  8039b6:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c9:	79 05                	jns    8039d0 <opencons+0x29>
		return r;
  8039cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ce:	eb 5b                	jmp    803a2b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d4:	ba 07 04 00 00       	mov    $0x407,%edx
  8039d9:	48 89 c6             	mov    %rax,%rsi
  8039dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e1:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
  8039ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f4:	79 05                	jns    8039fb <opencons+0x54>
		return r;
  8039f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f9:	eb 30                	jmp    803a2b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ff:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803a06:	00 00 00 
  803a09:	8b 12                	mov    (%rdx),%edx
  803a0b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1c:	48 89 c7             	mov    %rax,%rdi
  803a1f:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
}
  803a2b:	c9                   	leaveq 
  803a2c:	c3                   	retq   

0000000000803a2d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 30          	sub    $0x30,%rsp
  803a35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a41:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a46:	75 07                	jne    803a4f <devcons_read+0x22>
		return 0;
  803a48:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4d:	eb 4b                	jmp    803a9a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a4f:	eb 0c                	jmp    803a5d <devcons_read+0x30>
		sys_yield();
  803a51:	48 b8 4d 19 80 00 00 	movabs $0x80194d,%rax
  803a58:	00 00 00 
  803a5b:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803a5d:	48 b8 8f 18 80 00 00 	movabs $0x80188f,%rax
  803a64:	00 00 00 
  803a67:	ff d0                	callq  *%rax
  803a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a70:	74 df                	je     803a51 <devcons_read+0x24>
	if (c < 0)
  803a72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a76:	79 05                	jns    803a7d <devcons_read+0x50>
		return c;
  803a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7b:	eb 1d                	jmp    803a9a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a81:	75 07                	jne    803a8a <devcons_read+0x5d>
		return 0;
  803a83:	b8 00 00 00 00       	mov    $0x0,%eax
  803a88:	eb 10                	jmp    803a9a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8d:	89 c2                	mov    %eax,%edx
  803a8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a93:	88 10                	mov    %dl,(%rax)
	return 1;
  803a95:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a9a:	c9                   	leaveq 
  803a9b:	c3                   	retq   

0000000000803a9c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a9c:	55                   	push   %rbp
  803a9d:	48 89 e5             	mov    %rsp,%rbp
  803aa0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803aa7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803aae:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ab5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803abc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ac3:	eb 76                	jmp    803b3b <devcons_write+0x9f>
		m = n - tot;
  803ac5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803acc:	89 c2                	mov    %eax,%edx
  803ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad1:	29 c2                	sub    %eax,%edx
  803ad3:	89 d0                	mov    %edx,%eax
  803ad5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803ad8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803adb:	83 f8 7f             	cmp    $0x7f,%eax
  803ade:	76 07                	jbe    803ae7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ae0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ae7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aea:	48 63 d0             	movslq %eax,%rdx
  803aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af0:	48 63 c8             	movslq %eax,%rcx
  803af3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803afa:	48 01 c1             	add    %rax,%rcx
  803afd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b04:	48 89 ce             	mov    %rcx,%rsi
  803b07:	48 89 c7             	mov    %rax,%rdi
  803b0a:	48 b8 80 13 80 00 00 	movabs $0x801380,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b19:	48 63 d0             	movslq %eax,%rdx
  803b1c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b23:	48 89 d6             	mov    %rdx,%rsi
  803b26:	48 89 c7             	mov    %rax,%rdi
  803b29:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  803b30:	00 00 00 
  803b33:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803b35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b38:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3e:	48 98                	cltq   
  803b40:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b47:	0f 82 78 ff ff ff    	jb     803ac5 <devcons_write+0x29>
	}
	return tot;
  803b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b50:	c9                   	leaveq 
  803b51:	c3                   	retq   

0000000000803b52 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b52:	55                   	push   %rbp
  803b53:	48 89 e5             	mov    %rsp,%rbp
  803b56:	48 83 ec 08          	sub    $0x8,%rsp
  803b5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b63:	c9                   	leaveq 
  803b64:	c3                   	retq   

0000000000803b65 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b65:	55                   	push   %rbp
  803b66:	48 89 e5             	mov    %rsp,%rbp
  803b69:	48 83 ec 10          	sub    $0x10,%rsp
  803b6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b79:	48 be 1c 4c 80 00 00 	movabs $0x804c1c,%rsi
  803b80:	00 00 00 
  803b83:	48 89 c7             	mov    %rax,%rdi
  803b86:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
	return 0;
  803b92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b97:	c9                   	leaveq 
  803b98:	c3                   	retq   

0000000000803b99 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803b99:	55                   	push   %rbp
  803b9a:	48 89 e5             	mov    %rsp,%rbp
  803b9d:	53                   	push   %rbx
  803b9e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ba5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803bac:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803bb2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803bb9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803bc0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803bc7:	84 c0                	test   %al,%al
  803bc9:	74 23                	je     803bee <_panic+0x55>
  803bcb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803bd2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803bd6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803bda:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803bde:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803be2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803be6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803bea:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803bee:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803bf5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803bfc:	00 00 00 
  803bff:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803c06:	00 00 00 
  803c09:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c0d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803c14:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803c1b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803c22:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803c29:	00 00 00 
  803c2c:	48 8b 18             	mov    (%rax),%rbx
  803c2f:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  803c36:	00 00 00 
  803c39:	ff d0                	callq  *%rax
  803c3b:	89 c6                	mov    %eax,%esi
  803c3d:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803c43:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c4a:	41 89 d0             	mov    %edx,%r8d
  803c4d:	48 89 c1             	mov    %rax,%rcx
  803c50:	48 89 da             	mov    %rbx,%rdx
  803c53:	48 bf 28 4c 80 00 00 	movabs $0x804c28,%rdi
  803c5a:	00 00 00 
  803c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c62:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  803c69:	00 00 00 
  803c6c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803c6f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803c76:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803c7d:	48 89 d6             	mov    %rdx,%rsi
  803c80:	48 89 c7             	mov    %rax,%rdi
  803c83:	48 b8 16 04 80 00 00 	movabs $0x800416,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
	cprintf("\n");
  803c8f:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  803c96:	00 00 00 
  803c99:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9e:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  803ca5:	00 00 00 
  803ca8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803caa:	cc                   	int3   
  803cab:	eb fd                	jmp    803caa <_panic+0x111>

0000000000803cad <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803cad:	55                   	push   %rbp
  803cae:	48 89 e5             	mov    %rsp,%rbp
  803cb1:	48 83 ec 20          	sub    $0x20,%rsp
  803cb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cbd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803cc1:	48 ba 50 4c 80 00 00 	movabs $0x804c50,%rdx
  803cc8:	00 00 00 
  803ccb:	be 1d 00 00 00       	mov    $0x1d,%esi
  803cd0:	48 bf 69 4c 80 00 00 	movabs $0x804c69,%rdi
  803cd7:	00 00 00 
  803cda:	b8 00 00 00 00       	mov    $0x0,%eax
  803cdf:	48 b9 99 3b 80 00 00 	movabs $0x803b99,%rcx
  803ce6:	00 00 00 
  803ce9:	ff d1                	callq  *%rcx

0000000000803ceb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ceb:	55                   	push   %rbp
  803cec:	48 89 e5             	mov    %rsp,%rbp
  803cef:	48 83 ec 20          	sub    $0x20,%rsp
  803cf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803cf9:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803cfd:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803d00:	48 ba 73 4c 80 00 00 	movabs $0x804c73,%rdx
  803d07:	00 00 00 
  803d0a:	be 2d 00 00 00       	mov    $0x2d,%esi
  803d0f:	48 bf 69 4c 80 00 00 	movabs $0x804c69,%rdi
  803d16:	00 00 00 
  803d19:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1e:	48 b9 99 3b 80 00 00 	movabs $0x803b99,%rcx
  803d25:	00 00 00 
  803d28:	ff d1                	callq  *%rcx

0000000000803d2a <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	53                   	push   %rbx
  803d2f:	48 83 ec 48          	sub    $0x48,%rsp
  803d33:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803d37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803d3e:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803d45:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803d4a:	75 0e                	jne    803d5a <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803d4c:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803d53:	00 00 00 
  803d56:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803d5a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803d5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803d62:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803d69:	00 
	a3 = (uint64_t) 0;
  803d6a:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803d71:	00 
	a4 = (uint64_t) 0;
  803d72:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803d79:	00 
	a5 = 0;
  803d7a:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803d81:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803d82:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d89:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803d8d:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803d91:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803d95:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803d99:	4c 89 c3             	mov    %r8,%rbx
  803d9c:	0f 01 c1             	vmcall 
  803d9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803da2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803da6:	7e 36                	jle    803dde <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803da8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dab:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dae:	41 89 d0             	mov    %edx,%r8d
  803db1:	89 c1                	mov    %eax,%ecx
  803db3:	48 ba 90 4c 80 00 00 	movabs $0x804c90,%rdx
  803dba:	00 00 00 
  803dbd:	be 54 00 00 00       	mov    $0x54,%esi
  803dc2:	48 bf 69 4c 80 00 00 	movabs $0x804c69,%rdi
  803dc9:	00 00 00 
  803dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd1:	49 b9 99 3b 80 00 00 	movabs $0x803b99,%r9
  803dd8:	00 00 00 
  803ddb:	41 ff d1             	callq  *%r9
	return ret;
  803dde:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803de1:	48 83 c4 48          	add    $0x48,%rsp
  803de5:	5b                   	pop    %rbx
  803de6:	5d                   	pop    %rbp
  803de7:	c3                   	retq   

0000000000803de8 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803de8:	55                   	push   %rbp
  803de9:	48 89 e5             	mov    %rsp,%rbp
  803dec:	53                   	push   %rbx
  803ded:	48 83 ec 58          	sub    $0x58,%rsp
  803df1:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803df4:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803df7:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803dfb:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803dfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803e05:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803e0c:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803e11:	75 0e                	jne    803e21 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803e13:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e1a:	00 00 00 
  803e1d:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803e21:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803e24:	48 98                	cltq   
  803e26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803e2a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803e2d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803e31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e35:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803e39:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803e3c:	48 98                	cltq   
  803e3e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803e42:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803e49:	00 

	int r = -E_IPC_NOT_RECV;
  803e4a:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803e51:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e58:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803e5c:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803e60:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803e64:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803e68:	4c 89 c3             	mov    %r8,%rbx
  803e6b:	0f 01 c1             	vmcall 
  803e6e:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803e71:	48 83 c4 58          	add    $0x58,%rsp
  803e75:	5b                   	pop    %rbx
  803e76:	5d                   	pop    %rbp
  803e77:	c3                   	retq   

0000000000803e78 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e78:	55                   	push   %rbp
  803e79:	48 89 e5             	mov    %rsp,%rbp
  803e7c:	48 83 ec 18          	sub    $0x18,%rsp
  803e80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e8a:	eb 4e                	jmp    803eda <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803e8c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803e93:	00 00 00 
  803e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e99:	48 98                	cltq   
  803e9b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ea2:	48 01 d0             	add    %rdx,%rax
  803ea5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803eab:	8b 00                	mov    (%rax),%eax
  803ead:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803eb0:	75 24                	jne    803ed6 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803eb2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803eb9:	00 00 00 
  803ebc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebf:	48 98                	cltq   
  803ec1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ec8:	48 01 d0             	add    %rdx,%rax
  803ecb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ed1:	8b 40 08             	mov    0x8(%rax),%eax
  803ed4:	eb 12                	jmp    803ee8 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803ed6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803eda:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ee1:	7e a9                	jle    803e8c <ipc_find_env+0x14>
	}
	return 0;
  803ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ee8:	c9                   	leaveq 
  803ee9:	c3                   	retq   

0000000000803eea <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803eea:	55                   	push   %rbp
  803eeb:	48 89 e5             	mov    %rsp,%rbp
  803eee:	48 83 ec 18          	sub    $0x18,%rsp
  803ef2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803efa:	48 c1 e8 15          	shr    $0x15,%rax
  803efe:	48 89 c2             	mov    %rax,%rdx
  803f01:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f08:	01 00 00 
  803f0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f0f:	83 e0 01             	and    $0x1,%eax
  803f12:	48 85 c0             	test   %rax,%rax
  803f15:	75 07                	jne    803f1e <pageref+0x34>
		return 0;
  803f17:	b8 00 00 00 00       	mov    $0x0,%eax
  803f1c:	eb 53                	jmp    803f71 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f22:	48 c1 e8 0c          	shr    $0xc,%rax
  803f26:	48 89 c2             	mov    %rax,%rdx
  803f29:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f30:	01 00 00 
  803f33:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f3f:	83 e0 01             	and    $0x1,%eax
  803f42:	48 85 c0             	test   %rax,%rax
  803f45:	75 07                	jne    803f4e <pageref+0x64>
		return 0;
  803f47:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4c:	eb 23                	jmp    803f71 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f52:	48 c1 e8 0c          	shr    $0xc,%rax
  803f56:	48 89 c2             	mov    %rax,%rdx
  803f59:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f60:	00 00 00 
  803f63:	48 c1 e2 04          	shl    $0x4,%rdx
  803f67:	48 01 d0             	add    %rdx,%rax
  803f6a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f6e:	0f b7 c0             	movzwl %ax,%eax
}
  803f71:	c9                   	leaveq 
  803f72:	c3                   	retq   

0000000000803f73 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803f73:	55                   	push   %rbp
  803f74:	48 89 e5             	mov    %rsp,%rbp
  803f77:	48 83 ec 20          	sub    $0x20,%rsp
  803f7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  803f7f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f87:	48 89 d6             	mov    %rdx,%rsi
  803f8a:	48 89 c7             	mov    %rax,%rdi
  803f8d:	48 b8 a9 3f 80 00 00 	movabs $0x803fa9,%rax
  803f94:	00 00 00 
  803f97:	ff d0                	callq  *%rax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	74 05                	je     803fa2 <inet_addr+0x2f>
    return (val.s_addr);
  803f9d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803fa0:	eb 05                	jmp    803fa7 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  803fa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803fa7:	c9                   	leaveq 
  803fa8:	c3                   	retq   

0000000000803fa9 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803fa9:	55                   	push   %rbp
  803faa:	48 89 e5             	mov    %rsp,%rbp
  803fad:	48 83 ec 40          	sub    $0x40,%rsp
  803fb1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803fb5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803fb9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803fbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  803fc1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fc5:	0f b6 00             	movzbl (%rax),%eax
  803fc8:	0f be c0             	movsbl %al,%eax
  803fcb:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803fce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803fd1:	3c 2f                	cmp    $0x2f,%al
  803fd3:	76 07                	jbe    803fdc <inet_aton+0x33>
  803fd5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803fd8:	3c 39                	cmp    $0x39,%al
  803fda:	76 0a                	jbe    803fe6 <inet_aton+0x3d>
      return (0);
  803fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe1:	e9 6e 02 00 00       	jmpq   804254 <inet_aton+0x2ab>
    val = 0;
  803fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  803fed:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  803ff4:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  803ff8:	75 40                	jne    80403a <inet_aton+0x91>
      c = *++cp;
  803ffa:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  803fff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804003:	0f b6 00             	movzbl (%rax),%eax
  804006:	0f be c0             	movsbl %al,%eax
  804009:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80400c:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804010:	74 06                	je     804018 <inet_aton+0x6f>
  804012:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804016:	75 1b                	jne    804033 <inet_aton+0x8a>
        base = 16;
  804018:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  80401f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804024:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804028:	0f b6 00             	movzbl (%rax),%eax
  80402b:	0f be c0             	movsbl %al,%eax
  80402e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804031:	eb 07                	jmp    80403a <inet_aton+0x91>
      } else
        base = 8;
  804033:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80403a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80403d:	3c 2f                	cmp    $0x2f,%al
  80403f:	76 2f                	jbe    804070 <inet_aton+0xc7>
  804041:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804044:	3c 39                	cmp    $0x39,%al
  804046:	77 28                	ja     804070 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  804048:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80404b:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  80404f:	89 c2                	mov    %eax,%edx
  804051:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804054:	01 d0                	add    %edx,%eax
  804056:	83 e8 30             	sub    $0x30,%eax
  804059:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80405c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804061:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804065:	0f b6 00             	movzbl (%rax),%eax
  804068:	0f be c0             	movsbl %al,%eax
  80406b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80406e:	eb 73                	jmp    8040e3 <inet_aton+0x13a>
      } else if (base == 16 && isxdigit(c)) {
  804070:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804074:	75 72                	jne    8040e8 <inet_aton+0x13f>
  804076:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804079:	3c 2f                	cmp    $0x2f,%al
  80407b:	76 07                	jbe    804084 <inet_aton+0xdb>
  80407d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804080:	3c 39                	cmp    $0x39,%al
  804082:	76 1c                	jbe    8040a0 <inet_aton+0xf7>
  804084:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804087:	3c 60                	cmp    $0x60,%al
  804089:	76 07                	jbe    804092 <inet_aton+0xe9>
  80408b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80408e:	3c 66                	cmp    $0x66,%al
  804090:	76 0e                	jbe    8040a0 <inet_aton+0xf7>
  804092:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804095:	3c 40                	cmp    $0x40,%al
  804097:	76 4f                	jbe    8040e8 <inet_aton+0x13f>
  804099:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80409c:	3c 46                	cmp    $0x46,%al
  80409e:	77 48                	ja     8040e8 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8040a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a3:	c1 e0 04             	shl    $0x4,%eax
  8040a6:	89 c2                	mov    %eax,%edx
  8040a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040ab:	8d 48 0a             	lea    0xa(%rax),%ecx
  8040ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040b1:	3c 60                	cmp    $0x60,%al
  8040b3:	76 0e                	jbe    8040c3 <inet_aton+0x11a>
  8040b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040b8:	3c 7a                	cmp    $0x7a,%al
  8040ba:	77 07                	ja     8040c3 <inet_aton+0x11a>
  8040bc:	b8 61 00 00 00       	mov    $0x61,%eax
  8040c1:	eb 05                	jmp    8040c8 <inet_aton+0x11f>
  8040c3:	b8 41 00 00 00       	mov    $0x41,%eax
  8040c8:	29 c1                	sub    %eax,%ecx
  8040ca:	89 c8                	mov    %ecx,%eax
  8040cc:	09 d0                	or     %edx,%eax
  8040ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8040d1:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8040d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040da:	0f b6 00             	movzbl (%rax),%eax
  8040dd:	0f be c0             	movsbl %al,%eax
  8040e0:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8040e3:	e9 52 ff ff ff       	jmpq   80403a <inet_aton+0x91>
    if (c == '.') {
  8040e8:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8040ec:	75 3d                	jne    80412b <inet_aton+0x182>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8040ee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8040f2:	48 83 c0 0c          	add    $0xc,%rax
  8040f6:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8040fa:	72 0a                	jb     804106 <inet_aton+0x15d>
        return (0);
  8040fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804101:	e9 4e 01 00 00       	jmpq   804254 <inet_aton+0x2ab>
      *pp++ = val;
  804106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410a:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80410e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804112:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804115:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804117:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80411c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804120:	0f b6 00             	movzbl (%rax),%eax
  804123:	0f be c0             	movsbl %al,%eax
  804126:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804129:	eb 09                	jmp    804134 <inet_aton+0x18b>
    } else
      break;
  80412b:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80412c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804130:	74 43                	je     804175 <inet_aton+0x1cc>
  804132:	eb 05                	jmp    804139 <inet_aton+0x190>
  }
  804134:	e9 95 fe ff ff       	jmpq   803fce <inet_aton+0x25>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804139:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80413c:	3c 1f                	cmp    $0x1f,%al
  80413e:	76 2b                	jbe    80416b <inet_aton+0x1c2>
  804140:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804143:	84 c0                	test   %al,%al
  804145:	78 24                	js     80416b <inet_aton+0x1c2>
  804147:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80414b:	74 28                	je     804175 <inet_aton+0x1cc>
  80414d:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804151:	74 22                	je     804175 <inet_aton+0x1cc>
  804153:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804157:	74 1c                	je     804175 <inet_aton+0x1cc>
  804159:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80415d:	74 16                	je     804175 <inet_aton+0x1cc>
  80415f:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804163:	74 10                	je     804175 <inet_aton+0x1cc>
  804165:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804169:	74 0a                	je     804175 <inet_aton+0x1cc>
    return (0);
  80416b:	b8 00 00 00 00       	mov    $0x0,%eax
  804170:	e9 df 00 00 00       	jmpq   804254 <inet_aton+0x2ab>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804175:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804179:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80417d:	48 29 c2             	sub    %rax,%rdx
  804180:	48 89 d0             	mov    %rdx,%rax
  804183:	48 c1 f8 02          	sar    $0x2,%rax
  804187:	83 c0 01             	add    $0x1,%eax
  80418a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80418d:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804191:	0f 87 98 00 00 00    	ja     80422f <inet_aton+0x286>
  804197:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80419a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8041a1:	00 
  8041a2:	48 b8 c0 4c 80 00 00 	movabs $0x804cc0,%rax
  8041a9:	00 00 00 
  8041ac:	48 01 d0             	add    %rdx,%rax
  8041af:	48 8b 00             	mov    (%rax),%rax
  8041b2:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8041b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b9:	e9 96 00 00 00       	jmpq   804254 <inet_aton+0x2ab>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8041be:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8041c5:	76 0a                	jbe    8041d1 <inet_aton+0x228>
      return (0);
  8041c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041cc:	e9 83 00 00 00       	jmpq   804254 <inet_aton+0x2ab>
    val |= parts[0] << 24;
  8041d1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8041d4:	c1 e0 18             	shl    $0x18,%eax
  8041d7:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8041da:	eb 53                	jmp    80422f <inet_aton+0x286>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8041dc:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8041e3:	76 07                	jbe    8041ec <inet_aton+0x243>
      return (0);
  8041e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ea:	eb 68                	jmp    804254 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8041ec:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8041ef:	c1 e0 18             	shl    $0x18,%eax
  8041f2:	89 c2                	mov    %eax,%edx
  8041f4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8041f7:	c1 e0 10             	shl    $0x10,%eax
  8041fa:	09 d0                	or     %edx,%eax
  8041fc:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8041ff:	eb 2e                	jmp    80422f <inet_aton+0x286>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804201:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  804208:	76 07                	jbe    804211 <inet_aton+0x268>
      return (0);
  80420a:	b8 00 00 00 00       	mov    $0x0,%eax
  80420f:	eb 43                	jmp    804254 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804211:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804214:	c1 e0 18             	shl    $0x18,%eax
  804217:	89 c2                	mov    %eax,%edx
  804219:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80421c:	c1 e0 10             	shl    $0x10,%eax
  80421f:	09 c2                	or     %eax,%edx
  804221:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804224:	c1 e0 08             	shl    $0x8,%eax
  804227:	09 d0                	or     %edx,%eax
  804229:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80422c:	eb 01                	jmp    80422f <inet_aton+0x286>
    break;
  80422e:	90                   	nop
  }
  if (addr)
  80422f:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804234:	74 19                	je     80424f <inet_aton+0x2a6>
    addr->s_addr = htonl(val);
  804236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804239:	89 c7                	mov    %eax,%edi
  80423b:	48 b8 cd 43 80 00 00 	movabs $0x8043cd,%rax
  804242:	00 00 00 
  804245:	ff d0                	callq  *%rax
  804247:	89 c2                	mov    %eax,%edx
  804249:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80424d:	89 10                	mov    %edx,(%rax)
  return (1);
  80424f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804254:	c9                   	leaveq 
  804255:	c3                   	retq   

0000000000804256 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804256:	55                   	push   %rbp
  804257:	48 89 e5             	mov    %rsp,%rbp
  80425a:	48 83 ec 30          	sub    $0x30,%rsp
  80425e:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804261:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804264:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804267:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80426e:	00 00 00 
  804271:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804275:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804279:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80427d:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804281:	e9 e0 00 00 00       	jmpq   804366 <inet_ntoa+0x110>
    i = 0;
  804286:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80428a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80428e:	0f b6 08             	movzbl (%rax),%ecx
  804291:	0f b6 d1             	movzbl %cl,%edx
  804294:	89 d0                	mov    %edx,%eax
  804296:	c1 e0 02             	shl    $0x2,%eax
  804299:	01 d0                	add    %edx,%eax
  80429b:	c1 e0 03             	shl    $0x3,%eax
  80429e:	01 d0                	add    %edx,%eax
  8042a0:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8042a7:	01 d0                	add    %edx,%eax
  8042a9:	66 c1 e8 08          	shr    $0x8,%ax
  8042ad:	c0 e8 03             	shr    $0x3,%al
  8042b0:	88 45 ed             	mov    %al,-0x13(%rbp)
  8042b3:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8042b7:	89 d0                	mov    %edx,%eax
  8042b9:	c1 e0 02             	shl    $0x2,%eax
  8042bc:	01 d0                	add    %edx,%eax
  8042be:	01 c0                	add    %eax,%eax
  8042c0:	29 c1                	sub    %eax,%ecx
  8042c2:	89 c8                	mov    %ecx,%eax
  8042c4:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8042c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042cb:	0f b6 00             	movzbl (%rax),%eax
  8042ce:	0f b6 d0             	movzbl %al,%edx
  8042d1:	89 d0                	mov    %edx,%eax
  8042d3:	c1 e0 02             	shl    $0x2,%eax
  8042d6:	01 d0                	add    %edx,%eax
  8042d8:	c1 e0 03             	shl    $0x3,%eax
  8042db:	01 d0                	add    %edx,%eax
  8042dd:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8042e4:	01 d0                	add    %edx,%eax
  8042e6:	66 c1 e8 08          	shr    $0x8,%ax
  8042ea:	89 c2                	mov    %eax,%edx
  8042ec:	c0 ea 03             	shr    $0x3,%dl
  8042ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f3:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8042f5:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8042f9:	8d 50 01             	lea    0x1(%rax),%edx
  8042fc:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8042ff:	0f b6 c0             	movzbl %al,%eax
  804302:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804306:	83 c2 30             	add    $0x30,%edx
  804309:	48 98                	cltq   
  80430b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80430f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804313:	0f b6 00             	movzbl (%rax),%eax
  804316:	84 c0                	test   %al,%al
  804318:	0f 85 6c ff ff ff    	jne    80428a <inet_ntoa+0x34>
    while(i--)
  80431e:	eb 1a                	jmp    80433a <inet_ntoa+0xe4>
      *rp++ = inv[i];
  804320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804324:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804328:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80432c:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  804330:	48 63 d2             	movslq %edx,%rdx
  804333:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804338:	88 10                	mov    %dl,(%rax)
    while(i--)
  80433a:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80433e:	8d 50 ff             	lea    -0x1(%rax),%edx
  804341:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804344:	84 c0                	test   %al,%al
  804346:	75 d8                	jne    804320 <inet_ntoa+0xca>
    *rp++ = '.';
  804348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80434c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804350:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804354:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804357:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80435c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804360:	83 c0 01             	add    $0x1,%eax
  804363:	88 45 ef             	mov    %al,-0x11(%rbp)
  804366:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80436a:	0f 86 16 ff ff ff    	jbe    804286 <inet_ntoa+0x30>
  }
  *--rp = 0;
  804370:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804375:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804379:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80437c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804383:	00 00 00 
}
  804386:	c9                   	leaveq 
  804387:	c3                   	retq   

0000000000804388 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804388:	55                   	push   %rbp
  804389:	48 89 e5             	mov    %rsp,%rbp
  80438c:	48 83 ec 08          	sub    $0x8,%rsp
  804390:	89 f8                	mov    %edi,%eax
  804392:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804396:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80439a:	c1 e0 08             	shl    $0x8,%eax
  80439d:	89 c2                	mov    %eax,%edx
  80439f:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8043a3:	66 c1 e8 08          	shr    $0x8,%ax
  8043a7:	09 d0                	or     %edx,%eax
}
  8043a9:	c9                   	leaveq 
  8043aa:	c3                   	retq   

00000000008043ab <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8043ab:	55                   	push   %rbp
  8043ac:	48 89 e5             	mov    %rsp,%rbp
  8043af:	48 83 ec 08          	sub    $0x8,%rsp
  8043b3:	89 f8                	mov    %edi,%eax
  8043b5:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8043b9:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8043bd:	89 c7                	mov    %eax,%edi
  8043bf:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
}
  8043cb:	c9                   	leaveq 
  8043cc:	c3                   	retq   

00000000008043cd <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8043cd:	55                   	push   %rbp
  8043ce:	48 89 e5             	mov    %rsp,%rbp
  8043d1:	48 83 ec 08          	sub    $0x8,%rsp
  8043d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8043d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043db:	c1 e0 18             	shl    $0x18,%eax
  8043de:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8043e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e3:	25 00 ff 00 00       	and    $0xff00,%eax
  8043e8:	c1 e0 08             	shl    $0x8,%eax
  return ((n & 0xff) << 24) |
  8043eb:	09 c2                	or     %eax,%edx
    ((n & 0xff0000UL) >> 8) |
  8043ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f0:	25 00 00 ff 00       	and    $0xff0000,%eax
  8043f5:	48 c1 e8 08          	shr    $0x8,%rax
  return ((n & 0xff) << 24) |
  8043f9:	09 c2                	or     %eax,%edx
    ((n & 0xff000000UL) >> 24);
  8043fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043fe:	c1 e8 18             	shr    $0x18,%eax
  return ((n & 0xff) << 24) |
  804401:	09 d0                	or     %edx,%eax
}
  804403:	c9                   	leaveq 
  804404:	c3                   	retq   

0000000000804405 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804405:	55                   	push   %rbp
  804406:	48 89 e5             	mov    %rsp,%rbp
  804409:	48 83 ec 08          	sub    $0x8,%rsp
  80440d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804413:	89 c7                	mov    %eax,%edi
  804415:	48 b8 cd 43 80 00 00 	movabs $0x8043cd,%rax
  80441c:	00 00 00 
  80441f:	ff d0                	callq  *%rax
}
  804421:	c9                   	leaveq 
  804422:	c3                   	retq   
