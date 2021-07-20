
vmm/guest/obj/user/testfile:     formato del fichero elf64-x86-64


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
  80003c:	e8 1a 0c 00 00       	callq  800c5b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  800060:	00 00 00 
  800063:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec d8 02 00 00 	sub    $0x2d8,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf e6 48 80 00 00 	movabs $0x8048e6,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba f1 48 80 00 00 	movabs $0x8048f1,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 20 49 80 00 00 	movabs $0x804920,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 41 49 80 00 00 	movabs $0x804941,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 4a 49 80 00 00 	movabs $0x80494a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba 68 49 80 00 00 	movabs $0x804968,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba a9 49 80 00 00 	movabs $0x8049a9,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 c2                	mov    %eax,%edx
  8002c2:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002c5:	39 c2                	cmp    %eax,%edx
  8002c7:	74 51                	je     80031a <umain+0x242>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002d0:	00 00 00 
  8002d3:	48 8b 00             	mov    (%rax),%rax
  8002d6:	48 89 c7             	mov    %rax,%rdi
  8002d9:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax
  8002e5:	89 c2                	mov    %eax,%edx
  8002e7:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002ea:	41 89 d0             	mov    %edx,%r8d
  8002ed:	89 c1                	mov    %eax,%ecx
  8002ef:	48 ba b8 49 80 00 00 	movabs $0x8049b8,%rdx
  8002f6:	00 00 00 
  8002f9:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fe:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800305:	00 00 00 
  800308:	b8 00 00 00 00       	mov    $0x0,%eax
  80030d:	49 b9 de 0c 80 00 00 	movabs $0x800cde,%r9
  800314:	00 00 00 
  800317:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  80031a:	48 bf de 49 80 00 00 	movabs $0x8049de,%rdi
  800321:	00 00 00 
  800324:	b8 00 00 00 00       	mov    $0x0,%eax
  800329:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800330:	00 00 00 
  800333:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800335:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033c:	ba 00 02 00 00       	mov    $0x200,%edx
  800341:	be 00 00 00 00       	mov    $0x0,%esi
  800346:	48 89 c7             	mov    %rax,%rdi
  800349:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  800350:	00 00 00 
  800353:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800355:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80035c:	00 00 00 
  80035f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800363:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  80036a:	ba 00 02 00 00       	mov    $0x200,%edx
  80036f:	48 89 ce             	mov    %rcx,%rsi
  800372:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800377:	ff d0                	callq  *%rax
  800379:	48 98                	cltq   
  80037b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800384:	79 32                	jns    8003b8 <umain+0x2e0>
		panic("file_read: %e", r);
  800386:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80038a:	48 89 c1             	mov    %rax,%rcx
  80038d:	48 ba f1 49 80 00 00 	movabs $0x8049f1,%rdx
  800394:	00 00 00 
  800397:	be 32 00 00 00       	mov    $0x32,%esi
  80039c:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  8003a3:	00 00 00 
  8003a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ab:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  8003b2:	00 00 00 
  8003b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003bf:	00 00 00 
  8003c2:	48 8b 10             	mov    (%rax),%rdx
  8003c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003cc:	48 89 d6             	mov    %rdx,%rsi
  8003cf:	48 89 c7             	mov    %rax,%rdi
  8003d2:	48 b8 13 1c 80 00 00 	movabs $0x801c13,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	callq  *%rax
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	74 2a                	je     80040c <umain+0x334>
		panic("file_read returned wrong data");
  8003e2:	48 ba ff 49 80 00 00 	movabs $0x8049ff,%rdx
  8003e9:	00 00 00 
  8003ec:	be 34 00 00 00       	mov    $0x34,%esi
  8003f1:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  8003f8:	00 00 00 
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800400:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  800407:	00 00 00 
  80040a:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040c:	48 bf 1d 4a 80 00 00 	movabs $0x804a1d,%rdi
  800413:	00 00 00 
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
  80041b:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800422:	00 00 00 
  800425:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800427:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80042e:	00 00 00 
  800431:	48 8b 40 20          	mov    0x20(%rax),%rax
  800435:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80043a:	ff d0                	callq  *%rax
  80043c:	48 98                	cltq   
  80043e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800442:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800447:	79 32                	jns    80047b <umain+0x3a3>
		panic("file_close: %e", r);
  800449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044d:	48 89 c1             	mov    %rax,%rcx
  800450:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  800457:	00 00 00 
  80045a:	be 38 00 00 00       	mov    $0x38,%esi
  80045f:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800466:	00 00 00 
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  800475:	00 00 00 
  800478:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  80047b:	48 bf 3f 4a 80 00 00 	movabs $0x804a3f,%rdi
  800482:	00 00 00 
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800491:	00 00 00 
  800494:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800496:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  80049b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049f:	48 8b 00             	mov    (%rax),%rax
  8004a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004aa:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004af:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b4:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004c0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8004c7:	00 00 00 
  8004ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004ce:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d5:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d9:	ba 00 02 00 00       	mov    $0x200,%edx
  8004de:	48 89 cf             	mov    %rcx,%rdi
  8004e1:	ff d0                	callq  *%rax
  8004e3:	48 98                	cltq   
  8004e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e9:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ee:	74 32                	je     800522 <umain+0x44a>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f4:	48 89 c1             	mov    %rax,%rcx
  8004f7:	48 ba 58 4a 80 00 00 	movabs $0x804a58,%rdx
  8004fe:	00 00 00 
  800501:	be 43 00 00 00       	mov    $0x43,%esi
  800506:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  80050d:	00 00 00 
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  80051c:	00 00 00 
  80051f:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800522:	48 bf 8f 4a 80 00 00 	movabs $0x804a8f,%rdi
  800529:	00 00 00 
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
  800531:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800538:	00 00 00 
  80053b:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053d:	be 02 01 00 00       	mov    $0x102,%esi
  800542:	48 bf a5 4a 80 00 00 	movabs $0x804aa5,%rdi
  800549:	00 00 00 
  80054c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800553:	00 00 00 
  800556:	ff d0                	callq  *%rax
  800558:	48 98                	cltq   
  80055a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800563:	79 32                	jns    800597 <umain+0x4bf>
		panic("serve_open /new-file: %e", r);
  800565:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800569:	48 89 c1             	mov    %rax,%rcx
  80056c:	48 ba af 4a 80 00 00 	movabs $0x804aaf,%rdx
  800573:	00 00 00 
  800576:	be 48 00 00 00       	mov    $0x48,%esi
  80057b:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800582:	00 00 00 
  800585:	b8 00 00 00 00       	mov    $0x0,%eax
  80058a:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  800591:	00 00 00 
  800594:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800597:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80059e:	00 00 00 
  8005a1:	48 8b 10             	mov    (%rax),%rdx
  8005a4:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005ab:	00 00 00 
  8005ae:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b2:	48 83 ec 08          	sub    $0x8,%rsp
  8005b6:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005bd:	00 00 00 
  8005c0:	ff 70 30             	pushq  0x30(%rax)
  8005c3:	ff 70 28             	pushq  0x28(%rax)
  8005c6:	ff 70 20             	pushq  0x20(%rax)
  8005c9:	ff 70 18             	pushq  0x18(%rax)
  8005cc:	ff 70 10             	pushq  0x10(%rax)
  8005cf:	ff 70 08             	pushq  0x8(%rax)
  8005d2:	ff 30                	pushq  (%rax)
  8005d4:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005d9:	48 bf c8 4a 80 00 00 	movabs $0x804ac8,%rdi
  8005e0:	00 00 00 
  8005e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e8:	49 b8 17 0f 80 00 00 	movabs $0x800f17,%r8
  8005ef:	00 00 00 
  8005f2:	41 ff d0             	callq  *%r8
  8005f5:	48 83 c4 40          	add    $0x40,%rsp

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  8005f9:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  800600:	00 00 00 
  800603:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800607:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80060e:	00 00 00 
  800611:	48 8b 00             	mov    (%rax),%rax
  800614:	48 89 c7             	mov    %rax,%rdi
  800617:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  80061e:	00 00 00 
  800621:	ff d0                	callq  *%rax
  800623:	48 63 d0             	movslq %eax,%rdx
  800626:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c6             	mov    %rax,%rsi
  800636:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80063b:	ff d3                	callq  *%rbx
  80063d:	48 98                	cltq   
  80063f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800643:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80064a:	00 00 00 
  80064d:	48 8b 00             	mov    (%rax),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	48 98                	cltq   
  800661:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800665:	74 32                	je     800699 <umain+0x5c1>
		panic("file_write: %e", r);
  800667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80066b:	48 89 c1             	mov    %rax,%rcx
  80066e:	48 ba 08 4b 80 00 00 	movabs $0x804b08,%rdx
  800675:	00 00 00 
  800678:	be 4d 00 00 00       	mov    $0x4d,%esi
  80067d:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800684:	00 00 00 
  800687:	b8 00 00 00 00       	mov    $0x0,%eax
  80068c:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  800693:	00 00 00 
  800696:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  800699:	48 bf 17 4b 80 00 00 	movabs $0x804b17,%rdi
  8006a0:	00 00 00 
  8006a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a8:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  8006af:	00 00 00 
  8006b2:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006b4:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006c0:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006c7:	ba 00 02 00 00       	mov    $0x200,%edx
  8006cc:	be 00 00 00 00       	mov    $0x0,%esi
  8006d1:	48 89 c7             	mov    %rax,%rdi
  8006d4:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  8006db:	00 00 00 
  8006de:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006e0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8006e7:	00 00 00 
  8006ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  8006ee:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  8006f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8006fa:	48 89 ce             	mov    %rcx,%rsi
  8006fd:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800702:	ff d0                	callq  *%rax
  800704:	48 98                	cltq   
  800706:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80070a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80070f:	79 32                	jns    800743 <umain+0x66b>
		panic("file_read after file_write: %e", r);
  800711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800715:	48 89 c1             	mov    %rax,%rcx
  800718:	48 ba 30 4b 80 00 00 	movabs $0x804b30,%rdx
  80071f:	00 00 00 
  800722:	be 53 00 00 00       	mov    $0x53,%esi
  800727:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  80072e:	00 00 00 
  800731:	b8 00 00 00 00       	mov    $0x0,%eax
  800736:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  80073d:	00 00 00 
  800740:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800743:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80074a:	00 00 00 
  80074d:	48 8b 00             	mov    (%rax),%rax
  800750:	48 89 c7             	mov    %rax,%rdi
  800753:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  80075a:	00 00 00 
  80075d:	ff d0                	callq  *%rax
  80075f:	48 98                	cltq   
  800761:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800765:	74 32                	je     800799 <umain+0x6c1>
		panic("file_read after file_write returned wrong length: %d", r);
  800767:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80076b:	48 89 c1             	mov    %rax,%rcx
  80076e:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  800775:	00 00 00 
  800778:	be 55 00 00 00       	mov    $0x55,%esi
  80077d:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800784:	00 00 00 
  800787:	b8 00 00 00 00       	mov    $0x0,%eax
  80078c:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  800793:	00 00 00 
  800796:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  800799:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8007a0:	00 00 00 
  8007a3:	48 8b 10             	mov    (%rax),%rdx
  8007a6:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007ad:	48 89 d6             	mov    %rdx,%rsi
  8007b0:	48 89 c7             	mov    %rax,%rdi
  8007b3:	48 b8 13 1c 80 00 00 	movabs $0x801c13,%rax
  8007ba:	00 00 00 
  8007bd:	ff d0                	callq  *%rax
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	74 2a                	je     8007ed <umain+0x715>
		panic("file_read after file_write returned wrong data");
  8007c3:	48 ba 88 4b 80 00 00 	movabs $0x804b88,%rdx
  8007ca:	00 00 00 
  8007cd:	be 57 00 00 00       	mov    $0x57,%esi
  8007d2:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  8007d9:	00 00 00 
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  8007e8:	00 00 00 
  8007eb:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  8007ed:	48 bf b8 4b 80 00 00 	movabs $0x804bb8,%rdi
  8007f4:	00 00 00 
  8007f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fc:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800803:	00 00 00 
  800806:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800808:	be 00 00 00 00       	mov    $0x0,%esi
  80080d:	48 bf e6 48 80 00 00 	movabs $0x8048e6,%rdi
  800814:	00 00 00 
  800817:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
  800823:	48 98                	cltq   
  800825:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800829:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80082e:	79 39                	jns    800869 <umain+0x791>
  800830:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800835:	74 32                	je     800869 <umain+0x791>
		panic("open /not-found: %e", r);
  800837:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80083b:	48 89 c1             	mov    %rax,%rcx
  80083e:	48 ba dc 4b 80 00 00 	movabs $0x804bdc,%rdx
  800845:	00 00 00 
  800848:	be 5c 00 00 00       	mov    $0x5c,%esi
  80084d:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800854:	00 00 00 
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  800863:	00 00 00 
  800866:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800869:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80086e:	78 2a                	js     80089a <umain+0x7c2>
		panic("open /not-found succeeded!");
  800870:	48 ba f0 4b 80 00 00 	movabs $0x804bf0,%rdx
  800877:	00 00 00 
  80087a:	be 5e 00 00 00       	mov    $0x5e,%esi
  80087f:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800886:	00 00 00 
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
  80088e:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  800895:	00 00 00 
  800898:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80089a:	be 00 00 00 00       	mov    $0x0,%esi
  80089f:	48 bf 41 49 80 00 00 	movabs $0x804941,%rdi
  8008a6:	00 00 00 
  8008a9:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  8008b0:	00 00 00 
  8008b3:	ff d0                	callq  *%rax
  8008b5:	48 98                	cltq   
  8008b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008c0:	79 32                	jns    8008f4 <umain+0x81c>
		panic("open /newmotd: %e", r);
  8008c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008c6:	48 89 c1             	mov    %rax,%rcx
  8008c9:	48 ba 0b 4c 80 00 00 	movabs $0x804c0b,%rdx
  8008d0:	00 00 00 
  8008d3:	be 61 00 00 00       	mov    $0x61,%esi
  8008d8:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  8008df:	00 00 00 
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e7:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  8008ee:	00 00 00 
  8008f1:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  8008f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008f8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8008fe:	48 c1 e0 0c          	shl    $0xc,%rax
  800902:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	83 f8 66             	cmp    $0x66,%eax
  80090f:	75 16                	jne    800927 <umain+0x84f>
  800911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800915:	8b 40 04             	mov    0x4(%rax),%eax
  800918:	85 c0                	test   %eax,%eax
  80091a:	75 0b                	jne    800927 <umain+0x84f>
  80091c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800920:	8b 40 08             	mov    0x8(%rax),%eax
  800923:	85 c0                	test   %eax,%eax
  800925:	74 2a                	je     800951 <umain+0x879>
		panic("open did not fill struct Fd correctly\n");
  800927:	48 ba 20 4c 80 00 00 	movabs $0x804c20,%rdx
  80092e:	00 00 00 
  800931:	be 64 00 00 00       	mov    $0x64,%esi
  800936:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  80093d:	00 00 00 
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  80094c:	00 00 00 
  80094f:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800951:	48 bf 47 4c 80 00 00 	movabs $0x804c47,%rdi
  800958:	00 00 00 
  80095b:	b8 00 00 00 00       	mov    $0x0,%eax
  800960:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800967:	00 00 00 
  80096a:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80096c:	be 01 01 00 00       	mov    $0x101,%esi
  800971:	48 bf 55 4c 80 00 00 	movabs $0x804c55,%rdi
  800978:	00 00 00 
  80097b:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
  800987:	48 98                	cltq   
  800989:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80098d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800992:	79 32                	jns    8009c6 <umain+0x8ee>
		panic("creat /big: %e", f);
  800994:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800998:	48 89 c1             	mov    %rax,%rcx
  80099b:	48 ba 5a 4c 80 00 00 	movabs $0x804c5a,%rdx
  8009a2:	00 00 00 
  8009a5:	be 69 00 00 00       	mov    $0x69,%esi
  8009aa:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  8009b1:	00 00 00 
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b9:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  8009c0:	00 00 00 
  8009c3:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009c6:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009cd:	ba 00 02 00 00       	mov    $0x200,%edx
  8009d2:	be 00 00 00 00       	mov    $0x0,%esi
  8009d7:	48 89 c7             	mov    %rax,%rdi
  8009da:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  8009e1:	00 00 00 
  8009e4:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8009e6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8009ed:	00 
  8009ee:	e9 84 00 00 00       	jmpq   800a77 <umain+0x99f>
		*(int*)buf = i;
  8009f3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a04:	89 c1                	mov    %eax,%ecx
  800a06:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a0d:	ba 00 02 00 00       	mov    $0x200,%edx
  800a12:	48 89 c6             	mov    %rax,%rsi
  800a15:	89 cf                	mov    %ecx,%edi
  800a17:	48 b8 e7 2f 80 00 00 	movabs $0x802fe7,%rax
  800a1e:	00 00 00 
  800a21:	ff d0                	callq  *%rax
  800a23:	48 98                	cltq   
  800a25:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a2e:	79 39                	jns    800a69 <umain+0x991>
			panic("write /big@%d: %e", i, r);
  800a30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	49 89 d0             	mov    %rdx,%r8
  800a3b:	48 89 c1             	mov    %rax,%rcx
  800a3e:	48 ba 69 4c 80 00 00 	movabs $0x804c69,%rdx
  800a45:	00 00 00 
  800a48:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a4d:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800a54:	00 00 00 
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5c:	49 b9 de 0c 80 00 00 	movabs $0x800cde,%r9
  800a63:	00 00 00 
  800a66:	41 ff d1             	callq  *%r9
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6d:	48 05 00 02 00 00    	add    $0x200,%rax
  800a73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a77:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a7e:	00 
  800a7f:	0f 8e 6e ff ff ff    	jle    8009f3 <umain+0x91b>
	}
	close(f);
  800a85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a89:	89 c7                	mov    %eax,%edi
  800a8b:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  800a92:	00 00 00 
  800a95:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800a97:	be 00 00 00 00       	mov    $0x0,%esi
  800a9c:	48 bf 55 4c 80 00 00 	movabs $0x804c55,%rdi
  800aa3:	00 00 00 
  800aa6:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 98                	cltq   
  800ab4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ab8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800abd:	79 32                	jns    800af1 <umain+0xa19>
		panic("open /big: %e", f);
  800abf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ac3:	48 89 c1             	mov    %rax,%rcx
  800ac6:	48 ba 7b 4c 80 00 00 	movabs $0x804c7b,%rdx
  800acd:	00 00 00 
  800ad0:	be 73 00 00 00       	mov    $0x73,%esi
  800ad5:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800adc:	00 00 00 
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  800aeb:	00 00 00 
  800aee:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800af1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800af8:	00 
  800af9:	e9 1c 01 00 00       	jmpq   800c1a <umain+0xb42>
		*(int*)buf = i;
  800afe:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b09:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b0f:	89 c1                	mov    %eax,%ecx
  800b11:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b18:	ba 00 02 00 00       	mov    $0x200,%edx
  800b1d:	48 89 c6             	mov    %rax,%rsi
  800b20:	89 cf                	mov    %ecx,%edi
  800b22:	48 b8 72 2f 80 00 00 	movabs $0x802f72,%rax
  800b29:	00 00 00 
  800b2c:	ff d0                	callq  *%rax
  800b2e:	48 98                	cltq   
  800b30:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b34:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b39:	79 39                	jns    800b74 <umain+0xa9c>
			panic("read /big@%d: %e", i, r);
  800b3b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b43:	49 89 d0             	mov    %rdx,%r8
  800b46:	48 89 c1             	mov    %rax,%rcx
  800b49:	48 ba 89 4c 80 00 00 	movabs $0x804c89,%rdx
  800b50:	00 00 00 
  800b53:	be 77 00 00 00       	mov    $0x77,%esi
  800b58:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800b5f:	00 00 00 
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	49 b9 de 0c 80 00 00 	movabs $0x800cde,%r9
  800b6e:	00 00 00 
  800b71:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b74:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b7b:	00 
  800b7c:	74 3f                	je     800bbd <umain+0xae5>
			panic("read /big from %d returned %d < %d bytes",
  800b7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b86:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800b8c:	49 89 d0             	mov    %rdx,%r8
  800b8f:	48 89 c1             	mov    %rax,%rcx
  800b92:	48 ba a0 4c 80 00 00 	movabs $0x804ca0,%rdx
  800b99:	00 00 00 
  800b9c:	be 7a 00 00 00       	mov    $0x7a,%esi
  800ba1:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800ba8:	00 00 00 
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	49 ba de 0c 80 00 00 	movabs $0x800cde,%r10
  800bb7:	00 00 00 
  800bba:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bbd:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bc4:	8b 00                	mov    (%rax),%eax
  800bc6:	48 98                	cltq   
  800bc8:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800bcc:	74 3e                	je     800c0c <umain+0xb34>
			panic("read /big from %d returned bad data %d",
  800bce:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bd5:	8b 10                	mov    (%rax),%edx
  800bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdb:	41 89 d0             	mov    %edx,%r8d
  800bde:	48 89 c1             	mov    %rax,%rcx
  800be1:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  800be8:	00 00 00 
  800beb:	be 7d 00 00 00       	mov    $0x7d,%esi
  800bf0:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  800bf7:	00 00 00 
  800bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800bff:	49 b9 de 0c 80 00 00 	movabs $0x800cde,%r9
  800c06:	00 00 00 
  800c09:	41 ff d1             	callq  *%r9
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c10:	48 05 00 02 00 00    	add    $0x200,%rax
  800c16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c1a:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c21:	00 
  800c22:	0f 8e d6 fe ff ff    	jle    800afe <umain+0xa26>
			      i, *(int*)buf);
	}
	close(f);
  800c28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c2c:	89 c7                	mov    %eax,%edi
  800c2e:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  800c35:	00 00 00 
  800c38:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c3a:	48 bf f7 4c 80 00 00 	movabs $0x804cf7,%rdi
  800c41:	00 00 00 
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
  800c49:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800c50:	00 00 00 
  800c53:	ff d2                	callq  *%rdx
}
  800c55:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c59:	c9                   	leaveq 
  800c5a:	c3                   	retq   

