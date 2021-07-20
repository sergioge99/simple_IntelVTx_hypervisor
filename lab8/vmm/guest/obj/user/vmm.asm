
vmm/guest/obj/user/vmm:     formato del fichero elf64-x86-64


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
  80003c:	e8 97 05 00 00       	callq  8005d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <map_in_guest>:
//
// Return 0 on success, <0 on failure.
//
static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz,
	      int fd, size_t filesz, off_t fileoffset ) {
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800052:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800056:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  800059:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80005d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	/* Your code here */
	if (PGOFF(gpa)) ROUNDDOWN(gpa, PGSIZE);
  800061:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800065:	25 ff 0f 00 00       	and    $0xfff,%eax
  80006a:	48 85 c0             	test   %rax,%rax
  80006d:	74 08                	je     800077 <map_in_guest+0x34>
  80006f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800073:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	int i, r = 0;
  800077:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	for (i = 0; i < filesz; i += PGSIZE) {
  80007e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800085:	e9 3f 01 00 00       	jmpq   8001c9 <map_in_guest+0x186>

		r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W);
  80008a:	ba 07 00 00 00       	mov    $0x7,%edx
  80008f:	be 00 00 40 00       	mov    $0x400000,%esi
  800094:	bf 00 00 00 00       	mov    $0x0,%edi
  800099:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  8000a0:	00 00 00 
  8000a3:	ff d0                	callq  *%rax
  8000a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0) return r;
  8000a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ac:	79 08                	jns    8000b6 <map_in_guest+0x73>
  8000ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b1:	e9 fc 01 00 00       	jmpq   8002b2 <map_in_guest+0x26f>

		r = seek(fd, fileoffset + i);
  8000b6:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8000b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bc:	01 c2                	add    %eax,%edx
  8000be:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000c1:	89 d6                	mov    %edx,%esi
  8000c3:	89 c7                	mov    %eax,%edi
  8000c5:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
  8000d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0) return r;
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000d8:	79 08                	jns    8000e2 <map_in_guest+0x9f>
  8000da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000dd:	e9 d0 01 00 00       	jmpq   8002b2 <map_in_guest+0x26f>

		r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i));
  8000e2:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%rbp)
  8000e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ec:	48 98                	cltq   
  8000ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8000f2:	48 29 c2             	sub    %rax,%rdx
  8000f5:	48 89 d0             	mov    %rdx,%rax
  8000f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8000fc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000ff:	48 63 d0             	movslq %eax,%rdx
  800102:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800106:	48 39 c2             	cmp    %rax,%rdx
  800109:	48 0f 47 d0          	cmova  %rax,%rdx
  80010d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800110:	be 00 00 40 00       	mov    $0x400000,%esi
  800115:	89 c7                	mov    %eax,%edi
  800117:	48 b8 b2 26 80 00 00 	movabs $0x8026b2,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax
  800123:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r<0) return r;
  800126:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80012a:	79 08                	jns    800134 <map_in_guest+0xf1>
  80012c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80012f:	e9 7e 01 00 00       	jmpq   8002b2 <map_in_guest+0x26f>

		r = sys_ept_map(thisenv->env_id, (void*)UTEMP, guest, (void*) (gpa + i), __EPTE_FULL);
  800134:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800137:	48 63 d0             	movslq %eax,%rdx
  80013a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80013e:	48 01 d0             	add    %rdx,%rax
  800141:	48 89 c1             	mov    %rax,%rcx
  800144:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80014b:	00 00 00 
  80014e:	48 8b 00             	mov    (%rax),%rax
  800151:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800157:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80015a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800160:	be 00 00 40 00       	mov    $0x400000,%esi
  800165:	89 c7                	mov    %eax,%edi
  800167:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0) panic("Something wrong with map_in_guest after calling sys_ept_map: %e", r);
  800176:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80017a:	79 30                	jns    8001ac <map_in_guest+0x169>
  80017c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017f:	89 c1                	mov    %eax,%ecx
  800181:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  800188:	00 00 00 
  80018b:	be 25 00 00 00       	mov    $0x25,%esi
  800190:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  800197:	00 00 00 
  80019a:	b8 00 00 00 00       	mov    $0x0,%eax
  80019f:	49 b8 5b 06 80 00 00 	movabs $0x80065b,%r8
  8001a6:	00 00 00 
  8001a9:	41 ff d0             	callq  *%r8

		sys_page_unmap(0, UTEMP);
  8001ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b6:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  8001bd:	00 00 00 
  8001c0:	ff d0                	callq  *%rax
	for (i = 0; i < filesz; i += PGSIZE) {
  8001c2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8001c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001cc:	48 98                	cltq   
  8001ce:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8001d2:	0f 82 b2 fe ff ff    	jb     80008a <map_in_guest+0x47>
	}

	for (; i < memsz; i+= PGSIZE) {
  8001d8:	e9 c1 00 00 00       	jmpq   80029e <map_in_guest+0x25b>

		r = sys_page_alloc(0, (void*) UTEMP, __EPTE_FULL);
  8001dd:	ba 07 00 00 00       	mov    $0x7,%edx
  8001e2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ec:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
  8001f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0) return r;
  8001fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001ff:	79 08                	jns    800209 <map_in_guest+0x1c6>
  800201:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800204:	e9 a9 00 00 00       	jmpq   8002b2 <map_in_guest+0x26f>

	  r = sys_ept_map(thisenv->env_id, UTEMP, guest, (void *)(gpa + i), __EPTE_FULL);
  800209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020c:	48 63 d0             	movslq %eax,%rdx
  80020f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800213:	48 01 d0             	add    %rdx,%rax
  800216:	48 89 c1             	mov    %rax,%rcx
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80022c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80022f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800235:	be 00 00 40 00       	mov    $0x400000,%esi
  80023a:	89 c7                	mov    %eax,%edi
  80023c:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  800243:	00 00 00 
  800246:	ff d0                	callq  *%rax
  800248:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0) panic("Something wrong with sys_ept_map: %e", r);
  80024b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80024f:	79 30                	jns    800281 <map_in_guest+0x23e>
  800251:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800254:	89 c1                	mov    %eax,%ecx
  800256:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  80025d:	00 00 00 
  800260:	be 30 00 00 00       	mov    $0x30,%esi
  800265:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  80026c:	00 00 00 
  80026f:	b8 00 00 00 00       	mov    $0x0,%eax
  800274:	49 b8 5b 06 80 00 00 	movabs $0x80065b,%r8
  80027b:	00 00 00 
  80027e:	41 ff d0             	callq  *%r8

	  sys_page_unmap(0, UTEMP);
  800281:	be 00 00 40 00       	mov    $0x400000,%esi
  800286:	bf 00 00 00 00       	mov    $0x0,%edi
  80028b:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	for (; i < memsz; i+= PGSIZE) {
  800297:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80029e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a1:	48 98                	cltq   
  8002a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8002a7:	0f 82 30 ff ff ff    	jb     8001dd <map_in_guest+0x19a>
	}
	return -E_NO_SYS;
  8002ad:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
}
  8002b2:	c9                   	leaveq 
  8002b3:	c3                   	retq   

00000000008002b4 <copy_guest_kern_gpa>:
//
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {
  8002b4:	55                   	push   %rbp
  8002b5:	48 89 e5             	mov    %rsp,%rbp
  8002b8:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  8002bf:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  8002c5:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	/* Your code here */
	int fd = open(fname, O_RDONLY);
  8002cc:	48 8b 85 d0 fd ff ff 	mov    -0x230(%rbp),%rax
  8002d3:	be 00 00 00 00       	mov    $0x0,%esi
  8002d8:	48 89 c7             	mov    %rax,%rdi
  8002db:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  8002e2:	00 00 00 
  8002e5:	ff d0                	callq  *%rax
  8002e7:	89 45 f0             	mov    %eax,-0x10(%rbp)
	if(fd < 0)
  8002ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002ee:	79 0a                	jns    8002fa <copy_guest_kern_gpa+0x46>
		return -E_NOT_FOUND;
  8002f0:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8002f5:	e9 48 01 00 00       	jmpq   800442 <copy_guest_kern_gpa+0x18e>
	char data[512]; //512 bytes block size
	if (readn(fd, data, sizeof(data)) != sizeof(data)) {
  8002fa:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  800301:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800304:	ba 00 02 00 00       	mov    $0x200,%edx
  800309:	48 89 ce             	mov    %rcx,%rsi
  80030c:	89 c7                	mov    %eax,%edi
  80030e:	48 b8 b2 26 80 00 00 	movabs $0x8026b2,%rax
  800315:	00 00 00 
  800318:	ff d0                	callq  *%rax
  80031a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80031f:	74 1b                	je     80033c <copy_guest_kern_gpa+0x88>
		close(fd);
  800321:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800324:	89 c7                	mov    %eax,%edi
  800326:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
		return -E_NOT_FOUND;
  800332:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800337:	e9 06 01 00 00       	jmpq   800442 <copy_guest_kern_gpa+0x18e>
	}
	struct Elf *elfhdr = (struct Elf*)data;
  80033c:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800343:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (elfhdr->e_magic != ELF_MAGIC) {
  800347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80034b:	8b 00                	mov    (%rax),%eax
  80034d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  800352:	74 1b                	je     80036f <copy_guest_kern_gpa+0xbb>
		close(fd);
  800354:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800357:	89 c7                	mov    %eax,%edi
  800359:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  800360:	00 00 00 
  800363:	ff d0                	callq  *%rax
		return -E_NOT_EXEC;
  800365:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80036a:	e9 d3 00 00 00       	jmpq   800442 <copy_guest_kern_gpa+0x18e>
	}
	// Program Header part from env.c...
	struct Proghdr* ph = (struct Proghdr*) (data + elfhdr->e_phoff);
  80036f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800373:	48 8b 40 20          	mov    0x20(%rax),%rax
  800377:	48 8d 95 e0 fd ff ff 	lea    -0x220(%rbp),%rdx
  80037e:	48 01 d0             	add    %rdx,%rax
  800381:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Proghdr* eph = ph + elfhdr->e_phnum;
  800385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800389:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80038d:	0f b7 c0             	movzwl %ax,%eax
  800390:	48 c1 e0 03          	shl    $0x3,%rax
  800394:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80039b:	00 
  80039c:	48 29 c2             	sub    %rax,%rdx
  80039f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003a3:	48 01 d0             	add    %rdx,%rax
  8003a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int r = 0;
  8003aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	for (; ph < eph; ph++) {
  8003b1:	eb 71                	jmp    800424 <copy_guest_kern_gpa+0x170>
    	if (ph->p_type == ELF_PROG_LOAD) {
  8003b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003b7:	8b 00                	mov    (%rax),%eax
  8003b9:	83 f8 01             	cmp    $0x1,%eax
  8003bc:	75 61                	jne    80041f <copy_guest_kern_gpa+0x16b>
			// Call map_in_guest if needed.
			r = map_in_guest(guest, ph->p_pa, ph->p_memsz, fd, ph->p_filesz, ph->p_offset);
  8003be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8003c6:	41 89 c0             	mov    %eax,%r8d
  8003c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cd:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8003d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003d5:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8003d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003dd:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8003e1:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8003e4:	8b 85 dc fd ff ff    	mov    -0x224(%rbp),%eax
  8003ea:	45 89 c1             	mov    %r8d,%r9d
  8003ed:	49 89 f8             	mov    %rdi,%r8
  8003f0:	89 c7                	mov    %eax,%edi
  8003f2:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
  8003fe:	89 45 f4             	mov    %eax,-0xc(%rbp)
			if (r < 0) {
  800401:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800405:	79 18                	jns    80041f <copy_guest_kern_gpa+0x16b>
				close(fd);
  800407:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80040a:	89 c7                	mov    %eax,%edi
  80040c:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
				return -E_NO_SYS;
  800418:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  80041d:	eb 23                	jmp    800442 <copy_guest_kern_gpa+0x18e>
	for (; ph < eph; ph++) {
  80041f:	48 83 45 f8 38       	addq   $0x38,-0x8(%rbp)
  800424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800428:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042c:	72 85                	jb     8003b3 <copy_guest_kern_gpa+0xff>
			}
		}
	}
	close(fd);
  80042e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800431:	89 c7                	mov    %eax,%edi
  800433:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  80043a:	00 00 00 
  80043d:	ff d0                	callq  *%rax
	return r;
  80043f:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <umain>:

void
umain(int argc, char **argv) {
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 ec 50          	sub    $0x50,%rsp
  80044c:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80044f:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ, JOS_ENTRY )) < 0) {
  800453:	be 00 70 00 00       	mov    $0x7000,%esi
  800458:	bf 00 00 00 01       	mov    $0x1000000,%edi
  80045d:	48 b8 77 20 80 00 00 	movabs $0x802077,%rax
  800464:	00 00 00 
  800467:	ff d0                	callq  *%rax
  800469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80046c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800470:	79 2c                	jns    80049e <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  800472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800475:	89 c6                	mov    %eax,%esi
  800477:	48 bf 78 43 80 00 00 	movabs $0x804378,%rdi
  80047e:	00 00 00 
  800481:	b8 00 00 00 00       	mov    $0x0,%eax
  800486:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  80048d:	00 00 00 
  800490:	ff d2                	callq  *%rdx
		exit();
  800492:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  800499:	00 00 00 
  80049c:	ff d0                	callq  *%rax
	}
	guest = ret;
  80049e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a1:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  8004a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a7:	48 be 9b 43 80 00 00 	movabs $0x80439b,%rsi
  8004ae:	00 00 00 
  8004b1:	89 c7                	mov    %eax,%edi
  8004b3:	48 b8 b4 02 80 00 00 	movabs $0x8002b4,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
  8004bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004c6:	79 2c                	jns    8004f4 <umain+0xb0>
		cprintf("Error copying page into the guest - %d\n.", ret);
  8004c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004cb:	89 c6                	mov    %eax,%esi
  8004cd:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  8004d4:	00 00 00 
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  8004e3:	00 00 00 
  8004e6:	ff d2                	callq  *%rdx
		exit();
  8004e8:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	callq  *%rax
	}

	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  8004f4:	be 00 00 00 00       	mov    $0x0,%esi
  8004f9:	48 bf d1 43 80 00 00 	movabs $0x8043d1,%rdi
  800500:	00 00 00 
  800503:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax
  80050f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800512:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800516:	79 36                	jns    80054e <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  800518:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80051b:	89 c2                	mov    %eax,%edx
  80051d:	48 be d1 43 80 00 00 	movabs $0x8043d1,%rsi
  800524:	00 00 00 
  800527:	48 bf db 43 80 00 00 	movabs $0x8043db,%rdi
  80052e:	00 00 00 
  800531:	b8 00 00 00 00       	mov    $0x0,%eax
  800536:	48 b9 94 08 80 00 00 	movabs $0x800894,%rcx
  80053d:	00 00 00 
  800540:	ff d1                	callq  *%rcx
		exit();
  800542:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  800549:	00 00 00 
  80054c:	ff d0                	callq  *%rax
	}

	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
  80054e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800551:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800554:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80055a:	41 b8 00 02 00 00    	mov    $0x200,%r8d
  800560:	89 d1                	mov    %edx,%ecx
  800562:	ba 00 02 00 00       	mov    $0x200,%edx
  800567:	be 00 70 00 00       	mov    $0x7000,%esi
  80056c:	89 c7                	mov    %eax,%edi
  80056e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800575:	00 00 00 
  800578:	ff d0                	callq  *%rax
  80057a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80057d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800581:	79 2c                	jns    8005af <umain+0x16b>
		cprintf("Error mapping bootloader into the guest - %d\n.", ret);
  800583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800586:	89 c6                	mov    %eax,%esi
  800588:	48 bf f8 43 80 00 00 	movabs $0x8043f8,%rdi
  80058f:	00 00 00 
  800592:	b8 00 00 00 00       	mov    $0x0,%eax
  800597:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  80059e:	00 00 00 
  8005a1:	ff d2                	callq  *%rdx
		exit();
  8005a3:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
        }

        cprintf("Create VHD finished\n");
#endif
	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  8005af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005b2:	be 02 00 00 00       	mov    $0x2,%esi
  8005b7:	89 c7                	mov    %eax,%edi
  8005b9:	48 b8 59 1e 80 00 00 	movabs $0x801e59,%rax
  8005c0:	00 00 00 
  8005c3:	ff d0                	callq  *%rax
	wait(guest);
  8005c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005c8:	89 c7                	mov    %eax,%edi
  8005ca:	48 b8 b8 3c 80 00 00 	movabs $0x803cb8,%rax
  8005d1:	00 00 00 
  8005d4:	ff d0                	callq  *%rax
}
  8005d6:	c9                   	leaveq 
  8005d7:	c3                   	retq   

00000000008005d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005d8:	55                   	push   %rbp
  8005d9:	48 89 e5             	mov    %rsp,%rbp
  8005dc:	48 83 ec 10          	sub    $0x10,%rsp
  8005e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8005e7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005ee:	00 00 00 
  8005f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005fc:	7e 14                	jle    800612 <libmain+0x3a>
		binaryname = argv[0];
  8005fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800602:	48 8b 10             	mov    (%rax),%rdx
  800605:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80060c:	00 00 00 
  80060f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800612:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800619:	48 89 d6             	mov    %rdx,%rsi
  80061c:	89 c7                	mov    %eax,%edi
  80061e:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80062a:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  800631:	00 00 00 
  800634:	ff d0                	callq  *%rax
}
  800636:	c9                   	leaveq 
  800637:	c3                   	retq   

0000000000800638 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800638:	55                   	push   %rbp
  800639:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80063c:	48 b8 06 24 80 00 00 	movabs $0x802406,%rax
  800643:	00 00 00 
  800646:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800648:	bf 00 00 00 00       	mov    $0x0,%edi
  80064d:	48 b8 9d 1c 80 00 00 	movabs $0x801c9d,%rax
  800654:	00 00 00 
  800657:	ff d0                	callq  *%rax
}
  800659:	5d                   	pop    %rbp
  80065a:	c3                   	retq   

000000000080065b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80065b:	55                   	push   %rbp
  80065c:	48 89 e5             	mov    %rsp,%rbp
  80065f:	53                   	push   %rbx
  800660:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800667:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80066e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800674:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80067b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800682:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800689:	84 c0                	test   %al,%al
  80068b:	74 23                	je     8006b0 <_panic+0x55>
  80068d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800694:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800698:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80069c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8006a0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8006a4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8006a8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8006ac:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8006b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8006b7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8006be:	00 00 00 
  8006c1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8006c8:	00 00 00 
  8006cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006cf:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8006d6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8006dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8006eb:	00 00 00 
  8006ee:	48 8b 18             	mov    (%rax),%rbx
  8006f1:	48 b8 e3 1c 80 00 00 	movabs $0x801ce3,%rax
  8006f8:	00 00 00 
  8006fb:	ff d0                	callq  *%rax
  8006fd:	89 c6                	mov    %eax,%esi
  8006ff:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800705:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80070c:	41 89 d0             	mov    %edx,%r8d
  80070f:	48 89 c1             	mov    %rax,%rcx
  800712:	48 89 da             	mov    %rbx,%rdx
  800715:	48 bf 38 44 80 00 00 	movabs $0x804438,%rdi
  80071c:	00 00 00 
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
  800724:	49 b9 94 08 80 00 00 	movabs $0x800894,%r9
  80072b:	00 00 00 
  80072e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800731:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800738:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80073f:	48 89 d6             	mov    %rdx,%rsi
  800742:	48 89 c7             	mov    %rax,%rdi
  800745:	48 b8 e8 07 80 00 00 	movabs $0x8007e8,%rax
  80074c:	00 00 00 
  80074f:	ff d0                	callq  *%rax
	cprintf("\n");
  800751:	48 bf 5b 44 80 00 00 	movabs $0x80445b,%rdi
  800758:	00 00 00 
  80075b:	b8 00 00 00 00       	mov    $0x0,%eax
  800760:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  800767:	00 00 00 
  80076a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80076c:	cc                   	int3   
  80076d:	eb fd                	jmp    80076c <_panic+0x111>

