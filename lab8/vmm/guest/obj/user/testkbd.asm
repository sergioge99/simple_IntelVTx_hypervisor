
vmm/guest/obj/user/testkbd:     formato del fichero elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba 80 42 80 00 00 	movabs $0x804280,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf 8d 42 80 00 00 	movabs $0x80428d,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 ee 04 80 00 00 	movabs $0x8004ee,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 9c 42 80 00 00 	movabs $0x80429c,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 8d 42 80 00 00 	movabs $0x80428d,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 ee 04 80 00 00 	movabs $0x8004ee,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba b6 42 80 00 00 	movabs $0x8042b6,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf 8d 42 80 00 00 	movabs $0x80428d,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 ee 04 80 00 00 	movabs $0x8004ee,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf be 42 80 00 00 	movabs $0x8042be,%rdi
  800153:	00 00 00 
  800156:	48 b8 55 12 80 00 00 	movabs $0x801255,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be cc 42 80 00 00 	movabs $0x8042cc,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 66 30 80 00 00 	movabs $0x803066,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
  800194:	eb 20                	jmp    8001b6 <umain+0x173>
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be d0 42 80 00 00 	movabs $0x8042d0,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 66 30 80 00 00 	movabs $0x803066,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be ed 42 80 00 00 	movabs $0x8042ed,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80047a:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  800481:	00 00 00 
  800484:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80048b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80048f:	7e 14                	jle    8004a5 <libmain+0x3a>
		binaryname = argv[0];
  800491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800495:	48 8b 10             	mov    (%rax),%rdx
  800498:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  80049f:	00 00 00 
  8004a2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ac:	48 89 d6             	mov    %rdx,%rsi
  8004af:	89 c7                	mov    %eax,%edi
  8004b1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004b8:	00 00 00 
  8004bb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004bd:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  8004c4:	00 00 00 
  8004c7:	ff d0                	callq  *%rax
}
  8004c9:	c9                   	leaveq 
  8004ca:	c3                   	retq   

00000000008004cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004cb:	55                   	push   %rbp
  8004cc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004cf:	48 b8 f3 23 80 00 00 	movabs $0x8023f3,%rax
  8004d6:	00 00 00 
  8004d9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004db:	bf 00 00 00 00       	mov    $0x0,%edi
  8004e0:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8004e7:	00 00 00 
  8004ea:	ff d0                	callq  *%rax
}
  8004ec:	5d                   	pop    %rbp
  8004ed:	c3                   	retq   

00000000008004ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004ee:	55                   	push   %rbp
  8004ef:	48 89 e5             	mov    %rsp,%rbp
  8004f2:	53                   	push   %rbx
  8004f3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004fa:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800501:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800507:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80050e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800515:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80051c:	84 c0                	test   %al,%al
  80051e:	74 23                	je     800543 <_panic+0x55>
  800520:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800527:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80052b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80052f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800533:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800537:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80053b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80053f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800543:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80054a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800551:	00 00 00 
  800554:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80055b:	00 00 00 
  80055e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800562:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800569:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800570:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800577:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  80057e:	00 00 00 
  800581:	48 8b 18             	mov    (%rax),%rbx
  800584:	48 b8 d0 1c 80 00 00 	movabs $0x801cd0,%rax
  80058b:	00 00 00 
  80058e:	ff d0                	callq  *%rax
  800590:	89 c6                	mov    %eax,%esi
  800592:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800598:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80059f:	41 89 d0             	mov    %edx,%r8d
  8005a2:	48 89 c1             	mov    %rax,%rcx
  8005a5:	48 89 da             	mov    %rbx,%rdx
  8005a8:	48 bf 00 43 80 00 00 	movabs $0x804300,%rdi
  8005af:	00 00 00 
  8005b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b7:	49 b9 27 07 80 00 00 	movabs $0x800727,%r9
  8005be:	00 00 00 
  8005c1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005c4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005d2:	48 89 d6             	mov    %rdx,%rsi
  8005d5:	48 89 c7             	mov    %rax,%rdi
  8005d8:	48 b8 7b 06 80 00 00 	movabs $0x80067b,%rax
  8005df:	00 00 00 
  8005e2:	ff d0                	callq  *%rax
	cprintf("\n");
  8005e4:	48 bf 23 43 80 00 00 	movabs $0x804323,%rdi
  8005eb:	00 00 00 
  8005ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f3:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  8005fa:	00 00 00 
  8005fd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005ff:	cc                   	int3   
  800600:	eb fd                	jmp    8005ff <_panic+0x111>

0000000000800602 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800602:	55                   	push   %rbp
  800603:	48 89 e5             	mov    %rsp,%rbp
  800606:	48 83 ec 10          	sub    $0x10,%rsp
  80060a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80060d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800615:	8b 00                	mov    (%rax),%eax
  800617:	8d 48 01             	lea    0x1(%rax),%ecx
  80061a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061e:	89 0a                	mov    %ecx,(%rdx)
  800620:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800623:	89 d1                	mov    %edx,%ecx
  800625:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800629:	48 98                	cltq   
  80062b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80062f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800633:	8b 00                	mov    (%rax),%eax
  800635:	3d ff 00 00 00       	cmp    $0xff,%eax
  80063a:	75 2c                	jne    800668 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	48 98                	cltq   
  800644:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800648:	48 83 c2 08          	add    $0x8,%rdx
  80064c:	48 89 c6             	mov    %rax,%rsi
  80064f:	48 89 d7             	mov    %rdx,%rdi
  800652:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  800659:	00 00 00 
  80065c:	ff d0                	callq  *%rax
        b->idx = 0;
  80065e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800662:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066c:	8b 40 04             	mov    0x4(%rax),%eax
  80066f:	8d 50 01             	lea    0x1(%rax),%edx
  800672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800676:	89 50 04             	mov    %edx,0x4(%rax)
}
  800679:	c9                   	leaveq 
  80067a:	c3                   	retq   

000000000080067b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80067b:	55                   	push   %rbp
  80067c:	48 89 e5             	mov    %rsp,%rbp
  80067f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800686:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80068d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800694:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80069b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006a2:	48 8b 0a             	mov    (%rdx),%rcx
  8006a5:	48 89 08             	mov    %rcx,(%rax)
  8006a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006bf:	00 00 00 
    b.cnt = 0;
  8006c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006c9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006e1:	48 89 c6             	mov    %rax,%rsi
  8006e4:	48 bf 02 06 80 00 00 	movabs $0x800602,%rdi
  8006eb:	00 00 00 
  8006ee:	48 b8 c6 0a 80 00 00 	movabs $0x800ac6,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800700:	48 98                	cltq   
  800702:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800709:	48 83 c2 08          	add    $0x8,%rdx
  80070d:	48 89 c6             	mov    %rax,%rsi
  800710:	48 89 d7             	mov    %rdx,%rdi
  800713:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80071f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800725:	c9                   	leaveq 
  800726:	c3                   	retq   

0000000000800727 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800727:	55                   	push   %rbp
  800728:	48 89 e5             	mov    %rsp,%rbp
  80072b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800732:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800739:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800740:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800747:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80074e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800755:	84 c0                	test   %al,%al
  800757:	74 20                	je     800779 <cprintf+0x52>
  800759:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80075d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800761:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800765:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800769:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80076d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800771:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800775:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800779:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800780:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800787:	00 00 00 
  80078a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800791:	00 00 00 
  800794:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800798:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80079f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007bb:	48 8b 0a             	mov    (%rdx),%rcx
  8007be:	48 89 08             	mov    %rcx,(%rax)
  8007c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007df:	48 89 d6             	mov    %rdx,%rsi
  8007e2:	48 89 c7             	mov    %rax,%rdi
  8007e5:	48 b8 7b 06 80 00 00 	movabs $0x80067b,%rax
  8007ec:	00 00 00 
  8007ef:	ff d0                	callq  *%rax
  8007f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007fd:	c9                   	leaveq 
  8007fe:	c3                   	retq   

00000000008007ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ff:	55                   	push   %rbp
  800800:	48 89 e5             	mov    %rsp,%rbp
  800803:	48 83 ec 30          	sub    $0x30,%rsp
  800807:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80080f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800813:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800816:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80081a:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800821:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800825:	77 42                	ja     800869 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800827:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80082a:	8d 78 ff             	lea    -0x1(%rax),%edi
  80082d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	48 f7 f6             	div    %rsi
  80083c:	49 89 c2             	mov    %rax,%r10
  80083f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800842:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800845:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80084d:	41 89 c9             	mov    %ecx,%r9d
  800850:	41 89 f8             	mov    %edi,%r8d
  800853:	89 d1                	mov    %edx,%ecx
  800855:	4c 89 d2             	mov    %r10,%rdx
  800858:	48 89 c7             	mov    %rax,%rdi
  80085b:	48 b8 ff 07 80 00 00 	movabs $0x8007ff,%rax
  800862:	00 00 00 
  800865:	ff d0                	callq  *%rax
  800867:	eb 1e                	jmp    800887 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800869:	eb 12                	jmp    80087d <printnum+0x7e>
			putch(padc, putdat);
  80086b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80086f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800876:	48 89 ce             	mov    %rcx,%rsi
  800879:	89 d7                	mov    %edx,%edi
  80087b:	ff d0                	callq  *%rax
		while (--width > 0)
  80087d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800881:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800885:	7f e4                	jg     80086b <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800887:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80088a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	48 f7 f1             	div    %rcx
  800896:	48 b8 30 45 80 00 00 	movabs $0x804530,%rax
  80089d:	00 00 00 
  8008a0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008a4:	0f be d0             	movsbl %al,%edx
  8008a7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008af:	48 89 ce             	mov    %rcx,%rsi
  8008b2:	89 d7                	mov    %edx,%edi
  8008b4:	ff d0                	callq  *%rax
}
  8008b6:	c9                   	leaveq 
  8008b7:	c3                   	retq   

00000000008008b8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %rbp
  8008b9:	48 89 e5             	mov    %rsp,%rbp
  8008bc:	48 83 ec 20          	sub    $0x20,%rsp
  8008c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008c7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008cb:	7e 4f                	jle    80091c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d1:	8b 00                	mov    (%rax),%eax
  8008d3:	83 f8 30             	cmp    $0x30,%eax
  8008d6:	73 24                	jae    8008fc <getuint+0x44>
  8008d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e4:	8b 00                	mov    (%rax),%eax
  8008e6:	89 c0                	mov    %eax,%eax
  8008e8:	48 01 d0             	add    %rdx,%rax
  8008eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ef:	8b 12                	mov    (%rdx),%edx
  8008f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f8:	89 0a                	mov    %ecx,(%rdx)
  8008fa:	eb 14                	jmp    800910 <getuint+0x58>
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	48 8b 40 08          	mov    0x8(%rax),%rax
  800904:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800908:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800910:	48 8b 00             	mov    (%rax),%rax
  800913:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800917:	e9 9d 00 00 00       	jmpq   8009b9 <getuint+0x101>
	else if (lflag)
  80091c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800920:	74 4c                	je     80096e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	8b 00                	mov    (%rax),%eax
  800928:	83 f8 30             	cmp    $0x30,%eax
  80092b:	73 24                	jae    800951 <getuint+0x99>
  80092d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800931:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	8b 00                	mov    (%rax),%eax
  80093b:	89 c0                	mov    %eax,%eax
  80093d:	48 01 d0             	add    %rdx,%rax
  800940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800944:	8b 12                	mov    (%rdx),%edx
  800946:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800949:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094d:	89 0a                	mov    %ecx,(%rdx)
  80094f:	eb 14                	jmp    800965 <getuint+0xad>
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	48 8b 40 08          	mov    0x8(%rax),%rax
  800959:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80095d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800961:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800965:	48 8b 00             	mov    (%rax),%rax
  800968:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80096c:	eb 4b                	jmp    8009b9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80096e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800972:	8b 00                	mov    (%rax),%eax
  800974:	83 f8 30             	cmp    $0x30,%eax
  800977:	73 24                	jae    80099d <getuint+0xe5>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	89 c0                	mov    %eax,%eax
  800989:	48 01 d0             	add    %rdx,%rax
  80098c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800990:	8b 12                	mov    (%rdx),%edx
  800992:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800999:	89 0a                	mov    %ecx,(%rdx)
  80099b:	eb 14                	jmp    8009b1 <getuint+0xf9>
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009a5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b1:	8b 00                	mov    (%rax),%eax
  8009b3:	89 c0                	mov    %eax,%eax
  8009b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009bd:	c9                   	leaveq 
  8009be:	c3                   	retq   

00000000008009bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009bf:	55                   	push   %rbp
  8009c0:	48 89 e5             	mov    %rsp,%rbp
  8009c3:	48 83 ec 20          	sub    $0x20,%rsp
  8009c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009cb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009ce:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009d2:	7e 4f                	jle    800a23 <getint+0x64>
		x=va_arg(*ap, long long);
  8009d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d8:	8b 00                	mov    (%rax),%eax
  8009da:	83 f8 30             	cmp    $0x30,%eax
  8009dd:	73 24                	jae    800a03 <getint+0x44>
  8009df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	8b 00                	mov    (%rax),%eax
  8009ed:	89 c0                	mov    %eax,%eax
  8009ef:	48 01 d0             	add    %rdx,%rax
  8009f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f6:	8b 12                	mov    (%rdx),%edx
  8009f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ff:	89 0a                	mov    %ecx,(%rdx)
  800a01:	eb 14                	jmp    800a17 <getint+0x58>
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a0b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a13:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a17:	48 8b 00             	mov    (%rax),%rax
  800a1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a1e:	e9 9d 00 00 00       	jmpq   800ac0 <getint+0x101>
	else if (lflag)
  800a23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a27:	74 4c                	je     800a75 <getint+0xb6>
		x=va_arg(*ap, long);
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	8b 00                	mov    (%rax),%eax
  800a2f:	83 f8 30             	cmp    $0x30,%eax
  800a32:	73 24                	jae    800a58 <getint+0x99>
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	8b 00                	mov    (%rax),%eax
  800a42:	89 c0                	mov    %eax,%eax
  800a44:	48 01 d0             	add    %rdx,%rax
  800a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4b:	8b 12                	mov    (%rdx),%edx
  800a4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a54:	89 0a                	mov    %ecx,(%rdx)
  800a56:	eb 14                	jmp    800a6c <getint+0xad>
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a60:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a68:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6c:	48 8b 00             	mov    (%rax),%rax
  800a6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a73:	eb 4b                	jmp    800ac0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a79:	8b 00                	mov    (%rax),%eax
  800a7b:	83 f8 30             	cmp    $0x30,%eax
  800a7e:	73 24                	jae    800aa4 <getint+0xe5>
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8c:	8b 00                	mov    (%rax),%eax
  800a8e:	89 c0                	mov    %eax,%eax
  800a90:	48 01 d0             	add    %rdx,%rax
  800a93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a97:	8b 12                	mov    (%rdx),%edx
  800a99:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa0:	89 0a                	mov    %ecx,(%rdx)
  800aa2:	eb 14                	jmp    800ab8 <getint+0xf9>
  800aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa8:	48 8b 40 08          	mov    0x8(%rax),%rax
  800aac:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ab0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab8:	8b 00                	mov    (%rax),%eax
  800aba:	48 98                	cltq   
  800abc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ac4:	c9                   	leaveq 
  800ac5:	c3                   	retq   

