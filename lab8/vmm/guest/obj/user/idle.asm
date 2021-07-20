
vmm/guest/obj/user/idle:     formato del fichero elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800059:	00 00 00 
  80005c:	48 ba 00 3d 80 00 00 	movabs $0x803d00,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800086:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80008d:	00 00 00 
  800090:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800097:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80009b:	7e 14                	jle    8000b1 <libmain+0x3a>
		binaryname = argv[0];
  80009d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000a1:	48 8b 10             	mov    (%rax),%rdx
  8000a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000ab:	00 00 00 
  8000ae:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	48 89 d6             	mov    %rdx,%rsi
  8000bb:	89 c7                	mov    %eax,%edi
  8000bd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c4:	00 00 00 
  8000c7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000c9:	48 b8 d7 00 80 00 00 	movabs $0x8000d7,%rax
  8000d0:	00 00 00 
  8000d3:	ff d0                	callq  *%rax
}
  8000d5:	c9                   	leaveq 
  8000d6:	c3                   	retq   

00000000008000d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d7:	55                   	push   %rbp
  8000d8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000db:	48 b8 79 09 80 00 00 	movabs $0x800979,%rax
  8000e2:	00 00 00 
  8000e5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8000e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ec:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
}
  8000f8:	5d                   	pop    %rbp
  8000f9:	c3                   	retq   

00000000008000fa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000fa:	55                   	push   %rbp
  8000fb:	48 89 e5             	mov    %rsp,%rbp
  8000fe:	53                   	push   %rbx
  8000ff:	48 83 ec 48          	sub    $0x48,%rsp
  800103:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800106:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800109:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80010d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800111:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800115:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800119:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80011c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800120:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800124:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800128:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80012c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800130:	4c 89 c3             	mov    %r8,%rbx
  800133:	cd 30                	int    $0x30
  800135:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800139:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80013d:	74 3e                	je     80017d <syscall+0x83>
  80013f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800144:	7e 37                	jle    80017d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800146:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014d:	49 89 d0             	mov    %rdx,%r8
  800150:	89 c1                	mov    %eax,%ecx
  800152:	48 ba 0f 3d 80 00 00 	movabs $0x803d0f,%rdx
  800159:	00 00 00 
  80015c:	be 23 00 00 00       	mov    $0x23,%esi
  800161:	48 bf 2c 3d 80 00 00 	movabs $0x803d2c,%rdi
  800168:	00 00 00 
  80016b:	b8 00 00 00 00       	mov    $0x0,%eax
  800170:	49 b9 de 24 80 00 00 	movabs $0x8024de,%r9
  800177:	00 00 00 
  80017a:	41 ff d1             	callq  *%r9

	return ret;
  80017d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800181:	48 83 c4 48          	add    $0x48,%rsp
  800185:	5b                   	pop    %rbx
  800186:	5d                   	pop    %rbp
  800187:	c3                   	retq   

0000000000800188 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800188:	55                   	push   %rbp
  800189:	48 89 e5             	mov    %rsp,%rbp
  80018c:	48 83 ec 10          	sub    $0x10,%rsp
  800190:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800194:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800198:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80019c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a0:	48 83 ec 08          	sub    $0x8,%rsp
  8001a4:	6a 00                	pushq  $0x0
  8001a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b2:	48 89 d1             	mov    %rdx,%rcx
  8001b5:	48 89 c2             	mov    %rax,%rdx
  8001b8:	be 00 00 00 00       	mov    $0x0,%esi
  8001bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c2:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8001c9:	00 00 00 
  8001cc:	ff d0                	callq  *%rax
  8001ce:	48 83 c4 10          	add    $0x10,%rsp
}
  8001d2:	c9                   	leaveq 
  8001d3:	c3                   	retq   

00000000008001d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d4:	55                   	push   %rbp
  8001d5:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001d8:	48 83 ec 08          	sub    $0x8,%rsp
  8001dc:	6a 00                	pushq  $0x0
  8001de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f4:	be 00 00 00 00       	mov    $0x0,%esi
  8001f9:	bf 01 00 00 00       	mov    $0x1,%edi
  8001fe:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
  80020a:	48 83 c4 10          	add    $0x10,%rsp
}
  80020e:	c9                   	leaveq 
  80020f:	c3                   	retq   

0000000000800210 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
  800214:	48 83 ec 10          	sub    $0x10,%rsp
  800218:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80021b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021e:	48 98                	cltq   
  800220:	48 83 ec 08          	sub    $0x8,%rsp
  800224:	6a 00                	pushq  $0x0
  800226:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800232:	b9 00 00 00 00       	mov    $0x0,%ecx
  800237:	48 89 c2             	mov    %rax,%rdx
  80023a:	be 01 00 00 00       	mov    $0x1,%esi
  80023f:	bf 03 00 00 00       	mov    $0x3,%edi
  800244:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
  800250:	48 83 c4 10          	add    $0x10,%rsp
}
  800254:	c9                   	leaveq 
  800255:	c3                   	retq   

0000000000800256 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800256:	55                   	push   %rbp
  800257:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80025a:	48 83 ec 08          	sub    $0x8,%rsp
  80025e:	6a 00                	pushq  $0x0
  800260:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800266:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800271:	ba 00 00 00 00       	mov    $0x0,%edx
  800276:	be 00 00 00 00       	mov    $0x0,%esi
  80027b:	bf 02 00 00 00       	mov    $0x2,%edi
  800280:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
  80028c:	48 83 c4 10          	add    $0x10,%rsp
}
  800290:	c9                   	leaveq 
  800291:	c3                   	retq   

0000000000800292 <sys_yield>:

void
sys_yield(void)
{
  800292:	55                   	push   %rbp
  800293:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800296:	48 83 ec 08          	sub    $0x8,%rsp
  80029a:	6a 00                	pushq  $0x0
  80029c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b2:	be 00 00 00 00       	mov    $0x0,%esi
  8002b7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002bc:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8002c3:	00 00 00 
  8002c6:	ff d0                	callq  *%rax
  8002c8:	48 83 c4 10          	add    $0x10,%rsp
}
  8002cc:	c9                   	leaveq 
  8002cd:	c3                   	retq   

00000000008002ce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002ce:	55                   	push   %rbp
  8002cf:	48 89 e5             	mov    %rsp,%rbp
  8002d2:	48 83 ec 10          	sub    $0x10,%rsp
  8002d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002dd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002e3:	48 63 c8             	movslq %eax,%rcx
  8002e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ed:	48 98                	cltq   
  8002ef:	48 83 ec 08          	sub    $0x8,%rsp
  8002f3:	6a 00                	pushq  $0x0
  8002f5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002fb:	49 89 c8             	mov    %rcx,%r8
  8002fe:	48 89 d1             	mov    %rdx,%rcx
  800301:	48 89 c2             	mov    %rax,%rdx
  800304:	be 01 00 00 00       	mov    $0x1,%esi
  800309:	bf 04 00 00 00       	mov    $0x4,%edi
  80030e:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800315:	00 00 00 
  800318:	ff d0                	callq  *%rax
  80031a:	48 83 c4 10          	add    $0x10,%rsp
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 83 ec 20          	sub    $0x20,%rsp
  800328:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80032f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800332:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800336:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80033a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80033d:	48 63 c8             	movslq %eax,%rcx
  800340:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800344:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800347:	48 63 f0             	movslq %eax,%rsi
  80034a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80034e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800351:	48 98                	cltq   
  800353:	48 83 ec 08          	sub    $0x8,%rsp
  800357:	51                   	push   %rcx
  800358:	49 89 f9             	mov    %rdi,%r9
  80035b:	49 89 f0             	mov    %rsi,%r8
  80035e:	48 89 d1             	mov    %rdx,%rcx
  800361:	48 89 c2             	mov    %rax,%rdx
  800364:	be 01 00 00 00       	mov    $0x1,%esi
  800369:	bf 05 00 00 00       	mov    $0x5,%edi
  80036e:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
  80037a:	48 83 c4 10          	add    $0x10,%rsp
}
  80037e:	c9                   	leaveq 
  80037f:	c3                   	retq   

0000000000800380 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800380:	55                   	push   %rbp
  800381:	48 89 e5             	mov    %rsp,%rbp
  800384:	48 83 ec 10          	sub    $0x10,%rsp
  800388:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80038b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80038f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800396:	48 98                	cltq   
  800398:	48 83 ec 08          	sub    $0x8,%rsp
  80039c:	6a 00                	pushq  $0x0
  80039e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003aa:	48 89 d1             	mov    %rdx,%rcx
  8003ad:	48 89 c2             	mov    %rax,%rdx
  8003b0:	be 01 00 00 00       	mov    $0x1,%esi
  8003b5:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ba:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax
  8003c6:	48 83 c4 10          	add    $0x10,%rsp
}
  8003ca:	c9                   	leaveq 
  8003cb:	c3                   	retq   

00000000008003cc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003cc:	55                   	push   %rbp
  8003cd:	48 89 e5             	mov    %rsp,%rbp
  8003d0:	48 83 ec 10          	sub    $0x10,%rsp
  8003d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003dd:	48 63 d0             	movslq %eax,%rdx
  8003e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e3:	48 98                	cltq   
  8003e5:	48 83 ec 08          	sub    $0x8,%rsp
  8003e9:	6a 00                	pushq  $0x0
  8003eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f7:	48 89 d1             	mov    %rdx,%rcx
  8003fa:	48 89 c2             	mov    %rax,%rdx
  8003fd:	be 01 00 00 00       	mov    $0x1,%esi
  800402:	bf 08 00 00 00       	mov    $0x8,%edi
  800407:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80040e:	00 00 00 
  800411:	ff d0                	callq  *%rax
  800413:	48 83 c4 10          	add    $0x10,%rsp
}
  800417:	c9                   	leaveq 
  800418:	c3                   	retq   

0000000000800419 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800419:	55                   	push   %rbp
  80041a:	48 89 e5             	mov    %rsp,%rbp
  80041d:	48 83 ec 10          	sub    $0x10,%rsp
  800421:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800424:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800428:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042f:	48 98                	cltq   
  800431:	48 83 ec 08          	sub    $0x8,%rsp
  800435:	6a 00                	pushq  $0x0
  800437:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80043d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800443:	48 89 d1             	mov    %rdx,%rcx
  800446:	48 89 c2             	mov    %rax,%rdx
  800449:	be 01 00 00 00       	mov    $0x1,%esi
  80044e:	bf 09 00 00 00       	mov    $0x9,%edi
  800453:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
  80045f:	48 83 c4 10          	add    $0x10,%rsp
}
  800463:	c9                   	leaveq 
  800464:	c3                   	retq   

0000000000800465 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800465:	55                   	push   %rbp
  800466:	48 89 e5             	mov    %rsp,%rbp
  800469:	48 83 ec 10          	sub    $0x10,%rsp
  80046d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800470:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800474:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80047b:	48 98                	cltq   
  80047d:	48 83 ec 08          	sub    $0x8,%rsp
  800481:	6a 00                	pushq  $0x0
  800483:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800489:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80048f:	48 89 d1             	mov    %rdx,%rcx
  800492:	48 89 c2             	mov    %rax,%rdx
  800495:	be 01 00 00 00       	mov    $0x1,%esi
  80049a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80049f:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8004a6:	00 00 00 
  8004a9:	ff d0                	callq  *%rax
  8004ab:	48 83 c4 10          	add    $0x10,%rsp
}
  8004af:	c9                   	leaveq 
  8004b0:	c3                   	retq   

00000000008004b1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004b1:	55                   	push   %rbp
  8004b2:	48 89 e5             	mov    %rsp,%rbp
  8004b5:	48 83 ec 20          	sub    $0x20,%rsp
  8004b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004c4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ca:	48 63 f0             	movslq %eax,%rsi
  8004cd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d4:	48 98                	cltq   
  8004d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004da:	48 83 ec 08          	sub    $0x8,%rsp
  8004de:	6a 00                	pushq  $0x0
  8004e0:	49 89 f1             	mov    %rsi,%r9
  8004e3:	49 89 c8             	mov    %rcx,%r8
  8004e6:	48 89 d1             	mov    %rdx,%rcx
  8004e9:	48 89 c2             	mov    %rax,%rdx
  8004ec:	be 00 00 00 00       	mov    $0x0,%esi
  8004f1:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004f6:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
  800502:	48 83 c4 10          	add    $0x10,%rsp
}
  800506:	c9                   	leaveq 
  800507:	c3                   	retq   

0000000000800508 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800508:	55                   	push   %rbp
  800509:	48 89 e5             	mov    %rsp,%rbp
  80050c:	48 83 ec 10          	sub    $0x10,%rsp
  800510:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800518:	48 83 ec 08          	sub    $0x8,%rsp
  80051c:	6a 00                	pushq  $0x0
  80051e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800524:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80052a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052f:	48 89 c2             	mov    %rax,%rdx
  800532:	be 01 00 00 00       	mov    $0x1,%esi
  800537:	bf 0d 00 00 00       	mov    $0xd,%edi
  80053c:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800543:	00 00 00 
  800546:	ff d0                	callq  *%rax
  800548:	48 83 c4 10          	add    $0x10,%rsp
}
  80054c:	c9                   	leaveq 
  80054d:	c3                   	retq   

000000000080054e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80054e:	55                   	push   %rbp
  80054f:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800552:	48 83 ec 08          	sub    $0x8,%rsp
  800556:	6a 00                	pushq  $0x0
  800558:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80055e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
  800569:	ba 00 00 00 00       	mov    $0x0,%edx
  80056e:	be 00 00 00 00       	mov    $0x0,%esi
  800573:	bf 0e 00 00 00       	mov    $0xe,%edi
  800578:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
  800584:	48 83 c4 10          	add    $0x10,%rsp
}
  800588:	c9                   	leaveq 
  800589:	c3                   	retq   

000000000080058a <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80058a:	55                   	push   %rbp
  80058b:	48 89 e5             	mov    %rsp,%rbp
  80058e:	48 83 ec 20          	sub    $0x20,%rsp
  800592:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800595:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800599:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80059c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005a0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8005a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005a7:	48 63 c8             	movslq %eax,%rcx
  8005aa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8005ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005b1:	48 63 f0             	movslq %eax,%rsi
  8005b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005bb:	48 98                	cltq   
  8005bd:	48 83 ec 08          	sub    $0x8,%rsp
  8005c1:	51                   	push   %rcx
  8005c2:	49 89 f9             	mov    %rdi,%r9
  8005c5:	49 89 f0             	mov    %rsi,%r8
  8005c8:	48 89 d1             	mov    %rdx,%rcx
  8005cb:	48 89 c2             	mov    %rax,%rdx
  8005ce:	be 00 00 00 00       	mov    $0x0,%esi
  8005d3:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005d8:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8005df:	00 00 00 
  8005e2:	ff d0                	callq  *%rax
  8005e4:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8005e8:	c9                   	leaveq 
  8005e9:	c3                   	retq   

00000000008005ea <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8005ea:	55                   	push   %rbp
  8005eb:	48 89 e5             	mov    %rsp,%rbp
  8005ee:	48 83 ec 10          	sub    $0x10,%rsp
  8005f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8005fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800602:	48 83 ec 08          	sub    $0x8,%rsp
  800606:	6a 00                	pushq  $0x0
  800608:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80060e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800614:	48 89 d1             	mov    %rdx,%rcx
  800617:	48 89 c2             	mov    %rax,%rdx
  80061a:	be 00 00 00 00       	mov    $0x0,%esi
  80061f:	bf 10 00 00 00       	mov    $0x10,%edi
  800624:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80062b:	00 00 00 
  80062e:	ff d0                	callq  *%rax
  800630:	48 83 c4 10          	add    $0x10,%rsp
}
  800634:	c9                   	leaveq 
  800635:	c3                   	retq   

0000000000800636 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800636:	55                   	push   %rbp
  800637:	48 89 e5             	mov    %rsp,%rbp
  80063a:	48 83 ec 08          	sub    $0x8,%rsp
  80063e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800642:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800646:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80064d:	ff ff ff 
  800650:	48 01 d0             	add    %rdx,%rax
  800653:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800657:	c9                   	leaveq 
  800658:	c3                   	retq   

0000000000800659 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800659:	55                   	push   %rbp
  80065a:	48 89 e5             	mov    %rsp,%rbp
  80065d:	48 83 ec 08          	sub    $0x8,%rsp
  800661:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800669:	48 89 c7             	mov    %rax,%rdi
  80066c:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  800673:	00 00 00 
  800676:	ff d0                	callq  *%rax
  800678:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80067e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800682:	c9                   	leaveq 
  800683:	c3                   	retq   

0000000000800684 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800684:	55                   	push   %rbp
  800685:	48 89 e5             	mov    %rsp,%rbp
  800688:	48 83 ec 18          	sub    $0x18,%rsp
  80068c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800690:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800697:	eb 6b                	jmp    800704 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80069c:	48 98                	cltq   
  80069e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006a4:	48 c1 e0 0c          	shl    $0xc,%rax
  8006a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b0:	48 c1 e8 15          	shr    $0x15,%rax
  8006b4:	48 89 c2             	mov    %rax,%rdx
  8006b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006be:	01 00 00 
  8006c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c5:	83 e0 01             	and    $0x1,%eax
  8006c8:	48 85 c0             	test   %rax,%rax
  8006cb:	74 21                	je     8006ee <fd_alloc+0x6a>
  8006cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8006d5:	48 89 c2             	mov    %rax,%rdx
  8006d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006df:	01 00 00 
  8006e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006e6:	83 e0 01             	and    $0x1,%eax
  8006e9:	48 85 c0             	test   %rax,%rax
  8006ec:	75 12                	jne    800700 <fd_alloc+0x7c>
			*fd_store = fd;
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fe:	eb 1a                	jmp    80071a <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  800700:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800704:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800708:	7e 8f                	jle    800699 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800715:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80071a:	c9                   	leaveq 
  80071b:	c3                   	retq   

000000000080071c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80071c:	55                   	push   %rbp
  80071d:	48 89 e5             	mov    %rsp,%rbp
  800720:	48 83 ec 20          	sub    $0x20,%rsp
  800724:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800727:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80072b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80072f:	78 06                	js     800737 <fd_lookup+0x1b>
  800731:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800735:	7e 07                	jle    80073e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800737:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073c:	eb 6c                	jmp    8007aa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80073e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800741:	48 98                	cltq   
  800743:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800749:	48 c1 e0 0c          	shl    $0xc,%rax
  80074d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800751:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800755:	48 c1 e8 15          	shr    $0x15,%rax
  800759:	48 89 c2             	mov    %rax,%rdx
  80075c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800763:	01 00 00 
  800766:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80076a:	83 e0 01             	and    $0x1,%eax
  80076d:	48 85 c0             	test   %rax,%rax
  800770:	74 21                	je     800793 <fd_lookup+0x77>
  800772:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800776:	48 c1 e8 0c          	shr    $0xc,%rax
  80077a:	48 89 c2             	mov    %rax,%rdx
  80077d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800784:	01 00 00 
  800787:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80078b:	83 e0 01             	and    $0x1,%eax
  80078e:	48 85 c0             	test   %rax,%rax
  800791:	75 07                	jne    80079a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800798:	eb 10                	jmp    8007aa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80079a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80079e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007a2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007aa:	c9                   	leaveq 
  8007ab:	c3                   	retq   

