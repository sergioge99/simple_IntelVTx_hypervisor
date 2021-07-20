
vmm/guest/obj/net/testinput:     formato del fichero elf64-x86-64


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
  80003c:	e8 2b 08 00 00       	callq  80086c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    static void
announce(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
    // with ARP requests.  Ideally, we would use gratuitous ARP
    // for this, but QEMU's ARP implementation is dumb and only
    // listens for very specific ARP requests, such as requests
    // for the gateway IP.

    uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004b:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  80004f:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800053:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800057:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005b:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  80005f:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
    uint32_t myip = inet_addr(IP);
  800063:	48 bf 80 4a 80 00 00 	movabs $0x804a80,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 a5 45 80 00 00 	movabs $0x8045a5,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007c:	48 bf 8a 4a 80 00 00 	movabs $0x804a8a,%rdi
  800083:	00 00 00 
  800086:	48 b8 a5 45 80 00 00 	movabs $0x8045a5,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	89 45 d8             	mov    %eax,-0x28(%rbp)
    int r;

    if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800095:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80009c:	00 00 00 
  80009f:	48 8b 00             	mov    (%rax),%rax
  8000a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a7:	48 89 c6             	mov    %rax,%rsi
  8000aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8000af:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c2:	79 30                	jns    8000f4 <announce+0xb1>
        panic("sys_page_map: %e", r);
  8000c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c7:	89 c1                	mov    %eax,%ecx
  8000c9:	48 ba 93 4a 80 00 00 	movabs $0x804a93,%rdx
  8000d0:	00 00 00 
  8000d3:	be 19 00 00 00       	mov    $0x19,%esi
  8000d8:	48 bf a4 4a 80 00 00 	movabs $0x804aa4,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  8000ee:	00 00 00 
  8000f1:	41 ff d0             	callq  *%r8

    struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000fb:	00 00 00 
  8000fe:	48 8b 00             	mov    (%rax),%rax
  800101:	48 83 c0 04          	add    $0x4,%rax
  800105:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    pkt->jp_len = sizeof(*arp);
  800109:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800110:	00 00 00 
  800113:	48 8b 00             	mov    (%rax),%rax
  800116:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

    memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800120:	ba 06 00 00 00       	mov    $0x6,%edx
  800125:	be ff 00 00 00       	mov    $0xff,%esi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
    memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013d:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800141:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800145:	ba 06 00 00 00       	mov    $0x6,%edx
  80014a:	48 89 c6             	mov    %rax,%rsi
  80014d:	48 89 cf             	mov    %rcx,%rdi
  800150:	48 b8 fd 1a 80 00 00 	movabs $0x801afd,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
    arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015c:	bf 06 08 00 00       	mov    $0x806,%edi
  800161:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	89 c2                	mov    %eax,%edx
  80016f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800173:	66 89 50 0c          	mov    %dx,0xc(%rax)
    arp->hwtype = htons(1); // Ethernet
  800177:	bf 01 00 00 00       	mov    $0x1,%edi
  80017c:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax
  800188:	89 c2                	mov    %eax,%edx
  80018a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018e:	66 89 50 0e          	mov    %dx,0xe(%rax)
    arp->proto = htons(ETHTYPE_IP);
  800192:	bf 00 08 00 00       	mov    $0x800,%edi
  800197:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax
  8001a3:	89 c2                	mov    %eax,%edx
  8001a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a9:	66 89 50 10          	mov    %dx,0x10(%rax)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ad:	bf 04 06 00 00       	mov    $0x604,%edi
  8001b2:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	callq  *%rax
  8001be:	89 c2                	mov    %eax,%edx
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	66 89 50 12          	mov    %dx,0x12(%rax)
    arp->opcode = htons(ARP_REQUEST);
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8001cd:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001df:	66 89 50 14          	mov    %dx,0x14(%rax)
    memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e7:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001eb:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001ef:	ba 06 00 00 00       	mov    $0x6,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	48 89 cf             	mov    %rcx,%rdi
  8001fa:	48 b8 fd 1a 80 00 00 	movabs $0x801afd,%rax
  800201:	00 00 00 
  800204:	ff d0                	callq  *%rax
    memcpy(arp->sipaddr.addrw, &myip, 4);
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  80020e:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800212:	ba 04 00 00 00       	mov    $0x4,%edx
  800217:	48 89 c6             	mov    %rax,%rsi
  80021a:	48 89 cf             	mov    %rcx,%rdi
  80021d:	48 b8 fd 1a 80 00 00 	movabs $0x801afd,%rax
  800224:	00 00 00 
  800227:	ff d0                	callq  *%rax
    memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022d:	48 83 c0 20          	add    $0x20,%rax
  800231:	ba 06 00 00 00       	mov    $0x6,%edx
  800236:	be 00 00 00 00       	mov    $0x0,%esi
  80023b:	48 89 c7             	mov    %rax,%rdi
  80023e:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  800245:	00 00 00 
  800248:	ff d0                	callq  *%rax
    memcpy(arp->dipaddr.addrw, &gwip, 4);
  80024a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024e:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800252:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800256:	ba 04 00 00 00       	mov    $0x4,%edx
  80025b:	48 89 c6             	mov    %rax,%rsi
  80025e:	48 89 cf             	mov    %rcx,%rdi
  800261:	48 b8 fd 1a 80 00 00 	movabs $0x801afd,%rax
  800268:	00 00 00 
  80026b:	ff d0                	callq  *%rax

    ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80026d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800274:	00 00 00 
  800277:	48 8b 10             	mov    (%rax),%rdx
  80027a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800281:	00 00 00 
  800284:	8b 00                	mov    (%rax),%eax
  800286:	b9 07 00 00 00       	mov    $0x7,%ecx
  80028b:	be 0b 00 00 00       	mov    $0xb,%esi
  800290:	89 c7                	mov    %eax,%edi
  800292:	48 b8 75 24 80 00 00 	movabs $0x802475,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
    sys_page_unmap(0, pkt);
  80029e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002a5:	00 00 00 
  8002a8:	48 8b 00             	mov    (%rax),%rax
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
}
  8002bf:	c9                   	leaveq 
  8002c0:	c3                   	retq   

00000000008002c1 <hexdump>:

    static void
hexdump(const char *prefix, const void *data, int len)
{
  8002c1:	55                   	push   %rbp
  8002c2:	48 89 e5             	mov    %rsp,%rbp
  8002c5:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  8002cc:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  8002d0:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  8002d4:	89 95 7c ff ff ff    	mov    %edx,-0x84(%rbp)
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
  8002da:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8002de:	48 83 c0 50          	add    $0x50,%rax
  8002e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    char *out = NULL;
  8002e6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8002ed:	00 
    for (i = 0; i < len; i++) {
  8002ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8002f5:	e9 41 01 00 00       	jmpq   80043b <hexdump+0x17a>
        if (i % 16 == 0)
  8002fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002fd:	83 e0 0f             	and    $0xf,%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	75 4d                	jne    800351 <hexdump+0x90>
            out = buf + snprintf(buf, end - buf,
  800304:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800308:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  80030c:	48 29 c2             	sub    %rax,%rdx
  80030f:	48 89 d0             	mov    %rdx,%rax
  800312:	89 c6                	mov    %eax,%esi
  800314:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800317:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  80031b:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  80031f:	41 89 c8             	mov    %ecx,%r8d
  800322:	48 89 d1             	mov    %rdx,%rcx
  800325:	48 ba b4 4a 80 00 00 	movabs $0x804ab4,%rdx
  80032c:	00 00 00 
  80032f:	48 89 c7             	mov    %rax,%rdi
  800332:	b8 00 00 00 00       	mov    $0x0,%eax
  800337:	49 b9 75 15 80 00 00 	movabs $0x801575,%r9
  80033e:	00 00 00 
  800341:	41 ff d1             	callq  *%r9
  800344:	48 98                	cltq   
  800346:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  80034a:	48 01 d0             	add    %rdx,%rax
  80034d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                    "%s%04x   ", prefix, i);
        out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800354:	48 63 d0             	movslq %eax,%rdx
  800357:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  80035b:	48 01 d0             	add    %rdx,%rax
  80035e:	0f b6 00             	movzbl (%rax),%eax
  800361:	0f b6 d0             	movzbl %al,%edx
  800364:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800368:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036c:	48 29 c1             	sub    %rax,%rcx
  80036f:	48 89 c8             	mov    %rcx,%rax
  800372:	89 c6                	mov    %eax,%esi
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	89 d1                	mov    %edx,%ecx
  80037a:	48 ba be 4a 80 00 00 	movabs $0x804abe,%rdx
  800381:	00 00 00 
  800384:	48 89 c7             	mov    %rax,%rdi
  800387:	b8 00 00 00 00       	mov    $0x0,%eax
  80038c:	49 b8 75 15 80 00 00 	movabs $0x801575,%r8
  800393:	00 00 00 
  800396:	41 ff d0             	callq  *%r8
  800399:	48 98                	cltq   
  80039b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        if (i % 16 == 15 || i == len - 1)
  80039f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a2:	99                   	cltd   
  8003a3:	c1 ea 1c             	shr    $0x1c,%edx
  8003a6:	01 d0                	add    %edx,%eax
  8003a8:	83 e0 0f             	and    $0xf,%eax
  8003ab:	29 d0                	sub    %edx,%eax
  8003ad:	83 f8 0f             	cmp    $0xf,%eax
  8003b0:	74 0e                	je     8003c0 <hexdump+0xff>
  8003b2:	8b 85 7c ff ff ff    	mov    -0x84(%rbp),%eax
  8003b8:	83 e8 01             	sub    $0x1,%eax
  8003bb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8003be:	75 33                	jne    8003f3 <hexdump+0x132>
            cprintf("%.*s\n", out - buf, buf);
  8003c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c4:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003c8:	48 89 d1             	mov    %rdx,%rcx
  8003cb:	48 29 c1             	sub    %rax,%rcx
  8003ce:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003d2:	48 89 c2             	mov    %rax,%rdx
  8003d5:	48 89 ce             	mov    %rcx,%rsi
  8003d8:	48 bf c3 4a 80 00 00 	movabs $0x804ac3,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 b9 28 0b 80 00 00 	movabs $0x800b28,%rcx
  8003ee:	00 00 00 
  8003f1:	ff d1                	callq  *%rcx
        if (i % 2 == 1)
  8003f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f6:	99                   	cltd   
  8003f7:	c1 ea 1f             	shr    $0x1f,%edx
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	83 e0 01             	and    $0x1,%eax
  8003ff:	29 d0                	sub    %edx,%eax
  800401:	83 f8 01             	cmp    $0x1,%eax
  800404:	75 0f                	jne    800415 <hexdump+0x154>
            *(out++) = ' ';
  800406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80040e:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800412:	c6 00 20             	movb   $0x20,(%rax)
        if (i % 16 == 7)
  800415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800418:	99                   	cltd   
  800419:	c1 ea 1c             	shr    $0x1c,%edx
  80041c:	01 d0                	add    %edx,%eax
  80041e:	83 e0 0f             	and    $0xf,%eax
  800421:	29 d0                	sub    %edx,%eax
  800423:	83 f8 07             	cmp    $0x7,%eax
  800426:	75 0f                	jne    800437 <hexdump+0x176>
            *(out++) = ' ';
  800428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800430:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800434:	c6 00 20             	movb   $0x20,(%rax)
    for (i = 0; i < len; i++) {
  800437:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80043b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043e:	3b 85 7c ff ff ff    	cmp    -0x84(%rbp),%eax
  800444:	0f 8c b0 fe ff ff    	jl     8002fa <hexdump+0x39>
    }
}
  80044a:	c9                   	leaveq 
  80044b:	c3                   	retq   

000000000080044c <umain>:

    void
umain(int argc, char **argv)
{
  80044c:	55                   	push   %rbp
  80044d:	48 89 e5             	mov    %rsp,%rbp
  800450:	48 83 ec 30          	sub    $0x30,%rsp
  800454:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800457:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  80045b:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
  800467:	89 45 f8             	mov    %eax,-0x8(%rbp)
    int i, r, first = 1;
  80046a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

    binaryname = "testinput";
  800471:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800478:	00 00 00 
  80047b:	48 be c9 4a 80 00 00 	movabs $0x804ac9,%rsi
  800482:	00 00 00 
  800485:	48 89 30             	mov    %rsi,(%rax)

    output_envid = fork();
  800488:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
  800494:	89 c2                	mov    %eax,%edx
  800496:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80049d:	00 00 00 
  8004a0:	89 10                	mov    %edx,(%rax)
    if (output_envid < 0)
  8004a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004a9:	00 00 00 
  8004ac:	8b 00                	mov    (%rax),%eax
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	79 2a                	jns    8004dc <umain+0x90>
        panic("error forking");
  8004b2:	48 ba d3 4a 80 00 00 	movabs $0x804ad3,%rdx
  8004b9:	00 00 00 
  8004bc:	be 4d 00 00 00       	mov    $0x4d,%esi
  8004c1:	48 bf a4 4a 80 00 00 	movabs $0x804aa4,%rdi
  8004c8:	00 00 00 
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  8004d7:	00 00 00 
  8004da:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8004dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004e3:	00 00 00 
  8004e6:	8b 00                	mov    (%rax),%eax
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	75 16                	jne    800502 <umain+0xb6>
        output(ns_envid);
  8004ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ef:	89 c7                	mov    %eax,%edi
  8004f1:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  8004f8:	00 00 00 
  8004fb:	ff d0                	callq  *%rax
        return;
  8004fd:	e9 fd 01 00 00       	jmpq   8006ff <umain+0x2b3>
    }

    input_envid = fork();
  800502:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  800509:	00 00 00 
  80050c:	ff d0                	callq  *%rax
  80050e:	89 c2                	mov    %eax,%edx
  800510:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800517:	00 00 00 
  80051a:	89 10                	mov    %edx,(%rax)
    if (input_envid < 0)
  80051c:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800523:	00 00 00 
  800526:	8b 00                	mov    (%rax),%eax
  800528:	85 c0                	test   %eax,%eax
  80052a:	79 2a                	jns    800556 <umain+0x10a>
        panic("error forking");
  80052c:	48 ba d3 4a 80 00 00 	movabs $0x804ad3,%rdx
  800533:	00 00 00 
  800536:	be 55 00 00 00       	mov    $0x55,%esi
  80053b:	48 bf a4 4a 80 00 00 	movabs $0x804aa4,%rdi
  800542:	00 00 00 
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  800551:	00 00 00 
  800554:	ff d1                	callq  *%rcx
    else if (input_envid == 0) {
  800556:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80055d:	00 00 00 
  800560:	8b 00                	mov    (%rax),%eax
  800562:	85 c0                	test   %eax,%eax
  800564:	75 16                	jne    80057c <umain+0x130>
        input(ns_envid);
  800566:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800569:	89 c7                	mov    %eax,%edi
  80056b:	48 b8 24 08 80 00 00 	movabs $0x800824,%rax
  800572:	00 00 00 
  800575:	ff d0                	callq  *%rax
        return;
  800577:	e9 83 01 00 00       	jmpq   8006ff <umain+0x2b3>
    }

    cprintf("Sending ARP announcement...\n");
  80057c:	48 bf e1 4a 80 00 00 	movabs $0x804ae1,%rdi
  800583:	00 00 00 
  800586:	b8 00 00 00 00       	mov    $0x0,%eax
  80058b:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  800592:	00 00 00 
  800595:	ff d2                	callq  *%rdx
    announce();
  800597:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80059e:	00 00 00 
  8005a1:	ff d0                	callq  *%rax

    while (1) {
        envid_t whom;
        int perm;

        int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8005a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8005aa:	00 00 00 
  8005ad:	48 8b 08             	mov    (%rax),%rcx
  8005b0:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
  8005b4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8005b8:	48 89 ce             	mov    %rcx,%rsi
  8005bb:	48 89 c7             	mov    %rax,%rdi
  8005be:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8005c5:	00 00 00 
  8005c8:	ff d0                	callq  *%rax
  8005ca:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (req < 0)
  8005cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8005d1:	79 30                	jns    800603 <umain+0x1b7>
            panic("ipc_recv: %e", req);
  8005d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005d6:	89 c1                	mov    %eax,%ecx
  8005d8:	48 ba fe 4a 80 00 00 	movabs $0x804afe,%rdx
  8005df:	00 00 00 
  8005e2:	be 64 00 00 00       	mov    $0x64,%esi
  8005e7:	48 bf a4 4a 80 00 00 	movabs $0x804aa4,%rdi
  8005ee:	00 00 00 
  8005f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f6:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  8005fd:	00 00 00 
  800600:	41 ff d0             	callq  *%r8
        if (whom != input_envid)
  800603:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800606:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80060d:	00 00 00 
  800610:	8b 00                	mov    (%rax),%eax
  800612:	39 c2                	cmp    %eax,%edx
  800614:	74 30                	je     800646 <umain+0x1fa>
            panic("IPC from unexpected environment %08x", whom);
  800616:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800619:	89 c1                	mov    %eax,%ecx
  80061b:	48 ba 10 4b 80 00 00 	movabs $0x804b10,%rdx
  800622:	00 00 00 
  800625:	be 66 00 00 00       	mov    $0x66,%esi
  80062a:	48 bf a4 4a 80 00 00 	movabs $0x804aa4,%rdi
  800631:	00 00 00 
  800634:	b8 00 00 00 00       	mov    $0x0,%eax
  800639:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  800640:	00 00 00 
  800643:	41 ff d0             	callq  *%r8
        if (req != NSREQ_INPUT)
  800646:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80064a:	74 30                	je     80067c <umain+0x230>
            panic("Unexpected IPC %d", req);
  80064c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80064f:	89 c1                	mov    %eax,%ecx
  800651:	48 ba 35 4b 80 00 00 	movabs $0x804b35,%rdx
  800658:	00 00 00 
  80065b:	be 68 00 00 00       	mov    $0x68,%esi
  800660:	48 bf a4 4a 80 00 00 	movabs $0x804aa4,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  800676:	00 00 00 
  800679:	41 ff d0             	callq  *%r8

        hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80067c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	8b 00                	mov    (%rax),%eax
  80068b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800692:	00 00 00 
  800695:	48 8b 12             	mov    (%rdx),%rdx
  800698:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  80069c:	89 c2                	mov    %eax,%edx
  80069e:	48 89 ce             	mov    %rcx,%rsi
  8006a1:	48 bf 47 4b 80 00 00 	movabs $0x804b47,%rdi
  8006a8:	00 00 00 
  8006ab:	48 b8 c1 02 80 00 00 	movabs $0x8002c1,%rax
  8006b2:	00 00 00 
  8006b5:	ff d0                	callq  *%rax
        cprintf("\n");
  8006b7:	48 bf 4f 4b 80 00 00 	movabs $0x804b4f,%rdi
  8006be:	00 00 00 
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  8006cd:	00 00 00 
  8006d0:	ff d2                	callq  *%rdx

        // Only indicate that we're waiting for packets once
        // we've received the ARP reply
        if (first)
  8006d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006d6:	74 1b                	je     8006f3 <umain+0x2a7>
            cprintf("Waiting for packets...\n");
  8006d8:	48 bf 51 4b 80 00 00 	movabs $0x804b51,%rdi
  8006df:	00 00 00 
  8006e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e7:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  8006ee:	00 00 00 
  8006f1:	ff d2                	callq  *%rdx
        first = 0;
  8006f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    }
  8006fa:	e9 a4 fe ff ff       	jmpq   8005a3 <umain+0x157>
}
  8006ff:	c9                   	leaveq 
  800700:	c3                   	retq   

0000000000800701 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800701:	55                   	push   %rbp
  800702:	48 89 e5             	mov    %rsp,%rbp
  800705:	48 83 ec 20          	sub    $0x20,%rsp
  800709:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80070c:	89 75 e8             	mov    %esi,-0x18(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  80070f:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  800716:	00 00 00 
  800719:	ff d0                	callq  *%rax
  80071b:	89 c2                	mov    %eax,%edx
  80071d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800720:	01 d0                	add    %edx,%eax
  800722:	89 45 fc             	mov    %eax,-0x4(%rbp)

    binaryname = "ns_timer";
  800725:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80072c:	00 00 00 
  80072f:	48 b9 70 4b 80 00 00 	movabs $0x804b70,%rcx
  800736:	00 00 00 
  800739:	48 89 08             	mov    %rcx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  80073c:	eb 0c                	jmp    80074a <timer+0x49>
            sys_yield();
  80073e:	48 b8 b3 1f 80 00 00 	movabs $0x801fb3,%rax
  800745:	00 00 00 
  800748:	ff d0                	callq  *%rax
        while((r = sys_time_msec()) < stop && r >= 0) {
  80074a:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  800751:	00 00 00 
  800754:	ff d0                	callq  *%rax
  800756:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800759:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80075c:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80075f:	73 06                	jae    800767 <timer+0x66>
  800761:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800765:	79 d7                	jns    80073e <timer+0x3d>
        }
        if (r < 0)
  800767:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80076b:	79 30                	jns    80079d <timer+0x9c>
            panic("sys_time_msec: %e", r);
  80076d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800770:	89 c1                	mov    %eax,%ecx
  800772:	48 ba 79 4b 80 00 00 	movabs $0x804b79,%rdx
  800779:	00 00 00 
  80077c:	be 0f 00 00 00       	mov    $0xf,%esi
  800781:	48 bf 8b 4b 80 00 00 	movabs $0x804b8b,%rdi
  800788:	00 00 00 
  80078b:	b8 00 00 00 00       	mov    $0x0,%eax
  800790:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  800797:	00 00 00 
  80079a:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  80079d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007aa:	be 0c 00 00 00       	mov    $0xc,%esi
  8007af:	89 c7                	mov    %eax,%edi
  8007b1:	48 b8 75 24 80 00 00 	movabs $0x802475,%rax
  8007b8:	00 00 00 
  8007bb:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007bd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	be 00 00 00 00       	mov    $0x0,%esi
  8007cb:	48 89 c7             	mov    %rax,%rdi
  8007ce:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8007d5:	00 00 00 
  8007d8:	ff d0                	callq  *%rax
  8007da:	89 45 f4             	mov    %eax,-0xc(%rbp)

            if (whom != ns_envid) {
  8007dd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8007e0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007e3:	39 c2                	cmp    %eax,%edx
  8007e5:	74 22                	je     800809 <timer+0x108>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007ea:	89 c6                	mov    %eax,%esi
  8007ec:	48 bf 98 4b 80 00 00 	movabs $0x804b98,%rdi
  8007f3:	00 00 00 
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  800802:	00 00 00 
  800805:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  800807:	eb b4                	jmp    8007bd <timer+0xbc>
            stop = sys_time_msec() + to;
  800809:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  800810:	00 00 00 
  800813:	ff d0                	callq  *%rax
  800815:	89 c2                	mov    %eax,%edx
  800817:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80081a:	01 d0                	add    %edx,%eax
  80081c:	89 45 fc             	mov    %eax,-0x4(%rbp)
    }
  80081f:	e9 18 ff ff ff       	jmpq   80073c <timer+0x3b>

0000000000800824 <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  800824:	55                   	push   %rbp
  800825:	48 89 e5             	mov    %rsp,%rbp
  800828:	48 83 ec 08          	sub    $0x8,%rsp
  80082c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_input";
  80082f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800836:	00 00 00 
  800839:	48 ba d3 4b 80 00 00 	movabs $0x804bd3,%rdx
  800840:	00 00 00 
  800843:	48 89 10             	mov    %rdx,(%rax)
    // 	- read a packet from the device driver
    //	- send it to the network server
    // Hint: When you IPC a page to the network server, it will be
    // reading from it for a while, so don't immediately receive
    // another packet in to the same physical page.
}
  800846:	c9                   	leaveq 
  800847:	c3                   	retq   

0000000000800848 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800848:	55                   	push   %rbp
  800849:	48 89 e5             	mov    %rsp,%rbp
  80084c:	48 83 ec 08          	sub    $0x8,%rsp
  800850:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_output";
  800853:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80085a:	00 00 00 
  80085d:	48 ba dc 4b 80 00 00 	movabs $0x804bdc,%rdx
  800864:	00 00 00 
  800867:	48 89 10             	mov    %rdx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
}
  80086a:	c9                   	leaveq 
  80086b:	c3                   	retq   

