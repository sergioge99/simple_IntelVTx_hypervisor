
vmm/guest/obj/user/echosrv:     formato del fichero elf64-x86-64


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
  80003c:	e8 f5 02 00 00       	callq  800336 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

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
  800056:	48 bf 40 44 80 00 00 	movabs $0x804440,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 96 03 80 00 00 	movabs $0x800396,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <handle_client>:

void
handle_client(int sock)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 40          	sub    $0x40,%rsp
  800087:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800091:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800095:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800098:	ba 20 00 00 00       	mov    $0x20,%edx
  80009d:	48 89 ce             	mov    %rcx,%rsi
  8000a0:	89 c7                	mov    %eax,%edi
  8000a2:	48 b8 27 22 80 00 00 	movabs $0x802227,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b5:	79 16                	jns    8000cd <handle_client+0x4e>
		die("Failed to receive initial bytes from client");
  8000b7:	48 bf 48 44 80 00 00 	movabs $0x804448,%rdi
  8000be:	00 00 00 
  8000c1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cd:	eb 75                	jmp    800144 <handle_client+0xc5>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	48 63 d0             	movslq %eax,%rdx
  8000d5:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000d9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000dc:	48 89 ce             	mov    %rcx,%rsi
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	48 b8 71 23 80 00 00 	movabs $0x802371,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax
  8000ed:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f0:	74 16                	je     800108 <handle_client+0x89>
			die("Failed to send bytes to client");
  8000f2:	48 bf 78 44 80 00 00 	movabs $0x804478,%rdi
  8000f9:	00 00 00 
  8000fc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800108:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80010c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80010f:	ba 20 00 00 00       	mov    $0x20,%edx
  800114:	48 89 ce             	mov    %rcx,%rsi
  800117:	89 c7                	mov    %eax,%edi
  800119:	48 b8 27 22 80 00 00 	movabs $0x802227,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
  800125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012c:	79 16                	jns    800144 <handle_client+0xc5>
			die("Failed to receive additional bytes from client");
  80012e:	48 bf 98 44 80 00 00 	movabs $0x804498,%rdi
  800135:	00 00 00 
  800138:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80013f:	00 00 00 
  800142:	ff d0                	callq  *%rax
	while (received > 0) {
  800144:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800148:	7f 85                	jg     8000cf <handle_client+0x50>
	}
	close(sock);
  80014a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
}
  80015b:	c9                   	leaveq 
  80015c:	c3                   	retq   

000000000080015d <umain>:

void
umain(int argc, char **argv)
{
  80015d:	55                   	push   %rbp
  80015e:	48 89 e5             	mov    %rsp,%rbp
  800161:	48 83 ec 70          	sub    $0x70,%rsp
  800165:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  800168:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80016c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800173:	ba 06 00 00 00       	mov    $0x6,%edx
  800178:	be 01 00 00 00       	mov    $0x1,%esi
  80017d:	bf 02 00 00 00       	mov    $0x2,%edi
  800182:	48 b8 a2 2e 80 00 00 	movabs $0x802ea2,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
  80018e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	79 16                	jns    8001ad <umain+0x50>
		die("Failed to create socket");
  800197:	48 bf c7 44 80 00 00 	movabs $0x8044c7,%rdi
  80019e:	00 00 00 
  8001a1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001ad:	48 bf df 44 80 00 00 	movabs $0x8044df,%rdi
  8001b4:	00 00 00 
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001bc:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  8001c3:	00 00 00 
  8001c6:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001c8:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001cc:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d1:	be 00 00 00 00       	mov    $0x0,%esi
  8001d6:	48 89 c7             	mov    %rax,%rdi
  8001d9:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001e5:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ee:	48 b8 e9 43 80 00 00 	movabs $0x8043e9,%rax
  8001f5:	00 00 00 
  8001f8:	ff d0                	callq  *%rax
  8001fa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  8001fd:	bf 07 00 00 00       	mov    $0x7,%edi
  800202:	48 b8 a4 43 80 00 00 	movabs $0x8043a4,%rax
  800209:	00 00 00 
  80020c:	ff d0                	callq  *%rax
  80020e:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800212:	48 bf ee 44 80 00 00 	movabs $0x8044ee,%rdi
  800219:	00 00 00 
  80021c:	b8 00 00 00 00       	mov    $0x0,%eax
  800221:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  800228:	00 00 00 
  80022b:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80022d:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800231:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800234:	ba 10 00 00 00       	mov    $0x10,%edx
  800239:	48 89 ce             	mov    %rcx,%rsi
  80023c:	89 c7                	mov    %eax,%edi
  80023e:	48 b8 92 2c 80 00 00 	movabs $0x802c92,%rax
  800245:	00 00 00 
  800248:	ff d0                	callq  *%rax
  80024a:	85 c0                	test   %eax,%eax
  80024c:	79 16                	jns    800264 <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  80024e:	48 bf 00 45 80 00 00 	movabs $0x804500,%rdi
  800255:	00 00 00 
  800258:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800264:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800267:	be 05 00 00 00       	mov    $0x5,%esi
  80026c:	89 c7                	mov    %eax,%edi
  80026e:	48 b8 b5 2d 80 00 00 	movabs $0x802db5,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
  80027a:	85 c0                	test   %eax,%eax
  80027c:	79 16                	jns    800294 <umain+0x137>
		die("Failed to listen on server socket");
  80027e:	48 bf 28 45 80 00 00 	movabs $0x804528,%rdi
  800285:	00 00 00 
  800288:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax

	cprintf("bound\n");
  800294:	48 bf 4a 45 80 00 00 	movabs $0x80454a,%rdi
  80029b:	00 00 00 
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a3:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  8002aa:	00 00 00 
  8002ad:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8002af:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
  8002b6:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
  8002ba:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8002be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c1:	48 89 ce             	mov    %rcx,%rsi
  8002c4:	89 c7                	mov    %eax,%edi
  8002c6:	48 b8 23 2c 80 00 00 	movabs $0x802c23,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
  8002d2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002d9:	79 16                	jns    8002f1 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002db:	48 bf 58 45 80 00 00 	movabs $0x804558,%rdi
  8002e2:	00 00 00 
  8002e5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002f4:	89 c7                	mov    %eax,%edi
  8002f6:	48 b8 72 42 80 00 00 	movabs $0x804272,%rax
  8002fd:	00 00 00 
  800300:	ff d0                	callq  *%rax
  800302:	48 89 c6             	mov    %rax,%rsi
  800305:	48 bf 7b 45 80 00 00 	movabs $0x80457b,%rdi
  80030c:	00 00 00 
  80030f:	b8 00 00 00 00       	mov    $0x0,%eax
  800314:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  80031b:	00 00 00 
  80031e:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800323:	89 c7                	mov    %eax,%edi
  800325:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
	}
  800331:	e9 79 ff ff ff       	jmpq   8002af <umain+0x152>

0000000000800336 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800336:	55                   	push   %rbp
  800337:	48 89 e5             	mov    %rsp,%rbp
  80033a:	48 83 ec 10          	sub    $0x10,%rsp
  80033e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800341:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800345:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80034c:	00 00 00 
  80034f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80035a:	7e 14                	jle    800370 <libmain+0x3a>
		binaryname = argv[0];
  80035c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800360:	48 8b 10             	mov    (%rax),%rdx
  800363:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80036a:	00 00 00 
  80036d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800370:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800377:	48 89 d6             	mov    %rdx,%rsi
  80037a:	89 c7                	mov    %eax,%edi
  80037c:	48 b8 5d 01 80 00 00 	movabs $0x80015d,%rax
  800383:	00 00 00 
  800386:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800388:	48 b8 96 03 80 00 00 	movabs $0x800396,%rax
  80038f:	00 00 00 
  800392:	ff d0                	callq  *%rax
}
  800394:	c9                   	leaveq 
  800395:	c3                   	retq   

0000000000800396 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800396:	55                   	push   %rbp
  800397:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80039a:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  8003a1:	00 00 00 
  8003a4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ab:	48 b8 e7 18 80 00 00 	movabs $0x8018e7,%rax
  8003b2:	00 00 00 
  8003b5:	ff d0                	callq  *%rax
}
  8003b7:	5d                   	pop    %rbp
  8003b8:	c3                   	retq   

00000000008003b9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003b9:	55                   	push   %rbp
  8003ba:	48 89 e5             	mov    %rsp,%rbp
  8003bd:	48 83 ec 10          	sub    $0x10,%rsp
  8003c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cc:	8b 00                	mov    (%rax),%eax
  8003ce:	8d 48 01             	lea    0x1(%rax),%ecx
  8003d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d5:	89 0a                	mov    %ecx,(%rdx)
  8003d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003da:	89 d1                	mov    %edx,%ecx
  8003dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e0:	48 98                	cltq   
  8003e2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ea:	8b 00                	mov    (%rax),%eax
  8003ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f1:	75 2c                	jne    80041f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f7:	8b 00                	mov    (%rax),%eax
  8003f9:	48 98                	cltq   
  8003fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ff:	48 83 c2 08          	add    $0x8,%rdx
  800403:	48 89 c6             	mov    %rax,%rsi
  800406:	48 89 d7             	mov    %rdx,%rdi
  800409:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  800410:	00 00 00 
  800413:	ff d0                	callq  *%rax
        b->idx = 0;
  800415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800419:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80041f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800423:	8b 40 04             	mov    0x4(%rax),%eax
  800426:	8d 50 01             	lea    0x1(%rax),%edx
  800429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800430:	c9                   	leaveq 
  800431:	c3                   	retq   

0000000000800432 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800432:	55                   	push   %rbp
  800433:	48 89 e5             	mov    %rsp,%rbp
  800436:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80043d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800444:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80044b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800452:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800459:	48 8b 0a             	mov    (%rdx),%rcx
  80045c:	48 89 08             	mov    %rcx,(%rax)
  80045f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800463:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800467:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80046b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80046f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800476:	00 00 00 
    b.cnt = 0;
  800479:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800480:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800483:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80048a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800491:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800498:	48 89 c6             	mov    %rax,%rsi
  80049b:	48 bf b9 03 80 00 00 	movabs $0x8003b9,%rdi
  8004a2:	00 00 00 
  8004a5:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  8004ac:	00 00 00 
  8004af:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004b1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004b7:	48 98                	cltq   
  8004b9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004c0:	48 83 c2 08          	add    $0x8,%rdx
  8004c4:	48 89 c6             	mov    %rax,%rsi
  8004c7:	48 89 d7             	mov    %rdx,%rdi
  8004ca:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004dc:	c9                   	leaveq 
  8004dd:	c3                   	retq   

00000000008004de <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004de:	55                   	push   %rbp
  8004df:	48 89 e5             	mov    %rsp,%rbp
  8004e2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004e9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004f0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004f7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004fe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800505:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80050c:	84 c0                	test   %al,%al
  80050e:	74 20                	je     800530 <cprintf+0x52>
  800510:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800514:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800518:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80051c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800520:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800524:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800528:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80052c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800530:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800537:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80053e:	00 00 00 
  800541:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800548:	00 00 00 
  80054b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80054f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800556:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80055d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800564:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80056b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800572:	48 8b 0a             	mov    (%rdx),%rcx
  800575:	48 89 08             	mov    %rcx,(%rax)
  800578:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80057c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800580:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800584:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800588:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80058f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800596:	48 89 d6             	mov    %rdx,%rsi
  800599:	48 89 c7             	mov    %rax,%rdi
  80059c:	48 b8 32 04 80 00 00 	movabs $0x800432,%rax
  8005a3:	00 00 00 
  8005a6:	ff d0                	callq  *%rax
  8005a8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005ae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005b4:	c9                   	leaveq 
  8005b5:	c3                   	retq   

00000000008005b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b6:	55                   	push   %rbp
  8005b7:	48 89 e5             	mov    %rsp,%rbp
  8005ba:	48 83 ec 30          	sub    $0x30,%rsp
  8005be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005ca:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005cd:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005d1:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005d8:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005dc:	77 42                	ja     800620 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005de:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005e1:	8d 78 ff             	lea    -0x1(%rax),%edi
  8005e4:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8005e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f0:	48 f7 f6             	div    %rsi
  8005f3:	49 89 c2             	mov    %rax,%r10
  8005f6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005f9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005fc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800604:	41 89 c9             	mov    %ecx,%r9d
  800607:	41 89 f8             	mov    %edi,%r8d
  80060a:	89 d1                	mov    %edx,%ecx
  80060c:	4c 89 d2             	mov    %r10,%rdx
  80060f:	48 89 c7             	mov    %rax,%rdi
  800612:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  800619:	00 00 00 
  80061c:	ff d0                	callq  *%rax
  80061e:	eb 1e                	jmp    80063e <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800620:	eb 12                	jmp    800634 <printnum+0x7e>
			putch(padc, putdat);
  800622:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800626:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062d:	48 89 ce             	mov    %rcx,%rsi
  800630:	89 d7                	mov    %edx,%edi
  800632:	ff d0                	callq  *%rax
		while (--width > 0)
  800634:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800638:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80063c:	7f e4                	jg     800622 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800645:	ba 00 00 00 00       	mov    $0x0,%edx
  80064a:	48 f7 f1             	div    %rcx
  80064d:	48 b8 b0 47 80 00 00 	movabs $0x8047b0,%rax
  800654:	00 00 00 
  800657:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80065b:	0f be d0             	movsbl %al,%edx
  80065e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800666:	48 89 ce             	mov    %rcx,%rsi
  800669:	89 d7                	mov    %edx,%edi
  80066b:	ff d0                	callq  *%rax
}
  80066d:	c9                   	leaveq 
  80066e:	c3                   	retq   

000000000080066f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80066f:	55                   	push   %rbp
  800670:	48 89 e5             	mov    %rsp,%rbp
  800673:	48 83 ec 20          	sub    $0x20,%rsp
  800677:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80067e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800682:	7e 4f                	jle    8006d3 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	8b 00                	mov    (%rax),%eax
  80068a:	83 f8 30             	cmp    $0x30,%eax
  80068d:	73 24                	jae    8006b3 <getuint+0x44>
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	8b 00                	mov    (%rax),%eax
  80069d:	89 c0                	mov    %eax,%eax
  80069f:	48 01 d0             	add    %rdx,%rax
  8006a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006af:	89 0a                	mov    %ecx,(%rdx)
  8006b1:	eb 14                	jmp    8006c7 <getuint+0x58>
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006bb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c7:	48 8b 00             	mov    (%rax),%rax
  8006ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ce:	e9 9d 00 00 00       	jmpq   800770 <getuint+0x101>
	else if (lflag)
  8006d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d7:	74 4c                	je     800725 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	8b 00                	mov    (%rax),%eax
  8006df:	83 f8 30             	cmp    $0x30,%eax
  8006e2:	73 24                	jae    800708 <getuint+0x99>
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	8b 00                	mov    (%rax),%eax
  8006f2:	89 c0                	mov    %eax,%eax
  8006f4:	48 01 d0             	add    %rdx,%rax
  8006f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fb:	8b 12                	mov    (%rdx),%edx
  8006fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800704:	89 0a                	mov    %ecx,(%rdx)
  800706:	eb 14                	jmp    80071c <getuint+0xad>
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800710:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071c:	48 8b 00             	mov    (%rax),%rax
  80071f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800723:	eb 4b                	jmp    800770 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	83 f8 30             	cmp    $0x30,%eax
  80072e:	73 24                	jae    800754 <getuint+0xe5>
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 01 d0             	add    %rdx,%rax
  800743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800747:	8b 12                	mov    (%rdx),%edx
  800749:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	89 0a                	mov    %ecx,(%rdx)
  800752:	eb 14                	jmp    800768 <getuint+0xf9>
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 8b 40 08          	mov    0x8(%rax),%rax
  80075c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800760:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800764:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800768:	8b 00                	mov    (%rax),%eax
  80076a:	89 c0                	mov    %eax,%eax
  80076c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800774:	c9                   	leaveq 
  800775:	c3                   	retq   

0000000000800776 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800776:	55                   	push   %rbp
  800777:	48 89 e5             	mov    %rsp,%rbp
  80077a:	48 83 ec 20          	sub    $0x20,%rsp
  80077e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800782:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800785:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800789:	7e 4f                	jle    8007da <getint+0x64>
		x=va_arg(*ap, long long);
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	8b 00                	mov    (%rax),%eax
  800791:	83 f8 30             	cmp    $0x30,%eax
  800794:	73 24                	jae    8007ba <getint+0x44>
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	8b 00                	mov    (%rax),%eax
  8007a4:	89 c0                	mov    %eax,%eax
  8007a6:	48 01 d0             	add    %rdx,%rax
  8007a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ad:	8b 12                	mov    (%rdx),%edx
  8007af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b6:	89 0a                	mov    %ecx,(%rdx)
  8007b8:	eb 14                	jmp    8007ce <getint+0x58>
  8007ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007c2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ce:	48 8b 00             	mov    (%rax),%rax
  8007d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d5:	e9 9d 00 00 00       	jmpq   800877 <getint+0x101>
	else if (lflag)
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007de:	74 4c                	je     80082c <getint+0xb6>
		x=va_arg(*ap, long);
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	8b 00                	mov    (%rax),%eax
  8007e6:	83 f8 30             	cmp    $0x30,%eax
  8007e9:	73 24                	jae    80080f <getint+0x99>
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	89 c0                	mov    %eax,%eax
  8007fb:	48 01 d0             	add    %rdx,%rax
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	8b 12                	mov    (%rdx),%edx
  800804:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	89 0a                	mov    %ecx,(%rdx)
  80080d:	eb 14                	jmp    800823 <getint+0xad>
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	48 8b 40 08          	mov    0x8(%rax),%rax
  800817:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80081b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800823:	48 8b 00             	mov    (%rax),%rax
  800826:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082a:	eb 4b                	jmp    800877 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	8b 00                	mov    (%rax),%eax
  800832:	83 f8 30             	cmp    $0x30,%eax
  800835:	73 24                	jae    80085b <getint+0xe5>
  800837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	8b 00                	mov    (%rax),%eax
  800845:	89 c0                	mov    %eax,%eax
  800847:	48 01 d0             	add    %rdx,%rax
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	8b 12                	mov    (%rdx),%edx
  800850:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800853:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800857:	89 0a                	mov    %ecx,(%rdx)
  800859:	eb 14                	jmp    80086f <getint+0xf9>
  80085b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800863:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086f:	8b 00                	mov    (%rax),%eax
  800871:	48 98                	cltq   
  800873:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80087b:	c9                   	leaveq 
  80087c:	c3                   	retq   