0000000000800ac6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ac6:	55                   	push   %rbp
  800ac7:	48 89 e5             	mov    %rsp,%rbp
  800aca:	41 54                	push   %r12
  800acc:	53                   	push   %rbx
  800acd:	48 83 ec 60          	sub    $0x60,%rsp
  800ad1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ad5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ad9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800add:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ae1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ae9:	48 8b 0a             	mov    (%rdx),%rcx
  800aec:	48 89 08             	mov    %rcx,(%rax)
  800aef:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800af3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800af7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800afb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aff:	eb 17                	jmp    800b18 <vprintfmt+0x52>
			if (ch == '\0')
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	0f 84 c5 04 00 00    	je     800fce <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800b09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b11:	48 89 d6             	mov    %rdx,%rsi
  800b14:	89 df                	mov    %ebx,%edi
  800b16:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b18:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b20:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b24:	0f b6 00             	movzbl (%rax),%eax
  800b27:	0f b6 d8             	movzbl %al,%ebx
  800b2a:	83 fb 25             	cmp    $0x25,%ebx
  800b2d:	75 d2                	jne    800b01 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800b2f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b33:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b3a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b48:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b5b:	0f b6 00             	movzbl (%rax),%eax
  800b5e:	0f b6 d8             	movzbl %al,%ebx
  800b61:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b64:	83 f8 55             	cmp    $0x55,%eax
  800b67:	0f 87 2e 04 00 00    	ja     800f9b <vprintfmt+0x4d5>
  800b6d:	89 c0                	mov    %eax,%eax
  800b6f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b76:	00 
  800b77:	48 b8 58 45 80 00 00 	movabs $0x804558,%rax
  800b7e:	00 00 00 
  800b81:	48 01 d0             	add    %rdx,%rax
  800b84:	48 8b 00             	mov    (%rax),%rax
  800b87:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b89:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b8d:	eb c0                	jmp    800b4f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b8f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b93:	eb ba                	jmp    800b4f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b9c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b9f:	89 d0                	mov    %edx,%eax
  800ba1:	c1 e0 02             	shl    $0x2,%eax
  800ba4:	01 d0                	add    %edx,%eax
  800ba6:	01 c0                	add    %eax,%eax
  800ba8:	01 d8                	add    %ebx,%eax
  800baa:	83 e8 30             	sub    $0x30,%eax
  800bad:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bb0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bb4:	0f b6 00             	movzbl (%rax),%eax
  800bb7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bba:	83 fb 2f             	cmp    $0x2f,%ebx
  800bbd:	7e 0c                	jle    800bcb <vprintfmt+0x105>
  800bbf:	83 fb 39             	cmp    $0x39,%ebx
  800bc2:	7f 07                	jg     800bcb <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800bc4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800bc9:	eb d1                	jmp    800b9c <vprintfmt+0xd6>
			goto process_precision;
  800bcb:	eb 50                	jmp    800c1d <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800bcd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd0:	83 f8 30             	cmp    $0x30,%eax
  800bd3:	73 17                	jae    800bec <vprintfmt+0x126>
  800bd5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdc:	89 d2                	mov    %edx,%edx
  800bde:	48 01 d0             	add    %rdx,%rax
  800be1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800be4:	83 c2 08             	add    $0x8,%edx
  800be7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bea:	eb 0c                	jmp    800bf8 <vprintfmt+0x132>
  800bec:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bf0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bf4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf8:	8b 00                	mov    (%rax),%eax
  800bfa:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bfd:	eb 1e                	jmp    800c1d <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800bff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c03:	79 07                	jns    800c0c <vprintfmt+0x146>
				width = 0;
  800c05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c0c:	e9 3e ff ff ff       	jmpq   800b4f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c11:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c18:	e9 32 ff ff ff       	jmpq   800b4f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c21:	79 0d                	jns    800c30 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800c23:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c26:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c30:	e9 1a ff ff ff       	jmpq   800b4f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c35:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c39:	e9 11 ff ff ff       	jmpq   800b4f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c41:	83 f8 30             	cmp    $0x30,%eax
  800c44:	73 17                	jae    800c5d <vprintfmt+0x197>
  800c46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c4a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4d:	89 d2                	mov    %edx,%edx
  800c4f:	48 01 d0             	add    %rdx,%rax
  800c52:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c55:	83 c2 08             	add    $0x8,%edx
  800c58:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c5b:	eb 0c                	jmp    800c69 <vprintfmt+0x1a3>
  800c5d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c61:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c69:	8b 10                	mov    (%rax),%edx
  800c6b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c73:	48 89 ce             	mov    %rcx,%rsi
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	ff d0                	callq  *%rax
			break;
  800c7a:	e9 4a 03 00 00       	jmpq   800fc9 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c82:	83 f8 30             	cmp    $0x30,%eax
  800c85:	73 17                	jae    800c9e <vprintfmt+0x1d8>
  800c87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8e:	89 d2                	mov    %edx,%edx
  800c90:	48 01 d0             	add    %rdx,%rax
  800c93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c96:	83 c2 08             	add    $0x8,%edx
  800c99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9c:	eb 0c                	jmp    800caa <vprintfmt+0x1e4>
  800c9e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ca2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ca6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800caa:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cac:	85 db                	test   %ebx,%ebx
  800cae:	79 02                	jns    800cb2 <vprintfmt+0x1ec>
				err = -err;
  800cb0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cb2:	83 fb 15             	cmp    $0x15,%ebx
  800cb5:	7f 16                	jg     800ccd <vprintfmt+0x207>
  800cb7:	48 b8 80 44 80 00 00 	movabs $0x804480,%rax
  800cbe:	00 00 00 
  800cc1:	48 63 d3             	movslq %ebx,%rdx
  800cc4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc8:	4d 85 e4             	test   %r12,%r12
  800ccb:	75 2e                	jne    800cfb <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800ccd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd5:	89 d9                	mov    %ebx,%ecx
  800cd7:	48 ba 41 45 80 00 00 	movabs $0x804541,%rdx
  800cde:	00 00 00 
  800ce1:	48 89 c7             	mov    %rax,%rdi
  800ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce9:	49 b8 d7 0f 80 00 00 	movabs $0x800fd7,%r8
  800cf0:	00 00 00 
  800cf3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf6:	e9 ce 02 00 00       	jmpq   800fc9 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800cfb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d03:	4c 89 e1             	mov    %r12,%rcx
  800d06:	48 ba 4a 45 80 00 00 	movabs $0x80454a,%rdx
  800d0d:	00 00 00 
  800d10:	48 89 c7             	mov    %rax,%rdi
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
  800d18:	49 b8 d7 0f 80 00 00 	movabs $0x800fd7,%r8
  800d1f:	00 00 00 
  800d22:	41 ff d0             	callq  *%r8
			break;
  800d25:	e9 9f 02 00 00       	jmpq   800fc9 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2d:	83 f8 30             	cmp    $0x30,%eax
  800d30:	73 17                	jae    800d49 <vprintfmt+0x283>
  800d32:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d39:	89 d2                	mov    %edx,%edx
  800d3b:	48 01 d0             	add    %rdx,%rax
  800d3e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d41:	83 c2 08             	add    $0x8,%edx
  800d44:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d47:	eb 0c                	jmp    800d55 <vprintfmt+0x28f>
  800d49:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d4d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d51:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d55:	4c 8b 20             	mov    (%rax),%r12
  800d58:	4d 85 e4             	test   %r12,%r12
  800d5b:	75 0a                	jne    800d67 <vprintfmt+0x2a1>
				p = "(null)";
  800d5d:	49 bc 4d 45 80 00 00 	movabs $0x80454d,%r12
  800d64:	00 00 00 
			if (width > 0 && padc != '-')
  800d67:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6b:	7e 3f                	jle    800dac <vprintfmt+0x2e6>
  800d6d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d71:	74 39                	je     800dac <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d73:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d76:	48 98                	cltq   
  800d78:	48 89 c6             	mov    %rax,%rsi
  800d7b:	4c 89 e7             	mov    %r12,%rdi
  800d7e:	48 b8 dd 13 80 00 00 	movabs $0x8013dd,%rax
  800d85:	00 00 00 
  800d88:	ff d0                	callq  *%rax
  800d8a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d8d:	eb 17                	jmp    800da6 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800d8f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d93:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	48 89 ce             	mov    %rcx,%rsi
  800d9e:	89 d7                	mov    %edx,%edi
  800da0:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800da2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800daa:	7f e3                	jg     800d8f <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dac:	eb 37                	jmp    800de5 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800dae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db2:	74 1e                	je     800dd2 <vprintfmt+0x30c>
  800db4:	83 fb 1f             	cmp    $0x1f,%ebx
  800db7:	7e 05                	jle    800dbe <vprintfmt+0x2f8>
  800db9:	83 fb 7e             	cmp    $0x7e,%ebx
  800dbc:	7e 14                	jle    800dd2 <vprintfmt+0x30c>
					putch('?', putdat);
  800dbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	48 89 d6             	mov    %rdx,%rsi
  800dc9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dce:	ff d0                	callq  *%rax
  800dd0:	eb 0f                	jmp    800de1 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800dd2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dda:	48 89 d6             	mov    %rdx,%rsi
  800ddd:	89 df                	mov    %ebx,%edi
  800ddf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de5:	4c 89 e0             	mov    %r12,%rax
  800de8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800dec:	0f b6 00             	movzbl (%rax),%eax
  800def:	0f be d8             	movsbl %al,%ebx
  800df2:	85 db                	test   %ebx,%ebx
  800df4:	74 10                	je     800e06 <vprintfmt+0x340>
  800df6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dfa:	78 b2                	js     800dae <vprintfmt+0x2e8>
  800dfc:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e00:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e04:	79 a8                	jns    800dae <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800e06:	eb 16                	jmp    800e1e <vprintfmt+0x358>
				putch(' ', putdat);
  800e08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e10:	48 89 d6             	mov    %rdx,%rsi
  800e13:	bf 20 00 00 00       	mov    $0x20,%edi
  800e18:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800e1a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e22:	7f e4                	jg     800e08 <vprintfmt+0x342>
			break;
  800e24:	e9 a0 01 00 00       	jmpq   800fc9 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e29:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e2d:	be 03 00 00 00       	mov    $0x3,%esi
  800e32:	48 89 c7             	mov    %rax,%rdi
  800e35:	48 b8 bf 09 80 00 00 	movabs $0x8009bf,%rax
  800e3c:	00 00 00 
  800e3f:	ff d0                	callq  *%rax
  800e41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e49:	48 85 c0             	test   %rax,%rax
  800e4c:	79 1d                	jns    800e6b <vprintfmt+0x3a5>
				putch('-', putdat);
  800e4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e56:	48 89 d6             	mov    %rdx,%rsi
  800e59:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e5e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e64:	48 f7 d8             	neg    %rax
  800e67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e6b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e72:	e9 e5 00 00 00       	jmpq   800f5c <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e77:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7b:	be 03 00 00 00       	mov    $0x3,%esi
  800e80:	48 89 c7             	mov    %rax,%rdi
  800e83:	48 b8 b8 08 80 00 00 	movabs $0x8008b8,%rax
  800e8a:	00 00 00 
  800e8d:	ff d0                	callq  *%rax
  800e8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e93:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e9a:	e9 bd 00 00 00       	jmpq   800f5c <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea7:	48 89 d6             	mov    %rdx,%rsi
  800eaa:	bf 58 00 00 00       	mov    $0x58,%edi
  800eaf:	ff d0                	callq  *%rax
			putch('X', putdat);
  800eb1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb9:	48 89 d6             	mov    %rdx,%rsi
  800ebc:	bf 58 00 00 00       	mov    $0x58,%edi
  800ec1:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ec3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecb:	48 89 d6             	mov    %rdx,%rsi
  800ece:	bf 58 00 00 00       	mov    $0x58,%edi
  800ed3:	ff d0                	callq  *%rax
			break;
  800ed5:	e9 ef 00 00 00       	jmpq   800fc9 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800eda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ede:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee2:	48 89 d6             	mov    %rdx,%rsi
  800ee5:	bf 30 00 00 00       	mov    $0x30,%edi
  800eea:	ff d0                	callq  *%rax
			putch('x', putdat);
  800eec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef4:	48 89 d6             	mov    %rdx,%rsi
  800ef7:	bf 78 00 00 00       	mov    $0x78,%edi
  800efc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800efe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f01:	83 f8 30             	cmp    $0x30,%eax
  800f04:	73 17                	jae    800f1d <vprintfmt+0x457>
  800f06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f0d:	89 d2                	mov    %edx,%edx
  800f0f:	48 01 d0             	add    %rdx,%rax
  800f12:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f15:	83 c2 08             	add    $0x8,%edx
  800f18:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800f1b:	eb 0c                	jmp    800f29 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800f1d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f21:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f25:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f29:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800f2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f30:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f37:	eb 23                	jmp    800f5c <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f39:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f3d:	be 03 00 00 00       	mov    $0x3,%esi
  800f42:	48 89 c7             	mov    %rax,%rdi
  800f45:	48 b8 b8 08 80 00 00 	movabs $0x8008b8,%rax
  800f4c:	00 00 00 
  800f4f:	ff d0                	callq  *%rax
  800f51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f55:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f5c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f61:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f64:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f6b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f73:	45 89 c1             	mov    %r8d,%r9d
  800f76:	41 89 f8             	mov    %edi,%r8d
  800f79:	48 89 c7             	mov    %rax,%rdi
  800f7c:	48 b8 ff 07 80 00 00 	movabs $0x8007ff,%rax
  800f83:	00 00 00 
  800f86:	ff d0                	callq  *%rax
			break;
  800f88:	eb 3f                	jmp    800fc9 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f92:	48 89 d6             	mov    %rdx,%rsi
  800f95:	89 df                	mov    %ebx,%edi
  800f97:	ff d0                	callq  *%rax
			break;
  800f99:	eb 2e                	jmp    800fc9 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa3:	48 89 d6             	mov    %rdx,%rsi
  800fa6:	bf 25 00 00 00       	mov    $0x25,%edi
  800fab:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fad:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fb2:	eb 05                	jmp    800fb9 <vprintfmt+0x4f3>
  800fb4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fb9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fbd:	48 83 e8 01          	sub    $0x1,%rax
  800fc1:	0f b6 00             	movzbl (%rax),%eax
  800fc4:	3c 25                	cmp    $0x25,%al
  800fc6:	75 ec                	jne    800fb4 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800fc8:	90                   	nop
		}
	}
  800fc9:	e9 31 fb ff ff       	jmpq   800aff <vprintfmt+0x39>
	va_end(aq);
}
  800fce:	48 83 c4 60          	add    $0x60,%rsp
  800fd2:	5b                   	pop    %rbx
  800fd3:	41 5c                	pop    %r12
  800fd5:	5d                   	pop    %rbp
  800fd6:	c3                   	retq   

0000000000800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %rbp
  800fd8:	48 89 e5             	mov    %rsp,%rbp
  800fdb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fe2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fe9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ff0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ff7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ffe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801005:	84 c0                	test   %al,%al
  801007:	74 20                	je     801029 <printfmt+0x52>
  801009:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80100d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801011:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801015:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801019:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80101d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801021:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801025:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801029:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801030:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801037:	00 00 00 
  80103a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801041:	00 00 00 
  801044:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801048:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80104f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801056:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80105d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801064:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80106b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801072:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801079:	48 89 c7             	mov    %rax,%rdi
  80107c:	48 b8 c6 0a 80 00 00 	movabs $0x800ac6,%rax
  801083:	00 00 00 
  801086:	ff d0                	callq  *%rax
	va_end(ap);
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 10          	sub    $0x10,%rsp
  801092:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801095:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109d:	8b 40 10             	mov    0x10(%rax),%eax
  8010a0:	8d 50 01             	lea    0x1(%rax),%edx
  8010a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ae:	48 8b 10             	mov    (%rax),%rdx
  8010b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010b9:	48 39 c2             	cmp    %rax,%rdx
  8010bc:	73 17                	jae    8010d5 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c2:	48 8b 00             	mov    (%rax),%rax
  8010c5:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010cd:	48 89 0a             	mov    %rcx,(%rdx)
  8010d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010d3:	88 10                	mov    %dl,(%rax)
}
  8010d5:	c9                   	leaveq 
  8010d6:	c3                   	retq   

00000000008010d7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d7:	55                   	push   %rbp
  8010d8:	48 89 e5             	mov    %rsp,%rbp
  8010db:	48 83 ec 50          	sub    $0x50,%rsp
  8010df:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010e3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010e6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010ea:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010ee:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010f2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010f6:	48 8b 0a             	mov    (%rdx),%rcx
  8010f9:	48 89 08             	mov    %rcx,(%rax)
  8010fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801100:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801104:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801108:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80110c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801110:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801114:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801117:	48 98                	cltq   
  801119:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80111d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801121:	48 01 d0             	add    %rdx,%rax
  801124:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801128:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80112f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801134:	74 06                	je     80113c <vsnprintf+0x65>
  801136:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80113a:	7f 07                	jg     801143 <vsnprintf+0x6c>
		return -E_INVAL;
  80113c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801141:	eb 2f                	jmp    801172 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801143:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801147:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80114b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80114f:	48 89 c6             	mov    %rax,%rsi
  801152:	48 bf 8a 10 80 00 00 	movabs $0x80108a,%rdi
  801159:	00 00 00 
  80115c:	48 b8 c6 0a 80 00 00 	movabs $0x800ac6,%rax
  801163:	00 00 00 
  801166:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801168:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80116c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80116f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801172:	c9                   	leaveq 
  801173:	c3                   	retq   

0000000000801174 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801174:	55                   	push   %rbp
  801175:	48 89 e5             	mov    %rsp,%rbp
  801178:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80117f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801186:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80118c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801193:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80119a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011a1:	84 c0                	test   %al,%al
  8011a3:	74 20                	je     8011c5 <snprintf+0x51>
  8011a5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011a9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011ad:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011b1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011b5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011b9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011bd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011c1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011c5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011cc:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011d3:	00 00 00 
  8011d6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011dd:	00 00 00 
  8011e0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011e4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011eb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011f2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011f9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801200:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801207:	48 8b 0a             	mov    (%rdx),%rcx
  80120a:	48 89 08             	mov    %rcx,(%rax)
  80120d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801211:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801215:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801219:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80121d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801224:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80122b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801231:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801238:	48 89 c7             	mov    %rax,%rdi
  80123b:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  801242:	00 00 00 
  801245:	ff d0                	callq  *%rax
  801247:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80124d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801253:	c9                   	leaveq 
  801254:	c3                   	retq   

0000000000801255 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801255:	55                   	push   %rbp
  801256:	48 89 e5             	mov    %rsp,%rbp
  801259:	48 83 ec 20          	sub    $0x20,%rsp
  80125d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801261:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801266:	74 27                	je     80128f <readline+0x3a>
		fprintf(1, "%s", prompt);
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126c:	48 89 c2             	mov    %rax,%rdx
  80126f:	48 be 08 48 80 00 00 	movabs $0x804808,%rsi
  801276:	00 00 00 
  801279:	bf 01 00 00 00       	mov    $0x1,%edi
  80127e:	b8 00 00 00 00       	mov    $0x0,%eax
  801283:	48 b9 66 30 80 00 00 	movabs $0x803066,%rcx
  80128a:	00 00 00 
  80128d:	ff d1                	callq  *%rcx
#endif

	i = 0;
  80128f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801296:	bf 00 00 00 00       	mov    $0x0,%edi
  80129b:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
  8012a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8012aa:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8012b1:	00 00 00 
  8012b4:	ff d0                	callq  *%rax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8012b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8012bd:	79 30                	jns    8012ef <readline+0x9a>
			if (c != -E_EOF)
  8012bf:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  8012c3:	74 20                	je     8012e5 <readline+0x90>
				cprintf("read error: %e\n", c);
  8012c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012c8:	89 c6                	mov    %eax,%esi
  8012ca:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  8012d1:	00 00 00 
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d9:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  8012e0:	00 00 00 
  8012e3:	ff d2                	callq  *%rdx
			return NULL;
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ea:	e9 be 00 00 00       	jmpq   8013ad <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8012ef:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  8012f3:	74 06                	je     8012fb <readline+0xa6>
  8012f5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8012f9:	75 26                	jne    801321 <readline+0xcc>
  8012fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ff:	7e 20                	jle    801321 <readline+0xcc>
			if (echoing)
  801301:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801305:	74 11                	je     801318 <readline+0xc3>
				cputchar('\b');
  801307:	bf 08 00 00 00       	mov    $0x8,%edi
  80130c:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801313:	00 00 00 
  801316:	ff d0                	callq  *%rax
			i--;
  801318:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80131c:	e9 87 00 00 00       	jmpq   8013a8 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801321:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801325:	7e 3f                	jle    801366 <readline+0x111>
  801327:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80132e:	7f 36                	jg     801366 <readline+0x111>
			if (echoing)
  801330:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801334:	74 11                	je     801347 <readline+0xf2>
				cputchar(c);
  801336:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801339:	89 c7                	mov    %eax,%edi
  80133b:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801342:	00 00 00 
  801345:	ff d0                	callq  *%rax
			buf[i++] = c;
  801347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80134a:	8d 50 01             	lea    0x1(%rax),%edx
  80134d:	89 55 fc             	mov    %edx,-0x4(%rbp)
  801350:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801353:	89 d1                	mov    %edx,%ecx
  801355:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80135c:	00 00 00 
  80135f:	48 98                	cltq   
  801361:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  801364:	eb 42                	jmp    8013a8 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  801366:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80136a:	74 06                	je     801372 <readline+0x11d>
  80136c:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  801370:	75 36                	jne    8013a8 <readline+0x153>
			if (echoing)
  801372:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801376:	74 11                	je     801389 <readline+0x134>
				cputchar('\n');
  801378:	bf 0a 00 00 00       	mov    $0xa,%edi
  80137d:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801384:	00 00 00 
  801387:	ff d0                	callq  *%rax
			buf[i] = 0;
  801389:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801390:	00 00 00 
  801393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801396:	48 98                	cltq   
  801398:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  80139c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013a3:	00 00 00 
  8013a6:	eb 05                	jmp    8013ad <readline+0x158>
		}
	}
  8013a8:	e9 fd fe ff ff       	jmpq   8012aa <readline+0x55>
}
  8013ad:	c9                   	leaveq 
  8013ae:	c3                   	retq   