000000000080086c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80086c:	55                   	push   %rbp
  80086d:	48 89 e5             	mov    %rsp,%rbp
  800870:	48 83 ec 10          	sub    $0x10,%rsp
  800874:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800877:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80087b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800882:	00 00 00 
  800885:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80088c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800890:	7e 14                	jle    8008a6 <libmain+0x3a>
		binaryname = argv[0];
  800892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800896:	48 8b 10             	mov    (%rax),%rdx
  800899:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008a0:	00 00 00 
  8008a3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ad:	48 89 d6             	mov    %rdx,%rsi
  8008b0:	89 c7                	mov    %eax,%edi
  8008b2:	48 b8 4c 04 80 00 00 	movabs $0x80044c,%rax
  8008b9:	00 00 00 
  8008bc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008be:	48 b8 cc 08 80 00 00 	movabs $0x8008cc,%rax
  8008c5:	00 00 00 
  8008c8:	ff d0                	callq  *%rax
}
  8008ca:	c9                   	leaveq 
  8008cb:	c3                   	retq   

00000000008008cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008cc:	55                   	push   %rbp
  8008cd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008d0:	48 b8 b7 29 80 00 00 	movabs $0x8029b7,%rax
  8008d7:	00 00 00 
  8008da:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8008e1:	48 b8 31 1f 80 00 00 	movabs $0x801f31,%rax
  8008e8:	00 00 00 
  8008eb:	ff d0                	callq  *%rax
}
  8008ed:	5d                   	pop    %rbp
  8008ee:	c3                   	retq   

00000000008008ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008ef:	55                   	push   %rbp
  8008f0:	48 89 e5             	mov    %rsp,%rbp
  8008f3:	53                   	push   %rbx
  8008f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800902:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800908:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80090f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800916:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80091d:	84 c0                	test   %al,%al
  80091f:	74 23                	je     800944 <_panic+0x55>
  800921:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800928:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80092c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800930:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800934:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800938:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80093c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800940:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800944:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80094b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800952:	00 00 00 
  800955:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80095c:	00 00 00 
  80095f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800963:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80096a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800971:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800978:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80097f:	00 00 00 
  800982:	48 8b 18             	mov    (%rax),%rbx
  800985:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  80098c:	00 00 00 
  80098f:	ff d0                	callq  *%rax
  800991:	89 c6                	mov    %eax,%esi
  800993:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800999:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8009a0:	41 89 d0             	mov    %edx,%r8d
  8009a3:	48 89 c1             	mov    %rax,%rcx
  8009a6:	48 89 da             	mov    %rbx,%rdx
  8009a9:	48 bf f0 4b 80 00 00 	movabs $0x804bf0,%rdi
  8009b0:	00 00 00 
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b8:	49 b9 28 0b 80 00 00 	movabs $0x800b28,%r9
  8009bf:	00 00 00 
  8009c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009d3:	48 89 d6             	mov    %rdx,%rsi
  8009d6:	48 89 c7             	mov    %rax,%rdi
  8009d9:	48 b8 7c 0a 80 00 00 	movabs $0x800a7c,%rax
  8009e0:	00 00 00 
  8009e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8009e5:	48 bf 13 4c 80 00 00 	movabs $0x804c13,%rdi
  8009ec:	00 00 00 
  8009ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f4:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  8009fb:	00 00 00 
  8009fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a00:	cc                   	int3   
  800a01:	eb fd                	jmp    800a00 <_panic+0x111>

0000000000800a03 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800a03:	55                   	push   %rbp
  800a04:	48 89 e5             	mov    %rsp,%rbp
  800a07:	48 83 ec 10          	sub    $0x10,%rsp
  800a0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a16:	8b 00                	mov    (%rax),%eax
  800a18:	8d 48 01             	lea    0x1(%rax),%ecx
  800a1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a1f:	89 0a                	mov    %ecx,(%rdx)
  800a21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a24:	89 d1                	mov    %edx,%ecx
  800a26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a2a:	48 98                	cltq   
  800a2c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a34:	8b 00                	mov    (%rax),%eax
  800a36:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a3b:	75 2c                	jne    800a69 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a41:	8b 00                	mov    (%rax),%eax
  800a43:	48 98                	cltq   
  800a45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a49:	48 83 c2 08          	add    $0x8,%rdx
  800a4d:	48 89 c6             	mov    %rax,%rsi
  800a50:	48 89 d7             	mov    %rdx,%rdi
  800a53:	48 b8 a9 1e 80 00 00 	movabs $0x801ea9,%rax
  800a5a:	00 00 00 
  800a5d:	ff d0                	callq  *%rax
        b->idx = 0;
  800a5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a63:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6d:	8b 40 04             	mov    0x4(%rax),%eax
  800a70:	8d 50 01             	lea    0x1(%rax),%edx
  800a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a77:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a7a:	c9                   	leaveq 
  800a7b:	c3                   	retq   

0000000000800a7c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a7c:	55                   	push   %rbp
  800a7d:	48 89 e5             	mov    %rsp,%rbp
  800a80:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a87:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a8e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a95:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a9c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800aa3:	48 8b 0a             	mov    (%rdx),%rcx
  800aa6:	48 89 08             	mov    %rcx,(%rax)
  800aa9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800aad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ab1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ab5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ab9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ac0:	00 00 00 
    b.cnt = 0;
  800ac3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800aca:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800acd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ad4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800adb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ae2:	48 89 c6             	mov    %rax,%rsi
  800ae5:	48 bf 03 0a 80 00 00 	movabs $0x800a03,%rdi
  800aec:	00 00 00 
  800aef:	48 b8 c7 0e 80 00 00 	movabs $0x800ec7,%rax
  800af6:	00 00 00 
  800af9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800afb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b01:	48 98                	cltq   
  800b03:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b0a:	48 83 c2 08          	add    $0x8,%rdx
  800b0e:	48 89 c6             	mov    %rax,%rsi
  800b11:	48 89 d7             	mov    %rdx,%rdi
  800b14:	48 b8 a9 1e 80 00 00 	movabs $0x801ea9,%rax
  800b1b:	00 00 00 
  800b1e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b26:	c9                   	leaveq 
  800b27:	c3                   	retq   

0000000000800b28 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b28:	55                   	push   %rbp
  800b29:	48 89 e5             	mov    %rsp,%rbp
  800b2c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b33:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b3a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b56:	84 c0                	test   %al,%al
  800b58:	74 20                	je     800b7a <cprintf+0x52>
  800b5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b7a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b81:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b88:	00 00 00 
  800b8b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b92:	00 00 00 
  800b95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b99:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ba0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800bae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800bb5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bbc:	48 8b 0a             	mov    (%rdx),%rcx
  800bbf:	48 89 08             	mov    %rcx,(%rax)
  800bc2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bc6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bd2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bd9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800be0:	48 89 d6             	mov    %rdx,%rsi
  800be3:	48 89 c7             	mov    %rax,%rdi
  800be6:	48 b8 7c 0a 80 00 00 	movabs $0x800a7c,%rax
  800bed:	00 00 00 
  800bf0:	ff d0                	callq  *%rax
  800bf2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800bf8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bfe:	c9                   	leaveq 
  800bff:	c3                   	retq   

0000000000800c00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c00:	55                   	push   %rbp
  800c01:	48 89 e5             	mov    %rsp,%rbp
  800c04:	48 83 ec 30          	sub    $0x30,%rsp
  800c08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c10:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800c14:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800c17:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800c1b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c1f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c22:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800c26:	77 42                	ja     800c6a <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c28:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c2b:	8d 78 ff             	lea    -0x1(%rax),%edi
  800c2e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c35:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3a:	48 f7 f6             	div    %rsi
  800c3d:	49 89 c2             	mov    %rax,%r10
  800c40:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800c43:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c46:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c4e:	41 89 c9             	mov    %ecx,%r9d
  800c51:	41 89 f8             	mov    %edi,%r8d
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	4c 89 d2             	mov    %r10,%rdx
  800c59:	48 89 c7             	mov    %rax,%rdi
  800c5c:	48 b8 00 0c 80 00 00 	movabs $0x800c00,%rax
  800c63:	00 00 00 
  800c66:	ff d0                	callq  *%rax
  800c68:	eb 1e                	jmp    800c88 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c6a:	eb 12                	jmp    800c7e <printnum+0x7e>
			putch(padc, putdat);
  800c6c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c70:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c77:	48 89 ce             	mov    %rcx,%rsi
  800c7a:	89 d7                	mov    %edx,%edi
  800c7c:	ff d0                	callq  *%rax
		while (--width > 0)
  800c7e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800c82:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800c86:	7f e4                	jg     800c6c <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c88:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c94:	48 f7 f1             	div    %rcx
  800c97:	48 b8 30 4e 80 00 00 	movabs $0x804e30,%rax
  800c9e:	00 00 00 
  800ca1:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800ca5:	0f be d0             	movsbl %al,%edx
  800ca8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800cb0:	48 89 ce             	mov    %rcx,%rsi
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	ff d0                	callq  *%rax
}
  800cb7:	c9                   	leaveq 
  800cb8:	c3                   	retq   

0000000000800cb9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb9:	55                   	push   %rbp
  800cba:	48 89 e5             	mov    %rsp,%rbp
  800cbd:	48 83 ec 20          	sub    $0x20,%rsp
  800cc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cc5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cc8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ccc:	7e 4f                	jle    800d1d <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd2:	8b 00                	mov    (%rax),%eax
  800cd4:	83 f8 30             	cmp    $0x30,%eax
  800cd7:	73 24                	jae    800cfd <getuint+0x44>
  800cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce5:	8b 00                	mov    (%rax),%eax
  800ce7:	89 c0                	mov    %eax,%eax
  800ce9:	48 01 d0             	add    %rdx,%rax
  800cec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf0:	8b 12                	mov    (%rdx),%edx
  800cf2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cf5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf9:	89 0a                	mov    %ecx,(%rdx)
  800cfb:	eb 14                	jmp    800d11 <getuint+0x58>
  800cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d01:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d05:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d11:	48 8b 00             	mov    (%rax),%rax
  800d14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d18:	e9 9d 00 00 00       	jmpq   800dba <getuint+0x101>
	else if (lflag)
  800d1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d21:	74 4c                	je     800d6f <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800d23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d27:	8b 00                	mov    (%rax),%eax
  800d29:	83 f8 30             	cmp    $0x30,%eax
  800d2c:	73 24                	jae    800d52 <getuint+0x99>
  800d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d32:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3a:	8b 00                	mov    (%rax),%eax
  800d3c:	89 c0                	mov    %eax,%eax
  800d3e:	48 01 d0             	add    %rdx,%rax
  800d41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d45:	8b 12                	mov    (%rdx),%edx
  800d47:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4e:	89 0a                	mov    %ecx,(%rdx)
  800d50:	eb 14                	jmp    800d66 <getuint+0xad>
  800d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d56:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d5a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d62:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d66:	48 8b 00             	mov    (%rax),%rax
  800d69:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d6d:	eb 4b                	jmp    800dba <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d73:	8b 00                	mov    (%rax),%eax
  800d75:	83 f8 30             	cmp    $0x30,%eax
  800d78:	73 24                	jae    800d9e <getuint+0xe5>
  800d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d86:	8b 00                	mov    (%rax),%eax
  800d88:	89 c0                	mov    %eax,%eax
  800d8a:	48 01 d0             	add    %rdx,%rax
  800d8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d91:	8b 12                	mov    (%rdx),%edx
  800d93:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9a:	89 0a                	mov    %ecx,(%rdx)
  800d9c:	eb 14                	jmp    800db2 <getuint+0xf9>
  800d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800da6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800daa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800db2:	8b 00                	mov    (%rax),%eax
  800db4:	89 c0                	mov    %eax,%eax
  800db6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 20          	sub    $0x20,%rsp
  800dc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dcc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dcf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dd3:	7e 4f                	jle    800e24 <getint+0x64>
		x=va_arg(*ap, long long);
  800dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd9:	8b 00                	mov    (%rax),%eax
  800ddb:	83 f8 30             	cmp    $0x30,%eax
  800dde:	73 24                	jae    800e04 <getint+0x44>
  800de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dec:	8b 00                	mov    (%rax),%eax
  800dee:	89 c0                	mov    %eax,%eax
  800df0:	48 01 d0             	add    %rdx,%rax
  800df3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df7:	8b 12                	mov    (%rdx),%edx
  800df9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800dfc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e00:	89 0a                	mov    %ecx,(%rdx)
  800e02:	eb 14                	jmp    800e18 <getint+0x58>
  800e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e08:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e0c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e14:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e18:	48 8b 00             	mov    (%rax),%rax
  800e1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e1f:	e9 9d 00 00 00       	jmpq   800ec1 <getint+0x101>
	else if (lflag)
  800e24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e28:	74 4c                	je     800e76 <getint+0xb6>
		x=va_arg(*ap, long);
  800e2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2e:	8b 00                	mov    (%rax),%eax
  800e30:	83 f8 30             	cmp    $0x30,%eax
  800e33:	73 24                	jae    800e59 <getint+0x99>
  800e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e39:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e41:	8b 00                	mov    (%rax),%eax
  800e43:	89 c0                	mov    %eax,%eax
  800e45:	48 01 d0             	add    %rdx,%rax
  800e48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e4c:	8b 12                	mov    (%rdx),%edx
  800e4e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e55:	89 0a                	mov    %ecx,(%rdx)
  800e57:	eb 14                	jmp    800e6d <getint+0xad>
  800e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e61:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e69:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e6d:	48 8b 00             	mov    (%rax),%rax
  800e70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e74:	eb 4b                	jmp    800ec1 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7a:	8b 00                	mov    (%rax),%eax
  800e7c:	83 f8 30             	cmp    $0x30,%eax
  800e7f:	73 24                	jae    800ea5 <getint+0xe5>
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8d:	8b 00                	mov    (%rax),%eax
  800e8f:	89 c0                	mov    %eax,%eax
  800e91:	48 01 d0             	add    %rdx,%rax
  800e94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e98:	8b 12                	mov    (%rdx),%edx
  800e9a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea1:	89 0a                	mov    %ecx,(%rdx)
  800ea3:	eb 14                	jmp    800eb9 <getint+0xf9>
  800ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ead:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800eb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800eb9:	8b 00                	mov    (%rax),%eax
  800ebb:	48 98                	cltq   
  800ebd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ec5:	c9                   	leaveq 
  800ec6:	c3                   	retq   

0000000000800ec7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec7:	55                   	push   %rbp
  800ec8:	48 89 e5             	mov    %rsp,%rbp
  800ecb:	41 54                	push   %r12
  800ecd:	53                   	push   %rbx
  800ece:	48 83 ec 60          	sub    $0x60,%rsp
  800ed2:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ed6:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800eda:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ede:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ee2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee6:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800eea:	48 8b 0a             	mov    (%rdx),%rcx
  800eed:	48 89 08             	mov    %rcx,(%rax)
  800ef0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800efc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f00:	eb 17                	jmp    800f19 <vprintfmt+0x52>
			if (ch == '\0')
  800f02:	85 db                	test   %ebx,%ebx
  800f04:	0f 84 c5 04 00 00    	je     8013cf <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800f0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f12:	48 89 d6             	mov    %rdx,%rsi
  800f15:	89 df                	mov    %ebx,%edi
  800f17:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f19:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f1d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f21:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f25:	0f b6 00             	movzbl (%rax),%eax
  800f28:	0f b6 d8             	movzbl %al,%ebx
  800f2b:	83 fb 25             	cmp    $0x25,%ebx
  800f2e:	75 d2                	jne    800f02 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800f30:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f34:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f3b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f49:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f50:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f54:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f58:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f5c:	0f b6 00             	movzbl (%rax),%eax
  800f5f:	0f b6 d8             	movzbl %al,%ebx
  800f62:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f65:	83 f8 55             	cmp    $0x55,%eax
  800f68:	0f 87 2e 04 00 00    	ja     80139c <vprintfmt+0x4d5>
  800f6e:	89 c0                	mov    %eax,%eax
  800f70:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f77:	00 
  800f78:	48 b8 58 4e 80 00 00 	movabs $0x804e58,%rax
  800f7f:	00 00 00 
  800f82:	48 01 d0             	add    %rdx,%rax
  800f85:	48 8b 00             	mov    (%rax),%rax
  800f88:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f8a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f8e:	eb c0                	jmp    800f50 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f90:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f94:	eb ba                	jmp    800f50 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f96:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800f9d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fa0:	89 d0                	mov    %edx,%eax
  800fa2:	c1 e0 02             	shl    $0x2,%eax
  800fa5:	01 d0                	add    %edx,%eax
  800fa7:	01 c0                	add    %eax,%eax
  800fa9:	01 d8                	add    %ebx,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fb1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fb5:	0f b6 00             	movzbl (%rax),%eax
  800fb8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fbb:	83 fb 2f             	cmp    $0x2f,%ebx
  800fbe:	7e 0c                	jle    800fcc <vprintfmt+0x105>
  800fc0:	83 fb 39             	cmp    $0x39,%ebx
  800fc3:	7f 07                	jg     800fcc <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800fc5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800fca:	eb d1                	jmp    800f9d <vprintfmt+0xd6>
			goto process_precision;
  800fcc:	eb 50                	jmp    80101e <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800fce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd1:	83 f8 30             	cmp    $0x30,%eax
  800fd4:	73 17                	jae    800fed <vprintfmt+0x126>
  800fd6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fdd:	89 d2                	mov    %edx,%edx
  800fdf:	48 01 d0             	add    %rdx,%rax
  800fe2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fe5:	83 c2 08             	add    $0x8,%edx
  800fe8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800feb:	eb 0c                	jmp    800ff9 <vprintfmt+0x132>
  800fed:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ff1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ff5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ff9:	8b 00                	mov    (%rax),%eax
  800ffb:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ffe:	eb 1e                	jmp    80101e <vprintfmt+0x157>

		case '.':
			if (width < 0)
  801000:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801004:	79 07                	jns    80100d <vprintfmt+0x146>
				width = 0;
  801006:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80100d:	e9 3e ff ff ff       	jmpq   800f50 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801012:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801019:	e9 32 ff ff ff       	jmpq   800f50 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80101e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801022:	79 0d                	jns    801031 <vprintfmt+0x16a>
				width = precision, precision = -1;
  801024:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801027:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80102a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801031:	e9 1a ff ff ff       	jmpq   800f50 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801036:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80103a:	e9 11 ff ff ff       	jmpq   800f50 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80103f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801042:	83 f8 30             	cmp    $0x30,%eax
  801045:	73 17                	jae    80105e <vprintfmt+0x197>
  801047:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80104b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80104e:	89 d2                	mov    %edx,%edx
  801050:	48 01 d0             	add    %rdx,%rax
  801053:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801056:	83 c2 08             	add    $0x8,%edx
  801059:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80105c:	eb 0c                	jmp    80106a <vprintfmt+0x1a3>
  80105e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801062:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801066:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80106a:	8b 10                	mov    (%rax),%edx
  80106c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801070:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801074:	48 89 ce             	mov    %rcx,%rsi
  801077:	89 d7                	mov    %edx,%edi
  801079:	ff d0                	callq  *%rax
			break;
  80107b:	e9 4a 03 00 00       	jmpq   8013ca <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801080:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801083:	83 f8 30             	cmp    $0x30,%eax
  801086:	73 17                	jae    80109f <vprintfmt+0x1d8>
  801088:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80108c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80108f:	89 d2                	mov    %edx,%edx
  801091:	48 01 d0             	add    %rdx,%rax
  801094:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801097:	83 c2 08             	add    $0x8,%edx
  80109a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80109d:	eb 0c                	jmp    8010ab <vprintfmt+0x1e4>
  80109f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8010a3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8010a7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010ab:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010ad:	85 db                	test   %ebx,%ebx
  8010af:	79 02                	jns    8010b3 <vprintfmt+0x1ec>
				err = -err;
  8010b1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010b3:	83 fb 15             	cmp    $0x15,%ebx
  8010b6:	7f 16                	jg     8010ce <vprintfmt+0x207>
  8010b8:	48 b8 80 4d 80 00 00 	movabs $0x804d80,%rax
  8010bf:	00 00 00 
  8010c2:	48 63 d3             	movslq %ebx,%rdx
  8010c5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010c9:	4d 85 e4             	test   %r12,%r12
  8010cc:	75 2e                	jne    8010fc <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  8010ce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d6:	89 d9                	mov    %ebx,%ecx
  8010d8:	48 ba 41 4e 80 00 00 	movabs $0x804e41,%rdx
  8010df:	00 00 00 
  8010e2:	48 89 c7             	mov    %rax,%rdi
  8010e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ea:	49 b8 d8 13 80 00 00 	movabs $0x8013d8,%r8
  8010f1:	00 00 00 
  8010f4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010f7:	e9 ce 02 00 00       	jmpq   8013ca <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  8010fc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801100:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801104:	4c 89 e1             	mov    %r12,%rcx
  801107:	48 ba 4a 4e 80 00 00 	movabs $0x804e4a,%rdx
  80110e:	00 00 00 
  801111:	48 89 c7             	mov    %rax,%rdi
  801114:	b8 00 00 00 00       	mov    $0x0,%eax
  801119:	49 b8 d8 13 80 00 00 	movabs $0x8013d8,%r8
  801120:	00 00 00 
  801123:	41 ff d0             	callq  *%r8
			break;
  801126:	e9 9f 02 00 00       	jmpq   8013ca <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80112b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80112e:	83 f8 30             	cmp    $0x30,%eax
  801131:	73 17                	jae    80114a <vprintfmt+0x283>
  801133:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801137:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80113a:	89 d2                	mov    %edx,%edx
  80113c:	48 01 d0             	add    %rdx,%rax
  80113f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801142:	83 c2 08             	add    $0x8,%edx
  801145:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801148:	eb 0c                	jmp    801156 <vprintfmt+0x28f>
  80114a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80114e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801152:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801156:	4c 8b 20             	mov    (%rax),%r12
  801159:	4d 85 e4             	test   %r12,%r12
  80115c:	75 0a                	jne    801168 <vprintfmt+0x2a1>
				p = "(null)";
  80115e:	49 bc 4d 4e 80 00 00 	movabs $0x804e4d,%r12
  801165:	00 00 00 
			if (width > 0 && padc != '-')
  801168:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80116c:	7e 3f                	jle    8011ad <vprintfmt+0x2e6>
  80116e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801172:	74 39                	je     8011ad <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801174:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801177:	48 98                	cltq   
  801179:	48 89 c6             	mov    %rax,%rsi
  80117c:	4c 89 e7             	mov    %r12,%rdi
  80117f:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801186:	00 00 00 
  801189:	ff d0                	callq  *%rax
  80118b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80118e:	eb 17                	jmp    8011a7 <vprintfmt+0x2e0>
					putch(padc, putdat);
  801190:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801194:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801198:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80119c:	48 89 ce             	mov    %rcx,%rsi
  80119f:	89 d7                	mov    %edx,%edi
  8011a1:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  8011a3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ab:	7f e3                	jg     801190 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011ad:	eb 37                	jmp    8011e6 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  8011af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011b3:	74 1e                	je     8011d3 <vprintfmt+0x30c>
  8011b5:	83 fb 1f             	cmp    $0x1f,%ebx
  8011b8:	7e 05                	jle    8011bf <vprintfmt+0x2f8>
  8011ba:	83 fb 7e             	cmp    $0x7e,%ebx
  8011bd:	7e 14                	jle    8011d3 <vprintfmt+0x30c>
					putch('?', putdat);
  8011bf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011c7:	48 89 d6             	mov    %rdx,%rsi
  8011ca:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011cf:	ff d0                	callq  *%rax
  8011d1:	eb 0f                	jmp    8011e2 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  8011d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011db:	48 89 d6             	mov    %rdx,%rsi
  8011de:	89 df                	mov    %ebx,%edi
  8011e0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011e2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011e6:	4c 89 e0             	mov    %r12,%rax
  8011e9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8011ed:	0f b6 00             	movzbl (%rax),%eax
  8011f0:	0f be d8             	movsbl %al,%ebx
  8011f3:	85 db                	test   %ebx,%ebx
  8011f5:	74 10                	je     801207 <vprintfmt+0x340>
  8011f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8011fb:	78 b2                	js     8011af <vprintfmt+0x2e8>
  8011fd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801201:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801205:	79 a8                	jns    8011af <vprintfmt+0x2e8>
			for (; width > 0; width--)
  801207:	eb 16                	jmp    80121f <vprintfmt+0x358>
				putch(' ', putdat);
  801209:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80120d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801211:	48 89 d6             	mov    %rdx,%rsi
  801214:	bf 20 00 00 00       	mov    $0x20,%edi
  801219:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  80121b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80121f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801223:	7f e4                	jg     801209 <vprintfmt+0x342>
			break;
  801225:	e9 a0 01 00 00       	jmpq   8013ca <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80122a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80122e:	be 03 00 00 00       	mov    $0x3,%esi
  801233:	48 89 c7             	mov    %rax,%rdi
  801236:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  80123d:	00 00 00 
  801240:	ff d0                	callq  *%rax
  801242:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124a:	48 85 c0             	test   %rax,%rax
  80124d:	79 1d                	jns    80126c <vprintfmt+0x3a5>
				putch('-', putdat);
  80124f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801253:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801257:	48 89 d6             	mov    %rdx,%rsi
  80125a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80125f:	ff d0                	callq  *%rax
				num = -(long long) num;
  801261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801265:	48 f7 d8             	neg    %rax
  801268:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80126c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801273:	e9 e5 00 00 00       	jmpq   80135d <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801278:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80127c:	be 03 00 00 00       	mov    $0x3,%esi
  801281:	48 89 c7             	mov    %rax,%rdi
  801284:	48 b8 b9 0c 80 00 00 	movabs $0x800cb9,%rax
  80128b:	00 00 00 
  80128e:	ff d0                	callq  *%rax
  801290:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801294:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80129b:	e9 bd 00 00 00       	jmpq   80135d <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8012a0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012a8:	48 89 d6             	mov    %rdx,%rsi
  8012ab:	bf 58 00 00 00       	mov    $0x58,%edi
  8012b0:	ff d0                	callq  *%rax
			putch('X', putdat);
  8012b2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ba:	48 89 d6             	mov    %rdx,%rsi
  8012bd:	bf 58 00 00 00       	mov    $0x58,%edi
  8012c2:	ff d0                	callq  *%rax
			putch('X', putdat);
  8012c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012cc:	48 89 d6             	mov    %rdx,%rsi
  8012cf:	bf 58 00 00 00       	mov    $0x58,%edi
  8012d4:	ff d0                	callq  *%rax
			break;
  8012d6:	e9 ef 00 00 00       	jmpq   8013ca <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  8012db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012e3:	48 89 d6             	mov    %rdx,%rsi
  8012e6:	bf 30 00 00 00       	mov    $0x30,%edi
  8012eb:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f5:	48 89 d6             	mov    %rdx,%rsi
  8012f8:	bf 78 00 00 00       	mov    $0x78,%edi
  8012fd:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8012ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801302:	83 f8 30             	cmp    $0x30,%eax
  801305:	73 17                	jae    80131e <vprintfmt+0x457>
  801307:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80130b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80130e:	89 d2                	mov    %edx,%edx
  801310:	48 01 d0             	add    %rdx,%rax
  801313:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801316:	83 c2 08             	add    $0x8,%edx
  801319:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  80131c:	eb 0c                	jmp    80132a <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  80131e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801322:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801326:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80132a:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  80132d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801331:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801338:	eb 23                	jmp    80135d <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80133a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80133e:	be 03 00 00 00       	mov    $0x3,%esi
  801343:	48 89 c7             	mov    %rax,%rdi
  801346:	48 b8 b9 0c 80 00 00 	movabs $0x800cb9,%rax
  80134d:	00 00 00 
  801350:	ff d0                	callq  *%rax
  801352:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801356:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80135d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801362:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801365:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801368:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80136c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801370:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801374:	45 89 c1             	mov    %r8d,%r9d
  801377:	41 89 f8             	mov    %edi,%r8d
  80137a:	48 89 c7             	mov    %rax,%rdi
  80137d:	48 b8 00 0c 80 00 00 	movabs $0x800c00,%rax
  801384:	00 00 00 
  801387:	ff d0                	callq  *%rax
			break;
  801389:	eb 3f                	jmp    8013ca <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80138b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80138f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801393:	48 89 d6             	mov    %rdx,%rsi
  801396:	89 df                	mov    %ebx,%edi
  801398:	ff d0                	callq  *%rax
			break;
  80139a:	eb 2e                	jmp    8013ca <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80139c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013a4:	48 89 d6             	mov    %rdx,%rsi
  8013a7:	bf 25 00 00 00       	mov    $0x25,%edi
  8013ac:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013ae:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013b3:	eb 05                	jmp    8013ba <vprintfmt+0x4f3>
  8013b5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013be:	48 83 e8 01          	sub    $0x1,%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	3c 25                	cmp    $0x25,%al
  8013c7:	75 ec                	jne    8013b5 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  8013c9:	90                   	nop
		}
	}
  8013ca:	e9 31 fb ff ff       	jmpq   800f00 <vprintfmt+0x39>
	va_end(aq);
}
  8013cf:	48 83 c4 60          	add    $0x60,%rsp
  8013d3:	5b                   	pop    %rbx
  8013d4:	41 5c                	pop    %r12
  8013d6:	5d                   	pop    %rbp
  8013d7:	c3                   	retq   