000000000080076f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80076f:	55                   	push   %rbp
  800770:	48 89 e5             	mov    %rsp,%rbp
  800773:	48 83 ec 10          	sub    $0x10,%rsp
  800777:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80077a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80077e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800782:	8b 00                	mov    (%rax),%eax
  800784:	8d 48 01             	lea    0x1(%rax),%ecx
  800787:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80078b:	89 0a                	mov    %ecx,(%rdx)
  80078d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800790:	89 d1                	mov    %edx,%ecx
  800792:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800796:	48 98                	cltq   
  800798:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80079c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007a7:	75 2c                	jne    8007d5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8007a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ad:	8b 00                	mov    (%rax),%eax
  8007af:	48 98                	cltq   
  8007b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007b5:	48 83 c2 08          	add    $0x8,%rdx
  8007b9:	48 89 c6             	mov    %rax,%rsi
  8007bc:	48 89 d7             	mov    %rdx,%rdi
  8007bf:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  8007c6:	00 00 00 
  8007c9:	ff d0                	callq  *%rax
        b->idx = 0;
  8007cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8007d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007d9:	8b 40 04             	mov    0x4(%rax),%eax
  8007dc:	8d 50 01             	lea    0x1(%rax),%edx
  8007df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007e3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8007e6:	c9                   	leaveq 
  8007e7:	c3                   	retq   

00000000008007e8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8007e8:	55                   	push   %rbp
  8007e9:	48 89 e5             	mov    %rsp,%rbp
  8007ec:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8007f3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8007fa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800801:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800808:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80080f:	48 8b 0a             	mov    (%rdx),%rcx
  800812:	48 89 08             	mov    %rcx,(%rax)
  800815:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800819:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80081d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800821:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800825:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80082c:	00 00 00 
    b.cnt = 0;
  80082f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800836:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800839:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800840:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800847:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80084e:	48 89 c6             	mov    %rax,%rsi
  800851:	48 bf 6f 07 80 00 00 	movabs $0x80076f,%rdi
  800858:	00 00 00 
  80085b:	48 b8 33 0c 80 00 00 	movabs $0x800c33,%rax
  800862:	00 00 00 
  800865:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800867:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80086d:	48 98                	cltq   
  80086f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800876:	48 83 c2 08          	add    $0x8,%rdx
  80087a:	48 89 c6             	mov    %rax,%rsi
  80087d:	48 89 d7             	mov    %rdx,%rdi
  800880:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  800887:	00 00 00 
  80088a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80088c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800892:	c9                   	leaveq 
  800893:	c3                   	retq   

0000000000800894 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800894:	55                   	push   %rbp
  800895:	48 89 e5             	mov    %rsp,%rbp
  800898:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80089f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8008a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8008ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8008b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8008bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8008c2:	84 c0                	test   %al,%al
  8008c4:	74 20                	je     8008e6 <cprintf+0x52>
  8008c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8008ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8008ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8008d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8008d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8008da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8008de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8008e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8008e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8008ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8008f4:	00 00 00 
  8008f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8008fe:	00 00 00 
  800901:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800905:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80090c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800913:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80091a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800921:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800928:	48 8b 0a             	mov    (%rdx),%rcx
  80092b:	48 89 08             	mov    %rcx,(%rax)
  80092e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800932:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800936:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80093a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80093e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800945:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80094c:	48 89 d6             	mov    %rdx,%rsi
  80094f:	48 89 c7             	mov    %rax,%rdi
  800952:	48 b8 e8 07 80 00 00 	movabs $0x8007e8,%rax
  800959:	00 00 00 
  80095c:	ff d0                	callq  *%rax
  80095e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800964:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80096a:	c9                   	leaveq 
  80096b:	c3                   	retq   

000000000080096c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80096c:	55                   	push   %rbp
  80096d:	48 89 e5             	mov    %rsp,%rbp
  800970:	48 83 ec 30          	sub    $0x30,%rsp
  800974:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800978:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80097c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800980:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800983:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800987:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80098b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80098e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800992:	77 42                	ja     8009d6 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800994:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800997:	8d 78 ff             	lea    -0x1(%rax),%edi
  80099a:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a6:	48 f7 f6             	div    %rsi
  8009a9:	49 89 c2             	mov    %rax,%r10
  8009ac:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8009af:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8009b2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8009b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009ba:	41 89 c9             	mov    %ecx,%r9d
  8009bd:	41 89 f8             	mov    %edi,%r8d
  8009c0:	89 d1                	mov    %edx,%ecx
  8009c2:	4c 89 d2             	mov    %r10,%rdx
  8009c5:	48 89 c7             	mov    %rax,%rdi
  8009c8:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  8009cf:	00 00 00 
  8009d2:	ff d0                	callq  *%rax
  8009d4:	eb 1e                	jmp    8009f4 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009d6:	eb 12                	jmp    8009ea <printnum+0x7e>
			putch(padc, putdat);
  8009d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8009dc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8009df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009e3:	48 89 ce             	mov    %rcx,%rsi
  8009e6:	89 d7                	mov    %edx,%edi
  8009e8:	ff d0                	callq  *%rax
		while (--width > 0)
  8009ea:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8009ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8009f2:	7f e4                	jg     8009d8 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009f4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8009f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800a00:	48 f7 f1             	div    %rcx
  800a03:	48 b8 70 46 80 00 00 	movabs $0x804670,%rax
  800a0a:	00 00 00 
  800a0d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800a11:	0f be d0             	movsbl %al,%edx
  800a14:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a1c:	48 89 ce             	mov    %rcx,%rsi
  800a1f:	89 d7                	mov    %edx,%edi
  800a21:	ff d0                	callq  *%rax
}
  800a23:	c9                   	leaveq 
  800a24:	c3                   	retq   

0000000000800a25 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a25:	55                   	push   %rbp
  800a26:	48 89 e5             	mov    %rsp,%rbp
  800a29:	48 83 ec 20          	sub    $0x20,%rsp
  800a2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a31:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a34:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a38:	7e 4f                	jle    800a89 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3e:	8b 00                	mov    (%rax),%eax
  800a40:	83 f8 30             	cmp    $0x30,%eax
  800a43:	73 24                	jae    800a69 <getuint+0x44>
  800a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a49:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a51:	8b 00                	mov    (%rax),%eax
  800a53:	89 c0                	mov    %eax,%eax
  800a55:	48 01 d0             	add    %rdx,%rax
  800a58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5c:	8b 12                	mov    (%rdx),%edx
  800a5e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a65:	89 0a                	mov    %ecx,(%rdx)
  800a67:	eb 14                	jmp    800a7d <getuint+0x58>
  800a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a71:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a79:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a7d:	48 8b 00             	mov    (%rax),%rax
  800a80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a84:	e9 9d 00 00 00       	jmpq   800b26 <getuint+0x101>
	else if (lflag)
  800a89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a8d:	74 4c                	je     800adb <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	8b 00                	mov    (%rax),%eax
  800a95:	83 f8 30             	cmp    $0x30,%eax
  800a98:	73 24                	jae    800abe <getuint+0x99>
  800a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	8b 00                	mov    (%rax),%eax
  800aa8:	89 c0                	mov    %eax,%eax
  800aaa:	48 01 d0             	add    %rdx,%rax
  800aad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab1:	8b 12                	mov    (%rdx),%edx
  800ab3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aba:	89 0a                	mov    %ecx,(%rdx)
  800abc:	eb 14                	jmp    800ad2 <getuint+0xad>
  800abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ac6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800aca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ace:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad2:	48 8b 00             	mov    (%rax),%rax
  800ad5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ad9:	eb 4b                	jmp    800b26 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	8b 00                	mov    (%rax),%eax
  800ae1:	83 f8 30             	cmp    $0x30,%eax
  800ae4:	73 24                	jae    800b0a <getuint+0xe5>
  800ae6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	8b 00                	mov    (%rax),%eax
  800af4:	89 c0                	mov    %eax,%eax
  800af6:	48 01 d0             	add    %rdx,%rax
  800af9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800afd:	8b 12                	mov    (%rdx),%edx
  800aff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b06:	89 0a                	mov    %ecx,(%rdx)
  800b08:	eb 14                	jmp    800b1e <getuint+0xf9>
  800b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b12:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b1e:	8b 00                	mov    (%rax),%eax
  800b20:	89 c0                	mov    %eax,%eax
  800b22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b2a:	c9                   	leaveq 
  800b2b:	c3                   	retq   

0000000000800b2c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b2c:	55                   	push   %rbp
  800b2d:	48 89 e5             	mov    %rsp,%rbp
  800b30:	48 83 ec 20          	sub    $0x20,%rsp
  800b34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b3b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b3f:	7e 4f                	jle    800b90 <getint+0x64>
		x=va_arg(*ap, long long);
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	8b 00                	mov    (%rax),%eax
  800b47:	83 f8 30             	cmp    $0x30,%eax
  800b4a:	73 24                	jae    800b70 <getint+0x44>
  800b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b50:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b58:	8b 00                	mov    (%rax),%eax
  800b5a:	89 c0                	mov    %eax,%eax
  800b5c:	48 01 d0             	add    %rdx,%rax
  800b5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b63:	8b 12                	mov    (%rdx),%edx
  800b65:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6c:	89 0a                	mov    %ecx,(%rdx)
  800b6e:	eb 14                	jmp    800b84 <getint+0x58>
  800b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b74:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b78:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b80:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b84:	48 8b 00             	mov    (%rax),%rax
  800b87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b8b:	e9 9d 00 00 00       	jmpq   800c2d <getint+0x101>
	else if (lflag)
  800b90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b94:	74 4c                	je     800be2 <getint+0xb6>
		x=va_arg(*ap, long);
  800b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9a:	8b 00                	mov    (%rax),%eax
  800b9c:	83 f8 30             	cmp    $0x30,%eax
  800b9f:	73 24                	jae    800bc5 <getint+0x99>
  800ba1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bad:	8b 00                	mov    (%rax),%eax
  800baf:	89 c0                	mov    %eax,%eax
  800bb1:	48 01 d0             	add    %rdx,%rax
  800bb4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb8:	8b 12                	mov    (%rdx),%edx
  800bba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc1:	89 0a                	mov    %ecx,(%rdx)
  800bc3:	eb 14                	jmp    800bd9 <getint+0xad>
  800bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bcd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800bd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bd9:	48 8b 00             	mov    (%rax),%rax
  800bdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800be0:	eb 4b                	jmp    800c2d <getint+0x101>
	else
		x=va_arg(*ap, int);
  800be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be6:	8b 00                	mov    (%rax),%eax
  800be8:	83 f8 30             	cmp    $0x30,%eax
  800beb:	73 24                	jae    800c11 <getint+0xe5>
  800bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf9:	8b 00                	mov    (%rax),%eax
  800bfb:	89 c0                	mov    %eax,%eax
  800bfd:	48 01 d0             	add    %rdx,%rax
  800c00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c04:	8b 12                	mov    (%rdx),%edx
  800c06:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0d:	89 0a                	mov    %ecx,(%rdx)
  800c0f:	eb 14                	jmp    800c25 <getint+0xf9>
  800c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c15:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c19:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c21:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c25:	8b 00                	mov    (%rax),%eax
  800c27:	48 98                	cltq   
  800c29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c31:	c9                   	leaveq 
  800c32:	c3                   	retq   

0000000000800c33 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c33:	55                   	push   %rbp
  800c34:	48 89 e5             	mov    %rsp,%rbp
  800c37:	41 54                	push   %r12
  800c39:	53                   	push   %rbx
  800c3a:	48 83 ec 60          	sub    $0x60,%rsp
  800c3e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c42:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800c46:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c4a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800c4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c52:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c56:	48 8b 0a             	mov    (%rdx),%rcx
  800c59:	48 89 08             	mov    %rcx,(%rax)
  800c5c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c60:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c64:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c68:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6c:	eb 17                	jmp    800c85 <vprintfmt+0x52>
			if (ch == '\0')
  800c6e:	85 db                	test   %ebx,%ebx
  800c70:	0f 84 c5 04 00 00    	je     80113b <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800c76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7e:	48 89 d6             	mov    %rdx,%rsi
  800c81:	89 df                	mov    %ebx,%edi
  800c83:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c8d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c91:	0f b6 00             	movzbl (%rax),%eax
  800c94:	0f b6 d8             	movzbl %al,%ebx
  800c97:	83 fb 25             	cmp    $0x25,%ebx
  800c9a:	75 d2                	jne    800c6e <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800c9c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800ca0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800ca7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800cae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800cb5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cbc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cc0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cc4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800cc8:	0f b6 00             	movzbl (%rax),%eax
  800ccb:	0f b6 d8             	movzbl %al,%ebx
  800cce:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800cd1:	83 f8 55             	cmp    $0x55,%eax
  800cd4:	0f 87 2e 04 00 00    	ja     801108 <vprintfmt+0x4d5>
  800cda:	89 c0                	mov    %eax,%eax
  800cdc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ce3:	00 
  800ce4:	48 b8 98 46 80 00 00 	movabs $0x804698,%rax
  800ceb:	00 00 00 
  800cee:	48 01 d0             	add    %rdx,%rax
  800cf1:	48 8b 00             	mov    (%rax),%rax
  800cf4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800cf6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800cfa:	eb c0                	jmp    800cbc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cfc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800d00:	eb ba                	jmp    800cbc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d02:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d09:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d0c:	89 d0                	mov    %edx,%eax
  800d0e:	c1 e0 02             	shl    $0x2,%eax
  800d11:	01 d0                	add    %edx,%eax
  800d13:	01 c0                	add    %eax,%eax
  800d15:	01 d8                	add    %ebx,%eax
  800d17:	83 e8 30             	sub    $0x30,%eax
  800d1a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d1d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d21:	0f b6 00             	movzbl (%rax),%eax
  800d24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d27:	83 fb 2f             	cmp    $0x2f,%ebx
  800d2a:	7e 0c                	jle    800d38 <vprintfmt+0x105>
  800d2c:	83 fb 39             	cmp    $0x39,%ebx
  800d2f:	7f 07                	jg     800d38 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800d31:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800d36:	eb d1                	jmp    800d09 <vprintfmt+0xd6>
			goto process_precision;
  800d38:	eb 50                	jmp    800d8a <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800d3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3d:	83 f8 30             	cmp    $0x30,%eax
  800d40:	73 17                	jae    800d59 <vprintfmt+0x126>
  800d42:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d49:	89 d2                	mov    %edx,%edx
  800d4b:	48 01 d0             	add    %rdx,%rax
  800d4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d51:	83 c2 08             	add    $0x8,%edx
  800d54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d57:	eb 0c                	jmp    800d65 <vprintfmt+0x132>
  800d59:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d5d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d65:	8b 00                	mov    (%rax),%eax
  800d67:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d6a:	eb 1e                	jmp    800d8a <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800d6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d70:	79 07                	jns    800d79 <vprintfmt+0x146>
				width = 0;
  800d72:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d79:	e9 3e ff ff ff       	jmpq   800cbc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d7e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d85:	e9 32 ff ff ff       	jmpq   800cbc <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d8e:	79 0d                	jns    800d9d <vprintfmt+0x16a>
				width = precision, precision = -1;
  800d90:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d93:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d96:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d9d:	e9 1a ff ff ff       	jmpq   800cbc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da2:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800da6:	e9 11 ff ff ff       	jmpq   800cbc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800dab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dae:	83 f8 30             	cmp    $0x30,%eax
  800db1:	73 17                	jae    800dca <vprintfmt+0x197>
  800db3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800db7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dba:	89 d2                	mov    %edx,%edx
  800dbc:	48 01 d0             	add    %rdx,%rax
  800dbf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc2:	83 c2 08             	add    $0x8,%edx
  800dc5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc8:	eb 0c                	jmp    800dd6 <vprintfmt+0x1a3>
  800dca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800dce:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800dd2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd6:	8b 10                	mov    (%rax),%edx
  800dd8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ddc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de0:	48 89 ce             	mov    %rcx,%rsi
  800de3:	89 d7                	mov    %edx,%edi
  800de5:	ff d0                	callq  *%rax
			break;
  800de7:	e9 4a 03 00 00       	jmpq   801136 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800dec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800def:	83 f8 30             	cmp    $0x30,%eax
  800df2:	73 17                	jae    800e0b <vprintfmt+0x1d8>
  800df4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800df8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dfb:	89 d2                	mov    %edx,%edx
  800dfd:	48 01 d0             	add    %rdx,%rax
  800e00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e03:	83 c2 08             	add    $0x8,%edx
  800e06:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e09:	eb 0c                	jmp    800e17 <vprintfmt+0x1e4>
  800e0b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e0f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e17:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e19:	85 db                	test   %ebx,%ebx
  800e1b:	79 02                	jns    800e1f <vprintfmt+0x1ec>
				err = -err;
  800e1d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e1f:	83 fb 15             	cmp    $0x15,%ebx
  800e22:	7f 16                	jg     800e3a <vprintfmt+0x207>
  800e24:	48 b8 c0 45 80 00 00 	movabs $0x8045c0,%rax
  800e2b:	00 00 00 
  800e2e:	48 63 d3             	movslq %ebx,%rdx
  800e31:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e35:	4d 85 e4             	test   %r12,%r12
  800e38:	75 2e                	jne    800e68 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800e3a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e42:	89 d9                	mov    %ebx,%ecx
  800e44:	48 ba 81 46 80 00 00 	movabs $0x804681,%rdx
  800e4b:	00 00 00 
  800e4e:	48 89 c7             	mov    %rax,%rdi
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
  800e56:	49 b8 44 11 80 00 00 	movabs $0x801144,%r8
  800e5d:	00 00 00 
  800e60:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e63:	e9 ce 02 00 00       	jmpq   801136 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800e68:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e70:	4c 89 e1             	mov    %r12,%rcx
  800e73:	48 ba 8a 46 80 00 00 	movabs $0x80468a,%rdx
  800e7a:	00 00 00 
  800e7d:	48 89 c7             	mov    %rax,%rdi
  800e80:	b8 00 00 00 00       	mov    $0x0,%eax
  800e85:	49 b8 44 11 80 00 00 	movabs $0x801144,%r8
  800e8c:	00 00 00 
  800e8f:	41 ff d0             	callq  *%r8
			break;
  800e92:	e9 9f 02 00 00       	jmpq   801136 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e9a:	83 f8 30             	cmp    $0x30,%eax
  800e9d:	73 17                	jae    800eb6 <vprintfmt+0x283>
  800e9f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ea6:	89 d2                	mov    %edx,%edx
  800ea8:	48 01 d0             	add    %rdx,%rax
  800eab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eae:	83 c2 08             	add    $0x8,%edx
  800eb1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800eb4:	eb 0c                	jmp    800ec2 <vprintfmt+0x28f>
  800eb6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800eba:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ebe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ec2:	4c 8b 20             	mov    (%rax),%r12
  800ec5:	4d 85 e4             	test   %r12,%r12
  800ec8:	75 0a                	jne    800ed4 <vprintfmt+0x2a1>
				p = "(null)";
  800eca:	49 bc 8d 46 80 00 00 	movabs $0x80468d,%r12
  800ed1:	00 00 00 
			if (width > 0 && padc != '-')
  800ed4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed8:	7e 3f                	jle    800f19 <vprintfmt+0x2e6>
  800eda:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ede:	74 39                	je     800f19 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ee3:	48 98                	cltq   
  800ee5:	48 89 c6             	mov    %rax,%rsi
  800ee8:	4c 89 e7             	mov    %r12,%rdi
  800eeb:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  800ef2:	00 00 00 
  800ef5:	ff d0                	callq  *%rax
  800ef7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800efa:	eb 17                	jmp    800f13 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800efc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800f00:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f08:	48 89 ce             	mov    %rcx,%rsi
  800f0b:	89 d7                	mov    %edx,%edi
  800f0d:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800f0f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f13:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f17:	7f e3                	jg     800efc <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f19:	eb 37                	jmp    800f52 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800f1b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f1f:	74 1e                	je     800f3f <vprintfmt+0x30c>
  800f21:	83 fb 1f             	cmp    $0x1f,%ebx
  800f24:	7e 05                	jle    800f2b <vprintfmt+0x2f8>
  800f26:	83 fb 7e             	cmp    $0x7e,%ebx
  800f29:	7e 14                	jle    800f3f <vprintfmt+0x30c>
					putch('?', putdat);
  800f2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f33:	48 89 d6             	mov    %rdx,%rsi
  800f36:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f3b:	ff d0                	callq  *%rax
  800f3d:	eb 0f                	jmp    800f4e <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800f3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f47:	48 89 d6             	mov    %rdx,%rsi
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f4e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f52:	4c 89 e0             	mov    %r12,%rax
  800f55:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f59:	0f b6 00             	movzbl (%rax),%eax
  800f5c:	0f be d8             	movsbl %al,%ebx
  800f5f:	85 db                	test   %ebx,%ebx
  800f61:	74 10                	je     800f73 <vprintfmt+0x340>
  800f63:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f67:	78 b2                	js     800f1b <vprintfmt+0x2e8>
  800f69:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f71:	79 a8                	jns    800f1b <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800f73:	eb 16                	jmp    800f8b <vprintfmt+0x358>
				putch(' ', putdat);
  800f75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7d:	48 89 d6             	mov    %rdx,%rsi
  800f80:	bf 20 00 00 00       	mov    $0x20,%edi
  800f85:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800f87:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f8f:	7f e4                	jg     800f75 <vprintfmt+0x342>
			break;
  800f91:	e9 a0 01 00 00       	jmpq   801136 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f9a:	be 03 00 00 00       	mov    $0x3,%esi
  800f9f:	48 89 c7             	mov    %rax,%rdi
  800fa2:	48 b8 2c 0b 80 00 00 	movabs $0x800b2c,%rax
  800fa9:	00 00 00 
  800fac:	ff d0                	callq  *%rax
  800fae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb6:	48 85 c0             	test   %rax,%rax
  800fb9:	79 1d                	jns    800fd8 <vprintfmt+0x3a5>
				putch('-', putdat);
  800fbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc3:	48 89 d6             	mov    %rdx,%rsi
  800fc6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fcb:	ff d0                	callq  *%rax
				num = -(long long) num;
  800fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd1:	48 f7 d8             	neg    %rax
  800fd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800fd8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fdf:	e9 e5 00 00 00       	jmpq   8010c9 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fe4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fe8:	be 03 00 00 00       	mov    $0x3,%esi
  800fed:	48 89 c7             	mov    %rax,%rdi
  800ff0:	48 b8 25 0a 80 00 00 	movabs $0x800a25,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	callq  *%rax
  800ffc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801000:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801007:	e9 bd 00 00 00       	jmpq   8010c9 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80100c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801010:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801014:	48 89 d6             	mov    %rdx,%rsi
  801017:	bf 58 00 00 00       	mov    $0x58,%edi
  80101c:	ff d0                	callq  *%rax
			putch('X', putdat);
  80101e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801022:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801026:	48 89 d6             	mov    %rdx,%rsi
  801029:	bf 58 00 00 00       	mov    $0x58,%edi
  80102e:	ff d0                	callq  *%rax
			putch('X', putdat);
  801030:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801034:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801038:	48 89 d6             	mov    %rdx,%rsi
  80103b:	bf 58 00 00 00       	mov    $0x58,%edi
  801040:	ff d0                	callq  *%rax
			break;
  801042:	e9 ef 00 00 00       	jmpq   801136 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  801047:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80104b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80104f:	48 89 d6             	mov    %rdx,%rsi
  801052:	bf 30 00 00 00       	mov    $0x30,%edi
  801057:	ff d0                	callq  *%rax
			putch('x', putdat);
  801059:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80105d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801061:	48 89 d6             	mov    %rdx,%rsi
  801064:	bf 78 00 00 00       	mov    $0x78,%edi
  801069:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80106b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80106e:	83 f8 30             	cmp    $0x30,%eax
  801071:	73 17                	jae    80108a <vprintfmt+0x457>
  801073:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801077:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80107a:	89 d2                	mov    %edx,%edx
  80107c:	48 01 d0             	add    %rdx,%rax
  80107f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801082:	83 c2 08             	add    $0x8,%edx
  801085:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  801088:	eb 0c                	jmp    801096 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  80108a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80108e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801092:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801096:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  801099:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80109d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8010a4:	eb 23                	jmp    8010c9 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8010a6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010aa:	be 03 00 00 00       	mov    $0x3,%esi
  8010af:	48 89 c7             	mov    %rax,%rdi
  8010b2:	48 b8 25 0a 80 00 00 	movabs $0x800a25,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	callq  *%rax
  8010be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010c2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010ce:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010d1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e0:	45 89 c1             	mov    %r8d,%r9d
  8010e3:	41 89 f8             	mov    %edi,%r8d
  8010e6:	48 89 c7             	mov    %rax,%rdi
  8010e9:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  8010f0:	00 00 00 
  8010f3:	ff d0                	callq  *%rax
			break;
  8010f5:	eb 3f                	jmp    801136 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ff:	48 89 d6             	mov    %rdx,%rsi
  801102:	89 df                	mov    %ebx,%edi
  801104:	ff d0                	callq  *%rax
			break;
  801106:	eb 2e                	jmp    801136 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801108:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80110c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801110:	48 89 d6             	mov    %rdx,%rsi
  801113:	bf 25 00 00 00       	mov    $0x25,%edi
  801118:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80111a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80111f:	eb 05                	jmp    801126 <vprintfmt+0x4f3>
  801121:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801126:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80112a:	48 83 e8 01          	sub    $0x1,%rax
  80112e:	0f b6 00             	movzbl (%rax),%eax
  801131:	3c 25                	cmp    $0x25,%al
  801133:	75 ec                	jne    801121 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801135:	90                   	nop
		}
	}
  801136:	e9 31 fb ff ff       	jmpq   800c6c <vprintfmt+0x39>
	va_end(aq);
}
  80113b:	48 83 c4 60          	add    $0x60,%rsp
  80113f:	5b                   	pop    %rbx
  801140:	41 5c                	pop    %r12
  801142:	5d                   	pop    %rbp
  801143:	c3                   	retq   

