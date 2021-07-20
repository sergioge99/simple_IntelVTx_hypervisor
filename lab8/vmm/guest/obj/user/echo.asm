
vmm/guest/obj/user/echo:     formato del fichero elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
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
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be c0 3d 80 00 00 	movabs $0x803dc0,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 a3 03 80 00 00 	movabs $0x8003a3,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be c3 3d 80 00 00 	movabs $0x803dc3,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be c5 3d 80 00 00 	movabs $0x803dc5,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800176:	7e 14                	jle    80018c <libmain+0x3a>
		binaryname = argv[0];
  800178:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017c:	48 8b 10             	mov    (%rax),%rdx
  80017f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800186:	00 00 00 
  800189:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80018c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800193:	48 89 d6             	mov    %rdx,%rsi
  800196:	89 c7                	mov    %eax,%edi
  800198:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019f:	00 00 00 
  8001a2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001a4:	48 b8 b2 01 80 00 00 	movabs $0x8001b2,%rax
  8001ab:	00 00 00 
  8001ae:	ff d0                	callq  *%rax
}
  8001b0:	c9                   	leaveq 
  8001b1:	c3                   	retq   

00000000008001b2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b2:	55                   	push   %rbp
  8001b3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001b6:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8001bd:	00 00 00 
  8001c0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c7:	48 b8 b0 0a 80 00 00 	movabs $0x800ab0,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
}
  8001d3:	5d                   	pop    %rbp
  8001d4:	c3                   	retq   

00000000008001d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp
  8001d9:	48 83 ec 18          	sub    $0x18,%rsp
  8001dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8001e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001e8:	eb 09                	jmp    8001f3 <strlen+0x1e>
		n++;
  8001ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8001ee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8001f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001f7:	0f b6 00             	movzbl (%rax),%eax
  8001fa:	84 c0                	test   %al,%al
  8001fc:	75 ec                	jne    8001ea <strlen+0x15>
	return n;
  8001fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 20          	sub    $0x20,%rsp
  80020b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80020f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80021a:	eb 0e                	jmp    80022a <strnlen+0x27>
		n++;
  80021c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800220:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800225:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80022a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80022f:	74 0b                	je     80023c <strnlen+0x39>
  800231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800235:	0f b6 00             	movzbl (%rax),%eax
  800238:	84 c0                	test   %al,%al
  80023a:	75 e0                	jne    80021c <strnlen+0x19>
	return n;
  80023c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80023f:	c9                   	leaveq 
  800240:	c3                   	retq   

0000000000800241 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800241:	55                   	push   %rbp
  800242:	48 89 e5             	mov    %rsp,%rbp
  800245:	48 83 ec 20          	sub    $0x20,%rsp
  800249:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80024d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800255:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800259:	90                   	nop
  80025a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80025e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800262:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800266:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80026a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80026e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800272:	0f b6 12             	movzbl (%rdx),%edx
  800275:	88 10                	mov    %dl,(%rax)
  800277:	0f b6 00             	movzbl (%rax),%eax
  80027a:	84 c0                	test   %al,%al
  80027c:	75 dc                	jne    80025a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80027e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800282:	c9                   	leaveq 
  800283:	c3                   	retq   

0000000000800284 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800284:	55                   	push   %rbp
  800285:	48 89 e5             	mov    %rsp,%rbp
  800288:	48 83 ec 20          	sub    $0x20,%rsp
  80028c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800290:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800298:	48 89 c7             	mov    %rax,%rdi
  80029b:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	callq  *%rax
  8002a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ad:	48 63 d0             	movslq %eax,%rdx
  8002b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002b4:	48 01 c2             	add    %rax,%rdx
  8002b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002bb:	48 89 c6             	mov    %rax,%rsi
  8002be:	48 89 d7             	mov    %rdx,%rdi
  8002c1:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  8002c8:	00 00 00 
  8002cb:	ff d0                	callq  *%rax
	return dst;
  8002cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002d1:	c9                   	leaveq 
  8002d2:	c3                   	retq   

00000000008002d3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002d3:	55                   	push   %rbp
  8002d4:	48 89 e5             	mov    %rsp,%rbp
  8002d7:	48 83 ec 28          	sub    $0x28,%rsp
  8002db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8002e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8002e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8002ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8002f6:	00 
  8002f7:	eb 2a                	jmp    800323 <strncpy+0x50>
		*dst++ = *src;
  8002f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800301:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800305:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800309:	0f b6 12             	movzbl (%rdx),%edx
  80030c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80030e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800312:	0f b6 00             	movzbl (%rax),%eax
  800315:	84 c0                	test   %al,%al
  800317:	74 05                	je     80031e <strncpy+0x4b>
			src++;
  800319:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80031e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800327:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80032b:	72 cc                	jb     8002f9 <strncpy+0x26>
	}
	return ret;
  80032d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800331:	c9                   	leaveq 
  800332:	c3                   	retq   

0000000000800333 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800333:	55                   	push   %rbp
  800334:	48 89 e5             	mov    %rsp,%rbp
  800337:	48 83 ec 28          	sub    $0x28,%rsp
  80033b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80033f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800343:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80034b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80034f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800354:	74 3d                	je     800393 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800356:	eb 1d                	jmp    800375 <strlcpy+0x42>
			*dst++ = *src++;
  800358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80035c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800360:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800364:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800368:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80036c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800370:	0f b6 12             	movzbl (%rdx),%edx
  800373:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  800375:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80037a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80037f:	74 0b                	je     80038c <strlcpy+0x59>
  800381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800385:	0f b6 00             	movzbl (%rax),%eax
  800388:	84 c0                	test   %al,%al
  80038a:	75 cc                	jne    800358 <strlcpy+0x25>
		*dst = '\0';
  80038c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800390:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800393:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80039b:	48 29 c2             	sub    %rax,%rdx
  80039e:	48 89 d0             	mov    %rdx,%rax
}
  8003a1:	c9                   	leaveq 
  8003a2:	c3                   	retq   

00000000008003a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003a3:	55                   	push   %rbp
  8003a4:	48 89 e5             	mov    %rsp,%rbp
  8003a7:	48 83 ec 10          	sub    $0x10,%rsp
  8003ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003b3:	eb 0a                	jmp    8003bf <strcmp+0x1c>
		p++, q++;
  8003b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8003bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c3:	0f b6 00             	movzbl (%rax),%eax
  8003c6:	84 c0                	test   %al,%al
  8003c8:	74 12                	je     8003dc <strcmp+0x39>
  8003ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ce:	0f b6 10             	movzbl (%rax),%edx
  8003d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d5:	0f b6 00             	movzbl (%rax),%eax
  8003d8:	38 c2                	cmp    %al,%dl
  8003da:	74 d9                	je     8003b5 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8003dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003e0:	0f b6 00             	movzbl (%rax),%eax
  8003e3:	0f b6 d0             	movzbl %al,%edx
  8003e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ea:	0f b6 00             	movzbl (%rax),%eax
  8003ed:	0f b6 c0             	movzbl %al,%eax
  8003f0:	29 c2                	sub    %eax,%edx
  8003f2:	89 d0                	mov    %edx,%eax
}
  8003f4:	c9                   	leaveq 
  8003f5:	c3                   	retq   

00000000008003f6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8003f6:	55                   	push   %rbp
  8003f7:	48 89 e5             	mov    %rsp,%rbp
  8003fa:	48 83 ec 18          	sub    $0x18,%rsp
  8003fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800402:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800406:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80040a:	eb 0f                	jmp    80041b <strncmp+0x25>
		n--, p++, q++;
  80040c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800411:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800416:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  80041b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420:	74 1d                	je     80043f <strncmp+0x49>
  800422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800426:	0f b6 00             	movzbl (%rax),%eax
  800429:	84 c0                	test   %al,%al
  80042b:	74 12                	je     80043f <strncmp+0x49>
  80042d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800431:	0f b6 10             	movzbl (%rax),%edx
  800434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800438:	0f b6 00             	movzbl (%rax),%eax
  80043b:	38 c2                	cmp    %al,%dl
  80043d:	74 cd                	je     80040c <strncmp+0x16>
	if (n == 0)
  80043f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800444:	75 07                	jne    80044d <strncmp+0x57>
		return 0;
  800446:	b8 00 00 00 00       	mov    $0x0,%eax
  80044b:	eb 18                	jmp    800465 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80044d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800451:	0f b6 00             	movzbl (%rax),%eax
  800454:	0f b6 d0             	movzbl %al,%edx
  800457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045b:	0f b6 00             	movzbl (%rax),%eax
  80045e:	0f b6 c0             	movzbl %al,%eax
  800461:	29 c2                	sub    %eax,%edx
  800463:	89 d0                	mov    %edx,%eax
}
  800465:	c9                   	leaveq 
  800466:	c3                   	retq   

0000000000800467 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800467:	55                   	push   %rbp
  800468:	48 89 e5             	mov    %rsp,%rbp
  80046b:	48 83 ec 10          	sub    $0x10,%rsp
  80046f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800473:	89 f0                	mov    %esi,%eax
  800475:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  800478:	eb 17                	jmp    800491 <strchr+0x2a>
		if (*s == c)
  80047a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80047e:	0f b6 00             	movzbl (%rax),%eax
  800481:	3a 45 f4             	cmp    -0xc(%rbp),%al
  800484:	75 06                	jne    80048c <strchr+0x25>
			return (char *) s;
  800486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80048a:	eb 15                	jmp    8004a1 <strchr+0x3a>
	for (; *s; s++)
  80048c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800495:	0f b6 00             	movzbl (%rax),%eax
  800498:	84 c0                	test   %al,%al
  80049a:	75 de                	jne    80047a <strchr+0x13>
	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004af:	89 f0                	mov    %esi,%eax
  8004b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004b4:	eb 13                	jmp    8004c9 <strfind+0x26>
		if (*s == c)
  8004b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ba:	0f b6 00             	movzbl (%rax),%eax
  8004bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004c0:	75 02                	jne    8004c4 <strfind+0x21>
			break;
  8004c2:	eb 10                	jmp    8004d4 <strfind+0x31>
	for (; *s; s++)
  8004c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004cd:	0f b6 00             	movzbl (%rax),%eax
  8004d0:	84 c0                	test   %al,%al
  8004d2:	75 e2                	jne    8004b6 <strfind+0x13>
	return (char *) s;
  8004d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004d8:	c9                   	leaveq 
  8004d9:	c3                   	retq   

00000000008004da <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8004da:	55                   	push   %rbp
  8004db:	48 89 e5             	mov    %rsp,%rbp
  8004de:	48 83 ec 18          	sub    $0x18,%rsp
  8004e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004e6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8004e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8004ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004f2:	75 06                	jne    8004fa <memset+0x20>
		return v;
  8004f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f8:	eb 69                	jmp    800563 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8004fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004fe:	83 e0 03             	and    $0x3,%eax
  800501:	48 85 c0             	test   %rax,%rax
  800504:	75 48                	jne    80054e <memset+0x74>
  800506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050a:	83 e0 03             	and    $0x3,%eax
  80050d:	48 85 c0             	test   %rax,%rax
  800510:	75 3c                	jne    80054e <memset+0x74>
		c &= 0xFF;
  800512:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800519:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80051c:	c1 e0 18             	shl    $0x18,%eax
  80051f:	89 c2                	mov    %eax,%edx
  800521:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800524:	c1 e0 10             	shl    $0x10,%eax
  800527:	09 c2                	or     %eax,%edx
  800529:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80052c:	c1 e0 08             	shl    $0x8,%eax
  80052f:	09 d0                	or     %edx,%eax
  800531:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  800534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800538:	48 c1 e8 02          	shr    $0x2,%rax
  80053c:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80053f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800543:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800546:	48 89 d7             	mov    %rdx,%rdi
  800549:	fc                   	cld    
  80054a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80054c:	eb 11                	jmp    80055f <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80054e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800552:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800555:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800559:	48 89 d7             	mov    %rdx,%rdi
  80055c:	fc                   	cld    
  80055d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80055f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800563:	c9                   	leaveq 
  800564:	c3                   	retq   

0000000000800565 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800565:	55                   	push   %rbp
  800566:	48 89 e5             	mov    %rsp,%rbp
  800569:	48 83 ec 28          	sub    $0x28,%rsp
  80056d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800571:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  800579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80057d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  800589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80058d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  800591:	0f 83 88 00 00 00    	jae    80061f <memmove+0xba>
  800597:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80059b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80059f:	48 01 d0             	add    %rdx,%rax
  8005a2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005a6:	76 77                	jbe    80061f <memmove+0xba>
		s += n;
  8005a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ac:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005bc:	83 e0 03             	and    $0x3,%eax
  8005bf:	48 85 c0             	test   %rax,%rax
  8005c2:	75 3b                	jne    8005ff <memmove+0x9a>
  8005c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c8:	83 e0 03             	and    $0x3,%eax
  8005cb:	48 85 c0             	test   %rax,%rax
  8005ce:	75 2f                	jne    8005ff <memmove+0x9a>
  8005d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d4:	83 e0 03             	and    $0x3,%eax
  8005d7:	48 85 c0             	test   %rax,%rax
  8005da:	75 23                	jne    8005ff <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8005dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e0:	48 83 e8 04          	sub    $0x4,%rax
  8005e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005e8:	48 83 ea 04          	sub    $0x4,%rdx
  8005ec:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8005f0:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8005f4:	48 89 c7             	mov    %rax,%rdi
  8005f7:	48 89 d6             	mov    %rdx,%rsi
  8005fa:	fd                   	std    
  8005fb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8005fd:	eb 1d                	jmp    80061c <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8005ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800603:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80060f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800613:	48 89 d7             	mov    %rdx,%rdi
  800616:	48 89 c1             	mov    %rax,%rcx
  800619:	fd                   	std    
  80061a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80061c:	fc                   	cld    
  80061d:	eb 57                	jmp    800676 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80061f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800623:	83 e0 03             	and    $0x3,%eax
  800626:	48 85 c0             	test   %rax,%rax
  800629:	75 36                	jne    800661 <memmove+0xfc>
  80062b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062f:	83 e0 03             	and    $0x3,%eax
  800632:	48 85 c0             	test   %rax,%rax
  800635:	75 2a                	jne    800661 <memmove+0xfc>
  800637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063b:	83 e0 03             	and    $0x3,%eax
  80063e:	48 85 c0             	test   %rax,%rax
  800641:	75 1e                	jne    800661 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800647:	48 c1 e8 02          	shr    $0x2,%rax
  80064b:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80064e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800652:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800656:	48 89 c7             	mov    %rax,%rdi
  800659:	48 89 d6             	mov    %rdx,%rsi
  80065c:	fc                   	cld    
  80065d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80065f:	eb 15                	jmp    800676 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  800661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800665:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800669:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80066d:	48 89 c7             	mov    %rax,%rdi
  800670:	48 89 d6             	mov    %rdx,%rsi
  800673:	fc                   	cld    
  800674:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80067a:	c9                   	leaveq 
  80067b:	c3                   	retq   

000000000080067c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80067c:	55                   	push   %rbp
  80067d:	48 89 e5             	mov    %rsp,%rbp
  800680:	48 83 ec 18          	sub    $0x18,%rsp
  800684:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800688:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80068c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  800690:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800694:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800698:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80069c:	48 89 ce             	mov    %rcx,%rsi
  80069f:	48 89 c7             	mov    %rax,%rdi
  8006a2:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8006a9:	00 00 00 
  8006ac:	ff d0                	callq  *%rax
}
  8006ae:	c9                   	leaveq 
  8006af:	c3                   	retq   

00000000008006b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006b0:	55                   	push   %rbp
  8006b1:	48 89 e5             	mov    %rsp,%rbp
  8006b4:	48 83 ec 28          	sub    $0x28,%rsp
  8006b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006d4:	eb 36                	jmp    80070c <memcmp+0x5c>
		if (*s1 != *s2)
  8006d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006da:	0f b6 10             	movzbl (%rax),%edx
  8006dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e1:	0f b6 00             	movzbl (%rax),%eax
  8006e4:	38 c2                	cmp    %al,%dl
  8006e6:	74 1a                	je     800702 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8006e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ec:	0f b6 00             	movzbl (%rax),%eax
  8006ef:	0f b6 d0             	movzbl %al,%edx
  8006f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f6:	0f b6 00             	movzbl (%rax),%eax
  8006f9:	0f b6 c0             	movzbl %al,%eax
  8006fc:	29 c2                	sub    %eax,%edx
  8006fe:	89 d0                	mov    %edx,%eax
  800700:	eb 20                	jmp    800722 <memcmp+0x72>
		s1++, s2++;
  800702:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800707:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  80070c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800710:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800714:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800718:	48 85 c0             	test   %rax,%rax
  80071b:	75 b9                	jne    8006d6 <memcmp+0x26>
	}

	return 0;
  80071d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800722:	c9                   	leaveq 
  800723:	c3                   	retq   

0000000000800724 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800724:	55                   	push   %rbp
  800725:	48 89 e5             	mov    %rsp,%rbp
  800728:	48 83 ec 28          	sub    $0x28,%rsp
  80072c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800730:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800733:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800737:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80073f:	48 01 d0             	add    %rdx,%rax
  800742:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800746:	eb 15                	jmp    80075d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	0f b6 00             	movzbl (%rax),%eax
  80074f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800752:	38 d0                	cmp    %dl,%al
  800754:	75 02                	jne    800758 <memfind+0x34>
			break;
  800756:	eb 0f                	jmp    800767 <memfind+0x43>
	for (; s < ends; s++)
  800758:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800765:	72 e1                	jb     800748 <memfind+0x24>
	return (void *) s;
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80076b:	c9                   	leaveq 
  80076c:	c3                   	retq   