00000000008007ac <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007ac:	55                   	push   %rbp
  8007ad:	48 89 e5             	mov    %rsp,%rbp
  8007b0:	48 83 ec 30          	sub    $0x30,%rsp
  8007b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007b8:	89 f0                	mov    %esi,%eax
  8007ba:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c1:	48 89 c7             	mov    %rax,%rdi
  8007c4:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  8007cb:	00 00 00 
  8007ce:	ff d0                	callq  *%rax
  8007d0:	89 c2                	mov    %eax,%edx
  8007d2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8007d6:	48 89 c6             	mov    %rax,%rsi
  8007d9:	89 d7                	mov    %edx,%edi
  8007db:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  8007e2:	00 00 00 
  8007e5:	ff d0                	callq  *%rax
  8007e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007ee:	78 0a                	js     8007fa <fd_close+0x4e>
	    || fd != fd2)
  8007f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007f4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007f8:	74 12                	je     80080c <fd_close+0x60>
		return (must_exist ? r : 0);
  8007fa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007fe:	74 05                	je     800805 <fd_close+0x59>
  800800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800803:	eb 70                	jmp    800875 <fd_close+0xc9>
  800805:	b8 00 00 00 00       	mov    $0x0,%eax
  80080a:	eb 69                	jmp    800875 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80080c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800816:	48 89 d6             	mov    %rdx,%rsi
  800819:	89 c7                	mov    %eax,%edi
  80081b:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800822:	00 00 00 
  800825:	ff d0                	callq  *%rax
  800827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80082a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80082e:	78 2a                	js     80085a <fd_close+0xae>
		if (dev->dev_close)
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	48 8b 40 20          	mov    0x20(%rax),%rax
  800838:	48 85 c0             	test   %rax,%rax
  80083b:	74 16                	je     800853 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	48 8b 40 20          	mov    0x20(%rax),%rax
  800845:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800849:	48 89 d7             	mov    %rdx,%rdi
  80084c:	ff d0                	callq  *%rax
  80084e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800851:	eb 07                	jmp    80085a <fd_close+0xae>
		else
			r = 0;
  800853:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80085a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085e:	48 89 c6             	mov    %rax,%rsi
  800861:	bf 00 00 00 00       	mov    $0x0,%edi
  800866:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  80086d:	00 00 00 
  800870:	ff d0                	callq  *%rax
	return r;
  800872:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800875:	c9                   	leaveq 
  800876:	c3                   	retq   

0000000000800877 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800877:	55                   	push   %rbp
  800878:	48 89 e5             	mov    %rsp,%rbp
  80087b:	48 83 ec 20          	sub    $0x20,%rsp
  80087f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800882:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800886:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80088d:	eb 41                	jmp    8008d0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80088f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800896:	00 00 00 
  800899:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80089c:	48 63 d2             	movslq %edx,%rdx
  80089f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008a8:	75 22                	jne    8008cc <dev_lookup+0x55>
			*dev = devtab[i];
  8008aa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008b1:	00 00 00 
  8008b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008b7:	48 63 d2             	movslq %edx,%rdx
  8008ba:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008c2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	eb 60                	jmp    80092c <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  8008cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008d0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008d7:	00 00 00 
  8008da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008dd:	48 63 d2             	movslq %edx,%rdx
  8008e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008e4:	48 85 c0             	test   %rax,%rax
  8008e7:	75 a6                	jne    80088f <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008f0:	00 00 00 
  8008f3:	48 8b 00             	mov    (%rax),%rax
  8008f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008ff:	89 c6                	mov    %eax,%esi
  800901:	48 bf 40 3d 80 00 00 	movabs $0x803d40,%rdi
  800908:	00 00 00 
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
  800910:	48 b9 17 27 80 00 00 	movabs $0x802717,%rcx
  800917:	00 00 00 
  80091a:	ff d1                	callq  *%rcx
	*dev = 0;
  80091c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800920:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800927:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80092c:	c9                   	leaveq 
  80092d:	c3                   	retq   

000000000080092e <close>:

int
close(int fdnum)
{
  80092e:	55                   	push   %rbp
  80092f:	48 89 e5             	mov    %rsp,%rbp
  800932:	48 83 ec 20          	sub    $0x20,%rsp
  800936:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800939:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80093d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800940:	48 89 d6             	mov    %rdx,%rsi
  800943:	89 c7                	mov    %eax,%edi
  800945:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  80094c:	00 00 00 
  80094f:	ff d0                	callq  *%rax
  800951:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800954:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800958:	79 05                	jns    80095f <close+0x31>
		return r;
  80095a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80095d:	eb 18                	jmp    800977 <close+0x49>
	else
		return fd_close(fd, 1);
  80095f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800963:	be 01 00 00 00       	mov    $0x1,%esi
  800968:	48 89 c7             	mov    %rax,%rdi
  80096b:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800972:	00 00 00 
  800975:	ff d0                	callq  *%rax
}
  800977:	c9                   	leaveq 
  800978:	c3                   	retq   

0000000000800979 <close_all>:

void
close_all(void)
{
  800979:	55                   	push   %rbp
  80097a:	48 89 e5             	mov    %rsp,%rbp
  80097d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800981:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800988:	eb 15                	jmp    80099f <close_all+0x26>
		close(i);
  80098a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80098d:	89 c7                	mov    %eax,%edi
  80098f:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  800996:	00 00 00 
  800999:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  80099b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80099f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009a3:	7e e5                	jle    80098a <close_all+0x11>
}
  8009a5:	c9                   	leaveq 
  8009a6:	c3                   	retq   

00000000008009a7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009a7:	55                   	push   %rbp
  8009a8:	48 89 e5             	mov    %rsp,%rbp
  8009ab:	48 83 ec 40          	sub    $0x40,%rsp
  8009af:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009b2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009b5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009bc:	48 89 d6             	mov    %rdx,%rsi
  8009bf:	89 c7                	mov    %eax,%edi
  8009c1:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  8009c8:	00 00 00 
  8009cb:	ff d0                	callq  *%rax
  8009cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009d4:	79 08                	jns    8009de <dup+0x37>
		return r;
  8009d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009d9:	e9 70 01 00 00       	jmpq   800b4e <dup+0x1a7>
	close(newfdnum);
  8009de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009e1:	89 c7                	mov    %eax,%edi
  8009e3:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  8009ea:	00 00 00 
  8009ed:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009ef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009f2:	48 98                	cltq   
  8009f4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009fa:	48 c1 e0 0c          	shl    $0xc,%rax
  8009fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a06:	48 89 c7             	mov    %rax,%rdi
  800a09:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  800a10:	00 00 00 
  800a13:	ff d0                	callq  *%rax
  800a15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a1d:	48 89 c7             	mov    %rax,%rdi
  800a20:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  800a27:	00 00 00 
  800a2a:	ff d0                	callq  *%rax
  800a2c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a34:	48 c1 e8 15          	shr    $0x15,%rax
  800a38:	48 89 c2             	mov    %rax,%rdx
  800a3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a42:	01 00 00 
  800a45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a49:	83 e0 01             	and    $0x1,%eax
  800a4c:	48 85 c0             	test   %rax,%rax
  800a4f:	74 73                	je     800ac4 <dup+0x11d>
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	48 c1 e8 0c          	shr    $0xc,%rax
  800a59:	48 89 c2             	mov    %rax,%rdx
  800a5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a63:	01 00 00 
  800a66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a6a:	83 e0 01             	and    $0x1,%eax
  800a6d:	48 85 c0             	test   %rax,%rax
  800a70:	74 52                	je     800ac4 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	48 c1 e8 0c          	shr    $0xc,%rax
  800a7a:	48 89 c2             	mov    %rax,%rdx
  800a7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a84:	01 00 00 
  800a87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a8b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a90:	89 c1                	mov    %eax,%ecx
  800a92:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9a:	41 89 c8             	mov    %ecx,%r8d
  800a9d:	48 89 d1             	mov    %rdx,%rcx
  800aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa5:	48 89 c6             	mov    %rax,%rsi
  800aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  800aad:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	callq  *%rax
  800ab9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800abc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ac0:	79 02                	jns    800ac4 <dup+0x11d>
			goto err;
  800ac2:	eb 57                	jmp    800b1b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ac8:	48 c1 e8 0c          	shr    $0xc,%rax
  800acc:	48 89 c2             	mov    %rax,%rdx
  800acf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ad6:	01 00 00 
  800ad9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800add:	25 07 0e 00 00       	and    $0xe07,%eax
  800ae2:	89 c1                	mov    %eax,%ecx
  800ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aec:	41 89 c8             	mov    %ecx,%r8d
  800aef:	48 89 d1             	mov    %rdx,%rcx
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	48 89 c6             	mov    %rax,%rsi
  800afa:	bf 00 00 00 00       	mov    $0x0,%edi
  800aff:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800b06:	00 00 00 
  800b09:	ff d0                	callq  *%rax
  800b0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b12:	79 02                	jns    800b16 <dup+0x16f>
		goto err;
  800b14:	eb 05                	jmp    800b1b <dup+0x174>

	return newfdnum;
  800b16:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b19:	eb 33                	jmp    800b4e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b1f:	48 89 c6             	mov    %rax,%rsi
  800b22:	bf 00 00 00 00       	mov    $0x0,%edi
  800b27:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  800b2e:	00 00 00 
  800b31:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b37:	48 89 c6             	mov    %rax,%rsi
  800b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3f:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  800b46:	00 00 00 
  800b49:	ff d0                	callq  *%rax
	return r;
  800b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b4e:	c9                   	leaveq 
  800b4f:	c3                   	retq   

0000000000800b50 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b50:	55                   	push   %rbp
  800b51:	48 89 e5             	mov    %rsp,%rbp
  800b54:	48 83 ec 40          	sub    $0x40,%rsp
  800b58:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b5b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b5f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b63:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b6a:	48 89 d6             	mov    %rdx,%rsi
  800b6d:	89 c7                	mov    %eax,%edi
  800b6f:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800b76:	00 00 00 
  800b79:	ff d0                	callq  *%rax
  800b7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b82:	78 24                	js     800ba8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b88:	8b 00                	mov    (%rax),%eax
  800b8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b8e:	48 89 d6             	mov    %rdx,%rsi
  800b91:	89 c7                	mov    %eax,%edi
  800b93:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800b9a:	00 00 00 
  800b9d:	ff d0                	callq  *%rax
  800b9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ba2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ba6:	79 05                	jns    800bad <read+0x5d>
		return r;
  800ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bab:	eb 76                	jmp    800c23 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb1:	8b 40 08             	mov    0x8(%rax),%eax
  800bb4:	83 e0 03             	and    $0x3,%eax
  800bb7:	83 f8 01             	cmp    $0x1,%eax
  800bba:	75 3a                	jne    800bf6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bbc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800bc3:	00 00 00 
  800bc6:	48 8b 00             	mov    (%rax),%rax
  800bc9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800bcf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800bd2:	89 c6                	mov    %eax,%esi
  800bd4:	48 bf 5f 3d 80 00 00 	movabs $0x803d5f,%rdi
  800bdb:	00 00 00 
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
  800be3:	48 b9 17 27 80 00 00 	movabs $0x802717,%rcx
  800bea:	00 00 00 
  800bed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800bef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bf4:	eb 2d                	jmp    800c23 <read+0xd3>
	}
	if (!dev->dev_read)
  800bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfa:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bfe:	48 85 c0             	test   %rax,%rax
  800c01:	75 07                	jne    800c0a <read+0xba>
		return -E_NOT_SUPP;
  800c03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c08:	eb 19                	jmp    800c23 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0e:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c12:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c1a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c1e:	48 89 cf             	mov    %rcx,%rdi
  800c21:	ff d0                	callq  *%rax
}
  800c23:	c9                   	leaveq 
  800c24:	c3                   	retq   

0000000000800c25 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c25:	55                   	push   %rbp
  800c26:	48 89 e5             	mov    %rsp,%rbp
  800c29:	48 83 ec 30          	sub    $0x30,%rsp
  800c2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c34:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c3f:	eb 49                	jmp    800c8a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c44:	48 98                	cltq   
  800c46:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c4a:	48 29 c2             	sub    %rax,%rdx
  800c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c50:	48 63 c8             	movslq %eax,%rcx
  800c53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c57:	48 01 c1             	add    %rax,%rcx
  800c5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c5d:	48 89 ce             	mov    %rcx,%rsi
  800c60:	89 c7                	mov    %eax,%edi
  800c62:	48 b8 50 0b 80 00 00 	movabs $0x800b50,%rax
  800c69:	00 00 00 
  800c6c:	ff d0                	callq  *%rax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c71:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c75:	79 05                	jns    800c7c <readn+0x57>
			return m;
  800c77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c7a:	eb 1c                	jmp    800c98 <readn+0x73>
		if (m == 0)
  800c7c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c80:	75 02                	jne    800c84 <readn+0x5f>
			break;
  800c82:	eb 11                	jmp    800c95 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  800c84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c87:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c8d:	48 98                	cltq   
  800c8f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c93:	72 ac                	jb     800c41 <readn+0x1c>
	}
	return tot;
  800c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c98:	c9                   	leaveq 
  800c99:	c3                   	retq   

0000000000800c9a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c9a:	55                   	push   %rbp
  800c9b:	48 89 e5             	mov    %rsp,%rbp
  800c9e:	48 83 ec 40          	sub    $0x40,%rsp
  800ca2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ca5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800ca9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cb1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cb4:	48 89 d6             	mov    %rdx,%rsi
  800cb7:	89 c7                	mov    %eax,%edi
  800cb9:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	callq  *%rax
  800cc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ccc:	78 24                	js     800cf2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd2:	8b 00                	mov    (%rax),%eax
  800cd4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cd8:	48 89 d6             	mov    %rdx,%rsi
  800cdb:	89 c7                	mov    %eax,%edi
  800cdd:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800ce4:	00 00 00 
  800ce7:	ff d0                	callq  *%rax
  800ce9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cf0:	79 05                	jns    800cf7 <write+0x5d>
		return r;
  800cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf5:	eb 75                	jmp    800d6c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfb:	8b 40 08             	mov    0x8(%rax),%eax
  800cfe:	83 e0 03             	and    $0x3,%eax
  800d01:	85 c0                	test   %eax,%eax
  800d03:	75 3a                	jne    800d3f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d05:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d0c:	00 00 00 
  800d0f:	48 8b 00             	mov    (%rax),%rax
  800d12:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d18:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d1b:	89 c6                	mov    %eax,%esi
  800d1d:	48 bf 7b 3d 80 00 00 	movabs $0x803d7b,%rdi
  800d24:	00 00 00 
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2c:	48 b9 17 27 80 00 00 	movabs $0x802717,%rcx
  800d33:	00 00 00 
  800d36:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d3d:	eb 2d                	jmp    800d6c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d43:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d47:	48 85 c0             	test   %rax,%rax
  800d4a:	75 07                	jne    800d53 <write+0xb9>
		return -E_NOT_SUPP;
  800d4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d51:	eb 19                	jmp    800d6c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d57:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d63:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d67:	48 89 cf             	mov    %rcx,%rdi
  800d6a:	ff d0                	callq  *%rax
}
  800d6c:	c9                   	leaveq 
  800d6d:	c3                   	retq   

0000000000800d6e <seek>:

int
seek(int fdnum, off_t offset)
{
  800d6e:	55                   	push   %rbp
  800d6f:	48 89 e5             	mov    %rsp,%rbp
  800d72:	48 83 ec 18          	sub    $0x18,%rsp
  800d76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d79:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d83:	48 89 d6             	mov    %rdx,%rsi
  800d86:	89 c7                	mov    %eax,%edi
  800d88:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800d8f:	00 00 00 
  800d92:	ff d0                	callq  *%rax
  800d94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d9b:	79 05                	jns    800da2 <seek+0x34>
		return r;
  800d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800da0:	eb 0f                	jmp    800db1 <seek+0x43>
	fd->fd_offset = offset;
  800da2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800da9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db1:	c9                   	leaveq 
  800db2:	c3                   	retq   

0000000000800db3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800db3:	55                   	push   %rbp
  800db4:	48 89 e5             	mov    %rsp,%rbp
  800db7:	48 83 ec 30          	sub    $0x30,%rsp
  800dbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dbe:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dc1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dc8:	48 89 d6             	mov    %rdx,%rsi
  800dcb:	89 c7                	mov    %eax,%edi
  800dcd:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800dd4:	00 00 00 
  800dd7:	ff d0                	callq  *%rax
  800dd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de0:	78 24                	js     800e06 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de6:	8b 00                	mov    (%rax),%eax
  800de8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dec:	48 89 d6             	mov    %rdx,%rsi
  800def:	89 c7                	mov    %eax,%edi
  800df1:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800df8:	00 00 00 
  800dfb:	ff d0                	callq  *%rax
  800dfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e04:	79 05                	jns    800e0b <ftruncate+0x58>
		return r;
  800e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e09:	eb 72                	jmp    800e7d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0f:	8b 40 08             	mov    0x8(%rax),%eax
  800e12:	83 e0 03             	and    $0x3,%eax
  800e15:	85 c0                	test   %eax,%eax
  800e17:	75 3a                	jne    800e53 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e19:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800e20:	00 00 00 
  800e23:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e26:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e2c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e2f:	89 c6                	mov    %eax,%esi
  800e31:	48 bf 98 3d 80 00 00 	movabs $0x803d98,%rdi
  800e38:	00 00 00 
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	48 b9 17 27 80 00 00 	movabs $0x802717,%rcx
  800e47:	00 00 00 
  800e4a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800e4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e51:	eb 2a                	jmp    800e7d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e5b:	48 85 c0             	test   %rax,%rax
  800e5e:	75 07                	jne    800e67 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e60:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e65:	eb 16                	jmp    800e7d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e73:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e76:	89 ce                	mov    %ecx,%esi
  800e78:	48 89 d7             	mov    %rdx,%rdi
  800e7b:	ff d0                	callq  *%rax
}
  800e7d:	c9                   	leaveq 
  800e7e:	c3                   	retq   

0000000000800e7f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e7f:	55                   	push   %rbp
  800e80:	48 89 e5             	mov    %rsp,%rbp
  800e83:	48 83 ec 30          	sub    $0x30,%rsp
  800e87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e8a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e8e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e95:	48 89 d6             	mov    %rdx,%rsi
  800e98:	89 c7                	mov    %eax,%edi
  800e9a:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ea9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ead:	78 24                	js     800ed3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	8b 00                	mov    (%rax),%eax
  800eb5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800eb9:	48 89 d6             	mov    %rdx,%rsi
  800ebc:	89 c7                	mov    %eax,%edi
  800ebe:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800ec5:	00 00 00 
  800ec8:	ff d0                	callq  *%rax
  800eca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ecd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ed1:	79 05                	jns    800ed8 <fstat+0x59>
		return r;
  800ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed6:	eb 5e                	jmp    800f36 <fstat+0xb7>
	if (!dev->dev_stat)
  800ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edc:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ee0:	48 85 c0             	test   %rax,%rax
  800ee3:	75 07                	jne    800eec <fstat+0x6d>
		return -E_NOT_SUPP;
  800ee5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eea:	eb 4a                	jmp    800f36 <fstat+0xb7>
	stat->st_name[0] = 0;
  800eec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800ef3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800efe:	00 00 00 
	stat->st_isdir = 0;
  800f01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f05:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f0c:	00 00 00 
	stat->st_dev = dev;
  800f0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f17:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f22:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f2a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f2e:	48 89 ce             	mov    %rcx,%rsi
  800f31:	48 89 d7             	mov    %rdx,%rdi
  800f34:	ff d0                	callq  *%rax
}
  800f36:	c9                   	leaveq 
  800f37:	c3                   	retq   