0000000000800c5b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c5b:	55                   	push   %rbp
  800c5c:	48 89 e5             	mov    %rsp,%rbp
  800c5f:	48 83 ec 10          	sub    $0x10,%rsp
  800c63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800c6a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800c71:	00 00 00 
  800c74:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c7f:	7e 14                	jle    800c95 <libmain+0x3a>
		binaryname = argv[0];
  800c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c85:	48 8b 10             	mov    (%rax),%rdx
  800c88:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800c8f:	00 00 00 
  800c92:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c9c:	48 89 d6             	mov    %rdx,%rsi
  800c9f:	89 c7                	mov    %eax,%edi
  800ca1:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800ca8:	00 00 00 
  800cab:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cad:	48 b8 bb 0c 80 00 00 	movabs $0x800cbb,%rax
  800cb4:	00 00 00 
  800cb7:	ff d0                	callq  *%rax
}
  800cb9:	c9                   	leaveq 
  800cba:	c3                   	retq   

0000000000800cbb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800cbb:	55                   	push   %rbp
  800cbc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800cbf:	48 b8 c6 2c 80 00 00 	movabs $0x802cc6,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ccb:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd0:	48 b8 20 23 80 00 00 	movabs $0x802320,%rax
  800cd7:	00 00 00 
  800cda:	ff d0                	callq  *%rax
}
  800cdc:	5d                   	pop    %rbp
  800cdd:	c3                   	retq   

0000000000800cde <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800cde:	55                   	push   %rbp
  800cdf:	48 89 e5             	mov    %rsp,%rbp
  800ce2:	53                   	push   %rbx
  800ce3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800cea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800cf1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800cf7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800cfe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d05:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d0c:	84 c0                	test   %al,%al
  800d0e:	74 23                	je     800d33 <_panic+0x55>
  800d10:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d17:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d1b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d1f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d23:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d27:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d2b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d2f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d33:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d3a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d41:	00 00 00 
  800d44:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d4b:	00 00 00 
  800d4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d52:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d59:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800d60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d67:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d6e:	00 00 00 
  800d71:	48 8b 18             	mov    (%rax),%rbx
  800d74:	48 b8 66 23 80 00 00 	movabs $0x802366,%rax
  800d7b:	00 00 00 
  800d7e:	ff d0                	callq  *%rax
  800d80:	89 c6                	mov    %eax,%esi
  800d82:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800d88:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800d8f:	41 89 d0             	mov    %edx,%r8d
  800d92:	48 89 c1             	mov    %rax,%rcx
  800d95:	48 89 da             	mov    %rbx,%rdx
  800d98:	48 bf 18 4d 80 00 00 	movabs $0x804d18,%rdi
  800d9f:	00 00 00 
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
  800da7:	49 b9 17 0f 80 00 00 	movabs $0x800f17,%r9
  800dae:	00 00 00 
  800db1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800db4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800dbb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dc2:	48 89 d6             	mov    %rdx,%rsi
  800dc5:	48 89 c7             	mov    %rax,%rdi
  800dc8:	48 b8 6b 0e 80 00 00 	movabs $0x800e6b,%rax
  800dcf:	00 00 00 
  800dd2:	ff d0                	callq  *%rax
	cprintf("\n");
  800dd4:	48 bf 3b 4d 80 00 00 	movabs $0x804d3b,%rdi
  800ddb:	00 00 00 
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  800dea:	00 00 00 
  800ded:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800def:	cc                   	int3   
  800df0:	eb fd                	jmp    800def <_panic+0x111>

0000000000800df2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800df2:	55                   	push   %rbp
  800df3:	48 89 e5             	mov    %rsp,%rbp
  800df6:	48 83 ec 10          	sub    $0x10,%rsp
  800dfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e05:	8b 00                	mov    (%rax),%eax
  800e07:	8d 48 01             	lea    0x1(%rax),%ecx
  800e0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e0e:	89 0a                	mov    %ecx,(%rdx)
  800e10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e13:	89 d1                	mov    %edx,%ecx
  800e15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e19:	48 98                	cltq   
  800e1b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e23:	8b 00                	mov    (%rax),%eax
  800e25:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e2a:	75 2c                	jne    800e58 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e30:	8b 00                	mov    (%rax),%eax
  800e32:	48 98                	cltq   
  800e34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e38:	48 83 c2 08          	add    $0x8,%rdx
  800e3c:	48 89 c6             	mov    %rax,%rsi
  800e3f:	48 89 d7             	mov    %rdx,%rdi
  800e42:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  800e49:	00 00 00 
  800e4c:	ff d0                	callq  *%rax
        b->idx = 0;
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5c:	8b 40 04             	mov    0x4(%rax),%eax
  800e5f:	8d 50 01             	lea    0x1(%rax),%edx
  800e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e66:	89 50 04             	mov    %edx,0x4(%rax)
}
  800e69:	c9                   	leaveq 
  800e6a:	c3                   	retq   

0000000000800e6b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800e6b:	55                   	push   %rbp
  800e6c:	48 89 e5             	mov    %rsp,%rbp
  800e6f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800e76:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800e7d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800e84:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800e8b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800e92:	48 8b 0a             	mov    (%rdx),%rcx
  800e95:	48 89 08             	mov    %rcx,(%rax)
  800e98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ea8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800eaf:	00 00 00 
    b.cnt = 0;
  800eb2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800eb9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ebc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ec3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800eca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ed1:	48 89 c6             	mov    %rax,%rsi
  800ed4:	48 bf f2 0d 80 00 00 	movabs $0x800df2,%rdi
  800edb:	00 00 00 
  800ede:	48 b8 b6 12 80 00 00 	movabs $0x8012b6,%rax
  800ee5:	00 00 00 
  800ee8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800eea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800ef0:	48 98                	cltq   
  800ef2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800ef9:	48 83 c2 08          	add    $0x8,%rdx
  800efd:	48 89 c6             	mov    %rax,%rsi
  800f00:	48 89 d7             	mov    %rdx,%rdi
  800f03:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  800f0a:	00 00 00 
  800f0d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f15:	c9                   	leaveq 
  800f16:	c3                   	retq   

0000000000800f17 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f17:	55                   	push   %rbp
  800f18:	48 89 e5             	mov    %rsp,%rbp
  800f1b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f22:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f29:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f45:	84 c0                	test   %al,%al
  800f47:	74 20                	je     800f69 <cprintf+0x52>
  800f49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f69:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800f70:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800f77:	00 00 00 
  800f7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f81:	00 00 00 
  800f84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800f9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fab:	48 8b 0a             	mov    (%rdx),%rcx
  800fae:	48 89 08             	mov    %rcx,(%rax)
  800fb1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800fc1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800fc8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fcf:	48 89 d6             	mov    %rdx,%rsi
  800fd2:	48 89 c7             	mov    %rax,%rdi
  800fd5:	48 b8 6b 0e 80 00 00 	movabs $0x800e6b,%rax
  800fdc:	00 00 00 
  800fdf:	ff d0                	callq  *%rax
  800fe1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800fe7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fed:	c9                   	leaveq 
  800fee:	c3                   	retq   

0000000000800fef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fef:	55                   	push   %rbp
  800ff0:	48 89 e5             	mov    %rsp,%rbp
  800ff3:	48 83 ec 30          	sub    $0x30,%rsp
  800ff7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ffb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801003:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  801006:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80100a:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80100e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801011:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  801015:	77 42                	ja     801059 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801017:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80101a:	8d 78 ff             	lea    -0x1(%rax),%edi
  80101d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801024:	ba 00 00 00 00       	mov    $0x0,%edx
  801029:	48 f7 f6             	div    %rsi
  80102c:	49 89 c2             	mov    %rax,%r10
  80102f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801032:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801035:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801039:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103d:	41 89 c9             	mov    %ecx,%r9d
  801040:	41 89 f8             	mov    %edi,%r8d
  801043:	89 d1                	mov    %edx,%ecx
  801045:	4c 89 d2             	mov    %r10,%rdx
  801048:	48 89 c7             	mov    %rax,%rdi
  80104b:	48 b8 ef 0f 80 00 00 	movabs $0x800fef,%rax
  801052:	00 00 00 
  801055:	ff d0                	callq  *%rax
  801057:	eb 1e                	jmp    801077 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801059:	eb 12                	jmp    80106d <printnum+0x7e>
			putch(padc, putdat);
  80105b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80105f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801066:	48 89 ce             	mov    %rcx,%rsi
  801069:	89 d7                	mov    %edx,%edi
  80106b:	ff d0                	callq  *%rax
		while (--width > 0)
  80106d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  801071:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  801075:	7f e4                	jg     80105b <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801077:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	ba 00 00 00 00       	mov    $0x0,%edx
  801083:	48 f7 f1             	div    %rcx
  801086:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  80108d:	00 00 00 
  801090:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  801094:	0f be d0             	movsbl %al,%edx
  801097:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80109b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109f:	48 89 ce             	mov    %rcx,%rsi
  8010a2:	89 d7                	mov    %edx,%edi
  8010a4:	ff d0                	callq  *%rax
}
  8010a6:	c9                   	leaveq 
  8010a7:	c3                   	retq   

00000000008010a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010a8:	55                   	push   %rbp
  8010a9:	48 89 e5             	mov    %rsp,%rbp
  8010ac:	48 83 ec 20          	sub    $0x20,%rsp
  8010b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8010b7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010bb:	7e 4f                	jle    80110c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8010bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c1:	8b 00                	mov    (%rax),%eax
  8010c3:	83 f8 30             	cmp    $0x30,%eax
  8010c6:	73 24                	jae    8010ec <getuint+0x44>
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	8b 00                	mov    (%rax),%eax
  8010d6:	89 c0                	mov    %eax,%eax
  8010d8:	48 01 d0             	add    %rdx,%rax
  8010db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010df:	8b 12                	mov    (%rdx),%edx
  8010e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e8:	89 0a                	mov    %ecx,(%rdx)
  8010ea:	eb 14                	jmp    801100 <getuint+0x58>
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8010f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801100:	48 8b 00             	mov    (%rax),%rax
  801103:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801107:	e9 9d 00 00 00       	jmpq   8011a9 <getuint+0x101>
	else if (lflag)
  80110c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801110:	74 4c                	je     80115e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  801112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801116:	8b 00                	mov    (%rax),%eax
  801118:	83 f8 30             	cmp    $0x30,%eax
  80111b:	73 24                	jae    801141 <getuint+0x99>
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801129:	8b 00                	mov    (%rax),%eax
  80112b:	89 c0                	mov    %eax,%eax
  80112d:	48 01 d0             	add    %rdx,%rax
  801130:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801134:	8b 12                	mov    (%rdx),%edx
  801136:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801139:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80113d:	89 0a                	mov    %ecx,(%rdx)
  80113f:	eb 14                	jmp    801155 <getuint+0xad>
  801141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801145:	48 8b 40 08          	mov    0x8(%rax),%rax
  801149:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80114d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801151:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801155:	48 8b 00             	mov    (%rax),%rax
  801158:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80115c:	eb 4b                	jmp    8011a9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80115e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801162:	8b 00                	mov    (%rax),%eax
  801164:	83 f8 30             	cmp    $0x30,%eax
  801167:	73 24                	jae    80118d <getuint+0xe5>
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801175:	8b 00                	mov    (%rax),%eax
  801177:	89 c0                	mov    %eax,%eax
  801179:	48 01 d0             	add    %rdx,%rax
  80117c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801180:	8b 12                	mov    (%rdx),%edx
  801182:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801185:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801189:	89 0a                	mov    %ecx,(%rdx)
  80118b:	eb 14                	jmp    8011a1 <getuint+0xf9>
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	48 8b 40 08          	mov    0x8(%rax),%rax
  801195:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801199:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011a1:	8b 00                	mov    (%rax),%eax
  8011a3:	89 c0                	mov    %eax,%eax
  8011a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 83 ec 20          	sub    $0x20,%rsp
  8011b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011bb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8011be:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8011c2:	7e 4f                	jle    801213 <getint+0x64>
		x=va_arg(*ap, long long);
  8011c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c8:	8b 00                	mov    (%rax),%eax
  8011ca:	83 f8 30             	cmp    $0x30,%eax
  8011cd:	73 24                	jae    8011f3 <getint+0x44>
  8011cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	8b 00                	mov    (%rax),%eax
  8011dd:	89 c0                	mov    %eax,%eax
  8011df:	48 01 d0             	add    %rdx,%rax
  8011e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e6:	8b 12                	mov    (%rdx),%edx
  8011e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ef:	89 0a                	mov    %ecx,(%rdx)
  8011f1:	eb 14                	jmp    801207 <getint+0x58>
  8011f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011fb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8011ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801203:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801207:	48 8b 00             	mov    (%rax),%rax
  80120a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80120e:	e9 9d 00 00 00       	jmpq   8012b0 <getint+0x101>
	else if (lflag)
  801213:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801217:	74 4c                	je     801265 <getint+0xb6>
		x=va_arg(*ap, long);
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	8b 00                	mov    (%rax),%eax
  80121f:	83 f8 30             	cmp    $0x30,%eax
  801222:	73 24                	jae    801248 <getint+0x99>
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80122c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801230:	8b 00                	mov    (%rax),%eax
  801232:	89 c0                	mov    %eax,%eax
  801234:	48 01 d0             	add    %rdx,%rax
  801237:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123b:	8b 12                	mov    (%rdx),%edx
  80123d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801240:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801244:	89 0a                	mov    %ecx,(%rdx)
  801246:	eb 14                	jmp    80125c <getint+0xad>
  801248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801250:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801254:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801258:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80125c:	48 8b 00             	mov    (%rax),%rax
  80125f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801263:	eb 4b                	jmp    8012b0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  801265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801269:	8b 00                	mov    (%rax),%eax
  80126b:	83 f8 30             	cmp    $0x30,%eax
  80126e:	73 24                	jae    801294 <getint+0xe5>
  801270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801274:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127c:	8b 00                	mov    (%rax),%eax
  80127e:	89 c0                	mov    %eax,%eax
  801280:	48 01 d0             	add    %rdx,%rax
  801283:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801287:	8b 12                	mov    (%rdx),%edx
  801289:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80128c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801290:	89 0a                	mov    %ecx,(%rdx)
  801292:	eb 14                	jmp    8012a8 <getint+0xf9>
  801294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801298:	48 8b 40 08          	mov    0x8(%rax),%rax
  80129c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8012a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012a8:	8b 00                	mov    (%rax),%eax
  8012aa:	48 98                	cltq   
  8012ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8012b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b4:	c9                   	leaveq 
  8012b5:	c3                   	retq   