000000000080076d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80076d:	55                   	push   %rbp
  80076e:	48 89 e5             	mov    %rsp,%rbp
  800771:	48 83 ec 38          	sub    $0x38,%rsp
  800775:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800779:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80077d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  800780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  800787:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80078e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80078f:	eb 05                	jmp    800796 <strtol+0x29>
		s++;
  800791:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  800796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80079a:	0f b6 00             	movzbl (%rax),%eax
  80079d:	3c 20                	cmp    $0x20,%al
  80079f:	74 f0                	je     800791 <strtol+0x24>
  8007a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007a5:	0f b6 00             	movzbl (%rax),%eax
  8007a8:	3c 09                	cmp    $0x9,%al
  8007aa:	74 e5                	je     800791 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8007ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007b0:	0f b6 00             	movzbl (%rax),%eax
  8007b3:	3c 2b                	cmp    $0x2b,%al
  8007b5:	75 07                	jne    8007be <strtol+0x51>
		s++;
  8007b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007bc:	eb 17                	jmp    8007d5 <strtol+0x68>
	else if (*s == '-')
  8007be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c2:	0f b6 00             	movzbl (%rax),%eax
  8007c5:	3c 2d                	cmp    $0x2d,%al
  8007c7:	75 0c                	jne    8007d5 <strtol+0x68>
		s++, neg = 1;
  8007c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8007d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8007d9:	74 06                	je     8007e1 <strtol+0x74>
  8007db:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8007df:	75 28                	jne    800809 <strtol+0x9c>
  8007e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e5:	0f b6 00             	movzbl (%rax),%eax
  8007e8:	3c 30                	cmp    $0x30,%al
  8007ea:	75 1d                	jne    800809 <strtol+0x9c>
  8007ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007f0:	48 83 c0 01          	add    $0x1,%rax
  8007f4:	0f b6 00             	movzbl (%rax),%eax
  8007f7:	3c 78                	cmp    $0x78,%al
  8007f9:	75 0e                	jne    800809 <strtol+0x9c>
		s += 2, base = 16;
  8007fb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800800:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800807:	eb 2c                	jmp    800835 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800809:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80080d:	75 19                	jne    800828 <strtol+0xbb>
  80080f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800813:	0f b6 00             	movzbl (%rax),%eax
  800816:	3c 30                	cmp    $0x30,%al
  800818:	75 0e                	jne    800828 <strtol+0xbb>
		s++, base = 8;
  80081a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80081f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800826:	eb 0d                	jmp    800835 <strtol+0xc8>
	else if (base == 0)
  800828:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80082c:	75 07                	jne    800835 <strtol+0xc8>
		base = 10;
  80082e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800839:	0f b6 00             	movzbl (%rax),%eax
  80083c:	3c 2f                	cmp    $0x2f,%al
  80083e:	7e 1d                	jle    80085d <strtol+0xf0>
  800840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800844:	0f b6 00             	movzbl (%rax),%eax
  800847:	3c 39                	cmp    $0x39,%al
  800849:	7f 12                	jg     80085d <strtol+0xf0>
			dig = *s - '0';
  80084b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80084f:	0f b6 00             	movzbl (%rax),%eax
  800852:	0f be c0             	movsbl %al,%eax
  800855:	83 e8 30             	sub    $0x30,%eax
  800858:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80085b:	eb 4e                	jmp    8008ab <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80085d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800861:	0f b6 00             	movzbl (%rax),%eax
  800864:	3c 60                	cmp    $0x60,%al
  800866:	7e 1d                	jle    800885 <strtol+0x118>
  800868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80086c:	0f b6 00             	movzbl (%rax),%eax
  80086f:	3c 7a                	cmp    $0x7a,%al
  800871:	7f 12                	jg     800885 <strtol+0x118>
			dig = *s - 'a' + 10;
  800873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800877:	0f b6 00             	movzbl (%rax),%eax
  80087a:	0f be c0             	movsbl %al,%eax
  80087d:	83 e8 57             	sub    $0x57,%eax
  800880:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800883:	eb 26                	jmp    8008ab <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  800885:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800889:	0f b6 00             	movzbl (%rax),%eax
  80088c:	3c 40                	cmp    $0x40,%al
  80088e:	7e 48                	jle    8008d8 <strtol+0x16b>
  800890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800894:	0f b6 00             	movzbl (%rax),%eax
  800897:	3c 5a                	cmp    $0x5a,%al
  800899:	7f 3d                	jg     8008d8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80089b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089f:	0f b6 00             	movzbl (%rax),%eax
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 e8 37             	sub    $0x37,%eax
  8008a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008ae:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008b1:	7c 02                	jl     8008b5 <strtol+0x148>
			break;
  8008b3:	eb 23                	jmp    8008d8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008ba:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008bd:	48 98                	cltq   
  8008bf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008c4:	48 89 c2             	mov    %rax,%rdx
  8008c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008ca:	48 98                	cltq   
  8008cc:	48 01 d0             	add    %rdx,%rax
  8008cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008d3:	e9 5d ff ff ff       	jmpq   800835 <strtol+0xc8>

	if (endptr)
  8008d8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8008dd:	74 0b                	je     8008ea <strtol+0x17d>
		*endptr = (char *) s;
  8008df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8008e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8008e7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8008ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008ee:	74 09                	je     8008f9 <strtol+0x18c>
  8008f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008f4:	48 f7 d8             	neg    %rax
  8008f7:	eb 04                	jmp    8008fd <strtol+0x190>
  8008f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8008fd:	c9                   	leaveq 
  8008fe:	c3                   	retq   

00000000008008ff <strstr>:

char * strstr(const char *in, const char *str)
{
  8008ff:	55                   	push   %rbp
  800900:	48 89 e5             	mov    %rsp,%rbp
  800903:	48 83 ec 30          	sub    $0x30,%rsp
  800907:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80090b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80090f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800913:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800917:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800921:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800925:	75 06                	jne    80092d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  800927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80092b:	eb 6b                	jmp    800998 <strstr+0x99>

	len = strlen(str);
  80092d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800931:	48 89 c7             	mov    %rax,%rdi
  800934:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  80093b:	00 00 00 
  80093e:	ff d0                	callq  *%rax
  800940:	48 98                	cltq   
  800942:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80094a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80094e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800952:	0f b6 00             	movzbl (%rax),%eax
  800955:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  800958:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80095c:	75 07                	jne    800965 <strstr+0x66>
				return (char *) 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb 33                	jmp    800998 <strstr+0x99>
		} while (sc != c);
  800965:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800969:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80096c:	75 d8                	jne    800946 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80096e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800972:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097a:	48 89 ce             	mov    %rcx,%rsi
  80097d:	48 89 c7             	mov    %rax,%rdi
  800980:	48 b8 f6 03 80 00 00 	movabs $0x8003f6,%rax
  800987:	00 00 00 
  80098a:	ff d0                	callq  *%rax
  80098c:	85 c0                	test   %eax,%eax
  80098e:	75 b6                	jne    800946 <strstr+0x47>

	return (char *) (in - 1);
  800990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800994:	48 83 e8 01          	sub    $0x1,%rax
}
  800998:	c9                   	leaveq 
  800999:	c3                   	retq   

000000000080099a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80099a:	55                   	push   %rbp
  80099b:	48 89 e5             	mov    %rsp,%rbp
  80099e:	53                   	push   %rbx
  80099f:	48 83 ec 48          	sub    $0x48,%rsp
  8009a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009a9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009ad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009b1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009b5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009bc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009c0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009c4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009c8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009cc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009d0:	4c 89 c3             	mov    %r8,%rbx
  8009d3:	cd 30                	int    $0x30
  8009d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8009d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009dd:	74 3e                	je     800a1d <syscall+0x83>
  8009df:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8009e4:	7e 37                	jle    800a1d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009ed:	49 89 d0             	mov    %rdx,%r8
  8009f0:	89 c1                	mov    %eax,%ecx
  8009f2:	48 ba d1 3d 80 00 00 	movabs $0x803dd1,%rdx
  8009f9:	00 00 00 
  8009fc:	be 23 00 00 00       	mov    $0x23,%esi
  800a01:	48 bf ee 3d 80 00 00 	movabs $0x803dee,%rdi
  800a08:	00 00 00 
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a10:	49 b9 7e 2d 80 00 00 	movabs $0x802d7e,%r9
  800a17:	00 00 00 
  800a1a:	41 ff d1             	callq  *%r9

	return ret;
  800a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a21:	48 83 c4 48          	add    $0x48,%rsp
  800a25:	5b                   	pop    %rbx
  800a26:	5d                   	pop    %rbp
  800a27:	c3                   	retq   

0000000000800a28 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a28:	55                   	push   %rbp
  800a29:	48 89 e5             	mov    %rsp,%rbp
  800a2c:	48 83 ec 10          	sub    $0x10,%rsp
  800a30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a40:	48 83 ec 08          	sub    $0x8,%rsp
  800a44:	6a 00                	pushq  $0x0
  800a46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a52:	48 89 d1             	mov    %rdx,%rcx
  800a55:	48 89 c2             	mov    %rax,%rdx
  800a58:	be 00 00 00 00       	mov    $0x0,%esi
  800a5d:	bf 00 00 00 00       	mov    $0x0,%edi
  800a62:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800a69:	00 00 00 
  800a6c:	ff d0                	callq  *%rax
  800a6e:	48 83 c4 10          	add    $0x10,%rsp
}
  800a72:	c9                   	leaveq 
  800a73:	c3                   	retq   

0000000000800a74 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a74:	55                   	push   %rbp
  800a75:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a78:	48 83 ec 08          	sub    $0x8,%rsp
  800a7c:	6a 00                	pushq  $0x0
  800a7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a94:	be 00 00 00 00       	mov    $0x0,%esi
  800a99:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9e:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800aa5:	00 00 00 
  800aa8:	ff d0                	callq  *%rax
  800aaa:	48 83 c4 10          	add    $0x10,%rsp
}
  800aae:	c9                   	leaveq 
  800aaf:	c3                   	retq   

0000000000800ab0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ab0:	55                   	push   %rbp
  800ab1:	48 89 e5             	mov    %rsp,%rbp
  800ab4:	48 83 ec 10          	sub    $0x10,%rsp
  800ab8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800abe:	48 98                	cltq   
  800ac0:	48 83 ec 08          	sub    $0x8,%rsp
  800ac4:	6a 00                	pushq  $0x0
  800ac6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800acc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ad2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad7:	48 89 c2             	mov    %rax,%rdx
  800ada:	be 01 00 00 00       	mov    $0x1,%esi
  800adf:	bf 03 00 00 00       	mov    $0x3,%edi
  800ae4:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800aeb:	00 00 00 
  800aee:	ff d0                	callq  *%rax
  800af0:	48 83 c4 10          	add    $0x10,%rsp
}
  800af4:	c9                   	leaveq 
  800af5:	c3                   	retq   

0000000000800af6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800af6:	55                   	push   %rbp
  800af7:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800afa:	48 83 ec 08          	sub    $0x8,%rsp
  800afe:	6a 00                	pushq  $0x0
  800b00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b11:	ba 00 00 00 00       	mov    $0x0,%edx
  800b16:	be 00 00 00 00       	mov    $0x0,%esi
  800b1b:	bf 02 00 00 00       	mov    $0x2,%edi
  800b20:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800b27:	00 00 00 
  800b2a:	ff d0                	callq  *%rax
  800b2c:	48 83 c4 10          	add    $0x10,%rsp
}
  800b30:	c9                   	leaveq 
  800b31:	c3                   	retq   

0000000000800b32 <sys_yield>:

void
sys_yield(void)
{
  800b32:	55                   	push   %rbp
  800b33:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b36:	48 83 ec 08          	sub    $0x8,%rsp
  800b3a:	6a 00                	pushq  $0x0
  800b3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	be 00 00 00 00       	mov    $0x0,%esi
  800b57:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b5c:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800b63:	00 00 00 
  800b66:	ff d0                	callq  *%rax
  800b68:	48 83 c4 10          	add    $0x10,%rsp
}
  800b6c:	c9                   	leaveq 
  800b6d:	c3                   	retq   

0000000000800b6e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b6e:	55                   	push   %rbp
  800b6f:	48 89 e5             	mov    %rsp,%rbp
  800b72:	48 83 ec 10          	sub    $0x10,%rsp
  800b76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800b7d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800b80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b83:	48 63 c8             	movslq %eax,%rcx
  800b86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b8d:	48 98                	cltq   
  800b8f:	48 83 ec 08          	sub    $0x8,%rsp
  800b93:	6a 00                	pushq  $0x0
  800b95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b9b:	49 89 c8             	mov    %rcx,%r8
  800b9e:	48 89 d1             	mov    %rdx,%rcx
  800ba1:	48 89 c2             	mov    %rax,%rdx
  800ba4:	be 01 00 00 00       	mov    $0x1,%esi
  800ba9:	bf 04 00 00 00       	mov    $0x4,%edi
  800bae:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800bb5:	00 00 00 
  800bb8:	ff d0                	callq  *%rax
  800bba:	48 83 c4 10          	add    $0x10,%rsp
}
  800bbe:	c9                   	leaveq 
  800bbf:	c3                   	retq   

0000000000800bc0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bc0:	55                   	push   %rbp
  800bc1:	48 89 e5             	mov    %rsp,%rbp
  800bc4:	48 83 ec 20          	sub    $0x20,%rsp
  800bc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bcf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800bd2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bd6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800bda:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800bdd:	48 63 c8             	movslq %eax,%rcx
  800be0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800be4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800be7:	48 63 f0             	movslq %eax,%rsi
  800bea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bf1:	48 98                	cltq   
  800bf3:	48 83 ec 08          	sub    $0x8,%rsp
  800bf7:	51                   	push   %rcx
  800bf8:	49 89 f9             	mov    %rdi,%r9
  800bfb:	49 89 f0             	mov    %rsi,%r8
  800bfe:	48 89 d1             	mov    %rdx,%rcx
  800c01:	48 89 c2             	mov    %rax,%rdx
  800c04:	be 01 00 00 00       	mov    $0x1,%esi
  800c09:	bf 05 00 00 00       	mov    $0x5,%edi
  800c0e:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800c15:	00 00 00 
  800c18:	ff d0                	callq  *%rax
  800c1a:	48 83 c4 10          	add    $0x10,%rsp
}
  800c1e:	c9                   	leaveq 
  800c1f:	c3                   	retq   

0000000000800c20 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c20:	55                   	push   %rbp
  800c21:	48 89 e5             	mov    %rsp,%rbp
  800c24:	48 83 ec 10          	sub    $0x10,%rsp
  800c28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c36:	48 98                	cltq   
  800c38:	48 83 ec 08          	sub    $0x8,%rsp
  800c3c:	6a 00                	pushq  $0x0
  800c3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c4a:	48 89 d1             	mov    %rdx,%rcx
  800c4d:	48 89 c2             	mov    %rax,%rdx
  800c50:	be 01 00 00 00       	mov    $0x1,%esi
  800c55:	bf 06 00 00 00       	mov    $0x6,%edi
  800c5a:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800c61:	00 00 00 
  800c64:	ff d0                	callq  *%rax
  800c66:	48 83 c4 10          	add    $0x10,%rsp
}
  800c6a:	c9                   	leaveq 
  800c6b:	c3                   	retq   

0000000000800c6c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c6c:	55                   	push   %rbp
  800c6d:	48 89 e5             	mov    %rsp,%rbp
  800c70:	48 83 ec 10          	sub    $0x10,%rsp
  800c74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c77:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c7d:	48 63 d0             	movslq %eax,%rdx
  800c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c83:	48 98                	cltq   
  800c85:	48 83 ec 08          	sub    $0x8,%rsp
  800c89:	6a 00                	pushq  $0x0
  800c8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c97:	48 89 d1             	mov    %rdx,%rcx
  800c9a:	48 89 c2             	mov    %rax,%rdx
  800c9d:	be 01 00 00 00       	mov    $0x1,%esi
  800ca2:	bf 08 00 00 00       	mov    $0x8,%edi
  800ca7:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800cae:	00 00 00 
  800cb1:	ff d0                	callq  *%rax
  800cb3:	48 83 c4 10          	add    $0x10,%rsp
}
  800cb7:	c9                   	leaveq 
  800cb8:	c3                   	retq   

0000000000800cb9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb9:	55                   	push   %rbp
  800cba:	48 89 e5             	mov    %rsp,%rbp
  800cbd:	48 83 ec 10          	sub    $0x10,%rsp
  800cc1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ccf:	48 98                	cltq   
  800cd1:	48 83 ec 08          	sub    $0x8,%rsp
  800cd5:	6a 00                	pushq  $0x0
  800cd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ce3:	48 89 d1             	mov    %rdx,%rcx
  800ce6:	48 89 c2             	mov    %rax,%rdx
  800ce9:	be 01 00 00 00       	mov    $0x1,%esi
  800cee:	bf 09 00 00 00       	mov    $0x9,%edi
  800cf3:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800cfa:	00 00 00 
  800cfd:	ff d0                	callq  *%rax
  800cff:	48 83 c4 10          	add    $0x10,%rsp
}
  800d03:	c9                   	leaveq 
  800d04:	c3                   	retq   

0000000000800d05 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d05:	55                   	push   %rbp
  800d06:	48 89 e5             	mov    %rsp,%rbp
  800d09:	48 83 ec 10          	sub    $0x10,%rsp
  800d0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d1b:	48 98                	cltq   
  800d1d:	48 83 ec 08          	sub    $0x8,%rsp
  800d21:	6a 00                	pushq  $0x0
  800d23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d2f:	48 89 d1             	mov    %rdx,%rcx
  800d32:	48 89 c2             	mov    %rax,%rdx
  800d35:	be 01 00 00 00       	mov    $0x1,%esi
  800d3a:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d3f:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800d46:	00 00 00 
  800d49:	ff d0                	callq  *%rax
  800d4b:	48 83 c4 10          	add    $0x10,%rsp
}
  800d4f:	c9                   	leaveq 
  800d50:	c3                   	retq   

0000000000800d51 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d51:	55                   	push   %rbp
  800d52:	48 89 e5             	mov    %rsp,%rbp
  800d55:	48 83 ec 20          	sub    $0x20,%rsp
  800d59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d60:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d64:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d6a:	48 63 f0             	movslq %eax,%rsi
  800d6d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d74:	48 98                	cltq   
  800d76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d7a:	48 83 ec 08          	sub    $0x8,%rsp
  800d7e:	6a 00                	pushq  $0x0
  800d80:	49 89 f1             	mov    %rsi,%r9
  800d83:	49 89 c8             	mov    %rcx,%r8
  800d86:	48 89 d1             	mov    %rdx,%rcx
  800d89:	48 89 c2             	mov    %rax,%rdx
  800d8c:	be 00 00 00 00       	mov    $0x0,%esi
  800d91:	bf 0c 00 00 00       	mov    $0xc,%edi
  800d96:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800d9d:	00 00 00 
  800da0:	ff d0                	callq  *%rax
  800da2:	48 83 c4 10          	add    $0x10,%rsp
}
  800da6:	c9                   	leaveq 
  800da7:	c3                   	retq   

0000000000800da8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da8:	55                   	push   %rbp
  800da9:	48 89 e5             	mov    %rsp,%rbp
  800dac:	48 83 ec 10          	sub    $0x10,%rsp
  800db0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800db8:	48 83 ec 08          	sub    $0x8,%rsp
  800dbc:	6a 00                	pushq  $0x0
  800dbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800dc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800dca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcf:	48 89 c2             	mov    %rax,%rdx
  800dd2:	be 01 00 00 00       	mov    $0x1,%esi
  800dd7:	bf 0d 00 00 00       	mov    $0xd,%edi
  800ddc:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	48 83 c4 10          	add    $0x10,%rsp
}
  800dec:	c9                   	leaveq 
  800ded:	c3                   	retq   

0000000000800dee <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dee:	55                   	push   %rbp
  800def:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800df2:	48 83 ec 08          	sub    $0x8,%rsp
  800df6:	6a 00                	pushq  $0x0
  800df8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800dfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e09:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0e:	be 00 00 00 00       	mov    $0x0,%esi
  800e13:	bf 0e 00 00 00       	mov    $0xe,%edi
  800e18:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800e1f:	00 00 00 
  800e22:	ff d0                	callq  *%rax
  800e24:	48 83 c4 10          	add    $0x10,%rsp
}
  800e28:	c9                   	leaveq 
  800e29:	c3                   	retq   