0000000000801144 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801144:	55                   	push   %rbp
  801145:	48 89 e5             	mov    %rsp,%rbp
  801148:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80114f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801156:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80115d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801164:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80116b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801172:	84 c0                	test   %al,%al
  801174:	74 20                	je     801196 <printfmt+0x52>
  801176:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80117a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80117e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801182:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801186:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80118a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80118e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801192:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801196:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80119d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8011a4:	00 00 00 
  8011a7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8011ae:	00 00 00 
  8011b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011b5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011bc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011c3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011ca:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011d8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011df:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011e6:	48 89 c7             	mov    %rax,%rdi
  8011e9:	48 b8 33 0c 80 00 00 	movabs $0x800c33,%rax
  8011f0:	00 00 00 
  8011f3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011f5:	c9                   	leaveq 
  8011f6:	c3                   	retq   

00000000008011f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	48 83 ec 10          	sub    $0x10,%rsp
  8011ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120a:	8b 40 10             	mov    0x10(%rax),%eax
  80120d:	8d 50 01             	lea    0x1(%rax),%edx
  801210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801214:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121b:	48 8b 10             	mov    (%rax),%rdx
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	48 8b 40 08          	mov    0x8(%rax),%rax
  801226:	48 39 c2             	cmp    %rax,%rdx
  801229:	73 17                	jae    801242 <sprintputch+0x4b>
		*b->buf++ = ch;
  80122b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122f:	48 8b 00             	mov    (%rax),%rax
  801232:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80123a:	48 89 0a             	mov    %rcx,(%rdx)
  80123d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801240:	88 10                	mov    %dl,(%rax)
}
  801242:	c9                   	leaveq 
  801243:	c3                   	retq   

0000000000801244 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	48 83 ec 50          	sub    $0x50,%rsp
  80124c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801250:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801253:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801257:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80125b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80125f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801263:	48 8b 0a             	mov    (%rdx),%rcx
  801266:	48 89 08             	mov    %rcx,(%rax)
  801269:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80126d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801271:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801275:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801279:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80127d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801281:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801284:	48 98                	cltq   
  801286:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80128a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80128e:	48 01 d0             	add    %rdx,%rax
  801291:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801295:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80129c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8012a1:	74 06                	je     8012a9 <vsnprintf+0x65>
  8012a3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8012a7:	7f 07                	jg     8012b0 <vsnprintf+0x6c>
		return -E_INVAL;
  8012a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ae:	eb 2f                	jmp    8012df <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8012b0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8012b4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8012b8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012bc:	48 89 c6             	mov    %rax,%rsi
  8012bf:	48 bf f7 11 80 00 00 	movabs $0x8011f7,%rdi
  8012c6:	00 00 00 
  8012c9:	48 b8 33 0c 80 00 00 	movabs $0x800c33,%rax
  8012d0:	00 00 00 
  8012d3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012d9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012dc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012ec:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012f3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801300:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801307:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80130e:	84 c0                	test   %al,%al
  801310:	74 20                	je     801332 <snprintf+0x51>
  801312:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801316:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80131a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80131e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801322:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801326:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80132a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80132e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801332:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801339:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801340:	00 00 00 
  801343:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80134a:	00 00 00 
  80134d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801351:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801358:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80135f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801366:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80136d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801374:	48 8b 0a             	mov    (%rdx),%rcx
  801377:	48 89 08             	mov    %rcx,(%rax)
  80137a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80137e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801382:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801386:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80138a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801391:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801398:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80139e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8013a5:	48 89 c7             	mov    %rax,%rdi
  8013a8:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  8013af:	00 00 00 
  8013b2:	ff d0                	callq  *%rax
  8013b4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013ba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013c0:	c9                   	leaveq 
  8013c1:	c3                   	retq   

00000000008013c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013c2:	55                   	push   %rbp
  8013c3:	48 89 e5             	mov    %rsp,%rbp
  8013c6:	48 83 ec 18          	sub    $0x18,%rsp
  8013ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013d5:	eb 09                	jmp    8013e0 <strlen+0x1e>
		n++;
  8013d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8013db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	84 c0                	test   %al,%al
  8013e9:	75 ec                	jne    8013d7 <strlen+0x15>
	return n;
  8013eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ee:	c9                   	leaveq 
  8013ef:	c3                   	retq   

00000000008013f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013f0:	55                   	push   %rbp
  8013f1:	48 89 e5             	mov    %rsp,%rbp
  8013f4:	48 83 ec 20          	sub    $0x20,%rsp
  8013f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801407:	eb 0e                	jmp    801417 <strnlen+0x27>
		n++;
  801409:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801412:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801417:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80141c:	74 0b                	je     801429 <strnlen+0x39>
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	84 c0                	test   %al,%al
  801427:	75 e0                	jne    801409 <strnlen+0x19>
	return n;
  801429:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80142c:	c9                   	leaveq 
  80142d:	c3                   	retq   

000000000080142e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	48 83 ec 20          	sub    $0x20,%rsp
  801436:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80143a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80144f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801453:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801457:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80145b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80145f:	0f b6 12             	movzbl (%rdx),%edx
  801462:	88 10                	mov    %dl,(%rax)
  801464:	0f b6 00             	movzbl (%rax),%eax
  801467:	84 c0                	test   %al,%al
  801469:	75 dc                	jne    801447 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80146b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80146f:	c9                   	leaveq 
  801470:	c3                   	retq   

0000000000801471 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801471:	55                   	push   %rbp
  801472:	48 89 e5             	mov    %rsp,%rbp
  801475:	48 83 ec 20          	sub    $0x20,%rsp
  801479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801485:	48 89 c7             	mov    %rax,%rdi
  801488:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  80148f:	00 00 00 
  801492:	ff d0                	callq  *%rax
  801494:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80149a:	48 63 d0             	movslq %eax,%rdx
  80149d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a1:	48 01 c2             	add    %rax,%rdx
  8014a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a8:	48 89 c6             	mov    %rax,%rsi
  8014ab:	48 89 d7             	mov    %rdx,%rdi
  8014ae:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8014b5:	00 00 00 
  8014b8:	ff d0                	callq  *%rax
	return dst;
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 28          	sub    $0x28,%rsp
  8014c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014dc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014e3:	00 
  8014e4:	eb 2a                	jmp    801510 <strncpy+0x50>
		*dst++ = *src;
  8014e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014f6:	0f b6 12             	movzbl (%rdx),%edx
  8014f9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	84 c0                	test   %al,%al
  801504:	74 05                	je     80150b <strncpy+0x4b>
			src++;
  801506:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80150b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801514:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801518:	72 cc                	jb     8014e6 <strncpy+0x26>
	}
	return ret;
  80151a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80151e:	c9                   	leaveq 
  80151f:	c3                   	retq   

0000000000801520 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801520:	55                   	push   %rbp
  801521:	48 89 e5             	mov    %rsp,%rbp
  801524:	48 83 ec 28          	sub    $0x28,%rsp
  801528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801538:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80153c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801541:	74 3d                	je     801580 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801543:	eb 1d                	jmp    801562 <strlcpy+0x42>
			*dst++ = *src++;
  801545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801549:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80154d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801551:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801555:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801559:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80155d:	0f b6 12             	movzbl (%rdx),%edx
  801560:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801562:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801567:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80156c:	74 0b                	je     801579 <strlcpy+0x59>
  80156e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	84 c0                	test   %al,%al
  801577:	75 cc                	jne    801545 <strlcpy+0x25>
		*dst = '\0';
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801588:	48 29 c2             	sub    %rax,%rdx
  80158b:	48 89 d0             	mov    %rdx,%rax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 10          	sub    $0x10,%rsp
  801598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015a0:	eb 0a                	jmp    8015ac <strcmp+0x1c>
		p++, q++;
  8015a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8015ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b0:	0f b6 00             	movzbl (%rax),%eax
  8015b3:	84 c0                	test   %al,%al
  8015b5:	74 12                	je     8015c9 <strcmp+0x39>
  8015b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bb:	0f b6 10             	movzbl (%rax),%edx
  8015be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	38 c2                	cmp    %al,%dl
  8015c7:	74 d9                	je     8015a2 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	0f b6 d0             	movzbl %al,%edx
  8015d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d7:	0f b6 00             	movzbl (%rax),%eax
  8015da:	0f b6 c0             	movzbl %al,%eax
  8015dd:	29 c2                	sub    %eax,%edx
  8015df:	89 d0                	mov    %edx,%eax
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 18          	sub    $0x18,%rsp
  8015eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015f7:	eb 0f                	jmp    801608 <strncmp+0x25>
		n--, p++, q++;
  8015f9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801603:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801608:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80160d:	74 1d                	je     80162c <strncmp+0x49>
  80160f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	84 c0                	test   %al,%al
  801618:	74 12                	je     80162c <strncmp+0x49>
  80161a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161e:	0f b6 10             	movzbl (%rax),%edx
  801621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801625:	0f b6 00             	movzbl (%rax),%eax
  801628:	38 c2                	cmp    %al,%dl
  80162a:	74 cd                	je     8015f9 <strncmp+0x16>
	if (n == 0)
  80162c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801631:	75 07                	jne    80163a <strncmp+0x57>
		return 0;
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	eb 18                	jmp    801652 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80163a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	0f b6 d0             	movzbl %al,%edx
  801644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	0f b6 c0             	movzbl %al,%eax
  80164e:	29 c2                	sub    %eax,%edx
  801650:	89 d0                	mov    %edx,%eax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 10          	sub    $0x10,%rsp
  80165c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801660:	89 f0                	mov    %esi,%eax
  801662:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801665:	eb 17                	jmp    80167e <strchr+0x2a>
		if (*s == c)
  801667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801671:	75 06                	jne    801679 <strchr+0x25>
			return (char *) s;
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801677:	eb 15                	jmp    80168e <strchr+0x3a>
	for (; *s; s++)
  801679:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	84 c0                	test   %al,%al
  801687:	75 de                	jne    801667 <strchr+0x13>
	return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
  801694:	48 83 ec 10          	sub    $0x10,%rsp
  801698:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169c:	89 f0                	mov    %esi,%eax
  80169e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016a1:	eb 13                	jmp    8016b6 <strfind+0x26>
		if (*s == c)
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016ad:	75 02                	jne    8016b1 <strfind+0x21>
			break;
  8016af:	eb 10                	jmp    8016c1 <strfind+0x31>
	for (; *s; s++)
  8016b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	84 c0                	test   %al,%al
  8016bf:	75 e2                	jne    8016a3 <strfind+0x13>
	return (char *) s;
  8016c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016c5:	c9                   	leaveq 
  8016c6:	c3                   	retq   

00000000008016c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016c7:	55                   	push   %rbp
  8016c8:	48 89 e5             	mov    %rsp,%rbp
  8016cb:	48 83 ec 18          	sub    $0x18,%rsp
  8016cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016df:	75 06                	jne    8016e7 <memset+0x20>
		return v;
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	eb 69                	jmp    801750 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016eb:	83 e0 03             	and    $0x3,%eax
  8016ee:	48 85 c0             	test   %rax,%rax
  8016f1:	75 48                	jne    80173b <memset+0x74>
  8016f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f7:	83 e0 03             	and    $0x3,%eax
  8016fa:	48 85 c0             	test   %rax,%rax
  8016fd:	75 3c                	jne    80173b <memset+0x74>
		c &= 0xFF;
  8016ff:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801706:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801709:	c1 e0 18             	shl    $0x18,%eax
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801711:	c1 e0 10             	shl    $0x10,%eax
  801714:	09 c2                	or     %eax,%edx
  801716:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801719:	c1 e0 08             	shl    $0x8,%eax
  80171c:	09 d0                	or     %edx,%eax
  80171e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801725:	48 c1 e8 02          	shr    $0x2,%rax
  801729:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80172c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801730:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801733:	48 89 d7             	mov    %rdx,%rdi
  801736:	fc                   	cld    
  801737:	f3 ab                	rep stos %eax,%es:(%rdi)
  801739:	eb 11                	jmp    80174c <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80173b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801742:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801746:	48 89 d7             	mov    %rdx,%rdi
  801749:	fc                   	cld    
  80174a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80174c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801750:	c9                   	leaveq 
  801751:	c3                   	retq   

0000000000801752 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801752:	55                   	push   %rbp
  801753:	48 89 e5             	mov    %rsp,%rbp
  801756:	48 83 ec 28          	sub    $0x28,%rsp
  80175a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80175e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801766:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80176e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801772:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80177e:	0f 83 88 00 00 00    	jae    80180c <memmove+0xba>
  801784:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	48 01 d0             	add    %rdx,%rax
  80178f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801793:	76 77                	jbe    80180c <memmove+0xba>
		s += n;
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a9:	83 e0 03             	and    $0x3,%eax
  8017ac:	48 85 c0             	test   %rax,%rax
  8017af:	75 3b                	jne    8017ec <memmove+0x9a>
  8017b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b5:	83 e0 03             	and    $0x3,%eax
  8017b8:	48 85 c0             	test   %rax,%rax
  8017bb:	75 2f                	jne    8017ec <memmove+0x9a>
  8017bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c1:	83 e0 03             	and    $0x3,%eax
  8017c4:	48 85 c0             	test   %rax,%rax
  8017c7:	75 23                	jne    8017ec <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cd:	48 83 e8 04          	sub    $0x4,%rax
  8017d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d5:	48 83 ea 04          	sub    $0x4,%rdx
  8017d9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017dd:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8017e1:	48 89 c7             	mov    %rax,%rdi
  8017e4:	48 89 d6             	mov    %rdx,%rsi
  8017e7:	fd                   	std    
  8017e8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ea:	eb 1d                	jmp    801809 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 89 d7             	mov    %rdx,%rdi
  801803:	48 89 c1             	mov    %rax,%rcx
  801806:	fd                   	std    
  801807:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801809:	fc                   	cld    
  80180a:	eb 57                	jmp    801863 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80180c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801810:	83 e0 03             	and    $0x3,%eax
  801813:	48 85 c0             	test   %rax,%rax
  801816:	75 36                	jne    80184e <memmove+0xfc>
  801818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181c:	83 e0 03             	and    $0x3,%eax
  80181f:	48 85 c0             	test   %rax,%rax
  801822:	75 2a                	jne    80184e <memmove+0xfc>
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	83 e0 03             	and    $0x3,%eax
  80182b:	48 85 c0             	test   %rax,%rax
  80182e:	75 1e                	jne    80184e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	48 c1 e8 02          	shr    $0x2,%rax
  801838:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80183b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801843:	48 89 c7             	mov    %rax,%rdi
  801846:	48 89 d6             	mov    %rdx,%rsi
  801849:	fc                   	cld    
  80184a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80184c:	eb 15                	jmp    801863 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80184e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801852:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801856:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80185a:	48 89 c7             	mov    %rax,%rdi
  80185d:	48 89 d6             	mov    %rdx,%rsi
  801860:	fc                   	cld    
  801861:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801867:	c9                   	leaveq 
  801868:	c3                   	retq   

0000000000801869 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801869:	55                   	push   %rbp
  80186a:	48 89 e5             	mov    %rsp,%rbp
  80186d:	48 83 ec 18          	sub    $0x18,%rsp
  801871:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801875:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801879:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80187d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801881:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801885:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801889:	48 89 ce             	mov    %rcx,%rsi
  80188c:	48 89 c7             	mov    %rax,%rdi
  80188f:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  801896:	00 00 00 
  801899:	ff d0                	callq  *%rax
}
  80189b:	c9                   	leaveq 
  80189c:	c3                   	retq   