00000000008013af <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013af:	55                   	push   %rbp
  8013b0:	48 89 e5             	mov    %rsp,%rbp
  8013b3:	48 83 ec 18          	sub    $0x18,%rsp
  8013b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013c2:	eb 09                	jmp    8013cd <strlen+0x1e>
		n++;
  8013c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8013c8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	84 c0                	test   %al,%al
  8013d6:	75 ec                	jne    8013c4 <strlen+0x15>
	return n;
  8013d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 20          	sub    $0x20,%rsp
  8013e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013f4:	eb 0e                	jmp    801404 <strnlen+0x27>
		n++;
  8013f6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ff:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801404:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801409:	74 0b                	je     801416 <strnlen+0x39>
  80140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	84 c0                	test   %al,%al
  801414:	75 e0                	jne    8013f6 <strnlen+0x19>
	return n;
  801416:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801419:	c9                   	leaveq 
  80141a:	c3                   	retq   

000000000080141b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80141b:	55                   	push   %rbp
  80141c:	48 89 e5             	mov    %rsp,%rbp
  80141f:	48 83 ec 20          	sub    $0x20,%rsp
  801423:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801427:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80142b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801433:	90                   	nop
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801438:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80143c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801440:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801444:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801448:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80144c:	0f b6 12             	movzbl (%rdx),%edx
  80144f:	88 10                	mov    %dl,(%rax)
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	84 c0                	test   %al,%al
  801456:	75 dc                	jne    801434 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80145c:	c9                   	leaveq 
  80145d:	c3                   	retq   

000000000080145e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80145e:	55                   	push   %rbp
  80145f:	48 89 e5             	mov    %rsp,%rbp
  801462:	48 83 ec 20          	sub    $0x20,%rsp
  801466:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80146e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801472:	48 89 c7             	mov    %rax,%rdi
  801475:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  80147c:	00 00 00 
  80147f:	ff d0                	callq  *%rax
  801481:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801487:	48 63 d0             	movslq %eax,%rdx
  80148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148e:	48 01 c2             	add    %rax,%rdx
  801491:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801495:	48 89 c6             	mov    %rax,%rsi
  801498:	48 89 d7             	mov    %rdx,%rdi
  80149b:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  8014a2:	00 00 00 
  8014a5:	ff d0                	callq  *%rax
	return dst;
  8014a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ab:	c9                   	leaveq 
  8014ac:	c3                   	retq   

00000000008014ad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014ad:	55                   	push   %rbp
  8014ae:	48 89 e5             	mov    %rsp,%rbp
  8014b1:	48 83 ec 28          	sub    $0x28,%rsp
  8014b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014c9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014d0:	00 
  8014d1:	eb 2a                	jmp    8014fd <strncpy+0x50>
		*dst++ = *src;
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014e3:	0f b6 12             	movzbl (%rdx),%edx
  8014e6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	84 c0                	test   %al,%al
  8014f1:	74 05                	je     8014f8 <strncpy+0x4b>
			src++;
  8014f3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8014f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801501:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801505:	72 cc                	jb     8014d3 <strncpy+0x26>
	}
	return ret;
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80150b:	c9                   	leaveq 
  80150c:	c3                   	retq   

000000000080150d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80150d:	55                   	push   %rbp
  80150e:	48 89 e5             	mov    %rsp,%rbp
  801511:	48 83 ec 28          	sub    $0x28,%rsp
  801515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801519:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801525:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801529:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80152e:	74 3d                	je     80156d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801530:	eb 1d                	jmp    80154f <strlcpy+0x42>
			*dst++ = *src++;
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80153e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801542:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801546:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80154a:	0f b6 12             	movzbl (%rdx),%edx
  80154d:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80154f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801554:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801559:	74 0b                	je     801566 <strlcpy+0x59>
  80155b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80155f:	0f b6 00             	movzbl (%rax),%eax
  801562:	84 c0                	test   %al,%al
  801564:	75 cc                	jne    801532 <strlcpy+0x25>
		*dst = '\0';
  801566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80156d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801575:	48 29 c2             	sub    %rax,%rdx
  801578:	48 89 d0             	mov    %rdx,%rax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 10          	sub    $0x10,%rsp
  801585:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801589:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80158d:	eb 0a                	jmp    801599 <strcmp+0x1c>
		p++, q++;
  80158f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801594:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	84 c0                	test   %al,%al
  8015a2:	74 12                	je     8015b6 <strcmp+0x39>
  8015a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a8:	0f b6 10             	movzbl (%rax),%edx
  8015ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015af:	0f b6 00             	movzbl (%rax),%eax
  8015b2:	38 c2                	cmp    %al,%dl
  8015b4:	74 d9                	je     80158f <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	0f b6 d0             	movzbl %al,%edx
  8015c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	0f b6 c0             	movzbl %al,%eax
  8015ca:	29 c2                	sub    %eax,%edx
  8015cc:	89 d0                	mov    %edx,%eax
}
  8015ce:	c9                   	leaveq 
  8015cf:	c3                   	retq   

00000000008015d0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015d0:	55                   	push   %rbp
  8015d1:	48 89 e5             	mov    %rsp,%rbp
  8015d4:	48 83 ec 18          	sub    $0x18,%rsp
  8015d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015e4:	eb 0f                	jmp    8015f5 <strncmp+0x25>
		n--, p++, q++;
  8015e6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8015f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015fa:	74 1d                	je     801619 <strncmp+0x49>
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	84 c0                	test   %al,%al
  801605:	74 12                	je     801619 <strncmp+0x49>
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160b:	0f b6 10             	movzbl (%rax),%edx
  80160e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801612:	0f b6 00             	movzbl (%rax),%eax
  801615:	38 c2                	cmp    %al,%dl
  801617:	74 cd                	je     8015e6 <strncmp+0x16>
	if (n == 0)
  801619:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80161e:	75 07                	jne    801627 <strncmp+0x57>
		return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	eb 18                	jmp    80163f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162b:	0f b6 00             	movzbl (%rax),%eax
  80162e:	0f b6 d0             	movzbl %al,%edx
  801631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	0f b6 c0             	movzbl %al,%eax
  80163b:	29 c2                	sub    %eax,%edx
  80163d:	89 d0                	mov    %edx,%eax
}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	48 83 ec 10          	sub    $0x10,%rsp
  801649:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164d:	89 f0                	mov    %esi,%eax
  80164f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801652:	eb 17                	jmp    80166b <strchr+0x2a>
		if (*s == c)
  801654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80165e:	75 06                	jne    801666 <strchr+0x25>
			return (char *) s;
  801660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801664:	eb 15                	jmp    80167b <strchr+0x3a>
	for (; *s; s++)
  801666:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80166b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	84 c0                	test   %al,%al
  801674:	75 de                	jne    801654 <strchr+0x13>
	return 0;
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167b:	c9                   	leaveq 
  80167c:	c3                   	retq   

000000000080167d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
  801681:	48 83 ec 10          	sub    $0x10,%rsp
  801685:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801689:	89 f0                	mov    %esi,%eax
  80168b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80168e:	eb 13                	jmp    8016a3 <strfind+0x26>
		if (*s == c)
  801690:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80169a:	75 02                	jne    80169e <strfind+0x21>
			break;
  80169c:	eb 10                	jmp    8016ae <strfind+0x31>
	for (; *s; s++)
  80169e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	84 c0                	test   %al,%al
  8016ac:	75 e2                	jne    801690 <strfind+0x13>
	return (char *) s;
  8016ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016b2:	c9                   	leaveq 
  8016b3:	c3                   	retq   

00000000008016b4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016b4:	55                   	push   %rbp
  8016b5:	48 89 e5             	mov    %rsp,%rbp
  8016b8:	48 83 ec 18          	sub    $0x18,%rsp
  8016bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016cc:	75 06                	jne    8016d4 <memset+0x20>
		return v;
  8016ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d2:	eb 69                	jmp    80173d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d8:	83 e0 03             	and    $0x3,%eax
  8016db:	48 85 c0             	test   %rax,%rax
  8016de:	75 48                	jne    801728 <memset+0x74>
  8016e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e4:	83 e0 03             	and    $0x3,%eax
  8016e7:	48 85 c0             	test   %rax,%rax
  8016ea:	75 3c                	jne    801728 <memset+0x74>
		c &= 0xFF;
  8016ec:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f6:	c1 e0 18             	shl    $0x18,%eax
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016fe:	c1 e0 10             	shl    $0x10,%eax
  801701:	09 c2                	or     %eax,%edx
  801703:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801706:	c1 e0 08             	shl    $0x8,%eax
  801709:	09 d0                	or     %edx,%eax
  80170b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80170e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801712:	48 c1 e8 02          	shr    $0x2,%rax
  801716:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801719:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801720:	48 89 d7             	mov    %rdx,%rdi
  801723:	fc                   	cld    
  801724:	f3 ab                	rep stos %eax,%es:(%rdi)
  801726:	eb 11                	jmp    801739 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801728:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80172f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801733:	48 89 d7             	mov    %rdx,%rdi
  801736:	fc                   	cld    
  801737:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 28          	sub    $0x28,%rsp
  801747:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80174b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80174f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801753:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801757:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80175b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801767:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80176b:	0f 83 88 00 00 00    	jae    8017f9 <memmove+0xba>
  801771:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	48 01 d0             	add    %rdx,%rax
  80177c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801780:	76 77                	jbe    8017f9 <memmove+0xba>
		s += n;
  801782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801786:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80178a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801796:	83 e0 03             	and    $0x3,%eax
  801799:	48 85 c0             	test   %rax,%rax
  80179c:	75 3b                	jne    8017d9 <memmove+0x9a>
  80179e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a2:	83 e0 03             	and    $0x3,%eax
  8017a5:	48 85 c0             	test   %rax,%rax
  8017a8:	75 2f                	jne    8017d9 <memmove+0x9a>
  8017aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ae:	83 e0 03             	and    $0x3,%eax
  8017b1:	48 85 c0             	test   %rax,%rax
  8017b4:	75 23                	jne    8017d9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ba:	48 83 e8 04          	sub    $0x4,%rax
  8017be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017c2:	48 83 ea 04          	sub    $0x4,%rdx
  8017c6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017ca:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8017ce:	48 89 c7             	mov    %rax,%rdi
  8017d1:	48 89 d6             	mov    %rdx,%rsi
  8017d4:	fd                   	std    
  8017d5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017d7:	eb 1d                	jmp    8017f6 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017dd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	48 89 d7             	mov    %rdx,%rdi
  8017f0:	48 89 c1             	mov    %rax,%rcx
  8017f3:	fd                   	std    
  8017f4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017f6:	fc                   	cld    
  8017f7:	eb 57                	jmp    801850 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fd:	83 e0 03             	and    $0x3,%eax
  801800:	48 85 c0             	test   %rax,%rax
  801803:	75 36                	jne    80183b <memmove+0xfc>
  801805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801809:	83 e0 03             	and    $0x3,%eax
  80180c:	48 85 c0             	test   %rax,%rax
  80180f:	75 2a                	jne    80183b <memmove+0xfc>
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	83 e0 03             	and    $0x3,%eax
  801818:	48 85 c0             	test   %rax,%rax
  80181b:	75 1e                	jne    80183b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	48 c1 e8 02          	shr    $0x2,%rax
  801825:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801830:	48 89 c7             	mov    %rax,%rdi
  801833:	48 89 d6             	mov    %rdx,%rsi
  801836:	fc                   	cld    
  801837:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801839:	eb 15                	jmp    801850 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80183b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801843:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801847:	48 89 c7             	mov    %rax,%rdi
  80184a:	48 89 d6             	mov    %rdx,%rsi
  80184d:	fc                   	cld    
  80184e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801854:	c9                   	leaveq 
  801855:	c3                   	retq   

0000000000801856 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801856:	55                   	push   %rbp
  801857:	48 89 e5             	mov    %rsp,%rbp
  80185a:	48 83 ec 18          	sub    $0x18,%rsp
  80185e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801862:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801866:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80186a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80186e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801876:	48 89 ce             	mov    %rcx,%rsi
  801879:	48 89 c7             	mov    %rax,%rdi
  80187c:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  801883:	00 00 00 
  801886:	ff d0                	callq  *%rax
}
  801888:	c9                   	leaveq 
  801889:	c3                   	retq   

000000000080188a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80188a:	55                   	push   %rbp
  80188b:	48 89 e5             	mov    %rsp,%rbp
  80188e:	48 83 ec 28          	sub    $0x28,%rsp
  801892:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801896:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80189a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80189e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018ae:	eb 36                	jmp    8018e6 <memcmp+0x5c>
		if (*s1 != *s2)
  8018b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b4:	0f b6 10             	movzbl (%rax),%edx
  8018b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018bb:	0f b6 00             	movzbl (%rax),%eax
  8018be:	38 c2                	cmp    %al,%dl
  8018c0:	74 1a                	je     8018dc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c6:	0f b6 00             	movzbl (%rax),%eax
  8018c9:	0f b6 d0             	movzbl %al,%edx
  8018cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d0:	0f b6 00             	movzbl (%rax),%eax
  8018d3:	0f b6 c0             	movzbl %al,%eax
  8018d6:	29 c2                	sub    %eax,%edx
  8018d8:	89 d0                	mov    %edx,%eax
  8018da:	eb 20                	jmp    8018fc <memcmp+0x72>
		s1++, s2++;
  8018dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018e1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8018e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ea:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018f2:	48 85 c0             	test   %rax,%rax
  8018f5:	75 b9                	jne    8018b0 <memcmp+0x26>
	}

	return 0;
  8018f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fc:	c9                   	leaveq 
  8018fd:	c3                   	retq   

00000000008018fe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018fe:	55                   	push   %rbp
  8018ff:	48 89 e5             	mov    %rsp,%rbp
  801902:	48 83 ec 28          	sub    $0x28,%rsp
  801906:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80190a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80190d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801919:	48 01 d0             	add    %rdx,%rax
  80191c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801920:	eb 15                	jmp    801937 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80192c:	38 d0                	cmp    %dl,%al
  80192e:	75 02                	jne    801932 <memfind+0x34>
			break;
  801930:	eb 0f                	jmp    801941 <memfind+0x43>
	for (; s < ends; s++)
  801932:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80193b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80193f:	72 e1                	jb     801922 <memfind+0x24>
	return (void *) s;
  801941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801945:	c9                   	leaveq 
  801946:	c3                   	retq   

0000000000801947 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801947:	55                   	push   %rbp
  801948:	48 89 e5             	mov    %rsp,%rbp
  80194b:	48 83 ec 38          	sub    $0x38,%rsp
  80194f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801953:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801957:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80195a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801961:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801968:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801969:	eb 05                	jmp    801970 <strtol+0x29>
		s++;
  80196b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801974:	0f b6 00             	movzbl (%rax),%eax
  801977:	3c 20                	cmp    $0x20,%al
  801979:	74 f0                	je     80196b <strtol+0x24>
  80197b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197f:	0f b6 00             	movzbl (%rax),%eax
  801982:	3c 09                	cmp    $0x9,%al
  801984:	74 e5                	je     80196b <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198a:	0f b6 00             	movzbl (%rax),%eax
  80198d:	3c 2b                	cmp    $0x2b,%al
  80198f:	75 07                	jne    801998 <strtol+0x51>
		s++;
  801991:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801996:	eb 17                	jmp    8019af <strtol+0x68>
	else if (*s == '-')
  801998:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199c:	0f b6 00             	movzbl (%rax),%eax
  80199f:	3c 2d                	cmp    $0x2d,%al
  8019a1:	75 0c                	jne    8019af <strtol+0x68>
		s++, neg = 1;
  8019a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019af:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019b3:	74 06                	je     8019bb <strtol+0x74>
  8019b5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019b9:	75 28                	jne    8019e3 <strtol+0x9c>
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	0f b6 00             	movzbl (%rax),%eax
  8019c2:	3c 30                	cmp    $0x30,%al
  8019c4:	75 1d                	jne    8019e3 <strtol+0x9c>
  8019c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ca:	48 83 c0 01          	add    $0x1,%rax
  8019ce:	0f b6 00             	movzbl (%rax),%eax
  8019d1:	3c 78                	cmp    $0x78,%al
  8019d3:	75 0e                	jne    8019e3 <strtol+0x9c>
		s += 2, base = 16;
  8019d5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019da:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019e1:	eb 2c                	jmp    801a0f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019e7:	75 19                	jne    801a02 <strtol+0xbb>
  8019e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ed:	0f b6 00             	movzbl (%rax),%eax
  8019f0:	3c 30                	cmp    $0x30,%al
  8019f2:	75 0e                	jne    801a02 <strtol+0xbb>
		s++, base = 8;
  8019f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a00:	eb 0d                	jmp    801a0f <strtol+0xc8>
	else if (base == 0)
  801a02:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a06:	75 07                	jne    801a0f <strtol+0xc8>
		base = 10;
  801a08:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a13:	0f b6 00             	movzbl (%rax),%eax
  801a16:	3c 2f                	cmp    $0x2f,%al
  801a18:	7e 1d                	jle    801a37 <strtol+0xf0>
  801a1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1e:	0f b6 00             	movzbl (%rax),%eax
  801a21:	3c 39                	cmp    $0x39,%al
  801a23:	7f 12                	jg     801a37 <strtol+0xf0>
			dig = *s - '0';
  801a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a29:	0f b6 00             	movzbl (%rax),%eax
  801a2c:	0f be c0             	movsbl %al,%eax
  801a2f:	83 e8 30             	sub    $0x30,%eax
  801a32:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a35:	eb 4e                	jmp    801a85 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3b:	0f b6 00             	movzbl (%rax),%eax
  801a3e:	3c 60                	cmp    $0x60,%al
  801a40:	7e 1d                	jle    801a5f <strtol+0x118>
  801a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a46:	0f b6 00             	movzbl (%rax),%eax
  801a49:	3c 7a                	cmp    $0x7a,%al
  801a4b:	7f 12                	jg     801a5f <strtol+0x118>
			dig = *s - 'a' + 10;
  801a4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a51:	0f b6 00             	movzbl (%rax),%eax
  801a54:	0f be c0             	movsbl %al,%eax
  801a57:	83 e8 57             	sub    $0x57,%eax
  801a5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a5d:	eb 26                	jmp    801a85 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a63:	0f b6 00             	movzbl (%rax),%eax
  801a66:	3c 40                	cmp    $0x40,%al
  801a68:	7e 48                	jle    801ab2 <strtol+0x16b>
  801a6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6e:	0f b6 00             	movzbl (%rax),%eax
  801a71:	3c 5a                	cmp    $0x5a,%al
  801a73:	7f 3d                	jg     801ab2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a79:	0f b6 00             	movzbl (%rax),%eax
  801a7c:	0f be c0             	movsbl %al,%eax
  801a7f:	83 e8 37             	sub    $0x37,%eax
  801a82:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a88:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a8b:	7c 02                	jl     801a8f <strtol+0x148>
			break;
  801a8d:	eb 23                	jmp    801ab2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a8f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a94:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a97:	48 98                	cltq   
  801a99:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a9e:	48 89 c2             	mov    %rax,%rdx
  801aa1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aa4:	48 98                	cltq   
  801aa6:	48 01 d0             	add    %rdx,%rax
  801aa9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801aad:	e9 5d ff ff ff       	jmpq   801a0f <strtol+0xc8>

	if (endptr)
  801ab2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801ab7:	74 0b                	je     801ac4 <strtol+0x17d>
		*endptr = (char *) s;
  801ab9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801abd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ac1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ac4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ac8:	74 09                	je     801ad3 <strtol+0x18c>
  801aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ace:	48 f7 d8             	neg    %rax
  801ad1:	eb 04                	jmp    801ad7 <strtol+0x190>
  801ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ad7:	c9                   	leaveq 
  801ad8:	c3                   	retq   