0000000000800e2a <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  800e2a:	55                   	push   %rbp
  800e2b:	48 89 e5             	mov    %rsp,%rbp
  800e2e:	48 83 ec 20          	sub    $0x20,%rsp
  800e32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e39:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800e3c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e40:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  800e44:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e47:	48 63 c8             	movslq %eax,%rcx
  800e4a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800e4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e51:	48 63 f0             	movslq %eax,%rsi
  800e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e5b:	48 98                	cltq   
  800e5d:	48 83 ec 08          	sub    $0x8,%rsp
  800e61:	51                   	push   %rcx
  800e62:	49 89 f9             	mov    %rdi,%r9
  800e65:	49 89 f0             	mov    %rsi,%r8
  800e68:	48 89 d1             	mov    %rdx,%rcx
  800e6b:	48 89 c2             	mov    %rax,%rdx
  800e6e:	be 00 00 00 00       	mov    $0x0,%esi
  800e73:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e78:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800e7f:	00 00 00 
  800e82:	ff d0                	callq  *%rax
  800e84:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  800e88:	c9                   	leaveq 
  800e89:	c3                   	retq   

0000000000800e8a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  800e8a:	55                   	push   %rbp
  800e8b:	48 89 e5             	mov    %rsp,%rbp
  800e8e:	48 83 ec 10          	sub    $0x10,%rsp
  800e92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ea2:	48 83 ec 08          	sub    $0x8,%rsp
  800ea6:	6a 00                	pushq  $0x0
  800ea8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800eae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800eb4:	48 89 d1             	mov    %rdx,%rcx
  800eb7:	48 89 c2             	mov    %rax,%rdx
  800eba:	be 00 00 00 00       	mov    $0x0,%esi
  800ebf:	bf 10 00 00 00       	mov    $0x10,%edi
  800ec4:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
  800ed0:	48 83 c4 10          	add    $0x10,%rsp
}
  800ed4:	c9                   	leaveq 
  800ed5:	c3                   	retq   

0000000000800ed6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800ed6:	55                   	push   %rbp
  800ed7:	48 89 e5             	mov    %rsp,%rbp
  800eda:	48 83 ec 08          	sub    $0x8,%rsp
  800ede:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800ee6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800eed:	ff ff ff 
  800ef0:	48 01 d0             	add    %rdx,%rax
  800ef3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800ef7:	c9                   	leaveq 
  800ef8:	c3                   	retq   

0000000000800ef9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef9:	55                   	push   %rbp
  800efa:	48 89 e5             	mov    %rsp,%rbp
  800efd:	48 83 ec 08          	sub    $0x8,%rsp
  800f01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f09:	48 89 c7             	mov    %rax,%rdi
  800f0c:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  800f13:	00 00 00 
  800f16:	ff d0                	callq  *%rax
  800f18:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f1e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f22:	c9                   	leaveq 
  800f23:	c3                   	retq   

0000000000800f24 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f24:	55                   	push   %rbp
  800f25:	48 89 e5             	mov    %rsp,%rbp
  800f28:	48 83 ec 18          	sub    $0x18,%rsp
  800f2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f37:	eb 6b                	jmp    800fa4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3c:	48 98                	cltq   
  800f3e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f44:	48 c1 e0 0c          	shl    $0xc,%rax
  800f48:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f50:	48 c1 e8 15          	shr    $0x15,%rax
  800f54:	48 89 c2             	mov    %rax,%rdx
  800f57:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f5e:	01 00 00 
  800f61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f65:	83 e0 01             	and    $0x1,%eax
  800f68:	48 85 c0             	test   %rax,%rax
  800f6b:	74 21                	je     800f8e <fd_alloc+0x6a>
  800f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f71:	48 c1 e8 0c          	shr    $0xc,%rax
  800f75:	48 89 c2             	mov    %rax,%rdx
  800f78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f7f:	01 00 00 
  800f82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f86:	83 e0 01             	and    $0x1,%eax
  800f89:	48 85 c0             	test   %rax,%rax
  800f8c:	75 12                	jne    800fa0 <fd_alloc+0x7c>
			*fd_store = fd;
  800f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f96:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800f99:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9e:	eb 1a                	jmp    800fba <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  800fa0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fa4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800fa8:	7e 8f                	jle    800f39 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  800faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fae:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800fb5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800fba:	c9                   	leaveq 
  800fbb:	c3                   	retq   

0000000000800fbc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fbc:	55                   	push   %rbp
  800fbd:	48 89 e5             	mov    %rsp,%rbp
  800fc0:	48 83 ec 20          	sub    $0x20,%rsp
  800fc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800fc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800fcf:	78 06                	js     800fd7 <fd_lookup+0x1b>
  800fd1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800fd5:	7e 07                	jle    800fde <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdc:	eb 6c                	jmp    80104a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800fde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fe1:	48 98                	cltq   
  800fe3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800fe9:	48 c1 e0 0c          	shl    $0xc,%rax
  800fed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff5:	48 c1 e8 15          	shr    $0x15,%rax
  800ff9:	48 89 c2             	mov    %rax,%rdx
  800ffc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801003:	01 00 00 
  801006:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80100a:	83 e0 01             	and    $0x1,%eax
  80100d:	48 85 c0             	test   %rax,%rax
  801010:	74 21                	je     801033 <fd_lookup+0x77>
  801012:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801016:	48 c1 e8 0c          	shr    $0xc,%rax
  80101a:	48 89 c2             	mov    %rax,%rdx
  80101d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801024:	01 00 00 
  801027:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80102b:	83 e0 01             	and    $0x1,%eax
  80102e:	48 85 c0             	test   %rax,%rax
  801031:	75 07                	jne    80103a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801033:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801038:	eb 10                	jmp    80104a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80103a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80103e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801042:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 30          	sub    $0x30,%rsp
  801054:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801058:	89 f0                	mov    %esi,%eax
  80105a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801061:	48 89 c7             	mov    %rax,%rdi
  801064:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  80106b:	00 00 00 
  80106e:	ff d0                	callq  *%rax
  801070:	89 c2                	mov    %eax,%edx
  801072:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801076:	48 89 c6             	mov    %rax,%rsi
  801079:	89 d7                	mov    %edx,%edi
  80107b:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax
  801087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80108a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108e:	78 0a                	js     80109a <fd_close+0x4e>
	    || fd != fd2)
  801090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801094:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801098:	74 12                	je     8010ac <fd_close+0x60>
		return (must_exist ? r : 0);
  80109a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80109e:	74 05                	je     8010a5 <fd_close+0x59>
  8010a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a3:	eb 70                	jmp    801115 <fd_close+0xc9>
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010aa:	eb 69                	jmp    801115 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010b0:	8b 00                	mov    (%rax),%eax
  8010b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8010b6:	48 89 d6             	mov    %rdx,%rsi
  8010b9:	89 c7                	mov    %eax,%edi
  8010bb:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  8010c2:	00 00 00 
  8010c5:	ff d0                	callq  *%rax
  8010c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010ce:	78 2a                	js     8010fa <fd_close+0xae>
		if (dev->dev_close)
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010d8:	48 85 c0             	test   %rax,%rax
  8010db:	74 16                	je     8010f3 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8010dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010e5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010e9:	48 89 d7             	mov    %rdx,%rdi
  8010ec:	ff d0                	callq  *%rax
  8010ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010f1:	eb 07                	jmp    8010fa <fd_close+0xae>
		else
			r = 0;
  8010f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010fe:	48 89 c6             	mov    %rax,%rsi
  801101:	bf 00 00 00 00       	mov    $0x0,%edi
  801106:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	return r;
  801112:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801115:	c9                   	leaveq 
  801116:	c3                   	retq   

0000000000801117 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	48 83 ec 20          	sub    $0x20,%rsp
  80111f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801122:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801126:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80112d:	eb 41                	jmp    801170 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80112f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801136:	00 00 00 
  801139:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80113c:	48 63 d2             	movslq %edx,%rdx
  80113f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801143:	8b 00                	mov    (%rax),%eax
  801145:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801148:	75 22                	jne    80116c <dev_lookup+0x55>
			*dev = devtab[i];
  80114a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801151:	00 00 00 
  801154:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801157:	48 63 d2             	movslq %edx,%rdx
  80115a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80115e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801162:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	eb 60                	jmp    8011cc <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  80116c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801170:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801177:	00 00 00 
  80117a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80117d:	48 63 d2             	movslq %edx,%rdx
  801180:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801184:	48 85 c0             	test   %rax,%rax
  801187:	75 a6                	jne    80112f <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801189:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801190:	00 00 00 
  801193:	48 8b 00             	mov    (%rax),%rax
  801196:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80119c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80119f:	89 c6                	mov    %eax,%esi
  8011a1:	48 bf 00 3e 80 00 00 	movabs $0x803e00,%rdi
  8011a8:	00 00 00 
  8011ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b0:	48 b9 b7 2f 80 00 00 	movabs $0x802fb7,%rcx
  8011b7:	00 00 00 
  8011ba:	ff d1                	callq  *%rcx
	*dev = 0;
  8011bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011cc:	c9                   	leaveq 
  8011cd:	c3                   	retq   

00000000008011ce <close>:

int
close(int fdnum)
{
  8011ce:	55                   	push   %rbp
  8011cf:	48 89 e5             	mov    %rsp,%rbp
  8011d2:	48 83 ec 20          	sub    $0x20,%rsp
  8011d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8011dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011e0:	48 89 d6             	mov    %rdx,%rsi
  8011e3:	89 c7                	mov    %eax,%edi
  8011e5:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  8011ec:	00 00 00 
  8011ef:	ff d0                	callq  *%rax
  8011f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011f8:	79 05                	jns    8011ff <close+0x31>
		return r;
  8011fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011fd:	eb 18                	jmp    801217 <close+0x49>
	else
		return fd_close(fd, 1);
  8011ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801203:	be 01 00 00 00       	mov    $0x1,%esi
  801208:	48 89 c7             	mov    %rax,%rdi
  80120b:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  801212:	00 00 00 
  801215:	ff d0                	callq  *%rax
}
  801217:	c9                   	leaveq 
  801218:	c3                   	retq   

0000000000801219 <close_all>:

void
close_all(void)
{
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801228:	eb 15                	jmp    80123f <close_all+0x26>
		close(i);
  80122a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80122d:	89 c7                	mov    %eax,%edi
  80122f:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801236:	00 00 00 
  801239:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  80123b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80123f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801243:	7e e5                	jle    80122a <close_all+0x11>
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 40          	sub    $0x40,%rsp
  80124f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801252:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801255:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801259:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80125c:	48 89 d6             	mov    %rdx,%rsi
  80125f:	89 c7                	mov    %eax,%edi
  801261:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801268:	00 00 00 
  80126b:	ff d0                	callq  *%rax
  80126d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801274:	79 08                	jns    80127e <dup+0x37>
		return r;
  801276:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801279:	e9 70 01 00 00       	jmpq   8013ee <dup+0x1a7>
	close(newfdnum);
  80127e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801281:	89 c7                	mov    %eax,%edi
  801283:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  80128a:	00 00 00 
  80128d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80128f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801292:	48 98                	cltq   
  801294:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80129a:	48 c1 e0 0c          	shl    $0xc,%rax
  80129e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8012a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a6:	48 89 c7             	mov    %rax,%rdi
  8012a9:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	callq  *%rax
  8012b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8012b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bd:	48 89 c7             	mov    %rax,%rdi
  8012c0:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  8012c7:	00 00 00 
  8012ca:	ff d0                	callq  *%rax
  8012cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d4:	48 c1 e8 15          	shr    $0x15,%rax
  8012d8:	48 89 c2             	mov    %rax,%rdx
  8012db:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8012e2:	01 00 00 
  8012e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012e9:	83 e0 01             	and    $0x1,%eax
  8012ec:	48 85 c0             	test   %rax,%rax
  8012ef:	74 73                	je     801364 <dup+0x11d>
  8012f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8012f9:	48 89 c2             	mov    %rax,%rdx
  8012fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801303:	01 00 00 
  801306:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80130a:	83 e0 01             	and    $0x1,%eax
  80130d:	48 85 c0             	test   %rax,%rax
  801310:	74 52                	je     801364 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	48 c1 e8 0c          	shr    $0xc,%rax
  80131a:	48 89 c2             	mov    %rax,%rdx
  80131d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801324:	01 00 00 
  801327:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80132b:	25 07 0e 00 00       	and    $0xe07,%eax
  801330:	89 c1                	mov    %eax,%ecx
  801332:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133a:	41 89 c8             	mov    %ecx,%r8d
  80133d:	48 89 d1             	mov    %rdx,%rcx
  801340:	ba 00 00 00 00       	mov    $0x0,%edx
  801345:	48 89 c6             	mov    %rax,%rsi
  801348:	bf 00 00 00 00       	mov    $0x0,%edi
  80134d:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  801354:	00 00 00 
  801357:	ff d0                	callq  *%rax
  801359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80135c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801360:	79 02                	jns    801364 <dup+0x11d>
			goto err;
  801362:	eb 57                	jmp    8013bb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801364:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801368:	48 c1 e8 0c          	shr    $0xc,%rax
  80136c:	48 89 c2             	mov    %rax,%rdx
  80136f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801376:	01 00 00 
  801379:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80137d:	25 07 0e 00 00       	and    $0xe07,%eax
  801382:	89 c1                	mov    %eax,%ecx
  801384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801388:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80138c:	41 89 c8             	mov    %ecx,%r8d
  80138f:	48 89 d1             	mov    %rdx,%rcx
  801392:	ba 00 00 00 00       	mov    $0x0,%edx
  801397:	48 89 c6             	mov    %rax,%rsi
  80139a:	bf 00 00 00 00       	mov    $0x0,%edi
  80139f:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  8013a6:	00 00 00 
  8013a9:	ff d0                	callq  *%rax
  8013ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013b2:	79 02                	jns    8013b6 <dup+0x16f>
		goto err;
  8013b4:	eb 05                	jmp    8013bb <dup+0x174>

	return newfdnum;
  8013b6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8013b9:	eb 33                	jmp    8013ee <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8013bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bf:	48 89 c6             	mov    %rax,%rsi
  8013c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c7:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  8013ce:	00 00 00 
  8013d1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8013d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d7:	48 89 c6             	mov    %rax,%rsi
  8013da:	bf 00 00 00 00       	mov    $0x0,%edi
  8013df:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  8013e6:	00 00 00 
  8013e9:	ff d0                	callq  *%rax
	return r;
  8013eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ee:	c9                   	leaveq 
  8013ef:	c3                   	retq   

00000000008013f0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013f0:	55                   	push   %rbp
  8013f1:	48 89 e5             	mov    %rsp,%rbp
  8013f4:	48 83 ec 40          	sub    $0x40,%rsp
  8013f8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8013fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013ff:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801403:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801407:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80140a:	48 89 d6             	mov    %rdx,%rsi
  80140d:	89 c7                	mov    %eax,%edi
  80140f:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801416:	00 00 00 
  801419:	ff d0                	callq  *%rax
  80141b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80141e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801422:	78 24                	js     801448 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801428:	8b 00                	mov    (%rax),%eax
  80142a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80142e:	48 89 d6             	mov    %rdx,%rsi
  801431:	89 c7                	mov    %eax,%edi
  801433:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  80143a:	00 00 00 
  80143d:	ff d0                	callq  *%rax
  80143f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801446:	79 05                	jns    80144d <read+0x5d>
		return r;
  801448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80144b:	eb 76                	jmp    8014c3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80144d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801451:	8b 40 08             	mov    0x8(%rax),%eax
  801454:	83 e0 03             	and    $0x3,%eax
  801457:	83 f8 01             	cmp    $0x1,%eax
  80145a:	75 3a                	jne    801496 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801463:	00 00 00 
  801466:	48 8b 00             	mov    (%rax),%rax
  801469:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80146f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801472:	89 c6                	mov    %eax,%esi
  801474:	48 bf 1f 3e 80 00 00 	movabs $0x803e1f,%rdi
  80147b:	00 00 00 
  80147e:	b8 00 00 00 00       	mov    $0x0,%eax
  801483:	48 b9 b7 2f 80 00 00 	movabs $0x802fb7,%rcx
  80148a:	00 00 00 
  80148d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80148f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801494:	eb 2d                	jmp    8014c3 <read+0xd3>
	}
	if (!dev->dev_read)
  801496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80149e:	48 85 c0             	test   %rax,%rax
  8014a1:	75 07                	jne    8014aa <read+0xba>
		return -E_NOT_SUPP;
  8014a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014a8:	eb 19                	jmp    8014c3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8014aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014b6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014ba:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8014be:	48 89 cf             	mov    %rcx,%rdi
  8014c1:	ff d0                	callq  *%rax
}
  8014c3:	c9                   	leaveq 
  8014c4:	c3                   	retq   

00000000008014c5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	48 83 ec 30          	sub    $0x30,%rsp
  8014cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014df:	eb 49                	jmp    80152a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e4:	48 98                	cltq   
  8014e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014ea:	48 29 c2             	sub    %rax,%rdx
  8014ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014f0:	48 63 c8             	movslq %eax,%rcx
  8014f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f7:	48 01 c1             	add    %rax,%rcx
  8014fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014fd:	48 89 ce             	mov    %rcx,%rsi
  801500:	89 c7                	mov    %eax,%edi
  801502:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  801509:	00 00 00 
  80150c:	ff d0                	callq  *%rax
  80150e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801511:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801515:	79 05                	jns    80151c <readn+0x57>
			return m;
  801517:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80151a:	eb 1c                	jmp    801538 <readn+0x73>
		if (m == 0)
  80151c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801520:	75 02                	jne    801524 <readn+0x5f>
			break;
  801522:	eb 11                	jmp    801535 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  801524:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801527:	01 45 fc             	add    %eax,-0x4(%rbp)
  80152a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80152d:	48 98                	cltq   
  80152f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801533:	72 ac                	jb     8014e1 <readn+0x1c>
	}
	return tot;
  801535:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	48 83 ec 40          	sub    $0x40,%rsp
  801542:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801545:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801549:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801551:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801554:	48 89 d6             	mov    %rdx,%rsi
  801557:	89 c7                	mov    %eax,%edi
  801559:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801560:	00 00 00 
  801563:	ff d0                	callq  *%rax
  801565:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80156c:	78 24                	js     801592 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801572:	8b 00                	mov    (%rax),%eax
  801574:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801578:	48 89 d6             	mov    %rdx,%rsi
  80157b:	89 c7                	mov    %eax,%edi
  80157d:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  801584:	00 00 00 
  801587:	ff d0                	callq  *%rax
  801589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80158c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801590:	79 05                	jns    801597 <write+0x5d>
		return r;
  801592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801595:	eb 75                	jmp    80160c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159b:	8b 40 08             	mov    0x8(%rax),%eax
  80159e:	83 e0 03             	and    $0x3,%eax
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	75 3a                	jne    8015df <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8015ac:	00 00 00 
  8015af:	48 8b 00             	mov    (%rax),%rax
  8015b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8015b8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8015bb:	89 c6                	mov    %eax,%esi
  8015bd:	48 bf 3b 3e 80 00 00 	movabs $0x803e3b,%rdi
  8015c4:	00 00 00 
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cc:	48 b9 b7 2f 80 00 00 	movabs $0x802fb7,%rcx
  8015d3:	00 00 00 
  8015d6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8015d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015dd:	eb 2d                	jmp    80160c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015e7:	48 85 c0             	test   %rax,%rax
  8015ea:	75 07                	jne    8015f3 <write+0xb9>
		return -E_NOT_SUPP;
  8015ec:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8015f1:	eb 19                	jmp    80160c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8015f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015fb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801603:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801607:	48 89 cf             	mov    %rcx,%rdi
  80160a:	ff d0                	callq  *%rax
}
  80160c:	c9                   	leaveq 
  80160d:	c3                   	retq   