00000000008012b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8012b6:	55                   	push   %rbp
  8012b7:	48 89 e5             	mov    %rsp,%rbp
  8012ba:	41 54                	push   %r12
  8012bc:	53                   	push   %rbx
  8012bd:	48 83 ec 60          	sub    $0x60,%rsp
  8012c1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8012c5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8012c9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8012cd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8012d1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012d5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8012d9:	48 8b 0a             	mov    (%rdx),%rcx
  8012dc:	48 89 08             	mov    %rcx,(%rax)
  8012df:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012e3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012e7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012eb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012ef:	eb 17                	jmp    801308 <vprintfmt+0x52>
			if (ch == '\0')
  8012f1:	85 db                	test   %ebx,%ebx
  8012f3:	0f 84 c5 04 00 00    	je     8017be <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8012f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801301:	48 89 d6             	mov    %rdx,%rsi
  801304:	89 df                	mov    %ebx,%edi
  801306:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801308:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80130c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801310:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801314:	0f b6 00             	movzbl (%rax),%eax
  801317:	0f b6 d8             	movzbl %al,%ebx
  80131a:	83 fb 25             	cmp    $0x25,%ebx
  80131d:	75 d2                	jne    8012f1 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  80131f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801323:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80132a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801331:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801338:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80133f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801343:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801347:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80134b:	0f b6 00             	movzbl (%rax),%eax
  80134e:	0f b6 d8             	movzbl %al,%ebx
  801351:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801354:	83 f8 55             	cmp    $0x55,%eax
  801357:	0f 87 2e 04 00 00    	ja     80178b <vprintfmt+0x4d5>
  80135d:	89 c0                	mov    %eax,%eax
  80135f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801366:	00 
  801367:	48 b8 58 4f 80 00 00 	movabs $0x804f58,%rax
  80136e:	00 00 00 
  801371:	48 01 d0             	add    %rdx,%rax
  801374:	48 8b 00             	mov    (%rax),%rax
  801377:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801379:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80137d:	eb c0                	jmp    80133f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80137f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801383:	eb ba                	jmp    80133f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801385:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80138c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80138f:	89 d0                	mov    %edx,%eax
  801391:	c1 e0 02             	shl    $0x2,%eax
  801394:	01 d0                	add    %edx,%eax
  801396:	01 c0                	add    %eax,%eax
  801398:	01 d8                	add    %ebx,%eax
  80139a:	83 e8 30             	sub    $0x30,%eax
  80139d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8013a0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013aa:	83 fb 2f             	cmp    $0x2f,%ebx
  8013ad:	7e 0c                	jle    8013bb <vprintfmt+0x105>
  8013af:	83 fb 39             	cmp    $0x39,%ebx
  8013b2:	7f 07                	jg     8013bb <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  8013b4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8013b9:	eb d1                	jmp    80138c <vprintfmt+0xd6>
			goto process_precision;
  8013bb:	eb 50                	jmp    80140d <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8013bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013c0:	83 f8 30             	cmp    $0x30,%eax
  8013c3:	73 17                	jae    8013dc <vprintfmt+0x126>
  8013c5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013c9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013cc:	89 d2                	mov    %edx,%edx
  8013ce:	48 01 d0             	add    %rdx,%rax
  8013d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013d4:	83 c2 08             	add    $0x8,%edx
  8013d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013da:	eb 0c                	jmp    8013e8 <vprintfmt+0x132>
  8013dc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8013e0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8013e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013e8:	8b 00                	mov    (%rax),%eax
  8013ea:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8013ed:	eb 1e                	jmp    80140d <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8013ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013f3:	79 07                	jns    8013fc <vprintfmt+0x146>
				width = 0;
  8013f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8013fc:	e9 3e ff ff ff       	jmpq   80133f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801401:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801408:	e9 32 ff ff ff       	jmpq   80133f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80140d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801411:	79 0d                	jns    801420 <vprintfmt+0x16a>
				width = precision, precision = -1;
  801413:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801416:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801419:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801420:	e9 1a ff ff ff       	jmpq   80133f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801425:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801429:	e9 11 ff ff ff       	jmpq   80133f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80142e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801431:	83 f8 30             	cmp    $0x30,%eax
  801434:	73 17                	jae    80144d <vprintfmt+0x197>
  801436:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80143a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80143d:	89 d2                	mov    %edx,%edx
  80143f:	48 01 d0             	add    %rdx,%rax
  801442:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801445:	83 c2 08             	add    $0x8,%edx
  801448:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80144b:	eb 0c                	jmp    801459 <vprintfmt+0x1a3>
  80144d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801451:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801455:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801459:	8b 10                	mov    (%rax),%edx
  80145b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80145f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801463:	48 89 ce             	mov    %rcx,%rsi
  801466:	89 d7                	mov    %edx,%edi
  801468:	ff d0                	callq  *%rax
			break;
  80146a:	e9 4a 03 00 00       	jmpq   8017b9 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80146f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801472:	83 f8 30             	cmp    $0x30,%eax
  801475:	73 17                	jae    80148e <vprintfmt+0x1d8>
  801477:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80147b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80147e:	89 d2                	mov    %edx,%edx
  801480:	48 01 d0             	add    %rdx,%rax
  801483:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801486:	83 c2 08             	add    $0x8,%edx
  801489:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80148c:	eb 0c                	jmp    80149a <vprintfmt+0x1e4>
  80148e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801492:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801496:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80149a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80149c:	85 db                	test   %ebx,%ebx
  80149e:	79 02                	jns    8014a2 <vprintfmt+0x1ec>
				err = -err;
  8014a0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8014a2:	83 fb 15             	cmp    $0x15,%ebx
  8014a5:	7f 16                	jg     8014bd <vprintfmt+0x207>
  8014a7:	48 b8 80 4e 80 00 00 	movabs $0x804e80,%rax
  8014ae:	00 00 00 
  8014b1:	48 63 d3             	movslq %ebx,%rdx
  8014b4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8014b8:	4d 85 e4             	test   %r12,%r12
  8014bb:	75 2e                	jne    8014eb <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  8014bd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c5:	89 d9                	mov    %ebx,%ecx
  8014c7:	48 ba 41 4f 80 00 00 	movabs $0x804f41,%rdx
  8014ce:	00 00 00 
  8014d1:	48 89 c7             	mov    %rax,%rdi
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	49 b8 c7 17 80 00 00 	movabs $0x8017c7,%r8
  8014e0:	00 00 00 
  8014e3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014e6:	e9 ce 02 00 00       	jmpq   8017b9 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  8014eb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f3:	4c 89 e1             	mov    %r12,%rcx
  8014f6:	48 ba 4a 4f 80 00 00 	movabs $0x804f4a,%rdx
  8014fd:	00 00 00 
  801500:	48 89 c7             	mov    %rax,%rdi
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
  801508:	49 b8 c7 17 80 00 00 	movabs $0x8017c7,%r8
  80150f:	00 00 00 
  801512:	41 ff d0             	callq  *%r8
			break;
  801515:	e9 9f 02 00 00       	jmpq   8017b9 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80151a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151d:	83 f8 30             	cmp    $0x30,%eax
  801520:	73 17                	jae    801539 <vprintfmt+0x283>
  801522:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801526:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801529:	89 d2                	mov    %edx,%edx
  80152b:	48 01 d0             	add    %rdx,%rax
  80152e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801531:	83 c2 08             	add    $0x8,%edx
  801534:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801537:	eb 0c                	jmp    801545 <vprintfmt+0x28f>
  801539:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80153d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801541:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801545:	4c 8b 20             	mov    (%rax),%r12
  801548:	4d 85 e4             	test   %r12,%r12
  80154b:	75 0a                	jne    801557 <vprintfmt+0x2a1>
				p = "(null)";
  80154d:	49 bc 4d 4f 80 00 00 	movabs $0x804f4d,%r12
  801554:	00 00 00 
			if (width > 0 && padc != '-')
  801557:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80155b:	7e 3f                	jle    80159c <vprintfmt+0x2e6>
  80155d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801561:	74 39                	je     80159c <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801563:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801566:	48 98                	cltq   
  801568:	48 89 c6             	mov    %rax,%rsi
  80156b:	4c 89 e7             	mov    %r12,%rdi
  80156e:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  801575:	00 00 00 
  801578:	ff d0                	callq  *%rax
  80157a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80157d:	eb 17                	jmp    801596 <vprintfmt+0x2e0>
					putch(padc, putdat);
  80157f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801583:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801587:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80158b:	48 89 ce             	mov    %rcx,%rsi
  80158e:	89 d7                	mov    %edx,%edi
  801590:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  801592:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801596:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80159a:	7f e3                	jg     80157f <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80159c:	eb 37                	jmp    8015d5 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  80159e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8015a2:	74 1e                	je     8015c2 <vprintfmt+0x30c>
  8015a4:	83 fb 1f             	cmp    $0x1f,%ebx
  8015a7:	7e 05                	jle    8015ae <vprintfmt+0x2f8>
  8015a9:	83 fb 7e             	cmp    $0x7e,%ebx
  8015ac:	7e 14                	jle    8015c2 <vprintfmt+0x30c>
					putch('?', putdat);
  8015ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015b6:	48 89 d6             	mov    %rdx,%rsi
  8015b9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8015be:	ff d0                	callq  *%rax
  8015c0:	eb 0f                	jmp    8015d1 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  8015c2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015ca:	48 89 d6             	mov    %rdx,%rsi
  8015cd:	89 df                	mov    %ebx,%edi
  8015cf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8015d5:	4c 89 e0             	mov    %r12,%rax
  8015d8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	0f be d8             	movsbl %al,%ebx
  8015e2:	85 db                	test   %ebx,%ebx
  8015e4:	74 10                	je     8015f6 <vprintfmt+0x340>
  8015e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015ea:	78 b2                	js     80159e <vprintfmt+0x2e8>
  8015ec:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8015f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015f4:	79 a8                	jns    80159e <vprintfmt+0x2e8>
			for (; width > 0; width--)
  8015f6:	eb 16                	jmp    80160e <vprintfmt+0x358>
				putch(' ', putdat);
  8015f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801600:	48 89 d6             	mov    %rdx,%rsi
  801603:	bf 20 00 00 00       	mov    $0x20,%edi
  801608:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  80160a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80160e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801612:	7f e4                	jg     8015f8 <vprintfmt+0x342>
			break;
  801614:	e9 a0 01 00 00       	jmpq   8017b9 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801619:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80161d:	be 03 00 00 00       	mov    $0x3,%esi
  801622:	48 89 c7             	mov    %rax,%rdi
  801625:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	callq  *%rax
  801631:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801639:	48 85 c0             	test   %rax,%rax
  80163c:	79 1d                	jns    80165b <vprintfmt+0x3a5>
				putch('-', putdat);
  80163e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801642:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801646:	48 89 d6             	mov    %rdx,%rsi
  801649:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80164e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801654:	48 f7 d8             	neg    %rax
  801657:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80165b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801662:	e9 e5 00 00 00       	jmpq   80174c <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801667:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80166b:	be 03 00 00 00       	mov    $0x3,%esi
  801670:	48 89 c7             	mov    %rax,%rdi
  801673:	48 b8 a8 10 80 00 00 	movabs $0x8010a8,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
  80167f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801683:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80168a:	e9 bd 00 00 00       	jmpq   80174c <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80168f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801693:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801697:	48 89 d6             	mov    %rdx,%rsi
  80169a:	bf 58 00 00 00       	mov    $0x58,%edi
  80169f:	ff d0                	callq  *%rax
			putch('X', putdat);
  8016a1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016a5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016a9:	48 89 d6             	mov    %rdx,%rsi
  8016ac:	bf 58 00 00 00       	mov    $0x58,%edi
  8016b1:	ff d0                	callq  *%rax
			putch('X', putdat);
  8016b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016bb:	48 89 d6             	mov    %rdx,%rsi
  8016be:	bf 58 00 00 00       	mov    $0x58,%edi
  8016c3:	ff d0                	callq  *%rax
			break;
  8016c5:	e9 ef 00 00 00       	jmpq   8017b9 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  8016ca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016d2:	48 89 d6             	mov    %rdx,%rsi
  8016d5:	bf 30 00 00 00       	mov    $0x30,%edi
  8016da:	ff d0                	callq  *%rax
			putch('x', putdat);
  8016dc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016e4:	48 89 d6             	mov    %rdx,%rsi
  8016e7:	bf 78 00 00 00       	mov    $0x78,%edi
  8016ec:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8016ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016f1:	83 f8 30             	cmp    $0x30,%eax
  8016f4:	73 17                	jae    80170d <vprintfmt+0x457>
  8016f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8016fa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8016fd:	89 d2                	mov    %edx,%edx
  8016ff:	48 01 d0             	add    %rdx,%rax
  801702:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801705:	83 c2 08             	add    $0x8,%edx
  801708:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  80170b:	eb 0c                	jmp    801719 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  80170d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801711:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801715:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801719:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  80171c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801720:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801727:	eb 23                	jmp    80174c <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801729:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80172d:	be 03 00 00 00       	mov    $0x3,%esi
  801732:	48 89 c7             	mov    %rax,%rdi
  801735:	48 b8 a8 10 80 00 00 	movabs $0x8010a8,%rax
  80173c:	00 00 00 
  80173f:	ff d0                	callq  *%rax
  801741:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801745:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80174c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801751:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801754:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80175f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801763:	45 89 c1             	mov    %r8d,%r9d
  801766:	41 89 f8             	mov    %edi,%r8d
  801769:	48 89 c7             	mov    %rax,%rdi
  80176c:	48 b8 ef 0f 80 00 00 	movabs $0x800fef,%rax
  801773:	00 00 00 
  801776:	ff d0                	callq  *%rax
			break;
  801778:	eb 3f                	jmp    8017b9 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80177e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801782:	48 89 d6             	mov    %rdx,%rsi
  801785:	89 df                	mov    %ebx,%edi
  801787:	ff d0                	callq  *%rax
			break;
  801789:	eb 2e                	jmp    8017b9 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80178f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801793:	48 89 d6             	mov    %rdx,%rsi
  801796:	bf 25 00 00 00       	mov    $0x25,%edi
  80179b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017a2:	eb 05                	jmp    8017a9 <vprintfmt+0x4f3>
  8017a4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017a9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8017ad:	48 83 e8 01          	sub    $0x1,%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	3c 25                	cmp    $0x25,%al
  8017b6:	75 ec                	jne    8017a4 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  8017b8:	90                   	nop
		}
	}
  8017b9:	e9 31 fb ff ff       	jmpq   8012ef <vprintfmt+0x39>
	va_end(aq);
}
  8017be:	48 83 c4 60          	add    $0x60,%rsp
  8017c2:	5b                   	pop    %rbx
  8017c3:	41 5c                	pop    %r12
  8017c5:	5d                   	pop    %rbp
  8017c6:	c3                   	retq   

00000000008017c7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017c7:	55                   	push   %rbp
  8017c8:	48 89 e5             	mov    %rsp,%rbp
  8017cb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8017d2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8017d9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8017e0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017e7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017ee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017f5:	84 c0                	test   %al,%al
  8017f7:	74 20                	je     801819 <printfmt+0x52>
  8017f9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017fd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801801:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801805:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801809:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80180d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801811:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801815:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801819:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801820:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801827:	00 00 00 
  80182a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801831:	00 00 00 
  801834:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801838:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80183f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801846:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80184d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801854:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80185b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801862:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 b8 b6 12 80 00 00 	movabs $0x8012b6,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
	va_end(ap);
}
  801878:	c9                   	leaveq 
  801879:	c3                   	retq   

000000000080187a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80187a:	55                   	push   %rbp
  80187b:	48 89 e5             	mov    %rsp,%rbp
  80187e:	48 83 ec 10          	sub    $0x10,%rsp
  801882:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801885:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801889:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188d:	8b 40 10             	mov    0x10(%rax),%eax
  801890:	8d 50 01             	lea    0x1(%rax),%edx
  801893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801897:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80189a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189e:	48 8b 10             	mov    (%rax),%rdx
  8018a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018a9:	48 39 c2             	cmp    %rax,%rdx
  8018ac:	73 17                	jae    8018c5 <sprintputch+0x4b>
		*b->buf++ = ch;
  8018ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b2:	48 8b 00             	mov    (%rax),%rax
  8018b5:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8018b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bd:	48 89 0a             	mov    %rcx,(%rdx)
  8018c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018c3:	88 10                	mov    %dl,(%rax)
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 50          	sub    $0x50,%rsp
  8018cf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018d3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8018d6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8018da:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8018de:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8018e2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8018e6:	48 8b 0a             	mov    (%rdx),%rcx
  8018e9:	48 89 08             	mov    %rcx,(%rax)
  8018ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8018f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8018f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8018f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801900:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801904:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801907:	48 98                	cltq   
  801909:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80190d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801911:	48 01 d0             	add    %rdx,%rax
  801914:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801918:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80191f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801924:	74 06                	je     80192c <vsnprintf+0x65>
  801926:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80192a:	7f 07                	jg     801933 <vsnprintf+0x6c>
		return -E_INVAL;
  80192c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801931:	eb 2f                	jmp    801962 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801933:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801937:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80193b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80193f:	48 89 c6             	mov    %rax,%rsi
  801942:	48 bf 7a 18 80 00 00 	movabs $0x80187a,%rdi
  801949:	00 00 00 
  80194c:	48 b8 b6 12 80 00 00 	movabs $0x8012b6,%rax
  801953:	00 00 00 
  801956:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801958:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80195c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80195f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80196f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801976:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80197c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801983:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80198a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801991:	84 c0                	test   %al,%al
  801993:	74 20                	je     8019b5 <snprintf+0x51>
  801995:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801999:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80199d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8019a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8019a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8019a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8019ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8019b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8019b5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8019bc:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8019c3:	00 00 00 
  8019c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8019cd:	00 00 00 
  8019d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8019db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8019e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8019e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8019f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8019f7:	48 8b 0a             	mov    (%rdx),%rcx
  8019fa:	48 89 08             	mov    %rcx,(%rax)
  8019fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a01:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a05:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a09:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a0d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a14:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a1b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a21:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a28:	48 89 c7             	mov    %rax,%rdi
  801a2b:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  801a32:	00 00 00 
  801a35:	ff d0                	callq  *%rax
  801a37:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801a3d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 18          	sub    $0x18,%rsp
  801a4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a58:	eb 09                	jmp    801a63 <strlen+0x1e>
		n++;
  801a5a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801a5e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a67:	0f b6 00             	movzbl (%rax),%eax
  801a6a:	84 c0                	test   %al,%al
  801a6c:	75 ec                	jne    801a5a <strlen+0x15>
	return n;
  801a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 20          	sub    $0x20,%rsp
  801a7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a8a:	eb 0e                	jmp    801a9a <strnlen+0x27>
		n++;
  801a8c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a90:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a95:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801a9a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a9f:	74 0b                	je     801aac <strnlen+0x39>
  801aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa5:	0f b6 00             	movzbl (%rax),%eax
  801aa8:	84 c0                	test   %al,%al
  801aaa:	75 e0                	jne    801a8c <strnlen+0x19>
	return n;
  801aac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801aaf:	c9                   	leaveq 
  801ab0:	c3                   	retq   

0000000000801ab1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
  801ab5:	48 83 ec 20          	sub    $0x20,%rsp
  801ab9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801abd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801ac9:	90                   	nop
  801aca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ace:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ad2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ad6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801ada:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801ade:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801ae2:	0f b6 12             	movzbl (%rdx),%edx
  801ae5:	88 10                	mov    %dl,(%rax)
  801ae7:	0f b6 00             	movzbl (%rax),%eax
  801aea:	84 c0                	test   %al,%al
  801aec:	75 dc                	jne    801aca <strcpy+0x19>
		/* do nothing */;
	return ret;
  801aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801af2:	c9                   	leaveq 
  801af3:	c3                   	retq   

0000000000801af4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801af4:	55                   	push   %rbp
  801af5:	48 89 e5             	mov    %rsp,%rbp
  801af8:	48 83 ec 20          	sub    $0x20,%rsp
  801afc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b08:	48 89 c7             	mov    %rax,%rdi
  801b0b:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  801b12:	00 00 00 
  801b15:	ff d0                	callq  *%rax
  801b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1d:	48 63 d0             	movslq %eax,%rdx
  801b20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b24:	48 01 c2             	add    %rax,%rdx
  801b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b2b:	48 89 c6             	mov    %rax,%rsi
  801b2e:	48 89 d7             	mov    %rdx,%rdi
  801b31:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	callq  *%rax
	return dst;
  801b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b41:	c9                   	leaveq 
  801b42:	c3                   	retq   

0000000000801b43 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801b43:	55                   	push   %rbp
  801b44:	48 89 e5             	mov    %rsp,%rbp
  801b47:	48 83 ec 28          	sub    $0x28,%rsp
  801b4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b4f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b53:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801b57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801b5f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801b66:	00 
  801b67:	eb 2a                	jmp    801b93 <strncpy+0x50>
		*dst++ = *src;
  801b69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b71:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b75:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b79:	0f b6 12             	movzbl (%rdx),%edx
  801b7c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	84 c0                	test   %al,%al
  801b87:	74 05                	je     801b8e <strncpy+0x4b>
			src++;
  801b89:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801b8e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b97:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801b9b:	72 cc                	jb     801b69 <strncpy+0x26>
	}
	return ret;
  801b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 28          	sub    $0x28,%rsp
  801bab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801baf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801bbf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bc4:	74 3d                	je     801c03 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801bc6:	eb 1d                	jmp    801be5 <strlcpy+0x42>
			*dst++ = *src++;
  801bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bcc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bd0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bd4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bd8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801bdc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801be0:	0f b6 12             	movzbl (%rdx),%edx
  801be3:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801be5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801bea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bef:	74 0b                	je     801bfc <strlcpy+0x59>
  801bf1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bf5:	0f b6 00             	movzbl (%rax),%eax
  801bf8:	84 c0                	test   %al,%al
  801bfa:	75 cc                	jne    801bc8 <strlcpy+0x25>
		*dst = '\0';
  801bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c00:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0b:	48 29 c2             	sub    %rax,%rdx
  801c0e:	48 89 d0             	mov    %rdx,%rax
}
  801c11:	c9                   	leaveq 
  801c12:	c3                   	retq   

0000000000801c13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c13:	55                   	push   %rbp
  801c14:	48 89 e5             	mov    %rsp,%rbp
  801c17:	48 83 ec 10          	sub    $0x10,%rsp
  801c1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c23:	eb 0a                	jmp    801c2f <strcmp+0x1c>
		p++, q++;
  801c25:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c2a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801c2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c33:	0f b6 00             	movzbl (%rax),%eax
  801c36:	84 c0                	test   %al,%al
  801c38:	74 12                	je     801c4c <strcmp+0x39>
  801c3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3e:	0f b6 10             	movzbl (%rax),%edx
  801c41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c45:	0f b6 00             	movzbl (%rax),%eax
  801c48:	38 c2                	cmp    %al,%dl
  801c4a:	74 d9                	je     801c25 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c50:	0f b6 00             	movzbl (%rax),%eax
  801c53:	0f b6 d0             	movzbl %al,%edx
  801c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5a:	0f b6 00             	movzbl (%rax),%eax
  801c5d:	0f b6 c0             	movzbl %al,%eax
  801c60:	29 c2                	sub    %eax,%edx
  801c62:	89 d0                	mov    %edx,%eax
}
  801c64:	c9                   	leaveq 
  801c65:	c3                   	retq   

0000000000801c66 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c66:	55                   	push   %rbp
  801c67:	48 89 e5             	mov    %rsp,%rbp
  801c6a:	48 83 ec 18          	sub    $0x18,%rsp
  801c6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c76:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801c7a:	eb 0f                	jmp    801c8b <strncmp+0x25>
		n--, p++, q++;
  801c7c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801c81:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c86:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801c8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c90:	74 1d                	je     801caf <strncmp+0x49>
  801c92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c96:	0f b6 00             	movzbl (%rax),%eax
  801c99:	84 c0                	test   %al,%al
  801c9b:	74 12                	je     801caf <strncmp+0x49>
  801c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca1:	0f b6 10             	movzbl (%rax),%edx
  801ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca8:	0f b6 00             	movzbl (%rax),%eax
  801cab:	38 c2                	cmp    %al,%dl
  801cad:	74 cd                	je     801c7c <strncmp+0x16>
	if (n == 0)
  801caf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cb4:	75 07                	jne    801cbd <strncmp+0x57>
		return 0;
  801cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbb:	eb 18                	jmp    801cd5 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc1:	0f b6 00             	movzbl (%rax),%eax
  801cc4:	0f b6 d0             	movzbl %al,%edx
  801cc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccb:	0f b6 00             	movzbl (%rax),%eax
  801cce:	0f b6 c0             	movzbl %al,%eax
  801cd1:	29 c2                	sub    %eax,%edx
  801cd3:	89 d0                	mov    %edx,%eax
}
  801cd5:	c9                   	leaveq 
  801cd6:	c3                   	retq   

0000000000801cd7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cd7:	55                   	push   %rbp
  801cd8:	48 89 e5             	mov    %rsp,%rbp
  801cdb:	48 83 ec 10          	sub    $0x10,%rsp
  801cdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ce3:	89 f0                	mov    %esi,%eax
  801ce5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801ce8:	eb 17                	jmp    801d01 <strchr+0x2a>
		if (*s == c)
  801cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cee:	0f b6 00             	movzbl (%rax),%eax
  801cf1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801cf4:	75 06                	jne    801cfc <strchr+0x25>
			return (char *) s;
  801cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfa:	eb 15                	jmp    801d11 <strchr+0x3a>
	for (; *s; s++)
  801cfc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d05:	0f b6 00             	movzbl (%rax),%eax
  801d08:	84 c0                	test   %al,%al
  801d0a:	75 de                	jne    801cea <strchr+0x13>
	return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
  801d17:	48 83 ec 10          	sub    $0x10,%rsp
  801d1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1f:	89 f0                	mov    %esi,%eax
  801d21:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d24:	eb 13                	jmp    801d39 <strfind+0x26>
		if (*s == c)
  801d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2a:	0f b6 00             	movzbl (%rax),%eax
  801d2d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d30:	75 02                	jne    801d34 <strfind+0x21>
			break;
  801d32:	eb 10                	jmp    801d44 <strfind+0x31>
	for (; *s; s++)
  801d34:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3d:	0f b6 00             	movzbl (%rax),%eax
  801d40:	84 c0                	test   %al,%al
  801d42:	75 e2                	jne    801d26 <strfind+0x13>
	return (char *) s;
  801d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801d48:	c9                   	leaveq 
  801d49:	c3                   	retq   

0000000000801d4a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	48 83 ec 18          	sub    $0x18,%rsp
  801d52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d56:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801d59:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801d5d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d62:	75 06                	jne    801d6a <memset+0x20>
		return v;
  801d64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d68:	eb 69                	jmp    801dd3 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801d6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6e:	83 e0 03             	and    $0x3,%eax
  801d71:	48 85 c0             	test   %rax,%rax
  801d74:	75 48                	jne    801dbe <memset+0x74>
  801d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d7a:	83 e0 03             	and    $0x3,%eax
  801d7d:	48 85 c0             	test   %rax,%rax
  801d80:	75 3c                	jne    801dbe <memset+0x74>
		c &= 0xFF;
  801d82:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d89:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d8c:	c1 e0 18             	shl    $0x18,%eax
  801d8f:	89 c2                	mov    %eax,%edx
  801d91:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d94:	c1 e0 10             	shl    $0x10,%eax
  801d97:	09 c2                	or     %eax,%edx
  801d99:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d9c:	c1 e0 08             	shl    $0x8,%eax
  801d9f:	09 d0                	or     %edx,%eax
  801da1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da8:	48 c1 e8 02          	shr    $0x2,%rax
  801dac:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801daf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801db3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801db6:	48 89 d7             	mov    %rdx,%rdi
  801db9:	fc                   	cld    
  801dba:	f3 ab                	rep stos %eax,%es:(%rdi)
  801dbc:	eb 11                	jmp    801dcf <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801dbe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dc2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dc5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dc9:	48 89 d7             	mov    %rdx,%rdi
  801dcc:	fc                   	cld    
  801dcd:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801dd3:	c9                   	leaveq 
  801dd4:	c3                   	retq   