0000000000801ad9 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	48 83 ec 30          	sub    $0x30,%rsp
  801ae1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ae5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801ae9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801af1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801af5:	0f b6 00             	movzbl (%rax),%eax
  801af8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801afb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801aff:	75 06                	jne    801b07 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b05:	eb 6b                	jmp    801b72 <strstr+0x99>

	len = strlen(str);
  801b07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b0b:	48 89 c7             	mov    %rax,%rdi
  801b0e:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  801b15:	00 00 00 
  801b18:	ff d0                	callq  *%rax
  801b1a:	48 98                	cltq   
  801b1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b24:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b2c:	0f b6 00             	movzbl (%rax),%eax
  801b2f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b32:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b36:	75 07                	jne    801b3f <strstr+0x66>
				return (char *) 0;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	eb 33                	jmp    801b72 <strstr+0x99>
		} while (sc != c);
  801b3f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b43:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b46:	75 d8                	jne    801b20 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b54:	48 89 ce             	mov    %rcx,%rsi
  801b57:	48 89 c7             	mov    %rax,%rdi
  801b5a:	48 b8 d0 15 80 00 00 	movabs $0x8015d0,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
  801b66:	85 c0                	test   %eax,%eax
  801b68:	75 b6                	jne    801b20 <strstr+0x47>

	return (char *) (in - 1);
  801b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6e:	48 83 e8 01          	sub    $0x1,%rax
}
  801b72:	c9                   	leaveq 
  801b73:	c3                   	retq   

0000000000801b74 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b74:	55                   	push   %rbp
  801b75:	48 89 e5             	mov    %rsp,%rbp
  801b78:	53                   	push   %rbx
  801b79:	48 83 ec 48          	sub    $0x48,%rsp
  801b7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b80:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b83:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b87:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b8b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b8f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b93:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b96:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b9a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b9e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ba2:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ba6:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801baa:	4c 89 c3             	mov    %r8,%rbx
  801bad:	cd 30                	int    $0x30
  801baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bb3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bb7:	74 3e                	je     801bf7 <syscall+0x83>
  801bb9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bbe:	7e 37                	jle    801bf7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bc4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bc7:	49 89 d0             	mov    %rdx,%r8
  801bca:	89 c1                	mov    %eax,%ecx
  801bcc:	48 ba 1b 48 80 00 00 	movabs $0x80481b,%rdx
  801bd3:	00 00 00 
  801bd6:	be 23 00 00 00       	mov    $0x23,%esi
  801bdb:	48 bf 38 48 80 00 00 	movabs $0x804838,%rdi
  801be2:	00 00 00 
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bea:	49 b9 ee 04 80 00 00 	movabs $0x8004ee,%r9
  801bf1:	00 00 00 
  801bf4:	41 ff d1             	callq  *%r9

	return ret;
  801bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bfb:	48 83 c4 48          	add    $0x48,%rsp
  801bff:	5b                   	pop    %rbx
  801c00:	5d                   	pop    %rbp
  801c01:	c3                   	retq   

0000000000801c02 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	48 83 ec 10          	sub    $0x10,%rsp
  801c0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c1a:	48 83 ec 08          	sub    $0x8,%rsp
  801c1e:	6a 00                	pushq  $0x0
  801c20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2c:	48 89 d1             	mov    %rdx,%rcx
  801c2f:	48 89 c2             	mov    %rax,%rdx
  801c32:	be 00 00 00 00       	mov    $0x0,%esi
  801c37:	bf 00 00 00 00       	mov    $0x0,%edi
  801c3c:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	callq  *%rax
  801c48:	48 83 c4 10          	add    $0x10,%rsp
}
  801c4c:	c9                   	leaveq 
  801c4d:	c3                   	retq   

0000000000801c4e <sys_cgetc>:

int
sys_cgetc(void)
{
  801c4e:	55                   	push   %rbp
  801c4f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c52:	48 83 ec 08          	sub    $0x8,%rsp
  801c56:	6a 00                	pushq  $0x0
  801c58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c64:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c69:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6e:	be 00 00 00 00       	mov    $0x0,%esi
  801c73:	bf 01 00 00 00       	mov    $0x1,%edi
  801c78:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
  801c84:	48 83 c4 10          	add    $0x10,%rsp
}
  801c88:	c9                   	leaveq 
  801c89:	c3                   	retq   

0000000000801c8a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c8a:	55                   	push   %rbp
  801c8b:	48 89 e5             	mov    %rsp,%rbp
  801c8e:	48 83 ec 10          	sub    $0x10,%rsp
  801c92:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c98:	48 98                	cltq   
  801c9a:	48 83 ec 08          	sub    $0x8,%rsp
  801c9e:	6a 00                	pushq  $0x0
  801ca0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 01 00 00 00       	mov    $0x1,%esi
  801cb9:	bf 03 00 00 00       	mov    $0x3,%edi
  801cbe:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
  801cca:	48 83 c4 10          	add    $0x10,%rsp
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cd4:	48 83 ec 08          	sub    $0x8,%rsp
  801cd8:	6a 00                	pushq  $0x0
  801cda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf0:	be 00 00 00 00       	mov    $0x0,%esi
  801cf5:	bf 02 00 00 00       	mov    $0x2,%edi
  801cfa:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
  801d06:	48 83 c4 10          	add    $0x10,%rsp
}
  801d0a:	c9                   	leaveq 
  801d0b:	c3                   	retq   

0000000000801d0c <sys_yield>:

void
sys_yield(void)
{
  801d0c:	55                   	push   %rbp
  801d0d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d10:	48 83 ec 08          	sub    $0x8,%rsp
  801d14:	6a 00                	pushq  $0x0
  801d16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d27:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2c:	be 00 00 00 00       	mov    $0x0,%esi
  801d31:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d36:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801d3d:	00 00 00 
  801d40:	ff d0                	callq  *%rax
  801d42:	48 83 c4 10          	add    $0x10,%rsp
}
  801d46:	c9                   	leaveq 
  801d47:	c3                   	retq   

0000000000801d48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d48:	55                   	push   %rbp
  801d49:	48 89 e5             	mov    %rsp,%rbp
  801d4c:	48 83 ec 10          	sub    $0x10,%rsp
  801d50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d57:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5d:	48 63 c8             	movslq %eax,%rcx
  801d60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d67:	48 98                	cltq   
  801d69:	48 83 ec 08          	sub    $0x8,%rsp
  801d6d:	6a 00                	pushq  $0x0
  801d6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d75:	49 89 c8             	mov    %rcx,%r8
  801d78:	48 89 d1             	mov    %rdx,%rcx
  801d7b:	48 89 c2             	mov    %rax,%rdx
  801d7e:	be 01 00 00 00       	mov    $0x1,%esi
  801d83:	bf 04 00 00 00       	mov    $0x4,%edi
  801d88:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
  801d94:	48 83 c4 10          	add    $0x10,%rsp
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 20          	sub    $0x20,%rsp
  801da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801db0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801db4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801db7:	48 63 c8             	movslq %eax,%rcx
  801dba:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc1:	48 63 f0             	movslq %eax,%rsi
  801dc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	48 98                	cltq   
  801dcd:	48 83 ec 08          	sub    $0x8,%rsp
  801dd1:	51                   	push   %rcx
  801dd2:	49 89 f9             	mov    %rdi,%r9
  801dd5:	49 89 f0             	mov    %rsi,%r8
  801dd8:	48 89 d1             	mov    %rdx,%rcx
  801ddb:	48 89 c2             	mov    %rax,%rdx
  801dde:	be 01 00 00 00       	mov    $0x1,%esi
  801de3:	bf 05 00 00 00       	mov    $0x5,%edi
  801de8:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	48 83 c4 10          	add    $0x10,%rsp
}
  801df8:	c9                   	leaveq 
  801df9:	c3                   	retq   

0000000000801dfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	48 83 ec 10          	sub    $0x10,%rsp
  801e02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e10:	48 98                	cltq   
  801e12:	48 83 ec 08          	sub    $0x8,%rsp
  801e16:	6a 00                	pushq  $0x0
  801e18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e24:	48 89 d1             	mov    %rdx,%rcx
  801e27:	48 89 c2             	mov    %rax,%rdx
  801e2a:	be 01 00 00 00       	mov    $0x1,%esi
  801e2f:	bf 06 00 00 00       	mov    $0x6,%edi
  801e34:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	48 83 c4 10          	add    $0x10,%rsp
}
  801e44:	c9                   	leaveq 
  801e45:	c3                   	retq   

0000000000801e46 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e46:	55                   	push   %rbp
  801e47:	48 89 e5             	mov    %rsp,%rbp
  801e4a:	48 83 ec 10          	sub    $0x10,%rsp
  801e4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e51:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e57:	48 63 d0             	movslq %eax,%rdx
  801e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5d:	48 98                	cltq   
  801e5f:	48 83 ec 08          	sub    $0x8,%rsp
  801e63:	6a 00                	pushq  $0x0
  801e65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e71:	48 89 d1             	mov    %rdx,%rcx
  801e74:	48 89 c2             	mov    %rax,%rdx
  801e77:	be 01 00 00 00       	mov    $0x1,%esi
  801e7c:	bf 08 00 00 00       	mov    $0x8,%edi
  801e81:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
  801e8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	48 83 ec 10          	sub    $0x10,%rsp
  801e9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ea2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea9:	48 98                	cltq   
  801eab:	48 83 ec 08          	sub    $0x8,%rsp
  801eaf:	6a 00                	pushq  $0x0
  801eb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebd:	48 89 d1             	mov    %rdx,%rcx
  801ec0:	48 89 c2             	mov    %rax,%rdx
  801ec3:	be 01 00 00 00       	mov    $0x1,%esi
  801ec8:	bf 09 00 00 00       	mov    $0x9,%edi
  801ecd:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
  801ed9:	48 83 c4 10          	add    $0x10,%rsp
}
  801edd:	c9                   	leaveq 
  801ede:	c3                   	retq   

0000000000801edf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801edf:	55                   	push   %rbp
  801ee0:	48 89 e5             	mov    %rsp,%rbp
  801ee3:	48 83 ec 10          	sub    $0x10,%rsp
  801ee7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
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
  801f14:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f19:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
  801f25:	48 83 c4 10          	add    $0x10,%rsp
}
  801f29:	c9                   	leaveq 
  801f2a:	c3                   	retq   

0000000000801f2b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	48 83 ec 20          	sub    $0x20,%rsp
  801f33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f3a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f3e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f44:	48 63 f0             	movslq %eax,%rsi
  801f47:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4e:	48 98                	cltq   
  801f50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f54:	48 83 ec 08          	sub    $0x8,%rsp
  801f58:	6a 00                	pushq  $0x0
  801f5a:	49 89 f1             	mov    %rsi,%r9
  801f5d:	49 89 c8             	mov    %rcx,%r8
  801f60:	48 89 d1             	mov    %rdx,%rcx
  801f63:	48 89 c2             	mov    %rax,%rdx
  801f66:	be 00 00 00 00       	mov    $0x0,%esi
  801f6b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f70:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801f77:	00 00 00 
  801f7a:	ff d0                	callq  *%rax
  801f7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801f80:	c9                   	leaveq 
  801f81:	c3                   	retq   

0000000000801f82 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f82:	55                   	push   %rbp
  801f83:	48 89 e5             	mov    %rsp,%rbp
  801f86:	48 83 ec 10          	sub    $0x10,%rsp
  801f8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f92:	48 83 ec 08          	sub    $0x8,%rsp
  801f96:	6a 00                	pushq  $0x0
  801f98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa9:	48 89 c2             	mov    %rax,%rdx
  801fac:	be 01 00 00 00       	mov    $0x1,%esi
  801fb1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fb6:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801fbd:	00 00 00 
  801fc0:	ff d0                	callq  *%rax
  801fc2:	48 83 c4 10          	add    $0x10,%rsp
}
  801fc6:	c9                   	leaveq 
  801fc7:	c3                   	retq   

0000000000801fc8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801fc8:	55                   	push   %rbp
  801fc9:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fcc:	48 83 ec 08          	sub    $0x8,%rsp
  801fd0:	6a 00                	pushq  $0x0
  801fd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fde:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe8:	be 00 00 00 00       	mov    $0x0,%esi
  801fed:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ff2:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	48 83 c4 10          	add    $0x10,%rsp
}
  802002:	c9                   	leaveq 
  802003:	c3                   	retq   

0000000000802004 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802004:	55                   	push   %rbp
  802005:	48 89 e5             	mov    %rsp,%rbp
  802008:	48 83 ec 20          	sub    $0x20,%rsp
  80200c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80200f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802013:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802016:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80201a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80201e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802021:	48 63 c8             	movslq %eax,%rcx
  802024:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802028:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80202b:	48 63 f0             	movslq %eax,%rsi
  80202e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802035:	48 98                	cltq   
  802037:	48 83 ec 08          	sub    $0x8,%rsp
  80203b:	51                   	push   %rcx
  80203c:	49 89 f9             	mov    %rdi,%r9
  80203f:	49 89 f0             	mov    %rsi,%r8
  802042:	48 89 d1             	mov    %rdx,%rcx
  802045:	48 89 c2             	mov    %rax,%rdx
  802048:	be 00 00 00 00       	mov    $0x0,%esi
  80204d:	bf 0f 00 00 00       	mov    $0xf,%edi
  802052:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  802059:	00 00 00 
  80205c:	ff d0                	callq  *%rax
  80205e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802062:	c9                   	leaveq 
  802063:	c3                   	retq   

0000000000802064 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802064:	55                   	push   %rbp
  802065:	48 89 e5             	mov    %rsp,%rbp
  802068:	48 83 ec 10          	sub    $0x10,%rsp
  80206c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802070:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802074:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80207c:	48 83 ec 08          	sub    $0x8,%rsp
  802080:	6a 00                	pushq  $0x0
  802082:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802088:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80208e:	48 89 d1             	mov    %rdx,%rcx
  802091:	48 89 c2             	mov    %rax,%rdx
  802094:	be 00 00 00 00       	mov    $0x0,%esi
  802099:	bf 10 00 00 00       	mov    $0x10,%edi
  80209e:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
  8020aa:	48 83 c4 10          	add    $0x10,%rsp
}
  8020ae:	c9                   	leaveq 
  8020af:	c3                   	retq   

00000000008020b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020b0:	55                   	push   %rbp
  8020b1:	48 89 e5             	mov    %rsp,%rbp
  8020b4:	48 83 ec 08          	sub    $0x8,%rsp
  8020b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020c0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020c7:	ff ff ff 
  8020ca:	48 01 d0             	add    %rdx,%rax
  8020cd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020d1:	c9                   	leaveq 
  8020d2:	c3                   	retq   

00000000008020d3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020d3:	55                   	push   %rbp
  8020d4:	48 89 e5             	mov    %rsp,%rbp
  8020d7:	48 83 ec 08          	sub    $0x8,%rsp
  8020db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e3:	48 89 c7             	mov    %rax,%rdi
  8020e6:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	callq  *%rax
  8020f2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8020f8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8020fc:	c9                   	leaveq 
  8020fd:	c3                   	retq   

00000000008020fe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	48 83 ec 18          	sub    $0x18,%rsp
  802106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80210a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802111:	eb 6b                	jmp    80217e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802116:	48 98                	cltq   
  802118:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80211e:	48 c1 e0 0c          	shl    $0xc,%rax
  802122:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212a:	48 c1 e8 15          	shr    $0x15,%rax
  80212e:	48 89 c2             	mov    %rax,%rdx
  802131:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802138:	01 00 00 
  80213b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213f:	83 e0 01             	and    $0x1,%eax
  802142:	48 85 c0             	test   %rax,%rax
  802145:	74 21                	je     802168 <fd_alloc+0x6a>
  802147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214b:	48 c1 e8 0c          	shr    $0xc,%rax
  80214f:	48 89 c2             	mov    %rax,%rdx
  802152:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802159:	01 00 00 
  80215c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802160:	83 e0 01             	and    $0x1,%eax
  802163:	48 85 c0             	test   %rax,%rax
  802166:	75 12                	jne    80217a <fd_alloc+0x7c>
			*fd_store = fd;
  802168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802170:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	eb 1a                	jmp    802194 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  80217a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80217e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802182:	7e 8f                	jle    802113 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802188:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80218f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802194:	c9                   	leaveq 
  802195:	c3                   	retq   