000000000080160e <seek>:

int
seek(int fdnum, off_t offset)
{
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
  801612:	48 83 ec 18          	sub    $0x18,%rsp
  801616:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801619:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80161c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801620:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801623:	48 89 d6             	mov    %rdx,%rsi
  801626:	89 c7                	mov    %eax,%edi
  801628:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  80162f:	00 00 00 
  801632:	ff d0                	callq  *%rax
  801634:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80163b:	79 05                	jns    801642 <seek+0x34>
		return r;
  80163d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801640:	eb 0f                	jmp    801651 <seek+0x43>
	fd->fd_offset = offset;
  801642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801646:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801649:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801651:	c9                   	leaveq 
  801652:	c3                   	retq   

0000000000801653 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801653:	55                   	push   %rbp
  801654:	48 89 e5             	mov    %rsp,%rbp
  801657:	48 83 ec 30          	sub    $0x30,%rsp
  80165b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80165e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801661:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801665:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801668:	48 89 d6             	mov    %rdx,%rsi
  80166b:	89 c7                	mov    %eax,%edi
  80166d:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801674:	00 00 00 
  801677:	ff d0                	callq  *%rax
  801679:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80167c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801680:	78 24                	js     8016a6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801686:	8b 00                	mov    (%rax),%eax
  801688:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80168c:	48 89 d6             	mov    %rdx,%rsi
  80168f:	89 c7                	mov    %eax,%edi
  801691:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  801698:	00 00 00 
  80169b:	ff d0                	callq  *%rax
  80169d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a4:	79 05                	jns    8016ab <ftruncate+0x58>
		return r;
  8016a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a9:	eb 72                	jmp    80171d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016af:	8b 40 08             	mov    0x8(%rax),%eax
  8016b2:	83 e0 03             	and    $0x3,%eax
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	75 3a                	jne    8016f3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8016c0:	00 00 00 
  8016c3:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8016cc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016cf:	89 c6                	mov    %eax,%esi
  8016d1:	48 bf 58 3e 80 00 00 	movabs $0x803e58,%rdi
  8016d8:	00 00 00 
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e0:	48 b9 b7 2f 80 00 00 	movabs $0x802fb7,%rcx
  8016e7:	00 00 00 
  8016ea:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8016ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f1:	eb 2a                	jmp    80171d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8016fb:	48 85 c0             	test   %rax,%rax
  8016fe:	75 07                	jne    801707 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801700:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801705:	eb 16                	jmp    80171d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  801707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80170f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801713:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  801716:	89 ce                	mov    %ecx,%esi
  801718:	48 89 d7             	mov    %rdx,%rdi
  80171b:	ff d0                	callq  *%rax
}
  80171d:	c9                   	leaveq 
  80171e:	c3                   	retq   

000000000080171f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80171f:	55                   	push   %rbp
  801720:	48 89 e5             	mov    %rsp,%rbp
  801723:	48 83 ec 30          	sub    $0x30,%rsp
  801727:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80172a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801732:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801735:	48 89 d6             	mov    %rdx,%rsi
  801738:	89 c7                	mov    %eax,%edi
  80173a:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801741:	00 00 00 
  801744:	ff d0                	callq  *%rax
  801746:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801749:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80174d:	78 24                	js     801773 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801753:	8b 00                	mov    (%rax),%eax
  801755:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801759:	48 89 d6             	mov    %rdx,%rsi
  80175c:	89 c7                	mov    %eax,%edi
  80175e:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
  80176a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80176d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801771:	79 05                	jns    801778 <fstat+0x59>
		return r;
  801773:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801776:	eb 5e                	jmp    8017d6 <fstat+0xb7>
	if (!dev->dev_stat)
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177c:	48 8b 40 28          	mov    0x28(%rax),%rax
  801780:	48 85 c0             	test   %rax,%rax
  801783:	75 07                	jne    80178c <fstat+0x6d>
		return -E_NOT_SUPP;
  801785:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80178a:	eb 4a                	jmp    8017d6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80178c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801790:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  801793:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801797:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80179e:	00 00 00 
	stat->st_isdir = 0;
  8017a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8017ac:	00 00 00 
	stat->st_dev = dev;
  8017af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8017be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8017c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ca:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ce:	48 89 ce             	mov    %rcx,%rsi
  8017d1:	48 89 d7             	mov    %rdx,%rdi
  8017d4:	ff d0                	callq  *%rax
}
  8017d6:	c9                   	leaveq 
  8017d7:	c3                   	retq   

00000000008017d8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017d8:	55                   	push   %rbp
  8017d9:	48 89 e5             	mov    %rsp,%rbp
  8017dc:	48 83 ec 20          	sub    $0x20,%rsp
  8017e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ec:	be 00 00 00 00       	mov    $0x0,%esi
  8017f1:	48 89 c7             	mov    %rax,%rdi
  8017f4:	48 b8 c8 18 80 00 00 	movabs $0x8018c8,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	callq  *%rax
  801800:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801803:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801807:	79 05                	jns    80180e <stat+0x36>
		return fd;
  801809:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180c:	eb 2f                	jmp    80183d <stat+0x65>
	r = fstat(fd, stat);
  80180e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801815:	48 89 d6             	mov    %rdx,%rsi
  801818:	89 c7                	mov    %eax,%edi
  80181a:	48 b8 1f 17 80 00 00 	movabs $0x80171f,%rax
  801821:	00 00 00 
  801824:	ff d0                	callq  *%rax
  801826:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801829:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182c:	89 c7                	mov    %eax,%edi
  80182e:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801835:	00 00 00 
  801838:	ff d0                	callq  *%rax
	return r;
  80183a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80183d:	c9                   	leaveq 
  80183e:	c3                   	retq   

000000000080183f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 10          	sub    $0x10,%rsp
  801847:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80184a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80184e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801855:	00 00 00 
  801858:	8b 00                	mov    (%rax),%eax
  80185a:	85 c0                	test   %eax,%eax
  80185c:	75 1f                	jne    80187d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80185e:	bf 01 00 00 00       	mov    $0x1,%edi
  801863:	48 b8 b0 3c 80 00 00 	movabs $0x803cb0,%rax
  80186a:	00 00 00 
  80186d:	ff d0                	callq  *%rax
  80186f:	89 c2                	mov    %eax,%edx
  801871:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801878:	00 00 00 
  80187b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80187d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801884:	00 00 00 
  801887:	8b 00                	mov    (%rax),%eax
  801889:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80188c:	b9 07 00 00 00       	mov    $0x7,%ecx
  801891:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801898:	00 00 00 
  80189b:	89 c7                	mov    %eax,%edi
  80189d:	48 b8 23 3b 80 00 00 	movabs $0x803b23,%rax
  8018a4:	00 00 00 
  8018a7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8018a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	48 89 c6             	mov    %rax,%rsi
  8018b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ba:	48 b8 e5 3a 80 00 00 	movabs $0x803ae5,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
}
  8018c6:	c9                   	leaveq 
  8018c7:	c3                   	retq   

00000000008018c8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018c8:	55                   	push   %rbp
  8018c9:	48 89 e5             	mov    %rsp,%rbp
  8018cc:	48 83 ec 10          	sub    $0x10,%rsp
  8018d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8018d7:	48 ba 7e 3e 80 00 00 	movabs $0x803e7e,%rdx
  8018de:	00 00 00 
  8018e1:	be 4c 00 00 00       	mov    $0x4c,%esi
  8018e6:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  8018ed:	00 00 00 
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f5:	48 b9 7e 2d 80 00 00 	movabs $0x802d7e,%rcx
  8018fc:	00 00 00 
  8018ff:	ff d1                	callq  *%rcx

0000000000801901 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801901:	55                   	push   %rbp
  801902:	48 89 e5             	mov    %rsp,%rbp
  801905:	48 83 ec 10          	sub    $0x10,%rsp
  801909:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80190d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801911:	8b 50 0c             	mov    0xc(%rax),%edx
  801914:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80191b:	00 00 00 
  80191e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801920:	be 00 00 00 00       	mov    $0x0,%esi
  801925:	bf 06 00 00 00       	mov    $0x6,%edi
  80192a:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801931:	00 00 00 
  801934:	ff d0                	callq  *%rax
}
  801936:	c9                   	leaveq 
  801937:	c3                   	retq   

0000000000801938 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801938:	55                   	push   %rbp
  801939:	48 89 e5             	mov    %rsp,%rbp
  80193c:	48 83 ec 20          	sub    $0x20,%rsp
  801940:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801944:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801948:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  80194c:	48 ba 9e 3e 80 00 00 	movabs $0x803e9e,%rdx
  801953:	00 00 00 
  801956:	be 6b 00 00 00       	mov    $0x6b,%esi
  80195b:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  801962:	00 00 00 
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
  80196a:	48 b9 7e 2d 80 00 00 	movabs $0x802d7e,%rcx
  801971:	00 00 00 
  801974:	ff d1                	callq  *%rcx

0000000000801976 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801976:	55                   	push   %rbp
  801977:	48 89 e5             	mov    %rsp,%rbp
  80197a:	48 83 ec 20          	sub    $0x20,%rsp
  80197e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801982:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801986:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  80198a:	48 ba bb 3e 80 00 00 	movabs $0x803ebb,%rdx
  801991:	00 00 00 
  801994:	be 7b 00 00 00       	mov    $0x7b,%esi
  801999:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  8019a0:	00 00 00 
  8019a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a8:	48 b9 7e 2d 80 00 00 	movabs $0x802d7e,%rcx
  8019af:	00 00 00 
  8019b2:	ff d1                	callq  *%rcx

00000000008019b4 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
  8019b8:	48 83 ec 20          	sub    $0x20,%rsp
  8019bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c8:	8b 50 0c             	mov    0xc(%rax),%edx
  8019cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8019d2:	00 00 00 
  8019d5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d7:	be 00 00 00 00       	mov    $0x0,%esi
  8019dc:	bf 05 00 00 00       	mov    $0x5,%edi
  8019e1:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	callq  *%rax
  8019ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019f4:	79 05                	jns    8019fb <devfile_stat+0x47>
		return r;
  8019f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f9:	eb 56                	jmp    801a51 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019ff:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801a06:	00 00 00 
  801a09:	48 89 c7             	mov    %rax,%rdi
  801a0c:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  801a13:	00 00 00 
  801a16:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801a18:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a1f:	00 00 00 
  801a22:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801a28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a2c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a32:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a39:	00 00 00 
  801a3c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801a42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a46:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
  801a57:	48 83 ec 10          	sub    $0x10,%rsp
  801a5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a5f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a66:	8b 50 0c             	mov    0xc(%rax),%edx
  801a69:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a70:	00 00 00 
  801a73:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801a75:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a7c:	00 00 00 
  801a7f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801a82:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a85:	be 00 00 00 00       	mov    $0x0,%esi
  801a8a:	bf 02 00 00 00       	mov    $0x2,%edi
  801a8f:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <remove>:

// Delete a file
int
remove(const char *path)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 10          	sub    $0x10,%rsp
  801aa5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801aa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aad:	48 89 c7             	mov    %rax,%rdi
  801ab0:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	callq  *%rax
  801abc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ac1:	7e 07                	jle    801aca <remove+0x2d>
		return -E_BAD_PATH;
  801ac3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801ac8:	eb 33                	jmp    801afd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801aca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ace:	48 89 c6             	mov    %rax,%rsi
  801ad1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801ad8:	00 00 00 
  801adb:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  801ae2:	00 00 00 
  801ae5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801ae7:	be 00 00 00 00       	mov    $0x0,%esi
  801aec:	bf 07 00 00 00       	mov    $0x7,%edi
  801af1:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801af8:	00 00 00 
  801afb:	ff d0                	callq  *%rax
}
  801afd:	c9                   	leaveq 
  801afe:	c3                   	retq   

0000000000801aff <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b03:	be 00 00 00 00       	mov    $0x0,%esi
  801b08:	bf 08 00 00 00       	mov    $0x8,%edi
  801b0d:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
}
  801b19:	5d                   	pop    %rbp
  801b1a:	c3                   	retq   

0000000000801b1b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801b26:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801b2d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801b34:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801b3b:	be 00 00 00 00       	mov    $0x0,%esi
  801b40:	48 89 c7             	mov    %rax,%rdi
  801b43:	48 b8 c8 18 80 00 00 	movabs $0x8018c8,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
  801b4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801b52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b56:	79 28                	jns    801b80 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5b:	89 c6                	mov    %eax,%esi
  801b5d:	48 bf d9 3e 80 00 00 	movabs $0x803ed9,%rdi
  801b64:	00 00 00 
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6c:	48 ba b7 2f 80 00 00 	movabs $0x802fb7,%rdx
  801b73:	00 00 00 
  801b76:	ff d2                	callq  *%rdx
		return fd_src;
  801b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7b:	e9 74 01 00 00       	jmpq   801cf4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801b80:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801b87:	be 01 01 00 00       	mov    $0x101,%esi
  801b8c:	48 89 c7             	mov    %rax,%rdi
  801b8f:	48 b8 c8 18 80 00 00 	movabs $0x8018c8,%rax
  801b96:	00 00 00 
  801b99:	ff d0                	callq  *%rax
  801b9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801b9e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ba2:	79 39                	jns    801bdd <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801ba4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba7:	89 c6                	mov    %eax,%esi
  801ba9:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  801bb0:	00 00 00 
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	48 ba b7 2f 80 00 00 	movabs $0x802fb7,%rdx
  801bbf:	00 00 00 
  801bc2:	ff d2                	callq  *%rdx
		close(fd_src);
  801bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc7:	89 c7                	mov    %eax,%edi
  801bc9:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
		return fd_dest;
  801bd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd8:	e9 17 01 00 00       	jmpq   801cf4 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801bdd:	eb 74                	jmp    801c53 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801bdf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be2:	48 63 d0             	movslq %eax,%rdx
  801be5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801bec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bef:	48 89 ce             	mov    %rcx,%rsi
  801bf2:	89 c7                	mov    %eax,%edi
  801bf4:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
  801c00:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801c03:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c07:	79 4a                	jns    801c53 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801c09:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c0c:	89 c6                	mov    %eax,%esi
  801c0e:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
  801c15:	00 00 00 
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1d:	48 ba b7 2f 80 00 00 	movabs $0x802fb7,%rdx
  801c24:	00 00 00 
  801c27:	ff d2                	callq  *%rdx
			close(fd_src);
  801c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2c:	89 c7                	mov    %eax,%edi
  801c2e:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
			close(fd_dest);
  801c3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c3d:	89 c7                	mov    %eax,%edi
  801c3f:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	callq  *%rax
			return write_size;
  801c4b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c4e:	e9 a1 00 00 00       	jmpq   801cf4 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801c53:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801c5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5d:	ba 00 02 00 00       	mov    $0x200,%edx
  801c62:	48 89 ce             	mov    %rcx,%rsi
  801c65:	89 c7                	mov    %eax,%edi
  801c67:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	callq  *%rax
  801c73:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801c7a:	0f 8f 5f ff ff ff    	jg     801bdf <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  801c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801c84:	79 47                	jns    801ccd <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801c86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c89:	89 c6                	mov    %eax,%esi
  801c8b:	48 bf 1c 3f 80 00 00 	movabs $0x803f1c,%rdi
  801c92:	00 00 00 
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9a:	48 ba b7 2f 80 00 00 	movabs $0x802fb7,%rdx
  801ca1:	00 00 00 
  801ca4:	ff d2                	callq  *%rdx
		close(fd_src);
  801ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca9:	89 c7                	mov    %eax,%edi
  801cab:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801cb2:	00 00 00 
  801cb5:	ff d0                	callq  *%rax
		close(fd_dest);
  801cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cba:	89 c7                	mov    %eax,%edi
  801cbc:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
		return read_size;
  801cc8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ccb:	eb 27                	jmp    801cf4 <copy+0x1d9>
	}
	close(fd_src);
  801ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd0:	89 c7                	mov    %eax,%edi
  801cd2:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
	close(fd_dest);
  801cde:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce1:	89 c7                	mov    %eax,%edi
  801ce3:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  801cea:	00 00 00 
  801ced:	ff d0                	callq  *%rax
	return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801cf4:	c9                   	leaveq 
  801cf5:	c3                   	retq   

0000000000801cf6 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	48 83 ec 20          	sub    $0x20,%rsp
  801cfe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d08:	48 89 d6             	mov    %rdx,%rsi
  801d0b:	89 c7                	mov    %eax,%edi
  801d0d:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	callq  *%rax
  801d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d20:	79 05                	jns    801d27 <fd2sockid+0x31>
		return r;
  801d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d25:	eb 24                	jmp    801d4b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2b:	8b 10                	mov    (%rax),%edx
  801d2d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801d34:	00 00 00 
  801d37:	8b 00                	mov    (%rax),%eax
  801d39:	39 c2                	cmp    %eax,%edx
  801d3b:	74 07                	je     801d44 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801d3d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801d42:	eb 07                	jmp    801d4b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d48:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801d4b:	c9                   	leaveq 
  801d4c:	c3                   	retq   

0000000000801d4d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d4d:	55                   	push   %rbp
  801d4e:	48 89 e5             	mov    %rsp,%rbp
  801d51:	48 83 ec 20          	sub    $0x20,%rsp
  801d55:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d58:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801d5c:	48 89 c7             	mov    %rax,%rdi
  801d5f:	48 b8 24 0f 80 00 00 	movabs $0x800f24,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	callq  *%rax
  801d6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d72:	78 26                	js     801d9a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d78:	ba 07 04 00 00       	mov    $0x407,%edx
  801d7d:	48 89 c6             	mov    %rax,%rsi
  801d80:	bf 00 00 00 00       	mov    $0x0,%edi
  801d85:	48 b8 6e 0b 80 00 00 	movabs $0x800b6e,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	callq  *%rax
  801d91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d98:	79 16                	jns    801db0 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801d9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d9d:	89 c7                	mov    %eax,%edi
  801d9f:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
		return r;
  801dab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dae:	eb 3a                	jmp    801dea <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db4:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801dbb:	00 00 00 
  801dbe:	8b 12                	mov    (%rdx),%edx
  801dc0:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dd1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dd4:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddb:	48 89 c7             	mov    %rax,%rdi
  801dde:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 30          	sub    $0x30,%rsp
  801df4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801df7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801dfb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e02:	89 c7                	mov    %eax,%edi
  801e04:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801e0b:	00 00 00 
  801e0e:	ff d0                	callq  *%rax
  801e10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e17:	79 05                	jns    801e1e <accept+0x32>
		return r;
  801e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1c:	eb 3b                	jmp    801e59 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e1e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e22:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801e26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e29:	48 89 ce             	mov    %rcx,%rsi
  801e2c:	89 c7                	mov    %eax,%edi
  801e2e:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  801e35:	00 00 00 
  801e38:	ff d0                	callq  *%rax
  801e3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e41:	79 05                	jns    801e48 <accept+0x5c>
		return r;
  801e43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e46:	eb 11                	jmp    801e59 <accept+0x6d>
	return alloc_sockfd(r);
  801e48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4b:	89 c7                	mov    %eax,%edi
  801e4d:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	48 83 ec 20          	sub    $0x20,%rsp
  801e63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e6a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e70:	89 c7                	mov    %eax,%edi
  801e72:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	callq  *%rax
  801e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e85:	79 05                	jns    801e8c <bind+0x31>
		return r;
  801e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8a:	eb 1b                	jmp    801ea7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801e8c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e8f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e96:	48 89 ce             	mov    %rcx,%rsi
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
}
  801ea7:	c9                   	leaveq 
  801ea8:	c3                   	retq   

