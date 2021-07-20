
vmm/guest/obj/user/httpd:     formato del fichero elf64-x86-64


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
  80003c:	e8 fa 08 00 00       	callq  80093b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
	{404, "Not Found"},
};

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
  800056:	48 bf 3c 50 80 00 00 	movabs $0x80503c,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 9b 09 80 00 00 	movabs $0x80099b,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <req_free>:

static void
req_free(struct http_request *req)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 10          	sub    $0x10,%rsp
  800087:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80008f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800093:	48 89 c7             	mov    %rax,%rdi
  800096:	48 b8 64 3e 80 00 00 	movabs $0x803e64,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	callq  *%rax
	free(req->version);
  8000a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000aa:	48 89 c7             	mov    %rax,%rdi
  8000ad:	48 b8 64 3e 80 00 00 	movabs $0x803e64,%rax
  8000b4:	00 00 00 
  8000b7:	ff d0                	callq  *%rax
}
  8000b9:	c9                   	leaveq 
  8000ba:	c3                   	retq   

00000000008000bb <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bb:	55                   	push   %rbp
  8000bc:	48 89 e5             	mov    %rsp,%rbp
  8000bf:	48 83 ec 20          	sub    $0x20,%rsp
  8000c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d1:	00 00 00 
  8000d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000d8:	eb 12                	jmp    8000ec <send_header+0x31>
		if (h->code == code)
  8000da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000de:	8b 00                	mov    (%rax),%eax
  8000e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e3:	75 02                	jne    8000e7 <send_header+0x2c>
			break;
  8000e5:	eb 1c                	jmp    800103 <send_header+0x48>
		h++;
  8000e7:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	8b 00                	mov    (%rax),%eax
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 0d                	je     800103 <send_header+0x48>
  8000f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fe:	48 85 c0             	test   %rax,%rax
  800101:	75 d7                	jne    8000da <send_header+0x1f>
	}

	if (h->code == 0)
  800103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800107:	8b 00                	mov    (%rax),%eax
  800109:	85 c0                	test   %eax,%eax
  80010b:	75 07                	jne    800114 <send_header+0x59>
		return -1;
  80010d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800112:	eb 5f                	jmp    800173 <send_header+0xb8>

	int len = strlen(h->header);
  800114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800118:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011c:	48 89 c7             	mov    %rax,%rdi
  80011f:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
  80012b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  80012e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800131:	48 63 d0             	movslq %eax,%rdx
  800134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800138:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800140:	8b 00                	mov    (%rax),%eax
  800142:	48 89 ce             	mov    %rcx,%rsi
  800145:	89 c7                	mov    %eax,%edi
  800147:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
  800153:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800156:	74 16                	je     80016e <send_header+0xb3>
		die("Failed to send bytes to client");
  800158:	48 bf 40 50 80 00 00 	movabs $0x805040,%rdi
  80015f:	00 00 00 
  800162:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
	}

	return 0;
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800173:	c9                   	leaveq 
  800174:	c3                   	retq   

0000000000800175 <send_data>:

static int
send_data(struct http_request *req, int fd)
{
  800175:	55                   	push   %rbp
  800176:	48 89 e5             	mov    %rsp,%rbp
  800179:	48 83 ec 10          	sub    $0x10,%rsp
  80017d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800181:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// LAB 6: Your code here.
	panic("send_data not implemented");
  800184:	48 ba 5f 50 80 00 00 	movabs $0x80505f,%rdx
  80018b:	00 00 00 
  80018e:	be 50 00 00 00       	mov    $0x50,%esi
  800193:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  80019a:	00 00 00 
  80019d:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a2:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  8001a9:	00 00 00 
  8001ac:	ff d1                	callq  *%rcx

00000000008001ae <send_size>:
}

static int
send_size(struct http_request *req, off_t size)
{
  8001ae:	55                   	push   %rbp
  8001af:	48 89 e5             	mov    %rsp,%rbp
  8001b2:	48 83 ec 60          	sub    $0x60,%rsp
  8001b6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8001ba:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  8001bd:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8001c0:	48 63 d0             	movslq %eax,%rdx
  8001c3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8001c7:	48 89 d1             	mov    %rdx,%rcx
  8001ca:	48 ba 86 50 80 00 00 	movabs $0x805086,%rdx
  8001d1:	00 00 00 
  8001d4:	be 40 00 00 00       	mov    $0x40,%esi
  8001d9:	48 89 c7             	mov    %rax,%rdi
  8001dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e1:	49 b8 44 16 80 00 00 	movabs $0x801644,%r8
  8001e8:	00 00 00 
  8001eb:	41 ff d0             	callq  *%r8
  8001ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  8001f1:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  8001f5:	7e 2a                	jle    800221 <send_size+0x73>
		panic("buffer too small!");
  8001f7:	48 ba 9c 50 80 00 00 	movabs $0x80509c,%rdx
  8001fe:	00 00 00 
  800201:	be 5b 00 00 00       	mov    $0x5b,%esi
  800206:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  80020d:	00 00 00 
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  80021c:	00 00 00 
  80021f:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	48 63 d0             	movslq %eax,%rdx
  800227:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  800231:	48 89 ce             	mov    %rcx,%rsi
  800234:	89 c7                	mov    %eax,%edi
  800236:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
  800242:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800245:	74 07                	je     80024e <send_size+0xa0>
		return -1;
  800247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80024c:	eb 05                	jmp    800253 <send_size+0xa5>

	return 0;
  80024e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800253:	c9                   	leaveq 
  800254:	c3                   	retq   

0000000000800255 <mime_type>:

static const char*
mime_type(const char *file)
{
  800255:	55                   	push   %rbp
  800256:	48 89 e5             	mov    %rsp,%rbp
  800259:	48 83 ec 08          	sub    $0x8,%rsp
  80025d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  800261:	48 b8 ae 50 80 00 00 	movabs $0x8050ae,%rax
  800268:	00 00 00 
}
  80026b:	c9                   	leaveq 
  80026c:	c3                   	retq   

000000000080026d <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  80026d:	55                   	push   %rbp
  80026e:	48 89 e5             	mov    %rsp,%rbp
  800271:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800278:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  80027f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800286:	48 8b 40 08          	mov    0x8(%rax),%rax
  80028a:	48 89 c7             	mov    %rax,%rdi
  80028d:	48 b8 55 02 80 00 00 	movabs $0x800255,%rax
  800294:	00 00 00 
  800297:	ff d0                	callq  *%rax
  800299:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  80029d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8002a2:	75 0a                	jne    8002ae <send_content_type+0x41>
		return -1;
  8002a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8002a9:	e9 9d 00 00 00       	jmpq   80034b <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8002b2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8002b9:	48 89 d1             	mov    %rdx,%rcx
  8002bc:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  8002c3:	00 00 00 
  8002c6:	be 80 00 00 00       	mov    $0x80,%esi
  8002cb:	48 89 c7             	mov    %rax,%rdi
  8002ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d3:	49 b8 44 16 80 00 00 	movabs $0x801644,%r8
  8002da:	00 00 00 
  8002dd:	41 ff d0             	callq  *%r8
  8002e0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  8002e3:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8002e7:	7e 2a                	jle    800313 <send_content_type+0xa6>
		panic("buffer too small!");
  8002e9:	48 ba 9c 50 80 00 00 	movabs $0x80509c,%rdx
  8002f0:	00 00 00 
  8002f3:	be 77 00 00 00       	mov    $0x77,%esi
  8002f8:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  8002ff:	00 00 00 
  800302:	b8 00 00 00 00       	mov    $0x0,%eax
  800307:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  80030e:	00 00 00 
  800311:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800313:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800316:	48 63 d0             	movslq %eax,%rdx
  800319:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800320:	8b 00                	mov    (%rax),%eax
  800322:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  800329:	48 89 ce             	mov    %rcx,%rsi
  80032c:	89 c7                	mov    %eax,%edi
  80032e:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  800335:	00 00 00 
  800338:	ff d0                	callq  *%rax
  80033a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80033d:	74 07                	je     800346 <send_content_type+0xd9>
		return -1;
  80033f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800344:	eb 05                	jmp    80034b <send_content_type+0xde>

	return 0;
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80034b:	c9                   	leaveq 
  80034c:	c3                   	retq   

000000000080034d <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  80034d:	55                   	push   %rbp
  80034e:	48 89 e5             	mov    %rsp,%rbp
  800351:	48 83 ec 20          	sub    $0x20,%rsp
  800355:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  800359:	48 b8 cb 50 80 00 00 	movabs $0x8050cb,%rax
  800360:	00 00 00 
  800363:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  800367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80036b:	48 89 c7             	mov    %rax,%rdi
  80036e:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
  80037a:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  80037d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800380:	48 63 d0             	movslq %eax,%rdx
  800383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800387:	8b 00                	mov    (%rax),%eax
  800389:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80038d:	48 89 ce             	mov    %rcx,%rsi
  800390:	89 c7                	mov    %eax,%edi
  800392:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
  80039e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8003a1:	74 07                	je     8003aa <send_header_fin+0x5d>
		return -1;
  8003a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003a8:	eb 05                	jmp    8003af <send_header_fin+0x62>

	return 0;
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003af:	c9                   	leaveq 
  8003b0:	c3                   	retq   

00000000008003b1 <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	48 83 ec 30          	sub    $0x30,%rsp
  8003b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8003bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  8003c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003c6:	75 0a                	jne    8003d2 <http_request_parse+0x21>
		return -1;
  8003c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003cd:	e9 5d 01 00 00       	jmpq   80052f <http_request_parse+0x17e>

	if (strncmp(request, "GET ", 4) != 0)
  8003d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8003d6:	ba 04 00 00 00       	mov    $0x4,%edx
  8003db:	48 be ce 50 80 00 00 	movabs $0x8050ce,%rsi
  8003e2:	00 00 00 
  8003e5:	48 89 c7             	mov    %rax,%rdi
  8003e8:	48 b8 46 19 80 00 00 	movabs $0x801946,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	74 0a                	je     800402 <http_request_parse+0x51>
		return -E_BAD_REQ;
  8003f8:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  8003fd:	e9 2d 01 00 00       	jmpq   80052f <http_request_parse+0x17e>

	// skip GET
	request += 4;
  800402:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  800407:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80040b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  80040f:	eb 05                	jmp    800416 <http_request_parse+0x65>
		request++;
  800411:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	while (*request && *request != ' ')
  800416:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80041a:	0f b6 00             	movzbl (%rax),%eax
  80041d:	84 c0                	test   %al,%al
  80041f:	74 0b                	je     80042c <http_request_parse+0x7b>
  800421:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800425:	0f b6 00             	movzbl (%rax),%eax
  800428:	3c 20                	cmp    $0x20,%al
  80042a:	75 e5                	jne    800411 <http_request_parse+0x60>
	url_len = request - url;
  80042c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800434:	48 29 c2             	sub    %rax,%rdx
  800437:	48 89 d0             	mov    %rdx,%rax
  80043a:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  80043d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800440:	83 c0 01             	add    $0x1,%eax
  800443:	48 98                	cltq   
  800445:	48 89 c7             	mov    %rax,%rdi
  800448:	48 b8 f2 3a 80 00 00 	movabs $0x803af2,%rax
  80044f:	00 00 00 
  800452:	ff d0                	callq  *%rax
  800454:	48 89 c2             	mov    %rax,%rdx
  800457:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80045b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(req->url, url, url_len);
  80045f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800462:	48 63 d0             	movslq %eax,%rdx
  800465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800469:	48 8b 40 08          	mov    0x8(%rax),%rax
  80046d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800471:	48 89 ce             	mov    %rcx,%rsi
  800474:	48 89 c7             	mov    %rax,%rdi
  800477:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  800483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800487:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80048b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80048e:	48 98                	cltq   
  800490:	48 01 d0             	add    %rdx,%rax
  800493:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  800496:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  80049b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80049f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  8004a3:	eb 05                	jmp    8004aa <http_request_parse+0xf9>
		request++;
  8004a5:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	while (*request && *request != '\n')
  8004aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004ae:	0f b6 00             	movzbl (%rax),%eax
  8004b1:	84 c0                	test   %al,%al
  8004b3:	74 0b                	je     8004c0 <http_request_parse+0x10f>
  8004b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004b9:	0f b6 00             	movzbl (%rax),%eax
  8004bc:	3c 0a                	cmp    $0xa,%al
  8004be:	75 e5                	jne    8004a5 <http_request_parse+0xf4>
	version_len = request - version;
  8004c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c8:	48 29 c2             	sub    %rax,%rdx
  8004cb:	48 89 d0             	mov    %rdx,%rax
  8004ce:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  8004d1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004d4:	83 c0 01             	add    $0x1,%eax
  8004d7:	48 98                	cltq   
  8004d9:	48 89 c7             	mov    %rax,%rdi
  8004dc:	48 b8 f2 3a 80 00 00 	movabs $0x803af2,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax
  8004e8:	48 89 c2             	mov    %rax,%rdx
  8004eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	memmove(req->version, version, version_len);
  8004f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004f6:	48 63 d0             	movslq %eax,%rdx
  8004f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004fd:	48 8b 40 10          	mov    0x10(%rax),%rax
  800501:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800505:	48 89 ce             	mov    %rcx,%rsi
  800508:	48 89 c7             	mov    %rax,%rdi
  80050b:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  800512:	00 00 00 
  800515:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  800517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80051f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800522:	48 98                	cltq   
  800524:	48 01 d0             	add    %rdx,%rax
  800527:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80052f:	c9                   	leaveq 
  800530:	c3                   	retq   

0000000000800531 <send_error>:

static int
send_error(struct http_request *req, int code)
{
  800531:	55                   	push   %rbp
  800532:	48 89 e5             	mov    %rsp,%rbp
  800535:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80053c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  800543:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  800549:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800550:	00 00 00 
  800553:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  800557:	eb 15                	jmp    80056e <send_error+0x3d>
		if (e->code == code)
  800559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  800565:	75 02                	jne    800569 <send_error+0x38>
			break;
  800567:	eb 1c                	jmp    800585 <send_error+0x54>
		e++;
  800569:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  80056e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	85 c0                	test   %eax,%eax
  800576:	74 0d                	je     800585 <send_error+0x54>
  800578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800580:	48 85 c0             	test   %rax,%rax
  800583:	75 d4                	jne    800559 <send_error+0x28>
	}

	if (e->code == 0)
  800585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800589:	8b 00                	mov    (%rax),%eax
  80058b:	85 c0                	test   %eax,%eax
  80058d:	75 0a                	jne    800599 <send_error+0x68>
		return -1;
  80058f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800594:	e9 93 00 00 00       	jmpq   80062c <send_error+0xfb>

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80059d:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005a5:	8b 38                	mov    (%rax),%edi
  8005a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ab:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8005af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b3:	8b 10                	mov    (%rax),%edx
  8005b5:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  8005bc:	48 83 ec 08          	sub    $0x8,%rsp
  8005c0:	51                   	push   %rcx
  8005c1:	41 89 f9             	mov    %edi,%r9d
  8005c4:	49 89 f0             	mov    %rsi,%r8
  8005c7:	89 d1                	mov    %edx,%ecx
  8005c9:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8005d0:	00 00 00 
  8005d3:	be 00 02 00 00       	mov    $0x200,%esi
  8005d8:	48 89 c7             	mov    %rax,%rdi
  8005db:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e0:	49 ba 44 16 80 00 00 	movabs $0x801644,%r10
  8005e7:	00 00 00 
  8005ea:	41 ff d2             	callq  *%r10
  8005ed:	48 83 c4 10          	add    $0x10,%rsp
  8005f1:	89 45 f4             	mov    %eax,-0xc(%rbp)
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8005f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005f7:	48 63 d0             	movslq %eax,%rdx
  8005fa:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  800601:	8b 00                	mov    (%rax),%eax
  800603:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80060a:	48 89 ce             	mov    %rcx,%rsi
  80060d:	89 c7                	mov    %eax,%edi
  80060f:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
  80061b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80061e:	74 07                	je     800627 <send_error+0xf6>
		return -1;
  800620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800625:	eb 05                	jmp    80062c <send_error+0xfb>

	return 0;
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80062c:	c9                   	leaveq 
  80062d:	c3                   	retq   

000000000080062e <send_file>:

static int
send_file(struct http_request *req)
{
  80062e:	55                   	push   %rbp
  80062f:	48 89 e5             	mov    %rsp,%rbp
  800632:	48 83 ec 20          	sub    $0x20,%rsp
  800636:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	off_t file_size = -1;
  80063a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// if the file does not exist, send a 404 error using send_error
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	panic("send_file not implemented");
  800641:	48 ba 53 51 80 00 00 	movabs $0x805153,%rdx
  800648:	00 00 00 
  80064b:	be e2 00 00 00       	mov    $0xe2,%esi
  800650:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  800657:	00 00 00 
  80065a:	b8 00 00 00 00       	mov    $0x0,%eax
  80065f:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  800666:	00 00 00 
  800669:	ff d1                	callq  *%rcx

000000000080066b <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  80066b:	55                   	push   %rbp
  80066c:	48 89 e5             	mov    %rsp,%rbp
  80066f:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  800676:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  80067c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  800683:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800687:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80068b:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  800692:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  800698:	ba 00 02 00 00       	mov    $0x200,%edx
  80069d:	48 89 ce             	mov    %rcx,%rsi
  8006a0:	89 c7                	mov    %eax,%edi
  8006a2:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  8006a9:	00 00 00 
  8006ac:	ff d0                	callq  *%rax
  8006ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8006b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006b5:	79 2a                	jns    8006e1 <handle_client+0x76>
			panic("failed to read");
  8006b7:	48 ba 6d 51 80 00 00 	movabs $0x80516d,%rdx
  8006be:	00 00 00 
  8006c1:	be 04 01 00 00       	mov    $0x104,%esi
  8006c6:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  8006cd:	00 00 00 
  8006d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d5:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  8006dc:	00 00 00 
  8006df:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  8006e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e5:	ba 08 00 00 00       	mov    $0x8,%edx
  8006ea:	be 00 00 00 00       	mov    $0x0,%esi
  8006ef:	48 89 c7             	mov    %rax,%rdi
  8006f2:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  8006f9:	00 00 00 
  8006fc:	ff d0                	callq  *%rax

		req->sock = sock;
  8006fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800702:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  800708:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  80070a:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  800711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800715:	48 89 d6             	mov    %rdx,%rsi
  800718:	48 89 c7             	mov    %rax,%rdi
  80071b:	48 b8 b1 03 80 00 00 	movabs $0x8003b1,%rax
  800722:	00 00 00 
  800725:	ff d0                	callq  *%rax
  800727:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  80072a:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  800731:	75 1a                	jne    80074d <handle_client+0xe2>
			send_error(req, 400);
  800733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800737:	be 90 01 00 00       	mov    $0x190,%esi
  80073c:	48 89 c7             	mov    %rax,%rdi
  80073f:	48 b8 31 05 80 00 00 	movabs $0x800531,%rax
  800746:	00 00 00 
  800749:	ff d0                	callq  *%rax
  80074b:	eb 43                	jmp    800790 <handle_client+0x125>
		else if (r < 0)
  80074d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800751:	79 2a                	jns    80077d <handle_client+0x112>
			panic("parse failed");
  800753:	48 ba 7c 51 80 00 00 	movabs $0x80517c,%rdx
  80075a:	00 00 00 
  80075d:	be 0e 01 00 00       	mov    $0x10e,%esi
  800762:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  800769:	00 00 00 
  80076c:	b8 00 00 00 00       	mov    $0x0,%eax
  800771:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  800778:	00 00 00 
  80077b:	ff d1                	callq  *%rcx
		else
			send_file(req);
  80077d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800781:	48 89 c7             	mov    %rax,%rdi
  800784:	48 b8 2e 06 80 00 00 	movabs $0x80062e,%rax
  80078b:	00 00 00 
  80078e:	ff d0                	callq  *%rax

		req_free(req);
  800790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800794:	48 89 c7             	mov    %rax,%rdi
  800797:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  80079e:	00 00 00 
  8007a1:	ff d0                	callq  *%rax

		// no keep alive
		break;
  8007a3:	90                   	nop
	}

	close(sock);
  8007a4:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8007aa:	89 c7                	mov    %eax,%edi
  8007ac:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  8007b3:	00 00 00 
  8007b6:	ff d0                	callq  *%rax
}
  8007b8:	c9                   	leaveq 
  8007b9:	c3                   	retq   

00000000008007ba <umain>:

void
umain(int argc, char **argv)
{
  8007ba:	55                   	push   %rbp
  8007bb:	48 89 e5             	mov    %rsp,%rbp
  8007be:	48 83 ec 50          	sub    $0x50,%rsp
  8007c2:	89 7d bc             	mov    %edi,-0x44(%rbp)
  8007c5:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8007c9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8007d0:	00 00 00 
  8007d3:	48 b9 89 51 80 00 00 	movabs $0x805189,%rcx
  8007da:	00 00 00 
  8007dd:	48 89 08             	mov    %rcx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8007e0:	ba 06 00 00 00       	mov    $0x6,%edx
  8007e5:	be 01 00 00 00       	mov    $0x1,%esi
  8007ea:	bf 02 00 00 00       	mov    $0x2,%edi
  8007ef:	48 b8 bb 35 80 00 00 	movabs $0x8035bb,%rax
  8007f6:	00 00 00 
  8007f9:	ff d0                	callq  *%rax
  8007fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800802:	79 16                	jns    80081a <umain+0x60>
		die("Failed to create socket");
  800804:	48 bf 90 51 80 00 00 	movabs $0x805190,%rdi
  80080b:	00 00 00 
  80080e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800815:	00 00 00 
  800818:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  80081a:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  80081e:	ba 10 00 00 00       	mov    $0x10,%edx
  800823:	be 00 00 00 00       	mov    $0x0,%esi
  800828:	48 89 c7             	mov    %rax,%rdi
  80082b:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  800832:	00 00 00 
  800835:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  800837:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  80083b:	bf 00 00 00 00       	mov    $0x0,%edi
  800840:	48 b8 6c 4f 80 00 00 	movabs $0x804f6c,%rax
  800847:	00 00 00 
  80084a:	ff d0                	callq  *%rax
  80084c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	server.sin_port = htons(PORT);			// server port
  80084f:	bf 50 00 00 00       	mov    $0x50,%edi
  800854:	48 b8 27 4f 80 00 00 	movabs $0x804f27,%rax
  80085b:	00 00 00 
  80085e:	ff d0                	callq  *%rax
  800860:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800864:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800868:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80086b:	ba 10 00 00 00       	mov    $0x10,%edx
  800870:	48 89 ce             	mov    %rcx,%rsi
  800873:	89 c7                	mov    %eax,%edi
  800875:	48 b8 ab 33 80 00 00 	movabs $0x8033ab,%rax
  80087c:	00 00 00 
  80087f:	ff d0                	callq  *%rax
  800881:	85 c0                	test   %eax,%eax
  800883:	79 16                	jns    80089b <umain+0xe1>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800885:	48 bf a8 51 80 00 00 	movabs $0x8051a8,%rdi
  80088c:	00 00 00 
  80088f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800896:	00 00 00 
  800899:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80089b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80089e:	be 05 00 00 00       	mov    $0x5,%esi
  8008a3:	89 c7                	mov    %eax,%edi
  8008a5:	48 b8 ce 34 80 00 00 	movabs $0x8034ce,%rax
  8008ac:	00 00 00 
  8008af:	ff d0                	callq  *%rax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	79 16                	jns    8008cb <umain+0x111>
		die("Failed to listen on server socket");
  8008b5:	48 bf d0 51 80 00 00 	movabs $0x8051d0,%rdi
  8008bc:	00 00 00 
  8008bf:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008c6:	00 00 00 
  8008c9:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  8008cb:	48 bf f8 51 80 00 00 	movabs $0x8051f8,%rdi
  8008d2:	00 00 00 
  8008d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008da:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  8008e1:	00 00 00 
  8008e4:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  8008e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8008ed:	48 8d 55 cc          	lea    -0x34(%rbp),%rdx
  8008f1:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8008f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008f8:	48 89 ce             	mov    %rcx,%rsi
  8008fb:	89 c7                	mov    %eax,%edi
  8008fd:	48 b8 3c 33 80 00 00 	movabs $0x80333c,%rax
  800904:	00 00 00 
  800907:	ff d0                	callq  *%rax
  800909:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80090c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800910:	79 16                	jns    800928 <umain+0x16e>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800912:	48 bf 20 52 80 00 00 	movabs $0x805220,%rdi
  800919:	00 00 00 
  80091c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800923:	00 00 00 
  800926:	ff d0                	callq  *%rax
		}
		handle_client(clientsock);
  800928:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80092b:	89 c7                	mov    %eax,%edi
  80092d:	48 b8 6b 06 80 00 00 	movabs $0x80066b,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
	}
  800939:	eb ab                	jmp    8008e6 <umain+0x12c>

000000000080093b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80093b:	55                   	push   %rbp
  80093c:	48 89 e5             	mov    %rsp,%rbp
  80093f:	48 83 ec 10          	sub    $0x10,%rsp
  800943:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800946:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80094a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800951:	00 00 00 
  800954:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80095b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80095f:	7e 14                	jle    800975 <libmain+0x3a>
		binaryname = argv[0];
  800961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800965:	48 8b 10             	mov    (%rax),%rdx
  800968:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80096f:	00 00 00 
  800972:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800975:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80097c:	48 89 d6             	mov    %rdx,%rsi
  80097f:	89 c7                	mov    %eax,%edi
  800981:	48 b8 ba 07 80 00 00 	movabs $0x8007ba,%rax
  800988:	00 00 00 
  80098b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80098d:	48 b8 9b 09 80 00 00 	movabs $0x80099b,%rax
  800994:	00 00 00 
  800997:	ff d0                	callq  *%rax
}
  800999:	c9                   	leaveq 
  80099a:	c3                   	retq   

000000000080099b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80099b:	55                   	push   %rbp
  80099c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80099f:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  8009a6:	00 00 00 
  8009a9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8009ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b0:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  8009b7:	00 00 00 
  8009ba:	ff d0                	callq  *%rax
}
  8009bc:	5d                   	pop    %rbp
  8009bd:	c3                   	retq   