000000000080087d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087d:	55                   	push   %rbp
  80087e:	48 89 e5             	mov    %rsp,%rbp
  800881:	41 54                	push   %r12
  800883:	53                   	push   %rbx
  800884:	48 83 ec 60          	sub    $0x60,%rsp
  800888:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80088c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800890:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800894:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800898:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80089c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008a0:	48 8b 0a             	mov    (%rdx),%rcx
  8008a3:	48 89 08             	mov    %rcx,(%rax)
  8008a6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008aa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008b2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b6:	eb 17                	jmp    8008cf <vprintfmt+0x52>
			if (ch == '\0')
  8008b8:	85 db                	test   %ebx,%ebx
  8008ba:	0f 84 c5 04 00 00    	je     800d85 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8008c0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c8:	48 89 d6             	mov    %rdx,%rsi
  8008cb:	89 df                	mov    %ebx,%edi
  8008cd:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008db:	0f b6 00             	movzbl (%rax),%eax
  8008de:	0f b6 d8             	movzbl %al,%ebx
  8008e1:	83 fb 25             	cmp    $0x25,%ebx
  8008e4:	75 d2                	jne    8008b8 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  8008e6:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008ea:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800906:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80090a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80090e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800912:	0f b6 00             	movzbl (%rax),%eax
  800915:	0f b6 d8             	movzbl %al,%ebx
  800918:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80091b:	83 f8 55             	cmp    $0x55,%eax
  80091e:	0f 87 2e 04 00 00    	ja     800d52 <vprintfmt+0x4d5>
  800924:	89 c0                	mov    %eax,%eax
  800926:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80092d:	00 
  80092e:	48 b8 d8 47 80 00 00 	movabs $0x8047d8,%rax
  800935:	00 00 00 
  800938:	48 01 d0             	add    %rdx,%rax
  80093b:	48 8b 00             	mov    (%rax),%rax
  80093e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800940:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800944:	eb c0                	jmp    800906 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800946:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80094a:	eb ba                	jmp    800906 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800953:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	c1 e0 02             	shl    $0x2,%eax
  80095b:	01 d0                	add    %edx,%eax
  80095d:	01 c0                	add    %eax,%eax
  80095f:	01 d8                	add    %ebx,%eax
  800961:	83 e8 30             	sub    $0x30,%eax
  800964:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800967:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80096b:	0f b6 00             	movzbl (%rax),%eax
  80096e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800971:	83 fb 2f             	cmp    $0x2f,%ebx
  800974:	7e 0c                	jle    800982 <vprintfmt+0x105>
  800976:	83 fb 39             	cmp    $0x39,%ebx
  800979:	7f 07                	jg     800982 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  80097b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800980:	eb d1                	jmp    800953 <vprintfmt+0xd6>
			goto process_precision;
  800982:	eb 50                	jmp    8009d4 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800984:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800987:	83 f8 30             	cmp    $0x30,%eax
  80098a:	73 17                	jae    8009a3 <vprintfmt+0x126>
  80098c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800990:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800993:	89 d2                	mov    %edx,%edx
  800995:	48 01 d0             	add    %rdx,%rax
  800998:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80099b:	83 c2 08             	add    $0x8,%edx
  80099e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009a1:	eb 0c                	jmp    8009af <vprintfmt+0x132>
  8009a3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009a7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009ab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009b4:	eb 1e                	jmp    8009d4 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8009b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ba:	79 07                	jns    8009c3 <vprintfmt+0x146>
				width = 0;
  8009bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009c3:	e9 3e ff ff ff       	jmpq   800906 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009c8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009cf:	e9 32 ff ff ff       	jmpq   800906 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d8:	79 0d                	jns    8009e7 <vprintfmt+0x16a>
				width = precision, precision = -1;
  8009da:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009dd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009e7:	e9 1a ff ff ff       	jmpq   800906 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009ec:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009f0:	e9 11 ff ff ff       	jmpq   800906 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f8:	83 f8 30             	cmp    $0x30,%eax
  8009fb:	73 17                	jae    800a14 <vprintfmt+0x197>
  8009fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a01:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a04:	89 d2                	mov    %edx,%edx
  800a06:	48 01 d0             	add    %rdx,%rax
  800a09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0c:	83 c2 08             	add    $0x8,%edx
  800a0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a12:	eb 0c                	jmp    800a20 <vprintfmt+0x1a3>
  800a14:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a18:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a1c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a20:	8b 10                	mov    (%rax),%edx
  800a22:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2a:	48 89 ce             	mov    %rcx,%rsi
  800a2d:	89 d7                	mov    %edx,%edi
  800a2f:	ff d0                	callq  *%rax
			break;
  800a31:	e9 4a 03 00 00       	jmpq   800d80 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a39:	83 f8 30             	cmp    $0x30,%eax
  800a3c:	73 17                	jae    800a55 <vprintfmt+0x1d8>
  800a3e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a45:	89 d2                	mov    %edx,%edx
  800a47:	48 01 d0             	add    %rdx,%rax
  800a4a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4d:	83 c2 08             	add    $0x8,%edx
  800a50:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a53:	eb 0c                	jmp    800a61 <vprintfmt+0x1e4>
  800a55:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a59:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a61:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	79 02                	jns    800a69 <vprintfmt+0x1ec>
				err = -err;
  800a67:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a69:	83 fb 15             	cmp    $0x15,%ebx
  800a6c:	7f 16                	jg     800a84 <vprintfmt+0x207>
  800a6e:	48 b8 00 47 80 00 00 	movabs $0x804700,%rax
  800a75:	00 00 00 
  800a78:	48 63 d3             	movslq %ebx,%rdx
  800a7b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a7f:	4d 85 e4             	test   %r12,%r12
  800a82:	75 2e                	jne    800ab2 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800a84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8c:	89 d9                	mov    %ebx,%ecx
  800a8e:	48 ba c1 47 80 00 00 	movabs $0x8047c1,%rdx
  800a95:	00 00 00 
  800a98:	48 89 c7             	mov    %rax,%rdi
  800a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa0:	49 b8 8e 0d 80 00 00 	movabs $0x800d8e,%r8
  800aa7:	00 00 00 
  800aaa:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aad:	e9 ce 02 00 00       	jmpq   800d80 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800ab2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aba:	4c 89 e1             	mov    %r12,%rcx
  800abd:	48 ba ca 47 80 00 00 	movabs $0x8047ca,%rdx
  800ac4:	00 00 00 
  800ac7:	48 89 c7             	mov    %rax,%rdi
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
  800acf:	49 b8 8e 0d 80 00 00 	movabs $0x800d8e,%r8
  800ad6:	00 00 00 
  800ad9:	41 ff d0             	callq  *%r8
			break;
  800adc:	e9 9f 02 00 00       	jmpq   800d80 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ae1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae4:	83 f8 30             	cmp    $0x30,%eax
  800ae7:	73 17                	jae    800b00 <vprintfmt+0x283>
  800ae9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af0:	89 d2                	mov    %edx,%edx
  800af2:	48 01 d0             	add    %rdx,%rax
  800af5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af8:	83 c2 08             	add    $0x8,%edx
  800afb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afe:	eb 0c                	jmp    800b0c <vprintfmt+0x28f>
  800b00:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b04:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b08:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0c:	4c 8b 20             	mov    (%rax),%r12
  800b0f:	4d 85 e4             	test   %r12,%r12
  800b12:	75 0a                	jne    800b1e <vprintfmt+0x2a1>
				p = "(null)";
  800b14:	49 bc cd 47 80 00 00 	movabs $0x8047cd,%r12
  800b1b:	00 00 00 
			if (width > 0 && padc != '-')
  800b1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b22:	7e 3f                	jle    800b63 <vprintfmt+0x2e6>
  800b24:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b28:	74 39                	je     800b63 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2d:	48 98                	cltq   
  800b2f:	48 89 c6             	mov    %rax,%rsi
  800b32:	4c 89 e7             	mov    %r12,%rdi
  800b35:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  800b3c:	00 00 00 
  800b3f:	ff d0                	callq  *%rax
  800b41:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b44:	eb 17                	jmp    800b5d <vprintfmt+0x2e0>
					putch(padc, putdat);
  800b46:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b4a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	48 89 ce             	mov    %rcx,%rsi
  800b55:	89 d7                	mov    %edx,%edi
  800b57:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800b59:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b61:	7f e3                	jg     800b46 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 37                	jmp    800b9c <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b69:	74 1e                	je     800b89 <vprintfmt+0x30c>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x2f8>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 14                	jle    800b89 <vprintfmt+0x30c>
					putch('?', putdat);
  800b75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7d:	48 89 d6             	mov    %rdx,%rsi
  800b80:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b85:	ff d0                	callq  *%rax
  800b87:	eb 0f                	jmp    800b98 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800b89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b91:	48 89 d6             	mov    %rdx,%rsi
  800b94:	89 df                	mov    %ebx,%edi
  800b96:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b98:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9c:	4c 89 e0             	mov    %r12,%rax
  800b9f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ba3:	0f b6 00             	movzbl (%rax),%eax
  800ba6:	0f be d8             	movsbl %al,%ebx
  800ba9:	85 db                	test   %ebx,%ebx
  800bab:	74 10                	je     800bbd <vprintfmt+0x340>
  800bad:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb1:	78 b2                	js     800b65 <vprintfmt+0x2e8>
  800bb3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bb7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bbb:	79 a8                	jns    800b65 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800bbd:	eb 16                	jmp    800bd5 <vprintfmt+0x358>
				putch(' ', putdat);
  800bbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc7:	48 89 d6             	mov    %rdx,%rsi
  800bca:	bf 20 00 00 00       	mov    $0x20,%edi
  800bcf:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800bd1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd9:	7f e4                	jg     800bbf <vprintfmt+0x342>
			break;
  800bdb:	e9 a0 01 00 00       	jmpq   800d80 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be4:	be 03 00 00 00       	mov    $0x3,%esi
  800be9:	48 89 c7             	mov    %rax,%rdi
  800bec:	48 b8 76 07 80 00 00 	movabs $0x800776,%rax
  800bf3:	00 00 00 
  800bf6:	ff d0                	callq  *%rax
  800bf8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c00:	48 85 c0             	test   %rax,%rax
  800c03:	79 1d                	jns    800c22 <vprintfmt+0x3a5>
				putch('-', putdat);
  800c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c15:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1b:	48 f7 d8             	neg    %rax
  800c1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c22:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c29:	e9 e5 00 00 00       	jmpq   800d13 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c2e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c32:	be 03 00 00 00       	mov    $0x3,%esi
  800c37:	48 89 c7             	mov    %rax,%rdi
  800c3a:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  800c41:	00 00 00 
  800c44:	ff d0                	callq  *%rax
  800c46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c4a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c51:	e9 bd 00 00 00       	jmpq   800d13 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 58 00 00 00       	mov    $0x58,%edi
  800c66:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c70:	48 89 d6             	mov    %rdx,%rsi
  800c73:	bf 58 00 00 00       	mov    $0x58,%edi
  800c78:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c82:	48 89 d6             	mov    %rdx,%rsi
  800c85:	bf 58 00 00 00       	mov    $0x58,%edi
  800c8a:	ff d0                	callq  *%rax
			break;
  800c8c:	e9 ef 00 00 00       	jmpq   800d80 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800c91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c99:	48 89 d6             	mov    %rdx,%rsi
  800c9c:	bf 30 00 00 00       	mov    $0x30,%edi
  800ca1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ca3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cab:	48 89 d6             	mov    %rdx,%rsi
  800cae:	bf 78 00 00 00       	mov    $0x78,%edi
  800cb3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb8:	83 f8 30             	cmp    $0x30,%eax
  800cbb:	73 17                	jae    800cd4 <vprintfmt+0x457>
  800cbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc4:	89 d2                	mov    %edx,%edx
  800cc6:	48 01 d0             	add    %rdx,%rax
  800cc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccc:	83 c2 08             	add    $0x8,%edx
  800ccf:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800cd2:	eb 0c                	jmp    800ce0 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800cd4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cd8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cdc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce0:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800ce3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ce7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cee:	eb 23                	jmp    800d13 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf4:	be 03 00 00 00       	mov    $0x3,%esi
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d0c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d13:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d18:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d1b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d22:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	45 89 c1             	mov    %r8d,%r9d
  800d2d:	41 89 f8             	mov    %edi,%r8d
  800d30:	48 89 c7             	mov    %rax,%rdi
  800d33:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  800d3a:	00 00 00 
  800d3d:	ff d0                	callq  *%rax
			break;
  800d3f:	eb 3f                	jmp    800d80 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d49:	48 89 d6             	mov    %rdx,%rsi
  800d4c:	89 df                	mov    %ebx,%edi
  800d4e:	ff d0                	callq  *%rax
			break;
  800d50:	eb 2e                	jmp    800d80 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5a:	48 89 d6             	mov    %rdx,%rsi
  800d5d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d62:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d64:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d69:	eb 05                	jmp    800d70 <vprintfmt+0x4f3>
  800d6b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d70:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d74:	48 83 e8 01          	sub    $0x1,%rax
  800d78:	0f b6 00             	movzbl (%rax),%eax
  800d7b:	3c 25                	cmp    $0x25,%al
  800d7d:	75 ec                	jne    800d6b <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800d7f:	90                   	nop
		}
	}
  800d80:	e9 31 fb ff ff       	jmpq   8008b6 <vprintfmt+0x39>
	va_end(aq);
}
  800d85:	48 83 c4 60          	add    $0x60,%rsp
  800d89:	5b                   	pop    %rbx
  800d8a:	41 5c                	pop    %r12
  800d8c:	5d                   	pop    %rbp
  800d8d:	c3                   	retq   

0000000000800d8e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
  800d92:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d99:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800da0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 20                	je     800de0 <printfmt+0x52>
  800dc0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de0:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dee:	00 00 00 
  800df1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800df8:	00 00 00 
  800dfb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e06:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e14:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e1b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e22:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e29:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e30:	48 89 c7             	mov    %rax,%rdi
  800e33:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e3f:	c9                   	leaveq 
  800e40:	c3                   	retq   

0000000000800e41 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
  800e45:	48 83 ec 10          	sub    $0x10,%rsp
  800e49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e54:	8b 40 10             	mov    0x10(%rax),%eax
  800e57:	8d 50 01             	lea    0x1(%rax),%edx
  800e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	48 8b 10             	mov    (%rax),%rdx
  800e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e70:	48 39 c2             	cmp    %rax,%rdx
  800e73:	73 17                	jae    800e8c <sprintputch+0x4b>
		*b->buf++ = ch;
  800e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e79:	48 8b 00             	mov    (%rax),%rax
  800e7c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e84:	48 89 0a             	mov    %rcx,(%rdx)
  800e87:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e8a:	88 10                	mov    %dl,(%rax)
}
  800e8c:	c9                   	leaveq 
  800e8d:	c3                   	retq   

0000000000800e8e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e8e:	55                   	push   %rbp
  800e8f:	48 89 e5             	mov    %rsp,%rbp
  800e92:	48 83 ec 50          	sub    $0x50,%rsp
  800e96:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e9a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e9d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ea9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ead:	48 8b 0a             	mov    (%rdx),%rcx
  800eb0:	48 89 08             	mov    %rcx,(%rax)
  800eb3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ebb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ebf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ecb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ece:	48 98                	cltq   
  800ed0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ed4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed8:	48 01 d0             	add    %rdx,%rax
  800edb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800edf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eeb:	74 06                	je     800ef3 <vsnprintf+0x65>
  800eed:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef1:	7f 07                	jg     800efa <vsnprintf+0x6c>
		return -E_INVAL;
  800ef3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef8:	eb 2f                	jmp    800f29 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800efa:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800efe:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f02:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f06:	48 89 c6             	mov    %rax,%rsi
  800f09:	48 bf 41 0e 80 00 00 	movabs $0x800e41,%rdi
  800f10:	00 00 00 
  800f13:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f23:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f26:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f29:	c9                   	leaveq 
  800f2a:	c3                   	retq   

0000000000800f2b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2b:	55                   	push   %rbp
  800f2c:	48 89 e5             	mov    %rsp,%rbp
  800f2f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f36:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f3d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f43:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f51:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f58:	84 c0                	test   %al,%al
  800f5a:	74 20                	je     800f7c <snprintf+0x51>
  800f5c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f60:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f64:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f68:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f70:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f74:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f78:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f83:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f8a:	00 00 00 
  800f8d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f94:	00 00 00 
  800f97:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fb0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fbe:	48 8b 0a             	mov    (%rdx),%rcx
  800fc1:	48 89 08             	mov    %rcx,(%rax)
  800fc4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fcc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fd0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd4:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fdb:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe2:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fe8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fef:	48 89 c7             	mov    %rax,%rdi
  800ff2:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  800ff9:	00 00 00 
  800ffc:	ff d0                	callq  *%rax
  800ffe:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801004:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80100a:	c9                   	leaveq 
  80100b:	c3                   	retq   

000000000080100c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80100c:	55                   	push   %rbp
  80100d:	48 89 e5             	mov    %rsp,%rbp
  801010:	48 83 ec 18          	sub    $0x18,%rsp
  801014:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101f:	eb 09                	jmp    80102a <strlen+0x1e>
		n++;
  801021:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801025:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102e:	0f b6 00             	movzbl (%rax),%eax
  801031:	84 c0                	test   %al,%al
  801033:	75 ec                	jne    801021 <strlen+0x15>
	return n;
  801035:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801038:	c9                   	leaveq 
  801039:	c3                   	retq   

000000000080103a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80103a:	55                   	push   %rbp
  80103b:	48 89 e5             	mov    %rsp,%rbp
  80103e:	48 83 ec 20          	sub    $0x20,%rsp
  801042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801051:	eb 0e                	jmp    801061 <strnlen+0x27>
		n++;
  801053:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801057:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801061:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801066:	74 0b                	je     801073 <strnlen+0x39>
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	0f b6 00             	movzbl (%rax),%eax
  80106f:	84 c0                	test   %al,%al
  801071:	75 e0                	jne    801053 <strnlen+0x19>
	return n;
  801073:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801076:	c9                   	leaveq 
  801077:	c3                   	retq   

0000000000801078 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801078:	55                   	push   %rbp
  801079:	48 89 e5             	mov    %rsp,%rbp
  80107c:	48 83 ec 20          	sub    $0x20,%rsp
  801080:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801084:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801090:	90                   	nop
  801091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801095:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801099:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80109d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010a9:	0f b6 12             	movzbl (%rdx),%edx
  8010ac:	88 10                	mov    %dl,(%rax)
  8010ae:	0f b6 00             	movzbl (%rax),%eax
  8010b1:	84 c0                	test   %al,%al
  8010b3:	75 dc                	jne    801091 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b9:	c9                   	leaveq 
  8010ba:	c3                   	retq   

00000000008010bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010bb:	55                   	push   %rbp
  8010bc:	48 89 e5             	mov    %rsp,%rbp
  8010bf:	48 83 ec 20          	sub    $0x20,%rsp
  8010c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	48 89 c7             	mov    %rax,%rdi
  8010d2:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  8010d9:	00 00 00 
  8010dc:	ff d0                	callq  *%rax
  8010de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e4:	48 63 d0             	movslq %eax,%rdx
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 01 c2             	add    %rax,%rdx
  8010ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f2:	48 89 c6             	mov    %rax,%rsi
  8010f5:	48 89 d7             	mov    %rdx,%rdi
  8010f8:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  8010ff:	00 00 00 
  801102:	ff d0                	callq  *%rax
	return dst;
  801104:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801108:	c9                   	leaveq 
  801109:	c3                   	retq   

000000000080110a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 83 ec 28          	sub    $0x28,%rsp
  801112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801126:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112d:	00 
  80112e:	eb 2a                	jmp    80115a <strncpy+0x50>
		*dst++ = *src;
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801138:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801140:	0f b6 12             	movzbl (%rdx),%edx
  801143:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801145:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801149:	0f b6 00             	movzbl (%rax),%eax
  80114c:	84 c0                	test   %al,%al
  80114e:	74 05                	je     801155 <strncpy+0x4b>
			src++;
  801150:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801155:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801162:	72 cc                	jb     801130 <strncpy+0x26>
	}
	return ret;
  801164:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801168:	c9                   	leaveq 
  801169:	c3                   	retq   

000000000080116a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80116a:	55                   	push   %rbp
  80116b:	48 89 e5             	mov    %rsp,%rbp
  80116e:	48 83 ec 28          	sub    $0x28,%rsp
  801172:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801176:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80117e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801182:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801186:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118b:	74 3d                	je     8011ca <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80118d:	eb 1d                	jmp    8011ac <strlcpy+0x42>
			*dst++ = *src++;
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801193:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801197:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80119f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a7:	0f b6 12             	movzbl (%rdx),%edx
  8011aa:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8011ac:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b6:	74 0b                	je     8011c3 <strlcpy+0x59>
  8011b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bc:	0f b6 00             	movzbl (%rax),%eax
  8011bf:	84 c0                	test   %al,%al
  8011c1:	75 cc                	jne    80118f <strlcpy+0x25>
		*dst = '\0';
  8011c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d2:	48 29 c2             	sub    %rax,%rdx
  8011d5:	48 89 d0             	mov    %rdx,%rax
}
  8011d8:	c9                   	leaveq 
  8011d9:	c3                   	retq   

00000000008011da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011da:	55                   	push   %rbp
  8011db:	48 89 e5             	mov    %rsp,%rbp
  8011de:	48 83 ec 10          	sub    $0x10,%rsp
  8011e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ea:	eb 0a                	jmp    8011f6 <strcmp+0x1c>
		p++, q++;
  8011ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	84 c0                	test   %al,%al
  8011ff:	74 12                	je     801213 <strcmp+0x39>
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	0f b6 10             	movzbl (%rax),%edx
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	38 c2                	cmp    %al,%dl
  801211:	74 d9                	je     8011ec <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801213:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801217:	0f b6 00             	movzbl (%rax),%eax
  80121a:	0f b6 d0             	movzbl %al,%edx
  80121d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801221:	0f b6 00             	movzbl (%rax),%eax
  801224:	0f b6 c0             	movzbl %al,%eax
  801227:	29 c2                	sub    %eax,%edx
  801229:	89 d0                	mov    %edx,%eax
}
  80122b:	c9                   	leaveq 
  80122c:	c3                   	retq   

000000000080122d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80122d:	55                   	push   %rbp
  80122e:	48 89 e5             	mov    %rsp,%rbp
  801231:	48 83 ec 18          	sub    $0x18,%rsp
  801235:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801239:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80123d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801241:	eb 0f                	jmp    801252 <strncmp+0x25>
		n--, p++, q++;
  801243:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801248:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801252:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801257:	74 1d                	je     801276 <strncmp+0x49>
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	0f b6 00             	movzbl (%rax),%eax
  801260:	84 c0                	test   %al,%al
  801262:	74 12                	je     801276 <strncmp+0x49>
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	0f b6 10             	movzbl (%rax),%edx
  80126b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126f:	0f b6 00             	movzbl (%rax),%eax
  801272:	38 c2                	cmp    %al,%dl
  801274:	74 cd                	je     801243 <strncmp+0x16>
	if (n == 0)
  801276:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127b:	75 07                	jne    801284 <strncmp+0x57>
		return 0;
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
  801282:	eb 18                	jmp    80129c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801288:	0f b6 00             	movzbl (%rax),%eax
  80128b:	0f b6 d0             	movzbl %al,%edx
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	0f b6 00             	movzbl (%rax),%eax
  801295:	0f b6 c0             	movzbl %al,%eax
  801298:	29 c2                	sub    %eax,%edx
  80129a:	89 d0                	mov    %edx,%eax
}
  80129c:	c9                   	leaveq 
  80129d:	c3                   	retq   