0000000000800f38 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f38:	55                   	push   %rbp
  800f39:	48 89 e5             	mov    %rsp,%rbp
  800f3c:	48 83 ec 20          	sub    $0x20,%rsp
  800f40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4c:	be 00 00 00 00       	mov    $0x0,%esi
  800f51:	48 89 c7             	mov    %rax,%rdi
  800f54:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  800f5b:	00 00 00 
  800f5e:	ff d0                	callq  *%rax
  800f60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f67:	79 05                	jns    800f6e <stat+0x36>
		return fd;
  800f69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f6c:	eb 2f                	jmp    800f9d <stat+0x65>
	r = fstat(fd, stat);
  800f6e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f75:	48 89 d6             	mov    %rdx,%rsi
  800f78:	89 c7                	mov    %eax,%edi
  800f7a:	48 b8 7f 0e 80 00 00 	movabs $0x800e7f,%rax
  800f81:	00 00 00 
  800f84:	ff d0                	callq  *%rax
  800f86:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f8c:	89 c7                	mov    %eax,%edi
  800f8e:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  800f95:	00 00 00 
  800f98:	ff d0                	callq  *%rax
	return r;
  800f9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f9d:	c9                   	leaveq 
  800f9e:	c3                   	retq   

0000000000800f9f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f9f:	55                   	push   %rbp
  800fa0:	48 89 e5             	mov    %rsp,%rbp
  800fa3:	48 83 ec 10          	sub    $0x10,%rsp
  800fa7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800faa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800fae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fb5:	00 00 00 
  800fb8:	8b 00                	mov    (%rax),%eax
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	75 1f                	jne    800fdd <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fbe:	bf 01 00 00 00       	mov    $0x1,%edi
  800fc3:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fd8:	00 00 00 
  800fdb:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800fdd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fe4:	00 00 00 
  800fe7:	8b 00                	mov    (%rax),%eax
  800fe9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fec:	b9 07 00 00 00       	mov    $0x7,%ecx
  800ff1:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800ff8:	00 00 00 
  800ffb:	89 c7                	mov    %eax,%edi
  800ffd:	48 b8 48 3a 80 00 00 	movabs $0x803a48,%rax
  801004:	00 00 00 
  801007:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	48 89 c6             	mov    %rax,%rsi
  801015:	bf 00 00 00 00       	mov    $0x0,%edi
  80101a:	48 b8 0a 3a 80 00 00 	movabs $0x803a0a,%rax
  801021:	00 00 00 
  801024:	ff d0                	callq  *%rax
}
  801026:	c9                   	leaveq 
  801027:	c3                   	retq   

0000000000801028 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	48 83 ec 10          	sub    $0x10,%rsp
  801030:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801034:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  801037:	48 ba be 3d 80 00 00 	movabs $0x803dbe,%rdx
  80103e:	00 00 00 
  801041:	be 4c 00 00 00       	mov    $0x4c,%esi
  801046:	48 bf d3 3d 80 00 00 	movabs $0x803dd3,%rdi
  80104d:	00 00 00 
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	48 b9 de 24 80 00 00 	movabs $0x8024de,%rcx
  80105c:	00 00 00 
  80105f:	ff d1                	callq  *%rcx

0000000000801061 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801061:	55                   	push   %rbp
  801062:	48 89 e5             	mov    %rsp,%rbp
  801065:	48 83 ec 10          	sub    $0x10,%rsp
  801069:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80106d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801071:	8b 50 0c             	mov    0xc(%rax),%edx
  801074:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80107b:	00 00 00 
  80107e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801080:	be 00 00 00 00       	mov    $0x0,%esi
  801085:	bf 06 00 00 00       	mov    $0x6,%edi
  80108a:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  801091:	00 00 00 
  801094:	ff d0                	callq  *%rax
}
  801096:	c9                   	leaveq 
  801097:	c3                   	retq   

0000000000801098 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	48 83 ec 20          	sub    $0x20,%rsp
  8010a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8010ac:	48 ba de 3d 80 00 00 	movabs $0x803dde,%rdx
  8010b3:	00 00 00 
  8010b6:	be 6b 00 00 00       	mov    $0x6b,%esi
  8010bb:	48 bf d3 3d 80 00 00 	movabs $0x803dd3,%rdi
  8010c2:	00 00 00 
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ca:	48 b9 de 24 80 00 00 	movabs $0x8024de,%rcx
  8010d1:	00 00 00 
  8010d4:	ff d1                	callq  *%rcx

00000000008010d6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8010d6:	55                   	push   %rbp
  8010d7:	48 89 e5             	mov    %rsp,%rbp
  8010da:	48 83 ec 20          	sub    $0x20,%rsp
  8010de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8010ea:	48 ba fb 3d 80 00 00 	movabs $0x803dfb,%rdx
  8010f1:	00 00 00 
  8010f4:	be 7b 00 00 00       	mov    $0x7b,%esi
  8010f9:	48 bf d3 3d 80 00 00 	movabs $0x803dd3,%rdi
  801100:	00 00 00 
  801103:	b8 00 00 00 00       	mov    $0x0,%eax
  801108:	48 b9 de 24 80 00 00 	movabs $0x8024de,%rcx
  80110f:	00 00 00 
  801112:	ff d1                	callq  *%rcx

0000000000801114 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801114:	55                   	push   %rbp
  801115:	48 89 e5             	mov    %rsp,%rbp
  801118:	48 83 ec 20          	sub    $0x20,%rsp
  80111c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801120:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801128:	8b 50 0c             	mov    0xc(%rax),%edx
  80112b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801132:	00 00 00 
  801135:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801137:	be 00 00 00 00       	mov    $0x0,%esi
  80113c:	bf 05 00 00 00       	mov    $0x5,%edi
  801141:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  801148:	00 00 00 
  80114b:	ff d0                	callq  *%rax
  80114d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801150:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801154:	79 05                	jns    80115b <devfile_stat+0x47>
		return r;
  801156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801159:	eb 56                	jmp    8011b1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80115b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801166:	00 00 00 
  801169:	48 89 c7             	mov    %rax,%rdi
  80116c:	48 b8 b1 32 80 00 00 	movabs $0x8032b1,%rax
  801173:	00 00 00 
  801176:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801178:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80117f:	00 00 00 
  801182:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801188:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801192:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801199:	00 00 00 
  80119c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8011a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8011ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b1:	c9                   	leaveq 
  8011b2:	c3                   	retq   

00000000008011b3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	48 83 ec 10          	sub    $0x10,%rsp
  8011bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bf:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8011c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c6:	8b 50 0c             	mov    0xc(%rax),%edx
  8011c9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011d0:	00 00 00 
  8011d3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8011d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011dc:	00 00 00 
  8011df:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8011e2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8011e5:	be 00 00 00 00       	mov    $0x0,%esi
  8011ea:	bf 02 00 00 00       	mov    $0x2,%edi
  8011ef:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  8011f6:	00 00 00 
  8011f9:	ff d0                	callq  *%rax
}
  8011fb:	c9                   	leaveq 
  8011fc:	c3                   	retq   

00000000008011fd <remove>:

// Delete a file
int
remove(const char *path)
{
  8011fd:	55                   	push   %rbp
  8011fe:	48 89 e5             	mov    %rsp,%rbp
  801201:	48 83 ec 10          	sub    $0x10,%rsp
  801205:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120d:	48 89 c7             	mov    %rax,%rdi
  801210:	48 b8 45 32 80 00 00 	movabs $0x803245,%rax
  801217:	00 00 00 
  80121a:	ff d0                	callq  *%rax
  80121c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801221:	7e 07                	jle    80122a <remove+0x2d>
		return -E_BAD_PATH;
  801223:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801228:	eb 33                	jmp    80125d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	48 89 c6             	mov    %rax,%rsi
  801231:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801238:	00 00 00 
  80123b:	48 b8 b1 32 80 00 00 	movabs $0x8032b1,%rax
  801242:	00 00 00 
  801245:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801247:	be 00 00 00 00       	mov    $0x0,%esi
  80124c:	bf 07 00 00 00       	mov    $0x7,%edi
  801251:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  801258:	00 00 00 
  80125b:	ff d0                	callq  *%rax
}
  80125d:	c9                   	leaveq 
  80125e:	c3                   	retq   

000000000080125f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80125f:	55                   	push   %rbp
  801260:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801263:	be 00 00 00 00       	mov    $0x0,%esi
  801268:	bf 08 00 00 00       	mov    $0x8,%edi
  80126d:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  801274:	00 00 00 
  801277:	ff d0                	callq  *%rax
}
  801279:	5d                   	pop    %rbp
  80127a:	c3                   	retq   

000000000080127b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80127b:	55                   	push   %rbp
  80127c:	48 89 e5             	mov    %rsp,%rbp
  80127f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801286:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80128d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801294:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80129b:	be 00 00 00 00       	mov    $0x0,%esi
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  8012aa:	00 00 00 
  8012ad:	ff d0                	callq  *%rax
  8012af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8012b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012b6:	79 28                	jns    8012e0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8012b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012bb:	89 c6                	mov    %eax,%esi
  8012bd:	48 bf 19 3e 80 00 00 	movabs $0x803e19,%rdi
  8012c4:	00 00 00 
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cc:	48 ba 17 27 80 00 00 	movabs $0x802717,%rdx
  8012d3:	00 00 00 
  8012d6:	ff d2                	callq  *%rdx
		return fd_src;
  8012d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012db:	e9 74 01 00 00       	jmpq   801454 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8012e0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8012e7:	be 01 01 00 00       	mov    $0x101,%esi
  8012ec:	48 89 c7             	mov    %rax,%rdi
  8012ef:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	callq  *%rax
  8012fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8012fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801302:	79 39                	jns    80133d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801304:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801307:	89 c6                	mov    %eax,%esi
  801309:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  801310:	00 00 00 
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
  801318:	48 ba 17 27 80 00 00 	movabs $0x802717,%rdx
  80131f:	00 00 00 
  801322:	ff d2                	callq  *%rdx
		close(fd_src);
  801324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801327:	89 c7                	mov    %eax,%edi
  801329:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  801330:	00 00 00 
  801333:	ff d0                	callq  *%rax
		return fd_dest;
  801335:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801338:	e9 17 01 00 00       	jmpq   801454 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80133d:	eb 74                	jmp    8013b3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80133f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801342:	48 63 d0             	movslq %eax,%rdx
  801345:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80134c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80134f:	48 89 ce             	mov    %rcx,%rsi
  801352:	89 c7                	mov    %eax,%edi
  801354:	48 b8 9a 0c 80 00 00 	movabs $0x800c9a,%rax
  80135b:	00 00 00 
  80135e:	ff d0                	callq  *%rax
  801360:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801363:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801367:	79 4a                	jns    8013b3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801369:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80136c:	89 c6                	mov    %eax,%esi
  80136e:	48 bf 49 3e 80 00 00 	movabs $0x803e49,%rdi
  801375:	00 00 00 
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
  80137d:	48 ba 17 27 80 00 00 	movabs $0x802717,%rdx
  801384:	00 00 00 
  801387:	ff d2                	callq  *%rdx
			close(fd_src);
  801389:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80138c:	89 c7                	mov    %eax,%edi
  80138e:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  801395:	00 00 00 
  801398:	ff d0                	callq  *%rax
			close(fd_dest);
  80139a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80139d:	89 c7                	mov    %eax,%edi
  80139f:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  8013a6:	00 00 00 
  8013a9:	ff d0                	callq  *%rax
			return write_size;
  8013ab:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8013ae:	e9 a1 00 00 00       	jmpq   801454 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8013b3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8013ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013bd:	ba 00 02 00 00       	mov    $0x200,%edx
  8013c2:	48 89 ce             	mov    %rcx,%rsi
  8013c5:	89 c7                	mov    %eax,%edi
  8013c7:	48 b8 50 0b 80 00 00 	movabs $0x800b50,%rax
  8013ce:	00 00 00 
  8013d1:	ff d0                	callq  *%rax
  8013d3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8013d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8013da:	0f 8f 5f ff ff ff    	jg     80133f <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  8013e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8013e4:	79 47                	jns    80142d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	89 c6                	mov    %eax,%esi
  8013eb:	48 bf 5c 3e 80 00 00 	movabs $0x803e5c,%rdi
  8013f2:	00 00 00 
  8013f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fa:	48 ba 17 27 80 00 00 	movabs $0x802717,%rdx
  801401:	00 00 00 
  801404:	ff d2                	callq  *%rdx
		close(fd_src);
  801406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801409:	89 c7                	mov    %eax,%edi
  80140b:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  801412:	00 00 00 
  801415:	ff d0                	callq  *%rax
		close(fd_dest);
  801417:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80141a:	89 c7                	mov    %eax,%edi
  80141c:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  801423:	00 00 00 
  801426:	ff d0                	callq  *%rax
		return read_size;
  801428:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142b:	eb 27                	jmp    801454 <copy+0x1d9>
	}
	close(fd_src);
  80142d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801430:	89 c7                	mov    %eax,%edi
  801432:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  801439:	00 00 00 
  80143c:	ff d0                	callq  *%rax
	close(fd_dest);
  80143e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801441:	89 c7                	mov    %eax,%edi
  801443:	48 b8 2e 09 80 00 00 	movabs $0x80092e,%rax
  80144a:	00 00 00 
  80144d:	ff d0                	callq  *%rax
	return 0;
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801454:	c9                   	leaveq 
  801455:	c3                   	retq   

0000000000801456 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801456:	55                   	push   %rbp
  801457:	48 89 e5             	mov    %rsp,%rbp
  80145a:	48 83 ec 20          	sub    $0x20,%rsp
  80145e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801461:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801465:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801468:	48 89 d6             	mov    %rdx,%rsi
  80146b:	89 c7                	mov    %eax,%edi
  80146d:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  801474:	00 00 00 
  801477:	ff d0                	callq  *%rax
  801479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80147c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801480:	79 05                	jns    801487 <fd2sockid+0x31>
		return r;
  801482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801485:	eb 24                	jmp    8014ab <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148b:	8b 10                	mov    (%rax),%edx
  80148d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801494:	00 00 00 
  801497:	8b 00                	mov    (%rax),%eax
  801499:	39 c2                	cmp    %eax,%edx
  80149b:	74 07                	je     8014a4 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80149d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014a2:	eb 07                	jmp    8014ab <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8014a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a8:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8014ab:	c9                   	leaveq 
  8014ac:	c3                   	retq   

00000000008014ad <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8014ad:	55                   	push   %rbp
  8014ae:	48 89 e5             	mov    %rsp,%rbp
  8014b1:	48 83 ec 20          	sub    $0x20,%rsp
  8014b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8014b8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8014bc:	48 89 c7             	mov    %rax,%rdi
  8014bf:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8014c6:	00 00 00 
  8014c9:	ff d0                	callq  *%rax
  8014cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d2:	78 26                	js     8014fa <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8014d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d8:	ba 07 04 00 00       	mov    $0x407,%edx
  8014dd:	48 89 c6             	mov    %rax,%rsi
  8014e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e5:	48 b8 ce 02 80 00 00 	movabs $0x8002ce,%rax
  8014ec:	00 00 00 
  8014ef:	ff d0                	callq  *%rax
  8014f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014f8:	79 16                	jns    801510 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8014fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014fd:	89 c7                	mov    %eax,%edi
  8014ff:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801506:	00 00 00 
  801509:	ff d0                	callq  *%rax
		return r;
  80150b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80150e:	eb 3a                	jmp    80154a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801514:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80151b:	00 00 00 
  80151e:	8b 12                	mov    (%rdx),%edx
  801520:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801526:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80152d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801531:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801534:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	48 89 c7             	mov    %rax,%rdi
  80153e:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  801545:	00 00 00 
  801548:	ff d0                	callq  *%rax
}
  80154a:	c9                   	leaveq 
  80154b:	c3                   	retq   

000000000080154c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	48 83 ec 30          	sub    $0x30,%rsp
  801554:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801557:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80155f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801562:	89 c7                	mov    %eax,%edi
  801564:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  80156b:	00 00 00 
  80156e:	ff d0                	callq  *%rax
  801570:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801573:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801577:	79 05                	jns    80157e <accept+0x32>
		return r;
  801579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80157c:	eb 3b                	jmp    8015b9 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80157e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801582:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801589:	48 89 ce             	mov    %rcx,%rsi
  80158c:	89 c7                	mov    %eax,%edi
  80158e:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  801595:	00 00 00 
  801598:	ff d0                	callq  *%rax
  80159a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80159d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015a1:	79 05                	jns    8015a8 <accept+0x5c>
		return r;
  8015a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015a6:	eb 11                	jmp    8015b9 <accept+0x6d>
	return alloc_sockfd(r);
  8015a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ab:	89 c7                	mov    %eax,%edi
  8015ad:	48 b8 ad 14 80 00 00 	movabs $0x8014ad,%rax
  8015b4:	00 00 00 
  8015b7:	ff d0                	callq  *%rax
}
  8015b9:	c9                   	leaveq 
  8015ba:	c3                   	retq   

00000000008015bb <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8015bb:	55                   	push   %rbp
  8015bc:	48 89 e5             	mov    %rsp,%rbp
  8015bf:	48 83 ec 20          	sub    $0x20,%rsp
  8015c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015ca:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8015cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015d0:	89 c7                	mov    %eax,%edi
  8015d2:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  8015d9:	00 00 00 
  8015dc:	ff d0                	callq  *%rax
  8015de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015e5:	79 05                	jns    8015ec <bind+0x31>
		return r;
  8015e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ea:	eb 1b                	jmp    801607 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8015ec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8015ef:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015f6:	48 89 ce             	mov    %rcx,%rsi
  8015f9:	89 c7                	mov    %eax,%edi
  8015fb:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  801602:	00 00 00 
  801605:	ff d0                	callq  *%rax
}
  801607:	c9                   	leaveq 
  801608:	c3                   	retq   

0000000000801609 <shutdown>:

int
shutdown(int s, int how)
{
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 83 ec 20          	sub    $0x20,%rsp
  801611:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801614:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801617:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80161a:	89 c7                	mov    %eax,%edi
  80161c:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  801623:	00 00 00 
  801626:	ff d0                	callq  *%rax
  801628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80162b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80162f:	79 05                	jns    801636 <shutdown+0x2d>
		return r;
  801631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801634:	eb 16                	jmp    80164c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801636:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80163c:	89 d6                	mov    %edx,%esi
  80163e:	89 c7                	mov    %eax,%edi
  801640:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  801647:	00 00 00 
  80164a:	ff d0                	callq  *%rax
}
  80164c:	c9                   	leaveq 
  80164d:	c3                   	retq   