00000000008009be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8009be:	55                   	push   %rbp
  8009bf:	48 89 e5             	mov    %rsp,%rbp
  8009c2:	53                   	push   %rbx
  8009c3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8009ca:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8009d1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8009d7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8009de:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8009e5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8009ec:	84 c0                	test   %al,%al
  8009ee:	74 23                	je     800a13 <_panic+0x55>
  8009f0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8009f7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8009fb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8009ff:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800a03:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800a07:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800a0b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800a0f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800a13:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800a1a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800a21:	00 00 00 
  800a24:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800a2b:	00 00 00 
  800a2e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a32:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800a39:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800a40:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a47:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800a4e:	00 00 00 
  800a51:	48 8b 18             	mov    (%rax),%rbx
  800a54:	48 b8 46 20 80 00 00 	movabs $0x802046,%rax
  800a5b:	00 00 00 
  800a5e:	ff d0                	callq  *%rax
  800a60:	89 c6                	mov    %eax,%esi
  800a62:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800a68:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800a6f:	41 89 d0             	mov    %edx,%r8d
  800a72:	48 89 c1             	mov    %rax,%rcx
  800a75:	48 89 da             	mov    %rbx,%rdx
  800a78:	48 bf 50 52 80 00 00 	movabs $0x805250,%rdi
  800a7f:	00 00 00 
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
  800a87:	49 b9 f7 0b 80 00 00 	movabs $0x800bf7,%r9
  800a8e:	00 00 00 
  800a91:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a94:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800a9b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800aa2:	48 89 d6             	mov    %rdx,%rsi
  800aa5:	48 89 c7             	mov    %rax,%rdi
  800aa8:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax
	cprintf("\n");
  800ab4:	48 bf 73 52 80 00 00 	movabs $0x805273,%rdi
  800abb:	00 00 00 
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac3:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  800aca:	00 00 00 
  800acd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800acf:	cc                   	int3   
  800ad0:	eb fd                	jmp    800acf <_panic+0x111>

0000000000800ad2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800ad2:	55                   	push   %rbp
  800ad3:	48 89 e5             	mov    %rsp,%rbp
  800ad6:	48 83 ec 10          	sub    $0x10,%rsp
  800ada:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800add:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ae5:	8b 00                	mov    (%rax),%eax
  800ae7:	8d 48 01             	lea    0x1(%rax),%ecx
  800aea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aee:	89 0a                	mov    %ecx,(%rdx)
  800af0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800af3:	89 d1                	mov    %edx,%ecx
  800af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800af9:	48 98                	cltq   
  800afb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800aff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b03:	8b 00                	mov    (%rax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b10:	8b 00                	mov    (%rax),%eax
  800b12:	48 98                	cltq   
  800b14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b18:	48 83 c2 08          	add    $0x8,%rdx
  800b1c:	48 89 c6             	mov    %rax,%rsi
  800b1f:	48 89 d7             	mov    %rdx,%rdi
  800b22:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  800b29:	00 00 00 
  800b2c:	ff d0                	callq  *%rax
        b->idx = 0;
  800b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800b38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b3c:	8b 40 04             	mov    0x4(%rax),%eax
  800b3f:	8d 50 01             	lea    0x1(%rax),%edx
  800b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b46:	89 50 04             	mov    %edx,0x4(%rax)
}
  800b49:	c9                   	leaveq 
  800b4a:	c3                   	retq   

0000000000800b4b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800b4b:	55                   	push   %rbp
  800b4c:	48 89 e5             	mov    %rsp,%rbp
  800b4f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800b56:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800b5d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800b64:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800b6b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800b72:	48 8b 0a             	mov    (%rdx),%rcx
  800b75:	48 89 08             	mov    %rcx,(%rax)
  800b78:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b7c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b84:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800b88:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800b8f:	00 00 00 
    b.cnt = 0;
  800b92:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800b99:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800b9c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ba3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800baa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800bb1:	48 89 c6             	mov    %rax,%rsi
  800bb4:	48 bf d2 0a 80 00 00 	movabs $0x800ad2,%rdi
  800bbb:	00 00 00 
  800bbe:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  800bc5:	00 00 00 
  800bc8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800bca:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800bd0:	48 98                	cltq   
  800bd2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800bd9:	48 83 c2 08          	add    $0x8,%rdx
  800bdd:	48 89 c6             	mov    %rax,%rsi
  800be0:	48 89 d7             	mov    %rdx,%rdi
  800be3:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  800bea:	00 00 00 
  800bed:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800bef:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800bf5:	c9                   	leaveq 
  800bf6:	c3                   	retq   

0000000000800bf7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800bf7:	55                   	push   %rbp
  800bf8:	48 89 e5             	mov    %rsp,%rbp
  800bfb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800c02:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800c09:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800c10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c25:	84 c0                	test   %al,%al
  800c27:	74 20                	je     800c49 <cprintf+0x52>
  800c29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c49:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800c50:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800c57:	00 00 00 
  800c5a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800c61:	00 00 00 
  800c64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c68:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800c6f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c76:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800c7d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800c84:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800c8b:	48 8b 0a             	mov    (%rdx),%rcx
  800c8e:	48 89 08             	mov    %rcx,(%rax)
  800c91:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c95:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c99:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c9d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800ca1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800ca8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800caf:	48 89 d6             	mov    %rdx,%rsi
  800cb2:	48 89 c7             	mov    %rax,%rdi
  800cb5:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	callq  *%rax
  800cc1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800cc7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ccd:	c9                   	leaveq 
  800cce:	c3                   	retq   

0000000000800ccf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ccf:	55                   	push   %rbp
  800cd0:	48 89 e5             	mov    %rsp,%rbp
  800cd3:	48 83 ec 30          	sub    $0x30,%rsp
  800cd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800cdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800cdf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ce3:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800ce6:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800cea:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800cf1:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800cf5:	77 42                	ja     800d39 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cf7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800cfa:	8d 78 ff             	lea    -0x1(%rax),%edi
  800cfd:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	48 f7 f6             	div    %rsi
  800d0c:	49 89 c2             	mov    %rax,%r10
  800d0f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800d12:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800d15:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800d19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800d1d:	41 89 c9             	mov    %ecx,%r9d
  800d20:	41 89 f8             	mov    %edi,%r8d
  800d23:	89 d1                	mov    %edx,%ecx
  800d25:	4c 89 d2             	mov    %r10,%rdx
  800d28:	48 89 c7             	mov    %rax,%rdi
  800d2b:	48 b8 cf 0c 80 00 00 	movabs $0x800ccf,%rax
  800d32:	00 00 00 
  800d35:	ff d0                	callq  *%rax
  800d37:	eb 1e                	jmp    800d57 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d39:	eb 12                	jmp    800d4d <printnum+0x7e>
			putch(padc, putdat);
  800d3b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800d3f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800d46:	48 89 ce             	mov    %rcx,%rsi
  800d49:	89 d7                	mov    %edx,%edi
  800d4b:	ff d0                	callq  *%rax
		while (--width > 0)
  800d4d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800d51:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800d55:	7f e4                	jg     800d3b <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d57:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d63:	48 f7 f1             	div    %rcx
  800d66:	48 b8 70 54 80 00 00 	movabs $0x805470,%rax
  800d6d:	00 00 00 
  800d70:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800d74:	0f be d0             	movsbl %al,%edx
  800d77:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800d7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800d7f:	48 89 ce             	mov    %rcx,%rsi
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	ff d0                	callq  *%rax
}
  800d86:	c9                   	leaveq 
  800d87:	c3                   	retq   

0000000000800d88 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d88:	55                   	push   %rbp
  800d89:	48 89 e5             	mov    %rsp,%rbp
  800d8c:	48 83 ec 20          	sub    $0x20,%rsp
  800d90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d94:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800d97:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800d9b:	7e 4f                	jle    800dec <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800d9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da1:	8b 00                	mov    (%rax),%eax
  800da3:	83 f8 30             	cmp    $0x30,%eax
  800da6:	73 24                	jae    800dcc <getuint+0x44>
  800da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db4:	8b 00                	mov    (%rax),%eax
  800db6:	89 c0                	mov    %eax,%eax
  800db8:	48 01 d0             	add    %rdx,%rax
  800dbb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dbf:	8b 12                	mov    (%rdx),%edx
  800dc1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800dc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc8:	89 0a                	mov    %ecx,(%rdx)
  800dca:	eb 14                	jmp    800de0 <getuint+0x58>
  800dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dd4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800dd8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ddc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800de0:	48 8b 00             	mov    (%rax),%rax
  800de3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800de7:	e9 9d 00 00 00       	jmpq   800e89 <getuint+0x101>
	else if (lflag)
  800dec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800df0:	74 4c                	je     800e3e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800df2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df6:	8b 00                	mov    (%rax),%eax
  800df8:	83 f8 30             	cmp    $0x30,%eax
  800dfb:	73 24                	jae    800e21 <getuint+0x99>
  800dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e01:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e09:	8b 00                	mov    (%rax),%eax
  800e0b:	89 c0                	mov    %eax,%eax
  800e0d:	48 01 d0             	add    %rdx,%rax
  800e10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e14:	8b 12                	mov    (%rdx),%edx
  800e16:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1d:	89 0a                	mov    %ecx,(%rdx)
  800e1f:	eb 14                	jmp    800e35 <getuint+0xad>
  800e21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e25:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e29:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e31:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e35:	48 8b 00             	mov    (%rax),%rax
  800e38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e3c:	eb 4b                	jmp    800e89 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e42:	8b 00                	mov    (%rax),%eax
  800e44:	83 f8 30             	cmp    $0x30,%eax
  800e47:	73 24                	jae    800e6d <getuint+0xe5>
  800e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e55:	8b 00                	mov    (%rax),%eax
  800e57:	89 c0                	mov    %eax,%eax
  800e59:	48 01 d0             	add    %rdx,%rax
  800e5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e60:	8b 12                	mov    (%rdx),%edx
  800e62:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e69:	89 0a                	mov    %ecx,(%rdx)
  800e6b:	eb 14                	jmp    800e81 <getuint+0xf9>
  800e6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e71:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e75:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e7d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e81:	8b 00                	mov    (%rax),%eax
  800e83:	89 c0                	mov    %eax,%eax
  800e85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e8d:	c9                   	leaveq 
  800e8e:	c3                   	retq   

0000000000800e8f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e8f:	55                   	push   %rbp
  800e90:	48 89 e5             	mov    %rsp,%rbp
  800e93:	48 83 ec 20          	sub    $0x20,%rsp
  800e97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800e9e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ea2:	7e 4f                	jle    800ef3 <getint+0x64>
		x=va_arg(*ap, long long);
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	8b 00                	mov    (%rax),%eax
  800eaa:	83 f8 30             	cmp    $0x30,%eax
  800ead:	73 24                	jae    800ed3 <getint+0x44>
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebb:	8b 00                	mov    (%rax),%eax
  800ebd:	89 c0                	mov    %eax,%eax
  800ebf:	48 01 d0             	add    %rdx,%rax
  800ec2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec6:	8b 12                	mov    (%rdx),%edx
  800ec8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ecb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ecf:	89 0a                	mov    %ecx,(%rdx)
  800ed1:	eb 14                	jmp    800ee7 <getint+0x58>
  800ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800edb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800edf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ee3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ee7:	48 8b 00             	mov    (%rax),%rax
  800eea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800eee:	e9 9d 00 00 00       	jmpq   800f90 <getint+0x101>
	else if (lflag)
  800ef3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ef7:	74 4c                	je     800f45 <getint+0xb6>
		x=va_arg(*ap, long);
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	8b 00                	mov    (%rax),%eax
  800eff:	83 f8 30             	cmp    $0x30,%eax
  800f02:	73 24                	jae    800f28 <getint+0x99>
  800f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f08:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f10:	8b 00                	mov    (%rax),%eax
  800f12:	89 c0                	mov    %eax,%eax
  800f14:	48 01 d0             	add    %rdx,%rax
  800f17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f1b:	8b 12                	mov    (%rdx),%edx
  800f1d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f24:	89 0a                	mov    %ecx,(%rdx)
  800f26:	eb 14                	jmp    800f3c <getint+0xad>
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f30:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800f34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f38:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f3c:	48 8b 00             	mov    (%rax),%rax
  800f3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f43:	eb 4b                	jmp    800f90 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f49:	8b 00                	mov    (%rax),%eax
  800f4b:	83 f8 30             	cmp    $0x30,%eax
  800f4e:	73 24                	jae    800f74 <getint+0xe5>
  800f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f54:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5c:	8b 00                	mov    (%rax),%eax
  800f5e:	89 c0                	mov    %eax,%eax
  800f60:	48 01 d0             	add    %rdx,%rax
  800f63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f67:	8b 12                	mov    (%rdx),%edx
  800f69:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f70:	89 0a                	mov    %ecx,(%rdx)
  800f72:	eb 14                	jmp    800f88 <getint+0xf9>
  800f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f78:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f7c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800f80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f84:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f88:	8b 00                	mov    (%rax),%eax
  800f8a:	48 98                	cltq   
  800f8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800f90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	41 54                	push   %r12
  800f9c:	53                   	push   %rbx
  800f9d:	48 83 ec 60          	sub    $0x60,%rsp
  800fa1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800fa5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800fa9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800fad:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800fb1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fb5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800fb9:	48 8b 0a             	mov    (%rdx),%rcx
  800fbc:	48 89 08             	mov    %rcx,(%rax)
  800fbf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fcb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fcf:	eb 17                	jmp    800fe8 <vprintfmt+0x52>
			if (ch == '\0')
  800fd1:	85 db                	test   %ebx,%ebx
  800fd3:	0f 84 c5 04 00 00    	je     80149e <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800fd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe1:	48 89 d6             	mov    %rdx,%rsi
  800fe4:	89 df                	mov    %ebx,%edi
  800fe6:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fe8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ff0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ff4:	0f b6 00             	movzbl (%rax),%eax
  800ff7:	0f b6 d8             	movzbl %al,%ebx
  800ffa:	83 fb 25             	cmp    $0x25,%ebx
  800ffd:	75 d2                	jne    800fd1 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800fff:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801003:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80100a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801011:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801018:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80101f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801023:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801027:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80102b:	0f b6 00             	movzbl (%rax),%eax
  80102e:	0f b6 d8             	movzbl %al,%ebx
  801031:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801034:	83 f8 55             	cmp    $0x55,%eax
  801037:	0f 87 2e 04 00 00    	ja     80146b <vprintfmt+0x4d5>
  80103d:	89 c0                	mov    %eax,%eax
  80103f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801046:	00 
  801047:	48 b8 98 54 80 00 00 	movabs $0x805498,%rax
  80104e:	00 00 00 
  801051:	48 01 d0             	add    %rdx,%rax
  801054:	48 8b 00             	mov    (%rax),%rax
  801057:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801059:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80105d:	eb c0                	jmp    80101f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80105f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801063:	eb ba                	jmp    80101f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801065:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80106c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80106f:	89 d0                	mov    %edx,%eax
  801071:	c1 e0 02             	shl    $0x2,%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	01 c0                	add    %eax,%eax
  801078:	01 d8                	add    %ebx,%eax
  80107a:	83 e8 30             	sub    $0x30,%eax
  80107d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801080:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801084:	0f b6 00             	movzbl (%rax),%eax
  801087:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80108a:	83 fb 2f             	cmp    $0x2f,%ebx
  80108d:	7e 0c                	jle    80109b <vprintfmt+0x105>
  80108f:	83 fb 39             	cmp    $0x39,%ebx
  801092:	7f 07                	jg     80109b <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  801094:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  801099:	eb d1                	jmp    80106c <vprintfmt+0xd6>
			goto process_precision;
  80109b:	eb 50                	jmp    8010ed <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  80109d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a0:	83 f8 30             	cmp    $0x30,%eax
  8010a3:	73 17                	jae    8010bc <vprintfmt+0x126>
  8010a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010ac:	89 d2                	mov    %edx,%edx
  8010ae:	48 01 d0             	add    %rdx,%rax
  8010b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010b4:	83 c2 08             	add    $0x8,%edx
  8010b7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010ba:	eb 0c                	jmp    8010c8 <vprintfmt+0x132>
  8010bc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8010c0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8010c4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010c8:	8b 00                	mov    (%rax),%eax
  8010ca:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8010cd:	eb 1e                	jmp    8010ed <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8010cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010d3:	79 07                	jns    8010dc <vprintfmt+0x146>
				width = 0;
  8010d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8010dc:	e9 3e ff ff ff       	jmpq   80101f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8010e1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8010e8:	e9 32 ff ff ff       	jmpq   80101f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8010ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010f1:	79 0d                	jns    801100 <vprintfmt+0x16a>
				width = precision, precision = -1;
  8010f3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8010f6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8010f9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801100:	e9 1a ff ff ff       	jmpq   80101f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801105:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801109:	e9 11 ff ff ff       	jmpq   80101f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80110e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801111:	83 f8 30             	cmp    $0x30,%eax
  801114:	73 17                	jae    80112d <vprintfmt+0x197>
  801116:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80111a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80111d:	89 d2                	mov    %edx,%edx
  80111f:	48 01 d0             	add    %rdx,%rax
  801122:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801125:	83 c2 08             	add    $0x8,%edx
  801128:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80112b:	eb 0c                	jmp    801139 <vprintfmt+0x1a3>
  80112d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801131:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801135:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801139:	8b 10                	mov    (%rax),%edx
  80113b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80113f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801143:	48 89 ce             	mov    %rcx,%rsi
  801146:	89 d7                	mov    %edx,%edi
  801148:	ff d0                	callq  *%rax
			break;
  80114a:	e9 4a 03 00 00       	jmpq   801499 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80114f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801152:	83 f8 30             	cmp    $0x30,%eax
  801155:	73 17                	jae    80116e <vprintfmt+0x1d8>
  801157:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80115b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80115e:	89 d2                	mov    %edx,%edx
  801160:	48 01 d0             	add    %rdx,%rax
  801163:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801166:	83 c2 08             	add    $0x8,%edx
  801169:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80116c:	eb 0c                	jmp    80117a <vprintfmt+0x1e4>
  80116e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801172:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801176:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80117a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80117c:	85 db                	test   %ebx,%ebx
  80117e:	79 02                	jns    801182 <vprintfmt+0x1ec>
				err = -err;
  801180:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801182:	83 fb 15             	cmp    $0x15,%ebx
  801185:	7f 16                	jg     80119d <vprintfmt+0x207>
  801187:	48 b8 c0 53 80 00 00 	movabs $0x8053c0,%rax
  80118e:	00 00 00 
  801191:	48 63 d3             	movslq %ebx,%rdx
  801194:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801198:	4d 85 e4             	test   %r12,%r12
  80119b:	75 2e                	jne    8011cb <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  80119d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011a5:	89 d9                	mov    %ebx,%ecx
  8011a7:	48 ba 81 54 80 00 00 	movabs $0x805481,%rdx
  8011ae:	00 00 00 
  8011b1:	48 89 c7             	mov    %rax,%rdi
  8011b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b9:	49 b8 a7 14 80 00 00 	movabs $0x8014a7,%r8
  8011c0:	00 00 00 
  8011c3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8011c6:	e9 ce 02 00 00       	jmpq   801499 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  8011cb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011d3:	4c 89 e1             	mov    %r12,%rcx
  8011d6:	48 ba 8a 54 80 00 00 	movabs $0x80548a,%rdx
  8011dd:	00 00 00 
  8011e0:	48 89 c7             	mov    %rax,%rdi
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e8:	49 b8 a7 14 80 00 00 	movabs $0x8014a7,%r8
  8011ef:	00 00 00 
  8011f2:	41 ff d0             	callq  *%r8
			break;
  8011f5:	e9 9f 02 00 00       	jmpq   801499 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8011fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011fd:	83 f8 30             	cmp    $0x30,%eax
  801200:	73 17                	jae    801219 <vprintfmt+0x283>
  801202:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801206:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801209:	89 d2                	mov    %edx,%edx
  80120b:	48 01 d0             	add    %rdx,%rax
  80120e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801211:	83 c2 08             	add    $0x8,%edx
  801214:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801217:	eb 0c                	jmp    801225 <vprintfmt+0x28f>
  801219:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80121d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801221:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801225:	4c 8b 20             	mov    (%rax),%r12
  801228:	4d 85 e4             	test   %r12,%r12
  80122b:	75 0a                	jne    801237 <vprintfmt+0x2a1>
				p = "(null)";
  80122d:	49 bc 8d 54 80 00 00 	movabs $0x80548d,%r12
  801234:	00 00 00 
			if (width > 0 && padc != '-')
  801237:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80123b:	7e 3f                	jle    80127c <vprintfmt+0x2e6>
  80123d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801241:	74 39                	je     80127c <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801243:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801246:	48 98                	cltq   
  801248:	48 89 c6             	mov    %rax,%rsi
  80124b:	4c 89 e7             	mov    %r12,%rdi
  80124e:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801255:	00 00 00 
  801258:	ff d0                	callq  *%rax
  80125a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80125d:	eb 17                	jmp    801276 <vprintfmt+0x2e0>
					putch(padc, putdat);
  80125f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801263:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801267:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80126b:	48 89 ce             	mov    %rcx,%rsi
  80126e:	89 d7                	mov    %edx,%edi
  801270:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  801272:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801276:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80127a:	7f e3                	jg     80125f <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80127c:	eb 37                	jmp    8012b5 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  80127e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801282:	74 1e                	je     8012a2 <vprintfmt+0x30c>
  801284:	83 fb 1f             	cmp    $0x1f,%ebx
  801287:	7e 05                	jle    80128e <vprintfmt+0x2f8>
  801289:	83 fb 7e             	cmp    $0x7e,%ebx
  80128c:	7e 14                	jle    8012a2 <vprintfmt+0x30c>
					putch('?', putdat);
  80128e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801292:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801296:	48 89 d6             	mov    %rdx,%rsi
  801299:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80129e:	ff d0                	callq  *%rax
  8012a0:	eb 0f                	jmp    8012b1 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  8012a2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012aa:	48 89 d6             	mov    %rdx,%rsi
  8012ad:	89 df                	mov    %ebx,%edi
  8012af:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8012b5:	4c 89 e0             	mov    %r12,%rax
  8012b8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	0f be d8             	movsbl %al,%ebx
  8012c2:	85 db                	test   %ebx,%ebx
  8012c4:	74 10                	je     8012d6 <vprintfmt+0x340>
  8012c6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8012ca:	78 b2                	js     80127e <vprintfmt+0x2e8>
  8012cc:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8012d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8012d4:	79 a8                	jns    80127e <vprintfmt+0x2e8>
			for (; width > 0; width--)
  8012d6:	eb 16                	jmp    8012ee <vprintfmt+0x358>
				putch(' ', putdat);
  8012d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012e0:	48 89 d6             	mov    %rdx,%rsi
  8012e3:	bf 20 00 00 00       	mov    $0x20,%edi
  8012e8:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  8012ea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8012ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012f2:	7f e4                	jg     8012d8 <vprintfmt+0x342>
			break;
  8012f4:	e9 a0 01 00 00       	jmpq   801499 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8012f9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012fd:	be 03 00 00 00       	mov    $0x3,%esi
  801302:	48 89 c7             	mov    %rax,%rdi
  801305:	48 b8 8f 0e 80 00 00 	movabs $0x800e8f,%rax
  80130c:	00 00 00 
  80130f:	ff d0                	callq  *%rax
  801311:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801319:	48 85 c0             	test   %rax,%rax
  80131c:	79 1d                	jns    80133b <vprintfmt+0x3a5>
				putch('-', putdat);
  80131e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801322:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801326:	48 89 d6             	mov    %rdx,%rsi
  801329:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80132e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 f7 d8             	neg    %rax
  801337:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80133b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801342:	e9 e5 00 00 00       	jmpq   80142c <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801347:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80134b:	be 03 00 00 00       	mov    $0x3,%esi
  801350:	48 89 c7             	mov    %rax,%rdi
  801353:	48 b8 88 0d 80 00 00 	movabs $0x800d88,%rax
  80135a:	00 00 00 
  80135d:	ff d0                	callq  *%rax
  80135f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801363:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80136a:	e9 bd 00 00 00       	jmpq   80142c <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80136f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801373:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801377:	48 89 d6             	mov    %rdx,%rsi
  80137a:	bf 58 00 00 00       	mov    $0x58,%edi
  80137f:	ff d0                	callq  *%rax
			putch('X', putdat);
  801381:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801385:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801389:	48 89 d6             	mov    %rdx,%rsi
  80138c:	bf 58 00 00 00       	mov    $0x58,%edi
  801391:	ff d0                	callq  *%rax
			putch('X', putdat);
  801393:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801397:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80139b:	48 89 d6             	mov    %rdx,%rsi
  80139e:	bf 58 00 00 00       	mov    $0x58,%edi
  8013a3:	ff d0                	callq  *%rax
			break;
  8013a5:	e9 ef 00 00 00       	jmpq   801499 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  8013aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b2:	48 89 d6             	mov    %rdx,%rsi
  8013b5:	bf 30 00 00 00       	mov    $0x30,%edi
  8013ba:	ff d0                	callq  *%rax
			putch('x', putdat);
  8013bc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c4:	48 89 d6             	mov    %rdx,%rsi
  8013c7:	bf 78 00 00 00       	mov    $0x78,%edi
  8013cc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8013ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013d1:	83 f8 30             	cmp    $0x30,%eax
  8013d4:	73 17                	jae    8013ed <vprintfmt+0x457>
  8013d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013da:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013dd:	89 d2                	mov    %edx,%edx
  8013df:	48 01 d0             	add    %rdx,%rax
  8013e2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013e5:	83 c2 08             	add    $0x8,%edx
  8013e8:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  8013eb:	eb 0c                	jmp    8013f9 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  8013ed:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8013f1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8013f5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013f9:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  8013fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801400:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801407:	eb 23                	jmp    80142c <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801409:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80140d:	be 03 00 00 00       	mov    $0x3,%esi
  801412:	48 89 c7             	mov    %rax,%rdi
  801415:	48 b8 88 0d 80 00 00 	movabs $0x800d88,%rax
  80141c:	00 00 00 
  80141f:	ff d0                	callq  *%rax
  801421:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801425:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80142c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801431:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801434:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801437:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80143b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80143f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801443:	45 89 c1             	mov    %r8d,%r9d
  801446:	41 89 f8             	mov    %edi,%r8d
  801449:	48 89 c7             	mov    %rax,%rdi
  80144c:	48 b8 cf 0c 80 00 00 	movabs $0x800ccf,%rax
  801453:	00 00 00 
  801456:	ff d0                	callq  *%rax
			break;
  801458:	eb 3f                	jmp    801499 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80145e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801462:	48 89 d6             	mov    %rdx,%rsi
  801465:	89 df                	mov    %ebx,%edi
  801467:	ff d0                	callq  *%rax
			break;
  801469:	eb 2e                	jmp    801499 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80146f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801473:	48 89 d6             	mov    %rdx,%rsi
  801476:	bf 25 00 00 00       	mov    $0x25,%edi
  80147b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801482:	eb 05                	jmp    801489 <vprintfmt+0x4f3>
  801484:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801489:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80148d:	48 83 e8 01          	sub    $0x1,%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3c 25                	cmp    $0x25,%al
  801496:	75 ec                	jne    801484 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801498:	90                   	nop
		}
	}
  801499:	e9 31 fb ff ff       	jmpq   800fcf <vprintfmt+0x39>
	va_end(aq);
}
  80149e:	48 83 c4 60          	add    $0x60,%rsp
  8014a2:	5b                   	pop    %rbx
  8014a3:	41 5c                	pop    %r12
  8014a5:	5d                   	pop    %rbp
  8014a6:	c3                   	retq   