000000000080189d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	48 83 ec 28          	sub    $0x28,%rsp
  8018a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018c1:	eb 36                	jmp    8018f9 <memcmp+0x5c>
		if (*s1 != *s2)
  8018c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c7:	0f b6 10             	movzbl (%rax),%edx
  8018ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	38 c2                	cmp    %al,%dl
  8018d3:	74 1a                	je     8018ef <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d9:	0f b6 00             	movzbl (%rax),%eax
  8018dc:	0f b6 d0             	movzbl %al,%edx
  8018df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	0f b6 c0             	movzbl %al,%eax
  8018e9:	29 c2                	sub    %eax,%edx
  8018eb:	89 d0                	mov    %edx,%eax
  8018ed:	eb 20                	jmp    80190f <memcmp+0x72>
		s1++, s2++;
  8018ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801901:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801905:	48 85 c0             	test   %rax,%rax
  801908:	75 b9                	jne    8018c3 <memcmp+0x26>
	}

	return 0;
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 28          	sub    $0x28,%rsp
  801919:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80191d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801920:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	48 01 d0             	add    %rdx,%rax
  80192f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801933:	eb 15                	jmp    80194a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801939:	0f b6 00             	movzbl (%rax),%eax
  80193c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80193f:	38 d0                	cmp    %dl,%al
  801941:	75 02                	jne    801945 <memfind+0x34>
			break;
  801943:	eb 0f                	jmp    801954 <memfind+0x43>
	for (; s < ends; s++)
  801945:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80194a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80194e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801952:	72 e1                	jb     801935 <memfind+0x24>
	return (void *) s;
  801954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801958:	c9                   	leaveq 
  801959:	c3                   	retq   

000000000080195a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80195a:	55                   	push   %rbp
  80195b:	48 89 e5             	mov    %rsp,%rbp
  80195e:	48 83 ec 38          	sub    $0x38,%rsp
  801962:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801966:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80196a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80196d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801974:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80197b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80197c:	eb 05                	jmp    801983 <strtol+0x29>
		s++;
  80197e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801983:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801987:	0f b6 00             	movzbl (%rax),%eax
  80198a:	3c 20                	cmp    $0x20,%al
  80198c:	74 f0                	je     80197e <strtol+0x24>
  80198e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801992:	0f b6 00             	movzbl (%rax),%eax
  801995:	3c 09                	cmp    $0x9,%al
  801997:	74 e5                	je     80197e <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801999:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199d:	0f b6 00             	movzbl (%rax),%eax
  8019a0:	3c 2b                	cmp    $0x2b,%al
  8019a2:	75 07                	jne    8019ab <strtol+0x51>
		s++;
  8019a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a9:	eb 17                	jmp    8019c2 <strtol+0x68>
	else if (*s == '-')
  8019ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	3c 2d                	cmp    $0x2d,%al
  8019b4:	75 0c                	jne    8019c2 <strtol+0x68>
		s++, neg = 1;
  8019b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019c6:	74 06                	je     8019ce <strtol+0x74>
  8019c8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019cc:	75 28                	jne    8019f6 <strtol+0x9c>
  8019ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	3c 30                	cmp    $0x30,%al
  8019d7:	75 1d                	jne    8019f6 <strtol+0x9c>
  8019d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dd:	48 83 c0 01          	add    $0x1,%rax
  8019e1:	0f b6 00             	movzbl (%rax),%eax
  8019e4:	3c 78                	cmp    $0x78,%al
  8019e6:	75 0e                	jne    8019f6 <strtol+0x9c>
		s += 2, base = 16;
  8019e8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019ed:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019f4:	eb 2c                	jmp    801a22 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019fa:	75 19                	jne    801a15 <strtol+0xbb>
  8019fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a00:	0f b6 00             	movzbl (%rax),%eax
  801a03:	3c 30                	cmp    $0x30,%al
  801a05:	75 0e                	jne    801a15 <strtol+0xbb>
		s++, base = 8;
  801a07:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a0c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a13:	eb 0d                	jmp    801a22 <strtol+0xc8>
	else if (base == 0)
  801a15:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a19:	75 07                	jne    801a22 <strtol+0xc8>
		base = 10;
  801a1b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a26:	0f b6 00             	movzbl (%rax),%eax
  801a29:	3c 2f                	cmp    $0x2f,%al
  801a2b:	7e 1d                	jle    801a4a <strtol+0xf0>
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	0f b6 00             	movzbl (%rax),%eax
  801a34:	3c 39                	cmp    $0x39,%al
  801a36:	7f 12                	jg     801a4a <strtol+0xf0>
			dig = *s - '0';
  801a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3c:	0f b6 00             	movzbl (%rax),%eax
  801a3f:	0f be c0             	movsbl %al,%eax
  801a42:	83 e8 30             	sub    $0x30,%eax
  801a45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a48:	eb 4e                	jmp    801a98 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4e:	0f b6 00             	movzbl (%rax),%eax
  801a51:	3c 60                	cmp    $0x60,%al
  801a53:	7e 1d                	jle    801a72 <strtol+0x118>
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	3c 7a                	cmp    $0x7a,%al
  801a5e:	7f 12                	jg     801a72 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	0f be c0             	movsbl %al,%eax
  801a6a:	83 e8 57             	sub    $0x57,%eax
  801a6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a70:	eb 26                	jmp    801a98 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a76:	0f b6 00             	movzbl (%rax),%eax
  801a79:	3c 40                	cmp    $0x40,%al
  801a7b:	7e 48                	jle    801ac5 <strtol+0x16b>
  801a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a81:	0f b6 00             	movzbl (%rax),%eax
  801a84:	3c 5a                	cmp    $0x5a,%al
  801a86:	7f 3d                	jg     801ac5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8c:	0f b6 00             	movzbl (%rax),%eax
  801a8f:	0f be c0             	movsbl %al,%eax
  801a92:	83 e8 37             	sub    $0x37,%eax
  801a95:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a9b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a9e:	7c 02                	jl     801aa2 <strtol+0x148>
			break;
  801aa0:	eb 23                	jmp    801ac5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801aa2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801aa7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801aaa:	48 98                	cltq   
  801aac:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ab7:	48 98                	cltq   
  801ab9:	48 01 d0             	add    %rdx,%rax
  801abc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ac0:	e9 5d ff ff ff       	jmpq   801a22 <strtol+0xc8>

	if (endptr)
  801ac5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801aca:	74 0b                	je     801ad7 <strtol+0x17d>
		*endptr = (char *) s;
  801acc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ad0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ad4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801adb:	74 09                	je     801ae6 <strtol+0x18c>
  801add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae1:	48 f7 d8             	neg    %rax
  801ae4:	eb 04                	jmp    801aea <strtol+0x190>
  801ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801aea:	c9                   	leaveq 
  801aeb:	c3                   	retq   

0000000000801aec <strstr>:

char * strstr(const char *in, const char *str)
{
  801aec:	55                   	push   %rbp
  801aed:	48 89 e5             	mov    %rsp,%rbp
  801af0:	48 83 ec 30          	sub    $0x30,%rsp
  801af4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801af8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801afc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b04:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b08:	0f b6 00             	movzbl (%rax),%eax
  801b0b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b0e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b12:	75 06                	jne    801b1a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b18:	eb 6b                	jmp    801b85 <strstr+0x99>

	len = strlen(str);
  801b1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b1e:	48 89 c7             	mov    %rax,%rdi
  801b21:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  801b28:	00 00 00 
  801b2b:	ff d0                	callq  *%rax
  801b2d:	48 98                	cltq   
  801b2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b3f:	0f b6 00             	movzbl (%rax),%eax
  801b42:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b45:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b49:	75 07                	jne    801b52 <strstr+0x66>
				return (char *) 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	eb 33                	jmp    801b85 <strstr+0x99>
		} while (sc != c);
  801b52:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b56:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b59:	75 d8                	jne    801b33 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b67:	48 89 ce             	mov    %rcx,%rsi
  801b6a:	48 89 c7             	mov    %rax,%rdi
  801b6d:	48 b8 e3 15 80 00 00 	movabs $0x8015e3,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	75 b6                	jne    801b33 <strstr+0x47>

	return (char *) (in - 1);
  801b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b81:	48 83 e8 01          	sub    $0x1,%rax
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   

0000000000801b87 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	53                   	push   %rbx
  801b8c:	48 83 ec 48          	sub    $0x48,%rsp
  801b90:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b93:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b96:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b9a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b9e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ba2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ba6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ba9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bad:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bb1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801bb5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bb9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bbd:	4c 89 c3             	mov    %r8,%rbx
  801bc0:	cd 30                	int    $0x30
  801bc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bc6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bca:	74 3e                	je     801c0a <syscall+0x83>
  801bcc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bd1:	7e 37                	jle    801c0a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bd7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bda:	49 89 d0             	mov    %rdx,%r8
  801bdd:	89 c1                	mov    %eax,%ecx
  801bdf:	48 ba 48 49 80 00 00 	movabs $0x804948,%rdx
  801be6:	00 00 00 
  801be9:	be 23 00 00 00       	mov    $0x23,%esi
  801bee:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
  801bf5:	00 00 00 
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfd:	49 b9 5b 06 80 00 00 	movabs $0x80065b,%r9
  801c04:	00 00 00 
  801c07:	41 ff d1             	callq  *%r9

	return ret;
  801c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c0e:	48 83 c4 48          	add    $0x48,%rsp
  801c12:	5b                   	pop    %rbx
  801c13:	5d                   	pop    %rbp
  801c14:	c3                   	retq   

0000000000801c15 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c15:	55                   	push   %rbp
  801c16:	48 89 e5             	mov    %rsp,%rbp
  801c19:	48 83 ec 10          	sub    $0x10,%rsp
  801c1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2d:	48 83 ec 08          	sub    $0x8,%rsp
  801c31:	6a 00                	pushq  $0x0
  801c33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3f:	48 89 d1             	mov    %rdx,%rcx
  801c42:	48 89 c2             	mov    %rax,%rdx
  801c45:	be 00 00 00 00       	mov    $0x0,%esi
  801c4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4f:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801c56:	00 00 00 
  801c59:	ff d0                	callq  *%rax
  801c5b:	48 83 c4 10          	add    $0x10,%rsp
}
  801c5f:	c9                   	leaveq 
  801c60:	c3                   	retq   

0000000000801c61 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c65:	48 83 ec 08          	sub    $0x8,%rsp
  801c69:	6a 00                	pushq  $0x0
  801c6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c77:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c81:	be 00 00 00 00       	mov    $0x0,%esi
  801c86:	bf 01 00 00 00       	mov    $0x1,%edi
  801c8b:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	callq  *%rax
  801c97:	48 83 c4 10          	add    $0x10,%rsp
}
  801c9b:	c9                   	leaveq 
  801c9c:	c3                   	retq   

0000000000801c9d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c9d:	55                   	push   %rbp
  801c9e:	48 89 e5             	mov    %rsp,%rbp
  801ca1:	48 83 ec 10          	sub    $0x10,%rsp
  801ca5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cab:	48 98                	cltq   
  801cad:	48 83 ec 08          	sub    $0x8,%rsp
  801cb1:	6a 00                	pushq  $0x0
  801cb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc4:	48 89 c2             	mov    %rax,%rdx
  801cc7:	be 01 00 00 00       	mov    $0x1,%esi
  801ccc:	bf 03 00 00 00       	mov    $0x3,%edi
  801cd1:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
  801cdd:	48 83 c4 10          	add    $0x10,%rsp
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   

0000000000801ce3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ce7:	48 83 ec 08          	sub    $0x8,%rsp
  801ceb:	6a 00                	pushq  $0x0
  801ced:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801d03:	be 00 00 00 00       	mov    $0x0,%esi
  801d08:	bf 02 00 00 00       	mov    $0x2,%edi
  801d0d:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	callq  *%rax
  801d19:	48 83 c4 10          	add    $0x10,%rsp
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_yield>:

void
sys_yield(void)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d23:	48 83 ec 08          	sub    $0x8,%rsp
  801d27:	6a 00                	pushq  $0x0
  801d29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d35:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3f:	be 00 00 00 00       	mov    $0x0,%esi
  801d44:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d49:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801d50:	00 00 00 
  801d53:	ff d0                	callq  *%rax
  801d55:	48 83 c4 10          	add    $0x10,%rsp
}
  801d59:	c9                   	leaveq 
  801d5a:	c3                   	retq   

0000000000801d5b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d5b:	55                   	push   %rbp
  801d5c:	48 89 e5             	mov    %rsp,%rbp
  801d5f:	48 83 ec 10          	sub    $0x10,%rsp
  801d63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d6a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d70:	48 63 c8             	movslq %eax,%rcx
  801d73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7a:	48 98                	cltq   
  801d7c:	48 83 ec 08          	sub    $0x8,%rsp
  801d80:	6a 00                	pushq  $0x0
  801d82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d88:	49 89 c8             	mov    %rcx,%r8
  801d8b:	48 89 d1             	mov    %rdx,%rcx
  801d8e:	48 89 c2             	mov    %rax,%rdx
  801d91:	be 01 00 00 00       	mov    $0x1,%esi
  801d96:	bf 04 00 00 00       	mov    $0x4,%edi
  801d9b:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax
  801da7:	48 83 c4 10          	add    $0x10,%rsp
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 20          	sub    $0x20,%rsp
  801db5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dbc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dbf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dc3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dc7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dca:	48 63 c8             	movslq %eax,%rcx
  801dcd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd4:	48 63 f0             	movslq %eax,%rsi
  801dd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dde:	48 98                	cltq   
  801de0:	48 83 ec 08          	sub    $0x8,%rsp
  801de4:	51                   	push   %rcx
  801de5:	49 89 f9             	mov    %rdi,%r9
  801de8:	49 89 f0             	mov    %rsi,%r8
  801deb:	48 89 d1             	mov    %rdx,%rcx
  801dee:	48 89 c2             	mov    %rax,%rdx
  801df1:	be 01 00 00 00       	mov    $0x1,%esi
  801df6:	bf 05 00 00 00       	mov    $0x5,%edi
  801dfb:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	callq  *%rax
  801e07:	48 83 c4 10          	add    $0x10,%rsp
}
  801e0b:	c9                   	leaveq 
  801e0c:	c3                   	retq   

0000000000801e0d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e0d:	55                   	push   %rbp
  801e0e:	48 89 e5             	mov    %rsp,%rbp
  801e11:	48 83 ec 10          	sub    $0x10,%rsp
  801e15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e23:	48 98                	cltq   
  801e25:	48 83 ec 08          	sub    $0x8,%rsp
  801e29:	6a 00                	pushq  $0x0
  801e2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e31:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e37:	48 89 d1             	mov    %rdx,%rcx
  801e3a:	48 89 c2             	mov    %rax,%rdx
  801e3d:	be 01 00 00 00       	mov    $0x1,%esi
  801e42:	bf 06 00 00 00       	mov    $0x6,%edi
  801e47:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	callq  *%rax
  801e53:	48 83 c4 10          	add    $0x10,%rsp
}
  801e57:	c9                   	leaveq 
  801e58:	c3                   	retq   

0000000000801e59 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e59:	55                   	push   %rbp
  801e5a:	48 89 e5             	mov    %rsp,%rbp
  801e5d:	48 83 ec 10          	sub    $0x10,%rsp
  801e61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e64:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e6a:	48 63 d0             	movslq %eax,%rdx
  801e6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e70:	48 98                	cltq   
  801e72:	48 83 ec 08          	sub    $0x8,%rsp
  801e76:	6a 00                	pushq  $0x0
  801e78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e84:	48 89 d1             	mov    %rdx,%rcx
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	be 01 00 00 00       	mov    $0x1,%esi
  801e8f:	bf 08 00 00 00       	mov    $0x8,%edi
  801e94:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801e9b:	00 00 00 
  801e9e:	ff d0                	callq  *%rax
  801ea0:	48 83 c4 10          	add    $0x10,%rsp
}
  801ea4:	c9                   	leaveq 
  801ea5:	c3                   	retq   

0000000000801ea6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ea6:	55                   	push   %rbp
  801ea7:	48 89 e5             	mov    %rsp,%rbp
  801eaa:	48 83 ec 10          	sub    $0x10,%rsp
  801eae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801eb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ebc:	48 98                	cltq   
  801ebe:	48 83 ec 08          	sub    $0x8,%rsp
  801ec2:	6a 00                	pushq  $0x0
  801ec4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed0:	48 89 d1             	mov    %rdx,%rcx
  801ed3:	48 89 c2             	mov    %rax,%rdx
  801ed6:	be 01 00 00 00       	mov    $0x1,%esi
  801edb:	bf 09 00 00 00       	mov    $0x9,%edi
  801ee0:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	callq  *%rax
  801eec:	48 83 c4 10          	add    $0x10,%rsp
}
  801ef0:	c9                   	leaveq 
  801ef1:	c3                   	retq   

0000000000801ef2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ef2:	55                   	push   %rbp
  801ef3:	48 89 e5             	mov    %rsp,%rbp
  801ef6:	48 83 ec 10          	sub    $0x10,%rsp
  801efa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801efd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f08:	48 98                	cltq   
  801f0a:	48 83 ec 08          	sub    $0x8,%rsp
  801f0e:	6a 00                	pushq  $0x0
  801f10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f1c:	48 89 d1             	mov    %rdx,%rcx
  801f1f:	48 89 c2             	mov    %rax,%rdx
  801f22:	be 01 00 00 00       	mov    $0x1,%esi
  801f27:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f2c:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801f33:	00 00 00 
  801f36:	ff d0                	callq  *%rax
  801f38:	48 83 c4 10          	add    $0x10,%rsp
}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 20          	sub    $0x20,%rsp
  801f46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f4d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f51:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f57:	48 63 f0             	movslq %eax,%rsi
  801f5a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f61:	48 98                	cltq   
  801f63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f67:	48 83 ec 08          	sub    $0x8,%rsp
  801f6b:	6a 00                	pushq  $0x0
  801f6d:	49 89 f1             	mov    %rsi,%r9
  801f70:	49 89 c8             	mov    %rcx,%r8
  801f73:	48 89 d1             	mov    %rdx,%rcx
  801f76:	48 89 c2             	mov    %rax,%rdx
  801f79:	be 00 00 00 00       	mov    $0x0,%esi
  801f7e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f83:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	callq  *%rax
  801f8f:	48 83 c4 10          	add    $0x10,%rsp
}
  801f93:	c9                   	leaveq 
  801f94:	c3                   	retq   

0000000000801f95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f95:	55                   	push   %rbp
  801f96:	48 89 e5             	mov    %rsp,%rbp
  801f99:	48 83 ec 10          	sub    $0x10,%rsp
  801f9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa5:	48 83 ec 08          	sub    $0x8,%rsp
  801fa9:	6a 00                	pushq  $0x0
  801fab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fbc:	48 89 c2             	mov    %rax,%rdx
  801fbf:	be 01 00 00 00       	mov    $0x1,%esi
  801fc4:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fc9:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
  801fd5:	48 83 c4 10          	add    $0x10,%rsp
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fdf:	48 83 ec 08          	sub    $0x8,%rsp
  801fe3:	6a 00                	pushq  $0x0
  801fe5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801feb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ff6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffb:	be 00 00 00 00       	mov    $0x0,%esi
  802000:	bf 0e 00 00 00       	mov    $0xe,%edi
  802005:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	48 83 c4 10          	add    $0x10,%rsp
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 20          	sub    $0x20,%rsp
  80201f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802022:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802026:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802029:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80202d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802031:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802034:	48 63 c8             	movslq %eax,%rcx
  802037:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80203b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80203e:	48 63 f0             	movslq %eax,%rsi
  802041:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802048:	48 98                	cltq   
  80204a:	48 83 ec 08          	sub    $0x8,%rsp
  80204e:	51                   	push   %rcx
  80204f:	49 89 f9             	mov    %rdi,%r9
  802052:	49 89 f0             	mov    %rsi,%r8
  802055:	48 89 d1             	mov    %rdx,%rcx
  802058:	48 89 c2             	mov    %rax,%rdx
  80205b:	be 00 00 00 00       	mov    $0x0,%esi
  802060:	bf 0f 00 00 00       	mov    $0xf,%edi
  802065:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  80206c:	00 00 00 
  80206f:	ff d0                	callq  *%rax
  802071:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802075:	c9                   	leaveq 
  802076:	c3                   	retq   