00000000008013d8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013d8:	55                   	push   %rbp
  8013d9:	48 89 e5             	mov    %rsp,%rbp
  8013dc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013e3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013ea:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8013f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801406:	84 c0                	test   %al,%al
  801408:	74 20                	je     80142a <printfmt+0x52>
  80140a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80140e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801412:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801416:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80141a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80141e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801422:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801426:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80142a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801431:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801438:	00 00 00 
  80143b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801442:	00 00 00 
  801445:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801449:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801450:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801457:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80145e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801465:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80146c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801473:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80147a:	48 89 c7             	mov    %rax,%rdi
  80147d:	48 b8 c7 0e 80 00 00 	movabs $0x800ec7,%rax
  801484:	00 00 00 
  801487:	ff d0                	callq  *%rax
	va_end(ap);
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 10          	sub    $0x10,%rsp
  801493:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801496:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80149a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149e:	8b 40 10             	mov    0x10(%rax),%eax
  8014a1:	8d 50 01             	lea    0x1(%rax),%edx
  8014a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	48 8b 10             	mov    (%rax),%rdx
  8014b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014ba:	48 39 c2             	cmp    %rax,%rdx
  8014bd:	73 17                	jae    8014d6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8014bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c3:	48 8b 00             	mov    (%rax),%rax
  8014c6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014ce:	48 89 0a             	mov    %rcx,(%rdx)
  8014d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014d4:	88 10                	mov    %dl,(%rax)
}
  8014d6:	c9                   	leaveq 
  8014d7:	c3                   	retq   

00000000008014d8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014d8:	55                   	push   %rbp
  8014d9:	48 89 e5             	mov    %rsp,%rbp
  8014dc:	48 83 ec 50          	sub    $0x50,%rsp
  8014e0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014e4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014e7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014eb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014ef:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8014f3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8014f7:	48 8b 0a             	mov    (%rdx),%rcx
  8014fa:	48 89 08             	mov    %rcx,(%rax)
  8014fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801501:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801505:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801509:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80150d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801511:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801515:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801518:	48 98                	cltq   
  80151a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80151e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801522:	48 01 d0             	add    %rdx,%rax
  801525:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801529:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801530:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801535:	74 06                	je     80153d <vsnprintf+0x65>
  801537:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80153b:	7f 07                	jg     801544 <vsnprintf+0x6c>
		return -E_INVAL;
  80153d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801542:	eb 2f                	jmp    801573 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801544:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801548:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80154c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801550:	48 89 c6             	mov    %rax,%rsi
  801553:	48 bf 8b 14 80 00 00 	movabs $0x80148b,%rdi
  80155a:	00 00 00 
  80155d:	48 b8 c7 0e 80 00 00 	movabs $0x800ec7,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801569:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80156d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801570:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801573:	c9                   	leaveq 
  801574:	c3                   	retq   

0000000000801575 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801575:	55                   	push   %rbp
  801576:	48 89 e5             	mov    %rsp,%rbp
  801579:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801580:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801587:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80158d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801594:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80159b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015a2:	84 c0                	test   %al,%al
  8015a4:	74 20                	je     8015c6 <snprintf+0x51>
  8015a6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015aa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015ae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015b2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015b6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015ba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015be:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015c2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015c6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015cd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015d4:	00 00 00 
  8015d7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015de:	00 00 00 
  8015e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015ec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015f3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8015fa:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801601:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801608:	48 8b 0a             	mov    (%rdx),%rcx
  80160b:	48 89 08             	mov    %rcx,(%rax)
  80160e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801612:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801616:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80161a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80161e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801625:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80162c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801632:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801639:	48 89 c7             	mov    %rax,%rdi
  80163c:	48 b8 d8 14 80 00 00 	movabs $0x8014d8,%rax
  801643:	00 00 00 
  801646:	ff d0                	callq  *%rax
  801648:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80164e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801654:	c9                   	leaveq 
  801655:	c3                   	retq   

0000000000801656 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801656:	55                   	push   %rbp
  801657:	48 89 e5             	mov    %rsp,%rbp
  80165a:	48 83 ec 18          	sub    $0x18,%rsp
  80165e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801662:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801669:	eb 09                	jmp    801674 <strlen+0x1e>
		n++;
  80166b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80166f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	84 c0                	test   %al,%al
  80167d:	75 ec                	jne    80166b <strlen+0x15>
	return n;
  80167f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801682:	c9                   	leaveq 
  801683:	c3                   	retq   

0000000000801684 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801684:	55                   	push   %rbp
  801685:	48 89 e5             	mov    %rsp,%rbp
  801688:	48 83 ec 20          	sub    $0x20,%rsp
  80168c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801690:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80169b:	eb 0e                	jmp    8016ab <strnlen+0x27>
		n++;
  80169d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016a6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016ab:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016b0:	74 0b                	je     8016bd <strnlen+0x39>
  8016b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	84 c0                	test   %al,%al
  8016bb:	75 e0                	jne    80169d <strnlen+0x19>
	return n;
  8016bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016c0:	c9                   	leaveq 
  8016c1:	c3                   	retq   

00000000008016c2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016c2:	55                   	push   %rbp
  8016c3:	48 89 e5             	mov    %rsp,%rbp
  8016c6:	48 83 ec 20          	sub    $0x20,%rsp
  8016ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016da:	90                   	nop
  8016db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016df:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016e7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016eb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016ef:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8016f3:	0f b6 12             	movzbl (%rdx),%edx
  8016f6:	88 10                	mov    %dl,(%rax)
  8016f8:	0f b6 00             	movzbl (%rax),%eax
  8016fb:	84 c0                	test   %al,%al
  8016fd:	75 dc                	jne    8016db <strcpy+0x19>
		/* do nothing */;
	return ret;
  8016ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801703:	c9                   	leaveq 
  801704:	c3                   	retq   

0000000000801705 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801705:	55                   	push   %rbp
  801706:	48 89 e5             	mov    %rsp,%rbp
  801709:	48 83 ec 20          	sub    $0x20,%rsp
  80170d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801711:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	48 89 c7             	mov    %rax,%rdi
  80171c:	48 b8 56 16 80 00 00 	movabs $0x801656,%rax
  801723:	00 00 00 
  801726:	ff d0                	callq  *%rax
  801728:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80172b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80172e:	48 63 d0             	movslq %eax,%rdx
  801731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801735:	48 01 c2             	add    %rax,%rdx
  801738:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80173c:	48 89 c6             	mov    %rax,%rsi
  80173f:	48 89 d7             	mov    %rdx,%rdi
  801742:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  801749:	00 00 00 
  80174c:	ff d0                	callq  *%rax
	return dst;
  80174e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801752:	c9                   	leaveq 
  801753:	c3                   	retq   

0000000000801754 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801754:	55                   	push   %rbp
  801755:	48 89 e5             	mov    %rsp,%rbp
  801758:	48 83 ec 28          	sub    $0x28,%rsp
  80175c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801760:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801764:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801770:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801777:	00 
  801778:	eb 2a                	jmp    8017a4 <strncpy+0x50>
		*dst++ = *src;
  80177a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801782:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801786:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80178a:	0f b6 12             	movzbl (%rdx),%edx
  80178d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80178f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	84 c0                	test   %al,%al
  801798:	74 05                	je     80179f <strncpy+0x4b>
			src++;
  80179a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80179f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017ac:	72 cc                	jb     80177a <strncpy+0x26>
	}
	return ret;
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 28          	sub    $0x28,%rsp
  8017bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017d0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017d5:	74 3d                	je     801814 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017d7:	eb 1d                	jmp    8017f6 <strlcpy+0x42>
			*dst++ = *src++;
  8017d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017e9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017ed:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017f1:	0f b6 12             	movzbl (%rdx),%edx
  8017f4:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8017f6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8017fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801800:	74 0b                	je     80180d <strlcpy+0x59>
  801802:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	84 c0                	test   %al,%al
  80180b:	75 cc                	jne    8017d9 <strlcpy+0x25>
		*dst = '\0';
  80180d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801811:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181c:	48 29 c2             	sub    %rax,%rdx
  80181f:	48 89 d0             	mov    %rdx,%rax
}
  801822:	c9                   	leaveq 
  801823:	c3                   	retq   

0000000000801824 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 83 ec 10          	sub    $0x10,%rsp
  80182c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801830:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801834:	eb 0a                	jmp    801840 <strcmp+0x1c>
		p++, q++;
  801836:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80183b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	84 c0                	test   %al,%al
  801849:	74 12                	je     80185d <strcmp+0x39>
  80184b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184f:	0f b6 10             	movzbl (%rax),%edx
  801852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801856:	0f b6 00             	movzbl (%rax),%eax
  801859:	38 c2                	cmp    %al,%dl
  80185b:	74 d9                	je     801836 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80185d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801861:	0f b6 00             	movzbl (%rax),%eax
  801864:	0f b6 d0             	movzbl %al,%edx
  801867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186b:	0f b6 00             	movzbl (%rax),%eax
  80186e:	0f b6 c0             	movzbl %al,%eax
  801871:	29 c2                	sub    %eax,%edx
  801873:	89 d0                	mov    %edx,%eax
}
  801875:	c9                   	leaveq 
  801876:	c3                   	retq   

0000000000801877 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801877:	55                   	push   %rbp
  801878:	48 89 e5             	mov    %rsp,%rbp
  80187b:	48 83 ec 18          	sub    $0x18,%rsp
  80187f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801883:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801887:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80188b:	eb 0f                	jmp    80189c <strncmp+0x25>
		n--, p++, q++;
  80188d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801892:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801897:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  80189c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a1:	74 1d                	je     8018c0 <strncmp+0x49>
  8018a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a7:	0f b6 00             	movzbl (%rax),%eax
  8018aa:	84 c0                	test   %al,%al
  8018ac:	74 12                	je     8018c0 <strncmp+0x49>
  8018ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b2:	0f b6 10             	movzbl (%rax),%edx
  8018b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b9:	0f b6 00             	movzbl (%rax),%eax
  8018bc:	38 c2                	cmp    %al,%dl
  8018be:	74 cd                	je     80188d <strncmp+0x16>
	if (n == 0)
  8018c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018c5:	75 07                	jne    8018ce <strncmp+0x57>
		return 0;
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	eb 18                	jmp    8018e6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d2:	0f b6 00             	movzbl (%rax),%eax
  8018d5:	0f b6 d0             	movzbl %al,%edx
  8018d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018dc:	0f b6 00             	movzbl (%rax),%eax
  8018df:	0f b6 c0             	movzbl %al,%eax
  8018e2:	29 c2                	sub    %eax,%edx
  8018e4:	89 d0                	mov    %edx,%eax
}
  8018e6:	c9                   	leaveq 
  8018e7:	c3                   	retq   

00000000008018e8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018e8:	55                   	push   %rbp
  8018e9:	48 89 e5             	mov    %rsp,%rbp
  8018ec:	48 83 ec 10          	sub    $0x10,%rsp
  8018f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f4:	89 f0                	mov    %esi,%eax
  8018f6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8018f9:	eb 17                	jmp    801912 <strchr+0x2a>
		if (*s == c)
  8018fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801905:	75 06                	jne    80190d <strchr+0x25>
			return (char *) s;
  801907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190b:	eb 15                	jmp    801922 <strchr+0x3a>
	for (; *s; s++)
  80190d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	84 c0                	test   %al,%al
  80191b:	75 de                	jne    8018fb <strchr+0x13>
	return 0;
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801922:	c9                   	leaveq 
  801923:	c3                   	retq   

0000000000801924 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 10          	sub    $0x10,%rsp
  80192c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801930:	89 f0                	mov    %esi,%eax
  801932:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801935:	eb 13                	jmp    80194a <strfind+0x26>
		if (*s == c)
  801937:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193b:	0f b6 00             	movzbl (%rax),%eax
  80193e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801941:	75 02                	jne    801945 <strfind+0x21>
			break;
  801943:	eb 10                	jmp    801955 <strfind+0x31>
	for (; *s; s++)
  801945:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80194a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194e:	0f b6 00             	movzbl (%rax),%eax
  801951:	84 c0                	test   %al,%al
  801953:	75 e2                	jne    801937 <strfind+0x13>
	return (char *) s;
  801955:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801959:	c9                   	leaveq 
  80195a:	c3                   	retq   

000000000080195b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	48 83 ec 18          	sub    $0x18,%rsp
  801963:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801967:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80196a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80196e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801973:	75 06                	jne    80197b <memset+0x20>
		return v;
  801975:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801979:	eb 69                	jmp    8019e4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80197b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197f:	83 e0 03             	and    $0x3,%eax
  801982:	48 85 c0             	test   %rax,%rax
  801985:	75 48                	jne    8019cf <memset+0x74>
  801987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80198b:	83 e0 03             	and    $0x3,%eax
  80198e:	48 85 c0             	test   %rax,%rax
  801991:	75 3c                	jne    8019cf <memset+0x74>
		c &= 0xFF;
  801993:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80199a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80199d:	c1 e0 18             	shl    $0x18,%eax
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019a5:	c1 e0 10             	shl    $0x10,%eax
  8019a8:	09 c2                	or     %eax,%edx
  8019aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ad:	c1 e0 08             	shl    $0x8,%eax
  8019b0:	09 d0                	or     %edx,%eax
  8019b2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b9:	48 c1 e8 02          	shr    $0x2,%rax
  8019bd:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8019c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019c7:	48 89 d7             	mov    %rdx,%rdi
  8019ca:	fc                   	cld    
  8019cb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019cd:	eb 11                	jmp    8019e0 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019d6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019da:	48 89 d7             	mov    %rdx,%rdi
  8019dd:	fc                   	cld    
  8019de:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019e4:	c9                   	leaveq 
  8019e5:	c3                   	retq   

00000000008019e6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 28          	sub    $0x28,%rsp
  8019ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8019fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a06:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a12:	0f 83 88 00 00 00    	jae    801aa0 <memmove+0xba>
  801a18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a20:	48 01 d0             	add    %rdx,%rax
  801a23:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a27:	76 77                	jbe    801aa0 <memmove+0xba>
		s += n;
  801a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a35:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3d:	83 e0 03             	and    $0x3,%eax
  801a40:	48 85 c0             	test   %rax,%rax
  801a43:	75 3b                	jne    801a80 <memmove+0x9a>
  801a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a49:	83 e0 03             	and    $0x3,%eax
  801a4c:	48 85 c0             	test   %rax,%rax
  801a4f:	75 2f                	jne    801a80 <memmove+0x9a>
  801a51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a55:	83 e0 03             	and    $0x3,%eax
  801a58:	48 85 c0             	test   %rax,%rax
  801a5b:	75 23                	jne    801a80 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a61:	48 83 e8 04          	sub    $0x4,%rax
  801a65:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a69:	48 83 ea 04          	sub    $0x4,%rdx
  801a6d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a71:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801a75:	48 89 c7             	mov    %rax,%rdi
  801a78:	48 89 d6             	mov    %rdx,%rsi
  801a7b:	fd                   	std    
  801a7c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a7e:	eb 1d                	jmp    801a9d <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a84:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a94:	48 89 d7             	mov    %rdx,%rdi
  801a97:	48 89 c1             	mov    %rax,%rcx
  801a9a:	fd                   	std    
  801a9b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801a9d:	fc                   	cld    
  801a9e:	eb 57                	jmp    801af7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa4:	83 e0 03             	and    $0x3,%eax
  801aa7:	48 85 c0             	test   %rax,%rax
  801aaa:	75 36                	jne    801ae2 <memmove+0xfc>
  801aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ab0:	83 e0 03             	and    $0x3,%eax
  801ab3:	48 85 c0             	test   %rax,%rax
  801ab6:	75 2a                	jne    801ae2 <memmove+0xfc>
  801ab8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abc:	83 e0 03             	and    $0x3,%eax
  801abf:	48 85 c0             	test   %rax,%rax
  801ac2:	75 1e                	jne    801ae2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac8:	48 c1 e8 02          	shr    $0x2,%rax
  801acc:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801acf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ad7:	48 89 c7             	mov    %rax,%rdi
  801ada:	48 89 d6             	mov    %rdx,%rsi
  801add:	fc                   	cld    
  801ade:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ae0:	eb 15                	jmp    801af7 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aea:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801aee:	48 89 c7             	mov    %rax,%rdi
  801af1:	48 89 d6             	mov    %rdx,%rsi
  801af4:	fc                   	cld    
  801af5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801afb:	c9                   	leaveq 
  801afc:	c3                   	retq   

0000000000801afd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801afd:	55                   	push   %rbp
  801afe:	48 89 e5             	mov    %rsp,%rbp
  801b01:	48 83 ec 18          	sub    $0x18,%rsp
  801b05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b0d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b15:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1d:	48 89 ce             	mov    %rcx,%rsi
  801b20:	48 89 c7             	mov    %rax,%rdi
  801b23:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  801b2a:	00 00 00 
  801b2d:	ff d0                	callq  *%rax
}
  801b2f:	c9                   	leaveq 
  801b30:	c3                   	retq   

0000000000801b31 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b31:	55                   	push   %rbp
  801b32:	48 89 e5             	mov    %rsp,%rbp
  801b35:	48 83 ec 28          	sub    $0x28,%rsp
  801b39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b3d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b41:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b49:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b55:	eb 36                	jmp    801b8d <memcmp+0x5c>
		if (*s1 != *s2)
  801b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5b:	0f b6 10             	movzbl (%rax),%edx
  801b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b62:	0f b6 00             	movzbl (%rax),%eax
  801b65:	38 c2                	cmp    %al,%dl
  801b67:	74 1a                	je     801b83 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6d:	0f b6 00             	movzbl (%rax),%eax
  801b70:	0f b6 d0             	movzbl %al,%edx
  801b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	0f b6 c0             	movzbl %al,%eax
  801b7d:	29 c2                	sub    %eax,%edx
  801b7f:	89 d0                	mov    %edx,%eax
  801b81:	eb 20                	jmp    801ba3 <memcmp+0x72>
		s1++, s2++;
  801b83:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b88:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b91:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b99:	48 85 c0             	test   %rax,%rax
  801b9c:	75 b9                	jne    801b57 <memcmp+0x26>
	}

	return 0;
  801b9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba3:	c9                   	leaveq 
  801ba4:	c3                   	retq   

0000000000801ba5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ba5:	55                   	push   %rbp
  801ba6:	48 89 e5             	mov    %rsp,%rbp
  801ba9:	48 83 ec 28          	sub    $0x28,%rsp
  801bad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc0:	48 01 d0             	add    %rdx,%rax
  801bc3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bc7:	eb 15                	jmp    801bde <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bcd:	0f b6 00             	movzbl (%rax),%eax
  801bd0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801bd3:	38 d0                	cmp    %dl,%al
  801bd5:	75 02                	jne    801bd9 <memfind+0x34>
			break;
  801bd7:	eb 0f                	jmp    801be8 <memfind+0x43>
	for (; s < ends; s++)
  801bd9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801be6:	72 e1                	jb     801bc9 <memfind+0x24>
	return (void *) s;
  801be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bec:	c9                   	leaveq 
  801bed:	c3                   	retq   