0000000000801dd5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dd5:	55                   	push   %rbp
  801dd6:	48 89 e5             	mov    %rsp,%rbp
  801dd9:	48 83 ec 28          	sub    $0x28,%rsp
  801ddd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801de1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801de5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801de9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ded:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801df9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e01:	0f 83 88 00 00 00    	jae    801e8f <memmove+0xba>
  801e07:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0f:	48 01 d0             	add    %rdx,%rax
  801e12:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e16:	76 77                	jbe    801e8f <memmove+0xba>
		s += n;
  801e18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e1c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e24:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2c:	83 e0 03             	and    $0x3,%eax
  801e2f:	48 85 c0             	test   %rax,%rax
  801e32:	75 3b                	jne    801e6f <memmove+0x9a>
  801e34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e38:	83 e0 03             	and    $0x3,%eax
  801e3b:	48 85 c0             	test   %rax,%rax
  801e3e:	75 2f                	jne    801e6f <memmove+0x9a>
  801e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e44:	83 e0 03             	and    $0x3,%eax
  801e47:	48 85 c0             	test   %rax,%rax
  801e4a:	75 23                	jne    801e6f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e50:	48 83 e8 04          	sub    $0x4,%rax
  801e54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e58:	48 83 ea 04          	sub    $0x4,%rdx
  801e5c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801e60:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801e64:	48 89 c7             	mov    %rax,%rdi
  801e67:	48 89 d6             	mov    %rdx,%rsi
  801e6a:	fd                   	std    
  801e6b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801e6d:	eb 1d                	jmp    801e8c <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e73:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e83:	48 89 d7             	mov    %rdx,%rdi
  801e86:	48 89 c1             	mov    %rax,%rcx
  801e89:	fd                   	std    
  801e8a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e8c:	fc                   	cld    
  801e8d:	eb 57                	jmp    801ee6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e93:	83 e0 03             	and    $0x3,%eax
  801e96:	48 85 c0             	test   %rax,%rax
  801e99:	75 36                	jne    801ed1 <memmove+0xfc>
  801e9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9f:	83 e0 03             	and    $0x3,%eax
  801ea2:	48 85 c0             	test   %rax,%rax
  801ea5:	75 2a                	jne    801ed1 <memmove+0xfc>
  801ea7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eab:	83 e0 03             	and    $0x3,%eax
  801eae:	48 85 c0             	test   %rax,%rax
  801eb1:	75 1e                	jne    801ed1 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801eb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb7:	48 c1 e8 02          	shr    $0x2,%rax
  801ebb:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ec6:	48 89 c7             	mov    %rax,%rdi
  801ec9:	48 89 d6             	mov    %rdx,%rsi
  801ecc:	fc                   	cld    
  801ecd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ecf:	eb 15                	jmp    801ee6 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801ed1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801edd:	48 89 c7             	mov    %rax,%rdi
  801ee0:	48 89 d6             	mov    %rdx,%rsi
  801ee3:	fc                   	cld    
  801ee4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eea:	c9                   	leaveq 
  801eeb:	c3                   	retq   

0000000000801eec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801eec:	55                   	push   %rbp
  801eed:	48 89 e5             	mov    %rsp,%rbp
  801ef0:	48 83 ec 18          	sub    $0x18,%rsp
  801ef4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ef8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801efc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f04:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0c:	48 89 ce             	mov    %rcx,%rsi
  801f0f:	48 89 c7             	mov    %rax,%rdi
  801f12:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
}
  801f1e:	c9                   	leaveq 
  801f1f:	c3                   	retq   

0000000000801f20 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f20:	55                   	push   %rbp
  801f21:	48 89 e5             	mov    %rsp,%rbp
  801f24:	48 83 ec 28          	sub    $0x28,%rsp
  801f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801f3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801f44:	eb 36                	jmp    801f7c <memcmp+0x5c>
		if (*s1 != *s2)
  801f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4a:	0f b6 10             	movzbl (%rax),%edx
  801f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f51:	0f b6 00             	movzbl (%rax),%eax
  801f54:	38 c2                	cmp    %al,%dl
  801f56:	74 1a                	je     801f72 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801f58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5c:	0f b6 00             	movzbl (%rax),%eax
  801f5f:	0f b6 d0             	movzbl %al,%edx
  801f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f66:	0f b6 00             	movzbl (%rax),%eax
  801f69:	0f b6 c0             	movzbl %al,%eax
  801f6c:	29 c2                	sub    %eax,%edx
  801f6e:	89 d0                	mov    %edx,%eax
  801f70:	eb 20                	jmp    801f92 <memcmp+0x72>
		s1++, s2++;
  801f72:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f77:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801f7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f80:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801f88:	48 85 c0             	test   %rax,%rax
  801f8b:	75 b9                	jne    801f46 <memcmp+0x26>
	}

	return 0;
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f92:	c9                   	leaveq 
  801f93:	c3                   	retq   

0000000000801f94 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f94:	55                   	push   %rbp
  801f95:	48 89 e5             	mov    %rsp,%rbp
  801f98:	48 83 ec 28          	sub    $0x28,%rsp
  801f9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fa0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801fa3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801fa7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801faf:	48 01 d0             	add    %rdx,%rax
  801fb2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801fb6:	eb 15                	jmp    801fcd <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbc:	0f b6 00             	movzbl (%rax),%eax
  801fbf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801fc2:	38 d0                	cmp    %dl,%al
  801fc4:	75 02                	jne    801fc8 <memfind+0x34>
			break;
  801fc6:	eb 0f                	jmp    801fd7 <memfind+0x43>
	for (; s < ends; s++)
  801fc8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801fd5:	72 e1                	jb     801fb8 <memfind+0x24>
	return (void *) s;
  801fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801fdb:	c9                   	leaveq 
  801fdc:	c3                   	retq   

0000000000801fdd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fdd:	55                   	push   %rbp
  801fde:	48 89 e5             	mov    %rsp,%rbp
  801fe1:	48 83 ec 38          	sub    $0x38,%rsp
  801fe5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fe9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801fed:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801ff0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801ff7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801ffe:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fff:	eb 05                	jmp    802006 <strtol+0x29>
		s++;
  802001:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  802006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200a:	0f b6 00             	movzbl (%rax),%eax
  80200d:	3c 20                	cmp    $0x20,%al
  80200f:	74 f0                	je     802001 <strtol+0x24>
  802011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802015:	0f b6 00             	movzbl (%rax),%eax
  802018:	3c 09                	cmp    $0x9,%al
  80201a:	74 e5                	je     802001 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80201c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802020:	0f b6 00             	movzbl (%rax),%eax
  802023:	3c 2b                	cmp    $0x2b,%al
  802025:	75 07                	jne    80202e <strtol+0x51>
		s++;
  802027:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80202c:	eb 17                	jmp    802045 <strtol+0x68>
	else if (*s == '-')
  80202e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802032:	0f b6 00             	movzbl (%rax),%eax
  802035:	3c 2d                	cmp    $0x2d,%al
  802037:	75 0c                	jne    802045 <strtol+0x68>
		s++, neg = 1;
  802039:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80203e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802045:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802049:	74 06                	je     802051 <strtol+0x74>
  80204b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80204f:	75 28                	jne    802079 <strtol+0x9c>
  802051:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802055:	0f b6 00             	movzbl (%rax),%eax
  802058:	3c 30                	cmp    $0x30,%al
  80205a:	75 1d                	jne    802079 <strtol+0x9c>
  80205c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802060:	48 83 c0 01          	add    $0x1,%rax
  802064:	0f b6 00             	movzbl (%rax),%eax
  802067:	3c 78                	cmp    $0x78,%al
  802069:	75 0e                	jne    802079 <strtol+0x9c>
		s += 2, base = 16;
  80206b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802070:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802077:	eb 2c                	jmp    8020a5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802079:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80207d:	75 19                	jne    802098 <strtol+0xbb>
  80207f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802083:	0f b6 00             	movzbl (%rax),%eax
  802086:	3c 30                	cmp    $0x30,%al
  802088:	75 0e                	jne    802098 <strtol+0xbb>
		s++, base = 8;
  80208a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80208f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802096:	eb 0d                	jmp    8020a5 <strtol+0xc8>
	else if (base == 0)
  802098:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80209c:	75 07                	jne    8020a5 <strtol+0xc8>
		base = 10;
  80209e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8020a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a9:	0f b6 00             	movzbl (%rax),%eax
  8020ac:	3c 2f                	cmp    $0x2f,%al
  8020ae:	7e 1d                	jle    8020cd <strtol+0xf0>
  8020b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b4:	0f b6 00             	movzbl (%rax),%eax
  8020b7:	3c 39                	cmp    $0x39,%al
  8020b9:	7f 12                	jg     8020cd <strtol+0xf0>
			dig = *s - '0';
  8020bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bf:	0f b6 00             	movzbl (%rax),%eax
  8020c2:	0f be c0             	movsbl %al,%eax
  8020c5:	83 e8 30             	sub    $0x30,%eax
  8020c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020cb:	eb 4e                	jmp    80211b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8020cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d1:	0f b6 00             	movzbl (%rax),%eax
  8020d4:	3c 60                	cmp    $0x60,%al
  8020d6:	7e 1d                	jle    8020f5 <strtol+0x118>
  8020d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020dc:	0f b6 00             	movzbl (%rax),%eax
  8020df:	3c 7a                	cmp    $0x7a,%al
  8020e1:	7f 12                	jg     8020f5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8020e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e7:	0f b6 00             	movzbl (%rax),%eax
  8020ea:	0f be c0             	movsbl %al,%eax
  8020ed:	83 e8 57             	sub    $0x57,%eax
  8020f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020f3:	eb 26                	jmp    80211b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8020f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f9:	0f b6 00             	movzbl (%rax),%eax
  8020fc:	3c 40                	cmp    $0x40,%al
  8020fe:	7e 48                	jle    802148 <strtol+0x16b>
  802100:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802104:	0f b6 00             	movzbl (%rax),%eax
  802107:	3c 5a                	cmp    $0x5a,%al
  802109:	7f 3d                	jg     802148 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80210b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210f:	0f b6 00             	movzbl (%rax),%eax
  802112:	0f be c0             	movsbl %al,%eax
  802115:	83 e8 37             	sub    $0x37,%eax
  802118:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80211b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80211e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802121:	7c 02                	jl     802125 <strtol+0x148>
			break;
  802123:	eb 23                	jmp    802148 <strtol+0x16b>
		s++, val = (val * base) + dig;
  802125:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80212a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80212d:	48 98                	cltq   
  80212f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802134:	48 89 c2             	mov    %rax,%rdx
  802137:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80213a:	48 98                	cltq   
  80213c:	48 01 d0             	add    %rdx,%rax
  80213f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802143:	e9 5d ff ff ff       	jmpq   8020a5 <strtol+0xc8>

	if (endptr)
  802148:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80214d:	74 0b                	je     80215a <strtol+0x17d>
		*endptr = (char *) s;
  80214f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802153:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802157:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80215a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215e:	74 09                	je     802169 <strtol+0x18c>
  802160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802164:	48 f7 d8             	neg    %rax
  802167:	eb 04                	jmp    80216d <strtol+0x190>
  802169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80216d:	c9                   	leaveq 
  80216e:	c3                   	retq   

000000000080216f <strstr>:

char * strstr(const char *in, const char *str)
{
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	48 83 ec 30          	sub    $0x30,%rsp
  802177:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80217b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80217f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802183:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802187:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80218b:	0f b6 00             	movzbl (%rax),%eax
  80218e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802191:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802195:	75 06                	jne    80219d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802197:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219b:	eb 6b                	jmp    802208 <strstr+0x99>

	len = strlen(str);
  80219d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021a1:	48 89 c7             	mov    %rax,%rdi
  8021a4:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  8021ab:	00 00 00 
  8021ae:	ff d0                	callq  *%rax
  8021b0:	48 98                	cltq   
  8021b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8021c2:	0f b6 00             	movzbl (%rax),%eax
  8021c5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8021c8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8021cc:	75 07                	jne    8021d5 <strstr+0x66>
				return (char *) 0;
  8021ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d3:	eb 33                	jmp    802208 <strstr+0x99>
		} while (sc != c);
  8021d5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8021d9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8021dc:	75 d8                	jne    8021b6 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8021de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8021e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ea:	48 89 ce             	mov    %rcx,%rsi
  8021ed:	48 89 c7             	mov    %rax,%rdi
  8021f0:	48 b8 66 1c 80 00 00 	movabs $0x801c66,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	75 b6                	jne    8021b6 <strstr+0x47>

	return (char *) (in - 1);
  802200:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802204:	48 83 e8 01          	sub    $0x1,%rax
}
  802208:	c9                   	leaveq 
  802209:	c3                   	retq   

000000000080220a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80220a:	55                   	push   %rbp
  80220b:	48 89 e5             	mov    %rsp,%rbp
  80220e:	53                   	push   %rbx
  80220f:	48 83 ec 48          	sub    $0x48,%rsp
  802213:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802216:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802219:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80221d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802221:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802225:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802229:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80222c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802230:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802234:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802238:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80223c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802240:	4c 89 c3             	mov    %r8,%rbx
  802243:	cd 30                	int    $0x30
  802245:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802249:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80224d:	74 3e                	je     80228d <syscall+0x83>
  80224f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802254:	7e 37                	jle    80228d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802256:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80225a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80225d:	49 89 d0             	mov    %rdx,%r8
  802260:	89 c1                	mov    %eax,%ecx
  802262:	48 ba 08 52 80 00 00 	movabs $0x805208,%rdx
  802269:	00 00 00 
  80226c:	be 23 00 00 00       	mov    $0x23,%esi
  802271:	48 bf 25 52 80 00 00 	movabs $0x805225,%rdi
  802278:	00 00 00 
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	49 b9 de 0c 80 00 00 	movabs $0x800cde,%r9
  802287:	00 00 00 
  80228a:	41 ff d1             	callq  *%r9

	return ret;
  80228d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802291:	48 83 c4 48          	add    $0x48,%rsp
  802295:	5b                   	pop    %rbx
  802296:	5d                   	pop    %rbp
  802297:	c3                   	retq   

0000000000802298 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802298:	55                   	push   %rbp
  802299:	48 89 e5             	mov    %rsp,%rbp
  80229c:	48 83 ec 10          	sub    $0x10,%rsp
  8022a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8022a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b0:	48 83 ec 08          	sub    $0x8,%rsp
  8022b4:	6a 00                	pushq  $0x0
  8022b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022c2:	48 89 d1             	mov    %rdx,%rcx
  8022c5:	48 89 c2             	mov    %rax,%rdx
  8022c8:	be 00 00 00 00       	mov    $0x0,%esi
  8022cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d2:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	callq  *%rax
  8022de:	48 83 c4 10          	add    $0x10,%rsp
}
  8022e2:	c9                   	leaveq 
  8022e3:	c3                   	retq   

00000000008022e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022e4:	55                   	push   %rbp
  8022e5:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8022e8:	48 83 ec 08          	sub    $0x8,%rsp
  8022ec:	6a 00                	pushq  $0x0
  8022ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802304:	be 00 00 00 00       	mov    $0x0,%esi
  802309:	bf 01 00 00 00       	mov    $0x1,%edi
  80230e:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  802315:	00 00 00 
  802318:	ff d0                	callq  *%rax
  80231a:	48 83 c4 10          	add    $0x10,%rsp
}
  80231e:	c9                   	leaveq 
  80231f:	c3                   	retq   

0000000000802320 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802320:	55                   	push   %rbp
  802321:	48 89 e5             	mov    %rsp,%rbp
  802324:	48 83 ec 10          	sub    $0x10,%rsp
  802328:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232e:	48 98                	cltq   
  802330:	48 83 ec 08          	sub    $0x8,%rsp
  802334:	6a 00                	pushq  $0x0
  802336:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80233c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802342:	b9 00 00 00 00       	mov    $0x0,%ecx
  802347:	48 89 c2             	mov    %rax,%rdx
  80234a:	be 01 00 00 00       	mov    $0x1,%esi
  80234f:	bf 03 00 00 00       	mov    $0x3,%edi
  802354:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80235b:	00 00 00 
  80235e:	ff d0                	callq  *%rax
  802360:	48 83 c4 10          	add    $0x10,%rsp
}
  802364:	c9                   	leaveq 
  802365:	c3                   	retq   

0000000000802366 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802366:	55                   	push   %rbp
  802367:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80236a:	48 83 ec 08          	sub    $0x8,%rsp
  80236e:	6a 00                	pushq  $0x0
  802370:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802376:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80237c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802381:	ba 00 00 00 00       	mov    $0x0,%edx
  802386:	be 00 00 00 00       	mov    $0x0,%esi
  80238b:	bf 02 00 00 00       	mov    $0x2,%edi
  802390:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
  80239c:	48 83 c4 10          	add    $0x10,%rsp
}
  8023a0:	c9                   	leaveq 
  8023a1:	c3                   	retq   

00000000008023a2 <sys_yield>:

void
sys_yield(void)
{
  8023a2:	55                   	push   %rbp
  8023a3:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8023a6:	48 83 ec 08          	sub    $0x8,%rsp
  8023aa:	6a 00                	pushq  $0x0
  8023ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c2:	be 00 00 00 00       	mov    $0x0,%esi
  8023c7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023cc:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	callq  *%rax
  8023d8:	48 83 c4 10          	add    $0x10,%rsp
}
  8023dc:	c9                   	leaveq 
  8023dd:	c3                   	retq   

00000000008023de <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8023de:	55                   	push   %rbp
  8023df:	48 89 e5             	mov    %rsp,%rbp
  8023e2:	48 83 ec 10          	sub    $0x10,%rsp
  8023e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023ed:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8023f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023f3:	48 63 c8             	movslq %eax,%rcx
  8023f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	48 98                	cltq   
  8023ff:	48 83 ec 08          	sub    $0x8,%rsp
  802403:	6a 00                	pushq  $0x0
  802405:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80240b:	49 89 c8             	mov    %rcx,%r8
  80240e:	48 89 d1             	mov    %rdx,%rcx
  802411:	48 89 c2             	mov    %rax,%rdx
  802414:	be 01 00 00 00       	mov    $0x1,%esi
  802419:	bf 04 00 00 00       	mov    $0x4,%edi
  80241e:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  802425:	00 00 00 
  802428:	ff d0                	callq  *%rax
  80242a:	48 83 c4 10          	add    $0x10,%rsp
}
  80242e:	c9                   	leaveq 
  80242f:	c3                   	retq   

0000000000802430 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
  802434:	48 83 ec 20          	sub    $0x20,%rsp
  802438:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80243b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80243f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802442:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802446:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80244a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80244d:	48 63 c8             	movslq %eax,%rcx
  802450:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802454:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802457:	48 63 f0             	movslq %eax,%rsi
  80245a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80245e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802461:	48 98                	cltq   
  802463:	48 83 ec 08          	sub    $0x8,%rsp
  802467:	51                   	push   %rcx
  802468:	49 89 f9             	mov    %rdi,%r9
  80246b:	49 89 f0             	mov    %rsi,%r8
  80246e:	48 89 d1             	mov    %rdx,%rcx
  802471:	48 89 c2             	mov    %rax,%rdx
  802474:	be 01 00 00 00       	mov    $0x1,%esi
  802479:	bf 05 00 00 00       	mov    $0x5,%edi
  80247e:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
  80248a:	48 83 c4 10          	add    $0x10,%rsp
}
  80248e:	c9                   	leaveq 
  80248f:	c3                   	retq   

0000000000802490 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802490:	55                   	push   %rbp
  802491:	48 89 e5             	mov    %rsp,%rbp
  802494:	48 83 ec 10          	sub    $0x10,%rsp
  802498:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80249b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80249f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a6:	48 98                	cltq   
  8024a8:	48 83 ec 08          	sub    $0x8,%rsp
  8024ac:	6a 00                	pushq  $0x0
  8024ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024ba:	48 89 d1             	mov    %rdx,%rcx
  8024bd:	48 89 c2             	mov    %rax,%rdx
  8024c0:	be 01 00 00 00       	mov    $0x1,%esi
  8024c5:	bf 06 00 00 00       	mov    $0x6,%edi
  8024ca:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
  8024d6:	48 83 c4 10          	add    $0x10,%rsp
}
  8024da:	c9                   	leaveq 
  8024db:	c3                   	retq   

00000000008024dc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8024dc:	55                   	push   %rbp
  8024dd:	48 89 e5             	mov    %rsp,%rbp
  8024e0:	48 83 ec 10          	sub    $0x10,%rsp
  8024e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024e7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8024ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ed:	48 63 d0             	movslq %eax,%rdx
  8024f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f3:	48 98                	cltq   
  8024f5:	48 83 ec 08          	sub    $0x8,%rsp
  8024f9:	6a 00                	pushq  $0x0
  8024fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802501:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802507:	48 89 d1             	mov    %rdx,%rcx
  80250a:	48 89 c2             	mov    %rax,%rdx
  80250d:	be 01 00 00 00       	mov    $0x1,%esi
  802512:	bf 08 00 00 00       	mov    $0x8,%edi
  802517:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80251e:	00 00 00 
  802521:	ff d0                	callq  *%rax
  802523:	48 83 c4 10          	add    $0x10,%rsp
}
  802527:	c9                   	leaveq 
  802528:	c3                   	retq   

0000000000802529 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802529:	55                   	push   %rbp
  80252a:	48 89 e5             	mov    %rsp,%rbp
  80252d:	48 83 ec 10          	sub    $0x10,%rsp
  802531:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802534:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802538:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80253c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253f:	48 98                	cltq   
  802541:	48 83 ec 08          	sub    $0x8,%rsp
  802545:	6a 00                	pushq  $0x0
  802547:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80254d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802553:	48 89 d1             	mov    %rdx,%rcx
  802556:	48 89 c2             	mov    %rax,%rdx
  802559:	be 01 00 00 00       	mov    $0x1,%esi
  80255e:	bf 09 00 00 00       	mov    $0x9,%edi
  802563:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80256a:	00 00 00 
  80256d:	ff d0                	callq  *%rax
  80256f:	48 83 c4 10          	add    $0x10,%rsp
}
  802573:	c9                   	leaveq 
  802574:	c3                   	retq   

0000000000802575 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802575:	55                   	push   %rbp
  802576:	48 89 e5             	mov    %rsp,%rbp
  802579:	48 83 ec 10          	sub    $0x10,%rsp
  80257d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802580:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802584:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258b:	48 98                	cltq   
  80258d:	48 83 ec 08          	sub    $0x8,%rsp
  802591:	6a 00                	pushq  $0x0
  802593:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802599:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80259f:	48 89 d1             	mov    %rdx,%rcx
  8025a2:	48 89 c2             	mov    %rax,%rdx
  8025a5:	be 01 00 00 00       	mov    $0x1,%esi
  8025aa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8025af:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  8025b6:	00 00 00 
  8025b9:	ff d0                	callq  *%rax
  8025bb:	48 83 c4 10          	add    $0x10,%rsp
}
  8025bf:	c9                   	leaveq 
  8025c0:	c3                   	retq   