0000000000802196 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802196:	55                   	push   %rbp
  802197:	48 89 e5             	mov    %rsp,%rbp
  80219a:	48 83 ec 20          	sub    $0x20,%rsp
  80219e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021a9:	78 06                	js     8021b1 <fd_lookup+0x1b>
  8021ab:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021af:	7e 07                	jle    8021b8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b6:	eb 6c                	jmp    802224 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021bb:	48 98                	cltq   
  8021bd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021c3:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021cf:	48 c1 e8 15          	shr    $0x15,%rax
  8021d3:	48 89 c2             	mov    %rax,%rdx
  8021d6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021dd:	01 00 00 
  8021e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e4:	83 e0 01             	and    $0x1,%eax
  8021e7:	48 85 c0             	test   %rax,%rax
  8021ea:	74 21                	je     80220d <fd_lookup+0x77>
  8021ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f4:	48 89 c2             	mov    %rax,%rdx
  8021f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fe:	01 00 00 
  802201:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802205:	83 e0 01             	and    $0x1,%eax
  802208:	48 85 c0             	test   %rax,%rax
  80220b:	75 07                	jne    802214 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80220d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802212:	eb 10                	jmp    802224 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802214:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802218:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80221c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802224:	c9                   	leaveq 
  802225:	c3                   	retq   

0000000000802226 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802226:	55                   	push   %rbp
  802227:	48 89 e5             	mov    %rsp,%rbp
  80222a:	48 83 ec 30          	sub    $0x30,%rsp
  80222e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802232:	89 f0                	mov    %esi,%eax
  802234:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802237:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80223b:	48 89 c7             	mov    %rax,%rdi
  80223e:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax
  80224a:	89 c2                	mov    %eax,%edx
  80224c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802250:	48 89 c6             	mov    %rax,%rsi
  802253:	89 d7                	mov    %edx,%edi
  802255:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802264:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802268:	78 0a                	js     802274 <fd_close+0x4e>
	    || fd != fd2)
  80226a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802272:	74 12                	je     802286 <fd_close+0x60>
		return (must_exist ? r : 0);
  802274:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802278:	74 05                	je     80227f <fd_close+0x59>
  80227a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227d:	eb 70                	jmp    8022ef <fd_close+0xc9>
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
  802284:	eb 69                	jmp    8022ef <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802286:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228a:	8b 00                	mov    (%rax),%eax
  80228c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802290:	48 89 d6             	mov    %rdx,%rsi
  802293:	89 c7                	mov    %eax,%edi
  802295:	48 b8 f1 22 80 00 00 	movabs $0x8022f1,%rax
  80229c:	00 00 00 
  80229f:	ff d0                	callq  *%rax
  8022a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a8:	78 2a                	js     8022d4 <fd_close+0xae>
		if (dev->dev_close)
  8022aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ae:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022b2:	48 85 c0             	test   %rax,%rax
  8022b5:	74 16                	je     8022cd <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8022b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022bf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022c3:	48 89 d7             	mov    %rdx,%rdi
  8022c6:	ff d0                	callq  *%rax
  8022c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022cb:	eb 07                	jmp    8022d4 <fd_close+0xae>
		else
			r = 0;
  8022cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d8:	48 89 c6             	mov    %rax,%rsi
  8022db:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e0:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax
	return r;
  8022ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022ef:	c9                   	leaveq 
  8022f0:	c3                   	retq   

00000000008022f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8022f1:	55                   	push   %rbp
  8022f2:	48 89 e5             	mov    %rsp,%rbp
  8022f5:	48 83 ec 20          	sub    $0x20,%rsp
  8022f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802307:	eb 41                	jmp    80234a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802309:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802310:	00 00 00 
  802313:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802316:	48 63 d2             	movslq %edx,%rdx
  802319:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231d:	8b 00                	mov    (%rax),%eax
  80231f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802322:	75 22                	jne    802346 <dev_lookup+0x55>
			*dev = devtab[i];
  802324:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80232b:	00 00 00 
  80232e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802331:	48 63 d2             	movslq %edx,%rdx
  802334:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802338:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80233c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	eb 60                	jmp    8023a6 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802346:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80234a:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802351:	00 00 00 
  802354:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802357:	48 63 d2             	movslq %edx,%rdx
  80235a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235e:	48 85 c0             	test   %rax,%rax
  802361:	75 a6                	jne    802309 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802363:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80236a:	00 00 00 
  80236d:	48 8b 00             	mov    (%rax),%rax
  802370:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802376:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802379:	89 c6                	mov    %eax,%esi
  80237b:	48 bf 48 48 80 00 00 	movabs $0x804848,%rdi
  802382:	00 00 00 
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
  80238a:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  802391:	00 00 00 
  802394:	ff d1                	callq  *%rcx
	*dev = 0;
  802396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80239a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023a6:	c9                   	leaveq 
  8023a7:	c3                   	retq   

00000000008023a8 <close>:

int
close(int fdnum)
{
  8023a8:	55                   	push   %rbp
  8023a9:	48 89 e5             	mov    %rsp,%rbp
  8023ac:	48 83 ec 20          	sub    $0x20,%rsp
  8023b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ba:	48 89 d6             	mov    %rdx,%rsi
  8023bd:	89 c7                	mov    %eax,%edi
  8023bf:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
  8023cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d2:	79 05                	jns    8023d9 <close+0x31>
		return r;
  8023d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d7:	eb 18                	jmp    8023f1 <close+0x49>
	else
		return fd_close(fd, 1);
  8023d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023dd:	be 01 00 00 00       	mov    $0x1,%esi
  8023e2:	48 89 c7             	mov    %rax,%rdi
  8023e5:	48 b8 26 22 80 00 00 	movabs $0x802226,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
}
  8023f1:	c9                   	leaveq 
  8023f2:	c3                   	retq   

00000000008023f3 <close_all>:

void
close_all(void)
{
  8023f3:	55                   	push   %rbp
  8023f4:	48 89 e5             	mov    %rsp,%rbp
  8023f7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8023fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802402:	eb 15                	jmp    802419 <close_all+0x26>
		close(i);
  802404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802407:	89 c7                	mov    %eax,%edi
  802409:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802415:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802419:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80241d:	7e e5                	jle    802404 <close_all+0x11>
}
  80241f:	c9                   	leaveq 
  802420:	c3                   	retq   

0000000000802421 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802421:	55                   	push   %rbp
  802422:	48 89 e5             	mov    %rsp,%rbp
  802425:	48 83 ec 40          	sub    $0x40,%rsp
  802429:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80242c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80242f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802433:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802436:	48 89 d6             	mov    %rdx,%rsi
  802439:	89 c7                	mov    %eax,%edi
  80243b:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
  802447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244e:	79 08                	jns    802458 <dup+0x37>
		return r;
  802450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802453:	e9 70 01 00 00       	jmpq   8025c8 <dup+0x1a7>
	close(newfdnum);
  802458:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80245b:	89 c7                	mov    %eax,%edi
  80245d:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802469:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80246c:	48 98                	cltq   
  80246e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802474:	48 c1 e0 0c          	shl    $0xc,%rax
  802478:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80247c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802480:	48 89 c7             	mov    %rax,%rdi
  802483:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802497:	48 89 c7             	mov    %rax,%rdi
  80249a:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax
  8024a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ae:	48 c1 e8 15          	shr    $0x15,%rax
  8024b2:	48 89 c2             	mov    %rax,%rdx
  8024b5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024bc:	01 00 00 
  8024bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c3:	83 e0 01             	and    $0x1,%eax
  8024c6:	48 85 c0             	test   %rax,%rax
  8024c9:	74 73                	je     80253e <dup+0x11d>
  8024cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cf:	48 c1 e8 0c          	shr    $0xc,%rax
  8024d3:	48 89 c2             	mov    %rax,%rdx
  8024d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024dd:	01 00 00 
  8024e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e4:	83 e0 01             	and    $0x1,%eax
  8024e7:	48 85 c0             	test   %rax,%rax
  8024ea:	74 52                	je     80253e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8024ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8024f4:	48 89 c2             	mov    %rax,%rdx
  8024f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024fe:	01 00 00 
  802501:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802505:	25 07 0e 00 00       	and    $0xe07,%eax
  80250a:	89 c1                	mov    %eax,%ecx
  80250c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802514:	41 89 c8             	mov    %ecx,%r8d
  802517:	48 89 d1             	mov    %rdx,%rcx
  80251a:	ba 00 00 00 00       	mov    $0x0,%edx
  80251f:	48 89 c6             	mov    %rax,%rsi
  802522:	bf 00 00 00 00       	mov    $0x0,%edi
  802527:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax
  802533:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802536:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253a:	79 02                	jns    80253e <dup+0x11d>
			goto err;
  80253c:	eb 57                	jmp    802595 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80253e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802542:	48 c1 e8 0c          	shr    $0xc,%rax
  802546:	48 89 c2             	mov    %rax,%rdx
  802549:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802550:	01 00 00 
  802553:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802557:	25 07 0e 00 00       	and    $0xe07,%eax
  80255c:	89 c1                	mov    %eax,%ecx
  80255e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802562:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802566:	41 89 c8             	mov    %ecx,%r8d
  802569:	48 89 d1             	mov    %rdx,%rcx
  80256c:	ba 00 00 00 00       	mov    $0x0,%edx
  802571:	48 89 c6             	mov    %rax,%rsi
  802574:	bf 00 00 00 00       	mov    $0x0,%edi
  802579:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802580:	00 00 00 
  802583:	ff d0                	callq  *%rax
  802585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258c:	79 02                	jns    802590 <dup+0x16f>
		goto err;
  80258e:	eb 05                	jmp    802595 <dup+0x174>

	return newfdnum;
  802590:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802593:	eb 33                	jmp    8025c8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802599:	48 89 c6             	mov    %rax,%rsi
  80259c:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a1:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b1:	48 89 c6             	mov    %rax,%rsi
  8025b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b9:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
	return r;
  8025c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025c8:	c9                   	leaveq 
  8025c9:	c3                   	retq   

00000000008025ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025ca:	55                   	push   %rbp
  8025cb:	48 89 e5             	mov    %rsp,%rbp
  8025ce:	48 83 ec 40          	sub    $0x40,%rsp
  8025d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025e4:	48 89 d6             	mov    %rdx,%rsi
  8025e7:	89 c7                	mov    %eax,%edi
  8025e9:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  8025f0:	00 00 00 
  8025f3:	ff d0                	callq  *%rax
  8025f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fc:	78 24                	js     802622 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802602:	8b 00                	mov    (%rax),%eax
  802604:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802608:	48 89 d6             	mov    %rdx,%rsi
  80260b:	89 c7                	mov    %eax,%edi
  80260d:	48 b8 f1 22 80 00 00 	movabs $0x8022f1,%rax
  802614:	00 00 00 
  802617:	ff d0                	callq  *%rax
  802619:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802620:	79 05                	jns    802627 <read+0x5d>
		return r;
  802622:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802625:	eb 76                	jmp    80269d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262b:	8b 40 08             	mov    0x8(%rax),%eax
  80262e:	83 e0 03             	and    $0x3,%eax
  802631:	83 f8 01             	cmp    $0x1,%eax
  802634:	75 3a                	jne    802670 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802636:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80263d:	00 00 00 
  802640:	48 8b 00             	mov    (%rax),%rax
  802643:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802649:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80264c:	89 c6                	mov    %eax,%esi
  80264e:	48 bf 67 48 80 00 00 	movabs $0x804867,%rdi
  802655:	00 00 00 
  802658:	b8 00 00 00 00       	mov    $0x0,%eax
  80265d:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  802664:	00 00 00 
  802667:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802669:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80266e:	eb 2d                	jmp    80269d <read+0xd3>
	}
	if (!dev->dev_read)
  802670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802674:	48 8b 40 10          	mov    0x10(%rax),%rax
  802678:	48 85 c0             	test   %rax,%rax
  80267b:	75 07                	jne    802684 <read+0xba>
		return -E_NOT_SUPP;
  80267d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802682:	eb 19                	jmp    80269d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802688:	48 8b 40 10          	mov    0x10(%rax),%rax
  80268c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802690:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802694:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802698:	48 89 cf             	mov    %rcx,%rdi
  80269b:	ff d0                	callq  *%rax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 30          	sub    $0x30,%rsp
  8026a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026b9:	eb 49                	jmp    802704 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026be:	48 98                	cltq   
  8026c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026c4:	48 29 c2             	sub    %rax,%rdx
  8026c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ca:	48 63 c8             	movslq %eax,%rcx
  8026cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d1:	48 01 c1             	add    %rax,%rcx
  8026d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026d7:	48 89 ce             	mov    %rcx,%rsi
  8026da:	89 c7                	mov    %eax,%edi
  8026dc:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8026eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026ef:	79 05                	jns    8026f6 <readn+0x57>
			return m;
  8026f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026f4:	eb 1c                	jmp    802712 <readn+0x73>
		if (m == 0)
  8026f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026fa:	75 02                	jne    8026fe <readn+0x5f>
			break;
  8026fc:	eb 11                	jmp    80270f <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8026fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802701:	01 45 fc             	add    %eax,-0x4(%rbp)
  802704:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802707:	48 98                	cltq   
  802709:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80270d:	72 ac                	jb     8026bb <readn+0x1c>
	}
	return tot;
  80270f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802712:	c9                   	leaveq 
  802713:	c3                   	retq   

0000000000802714 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
  802718:	48 83 ec 40          	sub    $0x40,%rsp
  80271c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80271f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802723:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802727:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80272b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80272e:	48 89 d6             	mov    %rdx,%rsi
  802731:	89 c7                	mov    %eax,%edi
  802733:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	callq  *%rax
  80273f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802746:	78 24                	js     80276c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274c:	8b 00                	mov    (%rax),%eax
  80274e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802752:	48 89 d6             	mov    %rdx,%rsi
  802755:	89 c7                	mov    %eax,%edi
  802757:	48 b8 f1 22 80 00 00 	movabs $0x8022f1,%rax
  80275e:	00 00 00 
  802761:	ff d0                	callq  *%rax
  802763:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802766:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276a:	79 05                	jns    802771 <write+0x5d>
		return r;
  80276c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276f:	eb 75                	jmp    8027e6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802775:	8b 40 08             	mov    0x8(%rax),%eax
  802778:	83 e0 03             	and    $0x3,%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	75 3a                	jne    8027b9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80277f:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802786:	00 00 00 
  802789:	48 8b 00             	mov    (%rax),%rax
  80278c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802792:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802795:	89 c6                	mov    %eax,%esi
  802797:	48 bf 83 48 80 00 00 	movabs $0x804883,%rdi
  80279e:	00 00 00 
  8027a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a6:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  8027ad:	00 00 00 
  8027b0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027b7:	eb 2d                	jmp    8027e6 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027bd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027c1:	48 85 c0             	test   %rax,%rax
  8027c4:	75 07                	jne    8027cd <write+0xb9>
		return -E_NOT_SUPP;
  8027c6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027cb:	eb 19                	jmp    8027e6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027d5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027dd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027e1:	48 89 cf             	mov    %rcx,%rdi
  8027e4:	ff d0                	callq  *%rax
}
  8027e6:	c9                   	leaveq 
  8027e7:	c3                   	retq   

00000000008027e8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8027e8:	55                   	push   %rbp
  8027e9:	48 89 e5             	mov    %rsp,%rbp
  8027ec:	48 83 ec 18          	sub    $0x18,%rsp
  8027f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027f3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027fd:	48 89 d6             	mov    %rdx,%rsi
  802800:	89 c7                	mov    %eax,%edi
  802802:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802811:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802815:	79 05                	jns    80281c <seek+0x34>
		return r;
  802817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281a:	eb 0f                	jmp    80282b <seek+0x43>
	fd->fd_offset = offset;
  80281c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802820:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802823:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282b:	c9                   	leaveq 
  80282c:	c3                   	retq   

000000000080282d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80282d:	55                   	push   %rbp
  80282e:	48 89 e5             	mov    %rsp,%rbp
  802831:	48 83 ec 30          	sub    $0x30,%rsp
  802835:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802838:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80283b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80283f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802842:	48 89 d6             	mov    %rdx,%rsi
  802845:	89 c7                	mov    %eax,%edi
  802847:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  80284e:	00 00 00 
  802851:	ff d0                	callq  *%rax
  802853:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802856:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285a:	78 24                	js     802880 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80285c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802860:	8b 00                	mov    (%rax),%eax
  802862:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802866:	48 89 d6             	mov    %rdx,%rsi
  802869:	89 c7                	mov    %eax,%edi
  80286b:	48 b8 f1 22 80 00 00 	movabs $0x8022f1,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
  802877:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287e:	79 05                	jns    802885 <ftruncate+0x58>
		return r;
  802880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802883:	eb 72                	jmp    8028f7 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802889:	8b 40 08             	mov    0x8(%rax),%eax
  80288c:	83 e0 03             	and    $0x3,%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	75 3a                	jne    8028cd <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802893:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80289a:	00 00 00 
  80289d:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028a0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028a9:	89 c6                	mov    %eax,%esi
  8028ab:	48 bf a0 48 80 00 00 	movabs $0x8048a0,%rdi
  8028b2:	00 00 00 
  8028b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ba:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  8028c1:	00 00 00 
  8028c4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028cb:	eb 2a                	jmp    8028f7 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028d5:	48 85 c0             	test   %rax,%rax
  8028d8:	75 07                	jne    8028e1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028df:	eb 16                	jmp    8028f7 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ed:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8028f0:	89 ce                	mov    %ecx,%esi
  8028f2:	48 89 d7             	mov    %rdx,%rdi
  8028f5:	ff d0                	callq  *%rax
}
  8028f7:	c9                   	leaveq 
  8028f8:	c3                   	retq   