00000000008014a7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014a7:	55                   	push   %rbp
  8014a8:	48 89 e5             	mov    %rsp,%rbp
  8014ab:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8014b2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8014b9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8014c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8014c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8014ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8014d5:	84 c0                	test   %al,%al
  8014d7:	74 20                	je     8014f9 <printfmt+0x52>
  8014d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8014dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8014e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8014e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014f9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801500:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801507:	00 00 00 
  80150a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801511:	00 00 00 
  801514:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801518:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80151f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801526:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80152d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801534:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80153b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801542:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801549:	48 89 c7             	mov    %rax,%rdi
  80154c:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  801553:	00 00 00 
  801556:	ff d0                	callq  *%rax
	va_end(ap);
}
  801558:	c9                   	leaveq 
  801559:	c3                   	retq   

000000000080155a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	48 83 ec 10          	sub    $0x10,%rsp
  801562:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801565:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	8b 40 10             	mov    0x10(%rax),%eax
  801570:	8d 50 01             	lea    0x1(%rax),%edx
  801573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801577:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80157a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157e:	48 8b 10             	mov    (%rax),%rdx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	48 8b 40 08          	mov    0x8(%rax),%rax
  801589:	48 39 c2             	cmp    %rax,%rdx
  80158c:	73 17                	jae    8015a5 <sprintputch+0x4b>
		*b->buf++ = ch;
  80158e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801592:	48 8b 00             	mov    (%rax),%rax
  801595:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801599:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80159d:	48 89 0a             	mov    %rcx,(%rdx)
  8015a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8015a3:	88 10                	mov    %dl,(%rax)
}
  8015a5:	c9                   	leaveq 
  8015a6:	c3                   	retq   

00000000008015a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	48 83 ec 50          	sub    $0x50,%rsp
  8015af:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8015b3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8015b6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8015ba:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8015be:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8015c2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8015c6:	48 8b 0a             	mov    (%rdx),%rcx
  8015c9:	48 89 08             	mov    %rcx,(%rax)
  8015cc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8015d0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8015d4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8015d8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8015e0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8015e4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8015e7:	48 98                	cltq   
  8015e9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8015f1:	48 01 d0             	add    %rdx,%rax
  8015f4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8015f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8015ff:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801604:	74 06                	je     80160c <vsnprintf+0x65>
  801606:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80160a:	7f 07                	jg     801613 <vsnprintf+0x6c>
		return -E_INVAL;
  80160c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801611:	eb 2f                	jmp    801642 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801613:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801617:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80161b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80161f:	48 89 c6             	mov    %rax,%rsi
  801622:	48 bf 5a 15 80 00 00 	movabs $0x80155a,%rdi
  801629:	00 00 00 
  80162c:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  801633:	00 00 00 
  801636:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801638:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80163c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80163f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801642:	c9                   	leaveq 
  801643:	c3                   	retq   

0000000000801644 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801644:	55                   	push   %rbp
  801645:	48 89 e5             	mov    %rsp,%rbp
  801648:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80164f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801656:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80165c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801663:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80166a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801671:	84 c0                	test   %al,%al
  801673:	74 20                	je     801695 <snprintf+0x51>
  801675:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801679:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80167d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801681:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801685:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801689:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80168d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801691:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801695:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80169c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8016a3:	00 00 00 
  8016a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8016ad:	00 00 00 
  8016b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8016b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8016bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8016c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8016c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8016d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8016d7:	48 8b 0a             	mov    (%rdx),%rcx
  8016da:	48 89 08             	mov    %rcx,(%rax)
  8016dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8016e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8016e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8016e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8016ed:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8016f4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8016fb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801701:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801708:	48 89 c7             	mov    %rax,%rdi
  80170b:	48 b8 a7 15 80 00 00 	movabs $0x8015a7,%rax
  801712:	00 00 00 
  801715:	ff d0                	callq  *%rax
  801717:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80171d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 18          	sub    $0x18,%rsp
  80172d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801731:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801738:	eb 09                	jmp    801743 <strlen+0x1e>
		n++;
  80173a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80173e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801747:	0f b6 00             	movzbl (%rax),%eax
  80174a:	84 c0                	test   %al,%al
  80174c:	75 ec                	jne    80173a <strlen+0x15>
	return n;
  80174e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801751:	c9                   	leaveq 
  801752:	c3                   	retq   

0000000000801753 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801753:	55                   	push   %rbp
  801754:	48 89 e5             	mov    %rsp,%rbp
  801757:	48 83 ec 20          	sub    $0x20,%rsp
  80175b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80175f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801763:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80176a:	eb 0e                	jmp    80177a <strnlen+0x27>
		n++;
  80176c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801770:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801775:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80177a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80177f:	74 0b                	je     80178c <strnlen+0x39>
  801781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	84 c0                	test   %al,%al
  80178a:	75 e0                	jne    80176c <strnlen+0x19>
	return n;
  80178c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80178f:	c9                   	leaveq 
  801790:	c3                   	retq   

0000000000801791 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801791:	55                   	push   %rbp
  801792:	48 89 e5             	mov    %rsp,%rbp
  801795:	48 83 ec 20          	sub    $0x20,%rsp
  801799:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80179d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8017a9:	90                   	nop
  8017aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017ba:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017be:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017c2:	0f b6 12             	movzbl (%rdx),%edx
  8017c5:	88 10                	mov    %dl,(%rax)
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	84 c0                	test   %al,%al
  8017cc:	75 dc                	jne    8017aa <strcpy+0x19>
		/* do nothing */;
	return ret;
  8017ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017d2:	c9                   	leaveq 
  8017d3:	c3                   	retq   

00000000008017d4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017d4:	55                   	push   %rbp
  8017d5:	48 89 e5             	mov    %rsp,%rbp
  8017d8:	48 83 ec 20          	sub    $0x20,%rsp
  8017dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8017e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e8:	48 89 c7             	mov    %rax,%rdi
  8017eb:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  8017f2:	00 00 00 
  8017f5:	ff d0                	callq  *%rax
  8017f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8017fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fd:	48 63 d0             	movslq %eax,%rdx
  801800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801804:	48 01 c2             	add    %rax,%rdx
  801807:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180b:	48 89 c6             	mov    %rax,%rsi
  80180e:	48 89 d7             	mov    %rdx,%rdi
  801811:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  801818:	00 00 00 
  80181b:	ff d0                	callq  *%rax
	return dst;
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801821:	c9                   	leaveq 
  801822:	c3                   	retq   

0000000000801823 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 28          	sub    $0x28,%rsp
  80182b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80182f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801833:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80183f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801846:	00 
  801847:	eb 2a                	jmp    801873 <strncpy+0x50>
		*dst++ = *src;
  801849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80184d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801851:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801855:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801859:	0f b6 12             	movzbl (%rdx),%edx
  80185c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80185e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801862:	0f b6 00             	movzbl (%rax),%eax
  801865:	84 c0                	test   %al,%al
  801867:	74 05                	je     80186e <strncpy+0x4b>
			src++;
  801869:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80186e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801873:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801877:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80187b:	72 cc                	jb     801849 <strncpy+0x26>
	}
	return ret;
  80187d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801881:	c9                   	leaveq 
  801882:	c3                   	retq   

0000000000801883 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801883:	55                   	push   %rbp
  801884:	48 89 e5             	mov    %rsp,%rbp
  801887:	48 83 ec 28          	sub    $0x28,%rsp
  80188b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80188f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801893:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80189f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018a4:	74 3d                	je     8018e3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8018a6:	eb 1d                	jmp    8018c5 <strlcpy+0x42>
			*dst++ = *src++;
  8018a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018b8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018bc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8018c0:	0f b6 12             	movzbl (%rdx),%edx
  8018c3:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8018c5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8018ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018cf:	74 0b                	je     8018dc <strlcpy+0x59>
  8018d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018d5:	0f b6 00             	movzbl (%rax),%eax
  8018d8:	84 c0                	test   %al,%al
  8018da:	75 cc                	jne    8018a8 <strlcpy+0x25>
		*dst = '\0';
  8018dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8018e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018eb:	48 29 c2             	sub    %rax,%rdx
  8018ee:	48 89 d0             	mov    %rdx,%rax
}
  8018f1:	c9                   	leaveq 
  8018f2:	c3                   	retq   

00000000008018f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018f3:	55                   	push   %rbp
  8018f4:	48 89 e5             	mov    %rsp,%rbp
  8018f7:	48 83 ec 10          	sub    $0x10,%rsp
  8018fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801903:	eb 0a                	jmp    80190f <strcmp+0x1c>
		p++, q++;
  801905:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80190a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801913:	0f b6 00             	movzbl (%rax),%eax
  801916:	84 c0                	test   %al,%al
  801918:	74 12                	je     80192c <strcmp+0x39>
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	0f b6 10             	movzbl (%rax),%edx
  801921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	38 c2                	cmp    %al,%dl
  80192a:	74 d9                	je     801905 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80192c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801930:	0f b6 00             	movzbl (%rax),%eax
  801933:	0f b6 d0             	movzbl %al,%edx
  801936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	0f b6 c0             	movzbl %al,%eax
  801940:	29 c2                	sub    %eax,%edx
  801942:	89 d0                	mov    %edx,%eax
}
  801944:	c9                   	leaveq 
  801945:	c3                   	retq   

0000000000801946 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801946:	55                   	push   %rbp
  801947:	48 89 e5             	mov    %rsp,%rbp
  80194a:	48 83 ec 18          	sub    $0x18,%rsp
  80194e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801952:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801956:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80195a:	eb 0f                	jmp    80196b <strncmp+0x25>
		n--, p++, q++;
  80195c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801961:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801966:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  80196b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801970:	74 1d                	je     80198f <strncmp+0x49>
  801972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801976:	0f b6 00             	movzbl (%rax),%eax
  801979:	84 c0                	test   %al,%al
  80197b:	74 12                	je     80198f <strncmp+0x49>
  80197d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801981:	0f b6 10             	movzbl (%rax),%edx
  801984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801988:	0f b6 00             	movzbl (%rax),%eax
  80198b:	38 c2                	cmp    %al,%dl
  80198d:	74 cd                	je     80195c <strncmp+0x16>
	if (n == 0)
  80198f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801994:	75 07                	jne    80199d <strncmp+0x57>
		return 0;
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
  80199b:	eb 18                	jmp    8019b5 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80199d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a1:	0f b6 00             	movzbl (%rax),%eax
  8019a4:	0f b6 d0             	movzbl %al,%edx
  8019a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ab:	0f b6 00             	movzbl (%rax),%eax
  8019ae:	0f b6 c0             	movzbl %al,%eax
  8019b1:	29 c2                	sub    %eax,%edx
  8019b3:	89 d0                	mov    %edx,%eax
}
  8019b5:	c9                   	leaveq 
  8019b6:	c3                   	retq   

00000000008019b7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8019b7:	55                   	push   %rbp
  8019b8:	48 89 e5             	mov    %rsp,%rbp
  8019bb:	48 83 ec 10          	sub    $0x10,%rsp
  8019bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019c3:	89 f0                	mov    %esi,%eax
  8019c5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8019c8:	eb 17                	jmp    8019e1 <strchr+0x2a>
		if (*s == c)
  8019ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ce:	0f b6 00             	movzbl (%rax),%eax
  8019d1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8019d4:	75 06                	jne    8019dc <strchr+0x25>
			return (char *) s;
  8019d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019da:	eb 15                	jmp    8019f1 <strchr+0x3a>
	for (; *s; s++)
  8019dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e5:	0f b6 00             	movzbl (%rax),%eax
  8019e8:	84 c0                	test   %al,%al
  8019ea:	75 de                	jne    8019ca <strchr+0x13>
	return 0;
  8019ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f1:	c9                   	leaveq 
  8019f2:	c3                   	retq   

00000000008019f3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019f3:	55                   	push   %rbp
  8019f4:	48 89 e5             	mov    %rsp,%rbp
  8019f7:	48 83 ec 10          	sub    $0x10,%rsp
  8019fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ff:	89 f0                	mov    %esi,%eax
  801a01:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801a04:	eb 13                	jmp    801a19 <strfind+0x26>
		if (*s == c)
  801a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0a:	0f b6 00             	movzbl (%rax),%eax
  801a0d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801a10:	75 02                	jne    801a14 <strfind+0x21>
			break;
  801a12:	eb 10                	jmp    801a24 <strfind+0x31>
	for (; *s; s++)
  801a14:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	84 c0                	test   %al,%al
  801a22:	75 e2                	jne    801a06 <strfind+0x13>
	return (char *) s;
  801a24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 18          	sub    $0x18,%rsp
  801a32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a36:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801a39:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801a3d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a42:	75 06                	jne    801a4a <memset+0x20>
		return v;
  801a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a48:	eb 69                	jmp    801ab3 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801a4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4e:	83 e0 03             	and    $0x3,%eax
  801a51:	48 85 c0             	test   %rax,%rax
  801a54:	75 48                	jne    801a9e <memset+0x74>
  801a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a5a:	83 e0 03             	and    $0x3,%eax
  801a5d:	48 85 c0             	test   %rax,%rax
  801a60:	75 3c                	jne    801a9e <memset+0x74>
		c &= 0xFF;
  801a62:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801a69:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a6c:	c1 e0 18             	shl    $0x18,%eax
  801a6f:	89 c2                	mov    %eax,%edx
  801a71:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a74:	c1 e0 10             	shl    $0x10,%eax
  801a77:	09 c2                	or     %eax,%edx
  801a79:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a7c:	c1 e0 08             	shl    $0x8,%eax
  801a7f:	09 d0                	or     %edx,%eax
  801a81:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a88:	48 c1 e8 02          	shr    $0x2,%rax
  801a8c:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801a8f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a93:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a96:	48 89 d7             	mov    %rdx,%rdi
  801a99:	fc                   	cld    
  801a9a:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a9c:	eb 11                	jmp    801aaf <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aa2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801aa5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aa9:	48 89 d7             	mov    %rdx,%rdi
  801aac:	fc                   	cld    
  801aad:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801ab3:	c9                   	leaveq 
  801ab4:	c3                   	retq   

0000000000801ab5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801ab5:	55                   	push   %rbp
  801ab6:	48 89 e5             	mov    %rsp,%rbp
  801ab9:	48 83 ec 28          	sub    $0x28,%rsp
  801abd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ac1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ac5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801ac9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801acd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801ad9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801add:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801ae1:	0f 83 88 00 00 00    	jae    801b6f <memmove+0xba>
  801ae7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aef:	48 01 d0             	add    %rdx,%rax
  801af2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801af6:	76 77                	jbe    801b6f <memmove+0xba>
		s += n;
  801af8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801b00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b04:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0c:	83 e0 03             	and    $0x3,%eax
  801b0f:	48 85 c0             	test   %rax,%rax
  801b12:	75 3b                	jne    801b4f <memmove+0x9a>
  801b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b18:	83 e0 03             	and    $0x3,%eax
  801b1b:	48 85 c0             	test   %rax,%rax
  801b1e:	75 2f                	jne    801b4f <memmove+0x9a>
  801b20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b24:	83 e0 03             	and    $0x3,%eax
  801b27:	48 85 c0             	test   %rax,%rax
  801b2a:	75 23                	jne    801b4f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b30:	48 83 e8 04          	sub    $0x4,%rax
  801b34:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b38:	48 83 ea 04          	sub    $0x4,%rdx
  801b3c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b40:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801b44:	48 89 c7             	mov    %rax,%rdi
  801b47:	48 89 d6             	mov    %rdx,%rsi
  801b4a:	fd                   	std    
  801b4b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b4d:	eb 1d                	jmp    801b6c <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b53:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801b5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b63:	48 89 d7             	mov    %rdx,%rdi
  801b66:	48 89 c1             	mov    %rax,%rcx
  801b69:	fd                   	std    
  801b6a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b6c:	fc                   	cld    
  801b6d:	eb 57                	jmp    801bc6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b73:	83 e0 03             	and    $0x3,%eax
  801b76:	48 85 c0             	test   %rax,%rax
  801b79:	75 36                	jne    801bb1 <memmove+0xfc>
  801b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b7f:	83 e0 03             	and    $0x3,%eax
  801b82:	48 85 c0             	test   %rax,%rax
  801b85:	75 2a                	jne    801bb1 <memmove+0xfc>
  801b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8b:	83 e0 03             	and    $0x3,%eax
  801b8e:	48 85 c0             	test   %rax,%rax
  801b91:	75 1e                	jne    801bb1 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b97:	48 c1 e8 02          	shr    $0x2,%rax
  801b9b:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801b9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ba6:	48 89 c7             	mov    %rax,%rdi
  801ba9:	48 89 d6             	mov    %rdx,%rsi
  801bac:	fc                   	cld    
  801bad:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801baf:	eb 15                	jmp    801bc6 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801bbd:	48 89 c7             	mov    %rax,%rdi
  801bc0:	48 89 d6             	mov    %rdx,%rsi
  801bc3:	fc                   	cld    
  801bc4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bca:	c9                   	leaveq 
  801bcb:	c3                   	retq   

0000000000801bcc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801bcc:	55                   	push   %rbp
  801bcd:	48 89 e5             	mov    %rsp,%rbp
  801bd0:	48 83 ec 18          	sub    $0x18,%rsp
  801bd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bdc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801be0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801be4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bec:	48 89 ce             	mov    %rcx,%rsi
  801bef:	48 89 c7             	mov    %rax,%rdi
  801bf2:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 28          	sub    $0x28,%rsp
  801c08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801c1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c20:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801c24:	eb 36                	jmp    801c5c <memcmp+0x5c>
		if (*s1 != *s2)
  801c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2a:	0f b6 10             	movzbl (%rax),%edx
  801c2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c31:	0f b6 00             	movzbl (%rax),%eax
  801c34:	38 c2                	cmp    %al,%dl
  801c36:	74 1a                	je     801c52 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3c:	0f b6 00             	movzbl (%rax),%eax
  801c3f:	0f b6 d0             	movzbl %al,%edx
  801c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c46:	0f b6 00             	movzbl (%rax),%eax
  801c49:	0f b6 c0             	movzbl %al,%eax
  801c4c:	29 c2                	sub    %eax,%edx
  801c4e:	89 d0                	mov    %edx,%eax
  801c50:	eb 20                	jmp    801c72 <memcmp+0x72>
		s1++, s2++;
  801c52:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c57:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801c5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c60:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c68:	48 85 c0             	test   %rax,%rax
  801c6b:	75 b9                	jne    801c26 <memcmp+0x26>
	}

	return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c72:	c9                   	leaveq 
  801c73:	c3                   	retq   

0000000000801c74 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c74:	55                   	push   %rbp
  801c75:	48 89 e5             	mov    %rsp,%rbp
  801c78:	48 83 ec 28          	sub    $0x28,%rsp
  801c7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c80:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c83:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8f:	48 01 d0             	add    %rdx,%rax
  801c92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c96:	eb 15                	jmp    801cad <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9c:	0f b6 00             	movzbl (%rax),%eax
  801c9f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801ca2:	38 d0                	cmp    %dl,%al
  801ca4:	75 02                	jne    801ca8 <memfind+0x34>
			break;
  801ca6:	eb 0f                	jmp    801cb7 <memfind+0x43>
	for (; s < ends; s++)
  801ca8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801cb5:	72 e1                	jb     801c98 <memfind+0x24>
	return (void *) s;
  801cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801cbb:	c9                   	leaveq 
  801cbc:	c3                   	retq   

0000000000801cbd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801cbd:	55                   	push   %rbp
  801cbe:	48 89 e5             	mov    %rsp,%rbp
  801cc1:	48 83 ec 38          	sub    $0x38,%rsp
  801cc5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cc9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ccd:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801cd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801cd7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801cde:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cdf:	eb 05                	jmp    801ce6 <strtol+0x29>
		s++;
  801ce1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801ce6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cea:	0f b6 00             	movzbl (%rax),%eax
  801ced:	3c 20                	cmp    $0x20,%al
  801cef:	74 f0                	je     801ce1 <strtol+0x24>
  801cf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf5:	0f b6 00             	movzbl (%rax),%eax
  801cf8:	3c 09                	cmp    $0x9,%al
  801cfa:	74 e5                	je     801ce1 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801cfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d00:	0f b6 00             	movzbl (%rax),%eax
  801d03:	3c 2b                	cmp    $0x2b,%al
  801d05:	75 07                	jne    801d0e <strtol+0x51>
		s++;
  801d07:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d0c:	eb 17                	jmp    801d25 <strtol+0x68>
	else if (*s == '-')
  801d0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d12:	0f b6 00             	movzbl (%rax),%eax
  801d15:	3c 2d                	cmp    $0x2d,%al
  801d17:	75 0c                	jne    801d25 <strtol+0x68>
		s++, neg = 1;
  801d19:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d25:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d29:	74 06                	je     801d31 <strtol+0x74>
  801d2b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801d2f:	75 28                	jne    801d59 <strtol+0x9c>
  801d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d35:	0f b6 00             	movzbl (%rax),%eax
  801d38:	3c 30                	cmp    $0x30,%al
  801d3a:	75 1d                	jne    801d59 <strtol+0x9c>
  801d3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d40:	48 83 c0 01          	add    $0x1,%rax
  801d44:	0f b6 00             	movzbl (%rax),%eax
  801d47:	3c 78                	cmp    $0x78,%al
  801d49:	75 0e                	jne    801d59 <strtol+0x9c>
		s += 2, base = 16;
  801d4b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801d50:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801d57:	eb 2c                	jmp    801d85 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801d59:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d5d:	75 19                	jne    801d78 <strtol+0xbb>
  801d5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d63:	0f b6 00             	movzbl (%rax),%eax
  801d66:	3c 30                	cmp    $0x30,%al
  801d68:	75 0e                	jne    801d78 <strtol+0xbb>
		s++, base = 8;
  801d6a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d6f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801d76:	eb 0d                	jmp    801d85 <strtol+0xc8>
	else if (base == 0)
  801d78:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d7c:	75 07                	jne    801d85 <strtol+0xc8>
		base = 10;
  801d7e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d89:	0f b6 00             	movzbl (%rax),%eax
  801d8c:	3c 2f                	cmp    $0x2f,%al
  801d8e:	7e 1d                	jle    801dad <strtol+0xf0>
  801d90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d94:	0f b6 00             	movzbl (%rax),%eax
  801d97:	3c 39                	cmp    $0x39,%al
  801d99:	7f 12                	jg     801dad <strtol+0xf0>
			dig = *s - '0';
  801d9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9f:	0f b6 00             	movzbl (%rax),%eax
  801da2:	0f be c0             	movsbl %al,%eax
  801da5:	83 e8 30             	sub    $0x30,%eax
  801da8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801dab:	eb 4e                	jmp    801dfb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801dad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db1:	0f b6 00             	movzbl (%rax),%eax
  801db4:	3c 60                	cmp    $0x60,%al
  801db6:	7e 1d                	jle    801dd5 <strtol+0x118>
  801db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dbc:	0f b6 00             	movzbl (%rax),%eax
  801dbf:	3c 7a                	cmp    $0x7a,%al
  801dc1:	7f 12                	jg     801dd5 <strtol+0x118>
			dig = *s - 'a' + 10;
  801dc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc7:	0f b6 00             	movzbl (%rax),%eax
  801dca:	0f be c0             	movsbl %al,%eax
  801dcd:	83 e8 57             	sub    $0x57,%eax
  801dd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801dd3:	eb 26                	jmp    801dfb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801dd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd9:	0f b6 00             	movzbl (%rax),%eax
  801ddc:	3c 40                	cmp    $0x40,%al
  801dde:	7e 48                	jle    801e28 <strtol+0x16b>
  801de0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de4:	0f b6 00             	movzbl (%rax),%eax
  801de7:	3c 5a                	cmp    $0x5a,%al
  801de9:	7f 3d                	jg     801e28 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801deb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801def:	0f b6 00             	movzbl (%rax),%eax
  801df2:	0f be c0             	movsbl %al,%eax
  801df5:	83 e8 37             	sub    $0x37,%eax
  801df8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801dfb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dfe:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801e01:	7c 02                	jl     801e05 <strtol+0x148>
			break;
  801e03:	eb 23                	jmp    801e28 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801e05:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e0a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e0d:	48 98                	cltq   
  801e0f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e1a:	48 98                	cltq   
  801e1c:	48 01 d0             	add    %rdx,%rax
  801e1f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801e23:	e9 5d ff ff ff       	jmpq   801d85 <strtol+0xc8>

	if (endptr)
  801e28:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801e2d:	74 0b                	je     801e3a <strtol+0x17d>
		*endptr = (char *) s;
  801e2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e33:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e37:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3e:	74 09                	je     801e49 <strtol+0x18c>
  801e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e44:	48 f7 d8             	neg    %rax
  801e47:	eb 04                	jmp    801e4d <strtol+0x190>
  801e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801e4d:	c9                   	leaveq 
  801e4e:	c3                   	retq   