0000000000801bee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bee:	55                   	push   %rbp
  801bef:	48 89 e5             	mov    %rsp,%rbp
  801bf2:	48 83 ec 38          	sub    $0x38,%rsp
  801bf6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bfa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801bfe:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c08:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c0f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c10:	eb 05                	jmp    801c17 <strtol+0x29>
		s++;
  801c12:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801c17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1b:	0f b6 00             	movzbl (%rax),%eax
  801c1e:	3c 20                	cmp    $0x20,%al
  801c20:	74 f0                	je     801c12 <strtol+0x24>
  801c22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c26:	0f b6 00             	movzbl (%rax),%eax
  801c29:	3c 09                	cmp    $0x9,%al
  801c2b:	74 e5                	je     801c12 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c31:	0f b6 00             	movzbl (%rax),%eax
  801c34:	3c 2b                	cmp    $0x2b,%al
  801c36:	75 07                	jne    801c3f <strtol+0x51>
		s++;
  801c38:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c3d:	eb 17                	jmp    801c56 <strtol+0x68>
	else if (*s == '-')
  801c3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c43:	0f b6 00             	movzbl (%rax),%eax
  801c46:	3c 2d                	cmp    $0x2d,%al
  801c48:	75 0c                	jne    801c56 <strtol+0x68>
		s++, neg = 1;
  801c4a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c4f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c56:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c5a:	74 06                	je     801c62 <strtol+0x74>
  801c5c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c60:	75 28                	jne    801c8a <strtol+0x9c>
  801c62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c66:	0f b6 00             	movzbl (%rax),%eax
  801c69:	3c 30                	cmp    $0x30,%al
  801c6b:	75 1d                	jne    801c8a <strtol+0x9c>
  801c6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c71:	48 83 c0 01          	add    $0x1,%rax
  801c75:	0f b6 00             	movzbl (%rax),%eax
  801c78:	3c 78                	cmp    $0x78,%al
  801c7a:	75 0e                	jne    801c8a <strtol+0x9c>
		s += 2, base = 16;
  801c7c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c81:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c88:	eb 2c                	jmp    801cb6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c8a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c8e:	75 19                	jne    801ca9 <strtol+0xbb>
  801c90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c94:	0f b6 00             	movzbl (%rax),%eax
  801c97:	3c 30                	cmp    $0x30,%al
  801c99:	75 0e                	jne    801ca9 <strtol+0xbb>
		s++, base = 8;
  801c9b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ca0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ca7:	eb 0d                	jmp    801cb6 <strtol+0xc8>
	else if (base == 0)
  801ca9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cad:	75 07                	jne    801cb6 <strtol+0xc8>
		base = 10;
  801caf:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cba:	0f b6 00             	movzbl (%rax),%eax
  801cbd:	3c 2f                	cmp    $0x2f,%al
  801cbf:	7e 1d                	jle    801cde <strtol+0xf0>
  801cc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc5:	0f b6 00             	movzbl (%rax),%eax
  801cc8:	3c 39                	cmp    $0x39,%al
  801cca:	7f 12                	jg     801cde <strtol+0xf0>
			dig = *s - '0';
  801ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd0:	0f b6 00             	movzbl (%rax),%eax
  801cd3:	0f be c0             	movsbl %al,%eax
  801cd6:	83 e8 30             	sub    $0x30,%eax
  801cd9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cdc:	eb 4e                	jmp    801d2c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801cde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce2:	0f b6 00             	movzbl (%rax),%eax
  801ce5:	3c 60                	cmp    $0x60,%al
  801ce7:	7e 1d                	jle    801d06 <strtol+0x118>
  801ce9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ced:	0f b6 00             	movzbl (%rax),%eax
  801cf0:	3c 7a                	cmp    $0x7a,%al
  801cf2:	7f 12                	jg     801d06 <strtol+0x118>
			dig = *s - 'a' + 10;
  801cf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf8:	0f b6 00             	movzbl (%rax),%eax
  801cfb:	0f be c0             	movsbl %al,%eax
  801cfe:	83 e8 57             	sub    $0x57,%eax
  801d01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d04:	eb 26                	jmp    801d2c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0a:	0f b6 00             	movzbl (%rax),%eax
  801d0d:	3c 40                	cmp    $0x40,%al
  801d0f:	7e 48                	jle    801d59 <strtol+0x16b>
  801d11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d15:	0f b6 00             	movzbl (%rax),%eax
  801d18:	3c 5a                	cmp    $0x5a,%al
  801d1a:	7f 3d                	jg     801d59 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d20:	0f b6 00             	movzbl (%rax),%eax
  801d23:	0f be c0             	movsbl %al,%eax
  801d26:	83 e8 37             	sub    $0x37,%eax
  801d29:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d2f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d32:	7c 02                	jl     801d36 <strtol+0x148>
			break;
  801d34:	eb 23                	jmp    801d59 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d36:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d3b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d3e:	48 98                	cltq   
  801d40:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d45:	48 89 c2             	mov    %rax,%rdx
  801d48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d4b:	48 98                	cltq   
  801d4d:	48 01 d0             	add    %rdx,%rax
  801d50:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d54:	e9 5d ff ff ff       	jmpq   801cb6 <strtol+0xc8>

	if (endptr)
  801d59:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d5e:	74 0b                	je     801d6b <strtol+0x17d>
		*endptr = (char *) s;
  801d60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d64:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d68:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d6f:	74 09                	je     801d7a <strtol+0x18c>
  801d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d75:	48 f7 d8             	neg    %rax
  801d78:	eb 04                	jmp    801d7e <strtol+0x190>
  801d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d7e:	c9                   	leaveq 
  801d7f:	c3                   	retq   

0000000000801d80 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d80:	55                   	push   %rbp
  801d81:	48 89 e5             	mov    %rsp,%rbp
  801d84:	48 83 ec 30          	sub    $0x30,%rsp
  801d88:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d8c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801d90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d94:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d98:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801d9c:	0f b6 00             	movzbl (%rax),%eax
  801d9f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801da2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801da6:	75 06                	jne    801dae <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dac:	eb 6b                	jmp    801e19 <strstr+0x99>

	len = strlen(str);
  801dae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801db2:	48 89 c7             	mov    %rax,%rdi
  801db5:	48 b8 56 16 80 00 00 	movabs $0x801656,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
  801dc1:	48 98                	cltq   
  801dc3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801dc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dcb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dcf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801dd3:	0f b6 00             	movzbl (%rax),%eax
  801dd6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801dd9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ddd:	75 07                	jne    801de6 <strstr+0x66>
				return (char *) 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	eb 33                	jmp    801e19 <strstr+0x99>
		} while (sc != c);
  801de6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801dea:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ded:	75 d8                	jne    801dc7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801def:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801df7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfb:	48 89 ce             	mov    %rcx,%rsi
  801dfe:	48 89 c7             	mov    %rax,%rdi
  801e01:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801e08:	00 00 00 
  801e0b:	ff d0                	callq  *%rax
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	75 b6                	jne    801dc7 <strstr+0x47>

	return (char *) (in - 1);
  801e11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e15:	48 83 e8 01          	sub    $0x1,%rax
}
  801e19:	c9                   	leaveq 
  801e1a:	c3                   	retq   

0000000000801e1b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e1b:	55                   	push   %rbp
  801e1c:	48 89 e5             	mov    %rsp,%rbp
  801e1f:	53                   	push   %rbx
  801e20:	48 83 ec 48          	sub    $0x48,%rsp
  801e24:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e27:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e2a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e2e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e32:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e36:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e3d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e41:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e45:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e49:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e4d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e51:	4c 89 c3             	mov    %r8,%rbx
  801e54:	cd 30                	int    $0x30
  801e56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e5a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e5e:	74 3e                	je     801e9e <syscall+0x83>
  801e60:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e65:	7e 37                	jle    801e9e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e6e:	49 89 d0             	mov    %rdx,%r8
  801e71:	89 c1                	mov    %eax,%ecx
  801e73:	48 ba 08 51 80 00 00 	movabs $0x805108,%rdx
  801e7a:	00 00 00 
  801e7d:	be 23 00 00 00       	mov    $0x23,%esi
  801e82:	48 bf 25 51 80 00 00 	movabs $0x805125,%rdi
  801e89:	00 00 00 
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e91:	49 b9 ef 08 80 00 00 	movabs $0x8008ef,%r9
  801e98:	00 00 00 
  801e9b:	41 ff d1             	callq  *%r9

	return ret;
  801e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ea2:	48 83 c4 48          	add    $0x48,%rsp
  801ea6:	5b                   	pop    %rbx
  801ea7:	5d                   	pop    %rbp
  801ea8:	c3                   	retq   

0000000000801ea9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ea9:	55                   	push   %rbp
  801eaa:	48 89 e5             	mov    %rsp,%rbp
  801ead:	48 83 ec 10          	sub    $0x10,%rsp
  801eb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801eb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec1:	48 83 ec 08          	sub    $0x8,%rsp
  801ec5:	6a 00                	pushq  $0x0
  801ec7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ecd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed3:	48 89 d1             	mov    %rdx,%rcx
  801ed6:	48 89 c2             	mov    %rax,%rdx
  801ed9:	be 00 00 00 00       	mov    $0x0,%esi
  801ede:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee3:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
  801eef:	48 83 c4 10          	add    $0x10,%rsp
}
  801ef3:	c9                   	leaveq 
  801ef4:	c3                   	retq   

0000000000801ef5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ef5:	55                   	push   %rbp
  801ef6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ef9:	48 83 ec 08          	sub    $0x8,%rsp
  801efd:	6a 00                	pushq  $0x0
  801eff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f10:	ba 00 00 00 00       	mov    $0x0,%edx
  801f15:	be 00 00 00 00       	mov    $0x0,%esi
  801f1a:	bf 01 00 00 00       	mov    $0x1,%edi
  801f1f:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
  801f2b:	48 83 c4 10          	add    $0x10,%rsp
}
  801f2f:	c9                   	leaveq 
  801f30:	c3                   	retq   

0000000000801f31 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f31:	55                   	push   %rbp
  801f32:	48 89 e5             	mov    %rsp,%rbp
  801f35:	48 83 ec 10          	sub    $0x10,%rsp
  801f39:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3f:	48 98                	cltq   
  801f41:	48 83 ec 08          	sub    $0x8,%rsp
  801f45:	6a 00                	pushq  $0x0
  801f47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f58:	48 89 c2             	mov    %rax,%rdx
  801f5b:	be 01 00 00 00       	mov    $0x1,%esi
  801f60:	bf 03 00 00 00       	mov    $0x3,%edi
  801f65:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
  801f71:	48 83 c4 10          	add    $0x10,%rsp
}
  801f75:	c9                   	leaveq 
  801f76:	c3                   	retq   

0000000000801f77 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f77:	55                   	push   %rbp
  801f78:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f7b:	48 83 ec 08          	sub    $0x8,%rsp
  801f7f:	6a 00                	pushq  $0x0
  801f81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
  801f97:	be 00 00 00 00       	mov    $0x0,%esi
  801f9c:	bf 02 00 00 00       	mov    $0x2,%edi
  801fa1:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	callq  *%rax
  801fad:	48 83 c4 10          	add    $0x10,%rsp
}
  801fb1:	c9                   	leaveq 
  801fb2:	c3                   	retq   

0000000000801fb3 <sys_yield>:

void
sys_yield(void)
{
  801fb3:	55                   	push   %rbp
  801fb4:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fb7:	48 83 ec 08          	sub    $0x8,%rsp
  801fbb:	6a 00                	pushq  $0x0
  801fbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fce:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd3:	be 00 00 00 00       	mov    $0x0,%esi
  801fd8:	bf 0b 00 00 00       	mov    $0xb,%edi
  801fdd:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax
  801fe9:	48 83 c4 10          	add    $0x10,%rsp
}
  801fed:	c9                   	leaveq 
  801fee:	c3                   	retq   

0000000000801fef <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801fef:	55                   	push   %rbp
  801ff0:	48 89 e5             	mov    %rsp,%rbp
  801ff3:	48 83 ec 10          	sub    $0x10,%rsp
  801ff7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ffa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ffe:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802001:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802004:	48 63 c8             	movslq %eax,%rcx
  802007:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200e:	48 98                	cltq   
  802010:	48 83 ec 08          	sub    $0x8,%rsp
  802014:	6a 00                	pushq  $0x0
  802016:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80201c:	49 89 c8             	mov    %rcx,%r8
  80201f:	48 89 d1             	mov    %rdx,%rcx
  802022:	48 89 c2             	mov    %rax,%rdx
  802025:	be 01 00 00 00       	mov    $0x1,%esi
  80202a:	bf 04 00 00 00       	mov    $0x4,%edi
  80202f:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
  80203b:	48 83 c4 10          	add    $0x10,%rsp
}
  80203f:	c9                   	leaveq 
  802040:	c3                   	retq   

0000000000802041 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802041:	55                   	push   %rbp
  802042:	48 89 e5             	mov    %rsp,%rbp
  802045:	48 83 ec 20          	sub    $0x20,%rsp
  802049:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80204c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802050:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802053:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802057:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80205b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80205e:	48 63 c8             	movslq %eax,%rcx
  802061:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802065:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802068:	48 63 f0             	movslq %eax,%rsi
  80206b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80206f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802072:	48 98                	cltq   
  802074:	48 83 ec 08          	sub    $0x8,%rsp
  802078:	51                   	push   %rcx
  802079:	49 89 f9             	mov    %rdi,%r9
  80207c:	49 89 f0             	mov    %rsi,%r8
  80207f:	48 89 d1             	mov    %rdx,%rcx
  802082:	48 89 c2             	mov    %rax,%rdx
  802085:	be 01 00 00 00       	mov    $0x1,%esi
  80208a:	bf 05 00 00 00       	mov    $0x5,%edi
  80208f:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802096:	00 00 00 
  802099:	ff d0                	callq  *%rax
  80209b:	48 83 c4 10          	add    $0x10,%rsp
}
  80209f:	c9                   	leaveq 
  8020a0:	c3                   	retq   

00000000008020a1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020a1:	55                   	push   %rbp
  8020a2:	48 89 e5             	mov    %rsp,%rbp
  8020a5:	48 83 ec 10          	sub    $0x10,%rsp
  8020a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b7:	48 98                	cltq   
  8020b9:	48 83 ec 08          	sub    $0x8,%rsp
  8020bd:	6a 00                	pushq  $0x0
  8020bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020cb:	48 89 d1             	mov    %rdx,%rcx
  8020ce:	48 89 c2             	mov    %rax,%rdx
  8020d1:	be 01 00 00 00       	mov    $0x1,%esi
  8020d6:	bf 06 00 00 00       	mov    $0x6,%edi
  8020db:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
  8020e7:	48 83 c4 10          	add    $0x10,%rsp
}
  8020eb:	c9                   	leaveq 
  8020ec:	c3                   	retq   

00000000008020ed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020ed:	55                   	push   %rbp
  8020ee:	48 89 e5             	mov    %rsp,%rbp
  8020f1:	48 83 ec 10          	sub    $0x10,%rsp
  8020f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8020fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020fe:	48 63 d0             	movslq %eax,%rdx
  802101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802104:	48 98                	cltq   
  802106:	48 83 ec 08          	sub    $0x8,%rsp
  80210a:	6a 00                	pushq  $0x0
  80210c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802112:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802118:	48 89 d1             	mov    %rdx,%rcx
  80211b:	48 89 c2             	mov    %rax,%rdx
  80211e:	be 01 00 00 00       	mov    $0x1,%esi
  802123:	bf 08 00 00 00       	mov    $0x8,%edi
  802128:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  80212f:	00 00 00 
  802132:	ff d0                	callq  *%rax
  802134:	48 83 c4 10          	add    $0x10,%rsp
}
  802138:	c9                   	leaveq 
  802139:	c3                   	retq   

000000000080213a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80213a:	55                   	push   %rbp
  80213b:	48 89 e5             	mov    %rsp,%rbp
  80213e:	48 83 ec 10          	sub    $0x10,%rsp
  802142:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802145:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802149:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802150:	48 98                	cltq   
  802152:	48 83 ec 08          	sub    $0x8,%rsp
  802156:	6a 00                	pushq  $0x0
  802158:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802164:	48 89 d1             	mov    %rdx,%rcx
  802167:	48 89 c2             	mov    %rax,%rdx
  80216a:	be 01 00 00 00       	mov    $0x1,%esi
  80216f:	bf 09 00 00 00       	mov    $0x9,%edi
  802174:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  80217b:	00 00 00 
  80217e:	ff d0                	callq  *%rax
  802180:	48 83 c4 10          	add    $0x10,%rsp
}
  802184:	c9                   	leaveq 
  802185:	c3                   	retq   

0000000000802186 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802186:	55                   	push   %rbp
  802187:	48 89 e5             	mov    %rsp,%rbp
  80218a:	48 83 ec 10          	sub    $0x10,%rsp
  80218e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802191:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802195:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219c:	48 98                	cltq   
  80219e:	48 83 ec 08          	sub    $0x8,%rsp
  8021a2:	6a 00                	pushq  $0x0
  8021a4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021b0:	48 89 d1             	mov    %rdx,%rcx
  8021b3:	48 89 c2             	mov    %rax,%rdx
  8021b6:	be 01 00 00 00       	mov    $0x1,%esi
  8021bb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021c0:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	callq  *%rax
  8021cc:	48 83 c4 10          	add    $0x10,%rsp
}
  8021d0:	c9                   	leaveq 
  8021d1:	c3                   	retq   

00000000008021d2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	48 83 ec 20          	sub    $0x20,%rsp
  8021da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021e5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021eb:	48 63 f0             	movslq %eax,%rsi
  8021ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	48 98                	cltq   
  8021f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fb:	48 83 ec 08          	sub    $0x8,%rsp
  8021ff:	6a 00                	pushq  $0x0
  802201:	49 89 f1             	mov    %rsi,%r9
  802204:	49 89 c8             	mov    %rcx,%r8
  802207:	48 89 d1             	mov    %rdx,%rcx
  80220a:	48 89 c2             	mov    %rax,%rdx
  80220d:	be 00 00 00 00       	mov    $0x0,%esi
  802212:	bf 0c 00 00 00       	mov    $0xc,%edi
  802217:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  80221e:	00 00 00 
  802221:	ff d0                	callq  *%rax
  802223:	48 83 c4 10          	add    $0x10,%rsp
}
  802227:	c9                   	leaveq 
  802228:	c3                   	retq   

0000000000802229 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802229:	55                   	push   %rbp
  80222a:	48 89 e5             	mov    %rsp,%rbp
  80222d:	48 83 ec 10          	sub    $0x10,%rsp
  802231:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802239:	48 83 ec 08          	sub    $0x8,%rsp
  80223d:	6a 00                	pushq  $0x0
  80223f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802245:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80224b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802250:	48 89 c2             	mov    %rax,%rdx
  802253:	be 01 00 00 00       	mov    $0x1,%esi
  802258:	bf 0d 00 00 00       	mov    $0xd,%edi
  80225d:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802264:	00 00 00 
  802267:	ff d0                	callq  *%rax
  802269:	48 83 c4 10          	add    $0x10,%rsp
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   

000000000080226f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802273:	48 83 ec 08          	sub    $0x8,%rsp
  802277:	6a 00                	pushq  $0x0
  802279:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80227f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802285:	b9 00 00 00 00       	mov    $0x0,%ecx
  80228a:	ba 00 00 00 00       	mov    $0x0,%edx
  80228f:	be 00 00 00 00       	mov    $0x0,%esi
  802294:	bf 0e 00 00 00       	mov    $0xe,%edi
  802299:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8022a0:	00 00 00 
  8022a3:	ff d0                	callq  *%rax
  8022a5:	48 83 c4 10          	add    $0x10,%rsp
}
  8022a9:	c9                   	leaveq 
  8022aa:	c3                   	retq   

00000000008022ab <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8022ab:	55                   	push   %rbp
  8022ac:	48 89 e5             	mov    %rsp,%rbp
  8022af:	48 83 ec 20          	sub    $0x20,%rsp
  8022b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022ba:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8022bd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022c1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8022c5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022c8:	48 63 c8             	movslq %eax,%rcx
  8022cb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8022cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022d2:	48 63 f0             	movslq %eax,%rsi
  8022d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022dc:	48 98                	cltq   
  8022de:	48 83 ec 08          	sub    $0x8,%rsp
  8022e2:	51                   	push   %rcx
  8022e3:	49 89 f9             	mov    %rdi,%r9
  8022e6:	49 89 f0             	mov    %rsi,%r8
  8022e9:	48 89 d1             	mov    %rdx,%rcx
  8022ec:	48 89 c2             	mov    %rax,%rdx
  8022ef:	be 00 00 00 00       	mov    $0x0,%esi
  8022f4:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022f9:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802300:	00 00 00 
  802303:	ff d0                	callq  *%rax
  802305:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802309:	c9                   	leaveq 
  80230a:	c3                   	retq   

000000000080230b <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80230b:	55                   	push   %rbp
  80230c:	48 89 e5             	mov    %rsp,%rbp
  80230f:	48 83 ec 10          	sub    $0x10,%rsp
  802313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802317:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80231b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80231f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802323:	48 83 ec 08          	sub    $0x8,%rsp
  802327:	6a 00                	pushq  $0x0
  802329:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80232f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802335:	48 89 d1             	mov    %rdx,%rcx
  802338:	48 89 c2             	mov    %rax,%rdx
  80233b:	be 00 00 00 00       	mov    $0x0,%esi
  802340:	bf 10 00 00 00       	mov    $0x10,%edi
  802345:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	callq  *%rax
  802351:	48 83 c4 10          	add    $0x10,%rsp
}
  802355:	c9                   	leaveq 
  802356:	c3                   	retq   

0000000000802357 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802357:	55                   	push   %rbp
  802358:	48 89 e5             	mov    %rsp,%rbp
  80235b:	48 83 ec 20          	sub    $0x20,%rsp
  80235f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802367:	48 8b 00             	mov    (%rax),%rax
  80236a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80236e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802372:	48 8b 40 08          	mov    0x8(%rax),%rax
  802376:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  802379:	48 ba 33 51 80 00 00 	movabs $0x805133,%rdx
  802380:	00 00 00 
  802383:	be 26 00 00 00       	mov    $0x26,%esi
  802388:	48 bf 4b 51 80 00 00 	movabs $0x80514b,%rdi
  80238f:	00 00 00 
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
  802397:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  80239e:	00 00 00 
  8023a1:	ff d1                	callq  *%rcx

00000000008023a3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8023a3:	55                   	push   %rbp
  8023a4:	48 89 e5             	mov    %rsp,%rbp
  8023a7:	48 83 ec 10          	sub    $0x10,%rsp
  8023ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023ae:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  8023b1:	48 ba 56 51 80 00 00 	movabs $0x805156,%rdx
  8023b8:	00 00 00 
  8023bb:	be 3a 00 00 00       	mov    $0x3a,%esi
  8023c0:	48 bf 4b 51 80 00 00 	movabs $0x80514b,%rdi
  8023c7:	00 00 00 
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  8023d6:	00 00 00 
  8023d9:	ff d1                	callq  *%rcx

00000000008023db <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8023db:	55                   	push   %rbp
  8023dc:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  8023df:	48 ba 6e 51 80 00 00 	movabs $0x80516e,%rdx
  8023e6:	00 00 00 
  8023e9:	be 52 00 00 00       	mov    $0x52,%esi
  8023ee:	48 bf 4b 51 80 00 00 	movabs $0x80514b,%rdi
  8023f5:	00 00 00 
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  802404:	00 00 00 
  802407:	ff d1                	callq  *%rcx

0000000000802409 <sfork>:
}