00000000008028f9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8028f9:	55                   	push   %rbp
  8028fa:	48 89 e5             	mov    %rsp,%rbp
  8028fd:	48 83 ec 30          	sub    $0x30,%rsp
  802901:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802904:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802908:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80290c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80290f:	48 89 d6             	mov    %rdx,%rsi
  802912:	89 c7                	mov    %eax,%edi
  802914:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
  802920:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802923:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802927:	78 24                	js     80294d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292d:	8b 00                	mov    (%rax),%eax
  80292f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802933:	48 89 d6             	mov    %rdx,%rsi
  802936:	89 c7                	mov    %eax,%edi
  802938:	48 b8 f1 22 80 00 00 	movabs $0x8022f1,%rax
  80293f:	00 00 00 
  802942:	ff d0                	callq  *%rax
  802944:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802947:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294b:	79 05                	jns    802952 <fstat+0x59>
		return r;
  80294d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802950:	eb 5e                	jmp    8029b0 <fstat+0xb7>
	if (!dev->dev_stat)
  802952:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802956:	48 8b 40 28          	mov    0x28(%rax),%rax
  80295a:	48 85 c0             	test   %rax,%rax
  80295d:	75 07                	jne    802966 <fstat+0x6d>
		return -E_NOT_SUPP;
  80295f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802964:	eb 4a                	jmp    8029b0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802966:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80296a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80296d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802971:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802978:	00 00 00 
	stat->st_isdir = 0;
  80297b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80297f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802986:	00 00 00 
	stat->st_dev = dev;
  802989:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80298d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802991:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029a4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029a8:	48 89 ce             	mov    %rcx,%rsi
  8029ab:	48 89 d7             	mov    %rdx,%rdi
  8029ae:	ff d0                	callq  *%rax
}
  8029b0:	c9                   	leaveq 
  8029b1:	c3                   	retq   

00000000008029b2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029b2:	55                   	push   %rbp
  8029b3:	48 89 e5             	mov    %rsp,%rbp
  8029b6:	48 83 ec 20          	sub    $0x20,%rsp
  8029ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c6:	be 00 00 00 00       	mov    $0x0,%esi
  8029cb:	48 89 c7             	mov    %rax,%rdi
  8029ce:	48 b8 a2 2a 80 00 00 	movabs $0x802aa2,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
  8029da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e1:	79 05                	jns    8029e8 <stat+0x36>
		return fd;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e6:	eb 2f                	jmp    802a17 <stat+0x65>
	r = fstat(fd, stat);
  8029e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ef:	48 89 d6             	mov    %rdx,%rsi
  8029f2:	89 c7                	mov    %eax,%edi
  8029f4:	48 b8 f9 28 80 00 00 	movabs $0x8028f9,%rax
  8029fb:	00 00 00 
  8029fe:	ff d0                	callq  *%rax
  802a00:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a06:	89 c7                	mov    %eax,%edi
  802a08:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
	return r;
  802a14:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a17:	c9                   	leaveq 
  802a18:	c3                   	retq   

0000000000802a19 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a19:	55                   	push   %rbp
  802a1a:	48 89 e5             	mov    %rsp,%rbp
  802a1d:	48 83 ec 10          	sub    $0x10,%rsp
  802a21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a28:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a2f:	00 00 00 
  802a32:	8b 00                	mov    (%rax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	75 1f                	jne    802a57 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a38:	bf 01 00 00 00       	mov    $0x1,%edi
  802a3d:	48 b8 74 41 80 00 00 	movabs $0x804174,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
  802a49:	89 c2                	mov    %eax,%edx
  802a4b:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a52:	00 00 00 
  802a55:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a57:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a5e:	00 00 00 
  802a61:	8b 00                	mov    (%rax),%eax
  802a63:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a66:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a6b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a72:	00 00 00 
  802a75:	89 c7                	mov    %eax,%edi
  802a77:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a87:	ba 00 00 00 00       	mov    $0x0,%edx
  802a8c:	48 89 c6             	mov    %rax,%rsi
  802a8f:	bf 00 00 00 00       	mov    $0x0,%edi
  802a94:	48 b8 a9 3f 80 00 00 	movabs $0x803fa9,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
}
  802aa0:	c9                   	leaveq 
  802aa1:	c3                   	retq   

0000000000802aa2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802aa2:	55                   	push   %rbp
  802aa3:	48 89 e5             	mov    %rsp,%rbp
  802aa6:	48 83 ec 10          	sub    $0x10,%rsp
  802aaa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aae:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802ab1:	48 ba c6 48 80 00 00 	movabs $0x8048c6,%rdx
  802ab8:	00 00 00 
  802abb:	be 4c 00 00 00       	mov    $0x4c,%esi
  802ac0:	48 bf db 48 80 00 00 	movabs $0x8048db,%rdi
  802ac7:	00 00 00 
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
  802acf:	48 b9 ee 04 80 00 00 	movabs $0x8004ee,%rcx
  802ad6:	00 00 00 
  802ad9:	ff d1                	callq  *%rcx

0000000000802adb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802adb:	55                   	push   %rbp
  802adc:	48 89 e5             	mov    %rsp,%rbp
  802adf:	48 83 ec 10          	sub    $0x10,%rsp
  802ae3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aeb:	8b 50 0c             	mov    0xc(%rax),%edx
  802aee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af5:	00 00 00 
  802af8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802afa:	be 00 00 00 00       	mov    $0x0,%esi
  802aff:	bf 06 00 00 00       	mov    $0x6,%edi
  802b04:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802b0b:	00 00 00 
  802b0e:	ff d0                	callq  *%rax
}
  802b10:	c9                   	leaveq 
  802b11:	c3                   	retq   

0000000000802b12 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b12:	55                   	push   %rbp
  802b13:	48 89 e5             	mov    %rsp,%rbp
  802b16:	48 83 ec 20          	sub    $0x20,%rsp
  802b1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b22:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802b26:	48 ba e6 48 80 00 00 	movabs $0x8048e6,%rdx
  802b2d:	00 00 00 
  802b30:	be 6b 00 00 00       	mov    $0x6b,%esi
  802b35:	48 bf db 48 80 00 00 	movabs $0x8048db,%rdi
  802b3c:	00 00 00 
  802b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b44:	48 b9 ee 04 80 00 00 	movabs $0x8004ee,%rcx
  802b4b:	00 00 00 
  802b4e:	ff d1                	callq  *%rcx

0000000000802b50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
  802b54:	48 83 ec 20          	sub    $0x20,%rsp
  802b58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b60:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802b64:	48 ba 03 49 80 00 00 	movabs $0x804903,%rdx
  802b6b:	00 00 00 
  802b6e:	be 7b 00 00 00       	mov    $0x7b,%esi
  802b73:	48 bf db 48 80 00 00 	movabs $0x8048db,%rdi
  802b7a:	00 00 00 
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b82:	48 b9 ee 04 80 00 00 	movabs $0x8004ee,%rcx
  802b89:	00 00 00 
  802b8c:	ff d1                	callq  *%rcx

0000000000802b8e <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b8e:	55                   	push   %rbp
  802b8f:	48 89 e5             	mov    %rsp,%rbp
  802b92:	48 83 ec 20          	sub    $0x20,%rsp
  802b96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ba5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bac:	00 00 00 
  802baf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bb1:	be 00 00 00 00       	mov    $0x0,%esi
  802bb6:	bf 05 00 00 00       	mov    $0x5,%edi
  802bbb:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bce:	79 05                	jns    802bd5 <devfile_stat+0x47>
		return r;
  802bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd3:	eb 56                	jmp    802c2b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802be0:	00 00 00 
  802be3:	48 89 c7             	mov    %rax,%rdi
  802be6:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bf2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf9:	00 00 00 
  802bfc:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c06:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c0c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c13:	00 00 00 
  802c16:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c20:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c2b:	c9                   	leaveq 
  802c2c:	c3                   	retq   

0000000000802c2d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c2d:	55                   	push   %rbp
  802c2e:	48 89 e5             	mov    %rsp,%rbp
  802c31:	48 83 ec 10          	sub    $0x10,%rsp
  802c35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c39:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c40:	8b 50 0c             	mov    0xc(%rax),%edx
  802c43:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c4a:	00 00 00 
  802c4d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c4f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c56:	00 00 00 
  802c59:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c5c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c5f:	be 00 00 00 00       	mov    $0x0,%esi
  802c64:	bf 02 00 00 00       	mov    $0x2,%edi
  802c69:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	callq  *%rax
}
  802c75:	c9                   	leaveq 
  802c76:	c3                   	retq   

0000000000802c77 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c77:	55                   	push   %rbp
  802c78:	48 89 e5             	mov    %rsp,%rbp
  802c7b:	48 83 ec 10          	sub    $0x10,%rsp
  802c7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c87:	48 89 c7             	mov    %rax,%rdi
  802c8a:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  802c91:	00 00 00 
  802c94:	ff d0                	callq  *%rax
  802c96:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c9b:	7e 07                	jle    802ca4 <remove+0x2d>
		return -E_BAD_PATH;
  802c9d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ca2:	eb 33                	jmp    802cd7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca8:	48 89 c6             	mov    %rax,%rsi
  802cab:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cb2:	00 00 00 
  802cb5:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  802cbc:	00 00 00 
  802cbf:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cc1:	be 00 00 00 00       	mov    $0x0,%esi
  802cc6:	bf 07 00 00 00       	mov    $0x7,%edi
  802ccb:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
}
  802cd7:	c9                   	leaveq 
  802cd8:	c3                   	retq   

0000000000802cd9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802cd9:	55                   	push   %rbp
  802cda:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802cdd:	be 00 00 00 00       	mov    $0x0,%esi
  802ce2:	bf 08 00 00 00       	mov    $0x8,%edi
  802ce7:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
}
  802cf3:	5d                   	pop    %rbp
  802cf4:	c3                   	retq   

0000000000802cf5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802cf5:	55                   	push   %rbp
  802cf6:	48 89 e5             	mov    %rsp,%rbp
  802cf9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d00:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d07:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d0e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d15:	be 00 00 00 00       	mov    $0x0,%esi
  802d1a:	48 89 c7             	mov    %rax,%rdi
  802d1d:	48 b8 a2 2a 80 00 00 	movabs $0x802aa2,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
  802d29:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d30:	79 28                	jns    802d5a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d35:	89 c6                	mov    %eax,%esi
  802d37:	48 bf 21 49 80 00 00 	movabs $0x804921,%rdi
  802d3e:	00 00 00 
  802d41:	b8 00 00 00 00       	mov    $0x0,%eax
  802d46:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  802d4d:	00 00 00 
  802d50:	ff d2                	callq  *%rdx
		return fd_src;
  802d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d55:	e9 74 01 00 00       	jmpq   802ece <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d5a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d61:	be 01 01 00 00       	mov    $0x101,%esi
  802d66:	48 89 c7             	mov    %rax,%rdi
  802d69:	48 b8 a2 2a 80 00 00 	movabs $0x802aa2,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d78:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d7c:	79 39                	jns    802db7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d81:	89 c6                	mov    %eax,%esi
  802d83:	48 bf 37 49 80 00 00 	movabs $0x804937,%rdi
  802d8a:	00 00 00 
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d92:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  802d99:	00 00 00 
  802d9c:	ff d2                	callq  *%rdx
		close(fd_src);
  802d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da1:	89 c7                	mov    %eax,%edi
  802da3:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
		return fd_dest;
  802daf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db2:	e9 17 01 00 00       	jmpq   802ece <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802db7:	eb 74                	jmp    802e2d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802db9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dbc:	48 63 d0             	movslq %eax,%rdx
  802dbf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc9:	48 89 ce             	mov    %rcx,%rsi
  802dcc:	89 c7                	mov    %eax,%edi
  802dce:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802dd5:	00 00 00 
  802dd8:	ff d0                	callq  *%rax
  802dda:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ddd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802de1:	79 4a                	jns    802e2d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802de3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802de6:	89 c6                	mov    %eax,%esi
  802de8:	48 bf 51 49 80 00 00 	movabs $0x804951,%rdi
  802def:	00 00 00 
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
  802df7:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  802dfe:	00 00 00 
  802e01:	ff d2                	callq  *%rdx
			close(fd_src);
  802e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e06:	89 c7                	mov    %eax,%edi
  802e08:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
			close(fd_dest);
  802e14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e17:	89 c7                	mov    %eax,%edi
  802e19:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
			return write_size;
  802e25:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e28:	e9 a1 00 00 00       	jmpq   802ece <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e2d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e37:	ba 00 02 00 00       	mov    $0x200,%edx
  802e3c:	48 89 ce             	mov    %rcx,%rsi
  802e3f:	89 c7                	mov    %eax,%edi
  802e41:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802e48:	00 00 00 
  802e4b:	ff d0                	callq  *%rax
  802e4d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e50:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e54:	0f 8f 5f ff ff ff    	jg     802db9 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e5e:	79 47                	jns    802ea7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e60:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e63:	89 c6                	mov    %eax,%esi
  802e65:	48 bf 64 49 80 00 00 	movabs $0x804964,%rdi
  802e6c:	00 00 00 
  802e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e74:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  802e7b:	00 00 00 
  802e7e:	ff d2                	callq  *%rdx
		close(fd_src);
  802e80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e83:	89 c7                	mov    %eax,%edi
  802e85:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
		close(fd_dest);
  802e91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e94:	89 c7                	mov    %eax,%edi
  802e96:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
		return read_size;
  802ea2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ea5:	eb 27                	jmp    802ece <copy+0x1d9>
	}
	close(fd_src);
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	89 c7                	mov    %eax,%edi
  802eac:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
	close(fd_dest);
  802eb8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ebb:	89 c7                	mov    %eax,%edi
  802ebd:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
	return 0;
  802ec9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ece:	c9                   	leaveq 
  802ecf:	c3                   	retq   

0000000000802ed0 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802ed0:	55                   	push   %rbp
  802ed1:	48 89 e5             	mov    %rsp,%rbp
  802ed4:	48 83 ec 20          	sub    $0x20,%rsp
  802ed8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee0:	8b 40 0c             	mov    0xc(%rax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	7e 67                	jle    802f4e <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eeb:	8b 40 04             	mov    0x4(%rax),%eax
  802eee:	48 63 d0             	movslq %eax,%rdx
  802ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef5:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efd:	8b 00                	mov    (%rax),%eax
  802eff:	48 89 ce             	mov    %rcx,%rsi
  802f02:	89 c7                	mov    %eax,%edi
  802f04:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f17:	7e 13                	jle    802f2c <writebuf+0x5c>
			b->result += result;
  802f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1d:	8b 50 08             	mov    0x8(%rax),%edx
  802f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f23:	01 c2                	add    %eax,%edx
  802f25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f29:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f30:	8b 40 04             	mov    0x4(%rax),%eax
  802f33:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f36:	74 16                	je     802f4e <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802f38:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f41:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f45:	89 c2                	mov    %eax,%edx
  802f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4b:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f4e:	c9                   	leaveq 
  802f4f:	c3                   	retq   

0000000000802f50 <putch>:

static void
putch(int ch, void *thunk)
{
  802f50:	55                   	push   %rbp
  802f51:	48 89 e5             	mov    %rsp,%rbp
  802f54:	48 83 ec 20          	sub    $0x20,%rsp
  802f58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6b:	8b 40 04             	mov    0x4(%rax),%eax
  802f6e:	8d 48 01             	lea    0x1(%rax),%ecx
  802f71:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f75:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f78:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f7b:	89 d1                	mov    %edx,%ecx
  802f7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f81:	48 98                	cltq   
  802f83:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8b:	8b 40 04             	mov    0x4(%rax),%eax
  802f8e:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f93:	75 1e                	jne    802fb3 <putch+0x63>
		writebuf(b);
  802f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f99:	48 89 c7             	mov    %rax,%rdi
  802f9c:	48 b8 d0 2e 80 00 00 	movabs $0x802ed0,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
		b->idx = 0;
  802fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802fb3:	c9                   	leaveq 
  802fb4:	c3                   	retq   

0000000000802fb5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802fb5:	55                   	push   %rbp
  802fb6:	48 89 e5             	mov    %rsp,%rbp
  802fb9:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802fc0:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802fc6:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802fcd:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802fd4:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802fda:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802fe0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802fe7:	00 00 00 
	b.result = 0;
  802fea:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802ff1:	00 00 00 
	b.error = 1;
  802ff4:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802ffb:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802ffe:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803005:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80300c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803013:	48 89 c6             	mov    %rax,%rsi
  803016:	48 bf 50 2f 80 00 00 	movabs $0x802f50,%rdi
  80301d:	00 00 00 
  803020:	48 b8 c6 0a 80 00 00 	movabs $0x800ac6,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80302c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	7e 16                	jle    80304c <vfprintf+0x97>
		writebuf(&b);
  803036:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80303d:	48 89 c7             	mov    %rax,%rdi
  803040:	48 b8 d0 2e 80 00 00 	movabs $0x802ed0,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80304c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	74 08                	je     80305e <vfprintf+0xa9>
  803056:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80305c:	eb 06                	jmp    803064 <vfprintf+0xaf>
  80305e:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803064:	c9                   	leaveq 
  803065:	c3                   	retq   

0000000000803066 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803066:	55                   	push   %rbp
  803067:	48 89 e5             	mov    %rsp,%rbp
  80306a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803071:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803077:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80307e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803085:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80308c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803093:	84 c0                	test   %al,%al
  803095:	74 20                	je     8030b7 <fprintf+0x51>
  803097:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80309b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80309f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030a3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030a7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030ab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030af:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030b3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030b7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030be:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8030c5:	00 00 00 
  8030c8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030cf:	00 00 00 
  8030d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030d6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030dd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030e4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8030eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030f2:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8030f9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030ff:	48 89 ce             	mov    %rcx,%rsi
  803102:	89 c7                	mov    %eax,%edi
  803104:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  80310b:	00 00 00 
  80310e:	ff d0                	callq  *%rax
  803110:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803116:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80311c:	c9                   	leaveq 
  80311d:	c3                   	retq   

000000000080311e <printf>:

int
printf(const char *fmt, ...)
{
  80311e:	55                   	push   %rbp
  80311f:	48 89 e5             	mov    %rsp,%rbp
  803122:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803129:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803130:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803137:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80313e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803145:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80314c:	84 c0                	test   %al,%al
  80314e:	74 20                	je     803170 <printf+0x52>
  803150:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803154:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803158:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80315c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803160:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803164:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803168:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80316c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803170:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803177:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80317e:	00 00 00 
  803181:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803188:	00 00 00 
  80318b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80318f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803196:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80319d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8031a4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031ab:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8031b2:	48 89 c6             	mov    %rax,%rsi
  8031b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8031ba:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
  8031c6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8031cc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031d2:	c9                   	leaveq 
  8031d3:	c3                   	retq   

00000000008031d4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031d4:	55                   	push   %rbp
  8031d5:	48 89 e5             	mov    %rsp,%rbp
  8031d8:	48 83 ec 20          	sub    $0x20,%rsp
  8031dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e6:	48 89 d6             	mov    %rdx,%rsi
  8031e9:	89 c7                	mov    %eax,%edi
  8031eb:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
  8031f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fe:	79 05                	jns    803205 <fd2sockid+0x31>
		return r;
  803200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803203:	eb 24                	jmp    803229 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803209:	8b 10                	mov    (%rax),%edx
  80320b:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803212:	00 00 00 
  803215:	8b 00                	mov    (%rax),%eax
  803217:	39 c2                	cmp    %eax,%edx
  803219:	74 07                	je     803222 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80321b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803220:	eb 07                	jmp    803229 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803226:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803229:	c9                   	leaveq 
  80322a:	c3                   	retq   

000000000080322b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80322b:	55                   	push   %rbp
  80322c:	48 89 e5             	mov    %rsp,%rbp
  80322f:	48 83 ec 20          	sub    $0x20,%rsp
  803233:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803236:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
  803249:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803250:	78 26                	js     803278 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803256:	ba 07 04 00 00       	mov    $0x407,%edx
  80325b:	48 89 c6             	mov    %rax,%rsi
  80325e:	bf 00 00 00 00       	mov    $0x0,%edi
  803263:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
  80326f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803272:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803276:	79 16                	jns    80328e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803278:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327b:	89 c7                	mov    %eax,%edi
  80327d:	48 b8 3a 37 80 00 00 	movabs $0x80373a,%rax
  803284:	00 00 00 
  803287:	ff d0                	callq  *%rax
		return r;
  803289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328c:	eb 3a                	jmp    8032c8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803299:	00 00 00 
  80329c:	8b 12                	mov    (%rdx),%edx
  80329e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032af:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b9:	48 89 c7             	mov    %rax,%rdi
  8032bc:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
}
  8032c8:	c9                   	leaveq 
  8032c9:	c3                   	retq   

00000000008032ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032ca:	55                   	push   %rbp
  8032cb:	48 89 e5             	mov    %rsp,%rbp
  8032ce:	48 83 ec 30          	sub    $0x30,%rsp
  8032d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e0:	89 c7                	mov    %eax,%edi
  8032e2:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
  8032ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f5:	79 05                	jns    8032fc <accept+0x32>
		return r;
  8032f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fa:	eb 3b                	jmp    803337 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803300:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803307:	48 89 ce             	mov    %rcx,%rsi
  80330a:	89 c7                	mov    %eax,%edi
  80330c:	48 b8 17 36 80 00 00 	movabs $0x803617,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
  803318:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331f:	79 05                	jns    803326 <accept+0x5c>
		return r;
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	eb 11                	jmp    803337 <accept+0x6d>
	return alloc_sockfd(r);
  803326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803329:	89 c7                	mov    %eax,%edi
  80332b:	48 b8 2b 32 80 00 00 	movabs $0x80322b,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
}
  803337:	c9                   	leaveq 
  803338:	c3                   	retq   

0000000000803339 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803339:	55                   	push   %rbp
  80333a:	48 89 e5             	mov    %rsp,%rbp
  80333d:	48 83 ec 20          	sub    $0x20,%rsp
  803341:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803344:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803348:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80334b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80334e:	89 c7                	mov    %eax,%edi
  803350:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803363:	79 05                	jns    80336a <bind+0x31>
		return r;
  803365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803368:	eb 1b                	jmp    803385 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80336a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80336d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803374:	48 89 ce             	mov    %rcx,%rsi
  803377:	89 c7                	mov    %eax,%edi
  803379:	48 b8 96 36 80 00 00 	movabs $0x803696,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
}
  803385:	c9                   	leaveq 
  803386:	c3                   	retq   