0000000000801e4f <strstr>:

char * strstr(const char *in, const char *str)
{
  801e4f:	55                   	push   %rbp
  801e50:	48 89 e5             	mov    %rsp,%rbp
  801e53:	48 83 ec 30          	sub    $0x30,%rsp
  801e57:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e5b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801e5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e63:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e67:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e6b:	0f b6 00             	movzbl (%rax),%eax
  801e6e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801e71:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801e75:	75 06                	jne    801e7d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801e77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7b:	eb 6b                	jmp    801ee8 <strstr+0x99>

	len = strlen(str);
  801e7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e81:	48 89 c7             	mov    %rax,%rdi
  801e84:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	callq  *%rax
  801e90:	48 98                	cltq   
  801e92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801e96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e9e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ea2:	0f b6 00             	movzbl (%rax),%eax
  801ea5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ea8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801eac:	75 07                	jne    801eb5 <strstr+0x66>
				return (char *) 0;
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	eb 33                	jmp    801ee8 <strstr+0x99>
		} while (sc != c);
  801eb5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801eb9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ebc:	75 d8                	jne    801e96 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ebe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eca:	48 89 ce             	mov    %rcx,%rsi
  801ecd:	48 89 c7             	mov    %rax,%rdi
  801ed0:	48 b8 46 19 80 00 00 	movabs $0x801946,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
  801edc:	85 c0                	test   %eax,%eax
  801ede:	75 b6                	jne    801e96 <strstr+0x47>

	return (char *) (in - 1);
  801ee0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee4:	48 83 e8 01          	sub    $0x1,%rax
}
  801ee8:	c9                   	leaveq 
  801ee9:	c3                   	retq   

0000000000801eea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801eea:	55                   	push   %rbp
  801eeb:	48 89 e5             	mov    %rsp,%rbp
  801eee:	53                   	push   %rbx
  801eef:	48 83 ec 48          	sub    $0x48,%rsp
  801ef3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ef6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ef9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801efd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801f01:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801f05:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f09:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f0c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801f10:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801f14:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801f18:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801f1c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801f20:	4c 89 c3             	mov    %r8,%rbx
  801f23:	cd 30                	int    $0x30
  801f25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801f29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801f2d:	74 3e                	je     801f6d <syscall+0x83>
  801f2f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f34:	7e 37                	jle    801f6d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801f36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f3d:	49 89 d0             	mov    %rdx,%r8
  801f40:	89 c1                	mov    %eax,%ecx
  801f42:	48 ba 48 57 80 00 00 	movabs $0x805748,%rdx
  801f49:	00 00 00 
  801f4c:	be 23 00 00 00       	mov    $0x23,%esi
  801f51:	48 bf 65 57 80 00 00 	movabs $0x805765,%rdi
  801f58:	00 00 00 
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	49 b9 be 09 80 00 00 	movabs $0x8009be,%r9
  801f67:	00 00 00 
  801f6a:	41 ff d1             	callq  *%r9

	return ret;
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f71:	48 83 c4 48          	add    $0x48,%rsp
  801f75:	5b                   	pop    %rbx
  801f76:	5d                   	pop    %rbp
  801f77:	c3                   	retq   

0000000000801f78 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f78:	55                   	push   %rbp
  801f79:	48 89 e5             	mov    %rsp,%rbp
  801f7c:	48 83 ec 10          	sub    $0x10,%rsp
  801f80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f90:	48 83 ec 08          	sub    $0x8,%rsp
  801f94:	6a 00                	pushq  $0x0
  801f96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa2:	48 89 d1             	mov    %rdx,%rcx
  801fa5:	48 89 c2             	mov    %rax,%rdx
  801fa8:	be 00 00 00 00       	mov    $0x0,%esi
  801fad:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb2:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  801fb9:	00 00 00 
  801fbc:	ff d0                	callq  *%rax
  801fbe:	48 83 c4 10          	add    $0x10,%rsp
}
  801fc2:	c9                   	leaveq 
  801fc3:	c3                   	retq   

0000000000801fc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fc4:	55                   	push   %rbp
  801fc5:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801fc8:	48 83 ec 08          	sub    $0x8,%rsp
  801fcc:	6a 00                	pushq  $0x0
  801fce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fda:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe4:	be 00 00 00 00       	mov    $0x0,%esi
  801fe9:	bf 01 00 00 00       	mov    $0x1,%edi
  801fee:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  801ff5:	00 00 00 
  801ff8:	ff d0                	callq  *%rax
  801ffa:	48 83 c4 10          	add    $0x10,%rsp
}
  801ffe:	c9                   	leaveq 
  801fff:	c3                   	retq   

0000000000802000 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802000:	55                   	push   %rbp
  802001:	48 89 e5             	mov    %rsp,%rbp
  802004:	48 83 ec 10          	sub    $0x10,%rsp
  802008:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80200b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200e:	48 98                	cltq   
  802010:	48 83 ec 08          	sub    $0x8,%rsp
  802014:	6a 00                	pushq  $0x0
  802016:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80201c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802022:	b9 00 00 00 00       	mov    $0x0,%ecx
  802027:	48 89 c2             	mov    %rax,%rdx
  80202a:	be 01 00 00 00       	mov    $0x1,%esi
  80202f:	bf 03 00 00 00       	mov    $0x3,%edi
  802034:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  80203b:	00 00 00 
  80203e:	ff d0                	callq  *%rax
  802040:	48 83 c4 10          	add    $0x10,%rsp
}
  802044:	c9                   	leaveq 
  802045:	c3                   	retq   

0000000000802046 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802046:	55                   	push   %rbp
  802047:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80204a:	48 83 ec 08          	sub    $0x8,%rsp
  80204e:	6a 00                	pushq  $0x0
  802050:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802056:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80205c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802061:	ba 00 00 00 00       	mov    $0x0,%edx
  802066:	be 00 00 00 00       	mov    $0x0,%esi
  80206b:	bf 02 00 00 00       	mov    $0x2,%edi
  802070:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802077:	00 00 00 
  80207a:	ff d0                	callq  *%rax
  80207c:	48 83 c4 10          	add    $0x10,%rsp
}
  802080:	c9                   	leaveq 
  802081:	c3                   	retq   

0000000000802082 <sys_yield>:

void
sys_yield(void)
{
  802082:	55                   	push   %rbp
  802083:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802086:	48 83 ec 08          	sub    $0x8,%rsp
  80208a:	6a 00                	pushq  $0x0
  80208c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802092:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802098:	b9 00 00 00 00       	mov    $0x0,%ecx
  80209d:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a2:	be 00 00 00 00       	mov    $0x0,%esi
  8020a7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8020ac:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  8020b3:	00 00 00 
  8020b6:	ff d0                	callq  *%rax
  8020b8:	48 83 c4 10          	add    $0x10,%rsp
}
  8020bc:	c9                   	leaveq 
  8020bd:	c3                   	retq   

00000000008020be <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8020be:	55                   	push   %rbp
  8020bf:	48 89 e5             	mov    %rsp,%rbp
  8020c2:	48 83 ec 10          	sub    $0x10,%rsp
  8020c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020cd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8020d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020d3:	48 63 c8             	movslq %eax,%rcx
  8020d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020dd:	48 98                	cltq   
  8020df:	48 83 ec 08          	sub    $0x8,%rsp
  8020e3:	6a 00                	pushq  $0x0
  8020e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020eb:	49 89 c8             	mov    %rcx,%r8
  8020ee:	48 89 d1             	mov    %rdx,%rcx
  8020f1:	48 89 c2             	mov    %rax,%rdx
  8020f4:	be 01 00 00 00       	mov    $0x1,%esi
  8020f9:	bf 04 00 00 00       	mov    $0x4,%edi
  8020fe:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802105:	00 00 00 
  802108:	ff d0                	callq  *%rax
  80210a:	48 83 c4 10          	add    $0x10,%rsp
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
  802114:	48 83 ec 20          	sub    $0x20,%rsp
  802118:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80211b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80211f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802122:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802126:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80212a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80212d:	48 63 c8             	movslq %eax,%rcx
  802130:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802134:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802137:	48 63 f0             	movslq %eax,%rsi
  80213a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80213e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802141:	48 98                	cltq   
  802143:	48 83 ec 08          	sub    $0x8,%rsp
  802147:	51                   	push   %rcx
  802148:	49 89 f9             	mov    %rdi,%r9
  80214b:	49 89 f0             	mov    %rsi,%r8
  80214e:	48 89 d1             	mov    %rdx,%rcx
  802151:	48 89 c2             	mov    %rax,%rdx
  802154:	be 01 00 00 00       	mov    $0x1,%esi
  802159:	bf 05 00 00 00       	mov    $0x5,%edi
  80215e:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802165:	00 00 00 
  802168:	ff d0                	callq  *%rax
  80216a:	48 83 c4 10          	add    $0x10,%rsp
}
  80216e:	c9                   	leaveq 
  80216f:	c3                   	retq   

0000000000802170 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802170:	55                   	push   %rbp
  802171:	48 89 e5             	mov    %rsp,%rbp
  802174:	48 83 ec 10          	sub    $0x10,%rsp
  802178:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80217b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80217f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802186:	48 98                	cltq   
  802188:	48 83 ec 08          	sub    $0x8,%rsp
  80218c:	6a 00                	pushq  $0x0
  80218e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802194:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80219a:	48 89 d1             	mov    %rdx,%rcx
  80219d:	48 89 c2             	mov    %rax,%rdx
  8021a0:	be 01 00 00 00       	mov    $0x1,%esi
  8021a5:	bf 06 00 00 00       	mov    $0x6,%edi
  8021aa:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
  8021b6:	48 83 c4 10          	add    $0x10,%rsp
}
  8021ba:	c9                   	leaveq 
  8021bb:	c3                   	retq   

00000000008021bc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	48 83 ec 10          	sub    $0x10,%rsp
  8021c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021c7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8021ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021cd:	48 63 d0             	movslq %eax,%rdx
  8021d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d3:	48 98                	cltq   
  8021d5:	48 83 ec 08          	sub    $0x8,%rsp
  8021d9:	6a 00                	pushq  $0x0
  8021db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021e7:	48 89 d1             	mov    %rdx,%rcx
  8021ea:	48 89 c2             	mov    %rax,%rdx
  8021ed:	be 01 00 00 00       	mov    $0x1,%esi
  8021f2:	bf 08 00 00 00       	mov    $0x8,%edi
  8021f7:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
  802203:	48 83 c4 10          	add    $0x10,%rsp
}
  802207:	c9                   	leaveq 
  802208:	c3                   	retq   

0000000000802209 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802209:	55                   	push   %rbp
  80220a:	48 89 e5             	mov    %rsp,%rbp
  80220d:	48 83 ec 10          	sub    $0x10,%rsp
  802211:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802214:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802218:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80221c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221f:	48 98                	cltq   
  802221:	48 83 ec 08          	sub    $0x8,%rsp
  802225:	6a 00                	pushq  $0x0
  802227:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80222d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802233:	48 89 d1             	mov    %rdx,%rcx
  802236:	48 89 c2             	mov    %rax,%rdx
  802239:	be 01 00 00 00       	mov    $0x1,%esi
  80223e:	bf 09 00 00 00       	mov    $0x9,%edi
  802243:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax
  80224f:	48 83 c4 10          	add    $0x10,%rsp
}
  802253:	c9                   	leaveq 
  802254:	c3                   	retq   

0000000000802255 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802255:	55                   	push   %rbp
  802256:	48 89 e5             	mov    %rsp,%rbp
  802259:	48 83 ec 10          	sub    $0x10,%rsp
  80225d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802260:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802264:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226b:	48 98                	cltq   
  80226d:	48 83 ec 08          	sub    $0x8,%rsp
  802271:	6a 00                	pushq  $0x0
  802273:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802279:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80227f:	48 89 d1             	mov    %rdx,%rcx
  802282:	48 89 c2             	mov    %rax,%rdx
  802285:	be 01 00 00 00       	mov    $0x1,%esi
  80228a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80228f:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
  80229b:	48 83 c4 10          	add    $0x10,%rsp
}
  80229f:	c9                   	leaveq 
  8022a0:	c3                   	retq   

00000000008022a1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8022a1:	55                   	push   %rbp
  8022a2:	48 89 e5             	mov    %rsp,%rbp
  8022a5:	48 83 ec 20          	sub    $0x20,%rsp
  8022a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8022b4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8022b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ba:	48 63 f0             	movslq %eax,%rsi
  8022bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c4:	48 98                	cltq   
  8022c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ca:	48 83 ec 08          	sub    $0x8,%rsp
  8022ce:	6a 00                	pushq  $0x0
  8022d0:	49 89 f1             	mov    %rsi,%r9
  8022d3:	49 89 c8             	mov    %rcx,%r8
  8022d6:	48 89 d1             	mov    %rdx,%rcx
  8022d9:	48 89 c2             	mov    %rax,%rdx
  8022dc:	be 00 00 00 00       	mov    $0x0,%esi
  8022e1:	bf 0c 00 00 00       	mov    $0xc,%edi
  8022e6:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
  8022f2:	48 83 c4 10          	add    $0x10,%rsp
}
  8022f6:	c9                   	leaveq 
  8022f7:	c3                   	retq   

00000000008022f8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8022f8:	55                   	push   %rbp
  8022f9:	48 89 e5             	mov    %rsp,%rbp
  8022fc:	48 83 ec 10          	sub    $0x10,%rsp
  802300:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802308:	48 83 ec 08          	sub    $0x8,%rsp
  80230c:	6a 00                	pushq  $0x0
  80230e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802314:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80231a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80231f:	48 89 c2             	mov    %rax,%rdx
  802322:	be 01 00 00 00       	mov    $0x1,%esi
  802327:	bf 0d 00 00 00       	mov    $0xd,%edi
  80232c:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802333:	00 00 00 
  802336:	ff d0                	callq  *%rax
  802338:	48 83 c4 10          	add    $0x10,%rsp
}
  80233c:	c9                   	leaveq 
  80233d:	c3                   	retq   

000000000080233e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80233e:	55                   	push   %rbp
  80233f:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802342:	48 83 ec 08          	sub    $0x8,%rsp
  802346:	6a 00                	pushq  $0x0
  802348:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80234e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802354:	b9 00 00 00 00       	mov    $0x0,%ecx
  802359:	ba 00 00 00 00       	mov    $0x0,%edx
  80235e:	be 00 00 00 00       	mov    $0x0,%esi
  802363:	bf 0e 00 00 00       	mov    $0xe,%edi
  802368:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  80236f:	00 00 00 
  802372:	ff d0                	callq  *%rax
  802374:	48 83 c4 10          	add    $0x10,%rsp
}
  802378:	c9                   	leaveq 
  802379:	c3                   	retq   

000000000080237a <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80237a:	55                   	push   %rbp
  80237b:	48 89 e5             	mov    %rsp,%rbp
  80237e:	48 83 ec 20          	sub    $0x20,%rsp
  802382:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802385:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802389:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80238c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802390:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802394:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802397:	48 63 c8             	movslq %eax,%rcx
  80239a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80239e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023a1:	48 63 f0             	movslq %eax,%rsi
  8023a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ab:	48 98                	cltq   
  8023ad:	48 83 ec 08          	sub    $0x8,%rsp
  8023b1:	51                   	push   %rcx
  8023b2:	49 89 f9             	mov    %rdi,%r9
  8023b5:	49 89 f0             	mov    %rsi,%r8
  8023b8:	48 89 d1             	mov    %rdx,%rcx
  8023bb:	48 89 c2             	mov    %rax,%rdx
  8023be:	be 00 00 00 00       	mov    $0x0,%esi
  8023c3:	bf 0f 00 00 00       	mov    $0xf,%edi
  8023c8:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  8023cf:	00 00 00 
  8023d2:	ff d0                	callq  *%rax
  8023d4:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 10          	sub    $0x10,%rsp
  8023e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8023ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f2:	48 83 ec 08          	sub    $0x8,%rsp
  8023f6:	6a 00                	pushq  $0x0
  8023f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802404:	48 89 d1             	mov    %rdx,%rcx
  802407:	48 89 c2             	mov    %rax,%rdx
  80240a:	be 00 00 00 00       	mov    $0x0,%esi
  80240f:	bf 10 00 00 00       	mov    $0x10,%edi
  802414:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  80241b:	00 00 00 
  80241e:	ff d0                	callq  *%rax
  802420:	48 83 c4 10          	add    $0x10,%rsp
}
  802424:	c9                   	leaveq 
  802425:	c3                   	retq   

0000000000802426 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802426:	55                   	push   %rbp
  802427:	48 89 e5             	mov    %rsp,%rbp
  80242a:	48 83 ec 08          	sub    $0x8,%rsp
  80242e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802432:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802436:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80243d:	ff ff ff 
  802440:	48 01 d0             	add    %rdx,%rax
  802443:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802447:	c9                   	leaveq 
  802448:	c3                   	retq   

0000000000802449 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802449:	55                   	push   %rbp
  80244a:	48 89 e5             	mov    %rsp,%rbp
  80244d:	48 83 ec 08          	sub    $0x8,%rsp
  802451:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802459:	48 89 c7             	mov    %rax,%rdi
  80245c:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  802463:	00 00 00 
  802466:	ff d0                	callq  *%rax
  802468:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80246e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802472:	c9                   	leaveq 
  802473:	c3                   	retq   

0000000000802474 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802474:	55                   	push   %rbp
  802475:	48 89 e5             	mov    %rsp,%rbp
  802478:	48 83 ec 18          	sub    $0x18,%rsp
  80247c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802487:	eb 6b                	jmp    8024f4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802489:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248c:	48 98                	cltq   
  80248e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802494:	48 c1 e0 0c          	shl    $0xc,%rax
  802498:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80249c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a0:	48 c1 e8 15          	shr    $0x15,%rax
  8024a4:	48 89 c2             	mov    %rax,%rdx
  8024a7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024ae:	01 00 00 
  8024b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b5:	83 e0 01             	and    $0x1,%eax
  8024b8:	48 85 c0             	test   %rax,%rax
  8024bb:	74 21                	je     8024de <fd_alloc+0x6a>
  8024bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c1:	48 c1 e8 0c          	shr    $0xc,%rax
  8024c5:	48 89 c2             	mov    %rax,%rdx
  8024c8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024cf:	01 00 00 
  8024d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d6:	83 e0 01             	and    $0x1,%eax
  8024d9:	48 85 c0             	test   %rax,%rax
  8024dc:	75 12                	jne    8024f0 <fd_alloc+0x7c>
			*fd_store = fd;
  8024de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024e6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	eb 1a                	jmp    80250a <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  8024f0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024f4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024f8:	7e 8f                	jle    802489 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  8024fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fe:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802505:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80250a:	c9                   	leaveq 
  80250b:	c3                   	retq   

000000000080250c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80250c:	55                   	push   %rbp
  80250d:	48 89 e5             	mov    %rsp,%rbp
  802510:	48 83 ec 20          	sub    $0x20,%rsp
  802514:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802517:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80251b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80251f:	78 06                	js     802527 <fd_lookup+0x1b>
  802521:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802525:	7e 07                	jle    80252e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802527:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80252c:	eb 6c                	jmp    80259a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80252e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802531:	48 98                	cltq   
  802533:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802539:	48 c1 e0 0c          	shl    $0xc,%rax
  80253d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802545:	48 c1 e8 15          	shr    $0x15,%rax
  802549:	48 89 c2             	mov    %rax,%rdx
  80254c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802553:	01 00 00 
  802556:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80255a:	83 e0 01             	and    $0x1,%eax
  80255d:	48 85 c0             	test   %rax,%rax
  802560:	74 21                	je     802583 <fd_lookup+0x77>
  802562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802566:	48 c1 e8 0c          	shr    $0xc,%rax
  80256a:	48 89 c2             	mov    %rax,%rdx
  80256d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802574:	01 00 00 
  802577:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257b:	83 e0 01             	and    $0x1,%eax
  80257e:	48 85 c0             	test   %rax,%rax
  802581:	75 07                	jne    80258a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802583:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802588:	eb 10                	jmp    80259a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80258a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802592:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259a:	c9                   	leaveq 
  80259b:	c3                   	retq   

000000000080259c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80259c:	55                   	push   %rbp
  80259d:	48 89 e5             	mov    %rsp,%rbp
  8025a0:	48 83 ec 30          	sub    $0x30,%rsp
  8025a4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025a8:	89 f0                	mov    %esi,%eax
  8025aa:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b1:	48 89 c7             	mov    %rax,%rdi
  8025b4:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8025c6:	48 89 c6             	mov    %rax,%rsi
  8025c9:	89 d7                	mov    %edx,%edi
  8025cb:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	78 0a                	js     8025ea <fd_close+0x4e>
	    || fd != fd2)
  8025e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025e8:	74 12                	je     8025fc <fd_close+0x60>
		return (must_exist ? r : 0);
  8025ea:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025ee:	74 05                	je     8025f5 <fd_close+0x59>
  8025f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f3:	eb 70                	jmp    802665 <fd_close+0xc9>
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	eb 69                	jmp    802665 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802600:	8b 00                	mov    (%rax),%eax
  802602:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802606:	48 89 d6             	mov    %rdx,%rsi
  802609:	89 c7                	mov    %eax,%edi
  80260b:	48 b8 67 26 80 00 00 	movabs $0x802667,%rax
  802612:	00 00 00 
  802615:	ff d0                	callq  *%rax
  802617:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261e:	78 2a                	js     80264a <fd_close+0xae>
		if (dev->dev_close)
  802620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802624:	48 8b 40 20          	mov    0x20(%rax),%rax
  802628:	48 85 c0             	test   %rax,%rax
  80262b:	74 16                	je     802643 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80262d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802631:	48 8b 40 20          	mov    0x20(%rax),%rax
  802635:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802639:	48 89 d7             	mov    %rdx,%rdi
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	eb 07                	jmp    80264a <fd_close+0xae>
		else
			r = 0;
  802643:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80264a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264e:	48 89 c6             	mov    %rax,%rsi
  802651:	bf 00 00 00 00       	mov    $0x0,%edi
  802656:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
	return r;
  802662:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802665:	c9                   	leaveq 
  802666:	c3                   	retq   

0000000000802667 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802667:	55                   	push   %rbp
  802668:	48 89 e5             	mov    %rsp,%rbp
  80266b:	48 83 ec 20          	sub    $0x20,%rsp
  80266f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802672:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802676:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80267d:	eb 41                	jmp    8026c0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80267f:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802686:	00 00 00 
  802689:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80268c:	48 63 d2             	movslq %edx,%rdx
  80268f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802693:	8b 00                	mov    (%rax),%eax
  802695:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802698:	75 22                	jne    8026bc <dev_lookup+0x55>
			*dev = devtab[i];
  80269a:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8026a1:	00 00 00 
  8026a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026a7:	48 63 d2             	movslq %edx,%rdx
  8026aa:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026b2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	eb 60                	jmp    80271c <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  8026bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026c0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8026c7:	00 00 00 
  8026ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026cd:	48 63 d2             	movslq %edx,%rdx
  8026d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d4:	48 85 c0             	test   %rax,%rax
  8026d7:	75 a6                	jne    80267f <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026d9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026e0:	00 00 00 
  8026e3:	48 8b 00             	mov    (%rax),%rax
  8026e6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026ec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026ef:	89 c6                	mov    %eax,%esi
  8026f1:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  8026f8:	00 00 00 
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	48 b9 f7 0b 80 00 00 	movabs $0x800bf7,%rcx
  802707:	00 00 00 
  80270a:	ff d1                	callq  *%rcx
	*dev = 0;
  80270c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802710:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80271c:	c9                   	leaveq 
  80271d:	c3                   	retq   

000000000080271e <close>:

int
close(int fdnum)
{
  80271e:	55                   	push   %rbp
  80271f:	48 89 e5             	mov    %rsp,%rbp
  802722:	48 83 ec 20          	sub    $0x20,%rsp
  802726:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802729:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80272d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802730:	48 89 d6             	mov    %rdx,%rsi
  802733:	89 c7                	mov    %eax,%edi
  802735:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802744:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802748:	79 05                	jns    80274f <close+0x31>
		return r;
  80274a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274d:	eb 18                	jmp    802767 <close+0x49>
	else
		return fd_close(fd, 1);
  80274f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802753:	be 01 00 00 00       	mov    $0x1,%esi
  802758:	48 89 c7             	mov    %rax,%rdi
  80275b:	48 b8 9c 25 80 00 00 	movabs $0x80259c,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax
}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <close_all>:

void
close_all(void)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802771:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802778:	eb 15                	jmp    80278f <close_all+0x26>
		close(i);
  80277a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277d:	89 c7                	mov    %eax,%edi
  80277f:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  80278b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80278f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802793:	7e e5                	jle    80277a <close_all+0x11>
}
  802795:	c9                   	leaveq 
  802796:	c3                   	retq   