// Challenge!
int
sfork(void)
{
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80240d:	48 ba 83 51 80 00 00 	movabs $0x805183,%rdx
  802414:	00 00 00 
  802417:	be 59 00 00 00       	mov    $0x59,%esi
  80241c:	48 bf 4b 51 80 00 00 	movabs $0x80514b,%rdi
  802423:	00 00 00 
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  802432:	00 00 00 
  802435:	ff d1                	callq  *%rcx

0000000000802437 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	48 83 ec 20          	sub    $0x20,%rsp
  80243f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802447:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80244b:	48 ba a0 51 80 00 00 	movabs $0x8051a0,%rdx
  802452:	00 00 00 
  802455:	be 1d 00 00 00       	mov    $0x1d,%esi
  80245a:	48 bf b9 51 80 00 00 	movabs $0x8051b9,%rdi
  802461:	00 00 00 
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
  802469:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  802470:	00 00 00 
  802473:	ff d1                	callq  *%rcx

0000000000802475 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802475:	55                   	push   %rbp
  802476:	48 89 e5             	mov    %rsp,%rbp
  802479:	48 83 ec 20          	sub    $0x20,%rsp
  80247d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802480:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802483:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  802487:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80248a:	48 ba c3 51 80 00 00 	movabs $0x8051c3,%rdx
  802491:	00 00 00 
  802494:	be 2d 00 00 00       	mov    $0x2d,%esi
  802499:	48 bf b9 51 80 00 00 	movabs $0x8051b9,%rdi
  8024a0:	00 00 00 
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  8024af:	00 00 00 
  8024b2:	ff d1                	callq  *%rcx

00000000008024b4 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8024b4:	55                   	push   %rbp
  8024b5:	48 89 e5             	mov    %rsp,%rbp
  8024b8:	53                   	push   %rbx
  8024b9:	48 83 ec 48          	sub    $0x48,%rsp
  8024bd:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8024c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  8024c8:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8024cf:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8024d4:	75 0e                	jne    8024e4 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8024d6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8024dd:	00 00 00 
  8024e0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8024e4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8024e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  8024ec:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8024f3:	00 
	a3 = (uint64_t) 0;
  8024f4:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8024fb:	00 
	a4 = (uint64_t) 0;
  8024fc:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802503:	00 
	a5 = 0;
  802504:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80250b:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  80250c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80250f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802513:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802517:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  80251b:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80251f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802523:	4c 89 c3             	mov    %r8,%rbx
  802526:	0f 01 c1             	vmcall 
  802529:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  80252c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802530:	7e 36                	jle    802568 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  802532:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802535:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802538:	41 89 d0             	mov    %edx,%r8d
  80253b:	89 c1                	mov    %eax,%ecx
  80253d:	48 ba e0 51 80 00 00 	movabs $0x8051e0,%rdx
  802544:	00 00 00 
  802547:	be 54 00 00 00       	mov    $0x54,%esi
  80254c:	48 bf b9 51 80 00 00 	movabs $0x8051b9,%rdi
  802553:	00 00 00 
  802556:	b8 00 00 00 00       	mov    $0x0,%eax
  80255b:	49 b9 ef 08 80 00 00 	movabs $0x8008ef,%r9
  802562:	00 00 00 
  802565:	41 ff d1             	callq  *%r9
	return ret;
  802568:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80256b:	48 83 c4 48          	add    $0x48,%rsp
  80256f:	5b                   	pop    %rbx
  802570:	5d                   	pop    %rbp
  802571:	c3                   	retq   

0000000000802572 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802572:	55                   	push   %rbp
  802573:	48 89 e5             	mov    %rsp,%rbp
  802576:	53                   	push   %rbx
  802577:	48 83 ec 58          	sub    $0x58,%rsp
  80257b:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  80257e:	89 75 b0             	mov    %esi,-0x50(%rbp)
  802581:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  802585:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  802588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  80258f:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  802596:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  80259b:	75 0e                	jne    8025ab <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  80259d:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8025a4:	00 00 00 
  8025a7:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8025ab:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8025ae:	48 98                	cltq   
  8025b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8025b4:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8025b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8025bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025bf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8025c3:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8025c6:	48 98                	cltq   
  8025c8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8025cc:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8025d3:	00 

	int r = -E_IPC_NOT_RECV;
  8025d4:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8025db:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8025de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8025e6:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8025ea:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8025ee:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8025f2:	4c 89 c3             	mov    %r8,%rbx
  8025f5:	0f 01 c1             	vmcall 
  8025f8:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  8025fb:	48 83 c4 58          	add    $0x58,%rsp
  8025ff:	5b                   	pop    %rbx
  802600:	5d                   	pop    %rbp
  802601:	c3                   	retq   

0000000000802602 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802602:	55                   	push   %rbp
  802603:	48 89 e5             	mov    %rsp,%rbp
  802606:	48 83 ec 18          	sub    $0x18,%rsp
  80260a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80260d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802614:	eb 4e                	jmp    802664 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802616:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80261d:	00 00 00 
  802620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802623:	48 98                	cltq   
  802625:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80262c:	48 01 d0             	add    %rdx,%rax
  80262f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802635:	8b 00                	mov    (%rax),%eax
  802637:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80263a:	75 24                	jne    802660 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80263c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802643:	00 00 00 
  802646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802649:	48 98                	cltq   
  80264b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802652:	48 01 d0             	add    %rdx,%rax
  802655:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80265b:	8b 40 08             	mov    0x8(%rax),%eax
  80265e:	eb 12                	jmp    802672 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  802660:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802664:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80266b:	7e a9                	jle    802616 <ipc_find_env+0x14>
	}
	return 0;
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802672:	c9                   	leaveq 
  802673:	c3                   	retq   

0000000000802674 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802674:	55                   	push   %rbp
  802675:	48 89 e5             	mov    %rsp,%rbp
  802678:	48 83 ec 08          	sub    $0x8,%rsp
  80267c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802680:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802684:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80268b:	ff ff ff 
  80268e:	48 01 d0             	add    %rdx,%rax
  802691:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802695:	c9                   	leaveq 
  802696:	c3                   	retq   

0000000000802697 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802697:	55                   	push   %rbp
  802698:	48 89 e5             	mov    %rsp,%rbp
  80269b:	48 83 ec 08          	sub    $0x8,%rsp
  80269f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a7:	48 89 c7             	mov    %rax,%rdi
  8026aa:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026bc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 18          	sub    $0x18,%rsp
  8026ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d5:	eb 6b                	jmp    802742 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026da:	48 98                	cltq   
  8026dc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026e2:	48 c1 e0 0c          	shl    $0xc,%rax
  8026e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ee:	48 c1 e8 15          	shr    $0x15,%rax
  8026f2:	48 89 c2             	mov    %rax,%rdx
  8026f5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026fc:	01 00 00 
  8026ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802703:	83 e0 01             	and    $0x1,%eax
  802706:	48 85 c0             	test   %rax,%rax
  802709:	74 21                	je     80272c <fd_alloc+0x6a>
  80270b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270f:	48 c1 e8 0c          	shr    $0xc,%rax
  802713:	48 89 c2             	mov    %rax,%rdx
  802716:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80271d:	01 00 00 
  802720:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802724:	83 e0 01             	and    $0x1,%eax
  802727:	48 85 c0             	test   %rax,%rax
  80272a:	75 12                	jne    80273e <fd_alloc+0x7c>
			*fd_store = fd;
  80272c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802730:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802734:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
  80273c:	eb 1a                	jmp    802758 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  80273e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802742:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802746:	7e 8f                	jle    8026d7 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802753:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802758:	c9                   	leaveq 
  802759:	c3                   	retq   

000000000080275a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80275a:	55                   	push   %rbp
  80275b:	48 89 e5             	mov    %rsp,%rbp
  80275e:	48 83 ec 20          	sub    $0x20,%rsp
  802762:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802765:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802769:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80276d:	78 06                	js     802775 <fd_lookup+0x1b>
  80276f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802773:	7e 07                	jle    80277c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802775:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80277a:	eb 6c                	jmp    8027e8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80277c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80277f:	48 98                	cltq   
  802781:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802787:	48 c1 e0 0c          	shl    $0xc,%rax
  80278b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80278f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802793:	48 c1 e8 15          	shr    $0x15,%rax
  802797:	48 89 c2             	mov    %rax,%rdx
  80279a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a1:	01 00 00 
  8027a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a8:	83 e0 01             	and    $0x1,%eax
  8027ab:	48 85 c0             	test   %rax,%rax
  8027ae:	74 21                	je     8027d1 <fd_lookup+0x77>
  8027b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b8:	48 89 c2             	mov    %rax,%rdx
  8027bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c2:	01 00 00 
  8027c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c9:	83 e0 01             	and    $0x1,%eax
  8027cc:	48 85 c0             	test   %rax,%rax
  8027cf:	75 07                	jne    8027d8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027d6:	eb 10                	jmp    8027e8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027e0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e8:	c9                   	leaveq 
  8027e9:	c3                   	retq   

00000000008027ea <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027ea:	55                   	push   %rbp
  8027eb:	48 89 e5             	mov    %rsp,%rbp
  8027ee:	48 83 ec 30          	sub    $0x30,%rsp
  8027f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027f6:	89 f0                	mov    %esi,%eax
  8027f8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ff:	48 89 c7             	mov    %rax,%rdi
  802802:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	89 c2                	mov    %eax,%edx
  802810:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802814:	48 89 c6             	mov    %rax,%rsi
  802817:	89 d7                	mov    %edx,%edi
  802819:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802828:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282c:	78 0a                	js     802838 <fd_close+0x4e>
	    || fd != fd2)
  80282e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802832:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802836:	74 12                	je     80284a <fd_close+0x60>
		return (must_exist ? r : 0);
  802838:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80283c:	74 05                	je     802843 <fd_close+0x59>
  80283e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802841:	eb 70                	jmp    8028b3 <fd_close+0xc9>
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
  802848:	eb 69                	jmp    8028b3 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80284a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284e:	8b 00                	mov    (%rax),%eax
  802850:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802854:	48 89 d6             	mov    %rdx,%rsi
  802857:	89 c7                	mov    %eax,%edi
  802859:	48 b8 b5 28 80 00 00 	movabs $0x8028b5,%rax
  802860:	00 00 00 
  802863:	ff d0                	callq  *%rax
  802865:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802868:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286c:	78 2a                	js     802898 <fd_close+0xae>
		if (dev->dev_close)
  80286e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802872:	48 8b 40 20          	mov    0x20(%rax),%rax
  802876:	48 85 c0             	test   %rax,%rax
  802879:	74 16                	je     802891 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80287b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802883:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802887:	48 89 d7             	mov    %rdx,%rdi
  80288a:	ff d0                	callq  *%rax
  80288c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288f:	eb 07                	jmp    802898 <fd_close+0xae>
		else
			r = 0;
  802891:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289c:	48 89 c6             	mov    %rax,%rsi
  80289f:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a4:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	callq  *%rax
	return r;
  8028b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b3:	c9                   	leaveq 
  8028b4:	c3                   	retq   

00000000008028b5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028b5:	55                   	push   %rbp
  8028b6:	48 89 e5             	mov    %rsp,%rbp
  8028b9:	48 83 ec 20          	sub    $0x20,%rsp
  8028bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028cb:	eb 41                	jmp    80290e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028cd:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028d4:	00 00 00 
  8028d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028da:	48 63 d2             	movslq %edx,%rdx
  8028dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028e1:	8b 00                	mov    (%rax),%eax
  8028e3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028e6:	75 22                	jne    80290a <dev_lookup+0x55>
			*dev = devtab[i];
  8028e8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028ef:	00 00 00 
  8028f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028f5:	48 63 d2             	movslq %edx,%rdx
  8028f8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802900:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	eb 60                	jmp    80296a <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  80290a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80290e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802915:	00 00 00 
  802918:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80291b:	48 63 d2             	movslq %edx,%rdx
  80291e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802922:	48 85 c0             	test   %rax,%rax
  802925:	75 a6                	jne    8028cd <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802927:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80292e:	00 00 00 
  802931:	48 8b 00             	mov    (%rax),%rax
  802934:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80293a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80293d:	89 c6                	mov    %eax,%esi
  80293f:	48 bf 10 52 80 00 00 	movabs $0x805210,%rdi
  802946:	00 00 00 
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	48 b9 28 0b 80 00 00 	movabs $0x800b28,%rcx
  802955:	00 00 00 
  802958:	ff d1                	callq  *%rcx
	*dev = 0;
  80295a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802965:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80296a:	c9                   	leaveq 
  80296b:	c3                   	retq   

000000000080296c <close>:

int
close(int fdnum)
{
  80296c:	55                   	push   %rbp
  80296d:	48 89 e5             	mov    %rsp,%rbp
  802970:	48 83 ec 20          	sub    $0x20,%rsp
  802974:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802977:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80297e:	48 89 d6             	mov    %rdx,%rsi
  802981:	89 c7                	mov    %eax,%edi
  802983:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
  80298f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802996:	79 05                	jns    80299d <close+0x31>
		return r;
  802998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299b:	eb 18                	jmp    8029b5 <close+0x49>
	else
		return fd_close(fd, 1);
  80299d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a1:	be 01 00 00 00       	mov    $0x1,%esi
  8029a6:	48 89 c7             	mov    %rax,%rdi
  8029a9:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   

00000000008029b7 <close_all>:

void
close_all(void)
{
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c6:	eb 15                	jmp    8029dd <close_all+0x26>
		close(i);
  8029c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cb:	89 c7                	mov    %eax,%edi
  8029cd:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8029d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029dd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029e1:	7e e5                	jle    8029c8 <close_all+0x11>
}
  8029e3:	c9                   	leaveq 
  8029e4:	c3                   	retq   

00000000008029e5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029e5:	55                   	push   %rbp
  8029e6:	48 89 e5             	mov    %rsp,%rbp
  8029e9:	48 83 ec 40          	sub    $0x40,%rsp
  8029ed:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029f0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029f3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029f7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029fa:	48 89 d6             	mov    %rdx,%rsi
  8029fd:	89 c7                	mov    %eax,%edi
  8029ff:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a12:	79 08                	jns    802a1c <dup+0x37>
		return r;
  802a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a17:	e9 70 01 00 00       	jmpq   802b8c <dup+0x1a7>
	close(newfdnum);
  802a1c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a1f:	89 c7                	mov    %eax,%edi
  802a21:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  802a28:	00 00 00 
  802a2b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a2d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a30:	48 98                	cltq   
  802a32:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a38:	48 c1 e0 0c          	shl    $0xc,%rax
  802a3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a44:	48 89 c7             	mov    %rax,%rdi
  802a47:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802a4e:	00 00 00 
  802a51:	ff d0                	callq  *%rax
  802a53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5b:	48 89 c7             	mov    %rax,%rdi
  802a5e:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802a65:	00 00 00 
  802a68:	ff d0                	callq  *%rax
  802a6a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a72:	48 c1 e8 15          	shr    $0x15,%rax
  802a76:	48 89 c2             	mov    %rax,%rdx
  802a79:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a80:	01 00 00 
  802a83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a87:	83 e0 01             	and    $0x1,%eax
  802a8a:	48 85 c0             	test   %rax,%rax
  802a8d:	74 73                	je     802b02 <dup+0x11d>
  802a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a93:	48 c1 e8 0c          	shr    $0xc,%rax
  802a97:	48 89 c2             	mov    %rax,%rdx
  802a9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aa1:	01 00 00 
  802aa4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aa8:	83 e0 01             	and    $0x1,%eax
  802aab:	48 85 c0             	test   %rax,%rax
  802aae:	74 52                	je     802b02 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab4:	48 c1 e8 0c          	shr    $0xc,%rax
  802ab8:	48 89 c2             	mov    %rax,%rdx
  802abb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ac2:	01 00 00 
  802ac5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac9:	25 07 0e 00 00       	and    $0xe07,%eax
  802ace:	89 c1                	mov    %eax,%ecx
  802ad0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad8:	41 89 c8             	mov    %ecx,%r8d
  802adb:	48 89 d1             	mov    %rdx,%rcx
  802ade:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae3:	48 89 c6             	mov    %rax,%rsi
  802ae6:	bf 00 00 00 00       	mov    $0x0,%edi
  802aeb:	48 b8 41 20 80 00 00 	movabs $0x802041,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afe:	79 02                	jns    802b02 <dup+0x11d>
			goto err;
  802b00:	eb 57                	jmp    802b59 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b06:	48 c1 e8 0c          	shr    $0xc,%rax
  802b0a:	48 89 c2             	mov    %rax,%rdx
  802b0d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b14:	01 00 00 
  802b17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b1b:	25 07 0e 00 00       	and    $0xe07,%eax
  802b20:	89 c1                	mov    %eax,%ecx
  802b22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2a:	41 89 c8             	mov    %ecx,%r8d
  802b2d:	48 89 d1             	mov    %rdx,%rcx
  802b30:	ba 00 00 00 00       	mov    $0x0,%edx
  802b35:	48 89 c6             	mov    %rax,%rsi
  802b38:	bf 00 00 00 00       	mov    $0x0,%edi
  802b3d:	48 b8 41 20 80 00 00 	movabs $0x802041,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
  802b49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b50:	79 02                	jns    802b54 <dup+0x16f>
		goto err;
  802b52:	eb 05                	jmp    802b59 <dup+0x174>

	return newfdnum;
  802b54:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b57:	eb 33                	jmp    802b8c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5d:	48 89 c6             	mov    %rax,%rsi
  802b60:	bf 00 00 00 00       	mov    $0x0,%edi
  802b65:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b75:	48 89 c6             	mov    %rax,%rsi
  802b78:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7d:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
	return r;
  802b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b8c:	c9                   	leaveq 
  802b8d:	c3                   	retq   

0000000000802b8e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b8e:	55                   	push   %rbp
  802b8f:	48 89 e5             	mov    %rsp,%rbp
  802b92:	48 83 ec 40          	sub    $0x40,%rsp
  802b96:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b99:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b9d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ba8:	48 89 d6             	mov    %rdx,%rsi
  802bab:	89 c7                	mov    %eax,%edi
  802bad:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802bb4:	00 00 00 
  802bb7:	ff d0                	callq  *%rax
  802bb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc0:	78 24                	js     802be6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc6:	8b 00                	mov    (%rax),%eax
  802bc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bcc:	48 89 d6             	mov    %rdx,%rsi
  802bcf:	89 c7                	mov    %eax,%edi
  802bd1:	48 b8 b5 28 80 00 00 	movabs $0x8028b5,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
  802bdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be4:	79 05                	jns    802beb <read+0x5d>
		return r;
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	eb 76                	jmp    802c61 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802beb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bef:	8b 40 08             	mov    0x8(%rax),%eax
  802bf2:	83 e0 03             	and    $0x3,%eax
  802bf5:	83 f8 01             	cmp    $0x1,%eax
  802bf8:	75 3a                	jne    802c34 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bfa:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c01:	00 00 00 
  802c04:	48 8b 00             	mov    (%rax),%rax
  802c07:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c0d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c10:	89 c6                	mov    %eax,%esi
  802c12:	48 bf 2f 52 80 00 00 	movabs $0x80522f,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	48 b9 28 0b 80 00 00 	movabs $0x800b28,%rcx
  802c28:	00 00 00 
  802c2b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c32:	eb 2d                	jmp    802c61 <read+0xd3>
	}
	if (!dev->dev_read)
  802c34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c38:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c3c:	48 85 c0             	test   %rax,%rax
  802c3f:	75 07                	jne    802c48 <read+0xba>
		return -E_NOT_SUPP;
  802c41:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c46:	eb 19                	jmp    802c61 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c50:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c58:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c5c:	48 89 cf             	mov    %rcx,%rdi
  802c5f:	ff d0                	callq  *%rax
}
  802c61:	c9                   	leaveq 
  802c62:	c3                   	retq   

0000000000802c63 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c63:	55                   	push   %rbp
  802c64:	48 89 e5             	mov    %rsp,%rbp
  802c67:	48 83 ec 30          	sub    $0x30,%rsp
  802c6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c7d:	eb 49                	jmp    802cc8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c82:	48 98                	cltq   
  802c84:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c88:	48 29 c2             	sub    %rax,%rdx
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	48 63 c8             	movslq %eax,%rcx
  802c91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c95:	48 01 c1             	add    %rax,%rcx
  802c98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c9b:	48 89 ce             	mov    %rcx,%rsi
  802c9e:	89 c7                	mov    %eax,%edi
  802ca0:	48 b8 8e 2b 80 00 00 	movabs $0x802b8e,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
  802cac:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802caf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cb3:	79 05                	jns    802cba <readn+0x57>
			return m;
  802cb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb8:	eb 1c                	jmp    802cd6 <readn+0x73>
		if (m == 0)
  802cba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cbe:	75 02                	jne    802cc2 <readn+0x5f>
			break;
  802cc0:	eb 11                	jmp    802cd3 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802cc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc5:	01 45 fc             	add    %eax,-0x4(%rbp)
  802cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccb:	48 98                	cltq   
  802ccd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cd1:	72 ac                	jb     802c7f <readn+0x1c>
	}
	return tot;
  802cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cd6:	c9                   	leaveq 
  802cd7:	c3                   	retq   

0000000000802cd8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cd8:	55                   	push   %rbp
  802cd9:	48 89 e5             	mov    %rsp,%rbp
  802cdc:	48 83 ec 40          	sub    $0x40,%rsp
  802ce0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ce3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ce7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ceb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf2:	48 89 d6             	mov    %rdx,%rsi
  802cf5:	89 c7                	mov    %eax,%edi
  802cf7:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
  802d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0a:	78 24                	js     802d30 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d10:	8b 00                	mov    (%rax),%eax
  802d12:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d16:	48 89 d6             	mov    %rdx,%rsi
  802d19:	89 c7                	mov    %eax,%edi
  802d1b:	48 b8 b5 28 80 00 00 	movabs $0x8028b5,%rax
  802d22:	00 00 00 
  802d25:	ff d0                	callq  *%rax
  802d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2e:	79 05                	jns    802d35 <write+0x5d>
		return r;
  802d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d33:	eb 75                	jmp    802daa <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d39:	8b 40 08             	mov    0x8(%rax),%eax
  802d3c:	83 e0 03             	and    $0x3,%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	75 3a                	jne    802d7d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d43:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802d4a:	00 00 00 
  802d4d:	48 8b 00             	mov    (%rax),%rax
  802d50:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d56:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d59:	89 c6                	mov    %eax,%esi
  802d5b:	48 bf 4b 52 80 00 00 	movabs $0x80524b,%rdi
  802d62:	00 00 00 
  802d65:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6a:	48 b9 28 0b 80 00 00 	movabs $0x800b28,%rcx
  802d71:	00 00 00 
  802d74:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d7b:	eb 2d                	jmp    802daa <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d81:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d85:	48 85 c0             	test   %rax,%rax
  802d88:	75 07                	jne    802d91 <write+0xb9>
		return -E_NOT_SUPP;
  802d8a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d8f:	eb 19                	jmp    802daa <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d95:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d9d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802da1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802da5:	48 89 cf             	mov    %rcx,%rdi
  802da8:	ff d0                	callq  *%rax
}
  802daa:	c9                   	leaveq 
  802dab:	c3                   	retq   

0000000000802dac <seek>:

int
seek(int fdnum, off_t offset)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 18          	sub    $0x18,%rsp
  802db4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc1:	48 89 d6             	mov    %rdx,%rsi
  802dc4:	89 c7                	mov    %eax,%edi
  802dc6:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
  802dd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd9:	79 05                	jns    802de0 <seek+0x34>
		return r;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	eb 0f                	jmp    802def <seek+0x43>
	fd->fd_offset = offset;
  802de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802def:	c9                   	leaveq 
  802df0:	c3                   	retq   

0000000000802df1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802df1:	55                   	push   %rbp
  802df2:	48 89 e5             	mov    %rsp,%rbp
  802df5:	48 83 ec 30          	sub    $0x30,%rsp
  802df9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dfc:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e06:	48 89 d6             	mov    %rdx,%rsi
  802e09:	89 c7                	mov    %eax,%edi
  802e0b:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1e:	78 24                	js     802e44 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e24:	8b 00                	mov    (%rax),%eax
  802e26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e2a:	48 89 d6             	mov    %rdx,%rsi
  802e2d:	89 c7                	mov    %eax,%edi
  802e2f:	48 b8 b5 28 80 00 00 	movabs $0x8028b5,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
  802e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e42:	79 05                	jns    802e49 <ftruncate+0x58>
		return r;
  802e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e47:	eb 72                	jmp    802ebb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4d:	8b 40 08             	mov    0x8(%rax),%eax
  802e50:	83 e0 03             	and    $0x3,%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	75 3a                	jne    802e91 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e57:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802e5e:	00 00 00 
  802e61:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e64:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e6a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e6d:	89 c6                	mov    %eax,%esi
  802e6f:	48 bf 68 52 80 00 00 	movabs $0x805268,%rdi
  802e76:	00 00 00 
  802e79:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7e:	48 b9 28 0b 80 00 00 	movabs $0x800b28,%rcx
  802e85:	00 00 00 
  802e88:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e8f:	eb 2a                	jmp    802ebb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e95:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e99:	48 85 c0             	test   %rax,%rax
  802e9c:	75 07                	jne    802ea5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e9e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ea3:	eb 16                	jmp    802ebb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea9:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ead:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eb1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802eb4:	89 ce                	mov    %ecx,%esi
  802eb6:	48 89 d7             	mov    %rdx,%rdi
  802eb9:	ff d0                	callq  *%rax
}
  802ebb:	c9                   	leaveq 
  802ebc:	c3                   	retq   