000000000080164e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80164e:	55                   	push   %rbp
  80164f:	48 89 e5             	mov    %rsp,%rbp
  801652:	48 83 ec 10          	sub    $0x10,%rsp
  801656:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80165a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165e:	48 89 c7             	mov    %rax,%rdi
  801661:	48 b8 47 3c 80 00 00 	movabs $0x803c47,%rax
  801668:	00 00 00 
  80166b:	ff d0                	callq  *%rax
  80166d:	83 f8 01             	cmp    $0x1,%eax
  801670:	75 17                	jne    801689 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801676:	8b 40 0c             	mov    0xc(%rax),%eax
  801679:	89 c7                	mov    %eax,%edi
  80167b:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801682:	00 00 00 
  801685:	ff d0                	callq  *%rax
  801687:	eb 05                	jmp    80168e <devsock_close+0x40>
	else
		return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
  801694:	48 83 ec 20          	sub    $0x20,%rsp
  801698:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80169b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80169f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8016a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a5:	89 c7                	mov    %eax,%edi
  8016a7:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  8016ae:	00 00 00 
  8016b1:	ff d0                	callq  *%rax
  8016b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ba:	79 05                	jns    8016c1 <connect+0x31>
		return r;
  8016bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016bf:	eb 1b                	jmp    8016dc <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8016c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8016c4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8016c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016cb:	48 89 ce             	mov    %rcx,%rsi
  8016ce:	89 c7                	mov    %eax,%edi
  8016d0:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  8016d7:	00 00 00 
  8016da:	ff d0                	callq  *%rax
}
  8016dc:	c9                   	leaveq 
  8016dd:	c3                   	retq   

00000000008016de <listen>:

int
listen(int s, int backlog)
{
  8016de:	55                   	push   %rbp
  8016df:	48 89 e5             	mov    %rsp,%rbp
  8016e2:	48 83 ec 20          	sub    $0x20,%rsp
  8016e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8016e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8016ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ef:	89 c7                	mov    %eax,%edi
  8016f1:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  8016f8:	00 00 00 
  8016fb:	ff d0                	callq  *%rax
  8016fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801700:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801704:	79 05                	jns    80170b <listen+0x2d>
		return r;
  801706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801709:	eb 16                	jmp    801721 <listen+0x43>
	return nsipc_listen(r, backlog);
  80170b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80170e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801711:	89 d6                	mov    %edx,%esi
  801713:	89 c7                	mov    %eax,%edi
  801715:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  80171c:	00 00 00 
  80171f:	ff d0                	callq  *%rax
}
  801721:	c9                   	leaveq 
  801722:	c3                   	retq   

0000000000801723 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801723:	55                   	push   %rbp
  801724:	48 89 e5             	mov    %rsp,%rbp
  801727:	48 83 ec 20          	sub    $0x20,%rsp
  80172b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80172f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801733:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173b:	89 c2                	mov    %eax,%edx
  80173d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801741:	8b 40 0c             	mov    0xc(%rax),%eax
  801744:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801748:	b9 00 00 00 00       	mov    $0x0,%ecx
  80174d:	89 c7                	mov    %eax,%edi
  80174f:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
}
  80175b:	c9                   	leaveq 
  80175c:	c3                   	retq   

000000000080175d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80175d:	55                   	push   %rbp
  80175e:	48 89 e5             	mov    %rsp,%rbp
  801761:	48 83 ec 20          	sub    $0x20,%rsp
  801765:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801769:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80176d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801775:	89 c2                	mov    %eax,%edx
  801777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177b:	8b 40 0c             	mov    0xc(%rax),%eax
  80177e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801782:	b9 00 00 00 00       	mov    $0x0,%ecx
  801787:	89 c7                	mov    %eax,%edi
  801789:	48 b8 59 1b 80 00 00 	movabs $0x801b59,%rax
  801790:	00 00 00 
  801793:	ff d0                	callq  *%rax
}
  801795:	c9                   	leaveq 
  801796:	c3                   	retq   

0000000000801797 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801797:	55                   	push   %rbp
  801798:	48 89 e5             	mov    %rsp,%rbp
  80179b:	48 83 ec 10          	sub    $0x10,%rsp
  80179f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8017a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ab:	48 be 77 3e 80 00 00 	movabs $0x803e77,%rsi
  8017b2:	00 00 00 
  8017b5:	48 89 c7             	mov    %rax,%rdi
  8017b8:	48 b8 b1 32 80 00 00 	movabs $0x8032b1,%rax
  8017bf:	00 00 00 
  8017c2:	ff d0                	callq  *%rax
	return 0;
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c9:	c9                   	leaveq 
  8017ca:	c3                   	retq   

00000000008017cb <socket>:

int
socket(int domain, int type, int protocol)
{
  8017cb:	55                   	push   %rbp
  8017cc:	48 89 e5             	mov    %rsp,%rbp
  8017cf:	48 83 ec 20          	sub    $0x20,%rsp
  8017d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017d6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8017d9:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8017dc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8017df:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8017e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e5:	89 ce                	mov    %ecx,%esi
  8017e7:	89 c7                	mov    %eax,%edi
  8017e9:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
  8017f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017fc:	79 05                	jns    801803 <socket+0x38>
		return r;
  8017fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801801:	eb 11                	jmp    801814 <socket+0x49>
	return alloc_sockfd(r);
  801803:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801806:	89 c7                	mov    %eax,%edi
  801808:	48 b8 ad 14 80 00 00 	movabs $0x8014ad,%rax
  80180f:	00 00 00 
  801812:	ff d0                	callq  *%rax
}
  801814:	c9                   	leaveq 
  801815:	c3                   	retq   

0000000000801816 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801816:	55                   	push   %rbp
  801817:	48 89 e5             	mov    %rsp,%rbp
  80181a:	48 83 ec 10          	sub    $0x10,%rsp
  80181e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801821:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801828:	00 00 00 
  80182b:	8b 00                	mov    (%rax),%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	75 1f                	jne    801850 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801831:	bf 02 00 00 00       	mov    $0x2,%edi
  801836:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  80183d:	00 00 00 
  801840:	ff d0                	callq  *%rax
  801842:	89 c2                	mov    %eax,%edx
  801844:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80184b:	00 00 00 
  80184e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801850:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801857:	00 00 00 
  80185a:	8b 00                	mov    (%rax),%eax
  80185c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80185f:	b9 07 00 00 00       	mov    $0x7,%ecx
  801864:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80186b:	00 00 00 
  80186e:	89 c7                	mov    %eax,%edi
  801870:	48 b8 48 3a 80 00 00 	movabs $0x803a48,%rax
  801877:	00 00 00 
  80187a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80187c:	ba 00 00 00 00       	mov    $0x0,%edx
  801881:	be 00 00 00 00       	mov    $0x0,%esi
  801886:	bf 00 00 00 00       	mov    $0x0,%edi
  80188b:	48 b8 0a 3a 80 00 00 	movabs $0x803a0a,%rax
  801892:	00 00 00 
  801895:	ff d0                	callq  *%rax
}
  801897:	c9                   	leaveq 
  801898:	c3                   	retq   

0000000000801899 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801899:	55                   	push   %rbp
  80189a:	48 89 e5             	mov    %rsp,%rbp
  80189d:	48 83 ec 30          	sub    $0x30,%rsp
  8018a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8018a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8018ac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018b3:	00 00 00 
  8018b6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8018b9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018bb:	bf 01 00 00 00       	mov    $0x1,%edi
  8018c0:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8018c7:	00 00 00 
  8018ca:	ff d0                	callq  *%rax
  8018cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018d3:	78 3e                	js     801913 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8018d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8018dc:	00 00 00 
  8018df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e7:	8b 40 10             	mov    0x10(%rax),%eax
  8018ea:	89 c2                	mov    %eax,%edx
  8018ec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018f4:	48 89 ce             	mov    %rcx,%rsi
  8018f7:	48 89 c7             	mov    %rax,%rdi
  8018fa:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  801901:	00 00 00 
  801904:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190a:	8b 50 10             	mov    0x10(%rax),%edx
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801913:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801916:	c9                   	leaveq 
  801917:	c3                   	retq   

0000000000801918 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801918:	55                   	push   %rbp
  801919:	48 89 e5             	mov    %rsp,%rbp
  80191c:	48 83 ec 10          	sub    $0x10,%rsp
  801920:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801923:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801927:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80192a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801931:	00 00 00 
  801934:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801937:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801939:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80193c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801940:	48 89 c6             	mov    %rax,%rsi
  801943:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80194a:	00 00 00 
  80194d:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  801954:	00 00 00 
  801957:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801959:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801960:	00 00 00 
  801963:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801966:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801969:	bf 02 00 00 00       	mov    $0x2,%edi
  80196e:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801975:	00 00 00 
  801978:	ff d0                	callq  *%rax
}
  80197a:	c9                   	leaveq 
  80197b:	c3                   	retq   

000000000080197c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80197c:	55                   	push   %rbp
  80197d:	48 89 e5             	mov    %rsp,%rbp
  801980:	48 83 ec 10          	sub    $0x10,%rsp
  801984:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801987:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80198a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801991:	00 00 00 
  801994:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801997:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801999:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019a0:	00 00 00 
  8019a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8019a6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8019a9:	bf 03 00 00 00       	mov    $0x3,%edi
  8019ae:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	callq  *%rax
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <nsipc_close>:

int
nsipc_close(int s)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 10          	sub    $0x10,%rsp
  8019c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8019c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8019ce:	00 00 00 
  8019d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8019d4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8019d6:	bf 04 00 00 00       	mov    $0x4,%edi
  8019db:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8019e2:	00 00 00 
  8019e5:	ff d0                	callq  *%rax
}
  8019e7:	c9                   	leaveq 
  8019e8:	c3                   	retq   

00000000008019e9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019e9:	55                   	push   %rbp
  8019ea:	48 89 e5             	mov    %rsp,%rbp
  8019ed:	48 83 ec 10          	sub    $0x10,%rsp
  8019f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8019fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a02:	00 00 00 
  801a05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801a08:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a0a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a11:	48 89 c6             	mov    %rax,%rsi
  801a14:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801a1b:	00 00 00 
  801a1e:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  801a25:	00 00 00 
  801a28:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801a2a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a31:	00 00 00 
  801a34:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801a37:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801a3a:	bf 05 00 00 00       	mov    $0x5,%edi
  801a3f:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801a46:	00 00 00 
  801a49:	ff d0                	callq  *%rax
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 10          	sub    $0x10,%rsp
  801a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801a5b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a62:	00 00 00 
  801a65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801a68:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801a6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a71:	00 00 00 
  801a74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801a77:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801a7a:	bf 06 00 00 00       	mov    $0x6,%edi
  801a7f:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801a86:	00 00 00 
  801a89:	ff d0                	callq  *%rax
}
  801a8b:	c9                   	leaveq 
  801a8c:	c3                   	retq   

0000000000801a8d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a8d:	55                   	push   %rbp
  801a8e:	48 89 e5             	mov    %rsp,%rbp
  801a91:	48 83 ec 30          	sub    $0x30,%rsp
  801a95:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a9c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801a9f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801aa2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801aa9:	00 00 00 
  801aac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801aaf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801ab1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ab8:	00 00 00 
  801abb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801abe:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801ac1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ac8:	00 00 00 
  801acb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801ace:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ad1:	bf 07 00 00 00       	mov    $0x7,%edi
  801ad6:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801add:	00 00 00 
  801ae0:	ff d0                	callq  *%rax
  801ae2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ae5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ae9:	78 69                	js     801b54 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801aeb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801af2:	7f 08                	jg     801afc <nsipc_recv+0x6f>
  801af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801afa:	7e 35                	jle    801b31 <nsipc_recv+0xa4>
  801afc:	48 b9 7e 3e 80 00 00 	movabs $0x803e7e,%rcx
  801b03:	00 00 00 
  801b06:	48 ba 93 3e 80 00 00 	movabs $0x803e93,%rdx
  801b0d:	00 00 00 
  801b10:	be 61 00 00 00       	mov    $0x61,%esi
  801b15:	48 bf a8 3e 80 00 00 	movabs $0x803ea8,%rdi
  801b1c:	00 00 00 
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	49 b8 de 24 80 00 00 	movabs $0x8024de,%r8
  801b2b:	00 00 00 
  801b2e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b34:	48 63 d0             	movslq %eax,%rdx
  801b37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801b42:	00 00 00 
  801b45:	48 89 c7             	mov    %rax,%rdi
  801b48:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
	}

	return r;
  801b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b57:	c9                   	leaveq 
  801b58:	c3                   	retq   

0000000000801b59 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	48 83 ec 20          	sub    $0x20,%rsp
  801b61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b68:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b6b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801b6e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b75:	00 00 00 
  801b78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b7b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801b7d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801b84:	7e 35                	jle    801bbb <nsipc_send+0x62>
  801b86:	48 b9 b4 3e 80 00 00 	movabs $0x803eb4,%rcx
  801b8d:	00 00 00 
  801b90:	48 ba 93 3e 80 00 00 	movabs $0x803e93,%rdx
  801b97:	00 00 00 
  801b9a:	be 6c 00 00 00       	mov    $0x6c,%esi
  801b9f:	48 bf a8 3e 80 00 00 	movabs $0x803ea8,%rdi
  801ba6:	00 00 00 
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bae:	49 b8 de 24 80 00 00 	movabs $0x8024de,%r8
  801bb5:	00 00 00 
  801bb8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbe:	48 63 d0             	movslq %eax,%rdx
  801bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc5:	48 89 c6             	mov    %rax,%rsi
  801bc8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801bcf:	00 00 00 
  801bd2:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801bde:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801be5:	00 00 00 
  801be8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801beb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801bee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bf5:	00 00 00 
  801bf8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801bfb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801bfe:	bf 08 00 00 00       	mov    $0x8,%edi
  801c03:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 10          	sub    $0x10,%rsp
  801c19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801c1f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801c22:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c29:	00 00 00 
  801c2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c2f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801c31:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c38:	00 00 00 
  801c3b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c3e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801c41:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c48:	00 00 00 
  801c4b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c4e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801c51:	bf 09 00 00 00       	mov    $0x9,%edi
  801c56:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	callq  *%rax
}
  801c62:	c9                   	leaveq 
  801c63:	c3                   	retq   

0000000000801c64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c64:	55                   	push   %rbp
  801c65:	48 89 e5             	mov    %rsp,%rbp
  801c68:	53                   	push   %rbx
  801c69:	48 83 ec 38          	sub    $0x38,%rsp
  801c6d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c71:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801c75:	48 89 c7             	mov    %rax,%rdi
  801c78:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
  801c84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c8b:	0f 88 bf 01 00 00    	js     801e50 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c95:	ba 07 04 00 00       	mov    $0x407,%edx
  801c9a:	48 89 c6             	mov    %rax,%rsi
  801c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca2:	48 b8 ce 02 80 00 00 	movabs $0x8002ce,%rax
  801ca9:	00 00 00 
  801cac:	ff d0                	callq  *%rax
  801cae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cb5:	0f 88 95 01 00 00    	js     801e50 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cbb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801cbf:	48 89 c7             	mov    %rax,%rdi
  801cc2:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
  801cce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cd5:	0f 88 5d 01 00 00    	js     801e38 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cdb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cdf:	ba 07 04 00 00       	mov    $0x407,%edx
  801ce4:	48 89 c6             	mov    %rax,%rsi
  801ce7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cec:	48 b8 ce 02 80 00 00 	movabs $0x8002ce,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	callq  *%rax
  801cf8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cff:	0f 88 33 01 00 00    	js     801e38 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d09:	48 89 c7             	mov    %rax,%rdi
  801d0c:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	callq  *%rax
  801d18:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d20:	ba 07 04 00 00       	mov    $0x407,%edx
  801d25:	48 89 c6             	mov    %rax,%rsi
  801d28:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2d:	48 b8 ce 02 80 00 00 	movabs $0x8002ce,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	callq  *%rax
  801d39:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d40:	79 05                	jns    801d47 <pipe+0xe3>
		goto err2;
  801d42:	e9 d9 00 00 00       	jmpq   801e20 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d4b:	48 89 c7             	mov    %rax,%rdi
  801d4e:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	callq  *%rax
  801d5a:	48 89 c2             	mov    %rax,%rdx
  801d5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d61:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801d67:	48 89 d1             	mov    %rdx,%rcx
  801d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6f:	48 89 c6             	mov    %rax,%rsi
  801d72:	bf 00 00 00 00       	mov    $0x0,%edi
  801d77:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  801d7e:	00 00 00 
  801d81:	ff d0                	callq  *%rax
  801d83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d8a:	79 1b                	jns    801da7 <pipe+0x143>
		goto err3;
  801d8c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801d8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d91:	48 89 c6             	mov    %rax,%rsi
  801d94:	bf 00 00 00 00       	mov    $0x0,%edi
  801d99:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  801da0:	00 00 00 
  801da3:	ff d0                	callq  *%rax
  801da5:	eb 79                	jmp    801e20 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  801da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dab:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801db2:	00 00 00 
  801db5:	8b 12                	mov    (%rdx),%edx
  801db7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801db9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dc4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801dcf:	00 00 00 
  801dd2:	8b 12                	mov    (%rdx),%edx
  801dd4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801dd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  801de1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de5:	48 89 c7             	mov    %rax,%rdi
  801de8:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	89 c2                	mov    %eax,%edx
  801df6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dfa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801dfc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e00:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801e04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e08:	48 89 c7             	mov    %rax,%rdi
  801e0b:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  801e12:	00 00 00 
  801e15:	ff d0                	callq  *%rax
  801e17:	89 03                	mov    %eax,(%rbx)
	return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1e:	eb 33                	jmp    801e53 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  801e20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e24:	48 89 c6             	mov    %rax,%rsi
  801e27:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2c:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801e38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3c:	48 89 c6             	mov    %rax,%rsi
  801e3f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e44:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
err:
	return r;
  801e50:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801e53:	48 83 c4 38          	add    $0x38,%rsp
  801e57:	5b                   	pop    %rbx
  801e58:	5d                   	pop    %rbp
  801e59:	c3                   	retq   

0000000000801e5a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
  801e5e:	53                   	push   %rbx
  801e5f:	48 83 ec 28          	sub    $0x28,%rsp
  801e63:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e6b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801e72:	00 00 00 
  801e75:	48 8b 00             	mov    (%rax),%rax
  801e78:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801e7e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801e81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e85:	48 89 c7             	mov    %rax,%rdi
  801e88:	48 b8 47 3c 80 00 00 	movabs $0x803c47,%rax
  801e8f:	00 00 00 
  801e92:	ff d0                	callq  *%rax
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e9a:	48 89 c7             	mov    %rax,%rdi
  801e9d:	48 b8 47 3c 80 00 00 	movabs $0x803c47,%rax
  801ea4:	00 00 00 
  801ea7:	ff d0                	callq  *%rax
  801ea9:	39 c3                	cmp    %eax,%ebx
  801eab:	0f 94 c0             	sete   %al
  801eae:	0f b6 c0             	movzbl %al,%eax
  801eb1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801eb4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ebb:	00 00 00 
  801ebe:	48 8b 00             	mov    (%rax),%rax
  801ec1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801ec7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801eca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ecd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801ed0:	75 05                	jne    801ed7 <_pipeisclosed+0x7d>
			return ret;
  801ed2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ed5:	eb 4a                	jmp    801f21 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  801ed7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eda:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801edd:	74 3d                	je     801f1c <_pipeisclosed+0xc2>
  801edf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801ee3:	75 37                	jne    801f1c <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ee5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801eec:	00 00 00 
  801eef:	48 8b 00             	mov    (%rax),%rax
  801ef2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801ef8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801efb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801efe:	89 c6                	mov    %eax,%esi
  801f00:	48 bf c5 3e 80 00 00 	movabs $0x803ec5,%rdi
  801f07:	00 00 00 
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0f:	49 b8 17 27 80 00 00 	movabs $0x802717,%r8
  801f16:	00 00 00 
  801f19:	41 ff d0             	callq  *%r8
	}
  801f1c:	e9 4a ff ff ff       	jmpq   801e6b <_pipeisclosed+0x11>
}
  801f21:	48 83 c4 28          	add    $0x28,%rsp
  801f25:	5b                   	pop    %rbx
  801f26:	5d                   	pop    %rbp
  801f27:	c3                   	retq   