000000000080129e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80129e:	55                   	push   %rbp
  80129f:	48 89 e5             	mov    %rsp,%rbp
  8012a2:	48 83 ec 10          	sub    $0x10,%rsp
  8012a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012aa:	89 f0                	mov    %esi,%eax
  8012ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012af:	eb 17                	jmp    8012c8 <strchr+0x2a>
		if (*s == c)
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b5:	0f b6 00             	movzbl (%rax),%eax
  8012b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012bb:	75 06                	jne    8012c3 <strchr+0x25>
			return (char *) s;
  8012bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c1:	eb 15                	jmp    8012d8 <strchr+0x3a>
	for (; *s; s++)
  8012c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cc:	0f b6 00             	movzbl (%rax),%eax
  8012cf:	84 c0                	test   %al,%al
  8012d1:	75 de                	jne    8012b1 <strchr+0x13>
	return 0;
  8012d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d8:	c9                   	leaveq 
  8012d9:	c3                   	retq   

00000000008012da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012da:	55                   	push   %rbp
  8012db:	48 89 e5             	mov    %rsp,%rbp
  8012de:	48 83 ec 10          	sub    $0x10,%rsp
  8012e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e6:	89 f0                	mov    %esi,%eax
  8012e8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012eb:	eb 13                	jmp    801300 <strfind+0x26>
		if (*s == c)
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f1:	0f b6 00             	movzbl (%rax),%eax
  8012f4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f7:	75 02                	jne    8012fb <strfind+0x21>
			break;
  8012f9:	eb 10                	jmp    80130b <strfind+0x31>
	for (; *s; s++)
  8012fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801304:	0f b6 00             	movzbl (%rax),%eax
  801307:	84 c0                	test   %al,%al
  801309:	75 e2                	jne    8012ed <strfind+0x13>
	return (char *) s;
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 18          	sub    $0x18,%rsp
  801319:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801320:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801324:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801329:	75 06                	jne    801331 <memset+0x20>
		return v;
  80132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132f:	eb 69                	jmp    80139a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801335:	83 e0 03             	and    $0x3,%eax
  801338:	48 85 c0             	test   %rax,%rax
  80133b:	75 48                	jne    801385 <memset+0x74>
  80133d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801341:	83 e0 03             	and    $0x3,%eax
  801344:	48 85 c0             	test   %rax,%rax
  801347:	75 3c                	jne    801385 <memset+0x74>
		c &= 0xFF;
  801349:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801350:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801353:	c1 e0 18             	shl    $0x18,%eax
  801356:	89 c2                	mov    %eax,%edx
  801358:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135b:	c1 e0 10             	shl    $0x10,%eax
  80135e:	09 c2                	or     %eax,%edx
  801360:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801363:	c1 e0 08             	shl    $0x8,%eax
  801366:	09 d0                	or     %edx,%eax
  801368:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136f:	48 c1 e8 02          	shr    $0x2,%rax
  801373:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801376:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137d:	48 89 d7             	mov    %rdx,%rdi
  801380:	fc                   	cld    
  801381:	f3 ab                	rep stos %eax,%es:(%rdi)
  801383:	eb 11                	jmp    801396 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801385:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801389:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801390:	48 89 d7             	mov    %rdx,%rdi
  801393:	fc                   	cld    
  801394:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80139a:	c9                   	leaveq 
  80139b:	c3                   	retq   

000000000080139c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139c:	55                   	push   %rbp
  80139d:	48 89 e5             	mov    %rsp,%rbp
  8013a0:	48 83 ec 28          	sub    $0x28,%rsp
  8013a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c8:	0f 83 88 00 00 00    	jae    801456 <memmove+0xba>
  8013ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d6:	48 01 d0             	add    %rdx,%rax
  8013d9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013dd:	76 77                	jbe    801456 <memmove+0xba>
		s += n;
  8013df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013eb:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	83 e0 03             	and    $0x3,%eax
  8013f6:	48 85 c0             	test   %rax,%rax
  8013f9:	75 3b                	jne    801436 <memmove+0x9a>
  8013fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ff:	83 e0 03             	and    $0x3,%eax
  801402:	48 85 c0             	test   %rax,%rax
  801405:	75 2f                	jne    801436 <memmove+0x9a>
  801407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140b:	83 e0 03             	and    $0x3,%eax
  80140e:	48 85 c0             	test   %rax,%rax
  801411:	75 23                	jne    801436 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801417:	48 83 e8 04          	sub    $0x4,%rax
  80141b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141f:	48 83 ea 04          	sub    $0x4,%rdx
  801423:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801427:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80142b:	48 89 c7             	mov    %rax,%rdi
  80142e:	48 89 d6             	mov    %rdx,%rsi
  801431:	fd                   	std    
  801432:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801434:	eb 1d                	jmp    801453 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	48 89 d7             	mov    %rdx,%rdi
  80144d:	48 89 c1             	mov    %rax,%rcx
  801450:	fd                   	std    
  801451:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801453:	fc                   	cld    
  801454:	eb 57                	jmp    8014ad <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	83 e0 03             	and    $0x3,%eax
  80145d:	48 85 c0             	test   %rax,%rax
  801460:	75 36                	jne    801498 <memmove+0xfc>
  801462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801466:	83 e0 03             	and    $0x3,%eax
  801469:	48 85 c0             	test   %rax,%rax
  80146c:	75 2a                	jne    801498 <memmove+0xfc>
  80146e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801472:	83 e0 03             	and    $0x3,%eax
  801475:	48 85 c0             	test   %rax,%rax
  801478:	75 1e                	jne    801498 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	48 c1 e8 02          	shr    $0x2,%rax
  801482:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801489:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148d:	48 89 c7             	mov    %rax,%rdi
  801490:	48 89 d6             	mov    %rdx,%rsi
  801493:	fc                   	cld    
  801494:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801496:	eb 15                	jmp    8014ad <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a4:	48 89 c7             	mov    %rax,%rdi
  8014a7:	48 89 d6             	mov    %rdx,%rsi
  8014aa:	fc                   	cld    
  8014ab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b1:	c9                   	leaveq 
  8014b2:	c3                   	retq   

00000000008014b3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b3:	55                   	push   %rbp
  8014b4:	48 89 e5             	mov    %rsp,%rbp
  8014b7:	48 83 ec 18          	sub    $0x18,%rsp
  8014bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014cb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d3:	48 89 ce             	mov    %rcx,%rsi
  8014d6:	48 89 c7             	mov    %rax,%rdi
  8014d9:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  8014e0:	00 00 00 
  8014e3:	ff d0                	callq  *%rax
}
  8014e5:	c9                   	leaveq 
  8014e6:	c3                   	retq   

00000000008014e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014e7:	55                   	push   %rbp
  8014e8:	48 89 e5             	mov    %rsp,%rbp
  8014eb:	48 83 ec 28          	sub    $0x28,%rsp
  8014ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801507:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80150b:	eb 36                	jmp    801543 <memcmp+0x5c>
		if (*s1 != *s2)
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	0f b6 10             	movzbl (%rax),%edx
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	38 c2                	cmp    %al,%dl
  80151d:	74 1a                	je     801539 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80151f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f b6 c0             	movzbl %al,%eax
  801533:	29 c2                	sub    %eax,%edx
  801535:	89 d0                	mov    %edx,%eax
  801537:	eb 20                	jmp    801559 <memcmp+0x72>
		s1++, s2++;
  801539:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801543:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801547:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80154b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154f:	48 85 c0             	test   %rax,%rax
  801552:	75 b9                	jne    80150d <memcmp+0x26>
	}

	return 0;
  801554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 83 ec 28          	sub    $0x28,%rsp
  801563:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801567:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80156a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80156e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801576:	48 01 d0             	add    %rdx,%rax
  801579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80157d:	eb 15                	jmp    801594 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801583:	0f b6 00             	movzbl (%rax),%eax
  801586:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801589:	38 d0                	cmp    %dl,%al
  80158b:	75 02                	jne    80158f <memfind+0x34>
			break;
  80158d:	eb 0f                	jmp    80159e <memfind+0x43>
	for (; s < ends; s++)
  80158f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801598:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80159c:	72 e1                	jb     80157f <memfind+0x24>
	return (void *) s;
  80159e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a2:	c9                   	leaveq 
  8015a3:	c3                   	retq   

00000000008015a4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a4:	55                   	push   %rbp
  8015a5:	48 89 e5             	mov    %rsp,%rbp
  8015a8:	48 83 ec 38          	sub    $0x38,%rsp
  8015ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015b4:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015be:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015c5:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c6:	eb 05                	jmp    8015cd <strtol+0x29>
		s++;
  8015c8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 20                	cmp    $0x20,%al
  8015d6:	74 f0                	je     8015c8 <strtol+0x24>
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 09                	cmp    $0x9,%al
  8015e1:	74 e5                	je     8015c8 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8015e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	3c 2b                	cmp    $0x2b,%al
  8015ec:	75 07                	jne    8015f5 <strtol+0x51>
		s++;
  8015ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f3:	eb 17                	jmp    80160c <strtol+0x68>
	else if (*s == '-')
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3c 2d                	cmp    $0x2d,%al
  8015fe:	75 0c                	jne    80160c <strtol+0x68>
		s++, neg = 1;
  801600:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801605:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801610:	74 06                	je     801618 <strtol+0x74>
  801612:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801616:	75 28                	jne    801640 <strtol+0x9c>
  801618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161c:	0f b6 00             	movzbl (%rax),%eax
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 1d                	jne    801640 <strtol+0x9c>
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	48 83 c0 01          	add    $0x1,%rax
  80162b:	0f b6 00             	movzbl (%rax),%eax
  80162e:	3c 78                	cmp    $0x78,%al
  801630:	75 0e                	jne    801640 <strtol+0x9c>
		s += 2, base = 16;
  801632:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801637:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80163e:	eb 2c                	jmp    80166c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801640:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801644:	75 19                	jne    80165f <strtol+0xbb>
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	3c 30                	cmp    $0x30,%al
  80164f:	75 0e                	jne    80165f <strtol+0xbb>
		s++, base = 8;
  801651:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801656:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80165d:	eb 0d                	jmp    80166c <strtol+0xc8>
	else if (base == 0)
  80165f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801663:	75 07                	jne    80166c <strtol+0xc8>
		base = 10;
  801665:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 2f                	cmp    $0x2f,%al
  801675:	7e 1d                	jle    801694 <strtol+0xf0>
  801677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	3c 39                	cmp    $0x39,%al
  801680:	7f 12                	jg     801694 <strtol+0xf0>
			dig = *s - '0';
  801682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801686:	0f b6 00             	movzbl (%rax),%eax
  801689:	0f be c0             	movsbl %al,%eax
  80168c:	83 e8 30             	sub    $0x30,%eax
  80168f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801692:	eb 4e                	jmp    8016e2 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 60                	cmp    $0x60,%al
  80169d:	7e 1d                	jle    8016bc <strtol+0x118>
  80169f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a3:	0f b6 00             	movzbl (%rax),%eax
  8016a6:	3c 7a                	cmp    $0x7a,%al
  8016a8:	7f 12                	jg     8016bc <strtol+0x118>
			dig = *s - 'a' + 10;
  8016aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	0f be c0             	movsbl %al,%eax
  8016b4:	83 e8 57             	sub    $0x57,%eax
  8016b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ba:	eb 26                	jmp    8016e2 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	3c 40                	cmp    $0x40,%al
  8016c5:	7e 48                	jle    80170f <strtol+0x16b>
  8016c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	3c 5a                	cmp    $0x5a,%al
  8016d0:	7f 3d                	jg     80170f <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	0f b6 00             	movzbl (%rax),%eax
  8016d9:	0f be c0             	movsbl %al,%eax
  8016dc:	83 e8 37             	sub    $0x37,%eax
  8016df:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e5:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016e8:	7c 02                	jl     8016ec <strtol+0x148>
			break;
  8016ea:	eb 23                	jmp    80170f <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016f4:	48 98                	cltq   
  8016f6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016fb:	48 89 c2             	mov    %rax,%rdx
  8016fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801701:	48 98                	cltq   
  801703:	48 01 d0             	add    %rdx,%rax
  801706:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80170a:	e9 5d ff ff ff       	jmpq   80166c <strtol+0xc8>

	if (endptr)
  80170f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801714:	74 0b                	je     801721 <strtol+0x17d>
		*endptr = (char *) s;
  801716:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80171e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801721:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801725:	74 09                	je     801730 <strtol+0x18c>
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	48 f7 d8             	neg    %rax
  80172e:	eb 04                	jmp    801734 <strtol+0x190>
  801730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801734:	c9                   	leaveq 
  801735:	c3                   	retq   

0000000000801736 <strstr>:

char * strstr(const char *in, const char *str)
{
  801736:	55                   	push   %rbp
  801737:	48 89 e5             	mov    %rsp,%rbp
  80173a:	48 83 ec 30          	sub    $0x30,%rsp
  80173e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801742:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801746:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801758:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80175c:	75 06                	jne    801764 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80175e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801762:	eb 6b                	jmp    8017cf <strstr+0x99>

	len = strlen(str);
  801764:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801768:	48 89 c7             	mov    %rax,%rdi
  80176b:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  801772:	00 00 00 
  801775:	ff d0                	callq  *%rax
  801777:	48 98                	cltq   
  801779:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80177d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801781:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801785:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80178f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801793:	75 07                	jne    80179c <strstr+0x66>
				return (char *) 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb 33                	jmp    8017cf <strstr+0x99>
		} while (sc != c);
  80179c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017a0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017a3:	75 d8                	jne    80177d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	48 89 ce             	mov    %rcx,%rsi
  8017b4:	48 89 c7             	mov    %rax,%rdi
  8017b7:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  8017be:	00 00 00 
  8017c1:	ff d0                	callq  *%rax
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	75 b6                	jne    80177d <strstr+0x47>

	return (char *) (in - 1);
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	48 83 e8 01          	sub    $0x1,%rax
}
  8017cf:	c9                   	leaveq 
  8017d0:	c3                   	retq   

00000000008017d1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017d1:	55                   	push   %rbp
  8017d2:	48 89 e5             	mov    %rsp,%rbp
  8017d5:	53                   	push   %rbx
  8017d6:	48 83 ec 48          	sub    $0x48,%rsp
  8017da:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017dd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017e0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017e4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017e8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017ec:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017f7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017fb:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017ff:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801803:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801807:	4c 89 c3             	mov    %r8,%rbx
  80180a:	cd 30                	int    $0x30
  80180c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801810:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801814:	74 3e                	je     801854 <syscall+0x83>
  801816:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80181b:	7e 37                	jle    801854 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80181d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801821:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801824:	49 89 d0             	mov    %rdx,%r8
  801827:	89 c1                	mov    %eax,%ecx
  801829:	48 ba 88 4a 80 00 00 	movabs $0x804a88,%rdx
  801830:	00 00 00 
  801833:	be 23 00 00 00       	mov    $0x23,%esi
  801838:	48 bf a5 4a 80 00 00 	movabs $0x804aa5,%rdi
  80183f:	00 00 00 
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	49 b9 b5 3b 80 00 00 	movabs $0x803bb5,%r9
  80184e:	00 00 00 
  801851:	41 ff d1             	callq  *%r9

	return ret;
  801854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801858:	48 83 c4 48          	add    $0x48,%rsp
  80185c:	5b                   	pop    %rbx
  80185d:	5d                   	pop    %rbp
  80185e:	c3                   	retq   

000000000080185f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80185f:	55                   	push   %rbp
  801860:	48 89 e5             	mov    %rsp,%rbp
  801863:	48 83 ec 10          	sub    $0x10,%rsp
  801867:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80186b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80186f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801873:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801877:	48 83 ec 08          	sub    $0x8,%rsp
  80187b:	6a 00                	pushq  $0x0
  80187d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801883:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801889:	48 89 d1             	mov    %rdx,%rcx
  80188c:	48 89 c2             	mov    %rax,%rdx
  80188f:	be 00 00 00 00       	mov    $0x0,%esi
  801894:	bf 00 00 00 00       	mov    $0x0,%edi
  801899:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  8018a0:	00 00 00 
  8018a3:	ff d0                	callq  *%rax
  8018a5:	48 83 c4 10          	add    $0x10,%rsp
}
  8018a9:	c9                   	leaveq 
  8018aa:	c3                   	retq   

00000000008018ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ab:	55                   	push   %rbp
  8018ac:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018af:	48 83 ec 08          	sub    $0x8,%rsp
  8018b3:	6a 00                	pushq  $0x0
  8018b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cb:	be 00 00 00 00       	mov    $0x0,%esi
  8018d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8018d5:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	callq  *%rax
  8018e1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018e5:	c9                   	leaveq 
  8018e6:	c3                   	retq   

00000000008018e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 10          	sub    $0x10,%rsp
  8018ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f5:	48 98                	cltq   
  8018f7:	48 83 ec 08          	sub    $0x8,%rsp
  8018fb:	6a 00                	pushq  $0x0
  8018fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801903:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801909:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190e:	48 89 c2             	mov    %rax,%rdx
  801911:	be 01 00 00 00       	mov    $0x1,%esi
  801916:	bf 03 00 00 00       	mov    $0x3,%edi
  80191b:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801922:	00 00 00 
  801925:	ff d0                	callq  *%rax
  801927:	48 83 c4 10          	add    $0x10,%rsp
}
  80192b:	c9                   	leaveq 
  80192c:	c3                   	retq   

000000000080192d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80192d:	55                   	push   %rbp
  80192e:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801931:	48 83 ec 08          	sub    $0x8,%rsp
  801935:	6a 00                	pushq  $0x0
  801937:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801943:	b9 00 00 00 00       	mov    $0x0,%ecx
  801948:	ba 00 00 00 00       	mov    $0x0,%edx
  80194d:	be 00 00 00 00       	mov    $0x0,%esi
  801952:	bf 02 00 00 00       	mov    $0x2,%edi
  801957:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  80195e:	00 00 00 
  801961:	ff d0                	callq  *%rax
  801963:	48 83 c4 10          	add    $0x10,%rsp
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <sys_yield>:

void
sys_yield(void)
{
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80196d:	48 83 ec 08          	sub    $0x8,%rsp
  801971:	6a 00                	pushq  $0x0
  801973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801979:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801984:	ba 00 00 00 00       	mov    $0x0,%edx
  801989:	be 00 00 00 00       	mov    $0x0,%esi
  80198e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801993:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  80199a:	00 00 00 
  80199d:	ff d0                	callq  *%rax
  80199f:	48 83 c4 10          	add    $0x10,%rsp
}
  8019a3:	c9                   	leaveq 
  8019a4:	c3                   	retq   

00000000008019a5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019a5:	55                   	push   %rbp
  8019a6:	48 89 e5             	mov    %rsp,%rbp
  8019a9:	48 83 ec 10          	sub    $0x10,%rsp
  8019ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ba:	48 63 c8             	movslq %eax,%rcx
  8019bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c4:	48 98                	cltq   
  8019c6:	48 83 ec 08          	sub    $0x8,%rsp
  8019ca:	6a 00                	pushq  $0x0
  8019cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d2:	49 89 c8             	mov    %rcx,%r8
  8019d5:	48 89 d1             	mov    %rdx,%rcx
  8019d8:	48 89 c2             	mov    %rax,%rdx
  8019db:	be 01 00 00 00       	mov    $0x1,%esi
  8019e0:	bf 04 00 00 00       	mov    $0x4,%edi
  8019e5:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	callq  *%rax
  8019f1:	48 83 c4 10          	add    $0x10,%rsp
}
  8019f5:	c9                   	leaveq 
  8019f6:	c3                   	retq   

00000000008019f7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	48 83 ec 20          	sub    $0x20,%rsp
  8019ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a06:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a09:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a0d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a11:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a14:	48 63 c8             	movslq %eax,%rcx
  801a17:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a1e:	48 63 f0             	movslq %eax,%rsi
  801a21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a28:	48 98                	cltq   
  801a2a:	48 83 ec 08          	sub    $0x8,%rsp
  801a2e:	51                   	push   %rcx
  801a2f:	49 89 f9             	mov    %rdi,%r9
  801a32:	49 89 f0             	mov    %rsi,%r8
  801a35:	48 89 d1             	mov    %rdx,%rcx
  801a38:	48 89 c2             	mov    %rax,%rdx
  801a3b:	be 01 00 00 00       	mov    $0x1,%esi
  801a40:	bf 05 00 00 00       	mov    $0x5,%edi
  801a45:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	callq  *%rax
  801a51:	48 83 c4 10          	add    $0x10,%rsp
}
  801a55:	c9                   	leaveq 
  801a56:	c3                   	retq   