0000000000801ea9 <shutdown>:

int
shutdown(int s, int how)
{
  801ea9:	55                   	push   %rbp
  801eaa:	48 89 e5             	mov    %rsp,%rbp
  801ead:	48 83 ec 20          	sub    $0x20,%rsp
  801eb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eb4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eba:	89 c7                	mov    %eax,%edi
  801ebc:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
  801ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ecf:	79 05                	jns    801ed6 <shutdown+0x2d>
		return r;
  801ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed4:	eb 16                	jmp    801eec <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801ed6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edc:	89 d6                	mov    %edx,%esi
  801ede:	89 c7                	mov    %eax,%edi
  801ee0:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	callq  *%rax
}
  801eec:	c9                   	leaveq 
  801eed:	c3                   	retq   

0000000000801eee <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801eee:	55                   	push   %rbp
  801eef:	48 89 e5             	mov    %rsp,%rbp
  801ef2:	48 83 ec 10          	sub    $0x10,%rsp
  801ef6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efe:	48 89 c7             	mov    %rax,%rdi
  801f01:	48 b8 22 3d 80 00 00 	movabs $0x803d22,%rax
  801f08:	00 00 00 
  801f0b:	ff d0                	callq  *%rax
  801f0d:	83 f8 01             	cmp    $0x1,%eax
  801f10:	75 17                	jne    801f29 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f16:	8b 40 0c             	mov    0xc(%rax),%eax
  801f19:	89 c7                	mov    %eax,%edi
  801f1b:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
  801f27:	eb 05                	jmp    801f2e <devsock_close+0x40>
	else
		return 0;
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2e:	c9                   	leaveq 
  801f2f:	c3                   	retq   

0000000000801f30 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f30:	55                   	push   %rbp
  801f31:	48 89 e5             	mov    %rsp,%rbp
  801f34:	48 83 ec 20          	sub    $0x20,%rsp
  801f38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f3f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f45:	89 c7                	mov    %eax,%edi
  801f47:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	callq  *%rax
  801f53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f5a:	79 05                	jns    801f61 <connect+0x31>
		return r;
  801f5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f5f:	eb 1b                	jmp    801f7c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  801f61:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f64:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6b:	48 89 ce             	mov    %rcx,%rsi
  801f6e:	89 c7                	mov    %eax,%edi
  801f70:	48 b8 89 22 80 00 00 	movabs $0x802289,%rax
  801f77:	00 00 00 
  801f7a:	ff d0                	callq  *%rax
}
  801f7c:	c9                   	leaveq 
  801f7d:	c3                   	retq   

0000000000801f7e <listen>:

int
listen(int s, int backlog)
{
  801f7e:	55                   	push   %rbp
  801f7f:	48 89 e5             	mov    %rsp,%rbp
  801f82:	48 83 ec 20          	sub    $0x20,%rsp
  801f86:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f89:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f8f:	89 c7                	mov    %eax,%edi
  801f91:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801f98:	00 00 00 
  801f9b:	ff d0                	callq  *%rax
  801f9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa4:	79 05                	jns    801fab <listen+0x2d>
		return r;
  801fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa9:	eb 16                	jmp    801fc1 <listen+0x43>
	return nsipc_listen(r, backlog);
  801fab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb1:	89 d6                	mov    %edx,%esi
  801fb3:	89 c7                	mov    %eax,%edi
  801fb5:	48 b8 ed 22 80 00 00 	movabs $0x8022ed,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 20          	sub    $0x20,%rsp
  801fcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdb:	89 c2                	mov    %eax,%edx
  801fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe1:	8b 40 0c             	mov    0xc(%rax),%eax
  801fe4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801fe8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fed:	89 c7                	mov    %eax,%edi
  801fef:	48 b8 2d 23 80 00 00 	movabs $0x80232d,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
}
  801ffb:	c9                   	leaveq 
  801ffc:	c3                   	retq   

0000000000801ffd <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ffd:	55                   	push   %rbp
  801ffe:	48 89 e5             	mov    %rsp,%rbp
  802001:	48 83 ec 20          	sub    $0x20,%rsp
  802005:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802009:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80200d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802015:	89 c2                	mov    %eax,%edx
  802017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201b:	8b 40 0c             	mov    0xc(%rax),%eax
  80201e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802022:	b9 00 00 00 00       	mov    $0x0,%ecx
  802027:	89 c7                	mov    %eax,%edi
  802029:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802030:	00 00 00 
  802033:	ff d0                	callq  *%rax
}
  802035:	c9                   	leaveq 
  802036:	c3                   	retq   

0000000000802037 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802037:	55                   	push   %rbp
  802038:	48 89 e5             	mov    %rsp,%rbp
  80203b:	48 83 ec 10          	sub    $0x10,%rsp
  80203f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802043:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204b:	48 be 37 3f 80 00 00 	movabs $0x803f37,%rsi
  802052:	00 00 00 
  802055:	48 89 c7             	mov    %rax,%rdi
  802058:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  80205f:	00 00 00 
  802062:	ff d0                	callq  *%rax
	return 0;
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802069:	c9                   	leaveq 
  80206a:	c3                   	retq   

000000000080206b <socket>:

int
socket(int domain, int type, int protocol)
{
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
  80206f:	48 83 ec 20          	sub    $0x20,%rsp
  802073:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802076:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802079:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80207c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80207f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802082:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802085:	89 ce                	mov    %ecx,%esi
  802087:	89 c7                	mov    %eax,%edi
  802089:	48 b8 b1 24 80 00 00 	movabs $0x8024b1,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax
  802095:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802098:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80209c:	79 05                	jns    8020a3 <socket+0x38>
		return r;
  80209e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a1:	eb 11                	jmp    8020b4 <socket+0x49>
	return alloc_sockfd(r);
  8020a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a6:	89 c7                	mov    %eax,%edi
  8020a8:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  8020af:	00 00 00 
  8020b2:	ff d0                	callq  *%rax
}
  8020b4:	c9                   	leaveq 
  8020b5:	c3                   	retq   

00000000008020b6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020b6:	55                   	push   %rbp
  8020b7:	48 89 e5             	mov    %rsp,%rbp
  8020ba:	48 83 ec 10          	sub    $0x10,%rsp
  8020be:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8020c1:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8020c8:	00 00 00 
  8020cb:	8b 00                	mov    (%rax),%eax
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	75 1f                	jne    8020f0 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020d1:	bf 02 00 00 00       	mov    $0x2,%edi
  8020d6:	48 b8 b0 3c 80 00 00 	movabs $0x803cb0,%rax
  8020dd:	00 00 00 
  8020e0:	ff d0                	callq  *%rax
  8020e2:	89 c2                	mov    %eax,%edx
  8020e4:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8020eb:	00 00 00 
  8020ee:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020f0:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8020f7:	00 00 00 
  8020fa:	8b 00                	mov    (%rax),%eax
  8020fc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ff:	b9 07 00 00 00       	mov    $0x7,%ecx
  802104:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80210b:	00 00 00 
  80210e:	89 c7                	mov    %eax,%edi
  802110:	48 b8 23 3b 80 00 00 	movabs $0x803b23,%rax
  802117:	00 00 00 
  80211a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80211c:	ba 00 00 00 00       	mov    $0x0,%edx
  802121:	be 00 00 00 00       	mov    $0x0,%esi
  802126:	bf 00 00 00 00       	mov    $0x0,%edi
  80212b:	48 b8 e5 3a 80 00 00 	movabs $0x803ae5,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
}
  802137:	c9                   	leaveq 
  802138:	c3                   	retq   

0000000000802139 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
  80213d:	48 83 ec 30          	sub    $0x30,%rsp
  802141:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802144:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802148:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80214c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802153:	00 00 00 
  802156:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802159:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80215b:	bf 01 00 00 00       	mov    $0x1,%edi
  802160:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802167:	00 00 00 
  80216a:	ff d0                	callq  *%rax
  80216c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80216f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802173:	78 3e                	js     8021b3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802175:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80217c:	00 00 00 
  80217f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802187:	8b 40 10             	mov    0x10(%rax),%eax
  80218a:	89 c2                	mov    %eax,%edx
  80218c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802190:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802194:	48 89 ce             	mov    %rcx,%rsi
  802197:	48 89 c7             	mov    %rax,%rdi
  80219a:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8021a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021aa:	8b 50 10             	mov    0x10(%rax),%edx
  8021ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8021b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021b6:	c9                   	leaveq 
  8021b7:	c3                   	retq   

00000000008021b8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021b8:	55                   	push   %rbp
  8021b9:	48 89 e5             	mov    %rsp,%rbp
  8021bc:	48 83 ec 10          	sub    $0x10,%rsp
  8021c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021c7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8021ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8021d1:	00 00 00 
  8021d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021d7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021d9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8021dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e0:	48 89 c6             	mov    %rax,%rsi
  8021e3:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8021ea:	00 00 00 
  8021ed:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8021f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802200:	00 00 00 
  802203:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802206:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802209:	bf 02 00 00 00       	mov    $0x2,%edi
  80220e:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
}
  80221a:	c9                   	leaveq 
  80221b:	c3                   	retq   

000000000080221c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80221c:	55                   	push   %rbp
  80221d:	48 89 e5             	mov    %rsp,%rbp
  802220:	48 83 ec 10          	sub    $0x10,%rsp
  802224:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802227:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80222a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802231:	00 00 00 
  802234:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802237:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802239:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802240:	00 00 00 
  802243:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802246:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802249:	bf 03 00 00 00       	mov    $0x3,%edi
  80224e:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
}
  80225a:	c9                   	leaveq 
  80225b:	c3                   	retq   

000000000080225c <nsipc_close>:

int
nsipc_close(int s)
{
  80225c:	55                   	push   %rbp
  80225d:	48 89 e5             	mov    %rsp,%rbp
  802260:	48 83 ec 10          	sub    $0x10,%rsp
  802264:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802267:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80226e:	00 00 00 
  802271:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802274:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802276:	bf 04 00 00 00       	mov    $0x4,%edi
  80227b:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802282:	00 00 00 
  802285:	ff d0                	callq  *%rax
}
  802287:	c9                   	leaveq 
  802288:	c3                   	retq   

0000000000802289 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802289:	55                   	push   %rbp
  80228a:	48 89 e5             	mov    %rsp,%rbp
  80228d:	48 83 ec 10          	sub    $0x10,%rsp
  802291:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802294:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802298:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80229b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022a2:	00 00 00 
  8022a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022a8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022aa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b1:	48 89 c6             	mov    %rax,%rsi
  8022b4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8022bb:	00 00 00 
  8022be:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8022ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022d1:	00 00 00 
  8022d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022d7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8022da:	bf 05 00 00 00       	mov    $0x5,%edi
  8022df:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  8022e6:	00 00 00 
  8022e9:	ff d0                	callq  *%rax
}
  8022eb:	c9                   	leaveq 
  8022ec:	c3                   	retq   

00000000008022ed <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022ed:	55                   	push   %rbp
  8022ee:	48 89 e5             	mov    %rsp,%rbp
  8022f1:	48 83 ec 10          	sub    $0x10,%rsp
  8022f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8022fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802302:	00 00 00 
  802305:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802308:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80230a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802311:	00 00 00 
  802314:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802317:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80231a:	bf 06 00 00 00       	mov    $0x6,%edi
  80231f:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802326:	00 00 00 
  802329:	ff d0                	callq  *%rax
}
  80232b:	c9                   	leaveq 
  80232c:	c3                   	retq   

000000000080232d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80232d:	55                   	push   %rbp
  80232e:	48 89 e5             	mov    %rsp,%rbp
  802331:	48 83 ec 30          	sub    $0x30,%rsp
  802335:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802338:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80233c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80233f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802342:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802349:	00 00 00 
  80234c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80234f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802351:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802358:	00 00 00 
  80235b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80235e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802361:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802368:	00 00 00 
  80236b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80236e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802371:	bf 07 00 00 00       	mov    $0x7,%edi
  802376:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  80237d:	00 00 00 
  802380:	ff d0                	callq  *%rax
  802382:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802385:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802389:	78 69                	js     8023f4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80238b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802392:	7f 08                	jg     80239c <nsipc_recv+0x6f>
  802394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802397:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80239a:	7e 35                	jle    8023d1 <nsipc_recv+0xa4>
  80239c:	48 b9 3e 3f 80 00 00 	movabs $0x803f3e,%rcx
  8023a3:	00 00 00 
  8023a6:	48 ba 53 3f 80 00 00 	movabs $0x803f53,%rdx
  8023ad:	00 00 00 
  8023b0:	be 61 00 00 00       	mov    $0x61,%esi
  8023b5:	48 bf 68 3f 80 00 00 	movabs $0x803f68,%rdi
  8023bc:	00 00 00 
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c4:	49 b8 7e 2d 80 00 00 	movabs $0x802d7e,%r8
  8023cb:	00 00 00 
  8023ce:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d4:	48 63 d0             	movslq %eax,%rdx
  8023d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023db:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8023e2:	00 00 00 
  8023e5:	48 89 c7             	mov    %rax,%rdi
  8023e8:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8023ef:	00 00 00 
  8023f2:	ff d0                	callq  *%rax
	}

	return r;
  8023f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023f7:	c9                   	leaveq 
  8023f8:	c3                   	retq   

00000000008023f9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023f9:	55                   	push   %rbp
  8023fa:	48 89 e5             	mov    %rsp,%rbp
  8023fd:	48 83 ec 20          	sub    $0x20,%rsp
  802401:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802404:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802408:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80240b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80240e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802415:	00 00 00 
  802418:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80241b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80241d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802424:	7e 35                	jle    80245b <nsipc_send+0x62>
  802426:	48 b9 74 3f 80 00 00 	movabs $0x803f74,%rcx
  80242d:	00 00 00 
  802430:	48 ba 53 3f 80 00 00 	movabs $0x803f53,%rdx
  802437:	00 00 00 
  80243a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80243f:	48 bf 68 3f 80 00 00 	movabs $0x803f68,%rdi
  802446:	00 00 00 
  802449:	b8 00 00 00 00       	mov    $0x0,%eax
  80244e:	49 b8 7e 2d 80 00 00 	movabs $0x802d7e,%r8
  802455:	00 00 00 
  802458:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80245b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245e:	48 63 d0             	movslq %eax,%rdx
  802461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802465:	48 89 c6             	mov    %rax,%rsi
  802468:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80246f:	00 00 00 
  802472:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  802479:	00 00 00 
  80247c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80247e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802485:	00 00 00 
  802488:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80248b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80248e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802495:	00 00 00 
  802498:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80249b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80249e:	bf 08 00 00 00       	mov    $0x8,%edi
  8024a3:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
}
  8024af:	c9                   	leaveq 
  8024b0:	c3                   	retq   

00000000008024b1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024b1:	55                   	push   %rbp
  8024b2:	48 89 e5             	mov    %rsp,%rbp
  8024b5:	48 83 ec 10          	sub    $0x10,%rsp
  8024b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8024bf:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8024c2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024c9:	00 00 00 
  8024cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024cf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8024d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024d8:	00 00 00 
  8024db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024de:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8024e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024e8:	00 00 00 
  8024eb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8024ee:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8024f1:	bf 09 00 00 00       	mov    $0x9,%edi
  8024f6:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
}
  802502:	c9                   	leaveq 
  802503:	c3                   	retq   

0000000000802504 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802504:	55                   	push   %rbp
  802505:	48 89 e5             	mov    %rsp,%rbp
  802508:	53                   	push   %rbx
  802509:	48 83 ec 38          	sub    $0x38,%rsp
  80250d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802511:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802515:	48 89 c7             	mov    %rax,%rdi
  802518:	48 b8 24 0f 80 00 00 	movabs $0x800f24,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
  802524:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802527:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80252b:	0f 88 bf 01 00 00    	js     8026f0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802535:	ba 07 04 00 00       	mov    $0x407,%edx
  80253a:	48 89 c6             	mov    %rax,%rsi
  80253d:	bf 00 00 00 00       	mov    $0x0,%edi
  802542:	48 b8 6e 0b 80 00 00 	movabs $0x800b6e,%rax
  802549:	00 00 00 
  80254c:	ff d0                	callq  *%rax
  80254e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802551:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802555:	0f 88 95 01 00 00    	js     8026f0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80255b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80255f:	48 89 c7             	mov    %rax,%rdi
  802562:	48 b8 24 0f 80 00 00 	movabs $0x800f24,%rax
  802569:	00 00 00 
  80256c:	ff d0                	callq  *%rax
  80256e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802571:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802575:	0f 88 5d 01 00 00    	js     8026d8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80257f:	ba 07 04 00 00       	mov    $0x407,%edx
  802584:	48 89 c6             	mov    %rax,%rsi
  802587:	bf 00 00 00 00       	mov    $0x0,%edi
  80258c:	48 b8 6e 0b 80 00 00 	movabs $0x800b6e,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
  802598:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80259b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80259f:	0f 88 33 01 00 00    	js     8026d8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a9:	48 89 c7             	mov    %rax,%rdi
  8025ac:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
  8025b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c0:	ba 07 04 00 00       	mov    $0x407,%edx
  8025c5:	48 89 c6             	mov    %rax,%rsi
  8025c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cd:	48 b8 6e 0b 80 00 00 	movabs $0x800b6e,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
  8025d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8025dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025e0:	79 05                	jns    8025e7 <pipe+0xe3>
		goto err2;
  8025e2:	e9 d9 00 00 00       	jmpq   8026c0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025eb:	48 89 c7             	mov    %rax,%rdi
  8025ee:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	callq  *%rax
  8025fa:	48 89 c2             	mov    %rax,%rdx
  8025fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802601:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802607:	48 89 d1             	mov    %rdx,%rcx
  80260a:	ba 00 00 00 00       	mov    $0x0,%edx
  80260f:	48 89 c6             	mov    %rax,%rsi
  802612:	bf 00 00 00 00       	mov    $0x0,%edi
  802617:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  80261e:	00 00 00 
  802621:	ff d0                	callq  *%rax
  802623:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802626:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80262a:	79 1b                	jns    802647 <pipe+0x143>
		goto err3;
  80262c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80262d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802631:	48 89 c6             	mov    %rax,%rsi
  802634:	bf 00 00 00 00       	mov    $0x0,%edi
  802639:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  802640:	00 00 00 
  802643:	ff d0                	callq  *%rax
  802645:	eb 79                	jmp    8026c0 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  802647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802652:	00 00 00 
  802655:	8b 12                	mov    (%rdx),%edx
  802657:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80265d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  802664:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802668:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80266f:	00 00 00 
  802672:	8b 12                	mov    (%rdx),%edx
  802674:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802676:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  802681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802685:	48 89 c7             	mov    %rax,%rdi
  802688:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
  802694:	89 c2                	mov    %eax,%edx
  802696:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80269a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80269c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026a0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8026a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a8:	48 89 c7             	mov    %rax,%rdi
  8026ab:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	eb 33                	jmp    8026f3 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8026c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c4:	48 89 c6             	mov    %rax,%rsi
  8026c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026cc:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8026d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026dc:	48 89 c6             	mov    %rax,%rsi
  8026df:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e4:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	callq  *%rax