0000000000801f28 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	48 83 ec 30          	sub    $0x30,%rsp
  801f30:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f33:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f3a:	48 89 d6             	mov    %rdx,%rsi
  801f3d:	89 c7                	mov    %eax,%edi
  801f3f:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  801f46:	00 00 00 
  801f49:	ff d0                	callq  *%rax
  801f4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f52:	79 05                	jns    801f59 <pipeisclosed+0x31>
		return r;
  801f54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f57:	eb 31                	jmp    801f8a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f5d:	48 89 c7             	mov    %rax,%rdi
  801f60:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  801f67:	00 00 00 
  801f6a:	ff d0                	callq  *%rax
  801f6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801f70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f78:	48 89 d6             	mov    %rdx,%rsi
  801f7b:	48 89 c7             	mov    %rax,%rdi
  801f7e:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	callq  *%rax
}
  801f8a:	c9                   	leaveq 
  801f8b:	c3                   	retq   

0000000000801f8c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f8c:	55                   	push   %rbp
  801f8d:	48 89 e5             	mov    %rsp,%rbp
  801f90:	48 83 ec 40          	sub    $0x40,%rsp
  801f94:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f98:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f9c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa4:	48 89 c7             	mov    %rax,%rdi
  801fa7:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
  801fb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801fb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801fbf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801fc6:	00 
  801fc7:	e9 92 00 00 00       	jmpq   80205e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801fcc:	eb 41                	jmp    80200f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fce:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801fd3:	74 09                	je     801fde <devpipe_read+0x52>
				return i;
  801fd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd9:	e9 92 00 00 00       	jmpq   802070 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fde:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe6:	48 89 d6             	mov    %rdx,%rsi
  801fe9:	48 89 c7             	mov    %rax,%rdi
  801fec:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 07                	je     802003 <devpipe_read+0x77>
				return 0;
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	eb 6d                	jmp    802070 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802003:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80200f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802013:	8b 10                	mov    (%rax),%edx
  802015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802019:	8b 40 04             	mov    0x4(%rax),%eax
  80201c:	39 c2                	cmp    %eax,%edx
  80201e:	74 ae                	je     801fce <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802020:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802028:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80202c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802030:	8b 00                	mov    (%rax),%eax
  802032:	99                   	cltd   
  802033:	c1 ea 1b             	shr    $0x1b,%edx
  802036:	01 d0                	add    %edx,%eax
  802038:	83 e0 1f             	and    $0x1f,%eax
  80203b:	29 d0                	sub    %edx,%eax
  80203d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802041:	48 98                	cltq   
  802043:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802048:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80204a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204e:	8b 00                	mov    (%rax),%eax
  802050:	8d 50 01             	lea    0x1(%rax),%edx
  802053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802057:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  802059:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80205e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802062:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802066:	0f 82 60 ff ff ff    	jb     801fcc <devpipe_read+0x40>
	}
	return i;
  80206c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802070:	c9                   	leaveq 
  802071:	c3                   	retq   

0000000000802072 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802072:	55                   	push   %rbp
  802073:	48 89 e5             	mov    %rsp,%rbp
  802076:	48 83 ec 40          	sub    $0x40,%rsp
  80207a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80207e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802082:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802086:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208a:	48 89 c7             	mov    %rax,%rdi
  80208d:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  802094:	00 00 00 
  802097:	ff d0                	callq  *%rax
  802099:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80209d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8020a5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8020ac:	00 
  8020ad:	e9 91 00 00 00       	jmpq   802143 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020b2:	eb 31                	jmp    8020e5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bc:	48 89 d6             	mov    %rdx,%rsi
  8020bf:	48 89 c7             	mov    %rax,%rdi
  8020c2:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 07                	je     8020d9 <devpipe_write+0x67>
				return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	eb 7c                	jmp    802155 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8020d9:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  8020e0:	00 00 00 
  8020e3:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e9:	8b 40 04             	mov    0x4(%rax),%eax
  8020ec:	48 63 d0             	movslq %eax,%rdx
  8020ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f3:	8b 00                	mov    (%rax),%eax
  8020f5:	48 98                	cltq   
  8020f7:	48 83 c0 20          	add    $0x20,%rax
  8020fb:	48 39 c2             	cmp    %rax,%rdx
  8020fe:	73 b4                	jae    8020b4 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802100:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802104:	8b 40 04             	mov    0x4(%rax),%eax
  802107:	99                   	cltd   
  802108:	c1 ea 1b             	shr    $0x1b,%edx
  80210b:	01 d0                	add    %edx,%eax
  80210d:	83 e0 1f             	and    $0x1f,%eax
  802110:	29 d0                	sub    %edx,%eax
  802112:	89 c6                	mov    %eax,%esi
  802114:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211c:	48 01 d0             	add    %rdx,%rax
  80211f:	0f b6 08             	movzbl (%rax),%ecx
  802122:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802126:	48 63 c6             	movslq %esi,%rax
  802129:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80212d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802131:	8b 40 04             	mov    0x4(%rax),%eax
  802134:	8d 50 01             	lea    0x1(%rax),%edx
  802137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213b:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80213e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802143:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802147:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80214b:	0f 82 61 ff ff ff    	jb     8020b2 <devpipe_write+0x40>
	}

	return i;
  802151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802155:	c9                   	leaveq 
  802156:	c3                   	retq   

0000000000802157 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802157:	55                   	push   %rbp
  802158:	48 89 e5             	mov    %rsp,%rbp
  80215b:	48 83 ec 20          	sub    $0x20,%rsp
  80215f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802163:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216b:	48 89 c7             	mov    %rax,%rdi
  80216e:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80217e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802182:	48 be d8 3e 80 00 00 	movabs $0x803ed8,%rsi
  802189:	00 00 00 
  80218c:	48 89 c7             	mov    %rax,%rdi
  80218f:	48 b8 b1 32 80 00 00 	movabs $0x8032b1,%rax
  802196:	00 00 00 
  802199:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80219b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219f:	8b 50 04             	mov    0x4(%rax),%edx
  8021a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a6:	8b 00                	mov    (%rax),%eax
  8021a8:	29 c2                	sub    %eax,%edx
  8021aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ae:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8021b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8021bf:	00 00 00 
	stat->st_dev = &devpipe;
  8021c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021c6:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8021cd:	00 00 00 
  8021d0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021dc:	c9                   	leaveq 
  8021dd:	c3                   	retq   

00000000008021de <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021de:	55                   	push   %rbp
  8021df:	48 89 e5             	mov    %rsp,%rbp
  8021e2:	48 83 ec 10          	sub    $0x10,%rsp
  8021e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8021ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ee:	48 89 c6             	mov    %rax,%rsi
  8021f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f6:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802206:	48 89 c7             	mov    %rax,%rdi
  802209:	48 b8 59 06 80 00 00 	movabs $0x800659,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
  802215:	48 89 c6             	mov    %rax,%rsi
  802218:	bf 00 00 00 00       	mov    $0x0,%edi
  80221d:	48 b8 80 03 80 00 00 	movabs $0x800380,%rax
  802224:	00 00 00 
  802227:	ff d0                	callq  *%rax
}
  802229:	c9                   	leaveq 
  80222a:	c3                   	retq   

000000000080222b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80222b:	55                   	push   %rbp
  80222c:	48 89 e5             	mov    %rsp,%rbp
  80222f:	48 83 ec 20          	sub    $0x20,%rsp
  802233:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802239:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80223c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802240:	be 01 00 00 00       	mov    $0x1,%esi
  802245:	48 89 c7             	mov    %rax,%rdi
  802248:	48 b8 88 01 80 00 00 	movabs $0x800188,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
}
  802254:	c9                   	leaveq 
  802255:	c3                   	retq   

0000000000802256 <getchar>:

int
getchar(void)
{
  802256:	55                   	push   %rbp
  802257:	48 89 e5             	mov    %rsp,%rbp
  80225a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80225e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802262:	ba 01 00 00 00       	mov    $0x1,%edx
  802267:	48 89 c6             	mov    %rax,%rsi
  80226a:	bf 00 00 00 00       	mov    $0x0,%edi
  80226f:	48 b8 50 0b 80 00 00 	movabs $0x800b50,%rax
  802276:	00 00 00 
  802279:	ff d0                	callq  *%rax
  80227b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80227e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802282:	79 05                	jns    802289 <getchar+0x33>
		return r;
  802284:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802287:	eb 14                	jmp    80229d <getchar+0x47>
	if (r < 1)
  802289:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228d:	7f 07                	jg     802296 <getchar+0x40>
		return -E_EOF;
  80228f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802294:	eb 07                	jmp    80229d <getchar+0x47>
	return c;
  802296:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80229a:	0f b6 c0             	movzbl %al,%eax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	48 83 ec 20          	sub    $0x20,%rsp
  8022a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022b1:	48 89 d6             	mov    %rdx,%rsi
  8022b4:	89 c7                	mov    %eax,%edi
  8022b6:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	callq  *%rax
  8022c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c9:	79 05                	jns    8022d0 <iscons+0x31>
		return r;
  8022cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ce:	eb 1a                	jmp    8022ea <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8022d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d4:	8b 10                	mov    (%rax),%edx
  8022d6:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8022dd:	00 00 00 
  8022e0:	8b 00                	mov    (%rax),%eax
  8022e2:	39 c2                	cmp    %eax,%edx
  8022e4:	0f 94 c0             	sete   %al
  8022e7:	0f b6 c0             	movzbl %al,%eax
}
  8022ea:	c9                   	leaveq 
  8022eb:	c3                   	retq   

00000000008022ec <opencons>:

int
opencons(void)
{
  8022ec:	55                   	push   %rbp
  8022ed:	48 89 e5             	mov    %rsp,%rbp
  8022f0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022f4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8022f8:	48 89 c7             	mov    %rax,%rdi
  8022fb:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  802302:	00 00 00 
  802305:	ff d0                	callq  *%rax
  802307:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80230e:	79 05                	jns    802315 <opencons+0x29>
		return r;
  802310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802313:	eb 5b                	jmp    802370 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802319:	ba 07 04 00 00       	mov    $0x407,%edx
  80231e:	48 89 c6             	mov    %rax,%rsi
  802321:	bf 00 00 00 00       	mov    $0x0,%edi
  802326:	48 b8 ce 02 80 00 00 	movabs $0x8002ce,%rax
  80232d:	00 00 00 
  802330:	ff d0                	callq  *%rax
  802332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802339:	79 05                	jns    802340 <opencons+0x54>
		return r;
  80233b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233e:	eb 30                	jmp    802370 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802344:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80234b:	00 00 00 
  80234e:	8b 12                	mov    (%rdx),%edx
  802350:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802356:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80235d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802361:	48 89 c7             	mov    %rax,%rdi
  802364:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  80236b:	00 00 00 
  80236e:	ff d0                	callq  *%rax
}
  802370:	c9                   	leaveq 
  802371:	c3                   	retq   

0000000000802372 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802372:	55                   	push   %rbp
  802373:	48 89 e5             	mov    %rsp,%rbp
  802376:	48 83 ec 30          	sub    $0x30,%rsp
  80237a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80237e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802382:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802386:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80238b:	75 07                	jne    802394 <devcons_read+0x22>
		return 0;
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
  802392:	eb 4b                	jmp    8023df <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802394:	eb 0c                	jmp    8023a2 <devcons_read+0x30>
		sys_yield();
  802396:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8023a2:	48 b8 d4 01 80 00 00 	movabs $0x8001d4,%rax
  8023a9:	00 00 00 
  8023ac:	ff d0                	callq  *%rax
  8023ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b5:	74 df                	je     802396 <devcons_read+0x24>
	if (c < 0)
  8023b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bb:	79 05                	jns    8023c2 <devcons_read+0x50>
		return c;
  8023bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c0:	eb 1d                	jmp    8023df <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8023c2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8023c6:	75 07                	jne    8023cf <devcons_read+0x5d>
		return 0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cd:	eb 10                	jmp    8023df <devcons_read+0x6d>
	*(char*)vbuf = c;
  8023cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d2:	89 c2                	mov    %eax,%edx
  8023d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023d8:	88 10                	mov    %dl,(%rax)
	return 1;
  8023da:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023df:	c9                   	leaveq 
  8023e0:	c3                   	retq   

00000000008023e1 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023e1:	55                   	push   %rbp
  8023e2:	48 89 e5             	mov    %rsp,%rbp
  8023e5:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8023ec:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8023f3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8023fa:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802408:	eb 76                	jmp    802480 <devcons_write+0x9f>
		m = n - tot;
  80240a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802411:	89 c2                	mov    %eax,%edx
  802413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802416:	29 c2                	sub    %eax,%edx
  802418:	89 d0                	mov    %edx,%eax
  80241a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80241d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802420:	83 f8 7f             	cmp    $0x7f,%eax
  802423:	76 07                	jbe    80242c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802425:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80242c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242f:	48 63 d0             	movslq %eax,%rdx
  802432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802435:	48 63 c8             	movslq %eax,%rcx
  802438:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80243f:	48 01 c1             	add    %rax,%rcx
  802442:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802449:	48 89 ce             	mov    %rcx,%rsi
  80244c:	48 89 c7             	mov    %rax,%rdi
  80244f:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  802456:	00 00 00 
  802459:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80245b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245e:	48 63 d0             	movslq %eax,%rdx
  802461:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802468:	48 89 d6             	mov    %rdx,%rsi
  80246b:	48 89 c7             	mov    %rax,%rdi
  80246e:	48 b8 88 01 80 00 00 	movabs $0x800188,%rax
  802475:	00 00 00 
  802478:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  80247a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80247d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	48 98                	cltq   
  802485:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80248c:	0f 82 78 ff ff ff    	jb     80240a <devcons_write+0x29>
	}
	return tot;
  802492:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802495:	c9                   	leaveq 
  802496:	c3                   	retq   

0000000000802497 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802497:	55                   	push   %rbp
  802498:	48 89 e5             	mov    %rsp,%rbp
  80249b:	48 83 ec 08          	sub    $0x8,%rsp
  80249f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a8:	c9                   	leaveq 
  8024a9:	c3                   	retq   

00000000008024aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024aa:	55                   	push   %rbp
  8024ab:	48 89 e5             	mov    %rsp,%rbp
  8024ae:	48 83 ec 10          	sub    $0x10,%rsp
  8024b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	48 be e4 3e 80 00 00 	movabs $0x803ee4,%rsi
  8024c5:	00 00 00 
  8024c8:	48 89 c7             	mov    %rax,%rdi
  8024cb:	48 b8 b1 32 80 00 00 	movabs $0x8032b1,%rax
  8024d2:	00 00 00 
  8024d5:	ff d0                	callq  *%rax
	return 0;
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dc:	c9                   	leaveq 
  8024dd:	c3                   	retq   

00000000008024de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024de:	55                   	push   %rbp
  8024df:	48 89 e5             	mov    %rsp,%rbp
  8024e2:	53                   	push   %rbx
  8024e3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8024ea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8024f1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8024f7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8024fe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802505:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80250c:	84 c0                	test   %al,%al
  80250e:	74 23                	je     802533 <_panic+0x55>
  802510:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802517:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80251b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80251f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802523:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802527:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80252b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80252f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802533:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80253a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802541:	00 00 00 
  802544:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80254b:	00 00 00 
  80254e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802552:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802559:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802560:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802567:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80256e:	00 00 00 
  802571:	48 8b 18             	mov    (%rax),%rbx
  802574:	48 b8 56 02 80 00 00 	movabs $0x800256,%rax
  80257b:	00 00 00 
  80257e:	ff d0                	callq  *%rax
  802580:	89 c6                	mov    %eax,%esi
  802582:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  802588:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80258f:	41 89 d0             	mov    %edx,%r8d
  802592:	48 89 c1             	mov    %rax,%rcx
  802595:	48 89 da             	mov    %rbx,%rdx
  802598:	48 bf f0 3e 80 00 00 	movabs $0x803ef0,%rdi
  80259f:	00 00 00 
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a7:	49 b9 17 27 80 00 00 	movabs $0x802717,%r9
  8025ae:	00 00 00 
  8025b1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025b4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8025bb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8025c2:	48 89 d6             	mov    %rdx,%rsi
  8025c5:	48 89 c7             	mov    %rax,%rdi
  8025c8:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
	cprintf("\n");
  8025d4:	48 bf 13 3f 80 00 00 	movabs $0x803f13,%rdi
  8025db:	00 00 00 
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e3:	48 ba 17 27 80 00 00 	movabs $0x802717,%rdx
  8025ea:	00 00 00 
  8025ed:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025ef:	cc                   	int3   
  8025f0:	eb fd                	jmp    8025ef <_panic+0x111>

00000000008025f2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8025f2:	55                   	push   %rbp
  8025f3:	48 89 e5             	mov    %rsp,%rbp
  8025f6:	48 83 ec 10          	sub    $0x10,%rsp
  8025fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802605:	8b 00                	mov    (%rax),%eax
  802607:	8d 48 01             	lea    0x1(%rax),%ecx
  80260a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80260e:	89 0a                	mov    %ecx,(%rdx)
  802610:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802613:	89 d1                	mov    %edx,%ecx
  802615:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802619:	48 98                	cltq   
  80261b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80261f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802623:	8b 00                	mov    (%rax),%eax
  802625:	3d ff 00 00 00       	cmp    $0xff,%eax
  80262a:	75 2c                	jne    802658 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80262c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802630:	8b 00                	mov    (%rax),%eax
  802632:	48 98                	cltq   
  802634:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802638:	48 83 c2 08          	add    $0x8,%rdx
  80263c:	48 89 c6             	mov    %rax,%rsi
  80263f:	48 89 d7             	mov    %rdx,%rdi
  802642:	48 b8 88 01 80 00 00 	movabs $0x800188,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
        b->idx = 0;
  80264e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802652:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265c:	8b 40 04             	mov    0x4(%rax),%eax
  80265f:	8d 50 01             	lea    0x1(%rax),%edx
  802662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802666:	89 50 04             	mov    %edx,0x4(%rax)
}
  802669:	c9                   	leaveq 
  80266a:	c3                   	retq   

000000000080266b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80266b:	55                   	push   %rbp
  80266c:	48 89 e5             	mov    %rsp,%rbp
  80266f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802676:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80267d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802684:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80268b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802692:	48 8b 0a             	mov    (%rdx),%rcx
  802695:	48 89 08             	mov    %rcx,(%rax)
  802698:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80269c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8026a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8026a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8026a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8026af:	00 00 00 
    b.cnt = 0;
  8026b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8026b9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8026bc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8026c3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8026ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8026d1:	48 89 c6             	mov    %rax,%rsi
  8026d4:	48 bf f2 25 80 00 00 	movabs $0x8025f2,%rdi
  8026db:	00 00 00 
  8026de:	48 b8 b6 2a 80 00 00 	movabs $0x802ab6,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8026ea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8026f0:	48 98                	cltq   
  8026f2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8026f9:	48 83 c2 08          	add    $0x8,%rdx
  8026fd:	48 89 c6             	mov    %rax,%rsi
  802700:	48 89 d7             	mov    %rdx,%rdi
  802703:	48 b8 88 01 80 00 00 	movabs $0x800188,%rax
  80270a:	00 00 00 
  80270d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80270f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802715:	c9                   	leaveq 
  802716:	c3                   	retq   