0000000000802077 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802077:	55                   	push   %rbp
  802078:	48 89 e5             	mov    %rsp,%rbp
  80207b:	48 83 ec 10          	sub    $0x10,%rsp
  80207f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802083:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802087:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80208b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80208f:	48 83 ec 08          	sub    $0x8,%rsp
  802093:	6a 00                	pushq  $0x0
  802095:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80209b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020a1:	48 89 d1             	mov    %rdx,%rcx
  8020a4:	48 89 c2             	mov    %rax,%rdx
  8020a7:	be 00 00 00 00       	mov    $0x0,%esi
  8020ac:	bf 10 00 00 00       	mov    $0x10,%edi
  8020b1:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8020b8:	00 00 00 
  8020bb:	ff d0                	callq  *%rax
  8020bd:	48 83 c4 10          	add    $0x10,%rsp
}
  8020c1:	c9                   	leaveq 
  8020c2:	c3                   	retq   

00000000008020c3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020c3:	55                   	push   %rbp
  8020c4:	48 89 e5             	mov    %rsp,%rbp
  8020c7:	48 83 ec 08          	sub    $0x8,%rsp
  8020cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020d3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020da:	ff ff ff 
  8020dd:	48 01 d0             	add    %rdx,%rax
  8020e0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020e4:	c9                   	leaveq 
  8020e5:	c3                   	retq   

00000000008020e6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020e6:	55                   	push   %rbp
  8020e7:	48 89 e5             	mov    %rsp,%rbp
  8020ea:	48 83 ec 08          	sub    $0x8,%rsp
  8020ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f6:	48 89 c7             	mov    %rax,%rdi
  8020f9:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80210b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80210f:	c9                   	leaveq 
  802110:	c3                   	retq   

0000000000802111 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
  802115:	48 83 ec 18          	sub    $0x18,%rsp
  802119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80211d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802124:	eb 6b                	jmp    802191 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802129:	48 98                	cltq   
  80212b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802131:	48 c1 e0 0c          	shl    $0xc,%rax
  802135:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213d:	48 c1 e8 15          	shr    $0x15,%rax
  802141:	48 89 c2             	mov    %rax,%rdx
  802144:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80214b:	01 00 00 
  80214e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802152:	83 e0 01             	and    $0x1,%eax
  802155:	48 85 c0             	test   %rax,%rax
  802158:	74 21                	je     80217b <fd_alloc+0x6a>
  80215a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80215e:	48 c1 e8 0c          	shr    $0xc,%rax
  802162:	48 89 c2             	mov    %rax,%rdx
  802165:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80216c:	01 00 00 
  80216f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802173:	83 e0 01             	and    $0x1,%eax
  802176:	48 85 c0             	test   %rax,%rax
  802179:	75 12                	jne    80218d <fd_alloc+0x7c>
			*fd_store = fd;
  80217b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802183:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802186:	b8 00 00 00 00       	mov    $0x0,%eax
  80218b:	eb 1a                	jmp    8021a7 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  80218d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802191:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802195:	7e 8f                	jle    802126 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021a2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021a7:	c9                   	leaveq 
  8021a8:	c3                   	retq   

00000000008021a9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021a9:	55                   	push   %rbp
  8021aa:	48 89 e5             	mov    %rsp,%rbp
  8021ad:	48 83 ec 20          	sub    $0x20,%rsp
  8021b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021bc:	78 06                	js     8021c4 <fd_lookup+0x1b>
  8021be:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021c2:	7e 07                	jle    8021cb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021c9:	eb 6c                	jmp    802237 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021ce:	48 98                	cltq   
  8021d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8021da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e2:	48 c1 e8 15          	shr    $0x15,%rax
  8021e6:	48 89 c2             	mov    %rax,%rdx
  8021e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f0:	01 00 00 
  8021f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f7:	83 e0 01             	and    $0x1,%eax
  8021fa:	48 85 c0             	test   %rax,%rax
  8021fd:	74 21                	je     802220 <fd_lookup+0x77>
  8021ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802203:	48 c1 e8 0c          	shr    $0xc,%rax
  802207:	48 89 c2             	mov    %rax,%rdx
  80220a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802211:	01 00 00 
  802214:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802218:	83 e0 01             	and    $0x1,%eax
  80221b:	48 85 c0             	test   %rax,%rax
  80221e:	75 07                	jne    802227 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802220:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802225:	eb 10                	jmp    802237 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802227:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80222b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80222f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802237:	c9                   	leaveq 
  802238:	c3                   	retq   

0000000000802239 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802239:	55                   	push   %rbp
  80223a:	48 89 e5             	mov    %rsp,%rbp
  80223d:	48 83 ec 30          	sub    $0x30,%rsp
  802241:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802245:	89 f0                	mov    %esi,%eax
  802247:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80224a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224e:	48 89 c7             	mov    %rax,%rdi
  802251:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
  80225d:	89 c2                	mov    %eax,%edx
  80225f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802263:	48 89 c6             	mov    %rax,%rsi
  802266:	89 d7                	mov    %edx,%edi
  802268:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  80226f:	00 00 00 
  802272:	ff d0                	callq  *%rax
  802274:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802277:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227b:	78 0a                	js     802287 <fd_close+0x4e>
	    || fd != fd2)
  80227d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802281:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802285:	74 12                	je     802299 <fd_close+0x60>
		return (must_exist ? r : 0);
  802287:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80228b:	74 05                	je     802292 <fd_close+0x59>
  80228d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802290:	eb 70                	jmp    802302 <fd_close+0xc9>
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
  802297:	eb 69                	jmp    802302 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802299:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80229d:	8b 00                	mov    (%rax),%eax
  80229f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a3:	48 89 d6             	mov    %rdx,%rsi
  8022a6:	89 c7                	mov    %eax,%edi
  8022a8:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	callq  *%rax
  8022b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bb:	78 2a                	js     8022e7 <fd_close+0xae>
		if (dev->dev_close)
  8022bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022c5:	48 85 c0             	test   %rax,%rax
  8022c8:	74 16                	je     8022e0 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8022ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022d6:	48 89 d7             	mov    %rdx,%rdi
  8022d9:	ff d0                	callq  *%rax
  8022db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022de:	eb 07                	jmp    8022e7 <fd_close+0xae>
		else
			r = 0;
  8022e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022eb:	48 89 c6             	mov    %rax,%rsi
  8022ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f3:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  8022fa:	00 00 00 
  8022fd:	ff d0                	callq  *%rax
	return r;
  8022ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802302:	c9                   	leaveq 
  802303:	c3                   	retq   

0000000000802304 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802304:	55                   	push   %rbp
  802305:	48 89 e5             	mov    %rsp,%rbp
  802308:	48 83 ec 20          	sub    $0x20,%rsp
  80230c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80230f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231a:	eb 41                	jmp    80235d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80231c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802323:	00 00 00 
  802326:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802329:	48 63 d2             	movslq %edx,%rdx
  80232c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802330:	8b 00                	mov    (%rax),%eax
  802332:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802335:	75 22                	jne    802359 <dev_lookup+0x55>
			*dev = devtab[i];
  802337:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80233e:	00 00 00 
  802341:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802344:	48 63 d2             	movslq %edx,%rdx
  802347:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80234b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80234f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	eb 60                	jmp    8023b9 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802359:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80235d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802364:	00 00 00 
  802367:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80236a:	48 63 d2             	movslq %edx,%rdx
  80236d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802371:	48 85 c0             	test   %rax,%rax
  802374:	75 a6                	jne    80231c <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802376:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80237d:	00 00 00 
  802380:	48 8b 00             	mov    (%rax),%rax
  802383:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802389:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80238c:	89 c6                	mov    %eax,%esi
  80238e:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  802395:	00 00 00 
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
  80239d:	48 b9 94 08 80 00 00 	movabs $0x800894,%rcx
  8023a4:	00 00 00 
  8023a7:	ff d1                	callq  *%rcx
	*dev = 0;
  8023a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ad:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023b9:	c9                   	leaveq 
  8023ba:	c3                   	retq   

00000000008023bb <close>:

int
close(int fdnum)
{
  8023bb:	55                   	push   %rbp
  8023bc:	48 89 e5             	mov    %rsp,%rbp
  8023bf:	48 83 ec 20          	sub    $0x20,%rsp
  8023c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023cd:	48 89 d6             	mov    %rdx,%rsi
  8023d0:	89 c7                	mov    %eax,%edi
  8023d2:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
  8023de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e5:	79 05                	jns    8023ec <close+0x31>
		return r;
  8023e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ea:	eb 18                	jmp    802404 <close+0x49>
	else
		return fd_close(fd, 1);
  8023ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f0:	be 01 00 00 00       	mov    $0x1,%esi
  8023f5:	48 89 c7             	mov    %rax,%rdi
  8023f8:	48 b8 39 22 80 00 00 	movabs $0x802239,%rax
  8023ff:	00 00 00 
  802402:	ff d0                	callq  *%rax
}
  802404:	c9                   	leaveq 
  802405:	c3                   	retq   

0000000000802406 <close_all>:

void
close_all(void)
{
  802406:	55                   	push   %rbp
  802407:	48 89 e5             	mov    %rsp,%rbp
  80240a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80240e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802415:	eb 15                	jmp    80242c <close_all+0x26>
		close(i);
  802417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241a:	89 c7                	mov    %eax,%edi
  80241c:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802428:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80242c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802430:	7e e5                	jle    802417 <close_all+0x11>
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 40          	sub    $0x40,%rsp
  80243c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80243f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802442:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802446:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802449:	48 89 d6             	mov    %rdx,%rsi
  80244c:	89 c7                	mov    %eax,%edi
  80244e:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  802455:	00 00 00 
  802458:	ff d0                	callq  *%rax
  80245a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802461:	79 08                	jns    80246b <dup+0x37>
		return r;
  802463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802466:	e9 70 01 00 00       	jmpq   8025db <dup+0x1a7>
	close(newfdnum);
  80246b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80246e:	89 c7                	mov    %eax,%edi
  802470:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802477:	00 00 00 
  80247a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80247c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80247f:	48 98                	cltq   
  802481:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802487:	48 c1 e0 0c          	shl    $0xc,%rax
  80248b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80248f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802493:	48 89 c7             	mov    %rax,%rdi
  802496:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
  8024a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024aa:	48 89 c7             	mov    %rax,%rdi
  8024ad:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax
  8024b9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c1:	48 c1 e8 15          	shr    $0x15,%rax
  8024c5:	48 89 c2             	mov    %rax,%rdx
  8024c8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024cf:	01 00 00 
  8024d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d6:	83 e0 01             	and    $0x1,%eax
  8024d9:	48 85 c0             	test   %rax,%rax
  8024dc:	74 73                	je     802551 <dup+0x11d>
  8024de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e2:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e6:	48 89 c2             	mov    %rax,%rdx
  8024e9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f0:	01 00 00 
  8024f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f7:	83 e0 01             	and    $0x1,%eax
  8024fa:	48 85 c0             	test   %rax,%rax
  8024fd:	74 52                	je     802551 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8024ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802503:	48 c1 e8 0c          	shr    $0xc,%rax
  802507:	48 89 c2             	mov    %rax,%rdx
  80250a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802511:	01 00 00 
  802514:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802518:	25 07 0e 00 00       	and    $0xe07,%eax
  80251d:	89 c1                	mov    %eax,%ecx
  80251f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802527:	41 89 c8             	mov    %ecx,%r8d
  80252a:	48 89 d1             	mov    %rdx,%rcx
  80252d:	ba 00 00 00 00       	mov    $0x0,%edx
  802532:	48 89 c6             	mov    %rax,%rsi
  802535:	bf 00 00 00 00       	mov    $0x0,%edi
  80253a:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802541:	00 00 00 
  802544:	ff d0                	callq  *%rax
  802546:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802549:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254d:	79 02                	jns    802551 <dup+0x11d>
			goto err;
  80254f:	eb 57                	jmp    8025a8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802555:	48 c1 e8 0c          	shr    $0xc,%rax
  802559:	48 89 c2             	mov    %rax,%rdx
  80255c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802563:	01 00 00 
  802566:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256a:	25 07 0e 00 00       	and    $0xe07,%eax
  80256f:	89 c1                	mov    %eax,%ecx
  802571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802575:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802579:	41 89 c8             	mov    %ecx,%r8d
  80257c:	48 89 d1             	mov    %rdx,%rcx
  80257f:	ba 00 00 00 00       	mov    $0x0,%edx
  802584:	48 89 c6             	mov    %rax,%rsi
  802587:	bf 00 00 00 00       	mov    $0x0,%edi
  80258c:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
  802598:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259f:	79 02                	jns    8025a3 <dup+0x16f>
		goto err;
  8025a1:	eb 05                	jmp    8025a8 <dup+0x174>

	return newfdnum;
  8025a3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025a6:	eb 33                	jmp    8025db <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ac:	48 89 c6             	mov    %rax,%rsi
  8025af:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b4:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c4:	48 89 c6             	mov    %rax,%rsi
  8025c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cc:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  8025d3:	00 00 00 
  8025d6:	ff d0                	callq  *%rax
	return r;
  8025d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025db:	c9                   	leaveq 
  8025dc:	c3                   	retq   

00000000008025dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025dd:	55                   	push   %rbp
  8025de:	48 89 e5             	mov    %rsp,%rbp
  8025e1:	48 83 ec 40          	sub    $0x40,%rsp
  8025e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f7:	48 89 d6             	mov    %rdx,%rsi
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260f:	78 24                	js     802635 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802615:	8b 00                	mov    (%rax),%eax
  802617:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261b:	48 89 d6             	mov    %rdx,%rsi
  80261e:	89 c7                	mov    %eax,%edi
  802620:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
  80262c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802633:	79 05                	jns    80263a <read+0x5d>
		return r;
  802635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802638:	eb 76                	jmp    8026b0 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80263a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263e:	8b 40 08             	mov    0x8(%rax),%eax
  802641:	83 e0 03             	and    $0x3,%eax
  802644:	83 f8 01             	cmp    $0x1,%eax
  802647:	75 3a                	jne    802683 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802649:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802650:	00 00 00 
  802653:	48 8b 00             	mov    (%rax),%rax
  802656:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80265c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80265f:	89 c6                	mov    %eax,%esi
  802661:	48 bf 97 49 80 00 00 	movabs $0x804997,%rdi
  802668:	00 00 00 
  80266b:	b8 00 00 00 00       	mov    $0x0,%eax
  802670:	48 b9 94 08 80 00 00 	movabs $0x800894,%rcx
  802677:	00 00 00 
  80267a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80267c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802681:	eb 2d                	jmp    8026b0 <read+0xd3>
	}
	if (!dev->dev_read)
  802683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802687:	48 8b 40 10          	mov    0x10(%rax),%rax
  80268b:	48 85 c0             	test   %rax,%rax
  80268e:	75 07                	jne    802697 <read+0xba>
		return -E_NOT_SUPP;
  802690:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802695:	eb 19                	jmp    8026b0 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80269f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026a7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026ab:	48 89 cf             	mov    %rcx,%rdi
  8026ae:	ff d0                	callq  *%rax
}
  8026b0:	c9                   	leaveq 
  8026b1:	c3                   	retq   

00000000008026b2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026b2:	55                   	push   %rbp
  8026b3:	48 89 e5             	mov    %rsp,%rbp
  8026b6:	48 83 ec 30          	sub    $0x30,%rsp
  8026ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026cc:	eb 49                	jmp    802717 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d1:	48 98                	cltq   
  8026d3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026d7:	48 29 c2             	sub    %rax,%rdx
  8026da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026dd:	48 63 c8             	movslq %eax,%rcx
  8026e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e4:	48 01 c1             	add    %rax,%rcx
  8026e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ea:	48 89 ce             	mov    %rcx,%rsi
  8026ed:	89 c7                	mov    %eax,%edi
  8026ef:	48 b8 dd 25 80 00 00 	movabs $0x8025dd,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
  8026fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8026fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802702:	79 05                	jns    802709 <readn+0x57>
			return m;
  802704:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802707:	eb 1c                	jmp    802725 <readn+0x73>
		if (m == 0)
  802709:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80270d:	75 02                	jne    802711 <readn+0x5f>
			break;
  80270f:	eb 11                	jmp    802722 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802711:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802714:	01 45 fc             	add    %eax,-0x4(%rbp)
  802717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271a:	48 98                	cltq   
  80271c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802720:	72 ac                	jb     8026ce <readn+0x1c>
	}
	return tot;
  802722:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802725:	c9                   	leaveq 
  802726:	c3                   	retq   

0000000000802727 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802727:	55                   	push   %rbp
  802728:	48 89 e5             	mov    %rsp,%rbp
  80272b:	48 83 ec 40          	sub    $0x40,%rsp
  80272f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802732:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802736:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80273a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80273e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802741:	48 89 d6             	mov    %rdx,%rsi
  802744:	89 c7                	mov    %eax,%edi
  802746:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  80274d:	00 00 00 
  802750:	ff d0                	callq  *%rax
  802752:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802755:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802759:	78 24                	js     80277f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80275b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80275f:	8b 00                	mov    (%rax),%eax
  802761:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802765:	48 89 d6             	mov    %rdx,%rsi
  802768:	89 c7                	mov    %eax,%edi
  80276a:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802779:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277d:	79 05                	jns    802784 <write+0x5d>
		return r;
  80277f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802782:	eb 75                	jmp    8027f9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802788:	8b 40 08             	mov    0x8(%rax),%eax
  80278b:	83 e0 03             	and    $0x3,%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	75 3a                	jne    8027cc <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802792:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802799:	00 00 00 
  80279c:	48 8b 00             	mov    (%rax),%rax
  80279f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027a8:	89 c6                	mov    %eax,%esi
  8027aa:	48 bf b3 49 80 00 00 	movabs $0x8049b3,%rdi
  8027b1:	00 00 00 
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	48 b9 94 08 80 00 00 	movabs $0x800894,%rcx
  8027c0:	00 00 00 
  8027c3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ca:	eb 2d                	jmp    8027f9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027d4:	48 85 c0             	test   %rax,%rax
  8027d7:	75 07                	jne    8027e0 <write+0xb9>
		return -E_NOT_SUPP;
  8027d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027de:	eb 19                	jmp    8027f9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027ec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027f0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027f4:	48 89 cf             	mov    %rcx,%rdi
  8027f7:	ff d0                	callq  *%rax
}
  8027f9:	c9                   	leaveq 
  8027fa:	c3                   	retq   

00000000008027fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8027fb:	55                   	push   %rbp
  8027fc:	48 89 e5             	mov    %rsp,%rbp
  8027ff:	48 83 ec 18          	sub    $0x18,%rsp
  802803:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802806:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802809:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80280d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802810:	48 89 d6             	mov    %rdx,%rsi
  802813:	89 c7                	mov    %eax,%edi
  802815:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	callq  *%rax
  802821:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802824:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802828:	79 05                	jns    80282f <seek+0x34>
		return r;
  80282a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282d:	eb 0f                	jmp    80283e <seek+0x43>
	fd->fd_offset = offset;
  80282f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802833:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802836:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283e:	c9                   	leaveq 
  80283f:	c3                   	retq   

0000000000802840 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802840:	55                   	push   %rbp
  802841:	48 89 e5             	mov    %rsp,%rbp
  802844:	48 83 ec 30          	sub    $0x30,%rsp
  802848:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80284b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80284e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802852:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802855:	48 89 d6             	mov    %rdx,%rsi
  802858:	89 c7                	mov    %eax,%edi
  80285a:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
  802866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286d:	78 24                	js     802893 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80286f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802873:	8b 00                	mov    (%rax),%eax
  802875:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802879:	48 89 d6             	mov    %rdx,%rsi
  80287c:	89 c7                	mov    %eax,%edi
  80287e:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802891:	79 05                	jns    802898 <ftruncate+0x58>
		return r;
  802893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802896:	eb 72                	jmp    80290a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289c:	8b 40 08             	mov    0x8(%rax),%eax
  80289f:	83 e0 03             	and    $0x3,%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	75 3a                	jne    8028e0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028ad:	00 00 00 
  8028b0:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028b3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028b9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028bc:	89 c6                	mov    %eax,%esi
  8028be:	48 bf d0 49 80 00 00 	movabs $0x8049d0,%rdi
  8028c5:	00 00 00 
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	48 b9 94 08 80 00 00 	movabs $0x800894,%rcx
  8028d4:	00 00 00 
  8028d7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028de:	eb 2a                	jmp    80290a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028e8:	48 85 c0             	test   %rax,%rax
  8028eb:	75 07                	jne    8028f4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028ed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028f2:	eb 16                	jmp    80290a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802900:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802903:	89 ce                	mov    %ecx,%esi
  802905:	48 89 d7             	mov    %rdx,%rdi
  802908:	ff d0                	callq  *%rax
}
  80290a:	c9                   	leaveq 
  80290b:	c3                   	retq   