0000000000802797 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802797:	55                   	push   %rbp
  802798:	48 89 e5             	mov    %rsp,%rbp
  80279b:	48 83 ec 40          	sub    $0x40,%rsp
  80279f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027a2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027a5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027a9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027ac:	48 89 d6             	mov    %rdx,%rsi
  8027af:	89 c7                	mov    %eax,%edi
  8027b1:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	callq  *%rax
  8027bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c4:	79 08                	jns    8027ce <dup+0x37>
		return r;
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c9:	e9 70 01 00 00       	jmpq   80293e <dup+0x1a7>
	close(newfdnum);
  8027ce:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027d1:	89 c7                	mov    %eax,%edi
  8027d3:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  8027da:	00 00 00 
  8027dd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027df:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027e2:	48 98                	cltq   
  8027e4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027ea:	48 c1 e0 0c          	shl    $0xc,%rax
  8027ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f6:	48 89 c7             	mov    %rax,%rdi
  8027f9:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
  802805:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802809:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280d:	48 89 c7             	mov    %rax,%rdi
  802810:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
  80281c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802824:	48 c1 e8 15          	shr    $0x15,%rax
  802828:	48 89 c2             	mov    %rax,%rdx
  80282b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802832:	01 00 00 
  802835:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802839:	83 e0 01             	and    $0x1,%eax
  80283c:	48 85 c0             	test   %rax,%rax
  80283f:	74 73                	je     8028b4 <dup+0x11d>
  802841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802845:	48 c1 e8 0c          	shr    $0xc,%rax
  802849:	48 89 c2             	mov    %rax,%rdx
  80284c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802853:	01 00 00 
  802856:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285a:	83 e0 01             	and    $0x1,%eax
  80285d:	48 85 c0             	test   %rax,%rax
  802860:	74 52                	je     8028b4 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802866:	48 c1 e8 0c          	shr    $0xc,%rax
  80286a:	48 89 c2             	mov    %rax,%rdx
  80286d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802874:	01 00 00 
  802877:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287b:	25 07 0e 00 00       	and    $0xe07,%eax
  802880:	89 c1                	mov    %eax,%ecx
  802882:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288a:	41 89 c8             	mov    %ecx,%r8d
  80288d:	48 89 d1             	mov    %rdx,%rcx
  802890:	ba 00 00 00 00       	mov    $0x0,%edx
  802895:	48 89 c6             	mov    %rax,%rsi
  802898:	bf 00 00 00 00       	mov    $0x0,%edi
  80289d:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8028a4:	00 00 00 
  8028a7:	ff d0                	callq  *%rax
  8028a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b0:	79 02                	jns    8028b4 <dup+0x11d>
			goto err;
  8028b2:	eb 57                	jmp    80290b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8028bc:	48 89 c2             	mov    %rax,%rdx
  8028bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c6:	01 00 00 
  8028c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8028d2:	89 c1                	mov    %eax,%ecx
  8028d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028dc:	41 89 c8             	mov    %ecx,%r8d
  8028df:	48 89 d1             	mov    %rdx,%rcx
  8028e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e7:	48 89 c6             	mov    %rax,%rsi
  8028ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ef:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8028f6:	00 00 00 
  8028f9:	ff d0                	callq  *%rax
  8028fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802902:	79 02                	jns    802906 <dup+0x16f>
		goto err;
  802904:	eb 05                	jmp    80290b <dup+0x174>

	return newfdnum;
  802906:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802909:	eb 33                	jmp    80293e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80290b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290f:	48 89 c6             	mov    %rax,%rsi
  802912:	bf 00 00 00 00       	mov    $0x0,%edi
  802917:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  80291e:	00 00 00 
  802921:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802923:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802927:	48 89 c6             	mov    %rax,%rsi
  80292a:	bf 00 00 00 00       	mov    $0x0,%edi
  80292f:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
	return r;
  80293b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80293e:	c9                   	leaveq 
  80293f:	c3                   	retq   

0000000000802940 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802940:	55                   	push   %rbp
  802941:	48 89 e5             	mov    %rsp,%rbp
  802944:	48 83 ec 40          	sub    $0x40,%rsp
  802948:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80294b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80294f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802953:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802957:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80295a:	48 89 d6             	mov    %rdx,%rsi
  80295d:	89 c7                	mov    %eax,%edi
  80295f:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
  80296b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802972:	78 24                	js     802998 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802978:	8b 00                	mov    (%rax),%eax
  80297a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297e:	48 89 d6             	mov    %rdx,%rsi
  802981:	89 c7                	mov    %eax,%edi
  802983:	48 b8 67 26 80 00 00 	movabs $0x802667,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
  80298f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802996:	79 05                	jns    80299d <read+0x5d>
		return r;
  802998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299b:	eb 76                	jmp    802a13 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80299d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a1:	8b 40 08             	mov    0x8(%rax),%eax
  8029a4:	83 e0 03             	and    $0x3,%eax
  8029a7:	83 f8 01             	cmp    $0x1,%eax
  8029aa:	75 3a                	jne    8029e6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029ac:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8029b3:	00 00 00 
  8029b6:	48 8b 00             	mov    (%rax),%rax
  8029b9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029bf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029c2:	89 c6                	mov    %eax,%esi
  8029c4:	48 bf 97 57 80 00 00 	movabs $0x805797,%rdi
  8029cb:	00 00 00 
  8029ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d3:	48 b9 f7 0b 80 00 00 	movabs $0x800bf7,%rcx
  8029da:	00 00 00 
  8029dd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e4:	eb 2d                	jmp    802a13 <read+0xd3>
	}
	if (!dev->dev_read)
  8029e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029ee:	48 85 c0             	test   %rax,%rax
  8029f1:	75 07                	jne    8029fa <read+0xba>
		return -E_NOT_SUPP;
  8029f3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029f8:	eb 19                	jmp    802a13 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fe:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a02:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a06:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a0a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a0e:	48 89 cf             	mov    %rcx,%rdi
  802a11:	ff d0                	callq  *%rax
}
  802a13:	c9                   	leaveq 
  802a14:	c3                   	retq   

0000000000802a15 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	48 83 ec 30          	sub    $0x30,%rsp
  802a1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a24:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a2f:	eb 49                	jmp    802a7a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a34:	48 98                	cltq   
  802a36:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a3a:	48 29 c2             	sub    %rax,%rdx
  802a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a40:	48 63 c8             	movslq %eax,%rcx
  802a43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a47:	48 01 c1             	add    %rax,%rcx
  802a4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a4d:	48 89 ce             	mov    %rcx,%rsi
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a61:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a65:	79 05                	jns    802a6c <readn+0x57>
			return m;
  802a67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a6a:	eb 1c                	jmp    802a88 <readn+0x73>
		if (m == 0)
  802a6c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a70:	75 02                	jne    802a74 <readn+0x5f>
			break;
  802a72:	eb 11                	jmp    802a85 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802a74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a77:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7d:	48 98                	cltq   
  802a7f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a83:	72 ac                	jb     802a31 <readn+0x1c>
	}
	return tot;
  802a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 40          	sub    $0x40,%rsp
  802a92:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a95:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a99:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a9d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aa1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aa4:	48 89 d6             	mov    %rdx,%rsi
  802aa7:	89 c7                	mov    %eax,%edi
  802aa9:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
  802ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abc:	78 24                	js     802ae2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac2:	8b 00                	mov    (%rax),%eax
  802ac4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ac8:	48 89 d6             	mov    %rdx,%rsi
  802acb:	89 c7                	mov    %eax,%edi
  802acd:	48 b8 67 26 80 00 00 	movabs $0x802667,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
  802ad9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802adc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae0:	79 05                	jns    802ae7 <write+0x5d>
		return r;
  802ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae5:	eb 75                	jmp    802b5c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aeb:	8b 40 08             	mov    0x8(%rax),%eax
  802aee:	83 e0 03             	and    $0x3,%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	75 3a                	jne    802b2f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802af5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802afc:	00 00 00 
  802aff:	48 8b 00             	mov    (%rax),%rax
  802b02:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b08:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b0b:	89 c6                	mov    %eax,%esi
  802b0d:	48 bf b3 57 80 00 00 	movabs $0x8057b3,%rdi
  802b14:	00 00 00 
  802b17:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1c:	48 b9 f7 0b 80 00 00 	movabs $0x800bf7,%rcx
  802b23:	00 00 00 
  802b26:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b2d:	eb 2d                	jmp    802b5c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b33:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b37:	48 85 c0             	test   %rax,%rax
  802b3a:	75 07                	jne    802b43 <write+0xb9>
		return -E_NOT_SUPP;
  802b3c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b41:	eb 19                	jmp    802b5c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b47:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b4b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b4f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b53:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b57:	48 89 cf             	mov    %rcx,%rdi
  802b5a:	ff d0                	callq  *%rax
}
  802b5c:	c9                   	leaveq 
  802b5d:	c3                   	retq   

0000000000802b5e <seek>:

int
seek(int fdnum, off_t offset)
{
  802b5e:	55                   	push   %rbp
  802b5f:	48 89 e5             	mov    %rsp,%rbp
  802b62:	48 83 ec 18          	sub    $0x18,%rsp
  802b66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b69:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b73:	48 89 d6             	mov    %rdx,%rsi
  802b76:	89 c7                	mov    %eax,%edi
  802b78:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	callq  *%rax
  802b84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8b:	79 05                	jns    802b92 <seek+0x34>
		return r;
  802b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b90:	eb 0f                	jmp    802ba1 <seek+0x43>
	fd->fd_offset = offset;
  802b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b96:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b99:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba1:	c9                   	leaveq 
  802ba2:	c3                   	retq   

0000000000802ba3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ba3:	55                   	push   %rbp
  802ba4:	48 89 e5             	mov    %rsp,%rbp
  802ba7:	48 83 ec 30          	sub    $0x30,%rsp
  802bab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bae:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bb1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bb8:	48 89 d6             	mov    %rdx,%rsi
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd0:	78 24                	js     802bf6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd6:	8b 00                	mov    (%rax),%eax
  802bd8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bdc:	48 89 d6             	mov    %rdx,%rsi
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 67 26 80 00 00 	movabs $0x802667,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
  802bed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf4:	79 05                	jns    802bfb <ftruncate+0x58>
		return r;
  802bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf9:	eb 72                	jmp    802c6d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bff:	8b 40 08             	mov    0x8(%rax),%eax
  802c02:	83 e0 03             	and    $0x3,%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	75 3a                	jne    802c43 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c09:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c10:	00 00 00 
  802c13:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c16:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c1c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c1f:	89 c6                	mov    %eax,%esi
  802c21:	48 bf d0 57 80 00 00 	movabs $0x8057d0,%rdi
  802c28:	00 00 00 
  802c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c30:	48 b9 f7 0b 80 00 00 	movabs $0x800bf7,%rcx
  802c37:	00 00 00 
  802c3a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c41:	eb 2a                	jmp    802c6d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c47:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c4b:	48 85 c0             	test   %rax,%rax
  802c4e:	75 07                	jne    802c57 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c55:	eb 16                	jmp    802c6d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c63:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c66:	89 ce                	mov    %ecx,%esi
  802c68:	48 89 d7             	mov    %rdx,%rdi
  802c6b:	ff d0                	callq  *%rax
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 30          	sub    $0x30,%rsp
  802c77:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c7a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c7e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c82:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c85:	48 89 d6             	mov    %rdx,%rsi
  802c88:	89 c7                	mov    %eax,%edi
  802c8a:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  802c91:	00 00 00 
  802c94:	ff d0                	callq  *%rax
  802c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9d:	78 24                	js     802cc3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca3:	8b 00                	mov    (%rax),%eax
  802ca5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ca9:	48 89 d6             	mov    %rdx,%rsi
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	48 b8 67 26 80 00 00 	movabs $0x802667,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
  802cba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc1:	79 05                	jns    802cc8 <fstat+0x59>
		return r;
  802cc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc6:	eb 5e                	jmp    802d26 <fstat+0xb7>
	if (!dev->dev_stat)
  802cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccc:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cd0:	48 85 c0             	test   %rax,%rax
  802cd3:	75 07                	jne    802cdc <fstat+0x6d>
		return -E_NOT_SUPP;
  802cd5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cda:	eb 4a                	jmp    802d26 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ce3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cee:	00 00 00 
	stat->st_isdir = 0;
  802cf1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cf5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802cfc:	00 00 00 
	stat->st_dev = dev;
  802cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d07:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d12:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d1a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d1e:	48 89 ce             	mov    %rcx,%rsi
  802d21:	48 89 d7             	mov    %rdx,%rdi
  802d24:	ff d0                	callq  *%rax
}
  802d26:	c9                   	leaveq 
  802d27:	c3                   	retq   

0000000000802d28 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d28:	55                   	push   %rbp
  802d29:	48 89 e5             	mov    %rsp,%rbp
  802d2c:	48 83 ec 20          	sub    $0x20,%rsp
  802d30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	be 00 00 00 00       	mov    $0x0,%esi
  802d41:	48 89 c7             	mov    %rax,%rdi
  802d44:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
  802d50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d57:	79 05                	jns    802d5e <stat+0x36>
		return fd;
  802d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5c:	eb 2f                	jmp    802d8d <stat+0x65>
	r = fstat(fd, stat);
  802d5e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d65:	48 89 d6             	mov    %rdx,%rsi
  802d68:	89 c7                	mov    %eax,%edi
  802d6a:	48 b8 6f 2c 80 00 00 	movabs $0x802c6f,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
  802d76:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7c:	89 c7                	mov    %eax,%edi
  802d7e:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
	return r;
  802d8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d8d:	c9                   	leaveq 
  802d8e:	c3                   	retq   

0000000000802d8f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d8f:	55                   	push   %rbp
  802d90:	48 89 e5             	mov    %rsp,%rbp
  802d93:	48 83 ec 10          	sub    $0x10,%rsp
  802d97:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d9e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da5:	00 00 00 
  802da8:	8b 00                	mov    (%rax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	75 1f                	jne    802dcd <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802dae:	bf 01 00 00 00       	mov    $0x1,%edi
  802db3:	48 b8 17 4a 80 00 00 	movabs $0x804a17,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
  802dbf:	89 c2                	mov    %eax,%edx
  802dc1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc8:	00 00 00 
  802dcb:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802dcd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd4:	00 00 00 
  802dd7:	8b 00                	mov    (%rax),%eax
  802dd9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ddc:	b9 07 00 00 00       	mov    $0x7,%ecx
  802de1:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802de8:	00 00 00 
  802deb:	89 c7                	mov    %eax,%edi
  802ded:	48 b8 8a 48 80 00 00 	movabs $0x80488a,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  802e02:	48 89 c6             	mov    %rax,%rsi
  802e05:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0a:	48 b8 4c 48 80 00 00 	movabs $0x80484c,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 10          	sub    $0x10,%rsp
  802e20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e24:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802e27:	48 ba f6 57 80 00 00 	movabs $0x8057f6,%rdx
  802e2e:	00 00 00 
  802e31:	be 4c 00 00 00       	mov    $0x4c,%esi
  802e36:	48 bf 0b 58 80 00 00 	movabs $0x80580b,%rdi
  802e3d:	00 00 00 
  802e40:	b8 00 00 00 00       	mov    $0x0,%eax
  802e45:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  802e4c:	00 00 00 
  802e4f:	ff d1                	callq  *%rcx

0000000000802e51 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e51:	55                   	push   %rbp
  802e52:	48 89 e5             	mov    %rsp,%rbp
  802e55:	48 83 ec 10          	sub    $0x10,%rsp
  802e59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e61:	8b 50 0c             	mov    0xc(%rax),%edx
  802e64:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e6b:	00 00 00 
  802e6e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e70:	be 00 00 00 00       	mov    $0x0,%esi
  802e75:	bf 06 00 00 00       	mov    $0x6,%edi
  802e7a:	48 b8 8f 2d 80 00 00 	movabs $0x802d8f,%rax
  802e81:	00 00 00 
  802e84:	ff d0                	callq  *%rax
}
  802e86:	c9                   	leaveq 
  802e87:	c3                   	retq   

0000000000802e88 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e88:	55                   	push   %rbp
  802e89:	48 89 e5             	mov    %rsp,%rbp
  802e8c:	48 83 ec 20          	sub    $0x20,%rsp
  802e90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e98:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802e9c:	48 ba 16 58 80 00 00 	movabs $0x805816,%rdx
  802ea3:	00 00 00 
  802ea6:	be 6b 00 00 00       	mov    $0x6b,%esi
  802eab:	48 bf 0b 58 80 00 00 	movabs $0x80580b,%rdi
  802eb2:	00 00 00 
  802eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eba:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  802ec1:	00 00 00 
  802ec4:	ff d1                	callq  *%rcx

0000000000802ec6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ec6:	55                   	push   %rbp
  802ec7:	48 89 e5             	mov    %rsp,%rbp
  802eca:	48 83 ec 20          	sub    $0x20,%rsp
  802ece:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ed2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ed6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802eda:	48 ba 33 58 80 00 00 	movabs $0x805833,%rdx
  802ee1:	00 00 00 
  802ee4:	be 7b 00 00 00       	mov    $0x7b,%esi
  802ee9:	48 bf 0b 58 80 00 00 	movabs $0x80580b,%rdi
  802ef0:	00 00 00 
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef8:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  802eff:	00 00 00 
  802f02:	ff d1                	callq  *%rcx

0000000000802f04 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	48 83 ec 20          	sub    $0x20,%rsp
  802f0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f18:	8b 50 0c             	mov    0xc(%rax),%edx
  802f1b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f22:	00 00 00 
  802f25:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f27:	be 00 00 00 00       	mov    $0x0,%esi
  802f2c:	bf 05 00 00 00       	mov    $0x5,%edi
  802f31:	48 b8 8f 2d 80 00 00 	movabs $0x802d8f,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f44:	79 05                	jns    802f4b <devfile_stat+0x47>
		return r;
  802f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f49:	eb 56                	jmp    802fa1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802f56:	00 00 00 
  802f59:	48 89 c7             	mov    %rax,%rdi
  802f5c:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f68:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f6f:	00 00 00 
  802f72:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f82:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f89:	00 00 00 
  802f8c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f96:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa1:	c9                   	leaveq 
  802fa2:	c3                   	retq   

0000000000802fa3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fa3:	55                   	push   %rbp
  802fa4:	48 89 e5             	mov    %rsp,%rbp
  802fa7:	48 83 ec 10          	sub    $0x10,%rsp
  802fab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802faf:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb6:	8b 50 0c             	mov    0xc(%rax),%edx
  802fb9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc0:	00 00 00 
  802fc3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802fc5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fcc:	00 00 00 
  802fcf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fd2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fd5:	be 00 00 00 00       	mov    $0x0,%esi
  802fda:	bf 02 00 00 00       	mov    $0x2,%edi
  802fdf:	48 b8 8f 2d 80 00 00 	movabs $0x802d8f,%rax
  802fe6:	00 00 00 
  802fe9:	ff d0                	callq  *%rax
}
  802feb:	c9                   	leaveq 
  802fec:	c3                   	retq   

0000000000802fed <remove>:

// Delete a file
int
remove(const char *path)
{
  802fed:	55                   	push   %rbp
  802fee:	48 89 e5             	mov    %rsp,%rbp
  802ff1:	48 83 ec 10          	sub    $0x10,%rsp
  802ff5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffd:	48 89 c7             	mov    %rax,%rdi
  803000:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
  80300c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803011:	7e 07                	jle    80301a <remove+0x2d>
		return -E_BAD_PATH;
  803013:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803018:	eb 33                	jmp    80304d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80301a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301e:	48 89 c6             	mov    %rax,%rsi
  803021:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803028:	00 00 00 
  80302b:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  803032:	00 00 00 
  803035:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803037:	be 00 00 00 00       	mov    $0x0,%esi
  80303c:	bf 07 00 00 00       	mov    $0x7,%edi
  803041:	48 b8 8f 2d 80 00 00 	movabs $0x802d8f,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
}
  80304d:	c9                   	leaveq 
  80304e:	c3                   	retq   

000000000080304f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80304f:	55                   	push   %rbp
  803050:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803053:	be 00 00 00 00       	mov    $0x0,%esi
  803058:	bf 08 00 00 00       	mov    $0x8,%edi
  80305d:	48 b8 8f 2d 80 00 00 	movabs $0x802d8f,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
}
  803069:	5d                   	pop    %rbp
  80306a:	c3                   	retq   

000000000080306b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80306b:	55                   	push   %rbp
  80306c:	48 89 e5             	mov    %rsp,%rbp
  80306f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803076:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80307d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803084:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80308b:	be 00 00 00 00       	mov    $0x0,%esi
  803090:	48 89 c7             	mov    %rax,%rdi
  803093:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
  80309f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a6:	79 28                	jns    8030d0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ab:	89 c6                	mov    %eax,%esi
  8030ad:	48 bf 51 58 80 00 00 	movabs $0x805851,%rdi
  8030b4:	00 00 00 
  8030b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bc:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  8030c3:	00 00 00 
  8030c6:	ff d2                	callq  *%rdx
		return fd_src;
  8030c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cb:	e9 74 01 00 00       	jmpq   803244 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8030d0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8030d7:	be 01 01 00 00       	mov    $0x101,%esi
  8030dc:	48 89 c7             	mov    %rax,%rdi
  8030df:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
  8030eb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8030ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030f2:	79 39                	jns    80312d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8030f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030f7:	89 c6                	mov    %eax,%esi
  8030f9:	48 bf 67 58 80 00 00 	movabs $0x805867,%rdi
  803100:	00 00 00 
  803103:	b8 00 00 00 00       	mov    $0x0,%eax
  803108:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  80310f:	00 00 00 
  803112:	ff d2                	callq  *%rdx
		close(fd_src);
  803114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803117:	89 c7                	mov    %eax,%edi
  803119:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803120:	00 00 00 
  803123:	ff d0                	callq  *%rax
		return fd_dest;
  803125:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803128:	e9 17 01 00 00       	jmpq   803244 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80312d:	eb 74                	jmp    8031a3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80312f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803132:	48 63 d0             	movslq %eax,%rdx
  803135:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80313c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313f:	48 89 ce             	mov    %rcx,%rsi
  803142:	89 c7                	mov    %eax,%edi
  803144:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  80314b:	00 00 00 
  80314e:	ff d0                	callq  *%rax
  803150:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803153:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803157:	79 4a                	jns    8031a3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803159:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80315c:	89 c6                	mov    %eax,%esi
  80315e:	48 bf 81 58 80 00 00 	movabs $0x805881,%rdi
  803165:	00 00 00 
  803168:	b8 00 00 00 00       	mov    $0x0,%eax
  80316d:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  803174:	00 00 00 
  803177:	ff d2                	callq  *%rdx
			close(fd_src);
  803179:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317c:	89 c7                	mov    %eax,%edi
  80317e:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
			close(fd_dest);
  80318a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80318d:	89 c7                	mov    %eax,%edi
  80318f:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
			return write_size;
  80319b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80319e:	e9 a1 00 00 00       	jmpq   803244 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031a3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ad:	ba 00 02 00 00       	mov    $0x200,%edx
  8031b2:	48 89 ce             	mov    %rcx,%rsi
  8031b5:	89 c7                	mov    %eax,%edi
  8031b7:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
  8031c3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8031c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031ca:	0f 8f 5f ff ff ff    	jg     80312f <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  8031d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031d4:	79 47                	jns    80321d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8031d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031d9:	89 c6                	mov    %eax,%esi
  8031db:	48 bf 94 58 80 00 00 	movabs $0x805894,%rdi
  8031e2:	00 00 00 
  8031e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ea:	48 ba f7 0b 80 00 00 	movabs $0x800bf7,%rdx
  8031f1:	00 00 00 
  8031f4:	ff d2                	callq  *%rdx
		close(fd_src);
  8031f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f9:	89 c7                	mov    %eax,%edi
  8031fb:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803202:	00 00 00 
  803205:	ff d0                	callq  *%rax
		close(fd_dest);
  803207:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80320a:	89 c7                	mov    %eax,%edi
  80320c:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803213:	00 00 00 
  803216:	ff d0                	callq  *%rax
		return read_size;
  803218:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80321b:	eb 27                	jmp    803244 <copy+0x1d9>
	}
	close(fd_src);
  80321d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803220:	89 c7                	mov    %eax,%edi
  803222:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
	close(fd_dest);
  80322e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803231:	89 c7                	mov    %eax,%edi
  803233:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
	return 0;
  80323f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803244:	c9                   	leaveq 
  803245:	c3                   	retq   

0000000000803246 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	48 83 ec 20          	sub    $0x20,%rsp
  80324e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803251:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803255:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803258:	48 89 d6             	mov    %rdx,%rsi
  80325b:	89 c7                	mov    %eax,%edi
  80325d:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
  803269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803270:	79 05                	jns    803277 <fd2sockid+0x31>
		return r;
  803272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803275:	eb 24                	jmp    80329b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803277:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327b:	8b 10                	mov    (%rax),%edx
  80327d:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803284:	00 00 00 
  803287:	8b 00                	mov    (%rax),%eax
  803289:	39 c2                	cmp    %eax,%edx
  80328b:	74 07                	je     803294 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80328d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803292:	eb 07                	jmp    80329b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803294:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803298:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 20          	sub    $0x20,%rsp
  8032a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8032a8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032ac:	48 89 c7             	mov    %rax,%rdi
  8032af:	48 b8 74 24 80 00 00 	movabs $0x802474,%rax
  8032b6:	00 00 00 
  8032b9:	ff d0                	callq  *%rax
  8032bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c2:	78 26                	js     8032ea <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8032c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c8:	ba 07 04 00 00       	mov    $0x407,%edx
  8032cd:	48 89 c6             	mov    %rax,%rsi
  8032d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d5:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	callq  *%rax
  8032e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e8:	79 16                	jns    803300 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ed:	89 c7                	mov    %eax,%edi
  8032ef:	48 b8 ac 37 80 00 00 	movabs $0x8037ac,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
		return r;
  8032fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fe:	eb 3a                	jmp    80333a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80330b:	00 00 00 
  80330e:	8b 12                	mov    (%rdx),%edx
  803310:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803316:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80331d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803321:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803324:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332b:	48 89 c7             	mov    %rax,%rdi
  80332e:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  803335:	00 00 00 
  803338:	ff d0                	callq  *%rax
}
  80333a:	c9                   	leaveq 
  80333b:	c3                   	retq   

000000000080333c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80333c:	55                   	push   %rbp
  80333d:	48 89 e5             	mov    %rsp,%rbp
  803340:	48 83 ec 30          	sub    $0x30,%rsp
  803344:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80334b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80334f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803352:	89 c7                	mov    %eax,%edi
  803354:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  80335b:	00 00 00 
  80335e:	ff d0                	callq  *%rax
  803360:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803367:	79 05                	jns    80336e <accept+0x32>
		return r;
  803369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336c:	eb 3b                	jmp    8033a9 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80336e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803372:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803379:	48 89 ce             	mov    %rcx,%rsi
  80337c:	89 c7                	mov    %eax,%edi
  80337e:	48 b8 89 36 80 00 00 	movabs $0x803689,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
  80338a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803391:	79 05                	jns    803398 <accept+0x5c>
		return r;
  803393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803396:	eb 11                	jmp    8033a9 <accept+0x6d>
	return alloc_sockfd(r);
  803398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339b:	89 c7                	mov    %eax,%edi
  80339d:	48 b8 9d 32 80 00 00 	movabs $0x80329d,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
}
  8033a9:	c9                   	leaveq 
  8033aa:	c3                   	retq   