err:
	return r;
  8026f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8026f3:	48 83 c4 38          	add    $0x38,%rsp
  8026f7:	5b                   	pop    %rbx
  8026f8:	5d                   	pop    %rbp
  8026f9:	c3                   	retq   

00000000008026fa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026fa:	55                   	push   %rbp
  8026fb:	48 89 e5             	mov    %rsp,%rbp
  8026fe:	53                   	push   %rbx
  8026ff:	48 83 ec 28          	sub    $0x28,%rsp
  802703:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802707:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80270b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802712:	00 00 00 
  802715:	48 8b 00             	mov    (%rax),%rax
  802718:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80271e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802725:	48 89 c7             	mov    %rax,%rdi
  802728:	48 b8 22 3d 80 00 00 	movabs $0x803d22,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
  802734:	89 c3                	mov    %eax,%ebx
  802736:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273a:	48 89 c7             	mov    %rax,%rdi
  80273d:	48 b8 22 3d 80 00 00 	movabs $0x803d22,%rax
  802744:	00 00 00 
  802747:	ff d0                	callq  *%rax
  802749:	39 c3                	cmp    %eax,%ebx
  80274b:	0f 94 c0             	sete   %al
  80274e:	0f b6 c0             	movzbl %al,%eax
  802751:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802754:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80275b:	00 00 00 
  80275e:	48 8b 00             	mov    (%rax),%rax
  802761:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802767:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80276a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80276d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802770:	75 05                	jne    802777 <_pipeisclosed+0x7d>
			return ret;
  802772:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802775:	eb 4a                	jmp    8027c1 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  802777:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80277a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80277d:	74 3d                	je     8027bc <_pipeisclosed+0xc2>
  80277f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802783:	75 37                	jne    8027bc <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802785:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80278c:	00 00 00 
  80278f:	48 8b 00             	mov    (%rax),%rax
  802792:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802798:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80279b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80279e:	89 c6                	mov    %eax,%esi
  8027a0:	48 bf 85 3f 80 00 00 	movabs $0x803f85,%rdi
  8027a7:	00 00 00 
  8027aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8027af:	49 b8 b7 2f 80 00 00 	movabs $0x802fb7,%r8
  8027b6:	00 00 00 
  8027b9:	41 ff d0             	callq  *%r8
	}
  8027bc:	e9 4a ff ff ff       	jmpq   80270b <_pipeisclosed+0x11>
}
  8027c1:	48 83 c4 28          	add    $0x28,%rsp
  8027c5:	5b                   	pop    %rbx
  8027c6:	5d                   	pop    %rbp
  8027c7:	c3                   	retq   

00000000008027c8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8027c8:	55                   	push   %rbp
  8027c9:	48 89 e5             	mov    %rsp,%rbp
  8027cc:	48 83 ec 30          	sub    $0x30,%rsp
  8027d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027d3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027da:	48 89 d6             	mov    %rdx,%rsi
  8027dd:	89 c7                	mov    %eax,%edi
  8027df:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
  8027eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f2:	79 05                	jns    8027f9 <pipeisclosed+0x31>
		return r;
  8027f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f7:	eb 31                	jmp    80282a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8027f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fd:	48 89 c7             	mov    %rax,%rdi
  802800:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  802807:	00 00 00 
  80280a:	ff d0                	callq  *%rax
  80280c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802814:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802818:	48 89 d6             	mov    %rdx,%rsi
  80281b:	48 89 c7             	mov    %rax,%rdi
  80281e:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
}
  80282a:	c9                   	leaveq 
  80282b:	c3                   	retq   

000000000080282c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80282c:	55                   	push   %rbp
  80282d:	48 89 e5             	mov    %rsp,%rbp
  802830:	48 83 ec 40          	sub    $0x40,%rsp
  802834:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802838:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80283c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802844:	48 89 c7             	mov    %rax,%rdi
  802847:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  80284e:	00 00 00 
  802851:	ff d0                	callq  *%rax
  802853:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802857:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80285b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80285f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802866:	00 
  802867:	e9 92 00 00 00       	jmpq   8028fe <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80286c:	eb 41                	jmp    8028af <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80286e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802873:	74 09                	je     80287e <devpipe_read+0x52>
				return i;
  802875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802879:	e9 92 00 00 00       	jmpq   802910 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80287e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802886:	48 89 d6             	mov    %rdx,%rsi
  802889:	48 89 c7             	mov    %rax,%rdi
  80288c:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  802893:	00 00 00 
  802896:	ff d0                	callq  *%rax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 07                	je     8028a3 <devpipe_read+0x77>
				return 0;
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	eb 6d                	jmp    802910 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8028a3:	48 b8 32 0b 80 00 00 	movabs $0x800b32,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8028af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b3:	8b 10                	mov    (%rax),%edx
  8028b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b9:	8b 40 04             	mov    0x4(%rax),%eax
  8028bc:	39 c2                	cmp    %eax,%edx
  8028be:	74 ae                	je     80286e <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8028c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8028cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d0:	8b 00                	mov    (%rax),%eax
  8028d2:	99                   	cltd   
  8028d3:	c1 ea 1b             	shr    $0x1b,%edx
  8028d6:	01 d0                	add    %edx,%eax
  8028d8:	83 e0 1f             	and    $0x1f,%eax
  8028db:	29 d0                	sub    %edx,%eax
  8028dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028e1:	48 98                	cltq   
  8028e3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8028e8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8028ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ee:	8b 00                	mov    (%rax),%eax
  8028f0:	8d 50 01             	lea    0x1(%rax),%edx
  8028f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f7:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8028f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8028fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802902:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802906:	0f 82 60 ff ff ff    	jb     80286c <devpipe_read+0x40>
	}
	return i;
  80290c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 83 ec 40          	sub    $0x40,%rsp
  80291a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80291e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802922:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80292a:	48 89 c7             	mov    %rax,%rdi
  80292d:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  802934:	00 00 00 
  802937:	ff d0                	callq  *%rax
  802939:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80293d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802941:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802945:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80294c:	00 
  80294d:	e9 91 00 00 00       	jmpq   8029e3 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802952:	eb 31                	jmp    802985 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802954:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80295c:	48 89 d6             	mov    %rdx,%rsi
  80295f:	48 89 c7             	mov    %rax,%rdi
  802962:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 07                	je     802979 <devpipe_write+0x67>
				return 0;
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	eb 7c                	jmp    8029f5 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802979:	48 b8 32 0b 80 00 00 	movabs $0x800b32,%rax
  802980:	00 00 00 
  802983:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802985:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802989:	8b 40 04             	mov    0x4(%rax),%eax
  80298c:	48 63 d0             	movslq %eax,%rdx
  80298f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802993:	8b 00                	mov    (%rax),%eax
  802995:	48 98                	cltq   
  802997:	48 83 c0 20          	add    $0x20,%rax
  80299b:	48 39 c2             	cmp    %rax,%rdx
  80299e:	73 b4                	jae    802954 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8029a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a4:	8b 40 04             	mov    0x4(%rax),%eax
  8029a7:	99                   	cltd   
  8029a8:	c1 ea 1b             	shr    $0x1b,%edx
  8029ab:	01 d0                	add    %edx,%eax
  8029ad:	83 e0 1f             	and    $0x1f,%eax
  8029b0:	29 d0                	sub    %edx,%eax
  8029b2:	89 c6                	mov    %eax,%esi
  8029b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029bc:	48 01 d0             	add    %rdx,%rax
  8029bf:	0f b6 08             	movzbl (%rax),%ecx
  8029c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029c6:	48 63 c6             	movslq %esi,%rax
  8029c9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8029cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d1:	8b 40 04             	mov    0x4(%rax),%eax
  8029d4:	8d 50 01             	lea    0x1(%rax),%edx
  8029d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029db:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8029de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8029e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8029eb:	0f 82 61 ff ff ff    	jb     802952 <devpipe_write+0x40>
	}

	return i;
  8029f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8029f5:	c9                   	leaveq 
  8029f6:	c3                   	retq   

00000000008029f7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8029f7:	55                   	push   %rbp
  8029f8:	48 89 e5             	mov    %rsp,%rbp
  8029fb:	48 83 ec 20          	sub    $0x20,%rsp
  8029ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a03:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0b:	48 89 c7             	mov    %rax,%rdi
  802a0e:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax
  802a1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802a1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a22:	48 be 98 3f 80 00 00 	movabs $0x803f98,%rsi
  802a29:	00 00 00 
  802a2c:	48 89 c7             	mov    %rax,%rdi
  802a2f:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  802a36:	00 00 00 
  802a39:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802a3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3f:	8b 50 04             	mov    0x4(%rax),%edx
  802a42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a46:	8b 00                	mov    (%rax),%eax
  802a48:	29 c2                	sub    %eax,%edx
  802a4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802a54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a58:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a5f:	00 00 00 
	stat->st_dev = &devpipe;
  802a62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a66:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  802a6d:	00 00 00 
  802a70:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7c:	c9                   	leaveq 
  802a7d:	c3                   	retq   

0000000000802a7e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802a7e:	55                   	push   %rbp
  802a7f:	48 89 e5             	mov    %rsp,%rbp
  802a82:	48 83 ec 10          	sub    $0x10,%rsp
  802a86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802a8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a8e:	48 89 c6             	mov    %rax,%rsi
  802a91:	bf 00 00 00 00       	mov    $0x0,%edi
  802a96:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802aa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa6:	48 89 c7             	mov    %rax,%rdi
  802aa9:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
  802ab5:	48 89 c6             	mov    %rax,%rsi
  802ab8:	bf 00 00 00 00       	mov    $0x0,%edi
  802abd:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  802ac4:	00 00 00 
  802ac7:	ff d0                	callq  *%rax
}
  802ac9:	c9                   	leaveq 
  802aca:	c3                   	retq   

0000000000802acb <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802acb:	55                   	push   %rbp
  802acc:	48 89 e5             	mov    %rsp,%rbp
  802acf:	48 83 ec 20          	sub    $0x20,%rsp
  802ad3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802ad6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ad9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802adc:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802ae0:	be 01 00 00 00       	mov    $0x1,%esi
  802ae5:	48 89 c7             	mov    %rax,%rdi
  802ae8:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
}
  802af4:	c9                   	leaveq 
  802af5:	c3                   	retq   

0000000000802af6 <getchar>:

int
getchar(void)
{
  802af6:	55                   	push   %rbp
  802af7:	48 89 e5             	mov    %rsp,%rbp
  802afa:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802afe:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802b02:	ba 01 00 00 00       	mov    $0x1,%edx
  802b07:	48 89 c6             	mov    %rax,%rsi
  802b0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b0f:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802b1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b22:	79 05                	jns    802b29 <getchar+0x33>
		return r;
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b27:	eb 14                	jmp    802b3d <getchar+0x47>
	if (r < 1)
  802b29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2d:	7f 07                	jg     802b36 <getchar+0x40>
		return -E_EOF;
  802b2f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802b34:	eb 07                	jmp    802b3d <getchar+0x47>
	return c;
  802b36:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802b3a:	0f b6 c0             	movzbl %al,%eax
}
  802b3d:	c9                   	leaveq 
  802b3e:	c3                   	retq   

0000000000802b3f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b3f:	55                   	push   %rbp
  802b40:	48 89 e5             	mov    %rsp,%rbp
  802b43:	48 83 ec 20          	sub    $0x20,%rsp
  802b47:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b4a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b51:	48 89 d6             	mov    %rdx,%rsi
  802b54:	89 c7                	mov    %eax,%edi
  802b56:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b69:	79 05                	jns    802b70 <iscons+0x31>
		return r;
  802b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6e:	eb 1a                	jmp    802b8a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b74:	8b 10                	mov    (%rax),%edx
  802b76:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802b7d:	00 00 00 
  802b80:	8b 00                	mov    (%rax),%eax
  802b82:	39 c2                	cmp    %eax,%edx
  802b84:	0f 94 c0             	sete   %al
  802b87:	0f b6 c0             	movzbl %al,%eax
}
  802b8a:	c9                   	leaveq 
  802b8b:	c3                   	retq   

0000000000802b8c <opencons>:

int
opencons(void)
{
  802b8c:	55                   	push   %rbp
  802b8d:	48 89 e5             	mov    %rsp,%rbp
  802b90:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b94:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b98:	48 89 c7             	mov    %rax,%rdi
  802b9b:	48 b8 24 0f 80 00 00 	movabs $0x800f24,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
  802ba7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802baa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bae:	79 05                	jns    802bb5 <opencons+0x29>
		return r;
  802bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb3:	eb 5b                	jmp    802c10 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802bb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb9:	ba 07 04 00 00       	mov    $0x407,%edx
  802bbe:	48 89 c6             	mov    %rax,%rsi
  802bc1:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc6:	48 b8 6e 0b 80 00 00 	movabs $0x800b6e,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
  802bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd9:	79 05                	jns    802be0 <opencons+0x54>
		return r;
  802bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bde:	eb 30                	jmp    802c10 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802be0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be4:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802beb:	00 00 00 
  802bee:	8b 12                	mov    (%rdx),%edx
  802bf0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802bf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802bfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c01:	48 89 c7             	mov    %rax,%rdi
  802c04:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
}
  802c10:	c9                   	leaveq 
  802c11:	c3                   	retq   

0000000000802c12 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c12:	55                   	push   %rbp
  802c13:	48 89 e5             	mov    %rsp,%rbp
  802c16:	48 83 ec 30          	sub    $0x30,%rsp
  802c1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c22:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802c26:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c2b:	75 07                	jne    802c34 <devcons_read+0x22>
		return 0;
  802c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c32:	eb 4b                	jmp    802c7f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802c34:	eb 0c                	jmp    802c42 <devcons_read+0x30>
		sys_yield();
  802c36:	48 b8 32 0b 80 00 00 	movabs $0x800b32,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  802c42:	48 b8 74 0a 80 00 00 	movabs $0x800a74,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
  802c4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c55:	74 df                	je     802c36 <devcons_read+0x24>
	if (c < 0)
  802c57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5b:	79 05                	jns    802c62 <devcons_read+0x50>
		return c;
  802c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c60:	eb 1d                	jmp    802c7f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802c62:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802c66:	75 07                	jne    802c6f <devcons_read+0x5d>
		return 0;
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	eb 10                	jmp    802c7f <devcons_read+0x6d>
	*(char*)vbuf = c;
  802c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c72:	89 c2                	mov    %eax,%edx
  802c74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c78:	88 10                	mov    %dl,(%rax)
	return 1;
  802c7a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802c7f:	c9                   	leaveq 
  802c80:	c3                   	retq   

0000000000802c81 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c81:	55                   	push   %rbp
  802c82:	48 89 e5             	mov    %rsp,%rbp
  802c85:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802c8c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802c93:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802c9a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ca8:	eb 76                	jmp    802d20 <devcons_write+0x9f>
		m = n - tot;
  802caa:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802cb1:	89 c2                	mov    %eax,%edx
  802cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb6:	29 c2                	sub    %eax,%edx
  802cb8:	89 d0                	mov    %edx,%eax
  802cba:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802cbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc0:	83 f8 7f             	cmp    $0x7f,%eax
  802cc3:	76 07                	jbe    802ccc <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802cc5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802ccc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ccf:	48 63 d0             	movslq %eax,%rdx
  802cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd5:	48 63 c8             	movslq %eax,%rcx
  802cd8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802cdf:	48 01 c1             	add    %rax,%rcx
  802ce2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802ce9:	48 89 ce             	mov    %rcx,%rsi
  802cec:	48 89 c7             	mov    %rax,%rdi
  802cef:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802cfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cfe:	48 63 d0             	movslq %eax,%rdx
  802d01:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802d08:	48 89 d6             	mov    %rdx,%rsi
  802d0b:	48 89 c7             	mov    %rax,%rdi
  802d0e:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  802d1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d1d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d23:	48 98                	cltq   
  802d25:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802d2c:	0f 82 78 ff ff ff    	jb     802caa <devcons_write+0x29>
	}
	return tot;
  802d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d35:	c9                   	leaveq 
  802d36:	c3                   	retq   

0000000000802d37 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802d37:	55                   	push   %rbp
  802d38:	48 89 e5             	mov    %rsp,%rbp
  802d3b:	48 83 ec 08          	sub    $0x8,%rsp
  802d3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d48:	c9                   	leaveq 
  802d49:	c3                   	retq   

0000000000802d4a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802d4a:	55                   	push   %rbp
  802d4b:	48 89 e5             	mov    %rsp,%rbp
  802d4e:	48 83 ec 10          	sub    $0x10,%rsp
  802d52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5e:	48 be a4 3f 80 00 00 	movabs $0x803fa4,%rsi
  802d65:	00 00 00 
  802d68:	48 89 c7             	mov    %rax,%rdi
  802d6b:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
	return 0;
  802d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d7c:	c9                   	leaveq 
  802d7d:	c3                   	retq   

0000000000802d7e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802d7e:	55                   	push   %rbp
  802d7f:	48 89 e5             	mov    %rsp,%rbp
  802d82:	53                   	push   %rbx
  802d83:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802d8a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802d91:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802d97:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802d9e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802da5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802dac:	84 c0                	test   %al,%al
  802dae:	74 23                	je     802dd3 <_panic+0x55>
  802db0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802db7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802dbb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802dbf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802dc3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802dc7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802dcb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802dcf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802dd3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802dda:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802de1:	00 00 00 
  802de4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802deb:	00 00 00 
  802dee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802df2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802df9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802e00:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802e07:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802e0e:	00 00 00 
  802e11:	48 8b 18             	mov    (%rax),%rbx
  802e14:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
  802e20:	89 c6                	mov    %eax,%esi
  802e22:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  802e28:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802e2f:	41 89 d0             	mov    %edx,%r8d
  802e32:	48 89 c1             	mov    %rax,%rcx
  802e35:	48 89 da             	mov    %rbx,%rdx
  802e38:	48 bf b0 3f 80 00 00 	movabs $0x803fb0,%rdi
  802e3f:	00 00 00 
  802e42:	b8 00 00 00 00       	mov    $0x0,%eax
  802e47:	49 b9 b7 2f 80 00 00 	movabs $0x802fb7,%r9
  802e4e:	00 00 00 
  802e51:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802e54:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802e5b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802e62:	48 89 d6             	mov    %rdx,%rsi
  802e65:	48 89 c7             	mov    %rax,%rdi
  802e68:	48 b8 0b 2f 80 00 00 	movabs $0x802f0b,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	callq  *%rax
	cprintf("\n");
  802e74:	48 bf d3 3f 80 00 00 	movabs $0x803fd3,%rdi
  802e7b:	00 00 00 
  802e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e83:	48 ba b7 2f 80 00 00 	movabs $0x802fb7,%rdx
  802e8a:	00 00 00 
  802e8d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802e8f:	cc                   	int3   
  802e90:	eb fd                	jmp    802e8f <_panic+0x111>