000000000080290c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80290c:	55                   	push   %rbp
  80290d:	48 89 e5             	mov    %rsp,%rbp
  802910:	48 83 ec 30          	sub    $0x30,%rsp
  802914:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802917:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80291b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80291f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802922:	48 89 d6             	mov    %rdx,%rsi
  802925:	89 c7                	mov    %eax,%edi
  802927:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802936:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293a:	78 24                	js     802960 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80293c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802940:	8b 00                	mov    (%rax),%eax
  802942:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802946:	48 89 d6             	mov    %rdx,%rsi
  802949:	89 c7                	mov    %eax,%edi
  80294b:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802952:	00 00 00 
  802955:	ff d0                	callq  *%rax
  802957:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295e:	79 05                	jns    802965 <fstat+0x59>
		return r;
  802960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802963:	eb 5e                	jmp    8029c3 <fstat+0xb7>
	if (!dev->dev_stat)
  802965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802969:	48 8b 40 28          	mov    0x28(%rax),%rax
  80296d:	48 85 c0             	test   %rax,%rax
  802970:	75 07                	jne    802979 <fstat+0x6d>
		return -E_NOT_SUPP;
  802972:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802977:	eb 4a                	jmp    8029c3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802979:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80297d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802980:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802984:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80298b:	00 00 00 
	stat->st_isdir = 0;
  80298e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802992:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802999:	00 00 00 
	stat->st_dev = dev;
  80299c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029a4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029af:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029b7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029bb:	48 89 ce             	mov    %rcx,%rsi
  8029be:	48 89 d7             	mov    %rdx,%rdi
  8029c1:	ff d0                	callq  *%rax
}
  8029c3:	c9                   	leaveq 
  8029c4:	c3                   	retq   

00000000008029c5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029c5:	55                   	push   %rbp
  8029c6:	48 89 e5             	mov    %rsp,%rbp
  8029c9:	48 83 ec 20          	sub    $0x20,%rsp
  8029cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d9:	be 00 00 00 00       	mov    $0x0,%esi
  8029de:	48 89 c7             	mov    %rax,%rdi
  8029e1:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
  8029ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f4:	79 05                	jns    8029fb <stat+0x36>
		return fd;
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f9:	eb 2f                	jmp    802a2a <stat+0x65>
	r = fstat(fd, stat);
  8029fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a02:	48 89 d6             	mov    %rdx,%rsi
  802a05:	89 c7                	mov    %eax,%edi
  802a07:	48 b8 0c 29 80 00 00 	movabs $0x80290c,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
  802a13:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a19:	89 c7                	mov    %eax,%edi
  802a1b:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802a22:	00 00 00 
  802a25:	ff d0                	callq  *%rax
	return r;
  802a27:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a2a:	c9                   	leaveq 
  802a2b:	c3                   	retq   

0000000000802a2c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a2c:	55                   	push   %rbp
  802a2d:	48 89 e5             	mov    %rsp,%rbp
  802a30:	48 83 ec 10          	sub    $0x10,%rsp
  802a34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a3b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a42:	00 00 00 
  802a45:	8b 00                	mov    (%rax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	75 1f                	jne    802a6a <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a4b:	bf 01 00 00 00       	mov    $0x1,%edi
  802a50:	48 b8 cb 41 80 00 00 	movabs $0x8041cb,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 c2                	mov    %eax,%edx
  802a5e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a65:	00 00 00 
  802a68:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a6a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a71:	00 00 00 
  802a74:	8b 00                	mov    (%rax),%eax
  802a76:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a79:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a7e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a85:	00 00 00 
  802a88:	89 c7                	mov    %eax,%edi
  802a8a:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9f:	48 89 c6             	mov    %rax,%rsi
  802aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802aae:	00 00 00 
  802ab1:	ff d0                	callq  *%rax
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 10          	sub    $0x10,%rsp
  802abd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ac1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802ac4:	48 ba f6 49 80 00 00 	movabs $0x8049f6,%rdx
  802acb:	00 00 00 
  802ace:	be 4c 00 00 00       	mov    $0x4c,%esi
  802ad3:	48 bf 0b 4a 80 00 00 	movabs $0x804a0b,%rdi
  802ada:	00 00 00 
  802add:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae2:	48 b9 5b 06 80 00 00 	movabs $0x80065b,%rcx
  802ae9:	00 00 00 
  802aec:	ff d1                	callq  *%rcx

0000000000802aee <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802aee:	55                   	push   %rbp
  802aef:	48 89 e5             	mov    %rsp,%rbp
  802af2:	48 83 ec 10          	sub    $0x10,%rsp
  802af6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afe:	8b 50 0c             	mov    0xc(%rax),%edx
  802b01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b08:	00 00 00 
  802b0b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b0d:	be 00 00 00 00       	mov    $0x0,%esi
  802b12:	bf 06 00 00 00       	mov    $0x6,%edi
  802b17:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802b1e:	00 00 00 
  802b21:	ff d0                	callq  *%rax
}
  802b23:	c9                   	leaveq 
  802b24:	c3                   	retq   

0000000000802b25 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b25:	55                   	push   %rbp
  802b26:	48 89 e5             	mov    %rsp,%rbp
  802b29:	48 83 ec 20          	sub    $0x20,%rsp
  802b2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b35:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802b39:	48 ba 16 4a 80 00 00 	movabs $0x804a16,%rdx
  802b40:	00 00 00 
  802b43:	be 6b 00 00 00       	mov    $0x6b,%esi
  802b48:	48 bf 0b 4a 80 00 00 	movabs $0x804a0b,%rdi
  802b4f:	00 00 00 
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	48 b9 5b 06 80 00 00 	movabs $0x80065b,%rcx
  802b5e:	00 00 00 
  802b61:	ff d1                	callq  *%rcx

0000000000802b63 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b63:	55                   	push   %rbp
  802b64:	48 89 e5             	mov    %rsp,%rbp
  802b67:	48 83 ec 20          	sub    $0x20,%rsp
  802b6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802b77:	48 ba 33 4a 80 00 00 	movabs $0x804a33,%rdx
  802b7e:	00 00 00 
  802b81:	be 7b 00 00 00       	mov    $0x7b,%esi
  802b86:	48 bf 0b 4a 80 00 00 	movabs $0x804a0b,%rdi
  802b8d:	00 00 00 
  802b90:	b8 00 00 00 00       	mov    $0x0,%eax
  802b95:	48 b9 5b 06 80 00 00 	movabs $0x80065b,%rcx
  802b9c:	00 00 00 
  802b9f:	ff d1                	callq  *%rcx

0000000000802ba1 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ba1:	55                   	push   %rbp
  802ba2:	48 89 e5             	mov    %rsp,%rbp
  802ba5:	48 83 ec 20          	sub    $0x20,%rsp
  802ba9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb5:	8b 50 0c             	mov    0xc(%rax),%edx
  802bb8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bbf:	00 00 00 
  802bc2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bc4:	be 00 00 00 00       	mov    $0x0,%esi
  802bc9:	bf 05 00 00 00       	mov    $0x5,%edi
  802bce:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802bd5:	00 00 00 
  802bd8:	ff d0                	callq  *%rax
  802bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be1:	79 05                	jns    802be8 <devfile_stat+0x47>
		return r;
  802be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be6:	eb 56                	jmp    802c3e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802be8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bec:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802bf3:	00 00 00 
  802bf6:	48 89 c7             	mov    %rax,%rdi
  802bf9:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c05:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c0c:	00 00 00 
  802c0f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c19:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c26:	00 00 00 
  802c29:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c33:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 83 ec 10          	sub    $0x10,%rsp
  802c48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c4c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c53:	8b 50 0c             	mov    0xc(%rax),%edx
  802c56:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c5d:	00 00 00 
  802c60:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c62:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c69:	00 00 00 
  802c6c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c72:	be 00 00 00 00       	mov    $0x0,%esi
  802c77:	bf 02 00 00 00       	mov    $0x2,%edi
  802c7c:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
}
  802c88:	c9                   	leaveq 
  802c89:	c3                   	retq   

0000000000802c8a <remove>:

// Delete a file
int
remove(const char *path)
{
  802c8a:	55                   	push   %rbp
  802c8b:	48 89 e5             	mov    %rsp,%rbp
  802c8e:	48 83 ec 10          	sub    $0x10,%rsp
  802c92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9a:	48 89 c7             	mov    %rax,%rdi
  802c9d:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
  802ca9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cae:	7e 07                	jle    802cb7 <remove+0x2d>
		return -E_BAD_PATH;
  802cb0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cb5:	eb 33                	jmp    802cea <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cbb:	48 89 c6             	mov    %rax,%rsi
  802cbe:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cc5:	00 00 00 
  802cc8:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cd4:	be 00 00 00 00       	mov    $0x0,%esi
  802cd9:	bf 07 00 00 00       	mov    $0x7,%edi
  802cde:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
}
  802cea:	c9                   	leaveq 
  802ceb:	c3                   	retq   

0000000000802cec <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802cec:	55                   	push   %rbp
  802ced:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802cf0:	be 00 00 00 00       	mov    $0x0,%esi
  802cf5:	bf 08 00 00 00       	mov    $0x8,%edi
  802cfa:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802d01:	00 00 00 
  802d04:	ff d0                	callq  *%rax
}
  802d06:	5d                   	pop    %rbp
  802d07:	c3                   	retq   

0000000000802d08 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d08:	55                   	push   %rbp
  802d09:	48 89 e5             	mov    %rsp,%rbp
  802d0c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d13:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d1a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d21:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d28:	be 00 00 00 00       	mov    $0x0,%esi
  802d2d:	48 89 c7             	mov    %rax,%rdi
  802d30:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
  802d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d43:	79 28                	jns    802d6d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d48:	89 c6                	mov    %eax,%esi
  802d4a:	48 bf 51 4a 80 00 00 	movabs $0x804a51,%rdi
  802d51:	00 00 00 
  802d54:	b8 00 00 00 00       	mov    $0x0,%eax
  802d59:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  802d60:	00 00 00 
  802d63:	ff d2                	callq  *%rdx
		return fd_src;
  802d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d68:	e9 74 01 00 00       	jmpq   802ee1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d6d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d74:	be 01 01 00 00       	mov    $0x101,%esi
  802d79:	48 89 c7             	mov    %rax,%rdi
  802d7c:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
  802d88:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d8b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d8f:	79 39                	jns    802dca <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d94:	89 c6                	mov    %eax,%esi
  802d96:	48 bf 67 4a 80 00 00 	movabs $0x804a67,%rdi
  802d9d:	00 00 00 
  802da0:	b8 00 00 00 00       	mov    $0x0,%eax
  802da5:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  802dac:	00 00 00 
  802daf:	ff d2                	callq  *%rdx
		close(fd_src);
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	89 c7                	mov    %eax,%edi
  802db6:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
		return fd_dest;
  802dc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc5:	e9 17 01 00 00       	jmpq   802ee1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dca:	eb 74                	jmp    802e40 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802dcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dcf:	48 63 d0             	movslq %eax,%rdx
  802dd2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddc:	48 89 ce             	mov    %rcx,%rsi
  802ddf:	89 c7                	mov    %eax,%edi
  802de1:	48 b8 27 27 80 00 00 	movabs $0x802727,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
  802ded:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802df0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802df4:	79 4a                	jns    802e40 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802df6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802df9:	89 c6                	mov    %eax,%esi
  802dfb:	48 bf 81 4a 80 00 00 	movabs $0x804a81,%rdi
  802e02:	00 00 00 
  802e05:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0a:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  802e11:	00 00 00 
  802e14:	ff d2                	callq  *%rdx
			close(fd_src);
  802e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e19:	89 c7                	mov    %eax,%edi
  802e1b:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
			close(fd_dest);
  802e27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e2a:	89 c7                	mov    %eax,%edi
  802e2c:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
			return write_size;
  802e38:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e3b:	e9 a1 00 00 00       	jmpq   802ee1 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e40:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4a:	ba 00 02 00 00       	mov    $0x200,%edx
  802e4f:	48 89 ce             	mov    %rcx,%rsi
  802e52:	89 c7                	mov    %eax,%edi
  802e54:	48 b8 dd 25 80 00 00 	movabs $0x8025dd,%rax
  802e5b:	00 00 00 
  802e5e:	ff d0                	callq  *%rax
  802e60:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e63:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e67:	0f 8f 5f ff ff ff    	jg     802dcc <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e71:	79 47                	jns    802eba <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e73:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e76:	89 c6                	mov    %eax,%esi
  802e78:	48 bf 94 4a 80 00 00 	movabs $0x804a94,%rdi
  802e7f:	00 00 00 
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
  802e87:	48 ba 94 08 80 00 00 	movabs $0x800894,%rdx
  802e8e:	00 00 00 
  802e91:	ff d2                	callq  *%rdx
		close(fd_src);
  802e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e96:	89 c7                	mov    %eax,%edi
  802e98:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
		close(fd_dest);
  802ea4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea7:	89 c7                	mov    %eax,%edi
  802ea9:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
		return read_size;
  802eb5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eb8:	eb 27                	jmp    802ee1 <copy+0x1d9>
	}
	close(fd_src);
  802eba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebd:	89 c7                	mov    %eax,%edi
  802ebf:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
	close(fd_dest);
  802ecb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ece:	89 c7                	mov    %eax,%edi
  802ed0:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802ed7:	00 00 00 
  802eda:	ff d0                	callq  *%rax
	return 0;
  802edc:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ee1:	c9                   	leaveq 
  802ee2:	c3                   	retq   

0000000000802ee3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ee3:	55                   	push   %rbp
  802ee4:	48 89 e5             	mov    %rsp,%rbp
  802ee7:	48 83 ec 20          	sub    $0x20,%rsp
  802eeb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802eee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ef2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef5:	48 89 d6             	mov    %rdx,%rsi
  802ef8:	89 c7                	mov    %eax,%edi
  802efa:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  802f01:	00 00 00 
  802f04:	ff d0                	callq  *%rax
  802f06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0d:	79 05                	jns    802f14 <fd2sockid+0x31>
		return r;
  802f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f12:	eb 24                	jmp    802f38 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f18:	8b 10                	mov    (%rax),%edx
  802f1a:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f21:	00 00 00 
  802f24:	8b 00                	mov    (%rax),%eax
  802f26:	39 c2                	cmp    %eax,%edx
  802f28:	74 07                	je     802f31 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f2a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f2f:	eb 07                	jmp    802f38 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f35:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f38:	c9                   	leaveq 
  802f39:	c3                   	retq   

0000000000802f3a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f3a:	55                   	push   %rbp
  802f3b:	48 89 e5             	mov    %rsp,%rbp
  802f3e:	48 83 ec 20          	sub    $0x20,%rsp
  802f42:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f45:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f49:	48 89 c7             	mov    %rax,%rdi
  802f4c:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  802f53:	00 00 00 
  802f56:	ff d0                	callq  *%rax
  802f58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5f:	78 26                	js     802f87 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f65:	ba 07 04 00 00       	mov    $0x407,%edx
  802f6a:	48 89 c6             	mov    %rax,%rsi
  802f6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f72:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f85:	79 16                	jns    802f9d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f8a:	89 c7                	mov    %eax,%edi
  802f8c:	48 b8 49 34 80 00 00 	movabs $0x803449,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
		return r;
  802f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9b:	eb 3a                	jmp    802fd7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa1:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802fa8:	00 00 00 
  802fab:	8b 12                	mov    (%rdx),%edx
  802fad:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fc1:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc8:	48 89 c7             	mov    %rax,%rdi
  802fcb:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
}
  802fd7:	c9                   	leaveq 
  802fd8:	c3                   	retq   

0000000000802fd9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fd9:	55                   	push   %rbp
  802fda:	48 89 e5             	mov    %rsp,%rbp
  802fdd:	48 83 ec 30          	sub    $0x30,%rsp
  802fe1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fef:	89 c7                	mov    %eax,%edi
  802ff1:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
  802ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803004:	79 05                	jns    80300b <accept+0x32>
		return r;
  803006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803009:	eb 3b                	jmp    803046 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80300b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80300f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803016:	48 89 ce             	mov    %rcx,%rsi
  803019:	89 c7                	mov    %eax,%edi
  80301b:	48 b8 26 33 80 00 00 	movabs $0x803326,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
  803027:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80302a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302e:	79 05                	jns    803035 <accept+0x5c>
		return r;
  803030:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803033:	eb 11                	jmp    803046 <accept+0x6d>
	return alloc_sockfd(r);
  803035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803038:	89 c7                	mov    %eax,%edi
  80303a:	48 b8 3a 2f 80 00 00 	movabs $0x802f3a,%rax
  803041:	00 00 00 
  803044:	ff d0                	callq  *%rax
}
  803046:	c9                   	leaveq 
  803047:	c3                   	retq   

0000000000803048 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803048:	55                   	push   %rbp
  803049:	48 89 e5             	mov    %rsp,%rbp
  80304c:	48 83 ec 20          	sub    $0x20,%rsp
  803050:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803053:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803057:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80305a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305d:	89 c7                	mov    %eax,%edi
  80305f:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803072:	79 05                	jns    803079 <bind+0x31>
		return r;
  803074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803077:	eb 1b                	jmp    803094 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803079:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80307c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803083:	48 89 ce             	mov    %rcx,%rsi
  803086:	89 c7                	mov    %eax,%edi
  803088:	48 b8 a5 33 80 00 00 	movabs $0x8033a5,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
}
  803094:	c9                   	leaveq 
  803095:	c3                   	retq   

0000000000803096 <shutdown>:

int
shutdown(int s, int how)
{
  803096:	55                   	push   %rbp
  803097:	48 89 e5             	mov    %rsp,%rbp
  80309a:	48 83 ec 20          	sub    $0x20,%rsp
  80309e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030a1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a7:	89 c7                	mov    %eax,%edi
  8030a9:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
  8030b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bc:	79 05                	jns    8030c3 <shutdown+0x2d>
		return r;
  8030be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c1:	eb 16                	jmp    8030d9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8030c3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c9:	89 d6                	mov    %edx,%esi
  8030cb:	89 c7                	mov    %eax,%edi
  8030cd:	48 b8 09 34 80 00 00 	movabs $0x803409,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
}
  8030d9:	c9                   	leaveq 
  8030da:	c3                   	retq   

00000000008030db <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8030db:	55                   	push   %rbp
  8030dc:	48 89 e5             	mov    %rsp,%rbp
  8030df:	48 83 ec 10          	sub    $0x10,%rsp
  8030e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030eb:	48 89 c7             	mov    %rax,%rdi
  8030ee:	48 b8 3d 42 80 00 00 	movabs $0x80423d,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	83 f8 01             	cmp    $0x1,%eax
  8030fd:	75 17                	jne    803116 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8030ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803103:	8b 40 0c             	mov    0xc(%rax),%eax
  803106:	89 c7                	mov    %eax,%edi
  803108:	48 b8 49 34 80 00 00 	movabs $0x803449,%rax
  80310f:	00 00 00 
  803112:	ff d0                	callq  *%rax
  803114:	eb 05                	jmp    80311b <devsock_close+0x40>
	else
		return 0;
  803116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80311b:	c9                   	leaveq 
  80311c:	c3                   	retq   

000000000080311d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80311d:	55                   	push   %rbp
  80311e:	48 89 e5             	mov    %rsp,%rbp
  803121:	48 83 ec 20          	sub    $0x20,%rsp
  803125:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803128:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80312c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80312f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803132:	89 c7                	mov    %eax,%edi
  803134:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	callq  *%rax
  803140:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803143:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803147:	79 05                	jns    80314e <connect+0x31>
		return r;
  803149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314c:	eb 1b                	jmp    803169 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80314e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803151:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803158:	48 89 ce             	mov    %rcx,%rsi
  80315b:	89 c7                	mov    %eax,%edi
  80315d:	48 b8 76 34 80 00 00 	movabs $0x803476,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
}
  803169:	c9                   	leaveq 
  80316a:	c3                   	retq   

000000000080316b <listen>:

int
listen(int s, int backlog)
{
  80316b:	55                   	push   %rbp
  80316c:	48 89 e5             	mov    %rsp,%rbp
  80316f:	48 83 ec 20          	sub    $0x20,%rsp
  803173:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803176:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803179:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80317c:	89 c7                	mov    %eax,%edi
  80317e:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
  80318a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803191:	79 05                	jns    803198 <listen+0x2d>
		return r;
  803193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803196:	eb 16                	jmp    8031ae <listen+0x43>
	return nsipc_listen(r, backlog);
  803198:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80319b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319e:	89 d6                	mov    %edx,%esi
  8031a0:	89 c7                	mov    %eax,%edi
  8031a2:	48 b8 da 34 80 00 00 	movabs $0x8034da,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 20          	sub    $0x20,%rsp
  8031b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c8:	89 c2                	mov    %eax,%edx
  8031ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ce:	8b 40 0c             	mov    0xc(%rax),%eax
  8031d1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031da:	89 c7                	mov    %eax,%edi
  8031dc:	48 b8 1a 35 80 00 00 	movabs $0x80351a,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
}
  8031e8:	c9                   	leaveq 
  8031e9:	c3                   	retq   