0000000000801a57 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a57:	55                   	push   %rbp
  801a58:	48 89 e5             	mov    %rsp,%rbp
  801a5b:	48 83 ec 10          	sub    $0x10,%rsp
  801a5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6d:	48 98                	cltq   
  801a6f:	48 83 ec 08          	sub    $0x8,%rsp
  801a73:	6a 00                	pushq  $0x0
  801a75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a81:	48 89 d1             	mov    %rdx,%rcx
  801a84:	48 89 c2             	mov    %rax,%rdx
  801a87:	be 01 00 00 00       	mov    $0x1,%esi
  801a8c:	bf 06 00 00 00       	mov    $0x6,%edi
  801a91:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801a98:	00 00 00 
  801a9b:	ff d0                	callq  *%rax
  801a9d:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa1:	c9                   	leaveq 
  801aa2:	c3                   	retq   

0000000000801aa3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 10          	sub    $0x10,%rsp
  801aab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aae:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ab1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab4:	48 63 d0             	movslq %eax,%rdx
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	48 98                	cltq   
  801abc:	48 83 ec 08          	sub    $0x8,%rsp
  801ac0:	6a 00                	pushq  $0x0
  801ac2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ace:	48 89 d1             	mov    %rdx,%rcx
  801ad1:	48 89 c2             	mov    %rax,%rdx
  801ad4:	be 01 00 00 00       	mov    $0x1,%esi
  801ad9:	bf 08 00 00 00       	mov    $0x8,%edi
  801ade:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	callq  *%rax
  801aea:	48 83 c4 10          	add    $0x10,%rsp
}
  801aee:	c9                   	leaveq 
  801aef:	c3                   	retq   

0000000000801af0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	48 83 ec 10          	sub    $0x10,%rsp
  801af8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801afb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b06:	48 98                	cltq   
  801b08:	48 83 ec 08          	sub    $0x8,%rsp
  801b0c:	6a 00                	pushq  $0x0
  801b0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1a:	48 89 d1             	mov    %rdx,%rcx
  801b1d:	48 89 c2             	mov    %rax,%rdx
  801b20:	be 01 00 00 00       	mov    $0x1,%esi
  801b25:	bf 09 00 00 00       	mov    $0x9,%edi
  801b2a:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
  801b36:	48 83 c4 10          	add    $0x10,%rsp
}
  801b3a:	c9                   	leaveq 
  801b3b:	c3                   	retq   

0000000000801b3c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b3c:	55                   	push   %rbp
  801b3d:	48 89 e5             	mov    %rsp,%rbp
  801b40:	48 83 ec 10          	sub    $0x10,%rsp
  801b44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b52:	48 98                	cltq   
  801b54:	48 83 ec 08          	sub    $0x8,%rsp
  801b58:	6a 00                	pushq  $0x0
  801b5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b66:	48 89 d1             	mov    %rdx,%rcx
  801b69:	48 89 c2             	mov    %rax,%rdx
  801b6c:	be 01 00 00 00       	mov    $0x1,%esi
  801b71:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b76:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801b7d:	00 00 00 
  801b80:	ff d0                	callq  *%rax
  801b82:	48 83 c4 10          	add    $0x10,%rsp
}
  801b86:	c9                   	leaveq 
  801b87:	c3                   	retq   

0000000000801b88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b88:	55                   	push   %rbp
  801b89:	48 89 e5             	mov    %rsp,%rbp
  801b8c:	48 83 ec 20          	sub    $0x20,%rsp
  801b90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b9b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba1:	48 63 f0             	movslq %eax,%rsi
  801ba4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bab:	48 98                	cltq   
  801bad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb1:	48 83 ec 08          	sub    $0x8,%rsp
  801bb5:	6a 00                	pushq  $0x0
  801bb7:	49 89 f1             	mov    %rsi,%r9
  801bba:	49 89 c8             	mov    %rcx,%r8
  801bbd:	48 89 d1             	mov    %rdx,%rcx
  801bc0:	48 89 c2             	mov    %rax,%rdx
  801bc3:	be 00 00 00 00       	mov    $0x0,%esi
  801bc8:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bcd:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
  801bd9:	48 83 c4 10          	add    $0x10,%rsp
}
  801bdd:	c9                   	leaveq 
  801bde:	c3                   	retq   

0000000000801bdf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	48 83 ec 10          	sub    $0x10,%rsp
  801be7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bef:	48 83 ec 08          	sub    $0x8,%rsp
  801bf3:	6a 00                	pushq  $0x0
  801bf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c06:	48 89 c2             	mov    %rax,%rdx
  801c09:	be 01 00 00 00       	mov    $0x1,%esi
  801c0e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c13:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	callq  *%rax
  801c1f:	48 83 c4 10          	add    $0x10,%rsp
}
  801c23:	c9                   	leaveq 
  801c24:	c3                   	retq   

0000000000801c25 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c25:	55                   	push   %rbp
  801c26:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c29:	48 83 ec 08          	sub    $0x8,%rsp
  801c2d:	6a 00                	pushq  $0x0
  801c2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c40:	ba 00 00 00 00       	mov    $0x0,%edx
  801c45:	be 00 00 00 00       	mov    $0x0,%esi
  801c4a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c4f:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801c56:	00 00 00 
  801c59:	ff d0                	callq  *%rax
  801c5b:	48 83 c4 10          	add    $0x10,%rsp
}
  801c5f:	c9                   	leaveq 
  801c60:	c3                   	retq   

0000000000801c61 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
  801c65:	48 83 ec 20          	sub    $0x20,%rsp
  801c69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c70:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c73:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c77:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c7b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c7e:	48 63 c8             	movslq %eax,%rcx
  801c81:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c88:	48 63 f0             	movslq %eax,%rsi
  801c8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	48 98                	cltq   
  801c94:	48 83 ec 08          	sub    $0x8,%rsp
  801c98:	51                   	push   %rcx
  801c99:	49 89 f9             	mov    %rdi,%r9
  801c9c:	49 89 f0             	mov    %rsi,%r8
  801c9f:	48 89 d1             	mov    %rdx,%rcx
  801ca2:	48 89 c2             	mov    %rax,%rdx
  801ca5:	be 00 00 00 00       	mov    $0x0,%esi
  801caa:	bf 0f 00 00 00       	mov    $0xf,%edi
  801caf:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801cb6:	00 00 00 
  801cb9:	ff d0                	callq  *%rax
  801cbb:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801cbf:	c9                   	leaveq 
  801cc0:	c3                   	retq   

0000000000801cc1 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801cc1:	55                   	push   %rbp
  801cc2:	48 89 e5             	mov    %rsp,%rbp
  801cc5:	48 83 ec 10          	sub    $0x10,%rsp
  801cc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ccd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801cd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd9:	48 83 ec 08          	sub    $0x8,%rsp
  801cdd:	6a 00                	pushq  $0x0
  801cdf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ceb:	48 89 d1             	mov    %rdx,%rcx
  801cee:	48 89 c2             	mov    %rax,%rdx
  801cf1:	be 00 00 00 00       	mov    $0x0,%esi
  801cf6:	bf 10 00 00 00       	mov    $0x10,%edi
  801cfb:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	callq  *%rax
  801d07:	48 83 c4 10          	add    $0x10,%rsp
}
  801d0b:	c9                   	leaveq 
  801d0c:	c3                   	retq   

0000000000801d0d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	48 83 ec 08          	sub    $0x8,%rsp
  801d15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d1d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d24:	ff ff ff 
  801d27:	48 01 d0             	add    %rdx,%rax
  801d2a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d2e:	c9                   	leaveq 
  801d2f:	c3                   	retq   

0000000000801d30 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d30:	55                   	push   %rbp
  801d31:	48 89 e5             	mov    %rsp,%rbp
  801d34:	48 83 ec 08          	sub    $0x8,%rsp
  801d38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d40:	48 89 c7             	mov    %rax,%rdi
  801d43:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  801d4a:	00 00 00 
  801d4d:	ff d0                	callq  *%rax
  801d4f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d55:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d59:	c9                   	leaveq 
  801d5a:	c3                   	retq   

0000000000801d5b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d5b:	55                   	push   %rbp
  801d5c:	48 89 e5             	mov    %rsp,%rbp
  801d5f:	48 83 ec 18          	sub    $0x18,%rsp
  801d63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d6e:	eb 6b                	jmp    801ddb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d73:	48 98                	cltq   
  801d75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d7b:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d87:	48 c1 e8 15          	shr    $0x15,%rax
  801d8b:	48 89 c2             	mov    %rax,%rdx
  801d8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d95:	01 00 00 
  801d98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9c:	83 e0 01             	and    $0x1,%eax
  801d9f:	48 85 c0             	test   %rax,%rax
  801da2:	74 21                	je     801dc5 <fd_alloc+0x6a>
  801da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da8:	48 c1 e8 0c          	shr    $0xc,%rax
  801dac:	48 89 c2             	mov    %rax,%rdx
  801daf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db6:	01 00 00 
  801db9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dbd:	83 e0 01             	and    $0x1,%eax
  801dc0:	48 85 c0             	test   %rax,%rax
  801dc3:	75 12                	jne    801dd7 <fd_alloc+0x7c>
			*fd_store = fd;
  801dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dcd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd5:	eb 1a                	jmp    801df1 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801dd7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ddb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ddf:	7e 8f                	jle    801d70 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dec:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
  801df7:	48 83 ec 20          	sub    $0x20,%rsp
  801dfb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dfe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e06:	78 06                	js     801e0e <fd_lookup+0x1b>
  801e08:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e0c:	7e 07                	jle    801e15 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e13:	eb 6c                	jmp    801e81 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e18:	48 98                	cltq   
  801e1a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e20:	48 c1 e0 0c          	shl    $0xc,%rax
  801e24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2c:	48 c1 e8 15          	shr    $0x15,%rax
  801e30:	48 89 c2             	mov    %rax,%rdx
  801e33:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e3a:	01 00 00 
  801e3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e41:	83 e0 01             	and    $0x1,%eax
  801e44:	48 85 c0             	test   %rax,%rax
  801e47:	74 21                	je     801e6a <fd_lookup+0x77>
  801e49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4d:	48 c1 e8 0c          	shr    $0xc,%rax
  801e51:	48 89 c2             	mov    %rax,%rdx
  801e54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e5b:	01 00 00 
  801e5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e62:	83 e0 01             	and    $0x1,%eax
  801e65:	48 85 c0             	test   %rax,%rax
  801e68:	75 07                	jne    801e71 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6f:	eb 10                	jmp    801e81 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e79:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	c9                   	leaveq 
  801e82:	c3                   	retq   

0000000000801e83 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e83:	55                   	push   %rbp
  801e84:	48 89 e5             	mov    %rsp,%rbp
  801e87:	48 83 ec 30          	sub    $0x30,%rsp
  801e8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e8f:	89 f0                	mov    %esi,%eax
  801e91:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e98:	48 89 c7             	mov    %rax,%rdi
  801e9b:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
  801ea7:	89 c2                	mov    %eax,%edx
  801ea9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ead:	48 89 c6             	mov    %rax,%rsi
  801eb0:	89 d7                	mov    %edx,%edi
  801eb2:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  801eb9:	00 00 00 
  801ebc:	ff d0                	callq  *%rax
  801ebe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec5:	78 0a                	js     801ed1 <fd_close+0x4e>
	    || fd != fd2)
  801ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ecb:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ecf:	74 12                	je     801ee3 <fd_close+0x60>
		return (must_exist ? r : 0);
  801ed1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ed5:	74 05                	je     801edc <fd_close+0x59>
  801ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eda:	eb 70                	jmp    801f4c <fd_close+0xc9>
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	eb 69                	jmp    801f4c <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ee3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee7:	8b 00                	mov    (%rax),%eax
  801ee9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801eed:	48 89 d6             	mov    %rdx,%rsi
  801ef0:	89 c7                	mov    %eax,%edi
  801ef2:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
  801efe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f05:	78 2a                	js     801f31 <fd_close+0xae>
		if (dev->dev_close)
  801f07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f0f:	48 85 c0             	test   %rax,%rax
  801f12:	74 16                	je     801f2a <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f18:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f1c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f20:	48 89 d7             	mov    %rdx,%rdi
  801f23:	ff d0                	callq  *%rax
  801f25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f28:	eb 07                	jmp    801f31 <fd_close+0xae>
		else
			r = 0;
  801f2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f35:	48 89 c6             	mov    %rax,%rsi
  801f38:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3d:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
	return r;
  801f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f4c:	c9                   	leaveq 
  801f4d:	c3                   	retq   

0000000000801f4e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f4e:	55                   	push   %rbp
  801f4f:	48 89 e5             	mov    %rsp,%rbp
  801f52:	48 83 ec 20          	sub    $0x20,%rsp
  801f56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f64:	eb 41                	jmp    801fa7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f66:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f6d:	00 00 00 
  801f70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f73:	48 63 d2             	movslq %edx,%rdx
  801f76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7a:	8b 00                	mov    (%rax),%eax
  801f7c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f7f:	75 22                	jne    801fa3 <dev_lookup+0x55>
			*dev = devtab[i];
  801f81:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f88:	00 00 00 
  801f8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f8e:	48 63 d2             	movslq %edx,%rdx
  801f91:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f99:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	eb 60                	jmp    802003 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801fa3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fa7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fae:	00 00 00 
  801fb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb4:	48 63 d2             	movslq %edx,%rdx
  801fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbb:	48 85 c0             	test   %rax,%rax
  801fbe:	75 a6                	jne    801f66 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fc0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fc7:	00 00 00 
  801fca:	48 8b 00             	mov    (%rax),%rax
  801fcd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fd3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fd6:	89 c6                	mov    %eax,%esi
  801fd8:	48 bf b8 4a 80 00 00 	movabs $0x804ab8,%rdi
  801fdf:	00 00 00 
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	48 b9 de 04 80 00 00 	movabs $0x8004de,%rcx
  801fee:	00 00 00 
  801ff1:	ff d1                	callq  *%rcx
	*dev = 0;
  801ff3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802003:	c9                   	leaveq 
  802004:	c3                   	retq   

0000000000802005 <close>:

int
close(int fdnum)
{
  802005:	55                   	push   %rbp
  802006:	48 89 e5             	mov    %rsp,%rbp
  802009:	48 83 ec 20          	sub    $0x20,%rsp
  80200d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802010:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802014:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802017:	48 89 d6             	mov    %rdx,%rsi
  80201a:	89 c7                	mov    %eax,%edi
  80201c:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  802023:	00 00 00 
  802026:	ff d0                	callq  *%rax
  802028:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202f:	79 05                	jns    802036 <close+0x31>
		return r;
  802031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802034:	eb 18                	jmp    80204e <close+0x49>
	else
		return fd_close(fd, 1);
  802036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203a:	be 01 00 00 00       	mov    $0x1,%esi
  80203f:	48 89 c7             	mov    %rax,%rdi
  802042:	48 b8 83 1e 80 00 00 	movabs $0x801e83,%rax
  802049:	00 00 00 
  80204c:	ff d0                	callq  *%rax
}
  80204e:	c9                   	leaveq 
  80204f:	c3                   	retq   

0000000000802050 <close_all>:

void
close_all(void)
{
  802050:	55                   	push   %rbp
  802051:	48 89 e5             	mov    %rsp,%rbp
  802054:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802058:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80205f:	eb 15                	jmp    802076 <close_all+0x26>
		close(i);
  802061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802064:	89 c7                	mov    %eax,%edi
  802066:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  80206d:	00 00 00 
  802070:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802072:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802076:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80207a:	7e e5                	jle    802061 <close_all+0x11>
}
  80207c:	c9                   	leaveq 
  80207d:	c3                   	retq   

000000000080207e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80207e:	55                   	push   %rbp
  80207f:	48 89 e5             	mov    %rsp,%rbp
  802082:	48 83 ec 40          	sub    $0x40,%rsp
  802086:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802089:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80208c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802090:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802093:	48 89 d6             	mov    %rdx,%rsi
  802096:	89 c7                	mov    %eax,%edi
  802098:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80209f:	00 00 00 
  8020a2:	ff d0                	callq  *%rax
  8020a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ab:	79 08                	jns    8020b5 <dup+0x37>
		return r;
  8020ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b0:	e9 70 01 00 00       	jmpq   802225 <dup+0x1a7>
	close(newfdnum);
  8020b5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b8:	89 c7                	mov    %eax,%edi
  8020ba:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020c9:	48 98                	cltq   
  8020cb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020dd:	48 89 c7             	mov    %rax,%rdi
  8020e0:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
  8020ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f4:	48 89 c7             	mov    %rax,%rdi
  8020f7:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
  802103:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210b:	48 c1 e8 15          	shr    $0x15,%rax
  80210f:	48 89 c2             	mov    %rax,%rdx
  802112:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802119:	01 00 00 
  80211c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802120:	83 e0 01             	and    $0x1,%eax
  802123:	48 85 c0             	test   %rax,%rax
  802126:	74 73                	je     80219b <dup+0x11d>
  802128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212c:	48 c1 e8 0c          	shr    $0xc,%rax
  802130:	48 89 c2             	mov    %rax,%rdx
  802133:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213a:	01 00 00 
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	48 85 c0             	test   %rax,%rax
  802147:	74 52                	je     80219b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214d:	48 c1 e8 0c          	shr    $0xc,%rax
  802151:	48 89 c2             	mov    %rax,%rdx
  802154:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80215b:	01 00 00 
  80215e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802162:	25 07 0e 00 00       	and    $0xe07,%eax
  802167:	89 c1                	mov    %eax,%ecx
  802169:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80216d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802171:	41 89 c8             	mov    %ecx,%r8d
  802174:	48 89 d1             	mov    %rdx,%rcx
  802177:	ba 00 00 00 00       	mov    $0x0,%edx
  80217c:	48 89 c6             	mov    %rax,%rsi
  80217f:	bf 00 00 00 00       	mov    $0x0,%edi
  802184:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	callq  *%rax
  802190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802197:	79 02                	jns    80219b <dup+0x11d>
			goto err;
  802199:	eb 57                	jmp    8021f2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80219b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219f:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a3:	48 89 c2             	mov    %rax,%rdx
  8021a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ad:	01 00 00 
  8021b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8021b9:	89 c1                	mov    %eax,%ecx
  8021bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c3:	41 89 c8             	mov    %ecx,%r8d
  8021c6:	48 89 d1             	mov    %rdx,%rcx
  8021c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ce:	48 89 c6             	mov    %rax,%rsi
  8021d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d6:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e9:	79 02                	jns    8021ed <dup+0x16f>
		goto err;
  8021eb:	eb 05                	jmp    8021f2 <dup+0x174>

	return newfdnum;
  8021ed:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021f0:	eb 33                	jmp    802225 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f6:	48 89 c6             	mov    %rax,%rsi
  8021f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fe:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  802205:	00 00 00 
  802208:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80220a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220e:	48 89 c6             	mov    %rax,%rsi
  802211:	bf 00 00 00 00       	mov    $0x0,%edi
  802216:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
	return r;
  802222:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802225:	c9                   	leaveq 
  802226:	c3                   	retq   

0000000000802227 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802227:	55                   	push   %rbp
  802228:	48 89 e5             	mov    %rsp,%rbp
  80222b:	48 83 ec 40          	sub    $0x40,%rsp
  80222f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802232:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802236:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80223a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80223e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802241:	48 89 d6             	mov    %rdx,%rsi
  802244:	89 c7                	mov    %eax,%edi
  802246:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax
  802252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802259:	78 24                	js     80227f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80225b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225f:	8b 00                	mov    (%rax),%eax
  802261:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802265:	48 89 d6             	mov    %rdx,%rsi
  802268:	89 c7                	mov    %eax,%edi
  80226a:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  802271:	00 00 00 
  802274:	ff d0                	callq  *%rax
  802276:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802279:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227d:	79 05                	jns    802284 <read+0x5d>
		return r;
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802282:	eb 76                	jmp    8022fa <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802288:	8b 40 08             	mov    0x8(%rax),%eax
  80228b:	83 e0 03             	and    $0x3,%eax
  80228e:	83 f8 01             	cmp    $0x1,%eax
  802291:	75 3a                	jne    8022cd <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802293:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80229a:	00 00 00 
  80229d:	48 8b 00             	mov    (%rax),%rax
  8022a0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a9:	89 c6                	mov    %eax,%esi
  8022ab:	48 bf d7 4a 80 00 00 	movabs $0x804ad7,%rdi
  8022b2:	00 00 00 
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	48 b9 de 04 80 00 00 	movabs $0x8004de,%rcx
  8022c1:	00 00 00 
  8022c4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022cb:	eb 2d                	jmp    8022fa <read+0xd3>
	}
	if (!dev->dev_read)
  8022cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d5:	48 85 c0             	test   %rax,%rax
  8022d8:	75 07                	jne    8022e1 <read+0xba>
		return -E_NOT_SUPP;
  8022da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022df:	eb 19                	jmp    8022fa <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022f1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022f5:	48 89 cf             	mov    %rcx,%rdi
  8022f8:	ff d0                	callq  *%rax
}
  8022fa:	c9                   	leaveq 
  8022fb:	c3                   	retq   