00000000008033ab <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033ab:	55                   	push   %rbp
  8033ac:	48 89 e5             	mov    %rsp,%rbp
  8033af:	48 83 ec 20          	sub    $0x20,%rsp
  8033b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ba:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033c0:	89 c7                	mov    %eax,%edi
  8033c2:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
  8033ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d5:	79 05                	jns    8033dc <bind+0x31>
		return r;
  8033d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033da:	eb 1b                	jmp    8033f7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033dc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033df:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e6:	48 89 ce             	mov    %rcx,%rsi
  8033e9:	89 c7                	mov    %eax,%edi
  8033eb:	48 b8 08 37 80 00 00 	movabs $0x803708,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
}
  8033f7:	c9                   	leaveq 
  8033f8:	c3                   	retq   

00000000008033f9 <shutdown>:

int
shutdown(int s, int how)
{
  8033f9:	55                   	push   %rbp
  8033fa:	48 89 e5             	mov    %rsp,%rbp
  8033fd:	48 83 ec 20          	sub    $0x20,%rsp
  803401:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803404:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803407:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340a:	89 c7                	mov    %eax,%edi
  80340c:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  803413:	00 00 00 
  803416:	ff d0                	callq  *%rax
  803418:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80341f:	79 05                	jns    803426 <shutdown+0x2d>
		return r;
  803421:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803424:	eb 16                	jmp    80343c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803426:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803429:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342c:	89 d6                	mov    %edx,%esi
  80342e:	89 c7                	mov    %eax,%edi
  803430:	48 b8 6c 37 80 00 00 	movabs $0x80376c,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
}
  80343c:	c9                   	leaveq 
  80343d:	c3                   	retq   

000000000080343e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80343e:	55                   	push   %rbp
  80343f:	48 89 e5             	mov    %rsp,%rbp
  803442:	48 83 ec 10          	sub    $0x10,%rsp
  803446:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80344a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80344e:	48 89 c7             	mov    %rax,%rdi
  803451:	48 b8 89 4a 80 00 00 	movabs $0x804a89,%rax
  803458:	00 00 00 
  80345b:	ff d0                	callq  *%rax
  80345d:	83 f8 01             	cmp    $0x1,%eax
  803460:	75 17                	jne    803479 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803466:	8b 40 0c             	mov    0xc(%rax),%eax
  803469:	89 c7                	mov    %eax,%edi
  80346b:	48 b8 ac 37 80 00 00 	movabs $0x8037ac,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
  803477:	eb 05                	jmp    80347e <devsock_close+0x40>
	else
		return 0;
  803479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80347e:	c9                   	leaveq 
  80347f:	c3                   	retq   

0000000000803480 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803480:	55                   	push   %rbp
  803481:	48 89 e5             	mov    %rsp,%rbp
  803484:	48 83 ec 20          	sub    $0x20,%rsp
  803488:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80348b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80348f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803492:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803495:	89 c7                	mov    %eax,%edi
  803497:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
  8034a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034aa:	79 05                	jns    8034b1 <connect+0x31>
		return r;
  8034ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034af:	eb 1b                	jmp    8034cc <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8034b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034b4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bb:	48 89 ce             	mov    %rcx,%rsi
  8034be:	89 c7                	mov    %eax,%edi
  8034c0:	48 b8 d9 37 80 00 00 	movabs $0x8037d9,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
}
  8034cc:	c9                   	leaveq 
  8034cd:	c3                   	retq   

00000000008034ce <listen>:

int
listen(int s, int backlog)
{
  8034ce:	55                   	push   %rbp
  8034cf:	48 89 e5             	mov    %rsp,%rbp
  8034d2:	48 83 ec 20          	sub    $0x20,%rsp
  8034d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034df:	89 c7                	mov    %eax,%edi
  8034e1:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
  8034ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f4:	79 05                	jns    8034fb <listen+0x2d>
		return r;
  8034f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f9:	eb 16                	jmp    803511 <listen+0x43>
	return nsipc_listen(r, backlog);
  8034fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803501:	89 d6                	mov    %edx,%esi
  803503:	89 c7                	mov    %eax,%edi
  803505:	48 b8 3d 38 80 00 00 	movabs $0x80383d,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
}
  803511:	c9                   	leaveq 
  803512:	c3                   	retq   

0000000000803513 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 20          	sub    $0x20,%rsp
  80351b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80351f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803523:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352b:	89 c2                	mov    %eax,%edx
  80352d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803531:	8b 40 0c             	mov    0xc(%rax),%eax
  803534:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803538:	b9 00 00 00 00       	mov    $0x0,%ecx
  80353d:	89 c7                	mov    %eax,%edi
  80353f:	48 b8 7d 38 80 00 00 	movabs $0x80387d,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
}
  80354b:	c9                   	leaveq 
  80354c:	c3                   	retq   

000000000080354d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80354d:	55                   	push   %rbp
  80354e:	48 89 e5             	mov    %rsp,%rbp
  803551:	48 83 ec 20          	sub    $0x20,%rsp
  803555:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803559:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80355d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803565:	89 c2                	mov    %eax,%edx
  803567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356b:	8b 40 0c             	mov    0xc(%rax),%eax
  80356e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803572:	b9 00 00 00 00       	mov    $0x0,%ecx
  803577:	89 c7                	mov    %eax,%edi
  803579:	48 b8 49 39 80 00 00 	movabs $0x803949,%rax
  803580:	00 00 00 
  803583:	ff d0                	callq  *%rax
}
  803585:	c9                   	leaveq 
  803586:	c3                   	retq   

0000000000803587 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803587:	55                   	push   %rbp
  803588:	48 89 e5             	mov    %rsp,%rbp
  80358b:	48 83 ec 10          	sub    $0x10,%rsp
  80358f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803593:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359b:	48 be af 58 80 00 00 	movabs $0x8058af,%rsi
  8035a2:	00 00 00 
  8035a5:	48 89 c7             	mov    %rax,%rdi
  8035a8:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  8035af:	00 00 00 
  8035b2:	ff d0                	callq  *%rax
	return 0;
  8035b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b9:	c9                   	leaveq 
  8035ba:	c3                   	retq   

00000000008035bb <socket>:

int
socket(int domain, int type, int protocol)
{
  8035bb:	55                   	push   %rbp
  8035bc:	48 89 e5             	mov    %rsp,%rbp
  8035bf:	48 83 ec 20          	sub    $0x20,%rsp
  8035c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035c6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035c9:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035cc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035cf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d5:	89 ce                	mov    %ecx,%esi
  8035d7:	89 c7                	mov    %eax,%edi
  8035d9:	48 b8 01 3a 80 00 00 	movabs $0x803a01,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
  8035e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ec:	79 05                	jns    8035f3 <socket+0x38>
		return r;
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f1:	eb 11                	jmp    803604 <socket+0x49>
	return alloc_sockfd(r);
  8035f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f6:	89 c7                	mov    %eax,%edi
  8035f8:	48 b8 9d 32 80 00 00 	movabs $0x80329d,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
}
  803604:	c9                   	leaveq 
  803605:	c3                   	retq   

0000000000803606 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803606:	55                   	push   %rbp
  803607:	48 89 e5             	mov    %rsp,%rbp
  80360a:	48 83 ec 10          	sub    $0x10,%rsp
  80360e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803611:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803618:	00 00 00 
  80361b:	8b 00                	mov    (%rax),%eax
  80361d:	85 c0                	test   %eax,%eax
  80361f:	75 1f                	jne    803640 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803621:	bf 02 00 00 00       	mov    $0x2,%edi
  803626:	48 b8 17 4a 80 00 00 	movabs $0x804a17,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
  803632:	89 c2                	mov    %eax,%edx
  803634:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80363b:	00 00 00 
  80363e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803640:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803647:	00 00 00 
  80364a:	8b 00                	mov    (%rax),%eax
  80364c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80364f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803654:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80365b:	00 00 00 
  80365e:	89 c7                	mov    %eax,%edi
  803660:	48 b8 8a 48 80 00 00 	movabs $0x80488a,%rax
  803667:	00 00 00 
  80366a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80366c:	ba 00 00 00 00       	mov    $0x0,%edx
  803671:	be 00 00 00 00       	mov    $0x0,%esi
  803676:	bf 00 00 00 00       	mov    $0x0,%edi
  80367b:	48 b8 4c 48 80 00 00 	movabs $0x80484c,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
}
  803687:	c9                   	leaveq 
  803688:	c3                   	retq   

0000000000803689 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803689:	55                   	push   %rbp
  80368a:	48 89 e5             	mov    %rsp,%rbp
  80368d:	48 83 ec 30          	sub    $0x30,%rsp
  803691:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803694:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803698:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80369c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036a3:	00 00 00 
  8036a6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036a9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8036b0:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
  8036bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c3:	78 3e                	js     803703 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8036c5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036cc:	00 00 00 
  8036cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d7:	8b 40 10             	mov    0x10(%rax),%eax
  8036da:	89 c2                	mov    %eax,%edx
  8036dc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e4:	48 89 ce             	mov    %rcx,%rsi
  8036e7:	48 89 c7             	mov    %rax,%rdi
  8036ea:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fa:	8b 50 10             	mov    0x10(%rax),%edx
  8036fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803701:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803703:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803706:	c9                   	leaveq 
  803707:	c3                   	retq   

0000000000803708 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803708:	55                   	push   %rbp
  803709:	48 89 e5             	mov    %rsp,%rbp
  80370c:	48 83 ec 10          	sub    $0x10,%rsp
  803710:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803713:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803717:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80371a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803721:	00 00 00 
  803724:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803727:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803729:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80372c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803730:	48 89 c6             	mov    %rax,%rsi
  803733:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80373a:	00 00 00 
  80373d:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803749:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803750:	00 00 00 
  803753:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803756:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803759:	bf 02 00 00 00       	mov    $0x2,%edi
  80375e:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
}
  80376a:	c9                   	leaveq 
  80376b:	c3                   	retq   

000000000080376c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80376c:	55                   	push   %rbp
  80376d:	48 89 e5             	mov    %rsp,%rbp
  803770:	48 83 ec 10          	sub    $0x10,%rsp
  803774:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803777:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80377a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803781:	00 00 00 
  803784:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803787:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803789:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803790:	00 00 00 
  803793:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803796:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803799:	bf 03 00 00 00       	mov    $0x3,%edi
  80379e:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
}
  8037aa:	c9                   	leaveq 
  8037ab:	c3                   	retq   

00000000008037ac <nsipc_close>:

int
nsipc_close(int s)
{
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	48 83 ec 10          	sub    $0x10,%rsp
  8037b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8037b7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037be:	00 00 00 
  8037c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037c4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8037c6:	bf 04 00 00 00       	mov    $0x4,%edi
  8037cb:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
}
  8037d7:	c9                   	leaveq 
  8037d8:	c3                   	retq   

00000000008037d9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037d9:	55                   	push   %rbp
  8037da:	48 89 e5             	mov    %rsp,%rbp
  8037dd:	48 83 ec 10          	sub    $0x10,%rsp
  8037e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037eb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037f2:	00 00 00 
  8037f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037f8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037fa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803801:	48 89 c6             	mov    %rax,%rsi
  803804:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80380b:	00 00 00 
  80380e:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  803815:	00 00 00 
  803818:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80381a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803821:	00 00 00 
  803824:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803827:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80382a:	bf 05 00 00 00       	mov    $0x5,%edi
  80382f:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
}
  80383b:	c9                   	leaveq 
  80383c:	c3                   	retq   

000000000080383d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80383d:	55                   	push   %rbp
  80383e:	48 89 e5             	mov    %rsp,%rbp
  803841:	48 83 ec 10          	sub    $0x10,%rsp
  803845:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803848:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80384b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803852:	00 00 00 
  803855:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803858:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80385a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803861:	00 00 00 
  803864:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803867:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80386a:	bf 06 00 00 00       	mov    $0x6,%edi
  80386f:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
}
  80387b:	c9                   	leaveq 
  80387c:	c3                   	retq   

000000000080387d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80387d:	55                   	push   %rbp
  80387e:	48 89 e5             	mov    %rsp,%rbp
  803881:	48 83 ec 30          	sub    $0x30,%rsp
  803885:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803888:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80388c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80388f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803892:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803899:	00 00 00 
  80389c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80389f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8038a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038a8:	00 00 00 
  8038ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038ae:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8038b1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038b8:	00 00 00 
  8038bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8038be:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038c1:	bf 07 00 00 00       	mov    $0x7,%edi
  8038c6:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
  8038d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d9:	78 69                	js     803944 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038db:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038e2:	7f 08                	jg     8038ec <nsipc_recv+0x6f>
  8038e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038ea:	7e 35                	jle    803921 <nsipc_recv+0xa4>
  8038ec:	48 b9 b6 58 80 00 00 	movabs $0x8058b6,%rcx
  8038f3:	00 00 00 
  8038f6:	48 ba cb 58 80 00 00 	movabs $0x8058cb,%rdx
  8038fd:	00 00 00 
  803900:	be 61 00 00 00       	mov    $0x61,%esi
  803905:	48 bf e0 58 80 00 00 	movabs $0x8058e0,%rdi
  80390c:	00 00 00 
  80390f:	b8 00 00 00 00       	mov    $0x0,%eax
  803914:	49 b8 be 09 80 00 00 	movabs $0x8009be,%r8
  80391b:	00 00 00 
  80391e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803924:	48 63 d0             	movslq %eax,%rdx
  803927:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80392b:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803932:	00 00 00 
  803935:	48 89 c7             	mov    %rax,%rdi
  803938:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
	}

	return r;
  803944:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803947:	c9                   	leaveq 
  803948:	c3                   	retq   

0000000000803949 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803949:	55                   	push   %rbp
  80394a:	48 89 e5             	mov    %rsp,%rbp
  80394d:	48 83 ec 20          	sub    $0x20,%rsp
  803951:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803954:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803958:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80395b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80395e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803965:	00 00 00 
  803968:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80396b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80396d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803974:	7e 35                	jle    8039ab <nsipc_send+0x62>
  803976:	48 b9 ec 58 80 00 00 	movabs $0x8058ec,%rcx
  80397d:	00 00 00 
  803980:	48 ba cb 58 80 00 00 	movabs $0x8058cb,%rdx
  803987:	00 00 00 
  80398a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80398f:	48 bf e0 58 80 00 00 	movabs $0x8058e0,%rdi
  803996:	00 00 00 
  803999:	b8 00 00 00 00       	mov    $0x0,%eax
  80399e:	49 b8 be 09 80 00 00 	movabs $0x8009be,%r8
  8039a5:	00 00 00 
  8039a8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039ae:	48 63 d0             	movslq %eax,%rdx
  8039b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b5:	48 89 c6             	mov    %rax,%rsi
  8039b8:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8039bf:	00 00 00 
  8039c2:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  8039c9:	00 00 00 
  8039cc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8039ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039d5:	00 00 00 
  8039d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039db:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039de:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e5:	00 00 00 
  8039e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039eb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039ee:	bf 08 00 00 00       	mov    $0x8,%edi
  8039f3:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
}
  8039ff:	c9                   	leaveq 
  803a00:	c3                   	retq   

0000000000803a01 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a01:	55                   	push   %rbp
  803a02:	48 89 e5             	mov    %rsp,%rbp
  803a05:	48 83 ec 10          	sub    $0x10,%rsp
  803a09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a0f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a12:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a19:	00 00 00 
  803a1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a21:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a28:	00 00 00 
  803a2b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a31:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a38:	00 00 00 
  803a3b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a3e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a41:	bf 09 00 00 00       	mov    $0x9,%edi
  803a46:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
}
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   