00000000008031ea <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031ea:	55                   	push   %rbp
  8031eb:	48 89 e5             	mov    %rsp,%rbp
  8031ee:	48 83 ec 20          	sub    $0x20,%rsp
  8031f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8031fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803202:	89 c2                	mov    %eax,%edx
  803204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803208:	8b 40 0c             	mov    0xc(%rax),%eax
  80320b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80320f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803214:	89 c7                	mov    %eax,%edi
  803216:	48 b8 e6 35 80 00 00 	movabs $0x8035e6,%rax
  80321d:	00 00 00 
  803220:	ff d0                	callq  *%rax
}
  803222:	c9                   	leaveq 
  803223:	c3                   	retq   

0000000000803224 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803224:	55                   	push   %rbp
  803225:	48 89 e5             	mov    %rsp,%rbp
  803228:	48 83 ec 10          	sub    $0x10,%rsp
  80322c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803230:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803238:	48 be af 4a 80 00 00 	movabs $0x804aaf,%rsi
  80323f:	00 00 00 
  803242:	48 89 c7             	mov    %rax,%rdi
  803245:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
	return 0;
  803251:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803256:	c9                   	leaveq 
  803257:	c3                   	retq   

0000000000803258 <socket>:

int
socket(int domain, int type, int protocol)
{
  803258:	55                   	push   %rbp
  803259:	48 89 e5             	mov    %rsp,%rbp
  80325c:	48 83 ec 20          	sub    $0x20,%rsp
  803260:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803263:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803266:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803269:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80326c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80326f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803272:	89 ce                	mov    %ecx,%esi
  803274:	89 c7                	mov    %eax,%edi
  803276:	48 b8 9e 36 80 00 00 	movabs $0x80369e,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
  803282:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803285:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803289:	79 05                	jns    803290 <socket+0x38>
		return r;
  80328b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328e:	eb 11                	jmp    8032a1 <socket+0x49>
	return alloc_sockfd(r);
  803290:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803293:	89 c7                	mov    %eax,%edi
  803295:	48 b8 3a 2f 80 00 00 	movabs $0x802f3a,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
}
  8032a1:	c9                   	leaveq 
  8032a2:	c3                   	retq   

00000000008032a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032a3:	55                   	push   %rbp
  8032a4:	48 89 e5             	mov    %rsp,%rbp
  8032a7:	48 83 ec 10          	sub    $0x10,%rsp
  8032ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8032ae:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8032b5:	00 00 00 
  8032b8:	8b 00                	mov    (%rax),%eax
  8032ba:	85 c0                	test   %eax,%eax
  8032bc:	75 1f                	jne    8032dd <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032be:	bf 02 00 00 00       	mov    $0x2,%edi
  8032c3:	48 b8 cb 41 80 00 00 	movabs $0x8041cb,%rax
  8032ca:	00 00 00 
  8032cd:	ff d0                	callq  *%rax
  8032cf:	89 c2                	mov    %eax,%edx
  8032d1:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8032d8:	00 00 00 
  8032db:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032dd:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8032e4:	00 00 00 
  8032e7:	8b 00                	mov    (%rax),%eax
  8032e9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032ec:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032f1:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8032f8:	00 00 00 
  8032fb:	89 c7                	mov    %eax,%edi
  8032fd:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803309:	ba 00 00 00 00       	mov    $0x0,%edx
  80330e:	be 00 00 00 00       	mov    $0x0,%esi
  803313:	bf 00 00 00 00       	mov    $0x0,%edi
  803318:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
}
  803324:	c9                   	leaveq 
  803325:	c3                   	retq   

0000000000803326 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803326:	55                   	push   %rbp
  803327:	48 89 e5             	mov    %rsp,%rbp
  80332a:	48 83 ec 30          	sub    $0x30,%rsp
  80332e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803331:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803335:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803339:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803340:	00 00 00 
  803343:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803346:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803348:	bf 01 00 00 00       	mov    $0x1,%edi
  80334d:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803360:	78 3e                	js     8033a0 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803362:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803369:	00 00 00 
  80336c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803374:	8b 40 10             	mov    0x10(%rax),%eax
  803377:	89 c2                	mov    %eax,%edx
  803379:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80337d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803381:	48 89 ce             	mov    %rcx,%rsi
  803384:	48 89 c7             	mov    %rax,%rdi
  803387:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803393:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803397:	8b 50 10             	mov    0x10(%rax),%edx
  80339a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8033a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033a3:	c9                   	leaveq 
  8033a4:	c3                   	retq   

00000000008033a5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033a5:	55                   	push   %rbp
  8033a6:	48 89 e5             	mov    %rsp,%rbp
  8033a9:	48 83 ec 10          	sub    $0x10,%rsp
  8033ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8033b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033be:	00 00 00 
  8033c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033c4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8033c6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cd:	48 89 c6             	mov    %rax,%rsi
  8033d0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033d7:	00 00 00 
  8033da:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8033e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ed:	00 00 00 
  8033f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033f3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8033f6:	bf 02 00 00 00       	mov    $0x2,%edi
  8033fb:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  803402:	00 00 00 
  803405:	ff d0                	callq  *%rax
}
  803407:	c9                   	leaveq 
  803408:	c3                   	retq   

0000000000803409 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803409:	55                   	push   %rbp
  80340a:	48 89 e5             	mov    %rsp,%rbp
  80340d:	48 83 ec 10          	sub    $0x10,%rsp
  803411:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803414:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803417:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80341e:	00 00 00 
  803421:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803424:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803426:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342d:	00 00 00 
  803430:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803433:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803436:	bf 03 00 00 00       	mov    $0x3,%edi
  80343b:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  803442:	00 00 00 
  803445:	ff d0                	callq  *%rax
}
  803447:	c9                   	leaveq 
  803448:	c3                   	retq   

0000000000803449 <nsipc_close>:

int
nsipc_close(int s)
{
  803449:	55                   	push   %rbp
  80344a:	48 89 e5             	mov    %rsp,%rbp
  80344d:	48 83 ec 10          	sub    $0x10,%rsp
  803451:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803454:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80345b:	00 00 00 
  80345e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803461:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803463:	bf 04 00 00 00       	mov    $0x4,%edi
  803468:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
}
  803474:	c9                   	leaveq 
  803475:	c3                   	retq   

0000000000803476 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803476:	55                   	push   %rbp
  803477:	48 89 e5             	mov    %rsp,%rbp
  80347a:	48 83 ec 10          	sub    $0x10,%rsp
  80347e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803481:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803485:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803488:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348f:	00 00 00 
  803492:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803495:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803497:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80349a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349e:	48 89 c6             	mov    %rax,%rsi
  8034a1:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8034a8:	00 00 00 
  8034ab:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8034b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034be:	00 00 00 
  8034c1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034c4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8034c7:	bf 05 00 00 00       	mov    $0x5,%edi
  8034cc:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  8034d3:	00 00 00 
  8034d6:	ff d0                	callq  *%rax
}
  8034d8:	c9                   	leaveq 
  8034d9:	c3                   	retq   

00000000008034da <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8034da:	55                   	push   %rbp
  8034db:	48 89 e5             	mov    %rsp,%rbp
  8034de:	48 83 ec 10          	sub    $0x10,%rsp
  8034e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034e5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8034e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ef:	00 00 00 
  8034f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034f5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8034f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fe:	00 00 00 
  803501:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803504:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803507:	bf 06 00 00 00       	mov    $0x6,%edi
  80350c:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
}
  803518:	c9                   	leaveq 
  803519:	c3                   	retq   

000000000080351a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80351a:	55                   	push   %rbp
  80351b:	48 89 e5             	mov    %rsp,%rbp
  80351e:	48 83 ec 30          	sub    $0x30,%rsp
  803522:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803525:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803529:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80352c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80352f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803536:	00 00 00 
  803539:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80353c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80353e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803545:	00 00 00 
  803548:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80354b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80354e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803555:	00 00 00 
  803558:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80355b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80355e:	bf 07 00 00 00       	mov    $0x7,%edi
  803563:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
  80356f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803572:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803576:	78 69                	js     8035e1 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803578:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80357f:	7f 08                	jg     803589 <nsipc_recv+0x6f>
  803581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803584:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803587:	7e 35                	jle    8035be <nsipc_recv+0xa4>
  803589:	48 b9 b6 4a 80 00 00 	movabs $0x804ab6,%rcx
  803590:	00 00 00 
  803593:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  80359a:	00 00 00 
  80359d:	be 61 00 00 00       	mov    $0x61,%esi
  8035a2:	48 bf e0 4a 80 00 00 	movabs $0x804ae0,%rdi
  8035a9:	00 00 00 
  8035ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b1:	49 b8 5b 06 80 00 00 	movabs $0x80065b,%r8
  8035b8:	00 00 00 
  8035bb:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c1:	48 63 d0             	movslq %eax,%rdx
  8035c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c8:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035cf:	00 00 00 
  8035d2:	48 89 c7             	mov    %rax,%rdi
  8035d5:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  8035dc:	00 00 00 
  8035df:	ff d0                	callq  *%rax
	}

	return r;
  8035e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035e4:	c9                   	leaveq 
  8035e5:	c3                   	retq   

00000000008035e6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035e6:	55                   	push   %rbp
  8035e7:	48 89 e5             	mov    %rsp,%rbp
  8035ea:	48 83 ec 20          	sub    $0x20,%rsp
  8035ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035f5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8035f8:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8035fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803602:	00 00 00 
  803605:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803608:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80360a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803611:	7e 35                	jle    803648 <nsipc_send+0x62>
  803613:	48 b9 ec 4a 80 00 00 	movabs $0x804aec,%rcx
  80361a:	00 00 00 
  80361d:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  803624:	00 00 00 
  803627:	be 6c 00 00 00       	mov    $0x6c,%esi
  80362c:	48 bf e0 4a 80 00 00 	movabs $0x804ae0,%rdi
  803633:	00 00 00 
  803636:	b8 00 00 00 00       	mov    $0x0,%eax
  80363b:	49 b8 5b 06 80 00 00 	movabs $0x80065b,%r8
  803642:	00 00 00 
  803645:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803648:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80364b:	48 63 d0             	movslq %eax,%rdx
  80364e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803652:	48 89 c6             	mov    %rax,%rsi
  803655:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80365c:	00 00 00 
  80365f:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80366b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803672:	00 00 00 
  803675:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803678:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80367b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803682:	00 00 00 
  803685:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803688:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80368b:	bf 08 00 00 00       	mov    $0x8,%edi
  803690:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  803697:	00 00 00 
  80369a:	ff d0                	callq  *%rax
}
  80369c:	c9                   	leaveq 
  80369d:	c3                   	retq   

000000000080369e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80369e:	55                   	push   %rbp
  80369f:	48 89 e5             	mov    %rsp,%rbp
  8036a2:	48 83 ec 10          	sub    $0x10,%rsp
  8036a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036a9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8036ac:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8036af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b6:	00 00 00 
  8036b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036bc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8036be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c5:	00 00 00 
  8036c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036cb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8036ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d5:	00 00 00 
  8036d8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8036db:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8036de:	bf 09 00 00 00       	mov    $0x9,%edi
  8036e3:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  8036ea:	00 00 00 
  8036ed:	ff d0                	callq  *%rax
}
  8036ef:	c9                   	leaveq 
  8036f0:	c3                   	retq   

00000000008036f1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036f1:	55                   	push   %rbp
  8036f2:	48 89 e5             	mov    %rsp,%rbp
  8036f5:	53                   	push   %rbx
  8036f6:	48 83 ec 38          	sub    $0x38,%rsp
  8036fa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036fe:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803702:	48 89 c7             	mov    %rax,%rdi
  803705:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  80370c:	00 00 00 
  80370f:	ff d0                	callq  *%rax
  803711:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803714:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803718:	0f 88 bf 01 00 00    	js     8038dd <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80371e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803722:	ba 07 04 00 00       	mov    $0x407,%edx
  803727:	48 89 c6             	mov    %rax,%rsi
  80372a:	bf 00 00 00 00       	mov    $0x0,%edi
  80372f:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  803736:	00 00 00 
  803739:	ff d0                	callq  *%rax
  80373b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80373e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803742:	0f 88 95 01 00 00    	js     8038dd <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803748:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80374c:	48 89 c7             	mov    %rax,%rdi
  80374f:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  803756:	00 00 00 
  803759:	ff d0                	callq  *%rax
  80375b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80375e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803762:	0f 88 5d 01 00 00    	js     8038c5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803768:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376c:	ba 07 04 00 00       	mov    $0x407,%edx
  803771:	48 89 c6             	mov    %rax,%rsi
  803774:	bf 00 00 00 00       	mov    $0x0,%edi
  803779:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
  803785:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803788:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80378c:	0f 88 33 01 00 00    	js     8038c5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803796:	48 89 c7             	mov    %rax,%rdi
  803799:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
  8037a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ad:	ba 07 04 00 00       	mov    $0x407,%edx
  8037b2:	48 89 c6             	mov    %rax,%rsi
  8037b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ba:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037cd:	79 05                	jns    8037d4 <pipe+0xe3>
		goto err2;
  8037cf:	e9 d9 00 00 00       	jmpq   8038ad <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d8:	48 89 c7             	mov    %rax,%rdi
  8037db:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
  8037e7:	48 89 c2             	mov    %rax,%rdx
  8037ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ee:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037f4:	48 89 d1             	mov    %rdx,%rcx
  8037f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8037fc:	48 89 c6             	mov    %rax,%rsi
  8037ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803804:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80380b:	00 00 00 
  80380e:	ff d0                	callq  *%rax
  803810:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803813:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803817:	79 1b                	jns    803834 <pipe+0x143>
		goto err3;
  803819:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80381a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80381e:	48 89 c6             	mov    %rax,%rsi
  803821:	bf 00 00 00 00       	mov    $0x0,%edi
  803826:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  80382d:	00 00 00 
  803830:	ff d0                	callq  *%rax
  803832:	eb 79                	jmp    8038ad <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803838:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80383f:	00 00 00 
  803842:	8b 12                	mov    (%rdx),%edx
  803844:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803851:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803855:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80385c:	00 00 00 
  80385f:	8b 12                	mov    (%rdx),%edx
  803861:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803863:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803867:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80386e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803872:	48 89 c7             	mov    %rax,%rdi
  803875:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
  803881:	89 c2                	mov    %eax,%edx
  803883:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803887:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803889:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80388d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803891:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803895:	48 89 c7             	mov    %rax,%rdi
  803898:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
  8038a4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ab:	eb 33                	jmp    8038e0 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8038ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038b1:	48 89 c6             	mov    %rax,%rsi
  8038b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b9:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8038c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c9:	48 89 c6             	mov    %rax,%rsi
  8038cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d1:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
err:
	return r;
  8038dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038e0:	48 83 c4 38          	add    $0x38,%rsp
  8038e4:	5b                   	pop    %rbx
  8038e5:	5d                   	pop    %rbp
  8038e6:	c3                   	retq   

00000000008038e7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038e7:	55                   	push   %rbp
  8038e8:	48 89 e5             	mov    %rsp,%rbp
  8038eb:	53                   	push   %rbx
  8038ec:	48 83 ec 28          	sub    $0x28,%rsp
  8038f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038f8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038ff:	00 00 00 
  803902:	48 8b 00             	mov    (%rax),%rax
  803905:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80390b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80390e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803912:	48 89 c7             	mov    %rax,%rdi
  803915:	48 b8 3d 42 80 00 00 	movabs $0x80423d,%rax
  80391c:	00 00 00 
  80391f:	ff d0                	callq  *%rax
  803921:	89 c3                	mov    %eax,%ebx
  803923:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803927:	48 89 c7             	mov    %rax,%rdi
  80392a:	48 b8 3d 42 80 00 00 	movabs $0x80423d,%rax
  803931:	00 00 00 
  803934:	ff d0                	callq  *%rax
  803936:	39 c3                	cmp    %eax,%ebx
  803938:	0f 94 c0             	sete   %al
  80393b:	0f b6 c0             	movzbl %al,%eax
  80393e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803941:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803948:	00 00 00 
  80394b:	48 8b 00             	mov    (%rax),%rax
  80394e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803954:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803957:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80395d:	75 05                	jne    803964 <_pipeisclosed+0x7d>
			return ret;
  80395f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803962:	eb 4a                	jmp    8039ae <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803964:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803967:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80396a:	74 3d                	je     8039a9 <_pipeisclosed+0xc2>
  80396c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803970:	75 37                	jne    8039a9 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803972:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803979:	00 00 00 
  80397c:	48 8b 00             	mov    (%rax),%rax
  80397f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803985:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803988:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80398b:	89 c6                	mov    %eax,%esi
  80398d:	48 bf fd 4a 80 00 00 	movabs $0x804afd,%rdi
  803994:	00 00 00 
  803997:	b8 00 00 00 00       	mov    $0x0,%eax
  80399c:	49 b8 94 08 80 00 00 	movabs $0x800894,%r8
  8039a3:	00 00 00 
  8039a6:	41 ff d0             	callq  *%r8
	}
  8039a9:	e9 4a ff ff ff       	jmpq   8038f8 <_pipeisclosed+0x11>
}
  8039ae:	48 83 c4 28          	add    $0x28,%rsp
  8039b2:	5b                   	pop    %rbx
  8039b3:	5d                   	pop    %rbp
  8039b4:	c3                   	retq   

00000000008039b5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8039b5:	55                   	push   %rbp
  8039b6:	48 89 e5             	mov    %rsp,%rbp
  8039b9:	48 83 ec 30          	sub    $0x30,%rsp
  8039bd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039c0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039c7:	48 89 d6             	mov    %rdx,%rsi
  8039ca:	89 c7                	mov    %eax,%edi
  8039cc:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
  8039d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039df:	79 05                	jns    8039e6 <pipeisclosed+0x31>
		return r;
  8039e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e4:	eb 31                	jmp    803a17 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ea:	48 89 c7             	mov    %rax,%rdi
  8039ed:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
  8039f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a05:	48 89 d6             	mov    %rdx,%rsi
  803a08:	48 89 c7             	mov    %rax,%rdi
  803a0b:	48 b8 e7 38 80 00 00 	movabs $0x8038e7,%rax
  803a12:	00 00 00 
  803a15:	ff d0                	callq  *%rax
}
  803a17:	c9                   	leaveq 
  803a18:	c3                   	retq   

0000000000803a19 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a19:	55                   	push   %rbp
  803a1a:	48 89 e5             	mov    %rsp,%rbp
  803a1d:	48 83 ec 40          	sub    $0x40,%rsp
  803a21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a29:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a31:	48 89 c7             	mov    %rax,%rdi
  803a34:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  803a3b:	00 00 00 
  803a3e:	ff d0                	callq  *%rax
  803a40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a4c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a53:	00 
  803a54:	e9 92 00 00 00       	jmpq   803aeb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803a59:	eb 41                	jmp    803a9c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a5b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a60:	74 09                	je     803a6b <devpipe_read+0x52>
				return i;
  803a62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a66:	e9 92 00 00 00       	jmpq   803afd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a73:	48 89 d6             	mov    %rdx,%rsi
  803a76:	48 89 c7             	mov    %rax,%rdi
  803a79:	48 b8 e7 38 80 00 00 	movabs $0x8038e7,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
  803a85:	85 c0                	test   %eax,%eax
  803a87:	74 07                	je     803a90 <devpipe_read+0x77>
				return 0;
  803a89:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8e:	eb 6d                	jmp    803afd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a90:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803a97:	00 00 00 
  803a9a:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803a9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa0:	8b 10                	mov    (%rax),%edx
  803aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa6:	8b 40 04             	mov    0x4(%rax),%eax
  803aa9:	39 c2                	cmp    %eax,%edx
  803aab:	74 ae                	je     803a5b <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803aad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ab5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abd:	8b 00                	mov    (%rax),%eax
  803abf:	99                   	cltd   
  803ac0:	c1 ea 1b             	shr    $0x1b,%edx
  803ac3:	01 d0                	add    %edx,%eax
  803ac5:	83 e0 1f             	and    $0x1f,%eax
  803ac8:	29 d0                	sub    %edx,%eax
  803aca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ace:	48 98                	cltq   
  803ad0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803ad5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803adb:	8b 00                	mov    (%rax),%eax
  803add:	8d 50 01             	lea    0x1(%rax),%edx
  803ae0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae4:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803ae6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aef:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803af3:	0f 82 60 ff ff ff    	jb     803a59 <devpipe_read+0x40>
	}
	return i;
  803af9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803afd:	c9                   	leaveq 
  803afe:	c3                   	retq   