00000000008022fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022fc:	55                   	push   %rbp
  8022fd:	48 89 e5             	mov    %rsp,%rbp
  802300:	48 83 ec 30          	sub    $0x30,%rsp
  802304:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802307:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80230b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80230f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802316:	eb 49                	jmp    802361 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802318:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231b:	48 98                	cltq   
  80231d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802321:	48 29 c2             	sub    %rax,%rdx
  802324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802327:	48 63 c8             	movslq %eax,%rcx
  80232a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80232e:	48 01 c1             	add    %rax,%rcx
  802331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802334:	48 89 ce             	mov    %rcx,%rsi
  802337:	89 c7                	mov    %eax,%edi
  802339:	48 b8 27 22 80 00 00 	movabs $0x802227,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
  802345:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802348:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80234c:	79 05                	jns    802353 <readn+0x57>
			return m;
  80234e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802351:	eb 1c                	jmp    80236f <readn+0x73>
		if (m == 0)
  802353:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802357:	75 02                	jne    80235b <readn+0x5f>
			break;
  802359:	eb 11                	jmp    80236c <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80235b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802364:	48 98                	cltq   
  802366:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80236a:	72 ac                	jb     802318 <readn+0x1c>
	}
	return tot;
  80236c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80236f:	c9                   	leaveq 
  802370:	c3                   	retq   

0000000000802371 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802371:	55                   	push   %rbp
  802372:	48 89 e5             	mov    %rsp,%rbp
  802375:	48 83 ec 40          	sub    $0x40,%rsp
  802379:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80237c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802380:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802384:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802388:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80238b:	48 89 d6             	mov    %rdx,%rsi
  80238e:	89 c7                	mov    %eax,%edi
  802390:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
  80239c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a3:	78 24                	js     8023c9 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a9:	8b 00                	mov    (%rax),%eax
  8023ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023af:	48 89 d6             	mov    %rdx,%rsi
  8023b2:	89 c7                	mov    %eax,%edi
  8023b4:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  8023bb:	00 00 00 
  8023be:	ff d0                	callq  *%rax
  8023c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c7:	79 05                	jns    8023ce <write+0x5d>
		return r;
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cc:	eb 75                	jmp    802443 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d2:	8b 40 08             	mov    0x8(%rax),%eax
  8023d5:	83 e0 03             	and    $0x3,%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	75 3a                	jne    802416 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023dc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8023e3:	00 00 00 
  8023e6:	48 8b 00             	mov    (%rax),%rax
  8023e9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023ef:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f2:	89 c6                	mov    %eax,%esi
  8023f4:	48 bf f3 4a 80 00 00 	movabs $0x804af3,%rdi
  8023fb:	00 00 00 
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	48 b9 de 04 80 00 00 	movabs $0x8004de,%rcx
  80240a:	00 00 00 
  80240d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80240f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802414:	eb 2d                	jmp    802443 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80241e:	48 85 c0             	test   %rax,%rax
  802421:	75 07                	jne    80242a <write+0xb9>
		return -E_NOT_SUPP;
  802423:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802428:	eb 19                	jmp    802443 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80242a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802432:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802436:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80243a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80243e:	48 89 cf             	mov    %rcx,%rdi
  802441:	ff d0                	callq  *%rax
}
  802443:	c9                   	leaveq 
  802444:	c3                   	retq   

0000000000802445 <seek>:

int
seek(int fdnum, off_t offset)
{
  802445:	55                   	push   %rbp
  802446:	48 89 e5             	mov    %rsp,%rbp
  802449:	48 83 ec 18          	sub    $0x18,%rsp
  80244d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802450:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802453:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802457:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80245a:	48 89 d6             	mov    %rdx,%rsi
  80245d:	89 c7                	mov    %eax,%edi
  80245f:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  802466:	00 00 00 
  802469:	ff d0                	callq  *%rax
  80246b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802472:	79 05                	jns    802479 <seek+0x34>
		return r;
  802474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802477:	eb 0f                	jmp    802488 <seek+0x43>
	fd->fd_offset = offset;
  802479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802480:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802488:	c9                   	leaveq 
  802489:	c3                   	retq   

000000000080248a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	48 83 ec 30          	sub    $0x30,%rsp
  802492:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802495:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802498:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80249c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80249f:	48 89 d6             	mov    %rdx,%rsi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b7:	78 24                	js     8024dd <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bd:	8b 00                	mov    (%rax),%eax
  8024bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c3:	48 89 d6             	mov    %rdx,%rsi
  8024c6:	89 c7                	mov    %eax,%edi
  8024c8:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  8024cf:	00 00 00 
  8024d2:	ff d0                	callq  *%rax
  8024d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024db:	79 05                	jns    8024e2 <ftruncate+0x58>
		return r;
  8024dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e0:	eb 72                	jmp    802554 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e6:	8b 40 08             	mov    0x8(%rax),%eax
  8024e9:	83 e0 03             	and    $0x3,%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	75 3a                	jne    80252a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024f0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024f7:	00 00 00 
  8024fa:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024fd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802503:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802506:	89 c6                	mov    %eax,%esi
  802508:	48 bf 10 4b 80 00 00 	movabs $0x804b10,%rdi
  80250f:	00 00 00 
  802512:	b8 00 00 00 00       	mov    $0x0,%eax
  802517:	48 b9 de 04 80 00 00 	movabs $0x8004de,%rcx
  80251e:	00 00 00 
  802521:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802528:	eb 2a                	jmp    802554 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80252a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802532:	48 85 c0             	test   %rax,%rax
  802535:	75 07                	jne    80253e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802537:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80253c:	eb 16                	jmp    802554 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80253e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802542:	48 8b 40 30          	mov    0x30(%rax),%rax
  802546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80254a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80254d:	89 ce                	mov    %ecx,%esi
  80254f:	48 89 d7             	mov    %rdx,%rdi
  802552:	ff d0                	callq  *%rax
}
  802554:	c9                   	leaveq 
  802555:	c3                   	retq   

0000000000802556 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802556:	55                   	push   %rbp
  802557:	48 89 e5             	mov    %rsp,%rbp
  80255a:	48 83 ec 30          	sub    $0x30,%rsp
  80255e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802561:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802565:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802569:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	78 24                	js     8025aa <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258a:	8b 00                	mov    (%rax),%eax
  80258c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802590:	48 89 d6             	mov    %rdx,%rsi
  802593:	89 c7                	mov    %eax,%edi
  802595:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	callq  *%rax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a8:	79 05                	jns    8025af <fstat+0x59>
		return r;
  8025aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ad:	eb 5e                	jmp    80260d <fstat+0xb7>
	if (!dev->dev_stat)
  8025af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025b7:	48 85 c0             	test   %rax,%rax
  8025ba:	75 07                	jne    8025c3 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025bc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c1:	eb 4a                	jmp    80260d <fstat+0xb7>
	stat->st_name[0] = 0;
  8025c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c7:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ce:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025d5:	00 00 00 
	stat->st_isdir = 0;
  8025d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025dc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025e3:	00 00 00 
	stat->st_dev = dev;
  8025e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ee:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802601:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802605:	48 89 ce             	mov    %rcx,%rsi
  802608:	48 89 d7             	mov    %rdx,%rdi
  80260b:	ff d0                	callq  *%rax
}
  80260d:	c9                   	leaveq 
  80260e:	c3                   	retq   

000000000080260f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80260f:	55                   	push   %rbp
  802610:	48 89 e5             	mov    %rsp,%rbp
  802613:	48 83 ec 20          	sub    $0x20,%rsp
  802617:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80261b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80261f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802623:	be 00 00 00 00       	mov    $0x0,%esi
  802628:	48 89 c7             	mov    %rax,%rdi
  80262b:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802632:	00 00 00 
  802635:	ff d0                	callq  *%rax
  802637:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263e:	79 05                	jns    802645 <stat+0x36>
		return fd;
  802640:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802643:	eb 2f                	jmp    802674 <stat+0x65>
	r = fstat(fd, stat);
  802645:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	48 89 d6             	mov    %rdx,%rsi
  80264f:	89 c7                	mov    %eax,%edi
  802651:	48 b8 56 25 80 00 00 	movabs $0x802556,%rax
  802658:	00 00 00 
  80265b:	ff d0                	callq  *%rax
  80265d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	89 c7                	mov    %eax,%edi
  802665:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	callq  *%rax
	return r;
  802671:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802674:	c9                   	leaveq 
  802675:	c3                   	retq   

0000000000802676 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802676:	55                   	push   %rbp
  802677:	48 89 e5             	mov    %rsp,%rbp
  80267a:	48 83 ec 10          	sub    $0x10,%rsp
  80267e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802681:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802685:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80268c:	00 00 00 
  80268f:	8b 00                	mov    (%rax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	75 1f                	jne    8026b4 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802695:	bf 01 00 00 00       	mov    $0x1,%edi
  80269a:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  8026a1:	00 00 00 
  8026a4:	ff d0                	callq  *%rax
  8026a6:	89 c2                	mov    %eax,%edx
  8026a8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026af:	00 00 00 
  8026b2:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026bb:	00 00 00 
  8026be:	8b 00                	mov    (%rax),%eax
  8026c0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026c3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026c8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026cf:	00 00 00 
  8026d2:	89 c7                	mov    %eax,%edi
  8026d4:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e9:	48 89 c6             	mov    %rax,%rsi
  8026ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f1:	48 b8 c9 3c 80 00 00 	movabs $0x803cc9,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax
}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   

00000000008026ff <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 10          	sub    $0x10,%rsp
  802707:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80270b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  80270e:	48 ba 36 4b 80 00 00 	movabs $0x804b36,%rdx
  802715:	00 00 00 
  802718:	be 4c 00 00 00       	mov    $0x4c,%esi
  80271d:	48 bf 4b 4b 80 00 00 	movabs $0x804b4b,%rdi
  802724:	00 00 00 
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
  80272c:	48 b9 b5 3b 80 00 00 	movabs $0x803bb5,%rcx
  802733:	00 00 00 
  802736:	ff d1                	callq  *%rcx

0000000000802738 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802738:	55                   	push   %rbp
  802739:	48 89 e5             	mov    %rsp,%rbp
  80273c:	48 83 ec 10          	sub    $0x10,%rsp
  802740:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802748:	8b 50 0c             	mov    0xc(%rax),%edx
  80274b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802752:	00 00 00 
  802755:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802757:	be 00 00 00 00       	mov    $0x0,%esi
  80275c:	bf 06 00 00 00       	mov    $0x6,%edi
  802761:	48 b8 76 26 80 00 00 	movabs $0x802676,%rax
  802768:	00 00 00 
  80276b:	ff d0                	callq  *%rax
}
  80276d:	c9                   	leaveq 
  80276e:	c3                   	retq   

000000000080276f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80276f:	55                   	push   %rbp
  802770:	48 89 e5             	mov    %rsp,%rbp
  802773:	48 83 ec 20          	sub    $0x20,%rsp
  802777:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80277b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80277f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802783:	48 ba 56 4b 80 00 00 	movabs $0x804b56,%rdx
  80278a:	00 00 00 
  80278d:	be 6b 00 00 00       	mov    $0x6b,%esi
  802792:	48 bf 4b 4b 80 00 00 	movabs $0x804b4b,%rdi
  802799:	00 00 00 
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	48 b9 b5 3b 80 00 00 	movabs $0x803bb5,%rcx
  8027a8:	00 00 00 
  8027ab:	ff d1                	callq  *%rcx

00000000008027ad <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027ad:	55                   	push   %rbp
  8027ae:	48 89 e5             	mov    %rsp,%rbp
  8027b1:	48 83 ec 20          	sub    $0x20,%rsp
  8027b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8027c1:	48 ba 73 4b 80 00 00 	movabs $0x804b73,%rdx
  8027c8:	00 00 00 
  8027cb:	be 7b 00 00 00       	mov    $0x7b,%esi
  8027d0:	48 bf 4b 4b 80 00 00 	movabs $0x804b4b,%rdi
  8027d7:	00 00 00 
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	48 b9 b5 3b 80 00 00 	movabs $0x803bb5,%rcx
  8027e6:	00 00 00 
  8027e9:	ff d1                	callq  *%rcx

00000000008027eb <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027eb:	55                   	push   %rbp
  8027ec:	48 89 e5             	mov    %rsp,%rbp
  8027ef:	48 83 ec 20          	sub    $0x20,%rsp
  8027f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	8b 50 0c             	mov    0xc(%rax),%edx
  802802:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802809:	00 00 00 
  80280c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80280e:	be 00 00 00 00       	mov    $0x0,%esi
  802813:	bf 05 00 00 00       	mov    $0x5,%edi
  802818:	48 b8 76 26 80 00 00 	movabs $0x802676,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
  802824:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802827:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282b:	79 05                	jns    802832 <devfile_stat+0x47>
		return r;
  80282d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802830:	eb 56                	jmp    802888 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802832:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802836:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80283d:	00 00 00 
  802840:	48 89 c7             	mov    %rax,%rdi
  802843:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  80284a:	00 00 00 
  80284d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80284f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802856:	00 00 00 
  802859:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80285f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802863:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802869:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802870:	00 00 00 
  802873:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802879:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802888:	c9                   	leaveq 
  802889:	c3                   	retq   

000000000080288a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80288a:	55                   	push   %rbp
  80288b:	48 89 e5             	mov    %rsp,%rbp
  80288e:	48 83 ec 10          	sub    $0x10,%rsp
  802892:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802896:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80289d:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028a7:	00 00 00 
  8028aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b3:	00 00 00 
  8028b6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028bc:	be 00 00 00 00       	mov    $0x0,%esi
  8028c1:	bf 02 00 00 00       	mov    $0x2,%edi
  8028c6:	48 b8 76 26 80 00 00 	movabs $0x802676,%rax
  8028cd:	00 00 00 
  8028d0:	ff d0                	callq  *%rax
}
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <remove>:

// Delete a file
int
remove(const char *path)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 10          	sub    $0x10,%rsp
  8028dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8028e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028e4:	48 89 c7             	mov    %rax,%rdi
  8028e7:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	callq  *%rax
  8028f3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028f8:	7e 07                	jle    802901 <remove+0x2d>
		return -E_BAD_PATH;
  8028fa:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028ff:	eb 33                	jmp    802934 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802905:	48 89 c6             	mov    %rax,%rsi
  802908:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80290f:	00 00 00 
  802912:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80291e:	be 00 00 00 00       	mov    $0x0,%esi
  802923:	bf 07 00 00 00       	mov    $0x7,%edi
  802928:	48 b8 76 26 80 00 00 	movabs $0x802676,%rax
  80292f:	00 00 00 
  802932:	ff d0                	callq  *%rax
}
  802934:	c9                   	leaveq 
  802935:	c3                   	retq   

0000000000802936 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802936:	55                   	push   %rbp
  802937:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80293a:	be 00 00 00 00       	mov    $0x0,%esi
  80293f:	bf 08 00 00 00       	mov    $0x8,%edi
  802944:	48 b8 76 26 80 00 00 	movabs $0x802676,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
}
  802950:	5d                   	pop    %rbp
  802951:	c3                   	retq   

0000000000802952 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802952:	55                   	push   %rbp
  802953:	48 89 e5             	mov    %rsp,%rbp
  802956:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80295d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802964:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80296b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802972:	be 00 00 00 00       	mov    $0x0,%esi
  802977:	48 89 c7             	mov    %rax,%rdi
  80297a:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802981:	00 00 00 
  802984:	ff d0                	callq  *%rax
  802986:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802989:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298d:	79 28                	jns    8029b7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80298f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802992:	89 c6                	mov    %eax,%esi
  802994:	48 bf 91 4b 80 00 00 	movabs $0x804b91,%rdi
  80299b:	00 00 00 
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  8029aa:	00 00 00 
  8029ad:	ff d2                	callq  *%rdx
		return fd_src;
  8029af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b2:	e9 74 01 00 00       	jmpq   802b2b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8029b7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8029be:	be 01 01 00 00       	mov    $0x101,%esi
  8029c3:	48 89 c7             	mov    %rax,%rdi
  8029c6:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8029d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029d9:	79 39                	jns    802a14 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8029db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029de:	89 c6                	mov    %eax,%esi
  8029e0:	48 bf a7 4b 80 00 00 	movabs $0x804ba7,%rdi
  8029e7:	00 00 00 
  8029ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ef:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  8029f6:	00 00 00 
  8029f9:	ff d2                	callq  *%rdx
		close(fd_src);
  8029fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fe:	89 c7                	mov    %eax,%edi
  802a00:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	callq  *%rax
		return fd_dest;
  802a0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a0f:	e9 17 01 00 00       	jmpq   802b2b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a14:	eb 74                	jmp    802a8a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a19:	48 63 d0             	movslq %eax,%rdx
  802a1c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a26:	48 89 ce             	mov    %rcx,%rsi
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	48 b8 71 23 80 00 00 	movabs $0x802371,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax
  802a37:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a3e:	79 4a                	jns    802a8a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a40:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a43:	89 c6                	mov    %eax,%esi
  802a45:	48 bf c1 4b 80 00 00 	movabs $0x804bc1,%rdi
  802a4c:	00 00 00 
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  802a5b:	00 00 00 
  802a5e:	ff d2                	callq  *%rdx
			close(fd_src);
  802a60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a63:	89 c7                	mov    %eax,%edi
  802a65:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	callq  *%rax
			close(fd_dest);
  802a71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a74:	89 c7                	mov    %eax,%edi
  802a76:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
			return write_size;
  802a82:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a85:	e9 a1 00 00 00       	jmpq   802b2b <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a8a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a94:	ba 00 02 00 00       	mov    $0x200,%edx
  802a99:	48 89 ce             	mov    %rcx,%rsi
  802a9c:	89 c7                	mov    %eax,%edi
  802a9e:	48 b8 27 22 80 00 00 	movabs $0x802227,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ab1:	0f 8f 5f ff ff ff    	jg     802a16 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802abb:	79 47                	jns    802b04 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802abd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ac0:	89 c6                	mov    %eax,%esi
  802ac2:	48 bf d4 4b 80 00 00 	movabs $0x804bd4,%rdi
  802ac9:	00 00 00 
  802acc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad1:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  802ad8:	00 00 00 
  802adb:	ff d2                	callq  *%rdx
		close(fd_src);
  802add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae0:	89 c7                	mov    %eax,%edi
  802ae2:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
		close(fd_dest);
  802aee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
		return read_size;
  802aff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b02:	eb 27                	jmp    802b2b <copy+0x1d9>
	}
	close(fd_src);
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	89 c7                	mov    %eax,%edi
  802b09:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802b10:	00 00 00 
  802b13:	ff d0                	callq  *%rax
	close(fd_dest);
  802b15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b18:	89 c7                	mov    %eax,%edi
  802b1a:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
	return 0;
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b2b:	c9                   	leaveq 
  802b2c:	c3                   	retq   

0000000000802b2d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802b2d:	55                   	push   %rbp
  802b2e:	48 89 e5             	mov    %rsp,%rbp
  802b31:	48 83 ec 20          	sub    $0x20,%rsp
  802b35:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802b38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b3f:	48 89 d6             	mov    %rdx,%rsi
  802b42:	89 c7                	mov    %eax,%edi
  802b44:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  802b4b:	00 00 00 
  802b4e:	ff d0                	callq  *%rax
  802b50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b57:	79 05                	jns    802b5e <fd2sockid+0x31>
		return r;
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	eb 24                	jmp    802b82 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b62:	8b 10                	mov    (%rax),%edx
  802b64:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802b6b:	00 00 00 
  802b6e:	8b 00                	mov    (%rax),%eax
  802b70:	39 c2                	cmp    %eax,%edx
  802b72:	74 07                	je     802b7b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802b74:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b79:	eb 07                	jmp    802b82 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802b82:	c9                   	leaveq 
  802b83:	c3                   	retq   

0000000000802b84 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802b84:	55                   	push   %rbp
  802b85:	48 89 e5             	mov    %rsp,%rbp
  802b88:	48 83 ec 20          	sub    $0x20,%rsp
  802b8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802b8f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b93:	48 89 c7             	mov    %rax,%rdi
  802b96:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
  802ba2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba9:	78 26                	js     802bd1 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802bab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802baf:	ba 07 04 00 00       	mov    $0x407,%edx
  802bb4:	48 89 c6             	mov    %rax,%rsi
  802bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bbc:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  802bc3:	00 00 00 
  802bc6:	ff d0                	callq  *%rax
  802bc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bcf:	79 16                	jns    802be7 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802bd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd4:	89 c7                	mov    %eax,%edi
  802bd6:	48 b8 93 30 80 00 00 	movabs $0x803093,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	callq  *%rax
		return r;
  802be2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be5:	eb 3a                	jmp    802c21 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802beb:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802bf2:	00 00 00 
  802bf5:	8b 12                	mov    (%rdx),%edx
  802bf7:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802bf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c08:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c0b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
}
  802c21:	c9                   	leaveq 
  802c22:	c3                   	retq   