0000000000803387 <shutdown>:

int
shutdown(int s, int how)
{
  803387:	55                   	push   %rbp
  803388:	48 89 e5             	mov    %rsp,%rbp
  80338b:	48 83 ec 20          	sub    $0x20,%rsp
  80338f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803392:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803395:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803398:	89 c7                	mov    %eax,%edi
  80339a:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  8033a1:	00 00 00 
  8033a4:	ff d0                	callq  *%rax
  8033a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ad:	79 05                	jns    8033b4 <shutdown+0x2d>
		return r;
  8033af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b2:	eb 16                	jmp    8033ca <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ba:	89 d6                	mov    %edx,%esi
  8033bc:	89 c7                	mov    %eax,%edi
  8033be:	48 b8 fa 36 80 00 00 	movabs $0x8036fa,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
}
  8033ca:	c9                   	leaveq 
  8033cb:	c3                   	retq   

00000000008033cc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033cc:	55                   	push   %rbp
  8033cd:	48 89 e5             	mov    %rsp,%rbp
  8033d0:	48 83 ec 10          	sub    $0x10,%rsp
  8033d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033dc:	48 89 c7             	mov    %rax,%rdi
  8033df:	48 b8 e6 41 80 00 00 	movabs $0x8041e6,%rax
  8033e6:	00 00 00 
  8033e9:	ff d0                	callq  *%rax
  8033eb:	83 f8 01             	cmp    $0x1,%eax
  8033ee:	75 17                	jne    803407 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8033f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f4:	8b 40 0c             	mov    0xc(%rax),%eax
  8033f7:	89 c7                	mov    %eax,%edi
  8033f9:	48 b8 3a 37 80 00 00 	movabs $0x80373a,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
  803405:	eb 05                	jmp    80340c <devsock_close+0x40>
	else
		return 0;
  803407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80340c:	c9                   	leaveq 
  80340d:	c3                   	retq   

000000000080340e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80340e:	55                   	push   %rbp
  80340f:	48 89 e5             	mov    %rsp,%rbp
  803412:	48 83 ec 20          	sub    $0x20,%rsp
  803416:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803419:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80341d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803420:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803423:	89 c7                	mov    %eax,%edi
  803425:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  80342c:	00 00 00 
  80342f:	ff d0                	callq  *%rax
  803431:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803434:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803438:	79 05                	jns    80343f <connect+0x31>
		return r;
  80343a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343d:	eb 1b                	jmp    80345a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80343f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803442:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803449:	48 89 ce             	mov    %rcx,%rsi
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 67 37 80 00 00 	movabs $0x803767,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <listen>:

int
listen(int s, int backlog)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 20          	sub    $0x20,%rsp
  803464:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803467:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80346a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80346d:	89 c7                	mov    %eax,%edi
  80346f:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803482:	79 05                	jns    803489 <listen+0x2d>
		return r;
  803484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803487:	eb 16                	jmp    80349f <listen+0x43>
	return nsipc_listen(r, backlog);
  803489:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80348c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348f:	89 d6                	mov    %edx,%esi
  803491:	89 c7                	mov    %eax,%edi
  803493:	48 b8 cb 37 80 00 00 	movabs $0x8037cb,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
}
  80349f:	c9                   	leaveq 
  8034a0:	c3                   	retq   

00000000008034a1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 83 ec 20          	sub    $0x20,%rsp
  8034a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b9:	89 c2                	mov    %eax,%edx
  8034bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bf:	8b 40 0c             	mov    0xc(%rax),%eax
  8034c2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 0b 38 80 00 00 	movabs $0x80380b,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
}
  8034d9:	c9                   	leaveq 
  8034da:	c3                   	retq   

00000000008034db <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	48 83 ec 20          	sub    $0x20,%rsp
  8034e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f3:	89 c2                	mov    %eax,%edx
  8034f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f9:	8b 40 0c             	mov    0xc(%rax),%eax
  8034fc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803500:	b9 00 00 00 00       	mov    $0x0,%ecx
  803505:	89 c7                	mov    %eax,%edi
  803507:	48 b8 d7 38 80 00 00 	movabs $0x8038d7,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 10          	sub    $0x10,%rsp
  80351d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803521:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803529:	48 be 7f 49 80 00 00 	movabs $0x80497f,%rsi
  803530:	00 00 00 
  803533:	48 89 c7             	mov    %rax,%rdi
  803536:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
	return 0;
  803542:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803547:	c9                   	leaveq 
  803548:	c3                   	retq   

0000000000803549 <socket>:

int
socket(int domain, int type, int protocol)
{
  803549:	55                   	push   %rbp
  80354a:	48 89 e5             	mov    %rsp,%rbp
  80354d:	48 83 ec 20          	sub    $0x20,%rsp
  803551:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803554:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803557:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80355a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80355d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803560:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803563:	89 ce                	mov    %ecx,%esi
  803565:	89 c7                	mov    %eax,%edi
  803567:	48 b8 8f 39 80 00 00 	movabs $0x80398f,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357a:	79 05                	jns    803581 <socket+0x38>
		return r;
  80357c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357f:	eb 11                	jmp    803592 <socket+0x49>
	return alloc_sockfd(r);
  803581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 2b 32 80 00 00 	movabs $0x80322b,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
}
  803592:	c9                   	leaveq 
  803593:	c3                   	retq   

0000000000803594 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803594:	55                   	push   %rbp
  803595:	48 89 e5             	mov    %rsp,%rbp
  803598:	48 83 ec 10          	sub    $0x10,%rsp
  80359c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80359f:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8035a6:	00 00 00 
  8035a9:	8b 00                	mov    (%rax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	75 1f                	jne    8035ce <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035af:	bf 02 00 00 00       	mov    $0x2,%edi
  8035b4:	48 b8 74 41 80 00 00 	movabs $0x804174,%rax
  8035bb:	00 00 00 
  8035be:	ff d0                	callq  *%rax
  8035c0:	89 c2                	mov    %eax,%edx
  8035c2:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8035c9:	00 00 00 
  8035cc:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035ce:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8035d5:	00 00 00 
  8035d8:	8b 00                	mov    (%rax),%eax
  8035da:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035dd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035e2:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8035e9:	00 00 00 
  8035ec:	89 c7                	mov    %eax,%edi
  8035ee:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8035fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ff:	be 00 00 00 00       	mov    $0x0,%esi
  803604:	bf 00 00 00 00       	mov    $0x0,%edi
  803609:	48 b8 a9 3f 80 00 00 	movabs $0x803fa9,%rax
  803610:	00 00 00 
  803613:	ff d0                	callq  *%rax
}
  803615:	c9                   	leaveq 
  803616:	c3                   	retq   

0000000000803617 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803617:	55                   	push   %rbp
  803618:	48 89 e5             	mov    %rsp,%rbp
  80361b:	48 83 ec 30          	sub    $0x30,%rsp
  80361f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803622:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803626:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80362a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803631:	00 00 00 
  803634:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803637:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803639:	bf 01 00 00 00       	mov    $0x1,%edi
  80363e:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803651:	78 3e                	js     803691 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803653:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80365a:	00 00 00 
  80365d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803665:	8b 40 10             	mov    0x10(%rax),%eax
  803668:	89 c2                	mov    %eax,%edx
  80366a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80366e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803672:	48 89 ce             	mov    %rcx,%rsi
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803688:	8b 50 10             	mov    0x10(%rax),%edx
  80368b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803691:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 10          	sub    $0x10,%rsp
  80369e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036a5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036af:	00 00 00 
  8036b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036b5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036be:	48 89 c6             	mov    %rax,%rsi
  8036c1:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036c8:	00 00 00 
  8036cb:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036d7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036de:	00 00 00 
  8036e1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8036e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8036ec:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
}
  8036f8:	c9                   	leaveq 
  8036f9:	c3                   	retq   

00000000008036fa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036fa:	55                   	push   %rbp
  8036fb:	48 89 e5             	mov    %rsp,%rbp
  8036fe:	48 83 ec 10          	sub    $0x10,%rsp
  803702:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803705:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803708:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370f:	00 00 00 
  803712:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803715:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803717:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371e:	00 00 00 
  803721:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803724:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803727:	bf 03 00 00 00       	mov    $0x3,%edi
  80372c:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   

000000000080373a <nsipc_close>:

int
nsipc_close(int s)
{
  80373a:	55                   	push   %rbp
  80373b:	48 89 e5             	mov    %rsp,%rbp
  80373e:	48 83 ec 10          	sub    $0x10,%rsp
  803742:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803745:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80374c:	00 00 00 
  80374f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803752:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803754:	bf 04 00 00 00       	mov    $0x4,%edi
  803759:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
}
  803765:	c9                   	leaveq 
  803766:	c3                   	retq   

0000000000803767 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803767:	55                   	push   %rbp
  803768:	48 89 e5             	mov    %rsp,%rbp
  80376b:	48 83 ec 10          	sub    $0x10,%rsp
  80376f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803772:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803776:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803779:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803780:	00 00 00 
  803783:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803786:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803788:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80378b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378f:	48 89 c6             	mov    %rax,%rsi
  803792:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803799:	00 00 00 
  80379c:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037af:	00 00 00 
  8037b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037b5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037b8:	bf 05 00 00 00       	mov    $0x5,%edi
  8037bd:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
}
  8037c9:	c9                   	leaveq 
  8037ca:	c3                   	retq   

00000000008037cb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8037cb:	55                   	push   %rbp
  8037cc:	48 89 e5             	mov    %rsp,%rbp
  8037cf:	48 83 ec 10          	sub    $0x10,%rsp
  8037d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037d6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e0:	00 00 00 
  8037e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8037e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ef:	00 00 00 
  8037f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8037f8:	bf 06 00 00 00       	mov    $0x6,%edi
  8037fd:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803804:	00 00 00 
  803807:	ff d0                	callq  *%rax
}
  803809:	c9                   	leaveq 
  80380a:	c3                   	retq   

000000000080380b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80380b:	55                   	push   %rbp
  80380c:	48 89 e5             	mov    %rsp,%rbp
  80380f:	48 83 ec 30          	sub    $0x30,%rsp
  803813:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803816:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80381a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80381d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803820:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803827:	00 00 00 
  80382a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80382d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80382f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803836:	00 00 00 
  803839:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80383c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80383f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803846:	00 00 00 
  803849:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80384c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80384f:	bf 07 00 00 00       	mov    $0x7,%edi
  803854:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803863:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803867:	78 69                	js     8038d2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803869:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803870:	7f 08                	jg     80387a <nsipc_recv+0x6f>
  803872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803875:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803878:	7e 35                	jle    8038af <nsipc_recv+0xa4>
  80387a:	48 b9 86 49 80 00 00 	movabs $0x804986,%rcx
  803881:	00 00 00 
  803884:	48 ba 9b 49 80 00 00 	movabs $0x80499b,%rdx
  80388b:	00 00 00 
  80388e:	be 61 00 00 00       	mov    $0x61,%esi
  803893:	48 bf b0 49 80 00 00 	movabs $0x8049b0,%rdi
  80389a:	00 00 00 
  80389d:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a2:	49 b8 ee 04 80 00 00 	movabs $0x8004ee,%r8
  8038a9:	00 00 00 
  8038ac:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b2:	48 63 d0             	movslq %eax,%rdx
  8038b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b9:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038c0:	00 00 00 
  8038c3:	48 89 c7             	mov    %rax,%rdi
  8038c6:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
	}

	return r;
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 20          	sub    $0x20,%rsp
  8038df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8038e9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8038ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f3:	00 00 00 
  8038f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8038fb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803902:	7e 35                	jle    803939 <nsipc_send+0x62>
  803904:	48 b9 bc 49 80 00 00 	movabs $0x8049bc,%rcx
  80390b:	00 00 00 
  80390e:	48 ba 9b 49 80 00 00 	movabs $0x80499b,%rdx
  803915:	00 00 00 
  803918:	be 6c 00 00 00       	mov    $0x6c,%esi
  80391d:	48 bf b0 49 80 00 00 	movabs $0x8049b0,%rdi
  803924:	00 00 00 
  803927:	b8 00 00 00 00       	mov    $0x0,%eax
  80392c:	49 b8 ee 04 80 00 00 	movabs $0x8004ee,%r8
  803933:	00 00 00 
  803936:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803939:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80393c:	48 63 d0             	movslq %eax,%rdx
  80393f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803943:	48 89 c6             	mov    %rax,%rsi
  803946:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80394d:	00 00 00 
  803950:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80395c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803963:	00 00 00 
  803966:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803969:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80396c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803973:	00 00 00 
  803976:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803979:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80397c:	bf 08 00 00 00       	mov    $0x8,%edi
  803981:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
}
  80398d:	c9                   	leaveq 
  80398e:	c3                   	retq   

000000000080398f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80398f:	55                   	push   %rbp
  803990:	48 89 e5             	mov    %rsp,%rbp
  803993:	48 83 ec 10          	sub    $0x10,%rsp
  803997:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80399a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80399d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039a0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a7:	00 00 00 
  8039aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ad:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b6:	00 00 00 
  8039b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039bc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c6:	00 00 00 
  8039c9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039cc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039cf:	bf 09 00 00 00       	mov    $0x9,%edi
  8039d4:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
}
  8039e0:	c9                   	leaveq 
  8039e1:	c3                   	retq   

00000000008039e2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039e2:	55                   	push   %rbp
  8039e3:	48 89 e5             	mov    %rsp,%rbp
  8039e6:	53                   	push   %rbx
  8039e7:	48 83 ec 38          	sub    $0x38,%rsp
  8039eb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039ef:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039f3:	48 89 c7             	mov    %rax,%rdi
  8039f6:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8039fd:	00 00 00 
  803a00:	ff d0                	callq  *%rax
  803a02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a09:	0f 88 bf 01 00 00    	js     803bce <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a13:	ba 07 04 00 00       	mov    $0x407,%edx
  803a18:	48 89 c6             	mov    %rax,%rsi
  803a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  803a20:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  803a27:	00 00 00 
  803a2a:	ff d0                	callq  *%rax
  803a2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a33:	0f 88 95 01 00 00    	js     803bce <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a39:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a3d:	48 89 c7             	mov    %rax,%rdi
  803a40:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a53:	0f 88 5d 01 00 00    	js     803bb6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a5d:	ba 07 04 00 00       	mov    $0x407,%edx
  803a62:	48 89 c6             	mov    %rax,%rsi
  803a65:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6a:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
  803a76:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7d:	0f 88 33 01 00 00    	js     803bb6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a87:	48 89 c7             	mov    %rax,%rdi
  803a8a:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9e:	ba 07 04 00 00       	mov    $0x407,%edx
  803aa3:	48 89 c6             	mov    %rax,%rsi
  803aa6:	bf 00 00 00 00       	mov    $0x0,%edi
  803aab:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
  803ab7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803abe:	79 05                	jns    803ac5 <pipe+0xe3>
		goto err2;
  803ac0:	e9 d9 00 00 00       	jmpq   803b9e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ac5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac9:	48 89 c7             	mov    %rax,%rdi
  803acc:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
  803ad8:	48 89 c2             	mov    %rax,%rdx
  803adb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803adf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ae5:	48 89 d1             	mov    %rdx,%rcx
  803ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  803aed:	48 89 c6             	mov    %rax,%rsi
  803af0:	bf 00 00 00 00       	mov    $0x0,%edi
  803af5:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
  803b01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b08:	79 1b                	jns    803b25 <pipe+0x143>
		goto err3;
  803b0a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0f:	48 89 c6             	mov    %rax,%rsi
  803b12:	bf 00 00 00 00       	mov    $0x0,%edi
  803b17:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803b1e:	00 00 00 
  803b21:	ff d0                	callq  *%rax
  803b23:	eb 79                	jmp    803b9e <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b29:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803b30:	00 00 00 
  803b33:	8b 12                	mov    (%rdx),%edx
  803b35:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803b42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b46:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803b4d:	00 00 00 
  803b50:	8b 12                	mov    (%rdx),%edx
  803b52:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b58:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803b5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b63:	48 89 c7             	mov    %rax,%rdi
  803b66:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  803b6d:	00 00 00 
  803b70:	ff d0                	callq  *%rax
  803b72:	89 c2                	mov    %eax,%edx
  803b74:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b78:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b7a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b7e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b86:	48 89 c7             	mov    %rax,%rdi
  803b89:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  803b90:	00 00 00 
  803b93:	ff d0                	callq  *%rax
  803b95:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b97:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9c:	eb 33                	jmp    803bd1 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803b9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba2:	48 89 c6             	mov    %rax,%rsi
  803ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  803baa:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803bb1:	00 00 00 
  803bb4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bba:	48 89 c6             	mov    %rax,%rsi
  803bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc2:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