00000000008025c1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8025c1:	55                   	push   %rbp
  8025c2:	48 89 e5             	mov    %rsp,%rbp
  8025c5:	48 83 ec 20          	sub    $0x20,%rsp
  8025c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8025d4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8025d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025da:	48 63 f0             	movslq %eax,%rsi
  8025dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e4:	48 98                	cltq   
  8025e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ea:	48 83 ec 08          	sub    $0x8,%rsp
  8025ee:	6a 00                	pushq  $0x0
  8025f0:	49 89 f1             	mov    %rsi,%r9
  8025f3:	49 89 c8             	mov    %rcx,%r8
  8025f6:	48 89 d1             	mov    %rdx,%rcx
  8025f9:	48 89 c2             	mov    %rax,%rdx
  8025fc:	be 00 00 00 00       	mov    $0x0,%esi
  802601:	bf 0c 00 00 00       	mov    $0xc,%edi
  802606:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
  802612:	48 83 c4 10          	add    $0x10,%rsp
}
  802616:	c9                   	leaveq 
  802617:	c3                   	retq   

0000000000802618 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802618:	55                   	push   %rbp
  802619:	48 89 e5             	mov    %rsp,%rbp
  80261c:	48 83 ec 10          	sub    $0x10,%rsp
  802620:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802628:	48 83 ec 08          	sub    $0x8,%rsp
  80262c:	6a 00                	pushq  $0x0
  80262e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802634:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80263a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80263f:	48 89 c2             	mov    %rax,%rdx
  802642:	be 01 00 00 00       	mov    $0x1,%esi
  802647:	bf 0d 00 00 00       	mov    $0xd,%edi
  80264c:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	48 83 c4 10          	add    $0x10,%rsp
}
  80265c:	c9                   	leaveq 
  80265d:	c3                   	retq   

000000000080265e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80265e:	55                   	push   %rbp
  80265f:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802662:	48 83 ec 08          	sub    $0x8,%rsp
  802666:	6a 00                	pushq  $0x0
  802668:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80266e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802674:	b9 00 00 00 00       	mov    $0x0,%ecx
  802679:	ba 00 00 00 00       	mov    $0x0,%edx
  80267e:	be 00 00 00 00       	mov    $0x0,%esi
  802683:	bf 0e 00 00 00       	mov    $0xe,%edi
  802688:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
  802694:	48 83 c4 10          	add    $0x10,%rsp
}
  802698:	c9                   	leaveq 
  802699:	c3                   	retq   

000000000080269a <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80269a:	55                   	push   %rbp
  80269b:	48 89 e5             	mov    %rsp,%rbp
  80269e:	48 83 ec 20          	sub    $0x20,%rsp
  8026a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026a9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8026ac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8026b0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8026b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8026b7:	48 63 c8             	movslq %eax,%rcx
  8026ba:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8026be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026c1:	48 63 f0             	movslq %eax,%rsi
  8026c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cb:	48 98                	cltq   
  8026cd:	48 83 ec 08          	sub    $0x8,%rsp
  8026d1:	51                   	push   %rcx
  8026d2:	49 89 f9             	mov    %rdi,%r9
  8026d5:	49 89 f0             	mov    %rsi,%r8
  8026d8:	48 89 d1             	mov    %rdx,%rcx
  8026db:	48 89 c2             	mov    %rax,%rdx
  8026de:	be 00 00 00 00       	mov    $0x0,%esi
  8026e3:	bf 0f 00 00 00       	mov    $0xf,%edi
  8026e8:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	callq  *%rax
  8026f4:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8026f8:	c9                   	leaveq 
  8026f9:	c3                   	retq   

00000000008026fa <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8026fa:	55                   	push   %rbp
  8026fb:	48 89 e5             	mov    %rsp,%rbp
  8026fe:	48 83 ec 10          	sub    $0x10,%rsp
  802702:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802706:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80270a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80270e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802712:	48 83 ec 08          	sub    $0x8,%rsp
  802716:	6a 00                	pushq  $0x0
  802718:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80271e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802724:	48 89 d1             	mov    %rdx,%rcx
  802727:	48 89 c2             	mov    %rax,%rdx
  80272a:	be 00 00 00 00       	mov    $0x0,%esi
  80272f:	bf 10 00 00 00       	mov    $0x10,%edi
  802734:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax
  802740:	48 83 c4 10          	add    $0x10,%rsp
}
  802744:	c9                   	leaveq 
  802745:	c3                   	retq   

0000000000802746 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802746:	55                   	push   %rbp
  802747:	48 89 e5             	mov    %rsp,%rbp
  80274a:	48 83 ec 20          	sub    $0x20,%rsp
  80274e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802752:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802756:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80275a:	48 ba 38 52 80 00 00 	movabs $0x805238,%rdx
  802761:	00 00 00 
  802764:	be 1d 00 00 00       	mov    $0x1d,%esi
  802769:	48 bf 51 52 80 00 00 	movabs $0x805251,%rdi
  802770:	00 00 00 
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  80277f:	00 00 00 
  802782:	ff d1                	callq  *%rcx

0000000000802784 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802784:	55                   	push   %rbp
  802785:	48 89 e5             	mov    %rsp,%rbp
  802788:	48 83 ec 20          	sub    $0x20,%rsp
  80278c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80278f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802792:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  802796:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  802799:	48 ba 5b 52 80 00 00 	movabs $0x80525b,%rdx
  8027a0:	00 00 00 
  8027a3:	be 2d 00 00 00       	mov    $0x2d,%esi
  8027a8:	48 bf 51 52 80 00 00 	movabs $0x805251,%rdi
  8027af:	00 00 00 
  8027b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b7:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  8027be:	00 00 00 
  8027c1:	ff d1                	callq  *%rcx

00000000008027c3 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8027c3:	55                   	push   %rbp
  8027c4:	48 89 e5             	mov    %rsp,%rbp
  8027c7:	53                   	push   %rbx
  8027c8:	48 83 ec 48          	sub    $0x48,%rsp
  8027cc:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8027d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  8027d7:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8027de:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8027e3:	75 0e                	jne    8027f3 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8027e5:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8027ec:	00 00 00 
  8027ef:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8027f3:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8027f7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  8027fb:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802802:	00 
	a3 = (uint64_t) 0;
  802803:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80280a:	00 
	a4 = (uint64_t) 0;
  80280b:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802812:	00 
	a5 = 0;
  802813:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80281a:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  80281b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80281e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802822:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802826:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  80282a:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80282e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802832:	4c 89 c3             	mov    %r8,%rbx
  802835:	0f 01 c1             	vmcall 
  802838:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  80283b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80283f:	7e 36                	jle    802877 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  802841:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802844:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802847:	41 89 d0             	mov    %edx,%r8d
  80284a:	89 c1                	mov    %eax,%ecx
  80284c:	48 ba 78 52 80 00 00 	movabs $0x805278,%rdx
  802853:	00 00 00 
  802856:	be 54 00 00 00       	mov    $0x54,%esi
  80285b:	48 bf 51 52 80 00 00 	movabs $0x805251,%rdi
  802862:	00 00 00 
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	49 b9 de 0c 80 00 00 	movabs $0x800cde,%r9
  802871:	00 00 00 
  802874:	41 ff d1             	callq  *%r9
	return ret;
  802877:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80287a:	48 83 c4 48          	add    $0x48,%rsp
  80287e:	5b                   	pop    %rbx
  80287f:	5d                   	pop    %rbp
  802880:	c3                   	retq   

0000000000802881 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802881:	55                   	push   %rbp
  802882:	48 89 e5             	mov    %rsp,%rbp
  802885:	53                   	push   %rbx
  802886:	48 83 ec 58          	sub    $0x58,%rsp
  80288a:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  80288d:	89 75 b0             	mov    %esi,-0x50(%rbp)
  802890:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  802894:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  802897:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  80289e:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8028a5:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8028aa:	75 0e                	jne    8028ba <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8028ac:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8028b3:	00 00 00 
  8028b6:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8028ba:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8028bd:	48 98                	cltq   
  8028bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8028c3:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8028c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8028ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028ce:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8028d2:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8028d5:	48 98                	cltq   
  8028d7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8028db:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8028e2:	00 

	int r = -E_IPC_NOT_RECV;
  8028e3:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8028ea:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8028ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028f1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8028f5:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8028f9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8028fd:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802901:	4c 89 c3             	mov    %r8,%rbx
  802904:	0f 01 c1             	vmcall 
  802907:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  80290a:	48 83 c4 58          	add    $0x58,%rsp
  80290e:	5b                   	pop    %rbx
  80290f:	5d                   	pop    %rbp
  802910:	c3                   	retq   

0000000000802911 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802911:	55                   	push   %rbp
  802912:	48 89 e5             	mov    %rsp,%rbp
  802915:	48 83 ec 18          	sub    $0x18,%rsp
  802919:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80291c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802923:	eb 4e                	jmp    802973 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802925:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80292c:	00 00 00 
  80292f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802932:	48 98                	cltq   
  802934:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80293b:	48 01 d0             	add    %rdx,%rax
  80293e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802944:	8b 00                	mov    (%rax),%eax
  802946:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802949:	75 24                	jne    80296f <ipc_find_env+0x5e>
			return envs[i].env_id;
  80294b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802952:	00 00 00 
  802955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802958:	48 98                	cltq   
  80295a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802961:	48 01 d0             	add    %rdx,%rax
  802964:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80296a:	8b 40 08             	mov    0x8(%rax),%eax
  80296d:	eb 12                	jmp    802981 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  80296f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802973:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80297a:	7e a9                	jle    802925 <ipc_find_env+0x14>
	}
	return 0;
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 83 ec 08          	sub    $0x8,%rsp
  80298b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80298f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802993:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80299a:	ff ff ff 
  80299d:	48 01 d0             	add    %rdx,%rax
  8029a0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8029a4:	c9                   	leaveq 
  8029a5:	c3                   	retq   

00000000008029a6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 83 ec 08          	sub    $0x8,%rsp
  8029ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8029b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b6:	48 89 c7             	mov    %rax,%rdi
  8029b9:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8029cb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8029cf:	c9                   	leaveq 
  8029d0:	c3                   	retq   

00000000008029d1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8029d1:	55                   	push   %rbp
  8029d2:	48 89 e5             	mov    %rsp,%rbp
  8029d5:	48 83 ec 18          	sub    $0x18,%rsp
  8029d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8029dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029e4:	eb 6b                	jmp    802a51 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8029e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e9:	48 98                	cltq   
  8029eb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029f1:	48 c1 e0 0c          	shl    $0xc,%rax
  8029f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8029f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fd:	48 c1 e8 15          	shr    $0x15,%rax
  802a01:	48 89 c2             	mov    %rax,%rdx
  802a04:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a0b:	01 00 00 
  802a0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a12:	83 e0 01             	and    $0x1,%eax
  802a15:	48 85 c0             	test   %rax,%rax
  802a18:	74 21                	je     802a3b <fd_alloc+0x6a>
  802a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1e:	48 c1 e8 0c          	shr    $0xc,%rax
  802a22:	48 89 c2             	mov    %rax,%rdx
  802a25:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a2c:	01 00 00 
  802a2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a33:	83 e0 01             	and    $0x1,%eax
  802a36:	48 85 c0             	test   %rax,%rax
  802a39:	75 12                	jne    802a4d <fd_alloc+0x7c>
			*fd_store = fd;
  802a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a43:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a46:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4b:	eb 1a                	jmp    802a67 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  802a4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a51:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a55:	7e 8f                	jle    8029e6 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802a62:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802a67:	c9                   	leaveq 
  802a68:	c3                   	retq   

0000000000802a69 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a69:	55                   	push   %rbp
  802a6a:	48 89 e5             	mov    %rsp,%rbp
  802a6d:	48 83 ec 20          	sub    $0x20,%rsp
  802a71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802a78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a7c:	78 06                	js     802a84 <fd_lookup+0x1b>
  802a7e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802a82:	7e 07                	jle    802a8b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a89:	eb 6c                	jmp    802af7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802a8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a8e:	48 98                	cltq   
  802a90:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a96:	48 c1 e0 0c          	shl    $0xc,%rax
  802a9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa2:	48 c1 e8 15          	shr    $0x15,%rax
  802aa6:	48 89 c2             	mov    %rax,%rdx
  802aa9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ab0:	01 00 00 
  802ab3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ab7:	83 e0 01             	and    $0x1,%eax
  802aba:	48 85 c0             	test   %rax,%rax
  802abd:	74 21                	je     802ae0 <fd_lookup+0x77>
  802abf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac3:	48 c1 e8 0c          	shr    $0xc,%rax
  802ac7:	48 89 c2             	mov    %rax,%rdx
  802aca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ad1:	01 00 00 
  802ad4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ad8:	83 e0 01             	and    $0x1,%eax
  802adb:	48 85 c0             	test   %rax,%rax
  802ade:	75 07                	jne    802ae7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ae5:	eb 10                	jmp    802af7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802ae7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aeb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802aef:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af7:	c9                   	leaveq 
  802af8:	c3                   	retq   

0000000000802af9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802af9:	55                   	push   %rbp
  802afa:	48 89 e5             	mov    %rsp,%rbp
  802afd:	48 83 ec 30          	sub    $0x30,%rsp
  802b01:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b05:	89 f0                	mov    %esi,%eax
  802b07:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b0e:	48 89 c7             	mov    %rax,%rdi
  802b11:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
  802b1d:	89 c2                	mov    %eax,%edx
  802b1f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b23:	48 89 c6             	mov    %rax,%rsi
  802b26:	89 d7                	mov    %edx,%edi
  802b28:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	callq  *%rax
  802b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3b:	78 0a                	js     802b47 <fd_close+0x4e>
	    || fd != fd2)
  802b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b41:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b45:	74 12                	je     802b59 <fd_close+0x60>
		return (must_exist ? r : 0);
  802b47:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b4b:	74 05                	je     802b52 <fd_close+0x59>
  802b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b50:	eb 70                	jmp    802bc2 <fd_close+0xc9>
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	eb 69                	jmp    802bc2 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802b59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b5d:	8b 00                	mov    (%rax),%eax
  802b5f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b63:	48 89 d6             	mov    %rdx,%rsi
  802b66:	89 c7                	mov    %eax,%edi
  802b68:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
  802b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7b:	78 2a                	js     802ba7 <fd_close+0xae>
		if (dev->dev_close)
  802b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b81:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b85:	48 85 c0             	test   %rax,%rax
  802b88:	74 16                	je     802ba0 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b92:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b96:	48 89 d7             	mov    %rdx,%rdi
  802b99:	ff d0                	callq  *%rax
  802b9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9e:	eb 07                	jmp    802ba7 <fd_close+0xae>
		else
			r = 0;
  802ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ba7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bab:	48 89 c6             	mov    %rax,%rsi
  802bae:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb3:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
	return r;
  802bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bc2:	c9                   	leaveq 
  802bc3:	c3                   	retq   

0000000000802bc4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802bc4:	55                   	push   %rbp
  802bc5:	48 89 e5             	mov    %rsp,%rbp
  802bc8:	48 83 ec 20          	sub    $0x20,%rsp
  802bcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bcf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802bd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bda:	eb 41                	jmp    802c1d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802bdc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802be3:	00 00 00 
  802be6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802be9:	48 63 d2             	movslq %edx,%rdx
  802bec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bf0:	8b 00                	mov    (%rax),%eax
  802bf2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802bf5:	75 22                	jne    802c19 <dev_lookup+0x55>
			*dev = devtab[i];
  802bf7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802bfe:	00 00 00 
  802c01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c04:	48 63 d2             	movslq %edx,%rdx
  802c07:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c0f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c12:	b8 00 00 00 00       	mov    $0x0,%eax
  802c17:	eb 60                	jmp    802c79 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802c19:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c1d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c24:	00 00 00 
  802c27:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c2a:	48 63 d2             	movslq %edx,%rdx
  802c2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c31:	48 85 c0             	test   %rax,%rax
  802c34:	75 a6                	jne    802bdc <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c36:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c3d:	00 00 00 
  802c40:	48 8b 00             	mov    (%rax),%rax
  802c43:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c49:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c4c:	89 c6                	mov    %eax,%esi
  802c4e:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  802c55:	00 00 00 
  802c58:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5d:	48 b9 17 0f 80 00 00 	movabs $0x800f17,%rcx
  802c64:	00 00 00 
  802c67:	ff d1                	callq  *%rcx
	*dev = 0;
  802c69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802c74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c79:	c9                   	leaveq 
  802c7a:	c3                   	retq   

0000000000802c7b <close>:

int
close(int fdnum)
{
  802c7b:	55                   	push   %rbp
  802c7c:	48 89 e5             	mov    %rsp,%rbp
  802c7f:	48 83 ec 20          	sub    $0x20,%rsp
  802c83:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c8d:	48 89 d6             	mov    %rdx,%rsi
  802c90:	89 c7                	mov    %eax,%edi
  802c92:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	79 05                	jns    802cac <close+0x31>
		return r;
  802ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caa:	eb 18                	jmp    802cc4 <close+0x49>
	else
		return fd_close(fd, 1);
  802cac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb0:	be 01 00 00 00       	mov    $0x1,%esi
  802cb5:	48 89 c7             	mov    %rax,%rdi
  802cb8:	48 b8 f9 2a 80 00 00 	movabs $0x802af9,%rax
  802cbf:	00 00 00 
  802cc2:	ff d0                	callq  *%rax
}
  802cc4:	c9                   	leaveq 
  802cc5:	c3                   	retq   

0000000000802cc6 <close_all>:

void
close_all(void)
{
  802cc6:	55                   	push   %rbp
  802cc7:	48 89 e5             	mov    %rsp,%rbp
  802cca:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802cce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cd5:	eb 15                	jmp    802cec <close_all+0x26>
		close(i);
  802cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802ce8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cec:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802cf0:	7e e5                	jle    802cd7 <close_all+0x11>
}
  802cf2:	c9                   	leaveq 
  802cf3:	c3                   	retq   

0000000000802cf4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	48 83 ec 40          	sub    $0x40,%rsp
  802cfc:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802cff:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d02:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d06:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d09:	48 89 d6             	mov    %rdx,%rsi
  802d0c:	89 c7                	mov    %eax,%edi
  802d0e:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
  802d1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d21:	79 08                	jns    802d2b <dup+0x37>
		return r;
  802d23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d26:	e9 70 01 00 00       	jmpq   802e9b <dup+0x1a7>
	close(newfdnum);
  802d2b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d2e:	89 c7                	mov    %eax,%edi
  802d30:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d3c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d3f:	48 98                	cltq   
  802d41:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d47:	48 c1 e0 0c          	shl    $0xc,%rax
  802d4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d53:	48 89 c7             	mov    %rax,%rdi
  802d56:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	callq  *%rax
  802d62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6a:	48 89 c7             	mov    %rax,%rdi
  802d6d:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d81:	48 c1 e8 15          	shr    $0x15,%rax
  802d85:	48 89 c2             	mov    %rax,%rdx
  802d88:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d8f:	01 00 00 
  802d92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d96:	83 e0 01             	and    $0x1,%eax
  802d99:	48 85 c0             	test   %rax,%rax
  802d9c:	74 73                	je     802e11 <dup+0x11d>
  802d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da2:	48 c1 e8 0c          	shr    $0xc,%rax
  802da6:	48 89 c2             	mov    %rax,%rdx
  802da9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802db0:	01 00 00 
  802db3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802db7:	83 e0 01             	and    $0x1,%eax
  802dba:	48 85 c0             	test   %rax,%rax
  802dbd:	74 52                	je     802e11 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc3:	48 c1 e8 0c          	shr    $0xc,%rax
  802dc7:	48 89 c2             	mov    %rax,%rdx
  802dca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dd1:	01 00 00 
  802dd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dd8:	25 07 0e 00 00       	and    $0xe07,%eax
  802ddd:	89 c1                	mov    %eax,%ecx
  802ddf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de7:	41 89 c8             	mov    %ecx,%r8d
  802dea:	48 89 d1             	mov    %rdx,%rcx
  802ded:	ba 00 00 00 00       	mov    $0x0,%edx
  802df2:	48 89 c6             	mov    %rax,%rsi
  802df5:	bf 00 00 00 00       	mov    $0x0,%edi
  802dfa:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
  802e06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0d:	79 02                	jns    802e11 <dup+0x11d>
			goto err;
  802e0f:	eb 57                	jmp    802e68 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e15:	48 c1 e8 0c          	shr    $0xc,%rax
  802e19:	48 89 c2             	mov    %rax,%rdx
  802e1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e23:	01 00 00 
  802e26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e2a:	25 07 0e 00 00       	and    $0xe07,%eax
  802e2f:	89 c1                	mov    %eax,%ecx
  802e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e39:	41 89 c8             	mov    %ecx,%r8d
  802e3c:	48 89 d1             	mov    %rdx,%rcx
  802e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802e44:	48 89 c6             	mov    %rax,%rsi
  802e47:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4c:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  802e53:	00 00 00 
  802e56:	ff d0                	callq  *%rax
  802e58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5f:	79 02                	jns    802e63 <dup+0x16f>
		goto err;
  802e61:	eb 05                	jmp    802e68 <dup+0x174>

	return newfdnum;
  802e63:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e66:	eb 33                	jmp    802e9b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6c:	48 89 c6             	mov    %rax,%rsi
  802e6f:	bf 00 00 00 00       	mov    $0x0,%edi
  802e74:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802e7b:	00 00 00 
  802e7e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802e80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e84:	48 89 c6             	mov    %rax,%rsi
  802e87:	bf 00 00 00 00       	mov    $0x0,%edi
  802e8c:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
	return r;
  802e98:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e9b:	c9                   	leaveq 
  802e9c:	c3                   	retq   