0000000000802c23 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c23:	55                   	push   %rbp
  802c24:	48 89 e5             	mov    %rsp,%rbp
  802c27:	48 83 ec 30          	sub    $0x30,%rsp
  802c2b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c32:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c39:	89 c7                	mov    %eax,%edi
  802c3b:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
  802c47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4e:	79 05                	jns    802c55 <accept+0x32>
		return r;
  802c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c53:	eb 3b                	jmp    802c90 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c55:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c59:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c60:	48 89 ce             	mov    %rcx,%rsi
  802c63:	89 c7                	mov    %eax,%edi
  802c65:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
  802c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c78:	79 05                	jns    802c7f <accept+0x5c>
		return r;
  802c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7d:	eb 11                	jmp    802c90 <accept+0x6d>
	return alloc_sockfd(r);
  802c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c82:	89 c7                	mov    %eax,%edi
  802c84:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
}
  802c90:	c9                   	leaveq 
  802c91:	c3                   	retq   

0000000000802c92 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c92:	55                   	push   %rbp
  802c93:	48 89 e5             	mov    %rsp,%rbp
  802c96:	48 83 ec 20          	sub    $0x20,%rsp
  802c9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ca1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ca4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
  802cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbc:	79 05                	jns    802cc3 <bind+0x31>
		return r;
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	eb 1b                	jmp    802cde <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802cc3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cc6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccd:	48 89 ce             	mov    %rcx,%rsi
  802cd0:	89 c7                	mov    %eax,%edi
  802cd2:	48 b8 ef 2f 80 00 00 	movabs $0x802fef,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
}
  802cde:	c9                   	leaveq 
  802cdf:	c3                   	retq   

0000000000802ce0 <shutdown>:

int
shutdown(int s, int how)
{
  802ce0:	55                   	push   %rbp
  802ce1:	48 89 e5             	mov    %rsp,%rbp
  802ce4:	48 83 ec 20          	sub    $0x20,%rsp
  802ce8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ceb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf1:	89 c7                	mov    %eax,%edi
  802cf3:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d06:	79 05                	jns    802d0d <shutdown+0x2d>
		return r;
  802d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0b:	eb 16                	jmp    802d23 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802d0d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d13:	89 d6                	mov    %edx,%esi
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 53 30 80 00 00 	movabs $0x803053,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
}
  802d23:	c9                   	leaveq 
  802d24:	c3                   	retq   

0000000000802d25 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802d25:	55                   	push   %rbp
  802d26:	48 89 e5             	mov    %rsp,%rbp
  802d29:	48 83 ec 10          	sub    $0x10,%rsp
  802d2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802d31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d35:	48 89 c7             	mov    %rax,%rdi
  802d38:	48 b8 06 3f 80 00 00 	movabs $0x803f06,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
  802d44:	83 f8 01             	cmp    $0x1,%eax
  802d47:	75 17                	jne    802d60 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802d49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d4d:	8b 40 0c             	mov    0xc(%rax),%eax
  802d50:	89 c7                	mov    %eax,%edi
  802d52:	48 b8 93 30 80 00 00 	movabs $0x803093,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
  802d5e:	eb 05                	jmp    802d65 <devsock_close+0x40>
	else
		return 0;
  802d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d65:	c9                   	leaveq 
  802d66:	c3                   	retq   

0000000000802d67 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d67:	55                   	push   %rbp
  802d68:	48 89 e5             	mov    %rsp,%rbp
  802d6b:	48 83 ec 20          	sub    $0x20,%rsp
  802d6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d76:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d7c:	89 c7                	mov    %eax,%edi
  802d7e:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
  802d8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d91:	79 05                	jns    802d98 <connect+0x31>
		return r;
  802d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d96:	eb 1b                	jmp    802db3 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802d98:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d9b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da2:	48 89 ce             	mov    %rcx,%rsi
  802da5:	89 c7                	mov    %eax,%edi
  802da7:	48 b8 c0 30 80 00 00 	movabs $0x8030c0,%rax
  802dae:	00 00 00 
  802db1:	ff d0                	callq  *%rax
}
  802db3:	c9                   	leaveq 
  802db4:	c3                   	retq   

0000000000802db5 <listen>:

int
listen(int s, int backlog)
{
  802db5:	55                   	push   %rbp
  802db6:	48 89 e5             	mov    %rsp,%rbp
  802db9:	48 83 ec 20          	sub    $0x20,%rsp
  802dbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802dc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
  802dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddb:	79 05                	jns    802de2 <listen+0x2d>
		return r;
  802ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de0:	eb 16                	jmp    802df8 <listen+0x43>
	return nsipc_listen(r, backlog);
  802de2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de8:	89 d6                	mov    %edx,%esi
  802dea:	89 c7                	mov    %eax,%edi
  802dec:	48 b8 24 31 80 00 00 	movabs $0x803124,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
}
  802df8:	c9                   	leaveq 
  802df9:	c3                   	retq   

0000000000802dfa <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802dfa:	55                   	push   %rbp
  802dfb:	48 89 e5             	mov    %rsp,%rbp
  802dfe:	48 83 ec 20          	sub    $0x20,%rsp
  802e02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e12:	89 c2                	mov    %eax,%edx
  802e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e18:	8b 40 0c             	mov    0xc(%rax),%eax
  802e1b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e24:	89 c7                	mov    %eax,%edi
  802e26:	48 b8 64 31 80 00 00 	movabs $0x803164,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
}
  802e32:	c9                   	leaveq 
  802e33:	c3                   	retq   

0000000000802e34 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802e34:	55                   	push   %rbp
  802e35:	48 89 e5             	mov    %rsp,%rbp
  802e38:	48 83 ec 20          	sub    $0x20,%rsp
  802e3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e44:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4c:	89 c2                	mov    %eax,%edx
  802e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e52:	8b 40 0c             	mov    0xc(%rax),%eax
  802e55:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e59:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e5e:	89 c7                	mov    %eax,%edi
  802e60:	48 b8 30 32 80 00 00 	movabs $0x803230,%rax
  802e67:	00 00 00 
  802e6a:	ff d0                	callq  *%rax
}
  802e6c:	c9                   	leaveq 
  802e6d:	c3                   	retq   

0000000000802e6e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 83 ec 10          	sub    $0x10,%rsp
  802e76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e82:	48 be ef 4b 80 00 00 	movabs $0x804bef,%rsi
  802e89:	00 00 00 
  802e8c:	48 89 c7             	mov    %rax,%rdi
  802e8f:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  802e96:	00 00 00 
  802e99:	ff d0                	callq  *%rax
	return 0;
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea0:	c9                   	leaveq 
  802ea1:	c3                   	retq   

0000000000802ea2 <socket>:

int
socket(int domain, int type, int protocol)
{
  802ea2:	55                   	push   %rbp
  802ea3:	48 89 e5             	mov    %rsp,%rbp
  802ea6:	48 83 ec 20          	sub    $0x20,%rsp
  802eaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ead:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802eb0:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802eb3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802eb6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802eb9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ebc:	89 ce                	mov    %ecx,%esi
  802ebe:	89 c7                	mov    %eax,%edi
  802ec0:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed3:	79 05                	jns    802eda <socket+0x38>
		return r;
  802ed5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed8:	eb 11                	jmp    802eeb <socket+0x49>
	return alloc_sockfd(r);
  802eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edd:	89 c7                	mov    %eax,%edi
  802edf:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
}
  802eeb:	c9                   	leaveq 
  802eec:	c3                   	retq   

0000000000802eed <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802eed:	55                   	push   %rbp
  802eee:	48 89 e5             	mov    %rsp,%rbp
  802ef1:	48 83 ec 10          	sub    $0x10,%rsp
  802ef5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802ef8:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802eff:	00 00 00 
  802f02:	8b 00                	mov    (%rax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	75 1f                	jne    802f27 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802f08:	bf 02 00 00 00       	mov    $0x2,%edi
  802f0d:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
  802f19:	89 c2                	mov    %eax,%edx
  802f1b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f22:	00 00 00 
  802f25:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802f27:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f2e:	00 00 00 
  802f31:	8b 00                	mov    (%rax),%eax
  802f33:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f36:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f3b:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802f42:	00 00 00 
  802f45:	89 c7                	mov    %eax,%edi
  802f47:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  802f4e:	00 00 00 
  802f51:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802f53:	ba 00 00 00 00       	mov    $0x0,%edx
  802f58:	be 00 00 00 00       	mov    $0x0,%esi
  802f5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f62:	48 b8 c9 3c 80 00 00 	movabs $0x803cc9,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
}
  802f6e:	c9                   	leaveq 
  802f6f:	c3                   	retq   

0000000000802f70 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f70:	55                   	push   %rbp
  802f71:	48 89 e5             	mov    %rsp,%rbp
  802f74:	48 83 ec 30          	sub    $0x30,%rsp
  802f78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802f83:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f8a:	00 00 00 
  802f8d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f90:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802f92:	bf 01 00 00 00       	mov    $0x1,%edi
  802f97:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
  802fa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802faa:	78 3e                	js     802fea <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802fac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fb3:	00 00 00 
  802fb6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbe:	8b 40 10             	mov    0x10(%rax),%eax
  802fc1:	89 c2                	mov    %eax,%edx
  802fc3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fcb:	48 89 ce             	mov    %rcx,%rsi
  802fce:	48 89 c7             	mov    %rax,%rdi
  802fd1:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe1:	8b 50 10             	mov    0x10(%rax),%edx
  802fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe8:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802fea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fed:	c9                   	leaveq 
  802fee:	c3                   	retq   

0000000000802fef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fef:	55                   	push   %rbp
  802ff0:	48 89 e5             	mov    %rsp,%rbp
  802ff3:	48 83 ec 10          	sub    $0x10,%rsp
  802ff7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ffa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ffe:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803001:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803008:	00 00 00 
  80300b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80300e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803010:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803017:	48 89 c6             	mov    %rax,%rsi
  80301a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803021:	00 00 00 
  803024:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803030:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803037:	00 00 00 
  80303a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80303d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803040:	bf 02 00 00 00       	mov    $0x2,%edi
  803045:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
}
  803051:	c9                   	leaveq 
  803052:	c3                   	retq   

0000000000803053 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803053:	55                   	push   %rbp
  803054:	48 89 e5             	mov    %rsp,%rbp
  803057:	48 83 ec 10          	sub    $0x10,%rsp
  80305b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80305e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803061:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803068:	00 00 00 
  80306b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80306e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803070:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803077:	00 00 00 
  80307a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80307d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803080:	bf 03 00 00 00       	mov    $0x3,%edi
  803085:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80308c:	00 00 00 
  80308f:	ff d0                	callq  *%rax
}
  803091:	c9                   	leaveq 
  803092:	c3                   	retq   

0000000000803093 <nsipc_close>:

int
nsipc_close(int s)
{
  803093:	55                   	push   %rbp
  803094:	48 89 e5             	mov    %rsp,%rbp
  803097:	48 83 ec 10          	sub    $0x10,%rsp
  80309b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80309e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030a5:	00 00 00 
  8030a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030ab:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8030ad:	bf 04 00 00 00       	mov    $0x4,%edi
  8030b2:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  8030b9:	00 00 00 
  8030bc:	ff d0                	callq  *%rax
}
  8030be:	c9                   	leaveq 
  8030bf:	c3                   	retq   

00000000008030c0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030c0:	55                   	push   %rbp
  8030c1:	48 89 e5             	mov    %rsp,%rbp
  8030c4:	48 83 ec 10          	sub    $0x10,%rsp
  8030c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030cf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8030d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030d9:	00 00 00 
  8030dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030df:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8030e1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e8:	48 89 c6             	mov    %rax,%rsi
  8030eb:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8030f2:	00 00 00 
  8030f5:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  8030fc:	00 00 00 
  8030ff:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803101:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803108:	00 00 00 
  80310b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80310e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803111:	bf 05 00 00 00       	mov    $0x5,%edi
  803116:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
}
  803122:	c9                   	leaveq 
  803123:	c3                   	retq   

0000000000803124 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 83 ec 10          	sub    $0x10,%rsp
  80312c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80312f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803132:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803139:	00 00 00 
  80313c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80313f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803141:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803148:	00 00 00 
  80314b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803151:	bf 06 00 00 00       	mov    $0x6,%edi
  803156:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
}
  803162:	c9                   	leaveq 
  803163:	c3                   	retq   

0000000000803164 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803164:	55                   	push   %rbp
  803165:	48 89 e5             	mov    %rsp,%rbp
  803168:	48 83 ec 30          	sub    $0x30,%rsp
  80316c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80316f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803173:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803176:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803179:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803180:	00 00 00 
  803183:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803186:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803188:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80318f:	00 00 00 
  803192:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803195:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803198:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80319f:	00 00 00 
  8031a2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031a5:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8031a8:	bf 07 00 00 00       	mov    $0x7,%edi
  8031ad:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  8031b4:	00 00 00 
  8031b7:	ff d0                	callq  *%rax
  8031b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c0:	78 69                	js     80322b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8031c2:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8031c9:	7f 08                	jg     8031d3 <nsipc_recv+0x6f>
  8031cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ce:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8031d1:	7e 35                	jle    803208 <nsipc_recv+0xa4>
  8031d3:	48 b9 f6 4b 80 00 00 	movabs $0x804bf6,%rcx
  8031da:	00 00 00 
  8031dd:	48 ba 0b 4c 80 00 00 	movabs $0x804c0b,%rdx
  8031e4:	00 00 00 
  8031e7:	be 61 00 00 00       	mov    $0x61,%esi
  8031ec:	48 bf 20 4c 80 00 00 	movabs $0x804c20,%rdi
  8031f3:	00 00 00 
  8031f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fb:	49 b8 b5 3b 80 00 00 	movabs $0x803bb5,%r8
  803202:	00 00 00 
  803205:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320b:	48 63 d0             	movslq %eax,%rdx
  80320e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803212:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803219:	00 00 00 
  80321c:	48 89 c7             	mov    %rax,%rdi
  80321f:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
	}

	return r;
  80322b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80322e:	c9                   	leaveq 
  80322f:	c3                   	retq   

0000000000803230 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803230:	55                   	push   %rbp
  803231:	48 89 e5             	mov    %rsp,%rbp
  803234:	48 83 ec 20          	sub    $0x20,%rsp
  803238:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80323b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80323f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803242:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803245:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80324c:	00 00 00 
  80324f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803252:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803254:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80325b:	7e 35                	jle    803292 <nsipc_send+0x62>
  80325d:	48 b9 2c 4c 80 00 00 	movabs $0x804c2c,%rcx
  803264:	00 00 00 
  803267:	48 ba 0b 4c 80 00 00 	movabs $0x804c0b,%rdx
  80326e:	00 00 00 
  803271:	be 6c 00 00 00       	mov    $0x6c,%esi
  803276:	48 bf 20 4c 80 00 00 	movabs $0x804c20,%rdi
  80327d:	00 00 00 
  803280:	b8 00 00 00 00       	mov    $0x0,%eax
  803285:	49 b8 b5 3b 80 00 00 	movabs $0x803bb5,%r8
  80328c:	00 00 00 
  80328f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803292:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803295:	48 63 d0             	movslq %eax,%rdx
  803298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329c:	48 89 c6             	mov    %rax,%rsi
  80329f:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8032a6:	00 00 00 
  8032a9:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8032b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032bc:	00 00 00 
  8032bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8032c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032cc:	00 00 00 
  8032cf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032d2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8032d5:	bf 08 00 00 00       	mov    $0x8,%edi
  8032da:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	callq  *%rax
}
  8032e6:	c9                   	leaveq 
  8032e7:	c3                   	retq   

00000000008032e8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8032e8:	55                   	push   %rbp
  8032e9:	48 89 e5             	mov    %rsp,%rbp
  8032ec:	48 83 ec 10          	sub    $0x10,%rsp
  8032f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8032f6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8032f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803300:	00 00 00 
  803303:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803306:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803308:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80330f:	00 00 00 
  803312:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803315:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803318:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80331f:	00 00 00 
  803322:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803325:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803328:	bf 09 00 00 00       	mov    $0x9,%edi
  80332d:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
}
  803339:	c9                   	leaveq 
  80333a:	c3                   	retq   

000000000080333b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80333b:	55                   	push   %rbp
  80333c:	48 89 e5             	mov    %rsp,%rbp
  80333f:	53                   	push   %rbx
  803340:	48 83 ec 38          	sub    $0x38,%rsp
  803344:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803348:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80334c:	48 89 c7             	mov    %rax,%rdi
  80334f:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
  80335b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803362:	0f 88 bf 01 00 00    	js     803527 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336c:	ba 07 04 00 00       	mov    $0x407,%edx
  803371:	48 89 c6             	mov    %rax,%rsi
  803374:	bf 00 00 00 00       	mov    $0x0,%edi
  803379:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
  803385:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803388:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338c:	0f 88 95 01 00 00    	js     803527 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803392:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803396:	48 89 c7             	mov    %rax,%rdi
  803399:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
  8033a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033ac:	0f 88 5d 01 00 00    	js     80350f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8033bb:	48 89 c6             	mov    %rax,%rsi
  8033be:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c3:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
  8033cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d6:	0f 88 33 01 00 00    	js     80350f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e0:	48 89 c7             	mov    %rax,%rdi
  8033e3:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  8033ea:	00 00 00 
  8033ed:	ff d0                	callq  *%rax
  8033ef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f7:	ba 07 04 00 00       	mov    $0x407,%edx
  8033fc:	48 89 c6             	mov    %rax,%rsi
  8033ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803404:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  80340b:	00 00 00 
  80340e:	ff d0                	callq  *%rax
  803410:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803413:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803417:	79 05                	jns    80341e <pipe+0xe3>
		goto err2;
  803419:	e9 d9 00 00 00       	jmpq   8034f7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80341e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803422:	48 89 c7             	mov    %rax,%rdi
  803425:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  80342c:	00 00 00 
  80342f:	ff d0                	callq  *%rax
  803431:	48 89 c2             	mov    %rax,%rdx
  803434:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803438:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80343e:	48 89 d1             	mov    %rdx,%rcx
  803441:	ba 00 00 00 00       	mov    $0x0,%edx
  803446:	48 89 c6             	mov    %rax,%rsi
  803449:	bf 00 00 00 00       	mov    $0x0,%edi
  80344e:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80345d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803461:	79 1b                	jns    80347e <pipe+0x143>
		goto err3;
  803463:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803464:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803468:	48 89 c6             	mov    %rax,%rsi
  80346b:	bf 00 00 00 00       	mov    $0x0,%edi
  803470:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	eb 79                	jmp    8034f7 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  80347e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803482:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803489:	00 00 00 
  80348c:	8b 12                	mov    (%rdx),%edx
  80348e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803490:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803494:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80349b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80349f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8034a6:	00 00 00 
  8034a9:	8b 12                	mov    (%rdx),%edx
  8034ab:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8034ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  8034b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034bc:	48 89 c7             	mov    %rax,%rdi
  8034bf:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
  8034cb:	89 c2                	mov    %eax,%edx
  8034cd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034d1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034d7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8034db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034df:	48 89 c7             	mov    %rax,%rdi
  8034e2:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
  8034ee:	89 03                	mov    %eax,(%rbx)
	return 0;
  8034f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f5:	eb 33                	jmp    80352a <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8034f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fb:	48 89 c6             	mov    %rax,%rsi
  8034fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803503:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80350f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803513:	48 89 c6             	mov    %rax,%rsi
  803516:	bf 00 00 00 00       	mov    $0x0,%edi
  80351b:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  803522:	00 00 00 
  803525:	ff d0                	callq  *%rax
err:
	return r;
  803527:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80352a:	48 83 c4 38          	add    $0x38,%rsp
  80352e:	5b                   	pop    %rbx
  80352f:	5d                   	pop    %rbp
  803530:	c3                   	retq   

0000000000803531 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803531:	55                   	push   %rbp
  803532:	48 89 e5             	mov    %rsp,%rbp
  803535:	53                   	push   %rbx
  803536:	48 83 ec 28          	sub    $0x28,%rsp
  80353a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80353e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803542:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803549:	00 00 00 
  80354c:	48 8b 00             	mov    (%rax),%rax
  80354f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803555:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80355c:	48 89 c7             	mov    %rax,%rdi
  80355f:	48 b8 06 3f 80 00 00 	movabs $0x803f06,%rax
  803566:	00 00 00 
  803569:	ff d0                	callq  *%rax
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803571:	48 89 c7             	mov    %rax,%rdi
  803574:	48 b8 06 3f 80 00 00 	movabs $0x803f06,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
  803580:	39 c3                	cmp    %eax,%ebx
  803582:	0f 94 c0             	sete   %al
  803585:	0f b6 c0             	movzbl %al,%eax
  803588:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80358b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803592:	00 00 00 
  803595:	48 8b 00             	mov    (%rax),%rax
  803598:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80359e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8035a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035a7:	75 05                	jne    8035ae <_pipeisclosed+0x7d>
			return ret;
  8035a9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035ac:	eb 4a                	jmp    8035f8 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8035ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035b4:	74 3d                	je     8035f3 <_pipeisclosed+0xc2>
  8035b6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8035ba:	75 37                	jne    8035f3 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035bc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8035c3:	00 00 00 
  8035c6:	48 8b 00             	mov    (%rax),%rax
  8035c9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035cf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d5:	89 c6                	mov    %eax,%esi
  8035d7:	48 bf 3d 4c 80 00 00 	movabs $0x804c3d,%rdi
  8035de:	00 00 00 
  8035e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e6:	49 b8 de 04 80 00 00 	movabs $0x8004de,%r8
  8035ed:	00 00 00 
  8035f0:	41 ff d0             	callq  *%r8
	}
  8035f3:	e9 4a ff ff ff       	jmpq   803542 <_pipeisclosed+0x11>
}
  8035f8:	48 83 c4 28          	add    $0x28,%rsp
  8035fc:	5b                   	pop    %rbx
  8035fd:	5d                   	pop    %rbp
  8035fe:	c3                   	retq   