err:
	return r;
  803bce:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bd1:	48 83 c4 38          	add    $0x38,%rsp
  803bd5:	5b                   	pop    %rbx
  803bd6:	5d                   	pop    %rbp
  803bd7:	c3                   	retq   

0000000000803bd8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bd8:	55                   	push   %rbp
  803bd9:	48 89 e5             	mov    %rsp,%rbp
  803bdc:	53                   	push   %rbx
  803bdd:	48 83 ec 28          	sub    $0x28,%rsp
  803be1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803be5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803be9:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803bf0:	00 00 00 
  803bf3:	48 8b 00             	mov    (%rax),%rax
  803bf6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bfc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c03:	48 89 c7             	mov    %rax,%rdi
  803c06:	48 b8 e6 41 80 00 00 	movabs $0x8041e6,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
  803c12:	89 c3                	mov    %eax,%ebx
  803c14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c18:	48 89 c7             	mov    %rax,%rdi
  803c1b:	48 b8 e6 41 80 00 00 	movabs $0x8041e6,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
  803c27:	39 c3                	cmp    %eax,%ebx
  803c29:	0f 94 c0             	sete   %al
  803c2c:	0f b6 c0             	movzbl %al,%eax
  803c2f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c32:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803c39:	00 00 00 
  803c3c:	48 8b 00             	mov    (%rax),%rax
  803c3f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c45:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c4e:	75 05                	jne    803c55 <_pipeisclosed+0x7d>
			return ret;
  803c50:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c53:	eb 4a                	jmp    803c9f <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803c55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c58:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c5b:	74 3d                	je     803c9a <_pipeisclosed+0xc2>
  803c5d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c61:	75 37                	jne    803c9a <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c63:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803c6a:	00 00 00 
  803c6d:	48 8b 00             	mov    (%rax),%rax
  803c70:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c76:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7c:	89 c6                	mov    %eax,%esi
  803c7e:	48 bf cd 49 80 00 00 	movabs $0x8049cd,%rdi
  803c85:	00 00 00 
  803c88:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8d:	49 b8 27 07 80 00 00 	movabs $0x800727,%r8
  803c94:	00 00 00 
  803c97:	41 ff d0             	callq  *%r8
	}
  803c9a:	e9 4a ff ff ff       	jmpq   803be9 <_pipeisclosed+0x11>
}
  803c9f:	48 83 c4 28          	add    $0x28,%rsp
  803ca3:	5b                   	pop    %rbx
  803ca4:	5d                   	pop    %rbp
  803ca5:	c3                   	retq   

0000000000803ca6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ca6:	55                   	push   %rbp
  803ca7:	48 89 e5             	mov    %rsp,%rbp
  803caa:	48 83 ec 30          	sub    $0x30,%rsp
  803cae:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cb1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cb8:	48 89 d6             	mov    %rdx,%rsi
  803cbb:	89 c7                	mov    %eax,%edi
  803cbd:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  803cc4:	00 00 00 
  803cc7:	ff d0                	callq  *%rax
  803cc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ccc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd0:	79 05                	jns    803cd7 <pipeisclosed+0x31>
		return r;
  803cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd5:	eb 31                	jmp    803d08 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cdb:	48 89 c7             	mov    %rax,%rdi
  803cde:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
  803cea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cf6:	48 89 d6             	mov    %rdx,%rsi
  803cf9:	48 89 c7             	mov    %rax,%rdi
  803cfc:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803d03:	00 00 00 
  803d06:	ff d0                	callq  *%rax
}
  803d08:	c9                   	leaveq 
  803d09:	c3                   	retq   

0000000000803d0a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d0a:	55                   	push   %rbp
  803d0b:	48 89 e5             	mov    %rsp,%rbp
  803d0e:	48 83 ec 40          	sub    $0x40,%rsp
  803d12:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d16:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d1a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d22:	48 89 c7             	mov    %rax,%rdi
  803d25:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803d2c:	00 00 00 
  803d2f:	ff d0                	callq  *%rax
  803d31:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d3d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d44:	00 
  803d45:	e9 92 00 00 00       	jmpq   803ddc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d4a:	eb 41                	jmp    803d8d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d4c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d51:	74 09                	je     803d5c <devpipe_read+0x52>
				return i;
  803d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d57:	e9 92 00 00 00       	jmpq   803dee <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d64:	48 89 d6             	mov    %rdx,%rsi
  803d67:	48 89 c7             	mov    %rax,%rdi
  803d6a:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803d71:	00 00 00 
  803d74:	ff d0                	callq  *%rax
  803d76:	85 c0                	test   %eax,%eax
  803d78:	74 07                	je     803d81 <devpipe_read+0x77>
				return 0;
  803d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7f:	eb 6d                	jmp    803dee <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d81:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  803d88:	00 00 00 
  803d8b:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d91:	8b 10                	mov    (%rax),%edx
  803d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d97:	8b 40 04             	mov    0x4(%rax),%eax
  803d9a:	39 c2                	cmp    %eax,%edx
  803d9c:	74 ae                	je     803d4c <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803da2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dae:	8b 00                	mov    (%rax),%eax
  803db0:	99                   	cltd   
  803db1:	c1 ea 1b             	shr    $0x1b,%edx
  803db4:	01 d0                	add    %edx,%eax
  803db6:	83 e0 1f             	and    $0x1f,%eax
  803db9:	29 d0                	sub    %edx,%eax
  803dbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dbf:	48 98                	cltq   
  803dc1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803dc6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dcc:	8b 00                	mov    (%rax),%eax
  803dce:	8d 50 01             	lea    0x1(%rax),%edx
  803dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd5:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803dd7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ddc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803de4:	0f 82 60 ff ff ff    	jb     803d4a <devpipe_read+0x40>
	}
	return i;
  803dea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803dee:	c9                   	leaveq 
  803def:	c3                   	retq   

0000000000803df0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803df0:	55                   	push   %rbp
  803df1:	48 89 e5             	mov    %rsp,%rbp
  803df4:	48 83 ec 40          	sub    $0x40,%rsp
  803df8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dfc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e00:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e08:	48 89 c7             	mov    %rax,%rdi
  803e0b:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803e12:	00 00 00 
  803e15:	ff d0                	callq  *%rax
  803e17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e23:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e2a:	00 
  803e2b:	e9 91 00 00 00       	jmpq   803ec1 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e30:	eb 31                	jmp    803e63 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3a:	48 89 d6             	mov    %rdx,%rsi
  803e3d:	48 89 c7             	mov    %rax,%rdi
  803e40:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803e47:	00 00 00 
  803e4a:	ff d0                	callq  *%rax
  803e4c:	85 c0                	test   %eax,%eax
  803e4e:	74 07                	je     803e57 <devpipe_write+0x67>
				return 0;
  803e50:	b8 00 00 00 00       	mov    $0x0,%eax
  803e55:	eb 7c                	jmp    803ed3 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e57:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  803e5e:	00 00 00 
  803e61:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e67:	8b 40 04             	mov    0x4(%rax),%eax
  803e6a:	48 63 d0             	movslq %eax,%rdx
  803e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e71:	8b 00                	mov    (%rax),%eax
  803e73:	48 98                	cltq   
  803e75:	48 83 c0 20          	add    $0x20,%rax
  803e79:	48 39 c2             	cmp    %rax,%rdx
  803e7c:	73 b4                	jae    803e32 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e82:	8b 40 04             	mov    0x4(%rax),%eax
  803e85:	99                   	cltd   
  803e86:	c1 ea 1b             	shr    $0x1b,%edx
  803e89:	01 d0                	add    %edx,%eax
  803e8b:	83 e0 1f             	and    $0x1f,%eax
  803e8e:	29 d0                	sub    %edx,%eax
  803e90:	89 c6                	mov    %eax,%esi
  803e92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e9a:	48 01 d0             	add    %rdx,%rax
  803e9d:	0f b6 08             	movzbl (%rax),%ecx
  803ea0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ea4:	48 63 c6             	movslq %esi,%rax
  803ea7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eaf:	8b 40 04             	mov    0x4(%rax),%eax
  803eb2:	8d 50 01             	lea    0x1(%rax),%edx
  803eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb9:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803ebc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ec9:	0f 82 61 ff ff ff    	jb     803e30 <devpipe_write+0x40>
	}

	return i;
  803ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ed3:	c9                   	leaveq 
  803ed4:	c3                   	retq   

0000000000803ed5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ed5:	55                   	push   %rbp
  803ed6:	48 89 e5             	mov    %rsp,%rbp
  803ed9:	48 83 ec 20          	sub    $0x20,%rsp
  803edd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ee1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee9:	48 89 c7             	mov    %rax,%rdi
  803eec:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
  803ef8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f00:	48 be e0 49 80 00 00 	movabs $0x8049e0,%rsi
  803f07:	00 00 00 
  803f0a:	48 89 c7             	mov    %rax,%rdi
  803f0d:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1d:	8b 50 04             	mov    0x4(%rax),%edx
  803f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f24:	8b 00                	mov    (%rax),%eax
  803f26:	29 c2                	sub    %eax,%edx
  803f28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f2c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f36:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f3d:	00 00 00 
	stat->st_dev = &devpipe;
  803f40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f44:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  803f4b:	00 00 00 
  803f4e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f5a:	c9                   	leaveq 
  803f5b:	c3                   	retq   

0000000000803f5c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f5c:	55                   	push   %rbp
  803f5d:	48 89 e5             	mov    %rsp,%rbp
  803f60:	48 83 ec 10          	sub    $0x10,%rsp
  803f64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6c:	48 89 c6             	mov    %rax,%rsi
  803f6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f74:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803f7b:	00 00 00 
  803f7e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f84:	48 89 c7             	mov    %rax,%rdi
  803f87:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
  803f93:	48 89 c6             	mov    %rax,%rsi
  803f96:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9b:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
}
  803fa7:	c9                   	leaveq 
  803fa8:	c3                   	retq   

0000000000803fa9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803fa9:	55                   	push   %rbp
  803faa:	48 89 e5             	mov    %rsp,%rbp
  803fad:	48 83 ec 20          	sub    $0x20,%rsp
  803fb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fb9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803fbd:	48 ba e8 49 80 00 00 	movabs $0x8049e8,%rdx
  803fc4:	00 00 00 
  803fc7:	be 1d 00 00 00       	mov    $0x1d,%esi
  803fcc:	48 bf 01 4a 80 00 00 	movabs $0x804a01,%rdi
  803fd3:	00 00 00 
  803fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  803fdb:	48 b9 ee 04 80 00 00 	movabs $0x8004ee,%rcx
  803fe2:	00 00 00 
  803fe5:	ff d1                	callq  *%rcx

0000000000803fe7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	48 83 ec 20          	sub    $0x20,%rsp
  803fef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ff2:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ff5:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803ff9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803ffc:	48 ba 0b 4a 80 00 00 	movabs $0x804a0b,%rdx
  804003:	00 00 00 
  804006:	be 2d 00 00 00       	mov    $0x2d,%esi
  80400b:	48 bf 01 4a 80 00 00 	movabs $0x804a01,%rdi
  804012:	00 00 00 
  804015:	b8 00 00 00 00       	mov    $0x0,%eax
  80401a:	48 b9 ee 04 80 00 00 	movabs $0x8004ee,%rcx
  804021:	00 00 00 
  804024:	ff d1                	callq  *%rcx

0000000000804026 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804026:	55                   	push   %rbp
  804027:	48 89 e5             	mov    %rsp,%rbp
  80402a:	53                   	push   %rbx
  80402b:	48 83 ec 48          	sub    $0x48,%rsp
  80402f:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  80403a:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804041:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  804046:	75 0e                	jne    804056 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  804048:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80404f:	00 00 00 
  804052:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  804056:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80405a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  80405e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804065:	00 
	a3 = (uint64_t) 0;
  804066:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80406d:	00 
	a4 = (uint64_t) 0;
  80406e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804075:	00 
	a5 = 0;
  804076:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80407d:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  80407e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804081:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804085:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804089:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  80408d:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804091:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804095:	4c 89 c3             	mov    %r8,%rbx
  804098:	0f 01 c1             	vmcall 
  80409b:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  80409e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040a2:	7e 36                	jle    8040da <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  8040a4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040a7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040aa:	41 89 d0             	mov    %edx,%r8d
  8040ad:	89 c1                	mov    %eax,%ecx
  8040af:	48 ba 28 4a 80 00 00 	movabs $0x804a28,%rdx
  8040b6:	00 00 00 
  8040b9:	be 54 00 00 00       	mov    $0x54,%esi
  8040be:	48 bf 01 4a 80 00 00 	movabs $0x804a01,%rdi
  8040c5:	00 00 00 
  8040c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040cd:	49 b9 ee 04 80 00 00 	movabs $0x8004ee,%r9
  8040d4:	00 00 00 
  8040d7:	41 ff d1             	callq  *%r9
	return ret;
  8040da:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8040dd:	48 83 c4 48          	add    $0x48,%rsp
  8040e1:	5b                   	pop    %rbx
  8040e2:	5d                   	pop    %rbp
  8040e3:	c3                   	retq   

00000000008040e4 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040e4:	55                   	push   %rbp
  8040e5:	48 89 e5             	mov    %rsp,%rbp
  8040e8:	53                   	push   %rbx
  8040e9:	48 83 ec 58          	sub    $0x58,%rsp
  8040ed:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  8040f0:	89 75 b0             	mov    %esi,-0x50(%rbp)
  8040f3:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8040f7:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8040fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804101:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  804108:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  80410d:	75 0e                	jne    80411d <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  80410f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804116:	00 00 00 
  804119:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  80411d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804120:	48 98                	cltq   
  804122:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804126:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804129:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  80412d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804131:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804135:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  804138:	48 98                	cltq   
  80413a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  80413e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804145:	00 

	int r = -E_IPC_NOT_RECV;
  804146:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  80414d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804150:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804154:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804158:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  80415c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804160:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804164:	4c 89 c3             	mov    %r8,%rbx
  804167:	0f 01 c1             	vmcall 
  80416a:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  80416d:	48 83 c4 58          	add    $0x58,%rsp
  804171:	5b                   	pop    %rbx
  804172:	5d                   	pop    %rbp
  804173:	c3                   	retq   

0000000000804174 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804174:	55                   	push   %rbp
  804175:	48 89 e5             	mov    %rsp,%rbp
  804178:	48 83 ec 18          	sub    $0x18,%rsp
  80417c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80417f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804186:	eb 4e                	jmp    8041d6 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804188:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80418f:	00 00 00 
  804192:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804195:	48 98                	cltq   
  804197:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80419e:	48 01 d0             	add    %rdx,%rax
  8041a1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041a7:	8b 00                	mov    (%rax),%eax
  8041a9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8041ac:	75 24                	jne    8041d2 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8041ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041b5:	00 00 00 
  8041b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041bb:	48 98                	cltq   
  8041bd:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041c4:	48 01 d0             	add    %rdx,%rax
  8041c7:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8041cd:	8b 40 08             	mov    0x8(%rax),%eax
  8041d0:	eb 12                	jmp    8041e4 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  8041d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8041d6:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8041dd:	7e a9                	jle    804188 <ipc_find_env+0x14>
	}
	return 0;
  8041df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041e4:	c9                   	leaveq 
  8041e5:	c3                   	retq   

00000000008041e6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8041e6:	55                   	push   %rbp
  8041e7:	48 89 e5             	mov    %rsp,%rbp
  8041ea:	48 83 ec 18          	sub    $0x18,%rsp
  8041ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8041f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f6:	48 c1 e8 15          	shr    $0x15,%rax
  8041fa:	48 89 c2             	mov    %rax,%rdx
  8041fd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804204:	01 00 00 
  804207:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80420b:	83 e0 01             	and    $0x1,%eax
  80420e:	48 85 c0             	test   %rax,%rax
  804211:	75 07                	jne    80421a <pageref+0x34>
		return 0;
  804213:	b8 00 00 00 00       	mov    $0x0,%eax
  804218:	eb 53                	jmp    80426d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80421a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80421e:	48 c1 e8 0c          	shr    $0xc,%rax
  804222:	48 89 c2             	mov    %rax,%rdx
  804225:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80422c:	01 00 00 
  80422f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804233:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80423b:	83 e0 01             	and    $0x1,%eax
  80423e:	48 85 c0             	test   %rax,%rax
  804241:	75 07                	jne    80424a <pageref+0x64>
		return 0;
  804243:	b8 00 00 00 00       	mov    $0x0,%eax
  804248:	eb 23                	jmp    80426d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80424a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424e:	48 c1 e8 0c          	shr    $0xc,%rax
  804252:	48 89 c2             	mov    %rax,%rdx
  804255:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80425c:	00 00 00 
  80425f:	48 c1 e2 04          	shl    $0x4,%rdx
  804263:	48 01 d0             	add    %rdx,%rax
  804266:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80426a:	0f b7 c0             	movzwl %ax,%eax
}
  80426d:	c9                   	leaveq 
  80426e:	c3                   	retq   