0000000000802e9d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e9d:	55                   	push   %rbp
  802e9e:	48 89 e5             	mov    %rsp,%rbp
  802ea1:	48 83 ec 40          	sub    $0x40,%rsp
  802ea5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ea8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802eb0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802eb4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802eb7:	48 89 d6             	mov    %rdx,%rsi
  802eba:	89 c7                	mov    %eax,%edi
  802ebc:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecf:	78 24                	js     802ef5 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed5:	8b 00                	mov    (%rax),%eax
  802ed7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802edb:	48 89 d6             	mov    %rdx,%rsi
  802ede:	89 c7                	mov    %eax,%edi
  802ee0:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802ee7:	00 00 00 
  802eea:	ff d0                	callq  *%rax
  802eec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef3:	79 05                	jns    802efa <read+0x5d>
		return r;
  802ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef8:	eb 76                	jmp    802f70 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802efa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efe:	8b 40 08             	mov    0x8(%rax),%eax
  802f01:	83 e0 03             	and    $0x3,%eax
  802f04:	83 f8 01             	cmp    $0x1,%eax
  802f07:	75 3a                	jne    802f43 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f09:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802f10:	00 00 00 
  802f13:	48 8b 00             	mov    (%rax),%rax
  802f16:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f1c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f1f:	89 c6                	mov    %eax,%esi
  802f21:	48 bf c7 52 80 00 00 	movabs $0x8052c7,%rdi
  802f28:	00 00 00 
  802f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f30:	48 b9 17 0f 80 00 00 	movabs $0x800f17,%rcx
  802f37:	00 00 00 
  802f3a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f41:	eb 2d                	jmp    802f70 <read+0xd3>
	}
	if (!dev->dev_read)
  802f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f47:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f4b:	48 85 c0             	test   %rax,%rax
  802f4e:	75 07                	jne    802f57 <read+0xba>
		return -E_NOT_SUPP;
  802f50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f55:	eb 19                	jmp    802f70 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f5f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f67:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f6b:	48 89 cf             	mov    %rcx,%rdi
  802f6e:	ff d0                	callq  *%rax
}
  802f70:	c9                   	leaveq 
  802f71:	c3                   	retq   

0000000000802f72 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802f72:	55                   	push   %rbp
  802f73:	48 89 e5             	mov    %rsp,%rbp
  802f76:	48 83 ec 30          	sub    $0x30,%rsp
  802f7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f81:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f8c:	eb 49                	jmp    802fd7 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f91:	48 98                	cltq   
  802f93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f97:	48 29 c2             	sub    %rax,%rdx
  802f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9d:	48 63 c8             	movslq %eax,%rcx
  802fa0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa4:	48 01 c1             	add    %rax,%rcx
  802fa7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802faa:	48 89 ce             	mov    %rcx,%rsi
  802fad:	89 c7                	mov    %eax,%edi
  802faf:	48 b8 9d 2e 80 00 00 	movabs $0x802e9d,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
  802fbb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802fbe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fc2:	79 05                	jns    802fc9 <readn+0x57>
			return m;
  802fc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc7:	eb 1c                	jmp    802fe5 <readn+0x73>
		if (m == 0)
  802fc9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fcd:	75 02                	jne    802fd1 <readn+0x5f>
			break;
  802fcf:	eb 11                	jmp    802fe2 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802fd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fd4:	01 45 fc             	add    %eax,-0x4(%rbp)
  802fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fda:	48 98                	cltq   
  802fdc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fe0:	72 ac                	jb     802f8e <readn+0x1c>
	}
	return tot;
  802fe2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fe5:	c9                   	leaveq 
  802fe6:	c3                   	retq   

0000000000802fe7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802fe7:	55                   	push   %rbp
  802fe8:	48 89 e5             	mov    %rsp,%rbp
  802feb:	48 83 ec 40          	sub    $0x40,%rsp
  802fef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ff2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ff6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ffa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ffe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803001:	48 89 d6             	mov    %rdx,%rsi
  803004:	89 c7                	mov    %eax,%edi
  803006:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803015:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803019:	78 24                	js     80303f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80301b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301f:	8b 00                	mov    (%rax),%eax
  803021:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803025:	48 89 d6             	mov    %rdx,%rsi
  803028:	89 c7                	mov    %eax,%edi
  80302a:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
  803036:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803039:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303d:	79 05                	jns    803044 <write+0x5d>
		return r;
  80303f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803042:	eb 75                	jmp    8030b9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803048:	8b 40 08             	mov    0x8(%rax),%eax
  80304b:	83 e0 03             	and    $0x3,%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	75 3a                	jne    80308c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803052:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803059:	00 00 00 
  80305c:	48 8b 00             	mov    (%rax),%rax
  80305f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803065:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803068:	89 c6                	mov    %eax,%esi
  80306a:	48 bf e3 52 80 00 00 	movabs $0x8052e3,%rdi
  803071:	00 00 00 
  803074:	b8 00 00 00 00       	mov    $0x0,%eax
  803079:	48 b9 17 0f 80 00 00 	movabs $0x800f17,%rcx
  803080:	00 00 00 
  803083:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803085:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80308a:	eb 2d                	jmp    8030b9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80308c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803090:	48 8b 40 18          	mov    0x18(%rax),%rax
  803094:	48 85 c0             	test   %rax,%rax
  803097:	75 07                	jne    8030a0 <write+0xb9>
		return -E_NOT_SUPP;
  803099:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80309e:	eb 19                	jmp    8030b9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8030a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030a8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030ac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030b0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030b4:	48 89 cf             	mov    %rcx,%rdi
  8030b7:	ff d0                	callq  *%rax
}
  8030b9:	c9                   	leaveq 
  8030ba:	c3                   	retq   

00000000008030bb <seek>:

int
seek(int fdnum, off_t offset)
{
  8030bb:	55                   	push   %rbp
  8030bc:	48 89 e5             	mov    %rsp,%rbp
  8030bf:	48 83 ec 18          	sub    $0x18,%rsp
  8030c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030c6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030d0:	48 89 d6             	mov    %rdx,%rsi
  8030d3:	89 c7                	mov    %eax,%edi
  8030d5:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  8030dc:	00 00 00 
  8030df:	ff d0                	callq  *%rax
  8030e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e8:	79 05                	jns    8030ef <seek+0x34>
		return r;
  8030ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ed:	eb 0f                	jmp    8030fe <seek+0x43>
	fd->fd_offset = offset;
  8030ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030f6:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030fe:	c9                   	leaveq 
  8030ff:	c3                   	retq   

0000000000803100 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803100:	55                   	push   %rbp
  803101:	48 89 e5             	mov    %rsp,%rbp
  803104:	48 83 ec 30          	sub    $0x30,%rsp
  803108:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80310b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80310e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803112:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803115:	48 89 d6             	mov    %rdx,%rsi
  803118:	89 c7                	mov    %eax,%edi
  80311a:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
  803126:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803129:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312d:	78 24                	js     803153 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80312f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803133:	8b 00                	mov    (%rax),%eax
  803135:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803139:	48 89 d6             	mov    %rdx,%rsi
  80313c:	89 c7                	mov    %eax,%edi
  80313e:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803151:	79 05                	jns    803158 <ftruncate+0x58>
		return r;
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	eb 72                	jmp    8031ca <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315c:	8b 40 08             	mov    0x8(%rax),%eax
  80315f:	83 e0 03             	and    $0x3,%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	75 3a                	jne    8031a0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803166:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80316d:	00 00 00 
  803170:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803173:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803179:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80317c:	89 c6                	mov    %eax,%esi
  80317e:	48 bf 00 53 80 00 00 	movabs $0x805300,%rdi
  803185:	00 00 00 
  803188:	b8 00 00 00 00       	mov    $0x0,%eax
  80318d:	48 b9 17 0f 80 00 00 	movabs $0x800f17,%rcx
  803194:	00 00 00 
  803197:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803199:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80319e:	eb 2a                	jmp    8031ca <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8031a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031a8:	48 85 c0             	test   %rax,%rax
  8031ab:	75 07                	jne    8031b4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8031ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031b2:	eb 16                	jmp    8031ca <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8031b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031c0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8031c3:	89 ce                	mov    %ecx,%esi
  8031c5:	48 89 d7             	mov    %rdx,%rdi
  8031c8:	ff d0                	callq  *%rax
}
  8031ca:	c9                   	leaveq 
  8031cb:	c3                   	retq   

00000000008031cc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8031cc:	55                   	push   %rbp
  8031cd:	48 89 e5             	mov    %rsp,%rbp
  8031d0:	48 83 ec 30          	sub    $0x30,%rsp
  8031d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031db:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031e2:	48 89 d6             	mov    %rdx,%rsi
  8031e5:	89 c7                	mov    %eax,%edi
  8031e7:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  8031ee:	00 00 00 
  8031f1:	ff d0                	callq  *%rax
  8031f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fa:	78 24                	js     803220 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803200:	8b 00                	mov    (%rax),%eax
  803202:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803206:	48 89 d6             	mov    %rdx,%rsi
  803209:	89 c7                	mov    %eax,%edi
  80320b:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
  803217:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80321a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321e:	79 05                	jns    803225 <fstat+0x59>
		return r;
  803220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803223:	eb 5e                	jmp    803283 <fstat+0xb7>
	if (!dev->dev_stat)
  803225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803229:	48 8b 40 28          	mov    0x28(%rax),%rax
  80322d:	48 85 c0             	test   %rax,%rax
  803230:	75 07                	jne    803239 <fstat+0x6d>
		return -E_NOT_SUPP;
  803232:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803237:	eb 4a                	jmp    803283 <fstat+0xb7>
	stat->st_name[0] = 0;
  803239:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80323d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803240:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803244:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80324b:	00 00 00 
	stat->st_isdir = 0;
  80324e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803252:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803259:	00 00 00 
	stat->st_dev = dev;
  80325c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803260:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803264:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326f:	48 8b 40 28          	mov    0x28(%rax),%rax
  803273:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803277:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80327b:	48 89 ce             	mov    %rcx,%rsi
  80327e:	48 89 d7             	mov    %rdx,%rdi
  803281:	ff d0                	callq  *%rax
}
  803283:	c9                   	leaveq 
  803284:	c3                   	retq   

0000000000803285 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803285:	55                   	push   %rbp
  803286:	48 89 e5             	mov    %rsp,%rbp
  803289:	48 83 ec 20          	sub    $0x20,%rsp
  80328d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803291:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803299:	be 00 00 00 00       	mov    $0x0,%esi
  80329e:	48 89 c7             	mov    %rax,%rdi
  8032a1:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
  8032ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b4:	79 05                	jns    8032bb <stat+0x36>
		return fd;
  8032b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b9:	eb 2f                	jmp    8032ea <stat+0x65>
	r = fstat(fd, stat);
  8032bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c2:	48 89 d6             	mov    %rdx,%rsi
  8032c5:	89 c7                	mov    %eax,%edi
  8032c7:	48 b8 cc 31 80 00 00 	movabs $0x8031cc,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8032d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d9:	89 c7                	mov    %eax,%edi
  8032db:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
	return r;
  8032e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8032ea:	c9                   	leaveq 
  8032eb:	c3                   	retq   

00000000008032ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8032ec:	55                   	push   %rbp
  8032ed:	48 89 e5             	mov    %rsp,%rbp
  8032f0:	48 83 ec 10          	sub    $0x10,%rsp
  8032f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8032fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803302:	00 00 00 
  803305:	8b 00                	mov    (%rax),%eax
  803307:	85 c0                	test   %eax,%eax
  803309:	75 1f                	jne    80332a <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80330b:	bf 01 00 00 00       	mov    $0x1,%edi
  803310:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
  80331c:	89 c2                	mov    %eax,%edx
  80331e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803325:	00 00 00 
  803328:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80332a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803331:	00 00 00 
  803334:	8b 00                	mov    (%rax),%eax
  803336:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803339:	b9 07 00 00 00       	mov    $0x7,%ecx
  80333e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803345:	00 00 00 
  803348:	89 c7                	mov    %eax,%edi
  80334a:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335a:	ba 00 00 00 00       	mov    $0x0,%edx
  80335f:	48 89 c6             	mov    %rax,%rsi
  803362:	bf 00 00 00 00       	mov    $0x0,%edi
  803367:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
}
  803373:	c9                   	leaveq 
  803374:	c3                   	retq   

0000000000803375 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803375:	55                   	push   %rbp
  803376:	48 89 e5             	mov    %rsp,%rbp
  803379:	48 83 ec 10          	sub    $0x10,%rsp
  80337d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803381:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  803384:	48 ba 26 53 80 00 00 	movabs $0x805326,%rdx
  80338b:	00 00 00 
  80338e:	be 4c 00 00 00       	mov    $0x4c,%esi
  803393:	48 bf 3b 53 80 00 00 	movabs $0x80533b,%rdi
  80339a:	00 00 00 
  80339d:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a2:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  8033a9:	00 00 00 
  8033ac:	ff d1                	callq  *%rcx

00000000008033ae <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8033ae:	55                   	push   %rbp
  8033af:	48 89 e5             	mov    %rsp,%rbp
  8033b2:	48 83 ec 10          	sub    $0x10,%rsp
  8033b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8033ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033be:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033c8:	00 00 00 
  8033cb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8033cd:	be 00 00 00 00       	mov    $0x0,%esi
  8033d2:	bf 06 00 00 00       	mov    $0x6,%edi
  8033d7:	48 b8 ec 32 80 00 00 	movabs $0x8032ec,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
}
  8033e3:	c9                   	leaveq 
  8033e4:	c3                   	retq   

00000000008033e5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 20          	sub    $0x20,%rsp
  8033ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8033f9:	48 ba 46 53 80 00 00 	movabs $0x805346,%rdx
  803400:	00 00 00 
  803403:	be 6b 00 00 00       	mov    $0x6b,%esi
  803408:	48 bf 3b 53 80 00 00 	movabs $0x80533b,%rdi
  80340f:	00 00 00 
  803412:	b8 00 00 00 00       	mov    $0x0,%eax
  803417:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  80341e:	00 00 00 
  803421:	ff d1                	callq  *%rcx

0000000000803423 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803423:	55                   	push   %rbp
  803424:	48 89 e5             	mov    %rsp,%rbp
  803427:	48 83 ec 20          	sub    $0x20,%rsp
  80342b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80342f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803433:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  803437:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  80343e:	00 00 00 
  803441:	be 7b 00 00 00       	mov    $0x7b,%esi
  803446:	48 bf 3b 53 80 00 00 	movabs $0x80533b,%rdi
  80344d:	00 00 00 
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
  803455:	48 b9 de 0c 80 00 00 	movabs $0x800cde,%rcx
  80345c:	00 00 00 
  80345f:	ff d1                	callq  *%rcx

0000000000803461 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803461:	55                   	push   %rbp
  803462:	48 89 e5             	mov    %rsp,%rbp
  803465:	48 83 ec 20          	sub    $0x20,%rsp
  803469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80346d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803475:	8b 50 0c             	mov    0xc(%rax),%edx
  803478:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80347f:	00 00 00 
  803482:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803484:	be 00 00 00 00       	mov    $0x0,%esi
  803489:	bf 05 00 00 00       	mov    $0x5,%edi
  80348e:	48 b8 ec 32 80 00 00 	movabs $0x8032ec,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
  80349a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a1:	79 05                	jns    8034a8 <devfile_stat+0x47>
		return r;
  8034a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a6:	eb 56                	jmp    8034fe <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8034a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ac:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8034b3:	00 00 00 
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8034c5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034cc:	00 00 00 
  8034cf:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8034d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034e6:	00 00 00 
  8034e9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8034ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8034f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034fe:	c9                   	leaveq 
  8034ff:	c3                   	retq   

0000000000803500 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803500:	55                   	push   %rbp
  803501:	48 89 e5             	mov    %rsp,%rbp
  803504:	48 83 ec 10          	sub    $0x10,%rsp
  803508:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80350c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80350f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803513:	8b 50 0c             	mov    0xc(%rax),%edx
  803516:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80351d:	00 00 00 
  803520:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803522:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803529:	00 00 00 
  80352c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80352f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803532:	be 00 00 00 00       	mov    $0x0,%esi
  803537:	bf 02 00 00 00       	mov    $0x2,%edi
  80353c:	48 b8 ec 32 80 00 00 	movabs $0x8032ec,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <remove>:

// Delete a file
int
remove(const char *path)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	48 83 ec 10          	sub    $0x10,%rsp
  803552:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355a:	48 89 c7             	mov    %rax,%rdi
  80355d:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
  803569:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80356e:	7e 07                	jle    803577 <remove+0x2d>
		return -E_BAD_PATH;
  803570:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803575:	eb 33                	jmp    8035aa <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803577:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357b:	48 89 c6             	mov    %rax,%rsi
  80357e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803585:	00 00 00 
  803588:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803594:	be 00 00 00 00       	mov    $0x0,%esi
  803599:	bf 07 00 00 00       	mov    $0x7,%edi
  80359e:	48 b8 ec 32 80 00 00 	movabs $0x8032ec,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
}
  8035aa:	c9                   	leaveq 
  8035ab:	c3                   	retq   

00000000008035ac <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8035ac:	55                   	push   %rbp
  8035ad:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035b0:	be 00 00 00 00       	mov    $0x0,%esi
  8035b5:	bf 08 00 00 00       	mov    $0x8,%edi
  8035ba:	48 b8 ec 32 80 00 00 	movabs $0x8032ec,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
}
  8035c6:	5d                   	pop    %rbp
  8035c7:	c3                   	retq   

00000000008035c8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8035c8:	55                   	push   %rbp
  8035c9:	48 89 e5             	mov    %rsp,%rbp
  8035cc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8035d3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8035da:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8035e1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8035e8:	be 00 00 00 00       	mov    $0x0,%esi
  8035ed:	48 89 c7             	mov    %rax,%rdi
  8035f0:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8035ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803603:	79 28                	jns    80362d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803608:	89 c6                	mov    %eax,%esi
  80360a:	48 bf 81 53 80 00 00 	movabs $0x805381,%rdi
  803611:	00 00 00 
  803614:	b8 00 00 00 00       	mov    $0x0,%eax
  803619:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  803620:	00 00 00 
  803623:	ff d2                	callq  *%rdx
		return fd_src;
  803625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803628:	e9 74 01 00 00       	jmpq   8037a1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80362d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803634:	be 01 01 00 00       	mov    $0x101,%esi
  803639:	48 89 c7             	mov    %rax,%rdi
  80363c:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80364b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80364f:	79 39                	jns    80368a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803651:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803654:	89 c6                	mov    %eax,%esi
  803656:	48 bf 97 53 80 00 00 	movabs $0x805397,%rdi
  80365d:	00 00 00 
  803660:	b8 00 00 00 00       	mov    $0x0,%eax
  803665:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  80366c:	00 00 00 
  80366f:	ff d2                	callq  *%rdx
		close(fd_src);
  803671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803674:	89 c7                	mov    %eax,%edi
  803676:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  80367d:	00 00 00 
  803680:	ff d0                	callq  *%rax
		return fd_dest;
  803682:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803685:	e9 17 01 00 00       	jmpq   8037a1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80368a:	eb 74                	jmp    803700 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80368c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80368f:	48 63 d0             	movslq %eax,%rdx
  803692:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803699:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80369c:	48 89 ce             	mov    %rcx,%rsi
  80369f:	89 c7                	mov    %eax,%edi
  8036a1:	48 b8 e7 2f 80 00 00 	movabs $0x802fe7,%rax
  8036a8:	00 00 00 
  8036ab:	ff d0                	callq  *%rax
  8036ad:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8036b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8036b4:	79 4a                	jns    803700 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8036b6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036b9:	89 c6                	mov    %eax,%esi
  8036bb:	48 bf b1 53 80 00 00 	movabs $0x8053b1,%rdi
  8036c2:	00 00 00 
  8036c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ca:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  8036d1:	00 00 00 
  8036d4:	ff d2                	callq  *%rdx
			close(fd_src);
  8036d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d9:	89 c7                	mov    %eax,%edi
  8036db:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
			close(fd_dest);
  8036e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ea:	89 c7                	mov    %eax,%edi
  8036ec:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
			return write_size;
  8036f8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036fb:	e9 a1 00 00 00       	jmpq   8037a1 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803700:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370a:	ba 00 02 00 00       	mov    $0x200,%edx
  80370f:	48 89 ce             	mov    %rcx,%rsi
  803712:	89 c7                	mov    %eax,%edi
  803714:	48 b8 9d 2e 80 00 00 	movabs $0x802e9d,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
  803720:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803723:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803727:	0f 8f 5f ff ff ff    	jg     80368c <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  80372d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803731:	79 47                	jns    80377a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803733:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803736:	89 c6                	mov    %eax,%esi
  803738:	48 bf c4 53 80 00 00 	movabs $0x8053c4,%rdi
  80373f:	00 00 00 
  803742:	b8 00 00 00 00       	mov    $0x0,%eax
  803747:	48 ba 17 0f 80 00 00 	movabs $0x800f17,%rdx
  80374e:	00 00 00 
  803751:	ff d2                	callq  *%rdx
		close(fd_src);
  803753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803756:	89 c7                	mov    %eax,%edi
  803758:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
		close(fd_dest);
  803764:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803767:	89 c7                	mov    %eax,%edi
  803769:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
		return read_size;
  803775:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803778:	eb 27                	jmp    8037a1 <copy+0x1d9>
	}
	close(fd_src);
  80377a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377d:	89 c7                	mov    %eax,%edi
  80377f:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
	close(fd_dest);
  80378b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80378e:	89 c7                	mov    %eax,%edi
  803790:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
	return 0;
  80379c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8037a1:	c9                   	leaveq 
  8037a2:	c3                   	retq   

00000000008037a3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8037a3:	55                   	push   %rbp
  8037a4:	48 89 e5             	mov    %rsp,%rbp
  8037a7:	48 83 ec 20          	sub    $0x20,%rsp
  8037ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8037ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b5:	48 89 d6             	mov    %rdx,%rsi
  8037b8:	89 c7                	mov    %eax,%edi
  8037ba:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cd:	79 05                	jns    8037d4 <fd2sockid+0x31>
		return r;
  8037cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d2:	eb 24                	jmp    8037f8 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8037d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d8:	8b 10                	mov    (%rax),%edx
  8037da:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8037e1:	00 00 00 
  8037e4:	8b 00                	mov    (%rax),%eax
  8037e6:	39 c2                	cmp    %eax,%edx
  8037e8:	74 07                	je     8037f1 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8037ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8037ef:	eb 07                	jmp    8037f8 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8037f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f5:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8037f8:	c9                   	leaveq 
  8037f9:	c3                   	retq   