0000000000802ebd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ebd:	55                   	push   %rbp
  802ebe:	48 89 e5             	mov    %rsp,%rbp
  802ec1:	48 83 ec 30          	sub    $0x30,%rsp
  802ec5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ec8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ecc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ed0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ed3:	48 89 d6             	mov    %rdx,%rsi
  802ed6:	89 c7                	mov    %eax,%edi
  802ed8:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802edf:	00 00 00 
  802ee2:	ff d0                	callq  *%rax
  802ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eeb:	78 24                	js     802f11 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef1:	8b 00                	mov    (%rax),%eax
  802ef3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ef7:	48 89 d6             	mov    %rdx,%rsi
  802efa:	89 c7                	mov    %eax,%edi
  802efc:	48 b8 b5 28 80 00 00 	movabs $0x8028b5,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
  802f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0f:	79 05                	jns    802f16 <fstat+0x59>
		return r;
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	eb 5e                	jmp    802f74 <fstat+0xb7>
	if (!dev->dev_stat)
  802f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f1e:	48 85 c0             	test   %rax,%rax
  802f21:	75 07                	jne    802f2a <fstat+0x6d>
		return -E_NOT_SUPP;
  802f23:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f28:	eb 4a                	jmp    802f74 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f2e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f35:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f3c:	00 00 00 
	stat->st_isdir = 0;
  802f3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f43:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f4a:	00 00 00 
	stat->st_dev = dev;
  802f4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f55:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f60:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f68:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f6c:	48 89 ce             	mov    %rcx,%rsi
  802f6f:	48 89 d7             	mov    %rdx,%rdi
  802f72:	ff d0                	callq  *%rax
}
  802f74:	c9                   	leaveq 
  802f75:	c3                   	retq   

0000000000802f76 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f76:	55                   	push   %rbp
  802f77:	48 89 e5             	mov    %rsp,%rbp
  802f7a:	48 83 ec 20          	sub    $0x20,%rsp
  802f7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8a:	be 00 00 00 00       	mov    $0x0,%esi
  802f8f:	48 89 c7             	mov    %rax,%rdi
  802f92:	48 b8 66 30 80 00 00 	movabs $0x803066,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
  802f9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa5:	79 05                	jns    802fac <stat+0x36>
		return fd;
  802fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faa:	eb 2f                	jmp    802fdb <stat+0x65>
	r = fstat(fd, stat);
  802fac:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb3:	48 89 d6             	mov    %rdx,%rsi
  802fb6:	89 c7                	mov    %eax,%edi
  802fb8:	48 b8 bd 2e 80 00 00 	movabs $0x802ebd,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
  802fc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fca:	89 c7                	mov    %eax,%edi
  802fcc:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
	return r;
  802fd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fdb:	c9                   	leaveq 
  802fdc:	c3                   	retq   

0000000000802fdd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fdd:	55                   	push   %rbp
  802fde:	48 89 e5             	mov    %rsp,%rbp
  802fe1:	48 83 ec 10          	sub    $0x10,%rsp
  802fe5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fe8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802fec:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ff3:	00 00 00 
  802ff6:	8b 00                	mov    (%rax),%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	75 1f                	jne    80301b <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ffc:	bf 01 00 00 00       	mov    $0x1,%edi
  803001:	48 b8 02 26 80 00 00 	movabs $0x802602,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax
  80300d:	89 c2                	mov    %eax,%edx
  80300f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803016:	00 00 00 
  803019:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80301b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803022:	00 00 00 
  803025:	8b 00                	mov    (%rax),%eax
  803027:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80302a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80302f:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803036:	00 00 00 
  803039:	89 c7                	mov    %eax,%edi
  80303b:	48 b8 75 24 80 00 00 	movabs $0x802475,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304b:	ba 00 00 00 00       	mov    $0x0,%edx
  803050:	48 89 c6             	mov    %rax,%rsi
  803053:	bf 00 00 00 00       	mov    $0x0,%edi
  803058:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  80305f:	00 00 00 
  803062:	ff d0                	callq  *%rax
}
  803064:	c9                   	leaveq 
  803065:	c3                   	retq   

0000000000803066 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803066:	55                   	push   %rbp
  803067:	48 89 e5             	mov    %rsp,%rbp
  80306a:	48 83 ec 10          	sub    $0x10,%rsp
  80306e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803072:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  803075:	48 ba 8e 52 80 00 00 	movabs $0x80528e,%rdx
  80307c:	00 00 00 
  80307f:	be 4c 00 00 00       	mov    $0x4c,%esi
  803084:	48 bf a3 52 80 00 00 	movabs $0x8052a3,%rdi
  80308b:	00 00 00 
  80308e:	b8 00 00 00 00       	mov    $0x0,%eax
  803093:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  80309a:	00 00 00 
  80309d:	ff d1                	callq  *%rcx

000000000080309f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 10          	sub    $0x10,%rsp
  8030a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030af:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030b9:	00 00 00 
  8030bc:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030be:	be 00 00 00 00       	mov    $0x0,%esi
  8030c3:	bf 06 00 00 00       	mov    $0x6,%edi
  8030c8:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
}
  8030d4:	c9                   	leaveq 
  8030d5:	c3                   	retq   

00000000008030d6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030d6:	55                   	push   %rbp
  8030d7:	48 89 e5             	mov    %rsp,%rbp
  8030da:	48 83 ec 20          	sub    $0x20,%rsp
  8030de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8030ea:	48 ba ae 52 80 00 00 	movabs $0x8052ae,%rdx
  8030f1:	00 00 00 
  8030f4:	be 6b 00 00 00       	mov    $0x6b,%esi
  8030f9:	48 bf a3 52 80 00 00 	movabs $0x8052a3,%rdi
  803100:	00 00 00 
  803103:	b8 00 00 00 00       	mov    $0x0,%eax
  803108:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  80310f:	00 00 00 
  803112:	ff d1                	callq  *%rcx

0000000000803114 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803114:	55                   	push   %rbp
  803115:	48 89 e5             	mov    %rsp,%rbp
  803118:	48 83 ec 20          	sub    $0x20,%rsp
  80311c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803120:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803124:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  803128:	48 ba cb 52 80 00 00 	movabs $0x8052cb,%rdx
  80312f:	00 00 00 
  803132:	be 7b 00 00 00       	mov    $0x7b,%esi
  803137:	48 bf a3 52 80 00 00 	movabs $0x8052a3,%rdi
  80313e:	00 00 00 
  803141:	b8 00 00 00 00       	mov    $0x0,%eax
  803146:	48 b9 ef 08 80 00 00 	movabs $0x8008ef,%rcx
  80314d:	00 00 00 
  803150:	ff d1                	callq  *%rcx

0000000000803152 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803152:	55                   	push   %rbp
  803153:	48 89 e5             	mov    %rsp,%rbp
  803156:	48 83 ec 20          	sub    $0x20,%rsp
  80315a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80315e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803162:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803166:	8b 50 0c             	mov    0xc(%rax),%edx
  803169:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803170:	00 00 00 
  803173:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803175:	be 00 00 00 00       	mov    $0x0,%esi
  80317a:	bf 05 00 00 00       	mov    $0x5,%edi
  80317f:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
  80318b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803192:	79 05                	jns    803199 <devfile_stat+0x47>
		return r;
  803194:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803197:	eb 56                	jmp    8031ef <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803199:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031a4:	00 00 00 
  8031a7:	48 89 c7             	mov    %rax,%rdi
  8031aa:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031bd:	00 00 00 
  8031c0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ca:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031d0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031d7:	00 00 00 
  8031da:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ef:	c9                   	leaveq 
  8031f0:	c3                   	retq   

00000000008031f1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031f1:	55                   	push   %rbp
  8031f2:	48 89 e5             	mov    %rsp,%rbp
  8031f5:	48 83 ec 10          	sub    $0x10,%rsp
  8031f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031fd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803204:	8b 50 0c             	mov    0xc(%rax),%edx
  803207:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320e:	00 00 00 
  803211:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803213:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80321a:	00 00 00 
  80321d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803220:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803223:	be 00 00 00 00       	mov    $0x0,%esi
  803228:	bf 02 00 00 00       	mov    $0x2,%edi
  80322d:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  803234:	00 00 00 
  803237:	ff d0                	callq  *%rax
}
  803239:	c9                   	leaveq 
  80323a:	c3                   	retq   

000000000080323b <remove>:

// Delete a file
int
remove(const char *path)
{
  80323b:	55                   	push   %rbp
  80323c:	48 89 e5             	mov    %rsp,%rbp
  80323f:	48 83 ec 10          	sub    $0x10,%rsp
  803243:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324b:	48 89 c7             	mov    %rax,%rdi
  80324e:	48 b8 56 16 80 00 00 	movabs $0x801656,%rax
  803255:	00 00 00 
  803258:	ff d0                	callq  *%rax
  80325a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80325f:	7e 07                	jle    803268 <remove+0x2d>
		return -E_BAD_PATH;
  803261:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803266:	eb 33                	jmp    80329b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326c:	48 89 c6             	mov    %rax,%rsi
  80326f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803276:	00 00 00 
  803279:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803285:	be 00 00 00 00       	mov    $0x0,%esi
  80328a:	bf 07 00 00 00       	mov    $0x7,%edi
  80328f:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032a1:	be 00 00 00 00       	mov    $0x0,%esi
  8032a6:	bf 08 00 00 00       	mov    $0x8,%edi
  8032ab:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
}
  8032b7:	5d                   	pop    %rbp
  8032b8:	c3                   	retq   

00000000008032b9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032b9:	55                   	push   %rbp
  8032ba:	48 89 e5             	mov    %rsp,%rbp
  8032bd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032c4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032cb:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032d2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032d9:	be 00 00 00 00       	mov    $0x0,%esi
  8032de:	48 89 c7             	mov    %rax,%rdi
  8032e1:	48 b8 66 30 80 00 00 	movabs $0x803066,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f4:	79 28                	jns    80331e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f9:	89 c6                	mov    %eax,%esi
  8032fb:	48 bf e9 52 80 00 00 	movabs $0x8052e9,%rdi
  803302:	00 00 00 
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  803311:	00 00 00 
  803314:	ff d2                	callq  *%rdx
		return fd_src;
  803316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803319:	e9 74 01 00 00       	jmpq   803492 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80331e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803325:	be 01 01 00 00       	mov    $0x101,%esi
  80332a:	48 89 c7             	mov    %rax,%rdi
  80332d:	48 b8 66 30 80 00 00 	movabs $0x803066,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
  803339:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80333c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803340:	79 39                	jns    80337b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803342:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803345:	89 c6                	mov    %eax,%esi
  803347:	48 bf ff 52 80 00 00 	movabs $0x8052ff,%rdi
  80334e:	00 00 00 
  803351:	b8 00 00 00 00       	mov    $0x0,%eax
  803356:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  80335d:	00 00 00 
  803360:	ff d2                	callq  *%rdx
		close(fd_src);
  803362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803365:	89 c7                	mov    %eax,%edi
  803367:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
		return fd_dest;
  803373:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803376:	e9 17 01 00 00       	jmpq   803492 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80337b:	eb 74                	jmp    8033f1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80337d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803380:	48 63 d0             	movslq %eax,%rdx
  803383:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80338a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80338d:	48 89 ce             	mov    %rcx,%rsi
  803390:	89 c7                	mov    %eax,%edi
  803392:	48 b8 d8 2c 80 00 00 	movabs $0x802cd8,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
  80339e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033a5:	79 4a                	jns    8033f1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033a7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033aa:	89 c6                	mov    %eax,%esi
  8033ac:	48 bf 19 53 80 00 00 	movabs $0x805319,%rdi
  8033b3:	00 00 00 
  8033b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bb:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  8033c2:	00 00 00 
  8033c5:	ff d2                	callq  *%rdx
			close(fd_src);
  8033c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ca:	89 c7                	mov    %eax,%edi
  8033cc:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
			close(fd_dest);
  8033d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033db:	89 c7                	mov    %eax,%edi
  8033dd:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
			return write_size;
  8033e9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033ec:	e9 a1 00 00 00       	jmpq   803492 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033f1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	ba 00 02 00 00       	mov    $0x200,%edx
  803400:	48 89 ce             	mov    %rcx,%rsi
  803403:	89 c7                	mov    %eax,%edi
  803405:	48 b8 8e 2b 80 00 00 	movabs $0x802b8e,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
  803411:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803414:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803418:	0f 8f 5f ff ff ff    	jg     80337d <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  80341e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803422:	79 47                	jns    80346b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803427:	89 c6                	mov    %eax,%esi
  803429:	48 bf 2c 53 80 00 00 	movabs $0x80532c,%rdi
  803430:	00 00 00 
  803433:	b8 00 00 00 00       	mov    $0x0,%eax
  803438:	48 ba 28 0b 80 00 00 	movabs $0x800b28,%rdx
  80343f:	00 00 00 
  803442:	ff d2                	callq  *%rdx
		close(fd_src);
  803444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803447:	89 c7                	mov    %eax,%edi
  803449:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  803450:	00 00 00 
  803453:	ff d0                	callq  *%rax
		close(fd_dest);
  803455:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803458:	89 c7                	mov    %eax,%edi
  80345a:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
		return read_size;
  803466:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803469:	eb 27                	jmp    803492 <copy+0x1d9>
	}
	close(fd_src);
  80346b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346e:	89 c7                	mov    %eax,%edi
  803470:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
	close(fd_dest);
  80347c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80347f:	89 c7                	mov    %eax,%edi
  803481:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  803488:	00 00 00 
  80348b:	ff d0                	callq  *%rax
	return 0;
  80348d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803492:	c9                   	leaveq 
  803493:	c3                   	retq   

0000000000803494 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803494:	55                   	push   %rbp
  803495:	48 89 e5             	mov    %rsp,%rbp
  803498:	48 83 ec 20          	sub    $0x20,%rsp
  80349c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80349f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034a6:	48 89 d6             	mov    %rdx,%rsi
  8034a9:	89 c7                	mov    %eax,%edi
  8034ab:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034be:	79 05                	jns    8034c5 <fd2sockid+0x31>
		return r;
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c3:	eb 24                	jmp    8034e9 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c9:	8b 10                	mov    (%rax),%edx
  8034cb:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8034d2:	00 00 00 
  8034d5:	8b 00                	mov    (%rax),%eax
  8034d7:	39 c2                	cmp    %eax,%edx
  8034d9:	74 07                	je     8034e2 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034e0:	eb 07                	jmp    8034e9 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e6:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034e9:	c9                   	leaveq 
  8034ea:	c3                   	retq   

00000000008034eb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034eb:	55                   	push   %rbp
  8034ec:	48 89 e5             	mov    %rsp,%rbp
  8034ef:	48 83 ec 20          	sub    $0x20,%rsp
  8034f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8034f6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034fa:	48 89 c7             	mov    %rax,%rdi
  8034fd:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
  803509:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803510:	78 26                	js     803538 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803516:	ba 07 04 00 00       	mov    $0x407,%edx
  80351b:	48 89 c6             	mov    %rax,%rsi
  80351e:	bf 00 00 00 00       	mov    $0x0,%edi
  803523:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
  80352f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803532:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803536:	79 16                	jns    80354e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803538:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80353b:	89 c7                	mov    %eax,%edi
  80353d:	48 b8 fa 39 80 00 00 	movabs $0x8039fa,%rax
  803544:	00 00 00 
  803547:	ff d0                	callq  *%rax
		return r;
  803549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354c:	eb 3a                	jmp    803588 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80354e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803552:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803559:	00 00 00 
  80355c:	8b 12                	mov    (%rdx),%edx
  80355e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803564:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80356b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803572:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803579:	48 89 c7             	mov    %rax,%rdi
  80357c:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
}
  803588:	c9                   	leaveq 
  803589:	c3                   	retq   

000000000080358a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80358a:	55                   	push   %rbp
  80358b:	48 89 e5             	mov    %rsp,%rbp
  80358e:	48 83 ec 30          	sub    $0x30,%rsp
  803592:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803595:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803599:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80359d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a0:	89 c7                	mov    %eax,%edi
  8035a2:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
  8035ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b5:	79 05                	jns    8035bc <accept+0x32>
		return r;
  8035b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ba:	eb 3b                	jmp    8035f7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035bc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c7:	48 89 ce             	mov    %rcx,%rsi
  8035ca:	89 c7                	mov    %eax,%edi
  8035cc:	48 b8 d7 38 80 00 00 	movabs $0x8038d7,%rax
  8035d3:	00 00 00 
  8035d6:	ff d0                	callq  *%rax
  8035d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035df:	79 05                	jns    8035e6 <accept+0x5c>
		return r;
  8035e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e4:	eb 11                	jmp    8035f7 <accept+0x6d>
	return alloc_sockfd(r);
  8035e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e9:	89 c7                	mov    %eax,%edi
  8035eb:	48 b8 eb 34 80 00 00 	movabs $0x8034eb,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
}
  8035f7:	c9                   	leaveq 
  8035f8:	c3                   	retq   

00000000008035f9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035f9:	55                   	push   %rbp
  8035fa:	48 89 e5             	mov    %rsp,%rbp
  8035fd:	48 83 ec 20          	sub    $0x20,%rsp
  803601:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803604:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803608:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80360b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80360e:	89 c7                	mov    %eax,%edi
  803610:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80361f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803623:	79 05                	jns    80362a <bind+0x31>
		return r;
  803625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803628:	eb 1b                	jmp    803645 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80362a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80362d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803634:	48 89 ce             	mov    %rcx,%rsi
  803637:	89 c7                	mov    %eax,%edi
  803639:	48 b8 56 39 80 00 00 	movabs $0x803956,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
}
  803645:	c9                   	leaveq 
  803646:	c3                   	retq   

0000000000803647 <shutdown>:

int
shutdown(int s, int how)
{
  803647:	55                   	push   %rbp
  803648:	48 89 e5             	mov    %rsp,%rbp
  80364b:	48 83 ec 20          	sub    $0x20,%rsp
  80364f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803652:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803655:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803658:	89 c7                	mov    %eax,%edi
  80365a:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366d:	79 05                	jns    803674 <shutdown+0x2d>
		return r;
  80366f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803672:	eb 16                	jmp    80368a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803674:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367a:	89 d6                	mov    %edx,%esi
  80367c:	89 c7                	mov    %eax,%edi
  80367e:	48 b8 ba 39 80 00 00 	movabs $0x8039ba,%rax
  803685:	00 00 00 
  803688:	ff d0                	callq  *%rax
}
  80368a:	c9                   	leaveq 
  80368b:	c3                   	retq   

000000000080368c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80368c:	55                   	push   %rbp
  80368d:	48 89 e5             	mov    %rsp,%rbp
  803690:	48 83 ec 10          	sub    $0x10,%rsp
  803694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803698:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369c:	48 89 c7             	mov    %rax,%rdi
  80369f:	48 b8 1c 45 80 00 00 	movabs $0x80451c,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
  8036ab:	83 f8 01             	cmp    $0x1,%eax
  8036ae:	75 17                	jne    8036c7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b4:	8b 40 0c             	mov    0xc(%rax),%eax
  8036b7:	89 c7                	mov    %eax,%edi
  8036b9:	48 b8 fa 39 80 00 00 	movabs $0x8039fa,%rax
  8036c0:	00 00 00 
  8036c3:	ff d0                	callq  *%rax
  8036c5:	eb 05                	jmp    8036cc <devsock_close+0x40>
	else
		return 0;
  8036c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036cc:	c9                   	leaveq 
  8036cd:	c3                   	retq   

00000000008036ce <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036ce:	55                   	push   %rbp
  8036cf:	48 89 e5             	mov    %rsp,%rbp
  8036d2:	48 83 ec 20          	sub    $0x20,%rsp
  8036d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036dd:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e3:	89 c7                	mov    %eax,%edi
  8036e5:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f8:	79 05                	jns    8036ff <connect+0x31>
		return r;
  8036fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fd:	eb 1b                	jmp    80371a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8036ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803702:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803709:	48 89 ce             	mov    %rcx,%rsi
  80370c:	89 c7                	mov    %eax,%edi
  80370e:	48 b8 27 3a 80 00 00 	movabs $0x803a27,%rax
  803715:	00 00 00 
  803718:	ff d0                	callq  *%rax
}
  80371a:	c9                   	leaveq 
  80371b:	c3                   	retq   

000000000080371c <listen>:

int
listen(int s, int backlog)
{
  80371c:	55                   	push   %rbp
  80371d:	48 89 e5             	mov    %rsp,%rbp
  803720:	48 83 ec 20          	sub    $0x20,%rsp
  803724:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803727:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80372a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372d:	89 c7                	mov    %eax,%edi
  80372f:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  803736:	00 00 00 
  803739:	ff d0                	callq  *%rax
  80373b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803742:	79 05                	jns    803749 <listen+0x2d>
		return r;
  803744:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803747:	eb 16                	jmp    80375f <listen+0x43>
	return nsipc_listen(r, backlog);
  803749:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80374c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374f:	89 d6                	mov    %edx,%esi
  803751:	89 c7                	mov    %eax,%edi
  803753:	48 b8 8b 3a 80 00 00 	movabs $0x803a8b,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
}
  80375f:	c9                   	leaveq 
  803760:	c3                   	retq   

0000000000803761 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803761:	55                   	push   %rbp
  803762:	48 89 e5             	mov    %rsp,%rbp
  803765:	48 83 ec 20          	sub    $0x20,%rsp
  803769:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80376d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803771:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803779:	89 c2                	mov    %eax,%edx
  80377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377f:	8b 40 0c             	mov    0xc(%rax),%eax
  803782:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803786:	b9 00 00 00 00       	mov    $0x0,%ecx
  80378b:	89 c7                	mov    %eax,%edi
  80378d:	48 b8 cb 3a 80 00 00 	movabs $0x803acb,%rax
  803794:	00 00 00 
  803797:	ff d0                	callq  *%rax
}
  803799:	c9                   	leaveq 
  80379a:	c3                   	retq   

000000000080379b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80379b:	55                   	push   %rbp
  80379c:	48 89 e5             	mov    %rsp,%rbp
  80379f:	48 83 ec 20          	sub    $0x20,%rsp
  8037a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b3:	89 c2                	mov    %eax,%edx
  8037b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b9:	8b 40 0c             	mov    0xc(%rax),%eax
  8037bc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037c5:	89 c7                	mov    %eax,%edi
  8037c7:	48 b8 97 3b 80 00 00 	movabs $0x803b97,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   

00000000008037d5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037d5:	55                   	push   %rbp
  8037d6:	48 89 e5             	mov    %rsp,%rbp
  8037d9:	48 83 ec 10          	sub    $0x10,%rsp
  8037dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e9:	48 be 47 53 80 00 00 	movabs $0x805347,%rsi
  8037f0:	00 00 00 
  8037f3:	48 89 c7             	mov    %rax,%rdi
  8037f6:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
	return 0;
  803802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803807:	c9                   	leaveq 
  803808:	c3                   	retq   

0000000000803809 <socket>:

int
socket(int domain, int type, int protocol)
{
  803809:	55                   	push   %rbp
  80380a:	48 89 e5             	mov    %rsp,%rbp
  80380d:	48 83 ec 20          	sub    $0x20,%rsp
  803811:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803814:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803817:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80381a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80381d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803820:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803823:	89 ce                	mov    %ecx,%esi
  803825:	89 c7                	mov    %eax,%edi
  803827:	48 b8 4f 3c 80 00 00 	movabs $0x803c4f,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
  803833:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803836:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383a:	79 05                	jns    803841 <socket+0x38>
		return r;
  80383c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383f:	eb 11                	jmp    803852 <socket+0x49>
	return alloc_sockfd(r);
  803841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803844:	89 c7                	mov    %eax,%edi
  803846:	48 b8 eb 34 80 00 00 	movabs $0x8034eb,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
}
  803852:	c9                   	leaveq 
  803853:	c3                   	retq   

0000000000803854 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803854:	55                   	push   %rbp
  803855:	48 89 e5             	mov    %rsp,%rbp
  803858:	48 83 ec 10          	sub    $0x10,%rsp
  80385c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80385f:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803866:	00 00 00 
  803869:	8b 00                	mov    (%rax),%eax
  80386b:	85 c0                	test   %eax,%eax
  80386d:	75 1f                	jne    80388e <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80386f:	bf 02 00 00 00       	mov    $0x2,%edi
  803874:	48 b8 02 26 80 00 00 	movabs $0x802602,%rax
  80387b:	00 00 00 
  80387e:	ff d0                	callq  *%rax
  803880:	89 c2                	mov    %eax,%edx
  803882:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803889:	00 00 00 
  80388c:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80388e:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803895:	00 00 00 
  803898:	8b 00                	mov    (%rax),%eax
  80389a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80389d:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038a2:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8038a9:	00 00 00 
  8038ac:	89 c7                	mov    %eax,%edi
  8038ae:	48 b8 75 24 80 00 00 	movabs $0x802475,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8038bf:	be 00 00 00 00       	mov    $0x0,%esi
  8038c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c9:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 30          	sub    $0x30,%rsp
  8038df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038ea:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038f1:	00 00 00 
  8038f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038f7:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038f9:	bf 01 00 00 00       	mov    $0x1,%edi
  8038fe:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80390d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803911:	78 3e                	js     803951 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803913:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80391a:	00 00 00 
  80391d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803925:	8b 40 10             	mov    0x10(%rax),%eax
  803928:	89 c2                	mov    %eax,%edx
  80392a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80392e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803932:	48 89 ce             	mov    %rcx,%rsi
  803935:	48 89 c7             	mov    %rax,%rdi
  803938:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803948:	8b 50 10             	mov    0x10(%rax),%edx
  80394b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80394f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803951:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803954:	c9                   	leaveq 
  803955:	c3                   	retq   