0000000000802e92 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  802e92:	55                   	push   %rbp
  802e93:	48 89 e5             	mov    %rsp,%rbp
  802e96:	48 83 ec 10          	sub    $0x10,%rsp
  802e9a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea5:	8b 00                	mov    (%rax),%eax
  802ea7:	8d 48 01             	lea    0x1(%rax),%ecx
  802eaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eae:	89 0a                	mov    %ecx,(%rdx)
  802eb0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802eb3:	89 d1                	mov    %edx,%ecx
  802eb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eb9:	48 98                	cltq   
  802ebb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  802ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec3:	8b 00                	mov    (%rax),%eax
  802ec5:	3d ff 00 00 00       	cmp    $0xff,%eax
  802eca:	75 2c                	jne    802ef8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed0:	8b 00                	mov    (%rax),%eax
  802ed2:	48 98                	cltq   
  802ed4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ed8:	48 83 c2 08          	add    $0x8,%rdx
  802edc:	48 89 c6             	mov    %rax,%rsi
  802edf:	48 89 d7             	mov    %rdx,%rdi
  802ee2:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
        b->idx = 0;
  802eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efc:	8b 40 04             	mov    0x4(%rax),%eax
  802eff:	8d 50 01             	lea    0x1(%rax),%edx
  802f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f06:	89 50 04             	mov    %edx,0x4(%rax)
}
  802f09:	c9                   	leaveq 
  802f0a:	c3                   	retq   

0000000000802f0b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802f0b:	55                   	push   %rbp
  802f0c:	48 89 e5             	mov    %rsp,%rbp
  802f0f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802f16:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802f1d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802f24:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802f2b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802f32:	48 8b 0a             	mov    (%rdx),%rcx
  802f35:	48 89 08             	mov    %rcx,(%rax)
  802f38:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802f3c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802f40:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802f44:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802f48:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802f4f:	00 00 00 
    b.cnt = 0;
  802f52:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f59:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802f5c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802f63:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802f6a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f71:	48 89 c6             	mov    %rax,%rsi
  802f74:	48 bf 92 2e 80 00 00 	movabs $0x802e92,%rdi
  802f7b:	00 00 00 
  802f7e:	48 b8 56 33 80 00 00 	movabs $0x803356,%rax
  802f85:	00 00 00 
  802f88:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802f8a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802f90:	48 98                	cltq   
  802f92:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802f99:	48 83 c2 08          	add    $0x8,%rdx
  802f9d:	48 89 c6             	mov    %rax,%rsi
  802fa0:	48 89 d7             	mov    %rdx,%rdi
  802fa3:	48 b8 28 0a 80 00 00 	movabs $0x800a28,%rax
  802faa:	00 00 00 
  802fad:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802faf:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802fb5:	c9                   	leaveq 
  802fb6:	c3                   	retq   

0000000000802fb7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802fb7:	55                   	push   %rbp
  802fb8:	48 89 e5             	mov    %rsp,%rbp
  802fbb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802fc2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802fc9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fd0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fd7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fde:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fe5:	84 c0                	test   %al,%al
  802fe7:	74 20                	je     803009 <cprintf+0x52>
  802fe9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fed:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ff1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ff5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802ff9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802ffd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803001:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803005:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803009:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  803010:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803017:	00 00 00 
  80301a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803021:	00 00 00 
  803024:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803028:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80302f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803036:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80303d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803044:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80304b:	48 8b 0a             	mov    (%rdx),%rcx
  80304e:	48 89 08             	mov    %rcx,(%rax)
  803051:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803055:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803059:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80305d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803061:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803068:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80306f:	48 89 d6             	mov    %rdx,%rsi
  803072:	48 89 c7             	mov    %rax,%rdi
  803075:	48 b8 0b 2f 80 00 00 	movabs $0x802f0b,%rax
  80307c:	00 00 00 
  80307f:	ff d0                	callq  *%rax
  803081:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803087:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80308d:	c9                   	leaveq 
  80308e:	c3                   	retq   

000000000080308f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80308f:	55                   	push   %rbp
  803090:	48 89 e5             	mov    %rsp,%rbp
  803093:	48 83 ec 30          	sub    $0x30,%rsp
  803097:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80309b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80309f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8030a3:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8030a6:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8030aa:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8030ae:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8030b1:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8030b5:	77 42                	ja     8030f9 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8030b7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8030ba:	8d 78 ff             	lea    -0x1(%rax),%edi
  8030bd:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8030c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030c9:	48 f7 f6             	div    %rsi
  8030cc:	49 89 c2             	mov    %rax,%r10
  8030cf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8030d2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030d5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030dd:	41 89 c9             	mov    %ecx,%r9d
  8030e0:	41 89 f8             	mov    %edi,%r8d
  8030e3:	89 d1                	mov    %edx,%ecx
  8030e5:	4c 89 d2             	mov    %r10,%rdx
  8030e8:	48 89 c7             	mov    %rax,%rdi
  8030eb:	48 b8 8f 30 80 00 00 	movabs $0x80308f,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
  8030f7:	eb 1e                	jmp    803117 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8030f9:	eb 12                	jmp    80310d <printnum+0x7e>
			putch(padc, putdat);
  8030fb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030ff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803102:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803106:	48 89 ce             	mov    %rcx,%rsi
  803109:	89 d7                	mov    %edx,%edi
  80310b:	ff d0                	callq  *%rax
		while (--width > 0)
  80310d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  803111:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  803115:	7f e4                	jg     8030fb <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803117:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80311a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311e:	ba 00 00 00 00       	mov    $0x0,%edx
  803123:	48 f7 f1             	div    %rcx
  803126:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  80312d:	00 00 00 
  803130:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  803134:	0f be d0             	movsbl %al,%edx
  803137:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80313b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313f:	48 89 ce             	mov    %rcx,%rsi
  803142:	89 d7                	mov    %edx,%edi
  803144:	ff d0                	callq  *%rax
}
  803146:	c9                   	leaveq 
  803147:	c3                   	retq   

0000000000803148 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803148:	55                   	push   %rbp
  803149:	48 89 e5             	mov    %rsp,%rbp
  80314c:	48 83 ec 20          	sub    $0x20,%rsp
  803150:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803154:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803157:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80315b:	7e 4f                	jle    8031ac <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80315d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803161:	8b 00                	mov    (%rax),%eax
  803163:	83 f8 30             	cmp    $0x30,%eax
  803166:	73 24                	jae    80318c <getuint+0x44>
  803168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80316c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803174:	8b 00                	mov    (%rax),%eax
  803176:	89 c0                	mov    %eax,%eax
  803178:	48 01 d0             	add    %rdx,%rax
  80317b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80317f:	8b 12                	mov    (%rdx),%edx
  803181:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803184:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803188:	89 0a                	mov    %ecx,(%rdx)
  80318a:	eb 14                	jmp    8031a0 <getuint+0x58>
  80318c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803190:	48 8b 40 08          	mov    0x8(%rax),%rax
  803194:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803198:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80319c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8031a0:	48 8b 00             	mov    (%rax),%rax
  8031a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8031a7:	e9 9d 00 00 00       	jmpq   803249 <getuint+0x101>
	else if (lflag)
  8031ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8031b0:	74 4c                	je     8031fe <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8031b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b6:	8b 00                	mov    (%rax),%eax
  8031b8:	83 f8 30             	cmp    $0x30,%eax
  8031bb:	73 24                	jae    8031e1 <getuint+0x99>
  8031bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8031c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c9:	8b 00                	mov    (%rax),%eax
  8031cb:	89 c0                	mov    %eax,%eax
  8031cd:	48 01 d0             	add    %rdx,%rax
  8031d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031d4:	8b 12                	mov    (%rdx),%edx
  8031d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8031d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031dd:	89 0a                	mov    %ecx,(%rdx)
  8031df:	eb 14                	jmp    8031f5 <getuint+0xad>
  8031e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8031e9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8031ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8031f5:	48 8b 00             	mov    (%rax),%rax
  8031f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8031fc:	eb 4b                	jmp    803249 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8031fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803202:	8b 00                	mov    (%rax),%eax
  803204:	83 f8 30             	cmp    $0x30,%eax
  803207:	73 24                	jae    80322d <getuint+0xe5>
  803209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803215:	8b 00                	mov    (%rax),%eax
  803217:	89 c0                	mov    %eax,%eax
  803219:	48 01 d0             	add    %rdx,%rax
  80321c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803220:	8b 12                	mov    (%rdx),%edx
  803222:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803225:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803229:	89 0a                	mov    %ecx,(%rdx)
  80322b:	eb 14                	jmp    803241 <getuint+0xf9>
  80322d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803231:	48 8b 40 08          	mov    0x8(%rax),%rax
  803235:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803239:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80323d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803241:	8b 00                	mov    (%rax),%eax
  803243:	89 c0                	mov    %eax,%eax
  803245:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80324d:	c9                   	leaveq 
  80324e:	c3                   	retq   

000000000080324f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80324f:	55                   	push   %rbp
  803250:	48 89 e5             	mov    %rsp,%rbp
  803253:	48 83 ec 20          	sub    $0x20,%rsp
  803257:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80325b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80325e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803262:	7e 4f                	jle    8032b3 <getint+0x64>
		x=va_arg(*ap, long long);
  803264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803268:	8b 00                	mov    (%rax),%eax
  80326a:	83 f8 30             	cmp    $0x30,%eax
  80326d:	73 24                	jae    803293 <getint+0x44>
  80326f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803273:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327b:	8b 00                	mov    (%rax),%eax
  80327d:	89 c0                	mov    %eax,%eax
  80327f:	48 01 d0             	add    %rdx,%rax
  803282:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803286:	8b 12                	mov    (%rdx),%edx
  803288:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80328b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80328f:	89 0a                	mov    %ecx,(%rdx)
  803291:	eb 14                	jmp    8032a7 <getint+0x58>
  803293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803297:	48 8b 40 08          	mov    0x8(%rax),%rax
  80329b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80329f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8032a7:	48 8b 00             	mov    (%rax),%rax
  8032aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032ae:	e9 9d 00 00 00       	jmpq   803350 <getint+0x101>
	else if (lflag)
  8032b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8032b7:	74 4c                	je     803305 <getint+0xb6>
		x=va_arg(*ap, long);
  8032b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bd:	8b 00                	mov    (%rax),%eax
  8032bf:	83 f8 30             	cmp    $0x30,%eax
  8032c2:	73 24                	jae    8032e8 <getint+0x99>
  8032c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8032cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d0:	8b 00                	mov    (%rax),%eax
  8032d2:	89 c0                	mov    %eax,%eax
  8032d4:	48 01 d0             	add    %rdx,%rax
  8032d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032db:	8b 12                	mov    (%rdx),%edx
  8032dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8032e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032e4:	89 0a                	mov    %ecx,(%rdx)
  8032e6:	eb 14                	jmp    8032fc <getint+0xad>
  8032e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ec:	48 8b 40 08          	mov    0x8(%rax),%rax
  8032f0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8032f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032f8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8032fc:	48 8b 00             	mov    (%rax),%rax
  8032ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803303:	eb 4b                	jmp    803350 <getint+0x101>
	else
		x=va_arg(*ap, int);
  803305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803309:	8b 00                	mov    (%rax),%eax
  80330b:	83 f8 30             	cmp    $0x30,%eax
  80330e:	73 24                	jae    803334 <getint+0xe5>
  803310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803314:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331c:	8b 00                	mov    (%rax),%eax
  80331e:	89 c0                	mov    %eax,%eax
  803320:	48 01 d0             	add    %rdx,%rax
  803323:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803327:	8b 12                	mov    (%rdx),%edx
  803329:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80332c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803330:	89 0a                	mov    %ecx,(%rdx)
  803332:	eb 14                	jmp    803348 <getint+0xf9>
  803334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803338:	48 8b 40 08          	mov    0x8(%rax),%rax
  80333c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803340:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803344:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803348:	8b 00                	mov    (%rax),%eax
  80334a:	48 98                	cltq   
  80334c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803354:	c9                   	leaveq 
  803355:	c3                   	retq   