0000000000803a54 <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	48 83 ec 20          	sub    $0x20,%rsp
  803a5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  803a64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6c:	48 01 d0             	add    %rdx,%rax
  803a6f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803a7b:	eb 64                	jmp    803ae1 <isfree+0x8d>
		if (va >= (uintptr_t) mend
  803a7d:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803a84:	00 00 00 
  803a87:	48 8b 00             	mov    (%rax),%rax
  803a8a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803a8e:	76 42                	jbe    803ad2 <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a94:	48 c1 e8 15          	shr    $0x15,%rax
  803a98:	48 89 c2             	mov    %rax,%rdx
  803a9b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803aa2:	01 00 00 
  803aa5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aa9:	83 e0 01             	and    $0x1,%eax
  803aac:	48 85 c0             	test   %rax,%rax
  803aaf:	74 28                	je     803ad9 <isfree+0x85>
  803ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ab5:	48 c1 e8 0c          	shr    $0xc,%rax
  803ab9:	48 89 c2             	mov    %rax,%rdx
  803abc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ac3:	01 00 00 
  803ac6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aca:	83 e0 01             	and    $0x1,%eax
  803acd:	48 85 c0             	test   %rax,%rax
  803ad0:	74 07                	je     803ad9 <isfree+0x85>
			return 0;
  803ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad7:	eb 17                	jmp    803af0 <isfree+0x9c>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803ad9:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803ae0:	00 
  803ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803ae9:	72 92                	jb     803a7d <isfree+0x29>
	return 1;
  803aeb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803af0:	c9                   	leaveq 
  803af1:	c3                   	retq   

0000000000803af2 <malloc>:

void*
malloc(size_t n)
{
  803af2:	55                   	push   %rbp
  803af3:	48 89 e5             	mov    %rsp,%rbp
  803af6:	48 83 ec 60          	sub    $0x60,%rsp
  803afa:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803afe:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b05:	00 00 00 
  803b08:	48 8b 00             	mov    (%rax),%rax
  803b0b:	48 85 c0             	test   %rax,%rax
  803b0e:	75 1a                	jne    803b2a <malloc+0x38>
		mptr = mbegin;
  803b10:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803b17:	00 00 00 
  803b1a:	48 8b 10             	mov    (%rax),%rdx
  803b1d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b24:	00 00 00 
  803b27:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  803b2a:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  803b31:	00 
  803b32:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3a:	48 01 d0             	add    %rdx,%rax
  803b3d:	48 83 e8 01          	sub    $0x1,%rax
  803b41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b49:	ba 00 00 00 00       	mov    $0x0,%edx
  803b4e:	48 f7 75 f0          	divq   -0x10(%rbp)
  803b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b56:	48 29 d0             	sub    %rdx,%rax
  803b59:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	if (n >= MAXMALLOC)
  803b5d:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  803b64:	00 
  803b65:	76 0a                	jbe    803b71 <malloc+0x7f>
		return 0;
  803b67:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6c:	e9 f1 02 00 00       	jmpq   803e62 <malloc+0x370>

	if ((uintptr_t) mptr % PGSIZE){
  803b71:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b78:	00 00 00 
  803b7b:	48 8b 00             	mov    (%rax),%rax
  803b7e:	25 ff 0f 00 00       	and    $0xfff,%eax
  803b83:	48 85 c0             	test   %rax,%rax
  803b86:	0f 84 0f 01 00 00    	je     803c9b <malloc+0x1a9>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803b8c:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803b93:	00 
  803b94:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b9b:	00 00 00 
  803b9e:	48 8b 00             	mov    (%rax),%rax
  803ba1:	48 89 c2             	mov    %rax,%rdx
  803ba4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba8:	48 01 d0             	add    %rdx,%rax
  803bab:	48 83 e8 01          	sub    $0x1,%rax
  803baf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803bb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  803bbc:	48 f7 75 e0          	divq   -0x20(%rbp)
  803bc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc4:	48 29 d0             	sub    %rdx,%rax
  803bc7:	48 83 e8 04          	sub    $0x4,%rax
  803bcb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803bcf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803bd6:	00 00 00 
  803bd9:	48 8b 00             	mov    (%rax),%rax
  803bdc:	48 c1 e8 0c          	shr    $0xc,%rax
  803be0:	48 89 c1             	mov    %rax,%rcx
  803be3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803bea:	00 00 00 
  803bed:	48 8b 00             	mov    (%rax),%rax
  803bf0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803bf4:	48 83 c2 03          	add    $0x3,%rdx
  803bf8:	48 01 d0             	add    %rdx,%rax
  803bfb:	48 c1 e8 0c          	shr    $0xc,%rax
  803bff:	48 39 c1             	cmp    %rax,%rcx
  803c02:	75 4a                	jne    803c4e <malloc+0x15c>
			(*ref)++;
  803c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c08:	8b 00                	mov    (%rax),%eax
  803c0a:	8d 50 01             	lea    0x1(%rax),%edx
  803c0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c11:	89 10                	mov    %edx,(%rax)
			v = mptr;
  803c13:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c1a:	00 00 00 
  803c1d:	48 8b 00             	mov    (%rax),%rax
  803c20:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  803c24:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c2b:	00 00 00 
  803c2e:	48 8b 10             	mov    (%rax),%rdx
  803c31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c35:	48 01 c2             	add    %rax,%rdx
  803c38:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c3f:	00 00 00 
  803c42:	48 89 10             	mov    %rdx,(%rax)
			return v;
  803c45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c49:	e9 14 02 00 00       	jmpq   803e62 <malloc+0x370>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803c4e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c55:	00 00 00 
  803c58:	48 8b 00             	mov    (%rax),%rax
  803c5b:	48 89 c7             	mov    %rax,%rdi
  803c5e:	48 b8 64 3e 80 00 00 	movabs $0x803e64,%rax
  803c65:	00 00 00 
  803c68:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803c6a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c71:	00 00 00 
  803c74:	48 8b 00             	mov    (%rax),%rax
  803c77:	48 05 00 10 00 00    	add    $0x1000,%rax
  803c7d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803c81:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803c85:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803c8b:	48 89 c2             	mov    %rax,%rdx
  803c8e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c95:	00 00 00 
  803c98:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  803c9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  803ca2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ca6:	48 8d 50 04          	lea    0x4(%rax),%rdx
  803caa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803cb1:	00 00 00 
  803cb4:	48 8b 00             	mov    (%rax),%rax
  803cb7:	48 89 d6             	mov    %rdx,%rsi
  803cba:	48 89 c7             	mov    %rax,%rdi
  803cbd:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803cc4:	00 00 00 
  803cc7:	ff d0                	callq  *%rax
  803cc9:	85 c0                	test   %eax,%eax
  803ccb:	74 0d                	je     803cda <malloc+0x1e8>
			break;
  803ccd:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803cce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cd5:	e9 14 01 00 00       	jmpq   803dee <malloc+0x2fc>
		mptr += PGSIZE;
  803cda:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ce1:	00 00 00 
  803ce4:	48 8b 00             	mov    (%rax),%rax
  803ce7:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  803cee:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803cf5:	00 00 00 
  803cf8:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  803cfb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d02:	00 00 00 
  803d05:	48 8b 10             	mov    (%rax),%rdx
  803d08:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803d0f:	00 00 00 
  803d12:	48 8b 00             	mov    (%rax),%rax
  803d15:	48 39 c2             	cmp    %rax,%rdx
  803d18:	75 2e                	jne    803d48 <malloc+0x256>
			mptr = mbegin;
  803d1a:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803d21:	00 00 00 
  803d24:	48 8b 10             	mov    (%rax),%rdx
  803d27:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d2e:	00 00 00 
  803d31:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  803d34:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  803d38:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  803d3c:	75 0a                	jne    803d48 <malloc+0x256>
				return 0;	/* out of address space */
  803d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d43:	e9 1a 01 00 00       	jmpq   803e62 <malloc+0x370>
	}
  803d48:	e9 55 ff ff ff       	jmpq   803ca2 <malloc+0x1b0>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d50:	05 00 10 00 00       	add    $0x1000,%eax
  803d55:	48 98                	cltq   
  803d57:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803d5b:	48 83 c2 04          	add    $0x4,%rdx
  803d5f:	48 39 d0             	cmp    %rdx,%rax
  803d62:	73 07                	jae    803d6b <malloc+0x279>
  803d64:	b8 00 04 00 00       	mov    $0x400,%eax
  803d69:	eb 05                	jmp    803d70 <malloc+0x27e>
  803d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d70:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803d73:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803d76:	83 c8 07             	or     $0x7,%eax
  803d79:	89 c2                	mov    %eax,%edx
  803d7b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d82:	00 00 00 
  803d85:	48 8b 08             	mov    (%rax),%rcx
  803d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8b:	48 98                	cltq   
  803d8d:	48 01 c8             	add    %rcx,%rax
  803d90:	48 89 c6             	mov    %rax,%rsi
  803d93:	bf 00 00 00 00       	mov    $0x0,%edi
  803d98:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  803d9f:	00 00 00 
  803da2:	ff d0                	callq  *%rax
  803da4:	85 c0                	test   %eax,%eax
  803da6:	79 3f                	jns    803de7 <malloc+0x2f5>
			for (; i >= 0; i -= PGSIZE)
  803da8:	eb 30                	jmp    803dda <malloc+0x2e8>
				sys_page_unmap(0, mptr + i);
  803daa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803db1:	00 00 00 
  803db4:	48 8b 10             	mov    (%rax),%rdx
  803db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dba:	48 98                	cltq   
  803dbc:	48 01 d0             	add    %rdx,%rax
  803dbf:	48 89 c6             	mov    %rax,%rsi
  803dc2:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc7:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  803dce:	00 00 00 
  803dd1:	ff d0                	callq  *%rax
			for (; i >= 0; i -= PGSIZE)
  803dd3:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  803dda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dde:	79 ca                	jns    803daa <malloc+0x2b8>
			return 0;	/* out of physical memory */
  803de0:	b8 00 00 00 00       	mov    $0x0,%eax
  803de5:	eb 7b                	jmp    803e62 <malloc+0x370>
	for (i = 0; i < n + 4; i += PGSIZE){
  803de7:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df1:	48 98                	cltq   
  803df3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803df7:	48 83 c2 04          	add    $0x4,%rdx
  803dfb:	48 39 d0             	cmp    %rdx,%rax
  803dfe:	0f 82 49 ff ff ff    	jb     803d4d <malloc+0x25b>
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  803e04:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e0b:	00 00 00 
  803e0e:	48 8b 00             	mov    (%rax),%rax
  803e11:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e14:	48 63 d2             	movslq %edx,%rdx
  803e17:	48 83 ea 04          	sub    $0x4,%rdx
  803e1b:	48 01 d0             	add    %rdx,%rax
  803e1e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  803e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e26:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  803e2c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e33:	00 00 00 
  803e36:	48 8b 00             	mov    (%rax),%rax
  803e39:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  803e3d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e44:	00 00 00 
  803e47:	48 8b 10             	mov    (%rax),%rdx
  803e4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e4e:	48 01 c2             	add    %rax,%rdx
  803e51:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e58:	00 00 00 
  803e5b:	48 89 10             	mov    %rdx,(%rax)
	return v;
  803e5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  803e62:	c9                   	leaveq 
  803e63:	c3                   	retq   

0000000000803e64 <free>:

void
free(void *v)
{
  803e64:	55                   	push   %rbp
  803e65:	48 89 e5             	mov    %rsp,%rbp
  803e68:	48 83 ec 30          	sub    $0x30,%rsp
  803e6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  803e70:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e75:	75 05                	jne    803e7c <free+0x18>
		return;
  803e77:	e9 54 01 00 00       	jmpq   803fd0 <free+0x16c>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  803e7c:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803e83:	00 00 00 
  803e86:	48 8b 00             	mov    (%rax),%rax
  803e89:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803e8d:	77 13                	ja     803ea2 <free+0x3e>
  803e8f:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803e96:	00 00 00 
  803e99:	48 8b 00             	mov    (%rax),%rax
  803e9c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803ea0:	72 35                	jb     803ed7 <free+0x73>
  803ea2:	48 b9 f8 58 80 00 00 	movabs $0x8058f8,%rcx
  803ea9:	00 00 00 
  803eac:	48 ba 26 59 80 00 00 	movabs $0x805926,%rdx
  803eb3:	00 00 00 
  803eb6:	be 7a 00 00 00       	mov    $0x7a,%esi
  803ebb:	48 bf 3b 59 80 00 00 	movabs $0x80593b,%rdi
  803ec2:	00 00 00 
  803ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eca:	49 b8 be 09 80 00 00 	movabs $0x8009be,%r8
  803ed1:	00 00 00 
  803ed4:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  803ed7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803edb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  803edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803ee9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803eed:	eb 7b                	jmp    803f6a <free+0x106>
		sys_page_unmap(0, c);
  803eef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef3:	48 89 c6             	mov    %rax,%rsi
  803ef6:	bf 00 00 00 00       	mov    $0x0,%edi
  803efb:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
		c += PGSIZE;
  803f07:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f0e:	00 
		assert(mbegin <= c && c < mend);
  803f0f:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803f16:	00 00 00 
  803f19:	48 8b 00             	mov    (%rax),%rax
  803f1c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803f20:	77 13                	ja     803f35 <free+0xd1>
  803f22:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803f29:	00 00 00 
  803f2c:	48 8b 00             	mov    (%rax),%rax
  803f2f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803f33:	72 35                	jb     803f6a <free+0x106>
  803f35:	48 b9 48 59 80 00 00 	movabs $0x805948,%rcx
  803f3c:	00 00 00 
  803f3f:	48 ba 26 59 80 00 00 	movabs $0x805926,%rdx
  803f46:	00 00 00 
  803f49:	be 81 00 00 00       	mov    $0x81,%esi
  803f4e:	48 bf 3b 59 80 00 00 	movabs $0x80593b,%rdi
  803f55:	00 00 00 
  803f58:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5d:	49 b8 be 09 80 00 00 	movabs $0x8009be,%r8
  803f64:	00 00 00 
  803f67:	41 ff d0             	callq  *%r8
	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6e:	48 c1 e8 0c          	shr    $0xc,%rax
  803f72:	48 89 c2             	mov    %rax,%rdx
  803f75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f7c:	01 00 00 
  803f7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f83:	25 00 04 00 00       	and    $0x400,%eax
  803f88:	48 85 c0             	test   %rax,%rax
  803f8b:	0f 85 5e ff ff ff    	jne    803eef <free+0x8b>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  803f91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f95:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  803f9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  803f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa3:	8b 00                	mov    (%rax),%eax
  803fa5:	8d 50 ff             	lea    -0x1(%rax),%edx
  803fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fac:	89 10                	mov    %edx,(%rax)
  803fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb2:	8b 00                	mov    (%rax),%eax
  803fb4:	85 c0                	test   %eax,%eax
  803fb6:	75 18                	jne    803fd0 <free+0x16c>
		sys_page_unmap(0, c);
  803fb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fbc:	48 89 c6             	mov    %rax,%rsi
  803fbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc4:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  803fcb:	00 00 00 
  803fce:	ff d0                	callq  *%rax
}
  803fd0:	c9                   	leaveq 
  803fd1:	c3                   	retq   

0000000000803fd2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803fd2:	55                   	push   %rbp
  803fd3:	48 89 e5             	mov    %rsp,%rbp
  803fd6:	53                   	push   %rbx
  803fd7:	48 83 ec 38          	sub    $0x38,%rsp
  803fdb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803fdf:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803fe3:	48 89 c7             	mov    %rax,%rdi
  803fe6:	48 b8 74 24 80 00 00 	movabs $0x802474,%rax
  803fed:	00 00 00 
  803ff0:	ff d0                	callq  *%rax
  803ff2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ff5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ff9:	0f 88 bf 01 00 00    	js     8041be <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804003:	ba 07 04 00 00       	mov    $0x407,%edx
  804008:	48 89 c6             	mov    %rax,%rsi
  80400b:	bf 00 00 00 00       	mov    $0x0,%edi
  804010:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  804017:	00 00 00 
  80401a:	ff d0                	callq  *%rax
  80401c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80401f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804023:	0f 88 95 01 00 00    	js     8041be <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804029:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80402d:	48 89 c7             	mov    %rax,%rdi
  804030:	48 b8 74 24 80 00 00 	movabs $0x802474,%rax
  804037:	00 00 00 
  80403a:	ff d0                	callq  *%rax
  80403c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80403f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804043:	0f 88 5d 01 00 00    	js     8041a6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804049:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404d:	ba 07 04 00 00       	mov    $0x407,%edx
  804052:	48 89 c6             	mov    %rax,%rsi
  804055:	bf 00 00 00 00       	mov    $0x0,%edi
  80405a:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  804061:	00 00 00 
  804064:	ff d0                	callq  *%rax
  804066:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804069:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80406d:	0f 88 33 01 00 00    	js     8041a6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804073:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804077:	48 89 c7             	mov    %rax,%rdi
  80407a:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
  804086:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80408a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80408e:	ba 07 04 00 00       	mov    $0x407,%edx
  804093:	48 89 c6             	mov    %rax,%rsi
  804096:	bf 00 00 00 00       	mov    $0x0,%edi
  80409b:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  8040a2:	00 00 00 
  8040a5:	ff d0                	callq  *%rax
  8040a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040ae:	79 05                	jns    8040b5 <pipe+0xe3>
		goto err2;
  8040b0:	e9 d9 00 00 00       	jmpq   80418e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040b9:	48 89 c7             	mov    %rax,%rdi
  8040bc:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  8040c3:	00 00 00 
  8040c6:	ff d0                	callq  *%rax
  8040c8:	48 89 c2             	mov    %rax,%rdx
  8040cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040cf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8040d5:	48 89 d1             	mov    %rdx,%rcx
  8040d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8040dd:	48 89 c6             	mov    %rax,%rsi
  8040e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e5:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8040ec:	00 00 00 
  8040ef:	ff d0                	callq  *%rax
  8040f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040f8:	79 1b                	jns    804115 <pipe+0x143>
		goto err3;
  8040fa:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ff:	48 89 c6             	mov    %rax,%rsi
  804102:	bf 00 00 00 00       	mov    $0x0,%edi
  804107:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  80410e:	00 00 00 
  804111:	ff d0                	callq  *%rax
  804113:	eb 79                	jmp    80418e <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  804115:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804119:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804120:	00 00 00 
  804123:	8b 12                	mov    (%rdx),%edx
  804125:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80412b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  804132:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804136:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  80413d:	00 00 00 
  804140:	8b 12                	mov    (%rdx),%edx
  804142:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804144:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804148:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80414f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804153:	48 89 c7             	mov    %rax,%rdi
  804156:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  80415d:	00 00 00 
  804160:	ff d0                	callq  *%rax
  804162:	89 c2                	mov    %eax,%edx
  804164:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804168:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80416a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80416e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804172:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804176:	48 89 c7             	mov    %rax,%rdi
  804179:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  804180:	00 00 00 
  804183:	ff d0                	callq  *%rax
  804185:	89 03                	mov    %eax,(%rbx)
	return 0;
  804187:	b8 00 00 00 00       	mov    $0x0,%eax
  80418c:	eb 33                	jmp    8041c1 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  80418e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804192:	48 89 c6             	mov    %rax,%rsi
  804195:	bf 00 00 00 00       	mov    $0x0,%edi
  80419a:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  8041a1:	00 00 00 
  8041a4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8041a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041aa:	48 89 c6             	mov    %rax,%rsi
  8041ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8041b2:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  8041b9:	00 00 00 
  8041bc:	ff d0                	callq  *%rax
err:
	return r;
  8041be:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8041c1:	48 83 c4 38          	add    $0x38,%rsp
  8041c5:	5b                   	pop    %rbx
  8041c6:	5d                   	pop    %rbp
  8041c7:	c3                   	retq   

00000000008041c8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8041c8:	55                   	push   %rbp
  8041c9:	48 89 e5             	mov    %rsp,%rbp
  8041cc:	53                   	push   %rbx
  8041cd:	48 83 ec 28          	sub    $0x28,%rsp
  8041d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8041d9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8041e0:	00 00 00 
  8041e3:	48 8b 00             	mov    (%rax),%rax
  8041e6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8041ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041f3:	48 89 c7             	mov    %rax,%rdi
  8041f6:	48 b8 89 4a 80 00 00 	movabs $0x804a89,%rax
  8041fd:	00 00 00 
  804200:	ff d0                	callq  *%rax
  804202:	89 c3                	mov    %eax,%ebx
  804204:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804208:	48 89 c7             	mov    %rax,%rdi
  80420b:	48 b8 89 4a 80 00 00 	movabs $0x804a89,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
  804217:	39 c3                	cmp    %eax,%ebx
  804219:	0f 94 c0             	sete   %al
  80421c:	0f b6 c0             	movzbl %al,%eax
  80421f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804222:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804229:	00 00 00 
  80422c:	48 8b 00             	mov    (%rax),%rax
  80422f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804235:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804238:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80423b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80423e:	75 05                	jne    804245 <_pipeisclosed+0x7d>
			return ret;
  804240:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804243:	eb 4a                	jmp    80428f <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804245:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804248:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80424b:	74 3d                	je     80428a <_pipeisclosed+0xc2>
  80424d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804251:	75 37                	jne    80428a <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804253:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80425a:	00 00 00 
  80425d:	48 8b 00             	mov    (%rax),%rax
  804260:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804266:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804269:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80426c:	89 c6                	mov    %eax,%esi
  80426e:	48 bf 65 59 80 00 00 	movabs $0x805965,%rdi
  804275:	00 00 00 
  804278:	b8 00 00 00 00       	mov    $0x0,%eax
  80427d:	49 b8 f7 0b 80 00 00 	movabs $0x800bf7,%r8
  804284:	00 00 00 
  804287:	41 ff d0             	callq  *%r8
	}
  80428a:	e9 4a ff ff ff       	jmpq   8041d9 <_pipeisclosed+0x11>
}
  80428f:	48 83 c4 28          	add    $0x28,%rsp
  804293:	5b                   	pop    %rbx
  804294:	5d                   	pop    %rbp
  804295:	c3                   	retq   

0000000000804296 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804296:	55                   	push   %rbp
  804297:	48 89 e5             	mov    %rsp,%rbp
  80429a:	48 83 ec 30          	sub    $0x30,%rsp
  80429e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8042a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042a8:	48 89 d6             	mov    %rdx,%rsi
  8042ab:	89 c7                	mov    %eax,%edi
  8042ad:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c0:	79 05                	jns    8042c7 <pipeisclosed+0x31>
		return r;
  8042c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c5:	eb 31                	jmp    8042f8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8042c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042cb:	48 89 c7             	mov    %rax,%rdi
  8042ce:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  8042d5:	00 00 00 
  8042d8:	ff d0                	callq  *%rax
  8042da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8042de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042e6:	48 89 d6             	mov    %rdx,%rsi
  8042e9:	48 89 c7             	mov    %rax,%rdi
  8042ec:	48 b8 c8 41 80 00 00 	movabs $0x8041c8,%rax
  8042f3:	00 00 00 
  8042f6:	ff d0                	callq  *%rax
}
  8042f8:	c9                   	leaveq 
  8042f9:	c3                   	retq   

00000000008042fa <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042fa:	55                   	push   %rbp
  8042fb:	48 89 e5             	mov    %rsp,%rbp
  8042fe:	48 83 ec 40          	sub    $0x40,%rsp
  804302:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804306:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80430a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80430e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804312:	48 89 c7             	mov    %rax,%rdi
  804315:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  80431c:	00 00 00 
  80431f:	ff d0                	callq  *%rax
  804321:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804325:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804329:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80432d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804334:	00 
  804335:	e9 92 00 00 00       	jmpq   8043cc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80433a:	eb 41                	jmp    80437d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80433c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804341:	74 09                	je     80434c <devpipe_read+0x52>
				return i;
  804343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804347:	e9 92 00 00 00       	jmpq   8043de <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80434c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804354:	48 89 d6             	mov    %rdx,%rsi
  804357:	48 89 c7             	mov    %rax,%rdi
  80435a:	48 b8 c8 41 80 00 00 	movabs $0x8041c8,%rax
  804361:	00 00 00 
  804364:	ff d0                	callq  *%rax
  804366:	85 c0                	test   %eax,%eax
  804368:	74 07                	je     804371 <devpipe_read+0x77>
				return 0;
  80436a:	b8 00 00 00 00       	mov    $0x0,%eax
  80436f:	eb 6d                	jmp    8043de <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804371:	48 b8 82 20 80 00 00 	movabs $0x802082,%rax
  804378:	00 00 00 
  80437b:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80437d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804381:	8b 10                	mov    (%rax),%edx
  804383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804387:	8b 40 04             	mov    0x4(%rax),%eax
  80438a:	39 c2                	cmp    %eax,%edx
  80438c:	74 ae                	je     80433c <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80438e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804396:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80439a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439e:	8b 00                	mov    (%rax),%eax
  8043a0:	99                   	cltd   
  8043a1:	c1 ea 1b             	shr    $0x1b,%edx
  8043a4:	01 d0                	add    %edx,%eax
  8043a6:	83 e0 1f             	and    $0x1f,%eax
  8043a9:	29 d0                	sub    %edx,%eax
  8043ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043af:	48 98                	cltq   
  8043b1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8043b6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8043b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043bc:	8b 00                	mov    (%rax),%eax
  8043be:	8d 50 01             	lea    0x1(%rax),%edx
  8043c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043c5:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8043c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043d0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043d4:	0f 82 60 ff ff ff    	jb     80433a <devpipe_read+0x40>
	}
	return i;
  8043da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043de:	c9                   	leaveq 
  8043df:	c3                   	retq   

00000000008043e0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043e0:	55                   	push   %rbp
  8043e1:	48 89 e5             	mov    %rsp,%rbp
  8043e4:	48 83 ec 40          	sub    $0x40,%rsp
  8043e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8043f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043f8:	48 89 c7             	mov    %rax,%rdi
  8043fb:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  804402:	00 00 00 
  804405:	ff d0                	callq  *%rax
  804407:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80440b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80440f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804413:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80441a:	00 
  80441b:	e9 91 00 00 00       	jmpq   8044b1 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804420:	eb 31                	jmp    804453 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804422:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80442a:	48 89 d6             	mov    %rdx,%rsi
  80442d:	48 89 c7             	mov    %rax,%rdi
  804430:	48 b8 c8 41 80 00 00 	movabs $0x8041c8,%rax
  804437:	00 00 00 
  80443a:	ff d0                	callq  *%rax
  80443c:	85 c0                	test   %eax,%eax
  80443e:	74 07                	je     804447 <devpipe_write+0x67>
				return 0;
  804440:	b8 00 00 00 00       	mov    $0x0,%eax
  804445:	eb 7c                	jmp    8044c3 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804447:	48 b8 82 20 80 00 00 	movabs $0x802082,%rax
  80444e:	00 00 00 
  804451:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804457:	8b 40 04             	mov    0x4(%rax),%eax
  80445a:	48 63 d0             	movslq %eax,%rdx
  80445d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804461:	8b 00                	mov    (%rax),%eax
  804463:	48 98                	cltq   
  804465:	48 83 c0 20          	add    $0x20,%rax
  804469:	48 39 c2             	cmp    %rax,%rdx
  80446c:	73 b4                	jae    804422 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80446e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804472:	8b 40 04             	mov    0x4(%rax),%eax
  804475:	99                   	cltd   
  804476:	c1 ea 1b             	shr    $0x1b,%edx
  804479:	01 d0                	add    %edx,%eax
  80447b:	83 e0 1f             	and    $0x1f,%eax
  80447e:	29 d0                	sub    %edx,%eax
  804480:	89 c6                	mov    %eax,%esi
  804482:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448a:	48 01 d0             	add    %rdx,%rax
  80448d:	0f b6 08             	movzbl (%rax),%ecx
  804490:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804494:	48 63 c6             	movslq %esi,%rax
  804497:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80449b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80449f:	8b 40 04             	mov    0x4(%rax),%eax
  8044a2:	8d 50 01             	lea    0x1(%rax),%edx
  8044a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a9:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8044ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8044b9:	0f 82 61 ff ff ff    	jb     804420 <devpipe_write+0x40>
	}

	return i;
  8044bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8044c3:	c9                   	leaveq 
  8044c4:	c3                   	retq   

00000000008044c5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8044c5:	55                   	push   %rbp
  8044c6:	48 89 e5             	mov    %rsp,%rbp
  8044c9:	48 83 ec 20          	sub    $0x20,%rsp
  8044cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8044d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d9:	48 89 c7             	mov    %rax,%rdi
  8044dc:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  8044e3:	00 00 00 
  8044e6:	ff d0                	callq  *%rax
  8044e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8044ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044f0:	48 be 78 59 80 00 00 	movabs $0x805978,%rsi
  8044f7:	00 00 00 
  8044fa:	48 89 c7             	mov    %rax,%rdi
  8044fd:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  804504:	00 00 00 
  804507:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450d:	8b 50 04             	mov    0x4(%rax),%edx
  804510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804514:	8b 00                	mov    (%rax),%eax
  804516:	29 c2                	sub    %eax,%edx
  804518:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80451c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804522:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804526:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80452d:	00 00 00 
	stat->st_dev = &devpipe;
  804530:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804534:	48 b9 40 71 80 00 00 	movabs $0x807140,%rcx
  80453b:	00 00 00 
  80453e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804545:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80454a:	c9                   	leaveq 
  80454b:	c3                   	retq   

000000000080454c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80454c:	55                   	push   %rbp
  80454d:	48 89 e5             	mov    %rsp,%rbp
  804550:	48 83 ec 10          	sub    $0x10,%rsp
  804554:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455c:	48 89 c6             	mov    %rax,%rsi
  80455f:	bf 00 00 00 00       	mov    $0x0,%edi
  804564:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  80456b:	00 00 00 
  80456e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804574:	48 89 c7             	mov    %rax,%rdi
  804577:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  80457e:	00 00 00 
  804581:	ff d0                	callq  *%rax
  804583:	48 89 c6             	mov    %rax,%rsi
  804586:	bf 00 00 00 00       	mov    $0x0,%edi
  80458b:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
}
  804597:	c9                   	leaveq 
  804598:	c3                   	retq   

0000000000804599 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804599:	55                   	push   %rbp
  80459a:	48 89 e5             	mov    %rsp,%rbp
  80459d:	48 83 ec 20          	sub    $0x20,%rsp
  8045a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8045a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045a7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8045aa:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8045ae:	be 01 00 00 00       	mov    $0x1,%esi
  8045b3:	48 89 c7             	mov    %rax,%rdi
  8045b6:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8045bd:	00 00 00 
  8045c0:	ff d0                	callq  *%rax
}
  8045c2:	c9                   	leaveq 
  8045c3:	c3                   	retq   

00000000008045c4 <getchar>:

int
getchar(void)
{
  8045c4:	55                   	push   %rbp
  8045c5:	48 89 e5             	mov    %rsp,%rbp
  8045c8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8045cc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8045d0:	ba 01 00 00 00       	mov    $0x1,%edx
  8045d5:	48 89 c6             	mov    %rax,%rsi
  8045d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8045dd:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  8045e4:	00 00 00 
  8045e7:	ff d0                	callq  *%rax
  8045e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f0:	79 05                	jns    8045f7 <getchar+0x33>
		return r;
  8045f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f5:	eb 14                	jmp    80460b <getchar+0x47>
	if (r < 1)
  8045f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045fb:	7f 07                	jg     804604 <getchar+0x40>
		return -E_EOF;
  8045fd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804602:	eb 07                	jmp    80460b <getchar+0x47>
	return c;
  804604:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804608:	0f b6 c0             	movzbl %al,%eax
}
  80460b:	c9                   	leaveq 
  80460c:	c3                   	retq   

000000000080460d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80460d:	55                   	push   %rbp
  80460e:	48 89 e5             	mov    %rsp,%rbp
  804611:	48 83 ec 20          	sub    $0x20,%rsp
  804615:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804618:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80461c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80461f:	48 89 d6             	mov    %rdx,%rsi
  804622:	89 c7                	mov    %eax,%edi
  804624:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  80462b:	00 00 00 
  80462e:	ff d0                	callq  *%rax
  804630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804637:	79 05                	jns    80463e <iscons+0x31>
		return r;
  804639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463c:	eb 1a                	jmp    804658 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80463e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804642:	8b 10                	mov    (%rax),%edx
  804644:	48 b8 80 71 80 00 00 	movabs $0x807180,%rax
  80464b:	00 00 00 
  80464e:	8b 00                	mov    (%rax),%eax
  804650:	39 c2                	cmp    %eax,%edx
  804652:	0f 94 c0             	sete   %al
  804655:	0f b6 c0             	movzbl %al,%eax
}
  804658:	c9                   	leaveq 
  804659:	c3                   	retq   

000000000080465a <opencons>:

int
opencons(void)
{
  80465a:	55                   	push   %rbp
  80465b:	48 89 e5             	mov    %rsp,%rbp
  80465e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804662:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804666:	48 89 c7             	mov    %rax,%rdi
  804669:	48 b8 74 24 80 00 00 	movabs $0x802474,%rax
  804670:	00 00 00 
  804673:	ff d0                	callq  *%rax
  804675:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80467c:	79 05                	jns    804683 <opencons+0x29>
		return r;
  80467e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804681:	eb 5b                	jmp    8046de <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804687:	ba 07 04 00 00       	mov    $0x407,%edx
  80468c:	48 89 c6             	mov    %rax,%rsi
  80468f:	bf 00 00 00 00       	mov    $0x0,%edi
  804694:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  80469b:	00 00 00 
  80469e:	ff d0                	callq  *%rax
  8046a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a7:	79 05                	jns    8046ae <opencons+0x54>
		return r;
  8046a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ac:	eb 30                	jmp    8046de <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8046ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b2:	48 ba 80 71 80 00 00 	movabs $0x807180,%rdx
  8046b9:	00 00 00 
  8046bc:	8b 12                	mov    (%rdx),%edx
  8046be:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8046c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8046cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046cf:	48 89 c7             	mov    %rax,%rdi
  8046d2:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  8046d9:	00 00 00 
  8046dc:	ff d0                	callq  *%rax
}
  8046de:	c9                   	leaveq 
  8046df:	c3                   	retq   

00000000008046e0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046e0:	55                   	push   %rbp
  8046e1:	48 89 e5             	mov    %rsp,%rbp
  8046e4:	48 83 ec 30          	sub    $0x30,%rsp
  8046e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046f4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046f9:	75 07                	jne    804702 <devcons_read+0x22>
		return 0;
  8046fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804700:	eb 4b                	jmp    80474d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804702:	eb 0c                	jmp    804710 <devcons_read+0x30>
		sys_yield();
  804704:	48 b8 82 20 80 00 00 	movabs $0x802082,%rax
  80470b:	00 00 00 
  80470e:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  804710:	48 b8 c4 1f 80 00 00 	movabs $0x801fc4,%rax
  804717:	00 00 00 
  80471a:	ff d0                	callq  *%rax
  80471c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80471f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804723:	74 df                	je     804704 <devcons_read+0x24>
	if (c < 0)
  804725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804729:	79 05                	jns    804730 <devcons_read+0x50>
		return c;
  80472b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80472e:	eb 1d                	jmp    80474d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804730:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804734:	75 07                	jne    80473d <devcons_read+0x5d>
		return 0;
  804736:	b8 00 00 00 00       	mov    $0x0,%eax
  80473b:	eb 10                	jmp    80474d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80473d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804740:	89 c2                	mov    %eax,%edx
  804742:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804746:	88 10                	mov    %dl,(%rax)
	return 1;
  804748:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80474d:	c9                   	leaveq 
  80474e:	c3                   	retq   

000000000080474f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80474f:	55                   	push   %rbp
  804750:	48 89 e5             	mov    %rsp,%rbp
  804753:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80475a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804761:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804768:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80476f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804776:	eb 76                	jmp    8047ee <devcons_write+0x9f>
		m = n - tot;
  804778:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80477f:	89 c2                	mov    %eax,%edx
  804781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804784:	29 c2                	sub    %eax,%edx
  804786:	89 d0                	mov    %edx,%eax
  804788:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80478b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80478e:	83 f8 7f             	cmp    $0x7f,%eax
  804791:	76 07                	jbe    80479a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804793:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80479a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80479d:	48 63 d0             	movslq %eax,%rdx
  8047a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a3:	48 63 c8             	movslq %eax,%rcx
  8047a6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8047ad:	48 01 c1             	add    %rax,%rcx
  8047b0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047b7:	48 89 ce             	mov    %rcx,%rsi
  8047ba:	48 89 c7             	mov    %rax,%rdi
  8047bd:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  8047c4:	00 00 00 
  8047c7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8047c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047cc:	48 63 d0             	movslq %eax,%rdx
  8047cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047d6:	48 89 d6             	mov    %rdx,%rsi
  8047d9:	48 89 c7             	mov    %rax,%rdi
  8047dc:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8047e3:	00 00 00 
  8047e6:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8047e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047eb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f1:	48 98                	cltq   
  8047f3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047fa:	0f 82 78 ff ff ff    	jb     804778 <devcons_write+0x29>
	}
	return tot;
  804800:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804803:	c9                   	leaveq 
  804804:	c3                   	retq   