0000000000802717 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802717:	55                   	push   %rbp
  802718:	48 89 e5             	mov    %rsp,%rbp
  80271b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802722:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802729:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802730:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802737:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80273e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802745:	84 c0                	test   %al,%al
  802747:	74 20                	je     802769 <cprintf+0x52>
  802749:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80274d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802751:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802755:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802759:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80275d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802761:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802765:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802769:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802770:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802777:	00 00 00 
  80277a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802781:	00 00 00 
  802784:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802788:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80278f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802796:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80279d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8027a4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8027ab:	48 8b 0a             	mov    (%rdx),%rcx
  8027ae:	48 89 08             	mov    %rcx,(%rax)
  8027b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8027b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8027b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8027bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8027c1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8027c8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027cf:	48 89 d6             	mov    %rdx,%rsi
  8027d2:	48 89 c7             	mov    %rax,%rdi
  8027d5:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8027e7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8027ed:	c9                   	leaveq 
  8027ee:	c3                   	retq   

00000000008027ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8027ef:	55                   	push   %rbp
  8027f0:	48 89 e5             	mov    %rsp,%rbp
  8027f3:	48 83 ec 30          	sub    $0x30,%rsp
  8027f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802803:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  802806:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80280a:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80280e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802811:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  802815:	77 42                	ja     802859 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802817:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80281a:	8d 78 ff             	lea    -0x1(%rax),%edi
  80281d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  802820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802824:	ba 00 00 00 00       	mov    $0x0,%edx
  802829:	48 f7 f6             	div    %rsi
  80282c:	49 89 c2             	mov    %rax,%r10
  80282f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802832:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802835:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80283d:	41 89 c9             	mov    %ecx,%r9d
  802840:	41 89 f8             	mov    %edi,%r8d
  802843:	89 d1                	mov    %edx,%ecx
  802845:	4c 89 d2             	mov    %r10,%rdx
  802848:	48 89 c7             	mov    %rax,%rdi
  80284b:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802852:	00 00 00 
  802855:	ff d0                	callq  *%rax
  802857:	eb 1e                	jmp    802877 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802859:	eb 12                	jmp    80286d <printnum+0x7e>
			putch(padc, putdat);
  80285b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80285f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802866:	48 89 ce             	mov    %rcx,%rsi
  802869:	89 d7                	mov    %edx,%edi
  80286b:	ff d0                	callq  *%rax
		while (--width > 0)
  80286d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  802871:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  802875:	7f e4                	jg     80285b <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802877:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80287a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287e:	ba 00 00 00 00       	mov    $0x0,%edx
  802883:	48 f7 f1             	div    %rcx
  802886:	48 b8 30 41 80 00 00 	movabs $0x804130,%rax
  80288d:	00 00 00 
  802890:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  802894:	0f be d0             	movsbl %al,%edx
  802897:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80289b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80289f:	48 89 ce             	mov    %rcx,%rsi
  8028a2:	89 d7                	mov    %edx,%edi
  8028a4:	ff d0                	callq  *%rax
}
  8028a6:	c9                   	leaveq 
  8028a7:	c3                   	retq   

00000000008028a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8028a8:	55                   	push   %rbp
  8028a9:	48 89 e5             	mov    %rsp,%rbp
  8028ac:	48 83 ec 20          	sub    $0x20,%rsp
  8028b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8028b7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8028bb:	7e 4f                	jle    80290c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	8b 00                	mov    (%rax),%eax
  8028c3:	83 f8 30             	cmp    $0x30,%eax
  8028c6:	73 24                	jae    8028ec <getuint+0x44>
  8028c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d4:	8b 00                	mov    (%rax),%eax
  8028d6:	89 c0                	mov    %eax,%eax
  8028d8:	48 01 d0             	add    %rdx,%rax
  8028db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028df:	8b 12                	mov    (%rdx),%edx
  8028e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028e8:	89 0a                	mov    %ecx,(%rdx)
  8028ea:	eb 14                	jmp    802900 <getuint+0x58>
  8028ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8028f4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8028f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802900:	48 8b 00             	mov    (%rax),%rax
  802903:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802907:	e9 9d 00 00 00       	jmpq   8029a9 <getuint+0x101>
	else if (lflag)
  80290c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802910:	74 4c                	je     80295e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  802912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802916:	8b 00                	mov    (%rax),%eax
  802918:	83 f8 30             	cmp    $0x30,%eax
  80291b:	73 24                	jae    802941 <getuint+0x99>
  80291d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802921:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802929:	8b 00                	mov    (%rax),%eax
  80292b:	89 c0                	mov    %eax,%eax
  80292d:	48 01 d0             	add    %rdx,%rax
  802930:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802934:	8b 12                	mov    (%rdx),%edx
  802936:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80293d:	89 0a                	mov    %ecx,(%rdx)
  80293f:	eb 14                	jmp    802955 <getuint+0xad>
  802941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802945:	48 8b 40 08          	mov    0x8(%rax),%rax
  802949:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80294d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802951:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802955:	48 8b 00             	mov    (%rax),%rax
  802958:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80295c:	eb 4b                	jmp    8029a9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80295e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802962:	8b 00                	mov    (%rax),%eax
  802964:	83 f8 30             	cmp    $0x30,%eax
  802967:	73 24                	jae    80298d <getuint+0xe5>
  802969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802975:	8b 00                	mov    (%rax),%eax
  802977:	89 c0                	mov    %eax,%eax
  802979:	48 01 d0             	add    %rdx,%rax
  80297c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802980:	8b 12                	mov    (%rdx),%edx
  802982:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802985:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802989:	89 0a                	mov    %ecx,(%rdx)
  80298b:	eb 14                	jmp    8029a1 <getuint+0xf9>
  80298d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802991:	48 8b 40 08          	mov    0x8(%rax),%rax
  802995:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802999:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80299d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8029a1:	8b 00                	mov    (%rax),%eax
  8029a3:	89 c0                	mov    %eax,%eax
  8029a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8029a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8029ad:	c9                   	leaveq 
  8029ae:	c3                   	retq   

00000000008029af <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8029af:	55                   	push   %rbp
  8029b0:	48 89 e5             	mov    %rsp,%rbp
  8029b3:	48 83 ec 20          	sub    $0x20,%rsp
  8029b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029bb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8029be:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8029c2:	7e 4f                	jle    802a13 <getint+0x64>
		x=va_arg(*ap, long long);
  8029c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c8:	8b 00                	mov    (%rax),%eax
  8029ca:	83 f8 30             	cmp    $0x30,%eax
  8029cd:	73 24                	jae    8029f3 <getint+0x44>
  8029cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8029d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029db:	8b 00                	mov    (%rax),%eax
  8029dd:	89 c0                	mov    %eax,%eax
  8029df:	48 01 d0             	add    %rdx,%rax
  8029e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029e6:	8b 12                	mov    (%rdx),%edx
  8029e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ef:	89 0a                	mov    %ecx,(%rdx)
  8029f1:	eb 14                	jmp    802a07 <getint+0x58>
  8029f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8029fb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8029ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a03:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a07:	48 8b 00             	mov    (%rax),%rax
  802a0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a0e:	e9 9d 00 00 00       	jmpq   802ab0 <getint+0x101>
	else if (lflag)
  802a13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802a17:	74 4c                	je     802a65 <getint+0xb6>
		x=va_arg(*ap, long);
  802a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1d:	8b 00                	mov    (%rax),%eax
  802a1f:	83 f8 30             	cmp    $0x30,%eax
  802a22:	73 24                	jae    802a48 <getint+0x99>
  802a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a28:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a30:	8b 00                	mov    (%rax),%eax
  802a32:	89 c0                	mov    %eax,%eax
  802a34:	48 01 d0             	add    %rdx,%rax
  802a37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a3b:	8b 12                	mov    (%rdx),%edx
  802a3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a44:	89 0a                	mov    %ecx,(%rdx)
  802a46:	eb 14                	jmp    802a5c <getint+0xad>
  802a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a50:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802a54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a58:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a5c:	48 8b 00             	mov    (%rax),%rax
  802a5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a63:	eb 4b                	jmp    802ab0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  802a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a69:	8b 00                	mov    (%rax),%eax
  802a6b:	83 f8 30             	cmp    $0x30,%eax
  802a6e:	73 24                	jae    802a94 <getint+0xe5>
  802a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a74:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7c:	8b 00                	mov    (%rax),%eax
  802a7e:	89 c0                	mov    %eax,%eax
  802a80:	48 01 d0             	add    %rdx,%rax
  802a83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a87:	8b 12                	mov    (%rdx),%edx
  802a89:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a90:	89 0a                	mov    %ecx,(%rdx)
  802a92:	eb 14                	jmp    802aa8 <getint+0xf9>
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a9c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aa4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802aa8:	8b 00                	mov    (%rax),%eax
  802aaa:	48 98                	cltq   
  802aac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ab4:	c9                   	leaveq 
  802ab5:	c3                   	retq   

0000000000802ab6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802ab6:	55                   	push   %rbp
  802ab7:	48 89 e5             	mov    %rsp,%rbp
  802aba:	41 54                	push   %r12
  802abc:	53                   	push   %rbx
  802abd:	48 83 ec 60          	sub    $0x60,%rsp
  802ac1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802ac5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802ac9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802acd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802ad1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802ad5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802ad9:	48 8b 0a             	mov    (%rdx),%rcx
  802adc:	48 89 08             	mov    %rcx,(%rax)
  802adf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802ae3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ae7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802aeb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802aef:	eb 17                	jmp    802b08 <vprintfmt+0x52>
			if (ch == '\0')
  802af1:	85 db                	test   %ebx,%ebx
  802af3:	0f 84 c5 04 00 00    	je     802fbe <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  802af9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802afd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802b01:	48 89 d6             	mov    %rdx,%rsi
  802b04:	89 df                	mov    %ebx,%edi
  802b06:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802b08:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802b0c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b10:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802b14:	0f b6 00             	movzbl (%rax),%eax
  802b17:	0f b6 d8             	movzbl %al,%ebx
  802b1a:	83 fb 25             	cmp    $0x25,%ebx
  802b1d:	75 d2                	jne    802af1 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  802b1f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802b23:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802b2a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802b31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802b38:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802b3f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802b43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802b4b:	0f b6 00             	movzbl (%rax),%eax
  802b4e:	0f b6 d8             	movzbl %al,%ebx
  802b51:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802b54:	83 f8 55             	cmp    $0x55,%eax
  802b57:	0f 87 2e 04 00 00    	ja     802f8b <vprintfmt+0x4d5>
  802b5d:	89 c0                	mov    %eax,%eax
  802b5f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802b66:	00 
  802b67:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  802b6e:	00 00 00 
  802b71:	48 01 d0             	add    %rdx,%rax
  802b74:	48 8b 00             	mov    (%rax),%rax
  802b77:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802b79:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802b7d:	eb c0                	jmp    802b3f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802b7f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802b83:	eb ba                	jmp    802b3f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802b85:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802b8c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802b8f:	89 d0                	mov    %edx,%eax
  802b91:	c1 e0 02             	shl    $0x2,%eax
  802b94:	01 d0                	add    %edx,%eax
  802b96:	01 c0                	add    %eax,%eax
  802b98:	01 d8                	add    %ebx,%eax
  802b9a:	83 e8 30             	sub    $0x30,%eax
  802b9d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802ba0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802ba4:	0f b6 00             	movzbl (%rax),%eax
  802ba7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802baa:	83 fb 2f             	cmp    $0x2f,%ebx
  802bad:	7e 0c                	jle    802bbb <vprintfmt+0x105>
  802baf:	83 fb 39             	cmp    $0x39,%ebx
  802bb2:	7f 07                	jg     802bbb <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  802bb4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  802bb9:	eb d1                	jmp    802b8c <vprintfmt+0xd6>
			goto process_precision;
  802bbb:	eb 50                	jmp    802c0d <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  802bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bc0:	83 f8 30             	cmp    $0x30,%eax
  802bc3:	73 17                	jae    802bdc <vprintfmt+0x126>
  802bc5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802bcc:	89 d2                	mov    %edx,%edx
  802bce:	48 01 d0             	add    %rdx,%rax
  802bd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802bd4:	83 c2 08             	add    $0x8,%edx
  802bd7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802bda:	eb 0c                	jmp    802be8 <vprintfmt+0x132>
  802bdc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802be0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802be4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802be8:	8b 00                	mov    (%rax),%eax
  802bea:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802bed:	eb 1e                	jmp    802c0d <vprintfmt+0x157>

		case '.':
			if (width < 0)
  802bef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802bf3:	79 07                	jns    802bfc <vprintfmt+0x146>
				width = 0;
  802bf5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802bfc:	e9 3e ff ff ff       	jmpq   802b3f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802c01:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802c08:	e9 32 ff ff ff       	jmpq   802b3f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802c0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802c11:	79 0d                	jns    802c20 <vprintfmt+0x16a>
				width = precision, precision = -1;
  802c13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802c16:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802c19:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802c20:	e9 1a ff ff ff       	jmpq   802b3f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802c25:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802c29:	e9 11 ff ff ff       	jmpq   802b3f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802c2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c31:	83 f8 30             	cmp    $0x30,%eax
  802c34:	73 17                	jae    802c4d <vprintfmt+0x197>
  802c36:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c3a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c3d:	89 d2                	mov    %edx,%edx
  802c3f:	48 01 d0             	add    %rdx,%rax
  802c42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c45:	83 c2 08             	add    $0x8,%edx
  802c48:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c4b:	eb 0c                	jmp    802c59 <vprintfmt+0x1a3>
  802c4d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802c51:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802c55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c59:	8b 10                	mov    (%rax),%edx
  802c5b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802c5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c63:	48 89 ce             	mov    %rcx,%rsi
  802c66:	89 d7                	mov    %edx,%edi
  802c68:	ff d0                	callq  *%rax
			break;
  802c6a:	e9 4a 03 00 00       	jmpq   802fb9 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802c6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c72:	83 f8 30             	cmp    $0x30,%eax
  802c75:	73 17                	jae    802c8e <vprintfmt+0x1d8>
  802c77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c7e:	89 d2                	mov    %edx,%edx
  802c80:	48 01 d0             	add    %rdx,%rax
  802c83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c86:	83 c2 08             	add    $0x8,%edx
  802c89:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c8c:	eb 0c                	jmp    802c9a <vprintfmt+0x1e4>
  802c8e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802c92:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802c96:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c9a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802c9c:	85 db                	test   %ebx,%ebx
  802c9e:	79 02                	jns    802ca2 <vprintfmt+0x1ec>
				err = -err;
  802ca0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802ca2:	83 fb 15             	cmp    $0x15,%ebx
  802ca5:	7f 16                	jg     802cbd <vprintfmt+0x207>
  802ca7:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  802cae:	00 00 00 
  802cb1:	48 63 d3             	movslq %ebx,%rdx
  802cb4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802cb8:	4d 85 e4             	test   %r12,%r12
  802cbb:	75 2e                	jne    802ceb <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  802cbd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802cc1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802cc5:	89 d9                	mov    %ebx,%ecx
  802cc7:	48 ba 41 41 80 00 00 	movabs $0x804141,%rdx
  802cce:	00 00 00 
  802cd1:	48 89 c7             	mov    %rax,%rdi
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	49 b8 c7 2f 80 00 00 	movabs $0x802fc7,%r8
  802ce0:	00 00 00 
  802ce3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802ce6:	e9 ce 02 00 00       	jmpq   802fb9 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  802ceb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802cef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802cf3:	4c 89 e1             	mov    %r12,%rcx
  802cf6:	48 ba 4a 41 80 00 00 	movabs $0x80414a,%rdx
  802cfd:	00 00 00 
  802d00:	48 89 c7             	mov    %rax,%rdi
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
  802d08:	49 b8 c7 2f 80 00 00 	movabs $0x802fc7,%r8
  802d0f:	00 00 00 
  802d12:	41 ff d0             	callq  *%r8
			break;
  802d15:	e9 9f 02 00 00       	jmpq   802fb9 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802d1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d1d:	83 f8 30             	cmp    $0x30,%eax
  802d20:	73 17                	jae    802d39 <vprintfmt+0x283>
  802d22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d29:	89 d2                	mov    %edx,%edx
  802d2b:	48 01 d0             	add    %rdx,%rax
  802d2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d31:	83 c2 08             	add    $0x8,%edx
  802d34:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802d37:	eb 0c                	jmp    802d45 <vprintfmt+0x28f>
  802d39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802d3d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802d41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802d45:	4c 8b 20             	mov    (%rax),%r12
  802d48:	4d 85 e4             	test   %r12,%r12
  802d4b:	75 0a                	jne    802d57 <vprintfmt+0x2a1>
				p = "(null)";
  802d4d:	49 bc 4d 41 80 00 00 	movabs $0x80414d,%r12
  802d54:	00 00 00 
			if (width > 0 && padc != '-')
  802d57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d5b:	7e 3f                	jle    802d9c <vprintfmt+0x2e6>
  802d5d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802d61:	74 39                	je     802d9c <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  802d63:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d66:	48 98                	cltq   
  802d68:	48 89 c6             	mov    %rax,%rsi
  802d6b:	4c 89 e7             	mov    %r12,%rdi
  802d6e:	48 b8 73 32 80 00 00 	movabs $0x803273,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	callq  *%rax
  802d7a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802d7d:	eb 17                	jmp    802d96 <vprintfmt+0x2e0>
					putch(padc, putdat);
  802d7f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802d83:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802d87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d8b:	48 89 ce             	mov    %rcx,%rsi
  802d8e:	89 d7                	mov    %edx,%edi
  802d90:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  802d92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d9a:	7f e3                	jg     802d7f <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802d9c:	eb 37                	jmp    802dd5 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  802d9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802da2:	74 1e                	je     802dc2 <vprintfmt+0x30c>
  802da4:	83 fb 1f             	cmp    $0x1f,%ebx
  802da7:	7e 05                	jle    802dae <vprintfmt+0x2f8>
  802da9:	83 fb 7e             	cmp    $0x7e,%ebx
  802dac:	7e 14                	jle    802dc2 <vprintfmt+0x30c>
					putch('?', putdat);
  802dae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802db2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802db6:	48 89 d6             	mov    %rdx,%rsi
  802db9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802dbe:	ff d0                	callq  *%rax
  802dc0:	eb 0f                	jmp    802dd1 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  802dc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802dc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802dca:	48 89 d6             	mov    %rdx,%rsi
  802dcd:	89 df                	mov    %ebx,%edi
  802dcf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802dd1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802dd5:	4c 89 e0             	mov    %r12,%rax
  802dd8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802ddc:	0f b6 00             	movzbl (%rax),%eax
  802ddf:	0f be d8             	movsbl %al,%ebx
  802de2:	85 db                	test   %ebx,%ebx
  802de4:	74 10                	je     802df6 <vprintfmt+0x340>
  802de6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802dea:	78 b2                	js     802d9e <vprintfmt+0x2e8>
  802dec:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802df0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802df4:	79 a8                	jns    802d9e <vprintfmt+0x2e8>
			for (; width > 0; width--)
  802df6:	eb 16                	jmp    802e0e <vprintfmt+0x358>
				putch(' ', putdat);
  802df8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802dfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e00:	48 89 d6             	mov    %rdx,%rsi
  802e03:	bf 20 00 00 00       	mov    $0x20,%edi
  802e08:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  802e0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e12:	7f e4                	jg     802df8 <vprintfmt+0x342>
			break;
  802e14:	e9 a0 01 00 00       	jmpq   802fb9 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802e19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e1d:	be 03 00 00 00       	mov    $0x3,%esi
  802e22:	48 89 c7             	mov    %rax,%rdi
  802e25:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e39:	48 85 c0             	test   %rax,%rax
  802e3c:	79 1d                	jns    802e5b <vprintfmt+0x3a5>
				putch('-', putdat);
  802e3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802e42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e46:	48 89 d6             	mov    %rdx,%rsi
  802e49:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802e4e:	ff d0                	callq  *%rax
				num = -(long long) num;
  802e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e54:	48 f7 d8             	neg    %rax
  802e57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802e5b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802e62:	e9 e5 00 00 00       	jmpq   802f4c <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802e67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e6b:	be 03 00 00 00       	mov    $0x3,%esi
  802e70:	48 89 c7             	mov    %rax,%rdi
  802e73:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
  802e7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802e83:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802e8a:	e9 bd 00 00 00       	jmpq   802f4c <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802e8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802e93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e97:	48 89 d6             	mov    %rdx,%rsi
  802e9a:	bf 58 00 00 00       	mov    $0x58,%edi
  802e9f:	ff d0                	callq  *%rax
			putch('X', putdat);
  802ea1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ea5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ea9:	48 89 d6             	mov    %rdx,%rsi
  802eac:	bf 58 00 00 00       	mov    $0x58,%edi
  802eb1:	ff d0                	callq  *%rax
			putch('X', putdat);
  802eb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802eb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ebb:	48 89 d6             	mov    %rdx,%rsi
  802ebe:	bf 58 00 00 00       	mov    $0x58,%edi
  802ec3:	ff d0                	callq  *%rax
			break;
  802ec5:	e9 ef 00 00 00       	jmpq   802fb9 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  802eca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ece:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ed2:	48 89 d6             	mov    %rdx,%rsi
  802ed5:	bf 30 00 00 00       	mov    $0x30,%edi
  802eda:	ff d0                	callq  *%rax
			putch('x', putdat);
  802edc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ee0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ee4:	48 89 d6             	mov    %rdx,%rsi
  802ee7:	bf 78 00 00 00       	mov    $0x78,%edi
  802eec:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802eee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ef1:	83 f8 30             	cmp    $0x30,%eax
  802ef4:	73 17                	jae    802f0d <vprintfmt+0x457>
  802ef6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802efa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802efd:	89 d2                	mov    %edx,%edx
  802eff:	48 01 d0             	add    %rdx,%rax
  802f02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f05:	83 c2 08             	add    $0x8,%edx
  802f08:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  802f0b:	eb 0c                	jmp    802f19 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  802f0d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802f11:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802f15:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f19:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  802f1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802f20:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802f27:	eb 23                	jmp    802f4c <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802f29:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802f2d:	be 03 00 00 00       	mov    $0x3,%esi
  802f32:	48 89 c7             	mov    %rax,%rdi
  802f35:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	callq  *%rax
  802f41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802f45:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802f4c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802f51:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f54:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802f57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f5b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f63:	45 89 c1             	mov    %r8d,%r9d
  802f66:	41 89 f8             	mov    %edi,%r8d
  802f69:	48 89 c7             	mov    %rax,%rdi
  802f6c:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	callq  *%rax
			break;
  802f78:	eb 3f                	jmp    802fb9 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802f7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f82:	48 89 d6             	mov    %rdx,%rsi
  802f85:	89 df                	mov    %ebx,%edi
  802f87:	ff d0                	callq  *%rax
			break;
  802f89:	eb 2e                	jmp    802fb9 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802f8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f93:	48 89 d6             	mov    %rdx,%rsi
  802f96:	bf 25 00 00 00       	mov    $0x25,%edi
  802f9b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802f9d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802fa2:	eb 05                	jmp    802fa9 <vprintfmt+0x4f3>
  802fa4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802fa9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802fad:	48 83 e8 01          	sub    $0x1,%rax
  802fb1:	0f b6 00             	movzbl (%rax),%eax
  802fb4:	3c 25                	cmp    $0x25,%al
  802fb6:	75 ec                	jne    802fa4 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  802fb8:	90                   	nop
		}
	}
  802fb9:	e9 31 fb ff ff       	jmpq   802aef <vprintfmt+0x39>
	va_end(aq);
}
  802fbe:	48 83 c4 60          	add    $0x60,%rsp
  802fc2:	5b                   	pop    %rbx
  802fc3:	41 5c                	pop    %r12
  802fc5:	5d                   	pop    %rbp
  802fc6:	c3                   	retq   