00000000008035ff <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8035ff:	55                   	push   %rbp
  803600:	48 89 e5             	mov    %rsp,%rbp
  803603:	48 83 ec 30          	sub    $0x30,%rsp
  803607:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80360a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80360e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803611:	48 89 d6             	mov    %rdx,%rsi
  803614:	89 c7                	mov    %eax,%edi
  803616:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
  803622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803629:	79 05                	jns    803630 <pipeisclosed+0x31>
		return r;
  80362b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362e:	eb 31                	jmp    803661 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803634:	48 89 c7             	mov    %rax,%rdi
  803637:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
  803643:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80364f:	48 89 d6             	mov    %rdx,%rsi
  803652:	48 89 c7             	mov    %rax,%rdi
  803655:	48 b8 31 35 80 00 00 	movabs $0x803531,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	callq  *%rax
}
  803661:	c9                   	leaveq 
  803662:	c3                   	retq   

0000000000803663 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803663:	55                   	push   %rbp
  803664:	48 89 e5             	mov    %rsp,%rbp
  803667:	48 83 ec 40          	sub    $0x40,%rsp
  80366b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80366f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803673:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80367b:	48 89 c7             	mov    %rax,%rdi
  80367e:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  803685:	00 00 00 
  803688:	ff d0                	callq  *%rax
  80368a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80368e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803692:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803696:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80369d:	00 
  80369e:	e9 92 00 00 00       	jmpq   803735 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8036a3:	eb 41                	jmp    8036e6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8036a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8036aa:	74 09                	je     8036b5 <devpipe_read+0x52>
				return i;
  8036ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b0:	e9 92 00 00 00       	jmpq   803747 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bd:	48 89 d6             	mov    %rdx,%rsi
  8036c0:	48 89 c7             	mov    %rax,%rdi
  8036c3:	48 b8 31 35 80 00 00 	movabs $0x803531,%rax
  8036ca:	00 00 00 
  8036cd:	ff d0                	callq  *%rax
  8036cf:	85 c0                	test   %eax,%eax
  8036d1:	74 07                	je     8036da <devpipe_read+0x77>
				return 0;
  8036d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d8:	eb 6d                	jmp    803747 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8036da:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  8036e1:	00 00 00 
  8036e4:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8036e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ea:	8b 10                	mov    (%rax),%edx
  8036ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f0:	8b 40 04             	mov    0x4(%rax),%eax
  8036f3:	39 c2                	cmp    %eax,%edx
  8036f5:	74 ae                	je     8036a5 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ff:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803707:	8b 00                	mov    (%rax),%eax
  803709:	99                   	cltd   
  80370a:	c1 ea 1b             	shr    $0x1b,%edx
  80370d:	01 d0                	add    %edx,%eax
  80370f:	83 e0 1f             	and    $0x1f,%eax
  803712:	29 d0                	sub    %edx,%eax
  803714:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803718:	48 98                	cltq   
  80371a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80371f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803725:	8b 00                	mov    (%rax),%eax
  803727:	8d 50 01             	lea    0x1(%rax),%edx
  80372a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372e:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803730:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803739:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80373d:	0f 82 60 ff ff ff    	jb     8036a3 <devpipe_read+0x40>
	}
	return i;
  803743:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803747:	c9                   	leaveq 
  803748:	c3                   	retq   

0000000000803749 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803749:	55                   	push   %rbp
  80374a:	48 89 e5             	mov    %rsp,%rbp
  80374d:	48 83 ec 40          	sub    $0x40,%rsp
  803751:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803755:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803759:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80375d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803761:	48 89 c7             	mov    %rax,%rdi
  803764:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
  803770:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803774:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803778:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80377c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803783:	00 
  803784:	e9 91 00 00 00       	jmpq   80381a <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803789:	eb 31                	jmp    8037bc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80378b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80378f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803793:	48 89 d6             	mov    %rdx,%rsi
  803796:	48 89 c7             	mov    %rax,%rdi
  803799:	48 b8 31 35 80 00 00 	movabs $0x803531,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	74 07                	je     8037b0 <devpipe_write+0x67>
				return 0;
  8037a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ae:	eb 7c                	jmp    80382c <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8037b0:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  8037b7:	00 00 00 
  8037ba:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c0:	8b 40 04             	mov    0x4(%rax),%eax
  8037c3:	48 63 d0             	movslq %eax,%rdx
  8037c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ca:	8b 00                	mov    (%rax),%eax
  8037cc:	48 98                	cltq   
  8037ce:	48 83 c0 20          	add    $0x20,%rax
  8037d2:	48 39 c2             	cmp    %rax,%rdx
  8037d5:	73 b4                	jae    80378b <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8037d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037db:	8b 40 04             	mov    0x4(%rax),%eax
  8037de:	99                   	cltd   
  8037df:	c1 ea 1b             	shr    $0x1b,%edx
  8037e2:	01 d0                	add    %edx,%eax
  8037e4:	83 e0 1f             	and    $0x1f,%eax
  8037e7:	29 d0                	sub    %edx,%eax
  8037e9:	89 c6                	mov    %eax,%esi
  8037eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f3:	48 01 d0             	add    %rdx,%rax
  8037f6:	0f b6 08             	movzbl (%rax),%ecx
  8037f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037fd:	48 63 c6             	movslq %esi,%rax
  803800:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803804:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803808:	8b 40 04             	mov    0x4(%rax),%eax
  80380b:	8d 50 01             	lea    0x1(%rax),%edx
  80380e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803812:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803815:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80381a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803822:	0f 82 61 ff ff ff    	jb     803789 <devpipe_write+0x40>
	}

	return i;
  803828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80382c:	c9                   	leaveq 
  80382d:	c3                   	retq   

000000000080382e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80382e:	55                   	push   %rbp
  80382f:	48 89 e5             	mov    %rsp,%rbp
  803832:	48 83 ec 20          	sub    $0x20,%rsp
  803836:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80383a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80383e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803842:	48 89 c7             	mov    %rax,%rdi
  803845:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  80384c:	00 00 00 
  80384f:	ff d0                	callq  *%rax
  803851:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803855:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803859:	48 be 50 4c 80 00 00 	movabs $0x804c50,%rsi
  803860:	00 00 00 
  803863:	48 89 c7             	mov    %rax,%rdi
  803866:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803876:	8b 50 04             	mov    0x4(%rax),%edx
  803879:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387d:	8b 00                	mov    (%rax),%eax
  80387f:	29 c2                	sub    %eax,%edx
  803881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803885:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80388b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803896:	00 00 00 
	stat->st_dev = &devpipe;
  803899:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80389d:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8038a4:	00 00 00 
  8038a7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8038ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038b3:	c9                   	leaveq 
  8038b4:	c3                   	retq   

00000000008038b5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8038b5:	55                   	push   %rbp
  8038b6:	48 89 e5             	mov    %rsp,%rbp
  8038b9:	48 83 ec 10          	sub    $0x10,%rsp
  8038bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8038c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c5:	48 89 c6             	mov    %rax,%rsi
  8038c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038cd:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  8038d4:	00 00 00 
  8038d7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8038d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038dd:	48 89 c7             	mov    %rax,%rdi
  8038e0:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
  8038ec:	48 89 c6             	mov    %rax,%rsi
  8038ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f4:	48 b8 57 1a 80 00 00 	movabs $0x801a57,%rax
  8038fb:	00 00 00 
  8038fe:	ff d0                	callq  *%rax
}
  803900:	c9                   	leaveq 
  803901:	c3                   	retq   

0000000000803902 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803902:	55                   	push   %rbp
  803903:	48 89 e5             	mov    %rsp,%rbp
  803906:	48 83 ec 20          	sub    $0x20,%rsp
  80390a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80390d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803910:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803913:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803917:	be 01 00 00 00       	mov    $0x1,%esi
  80391c:	48 89 c7             	mov    %rax,%rdi
  80391f:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
}
  80392b:	c9                   	leaveq 
  80392c:	c3                   	retq   

000000000080392d <getchar>:

int
getchar(void)
{
  80392d:	55                   	push   %rbp
  80392e:	48 89 e5             	mov    %rsp,%rbp
  803931:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803935:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803939:	ba 01 00 00 00       	mov    $0x1,%edx
  80393e:	48 89 c6             	mov    %rax,%rsi
  803941:	bf 00 00 00 00       	mov    $0x0,%edi
  803946:	48 b8 27 22 80 00 00 	movabs $0x802227,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
  803952:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803955:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803959:	79 05                	jns    803960 <getchar+0x33>
		return r;
  80395b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395e:	eb 14                	jmp    803974 <getchar+0x47>
	if (r < 1)
  803960:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803964:	7f 07                	jg     80396d <getchar+0x40>
		return -E_EOF;
  803966:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80396b:	eb 07                	jmp    803974 <getchar+0x47>
	return c;
  80396d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803971:	0f b6 c0             	movzbl %al,%eax
}
  803974:	c9                   	leaveq 
  803975:	c3                   	retq   

0000000000803976 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803976:	55                   	push   %rbp
  803977:	48 89 e5             	mov    %rsp,%rbp
  80397a:	48 83 ec 20          	sub    $0x20,%rsp
  80397e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803981:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803985:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803988:	48 89 d6             	mov    %rdx,%rsi
  80398b:	89 c7                	mov    %eax,%edi
  80398d:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
  803999:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a0:	79 05                	jns    8039a7 <iscons+0x31>
		return r;
  8039a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a5:	eb 1a                	jmp    8039c1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8039a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ab:	8b 10                	mov    (%rax),%edx
  8039ad:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8039b4:	00 00 00 
  8039b7:	8b 00                	mov    (%rax),%eax
  8039b9:	39 c2                	cmp    %eax,%edx
  8039bb:	0f 94 c0             	sete   %al
  8039be:	0f b6 c0             	movzbl %al,%eax
}
  8039c1:	c9                   	leaveq 
  8039c2:	c3                   	retq   

00000000008039c3 <opencons>:

int
opencons(void)
{
  8039c3:	55                   	push   %rbp
  8039c4:	48 89 e5             	mov    %rsp,%rbp
  8039c7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039cb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039cf:	48 89 c7             	mov    %rax,%rdi
  8039d2:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
  8039de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e5:	79 05                	jns    8039ec <opencons+0x29>
		return r;
  8039e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ea:	eb 5b                	jmp    803a47 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f0:	ba 07 04 00 00       	mov    $0x407,%edx
  8039f5:	48 89 c6             	mov    %rax,%rsi
  8039f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039fd:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  803a04:	00 00 00 
  803a07:	ff d0                	callq  *%rax
  803a09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a10:	79 05                	jns    803a17 <opencons+0x54>
		return r;
  803a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a15:	eb 30                	jmp    803a47 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1b:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803a22:	00 00 00 
  803a25:	8b 12                	mov    (%rdx),%edx
  803a27:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a38:	48 89 c7             	mov    %rax,%rdi
  803a3b:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  803a42:	00 00 00 
  803a45:	ff d0                	callq  *%rax
}
  803a47:	c9                   	leaveq 
  803a48:	c3                   	retq   

0000000000803a49 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a49:	55                   	push   %rbp
  803a4a:	48 89 e5             	mov    %rsp,%rbp
  803a4d:	48 83 ec 30          	sub    $0x30,%rsp
  803a51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a59:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a5d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a62:	75 07                	jne    803a6b <devcons_read+0x22>
		return 0;
  803a64:	b8 00 00 00 00       	mov    $0x0,%eax
  803a69:	eb 4b                	jmp    803ab6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a6b:	eb 0c                	jmp    803a79 <devcons_read+0x30>
		sys_yield();
  803a6d:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803a79:	48 b8 ab 18 80 00 00 	movabs $0x8018ab,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
  803a85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a8c:	74 df                	je     803a6d <devcons_read+0x24>
	if (c < 0)
  803a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a92:	79 05                	jns    803a99 <devcons_read+0x50>
		return c;
  803a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a97:	eb 1d                	jmp    803ab6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a99:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a9d:	75 07                	jne    803aa6 <devcons_read+0x5d>
		return 0;
  803a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa4:	eb 10                	jmp    803ab6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa9:	89 c2                	mov    %eax,%edx
  803aab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aaf:	88 10                	mov    %dl,(%rax)
	return 1;
  803ab1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ab6:	c9                   	leaveq 
  803ab7:	c3                   	retq   

0000000000803ab8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ab8:	55                   	push   %rbp
  803ab9:	48 89 e5             	mov    %rsp,%rbp
  803abc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ac3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803aca:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ad1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803adf:	eb 76                	jmp    803b57 <devcons_write+0x9f>
		m = n - tot;
  803ae1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ae8:	89 c2                	mov    %eax,%edx
  803aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aed:	29 c2                	sub    %eax,%edx
  803aef:	89 d0                	mov    %edx,%eax
  803af1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803af4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803af7:	83 f8 7f             	cmp    $0x7f,%eax
  803afa:	76 07                	jbe    803b03 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803afc:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803b03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b06:	48 63 d0             	movslq %eax,%rdx
  803b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0c:	48 63 c8             	movslq %eax,%rcx
  803b0f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803b16:	48 01 c1             	add    %rax,%rcx
  803b19:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b20:	48 89 ce             	mov    %rcx,%rsi
  803b23:	48 89 c7             	mov    %rax,%rdi
  803b26:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  803b2d:	00 00 00 
  803b30:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b35:	48 63 d0             	movslq %eax,%rdx
  803b38:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b3f:	48 89 d6             	mov    %rdx,%rsi
  803b42:	48 89 c7             	mov    %rax,%rdi
  803b45:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  803b4c:	00 00 00 
  803b4f:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803b51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b54:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5a:	48 98                	cltq   
  803b5c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b63:	0f 82 78 ff ff ff    	jb     803ae1 <devcons_write+0x29>
	}
	return tot;
  803b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b6c:	c9                   	leaveq 
  803b6d:	c3                   	retq   

0000000000803b6e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b6e:	55                   	push   %rbp
  803b6f:	48 89 e5             	mov    %rsp,%rbp
  803b72:	48 83 ec 08          	sub    $0x8,%rsp
  803b76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b7f:	c9                   	leaveq 
  803b80:	c3                   	retq   

0000000000803b81 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b81:	55                   	push   %rbp
  803b82:	48 89 e5             	mov    %rsp,%rbp
  803b85:	48 83 ec 10          	sub    $0x10,%rsp
  803b89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b95:	48 be 5c 4c 80 00 00 	movabs $0x804c5c,%rsi
  803b9c:	00 00 00 
  803b9f:	48 89 c7             	mov    %rax,%rdi
  803ba2:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  803ba9:	00 00 00 
  803bac:	ff d0                	callq  *%rax
	return 0;
  803bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bb3:	c9                   	leaveq 
  803bb4:	c3                   	retq   

0000000000803bb5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803bb5:	55                   	push   %rbp
  803bb6:	48 89 e5             	mov    %rsp,%rbp
  803bb9:	53                   	push   %rbx
  803bba:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803bc1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803bc8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803bce:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803bd5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803bdc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803be3:	84 c0                	test   %al,%al
  803be5:	74 23                	je     803c0a <_panic+0x55>
  803be7:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803bee:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803bf2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803bf6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803bfa:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803bfe:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803c02:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803c06:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803c0a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803c11:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803c18:	00 00 00 
  803c1b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803c22:	00 00 00 
  803c25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c29:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803c30:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803c37:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803c3e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803c45:	00 00 00 
  803c48:	48 8b 18             	mov    (%rax),%rbx
  803c4b:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
  803c57:	89 c6                	mov    %eax,%esi
  803c59:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803c5f:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c66:	41 89 d0             	mov    %edx,%r8d
  803c69:	48 89 c1             	mov    %rax,%rcx
  803c6c:	48 89 da             	mov    %rbx,%rdx
  803c6f:	48 bf 68 4c 80 00 00 	movabs $0x804c68,%rdi
  803c76:	00 00 00 
  803c79:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7e:	49 b9 de 04 80 00 00 	movabs $0x8004de,%r9
  803c85:	00 00 00 
  803c88:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803c8b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803c92:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803c99:	48 89 d6             	mov    %rdx,%rsi
  803c9c:	48 89 c7             	mov    %rax,%rdi
  803c9f:	48 b8 32 04 80 00 00 	movabs $0x800432,%rax
  803ca6:	00 00 00 
  803ca9:	ff d0                	callq  *%rax
	cprintf("\n");
  803cab:	48 bf 8b 4c 80 00 00 	movabs $0x804c8b,%rdi
  803cb2:	00 00 00 
  803cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  803cba:	48 ba de 04 80 00 00 	movabs $0x8004de,%rdx
  803cc1:	00 00 00 
  803cc4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803cc6:	cc                   	int3   
  803cc7:	eb fd                	jmp    803cc6 <_panic+0x111>

0000000000803cc9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803cc9:	55                   	push   %rbp
  803cca:	48 89 e5             	mov    %rsp,%rbp
  803ccd:	48 83 ec 20          	sub    $0x20,%rsp
  803cd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cd9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803cdd:	48 ba 90 4c 80 00 00 	movabs $0x804c90,%rdx
  803ce4:	00 00 00 
  803ce7:	be 1d 00 00 00       	mov    $0x1d,%esi
  803cec:	48 bf a9 4c 80 00 00 	movabs $0x804ca9,%rdi
  803cf3:	00 00 00 
  803cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfb:	48 b9 b5 3b 80 00 00 	movabs $0x803bb5,%rcx
  803d02:	00 00 00 
  803d05:	ff d1                	callq  *%rcx

0000000000803d07 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d07:	55                   	push   %rbp
  803d08:	48 89 e5             	mov    %rsp,%rbp
  803d0b:	48 83 ec 20          	sub    $0x20,%rsp
  803d0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d12:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d15:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803d19:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803d1c:	48 ba b3 4c 80 00 00 	movabs $0x804cb3,%rdx
  803d23:	00 00 00 
  803d26:	be 2d 00 00 00       	mov    $0x2d,%esi
  803d2b:	48 bf a9 4c 80 00 00 	movabs $0x804ca9,%rdi
  803d32:	00 00 00 
  803d35:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3a:	48 b9 b5 3b 80 00 00 	movabs $0x803bb5,%rcx
  803d41:	00 00 00 
  803d44:	ff d1                	callq  *%rcx

0000000000803d46 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803d46:	55                   	push   %rbp
  803d47:	48 89 e5             	mov    %rsp,%rbp
  803d4a:	53                   	push   %rbx
  803d4b:	48 83 ec 48          	sub    $0x48,%rsp
  803d4f:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803d53:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803d5a:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803d61:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803d66:	75 0e                	jne    803d76 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803d68:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803d6f:	00 00 00 
  803d72:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803d76:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803d7a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803d7e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803d85:	00 
	a3 = (uint64_t) 0;
  803d86:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803d8d:	00 
	a4 = (uint64_t) 0;
  803d8e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803d95:	00 
	a5 = 0;
  803d96:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803d9d:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803d9e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803da1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803da5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803da9:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803dad:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803db1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803db5:	4c 89 c3             	mov    %r8,%rbx
  803db8:	0f 01 c1             	vmcall 
  803dbb:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803dbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc2:	7e 36                	jle    803dfa <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803dc4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dc7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dca:	41 89 d0             	mov    %edx,%r8d
  803dcd:	89 c1                	mov    %eax,%ecx
  803dcf:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  803dd6:	00 00 00 
  803dd9:	be 54 00 00 00       	mov    $0x54,%esi
  803dde:	48 bf a9 4c 80 00 00 	movabs $0x804ca9,%rdi
  803de5:	00 00 00 
  803de8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ded:	49 b9 b5 3b 80 00 00 	movabs $0x803bb5,%r9
  803df4:	00 00 00 
  803df7:	41 ff d1             	callq  *%r9
	return ret;
  803dfa:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803dfd:	48 83 c4 48          	add    $0x48,%rsp
  803e01:	5b                   	pop    %rbx
  803e02:	5d                   	pop    %rbp
  803e03:	c3                   	retq   