00000000008037fa <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8037fa:	55                   	push   %rbp
  8037fb:	48 89 e5             	mov    %rsp,%rbp
  8037fe:	48 83 ec 20          	sub    $0x20,%rsp
  803802:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803805:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
  803818:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381f:	78 26                	js     803847 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803825:	ba 07 04 00 00       	mov    $0x407,%edx
  80382a:	48 89 c6             	mov    %rax,%rsi
  80382d:	bf 00 00 00 00       	mov    $0x0,%edi
  803832:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803845:	79 16                	jns    80385d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803847:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384a:	89 c7                	mov    %eax,%edi
  80384c:	48 b8 09 3d 80 00 00 	movabs $0x803d09,%rax
  803853:	00 00 00 
  803856:	ff d0                	callq  *%rax
		return r;
  803858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385b:	eb 3a                	jmp    803897 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80385d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803861:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803868:	00 00 00 
  80386b:	8b 12                	mov    (%rdx),%edx
  80386d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80386f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803873:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80387a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803881:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803888:	48 89 c7             	mov    %rax,%rdi
  80388b:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  803892:	00 00 00 
  803895:	ff d0                	callq  *%rax
}
  803897:	c9                   	leaveq 
  803898:	c3                   	retq   

0000000000803899 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803899:	55                   	push   %rbp
  80389a:	48 89 e5             	mov    %rsp,%rbp
  80389d:	48 83 ec 30          	sub    $0x30,%rsp
  8038a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038af:	89 c7                	mov    %eax,%edi
  8038b1:	48 b8 a3 37 80 00 00 	movabs $0x8037a3,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
  8038bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c4:	79 05                	jns    8038cb <accept+0x32>
		return r;
  8038c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c9:	eb 3b                	jmp    803906 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038cf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d6:	48 89 ce             	mov    %rcx,%rsi
  8038d9:	89 c7                	mov    %eax,%edi
  8038db:	48 b8 e6 3b 80 00 00 	movabs $0x803be6,%rax
  8038e2:	00 00 00 
  8038e5:	ff d0                	callq  *%rax
  8038e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ee:	79 05                	jns    8038f5 <accept+0x5c>
		return r;
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f3:	eb 11                	jmp    803906 <accept+0x6d>
	return alloc_sockfd(r);
  8038f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f8:	89 c7                	mov    %eax,%edi
  8038fa:	48 b8 fa 37 80 00 00 	movabs $0x8037fa,%rax
  803901:	00 00 00 
  803904:	ff d0                	callq  *%rax
}
  803906:	c9                   	leaveq 
  803907:	c3                   	retq   

0000000000803908 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803908:	55                   	push   %rbp
  803909:	48 89 e5             	mov    %rsp,%rbp
  80390c:	48 83 ec 20          	sub    $0x20,%rsp
  803910:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803913:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803917:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80391a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80391d:	89 c7                	mov    %eax,%edi
  80391f:	48 b8 a3 37 80 00 00 	movabs $0x8037a3,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
  80392b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803932:	79 05                	jns    803939 <bind+0x31>
		return r;
  803934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803937:	eb 1b                	jmp    803954 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803939:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80393c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803940:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803943:	48 89 ce             	mov    %rcx,%rsi
  803946:	89 c7                	mov    %eax,%edi
  803948:	48 b8 65 3c 80 00 00 	movabs $0x803c65,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
}
  803954:	c9                   	leaveq 
  803955:	c3                   	retq   

0000000000803956 <shutdown>:

int
shutdown(int s, int how)
{
  803956:	55                   	push   %rbp
  803957:	48 89 e5             	mov    %rsp,%rbp
  80395a:	48 83 ec 20          	sub    $0x20,%rsp
  80395e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803961:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803964:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803967:	89 c7                	mov    %eax,%edi
  803969:	48 b8 a3 37 80 00 00 	movabs $0x8037a3,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
  803975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803978:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397c:	79 05                	jns    803983 <shutdown+0x2d>
		return r;
  80397e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803981:	eb 16                	jmp    803999 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803983:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803989:	89 d6                	mov    %edx,%esi
  80398b:	89 c7                	mov    %eax,%edi
  80398d:	48 b8 c9 3c 80 00 00 	movabs $0x803cc9,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
}
  803999:	c9                   	leaveq 
  80399a:	c3                   	retq   

000000000080399b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80399b:	55                   	push   %rbp
  80399c:	48 89 e5             	mov    %rsp,%rbp
  80399f:	48 83 ec 10          	sub    $0x10,%rsp
  8039a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8039a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ab:	48 89 c7             	mov    %rax,%rdi
  8039ae:	48 b8 2b 48 80 00 00 	movabs $0x80482b,%rax
  8039b5:	00 00 00 
  8039b8:	ff d0                	callq  *%rax
  8039ba:	83 f8 01             	cmp    $0x1,%eax
  8039bd:	75 17                	jne    8039d6 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8039bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8039c6:	89 c7                	mov    %eax,%edi
  8039c8:	48 b8 09 3d 80 00 00 	movabs $0x803d09,%rax
  8039cf:	00 00 00 
  8039d2:	ff d0                	callq  *%rax
  8039d4:	eb 05                	jmp    8039db <devsock_close+0x40>
	else
		return 0;
  8039d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039db:	c9                   	leaveq 
  8039dc:	c3                   	retq   

00000000008039dd <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039dd:	55                   	push   %rbp
  8039de:	48 89 e5             	mov    %rsp,%rbp
  8039e1:	48 83 ec 20          	sub    $0x20,%rsp
  8039e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039ec:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f2:	89 c7                	mov    %eax,%edi
  8039f4:	48 b8 a3 37 80 00 00 	movabs $0x8037a3,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a07:	79 05                	jns    803a0e <connect+0x31>
		return r;
  803a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0c:	eb 1b                	jmp    803a29 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a0e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a11:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a18:	48 89 ce             	mov    %rcx,%rsi
  803a1b:	89 c7                	mov    %eax,%edi
  803a1d:	48 b8 36 3d 80 00 00 	movabs $0x803d36,%rax
  803a24:	00 00 00 
  803a27:	ff d0                	callq  *%rax
}
  803a29:	c9                   	leaveq 
  803a2a:	c3                   	retq   

0000000000803a2b <listen>:

int
listen(int s, int backlog)
{
  803a2b:	55                   	push   %rbp
  803a2c:	48 89 e5             	mov    %rsp,%rbp
  803a2f:	48 83 ec 20          	sub    $0x20,%rsp
  803a33:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a36:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a3c:	89 c7                	mov    %eax,%edi
  803a3e:	48 b8 a3 37 80 00 00 	movabs $0x8037a3,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a51:	79 05                	jns    803a58 <listen+0x2d>
		return r;
  803a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a56:	eb 16                	jmp    803a6e <listen+0x43>
	return nsipc_listen(r, backlog);
  803a58:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5e:	89 d6                	mov    %edx,%esi
  803a60:	89 c7                	mov    %eax,%edi
  803a62:	48 b8 9a 3d 80 00 00 	movabs $0x803d9a,%rax
  803a69:	00 00 00 
  803a6c:	ff d0                	callq  *%rax
}
  803a6e:	c9                   	leaveq 
  803a6f:	c3                   	retq   

0000000000803a70 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a70:	55                   	push   %rbp
  803a71:	48 89 e5             	mov    %rsp,%rbp
  803a74:	48 83 ec 20          	sub    $0x20,%rsp
  803a78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a80:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a88:	89 c2                	mov    %eax,%edx
  803a8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8e:	8b 40 0c             	mov    0xc(%rax),%eax
  803a91:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a95:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a9a:	89 c7                	mov    %eax,%edi
  803a9c:	48 b8 da 3d 80 00 00 	movabs $0x803dda,%rax
  803aa3:	00 00 00 
  803aa6:	ff d0                	callq  *%rax
}
  803aa8:	c9                   	leaveq 
  803aa9:	c3                   	retq   

0000000000803aaa <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803aaa:	55                   	push   %rbp
  803aab:	48 89 e5             	mov    %rsp,%rbp
  803aae:	48 83 ec 20          	sub    $0x20,%rsp
  803ab2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803aba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ac2:	89 c2                	mov    %eax,%edx
  803ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac8:	8b 40 0c             	mov    0xc(%rax),%eax
  803acb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803acf:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ad4:	89 c7                	mov    %eax,%edi
  803ad6:	48 b8 a6 3e 80 00 00 	movabs $0x803ea6,%rax
  803add:	00 00 00 
  803ae0:	ff d0                	callq  *%rax
}
  803ae2:	c9                   	leaveq 
  803ae3:	c3                   	retq   

0000000000803ae4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ae4:	55                   	push   %rbp
  803ae5:	48 89 e5             	mov    %rsp,%rbp
  803ae8:	48 83 ec 10          	sub    $0x10,%rsp
  803aec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803af0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af8:	48 be df 53 80 00 00 	movabs $0x8053df,%rsi
  803aff:	00 00 00 
  803b02:	48 89 c7             	mov    %rax,%rdi
  803b05:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  803b0c:	00 00 00 
  803b0f:	ff d0                	callq  *%rax
	return 0;
  803b11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b16:	c9                   	leaveq 
  803b17:	c3                   	retq   

0000000000803b18 <socket>:

int
socket(int domain, int type, int protocol)
{
  803b18:	55                   	push   %rbp
  803b19:	48 89 e5             	mov    %rsp,%rbp
  803b1c:	48 83 ec 20          	sub    $0x20,%rsp
  803b20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b23:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b26:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b29:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803b2c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b32:	89 ce                	mov    %ecx,%esi
  803b34:	89 c7                	mov    %eax,%edi
  803b36:	48 b8 5e 3f 80 00 00 	movabs $0x803f5e,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	callq  *%rax
  803b42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b49:	79 05                	jns    803b50 <socket+0x38>
		return r;
  803b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4e:	eb 11                	jmp    803b61 <socket+0x49>
	return alloc_sockfd(r);
  803b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b53:	89 c7                	mov    %eax,%edi
  803b55:	48 b8 fa 37 80 00 00 	movabs $0x8037fa,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
}
  803b61:	c9                   	leaveq 
  803b62:	c3                   	retq   

0000000000803b63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b63:	55                   	push   %rbp
  803b64:	48 89 e5             	mov    %rsp,%rbp
  803b67:	48 83 ec 10          	sub    $0x10,%rsp
  803b6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b6e:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b75:	00 00 00 
  803b78:	8b 00                	mov    (%rax),%eax
  803b7a:	85 c0                	test   %eax,%eax
  803b7c:	75 1f                	jne    803b9d <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803b7e:	bf 02 00 00 00       	mov    $0x2,%edi
  803b83:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  803b8a:	00 00 00 
  803b8d:	ff d0                	callq  *%rax
  803b8f:	89 c2                	mov    %eax,%edx
  803b91:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b98:	00 00 00 
  803b9b:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b9d:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ba4:	00 00 00 
  803ba7:	8b 00                	mov    (%rax),%eax
  803ba9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803bac:	b9 07 00 00 00       	mov    $0x7,%ecx
  803bb1:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803bb8:	00 00 00 
  803bbb:	89 c7                	mov    %eax,%edi
  803bbd:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  803bc4:	00 00 00 
  803bc7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  803bce:	be 00 00 00 00       	mov    $0x0,%esi
  803bd3:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd8:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  803bdf:	00 00 00 
  803be2:	ff d0                	callq  *%rax
}
  803be4:	c9                   	leaveq 
  803be5:	c3                   	retq   

0000000000803be6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803be6:	55                   	push   %rbp
  803be7:	48 89 e5             	mov    %rsp,%rbp
  803bea:	48 83 ec 30          	sub    $0x30,%rsp
  803bee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bf1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803bf9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c00:	00 00 00 
  803c03:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c06:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c08:	bf 01 00 00 00       	mov    $0x1,%edi
  803c0d:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
  803c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c20:	78 3e                	js     803c60 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803c22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c29:	00 00 00 
  803c2c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c34:	8b 40 10             	mov    0x10(%rax),%eax
  803c37:	89 c2                	mov    %eax,%edx
  803c39:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803c3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c41:	48 89 ce             	mov    %rcx,%rsi
  803c44:	48 89 c7             	mov    %rax,%rdi
  803c47:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c57:	8b 50 10             	mov    0x10(%rax),%edx
  803c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c5e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	48 83 ec 10          	sub    $0x10,%rsp
  803c6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c74:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803c77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7e:	00 00 00 
  803c81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c84:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c86:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8d:	48 89 c6             	mov    %rax,%rsi
  803c90:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c97:	00 00 00 
  803c9a:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  803ca1:	00 00 00 
  803ca4:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ca6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cad:	00 00 00 
  803cb0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803cb6:	bf 02 00 00 00       	mov    $0x2,%edi
  803cbb:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803cc2:	00 00 00 
  803cc5:	ff d0                	callq  *%rax
}
  803cc7:	c9                   	leaveq 
  803cc8:	c3                   	retq   

0000000000803cc9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803cc9:	55                   	push   %rbp
  803cca:	48 89 e5             	mov    %rsp,%rbp
  803ccd:	48 83 ec 10          	sub    $0x10,%rsp
  803cd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cd4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803cd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cde:	00 00 00 
  803ce1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ce4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ce6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ced:	00 00 00 
  803cf0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cf3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803cf6:	bf 03 00 00 00       	mov    $0x3,%edi
  803cfb:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
}
  803d07:	c9                   	leaveq 
  803d08:	c3                   	retq   

0000000000803d09 <nsipc_close>:

int
nsipc_close(int s)
{
  803d09:	55                   	push   %rbp
  803d0a:	48 89 e5             	mov    %rsp,%rbp
  803d0d:	48 83 ec 10          	sub    $0x10,%rsp
  803d11:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d14:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1b:	00 00 00 
  803d1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d21:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803d23:	bf 04 00 00 00       	mov    $0x4,%edi
  803d28:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
}
  803d34:	c9                   	leaveq 
  803d35:	c3                   	retq   

0000000000803d36 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d36:	55                   	push   %rbp
  803d37:	48 89 e5             	mov    %rsp,%rbp
  803d3a:	48 83 ec 10          	sub    $0x10,%rsp
  803d3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d45:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803d48:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4f:	00 00 00 
  803d52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d55:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d57:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5e:	48 89 c6             	mov    %rax,%rsi
  803d61:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d68:	00 00 00 
  803d6b:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  803d72:	00 00 00 
  803d75:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803d77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d7e:	00 00 00 
  803d81:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d84:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803d87:	bf 05 00 00 00       	mov    $0x5,%edi
  803d8c:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
}
  803d98:	c9                   	leaveq 
  803d99:	c3                   	retq   

0000000000803d9a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803d9a:	55                   	push   %rbp
  803d9b:	48 89 e5             	mov    %rsp,%rbp
  803d9e:	48 83 ec 10          	sub    $0x10,%rsp
  803da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803da5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803da8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803daf:	00 00 00 
  803db2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803db5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803db7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dbe:	00 00 00 
  803dc1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dc4:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803dc7:	bf 06 00 00 00       	mov    $0x6,%edi
  803dcc:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803dd3:	00 00 00 
  803dd6:	ff d0                	callq  *%rax
}
  803dd8:	c9                   	leaveq 
  803dd9:	c3                   	retq   

0000000000803dda <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803dda:	55                   	push   %rbp
  803ddb:	48 89 e5             	mov    %rsp,%rbp
  803dde:	48 83 ec 30          	sub    $0x30,%rsp
  803de2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803de5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803de9:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803dec:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803def:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df6:	00 00 00 
  803df9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dfc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803dfe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e05:	00 00 00 
  803e08:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e0b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e0e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e15:	00 00 00 
  803e18:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e1b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e1e:	bf 07 00 00 00       	mov    $0x7,%edi
  803e23:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803e2a:	00 00 00 
  803e2d:	ff d0                	callq  *%rax
  803e2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e36:	78 69                	js     803ea1 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803e38:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803e3f:	7f 08                	jg     803e49 <nsipc_recv+0x6f>
  803e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e44:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803e47:	7e 35                	jle    803e7e <nsipc_recv+0xa4>
  803e49:	48 b9 e6 53 80 00 00 	movabs $0x8053e6,%rcx
  803e50:	00 00 00 
  803e53:	48 ba fb 53 80 00 00 	movabs $0x8053fb,%rdx
  803e5a:	00 00 00 
  803e5d:	be 61 00 00 00       	mov    $0x61,%esi
  803e62:	48 bf 10 54 80 00 00 	movabs $0x805410,%rdi
  803e69:	00 00 00 
  803e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e71:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  803e78:	00 00 00 
  803e7b:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e81:	48 63 d0             	movslq %eax,%rdx
  803e84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e88:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803e8f:	00 00 00 
  803e92:	48 89 c7             	mov    %rax,%rdi
  803e95:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  803e9c:	00 00 00 
  803e9f:	ff d0                	callq  *%rax
	}

	return r;
  803ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ea4:	c9                   	leaveq 
  803ea5:	c3                   	retq   

0000000000803ea6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ea6:	55                   	push   %rbp
  803ea7:	48 89 e5             	mov    %rsp,%rbp
  803eaa:	48 83 ec 20          	sub    $0x20,%rsp
  803eae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803eb5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803eb8:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803ebb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ec2:	00 00 00 
  803ec5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ec8:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803eca:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ed1:	7e 35                	jle    803f08 <nsipc_send+0x62>
  803ed3:	48 b9 1c 54 80 00 00 	movabs $0x80541c,%rcx
  803eda:	00 00 00 
  803edd:	48 ba fb 53 80 00 00 	movabs $0x8053fb,%rdx
  803ee4:	00 00 00 
  803ee7:	be 6c 00 00 00       	mov    $0x6c,%esi
  803eec:	48 bf 10 54 80 00 00 	movabs $0x805410,%rdi
  803ef3:	00 00 00 
  803ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  803efb:	49 b8 de 0c 80 00 00 	movabs $0x800cde,%r8
  803f02:	00 00 00 
  803f05:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f0b:	48 63 d0             	movslq %eax,%rdx
  803f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f12:	48 89 c6             	mov    %rax,%rsi
  803f15:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803f1c:	00 00 00 
  803f1f:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  803f26:	00 00 00 
  803f29:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803f2b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f32:	00 00 00 
  803f35:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f38:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803f3b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f42:	00 00 00 
  803f45:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f48:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803f4b:	bf 08 00 00 00       	mov    $0x8,%edi
  803f50:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803f57:	00 00 00 
  803f5a:	ff d0                	callq  *%rax
}
  803f5c:	c9                   	leaveq 
  803f5d:	c3                   	retq   

0000000000803f5e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803f5e:	55                   	push   %rbp
  803f5f:	48 89 e5             	mov    %rsp,%rbp
  803f62:	48 83 ec 10          	sub    $0x10,%rsp
  803f66:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f69:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f6c:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803f6f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f76:	00 00 00 
  803f79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f7c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803f7e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f85:	00 00 00 
  803f88:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f8b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803f8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f95:	00 00 00 
  803f98:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f9b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803f9e:	bf 09 00 00 00       	mov    $0x9,%edi
  803fa3:	48 b8 63 3b 80 00 00 	movabs $0x803b63,%rax
  803faa:	00 00 00 
  803fad:	ff d0                	callq  *%rax
}
  803faf:	c9                   	leaveq 
  803fb0:	c3                   	retq   

0000000000803fb1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803fb1:	55                   	push   %rbp
  803fb2:	48 89 e5             	mov    %rsp,%rbp
  803fb5:	53                   	push   %rbx
  803fb6:	48 83 ec 38          	sub    $0x38,%rsp
  803fba:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803fbe:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803fc2:	48 89 c7             	mov    %rax,%rdi
  803fc5:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  803fcc:	00 00 00 
  803fcf:	ff d0                	callq  *%rax
  803fd1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fd8:	0f 88 bf 01 00 00    	js     80419d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe2:	ba 07 04 00 00       	mov    $0x407,%edx
  803fe7:	48 89 c6             	mov    %rax,%rsi
  803fea:	bf 00 00 00 00       	mov    $0x0,%edi
  803fef:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
  803ffb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ffe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804002:	0f 88 95 01 00 00    	js     80419d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804008:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80400c:	48 89 c7             	mov    %rax,%rdi
  80400f:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  804016:	00 00 00 
  804019:	ff d0                	callq  *%rax
  80401b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80401e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804022:	0f 88 5d 01 00 00    	js     804185 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804028:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80402c:	ba 07 04 00 00       	mov    $0x407,%edx
  804031:	48 89 c6             	mov    %rax,%rsi
  804034:	bf 00 00 00 00       	mov    $0x0,%edi
  804039:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804048:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80404c:	0f 88 33 01 00 00    	js     804185 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804052:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804056:	48 89 c7             	mov    %rax,%rdi
  804059:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  804060:	00 00 00 
  804063:	ff d0                	callq  *%rax
  804065:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804069:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80406d:	ba 07 04 00 00       	mov    $0x407,%edx
  804072:	48 89 c6             	mov    %rax,%rsi
  804075:	bf 00 00 00 00       	mov    $0x0,%edi
  80407a:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
  804086:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804089:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80408d:	79 05                	jns    804094 <pipe+0xe3>
		goto err2;
  80408f:	e9 d9 00 00 00       	jmpq   80416d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804094:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804098:	48 89 c7             	mov    %rax,%rdi
  80409b:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  8040a2:	00 00 00 
  8040a5:	ff d0                	callq  *%rax
  8040a7:	48 89 c2             	mov    %rax,%rdx
  8040aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ae:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8040b4:	48 89 d1             	mov    %rdx,%rcx
  8040b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8040bc:	48 89 c6             	mov    %rax,%rsi
  8040bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c4:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  8040cb:	00 00 00 
  8040ce:	ff d0                	callq  *%rax
  8040d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040d7:	79 1b                	jns    8040f4 <pipe+0x143>
		goto err3;
  8040d9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040de:	48 89 c6             	mov    %rax,%rsi
  8040e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e6:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
  8040f2:	eb 79                	jmp    80416d <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  8040f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f8:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040ff:	00 00 00 
  804102:	8b 12                	mov    (%rdx),%edx
  804104:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804106:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80410a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  804111:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804115:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80411c:	00 00 00 
  80411f:	8b 12                	mov    (%rdx),%edx
  804121:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804123:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804127:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80412e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804132:	48 89 c7             	mov    %rax,%rdi
  804135:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
  804141:	89 c2                	mov    %eax,%edx
  804143:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804147:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804149:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80414d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804151:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804155:	48 89 c7             	mov    %rax,%rdi
  804158:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  80415f:	00 00 00 
  804162:	ff d0                	callq  *%rax
  804164:	89 03                	mov    %eax,(%rbx)
	return 0;
  804166:	b8 00 00 00 00       	mov    $0x0,%eax
  80416b:	eb 33                	jmp    8041a0 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  80416d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804171:	48 89 c6             	mov    %rax,%rsi
  804174:	bf 00 00 00 00       	mov    $0x0,%edi
  804179:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  804180:	00 00 00 
  804183:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804189:	48 89 c6             	mov    %rax,%rsi
  80418c:	bf 00 00 00 00       	mov    $0x0,%edi
  804191:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  804198:	00 00 00 
  80419b:	ff d0                	callq  *%rax