0000000000804805 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804805:	55                   	push   %rbp
  804806:	48 89 e5             	mov    %rsp,%rbp
  804809:	48 83 ec 08          	sub    $0x8,%rsp
  80480d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804811:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804816:	c9                   	leaveq 
  804817:	c3                   	retq   

0000000000804818 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804818:	55                   	push   %rbp
  804819:	48 89 e5             	mov    %rsp,%rbp
  80481c:	48 83 ec 10          	sub    $0x10,%rsp
  804820:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804824:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80482c:	48 be 84 59 80 00 00 	movabs $0x805984,%rsi
  804833:	00 00 00 
  804836:	48 89 c7             	mov    %rax,%rdi
  804839:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  804840:	00 00 00 
  804843:	ff d0                	callq  *%rax
	return 0;
  804845:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80484a:	c9                   	leaveq 
  80484b:	c3                   	retq   

000000000080484c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80484c:	55                   	push   %rbp
  80484d:	48 89 e5             	mov    %rsp,%rbp
  804850:	48 83 ec 20          	sub    $0x20,%rsp
  804854:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804858:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80485c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804860:	48 ba 90 59 80 00 00 	movabs $0x805990,%rdx
  804867:	00 00 00 
  80486a:	be 1d 00 00 00       	mov    $0x1d,%esi
  80486f:	48 bf a9 59 80 00 00 	movabs $0x8059a9,%rdi
  804876:	00 00 00 
  804879:	b8 00 00 00 00       	mov    $0x0,%eax
  80487e:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  804885:	00 00 00 
  804888:	ff d1                	callq  *%rcx

000000000080488a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80488a:	55                   	push   %rbp
  80488b:	48 89 e5             	mov    %rsp,%rbp
  80488e:	48 83 ec 20          	sub    $0x20,%rsp
  804892:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804895:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804898:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80489c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80489f:	48 ba b3 59 80 00 00 	movabs $0x8059b3,%rdx
  8048a6:	00 00 00 
  8048a9:	be 2d 00 00 00       	mov    $0x2d,%esi
  8048ae:	48 bf a9 59 80 00 00 	movabs $0x8059a9,%rdi
  8048b5:	00 00 00 
  8048b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8048bd:	48 b9 be 09 80 00 00 	movabs $0x8009be,%rcx
  8048c4:	00 00 00 
  8048c7:	ff d1                	callq  *%rcx

00000000008048c9 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8048c9:	55                   	push   %rbp
  8048ca:	48 89 e5             	mov    %rsp,%rbp
  8048cd:	53                   	push   %rbx
  8048ce:	48 83 ec 48          	sub    $0x48,%rsp
  8048d2:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8048d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  8048dd:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8048e4:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8048e9:	75 0e                	jne    8048f9 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8048eb:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8048f2:	00 00 00 
  8048f5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8048f9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8048fd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804901:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804908:	00 
	a3 = (uint64_t) 0;
  804909:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804910:	00 
	a4 = (uint64_t) 0;
  804911:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804918:	00 
	a5 = 0;
  804919:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804920:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  804921:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804924:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804928:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80492c:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  804930:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804934:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804938:	4c 89 c3             	mov    %r8,%rbx
  80493b:	0f 01 c1             	vmcall 
  80493e:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804941:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804945:	7e 36                	jle    80497d <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804947:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80494a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80494d:	41 89 d0             	mov    %edx,%r8d
  804950:	89 c1                	mov    %eax,%ecx
  804952:	48 ba d0 59 80 00 00 	movabs $0x8059d0,%rdx
  804959:	00 00 00 
  80495c:	be 54 00 00 00       	mov    $0x54,%esi
  804961:	48 bf a9 59 80 00 00 	movabs $0x8059a9,%rdi
  804968:	00 00 00 
  80496b:	b8 00 00 00 00       	mov    $0x0,%eax
  804970:	49 b9 be 09 80 00 00 	movabs $0x8009be,%r9
  804977:	00 00 00 
  80497a:	41 ff d1             	callq  *%r9
	return ret;
  80497d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804980:	48 83 c4 48          	add    $0x48,%rsp
  804984:	5b                   	pop    %rbx
  804985:	5d                   	pop    %rbp
  804986:	c3                   	retq   

0000000000804987 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804987:	55                   	push   %rbp
  804988:	48 89 e5             	mov    %rsp,%rbp
  80498b:	53                   	push   %rbx
  80498c:	48 83 ec 58          	sub    $0x58,%rsp
  804990:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804993:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804996:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80499a:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80499d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8049a4:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8049ab:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8049b0:	75 0e                	jne    8049c0 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8049b2:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8049b9:	00 00 00 
  8049bc:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8049c0:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8049c3:	48 98                	cltq   
  8049c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8049c9:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8049cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8049d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8049d4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8049d8:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8049db:	48 98                	cltq   
  8049dd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8049e1:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8049e8:	00 

	int r = -E_IPC_NOT_RECV;
  8049e9:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8049f0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8049f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049f7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8049fb:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8049ff:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804a03:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804a07:	4c 89 c3             	mov    %r8,%rbx
  804a0a:	0f 01 c1             	vmcall 
  804a0d:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804a10:	48 83 c4 58          	add    $0x58,%rsp
  804a14:	5b                   	pop    %rbx
  804a15:	5d                   	pop    %rbp
  804a16:	c3                   	retq   

0000000000804a17 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a17:	55                   	push   %rbp
  804a18:	48 89 e5             	mov    %rsp,%rbp
  804a1b:	48 83 ec 18          	sub    $0x18,%rsp
  804a1f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a29:	eb 4e                	jmp    804a79 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804a2b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a32:	00 00 00 
  804a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a38:	48 98                	cltq   
  804a3a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a41:	48 01 d0             	add    %rdx,%rax
  804a44:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a4a:	8b 00                	mov    (%rax),%eax
  804a4c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a4f:	75 24                	jne    804a75 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804a51:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a58:	00 00 00 
  804a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a5e:	48 98                	cltq   
  804a60:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a67:	48 01 d0             	add    %rdx,%rax
  804a6a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804a70:	8b 40 08             	mov    0x8(%rax),%eax
  804a73:	eb 12                	jmp    804a87 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804a75:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a79:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a80:	7e a9                	jle    804a2b <ipc_find_env+0x14>
	}
	return 0;
  804a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a87:	c9                   	leaveq 
  804a88:	c3                   	retq   

0000000000804a89 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804a89:	55                   	push   %rbp
  804a8a:	48 89 e5             	mov    %rsp,%rbp
  804a8d:	48 83 ec 18          	sub    $0x18,%rsp
  804a91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a99:	48 c1 e8 15          	shr    $0x15,%rax
  804a9d:	48 89 c2             	mov    %rax,%rdx
  804aa0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804aa7:	01 00 00 
  804aaa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804aae:	83 e0 01             	and    $0x1,%eax
  804ab1:	48 85 c0             	test   %rax,%rax
  804ab4:	75 07                	jne    804abd <pageref+0x34>
		return 0;
  804ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  804abb:	eb 53                	jmp    804b10 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ac1:	48 c1 e8 0c          	shr    $0xc,%rax
  804ac5:	48 89 c2             	mov    %rax,%rdx
  804ac8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804acf:	01 00 00 
  804ad2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ad6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804ada:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ade:	83 e0 01             	and    $0x1,%eax
  804ae1:	48 85 c0             	test   %rax,%rax
  804ae4:	75 07                	jne    804aed <pageref+0x64>
		return 0;
  804ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  804aeb:	eb 23                	jmp    804b10 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804af1:	48 c1 e8 0c          	shr    $0xc,%rax
  804af5:	48 89 c2             	mov    %rax,%rdx
  804af8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804aff:	00 00 00 
  804b02:	48 c1 e2 04          	shl    $0x4,%rdx
  804b06:	48 01 d0             	add    %rdx,%rax
  804b09:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804b0d:	0f b7 c0             	movzwl %ax,%eax
}
  804b10:	c9                   	leaveq 
  804b11:	c3                   	retq   

0000000000804b12 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804b12:	55                   	push   %rbp
  804b13:	48 89 e5             	mov    %rsp,%rbp
  804b16:	48 83 ec 20          	sub    $0x20,%rsp
  804b1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804b1e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b26:	48 89 d6             	mov    %rdx,%rsi
  804b29:	48 89 c7             	mov    %rax,%rdi
  804b2c:	48 b8 48 4b 80 00 00 	movabs $0x804b48,%rax
  804b33:	00 00 00 
  804b36:	ff d0                	callq  *%rax
  804b38:	85 c0                	test   %eax,%eax
  804b3a:	74 05                	je     804b41 <inet_addr+0x2f>
    return (val.s_addr);
  804b3c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804b3f:	eb 05                	jmp    804b46 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804b46:	c9                   	leaveq 
  804b47:	c3                   	retq   

0000000000804b48 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804b48:	55                   	push   %rbp
  804b49:	48 89 e5             	mov    %rsp,%rbp
  804b4c:	48 83 ec 40          	sub    $0x40,%rsp
  804b50:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804b54:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804b58:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804b5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804b60:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804b64:	0f b6 00             	movzbl (%rax),%eax
  804b67:	0f be c0             	movsbl %al,%eax
  804b6a:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804b6d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804b70:	3c 2f                	cmp    $0x2f,%al
  804b72:	76 07                	jbe    804b7b <inet_aton+0x33>
  804b74:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804b77:	3c 39                	cmp    $0x39,%al
  804b79:	76 0a                	jbe    804b85 <inet_aton+0x3d>
      return (0);
  804b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b80:	e9 6e 02 00 00       	jmpq   804df3 <inet_aton+0x2ab>
    val = 0;
  804b85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804b8c:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804b93:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  804b97:	75 40                	jne    804bd9 <inet_aton+0x91>
      c = *++cp;
  804b99:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804b9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804ba2:	0f b6 00             	movzbl (%rax),%eax
  804ba5:	0f be c0             	movsbl %al,%eax
  804ba8:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  804bab:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804baf:	74 06                	je     804bb7 <inet_aton+0x6f>
  804bb1:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804bb5:	75 1b                	jne    804bd2 <inet_aton+0x8a>
        base = 16;
  804bb7:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804bbe:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804bc3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804bc7:	0f b6 00             	movzbl (%rax),%eax
  804bca:	0f be c0             	movsbl %al,%eax
  804bcd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804bd0:	eb 07                	jmp    804bd9 <inet_aton+0x91>
      } else
        base = 8;
  804bd2:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804bd9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804bdc:	3c 2f                	cmp    $0x2f,%al
  804bde:	76 2f                	jbe    804c0f <inet_aton+0xc7>
  804be0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804be3:	3c 39                	cmp    $0x39,%al
  804be5:	77 28                	ja     804c0f <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  804be7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bea:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804bee:	89 c2                	mov    %eax,%edx
  804bf0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804bf3:	01 d0                	add    %edx,%eax
  804bf5:	83 e8 30             	sub    $0x30,%eax
  804bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804bfb:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804c00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804c04:	0f b6 00             	movzbl (%rax),%eax
  804c07:	0f be c0             	movsbl %al,%eax
  804c0a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804c0d:	eb 73                	jmp    804c82 <inet_aton+0x13a>
      } else if (base == 16 && isxdigit(c)) {
  804c0f:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804c13:	75 72                	jne    804c87 <inet_aton+0x13f>
  804c15:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c18:	3c 2f                	cmp    $0x2f,%al
  804c1a:	76 07                	jbe    804c23 <inet_aton+0xdb>
  804c1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c1f:	3c 39                	cmp    $0x39,%al
  804c21:	76 1c                	jbe    804c3f <inet_aton+0xf7>
  804c23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c26:	3c 60                	cmp    $0x60,%al
  804c28:	76 07                	jbe    804c31 <inet_aton+0xe9>
  804c2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c2d:	3c 66                	cmp    $0x66,%al
  804c2f:	76 0e                	jbe    804c3f <inet_aton+0xf7>
  804c31:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c34:	3c 40                	cmp    $0x40,%al
  804c36:	76 4f                	jbe    804c87 <inet_aton+0x13f>
  804c38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c3b:	3c 46                	cmp    $0x46,%al
  804c3d:	77 48                	ja     804c87 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804c3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c42:	c1 e0 04             	shl    $0x4,%eax
  804c45:	89 c2                	mov    %eax,%edx
  804c47:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c4a:	8d 48 0a             	lea    0xa(%rax),%ecx
  804c4d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c50:	3c 60                	cmp    $0x60,%al
  804c52:	76 0e                	jbe    804c62 <inet_aton+0x11a>
  804c54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c57:	3c 7a                	cmp    $0x7a,%al
  804c59:	77 07                	ja     804c62 <inet_aton+0x11a>
  804c5b:	b8 61 00 00 00       	mov    $0x61,%eax
  804c60:	eb 05                	jmp    804c67 <inet_aton+0x11f>
  804c62:	b8 41 00 00 00       	mov    $0x41,%eax
  804c67:	29 c1                	sub    %eax,%ecx
  804c69:	89 c8                	mov    %ecx,%eax
  804c6b:	09 d0                	or     %edx,%eax
  804c6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804c70:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804c75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804c79:	0f b6 00             	movzbl (%rax),%eax
  804c7c:	0f be c0             	movsbl %al,%eax
  804c7f:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  804c82:	e9 52 ff ff ff       	jmpq   804bd9 <inet_aton+0x91>
    if (c == '.') {
  804c87:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804c8b:	75 3d                	jne    804cca <inet_aton+0x182>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804c8d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804c91:	48 83 c0 0c          	add    $0xc,%rax
  804c95:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  804c99:	72 0a                	jb     804ca5 <inet_aton+0x15d>
        return (0);
  804c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  804ca0:	e9 4e 01 00 00       	jmpq   804df3 <inet_aton+0x2ab>
      *pp++ = val;
  804ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ca9:	48 8d 50 04          	lea    0x4(%rax),%rdx
  804cad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804cb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804cb4:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804cb6:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804cbb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804cbf:	0f b6 00             	movzbl (%rax),%eax
  804cc2:	0f be c0             	movsbl %al,%eax
  804cc5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804cc8:	eb 09                	jmp    804cd3 <inet_aton+0x18b>
    } else
      break;
  804cca:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804ccb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804ccf:	74 43                	je     804d14 <inet_aton+0x1cc>
  804cd1:	eb 05                	jmp    804cd8 <inet_aton+0x190>
  }
  804cd3:	e9 95 fe ff ff       	jmpq   804b6d <inet_aton+0x25>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804cd8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804cdb:	3c 1f                	cmp    $0x1f,%al
  804cdd:	76 2b                	jbe    804d0a <inet_aton+0x1c2>
  804cdf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804ce2:	84 c0                	test   %al,%al
  804ce4:	78 24                	js     804d0a <inet_aton+0x1c2>
  804ce6:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  804cea:	74 28                	je     804d14 <inet_aton+0x1cc>
  804cec:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804cf0:	74 22                	je     804d14 <inet_aton+0x1cc>
  804cf2:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804cf6:	74 1c                	je     804d14 <inet_aton+0x1cc>
  804cf8:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  804cfc:	74 16                	je     804d14 <inet_aton+0x1cc>
  804cfe:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804d02:	74 10                	je     804d14 <inet_aton+0x1cc>
  804d04:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804d08:	74 0a                	je     804d14 <inet_aton+0x1cc>
    return (0);
  804d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  804d0f:	e9 df 00 00 00       	jmpq   804df3 <inet_aton+0x2ab>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804d14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804d18:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804d1c:	48 29 c2             	sub    %rax,%rdx
  804d1f:	48 89 d0             	mov    %rdx,%rax
  804d22:	48 c1 f8 02          	sar    $0x2,%rax
  804d26:	83 c0 01             	add    $0x1,%eax
  804d29:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  804d2c:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804d30:	0f 87 98 00 00 00    	ja     804dce <inet_aton+0x286>
  804d36:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d39:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804d40:	00 
  804d41:	48 b8 00 5a 80 00 00 	movabs $0x805a00,%rax
  804d48:	00 00 00 
  804d4b:	48 01 d0             	add    %rdx,%rax
  804d4e:	48 8b 00             	mov    (%rax),%rax
  804d51:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804d53:	b8 00 00 00 00       	mov    $0x0,%eax
  804d58:	e9 96 00 00 00       	jmpq   804df3 <inet_aton+0x2ab>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804d5d:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  804d64:	76 0a                	jbe    804d70 <inet_aton+0x228>
      return (0);
  804d66:	b8 00 00 00 00       	mov    $0x0,%eax
  804d6b:	e9 83 00 00 00       	jmpq   804df3 <inet_aton+0x2ab>
    val |= parts[0] << 24;
  804d70:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804d73:	c1 e0 18             	shl    $0x18,%eax
  804d76:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804d79:	eb 53                	jmp    804dce <inet_aton+0x286>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804d7b:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804d82:	76 07                	jbe    804d8b <inet_aton+0x243>
      return (0);
  804d84:	b8 00 00 00 00       	mov    $0x0,%eax
  804d89:	eb 68                	jmp    804df3 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804d8b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804d8e:	c1 e0 18             	shl    $0x18,%eax
  804d91:	89 c2                	mov    %eax,%edx
  804d93:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d96:	c1 e0 10             	shl    $0x10,%eax
  804d99:	09 d0                	or     %edx,%eax
  804d9b:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804d9e:	eb 2e                	jmp    804dce <inet_aton+0x286>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804da0:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  804da7:	76 07                	jbe    804db0 <inet_aton+0x268>
      return (0);
  804da9:	b8 00 00 00 00       	mov    $0x0,%eax
  804dae:	eb 43                	jmp    804df3 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804db0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804db3:	c1 e0 18             	shl    $0x18,%eax
  804db6:	89 c2                	mov    %eax,%edx
  804db8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804dbb:	c1 e0 10             	shl    $0x10,%eax
  804dbe:	09 c2                	or     %eax,%edx
  804dc0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804dc3:	c1 e0 08             	shl    $0x8,%eax
  804dc6:	09 d0                	or     %edx,%eax
  804dc8:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804dcb:	eb 01                	jmp    804dce <inet_aton+0x286>
    break;
  804dcd:	90                   	nop
  }
  if (addr)
  804dce:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804dd3:	74 19                	je     804dee <inet_aton+0x2a6>
    addr->s_addr = htonl(val);
  804dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dd8:	89 c7                	mov    %eax,%edi
  804dda:	48 b8 6c 4f 80 00 00 	movabs $0x804f6c,%rax
  804de1:	00 00 00 
  804de4:	ff d0                	callq  *%rax
  804de6:	89 c2                	mov    %eax,%edx
  804de8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804dec:	89 10                	mov    %edx,(%rax)
  return (1);
  804dee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804df3:	c9                   	leaveq 
  804df4:	c3                   	retq   

0000000000804df5 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804df5:	55                   	push   %rbp
  804df6:	48 89 e5             	mov    %rsp,%rbp
  804df9:	48 83 ec 30          	sub    $0x30,%rsp
  804dfd:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804e00:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804e03:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804e06:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804e0d:	00 00 00 
  804e10:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804e14:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804e18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804e1c:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804e20:	e9 e0 00 00 00       	jmpq   804f05 <inet_ntoa+0x110>
    i = 0;
  804e25:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e2d:	0f b6 08             	movzbl (%rax),%ecx
  804e30:	0f b6 d1             	movzbl %cl,%edx
  804e33:	89 d0                	mov    %edx,%eax
  804e35:	c1 e0 02             	shl    $0x2,%eax
  804e38:	01 d0                	add    %edx,%eax
  804e3a:	c1 e0 03             	shl    $0x3,%eax
  804e3d:	01 d0                	add    %edx,%eax
  804e3f:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804e46:	01 d0                	add    %edx,%eax
  804e48:	66 c1 e8 08          	shr    $0x8,%ax
  804e4c:	c0 e8 03             	shr    $0x3,%al
  804e4f:	88 45 ed             	mov    %al,-0x13(%rbp)
  804e52:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804e56:	89 d0                	mov    %edx,%eax
  804e58:	c1 e0 02             	shl    $0x2,%eax
  804e5b:	01 d0                	add    %edx,%eax
  804e5d:	01 c0                	add    %eax,%eax
  804e5f:	29 c1                	sub    %eax,%ecx
  804e61:	89 c8                	mov    %ecx,%eax
  804e63:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804e66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e6a:	0f b6 00             	movzbl (%rax),%eax
  804e6d:	0f b6 d0             	movzbl %al,%edx
  804e70:	89 d0                	mov    %edx,%eax
  804e72:	c1 e0 02             	shl    $0x2,%eax
  804e75:	01 d0                	add    %edx,%eax
  804e77:	c1 e0 03             	shl    $0x3,%eax
  804e7a:	01 d0                	add    %edx,%eax
  804e7c:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804e83:	01 d0                	add    %edx,%eax
  804e85:	66 c1 e8 08          	shr    $0x8,%ax
  804e89:	89 c2                	mov    %eax,%edx
  804e8b:	c0 ea 03             	shr    $0x3,%dl
  804e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e92:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804e94:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804e98:	8d 50 01             	lea    0x1(%rax),%edx
  804e9b:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804e9e:	0f b6 c0             	movzbl %al,%eax
  804ea1:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804ea5:	83 c2 30             	add    $0x30,%edx
  804ea8:	48 98                	cltq   
  804eaa:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  804eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804eb2:	0f b6 00             	movzbl (%rax),%eax
  804eb5:	84 c0                	test   %al,%al
  804eb7:	0f 85 6c ff ff ff    	jne    804e29 <inet_ntoa+0x34>
    while(i--)
  804ebd:	eb 1a                	jmp    804ed9 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  804ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ec3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804ec7:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804ecb:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  804ecf:	48 63 d2             	movslq %edx,%rdx
  804ed2:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804ed7:	88 10                	mov    %dl,(%rax)
    while(i--)
  804ed9:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804edd:	8d 50 ff             	lea    -0x1(%rax),%edx
  804ee0:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804ee3:	84 c0                	test   %al,%al
  804ee5:	75 d8                	jne    804ebf <inet_ntoa+0xca>
    *rp++ = '.';
  804ee7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804eeb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804eef:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804ef3:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804ef6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804efb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804eff:	83 c0 01             	add    $0x1,%eax
  804f02:	88 45 ef             	mov    %al,-0x11(%rbp)
  804f05:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804f09:	0f 86 16 ff ff ff    	jbe    804e25 <inet_ntoa+0x30>
  }
  *--rp = 0;
  804f0f:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804f14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f18:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804f1b:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804f22:	00 00 00 
}
  804f25:	c9                   	leaveq 
  804f26:	c3                   	retq   

0000000000804f27 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804f27:	55                   	push   %rbp
  804f28:	48 89 e5             	mov    %rsp,%rbp
  804f2b:	48 83 ec 08          	sub    $0x8,%rsp
  804f2f:	89 f8                	mov    %edi,%eax
  804f31:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804f35:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804f39:	c1 e0 08             	shl    $0x8,%eax
  804f3c:	89 c2                	mov    %eax,%edx
  804f3e:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804f42:	66 c1 e8 08          	shr    $0x8,%ax
  804f46:	09 d0                	or     %edx,%eax
}
  804f48:	c9                   	leaveq 
  804f49:	c3                   	retq   

0000000000804f4a <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804f4a:	55                   	push   %rbp
  804f4b:	48 89 e5             	mov    %rsp,%rbp
  804f4e:	48 83 ec 08          	sub    $0x8,%rsp
  804f52:	89 f8                	mov    %edi,%eax
  804f54:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804f58:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804f5c:	89 c7                	mov    %eax,%edi
  804f5e:	48 b8 27 4f 80 00 00 	movabs $0x804f27,%rax
  804f65:	00 00 00 
  804f68:	ff d0                	callq  *%rax
}
  804f6a:	c9                   	leaveq 
  804f6b:	c3                   	retq   

0000000000804f6c <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804f6c:	55                   	push   %rbp
  804f6d:	48 89 e5             	mov    %rsp,%rbp
  804f70:	48 83 ec 08          	sub    $0x8,%rsp
  804f74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  804f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f7a:	c1 e0 18             	shl    $0x18,%eax
  804f7d:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f82:	25 00 ff 00 00       	and    $0xff00,%eax
  804f87:	c1 e0 08             	shl    $0x8,%eax
  return ((n & 0xff) << 24) |
  804f8a:	09 c2                	or     %eax,%edx
    ((n & 0xff0000UL) >> 8) |
  804f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f8f:	25 00 00 ff 00       	and    $0xff0000,%eax
  804f94:	48 c1 e8 08          	shr    $0x8,%rax
  return ((n & 0xff) << 24) |
  804f98:	09 c2                	or     %eax,%edx
    ((n & 0xff000000UL) >> 24);
  804f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f9d:	c1 e8 18             	shr    $0x18,%eax
  return ((n & 0xff) << 24) |
  804fa0:	09 d0                	or     %edx,%eax
}
  804fa2:	c9                   	leaveq 
  804fa3:	c3                   	retq   

0000000000804fa4 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804fa4:	55                   	push   %rbp
  804fa5:	48 89 e5             	mov    %rsp,%rbp
  804fa8:	48 83 ec 08          	sub    $0x8,%rsp
  804fac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fb2:	89 c7                	mov    %eax,%edi
  804fb4:	48 b8 6c 4f 80 00 00 	movabs $0x804f6c,%rax
  804fbb:	00 00 00 
  804fbe:	ff d0                	callq  *%rax
}
  804fc0:	c9                   	leaveq 
  804fc1:	c3                   	retq   