0000000000803e04 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e04:	55                   	push   %rbp
  803e05:	48 89 e5             	mov    %rsp,%rbp
  803e08:	53                   	push   %rbx
  803e09:	48 83 ec 58          	sub    $0x58,%rsp
  803e0d:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803e10:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803e13:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803e17:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803e21:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803e28:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803e2d:	75 0e                	jne    803e3d <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803e2f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e36:	00 00 00 
  803e39:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803e3d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803e40:	48 98                	cltq   
  803e42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803e46:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803e49:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803e4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e51:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803e55:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803e58:	48 98                	cltq   
  803e5a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803e5e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803e65:	00 

	int r = -E_IPC_NOT_RECV;
  803e66:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803e6d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e74:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803e78:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803e7c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803e80:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803e84:	4c 89 c3             	mov    %r8,%rbx
  803e87:	0f 01 c1             	vmcall 
  803e8a:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803e8d:	48 83 c4 58          	add    $0x58,%rsp
  803e91:	5b                   	pop    %rbx
  803e92:	5d                   	pop    %rbp
  803e93:	c3                   	retq   

0000000000803e94 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e94:	55                   	push   %rbp
  803e95:	48 89 e5             	mov    %rsp,%rbp
  803e98:	48 83 ec 18          	sub    $0x18,%rsp
  803e9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ea6:	eb 4e                	jmp    803ef6 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803ea8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803eaf:	00 00 00 
  803eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb5:	48 98                	cltq   
  803eb7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ebe:	48 01 d0             	add    %rdx,%rax
  803ec1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ec7:	8b 00                	mov    (%rax),%eax
  803ec9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ecc:	75 24                	jne    803ef2 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803ece:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ed5:	00 00 00 
  803ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803edb:	48 98                	cltq   
  803edd:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ee4:	48 01 d0             	add    %rdx,%rax
  803ee7:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803eed:	8b 40 08             	mov    0x8(%rax),%eax
  803ef0:	eb 12                	jmp    803f04 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803ef2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ef6:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803efd:	7e a9                	jle    803ea8 <ipc_find_env+0x14>
	}
	return 0;
  803eff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f04:	c9                   	leaveq 
  803f05:	c3                   	retq   

0000000000803f06 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f06:	55                   	push   %rbp
  803f07:	48 89 e5             	mov    %rsp,%rbp
  803f0a:	48 83 ec 18          	sub    $0x18,%rsp
  803f0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f16:	48 c1 e8 15          	shr    $0x15,%rax
  803f1a:	48 89 c2             	mov    %rax,%rdx
  803f1d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f24:	01 00 00 
  803f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f2b:	83 e0 01             	and    $0x1,%eax
  803f2e:	48 85 c0             	test   %rax,%rax
  803f31:	75 07                	jne    803f3a <pageref+0x34>
		return 0;
  803f33:	b8 00 00 00 00       	mov    $0x0,%eax
  803f38:	eb 53                	jmp    803f8d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f3e:	48 c1 e8 0c          	shr    $0xc,%rax
  803f42:	48 89 c2             	mov    %rax,%rdx
  803f45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f4c:	01 00 00 
  803f4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5b:	83 e0 01             	and    $0x1,%eax
  803f5e:	48 85 c0             	test   %rax,%rax
  803f61:	75 07                	jne    803f6a <pageref+0x64>
		return 0;
  803f63:	b8 00 00 00 00       	mov    $0x0,%eax
  803f68:	eb 23                	jmp    803f8d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6e:	48 c1 e8 0c          	shr    $0xc,%rax
  803f72:	48 89 c2             	mov    %rax,%rdx
  803f75:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f7c:	00 00 00 
  803f7f:	48 c1 e2 04          	shl    $0x4,%rdx
  803f83:	48 01 d0             	add    %rdx,%rax
  803f86:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f8a:	0f b7 c0             	movzwl %ax,%eax
}
  803f8d:	c9                   	leaveq 
  803f8e:	c3                   	retq   

0000000000803f8f <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803f8f:	55                   	push   %rbp
  803f90:	48 89 e5             	mov    %rsp,%rbp
  803f93:	48 83 ec 20          	sub    $0x20,%rsp
  803f97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  803f9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa3:	48 89 d6             	mov    %rdx,%rsi
  803fa6:	48 89 c7             	mov    %rax,%rdi
  803fa9:	48 b8 c5 3f 80 00 00 	movabs $0x803fc5,%rax
  803fb0:	00 00 00 
  803fb3:	ff d0                	callq  *%rax
  803fb5:	85 c0                	test   %eax,%eax
  803fb7:	74 05                	je     803fbe <inet_addr+0x2f>
    return (val.s_addr);
  803fb9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803fbc:	eb 05                	jmp    803fc3 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  803fbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803fc3:	c9                   	leaveq 
  803fc4:	c3                   	retq   

0000000000803fc5 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803fc5:	55                   	push   %rbp
  803fc6:	48 89 e5             	mov    %rsp,%rbp
  803fc9:	48 83 ec 40          	sub    $0x40,%rsp
  803fcd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803fd1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803fd5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803fd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  803fdd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fe1:	0f b6 00             	movzbl (%rax),%eax
  803fe4:	0f be c0             	movsbl %al,%eax
  803fe7:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803fea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803fed:	3c 2f                	cmp    $0x2f,%al
  803fef:	76 07                	jbe    803ff8 <inet_aton+0x33>
  803ff1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ff4:	3c 39                	cmp    $0x39,%al
  803ff6:	76 0a                	jbe    804002 <inet_aton+0x3d>
      return (0);
  803ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffd:	e9 6e 02 00 00       	jmpq   804270 <inet_aton+0x2ab>
    val = 0;
  804002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804009:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804010:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  804014:	75 40                	jne    804056 <inet_aton+0x91>
      c = *++cp;
  804016:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80401b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80401f:	0f b6 00             	movzbl (%rax),%eax
  804022:	0f be c0             	movsbl %al,%eax
  804025:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  804028:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  80402c:	74 06                	je     804034 <inet_aton+0x6f>
  80402e:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804032:	75 1b                	jne    80404f <inet_aton+0x8a>
        base = 16;
  804034:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  80403b:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804040:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804044:	0f b6 00             	movzbl (%rax),%eax
  804047:	0f be c0             	movsbl %al,%eax
  80404a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80404d:	eb 07                	jmp    804056 <inet_aton+0x91>
      } else
        base = 8;
  80404f:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804056:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804059:	3c 2f                	cmp    $0x2f,%al
  80405b:	76 2f                	jbe    80408c <inet_aton+0xc7>
  80405d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804060:	3c 39                	cmp    $0x39,%al
  804062:	77 28                	ja     80408c <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  804064:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804067:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  80406b:	89 c2                	mov    %eax,%edx
  80406d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804070:	01 d0                	add    %edx,%eax
  804072:	83 e8 30             	sub    $0x30,%eax
  804075:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804078:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80407d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804081:	0f b6 00             	movzbl (%rax),%eax
  804084:	0f be c0             	movsbl %al,%eax
  804087:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80408a:	eb 73                	jmp    8040ff <inet_aton+0x13a>
      } else if (base == 16 && isxdigit(c)) {
  80408c:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804090:	75 72                	jne    804104 <inet_aton+0x13f>
  804092:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804095:	3c 2f                	cmp    $0x2f,%al
  804097:	76 07                	jbe    8040a0 <inet_aton+0xdb>
  804099:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80409c:	3c 39                	cmp    $0x39,%al
  80409e:	76 1c                	jbe    8040bc <inet_aton+0xf7>
  8040a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040a3:	3c 60                	cmp    $0x60,%al
  8040a5:	76 07                	jbe    8040ae <inet_aton+0xe9>
  8040a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040aa:	3c 66                	cmp    $0x66,%al
  8040ac:	76 0e                	jbe    8040bc <inet_aton+0xf7>
  8040ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040b1:	3c 40                	cmp    $0x40,%al
  8040b3:	76 4f                	jbe    804104 <inet_aton+0x13f>
  8040b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040b8:	3c 46                	cmp    $0x46,%al
  8040ba:	77 48                	ja     804104 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8040bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bf:	c1 e0 04             	shl    $0x4,%eax
  8040c2:	89 c2                	mov    %eax,%edx
  8040c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040c7:	8d 48 0a             	lea    0xa(%rax),%ecx
  8040ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040cd:	3c 60                	cmp    $0x60,%al
  8040cf:	76 0e                	jbe    8040df <inet_aton+0x11a>
  8040d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040d4:	3c 7a                	cmp    $0x7a,%al
  8040d6:	77 07                	ja     8040df <inet_aton+0x11a>
  8040d8:	b8 61 00 00 00       	mov    $0x61,%eax
  8040dd:	eb 05                	jmp    8040e4 <inet_aton+0x11f>
  8040df:	b8 41 00 00 00       	mov    $0x41,%eax
  8040e4:	29 c1                	sub    %eax,%ecx
  8040e6:	89 c8                	mov    %ecx,%eax
  8040e8:	09 d0                	or     %edx,%eax
  8040ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8040ed:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8040f2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040f6:	0f b6 00             	movzbl (%rax),%eax
  8040f9:	0f be c0             	movsbl %al,%eax
  8040fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8040ff:	e9 52 ff ff ff       	jmpq   804056 <inet_aton+0x91>
    if (c == '.') {
  804104:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804108:	75 3d                	jne    804147 <inet_aton+0x182>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80410a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80410e:	48 83 c0 0c          	add    $0xc,%rax
  804112:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  804116:	72 0a                	jb     804122 <inet_aton+0x15d>
        return (0);
  804118:	b8 00 00 00 00       	mov    $0x0,%eax
  80411d:	e9 4e 01 00 00       	jmpq   804270 <inet_aton+0x2ab>
      *pp++ = val;
  804122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804126:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80412a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80412e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804131:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804133:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804138:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80413c:	0f b6 00             	movzbl (%rax),%eax
  80413f:	0f be c0             	movsbl %al,%eax
  804142:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804145:	eb 09                	jmp    804150 <inet_aton+0x18b>
    } else
      break;
  804147:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804148:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80414c:	74 43                	je     804191 <inet_aton+0x1cc>
  80414e:	eb 05                	jmp    804155 <inet_aton+0x190>
  }
  804150:	e9 95 fe ff ff       	jmpq   803fea <inet_aton+0x25>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804155:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804158:	3c 1f                	cmp    $0x1f,%al
  80415a:	76 2b                	jbe    804187 <inet_aton+0x1c2>
  80415c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80415f:	84 c0                	test   %al,%al
  804161:	78 24                	js     804187 <inet_aton+0x1c2>
  804163:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  804167:	74 28                	je     804191 <inet_aton+0x1cc>
  804169:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  80416d:	74 22                	je     804191 <inet_aton+0x1cc>
  80416f:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804173:	74 1c                	je     804191 <inet_aton+0x1cc>
  804175:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  804179:	74 16                	je     804191 <inet_aton+0x1cc>
  80417b:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  80417f:	74 10                	je     804191 <inet_aton+0x1cc>
  804181:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804185:	74 0a                	je     804191 <inet_aton+0x1cc>
    return (0);
  804187:	b8 00 00 00 00       	mov    $0x0,%eax
  80418c:	e9 df 00 00 00       	jmpq   804270 <inet_aton+0x2ab>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804191:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804195:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804199:	48 29 c2             	sub    %rax,%rdx
  80419c:	48 89 d0             	mov    %rdx,%rax
  80419f:	48 c1 f8 02          	sar    $0x2,%rax
  8041a3:	83 c0 01             	add    $0x1,%eax
  8041a6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  8041a9:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8041ad:	0f 87 98 00 00 00    	ja     80424b <inet_aton+0x286>
  8041b3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8041b6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8041bd:	00 
  8041be:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  8041c5:	00 00 00 
  8041c8:	48 01 d0             	add    %rdx,%rax
  8041cb:	48 8b 00             	mov    (%rax),%rax
  8041ce:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8041d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d5:	e9 96 00 00 00       	jmpq   804270 <inet_aton+0x2ab>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8041da:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8041e1:	76 0a                	jbe    8041ed <inet_aton+0x228>
      return (0);
  8041e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041e8:	e9 83 00 00 00       	jmpq   804270 <inet_aton+0x2ab>
    val |= parts[0] << 24;
  8041ed:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8041f0:	c1 e0 18             	shl    $0x18,%eax
  8041f3:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8041f6:	eb 53                	jmp    80424b <inet_aton+0x286>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8041f8:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8041ff:	76 07                	jbe    804208 <inet_aton+0x243>
      return (0);
  804201:	b8 00 00 00 00       	mov    $0x0,%eax
  804206:	eb 68                	jmp    804270 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804208:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80420b:	c1 e0 18             	shl    $0x18,%eax
  80420e:	89 c2                	mov    %eax,%edx
  804210:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804213:	c1 e0 10             	shl    $0x10,%eax
  804216:	09 d0                	or     %edx,%eax
  804218:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80421b:	eb 2e                	jmp    80424b <inet_aton+0x286>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80421d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  804224:	76 07                	jbe    80422d <inet_aton+0x268>
      return (0);
  804226:	b8 00 00 00 00       	mov    $0x0,%eax
  80422b:	eb 43                	jmp    804270 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80422d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804230:	c1 e0 18             	shl    $0x18,%eax
  804233:	89 c2                	mov    %eax,%edx
  804235:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804238:	c1 e0 10             	shl    $0x10,%eax
  80423b:	09 c2                	or     %eax,%edx
  80423d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804240:	c1 e0 08             	shl    $0x8,%eax
  804243:	09 d0                	or     %edx,%eax
  804245:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804248:	eb 01                	jmp    80424b <inet_aton+0x286>
    break;
  80424a:	90                   	nop
  }
  if (addr)
  80424b:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804250:	74 19                	je     80426b <inet_aton+0x2a6>
    addr->s_addr = htonl(val);
  804252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804255:	89 c7                	mov    %eax,%edi
  804257:	48 b8 e9 43 80 00 00 	movabs $0x8043e9,%rax
  80425e:	00 00 00 
  804261:	ff d0                	callq  *%rax
  804263:	89 c2                	mov    %eax,%edx
  804265:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804269:	89 10                	mov    %edx,(%rax)
  return (1);
  80426b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804270:	c9                   	leaveq 
  804271:	c3                   	retq   

0000000000804272 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804272:	55                   	push   %rbp
  804273:	48 89 e5             	mov    %rsp,%rbp
  804276:	48 83 ec 30          	sub    $0x30,%rsp
  80427a:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80427d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804280:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804283:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80428a:	00 00 00 
  80428d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804291:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804295:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804299:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80429d:	e9 e0 00 00 00       	jmpq   804382 <inet_ntoa+0x110>
    i = 0;
  8042a2:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8042a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042aa:	0f b6 08             	movzbl (%rax),%ecx
  8042ad:	0f b6 d1             	movzbl %cl,%edx
  8042b0:	89 d0                	mov    %edx,%eax
  8042b2:	c1 e0 02             	shl    $0x2,%eax
  8042b5:	01 d0                	add    %edx,%eax
  8042b7:	c1 e0 03             	shl    $0x3,%eax
  8042ba:	01 d0                	add    %edx,%eax
  8042bc:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8042c3:	01 d0                	add    %edx,%eax
  8042c5:	66 c1 e8 08          	shr    $0x8,%ax
  8042c9:	c0 e8 03             	shr    $0x3,%al
  8042cc:	88 45 ed             	mov    %al,-0x13(%rbp)
  8042cf:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8042d3:	89 d0                	mov    %edx,%eax
  8042d5:	c1 e0 02             	shl    $0x2,%eax
  8042d8:	01 d0                	add    %edx,%eax
  8042da:	01 c0                	add    %eax,%eax
  8042dc:	29 c1                	sub    %eax,%ecx
  8042de:	89 c8                	mov    %ecx,%eax
  8042e0:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8042e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e7:	0f b6 00             	movzbl (%rax),%eax
  8042ea:	0f b6 d0             	movzbl %al,%edx
  8042ed:	89 d0                	mov    %edx,%eax
  8042ef:	c1 e0 02             	shl    $0x2,%eax
  8042f2:	01 d0                	add    %edx,%eax
  8042f4:	c1 e0 03             	shl    $0x3,%eax
  8042f7:	01 d0                	add    %edx,%eax
  8042f9:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804300:	01 d0                	add    %edx,%eax
  804302:	66 c1 e8 08          	shr    $0x8,%ax
  804306:	89 c2                	mov    %eax,%edx
  804308:	c0 ea 03             	shr    $0x3,%dl
  80430b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80430f:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804311:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804315:	8d 50 01             	lea    0x1(%rax),%edx
  804318:	88 55 ee             	mov    %dl,-0x12(%rbp)
  80431b:	0f b6 c0             	movzbl %al,%eax
  80431e:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804322:	83 c2 30             	add    $0x30,%edx
  804325:	48 98                	cltq   
  804327:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80432b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432f:	0f b6 00             	movzbl (%rax),%eax
  804332:	84 c0                	test   %al,%al
  804334:	0f 85 6c ff ff ff    	jne    8042a6 <inet_ntoa+0x34>
    while(i--)
  80433a:	eb 1a                	jmp    804356 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  80433c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804340:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804344:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804348:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  80434c:	48 63 d2             	movslq %edx,%rdx
  80434f:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804354:	88 10                	mov    %dl,(%rax)
    while(i--)
  804356:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80435a:	8d 50 ff             	lea    -0x1(%rax),%edx
  80435d:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804360:	84 c0                	test   %al,%al
  804362:	75 d8                	jne    80433c <inet_ntoa+0xca>
    *rp++ = '.';
  804364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804368:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80436c:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804370:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804373:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804378:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80437c:	83 c0 01             	add    $0x1,%eax
  80437f:	88 45 ef             	mov    %al,-0x11(%rbp)
  804382:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804386:	0f 86 16 ff ff ff    	jbe    8042a2 <inet_ntoa+0x30>
  }
  *--rp = 0;
  80438c:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804395:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804398:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80439f:	00 00 00 
}
  8043a2:	c9                   	leaveq 
  8043a3:	c3                   	retq   

00000000008043a4 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8043a4:	55                   	push   %rbp
  8043a5:	48 89 e5             	mov    %rsp,%rbp
  8043a8:	48 83 ec 08          	sub    $0x8,%rsp
  8043ac:	89 f8                	mov    %edi,%eax
  8043ae:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8043b2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8043b6:	c1 e0 08             	shl    $0x8,%eax
  8043b9:	89 c2                	mov    %eax,%edx
  8043bb:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8043bf:	66 c1 e8 08          	shr    $0x8,%ax
  8043c3:	09 d0                	or     %edx,%eax
}
  8043c5:	c9                   	leaveq 
  8043c6:	c3                   	retq   

00000000008043c7 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8043c7:	55                   	push   %rbp
  8043c8:	48 89 e5             	mov    %rsp,%rbp
  8043cb:	48 83 ec 08          	sub    $0x8,%rsp
  8043cf:	89 f8                	mov    %edi,%eax
  8043d1:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8043d5:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8043d9:	89 c7                	mov    %eax,%edi
  8043db:	48 b8 a4 43 80 00 00 	movabs $0x8043a4,%rax
  8043e2:	00 00 00 
  8043e5:	ff d0                	callq  *%rax
}
  8043e7:	c9                   	leaveq 
  8043e8:	c3                   	retq   

00000000008043e9 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8043e9:	55                   	push   %rbp
  8043ea:	48 89 e5             	mov    %rsp,%rbp
  8043ed:	48 83 ec 08          	sub    $0x8,%rsp
  8043f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8043f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f7:	c1 e0 18             	shl    $0x18,%eax
  8043fa:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8043fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ff:	25 00 ff 00 00       	and    $0xff00,%eax
  804404:	c1 e0 08             	shl    $0x8,%eax
  return ((n & 0xff) << 24) |
  804407:	09 c2                	or     %eax,%edx
    ((n & 0xff0000UL) >> 8) |
  804409:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80440c:	25 00 00 ff 00       	and    $0xff0000,%eax
  804411:	48 c1 e8 08          	shr    $0x8,%rax
  return ((n & 0xff) << 24) |
  804415:	09 c2                	or     %eax,%edx
    ((n & 0xff000000UL) >> 24);
  804417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441a:	c1 e8 18             	shr    $0x18,%eax
  return ((n & 0xff) << 24) |
  80441d:	09 d0                	or     %edx,%eax
}
  80441f:	c9                   	leaveq 
  804420:	c3                   	retq   

0000000000804421 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804421:	55                   	push   %rbp
  804422:	48 89 e5             	mov    %rsp,%rbp
  804425:	48 83 ec 08          	sub    $0x8,%rsp
  804429:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80442c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442f:	89 c7                	mov    %eax,%edi
  804431:	48 b8 e9 43 80 00 00 	movabs $0x8043e9,%rax
  804438:	00 00 00 
  80443b:	ff d0                	callq  *%rax
}
  80443d:	c9                   	leaveq 
  80443e:	c3                   	retq   