0000000000802fc7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802fc7:	55                   	push   %rbp
  802fc8:	48 89 e5             	mov    %rsp,%rbp
  802fcb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802fd2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802fd9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802fe0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fe7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802ff5:	84 c0                	test   %al,%al
  802ff7:	74 20                	je     803019 <printfmt+0x52>
  802ff9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ffd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803001:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803005:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803009:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80300d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803011:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803015:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803019:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803020:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803027:	00 00 00 
  80302a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803031:	00 00 00 
  803034:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803038:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80303f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803046:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80304d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803054:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80305b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803062:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803069:	48 89 c7             	mov    %rax,%rdi
  80306c:	48 b8 b6 2a 80 00 00 	movabs $0x802ab6,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
	va_end(ap);
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 10          	sub    $0x10,%rsp
  803082:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803085:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308d:	8b 40 10             	mov    0x10(%rax),%eax
  803090:	8d 50 01             	lea    0x1(%rax),%edx
  803093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803097:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80309a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309e:	48 8b 10             	mov    (%rax),%rdx
  8030a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8030a9:	48 39 c2             	cmp    %rax,%rdx
  8030ac:	73 17                	jae    8030c5 <sprintputch+0x4b>
		*b->buf++ = ch;
  8030ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b2:	48 8b 00             	mov    (%rax),%rax
  8030b5:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8030b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030bd:	48 89 0a             	mov    %rcx,(%rdx)
  8030c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030c3:	88 10                	mov    %dl,(%rax)
}
  8030c5:	c9                   	leaveq 
  8030c6:	c3                   	retq   

00000000008030c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8030c7:	55                   	push   %rbp
  8030c8:	48 89 e5             	mov    %rsp,%rbp
  8030cb:	48 83 ec 50          	sub    $0x50,%rsp
  8030cf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8030d3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8030d6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8030da:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8030de:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030e2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8030e6:	48 8b 0a             	mov    (%rdx),%rcx
  8030e9:	48 89 08             	mov    %rcx,(%rax)
  8030ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8030f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8030f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8030f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8030fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803100:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803104:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803107:	48 98                	cltq   
  803109:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80310d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803111:	48 01 d0             	add    %rdx,%rax
  803114:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803118:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80311f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803124:	74 06                	je     80312c <vsnprintf+0x65>
  803126:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80312a:	7f 07                	jg     803133 <vsnprintf+0x6c>
		return -E_INVAL;
  80312c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803131:	eb 2f                	jmp    803162 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803133:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803137:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80313b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80313f:	48 89 c6             	mov    %rax,%rsi
  803142:	48 bf 7a 30 80 00 00 	movabs $0x80307a,%rdi
  803149:	00 00 00 
  80314c:	48 b8 b6 2a 80 00 00 	movabs $0x802ab6,%rax
  803153:	00 00 00 
  803156:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803158:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80315f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803162:	c9                   	leaveq 
  803163:	c3                   	retq   

0000000000803164 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803164:	55                   	push   %rbp
  803165:	48 89 e5             	mov    %rsp,%rbp
  803168:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80316f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803176:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80317c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803183:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80318a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803191:	84 c0                	test   %al,%al
  803193:	74 20                	je     8031b5 <snprintf+0x51>
  803195:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803199:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80319d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8031a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8031a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8031a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8031ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8031b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8031b5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8031bc:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8031c3:	00 00 00 
  8031c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8031cd:	00 00 00 
  8031d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8031db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8031e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8031e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8031f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031f7:	48 8b 0a             	mov    (%rdx),%rcx
  8031fa:	48 89 08             	mov    %rcx,(%rax)
  8031fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803201:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803205:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803209:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80320d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803214:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80321b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803221:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803228:	48 89 c7             	mov    %rax,%rdi
  80322b:	48 b8 c7 30 80 00 00 	movabs $0x8030c7,%rax
  803232:	00 00 00 
  803235:	ff d0                	callq  *%rax
  803237:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80323d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803243:	c9                   	leaveq 
  803244:	c3                   	retq   

0000000000803245 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803245:	55                   	push   %rbp
  803246:	48 89 e5             	mov    %rsp,%rbp
  803249:	48 83 ec 18          	sub    $0x18,%rsp
  80324d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803258:	eb 09                	jmp    803263 <strlen+0x1e>
		n++;
  80325a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80325e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803267:	0f b6 00             	movzbl (%rax),%eax
  80326a:	84 c0                	test   %al,%al
  80326c:	75 ec                	jne    80325a <strlen+0x15>
	return n;
  80326e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 83 ec 20          	sub    $0x20,%rsp
  80327b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80328a:	eb 0e                	jmp    80329a <strnlen+0x27>
		n++;
  80328c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803290:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803295:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80329a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80329f:	74 0b                	je     8032ac <strnlen+0x39>
  8032a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a5:	0f b6 00             	movzbl (%rax),%eax
  8032a8:	84 c0                	test   %al,%al
  8032aa:	75 e0                	jne    80328c <strnlen+0x19>
	return n;
  8032ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032af:	c9                   	leaveq 
  8032b0:	c3                   	retq   

00000000008032b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8032b1:	55                   	push   %rbp
  8032b2:	48 89 e5             	mov    %rsp,%rbp
  8032b5:	48 83 ec 20          	sub    $0x20,%rsp
  8032b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8032c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8032c9:	90                   	nop
  8032ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8032d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032da:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8032de:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8032e2:	0f b6 12             	movzbl (%rdx),%edx
  8032e5:	88 10                	mov    %dl,(%rax)
  8032e7:	0f b6 00             	movzbl (%rax),%eax
  8032ea:	84 c0                	test   %al,%al
  8032ec:	75 dc                	jne    8032ca <strcpy+0x19>
		/* do nothing */;
	return ret;
  8032ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8032f2:	c9                   	leaveq 
  8032f3:	c3                   	retq   

00000000008032f4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8032f4:	55                   	push   %rbp
  8032f5:	48 89 e5             	mov    %rsp,%rbp
  8032f8:	48 83 ec 20          	sub    $0x20,%rsp
  8032fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803300:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803308:	48 89 c7             	mov    %rax,%rdi
  80330b:	48 b8 45 32 80 00 00 	movabs $0x803245,%rax
  803312:	00 00 00 
  803315:	ff d0                	callq  *%rax
  803317:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80331a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331d:	48 63 d0             	movslq %eax,%rdx
  803320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803324:	48 01 c2             	add    %rax,%rdx
  803327:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332b:	48 89 c6             	mov    %rax,%rsi
  80332e:	48 89 d7             	mov    %rdx,%rdi
  803331:	48 b8 b1 32 80 00 00 	movabs $0x8032b1,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
	return dst;
  80333d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803341:	c9                   	leaveq 
  803342:	c3                   	retq   

0000000000803343 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803343:	55                   	push   %rbp
  803344:	48 89 e5             	mov    %rsp,%rbp
  803347:	48 83 ec 28          	sub    $0x28,%rsp
  80334b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80334f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803353:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80335f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803366:	00 
  803367:	eb 2a                	jmp    803393 <strncpy+0x50>
		*dst++ = *src;
  803369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80336d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803371:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803375:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803379:	0f b6 12             	movzbl (%rdx),%edx
  80337c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80337e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803382:	0f b6 00             	movzbl (%rax),%eax
  803385:	84 c0                	test   %al,%al
  803387:	74 05                	je     80338e <strncpy+0x4b>
			src++;
  803389:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80338e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803397:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80339b:	72 cc                	jb     803369 <strncpy+0x26>
	}
	return ret;
  80339d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 28          	sub    $0x28,%rsp
  8033ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8033b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8033bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033c4:	74 3d                	je     803403 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8033c6:	eb 1d                	jmp    8033e5 <strlcpy+0x42>
			*dst++ = *src++;
  8033c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8033d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8033d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033d8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8033dc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8033e0:	0f b6 12             	movzbl (%rdx),%edx
  8033e3:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8033e5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8033ea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033ef:	74 0b                	je     8033fc <strlcpy+0x59>
  8033f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f5:	0f b6 00             	movzbl (%rax),%eax
  8033f8:	84 c0                	test   %al,%al
  8033fa:	75 cc                	jne    8033c8 <strlcpy+0x25>
		*dst = '\0';
  8033fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803400:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803403:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80340b:	48 29 c2             	sub    %rax,%rdx
  80340e:	48 89 d0             	mov    %rdx,%rax
}
  803411:	c9                   	leaveq 
  803412:	c3                   	retq   

0000000000803413 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803413:	55                   	push   %rbp
  803414:	48 89 e5             	mov    %rsp,%rbp
  803417:	48 83 ec 10          	sub    $0x10,%rsp
  80341b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80341f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803423:	eb 0a                	jmp    80342f <strcmp+0x1c>
		p++, q++;
  803425:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80342a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80342f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803433:	0f b6 00             	movzbl (%rax),%eax
  803436:	84 c0                	test   %al,%al
  803438:	74 12                	je     80344c <strcmp+0x39>
  80343a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343e:	0f b6 10             	movzbl (%rax),%edx
  803441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803445:	0f b6 00             	movzbl (%rax),%eax
  803448:	38 c2                	cmp    %al,%dl
  80344a:	74 d9                	je     803425 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80344c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803450:	0f b6 00             	movzbl (%rax),%eax
  803453:	0f b6 d0             	movzbl %al,%edx
  803456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80345a:	0f b6 00             	movzbl (%rax),%eax
  80345d:	0f b6 c0             	movzbl %al,%eax
  803460:	29 c2                	sub    %eax,%edx
  803462:	89 d0                	mov    %edx,%eax
}
  803464:	c9                   	leaveq 
  803465:	c3                   	retq   

0000000000803466 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  803466:	55                   	push   %rbp
  803467:	48 89 e5             	mov    %rsp,%rbp
  80346a:	48 83 ec 18          	sub    $0x18,%rsp
  80346e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803472:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803476:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80347a:	eb 0f                	jmp    80348b <strncmp+0x25>
		n--, p++, q++;
  80347c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803481:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803486:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  80348b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803490:	74 1d                	je     8034af <strncmp+0x49>
  803492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803496:	0f b6 00             	movzbl (%rax),%eax
  803499:	84 c0                	test   %al,%al
  80349b:	74 12                	je     8034af <strncmp+0x49>
  80349d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a1:	0f b6 10             	movzbl (%rax),%edx
  8034a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a8:	0f b6 00             	movzbl (%rax),%eax
  8034ab:	38 c2                	cmp    %al,%dl
  8034ad:	74 cd                	je     80347c <strncmp+0x16>
	if (n == 0)
  8034af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034b4:	75 07                	jne    8034bd <strncmp+0x57>
		return 0;
  8034b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034bb:	eb 18                	jmp    8034d5 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8034bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c1:	0f b6 00             	movzbl (%rax),%eax
  8034c4:	0f b6 d0             	movzbl %al,%edx
  8034c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034cb:	0f b6 00             	movzbl (%rax),%eax
  8034ce:	0f b6 c0             	movzbl %al,%eax
  8034d1:	29 c2                	sub    %eax,%edx
  8034d3:	89 d0                	mov    %edx,%eax
}
  8034d5:	c9                   	leaveq 
  8034d6:	c3                   	retq   

00000000008034d7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8034d7:	55                   	push   %rbp
  8034d8:	48 89 e5             	mov    %rsp,%rbp
  8034db:	48 83 ec 10          	sub    $0x10,%rsp
  8034df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e3:	89 f0                	mov    %esi,%eax
  8034e5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8034e8:	eb 17                	jmp    803501 <strchr+0x2a>
		if (*s == c)
  8034ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ee:	0f b6 00             	movzbl (%rax),%eax
  8034f1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8034f4:	75 06                	jne    8034fc <strchr+0x25>
			return (char *) s;
  8034f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034fa:	eb 15                	jmp    803511 <strchr+0x3a>
	for (; *s; s++)
  8034fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803501:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803505:	0f b6 00             	movzbl (%rax),%eax
  803508:	84 c0                	test   %al,%al
  80350a:	75 de                	jne    8034ea <strchr+0x13>
	return 0;
  80350c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803511:	c9                   	leaveq 
  803512:	c3                   	retq   

0000000000803513 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 10          	sub    $0x10,%rsp
  80351b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80351f:	89 f0                	mov    %esi,%eax
  803521:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803524:	eb 13                	jmp    803539 <strfind+0x26>
		if (*s == c)
  803526:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352a:	0f b6 00             	movzbl (%rax),%eax
  80352d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803530:	75 02                	jne    803534 <strfind+0x21>
			break;
  803532:	eb 10                	jmp    803544 <strfind+0x31>
	for (; *s; s++)
  803534:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80353d:	0f b6 00             	movzbl (%rax),%eax
  803540:	84 c0                	test   %al,%al
  803542:	75 e2                	jne    803526 <strfind+0x13>
	return (char *) s;
  803544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	48 83 ec 18          	sub    $0x18,%rsp
  803552:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803556:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803559:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80355d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803562:	75 06                	jne    80356a <memset+0x20>
		return v;
  803564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803568:	eb 69                	jmp    8035d3 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80356a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356e:	83 e0 03             	and    $0x3,%eax
  803571:	48 85 c0             	test   %rax,%rax
  803574:	75 48                	jne    8035be <memset+0x74>
  803576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357a:	83 e0 03             	and    $0x3,%eax
  80357d:	48 85 c0             	test   %rax,%rax
  803580:	75 3c                	jne    8035be <memset+0x74>
		c &= 0xFF;
  803582:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803589:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80358c:	c1 e0 18             	shl    $0x18,%eax
  80358f:	89 c2                	mov    %eax,%edx
  803591:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803594:	c1 e0 10             	shl    $0x10,%eax
  803597:	09 c2                	or     %eax,%edx
  803599:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80359c:	c1 e0 08             	shl    $0x8,%eax
  80359f:	09 d0                	or     %edx,%eax
  8035a1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8035a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a8:	48 c1 e8 02          	shr    $0x2,%rax
  8035ac:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8035af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035b6:	48 89 d7             	mov    %rdx,%rdi
  8035b9:	fc                   	cld    
  8035ba:	f3 ab                	rep stos %eax,%es:(%rdi)
  8035bc:	eb 11                	jmp    8035cf <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8035be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035c5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035c9:	48 89 d7             	mov    %rdx,%rdi
  8035cc:	fc                   	cld    
  8035cd:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8035cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035d3:	c9                   	leaveq 
  8035d4:	c3                   	retq   