0000000000803956 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803956:	55                   	push   %rbp
  803957:	48 89 e5             	mov    %rsp,%rbp
  80395a:	48 83 ec 10          	sub    $0x10,%rsp
  80395e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803961:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803965:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803968:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80396f:	00 00 00 
  803972:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803975:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803977:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80397a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397e:	48 89 c6             	mov    %rax,%rsi
  803981:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803988:	00 00 00 
  80398b:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  803992:	00 00 00 
  803995:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803997:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80399e:	00 00 00 
  8039a1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039a4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039a7:	bf 02 00 00 00       	mov    $0x2,%edi
  8039ac:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  8039b3:	00 00 00 
  8039b6:	ff d0                	callq  *%rax
}
  8039b8:	c9                   	leaveq 
  8039b9:	c3                   	retq   

00000000008039ba <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039ba:	55                   	push   %rbp
  8039bb:	48 89 e5             	mov    %rsp,%rbp
  8039be:	48 83 ec 10          	sub    $0x10,%rsp
  8039c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039c5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039c8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039cf:	00 00 00 
  8039d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039d5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039d7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039de:	00 00 00 
  8039e1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039e4:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039e7:	bf 03 00 00 00       	mov    $0x3,%edi
  8039ec:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
}
  8039f8:	c9                   	leaveq 
  8039f9:	c3                   	retq   

00000000008039fa <nsipc_close>:

int
nsipc_close(int s)
{
  8039fa:	55                   	push   %rbp
  8039fb:	48 89 e5             	mov    %rsp,%rbp
  8039fe:	48 83 ec 10          	sub    $0x10,%rsp
  803a02:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a05:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a0c:	00 00 00 
  803a0f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a12:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a14:	bf 04 00 00 00       	mov    $0x4,%edi
  803a19:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803a20:	00 00 00 
  803a23:	ff d0                	callq  *%rax
}
  803a25:	c9                   	leaveq 
  803a26:	c3                   	retq   

0000000000803a27 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a27:	55                   	push   %rbp
  803a28:	48 89 e5             	mov    %rsp,%rbp
  803a2b:	48 83 ec 10          	sub    $0x10,%rsp
  803a2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a36:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a39:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a40:	00 00 00 
  803a43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a46:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a48:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4f:	48 89 c6             	mov    %rax,%rsi
  803a52:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a59:	00 00 00 
  803a5c:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a68:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a6f:	00 00 00 
  803a72:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a75:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a78:	bf 05 00 00 00       	mov    $0x5,%edi
  803a7d:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803a84:	00 00 00 
  803a87:	ff d0                	callq  *%rax
}
  803a89:	c9                   	leaveq 
  803a8a:	c3                   	retq   

0000000000803a8b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a8b:	55                   	push   %rbp
  803a8c:	48 89 e5             	mov    %rsp,%rbp
  803a8f:	48 83 ec 10          	sub    $0x10,%rsp
  803a93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a96:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a99:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa0:	00 00 00 
  803aa3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aa6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803aa8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aaf:	00 00 00 
  803ab2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ab5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ab8:	bf 06 00 00 00       	mov    $0x6,%edi
  803abd:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803ac4:	00 00 00 
  803ac7:	ff d0                	callq  *%rax
}
  803ac9:	c9                   	leaveq 
  803aca:	c3                   	retq   

0000000000803acb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803acb:	55                   	push   %rbp
  803acc:	48 89 e5             	mov    %rsp,%rbp
  803acf:	48 83 ec 30          	sub    $0x30,%rsp
  803ad3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ad6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ada:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803add:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803ae0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae7:	00 00 00 
  803aea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803aed:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803aef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803af6:	00 00 00 
  803af9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803afc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803aff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b06:	00 00 00 
  803b09:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b0c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b0f:	bf 07 00 00 00       	mov    $0x7,%edi
  803b14:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803b1b:	00 00 00 
  803b1e:	ff d0                	callq  *%rax
  803b20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b27:	78 69                	js     803b92 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b29:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b30:	7f 08                	jg     803b3a <nsipc_recv+0x6f>
  803b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b35:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b38:	7e 35                	jle    803b6f <nsipc_recv+0xa4>
  803b3a:	48 b9 4e 53 80 00 00 	movabs $0x80534e,%rcx
  803b41:	00 00 00 
  803b44:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  803b4b:	00 00 00 
  803b4e:	be 61 00 00 00       	mov    $0x61,%esi
  803b53:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  803b5a:	00 00 00 
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b62:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  803b69:	00 00 00 
  803b6c:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b72:	48 63 d0             	movslq %eax,%rdx
  803b75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b79:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803b80:	00 00 00 
  803b83:	48 89 c7             	mov    %rax,%rdi
  803b86:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
	}

	return r;
  803b92:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b95:	c9                   	leaveq 
  803b96:	c3                   	retq   

0000000000803b97 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b97:	55                   	push   %rbp
  803b98:	48 89 e5             	mov    %rsp,%rbp
  803b9b:	48 83 ec 20          	sub    $0x20,%rsp
  803b9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ba6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803ba9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803bac:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb3:	00 00 00 
  803bb6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bb9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803bbb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bc2:	7e 35                	jle    803bf9 <nsipc_send+0x62>
  803bc4:	48 b9 84 53 80 00 00 	movabs $0x805384,%rcx
  803bcb:	00 00 00 
  803bce:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  803bd5:	00 00 00 
  803bd8:	be 6c 00 00 00       	mov    $0x6c,%esi
  803bdd:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  803be4:	00 00 00 
  803be7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bec:	49 b8 ef 08 80 00 00 	movabs $0x8008ef,%r8
  803bf3:	00 00 00 
  803bf6:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bf9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bfc:	48 63 d0             	movslq %eax,%rdx
  803bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c03:	48 89 c6             	mov    %rax,%rsi
  803c06:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c0d:	00 00 00 
  803c10:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  803c17:	00 00 00 
  803c1a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c1c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c23:	00 00 00 
  803c26:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c29:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c2c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c33:	00 00 00 
  803c36:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c39:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c3c:	bf 08 00 00 00       	mov    $0x8,%edi
  803c41:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803c48:	00 00 00 
  803c4b:	ff d0                	callq  *%rax
}
  803c4d:	c9                   	leaveq 
  803c4e:	c3                   	retq   

0000000000803c4f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c4f:	55                   	push   %rbp
  803c50:	48 89 e5             	mov    %rsp,%rbp
  803c53:	48 83 ec 10          	sub    $0x10,%rsp
  803c57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c5a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c5d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c60:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c67:	00 00 00 
  803c6a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c6d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c6f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c76:	00 00 00 
  803c79:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c7c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c7f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c86:	00 00 00 
  803c89:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c8c:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c8f:	bf 09 00 00 00       	mov    $0x9,%edi
  803c94:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  803c9b:	00 00 00 
  803c9e:	ff d0                	callq  *%rax
}
  803ca0:	c9                   	leaveq 
  803ca1:	c3                   	retq   

0000000000803ca2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803ca2:	55                   	push   %rbp
  803ca3:	48 89 e5             	mov    %rsp,%rbp
  803ca6:	53                   	push   %rbx
  803ca7:	48 83 ec 38          	sub    $0x38,%rsp
  803cab:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803caf:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803cb3:	48 89 c7             	mov    %rax,%rdi
  803cb6:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
  803cc2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc9:	0f 88 bf 01 00 00    	js     803e8e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ccf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd3:	ba 07 04 00 00       	mov    $0x407,%edx
  803cd8:	48 89 c6             	mov    %rax,%rsi
  803cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce0:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  803ce7:	00 00 00 
  803cea:	ff d0                	callq  *%rax
  803cec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cf3:	0f 88 95 01 00 00    	js     803e8e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803cf9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803cfd:	48 89 c7             	mov    %rax,%rdi
  803d00:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  803d07:	00 00 00 
  803d0a:	ff d0                	callq  *%rax
  803d0c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d13:	0f 88 5d 01 00 00    	js     803e76 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d1d:	ba 07 04 00 00       	mov    $0x407,%edx
  803d22:	48 89 c6             	mov    %rax,%rsi
  803d25:	bf 00 00 00 00       	mov    $0x0,%edi
  803d2a:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  803d31:	00 00 00 
  803d34:	ff d0                	callq  *%rax
  803d36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d3d:	0f 88 33 01 00 00    	js     803e76 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d47:	48 89 c7             	mov    %rax,%rdi
  803d4a:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803d51:	00 00 00 
  803d54:	ff d0                	callq  *%rax
  803d56:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5e:	ba 07 04 00 00       	mov    $0x407,%edx
  803d63:	48 89 c6             	mov    %rax,%rsi
  803d66:	bf 00 00 00 00       	mov    $0x0,%edi
  803d6b:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  803d72:	00 00 00 
  803d75:	ff d0                	callq  *%rax
  803d77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d7e:	79 05                	jns    803d85 <pipe+0xe3>
		goto err2;
  803d80:	e9 d9 00 00 00       	jmpq   803e5e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d89:	48 89 c7             	mov    %rax,%rdi
  803d8c:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
  803d98:	48 89 c2             	mov    %rax,%rdx
  803d9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d9f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803da5:	48 89 d1             	mov    %rdx,%rcx
  803da8:	ba 00 00 00 00       	mov    $0x0,%edx
  803dad:	48 89 c6             	mov    %rax,%rsi
  803db0:	bf 00 00 00 00       	mov    $0x0,%edi
  803db5:	48 b8 41 20 80 00 00 	movabs $0x802041,%rax
  803dbc:	00 00 00 
  803dbf:	ff d0                	callq  *%rax
  803dc1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc8:	79 1b                	jns    803de5 <pipe+0x143>
		goto err3;
  803dca:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803dcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dcf:	48 89 c6             	mov    %rax,%rsi
  803dd2:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd7:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  803dde:	00 00 00 
  803de1:	ff d0                	callq  *%rax
  803de3:	eb 79                	jmp    803e5e <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803de5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de9:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803df0:	00 00 00 
  803df3:	8b 12                	mov    (%rdx),%edx
  803df5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803df7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803e02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e06:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e0d:	00 00 00 
  803e10:	8b 12                	mov    (%rdx),%edx
  803e12:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803e1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e23:	48 89 c7             	mov    %rax,%rdi
  803e26:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  803e2d:	00 00 00 
  803e30:	ff d0                	callq  *%rax
  803e32:	89 c2                	mov    %eax,%edx
  803e34:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e38:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e3a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e3e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e46:	48 89 c7             	mov    %rax,%rdi
  803e49:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  803e50:	00 00 00 
  803e53:	ff d0                	callq  *%rax
  803e55:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5c:	eb 33                	jmp    803e91 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803e5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e62:	48 89 c6             	mov    %rax,%rsi
  803e65:	bf 00 00 00 00       	mov    $0x0,%edi
  803e6a:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  803e71:	00 00 00 
  803e74:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7a:	48 89 c6             	mov    %rax,%rsi
  803e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  803e82:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
err:
	return r;
  803e8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e91:	48 83 c4 38          	add    $0x38,%rsp
  803e95:	5b                   	pop    %rbx
  803e96:	5d                   	pop    %rbp
  803e97:	c3                   	retq   

0000000000803e98 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e98:	55                   	push   %rbp
  803e99:	48 89 e5             	mov    %rsp,%rbp
  803e9c:	53                   	push   %rbx
  803e9d:	48 83 ec 28          	sub    $0x28,%rsp
  803ea1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ea5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ea9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803eb0:	00 00 00 
  803eb3:	48 8b 00             	mov    (%rax),%rax
  803eb6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ebc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ebf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec3:	48 89 c7             	mov    %rax,%rdi
  803ec6:	48 b8 1c 45 80 00 00 	movabs $0x80451c,%rax
  803ecd:	00 00 00 
  803ed0:	ff d0                	callq  *%rax
  803ed2:	89 c3                	mov    %eax,%ebx
  803ed4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ed8:	48 89 c7             	mov    %rax,%rdi
  803edb:	48 b8 1c 45 80 00 00 	movabs $0x80451c,%rax
  803ee2:	00 00 00 
  803ee5:	ff d0                	callq  *%rax
  803ee7:	39 c3                	cmp    %eax,%ebx
  803ee9:	0f 94 c0             	sete   %al
  803eec:	0f b6 c0             	movzbl %al,%eax
  803eef:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ef2:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803ef9:	00 00 00 
  803efc:	48 8b 00             	mov    (%rax),%rax
  803eff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f05:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f0b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f0e:	75 05                	jne    803f15 <_pipeisclosed+0x7d>
			return ret;
  803f10:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f13:	eb 4a                	jmp    803f5f <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f18:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f1b:	74 3d                	je     803f5a <_pipeisclosed+0xc2>
  803f1d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f21:	75 37                	jne    803f5a <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f23:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803f2a:	00 00 00 
  803f2d:	48 8b 00             	mov    (%rax),%rax
  803f30:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f36:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3c:	89 c6                	mov    %eax,%esi
  803f3e:	48 bf 95 53 80 00 00 	movabs $0x805395,%rdi
  803f45:	00 00 00 
  803f48:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4d:	49 b8 28 0b 80 00 00 	movabs $0x800b28,%r8
  803f54:	00 00 00 
  803f57:	41 ff d0             	callq  *%r8
	}
  803f5a:	e9 4a ff ff ff       	jmpq   803ea9 <_pipeisclosed+0x11>
}
  803f5f:	48 83 c4 28          	add    $0x28,%rsp
  803f63:	5b                   	pop    %rbx
  803f64:	5d                   	pop    %rbp
  803f65:	c3                   	retq   

0000000000803f66 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803f66:	55                   	push   %rbp
  803f67:	48 89 e5             	mov    %rsp,%rbp
  803f6a:	48 83 ec 30          	sub    $0x30,%rsp
  803f6e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f71:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f75:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f78:	48 89 d6             	mov    %rdx,%rsi
  803f7b:	89 c7                	mov    %eax,%edi
  803f7d:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  803f84:	00 00 00 
  803f87:	ff d0                	callq  *%rax
  803f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f90:	79 05                	jns    803f97 <pipeisclosed+0x31>
		return r;
  803f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f95:	eb 31                	jmp    803fc8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f9b:	48 89 c7             	mov    %rax,%rdi
  803f9e:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803fa5:	00 00 00 
  803fa8:	ff d0                	callq  *%rax
  803faa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fb6:	48 89 d6             	mov    %rdx,%rsi
  803fb9:	48 89 c7             	mov    %rax,%rdi
  803fbc:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  803fc3:	00 00 00 
  803fc6:	ff d0                	callq  *%rax
}
  803fc8:	c9                   	leaveq 
  803fc9:	c3                   	retq   

0000000000803fca <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fca:	55                   	push   %rbp
  803fcb:	48 89 e5             	mov    %rsp,%rbp
  803fce:	48 83 ec 40          	sub    $0x40,%rsp
  803fd2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fd6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fda:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe2:	48 89 c7             	mov    %rax,%rdi
  803fe5:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803fec:	00 00 00 
  803fef:	ff d0                	callq  *%rax
  803ff1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ff5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ffd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804004:	00 
  804005:	e9 92 00 00 00       	jmpq   80409c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80400a:	eb 41                	jmp    80404d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80400c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804011:	74 09                	je     80401c <devpipe_read+0x52>
				return i;
  804013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804017:	e9 92 00 00 00       	jmpq   8040ae <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80401c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804020:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804024:	48 89 d6             	mov    %rdx,%rsi
  804027:	48 89 c7             	mov    %rax,%rdi
  80402a:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  804031:	00 00 00 
  804034:	ff d0                	callq  *%rax
  804036:	85 c0                	test   %eax,%eax
  804038:	74 07                	je     804041 <devpipe_read+0x77>
				return 0;
  80403a:	b8 00 00 00 00       	mov    $0x0,%eax
  80403f:	eb 6d                	jmp    8040ae <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804041:	48 b8 b3 1f 80 00 00 	movabs $0x801fb3,%rax
  804048:	00 00 00 
  80404b:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80404d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804051:	8b 10                	mov    (%rax),%edx
  804053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804057:	8b 40 04             	mov    0x4(%rax),%eax
  80405a:	39 c2                	cmp    %eax,%edx
  80405c:	74 ae                	je     80400c <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80405e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804066:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80406a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406e:	8b 00                	mov    (%rax),%eax
  804070:	99                   	cltd   
  804071:	c1 ea 1b             	shr    $0x1b,%edx
  804074:	01 d0                	add    %edx,%eax
  804076:	83 e0 1f             	and    $0x1f,%eax
  804079:	29 d0                	sub    %edx,%eax
  80407b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80407f:	48 98                	cltq   
  804081:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804086:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408c:	8b 00                	mov    (%rax),%eax
  80408e:	8d 50 01             	lea    0x1(%rax),%edx
  804091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804095:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  804097:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80409c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040a4:	0f 82 60 ff ff ff    	jb     80400a <devpipe_read+0x40>
	}
	return i;
  8040aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040ae:	c9                   	leaveq 
  8040af:	c3                   	retq   

00000000008040b0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040b0:	55                   	push   %rbp
  8040b1:	48 89 e5             	mov    %rsp,%rbp
  8040b4:	48 83 ec 40          	sub    $0x40,%rsp
  8040b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040c0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c8:	48 89 c7             	mov    %rax,%rdi
  8040cb:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8040d2:	00 00 00 
  8040d5:	ff d0                	callq  *%rax
  8040d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040e3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040ea:	00 
  8040eb:	e9 91 00 00 00       	jmpq   804181 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040f0:	eb 31                	jmp    804123 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040fa:	48 89 d6             	mov    %rdx,%rsi
  8040fd:	48 89 c7             	mov    %rax,%rdi
  804100:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  804107:	00 00 00 
  80410a:	ff d0                	callq  *%rax
  80410c:	85 c0                	test   %eax,%eax
  80410e:	74 07                	je     804117 <devpipe_write+0x67>
				return 0;
  804110:	b8 00 00 00 00       	mov    $0x0,%eax
  804115:	eb 7c                	jmp    804193 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804117:	48 b8 b3 1f 80 00 00 	movabs $0x801fb3,%rax
  80411e:	00 00 00 
  804121:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804127:	8b 40 04             	mov    0x4(%rax),%eax
  80412a:	48 63 d0             	movslq %eax,%rdx
  80412d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804131:	8b 00                	mov    (%rax),%eax
  804133:	48 98                	cltq   
  804135:	48 83 c0 20          	add    $0x20,%rax
  804139:	48 39 c2             	cmp    %rax,%rdx
  80413c:	73 b4                	jae    8040f2 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80413e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804142:	8b 40 04             	mov    0x4(%rax),%eax
  804145:	99                   	cltd   
  804146:	c1 ea 1b             	shr    $0x1b,%edx
  804149:	01 d0                	add    %edx,%eax
  80414b:	83 e0 1f             	and    $0x1f,%eax
  80414e:	29 d0                	sub    %edx,%eax
  804150:	89 c6                	mov    %eax,%esi
  804152:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80415a:	48 01 d0             	add    %rdx,%rax
  80415d:	0f b6 08             	movzbl (%rax),%ecx
  804160:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804164:	48 63 c6             	movslq %esi,%rax
  804167:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80416b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416f:	8b 40 04             	mov    0x4(%rax),%eax
  804172:	8d 50 01             	lea    0x1(%rax),%edx
  804175:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804179:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80417c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804185:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804189:	0f 82 61 ff ff ff    	jb     8040f0 <devpipe_write+0x40>
	}

	return i;
  80418f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804193:	c9                   	leaveq 
  804194:	c3                   	retq   

0000000000804195 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804195:	55                   	push   %rbp
  804196:	48 89 e5             	mov    %rsp,%rbp
  804199:	48 83 ec 20          	sub    $0x20,%rsp
  80419d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a9:	48 89 c7             	mov    %rax,%rdi
  8041ac:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8041b3:	00 00 00 
  8041b6:	ff d0                	callq  *%rax
  8041b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c0:	48 be a8 53 80 00 00 	movabs $0x8053a8,%rsi
  8041c7:	00 00 00 
  8041ca:	48 89 c7             	mov    %rax,%rdi
  8041cd:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  8041d4:	00 00 00 
  8041d7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041dd:	8b 50 04             	mov    0x4(%rax),%edx
  8041e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e4:	8b 00                	mov    (%rax),%eax
  8041e6:	29 c2                	sub    %eax,%edx
  8041e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ec:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8041fd:	00 00 00 
	stat->st_dev = &devpipe;
  804200:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804204:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80420b:	00 00 00 
  80420e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804215:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80421a:	c9                   	leaveq 
  80421b:	c3                   	retq   

000000000080421c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80421c:	55                   	push   %rbp
  80421d:	48 89 e5             	mov    %rsp,%rbp
  804220:	48 83 ec 10          	sub    $0x10,%rsp
  804224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80422c:	48 89 c6             	mov    %rax,%rsi
  80422f:	bf 00 00 00 00       	mov    $0x0,%edi
  804234:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  80423b:	00 00 00 
  80423e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804244:	48 89 c7             	mov    %rax,%rdi
  804247:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  80424e:	00 00 00 
  804251:	ff d0                	callq  *%rax
  804253:	48 89 c6             	mov    %rax,%rsi
  804256:	bf 00 00 00 00       	mov    $0x0,%edi
  80425b:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  804262:	00 00 00 
  804265:	ff d0                	callq  *%rax
}
  804267:	c9                   	leaveq 
  804268:	c3                   	retq   

0000000000804269 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804269:	55                   	push   %rbp
  80426a:	48 89 e5             	mov    %rsp,%rbp
  80426d:	48 83 ec 20          	sub    $0x20,%rsp
  804271:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804274:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804277:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80427a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80427e:	be 01 00 00 00       	mov    $0x1,%esi
  804283:	48 89 c7             	mov    %rax,%rdi
  804286:	48 b8 a9 1e 80 00 00 	movabs $0x801ea9,%rax
  80428d:	00 00 00 
  804290:	ff d0                	callq  *%rax
}
  804292:	c9                   	leaveq 
  804293:	c3                   	retq   

0000000000804294 <getchar>:

int
getchar(void)
{
  804294:	55                   	push   %rbp
  804295:	48 89 e5             	mov    %rsp,%rbp
  804298:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80429c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042a0:	ba 01 00 00 00       	mov    $0x1,%edx
  8042a5:	48 89 c6             	mov    %rax,%rsi
  8042a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8042ad:	48 b8 8e 2b 80 00 00 	movabs $0x802b8e,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c0:	79 05                	jns    8042c7 <getchar+0x33>
		return r;
  8042c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c5:	eb 14                	jmp    8042db <getchar+0x47>
	if (r < 1)
  8042c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042cb:	7f 07                	jg     8042d4 <getchar+0x40>
		return -E_EOF;
  8042cd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042d2:	eb 07                	jmp    8042db <getchar+0x47>
	return c;
  8042d4:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042d8:	0f b6 c0             	movzbl %al,%eax
}
  8042db:	c9                   	leaveq 
  8042dc:	c3                   	retq   

00000000008042dd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042dd:	55                   	push   %rbp
  8042de:	48 89 e5             	mov    %rsp,%rbp
  8042e1:	48 83 ec 20          	sub    $0x20,%rsp
  8042e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ef:	48 89 d6             	mov    %rdx,%rsi
  8042f2:	89 c7                	mov    %eax,%edi
  8042f4:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  8042fb:	00 00 00 
  8042fe:	ff d0                	callq  *%rax
  804300:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804303:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804307:	79 05                	jns    80430e <iscons+0x31>
		return r;
  804309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80430c:	eb 1a                	jmp    804328 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80430e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804312:	8b 10                	mov    (%rax),%edx
  804314:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80431b:	00 00 00 
  80431e:	8b 00                	mov    (%rax),%eax
  804320:	39 c2                	cmp    %eax,%edx
  804322:	0f 94 c0             	sete   %al
  804325:	0f b6 c0             	movzbl %al,%eax
}
  804328:	c9                   	leaveq 
  804329:	c3                   	retq   