0000000000803aff <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803aff:	55                   	push   %rbp
  803b00:	48 89 e5             	mov    %rsp,%rbp
  803b03:	48 83 ec 40          	sub    $0x40,%rsp
  803b07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b0f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b17:	48 89 c7             	mov    %rax,%rdi
  803b1a:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  803b21:	00 00 00 
  803b24:	ff d0                	callq  *%rax
  803b26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b32:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b39:	00 
  803b3a:	e9 91 00 00 00       	jmpq   803bd0 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b3f:	eb 31                	jmp    803b72 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b49:	48 89 d6             	mov    %rdx,%rsi
  803b4c:	48 89 c7             	mov    %rax,%rdi
  803b4f:	48 b8 e7 38 80 00 00 	movabs $0x8038e7,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 07                	je     803b66 <devpipe_write+0x67>
				return 0;
  803b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b64:	eb 7c                	jmp    803be2 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b66:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803b6d:	00 00 00 
  803b70:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	8b 40 04             	mov    0x4(%rax),%eax
  803b79:	48 63 d0             	movslq %eax,%rdx
  803b7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b80:	8b 00                	mov    (%rax),%eax
  803b82:	48 98                	cltq   
  803b84:	48 83 c0 20          	add    $0x20,%rax
  803b88:	48 39 c2             	cmp    %rax,%rdx
  803b8b:	73 b4                	jae    803b41 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b91:	8b 40 04             	mov    0x4(%rax),%eax
  803b94:	99                   	cltd   
  803b95:	c1 ea 1b             	shr    $0x1b,%edx
  803b98:	01 d0                	add    %edx,%eax
  803b9a:	83 e0 1f             	and    $0x1f,%eax
  803b9d:	29 d0                	sub    %edx,%eax
  803b9f:	89 c6                	mov    %eax,%esi
  803ba1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ba5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba9:	48 01 d0             	add    %rdx,%rax
  803bac:	0f b6 08             	movzbl (%rax),%ecx
  803baf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bb3:	48 63 c6             	movslq %esi,%rax
  803bb6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbe:	8b 40 04             	mov    0x4(%rax),%eax
  803bc1:	8d 50 01             	lea    0x1(%rax),%edx
  803bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc8:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803bcb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bd8:	0f 82 61 ff ff ff    	jb     803b3f <devpipe_write+0x40>
	}

	return i;
  803bde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803be2:	c9                   	leaveq 
  803be3:	c3                   	retq   

0000000000803be4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803be4:	55                   	push   %rbp
  803be5:	48 89 e5             	mov    %rsp,%rbp
  803be8:	48 83 ec 20          	sub    $0x20,%rsp
  803bec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bf0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf8:	48 89 c7             	mov    %rax,%rdi
  803bfb:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  803c02:	00 00 00 
  803c05:	ff d0                	callq  *%rax
  803c07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c0f:	48 be 10 4b 80 00 00 	movabs $0x804b10,%rsi
  803c16:	00 00 00 
  803c19:	48 89 c7             	mov    %rax,%rdi
  803c1c:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2c:	8b 50 04             	mov    0x4(%rax),%edx
  803c2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c33:	8b 00                	mov    (%rax),%eax
  803c35:	29 c2                	sub    %eax,%edx
  803c37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c45:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c4c:	00 00 00 
	stat->st_dev = &devpipe;
  803c4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c53:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803c5a:	00 00 00 
  803c5d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c69:	c9                   	leaveq 
  803c6a:	c3                   	retq   

0000000000803c6b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c6b:	55                   	push   %rbp
  803c6c:	48 89 e5             	mov    %rsp,%rbp
  803c6f:	48 83 ec 10          	sub    $0x10,%rsp
  803c73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c7b:	48 89 c6             	mov    %rax,%rsi
  803c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c83:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c93:	48 89 c7             	mov    %rax,%rdi
  803c96:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	48 89 c6             	mov    %rax,%rsi
  803ca5:	bf 00 00 00 00       	mov    $0x0,%edi
  803caa:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
}
  803cb6:	c9                   	leaveq 
  803cb7:	c3                   	retq   

0000000000803cb8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803cb8:	55                   	push   %rbp
  803cb9:	48 89 e5             	mov    %rsp,%rbp
  803cbc:	48 83 ec 20          	sub    $0x20,%rsp
  803cc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803cc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc7:	75 35                	jne    803cfe <wait+0x46>
  803cc9:	48 b9 17 4b 80 00 00 	movabs $0x804b17,%rcx
  803cd0:	00 00 00 
  803cd3:	48 ba 22 4b 80 00 00 	movabs $0x804b22,%rdx
  803cda:	00 00 00 
  803cdd:	be 09 00 00 00       	mov    $0x9,%esi
  803ce2:	48 bf 37 4b 80 00 00 	movabs $0x804b37,%rdi
  803ce9:	00 00 00 
  803cec:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf1:	49 b8 5b 06 80 00 00 	movabs $0x80065b,%r8
  803cf8:	00 00 00 
  803cfb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803cfe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d01:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d06:	48 98                	cltq   
  803d08:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803d0f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d16:	00 00 00 
  803d19:	48 01 d0             	add    %rdx,%rax
  803d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803d20:	eb 0c                	jmp    803d2e <wait+0x76>
		sys_yield();
  803d22:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d32:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d38:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d3b:	75 0e                	jne    803d4b <wait+0x93>
  803d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d41:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d47:	85 c0                	test   %eax,%eax
  803d49:	75 d7                	jne    803d22 <wait+0x6a>
}
  803d4b:	c9                   	leaveq 
  803d4c:	c3                   	retq   

0000000000803d4d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d4d:	55                   	push   %rbp
  803d4e:	48 89 e5             	mov    %rsp,%rbp
  803d51:	48 83 ec 20          	sub    $0x20,%rsp
  803d55:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d5e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d62:	be 01 00 00 00       	mov    $0x1,%esi
  803d67:	48 89 c7             	mov    %rax,%rdi
  803d6a:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  803d71:	00 00 00 
  803d74:	ff d0                	callq  *%rax
}
  803d76:	c9                   	leaveq 
  803d77:	c3                   	retq   

0000000000803d78 <getchar>:

int
getchar(void)
{
  803d78:	55                   	push   %rbp
  803d79:	48 89 e5             	mov    %rsp,%rbp
  803d7c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d80:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d84:	ba 01 00 00 00       	mov    $0x1,%edx
  803d89:	48 89 c6             	mov    %rax,%rsi
  803d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d91:	48 b8 dd 25 80 00 00 	movabs $0x8025dd,%rax
  803d98:	00 00 00 
  803d9b:	ff d0                	callq  *%rax
  803d9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803da0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da4:	79 05                	jns    803dab <getchar+0x33>
		return r;
  803da6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da9:	eb 14                	jmp    803dbf <getchar+0x47>
	if (r < 1)
  803dab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803daf:	7f 07                	jg     803db8 <getchar+0x40>
		return -E_EOF;
  803db1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803db6:	eb 07                	jmp    803dbf <getchar+0x47>
	return c;
  803db8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803dbc:	0f b6 c0             	movzbl %al,%eax
}
  803dbf:	c9                   	leaveq 
  803dc0:	c3                   	retq   

0000000000803dc1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803dc1:	55                   	push   %rbp
  803dc2:	48 89 e5             	mov    %rsp,%rbp
  803dc5:	48 83 ec 20          	sub    $0x20,%rsp
  803dc9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dcc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd3:	48 89 d6             	mov    %rdx,%rsi
  803dd6:	89 c7                	mov    %eax,%edi
  803dd8:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  803ddf:	00 00 00 
  803de2:	ff d0                	callq  *%rax
  803de4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803deb:	79 05                	jns    803df2 <iscons+0x31>
		return r;
  803ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df0:	eb 1a                	jmp    803e0c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df6:	8b 10                	mov    (%rax),%edx
  803df8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803dff:	00 00 00 
  803e02:	8b 00                	mov    (%rax),%eax
  803e04:	39 c2                	cmp    %eax,%edx
  803e06:	0f 94 c0             	sete   %al
  803e09:	0f b6 c0             	movzbl %al,%eax
}
  803e0c:	c9                   	leaveq 
  803e0d:	c3                   	retq   

0000000000803e0e <opencons>:

int
opencons(void)
{
  803e0e:	55                   	push   %rbp
  803e0f:	48 89 e5             	mov    %rsp,%rbp
  803e12:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e16:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e1a:	48 89 c7             	mov    %rax,%rdi
  803e1d:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  803e24:	00 00 00 
  803e27:	ff d0                	callq  *%rax
  803e29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e30:	79 05                	jns    803e37 <opencons+0x29>
		return r;
  803e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e35:	eb 5b                	jmp    803e92 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3b:	ba 07 04 00 00       	mov    $0x407,%edx
  803e40:	48 89 c6             	mov    %rax,%rsi
  803e43:	bf 00 00 00 00       	mov    $0x0,%edi
  803e48:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  803e4f:	00 00 00 
  803e52:	ff d0                	callq  *%rax
  803e54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e5b:	79 05                	jns    803e62 <opencons+0x54>
		return r;
  803e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e60:	eb 30                	jmp    803e92 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e66:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e6d:	00 00 00 
  803e70:	8b 12                	mov    (%rdx),%edx
  803e72:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e78:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e83:	48 89 c7             	mov    %rax,%rdi
  803e86:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  803e8d:	00 00 00 
  803e90:	ff d0                	callq  *%rax
}
  803e92:	c9                   	leaveq 
  803e93:	c3                   	retq   

0000000000803e94 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e94:	55                   	push   %rbp
  803e95:	48 89 e5             	mov    %rsp,%rbp
  803e98:	48 83 ec 30          	sub    $0x30,%rsp
  803e9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ea8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ead:	75 07                	jne    803eb6 <devcons_read+0x22>
		return 0;
  803eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb4:	eb 4b                	jmp    803f01 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803eb6:	eb 0c                	jmp    803ec4 <devcons_read+0x30>
		sys_yield();
  803eb8:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803ebf:	00 00 00 
  803ec2:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803ec4:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  803ecb:	00 00 00 
  803ece:	ff d0                	callq  *%rax
  803ed0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ed3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed7:	74 df                	je     803eb8 <devcons_read+0x24>
	if (c < 0)
  803ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803edd:	79 05                	jns    803ee4 <devcons_read+0x50>
		return c;
  803edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee2:	eb 1d                	jmp    803f01 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ee4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ee8:	75 07                	jne    803ef1 <devcons_read+0x5d>
		return 0;
  803eea:	b8 00 00 00 00       	mov    $0x0,%eax
  803eef:	eb 10                	jmp    803f01 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef4:	89 c2                	mov    %eax,%edx
  803ef6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803efa:	88 10                	mov    %dl,(%rax)
	return 1;
  803efc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f01:	c9                   	leaveq 
  803f02:	c3                   	retq   

0000000000803f03 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f03:	55                   	push   %rbp
  803f04:	48 89 e5             	mov    %rsp,%rbp
  803f07:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f0e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f15:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f1c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f2a:	eb 76                	jmp    803fa2 <devcons_write+0x9f>
		m = n - tot;
  803f2c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f33:	89 c2                	mov    %eax,%edx
  803f35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f38:	29 c2                	sub    %eax,%edx
  803f3a:	89 d0                	mov    %edx,%eax
  803f3c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f42:	83 f8 7f             	cmp    $0x7f,%eax
  803f45:	76 07                	jbe    803f4e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f47:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f51:	48 63 d0             	movslq %eax,%rdx
  803f54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f57:	48 63 c8             	movslq %eax,%rcx
  803f5a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f61:	48 01 c1             	add    %rax,%rcx
  803f64:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f6b:	48 89 ce             	mov    %rcx,%rsi
  803f6e:	48 89 c7             	mov    %rax,%rdi
  803f71:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  803f78:	00 00 00 
  803f7b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f80:	48 63 d0             	movslq %eax,%rdx
  803f83:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f8a:	48 89 d6             	mov    %rdx,%rsi
  803f8d:	48 89 c7             	mov    %rax,%rdi
  803f90:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  803f97:	00 00 00 
  803f9a:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803f9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f9f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa5:	48 98                	cltq   
  803fa7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803fae:	0f 82 78 ff ff ff    	jb     803f2c <devcons_write+0x29>
	}
	return tot;
  803fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fb7:	c9                   	leaveq 
  803fb8:	c3                   	retq   

0000000000803fb9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803fb9:	55                   	push   %rbp
  803fba:	48 89 e5             	mov    %rsp,%rbp
  803fbd:	48 83 ec 08          	sub    $0x8,%rsp
  803fc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fca:	c9                   	leaveq 
  803fcb:	c3                   	retq   

0000000000803fcc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fcc:	55                   	push   %rbp
  803fcd:	48 89 e5             	mov    %rsp,%rbp
  803fd0:	48 83 ec 10          	sub    $0x10,%rsp
  803fd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe0:	48 be 47 4b 80 00 00 	movabs $0x804b47,%rsi
  803fe7:	00 00 00 
  803fea:	48 89 c7             	mov    %rax,%rdi
  803fed:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  803ff4:	00 00 00 
  803ff7:	ff d0                	callq  *%rax
	return 0;
  803ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ffe:	c9                   	leaveq 
  803fff:	c3                   	retq   

0000000000804000 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804000:	55                   	push   %rbp
  804001:	48 89 e5             	mov    %rsp,%rbp
  804004:	48 83 ec 20          	sub    $0x20,%rsp
  804008:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80400c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804010:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804014:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  80401b:	00 00 00 
  80401e:	be 1d 00 00 00       	mov    $0x1d,%esi
  804023:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  80402a:	00 00 00 
  80402d:	b8 00 00 00 00       	mov    $0x0,%eax
  804032:	48 b9 5b 06 80 00 00 	movabs $0x80065b,%rcx
  804039:	00 00 00 
  80403c:	ff d1                	callq  *%rcx

000000000080403e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80403e:	55                   	push   %rbp
  80403f:	48 89 e5             	mov    %rsp,%rbp
  804042:	48 83 ec 20          	sub    $0x20,%rsp
  804046:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804049:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80404c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804050:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  804053:	48 ba 73 4b 80 00 00 	movabs $0x804b73,%rdx
  80405a:	00 00 00 
  80405d:	be 2d 00 00 00       	mov    $0x2d,%esi
  804062:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  804069:	00 00 00 
  80406c:	b8 00 00 00 00       	mov    $0x0,%eax
  804071:	48 b9 5b 06 80 00 00 	movabs $0x80065b,%rcx
  804078:	00 00 00 
  80407b:	ff d1                	callq  *%rcx

000000000080407d <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80407d:	55                   	push   %rbp
  80407e:	48 89 e5             	mov    %rsp,%rbp
  804081:	53                   	push   %rbx
  804082:	48 83 ec 48          	sub    $0x48,%rsp
  804086:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80408a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  804091:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804098:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  80409d:	75 0e                	jne    8040ad <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  80409f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8040a6:	00 00 00 
  8040a9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8040ad:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8040b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  8040b5:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8040bc:	00 
	a3 = (uint64_t) 0;
  8040bd:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8040c4:	00 
	a4 = (uint64_t) 0;
  8040c5:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8040cc:	00 
	a5 = 0;
  8040cd:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8040d4:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  8040d5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040dc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8040e0:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  8040e4:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8040e8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8040ec:	4c 89 c3             	mov    %r8,%rbx
  8040ef:	0f 01 c1             	vmcall 
  8040f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  8040f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040f9:	7e 36                	jle    804131 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  8040fb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040fe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804101:	41 89 d0             	mov    %edx,%r8d
  804104:	89 c1                	mov    %eax,%ecx
  804106:	48 ba 90 4b 80 00 00 	movabs $0x804b90,%rdx
  80410d:	00 00 00 
  804110:	be 54 00 00 00       	mov    $0x54,%esi
  804115:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  80411c:	00 00 00 
  80411f:	b8 00 00 00 00       	mov    $0x0,%eax
  804124:	49 b9 5b 06 80 00 00 	movabs $0x80065b,%r9
  80412b:	00 00 00 
  80412e:	41 ff d1             	callq  *%r9
	return ret;
  804131:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804134:	48 83 c4 48          	add    $0x48,%rsp
  804138:	5b                   	pop    %rbx
  804139:	5d                   	pop    %rbp
  80413a:	c3                   	retq   

000000000080413b <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80413b:	55                   	push   %rbp
  80413c:	48 89 e5             	mov    %rsp,%rbp
  80413f:	53                   	push   %rbx
  804140:	48 83 ec 58          	sub    $0x58,%rsp
  804144:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804147:	89 75 b0             	mov    %esi,-0x50(%rbp)
  80414a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80414e:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804151:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804158:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  80415f:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  804164:	75 0e                	jne    804174 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  804166:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80416d:	00 00 00 
  804170:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804174:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804177:	48 98                	cltq   
  804179:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  80417d:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804180:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804184:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804188:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  80418c:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80418f:	48 98                	cltq   
  804191:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  804195:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80419c:	00 

	int r = -E_IPC_NOT_RECV;
  80419d:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8041a4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8041a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041ab:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8041af:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8041b3:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8041b7:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041bb:	4c 89 c3             	mov    %r8,%rbx
  8041be:	0f 01 c1             	vmcall 
  8041c1:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  8041c4:	48 83 c4 58          	add    $0x58,%rsp
  8041c8:	5b                   	pop    %rbx
  8041c9:	5d                   	pop    %rbp
  8041ca:	c3                   	retq   

00000000008041cb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041cb:	55                   	push   %rbp
  8041cc:	48 89 e5             	mov    %rsp,%rbp
  8041cf:	48 83 ec 18          	sub    $0x18,%rsp
  8041d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041dd:	eb 4e                	jmp    80422d <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8041df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041e6:	00 00 00 
  8041e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ec:	48 98                	cltq   
  8041ee:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041f5:	48 01 d0             	add    %rdx,%rax
  8041f8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041fe:	8b 00                	mov    (%rax),%eax
  804200:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804203:	75 24                	jne    804229 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804205:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80420c:	00 00 00 
  80420f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804212:	48 98                	cltq   
  804214:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80421b:	48 01 d0             	add    %rdx,%rax
  80421e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804224:	8b 40 08             	mov    0x8(%rax),%eax
  804227:	eb 12                	jmp    80423b <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804229:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80422d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804234:	7e a9                	jle    8041df <ipc_find_env+0x14>
	}
	return 0;
  804236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80423b:	c9                   	leaveq 
  80423c:	c3                   	retq   

000000000080423d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80423d:	55                   	push   %rbp
  80423e:	48 89 e5             	mov    %rsp,%rbp
  804241:	48 83 ec 18          	sub    $0x18,%rsp
  804245:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424d:	48 c1 e8 15          	shr    $0x15,%rax
  804251:	48 89 c2             	mov    %rax,%rdx
  804254:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80425b:	01 00 00 
  80425e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804262:	83 e0 01             	and    $0x1,%eax
  804265:	48 85 c0             	test   %rax,%rax
  804268:	75 07                	jne    804271 <pageref+0x34>
		return 0;
  80426a:	b8 00 00 00 00       	mov    $0x0,%eax
  80426f:	eb 53                	jmp    8042c4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804275:	48 c1 e8 0c          	shr    $0xc,%rax
  804279:	48 89 c2             	mov    %rax,%rdx
  80427c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804283:	01 00 00 
  804286:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80428a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80428e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804292:	83 e0 01             	and    $0x1,%eax
  804295:	48 85 c0             	test   %rax,%rax
  804298:	75 07                	jne    8042a1 <pageref+0x64>
		return 0;
  80429a:	b8 00 00 00 00       	mov    $0x0,%eax
  80429f:	eb 23                	jmp    8042c4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8042a9:	48 89 c2             	mov    %rax,%rdx
  8042ac:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042b3:	00 00 00 
  8042b6:	48 c1 e2 04          	shl    $0x4,%rdx
  8042ba:	48 01 d0             	add    %rdx,%rax
  8042bd:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042c1:	0f b7 c0             	movzwl %ax,%eax
}
  8042c4:	c9                   	leaveq 
  8042c5:	c3                   	retq   