0000000000803356 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803356:	55                   	push   %rbp
  803357:	48 89 e5             	mov    %rsp,%rbp
  80335a:	41 54                	push   %r12
  80335c:	53                   	push   %rbx
  80335d:	48 83 ec 60          	sub    $0x60,%rsp
  803361:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803365:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  803369:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80336d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803371:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803375:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  803379:	48 8b 0a             	mov    (%rdx),%rcx
  80337c:	48 89 08             	mov    %rcx,(%rax)
  80337f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803383:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803387:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80338b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80338f:	eb 17                	jmp    8033a8 <vprintfmt+0x52>
			if (ch == '\0')
  803391:	85 db                	test   %ebx,%ebx
  803393:	0f 84 c5 04 00 00    	je     80385e <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  803399:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80339d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8033a1:	48 89 d6             	mov    %rdx,%rsi
  8033a4:	89 df                	mov    %ebx,%edi
  8033a6:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8033a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8033ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8033b0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8033b4:	0f b6 00             	movzbl (%rax),%eax
  8033b7:	0f b6 d8             	movzbl %al,%ebx
  8033ba:	83 fb 25             	cmp    $0x25,%ebx
  8033bd:	75 d2                	jne    803391 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  8033bf:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8033c3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8033ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8033d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8033d8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8033df:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8033e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8033e7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8033eb:	0f b6 00             	movzbl (%rax),%eax
  8033ee:	0f b6 d8             	movzbl %al,%ebx
  8033f1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8033f4:	83 f8 55             	cmp    $0x55,%eax
  8033f7:	0f 87 2e 04 00 00    	ja     80382b <vprintfmt+0x4d5>
  8033fd:	89 c0                	mov    %eax,%eax
  8033ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803406:	00 
  803407:	48 b8 18 42 80 00 00 	movabs $0x804218,%rax
  80340e:	00 00 00 
  803411:	48 01 d0             	add    %rdx,%rax
  803414:	48 8b 00             	mov    (%rax),%rax
  803417:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  803419:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80341d:	eb c0                	jmp    8033df <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80341f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803423:	eb ba                	jmp    8033df <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803425:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80342c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80342f:	89 d0                	mov    %edx,%eax
  803431:	c1 e0 02             	shl    $0x2,%eax
  803434:	01 d0                	add    %edx,%eax
  803436:	01 c0                	add    %eax,%eax
  803438:	01 d8                	add    %ebx,%eax
  80343a:	83 e8 30             	sub    $0x30,%eax
  80343d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803440:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803444:	0f b6 00             	movzbl (%rax),%eax
  803447:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80344a:	83 fb 2f             	cmp    $0x2f,%ebx
  80344d:	7e 0c                	jle    80345b <vprintfmt+0x105>
  80344f:	83 fb 39             	cmp    $0x39,%ebx
  803452:	7f 07                	jg     80345b <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  803454:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  803459:	eb d1                	jmp    80342c <vprintfmt+0xd6>
			goto process_precision;
  80345b:	eb 50                	jmp    8034ad <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  80345d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803460:	83 f8 30             	cmp    $0x30,%eax
  803463:	73 17                	jae    80347c <vprintfmt+0x126>
  803465:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803469:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80346c:	89 d2                	mov    %edx,%edx
  80346e:	48 01 d0             	add    %rdx,%rax
  803471:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803474:	83 c2 08             	add    $0x8,%edx
  803477:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80347a:	eb 0c                	jmp    803488 <vprintfmt+0x132>
  80347c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803480:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803484:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803488:	8b 00                	mov    (%rax),%eax
  80348a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80348d:	eb 1e                	jmp    8034ad <vprintfmt+0x157>

		case '.':
			if (width < 0)
  80348f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803493:	79 07                	jns    80349c <vprintfmt+0x146>
				width = 0;
  803495:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80349c:	e9 3e ff ff ff       	jmpq   8033df <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8034a1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8034a8:	e9 32 ff ff ff       	jmpq   8033df <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8034ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8034b1:	79 0d                	jns    8034c0 <vprintfmt+0x16a>
				width = precision, precision = -1;
  8034b3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8034b6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8034b9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8034c0:	e9 1a ff ff ff       	jmpq   8033df <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8034c5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8034c9:	e9 11 ff ff ff       	jmpq   8033df <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8034ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8034d1:	83 f8 30             	cmp    $0x30,%eax
  8034d4:	73 17                	jae    8034ed <vprintfmt+0x197>
  8034d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034da:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8034dd:	89 d2                	mov    %edx,%edx
  8034df:	48 01 d0             	add    %rdx,%rax
  8034e2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8034e5:	83 c2 08             	add    $0x8,%edx
  8034e8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8034eb:	eb 0c                	jmp    8034f9 <vprintfmt+0x1a3>
  8034ed:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8034f1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8034f5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8034f9:	8b 10                	mov    (%rax),%edx
  8034fb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8034ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803503:	48 89 ce             	mov    %rcx,%rsi
  803506:	89 d7                	mov    %edx,%edi
  803508:	ff d0                	callq  *%rax
			break;
  80350a:	e9 4a 03 00 00       	jmpq   803859 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80350f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803512:	83 f8 30             	cmp    $0x30,%eax
  803515:	73 17                	jae    80352e <vprintfmt+0x1d8>
  803517:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80351b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80351e:	89 d2                	mov    %edx,%edx
  803520:	48 01 d0             	add    %rdx,%rax
  803523:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803526:	83 c2 08             	add    $0x8,%edx
  803529:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80352c:	eb 0c                	jmp    80353a <vprintfmt+0x1e4>
  80352e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803532:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803536:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80353a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80353c:	85 db                	test   %ebx,%ebx
  80353e:	79 02                	jns    803542 <vprintfmt+0x1ec>
				err = -err;
  803540:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803542:	83 fb 15             	cmp    $0x15,%ebx
  803545:	7f 16                	jg     80355d <vprintfmt+0x207>
  803547:	48 b8 40 41 80 00 00 	movabs $0x804140,%rax
  80354e:	00 00 00 
  803551:	48 63 d3             	movslq %ebx,%rdx
  803554:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803558:	4d 85 e4             	test   %r12,%r12
  80355b:	75 2e                	jne    80358b <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  80355d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803561:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803565:	89 d9                	mov    %ebx,%ecx
  803567:	48 ba 01 42 80 00 00 	movabs $0x804201,%rdx
  80356e:	00 00 00 
  803571:	48 89 c7             	mov    %rax,%rdi
  803574:	b8 00 00 00 00       	mov    $0x0,%eax
  803579:	49 b8 67 38 80 00 00 	movabs $0x803867,%r8
  803580:	00 00 00 
  803583:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803586:	e9 ce 02 00 00       	jmpq   803859 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  80358b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80358f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803593:	4c 89 e1             	mov    %r12,%rcx
  803596:	48 ba 0a 42 80 00 00 	movabs $0x80420a,%rdx
  80359d:	00 00 00 
  8035a0:	48 89 c7             	mov    %rax,%rdi
  8035a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a8:	49 b8 67 38 80 00 00 	movabs $0x803867,%r8
  8035af:	00 00 00 
  8035b2:	41 ff d0             	callq  *%r8
			break;
  8035b5:	e9 9f 02 00 00       	jmpq   803859 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8035ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035bd:	83 f8 30             	cmp    $0x30,%eax
  8035c0:	73 17                	jae    8035d9 <vprintfmt+0x283>
  8035c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8035c9:	89 d2                	mov    %edx,%edx
  8035cb:	48 01 d0             	add    %rdx,%rax
  8035ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8035d1:	83 c2 08             	add    $0x8,%edx
  8035d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8035d7:	eb 0c                	jmp    8035e5 <vprintfmt+0x28f>
  8035d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8035dd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8035e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8035e5:	4c 8b 20             	mov    (%rax),%r12
  8035e8:	4d 85 e4             	test   %r12,%r12
  8035eb:	75 0a                	jne    8035f7 <vprintfmt+0x2a1>
				p = "(null)";
  8035ed:	49 bc 0d 42 80 00 00 	movabs $0x80420d,%r12
  8035f4:	00 00 00 
			if (width > 0 && padc != '-')
  8035f7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8035fb:	7e 3f                	jle    80363c <vprintfmt+0x2e6>
  8035fd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803601:	74 39                	je     80363c <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  803603:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803606:	48 98                	cltq   
  803608:	48 89 c6             	mov    %rax,%rsi
  80360b:	4c 89 e7             	mov    %r12,%rdi
  80360e:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  803615:	00 00 00 
  803618:	ff d0                	callq  *%rax
  80361a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80361d:	eb 17                	jmp    803636 <vprintfmt+0x2e0>
					putch(padc, putdat);
  80361f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803623:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803627:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80362b:	48 89 ce             	mov    %rcx,%rsi
  80362e:	89 d7                	mov    %edx,%edi
  803630:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  803632:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803636:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80363a:	7f e3                	jg     80361f <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80363c:	eb 37                	jmp    803675 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  80363e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803642:	74 1e                	je     803662 <vprintfmt+0x30c>
  803644:	83 fb 1f             	cmp    $0x1f,%ebx
  803647:	7e 05                	jle    80364e <vprintfmt+0x2f8>
  803649:	83 fb 7e             	cmp    $0x7e,%ebx
  80364c:	7e 14                	jle    803662 <vprintfmt+0x30c>
					putch('?', putdat);
  80364e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803652:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803656:	48 89 d6             	mov    %rdx,%rsi
  803659:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80365e:	ff d0                	callq  *%rax
  803660:	eb 0f                	jmp    803671 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  803662:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803666:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80366a:	48 89 d6             	mov    %rdx,%rsi
  80366d:	89 df                	mov    %ebx,%edi
  80366f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803671:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803675:	4c 89 e0             	mov    %r12,%rax
  803678:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80367c:	0f b6 00             	movzbl (%rax),%eax
  80367f:	0f be d8             	movsbl %al,%ebx
  803682:	85 db                	test   %ebx,%ebx
  803684:	74 10                	je     803696 <vprintfmt+0x340>
  803686:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80368a:	78 b2                	js     80363e <vprintfmt+0x2e8>
  80368c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803690:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803694:	79 a8                	jns    80363e <vprintfmt+0x2e8>
			for (; width > 0; width--)
  803696:	eb 16                	jmp    8036ae <vprintfmt+0x358>
				putch(' ', putdat);
  803698:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80369c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8036a0:	48 89 d6             	mov    %rdx,%rsi
  8036a3:	bf 20 00 00 00       	mov    $0x20,%edi
  8036a8:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  8036aa:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8036ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8036b2:	7f e4                	jg     803698 <vprintfmt+0x342>
			break;
  8036b4:	e9 a0 01 00 00       	jmpq   803859 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8036b9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8036bd:	be 03 00 00 00       	mov    $0x3,%esi
  8036c2:	48 89 c7             	mov    %rax,%rdi
  8036c5:	48 b8 4f 32 80 00 00 	movabs $0x80324f,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
  8036d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8036d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d9:	48 85 c0             	test   %rax,%rax
  8036dc:	79 1d                	jns    8036fb <vprintfmt+0x3a5>
				putch('-', putdat);
  8036de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8036e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8036e6:	48 89 d6             	mov    %rdx,%rsi
  8036e9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8036ee:	ff d0                	callq  *%rax
				num = -(long long) num;
  8036f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f4:	48 f7 d8             	neg    %rax
  8036f7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8036fb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803702:	e9 e5 00 00 00       	jmpq   8037ec <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803707:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80370b:	be 03 00 00 00       	mov    $0x3,%esi
  803710:	48 89 c7             	mov    %rax,%rdi
  803713:	48 b8 48 31 80 00 00 	movabs $0x803148,%rax
  80371a:	00 00 00 
  80371d:	ff d0                	callq  *%rax
  80371f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803723:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80372a:	e9 bd 00 00 00       	jmpq   8037ec <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80372f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803733:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803737:	48 89 d6             	mov    %rdx,%rsi
  80373a:	bf 58 00 00 00       	mov    $0x58,%edi
  80373f:	ff d0                	callq  *%rax
			putch('X', putdat);
  803741:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803745:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803749:	48 89 d6             	mov    %rdx,%rsi
  80374c:	bf 58 00 00 00       	mov    $0x58,%edi
  803751:	ff d0                	callq  *%rax
			putch('X', putdat);
  803753:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803757:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80375b:	48 89 d6             	mov    %rdx,%rsi
  80375e:	bf 58 00 00 00       	mov    $0x58,%edi
  803763:	ff d0                	callq  *%rax
			break;
  803765:	e9 ef 00 00 00       	jmpq   803859 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  80376a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80376e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803772:	48 89 d6             	mov    %rdx,%rsi
  803775:	bf 30 00 00 00       	mov    $0x30,%edi
  80377a:	ff d0                	callq  *%rax
			putch('x', putdat);
  80377c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803780:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803784:	48 89 d6             	mov    %rdx,%rsi
  803787:	bf 78 00 00 00       	mov    $0x78,%edi
  80378c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80378e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803791:	83 f8 30             	cmp    $0x30,%eax
  803794:	73 17                	jae    8037ad <vprintfmt+0x457>
  803796:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80379a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80379d:	89 d2                	mov    %edx,%edx
  80379f:	48 01 d0             	add    %rdx,%rax
  8037a2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8037a5:	83 c2 08             	add    $0x8,%edx
  8037a8:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  8037ab:	eb 0c                	jmp    8037b9 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  8037ad:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037b1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8037b5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8037b9:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  8037bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8037c0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8037c7:	eb 23                	jmp    8037ec <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8037c9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8037cd:	be 03 00 00 00       	mov    $0x3,%esi
  8037d2:	48 89 c7             	mov    %rax,%rdi
  8037d5:	48 b8 48 31 80 00 00 	movabs $0x803148,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
  8037e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8037e5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8037ec:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8037f1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8037f4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8037f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037fb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8037ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803803:	45 89 c1             	mov    %r8d,%r9d
  803806:	41 89 f8             	mov    %edi,%r8d
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 8f 30 80 00 00 	movabs $0x80308f,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
			break;
  803818:	eb 3f                	jmp    803859 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80381a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80381e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803822:	48 89 d6             	mov    %rdx,%rsi
  803825:	89 df                	mov    %ebx,%edi
  803827:	ff d0                	callq  *%rax
			break;
  803829:	eb 2e                	jmp    803859 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80382b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80382f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803833:	48 89 d6             	mov    %rdx,%rsi
  803836:	bf 25 00 00 00       	mov    $0x25,%edi
  80383b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80383d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803842:	eb 05                	jmp    803849 <vprintfmt+0x4f3>
  803844:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803849:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80384d:	48 83 e8 01          	sub    $0x1,%rax
  803851:	0f b6 00             	movzbl (%rax),%eax
  803854:	3c 25                	cmp    $0x25,%al
  803856:	75 ec                	jne    803844 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  803858:	90                   	nop
		}
	}
  803859:	e9 31 fb ff ff       	jmpq   80338f <vprintfmt+0x39>
	va_end(aq);
}
  80385e:	48 83 c4 60          	add    $0x60,%rsp
  803862:	5b                   	pop    %rbx
  803863:	41 5c                	pop    %r12
  803865:	5d                   	pop    %rbp
  803866:	c3                   	retq   

0000000000803867 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803867:	55                   	push   %rbp
  803868:	48 89 e5             	mov    %rsp,%rbp
  80386b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803872:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803879:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803880:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803887:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80388e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803895:	84 c0                	test   %al,%al
  803897:	74 20                	je     8038b9 <printfmt+0x52>
  803899:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80389d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8038a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8038a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8038a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8038ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8038b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8038b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8038b9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8038c0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8038c7:	00 00 00 
  8038ca:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8038d1:	00 00 00 
  8038d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8038d8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8038df:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8038e6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8038ed:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8038f4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8038fb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803902:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803909:	48 89 c7             	mov    %rax,%rdi
  80390c:	48 b8 56 33 80 00 00 	movabs $0x803356,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
	va_end(ap);
}
  803918:	c9                   	leaveq 
  803919:	c3                   	retq   

000000000080391a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80391a:	55                   	push   %rbp
  80391b:	48 89 e5             	mov    %rsp,%rbp
  80391e:	48 83 ec 10          	sub    $0x10,%rsp
  803922:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803925:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392d:	8b 40 10             	mov    0x10(%rax),%eax
  803930:	8d 50 01             	lea    0x1(%rax),%edx
  803933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803937:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80393a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393e:	48 8b 10             	mov    (%rax),%rdx
  803941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803945:	48 8b 40 08          	mov    0x8(%rax),%rax
  803949:	48 39 c2             	cmp    %rax,%rdx
  80394c:	73 17                	jae    803965 <sprintputch+0x4b>
		*b->buf++ = ch;
  80394e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803952:	48 8b 00             	mov    (%rax),%rax
  803955:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803959:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80395d:	48 89 0a             	mov    %rcx,(%rdx)
  803960:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803963:	88 10                	mov    %dl,(%rax)
}
  803965:	c9                   	leaveq 
  803966:	c3                   	retq   

0000000000803967 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803967:	55                   	push   %rbp
  803968:	48 89 e5             	mov    %rsp,%rbp
  80396b:	48 83 ec 50          	sub    $0x50,%rsp
  80396f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803973:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803976:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80397a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80397e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803982:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803986:	48 8b 0a             	mov    (%rdx),%rcx
  803989:	48 89 08             	mov    %rcx,(%rax)
  80398c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803990:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803994:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803998:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80399c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039a0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8039a4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8039a7:	48 98                	cltq   
  8039a9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8039ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039b1:	48 01 d0             	add    %rdx,%rax
  8039b4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8039b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8039bf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8039c4:	74 06                	je     8039cc <vsnprintf+0x65>
  8039c6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8039ca:	7f 07                	jg     8039d3 <vsnprintf+0x6c>
		return -E_INVAL;
  8039cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8039d1:	eb 2f                	jmp    803a02 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8039d3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8039d7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8039db:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039df:	48 89 c6             	mov    %rax,%rsi
  8039e2:	48 bf 1a 39 80 00 00 	movabs $0x80391a,%rdi
  8039e9:	00 00 00 
  8039ec:	48 b8 56 33 80 00 00 	movabs $0x803356,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8039f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039fc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8039ff:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803a02:	c9                   	leaveq 
  803a03:	c3                   	retq   

0000000000803a04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803a04:	55                   	push   %rbp
  803a05:	48 89 e5             	mov    %rsp,%rbp
  803a08:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803a0f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803a16:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803a1c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803a23:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803a2a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803a31:	84 c0                	test   %al,%al
  803a33:	74 20                	je     803a55 <snprintf+0x51>
  803a35:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803a39:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803a3d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803a41:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803a45:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803a49:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803a4d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803a51:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803a55:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803a5c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803a63:	00 00 00 
  803a66:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803a6d:	00 00 00 
  803a70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a74:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803a7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803a82:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803a89:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803a90:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803a97:	48 8b 0a             	mov    (%rdx),%rcx
  803a9a:	48 89 08             	mov    %rcx,(%rax)
  803a9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803aa1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803aa5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803aa9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803aad:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803ab4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803abb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803ac1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803ac8:	48 89 c7             	mov    %rax,%rdi
  803acb:	48 b8 67 39 80 00 00 	movabs $0x803967,%rax
  803ad2:	00 00 00 
  803ad5:	ff d0                	callq  *%rax
  803ad7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803add:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803ae3:	c9                   	leaveq 
  803ae4:	c3                   	retq   

0000000000803ae5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ae5:	55                   	push   %rbp
  803ae6:	48 89 e5             	mov    %rsp,%rbp
  803ae9:	48 83 ec 20          	sub    $0x20,%rsp
  803aed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803af1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803af5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803af9:	48 ba c8 44 80 00 00 	movabs $0x8044c8,%rdx
  803b00:	00 00 00 
  803b03:	be 1d 00 00 00       	mov    $0x1d,%esi
  803b08:	48 bf e1 44 80 00 00 	movabs $0x8044e1,%rdi
  803b0f:	00 00 00 
  803b12:	b8 00 00 00 00       	mov    $0x0,%eax
  803b17:	48 b9 7e 2d 80 00 00 	movabs $0x802d7e,%rcx
  803b1e:	00 00 00 
  803b21:	ff d1                	callq  *%rcx

0000000000803b23 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b23:	55                   	push   %rbp
  803b24:	48 89 e5             	mov    %rsp,%rbp
  803b27:	48 83 ec 20          	sub    $0x20,%rsp
  803b2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b2e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b31:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803b35:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803b38:	48 ba eb 44 80 00 00 	movabs $0x8044eb,%rdx
  803b3f:	00 00 00 
  803b42:	be 2d 00 00 00       	mov    $0x2d,%esi
  803b47:	48 bf e1 44 80 00 00 	movabs $0x8044e1,%rdi
  803b4e:	00 00 00 
  803b51:	b8 00 00 00 00       	mov    $0x0,%eax
  803b56:	48 b9 7e 2d 80 00 00 	movabs $0x802d7e,%rcx
  803b5d:	00 00 00 
  803b60:	ff d1                	callq  *%rcx

0000000000803b62 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803b62:	55                   	push   %rbp
  803b63:	48 89 e5             	mov    %rsp,%rbp
  803b66:	53                   	push   %rbx
  803b67:	48 83 ec 48          	sub    $0x48,%rsp
  803b6b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803b6f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803b76:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803b7d:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803b82:	75 0e                	jne    803b92 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803b84:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803b8b:	00 00 00 
  803b8e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803b92:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803b96:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803b9a:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803ba1:	00 
	a3 = (uint64_t) 0;
  803ba2:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803ba9:	00 
	a4 = (uint64_t) 0;
  803baa:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803bb1:	00 
	a5 = 0;
  803bb2:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803bb9:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803bba:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803bbd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803bc1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803bc5:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803bc9:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803bcd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803bd1:	4c 89 c3             	mov    %r8,%rbx
  803bd4:	0f 01 c1             	vmcall 
  803bd7:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803bda:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bde:	7e 36                	jle    803c16 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803be0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803be3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803be6:	41 89 d0             	mov    %edx,%r8d
  803be9:	89 c1                	mov    %eax,%ecx
  803beb:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  803bf2:	00 00 00 
  803bf5:	be 54 00 00 00       	mov    $0x54,%esi
  803bfa:	48 bf e1 44 80 00 00 	movabs $0x8044e1,%rdi
  803c01:	00 00 00 
  803c04:	b8 00 00 00 00       	mov    $0x0,%eax
  803c09:	49 b9 7e 2d 80 00 00 	movabs $0x802d7e,%r9
  803c10:	00 00 00 
  803c13:	41 ff d1             	callq  *%r9
	return ret;
  803c16:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c19:	48 83 c4 48          	add    $0x48,%rsp
  803c1d:	5b                   	pop    %rbx
  803c1e:	5d                   	pop    %rbp
  803c1f:	c3                   	retq   

0000000000803c20 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c20:	55                   	push   %rbp
  803c21:	48 89 e5             	mov    %rsp,%rbp
  803c24:	53                   	push   %rbx
  803c25:	48 83 ec 58          	sub    $0x58,%rsp
  803c29:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803c2c:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803c2f:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803c33:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803c36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803c3d:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803c44:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803c49:	75 0e                	jne    803c59 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803c4b:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803c52:	00 00 00 
  803c55:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803c59:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803c5c:	48 98                	cltq   
  803c5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803c62:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803c65:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803c69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c6d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803c71:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803c74:	48 98                	cltq   
  803c76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803c7a:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803c81:	00 

	int r = -E_IPC_NOT_RECV;
  803c82:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803c89:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803c8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c90:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c94:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803c98:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803c9c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803ca0:	4c 89 c3             	mov    %r8,%rbx
  803ca3:	0f 01 c1             	vmcall 
  803ca6:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803ca9:	48 83 c4 58          	add    $0x58,%rsp
  803cad:	5b                   	pop    %rbx
  803cae:	5d                   	pop    %rbp
  803caf:	c3                   	retq   

0000000000803cb0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803cb0:	55                   	push   %rbp
  803cb1:	48 89 e5             	mov    %rsp,%rbp
  803cb4:	48 83 ec 18          	sub    $0x18,%rsp
  803cb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cc2:	eb 4e                	jmp    803d12 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803cc4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ccb:	00 00 00 
  803cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd1:	48 98                	cltq   
  803cd3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803cda:	48 01 d0             	add    %rdx,%rax
  803cdd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ce3:	8b 00                	mov    (%rax),%eax
  803ce5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ce8:	75 24                	jne    803d0e <ipc_find_env+0x5e>
			return envs[i].env_id;
  803cea:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803cf1:	00 00 00 
  803cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf7:	48 98                	cltq   
  803cf9:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803d00:	48 01 d0             	add    %rdx,%rax
  803d03:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d09:	8b 40 08             	mov    0x8(%rax),%eax
  803d0c:	eb 12                	jmp    803d20 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803d0e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d12:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d19:	7e a9                	jle    803cc4 <ipc_find_env+0x14>
	}
	return 0;
  803d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d20:	c9                   	leaveq 
  803d21:	c3                   	retq   

0000000000803d22 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d22:	55                   	push   %rbp
  803d23:	48 89 e5             	mov    %rsp,%rbp
  803d26:	48 83 ec 18          	sub    $0x18,%rsp
  803d2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d32:	48 c1 e8 15          	shr    $0x15,%rax
  803d36:	48 89 c2             	mov    %rax,%rdx
  803d39:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d40:	01 00 00 
  803d43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d47:	83 e0 01             	and    $0x1,%eax
  803d4a:	48 85 c0             	test   %rax,%rax
  803d4d:	75 07                	jne    803d56 <pageref+0x34>
		return 0;
  803d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d54:	eb 53                	jmp    803da9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d5e:	48 89 c2             	mov    %rax,%rdx
  803d61:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d68:	01 00 00 
  803d6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d77:	83 e0 01             	and    $0x1,%eax
  803d7a:	48 85 c0             	test   %rax,%rax
  803d7d:	75 07                	jne    803d86 <pageref+0x64>
		return 0;
  803d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d84:	eb 23                	jmp    803da9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d8a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d8e:	48 89 c2             	mov    %rax,%rdx
  803d91:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d98:	00 00 00 
  803d9b:	48 c1 e2 04          	shl    $0x4,%rdx
  803d9f:	48 01 d0             	add    %rdx,%rax
  803da2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803da6:	0f b7 c0             	movzwl %ax,%eax
}
  803da9:	c9                   	leaveq 
  803daa:	c3                   	retq   