00000000008035d5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8035d5:	55                   	push   %rbp
  8035d6:	48 89 e5             	mov    %rsp,%rbp
  8035d9:	48 83 ec 28          	sub    $0x28,%rsp
  8035dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8035e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8035f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8035f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035fd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803601:	0f 83 88 00 00 00    	jae    80368f <memmove+0xba>
  803607:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80360b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360f:	48 01 d0             	add    %rdx,%rax
  803612:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803616:	76 77                	jbe    80368f <memmove+0xba>
		s += n;
  803618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  803620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803624:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362c:	83 e0 03             	and    $0x3,%eax
  80362f:	48 85 c0             	test   %rax,%rax
  803632:	75 3b                	jne    80366f <memmove+0x9a>
  803634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803638:	83 e0 03             	and    $0x3,%eax
  80363b:	48 85 c0             	test   %rax,%rax
  80363e:	75 2f                	jne    80366f <memmove+0x9a>
  803640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803644:	83 e0 03             	and    $0x3,%eax
  803647:	48 85 c0             	test   %rax,%rax
  80364a:	75 23                	jne    80366f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80364c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803650:	48 83 e8 04          	sub    $0x4,%rax
  803654:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803658:	48 83 ea 04          	sub    $0x4,%rdx
  80365c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803660:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  803664:	48 89 c7             	mov    %rax,%rdi
  803667:	48 89 d6             	mov    %rdx,%rsi
  80366a:	fd                   	std    
  80366b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80366d:	eb 1d                	jmp    80368c <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80366f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803673:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80367f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803683:	48 89 d7             	mov    %rdx,%rdi
  803686:	48 89 c1             	mov    %rax,%rcx
  803689:	fd                   	std    
  80368a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80368c:	fc                   	cld    
  80368d:	eb 57                	jmp    8036e6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80368f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803693:	83 e0 03             	and    $0x3,%eax
  803696:	48 85 c0             	test   %rax,%rax
  803699:	75 36                	jne    8036d1 <memmove+0xfc>
  80369b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369f:	83 e0 03             	and    $0x3,%eax
  8036a2:	48 85 c0             	test   %rax,%rax
  8036a5:	75 2a                	jne    8036d1 <memmove+0xfc>
  8036a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ab:	83 e0 03             	and    $0x3,%eax
  8036ae:	48 85 c0             	test   %rax,%rax
  8036b1:	75 1e                	jne    8036d1 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8036b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b7:	48 c1 e8 02          	shr    $0x2,%rax
  8036bb:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8036be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036c6:	48 89 c7             	mov    %rax,%rdi
  8036c9:	48 89 d6             	mov    %rdx,%rsi
  8036cc:	fc                   	cld    
  8036cd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8036cf:	eb 15                	jmp    8036e6 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8036d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036d9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8036dd:	48 89 c7             	mov    %rax,%rdi
  8036e0:	48 89 d6             	mov    %rdx,%rsi
  8036e3:	fc                   	cld    
  8036e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8036e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8036ea:	c9                   	leaveq 
  8036eb:	c3                   	retq   

00000000008036ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8036ec:	55                   	push   %rbp
  8036ed:	48 89 e5             	mov    %rsp,%rbp
  8036f0:	48 83 ec 18          	sub    $0x18,%rsp
  8036f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803704:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370c:	48 89 ce             	mov    %rcx,%rsi
  80370f:	48 89 c7             	mov    %rax,%rdi
  803712:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  803719:	00 00 00 
  80371c:	ff d0                	callq  *%rax
}
  80371e:	c9                   	leaveq 
  80371f:	c3                   	retq   

0000000000803720 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803720:	55                   	push   %rbp
  803721:	48 89 e5             	mov    %rsp,%rbp
  803724:	48 83 ec 28          	sub    $0x28,%rsp
  803728:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80372c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803730:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803738:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80373c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803740:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803744:	eb 36                	jmp    80377c <memcmp+0x5c>
		if (*s1 != *s2)
  803746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374a:	0f b6 10             	movzbl (%rax),%edx
  80374d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803751:	0f b6 00             	movzbl (%rax),%eax
  803754:	38 c2                	cmp    %al,%dl
  803756:	74 1a                	je     803772 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375c:	0f b6 00             	movzbl (%rax),%eax
  80375f:	0f b6 d0             	movzbl %al,%edx
  803762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803766:	0f b6 00             	movzbl (%rax),%eax
  803769:	0f b6 c0             	movzbl %al,%eax
  80376c:	29 c2                	sub    %eax,%edx
  80376e:	89 d0                	mov    %edx,%eax
  803770:	eb 20                	jmp    803792 <memcmp+0x72>
		s1++, s2++;
  803772:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803777:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  80377c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803780:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803784:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803788:	48 85 c0             	test   %rax,%rax
  80378b:	75 b9                	jne    803746 <memcmp+0x26>
	}

	return 0;
  80378d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803792:	c9                   	leaveq 
  803793:	c3                   	retq   

0000000000803794 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803794:	55                   	push   %rbp
  803795:	48 89 e5             	mov    %rsp,%rbp
  803798:	48 83 ec 28          	sub    $0x28,%rsp
  80379c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037a0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8037a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8037a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037af:	48 01 d0             	add    %rdx,%rax
  8037b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8037b6:	eb 15                	jmp    8037cd <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8037b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bc:	0f b6 00             	movzbl (%rax),%eax
  8037bf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8037c2:	38 d0                	cmp    %dl,%al
  8037c4:	75 02                	jne    8037c8 <memfind+0x34>
			break;
  8037c6:	eb 0f                	jmp    8037d7 <memfind+0x43>
	for (; s < ends; s++)
  8037c8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8037cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8037d5:	72 e1                	jb     8037b8 <memfind+0x24>
	return (void *) s;
  8037d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8037db:	c9                   	leaveq 
  8037dc:	c3                   	retq   

00000000008037dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8037dd:	55                   	push   %rbp
  8037de:	48 89 e5             	mov    %rsp,%rbp
  8037e1:	48 83 ec 38          	sub    $0x38,%rsp
  8037e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037ed:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8037f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8037f7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8037fe:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8037ff:	eb 05                	jmp    803806 <strtol+0x29>
		s++;
  803801:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  803806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380a:	0f b6 00             	movzbl (%rax),%eax
  80380d:	3c 20                	cmp    $0x20,%al
  80380f:	74 f0                	je     803801 <strtol+0x24>
  803811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803815:	0f b6 00             	movzbl (%rax),%eax
  803818:	3c 09                	cmp    $0x9,%al
  80381a:	74 e5                	je     803801 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80381c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803820:	0f b6 00             	movzbl (%rax),%eax
  803823:	3c 2b                	cmp    $0x2b,%al
  803825:	75 07                	jne    80382e <strtol+0x51>
		s++;
  803827:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80382c:	eb 17                	jmp    803845 <strtol+0x68>
	else if (*s == '-')
  80382e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803832:	0f b6 00             	movzbl (%rax),%eax
  803835:	3c 2d                	cmp    $0x2d,%al
  803837:	75 0c                	jne    803845 <strtol+0x68>
		s++, neg = 1;
  803839:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80383e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803845:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803849:	74 06                	je     803851 <strtol+0x74>
  80384b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80384f:	75 28                	jne    803879 <strtol+0x9c>
  803851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803855:	0f b6 00             	movzbl (%rax),%eax
  803858:	3c 30                	cmp    $0x30,%al
  80385a:	75 1d                	jne    803879 <strtol+0x9c>
  80385c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803860:	48 83 c0 01          	add    $0x1,%rax
  803864:	0f b6 00             	movzbl (%rax),%eax
  803867:	3c 78                	cmp    $0x78,%al
  803869:	75 0e                	jne    803879 <strtol+0x9c>
		s += 2, base = 16;
  80386b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803870:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803877:	eb 2c                	jmp    8038a5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803879:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80387d:	75 19                	jne    803898 <strtol+0xbb>
  80387f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803883:	0f b6 00             	movzbl (%rax),%eax
  803886:	3c 30                	cmp    $0x30,%al
  803888:	75 0e                	jne    803898 <strtol+0xbb>
		s++, base = 8;
  80388a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80388f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803896:	eb 0d                	jmp    8038a5 <strtol+0xc8>
	else if (base == 0)
  803898:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80389c:	75 07                	jne    8038a5 <strtol+0xc8>
		base = 10;
  80389e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8038a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a9:	0f b6 00             	movzbl (%rax),%eax
  8038ac:	3c 2f                	cmp    $0x2f,%al
  8038ae:	7e 1d                	jle    8038cd <strtol+0xf0>
  8038b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b4:	0f b6 00             	movzbl (%rax),%eax
  8038b7:	3c 39                	cmp    $0x39,%al
  8038b9:	7f 12                	jg     8038cd <strtol+0xf0>
			dig = *s - '0';
  8038bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bf:	0f b6 00             	movzbl (%rax),%eax
  8038c2:	0f be c0             	movsbl %al,%eax
  8038c5:	83 e8 30             	sub    $0x30,%eax
  8038c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038cb:	eb 4e                	jmp    80391b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8038cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d1:	0f b6 00             	movzbl (%rax),%eax
  8038d4:	3c 60                	cmp    $0x60,%al
  8038d6:	7e 1d                	jle    8038f5 <strtol+0x118>
  8038d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038dc:	0f b6 00             	movzbl (%rax),%eax
  8038df:	3c 7a                	cmp    $0x7a,%al
  8038e1:	7f 12                	jg     8038f5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8038e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e7:	0f b6 00             	movzbl (%rax),%eax
  8038ea:	0f be c0             	movsbl %al,%eax
  8038ed:	83 e8 57             	sub    $0x57,%eax
  8038f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038f3:	eb 26                	jmp    80391b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8038f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f9:	0f b6 00             	movzbl (%rax),%eax
  8038fc:	3c 40                	cmp    $0x40,%al
  8038fe:	7e 48                	jle    803948 <strtol+0x16b>
  803900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803904:	0f b6 00             	movzbl (%rax),%eax
  803907:	3c 5a                	cmp    $0x5a,%al
  803909:	7f 3d                	jg     803948 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80390b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390f:	0f b6 00             	movzbl (%rax),%eax
  803912:	0f be c0             	movsbl %al,%eax
  803915:	83 e8 37             	sub    $0x37,%eax
  803918:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80391b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80391e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803921:	7c 02                	jl     803925 <strtol+0x148>
			break;
  803923:	eb 23                	jmp    803948 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803925:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80392a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80392d:	48 98                	cltq   
  80392f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803934:	48 89 c2             	mov    %rax,%rdx
  803937:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80393a:	48 98                	cltq   
  80393c:	48 01 d0             	add    %rdx,%rax
  80393f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803943:	e9 5d ff ff ff       	jmpq   8038a5 <strtol+0xc8>

	if (endptr)
  803948:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80394d:	74 0b                	je     80395a <strtol+0x17d>
		*endptr = (char *) s;
  80394f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803953:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803957:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80395a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395e:	74 09                	je     803969 <strtol+0x18c>
  803960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803964:	48 f7 d8             	neg    %rax
  803967:	eb 04                	jmp    80396d <strtol+0x190>
  803969:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80396d:	c9                   	leaveq 
  80396e:	c3                   	retq   

000000000080396f <strstr>:

char * strstr(const char *in, const char *str)
{
  80396f:	55                   	push   %rbp
  803970:	48 89 e5             	mov    %rsp,%rbp
  803973:	48 83 ec 30          	sub    $0x30,%rsp
  803977:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80397b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80397f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803983:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803987:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80398b:	0f b6 00             	movzbl (%rax),%eax
  80398e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803991:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803995:	75 06                	jne    80399d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399b:	eb 6b                	jmp    803a08 <strstr+0x99>

	len = strlen(str);
  80399d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a1:	48 89 c7             	mov    %rax,%rdi
  8039a4:	48 b8 45 32 80 00 00 	movabs $0x803245,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	48 98                	cltq   
  8039b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8039b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8039be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8039c2:	0f b6 00             	movzbl (%rax),%eax
  8039c5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8039c8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8039cc:	75 07                	jne    8039d5 <strstr+0x66>
				return (char *) 0;
  8039ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d3:	eb 33                	jmp    803a08 <strstr+0x99>
		} while (sc != c);
  8039d5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8039d9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8039dc:	75 d8                	jne    8039b6 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8039de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039e2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8039e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ea:	48 89 ce             	mov    %rcx,%rsi
  8039ed:	48 89 c7             	mov    %rax,%rdi
  8039f0:	48 b8 66 34 80 00 00 	movabs $0x803466,%rax
  8039f7:	00 00 00 
  8039fa:	ff d0                	callq  *%rax
  8039fc:	85 c0                	test   %eax,%eax
  8039fe:	75 b6                	jne    8039b6 <strstr+0x47>

	return (char *) (in - 1);
  803a00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a04:	48 83 e8 01          	sub    $0x1,%rax
}
  803a08:	c9                   	leaveq 
  803a09:	c3                   	retq   

0000000000803a0a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 83 ec 20          	sub    $0x20,%rsp
  803a12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803a1e:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  803a25:	00 00 00 
  803a28:	be 1d 00 00 00       	mov    $0x1d,%esi
  803a2d:	48 bf 21 44 80 00 00 	movabs $0x804421,%rdi
  803a34:	00 00 00 
  803a37:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3c:	48 b9 de 24 80 00 00 	movabs $0x8024de,%rcx
  803a43:	00 00 00 
  803a46:	ff d1                	callq  *%rcx

0000000000803a48 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a48:	55                   	push   %rbp
  803a49:	48 89 e5             	mov    %rsp,%rbp
  803a4c:	48 83 ec 20          	sub    $0x20,%rsp
  803a50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a53:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a56:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803a5a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803a5d:	48 ba 2b 44 80 00 00 	movabs $0x80442b,%rdx
  803a64:	00 00 00 
  803a67:	be 2d 00 00 00       	mov    $0x2d,%esi
  803a6c:	48 bf 21 44 80 00 00 	movabs $0x804421,%rdi
  803a73:	00 00 00 
  803a76:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7b:	48 b9 de 24 80 00 00 	movabs $0x8024de,%rcx
  803a82:	00 00 00 
  803a85:	ff d1                	callq  *%rcx

0000000000803a87 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803a87:	55                   	push   %rbp
  803a88:	48 89 e5             	mov    %rsp,%rbp
  803a8b:	53                   	push   %rbx
  803a8c:	48 83 ec 48          	sub    $0x48,%rsp
  803a90:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803a94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803a9b:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803aa2:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803aa7:	75 0e                	jne    803ab7 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803aa9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ab0:	00 00 00 
  803ab3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803ab7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803abb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803abf:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803ac6:	00 
	a3 = (uint64_t) 0;
  803ac7:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803ace:	00 
	a4 = (uint64_t) 0;
  803acf:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803ad6:	00 
	a5 = 0;
  803ad7:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803ade:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803adf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ae2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ae6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803aea:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803aee:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803af2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803af6:	4c 89 c3             	mov    %r8,%rbx
  803af9:	0f 01 c1             	vmcall 
  803afc:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803aff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b03:	7e 36                	jle    803b3b <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803b05:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b0b:	41 89 d0             	mov    %edx,%r8d
  803b0e:	89 c1                	mov    %eax,%ecx
  803b10:	48 ba 48 44 80 00 00 	movabs $0x804448,%rdx
  803b17:	00 00 00 
  803b1a:	be 54 00 00 00       	mov    $0x54,%esi
  803b1f:	48 bf 21 44 80 00 00 	movabs $0x804421,%rdi
  803b26:	00 00 00 
  803b29:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2e:	49 b9 de 24 80 00 00 	movabs $0x8024de,%r9
  803b35:	00 00 00 
  803b38:	41 ff d1             	callq  *%r9
	return ret;
  803b3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b3e:	48 83 c4 48          	add    $0x48,%rsp
  803b42:	5b                   	pop    %rbx
  803b43:	5d                   	pop    %rbp
  803b44:	c3                   	retq   

0000000000803b45 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b45:	55                   	push   %rbp
  803b46:	48 89 e5             	mov    %rsp,%rbp
  803b49:	53                   	push   %rbx
  803b4a:	48 83 ec 58          	sub    $0x58,%rsp
  803b4e:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803b51:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803b54:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803b58:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803b62:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803b69:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803b6e:	75 0e                	jne    803b7e <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803b70:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803b77:	00 00 00 
  803b7a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803b7e:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803b81:	48 98                	cltq   
  803b83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803b87:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803b8a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b92:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803b96:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803b99:	48 98                	cltq   
  803b9b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803b9f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803ba6:	00 

	int r = -E_IPC_NOT_RECV;
  803ba7:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803bae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bb5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bb9:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803bbd:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803bc1:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803bc5:	4c 89 c3             	mov    %r8,%rbx
  803bc8:	0f 01 c1             	vmcall 
  803bcb:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803bce:	48 83 c4 58          	add    $0x58,%rsp
  803bd2:	5b                   	pop    %rbx
  803bd3:	5d                   	pop    %rbp
  803bd4:	c3                   	retq   

0000000000803bd5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803bd5:	55                   	push   %rbp
  803bd6:	48 89 e5             	mov    %rsp,%rbp
  803bd9:	48 83 ec 18          	sub    $0x18,%rsp
  803bdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803be0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803be7:	eb 4e                	jmp    803c37 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803be9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803bf0:	00 00 00 
  803bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf6:	48 98                	cltq   
  803bf8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803bff:	48 01 d0             	add    %rdx,%rax
  803c02:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803c08:	8b 00                	mov    (%rax),%eax
  803c0a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c0d:	75 24                	jne    803c33 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803c0f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c16:	00 00 00 
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1c:	48 98                	cltq   
  803c1e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803c25:	48 01 d0             	add    %rdx,%rax
  803c28:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c2e:	8b 40 08             	mov    0x8(%rax),%eax
  803c31:	eb 12                	jmp    803c45 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803c33:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c37:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c3e:	7e a9                	jle    803be9 <ipc_find_env+0x14>
	}
	return 0;
  803c40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c45:	c9                   	leaveq 
  803c46:	c3                   	retq   

0000000000803c47 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c47:	55                   	push   %rbp
  803c48:	48 89 e5             	mov    %rsp,%rbp
  803c4b:	48 83 ec 18          	sub    $0x18,%rsp
  803c4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c57:	48 c1 e8 15          	shr    $0x15,%rax
  803c5b:	48 89 c2             	mov    %rax,%rdx
  803c5e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c65:	01 00 00 
  803c68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c6c:	83 e0 01             	and    $0x1,%eax
  803c6f:	48 85 c0             	test   %rax,%rax
  803c72:	75 07                	jne    803c7b <pageref+0x34>
		return 0;
  803c74:	b8 00 00 00 00       	mov    $0x0,%eax
  803c79:	eb 53                	jmp    803cce <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c7f:	48 c1 e8 0c          	shr    $0xc,%rax
  803c83:	48 89 c2             	mov    %rax,%rdx
  803c86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c8d:	01 00 00 
  803c90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c9c:	83 e0 01             	and    $0x1,%eax
  803c9f:	48 85 c0             	test   %rax,%rax
  803ca2:	75 07                	jne    803cab <pageref+0x64>
		return 0;
  803ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca9:	eb 23                	jmp    803cce <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803caf:	48 c1 e8 0c          	shr    $0xc,%rax
  803cb3:	48 89 c2             	mov    %rax,%rdx
  803cb6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803cbd:	00 00 00 
  803cc0:	48 c1 e2 04          	shl    $0x4,%rdx
  803cc4:	48 01 d0             	add    %rdx,%rax
  803cc7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ccb:	0f b7 c0             	movzwl %ax,%eax
}
  803cce:	c9                   	leaveq 
  803ccf:	c3                   	retq   