000000000080432a <opencons>:

int
opencons(void)
{
  80432a:	55                   	push   %rbp
  80432b:	48 89 e5             	mov    %rsp,%rbp
  80432e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804332:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804336:	48 89 c7             	mov    %rax,%rdi
  804339:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  804340:	00 00 00 
  804343:	ff d0                	callq  *%rax
  804345:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804348:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80434c:	79 05                	jns    804353 <opencons+0x29>
		return r;
  80434e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804351:	eb 5b                	jmp    8043ae <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804357:	ba 07 04 00 00       	mov    $0x407,%edx
  80435c:	48 89 c6             	mov    %rax,%rsi
  80435f:	bf 00 00 00 00       	mov    $0x0,%edi
  804364:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  80436b:	00 00 00 
  80436e:	ff d0                	callq  *%rax
  804370:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804373:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804377:	79 05                	jns    80437e <opencons+0x54>
		return r;
  804379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80437c:	eb 30                	jmp    8043ae <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80437e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804382:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804389:	00 00 00 
  80438c:	8b 12                	mov    (%rdx),%edx
  80438e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804394:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80439b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439f:	48 89 c7             	mov    %rax,%rdi
  8043a2:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  8043a9:	00 00 00 
  8043ac:	ff d0                	callq  *%rax
}
  8043ae:	c9                   	leaveq 
  8043af:	c3                   	retq   

00000000008043b0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043b0:	55                   	push   %rbp
  8043b1:	48 89 e5             	mov    %rsp,%rbp
  8043b4:	48 83 ec 30          	sub    $0x30,%rsp
  8043b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043c4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043c9:	75 07                	jne    8043d2 <devcons_read+0x22>
		return 0;
  8043cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d0:	eb 4b                	jmp    80441d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8043d2:	eb 0c                	jmp    8043e0 <devcons_read+0x30>
		sys_yield();
  8043d4:	48 b8 b3 1f 80 00 00 	movabs $0x801fb3,%rax
  8043db:	00 00 00 
  8043de:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8043e0:	48 b8 f5 1e 80 00 00 	movabs $0x801ef5,%rax
  8043e7:	00 00 00 
  8043ea:	ff d0                	callq  *%rax
  8043ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f3:	74 df                	je     8043d4 <devcons_read+0x24>
	if (c < 0)
  8043f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f9:	79 05                	jns    804400 <devcons_read+0x50>
		return c;
  8043fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043fe:	eb 1d                	jmp    80441d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804400:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804404:	75 07                	jne    80440d <devcons_read+0x5d>
		return 0;
  804406:	b8 00 00 00 00       	mov    $0x0,%eax
  80440b:	eb 10                	jmp    80441d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80440d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804410:	89 c2                	mov    %eax,%edx
  804412:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804416:	88 10                	mov    %dl,(%rax)
	return 1;
  804418:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80441d:	c9                   	leaveq 
  80441e:	c3                   	retq   

000000000080441f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80441f:	55                   	push   %rbp
  804420:	48 89 e5             	mov    %rsp,%rbp
  804423:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80442a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804431:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804438:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80443f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804446:	eb 76                	jmp    8044be <devcons_write+0x9f>
		m = n - tot;
  804448:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80444f:	89 c2                	mov    %eax,%edx
  804451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804454:	29 c2                	sub    %eax,%edx
  804456:	89 d0                	mov    %edx,%eax
  804458:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80445b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80445e:	83 f8 7f             	cmp    $0x7f,%eax
  804461:	76 07                	jbe    80446a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804463:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80446a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80446d:	48 63 d0             	movslq %eax,%rdx
  804470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804473:	48 63 c8             	movslq %eax,%rcx
  804476:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80447d:	48 01 c1             	add    %rax,%rcx
  804480:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804487:	48 89 ce             	mov    %rcx,%rsi
  80448a:	48 89 c7             	mov    %rax,%rdi
  80448d:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  804494:	00 00 00 
  804497:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804499:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80449c:	48 63 d0             	movslq %eax,%rdx
  80449f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044a6:	48 89 d6             	mov    %rdx,%rsi
  8044a9:	48 89 c7             	mov    %rax,%rdi
  8044ac:	48 b8 a9 1e 80 00 00 	movabs $0x801ea9,%rax
  8044b3:	00 00 00 
  8044b6:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8044b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044bb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c1:	48 98                	cltq   
  8044c3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044ca:	0f 82 78 ff ff ff    	jb     804448 <devcons_write+0x29>
	}
	return tot;
  8044d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044d3:	c9                   	leaveq 
  8044d4:	c3                   	retq   

00000000008044d5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044d5:	55                   	push   %rbp
  8044d6:	48 89 e5             	mov    %rsp,%rbp
  8044d9:	48 83 ec 08          	sub    $0x8,%rsp
  8044dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044e6:	c9                   	leaveq 
  8044e7:	c3                   	retq   

00000000008044e8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044e8:	55                   	push   %rbp
  8044e9:	48 89 e5             	mov    %rsp,%rbp
  8044ec:	48 83 ec 10          	sub    $0x10,%rsp
  8044f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8044f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fc:	48 be b4 53 80 00 00 	movabs $0x8053b4,%rsi
  804503:	00 00 00 
  804506:	48 89 c7             	mov    %rax,%rdi
  804509:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  804510:	00 00 00 
  804513:	ff d0                	callq  *%rax
	return 0;
  804515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80451a:	c9                   	leaveq 
  80451b:	c3                   	retq   

000000000080451c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80451c:	55                   	push   %rbp
  80451d:	48 89 e5             	mov    %rsp,%rbp
  804520:	48 83 ec 18          	sub    $0x18,%rsp
  804524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80452c:	48 c1 e8 15          	shr    $0x15,%rax
  804530:	48 89 c2             	mov    %rax,%rdx
  804533:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80453a:	01 00 00 
  80453d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804541:	83 e0 01             	and    $0x1,%eax
  804544:	48 85 c0             	test   %rax,%rax
  804547:	75 07                	jne    804550 <pageref+0x34>
		return 0;
  804549:	b8 00 00 00 00       	mov    $0x0,%eax
  80454e:	eb 53                	jmp    8045a3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804554:	48 c1 e8 0c          	shr    $0xc,%rax
  804558:	48 89 c2             	mov    %rax,%rdx
  80455b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804562:	01 00 00 
  804565:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804569:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80456d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804571:	83 e0 01             	and    $0x1,%eax
  804574:	48 85 c0             	test   %rax,%rax
  804577:	75 07                	jne    804580 <pageref+0x64>
		return 0;
  804579:	b8 00 00 00 00       	mov    $0x0,%eax
  80457e:	eb 23                	jmp    8045a3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804584:	48 c1 e8 0c          	shr    $0xc,%rax
  804588:	48 89 c2             	mov    %rax,%rdx
  80458b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804592:	00 00 00 
  804595:	48 c1 e2 04          	shl    $0x4,%rdx
  804599:	48 01 d0             	add    %rdx,%rax
  80459c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8045a0:	0f b7 c0             	movzwl %ax,%eax
}
  8045a3:	c9                   	leaveq 
  8045a4:	c3                   	retq   

00000000008045a5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8045a5:	55                   	push   %rbp
  8045a6:	48 89 e5             	mov    %rsp,%rbp
  8045a9:	48 83 ec 20          	sub    $0x20,%rsp
  8045ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8045b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045b9:	48 89 d6             	mov    %rdx,%rsi
  8045bc:	48 89 c7             	mov    %rax,%rdi
  8045bf:	48 b8 db 45 80 00 00 	movabs $0x8045db,%rax
  8045c6:	00 00 00 
  8045c9:	ff d0                	callq  *%rax
  8045cb:	85 c0                	test   %eax,%eax
  8045cd:	74 05                	je     8045d4 <inet_addr+0x2f>
    return (val.s_addr);
  8045cf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8045d2:	eb 05                	jmp    8045d9 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  8045d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8045d9:	c9                   	leaveq 
  8045da:	c3                   	retq   

00000000008045db <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8045db:	55                   	push   %rbp
  8045dc:	48 89 e5             	mov    %rsp,%rbp
  8045df:	48 83 ec 40          	sub    $0x40,%rsp
  8045e3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8045e7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8045eb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8045ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8045f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8045f7:	0f b6 00             	movzbl (%rax),%eax
  8045fa:	0f be c0             	movsbl %al,%eax
  8045fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804600:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804603:	3c 2f                	cmp    $0x2f,%al
  804605:	76 07                	jbe    80460e <inet_aton+0x33>
  804607:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80460a:	3c 39                	cmp    $0x39,%al
  80460c:	76 0a                	jbe    804618 <inet_aton+0x3d>
      return (0);
  80460e:	b8 00 00 00 00       	mov    $0x0,%eax
  804613:	e9 6e 02 00 00       	jmpq   804886 <inet_aton+0x2ab>
    val = 0;
  804618:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  80461f:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804626:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  80462a:	75 40                	jne    80466c <inet_aton+0x91>
      c = *++cp;
  80462c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804631:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804635:	0f b6 00             	movzbl (%rax),%eax
  804638:	0f be c0             	movsbl %al,%eax
  80463b:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80463e:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804642:	74 06                	je     80464a <inet_aton+0x6f>
  804644:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804648:	75 1b                	jne    804665 <inet_aton+0x8a>
        base = 16;
  80464a:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804651:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804656:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80465a:	0f b6 00             	movzbl (%rax),%eax
  80465d:	0f be c0             	movsbl %al,%eax
  804660:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804663:	eb 07                	jmp    80466c <inet_aton+0x91>
      } else
        base = 8;
  804665:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80466c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80466f:	3c 2f                	cmp    $0x2f,%al
  804671:	76 2f                	jbe    8046a2 <inet_aton+0xc7>
  804673:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804676:	3c 39                	cmp    $0x39,%al
  804678:	77 28                	ja     8046a2 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  80467a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80467d:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804681:	89 c2                	mov    %eax,%edx
  804683:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804686:	01 d0                	add    %edx,%eax
  804688:	83 e8 30             	sub    $0x30,%eax
  80468b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80468e:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804693:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804697:	0f b6 00             	movzbl (%rax),%eax
  80469a:	0f be c0             	movsbl %al,%eax
  80469d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8046a0:	eb 73                	jmp    804715 <inet_aton+0x13a>
      } else if (base == 16 && isxdigit(c)) {
  8046a2:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  8046a6:	75 72                	jne    80471a <inet_aton+0x13f>
  8046a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046ab:	3c 2f                	cmp    $0x2f,%al
  8046ad:	76 07                	jbe    8046b6 <inet_aton+0xdb>
  8046af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046b2:	3c 39                	cmp    $0x39,%al
  8046b4:	76 1c                	jbe    8046d2 <inet_aton+0xf7>
  8046b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046b9:	3c 60                	cmp    $0x60,%al
  8046bb:	76 07                	jbe    8046c4 <inet_aton+0xe9>
  8046bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046c0:	3c 66                	cmp    $0x66,%al
  8046c2:	76 0e                	jbe    8046d2 <inet_aton+0xf7>
  8046c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046c7:	3c 40                	cmp    $0x40,%al
  8046c9:	76 4f                	jbe    80471a <inet_aton+0x13f>
  8046cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046ce:	3c 46                	cmp    $0x46,%al
  8046d0:	77 48                	ja     80471a <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8046d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d5:	c1 e0 04             	shl    $0x4,%eax
  8046d8:	89 c2                	mov    %eax,%edx
  8046da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046dd:	8d 48 0a             	lea    0xa(%rax),%ecx
  8046e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046e3:	3c 60                	cmp    $0x60,%al
  8046e5:	76 0e                	jbe    8046f5 <inet_aton+0x11a>
  8046e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046ea:	3c 7a                	cmp    $0x7a,%al
  8046ec:	77 07                	ja     8046f5 <inet_aton+0x11a>
  8046ee:	b8 61 00 00 00       	mov    $0x61,%eax
  8046f3:	eb 05                	jmp    8046fa <inet_aton+0x11f>
  8046f5:	b8 41 00 00 00       	mov    $0x41,%eax
  8046fa:	29 c1                	sub    %eax,%ecx
  8046fc:	89 c8                	mov    %ecx,%eax
  8046fe:	09 d0                	or     %edx,%eax
  804700:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804703:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804708:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80470c:	0f b6 00             	movzbl (%rax),%eax
  80470f:	0f be c0             	movsbl %al,%eax
  804712:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  804715:	e9 52 ff ff ff       	jmpq   80466c <inet_aton+0x91>
    if (c == '.') {
  80471a:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  80471e:	75 3d                	jne    80475d <inet_aton+0x182>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804720:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804724:	48 83 c0 0c          	add    $0xc,%rax
  804728:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  80472c:	72 0a                	jb     804738 <inet_aton+0x15d>
        return (0);
  80472e:	b8 00 00 00 00       	mov    $0x0,%eax
  804733:	e9 4e 01 00 00       	jmpq   804886 <inet_aton+0x2ab>
      *pp++ = val;
  804738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80473c:	48 8d 50 04          	lea    0x4(%rax),%rdx
  804740:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804744:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804747:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804749:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80474e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804752:	0f b6 00             	movzbl (%rax),%eax
  804755:	0f be c0             	movsbl %al,%eax
  804758:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80475b:	eb 09                	jmp    804766 <inet_aton+0x18b>
    } else
      break;
  80475d:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80475e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804762:	74 43                	je     8047a7 <inet_aton+0x1cc>
  804764:	eb 05                	jmp    80476b <inet_aton+0x190>
  }
  804766:	e9 95 fe ff ff       	jmpq   804600 <inet_aton+0x25>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80476b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80476e:	3c 1f                	cmp    $0x1f,%al
  804770:	76 2b                	jbe    80479d <inet_aton+0x1c2>
  804772:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804775:	84 c0                	test   %al,%al
  804777:	78 24                	js     80479d <inet_aton+0x1c2>
  804779:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80477d:	74 28                	je     8047a7 <inet_aton+0x1cc>
  80477f:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804783:	74 22                	je     8047a7 <inet_aton+0x1cc>
  804785:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804789:	74 1c                	je     8047a7 <inet_aton+0x1cc>
  80478b:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80478f:	74 16                	je     8047a7 <inet_aton+0x1cc>
  804791:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804795:	74 10                	je     8047a7 <inet_aton+0x1cc>
  804797:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80479b:	74 0a                	je     8047a7 <inet_aton+0x1cc>
    return (0);
  80479d:	b8 00 00 00 00       	mov    $0x0,%eax
  8047a2:	e9 df 00 00 00       	jmpq   804886 <inet_aton+0x2ab>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8047a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047ab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8047af:	48 29 c2             	sub    %rax,%rdx
  8047b2:	48 89 d0             	mov    %rdx,%rax
  8047b5:	48 c1 f8 02          	sar    $0x2,%rax
  8047b9:	83 c0 01             	add    $0x1,%eax
  8047bc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  8047bf:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8047c3:	0f 87 98 00 00 00    	ja     804861 <inet_aton+0x286>
  8047c9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8047cc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8047d3:	00 
  8047d4:	48 b8 c0 53 80 00 00 	movabs $0x8053c0,%rax
  8047db:	00 00 00 
  8047de:	48 01 d0             	add    %rdx,%rax
  8047e1:	48 8b 00             	mov    (%rax),%rax
  8047e4:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8047e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8047eb:	e9 96 00 00 00       	jmpq   804886 <inet_aton+0x2ab>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8047f0:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8047f7:	76 0a                	jbe    804803 <inet_aton+0x228>
      return (0);
  8047f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8047fe:	e9 83 00 00 00       	jmpq   804886 <inet_aton+0x2ab>
    val |= parts[0] << 24;
  804803:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804806:	c1 e0 18             	shl    $0x18,%eax
  804809:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80480c:	eb 53                	jmp    804861 <inet_aton+0x286>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  80480e:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804815:	76 07                	jbe    80481e <inet_aton+0x243>
      return (0);
  804817:	b8 00 00 00 00       	mov    $0x0,%eax
  80481c:	eb 68                	jmp    804886 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80481e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804821:	c1 e0 18             	shl    $0x18,%eax
  804824:	89 c2                	mov    %eax,%edx
  804826:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804829:	c1 e0 10             	shl    $0x10,%eax
  80482c:	09 d0                	or     %edx,%eax
  80482e:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804831:	eb 2e                	jmp    804861 <inet_aton+0x286>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804833:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  80483a:	76 07                	jbe    804843 <inet_aton+0x268>
      return (0);
  80483c:	b8 00 00 00 00       	mov    $0x0,%eax
  804841:	eb 43                	jmp    804886 <inet_aton+0x2ab>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804843:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804846:	c1 e0 18             	shl    $0x18,%eax
  804849:	89 c2                	mov    %eax,%edx
  80484b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80484e:	c1 e0 10             	shl    $0x10,%eax
  804851:	09 c2                	or     %eax,%edx
  804853:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804856:	c1 e0 08             	shl    $0x8,%eax
  804859:	09 d0                	or     %edx,%eax
  80485b:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80485e:	eb 01                	jmp    804861 <inet_aton+0x286>
    break;
  804860:	90                   	nop
  }
  if (addr)
  804861:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804866:	74 19                	je     804881 <inet_aton+0x2a6>
    addr->s_addr = htonl(val);
  804868:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80486b:	89 c7                	mov    %eax,%edi
  80486d:	48 b8 ff 49 80 00 00 	movabs $0x8049ff,%rax
  804874:	00 00 00 
  804877:	ff d0                	callq  *%rax
  804879:	89 c2                	mov    %eax,%edx
  80487b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80487f:	89 10                	mov    %edx,(%rax)
  return (1);
  804881:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804886:	c9                   	leaveq 
  804887:	c3                   	retq   

0000000000804888 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804888:	55                   	push   %rbp
  804889:	48 89 e5             	mov    %rsp,%rbp
  80488c:	48 83 ec 30          	sub    $0x30,%rsp
  804890:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804893:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804896:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804899:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8048a0:	00 00 00 
  8048a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8048a7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8048ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8048af:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8048b3:	e9 e0 00 00 00       	jmpq   804998 <inet_ntoa+0x110>
    i = 0;
  8048b8:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8048bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048c0:	0f b6 08             	movzbl (%rax),%ecx
  8048c3:	0f b6 d1             	movzbl %cl,%edx
  8048c6:	89 d0                	mov    %edx,%eax
  8048c8:	c1 e0 02             	shl    $0x2,%eax
  8048cb:	01 d0                	add    %edx,%eax
  8048cd:	c1 e0 03             	shl    $0x3,%eax
  8048d0:	01 d0                	add    %edx,%eax
  8048d2:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8048d9:	01 d0                	add    %edx,%eax
  8048db:	66 c1 e8 08          	shr    $0x8,%ax
  8048df:	c0 e8 03             	shr    $0x3,%al
  8048e2:	88 45 ed             	mov    %al,-0x13(%rbp)
  8048e5:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8048e9:	89 d0                	mov    %edx,%eax
  8048eb:	c1 e0 02             	shl    $0x2,%eax
  8048ee:	01 d0                	add    %edx,%eax
  8048f0:	01 c0                	add    %eax,%eax
  8048f2:	29 c1                	sub    %eax,%ecx
  8048f4:	89 c8                	mov    %ecx,%eax
  8048f6:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8048f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048fd:	0f b6 00             	movzbl (%rax),%eax
  804900:	0f b6 d0             	movzbl %al,%edx
  804903:	89 d0                	mov    %edx,%eax
  804905:	c1 e0 02             	shl    $0x2,%eax
  804908:	01 d0                	add    %edx,%eax
  80490a:	c1 e0 03             	shl    $0x3,%eax
  80490d:	01 d0                	add    %edx,%eax
  80490f:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804916:	01 d0                	add    %edx,%eax
  804918:	66 c1 e8 08          	shr    $0x8,%ax
  80491c:	89 c2                	mov    %eax,%edx
  80491e:	c0 ea 03             	shr    $0x3,%dl
  804921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804925:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804927:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80492b:	8d 50 01             	lea    0x1(%rax),%edx
  80492e:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804931:	0f b6 c0             	movzbl %al,%eax
  804934:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804938:	83 c2 30             	add    $0x30,%edx
  80493b:	48 98                	cltq   
  80493d:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  804941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804945:	0f b6 00             	movzbl (%rax),%eax
  804948:	84 c0                	test   %al,%al
  80494a:	0f 85 6c ff ff ff    	jne    8048bc <inet_ntoa+0x34>
    while(i--)
  804950:	eb 1a                	jmp    80496c <inet_ntoa+0xe4>
      *rp++ = inv[i];
  804952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804956:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80495a:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80495e:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  804962:	48 63 d2             	movslq %edx,%rdx
  804965:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  80496a:	88 10                	mov    %dl,(%rax)
    while(i--)
  80496c:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804970:	8d 50 ff             	lea    -0x1(%rax),%edx
  804973:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804976:	84 c0                	test   %al,%al
  804978:	75 d8                	jne    804952 <inet_ntoa+0xca>
    *rp++ = '.';
  80497a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80497e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804982:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804986:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804989:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80498e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804992:	83 c0 01             	add    $0x1,%eax
  804995:	88 45 ef             	mov    %al,-0x11(%rbp)
  804998:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80499c:	0f 86 16 ff ff ff    	jbe    8048b8 <inet_ntoa+0x30>
  }
  *--rp = 0;
  8049a2:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8049a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049ab:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8049ae:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8049b5:	00 00 00 
}
  8049b8:	c9                   	leaveq 
  8049b9:	c3                   	retq   

00000000008049ba <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8049ba:	55                   	push   %rbp
  8049bb:	48 89 e5             	mov    %rsp,%rbp
  8049be:	48 83 ec 08          	sub    $0x8,%rsp
  8049c2:	89 f8                	mov    %edi,%eax
  8049c4:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8049c8:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8049cc:	c1 e0 08             	shl    $0x8,%eax
  8049cf:	89 c2                	mov    %eax,%edx
  8049d1:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8049d5:	66 c1 e8 08          	shr    $0x8,%ax
  8049d9:	09 d0                	or     %edx,%eax
}
  8049db:	c9                   	leaveq 
  8049dc:	c3                   	retq   

00000000008049dd <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8049dd:	55                   	push   %rbp
  8049de:	48 89 e5             	mov    %rsp,%rbp
  8049e1:	48 83 ec 08          	sub    $0x8,%rsp
  8049e5:	89 f8                	mov    %edi,%eax
  8049e7:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8049eb:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8049ef:	89 c7                	mov    %eax,%edi
  8049f1:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  8049f8:	00 00 00 
  8049fb:	ff d0                	callq  *%rax
}
  8049fd:	c9                   	leaveq 
  8049fe:	c3                   	retq   

00000000008049ff <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8049ff:	55                   	push   %rbp
  804a00:	48 89 e5             	mov    %rsp,%rbp
  804a03:	48 83 ec 08          	sub    $0x8,%rsp
  804a07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  804a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a0d:	c1 e0 18             	shl    $0x18,%eax
  804a10:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a15:	25 00 ff 00 00       	and    $0xff00,%eax
  804a1a:	c1 e0 08             	shl    $0x8,%eax
  return ((n & 0xff) << 24) |
  804a1d:	09 c2                	or     %eax,%edx
    ((n & 0xff0000UL) >> 8) |
  804a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a22:	25 00 00 ff 00       	and    $0xff0000,%eax
  804a27:	48 c1 e8 08          	shr    $0x8,%rax
  return ((n & 0xff) << 24) |
  804a2b:	09 c2                	or     %eax,%edx
    ((n & 0xff000000UL) >> 24);
  804a2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a30:	c1 e8 18             	shr    $0x18,%eax
  return ((n & 0xff) << 24) |
  804a33:	09 d0                	or     %edx,%eax
}
  804a35:	c9                   	leaveq 
  804a36:	c3                   	retq   

0000000000804a37 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804a37:	55                   	push   %rbp
  804a38:	48 89 e5             	mov    %rsp,%rbp
  804a3b:	48 83 ec 08          	sub    $0x8,%rsp
  804a3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804a42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a45:	89 c7                	mov    %eax,%edi
  804a47:	48 b8 ff 49 80 00 00 	movabs $0x8049ff,%rax
  804a4e:	00 00 00 
  804a51:	ff d0                	callq  *%rax
}
  804a53:	c9                   	leaveq 
  804a54:	c3                   	retq   