err:
	return r;
  80419d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8041a0:	48 83 c4 38          	add    $0x38,%rsp
  8041a4:	5b                   	pop    %rbx
  8041a5:	5d                   	pop    %rbp
  8041a6:	c3                   	retq   

00000000008041a7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8041a7:	55                   	push   %rbp
  8041a8:	48 89 e5             	mov    %rsp,%rbp
  8041ab:	53                   	push   %rbx
  8041ac:	48 83 ec 28          	sub    $0x28,%rsp
  8041b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8041b8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041bf:	00 00 00 
  8041c2:	48 8b 00             	mov    (%rax),%rax
  8041c5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8041ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d2:	48 89 c7             	mov    %rax,%rdi
  8041d5:	48 b8 2b 48 80 00 00 	movabs $0x80482b,%rax
  8041dc:	00 00 00 
  8041df:	ff d0                	callq  *%rax
  8041e1:	89 c3                	mov    %eax,%ebx
  8041e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e7:	48 89 c7             	mov    %rax,%rdi
  8041ea:	48 b8 2b 48 80 00 00 	movabs $0x80482b,%rax
  8041f1:	00 00 00 
  8041f4:	ff d0                	callq  *%rax
  8041f6:	39 c3                	cmp    %eax,%ebx
  8041f8:	0f 94 c0             	sete   %al
  8041fb:	0f b6 c0             	movzbl %al,%eax
  8041fe:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804201:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804208:	00 00 00 
  80420b:	48 8b 00             	mov    (%rax),%rax
  80420e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804214:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804217:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80421a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80421d:	75 05                	jne    804224 <_pipeisclosed+0x7d>
			return ret;
  80421f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804222:	eb 4a                	jmp    80426e <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804224:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804227:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80422a:	74 3d                	je     804269 <_pipeisclosed+0xc2>
  80422c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804230:	75 37                	jne    804269 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804232:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804239:	00 00 00 
  80423c:	48 8b 00             	mov    (%rax),%rax
  80423f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804245:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804248:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80424b:	89 c6                	mov    %eax,%esi
  80424d:	48 bf 2d 54 80 00 00 	movabs $0x80542d,%rdi
  804254:	00 00 00 
  804257:	b8 00 00 00 00       	mov    $0x0,%eax
  80425c:	49 b8 17 0f 80 00 00 	movabs $0x800f17,%r8
  804263:	00 00 00 
  804266:	41 ff d0             	callq  *%r8
	}
  804269:	e9 4a ff ff ff       	jmpq   8041b8 <_pipeisclosed+0x11>
}
  80426e:	48 83 c4 28          	add    $0x28,%rsp
  804272:	5b                   	pop    %rbx
  804273:	5d                   	pop    %rbp
  804274:	c3                   	retq   

0000000000804275 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804275:	55                   	push   %rbp
  804276:	48 89 e5             	mov    %rsp,%rbp
  804279:	48 83 ec 30          	sub    $0x30,%rsp
  80427d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804280:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804284:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804287:	48 89 d6             	mov    %rdx,%rsi
  80428a:	89 c7                	mov    %eax,%edi
  80428c:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  804293:	00 00 00 
  804296:	ff d0                	callq  *%rax
  804298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80429b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80429f:	79 05                	jns    8042a6 <pipeisclosed+0x31>
		return r;
  8042a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a4:	eb 31                	jmp    8042d7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8042a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042aa:	48 89 c7             	mov    %rax,%rdi
  8042ad:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8042bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042c5:	48 89 d6             	mov    %rdx,%rsi
  8042c8:	48 89 c7             	mov    %rax,%rdi
  8042cb:	48 b8 a7 41 80 00 00 	movabs $0x8041a7,%rax
  8042d2:	00 00 00 
  8042d5:	ff d0                	callq  *%rax
}
  8042d7:	c9                   	leaveq 
  8042d8:	c3                   	retq   

00000000008042d9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042d9:	55                   	push   %rbp
  8042da:	48 89 e5             	mov    %rsp,%rbp
  8042dd:	48 83 ec 40          	sub    $0x40,%rsp
  8042e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8042ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f1:	48 89 c7             	mov    %rax,%rdi
  8042f4:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  8042fb:	00 00 00 
  8042fe:	ff d0                	callq  *%rax
  804300:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804304:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804308:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80430c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804313:	00 
  804314:	e9 92 00 00 00       	jmpq   8043ab <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804319:	eb 41                	jmp    80435c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80431b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804320:	74 09                	je     80432b <devpipe_read+0x52>
				return i;
  804322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804326:	e9 92 00 00 00       	jmpq   8043bd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80432b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80432f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804333:	48 89 d6             	mov    %rdx,%rsi
  804336:	48 89 c7             	mov    %rax,%rdi
  804339:	48 b8 a7 41 80 00 00 	movabs $0x8041a7,%rax
  804340:	00 00 00 
  804343:	ff d0                	callq  *%rax
  804345:	85 c0                	test   %eax,%eax
  804347:	74 07                	je     804350 <devpipe_read+0x77>
				return 0;
  804349:	b8 00 00 00 00       	mov    $0x0,%eax
  80434e:	eb 6d                	jmp    8043bd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804350:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  804357:	00 00 00 
  80435a:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80435c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804360:	8b 10                	mov    (%rax),%edx
  804362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804366:	8b 40 04             	mov    0x4(%rax),%eax
  804369:	39 c2                	cmp    %eax,%edx
  80436b:	74 ae                	je     80431b <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80436d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804375:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437d:	8b 00                	mov    (%rax),%eax
  80437f:	99                   	cltd   
  804380:	c1 ea 1b             	shr    $0x1b,%edx
  804383:	01 d0                	add    %edx,%eax
  804385:	83 e0 1f             	and    $0x1f,%eax
  804388:	29 d0                	sub    %edx,%eax
  80438a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80438e:	48 98                	cltq   
  804390:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804395:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439b:	8b 00                	mov    (%rax),%eax
  80439d:	8d 50 01             	lea    0x1(%rax),%edx
  8043a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a4:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8043a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043af:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043b3:	0f 82 60 ff ff ff    	jb     804319 <devpipe_read+0x40>
	}
	return i;
  8043b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043bd:	c9                   	leaveq 
  8043be:	c3                   	retq   

00000000008043bf <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043bf:	55                   	push   %rbp
  8043c0:	48 89 e5             	mov    %rsp,%rbp
  8043c3:	48 83 ec 40          	sub    $0x40,%rsp
  8043c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8043d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d7:	48 89 c7             	mov    %rax,%rdi
  8043da:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  8043e1:	00 00 00 
  8043e4:	ff d0                	callq  *%rax
  8043e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8043ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8043f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043f9:	00 
  8043fa:	e9 91 00 00 00       	jmpq   804490 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043ff:	eb 31                	jmp    804432 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804401:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804409:	48 89 d6             	mov    %rdx,%rsi
  80440c:	48 89 c7             	mov    %rax,%rdi
  80440f:	48 b8 a7 41 80 00 00 	movabs $0x8041a7,%rax
  804416:	00 00 00 
  804419:	ff d0                	callq  *%rax
  80441b:	85 c0                	test   %eax,%eax
  80441d:	74 07                	je     804426 <devpipe_write+0x67>
				return 0;
  80441f:	b8 00 00 00 00       	mov    $0x0,%eax
  804424:	eb 7c                	jmp    8044a2 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804426:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  80442d:	00 00 00 
  804430:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804436:	8b 40 04             	mov    0x4(%rax),%eax
  804439:	48 63 d0             	movslq %eax,%rdx
  80443c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804440:	8b 00                	mov    (%rax),%eax
  804442:	48 98                	cltq   
  804444:	48 83 c0 20          	add    $0x20,%rax
  804448:	48 39 c2             	cmp    %rax,%rdx
  80444b:	73 b4                	jae    804401 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80444d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804451:	8b 40 04             	mov    0x4(%rax),%eax
  804454:	99                   	cltd   
  804455:	c1 ea 1b             	shr    $0x1b,%edx
  804458:	01 d0                	add    %edx,%eax
  80445a:	83 e0 1f             	and    $0x1f,%eax
  80445d:	29 d0                	sub    %edx,%eax
  80445f:	89 c6                	mov    %eax,%esi
  804461:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804469:	48 01 d0             	add    %rdx,%rax
  80446c:	0f b6 08             	movzbl (%rax),%ecx
  80446f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804473:	48 63 c6             	movslq %esi,%rax
  804476:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80447a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447e:	8b 40 04             	mov    0x4(%rax),%eax
  804481:	8d 50 01             	lea    0x1(%rax),%edx
  804484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804488:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80448b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804494:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804498:	0f 82 61 ff ff ff    	jb     8043ff <devpipe_write+0x40>
	}

	return i;
  80449e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8044a2:	c9                   	leaveq 
  8044a3:	c3                   	retq   

00000000008044a4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8044a4:	55                   	push   %rbp
  8044a5:	48 89 e5             	mov    %rsp,%rbp
  8044a8:	48 83 ec 20          	sub    $0x20,%rsp
  8044ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8044b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b8:	48 89 c7             	mov    %rax,%rdi
  8044bb:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  8044c2:	00 00 00 
  8044c5:	ff d0                	callq  *%rax
  8044c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8044cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044cf:	48 be 40 54 80 00 00 	movabs $0x805440,%rsi
  8044d6:	00 00 00 
  8044d9:	48 89 c7             	mov    %rax,%rdi
  8044dc:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  8044e3:	00 00 00 
  8044e6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8044e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ec:	8b 50 04             	mov    0x4(%rax),%edx
  8044ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f3:	8b 00                	mov    (%rax),%eax
  8044f5:	29 c2                	sub    %eax,%edx
  8044f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044fb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804501:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804505:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80450c:	00 00 00 
	stat->st_dev = &devpipe;
  80450f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804513:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80451a:	00 00 00 
  80451d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804529:	c9                   	leaveq 
  80452a:	c3                   	retq   

000000000080452b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80452b:	55                   	push   %rbp
  80452c:	48 89 e5             	mov    %rsp,%rbp
  80452f:	48 83 ec 10          	sub    $0x10,%rsp
  804533:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80453b:	48 89 c6             	mov    %rax,%rsi
  80453e:	bf 00 00 00 00       	mov    $0x0,%edi
  804543:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  80454a:	00 00 00 
  80454d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80454f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804553:	48 89 c7             	mov    %rax,%rdi
  804556:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  80455d:	00 00 00 
  804560:	ff d0                	callq  *%rax
  804562:	48 89 c6             	mov    %rax,%rsi
  804565:	bf 00 00 00 00       	mov    $0x0,%edi
  80456a:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  804571:	00 00 00 
  804574:	ff d0                	callq  *%rax
}
  804576:	c9                   	leaveq 
  804577:	c3                   	retq   

0000000000804578 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804578:	55                   	push   %rbp
  804579:	48 89 e5             	mov    %rsp,%rbp
  80457c:	48 83 ec 20          	sub    $0x20,%rsp
  804580:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804583:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804586:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804589:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80458d:	be 01 00 00 00       	mov    $0x1,%esi
  804592:	48 89 c7             	mov    %rax,%rdi
  804595:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  80459c:	00 00 00 
  80459f:	ff d0                	callq  *%rax
}
  8045a1:	c9                   	leaveq 
  8045a2:	c3                   	retq   

00000000008045a3 <getchar>:

int
getchar(void)
{
  8045a3:	55                   	push   %rbp
  8045a4:	48 89 e5             	mov    %rsp,%rbp
  8045a7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8045ab:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8045af:	ba 01 00 00 00       	mov    $0x1,%edx
  8045b4:	48 89 c6             	mov    %rax,%rsi
  8045b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8045bc:	48 b8 9d 2e 80 00 00 	movabs $0x802e9d,%rax
  8045c3:	00 00 00 
  8045c6:	ff d0                	callq  *%rax
  8045c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045cf:	79 05                	jns    8045d6 <getchar+0x33>
		return r;
  8045d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d4:	eb 14                	jmp    8045ea <getchar+0x47>
	if (r < 1)
  8045d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045da:	7f 07                	jg     8045e3 <getchar+0x40>
		return -E_EOF;
  8045dc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045e1:	eb 07                	jmp    8045ea <getchar+0x47>
	return c;
  8045e3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045e7:	0f b6 c0             	movzbl %al,%eax
}
  8045ea:	c9                   	leaveq 
  8045eb:	c3                   	retq   

00000000008045ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045ec:	55                   	push   %rbp
  8045ed:	48 89 e5             	mov    %rsp,%rbp
  8045f0:	48 83 ec 20          	sub    $0x20,%rsp
  8045f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045fe:	48 89 d6             	mov    %rdx,%rsi
  804601:	89 c7                	mov    %eax,%edi
  804603:	48 b8 69 2a 80 00 00 	movabs $0x802a69,%rax
  80460a:	00 00 00 
  80460d:	ff d0                	callq  *%rax
  80460f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804616:	79 05                	jns    80461d <iscons+0x31>
		return r;
  804618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80461b:	eb 1a                	jmp    804637 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80461d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804621:	8b 10                	mov    (%rax),%edx
  804623:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80462a:	00 00 00 
  80462d:	8b 00                	mov    (%rax),%eax
  80462f:	39 c2                	cmp    %eax,%edx
  804631:	0f 94 c0             	sete   %al
  804634:	0f b6 c0             	movzbl %al,%eax
}
  804637:	c9                   	leaveq 
  804638:	c3                   	retq   

0000000000804639 <opencons>:

int
opencons(void)
{
  804639:	55                   	push   %rbp
  80463a:	48 89 e5             	mov    %rsp,%rbp
  80463d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804641:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804645:	48 89 c7             	mov    %rax,%rdi
  804648:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80464f:	00 00 00 
  804652:	ff d0                	callq  *%rax
  804654:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804657:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80465b:	79 05                	jns    804662 <opencons+0x29>
		return r;
  80465d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804660:	eb 5b                	jmp    8046bd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804666:	ba 07 04 00 00       	mov    $0x407,%edx
  80466b:	48 89 c6             	mov    %rax,%rsi
  80466e:	bf 00 00 00 00       	mov    $0x0,%edi
  804673:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  80467a:	00 00 00 
  80467d:	ff d0                	callq  *%rax
  80467f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804682:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804686:	79 05                	jns    80468d <opencons+0x54>
		return r;
  804688:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468b:	eb 30                	jmp    8046bd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80468d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804691:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804698:	00 00 00 
  80469b:	8b 12                	mov    (%rdx),%edx
  80469d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80469f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8046aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ae:	48 89 c7             	mov    %rax,%rdi
  8046b1:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  8046b8:	00 00 00 
  8046bb:	ff d0                	callq  *%rax
}
  8046bd:	c9                   	leaveq 
  8046be:	c3                   	retq   

00000000008046bf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046bf:	55                   	push   %rbp
  8046c0:	48 89 e5             	mov    %rsp,%rbp
  8046c3:	48 83 ec 30          	sub    $0x30,%rsp
  8046c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046d8:	75 07                	jne    8046e1 <devcons_read+0x22>
		return 0;
  8046da:	b8 00 00 00 00       	mov    $0x0,%eax
  8046df:	eb 4b                	jmp    80472c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8046e1:	eb 0c                	jmp    8046ef <devcons_read+0x30>
		sys_yield();
  8046e3:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8046ea:	00 00 00 
  8046ed:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8046ef:	48 b8 e4 22 80 00 00 	movabs $0x8022e4,%rax
  8046f6:	00 00 00 
  8046f9:	ff d0                	callq  *%rax
  8046fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804702:	74 df                	je     8046e3 <devcons_read+0x24>
	if (c < 0)
  804704:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804708:	79 05                	jns    80470f <devcons_read+0x50>
		return c;
  80470a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80470d:	eb 1d                	jmp    80472c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80470f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804713:	75 07                	jne    80471c <devcons_read+0x5d>
		return 0;
  804715:	b8 00 00 00 00       	mov    $0x0,%eax
  80471a:	eb 10                	jmp    80472c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80471c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80471f:	89 c2                	mov    %eax,%edx
  804721:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804725:	88 10                	mov    %dl,(%rax)
	return 1;
  804727:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80472c:	c9                   	leaveq 
  80472d:	c3                   	retq   

000000000080472e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80472e:	55                   	push   %rbp
  80472f:	48 89 e5             	mov    %rsp,%rbp
  804732:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804739:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804740:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804747:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80474e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804755:	eb 76                	jmp    8047cd <devcons_write+0x9f>
		m = n - tot;
  804757:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80475e:	89 c2                	mov    %eax,%edx
  804760:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804763:	29 c2                	sub    %eax,%edx
  804765:	89 d0                	mov    %edx,%eax
  804767:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80476a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80476d:	83 f8 7f             	cmp    $0x7f,%eax
  804770:	76 07                	jbe    804779 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804772:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804779:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80477c:	48 63 d0             	movslq %eax,%rdx
  80477f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804782:	48 63 c8             	movslq %eax,%rcx
  804785:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80478c:	48 01 c1             	add    %rax,%rcx
  80478f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804796:	48 89 ce             	mov    %rcx,%rsi
  804799:	48 89 c7             	mov    %rax,%rdi
  80479c:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  8047a3:	00 00 00 
  8047a6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8047a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047ab:	48 63 d0             	movslq %eax,%rdx
  8047ae:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047b5:	48 89 d6             	mov    %rdx,%rsi
  8047b8:	48 89 c7             	mov    %rax,%rdi
  8047bb:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  8047c2:	00 00 00 
  8047c5:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8047c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047ca:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047d0:	48 98                	cltq   
  8047d2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047d9:	0f 82 78 ff ff ff    	jb     804757 <devcons_write+0x29>
	}
	return tot;
  8047df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047e2:	c9                   	leaveq 
  8047e3:	c3                   	retq   

00000000008047e4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047e4:	55                   	push   %rbp
  8047e5:	48 89 e5             	mov    %rsp,%rbp
  8047e8:	48 83 ec 08          	sub    $0x8,%rsp
  8047ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047f5:	c9                   	leaveq 
  8047f6:	c3                   	retq   

00000000008047f7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047f7:	55                   	push   %rbp
  8047f8:	48 89 e5             	mov    %rsp,%rbp
  8047fb:	48 83 ec 10          	sub    $0x10,%rsp
  8047ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804803:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804807:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80480b:	48 be 4c 54 80 00 00 	movabs $0x80544c,%rsi
  804812:	00 00 00 
  804815:	48 89 c7             	mov    %rax,%rdi
  804818:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  80481f:	00 00 00 
  804822:	ff d0                	callq  *%rax
	return 0;
  804824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804829:	c9                   	leaveq 
  80482a:	c3                   	retq   

000000000080482b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80482b:	55                   	push   %rbp
  80482c:	48 89 e5             	mov    %rsp,%rbp
  80482f:	48 83 ec 18          	sub    $0x18,%rsp
  804833:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80483b:	48 c1 e8 15          	shr    $0x15,%rax
  80483f:	48 89 c2             	mov    %rax,%rdx
  804842:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804849:	01 00 00 
  80484c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804850:	83 e0 01             	and    $0x1,%eax
  804853:	48 85 c0             	test   %rax,%rax
  804856:	75 07                	jne    80485f <pageref+0x34>
		return 0;
  804858:	b8 00 00 00 00       	mov    $0x0,%eax
  80485d:	eb 53                	jmp    8048b2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80485f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804863:	48 c1 e8 0c          	shr    $0xc,%rax
  804867:	48 89 c2             	mov    %rax,%rdx
  80486a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804871:	01 00 00 
  804874:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804878:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80487c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804880:	83 e0 01             	and    $0x1,%eax
  804883:	48 85 c0             	test   %rax,%rax
  804886:	75 07                	jne    80488f <pageref+0x64>
		return 0;
  804888:	b8 00 00 00 00       	mov    $0x0,%eax
  80488d:	eb 23                	jmp    8048b2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80488f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804893:	48 c1 e8 0c          	shr    $0xc,%rax
  804897:	48 89 c2             	mov    %rax,%rdx
  80489a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048a1:	00 00 00 
  8048a4:	48 c1 e2 04          	shl    $0x4,%rdx
  8048a8:	48 01 d0             	add    %rdx,%rax
  8048ab:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8048af:	0f b7 c0             	movzwl %ax,%eax
}
  8048b2:	c9                   	leaveq 
  8048b3:	c3                   	retq   
