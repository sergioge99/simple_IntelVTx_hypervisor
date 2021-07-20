
vmm/guest/obj/net/testoutput:     formato del fichero elf64-x86-64


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
  80003c:	e8 74 03 00 00       	callq  8003b5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  800053:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r;

    binaryname = "testoutput";
  800062:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800069:	00 00 00 
  80006c:	48 bb 00 41 80 00 00 	movabs $0x804100,%rbx
  800073:	00 00 00 
  800076:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  800079:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	89 c2                	mov    %eax,%edx
  800087:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80008e:	00 00 00 
  800091:	89 10                	mov    %edx,(%rax)
    if (output_envid < 0)
  800093:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80009a:	00 00 00 
  80009d:	8b 00                	mov    (%rax),%eax
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	79 2a                	jns    8000cd <umain+0x8a>
        panic("error forking");
  8000a3:	48 ba 0b 41 80 00 00 	movabs $0x80410b,%rdx
  8000aa:	00 00 00 
  8000ad:	be 16 00 00 00       	mov    $0x16,%esi
  8000b2:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  8000b9:	00 00 00 
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  8000c8:	00 00 00 
  8000cb:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8000cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d4:	00 00 00 
  8000d7:	8b 00                	mov    (%rax),%eax
  8000d9:	85 c0                	test   %eax,%eax
  8000db:	75 16                	jne    8000f3 <umain+0xb0>
        output(ns_envid);
  8000dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	48 b8 91 03 80 00 00 	movabs $0x800391,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
        return;
  8000ee:	e9 50 01 00 00       	jmpq   800243 <umain+0x200>
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000fa:	e9 1b 01 00 00       	jmpq   80021a <umain+0x1d7>
        if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000ff:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800106:	00 00 00 
  800109:	48 8b 00             	mov    (%rax),%rax
  80010c:	ba 07 00 00 00       	mov    $0x7,%edx
  800111:	48 89 c6             	mov    %rax,%rsi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
  800125:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800128:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80012c:	79 30                	jns    80015e <umain+0x11b>
            panic("sys_page_alloc: %e", r);
  80012e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800131:	89 c1                	mov    %eax,%ecx
  800133:	48 ba 2a 41 80 00 00 	movabs $0x80412a,%rdx
  80013a:	00 00 00 
  80013d:	be 1e 00 00 00       	mov    $0x1e,%esi
  800142:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  800149:	00 00 00 
  80014c:	b8 00 00 00 00       	mov    $0x0,%eax
  800151:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  800158:	00 00 00 
  80015b:	41 ff d0             	callq  *%r8
        pkt->jp_len = snprintf(pkt->jp_data,
  80015e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800165:	00 00 00 
  800168:	48 8b 18             	mov    (%rax),%rbx
  80016b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800172:	00 00 00 
  800175:	48 8b 00             	mov    (%rax),%rax
  800178:	48 8d 78 04          	lea    0x4(%rax),%rdi
  80017c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017f:	89 c1                	mov    %eax,%ecx
  800181:	48 ba 3d 41 80 00 00 	movabs $0x80413d,%rdx
  800188:	00 00 00 
  80018b:	be fc 0f 00 00       	mov    $0xffc,%esi
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	49 b8 be 10 80 00 00 	movabs $0x8010be,%r8
  80019c:	00 00 00 
  80019f:	41 ff d0             	callq  *%r8
  8001a2:	89 03                	mov    %eax,(%rbx)
                PGSIZE - sizeof(pkt->jp_len),
                "Packet %02d", i);
        cprintf("Transmitting packet %d\n", i);
  8001a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a7:	89 c6                	mov    %eax,%esi
  8001a9:	48 bf 49 41 80 00 00 	movabs $0x804149,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001c4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001cb:	00 00 00 
  8001ce:	48 8b 10             	mov    (%rax),%rdx
  8001d1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001d8:	00 00 00 
  8001db:	8b 00                	mov    (%rax),%eax
  8001dd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001e2:	be 0b 00 00 00       	mov    $0xb,%esi
  8001e7:	89 c7                	mov    %eax,%edi
  8001e9:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	callq  *%rax
        sys_page_unmap(0, pkt);
  8001f5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fc:	00 00 00 
  8001ff:	48 8b 00             	mov    (%rax),%rax
  800202:	48 89 c6             	mov    %rax,%rsi
  800205:	bf 00 00 00 00       	mov    $0x0,%edi
  80020a:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800216:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80021a:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80021e:	0f 8e db fe ff ff    	jle    8000ff <umain+0xbc>
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800224:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80022b:	eb 10                	jmp    80023d <umain+0x1fa>
        sys_yield();
  80022d:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800239:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80023d:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  800241:	7e ea                	jle    80022d <umain+0x1ea>
}
  800243:	48 83 c4 28          	add    $0x28,%rsp
  800247:	5b                   	pop    %rbx
  800248:	5d                   	pop    %rbp
  800249:	c3                   	retq   

000000000080024a <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  80024a:	55                   	push   %rbp
  80024b:	48 89 e5             	mov    %rsp,%rbp
  80024e:	48 83 ec 20          	sub    $0x20,%rsp
  800252:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800255:	89 75 e8             	mov    %esi,-0x18(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800258:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	89 c2                	mov    %eax,%edx
  800266:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800269:	01 d0                	add    %edx,%eax
  80026b:	89 45 fc             	mov    %eax,-0x4(%rbp)

    binaryname = "ns_timer";
  80026e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800275:	00 00 00 
  800278:	48 b9 68 41 80 00 00 	movabs $0x804168,%rcx
  80027f:	00 00 00 
  800282:	48 89 08             	mov    %rcx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800285:	eb 0c                	jmp    800293 <timer+0x49>
            sys_yield();
  800287:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
        while((r = sys_time_msec()) < stop && r >= 0) {
  800293:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  80029a:	00 00 00 
  80029d:	ff d0                	callq  *%rax
  80029f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002a5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8002a8:	73 06                	jae    8002b0 <timer+0x66>
  8002aa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ae:	79 d7                	jns    800287 <timer+0x3d>
        }
        if (r < 0)
  8002b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002b4:	79 30                	jns    8002e6 <timer+0x9c>
            panic("sys_time_msec: %e", r);
  8002b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002b9:	89 c1                	mov    %eax,%ecx
  8002bb:	48 ba 71 41 80 00 00 	movabs $0x804171,%rdx
  8002c2:	00 00 00 
  8002c5:	be 0f 00 00 00       	mov    $0xf,%esi
  8002ca:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
  8002d1:	00 00 00 
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  8002e0:	00 00 00 
  8002e3:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8002e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f3:	be 0c 00 00 00       	mov    $0xc,%esi
  8002f8:	89 c7                	mov    %eax,%edi
  8002fa:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800306:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	be 00 00 00 00       	mov    $0x0,%esi
  800314:	48 89 c7             	mov    %rax,%rdi
  800317:	48 b8 80 1f 80 00 00 	movabs $0x801f80,%rax
  80031e:	00 00 00 
  800321:	ff d0                	callq  *%rax
  800323:	89 45 f4             	mov    %eax,-0xc(%rbp)

            if (whom != ns_envid) {
  800326:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800329:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032c:	39 c2                	cmp    %eax,%edx
  80032e:	74 22                	je     800352 <timer+0x108>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800330:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800333:	89 c6                	mov    %eax,%esi
  800335:	48 bf 90 41 80 00 00 	movabs $0x804190,%rdi
  80033c:	00 00 00 
  80033f:	b8 00 00 00 00       	mov    $0x0,%eax
  800344:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  80034b:	00 00 00 
  80034e:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  800350:	eb b4                	jmp    800306 <timer+0xbc>
            stop = sys_time_msec() + to;
  800352:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 c2                	mov    %eax,%edx
  800360:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	89 45 fc             	mov    %eax,-0x4(%rbp)
    }
  800368:	e9 18 ff ff ff       	jmpq   800285 <timer+0x3b>

000000000080036d <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  80036d:	55                   	push   %rbp
  80036e:	48 89 e5             	mov    %rsp,%rbp
  800371:	48 83 ec 08          	sub    $0x8,%rsp
  800375:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_input";
  800378:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80037f:	00 00 00 
  800382:	48 ba cb 41 80 00 00 	movabs $0x8041cb,%rdx
  800389:	00 00 00 
  80038c:	48 89 10             	mov    %rdx,(%rax)
    // 	- read a packet from the device driver
    //	- send it to the network server
    // Hint: When you IPC a page to the network server, it will be
    // reading from it for a while, so don't immediately receive
    // another packet in to the same physical page.
}
  80038f:	c9                   	leaveq 
  800390:	c3                   	retq   

0000000000800391 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800391:	55                   	push   %rbp
  800392:	48 89 e5             	mov    %rsp,%rbp
  800395:	48 83 ec 08          	sub    $0x8,%rsp
  800399:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_output";
  80039c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003a3:	00 00 00 
  8003a6:	48 ba d4 41 80 00 00 	movabs $0x8041d4,%rdx
  8003ad:	00 00 00 
  8003b0:	48 89 10             	mov    %rdx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
}
  8003b3:	c9                   	leaveq 
  8003b4:	c3                   	retq   

00000000008003b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003b5:	55                   	push   %rbp
  8003b6:	48 89 e5             	mov    %rsp,%rbp
  8003b9:	48 83 ec 10          	sub    $0x10,%rsp
  8003bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8003c4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003cb:	00 00 00 
  8003ce:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003d9:	7e 14                	jle    8003ef <libmain+0x3a>
		binaryname = argv[0];
  8003db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003df:	48 8b 10             	mov    (%rax),%rdx
  8003e2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003e9:	00 00 00 
  8003ec:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f6:	48 89 d6             	mov    %rdx,%rsi
  8003f9:	89 c7                	mov    %eax,%edi
  8003fb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800407:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  80040e:	00 00 00 
  800411:	ff d0                	callq  *%rax
}
  800413:	c9                   	leaveq 
  800414:	c3                   	retq   

0000000000800415 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800419:	48 b8 00 25 80 00 00 	movabs $0x802500,%rax
  800420:	00 00 00 
  800423:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800425:	bf 00 00 00 00       	mov    $0x0,%edi
  80042a:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  800431:	00 00 00 
  800434:	ff d0                	callq  *%rax
}
  800436:	5d                   	pop    %rbp
  800437:	c3                   	retq   

0000000000800438 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800438:	55                   	push   %rbp
  800439:	48 89 e5             	mov    %rsp,%rbp
  80043c:	53                   	push   %rbx
  80043d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800444:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80044b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800451:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800458:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80045f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800466:	84 c0                	test   %al,%al
  800468:	74 23                	je     80048d <_panic+0x55>
  80046a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800471:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800475:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800479:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80047d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800481:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800485:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800489:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80048d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800494:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80049b:	00 00 00 
  80049e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004a5:	00 00 00 
  8004a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004ac:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004b3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8004c8:	00 00 00 
  8004cb:	48 8b 18             	mov    (%rax),%rbx
  8004ce:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  8004d5:	00 00 00 
  8004d8:	ff d0                	callq  *%rax
  8004da:	89 c6                	mov    %eax,%esi
  8004dc:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8004e2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004e9:	41 89 d0             	mov    %edx,%r8d
  8004ec:	48 89 c1             	mov    %rax,%rcx
  8004ef:	48 89 da             	mov    %rbx,%rdx
  8004f2:	48 bf e8 41 80 00 00 	movabs $0x8041e8,%rdi
  8004f9:	00 00 00 
  8004fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800501:	49 b9 71 06 80 00 00 	movabs $0x800671,%r9
  800508:	00 00 00 
  80050b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80050e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800515:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80051c:	48 89 d6             	mov    %rdx,%rsi
  80051f:	48 89 c7             	mov    %rax,%rdi
  800522:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  800529:	00 00 00 
  80052c:	ff d0                	callq  *%rax
	cprintf("\n");
  80052e:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  800535:	00 00 00 
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  800544:	00 00 00 
  800547:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800549:	cc                   	int3   
  80054a:	eb fd                	jmp    800549 <_panic+0x111>

000000000080054c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80054c:	55                   	push   %rbp
  80054d:	48 89 e5             	mov    %rsp,%rbp
  800550:	48 83 ec 10          	sub    $0x10,%rsp
  800554:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800557:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80055b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055f:	8b 00                	mov    (%rax),%eax
  800561:	8d 48 01             	lea    0x1(%rax),%ecx
  800564:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800568:	89 0a                	mov    %ecx,(%rdx)
  80056a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80056d:	89 d1                	mov    %edx,%ecx
  80056f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800573:	48 98                	cltq   
  800575:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800584:	75 2c                	jne    8005b2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058a:	8b 00                	mov    (%rax),%eax
  80058c:	48 98                	cltq   
  80058e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800592:	48 83 c2 08          	add    $0x8,%rdx
  800596:	48 89 c6             	mov    %rax,%rsi
  800599:	48 89 d7             	mov    %rdx,%rdi
  80059c:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  8005a3:	00 00 00 
  8005a6:	ff d0                	callq  *%rax
        b->idx = 0;
  8005a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b6:	8b 40 04             	mov    0x4(%rax),%eax
  8005b9:	8d 50 01             	lea    0x1(%rax),%edx
  8005bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005c3:	c9                   	leaveq 
  8005c4:	c3                   	retq   

00000000008005c5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005c5:	55                   	push   %rbp
  8005c6:	48 89 e5             	mov    %rsp,%rbp
  8005c9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005d7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005de:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005e5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005ec:	48 8b 0a             	mov    (%rdx),%rcx
  8005ef:	48 89 08             	mov    %rcx,(%rax)
  8005f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800602:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800609:	00 00 00 
    b.cnt = 0;
  80060c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800613:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800616:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80061d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800624:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80062b:	48 89 c6             	mov    %rax,%rsi
  80062e:	48 bf 4c 05 80 00 00 	movabs $0x80054c,%rdi
  800635:	00 00 00 
  800638:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  80063f:	00 00 00 
  800642:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800644:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80064a:	48 98                	cltq   
  80064c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800653:	48 83 c2 08          	add    $0x8,%rdx
  800657:	48 89 c6             	mov    %rax,%rsi
  80065a:	48 89 d7             	mov    %rdx,%rdi
  80065d:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  800664:	00 00 00 
  800667:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800669:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80066f:	c9                   	leaveq 
  800670:	c3                   	retq   

0000000000800671 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800671:	55                   	push   %rbp
  800672:	48 89 e5             	mov    %rsp,%rbp
  800675:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80067c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800683:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80068a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800691:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800698:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80069f:	84 c0                	test   %al,%al
  8006a1:	74 20                	je     8006c3 <cprintf+0x52>
  8006a3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006a7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006ab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006af:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006b3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006b7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006bb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006bf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006c3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006ca:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006d1:	00 00 00 
  8006d4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006db:	00 00 00 
  8006de:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006e2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006e9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006f7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006fe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800705:	48 8b 0a             	mov    (%rdx),%rcx
  800708:	48 89 08             	mov    %rcx,(%rax)
  80070b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80070f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800713:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800717:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80071b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800722:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800729:	48 89 d6             	mov    %rdx,%rsi
  80072c:	48 89 c7             	mov    %rax,%rdi
  80072f:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  800736:	00 00 00 
  800739:	ff d0                	callq  *%rax
  80073b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800741:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800747:	c9                   	leaveq 
  800748:	c3                   	retq   

0000000000800749 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800749:	55                   	push   %rbp
  80074a:	48 89 e5             	mov    %rsp,%rbp
  80074d:	48 83 ec 30          	sub    $0x30,%rsp
  800751:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800755:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800759:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80075d:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800760:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800764:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800768:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80076b:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80076f:	77 42                	ja     8007b3 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800771:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800774:	8d 78 ff             	lea    -0x1(%rax),%edi
  800777:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	48 f7 f6             	div    %rsi
  800786:	49 89 c2             	mov    %rax,%r10
  800789:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80078c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80078f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800797:	41 89 c9             	mov    %ecx,%r9d
  80079a:	41 89 f8             	mov    %edi,%r8d
  80079d:	89 d1                	mov    %edx,%ecx
  80079f:	4c 89 d2             	mov    %r10,%rdx
  8007a2:	48 89 c7             	mov    %rax,%rdi
  8007a5:	48 b8 49 07 80 00 00 	movabs $0x800749,%rax
  8007ac:	00 00 00 
  8007af:	ff d0                	callq  *%rax
  8007b1:	eb 1e                	jmp    8007d1 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b3:	eb 12                	jmp    8007c7 <printnum+0x7e>
			putch(padc, putdat);
  8007b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007b9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8007bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007c0:	48 89 ce             	mov    %rcx,%rsi
  8007c3:	89 d7                	mov    %edx,%edi
  8007c5:	ff d0                	callq  *%rax
		while (--width > 0)
  8007c7:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8007cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8007cf:	7f e4                	jg     8007b5 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007d1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	48 f7 f1             	div    %rcx
  8007e0:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  8007e7:	00 00 00 
  8007ea:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8007ee:	0f be d0             	movsbl %al,%edx
  8007f1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007f9:	48 89 ce             	mov    %rcx,%rsi
  8007fc:	89 d7                	mov    %edx,%edi
  8007fe:	ff d0                	callq  *%rax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 20          	sub    $0x20,%rsp
  80080a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80080e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800811:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800815:	7e 4f                	jle    800866 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	8b 00                	mov    (%rax),%eax
  80081d:	83 f8 30             	cmp    $0x30,%eax
  800820:	73 24                	jae    800846 <getuint+0x44>
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	8b 00                	mov    (%rax),%eax
  800830:	89 c0                	mov    %eax,%eax
  800832:	48 01 d0             	add    %rdx,%rax
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	8b 12                	mov    (%rdx),%edx
  80083b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	89 0a                	mov    %ecx,(%rdx)
  800844:	eb 14                	jmp    80085a <getuint+0x58>
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80084e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800852:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800856:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085a:	48 8b 00             	mov    (%rax),%rax
  80085d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800861:	e9 9d 00 00 00       	jmpq   800903 <getuint+0x101>
	else if (lflag)
  800866:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80086a:	74 4c                	je     8008b8 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	8b 00                	mov    (%rax),%eax
  800872:	83 f8 30             	cmp    $0x30,%eax
  800875:	73 24                	jae    80089b <getuint+0x99>
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800883:	8b 00                	mov    (%rax),%eax
  800885:	89 c0                	mov    %eax,%eax
  800887:	48 01 d0             	add    %rdx,%rax
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	8b 12                	mov    (%rdx),%edx
  800890:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800893:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800897:	89 0a                	mov    %ecx,(%rdx)
  800899:	eb 14                	jmp    8008af <getuint+0xad>
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008a3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008af:	48 8b 00             	mov    (%rax),%rax
  8008b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b6:	eb 4b                	jmp    800903 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	83 f8 30             	cmp    $0x30,%eax
  8008c1:	73 24                	jae    8008e7 <getuint+0xe5>
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cf:	8b 00                	mov    (%rax),%eax
  8008d1:	89 c0                	mov    %eax,%eax
  8008d3:	48 01 d0             	add    %rdx,%rax
  8008d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008da:	8b 12                	mov    (%rdx),%edx
  8008dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e3:	89 0a                	mov    %ecx,(%rdx)
  8008e5:	eb 14                	jmp    8008fb <getuint+0xf9>
  8008e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008ef:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008fb:	8b 00                	mov    (%rax),%eax
  8008fd:	89 c0                	mov    %eax,%eax
  8008ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800907:	c9                   	leaveq 
  800908:	c3                   	retq   

0000000000800909 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800909:	55                   	push   %rbp
  80090a:	48 89 e5             	mov    %rsp,%rbp
  80090d:	48 83 ec 20          	sub    $0x20,%rsp
  800911:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800915:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800918:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091c:	7e 4f                	jle    80096d <getint+0x64>
		x=va_arg(*ap, long long);
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	8b 00                	mov    (%rax),%eax
  800924:	83 f8 30             	cmp    $0x30,%eax
  800927:	73 24                	jae    80094d <getint+0x44>
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	8b 00                	mov    (%rax),%eax
  800937:	89 c0                	mov    %eax,%eax
  800939:	48 01 d0             	add    %rdx,%rax
  80093c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800940:	8b 12                	mov    (%rdx),%edx
  800942:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800945:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800949:	89 0a                	mov    %ecx,(%rdx)
  80094b:	eb 14                	jmp    800961 <getint+0x58>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 40 08          	mov    0x8(%rax),%rax
  800955:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800961:	48 8b 00             	mov    (%rax),%rax
  800964:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800968:	e9 9d 00 00 00       	jmpq   800a0a <getint+0x101>
	else if (lflag)
  80096d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800971:	74 4c                	je     8009bf <getint+0xb6>
		x=va_arg(*ap, long);
  800973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800977:	8b 00                	mov    (%rax),%eax
  800979:	83 f8 30             	cmp    $0x30,%eax
  80097c:	73 24                	jae    8009a2 <getint+0x99>
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	89 c0                	mov    %eax,%eax
  80098e:	48 01 d0             	add    %rdx,%rax
  800991:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800995:	8b 12                	mov    (%rdx),%edx
  800997:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099e:	89 0a                	mov    %ecx,(%rdx)
  8009a0:	eb 14                	jmp    8009b6 <getint+0xad>
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b6:	48 8b 00             	mov    (%rax),%rax
  8009b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009bd:	eb 4b                	jmp    800a0a <getint+0x101>
	else
		x=va_arg(*ap, int);
  8009bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c3:	8b 00                	mov    (%rax),%eax
  8009c5:	83 f8 30             	cmp    $0x30,%eax
  8009c8:	73 24                	jae    8009ee <getint+0xe5>
  8009ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d6:	8b 00                	mov    (%rax),%eax
  8009d8:	89 c0                	mov    %eax,%eax
  8009da:	48 01 d0             	add    %rdx,%rax
  8009dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e1:	8b 12                	mov    (%rdx),%edx
  8009e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ea:	89 0a                	mov    %ecx,(%rdx)
  8009ec:	eb 14                	jmp    800a02 <getint+0xf9>
  8009ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009f6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	48 98                	cltq   
  800a06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a0e:	c9                   	leaveq 
  800a0f:	c3                   	retq   

0000000000800a10 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a10:	55                   	push   %rbp
  800a11:	48 89 e5             	mov    %rsp,%rbp
  800a14:	41 54                	push   %r12
  800a16:	53                   	push   %rbx
  800a17:	48 83 ec 60          	sub    $0x60,%rsp
  800a1b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a1f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a23:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a27:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a2b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a2f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a33:	48 8b 0a             	mov    (%rdx),%rcx
  800a36:	48 89 08             	mov    %rcx,(%rax)
  800a39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a49:	eb 17                	jmp    800a62 <vprintfmt+0x52>
			if (ch == '\0')
  800a4b:	85 db                	test   %ebx,%ebx
  800a4d:	0f 84 c5 04 00 00    	je     800f18 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800a53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5b:	48 89 d6             	mov    %rdx,%rsi
  800a5e:	89 df                	mov    %ebx,%edi
  800a60:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a62:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a66:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6e:	0f b6 00             	movzbl (%rax),%eax
  800a71:	0f b6 d8             	movzbl %al,%ebx
  800a74:	83 fb 25             	cmp    $0x25,%ebx
  800a77:	75 d2                	jne    800a4b <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800a79:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a7d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a84:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a8b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a92:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a99:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a9d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aa5:	0f b6 00             	movzbl (%rax),%eax
  800aa8:	0f b6 d8             	movzbl %al,%ebx
  800aab:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800aae:	83 f8 55             	cmp    $0x55,%eax
  800ab1:	0f 87 2e 04 00 00    	ja     800ee5 <vprintfmt+0x4d5>
  800ab7:	89 c0                	mov    %eax,%eax
  800ab9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac0:	00 
  800ac1:	48 b8 58 44 80 00 00 	movabs $0x804458,%rax
  800ac8:	00 00 00 
  800acb:	48 01 d0             	add    %rdx,%rax
  800ace:	48 8b 00             	mov    (%rax),%rax
  800ad1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ad3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ad7:	eb c0                	jmp    800a99 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ad9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800add:	eb ba                	jmp    800a99 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800adf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ae6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ae9:	89 d0                	mov    %edx,%eax
  800aeb:	c1 e0 02             	shl    $0x2,%eax
  800aee:	01 d0                	add    %edx,%eax
  800af0:	01 c0                	add    %eax,%eax
  800af2:	01 d8                	add    %ebx,%eax
  800af4:	83 e8 30             	sub    $0x30,%eax
  800af7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800afa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800afe:	0f b6 00             	movzbl (%rax),%eax
  800b01:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b04:	83 fb 2f             	cmp    $0x2f,%ebx
  800b07:	7e 0c                	jle    800b15 <vprintfmt+0x105>
  800b09:	83 fb 39             	cmp    $0x39,%ebx
  800b0c:	7f 07                	jg     800b15 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800b0e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800b13:	eb d1                	jmp    800ae6 <vprintfmt+0xd6>
			goto process_precision;
  800b15:	eb 50                	jmp    800b67 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	83 f8 30             	cmp    $0x30,%eax
  800b1d:	73 17                	jae    800b36 <vprintfmt+0x126>
  800b1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b23:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b26:	89 d2                	mov    %edx,%edx
  800b28:	48 01 d0             	add    %rdx,%rax
  800b2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2e:	83 c2 08             	add    $0x8,%edx
  800b31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b34:	eb 0c                	jmp    800b42 <vprintfmt+0x132>
  800b36:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b3a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b42:	8b 00                	mov    (%rax),%eax
  800b44:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b47:	eb 1e                	jmp    800b67 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4d:	79 07                	jns    800b56 <vprintfmt+0x146>
				width = 0;
  800b4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b56:	e9 3e ff ff ff       	jmpq   800a99 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b5b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b62:	e9 32 ff ff ff       	jmpq   800a99 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b67:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6b:	79 0d                	jns    800b7a <vprintfmt+0x16a>
				width = precision, precision = -1;
  800b6d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b70:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b73:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b7a:	e9 1a ff ff ff       	jmpq   800a99 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b7f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b83:	e9 11 ff ff ff       	jmpq   800a99 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8b:	83 f8 30             	cmp    $0x30,%eax
  800b8e:	73 17                	jae    800ba7 <vprintfmt+0x197>
  800b90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b94:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b97:	89 d2                	mov    %edx,%edx
  800b99:	48 01 d0             	add    %rdx,%rax
  800b9c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9f:	83 c2 08             	add    $0x8,%edx
  800ba2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ba5:	eb 0c                	jmp    800bb3 <vprintfmt+0x1a3>
  800ba7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bab:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800baf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb3:	8b 10                	mov    (%rax),%edx
  800bb5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbd:	48 89 ce             	mov    %rcx,%rsi
  800bc0:	89 d7                	mov    %edx,%edi
  800bc2:	ff d0                	callq  *%rax
			break;
  800bc4:	e9 4a 03 00 00       	jmpq   800f13 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	83 f8 30             	cmp    $0x30,%eax
  800bcf:	73 17                	jae    800be8 <vprintfmt+0x1d8>
  800bd1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bd5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd8:	89 d2                	mov    %edx,%edx
  800bda:	48 01 d0             	add    %rdx,%rax
  800bdd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800be0:	83 c2 08             	add    $0x8,%edx
  800be3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be6:	eb 0c                	jmp    800bf4 <vprintfmt+0x1e4>
  800be8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bec:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bf0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf6:	85 db                	test   %ebx,%ebx
  800bf8:	79 02                	jns    800bfc <vprintfmt+0x1ec>
				err = -err;
  800bfa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bfc:	83 fb 15             	cmp    $0x15,%ebx
  800bff:	7f 16                	jg     800c17 <vprintfmt+0x207>
  800c01:	48 b8 80 43 80 00 00 	movabs $0x804380,%rax
  800c08:	00 00 00 
  800c0b:	48 63 d3             	movslq %ebx,%rdx
  800c0e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c12:	4d 85 e4             	test   %r12,%r12
  800c15:	75 2e                	jne    800c45 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800c17:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1f:	89 d9                	mov    %ebx,%ecx
  800c21:	48 ba 41 44 80 00 00 	movabs $0x804441,%rdx
  800c28:	00 00 00 
  800c2b:	48 89 c7             	mov    %rax,%rdi
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c33:	49 b8 21 0f 80 00 00 	movabs $0x800f21,%r8
  800c3a:	00 00 00 
  800c3d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c40:	e9 ce 02 00 00       	jmpq   800f13 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800c45:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4d:	4c 89 e1             	mov    %r12,%rcx
  800c50:	48 ba 4a 44 80 00 00 	movabs $0x80444a,%rdx
  800c57:	00 00 00 
  800c5a:	48 89 c7             	mov    %rax,%rdi
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	49 b8 21 0f 80 00 00 	movabs $0x800f21,%r8
  800c69:	00 00 00 
  800c6c:	41 ff d0             	callq  *%r8
			break;
  800c6f:	e9 9f 02 00 00       	jmpq   800f13 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	83 f8 30             	cmp    $0x30,%eax
  800c7a:	73 17                	jae    800c93 <vprintfmt+0x283>
  800c7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c80:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c83:	89 d2                	mov    %edx,%edx
  800c85:	48 01 d0             	add    %rdx,%rax
  800c88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8b:	83 c2 08             	add    $0x8,%edx
  800c8e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c91:	eb 0c                	jmp    800c9f <vprintfmt+0x28f>
  800c93:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c97:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9f:	4c 8b 20             	mov    (%rax),%r12
  800ca2:	4d 85 e4             	test   %r12,%r12
  800ca5:	75 0a                	jne    800cb1 <vprintfmt+0x2a1>
				p = "(null)";
  800ca7:	49 bc 4d 44 80 00 00 	movabs $0x80444d,%r12
  800cae:	00 00 00 
			if (width > 0 && padc != '-')
  800cb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb5:	7e 3f                	jle    800cf6 <vprintfmt+0x2e6>
  800cb7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cbb:	74 39                	je     800cf6 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cc0:	48 98                	cltq   
  800cc2:	48 89 c6             	mov    %rax,%rsi
  800cc5:	4c 89 e7             	mov    %r12,%rdi
  800cc8:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  800ccf:	00 00 00 
  800cd2:	ff d0                	callq  *%rax
  800cd4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd7:	eb 17                	jmp    800cf0 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800cd9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cdd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ce1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce5:	48 89 ce             	mov    %rcx,%rsi
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800cec:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf4:	7f e3                	jg     800cd9 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf6:	eb 37                	jmp    800d2f <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cfc:	74 1e                	je     800d1c <vprintfmt+0x30c>
  800cfe:	83 fb 1f             	cmp    $0x1f,%ebx
  800d01:	7e 05                	jle    800d08 <vprintfmt+0x2f8>
  800d03:	83 fb 7e             	cmp    $0x7e,%ebx
  800d06:	7e 14                	jle    800d1c <vprintfmt+0x30c>
					putch('?', putdat);
  800d08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d10:	48 89 d6             	mov    %rdx,%rsi
  800d13:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d18:	ff d0                	callq  *%rax
  800d1a:	eb 0f                	jmp    800d2b <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800d1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d24:	48 89 d6             	mov    %rdx,%rsi
  800d27:	89 df                	mov    %ebx,%edi
  800d29:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d2f:	4c 89 e0             	mov    %r12,%rax
  800d32:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d36:	0f b6 00             	movzbl (%rax),%eax
  800d39:	0f be d8             	movsbl %al,%ebx
  800d3c:	85 db                	test   %ebx,%ebx
  800d3e:	74 10                	je     800d50 <vprintfmt+0x340>
  800d40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d44:	78 b2                	js     800cf8 <vprintfmt+0x2e8>
  800d46:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4e:	79 a8                	jns    800cf8 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800d50:	eb 16                	jmp    800d68 <vprintfmt+0x358>
				putch(' ', putdat);
  800d52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5a:	48 89 d6             	mov    %rdx,%rsi
  800d5d:	bf 20 00 00 00       	mov    $0x20,%edi
  800d62:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800d64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6c:	7f e4                	jg     800d52 <vprintfmt+0x342>
			break;
  800d6e:	e9 a0 01 00 00       	jmpq   800f13 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d77:	be 03 00 00 00       	mov    $0x3,%esi
  800d7c:	48 89 c7             	mov    %rax,%rdi
  800d7f:	48 b8 09 09 80 00 00 	movabs $0x800909,%rax
  800d86:	00 00 00 
  800d89:	ff d0                	callq  *%rax
  800d8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d93:	48 85 c0             	test   %rax,%rax
  800d96:	79 1d                	jns    800db5 <vprintfmt+0x3a5>
				putch('-', putdat);
  800d98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da0:	48 89 d6             	mov    %rdx,%rsi
  800da3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800daa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dae:	48 f7 d8             	neg    %rax
  800db1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbc:	e9 e5 00 00 00       	jmpq   800ea6 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc5:	be 03 00 00 00       	mov    $0x3,%esi
  800dca:	48 89 c7             	mov    %rax,%rdi
  800dcd:	48 b8 02 08 80 00 00 	movabs $0x800802,%rax
  800dd4:	00 00 00 
  800dd7:	ff d0                	callq  *%rax
  800dd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ddd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de4:	e9 bd 00 00 00       	jmpq   800ea6 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800de9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ded:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df1:	48 89 d6             	mov    %rdx,%rsi
  800df4:	bf 58 00 00 00       	mov    $0x58,%edi
  800df9:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e03:	48 89 d6             	mov    %rdx,%rsi
  800e06:	bf 58 00 00 00       	mov    $0x58,%edi
  800e0b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e15:	48 89 d6             	mov    %rdx,%rsi
  800e18:	bf 58 00 00 00       	mov    $0x58,%edi
  800e1d:	ff d0                	callq  *%rax
			break;
  800e1f:	e9 ef 00 00 00       	jmpq   800f13 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800e24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2c:	48 89 d6             	mov    %rdx,%rsi
  800e2f:	bf 30 00 00 00       	mov    $0x30,%edi
  800e34:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3e:	48 89 d6             	mov    %rdx,%rsi
  800e41:	bf 78 00 00 00       	mov    $0x78,%edi
  800e46:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4b:	83 f8 30             	cmp    $0x30,%eax
  800e4e:	73 17                	jae    800e67 <vprintfmt+0x457>
  800e50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e57:	89 d2                	mov    %edx,%edx
  800e59:	48 01 d0             	add    %rdx,%rax
  800e5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5f:	83 c2 08             	add    $0x8,%edx
  800e62:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800e65:	eb 0c                	jmp    800e73 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800e67:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e6b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e73:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800e76:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e7a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e81:	eb 23                	jmp    800ea6 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e83:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e87:	be 03 00 00 00       	mov    $0x3,%esi
  800e8c:	48 89 c7             	mov    %rax,%rdi
  800e8f:	48 b8 02 08 80 00 00 	movabs $0x800802,%rax
  800e96:	00 00 00 
  800e99:	ff d0                	callq  *%rax
  800e9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e9f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eab:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eae:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebd:	45 89 c1             	mov    %r8d,%r9d
  800ec0:	41 89 f8             	mov    %edi,%r8d
  800ec3:	48 89 c7             	mov    %rax,%rdi
  800ec6:	48 b8 49 07 80 00 00 	movabs $0x800749,%rax
  800ecd:	00 00 00 
  800ed0:	ff d0                	callq  *%rax
			break;
  800ed2:	eb 3f                	jmp    800f13 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ed4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edc:	48 89 d6             	mov    %rdx,%rsi
  800edf:	89 df                	mov    %ebx,%edi
  800ee1:	ff d0                	callq  *%rax
			break;
  800ee3:	eb 2e                	jmp    800f13 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eed:	48 89 d6             	mov    %rdx,%rsi
  800ef0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ef5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800efc:	eb 05                	jmp    800f03 <vprintfmt+0x4f3>
  800efe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f03:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f07:	48 83 e8 01          	sub    $0x1,%rax
  800f0b:	0f b6 00             	movzbl (%rax),%eax
  800f0e:	3c 25                	cmp    $0x25,%al
  800f10:	75 ec                	jne    800efe <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800f12:	90                   	nop
		}
	}
  800f13:	e9 31 fb ff ff       	jmpq   800a49 <vprintfmt+0x39>
	va_end(aq);
}
  800f18:	48 83 c4 60          	add    $0x60,%rsp
  800f1c:	5b                   	pop    %rbx
  800f1d:	41 5c                	pop    %r12
  800f1f:	5d                   	pop    %rbp
  800f20:	c3                   	retq   

0000000000800f21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f21:	55                   	push   %rbp
  800f22:	48 89 e5             	mov    %rsp,%rbp
  800f25:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f2c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4f:	84 c0                	test   %al,%al
  800f51:	74 20                	je     800f73 <printfmt+0x52>
  800f53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f73:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f7a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f81:	00 00 00 
  800f84:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f8b:	00 00 00 
  800f8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fa7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fb5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fbc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fc3:	48 89 c7             	mov    %rax,%rdi
  800fc6:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  800fcd:	00 00 00 
  800fd0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fd2:	c9                   	leaveq 
  800fd3:	c3                   	retq   

0000000000800fd4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd4:	55                   	push   %rbp
  800fd5:	48 89 e5             	mov    %rsp,%rbp
  800fd8:	48 83 ec 10          	sub    $0x10,%rsp
  800fdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe7:	8b 40 10             	mov    0x10(%rax),%eax
  800fea:	8d 50 01             	lea    0x1(%rax),%edx
  800fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff8:	48 8b 10             	mov    (%rax),%rdx
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 8b 40 08          	mov    0x8(%rax),%rax
  801003:	48 39 c2             	cmp    %rax,%rdx
  801006:	73 17                	jae    80101f <sprintputch+0x4b>
		*b->buf++ = ch;
  801008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100c:	48 8b 00             	mov    (%rax),%rax
  80100f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801013:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801017:	48 89 0a             	mov    %rcx,(%rdx)
  80101a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80101d:	88 10                	mov    %dl,(%rax)
}
  80101f:	c9                   	leaveq 
  801020:	c3                   	retq   

0000000000801021 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
  801025:	48 83 ec 50          	sub    $0x50,%rsp
  801029:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80102d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801030:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801034:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801038:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80103c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801040:	48 8b 0a             	mov    (%rdx),%rcx
  801043:	48 89 08             	mov    %rcx,(%rax)
  801046:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80104e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801052:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801056:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80105a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80105e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801061:	48 98                	cltq   
  801063:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801067:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80106b:	48 01 d0             	add    %rdx,%rax
  80106e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801072:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801079:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80107e:	74 06                	je     801086 <vsnprintf+0x65>
  801080:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801084:	7f 07                	jg     80108d <vsnprintf+0x6c>
		return -E_INVAL;
  801086:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108b:	eb 2f                	jmp    8010bc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80108d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801091:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801095:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801099:	48 89 c6             	mov    %rax,%rsi
  80109c:	48 bf d4 0f 80 00 00 	movabs $0x800fd4,%rdi
  8010a3:	00 00 00 
  8010a6:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  8010ad:	00 00 00 
  8010b0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010b6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010b9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010bc:	c9                   	leaveq 
  8010bd:	c3                   	retq   

00000000008010be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010be:	55                   	push   %rbp
  8010bf:	48 89 e5             	mov    %rsp,%rbp
  8010c2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010eb:	84 c0                	test   %al,%al
  8010ed:	74 20                	je     80110f <snprintf+0x51>
  8010ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801103:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801107:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80110b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80110f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801116:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80111d:	00 00 00 
  801120:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801127:	00 00 00 
  80112a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80112e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801135:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80113c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801143:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80114a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801151:	48 8b 0a             	mov    (%rdx),%rcx
  801154:	48 89 08             	mov    %rcx,(%rax)
  801157:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80115b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80115f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801163:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801167:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80116e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801175:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80117b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801182:	48 89 c7             	mov    %rax,%rdi
  801185:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801197:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 18          	sub    $0x18,%rsp
  8011a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b2:	eb 09                	jmp    8011bd <strlen+0x1e>
		n++;
  8011b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8011b8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	0f b6 00             	movzbl (%rax),%eax
  8011c4:	84 c0                	test   %al,%al
  8011c6:	75 ec                	jne    8011b4 <strlen+0x15>
	return n;
  8011c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 20          	sub    $0x20,%rsp
  8011d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011e4:	eb 0e                	jmp    8011f4 <strnlen+0x27>
		n++;
  8011e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ef:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011f4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011f9:	74 0b                	je     801206 <strnlen+0x39>
  8011fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ff:	0f b6 00             	movzbl (%rax),%eax
  801202:	84 c0                	test   %al,%al
  801204:	75 e0                	jne    8011e6 <strnlen+0x19>
	return n;
  801206:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 20          	sub    $0x20,%rsp
  801213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801217:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80121b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801223:	90                   	nop
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801230:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801234:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801238:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80123c:	0f b6 12             	movzbl (%rdx),%edx
  80123f:	88 10                	mov    %dl,(%rax)
  801241:	0f b6 00             	movzbl (%rax),%eax
  801244:	84 c0                	test   %al,%al
  801246:	75 dc                	jne    801224 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80124c:	c9                   	leaveq 
  80124d:	c3                   	retq   

000000000080124e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80124e:	55                   	push   %rbp
  80124f:	48 89 e5             	mov    %rsp,%rbp
  801252:	48 83 ec 20          	sub    $0x20,%rsp
  801256:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80125e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801262:	48 89 c7             	mov    %rax,%rdi
  801265:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  80126c:	00 00 00 
  80126f:	ff d0                	callq  *%rax
  801271:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801277:	48 63 d0             	movslq %eax,%rdx
  80127a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127e:	48 01 c2             	add    %rax,%rdx
  801281:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801285:	48 89 c6             	mov    %rax,%rsi
  801288:	48 89 d7             	mov    %rdx,%rdi
  80128b:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
	return dst;
  801297:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 28          	sub    $0x28,%rsp
  8012a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c0:	00 
  8012c1:	eb 2a                	jmp    8012ed <strncpy+0x50>
		*dst++ = *src;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d3:	0f b6 12             	movzbl (%rdx),%edx
  8012d6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	84 c0                	test   %al,%al
  8012e1:	74 05                	je     8012e8 <strncpy+0x4b>
			src++;
  8012e3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012f5:	72 cc                	jb     8012c3 <strncpy+0x26>
	}
	return ret;
  8012f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012fb:	c9                   	leaveq 
  8012fc:	c3                   	retq   

00000000008012fd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
  801301:	48 83 ec 28          	sub    $0x28,%rsp
  801305:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801309:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80130d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801319:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80131e:	74 3d                	je     80135d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801320:	eb 1d                	jmp    80133f <strlcpy+0x42>
			*dst++ = *src++;
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80132e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801332:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801336:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80133a:	0f b6 12             	movzbl (%rdx),%edx
  80133d:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80133f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801344:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801349:	74 0b                	je     801356 <strlcpy+0x59>
  80134b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	75 cc                	jne    801322 <strlcpy+0x25>
		*dst = '\0';
  801356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80135d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	48 29 c2             	sub    %rax,%rdx
  801368:	48 89 d0             	mov    %rdx,%rax
}
  80136b:	c9                   	leaveq 
  80136c:	c3                   	retq   

000000000080136d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136d:	55                   	push   %rbp
  80136e:	48 89 e5             	mov    %rsp,%rbp
  801371:	48 83 ec 10          	sub    $0x10,%rsp
  801375:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801379:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80137d:	eb 0a                	jmp    801389 <strcmp+0x1c>
		p++, q++;
  80137f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801384:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	84 c0                	test   %al,%al
  801392:	74 12                	je     8013a6 <strcmp+0x39>
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 10             	movzbl (%rax),%edx
  80139b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139f:	0f b6 00             	movzbl (%rax),%eax
  8013a2:	38 c2                	cmp    %al,%dl
  8013a4:	74 d9                	je     80137f <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	0f b6 d0             	movzbl %al,%edx
  8013b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b4:	0f b6 00             	movzbl (%rax),%eax
  8013b7:	0f b6 c0             	movzbl %al,%eax
  8013ba:	29 c2                	sub    %eax,%edx
  8013bc:	89 d0                	mov    %edx,%eax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	48 83 ec 18          	sub    $0x18,%rsp
  8013c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013d4:	eb 0f                	jmp    8013e5 <strncmp+0x25>
		n--, p++, q++;
  8013d6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8013e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ea:	74 1d                	je     801409 <strncmp+0x49>
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	84 c0                	test   %al,%al
  8013f5:	74 12                	je     801409 <strncmp+0x49>
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	0f b6 10             	movzbl (%rax),%edx
  8013fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	38 c2                	cmp    %al,%dl
  801407:	74 cd                	je     8013d6 <strncmp+0x16>
	if (n == 0)
  801409:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140e:	75 07                	jne    801417 <strncmp+0x57>
		return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	eb 18                	jmp    80142f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	0f b6 d0             	movzbl %al,%edx
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	0f b6 c0             	movzbl %al,%eax
  80142b:	29 c2                	sub    %eax,%edx
  80142d:	89 d0                	mov    %edx,%eax
}
  80142f:	c9                   	leaveq 
  801430:	c3                   	retq   

0000000000801431 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801431:	55                   	push   %rbp
  801432:	48 89 e5             	mov    %rsp,%rbp
  801435:	48 83 ec 10          	sub    $0x10,%rsp
  801439:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143d:	89 f0                	mov    %esi,%eax
  80143f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801442:	eb 17                	jmp    80145b <strchr+0x2a>
		if (*s == c)
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80144e:	75 06                	jne    801456 <strchr+0x25>
			return (char *) s;
  801450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801454:	eb 15                	jmp    80146b <strchr+0x3a>
	for (; *s; s++)
  801456:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	84 c0                	test   %al,%al
  801464:	75 de                	jne    801444 <strchr+0x13>
	return 0;
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146b:	c9                   	leaveq 
  80146c:	c3                   	retq   

000000000080146d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80146d:	55                   	push   %rbp
  80146e:	48 89 e5             	mov    %rsp,%rbp
  801471:	48 83 ec 10          	sub    $0x10,%rsp
  801475:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801479:	89 f0                	mov    %esi,%eax
  80147b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80147e:	eb 13                	jmp    801493 <strfind+0x26>
		if (*s == c)
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	0f b6 00             	movzbl (%rax),%eax
  801487:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80148a:	75 02                	jne    80148e <strfind+0x21>
			break;
  80148c:	eb 10                	jmp    80149e <strfind+0x31>
	for (; *s; s++)
  80148e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	84 c0                	test   %al,%al
  80149c:	75 e2                	jne    801480 <strfind+0x13>
	return (char *) s;
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 18          	sub    $0x18,%rsp
  8014ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014bc:	75 06                	jne    8014c4 <memset+0x20>
		return v;
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	eb 69                	jmp    80152d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	83 e0 03             	and    $0x3,%eax
  8014cb:	48 85 c0             	test   %rax,%rax
  8014ce:	75 48                	jne    801518 <memset+0x74>
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d4:	83 e0 03             	and    $0x3,%eax
  8014d7:	48 85 c0             	test   %rax,%rax
  8014da:	75 3c                	jne    801518 <memset+0x74>
		c &= 0xFF;
  8014dc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e6:	c1 e0 18             	shl    $0x18,%eax
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ee:	c1 e0 10             	shl    $0x10,%eax
  8014f1:	09 c2                	or     %eax,%edx
  8014f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f6:	c1 e0 08             	shl    $0x8,%eax
  8014f9:	09 d0                	or     %edx,%eax
  8014fb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	48 c1 e8 02          	shr    $0x2,%rax
  801506:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801509:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801510:	48 89 d7             	mov    %rdx,%rdi
  801513:	fc                   	cld    
  801514:	f3 ab                	rep stos %eax,%es:(%rdi)
  801516:	eb 11                	jmp    801529 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801518:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801523:	48 89 d7             	mov    %rdx,%rdi
  801526:	fc                   	cld    
  801527:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80152d:	c9                   	leaveq 
  80152e:	c3                   	retq   

000000000080152f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80152f:	55                   	push   %rbp
  801530:	48 89 e5             	mov    %rsp,%rbp
  801533:	48 83 ec 28          	sub    $0x28,%rsp
  801537:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80153b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80153f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801547:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801557:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155b:	0f 83 88 00 00 00    	jae    8015e9 <memmove+0xba>
  801561:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 01 d0             	add    %rdx,%rax
  80156c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801570:	76 77                	jbe    8015e9 <memmove+0xba>
		s += n;
  801572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801576:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	83 e0 03             	and    $0x3,%eax
  801589:	48 85 c0             	test   %rax,%rax
  80158c:	75 3b                	jne    8015c9 <memmove+0x9a>
  80158e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801592:	83 e0 03             	and    $0x3,%eax
  801595:	48 85 c0             	test   %rax,%rax
  801598:	75 2f                	jne    8015c9 <memmove+0x9a>
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	83 e0 03             	and    $0x3,%eax
  8015a1:	48 85 c0             	test   %rax,%rax
  8015a4:	75 23                	jne    8015c9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015aa:	48 83 e8 04          	sub    $0x4,%rax
  8015ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b2:	48 83 ea 04          	sub    $0x4,%rdx
  8015b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015ba:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8015be:	48 89 c7             	mov    %rax,%rdi
  8015c1:	48 89 d6             	mov    %rdx,%rsi
  8015c4:	fd                   	std    
  8015c5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015c7:	eb 1d                	jmp    8015e6 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 89 d7             	mov    %rdx,%rdi
  8015e0:	48 89 c1             	mov    %rax,%rcx
  8015e3:	fd                   	std    
  8015e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015e6:	fc                   	cld    
  8015e7:	eb 57                	jmp    801640 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ed:	83 e0 03             	and    $0x3,%eax
  8015f0:	48 85 c0             	test   %rax,%rax
  8015f3:	75 36                	jne    80162b <memmove+0xfc>
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	83 e0 03             	and    $0x3,%eax
  8015fc:	48 85 c0             	test   %rax,%rax
  8015ff:	75 2a                	jne    80162b <memmove+0xfc>
  801601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801605:	83 e0 03             	and    $0x3,%eax
  801608:	48 85 c0             	test   %rax,%rax
  80160b:	75 1e                	jne    80162b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	48 c1 e8 02          	shr    $0x2,%rax
  801615:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801620:	48 89 c7             	mov    %rax,%rdi
  801623:	48 89 d6             	mov    %rdx,%rsi
  801626:	fc                   	cld    
  801627:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801629:	eb 15                	jmp    801640 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80162b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801633:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801637:	48 89 c7             	mov    %rax,%rdi
  80163a:	48 89 d6             	mov    %rdx,%rsi
  80163d:	fc                   	cld    
  80163e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	48 83 ec 18          	sub    $0x18,%rsp
  80164e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801652:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801656:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80165a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80165e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801666:	48 89 ce             	mov    %rcx,%rsi
  801669:	48 89 c7             	mov    %rax,%rdi
  80166c:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  801673:	00 00 00 
  801676:	ff d0                	callq  *%rax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 28          	sub    $0x28,%rsp
  801682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801686:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80168a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80168e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801696:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80169a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80169e:	eb 36                	jmp    8016d6 <memcmp+0x5c>
		if (*s1 != *s2)
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	0f b6 10             	movzbl (%rax),%edx
  8016a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ab:	0f b6 00             	movzbl (%rax),%eax
  8016ae:	38 c2                	cmp    %al,%dl
  8016b0:	74 1a                	je     8016cc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	0f b6 d0             	movzbl %al,%edx
  8016bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	0f b6 c0             	movzbl %al,%eax
  8016c6:	29 c2                	sub    %eax,%edx
  8016c8:	89 d0                	mov    %edx,%eax
  8016ca:	eb 20                	jmp    8016ec <memcmp+0x72>
		s1++, s2++;
  8016cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016e2:	48 85 c0             	test   %rax,%rax
  8016e5:	75 b9                	jne    8016a0 <memcmp+0x26>
	}

	return 0;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	c9                   	leaveq 
  8016ed:	c3                   	retq   

00000000008016ee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016ee:	55                   	push   %rbp
  8016ef:	48 89 e5             	mov    %rsp,%rbp
  8016f2:	48 83 ec 28          	sub    $0x28,%rsp
  8016f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801709:	48 01 d0             	add    %rdx,%rax
  80170c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801710:	eb 15                	jmp    801727 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80171c:	38 d0                	cmp    %dl,%al
  80171e:	75 02                	jne    801722 <memfind+0x34>
			break;
  801720:	eb 0f                	jmp    801731 <memfind+0x43>
	for (; s < ends; s++)
  801722:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80172f:	72 e1                	jb     801712 <memfind+0x24>
	return (void *) s;
  801731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801735:	c9                   	leaveq 
  801736:	c3                   	retq   

0000000000801737 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
  80173b:	48 83 ec 38          	sub    $0x38,%rsp
  80173f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801743:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801747:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80174a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801751:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801758:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801759:	eb 05                	jmp    801760 <strtol+0x29>
		s++;
  80175b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 20                	cmp    $0x20,%al
  801769:	74 f0                	je     80175b <strtol+0x24>
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 e5                	je     80175b <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 2b                	cmp    $0x2b,%al
  80177f:	75 07                	jne    801788 <strtol+0x51>
		s++;
  801781:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801786:	eb 17                	jmp    80179f <strtol+0x68>
	else if (*s == '-')
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	3c 2d                	cmp    $0x2d,%al
  801791:	75 0c                	jne    80179f <strtol+0x68>
		s++, neg = 1;
  801793:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801798:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80179f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a3:	74 06                	je     8017ab <strtol+0x74>
  8017a5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017a9:	75 28                	jne    8017d3 <strtol+0x9c>
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	3c 30                	cmp    $0x30,%al
  8017b4:	75 1d                	jne    8017d3 <strtol+0x9c>
  8017b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ba:	48 83 c0 01          	add    $0x1,%rax
  8017be:	0f b6 00             	movzbl (%rax),%eax
  8017c1:	3c 78                	cmp    $0x78,%al
  8017c3:	75 0e                	jne    8017d3 <strtol+0x9c>
		s += 2, base = 16;
  8017c5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017ca:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d1:	eb 2c                	jmp    8017ff <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017d7:	75 19                	jne    8017f2 <strtol+0xbb>
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	3c 30                	cmp    $0x30,%al
  8017e2:	75 0e                	jne    8017f2 <strtol+0xbb>
		s++, base = 8;
  8017e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f0:	eb 0d                	jmp    8017ff <strtol+0xc8>
	else if (base == 0)
  8017f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f6:	75 07                	jne    8017ff <strtol+0xc8>
		base = 10;
  8017f8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	3c 2f                	cmp    $0x2f,%al
  801808:	7e 1d                	jle    801827 <strtol+0xf0>
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	3c 39                	cmp    $0x39,%al
  801813:	7f 12                	jg     801827 <strtol+0xf0>
			dig = *s - '0';
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	0f b6 00             	movzbl (%rax),%eax
  80181c:	0f be c0             	movsbl %al,%eax
  80181f:	83 e8 30             	sub    $0x30,%eax
  801822:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801825:	eb 4e                	jmp    801875 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	3c 60                	cmp    $0x60,%al
  801830:	7e 1d                	jle    80184f <strtol+0x118>
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	0f b6 00             	movzbl (%rax),%eax
  801839:	3c 7a                	cmp    $0x7a,%al
  80183b:	7f 12                	jg     80184f <strtol+0x118>
			dig = *s - 'a' + 10;
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	0f be c0             	movsbl %al,%eax
  801847:	83 e8 57             	sub    $0x57,%eax
  80184a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80184d:	eb 26                	jmp    801875 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80184f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801853:	0f b6 00             	movzbl (%rax),%eax
  801856:	3c 40                	cmp    $0x40,%al
  801858:	7e 48                	jle    8018a2 <strtol+0x16b>
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	3c 5a                	cmp    $0x5a,%al
  801863:	7f 3d                	jg     8018a2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801869:	0f b6 00             	movzbl (%rax),%eax
  80186c:	0f be c0             	movsbl %al,%eax
  80186f:	83 e8 37             	sub    $0x37,%eax
  801872:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801875:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801878:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80187b:	7c 02                	jl     80187f <strtol+0x148>
			break;
  80187d:	eb 23                	jmp    8018a2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80187f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801884:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80188e:	48 89 c2             	mov    %rax,%rdx
  801891:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801894:	48 98                	cltq   
  801896:	48 01 d0             	add    %rdx,%rax
  801899:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80189d:	e9 5d ff ff ff       	jmpq   8017ff <strtol+0xc8>

	if (endptr)
  8018a2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018a7:	74 0b                	je     8018b4 <strtol+0x17d>
		*endptr = (char *) s;
  8018a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018b8:	74 09                	je     8018c3 <strtol+0x18c>
  8018ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018be:	48 f7 d8             	neg    %rax
  8018c1:	eb 04                	jmp    8018c7 <strtol+0x190>
  8018c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018c7:	c9                   	leaveq 
  8018c8:	c3                   	retq   

00000000008018c9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018c9:	55                   	push   %rbp
  8018ca:	48 89 e5             	mov    %rsp,%rbp
  8018cd:	48 83 ec 30          	sub    $0x30,%rsp
  8018d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018eb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018ef:	75 06                	jne    8018f7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f5:	eb 6b                	jmp    801962 <strstr+0x99>

	len = strlen(str);
  8018f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fb:	48 89 c7             	mov    %rax,%rdi
  8018fe:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
  80190a:	48 98                	cltq   
  80190c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801918:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801922:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801926:	75 07                	jne    80192f <strstr+0x66>
				return (char *) 0;
  801928:	b8 00 00 00 00       	mov    $0x0,%eax
  80192d:	eb 33                	jmp    801962 <strstr+0x99>
		} while (sc != c);
  80192f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801933:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801936:	75 d8                	jne    801910 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	48 89 ce             	mov    %rcx,%rsi
  801947:	48 89 c7             	mov    %rax,%rdi
  80194a:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
  801956:	85 c0                	test   %eax,%eax
  801958:	75 b6                	jne    801910 <strstr+0x47>

	return (char *) (in - 1);
  80195a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195e:	48 83 e8 01          	sub    $0x1,%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
  801969:	48 83 ec 48          	sub    $0x48,%rsp
  80196d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801970:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801973:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801977:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80197b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80197f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801983:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801986:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80198a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80198e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801992:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801996:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80199a:	4c 89 c3             	mov    %r8,%rbx
  80199d:	cd 30                	int    $0x30
  80199f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019a7:	74 3e                	je     8019e7 <syscall+0x83>
  8019a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ae:	7e 37                	jle    8019e7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019b7:	49 89 d0             	mov    %rdx,%r8
  8019ba:	89 c1                	mov    %eax,%ecx
  8019bc:	48 ba 08 47 80 00 00 	movabs $0x804708,%rdx
  8019c3:	00 00 00 
  8019c6:	be 23 00 00 00       	mov    $0x23,%esi
  8019cb:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8019d2:	00 00 00 
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019da:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  8019e1:	00 00 00 
  8019e4:	41 ff d1             	callq  *%r9

	return ret;
  8019e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019eb:	48 83 c4 48          	add    $0x48,%rsp
  8019ef:	5b                   	pop    %rbx
  8019f0:	5d                   	pop    %rbp
  8019f1:	c3                   	retq   

00000000008019f2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019f2:	55                   	push   %rbp
  8019f3:	48 89 e5             	mov    %rsp,%rbp
  8019f6:	48 83 ec 10          	sub    $0x10,%rsp
  8019fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0a:	48 83 ec 08          	sub    $0x8,%rsp
  801a0e:	6a 00                	pushq  $0x0
  801a10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1c:	48 89 d1             	mov    %rdx,%rcx
  801a1f:	48 89 c2             	mov    %rax,%rdx
  801a22:	be 00 00 00 00       	mov    $0x0,%esi
  801a27:	bf 00 00 00 00       	mov    $0x0,%edi
  801a2c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801a33:	00 00 00 
  801a36:	ff d0                	callq  *%rax
  801a38:	48 83 c4 10          	add    $0x10,%rsp
}
  801a3c:	c9                   	leaveq 
  801a3d:	c3                   	retq   

0000000000801a3e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a3e:	55                   	push   %rbp
  801a3f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a42:	48 83 ec 08          	sub    $0x8,%rsp
  801a46:	6a 00                	pushq  $0x0
  801a48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a54:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a59:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5e:	be 00 00 00 00       	mov    $0x0,%esi
  801a63:	bf 01 00 00 00       	mov    $0x1,%edi
  801a68:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801a6f:	00 00 00 
  801a72:	ff d0                	callq  *%rax
  801a74:	48 83 c4 10          	add    $0x10,%rsp
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
  801a82:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a88:	48 98                	cltq   
  801a8a:	48 83 ec 08          	sub    $0x8,%rsp
  801a8e:	6a 00                	pushq  $0x0
  801a90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa1:	48 89 c2             	mov    %rax,%rdx
  801aa4:	be 01 00 00 00       	mov    $0x1,%esi
  801aa9:	bf 03 00 00 00       	mov    $0x3,%edi
  801aae:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
  801aba:	48 83 c4 10          	add    $0x10,%rsp
}
  801abe:	c9                   	leaveq 
  801abf:	c3                   	retq   

0000000000801ac0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ac0:	55                   	push   %rbp
  801ac1:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ac4:	48 83 ec 08          	sub    $0x8,%rsp
  801ac8:	6a 00                	pushq  $0x0
  801aca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801adb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae0:	be 00 00 00 00       	mov    $0x0,%esi
  801ae5:	bf 02 00 00 00       	mov    $0x2,%edi
  801aea:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	callq  *%rax
  801af6:	48 83 c4 10          	add    $0x10,%rsp
}
  801afa:	c9                   	leaveq 
  801afb:	c3                   	retq   

0000000000801afc <sys_yield>:

void
sys_yield(void)
{
  801afc:	55                   	push   %rbp
  801afd:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b00:	48 83 ec 08          	sub    $0x8,%rsp
  801b04:	6a 00                	pushq  $0x0
  801b06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	be 00 00 00 00       	mov    $0x0,%esi
  801b21:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b26:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	callq  *%rax
  801b32:	48 83 c4 10          	add    $0x10,%rsp
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 10          	sub    $0x10,%rsp
  801b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b47:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4d:	48 63 c8             	movslq %eax,%rcx
  801b50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b57:	48 98                	cltq   
  801b59:	48 83 ec 08          	sub    $0x8,%rsp
  801b5d:	6a 00                	pushq  $0x0
  801b5f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b65:	49 89 c8             	mov    %rcx,%r8
  801b68:	48 89 d1             	mov    %rdx,%rcx
  801b6b:	48 89 c2             	mov    %rax,%rdx
  801b6e:	be 01 00 00 00       	mov    $0x1,%esi
  801b73:	bf 04 00 00 00       	mov    $0x4,%edi
  801b78:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	callq  *%rax
  801b84:	48 83 c4 10          	add    $0x10,%rsp
}
  801b88:	c9                   	leaveq 
  801b89:	c3                   	retq   

0000000000801b8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b8a:	55                   	push   %rbp
  801b8b:	48 89 e5             	mov    %rsp,%rbp
  801b8e:	48 83 ec 20          	sub    $0x20,%rsp
  801b92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b99:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b9c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ba4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ba7:	48 63 c8             	movslq %eax,%rcx
  801baa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb1:	48 63 f0             	movslq %eax,%rsi
  801bb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbb:	48 98                	cltq   
  801bbd:	48 83 ec 08          	sub    $0x8,%rsp
  801bc1:	51                   	push   %rcx
  801bc2:	49 89 f9             	mov    %rdi,%r9
  801bc5:	49 89 f0             	mov    %rsi,%r8
  801bc8:	48 89 d1             	mov    %rdx,%rcx
  801bcb:	48 89 c2             	mov    %rax,%rdx
  801bce:	be 01 00 00 00       	mov    $0x1,%esi
  801bd3:	bf 05 00 00 00       	mov    $0x5,%edi
  801bd8:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
  801be4:	48 83 c4 10          	add    $0x10,%rsp
}
  801be8:	c9                   	leaveq 
  801be9:	c3                   	retq   

0000000000801bea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	48 83 ec 10          	sub    $0x10,%rsp
  801bf2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c00:	48 98                	cltq   
  801c02:	48 83 ec 08          	sub    $0x8,%rsp
  801c06:	6a 00                	pushq  $0x0
  801c08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c14:	48 89 d1             	mov    %rdx,%rcx
  801c17:	48 89 c2             	mov    %rax,%rdx
  801c1a:	be 01 00 00 00       	mov    $0x1,%esi
  801c1f:	bf 06 00 00 00       	mov    $0x6,%edi
  801c24:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c2b:	00 00 00 
  801c2e:	ff d0                	callq  *%rax
  801c30:	48 83 c4 10          	add    $0x10,%rsp
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 10          	sub    $0x10,%rsp
  801c3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c41:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c47:	48 63 d0             	movslq %eax,%rdx
  801c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4d:	48 98                	cltq   
  801c4f:	48 83 ec 08          	sub    $0x8,%rsp
  801c53:	6a 00                	pushq  $0x0
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	48 89 d1             	mov    %rdx,%rcx
  801c64:	48 89 c2             	mov    %rax,%rdx
  801c67:	be 01 00 00 00       	mov    $0x1,%esi
  801c6c:	bf 08 00 00 00       	mov    $0x8,%edi
  801c71:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
  801c7d:	48 83 c4 10          	add    $0x10,%rsp
}
  801c81:	c9                   	leaveq 
  801c82:	c3                   	retq   

0000000000801c83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c83:	55                   	push   %rbp
  801c84:	48 89 e5             	mov    %rsp,%rbp
  801c87:	48 83 ec 10          	sub    $0x10,%rsp
  801c8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c99:	48 98                	cltq   
  801c9b:	48 83 ec 08          	sub    $0x8,%rsp
  801c9f:	6a 00                	pushq  $0x0
  801ca1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cad:	48 89 d1             	mov    %rdx,%rcx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 01 00 00 00       	mov    $0x1,%esi
  801cb8:	bf 09 00 00 00       	mov    $0x9,%edi
  801cbd:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
  801cc9:	48 83 c4 10          	add    $0x10,%rsp
}
  801ccd:	c9                   	leaveq 
  801cce:	c3                   	retq   

0000000000801ccf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ccf:	55                   	push   %rbp
  801cd0:	48 89 e5             	mov    %rsp,%rbp
  801cd3:	48 83 ec 10          	sub    $0x10,%rsp
  801cd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cde:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce5:	48 98                	cltq   
  801ce7:	48 83 ec 08          	sub    $0x8,%rsp
  801ceb:	6a 00                	pushq  $0x0
  801ced:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf9:	48 89 d1             	mov    %rdx,%rcx
  801cfc:	48 89 c2             	mov    %rax,%rdx
  801cff:	be 01 00 00 00       	mov    $0x1,%esi
  801d04:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d09:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
  801d15:	48 83 c4 10          	add    $0x10,%rsp
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 20          	sub    $0x20,%rsp
  801d23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d2e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d34:	48 63 f0             	movslq %eax,%rsi
  801d37:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3e:	48 98                	cltq   
  801d40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d44:	48 83 ec 08          	sub    $0x8,%rsp
  801d48:	6a 00                	pushq  $0x0
  801d4a:	49 89 f1             	mov    %rsi,%r9
  801d4d:	49 89 c8             	mov    %rcx,%r8
  801d50:	48 89 d1             	mov    %rdx,%rcx
  801d53:	48 89 c2             	mov    %rax,%rdx
  801d56:	be 00 00 00 00       	mov    $0x0,%esi
  801d5b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d60:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax
  801d6c:	48 83 c4 10          	add    $0x10,%rsp
}
  801d70:	c9                   	leaveq 
  801d71:	c3                   	retq   

0000000000801d72 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d72:	55                   	push   %rbp
  801d73:	48 89 e5             	mov    %rsp,%rbp
  801d76:	48 83 ec 10          	sub    $0x10,%rsp
  801d7a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d82:	48 83 ec 08          	sub    $0x8,%rsp
  801d86:	6a 00                	pushq  $0x0
  801d88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d99:	48 89 c2             	mov    %rax,%rdx
  801d9c:	be 01 00 00 00       	mov    $0x1,%esi
  801da1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da6:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	callq  *%rax
  801db2:	48 83 c4 10          	add    $0x10,%rsp
}
  801db6:	c9                   	leaveq 
  801db7:	c3                   	retq   

0000000000801db8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801db8:	55                   	push   %rbp
  801db9:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801dbc:	48 83 ec 08          	sub    $0x8,%rsp
  801dc0:	6a 00                	pushq  $0x0
  801dc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dce:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd8:	be 00 00 00 00       	mov    $0x0,%esi
  801ddd:	bf 0e 00 00 00       	mov    $0xe,%edi
  801de2:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	callq  *%rax
  801dee:	48 83 c4 10          	add    $0x10,%rsp
}
  801df2:	c9                   	leaveq 
  801df3:	c3                   	retq   

0000000000801df4 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801df4:	55                   	push   %rbp
  801df5:	48 89 e5             	mov    %rsp,%rbp
  801df8:	48 83 ec 20          	sub    $0x20,%rsp
  801dfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e03:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e06:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e0a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e11:	48 63 c8             	movslq %eax,%rcx
  801e14:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1b:	48 63 f0             	movslq %eax,%rsi
  801e1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e25:	48 98                	cltq   
  801e27:	48 83 ec 08          	sub    $0x8,%rsp
  801e2b:	51                   	push   %rcx
  801e2c:	49 89 f9             	mov    %rdi,%r9
  801e2f:	49 89 f0             	mov    %rsi,%r8
  801e32:	48 89 d1             	mov    %rdx,%rcx
  801e35:	48 89 c2             	mov    %rax,%rdx
  801e38:	be 00 00 00 00       	mov    $0x0,%esi
  801e3d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e42:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	callq  *%rax
  801e4e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e52:	c9                   	leaveq 
  801e53:	c3                   	retq   

0000000000801e54 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e54:	55                   	push   %rbp
  801e55:	48 89 e5             	mov    %rsp,%rbp
  801e58:	48 83 ec 10          	sub    $0x10,%rsp
  801e5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6c:	48 83 ec 08          	sub    $0x8,%rsp
  801e70:	6a 00                	pushq  $0x0
  801e72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7e:	48 89 d1             	mov    %rdx,%rcx
  801e81:	48 89 c2             	mov    %rax,%rdx
  801e84:	be 00 00 00 00       	mov    $0x0,%esi
  801e89:	bf 10 00 00 00       	mov    $0x10,%edi
  801e8e:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
  801e9a:	48 83 c4 10          	add    $0x10,%rsp
}
  801e9e:	c9                   	leaveq 
  801e9f:	c3                   	retq   

0000000000801ea0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ea0:	55                   	push   %rbp
  801ea1:	48 89 e5             	mov    %rsp,%rbp
  801ea4:	48 83 ec 20          	sub    $0x20,%rsp
  801ea8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb0:	48 8b 00             	mov    (%rax),%rax
  801eb3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebb:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ebf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801ec2:	48 ba 33 47 80 00 00 	movabs $0x804733,%rdx
  801ec9:	00 00 00 
  801ecc:	be 26 00 00 00       	mov    $0x26,%esi
  801ed1:	48 bf 4b 47 80 00 00 	movabs $0x80474b,%rdi
  801ed8:	00 00 00 
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee0:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  801ee7:	00 00 00 
  801eea:	ff d1                	callq  *%rcx

0000000000801eec <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801eec:	55                   	push   %rbp
  801eed:	48 89 e5             	mov    %rsp,%rbp
  801ef0:	48 83 ec 10          	sub    $0x10,%rsp
  801ef4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801efa:	48 ba 56 47 80 00 00 	movabs $0x804756,%rdx
  801f01:	00 00 00 
  801f04:	be 3a 00 00 00       	mov    $0x3a,%esi
  801f09:	48 bf 4b 47 80 00 00 	movabs $0x80474b,%rdi
  801f10:	00 00 00 
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  801f1f:	00 00 00 
  801f22:	ff d1                	callq  *%rcx

0000000000801f24 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f24:	55                   	push   %rbp
  801f25:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801f28:	48 ba 6e 47 80 00 00 	movabs $0x80476e,%rdx
  801f2f:	00 00 00 
  801f32:	be 52 00 00 00       	mov    $0x52,%esi
  801f37:	48 bf 4b 47 80 00 00 	movabs $0x80474b,%rdi
  801f3e:	00 00 00 
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  801f4d:	00 00 00 
  801f50:	ff d1                	callq  *%rcx

0000000000801f52 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801f52:	55                   	push   %rbp
  801f53:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801f56:	48 ba 83 47 80 00 00 	movabs $0x804783,%rdx
  801f5d:	00 00 00 
  801f60:	be 59 00 00 00       	mov    $0x59,%esi
  801f65:	48 bf 4b 47 80 00 00 	movabs $0x80474b,%rdi
  801f6c:	00 00 00 
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  801f7b:	00 00 00 
  801f7e:	ff d1                	callq  *%rcx

0000000000801f80 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f80:	55                   	push   %rbp
  801f81:	48 89 e5             	mov    %rsp,%rbp
  801f84:	48 83 ec 20          	sub    $0x20,%rsp
  801f88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801f94:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  801f9b:	00 00 00 
  801f9e:	be 1d 00 00 00       	mov    $0x1d,%esi
  801fa3:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  801faa:	00 00 00 
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  801fb9:	00 00 00 
  801fbc:	ff d1                	callq  *%rcx

0000000000801fbe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fbe:	55                   	push   %rbp
  801fbf:	48 89 e5             	mov    %rsp,%rbp
  801fc2:	48 83 ec 20          	sub    $0x20,%rsp
  801fc6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fc9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801fcc:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  801fd0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801fd3:	48 ba c3 47 80 00 00 	movabs $0x8047c3,%rdx
  801fda:	00 00 00 
  801fdd:	be 2d 00 00 00       	mov    $0x2d,%esi
  801fe2:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  801fe9:	00 00 00 
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff1:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  801ff8:	00 00 00 
  801ffb:	ff d1                	callq  *%rcx

0000000000801ffd <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  801ffd:	55                   	push   %rbp
  801ffe:	48 89 e5             	mov    %rsp,%rbp
  802001:	53                   	push   %rbx
  802002:	48 83 ec 48          	sub    $0x48,%rsp
  802006:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80200a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  802011:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  802018:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  80201d:	75 0e                	jne    80202d <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  80201f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  802026:	00 00 00 
  802029:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  80202d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802031:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  802035:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80203c:	00 
	a3 = (uint64_t) 0;
  80203d:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802044:	00 
	a4 = (uint64_t) 0;
  802045:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80204c:	00 
	a5 = 0;
  80204d:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  802054:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  802055:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802058:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80205c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802060:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  802064:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802068:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80206c:	4c 89 c3             	mov    %r8,%rbx
  80206f:	0f 01 c1             	vmcall 
  802072:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  802075:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802079:	7e 36                	jle    8020b1 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  80207b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80207e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802081:	41 89 d0             	mov    %edx,%r8d
  802084:	89 c1                	mov    %eax,%ecx
  802086:	48 ba e0 47 80 00 00 	movabs $0x8047e0,%rdx
  80208d:	00 00 00 
  802090:	be 54 00 00 00       	mov    $0x54,%esi
  802095:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  80209c:	00 00 00 
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  8020ab:	00 00 00 
  8020ae:	41 ff d1             	callq  *%r9
	return ret;
  8020b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8020b4:	48 83 c4 48          	add    $0x48,%rsp
  8020b8:	5b                   	pop    %rbx
  8020b9:	5d                   	pop    %rbp
  8020ba:	c3                   	retq   

00000000008020bb <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020bb:	55                   	push   %rbp
  8020bc:	48 89 e5             	mov    %rsp,%rbp
  8020bf:	53                   	push   %rbx
  8020c0:	48 83 ec 58          	sub    $0x58,%rsp
  8020c4:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  8020c7:	89 75 b0             	mov    %esi,-0x50(%rbp)
  8020ca:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8020ce:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8020d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8020d8:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8020df:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8020e4:	75 0e                	jne    8020f4 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8020e6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8020ed:	00 00 00 
  8020f0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8020f4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8020f7:	48 98                	cltq   
  8020f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8020fd:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802100:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  802104:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802108:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  80210c:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80210f:	48 98                	cltq   
  802111:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  802115:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80211c:	00 

	int r = -E_IPC_NOT_RECV;
  80211d:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  802124:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802127:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80212b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80212f:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  802133:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802137:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80213b:	4c 89 c3             	mov    %r8,%rbx
  80213e:	0f 01 c1             	vmcall 
  802141:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  802144:	48 83 c4 58          	add    $0x58,%rsp
  802148:	5b                   	pop    %rbx
  802149:	5d                   	pop    %rbp
  80214a:	c3                   	retq   

000000000080214b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80214b:	55                   	push   %rbp
  80214c:	48 89 e5             	mov    %rsp,%rbp
  80214f:	48 83 ec 18          	sub    $0x18,%rsp
  802153:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80215d:	eb 4e                	jmp    8021ad <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80215f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802166:	00 00 00 
  802169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216c:	48 98                	cltq   
  80216e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802175:	48 01 d0             	add    %rdx,%rax
  802178:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80217e:	8b 00                	mov    (%rax),%eax
  802180:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802183:	75 24                	jne    8021a9 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802185:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80218c:	00 00 00 
  80218f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802192:	48 98                	cltq   
  802194:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80219b:	48 01 d0             	add    %rdx,%rax
  80219e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8021a4:	8b 40 08             	mov    0x8(%rax),%eax
  8021a7:	eb 12                	jmp    8021bb <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  8021a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021ad:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8021b4:	7e a9                	jle    80215f <ipc_find_env+0x14>
	}
	return 0;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bb:	c9                   	leaveq 
  8021bc:	c3                   	retq   

00000000008021bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021bd:	55                   	push   %rbp
  8021be:	48 89 e5             	mov    %rsp,%rbp
  8021c1:	48 83 ec 08          	sub    $0x8,%rsp
  8021c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021cd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021d4:	ff ff ff 
  8021d7:	48 01 d0             	add    %rdx,%rax
  8021da:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021de:	c9                   	leaveq 
  8021df:	c3                   	retq   

00000000008021e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021e0:	55                   	push   %rbp
  8021e1:	48 89 e5             	mov    %rsp,%rbp
  8021e4:	48 83 ec 08          	sub    $0x8,%rsp
  8021e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f0:	48 89 c7             	mov    %rax,%rdi
  8021f3:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  8021fa:	00 00 00 
  8021fd:	ff d0                	callq  *%rax
  8021ff:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802205:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802209:	c9                   	leaveq 
  80220a:	c3                   	retq   

000000000080220b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	48 83 ec 18          	sub    $0x18,%rsp
  802213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802217:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80221e:	eb 6b                	jmp    80228b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802223:	48 98                	cltq   
  802225:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80222b:	48 c1 e0 0c          	shl    $0xc,%rax
  80222f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802237:	48 c1 e8 15          	shr    $0x15,%rax
  80223b:	48 89 c2             	mov    %rax,%rdx
  80223e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802245:	01 00 00 
  802248:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224c:	83 e0 01             	and    $0x1,%eax
  80224f:	48 85 c0             	test   %rax,%rax
  802252:	74 21                	je     802275 <fd_alloc+0x6a>
  802254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802258:	48 c1 e8 0c          	shr    $0xc,%rax
  80225c:	48 89 c2             	mov    %rax,%rdx
  80225f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802266:	01 00 00 
  802269:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226d:	83 e0 01             	and    $0x1,%eax
  802270:	48 85 c0             	test   %rax,%rax
  802273:	75 12                	jne    802287 <fd_alloc+0x7c>
			*fd_store = fd;
  802275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802279:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
  802285:	eb 1a                	jmp    8022a1 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  802287:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80228b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80228f:	7e 8f                	jle    802220 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  802291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802295:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80229c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022a1:	c9                   	leaveq 
  8022a2:	c3                   	retq   

00000000008022a3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	48 83 ec 20          	sub    $0x20,%rsp
  8022ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022b6:	78 06                	js     8022be <fd_lookup+0x1b>
  8022b8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022bc:	7e 07                	jle    8022c5 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c3:	eb 6c                	jmp    802331 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c8:	48 98                	cltq   
  8022ca:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d0:	48 c1 e0 0c          	shl    $0xc,%rax
  8022d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022dc:	48 c1 e8 15          	shr    $0x15,%rax
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ea:	01 00 00 
  8022ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f1:	83 e0 01             	and    $0x1,%eax
  8022f4:	48 85 c0             	test   %rax,%rax
  8022f7:	74 21                	je     80231a <fd_lookup+0x77>
  8022f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802301:	48 89 c2             	mov    %rax,%rdx
  802304:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80230b:	01 00 00 
  80230e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802312:	83 e0 01             	and    $0x1,%eax
  802315:	48 85 c0             	test   %rax,%rax
  802318:	75 07                	jne    802321 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80231a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80231f:	eb 10                	jmp    802331 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802321:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802325:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802329:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802331:	c9                   	leaveq 
  802332:	c3                   	retq   

0000000000802333 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802333:	55                   	push   %rbp
  802334:	48 89 e5             	mov    %rsp,%rbp
  802337:	48 83 ec 30          	sub    $0x30,%rsp
  80233b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80233f:	89 f0                	mov    %esi,%eax
  802341:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802348:	48 89 c7             	mov    %rax,%rdi
  80234b:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  802352:	00 00 00 
  802355:	ff d0                	callq  *%rax
  802357:	89 c2                	mov    %eax,%edx
  802359:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80235d:	48 89 c6             	mov    %rax,%rsi
  802360:	89 d7                	mov    %edx,%edi
  802362:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802369:	00 00 00 
  80236c:	ff d0                	callq  *%rax
  80236e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802371:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802375:	78 0a                	js     802381 <fd_close+0x4e>
	    || fd != fd2)
  802377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80237f:	74 12                	je     802393 <fd_close+0x60>
		return (must_exist ? r : 0);
  802381:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802385:	74 05                	je     80238c <fd_close+0x59>
  802387:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238a:	eb 70                	jmp    8023fc <fd_close+0xc9>
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
  802391:	eb 69                	jmp    8023fc <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802393:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802397:	8b 00                	mov    (%rax),%eax
  802399:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80239d:	48 89 d6             	mov    %rdx,%rsi
  8023a0:	89 c7                	mov    %eax,%edi
  8023a2:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  8023a9:	00 00 00 
  8023ac:	ff d0                	callq  *%rax
  8023ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b5:	78 2a                	js     8023e1 <fd_close+0xae>
		if (dev->dev_close)
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023bf:	48 85 c0             	test   %rax,%rax
  8023c2:	74 16                	je     8023da <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8023c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023d0:	48 89 d7             	mov    %rdx,%rdi
  8023d3:	ff d0                	callq  *%rax
  8023d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d8:	eb 07                	jmp    8023e1 <fd_close+0xae>
		else
			r = 0;
  8023da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e5:	48 89 c6             	mov    %rax,%rsi
  8023e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ed:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
	return r;
  8023f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023fc:	c9                   	leaveq 
  8023fd:	c3                   	retq   

00000000008023fe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	48 83 ec 20          	sub    $0x20,%rsp
  802406:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802409:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80240d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802414:	eb 41                	jmp    802457 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802416:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80241d:	00 00 00 
  802420:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802423:	48 63 d2             	movslq %edx,%rdx
  802426:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242a:	8b 00                	mov    (%rax),%eax
  80242c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80242f:	75 22                	jne    802453 <dev_lookup+0x55>
			*dev = devtab[i];
  802431:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802438:	00 00 00 
  80243b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80243e:	48 63 d2             	movslq %edx,%rdx
  802441:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802449:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	eb 60                	jmp    8024b3 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802453:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802457:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80245e:	00 00 00 
  802461:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802464:	48 63 d2             	movslq %edx,%rdx
  802467:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246b:	48 85 c0             	test   %rax,%rax
  80246e:	75 a6                	jne    802416 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802470:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802477:	00 00 00 
  80247a:	48 8b 00             	mov    (%rax),%rax
  80247d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802483:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802486:	89 c6                	mov    %eax,%esi
  802488:	48 bf 10 48 80 00 00 	movabs $0x804810,%rdi
  80248f:	00 00 00 
  802492:	b8 00 00 00 00       	mov    $0x0,%eax
  802497:	48 b9 71 06 80 00 00 	movabs $0x800671,%rcx
  80249e:	00 00 00 
  8024a1:	ff d1                	callq  *%rcx
	*dev = 0;
  8024a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024b3:	c9                   	leaveq 
  8024b4:	c3                   	retq   

00000000008024b5 <close>:

int
close(int fdnum)
{
  8024b5:	55                   	push   %rbp
  8024b6:	48 89 e5             	mov    %rsp,%rbp
  8024b9:	48 83 ec 20          	sub    $0x20,%rsp
  8024bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024c7:	48 89 d6             	mov    %rdx,%rsi
  8024ca:	89 c7                	mov    %eax,%edi
  8024cc:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8024d3:	00 00 00 
  8024d6:	ff d0                	callq  *%rax
  8024d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024df:	79 05                	jns    8024e6 <close+0x31>
		return r;
  8024e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e4:	eb 18                	jmp    8024fe <close+0x49>
	else
		return fd_close(fd, 1);
  8024e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ea:	be 01 00 00 00       	mov    $0x1,%esi
  8024ef:	48 89 c7             	mov    %rax,%rdi
  8024f2:	48 b8 33 23 80 00 00 	movabs $0x802333,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax
}
  8024fe:	c9                   	leaveq 
  8024ff:	c3                   	retq   

0000000000802500 <close_all>:

void
close_all(void)
{
  802500:	55                   	push   %rbp
  802501:	48 89 e5             	mov    %rsp,%rbp
  802504:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80250f:	eb 15                	jmp    802526 <close_all+0x26>
		close(i);
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	89 c7                	mov    %eax,%edi
  802516:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802522:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802526:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80252a:	7e e5                	jle    802511 <close_all+0x11>
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 40          	sub    $0x40,%rsp
  802536:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802539:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80253c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802540:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802543:	48 89 d6             	mov    %rdx,%rsi
  802546:	89 c7                	mov    %eax,%edi
  802548:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  80254f:	00 00 00 
  802552:	ff d0                	callq  *%rax
  802554:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802557:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255b:	79 08                	jns    802565 <dup+0x37>
		return r;
  80255d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802560:	e9 70 01 00 00       	jmpq   8026d5 <dup+0x1a7>
	close(newfdnum);
  802565:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802568:	89 c7                	mov    %eax,%edi
  80256a:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802576:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802579:	48 98                	cltq   
  80257b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802581:	48 c1 e0 0c          	shl    $0xc,%rax
  802585:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258d:	48 89 c7             	mov    %rax,%rdi
  802590:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
  80259c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a4:	48 89 c7             	mov    %rax,%rdi
  8025a7:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax
  8025b3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bb:	48 c1 e8 15          	shr    $0x15,%rax
  8025bf:	48 89 c2             	mov    %rax,%rdx
  8025c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025c9:	01 00 00 
  8025cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d0:	83 e0 01             	and    $0x1,%eax
  8025d3:	48 85 c0             	test   %rax,%rax
  8025d6:	74 73                	je     80264b <dup+0x11d>
  8025d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8025e0:	48 89 c2             	mov    %rax,%rdx
  8025e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ea:	01 00 00 
  8025ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f1:	83 e0 01             	and    $0x1,%eax
  8025f4:	48 85 c0             	test   %rax,%rax
  8025f7:	74 52                	je     80264b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802601:	48 89 c2             	mov    %rax,%rdx
  802604:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80260b:	01 00 00 
  80260e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802612:	25 07 0e 00 00       	and    $0xe07,%eax
  802617:	89 c1                	mov    %eax,%ecx
  802619:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80261d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802621:	41 89 c8             	mov    %ecx,%r8d
  802624:	48 89 d1             	mov    %rdx,%rcx
  802627:	ba 00 00 00 00       	mov    $0x0,%edx
  80262c:	48 89 c6             	mov    %rax,%rsi
  80262f:	bf 00 00 00 00       	mov    $0x0,%edi
  802634:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	79 02                	jns    80264b <dup+0x11d>
			goto err;
  802649:	eb 57                	jmp    8026a2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80264b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264f:	48 c1 e8 0c          	shr    $0xc,%rax
  802653:	48 89 c2             	mov    %rax,%rdx
  802656:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265d:	01 00 00 
  802660:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802664:	25 07 0e 00 00       	and    $0xe07,%eax
  802669:	89 c1                	mov    %eax,%ecx
  80266b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802673:	41 89 c8             	mov    %ecx,%r8d
  802676:	48 89 d1             	mov    %rdx,%rcx
  802679:	ba 00 00 00 00       	mov    $0x0,%edx
  80267e:	48 89 c6             	mov    %rax,%rsi
  802681:	bf 00 00 00 00       	mov    $0x0,%edi
  802686:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
  802692:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802695:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802699:	79 02                	jns    80269d <dup+0x16f>
		goto err;
  80269b:	eb 05                	jmp    8026a2 <dup+0x174>

	return newfdnum;
  80269d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026a0:	eb 33                	jmp    8026d5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a6:	48 89 c6             	mov    %rax,%rsi
  8026a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ae:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026be:	48 89 c6             	mov    %rax,%rsi
  8026c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c6:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
	return r;
  8026d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   

00000000008026d7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026d7:	55                   	push   %rbp
  8026d8:	48 89 e5             	mov    %rsp,%rbp
  8026db:	48 83 ec 40          	sub    $0x40,%rsp
  8026df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026e6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026f1:	48 89 d6             	mov    %rdx,%rsi
  8026f4:	89 c7                	mov    %eax,%edi
  8026f6:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802709:	78 24                	js     80272f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80270b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270f:	8b 00                	mov    (%rax),%eax
  802711:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802715:	48 89 d6             	mov    %rdx,%rsi
  802718:	89 c7                	mov    %eax,%edi
  80271a:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
  802726:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802729:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272d:	79 05                	jns    802734 <read+0x5d>
		return r;
  80272f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802732:	eb 76                	jmp    8027aa <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802738:	8b 40 08             	mov    0x8(%rax),%eax
  80273b:	83 e0 03             	and    $0x3,%eax
  80273e:	83 f8 01             	cmp    $0x1,%eax
  802741:	75 3a                	jne    80277d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802743:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80274a:	00 00 00 
  80274d:	48 8b 00             	mov    (%rax),%rax
  802750:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802756:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802759:	89 c6                	mov    %eax,%esi
  80275b:	48 bf 2f 48 80 00 00 	movabs $0x80482f,%rdi
  802762:	00 00 00 
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	48 b9 71 06 80 00 00 	movabs $0x800671,%rcx
  802771:	00 00 00 
  802774:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802776:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80277b:	eb 2d                	jmp    8027aa <read+0xd3>
	}
	if (!dev->dev_read)
  80277d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802781:	48 8b 40 10          	mov    0x10(%rax),%rax
  802785:	48 85 c0             	test   %rax,%rax
  802788:	75 07                	jne    802791 <read+0xba>
		return -E_NOT_SUPP;
  80278a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80278f:	eb 19                	jmp    8027aa <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802791:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802795:	48 8b 40 10          	mov    0x10(%rax),%rax
  802799:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80279d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027a1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027a5:	48 89 cf             	mov    %rcx,%rdi
  8027a8:	ff d0                	callq  *%rax
}
  8027aa:	c9                   	leaveq 
  8027ab:	c3                   	retq   

00000000008027ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027ac:	55                   	push   %rbp
  8027ad:	48 89 e5             	mov    %rsp,%rbp
  8027b0:	48 83 ec 30          	sub    $0x30,%rsp
  8027b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027c6:	eb 49                	jmp    802811 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cb:	48 98                	cltq   
  8027cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d1:	48 29 c2             	sub    %rax,%rdx
  8027d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d7:	48 63 c8             	movslq %eax,%rcx
  8027da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027de:	48 01 c1             	add    %rax,%rcx
  8027e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e4:	48 89 ce             	mov    %rcx,%rsi
  8027e7:	89 c7                	mov    %eax,%edi
  8027e9:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  8027f0:	00 00 00 
  8027f3:	ff d0                	callq  *%rax
  8027f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027fc:	79 05                	jns    802803 <readn+0x57>
			return m;
  8027fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802801:	eb 1c                	jmp    80281f <readn+0x73>
		if (m == 0)
  802803:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802807:	75 02                	jne    80280b <readn+0x5f>
			break;
  802809:	eb 11                	jmp    80281c <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80280b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80280e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802811:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802814:	48 98                	cltq   
  802816:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80281a:	72 ac                	jb     8027c8 <readn+0x1c>
	}
	return tot;
  80281c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80281f:	c9                   	leaveq 
  802820:	c3                   	retq   

0000000000802821 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802821:	55                   	push   %rbp
  802822:	48 89 e5             	mov    %rsp,%rbp
  802825:	48 83 ec 40          	sub    $0x40,%rsp
  802829:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80282c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802830:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802834:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802838:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80283b:	48 89 d6             	mov    %rdx,%rsi
  80283e:	89 c7                	mov    %eax,%edi
  802840:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
  80284c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802853:	78 24                	js     802879 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802859:	8b 00                	mov    (%rax),%eax
  80285b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285f:	48 89 d6             	mov    %rdx,%rsi
  802862:	89 c7                	mov    %eax,%edi
  802864:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
  802870:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802873:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802877:	79 05                	jns    80287e <write+0x5d>
		return r;
  802879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287c:	eb 75                	jmp    8028f3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80287e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802882:	8b 40 08             	mov    0x8(%rax),%eax
  802885:	83 e0 03             	and    $0x3,%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	75 3a                	jne    8028c6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80288c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802893:	00 00 00 
  802896:	48 8b 00             	mov    (%rax),%rax
  802899:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80289f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028a2:	89 c6                	mov    %eax,%esi
  8028a4:	48 bf 4b 48 80 00 00 	movabs $0x80484b,%rdi
  8028ab:	00 00 00 
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b3:	48 b9 71 06 80 00 00 	movabs $0x800671,%rcx
  8028ba:	00 00 00 
  8028bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c4:	eb 2d                	jmp    8028f3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8028c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ca:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028ce:	48 85 c0             	test   %rax,%rax
  8028d1:	75 07                	jne    8028da <write+0xb9>
		return -E_NOT_SUPP;
  8028d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d8:	eb 19                	jmp    8028f3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028de:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028ea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028ee:	48 89 cf             	mov    %rcx,%rdi
  8028f1:	ff d0                	callq  *%rax
}
  8028f3:	c9                   	leaveq 
  8028f4:	c3                   	retq   

00000000008028f5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028f5:	55                   	push   %rbp
  8028f6:	48 89 e5             	mov    %rsp,%rbp
  8028f9:	48 83 ec 18          	sub    $0x18,%rsp
  8028fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802900:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802903:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802907:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80290a:	48 89 d6             	mov    %rdx,%rsi
  80290d:	89 c7                	mov    %eax,%edi
  80290f:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802922:	79 05                	jns    802929 <seek+0x34>
		return r;
  802924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802927:	eb 0f                	jmp    802938 <seek+0x43>
	fd->fd_offset = offset;
  802929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802930:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802938:	c9                   	leaveq 
  802939:	c3                   	retq   

000000000080293a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80293a:	55                   	push   %rbp
  80293b:	48 89 e5             	mov    %rsp,%rbp
  80293e:	48 83 ec 30          	sub    $0x30,%rsp
  802942:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802945:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802948:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80294c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80294f:	48 89 d6             	mov    %rdx,%rsi
  802952:	89 c7                	mov    %eax,%edi
  802954:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  80295b:	00 00 00 
  80295e:	ff d0                	callq  *%rax
  802960:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802963:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802967:	78 24                	js     80298d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296d:	8b 00                	mov    (%rax),%eax
  80296f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802973:	48 89 d6             	mov    %rdx,%rsi
  802976:	89 c7                	mov    %eax,%edi
  802978:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
  802984:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802987:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298b:	79 05                	jns    802992 <ftruncate+0x58>
		return r;
  80298d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802990:	eb 72                	jmp    802a04 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802996:	8b 40 08             	mov    0x8(%rax),%eax
  802999:	83 e0 03             	and    $0x3,%eax
  80299c:	85 c0                	test   %eax,%eax
  80299e:	75 3a                	jne    8029da <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029a0:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8029a7:	00 00 00 
  8029aa:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029b6:	89 c6                	mov    %eax,%esi
  8029b8:	48 bf 68 48 80 00 00 	movabs $0x804868,%rdi
  8029bf:	00 00 00 
  8029c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c7:	48 b9 71 06 80 00 00 	movabs $0x800671,%rcx
  8029ce:	00 00 00 
  8029d1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029d8:	eb 2a                	jmp    802a04 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029de:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029e2:	48 85 c0             	test   %rax,%rax
  8029e5:	75 07                	jne    8029ee <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029ec:	eb 16                	jmp    802a04 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029fa:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029fd:	89 ce                	mov    %ecx,%esi
  8029ff:	48 89 d7             	mov    %rdx,%rdi
  802a02:	ff d0                	callq  *%rax
}
  802a04:	c9                   	leaveq 
  802a05:	c3                   	retq   

0000000000802a06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a06:	55                   	push   %rbp
  802a07:	48 89 e5             	mov    %rsp,%rbp
  802a0a:	48 83 ec 30          	sub    $0x30,%rsp
  802a0e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a11:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a15:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a19:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a1c:	48 89 d6             	mov    %rdx,%rsi
  802a1f:	89 c7                	mov    %eax,%edi
  802a21:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802a28:	00 00 00 
  802a2b:	ff d0                	callq  *%rax
  802a2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a34:	78 24                	js     802a5a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3a:	8b 00                	mov    (%rax),%eax
  802a3c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a40:	48 89 d6             	mov    %rdx,%rsi
  802a43:	89 c7                	mov    %eax,%edi
  802a45:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  802a4c:	00 00 00 
  802a4f:	ff d0                	callq  *%rax
  802a51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a58:	79 05                	jns    802a5f <fstat+0x59>
		return r;
  802a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5d:	eb 5e                	jmp    802abd <fstat+0xb7>
	if (!dev->dev_stat)
  802a5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a63:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a67:	48 85 c0             	test   %rax,%rax
  802a6a:	75 07                	jne    802a73 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a6c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a71:	eb 4a                	jmp    802abd <fstat+0xb7>
	stat->st_name[0] = 0;
  802a73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a77:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a85:	00 00 00 
	stat->st_isdir = 0;
  802a88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a8c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a93:	00 00 00 
	stat->st_dev = dev;
  802a96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a9e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802aa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa9:	48 8b 40 28          	mov    0x28(%rax),%rax
  802aad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ab1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ab5:	48 89 ce             	mov    %rcx,%rsi
  802ab8:	48 89 d7             	mov    %rdx,%rdi
  802abb:	ff d0                	callq  *%rax
}
  802abd:	c9                   	leaveq 
  802abe:	c3                   	retq   

0000000000802abf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802abf:	55                   	push   %rbp
  802ac0:	48 89 e5             	mov    %rsp,%rbp
  802ac3:	48 83 ec 20          	sub    $0x20,%rsp
  802ac7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802acb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802acf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad3:	be 00 00 00 00       	mov    $0x0,%esi
  802ad8:	48 89 c7             	mov    %rax,%rdi
  802adb:	48 b8 af 2b 80 00 00 	movabs $0x802baf,%rax
  802ae2:	00 00 00 
  802ae5:	ff d0                	callq  *%rax
  802ae7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aee:	79 05                	jns    802af5 <stat+0x36>
		return fd;
  802af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af3:	eb 2f                	jmp    802b24 <stat+0x65>
	r = fstat(fd, stat);
  802af5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afc:	48 89 d6             	mov    %rdx,%rsi
  802aff:	89 c7                	mov    %eax,%edi
  802b01:	48 b8 06 2a 80 00 00 	movabs $0x802a06,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
  802b0d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b13:	89 c7                	mov    %eax,%edi
  802b15:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
	return r;
  802b21:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b24:	c9                   	leaveq 
  802b25:	c3                   	retq   

0000000000802b26 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b26:	55                   	push   %rbp
  802b27:	48 89 e5             	mov    %rsp,%rbp
  802b2a:	48 83 ec 10          	sub    $0x10,%rsp
  802b2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b35:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802b3c:	00 00 00 
  802b3f:	8b 00                	mov    (%rax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	75 1f                	jne    802b64 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b45:	bf 01 00 00 00       	mov    $0x1,%edi
  802b4a:	48 b8 4b 21 80 00 00 	movabs $0x80214b,%rax
  802b51:	00 00 00 
  802b54:	ff d0                	callq  *%rax
  802b56:	89 c2                	mov    %eax,%edx
  802b58:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802b5f:	00 00 00 
  802b62:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b64:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802b6b:	00 00 00 
  802b6e:	8b 00                	mov    (%rax),%eax
  802b70:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b73:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b78:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b7f:	00 00 00 
  802b82:	89 c7                	mov    %eax,%edi
  802b84:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b94:	ba 00 00 00 00       	mov    $0x0,%edx
  802b99:	48 89 c6             	mov    %rax,%rsi
  802b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba1:	48 b8 80 1f 80 00 00 	movabs $0x801f80,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
}
  802bad:	c9                   	leaveq 
  802bae:	c3                   	retq   

0000000000802baf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802baf:	55                   	push   %rbp
  802bb0:	48 89 e5             	mov    %rsp,%rbp
  802bb3:	48 83 ec 10          	sub    $0x10,%rsp
  802bb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bbb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802bbe:	48 ba 8e 48 80 00 00 	movabs $0x80488e,%rdx
  802bc5:	00 00 00 
  802bc8:	be 4c 00 00 00       	mov    $0x4c,%esi
  802bcd:	48 bf a3 48 80 00 00 	movabs $0x8048a3,%rdi
  802bd4:	00 00 00 
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdc:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  802be3:	00 00 00 
  802be6:	ff d1                	callq  *%rcx

0000000000802be8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802be8:	55                   	push   %rbp
  802be9:	48 89 e5             	mov    %rsp,%rbp
  802bec:	48 83 ec 10          	sub    $0x10,%rsp
  802bf0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf8:	8b 50 0c             	mov    0xc(%rax),%edx
  802bfb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c02:	00 00 00 
  802c05:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c07:	be 00 00 00 00       	mov    $0x0,%esi
  802c0c:	bf 06 00 00 00       	mov    $0x6,%edi
  802c11:	48 b8 26 2b 80 00 00 	movabs $0x802b26,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
}
  802c1d:	c9                   	leaveq 
  802c1e:	c3                   	retq   

0000000000802c1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c1f:	55                   	push   %rbp
  802c20:	48 89 e5             	mov    %rsp,%rbp
  802c23:	48 83 ec 20          	sub    $0x20,%rsp
  802c27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802c33:	48 ba ae 48 80 00 00 	movabs $0x8048ae,%rdx
  802c3a:	00 00 00 
  802c3d:	be 6b 00 00 00       	mov    $0x6b,%esi
  802c42:	48 bf a3 48 80 00 00 	movabs $0x8048a3,%rdi
  802c49:	00 00 00 
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  802c58:	00 00 00 
  802c5b:	ff d1                	callq  *%rcx

0000000000802c5d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c5d:	55                   	push   %rbp
  802c5e:	48 89 e5             	mov    %rsp,%rbp
  802c61:	48 83 ec 20          	sub    $0x20,%rsp
  802c65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c6d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802c71:	48 ba cb 48 80 00 00 	movabs $0x8048cb,%rdx
  802c78:	00 00 00 
  802c7b:	be 7b 00 00 00       	mov    $0x7b,%esi
  802c80:	48 bf a3 48 80 00 00 	movabs $0x8048a3,%rdi
  802c87:	00 00 00 
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  802c96:	00 00 00 
  802c99:	ff d1                	callq  *%rcx

0000000000802c9b <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c9b:	55                   	push   %rbp
  802c9c:	48 89 e5             	mov    %rsp,%rbp
  802c9f:	48 83 ec 20          	sub    $0x20,%rsp
  802ca3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caf:	8b 50 0c             	mov    0xc(%rax),%edx
  802cb2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cb9:	00 00 00 
  802cbc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802cbe:	be 00 00 00 00       	mov    $0x0,%esi
  802cc3:	bf 05 00 00 00       	mov    $0x5,%edi
  802cc8:	48 b8 26 2b 80 00 00 	movabs $0x802b26,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdb:	79 05                	jns    802ce2 <devfile_stat+0x47>
		return r;
  802cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce0:	eb 56                	jmp    802d38 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ce2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ced:	00 00 00 
  802cf0:	48 89 c7             	mov    %rax,%rdi
  802cf3:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802cff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d06:	00 00 00 
  802d09:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d13:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d19:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d20:	00 00 00 
  802d23:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d38:	c9                   	leaveq 
  802d39:	c3                   	retq   

0000000000802d3a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d3a:	55                   	push   %rbp
  802d3b:	48 89 e5             	mov    %rsp,%rbp
  802d3e:	48 83 ec 10          	sub    $0x10,%rsp
  802d42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d46:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d4d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d50:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d57:	00 00 00 
  802d5a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802d5c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d63:	00 00 00 
  802d66:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802d69:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d6c:	be 00 00 00 00       	mov    $0x0,%esi
  802d71:	bf 02 00 00 00       	mov    $0x2,%edi
  802d76:	48 b8 26 2b 80 00 00 	movabs $0x802b26,%rax
  802d7d:	00 00 00 
  802d80:	ff d0                	callq  *%rax
}
  802d82:	c9                   	leaveq 
  802d83:	c3                   	retq   

0000000000802d84 <remove>:

// Delete a file
int
remove(const char *path)
{
  802d84:	55                   	push   %rbp
  802d85:	48 89 e5             	mov    %rsp,%rbp
  802d88:	48 83 ec 10          	sub    $0x10,%rsp
  802d8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d94:	48 89 c7             	mov    %rax,%rdi
  802d97:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  802d9e:	00 00 00 
  802da1:	ff d0                	callq  *%rax
  802da3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802da8:	7e 07                	jle    802db1 <remove+0x2d>
		return -E_BAD_PATH;
  802daa:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802daf:	eb 33                	jmp    802de4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802db1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db5:	48 89 c6             	mov    %rax,%rsi
  802db8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802dbf:	00 00 00 
  802dc2:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  802dc9:	00 00 00 
  802dcc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802dce:	be 00 00 00 00       	mov    $0x0,%esi
  802dd3:	bf 07 00 00 00       	mov    $0x7,%edi
  802dd8:	48 b8 26 2b 80 00 00 	movabs $0x802b26,%rax
  802ddf:	00 00 00 
  802de2:	ff d0                	callq  *%rax
}
  802de4:	c9                   	leaveq 
  802de5:	c3                   	retq   

0000000000802de6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802de6:	55                   	push   %rbp
  802de7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802dea:	be 00 00 00 00       	mov    $0x0,%esi
  802def:	bf 08 00 00 00       	mov    $0x8,%edi
  802df4:	48 b8 26 2b 80 00 00 	movabs $0x802b26,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	callq  *%rax
}
  802e00:	5d                   	pop    %rbp
  802e01:	c3                   	retq   

0000000000802e02 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e02:	55                   	push   %rbp
  802e03:	48 89 e5             	mov    %rsp,%rbp
  802e06:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e0d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e14:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e1b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802e22:	be 00 00 00 00       	mov    $0x0,%esi
  802e27:	48 89 c7             	mov    %rax,%rdi
  802e2a:	48 b8 af 2b 80 00 00 	movabs $0x802baf,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3d:	79 28                	jns    802e67 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e42:	89 c6                	mov    %eax,%esi
  802e44:	48 bf e9 48 80 00 00 	movabs $0x8048e9,%rdi
  802e4b:	00 00 00 
  802e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e53:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  802e5a:	00 00 00 
  802e5d:	ff d2                	callq  *%rdx
		return fd_src;
  802e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e62:	e9 74 01 00 00       	jmpq   802fdb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802e67:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802e6e:	be 01 01 00 00       	mov    $0x101,%esi
  802e73:	48 89 c7             	mov    %rax,%rdi
  802e76:	48 b8 af 2b 80 00 00 	movabs $0x802baf,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
  802e82:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e89:	79 39                	jns    802ec4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e8e:	89 c6                	mov    %eax,%esi
  802e90:	48 bf ff 48 80 00 00 	movabs $0x8048ff,%rdi
  802e97:	00 00 00 
  802e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9f:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  802ea6:	00 00 00 
  802ea9:	ff d2                	callq  *%rdx
		close(fd_src);
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	89 c7                	mov    %eax,%edi
  802eb0:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
		return fd_dest;
  802ebc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ebf:	e9 17 01 00 00       	jmpq   802fdb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ec4:	eb 74                	jmp    802f3a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ec6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ec9:	48 63 d0             	movslq %eax,%rdx
  802ecc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ed3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ed6:	48 89 ce             	mov    %rcx,%rsi
  802ed9:	89 c7                	mov    %eax,%edi
  802edb:	48 b8 21 28 80 00 00 	movabs $0x802821,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
  802ee7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802eee:	79 4a                	jns    802f3a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802ef0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ef3:	89 c6                	mov    %eax,%esi
  802ef5:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
  802efc:	00 00 00 
  802eff:	b8 00 00 00 00       	mov    $0x0,%eax
  802f04:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  802f0b:	00 00 00 
  802f0e:	ff d2                	callq  *%rdx
			close(fd_src);
  802f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f13:	89 c7                	mov    %eax,%edi
  802f15:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802f1c:	00 00 00 
  802f1f:	ff d0                	callq  *%rax
			close(fd_dest);
  802f21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f24:	89 c7                	mov    %eax,%edi
  802f26:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
			return write_size;
  802f32:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f35:	e9 a1 00 00 00       	jmpq   802fdb <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f3a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f44:	ba 00 02 00 00       	mov    $0x200,%edx
  802f49:	48 89 ce             	mov    %rcx,%rsi
  802f4c:	89 c7                	mov    %eax,%edi
  802f4e:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
  802f5a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f61:	0f 8f 5f ff ff ff    	jg     802ec6 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f6b:	79 47                	jns    802fb4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802f6d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f70:	89 c6                	mov    %eax,%esi
  802f72:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
  802f79:	00 00 00 
  802f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f81:	48 ba 71 06 80 00 00 	movabs $0x800671,%rdx
  802f88:	00 00 00 
  802f8b:	ff d2                	callq  *%rdx
		close(fd_src);
  802f8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f90:	89 c7                	mov    %eax,%edi
  802f92:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
		close(fd_dest);
  802f9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa1:	89 c7                	mov    %eax,%edi
  802fa3:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802faa:	00 00 00 
  802fad:	ff d0                	callq  *%rax
		return read_size;
  802faf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fb2:	eb 27                	jmp    802fdb <copy+0x1d9>
	}
	close(fd_src);
  802fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb7:	89 c7                	mov    %eax,%edi
  802fb9:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
	close(fd_dest);
  802fc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc8:	89 c7                	mov    %eax,%edi
  802fca:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  802fd1:	00 00 00 
  802fd4:	ff d0                	callq  *%rax
	return 0;
  802fd6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802fdb:	c9                   	leaveq 
  802fdc:	c3                   	retq   

0000000000802fdd <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802fdd:	55                   	push   %rbp
  802fde:	48 89 e5             	mov    %rsp,%rbp
  802fe1:	48 83 ec 20          	sub    $0x20,%rsp
  802fe5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802fe8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fef:	48 89 d6             	mov    %rdx,%rsi
  802ff2:	89 c7                	mov    %eax,%edi
  802ff4:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802ffb:	00 00 00 
  802ffe:	ff d0                	callq  *%rax
  803000:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803003:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803007:	79 05                	jns    80300e <fd2sockid+0x31>
		return r;
  803009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300c:	eb 24                	jmp    803032 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80300e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803012:	8b 10                	mov    (%rax),%edx
  803014:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80301b:	00 00 00 
  80301e:	8b 00                	mov    (%rax),%eax
  803020:	39 c2                	cmp    %eax,%edx
  803022:	74 07                	je     80302b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803024:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803029:	eb 07                	jmp    803032 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80302b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803032:	c9                   	leaveq 
  803033:	c3                   	retq   

0000000000803034 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803034:	55                   	push   %rbp
  803035:	48 89 e5             	mov    %rsp,%rbp
  803038:	48 83 ec 20          	sub    $0x20,%rsp
  80303c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80303f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803043:	48 89 c7             	mov    %rax,%rdi
  803046:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803055:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803059:	78 26                	js     803081 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80305b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305f:	ba 07 04 00 00       	mov    $0x407,%edx
  803064:	48 89 c6             	mov    %rax,%rsi
  803067:	bf 00 00 00 00       	mov    $0x0,%edi
  80306c:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
  803078:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307f:	79 16                	jns    803097 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803081:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803084:	89 c7                	mov    %eax,%edi
  803086:	48 b8 43 35 80 00 00 	movabs $0x803543,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
		return r;
  803092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803095:	eb 3a                	jmp    8030d1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309b:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8030a2:	00 00 00 
  8030a5:	8b 12                	mov    (%rdx),%edx
  8030a7:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8030a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ad:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8030b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030bb:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8030be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c2:	48 89 c7             	mov    %rax,%rdi
  8030c5:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
}
  8030d1:	c9                   	leaveq 
  8030d2:	c3                   	retq   

00000000008030d3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8030d3:	55                   	push   %rbp
  8030d4:	48 89 e5             	mov    %rsp,%rbp
  8030d7:	48 83 ec 30          	sub    $0x30,%rsp
  8030db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030e9:	89 c7                	mov    %eax,%edi
  8030eb:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
  8030f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fe:	79 05                	jns    803105 <accept+0x32>
		return r;
  803100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803103:	eb 3b                	jmp    803140 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803105:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803109:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80310d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803110:	48 89 ce             	mov    %rcx,%rsi
  803113:	89 c7                	mov    %eax,%edi
  803115:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
  803121:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803128:	79 05                	jns    80312f <accept+0x5c>
		return r;
  80312a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312d:	eb 11                	jmp    803140 <accept+0x6d>
	return alloc_sockfd(r);
  80312f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803132:	89 c7                	mov    %eax,%edi
  803134:	48 b8 34 30 80 00 00 	movabs $0x803034,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	callq  *%rax
}
  803140:	c9                   	leaveq 
  803141:	c3                   	retq   

0000000000803142 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803142:	55                   	push   %rbp
  803143:	48 89 e5             	mov    %rsp,%rbp
  803146:	48 83 ec 20          	sub    $0x20,%rsp
  80314a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80314d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803151:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803154:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803157:	89 c7                	mov    %eax,%edi
  803159:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316c:	79 05                	jns    803173 <bind+0x31>
		return r;
  80316e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803171:	eb 1b                	jmp    80318e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803173:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803176:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80317a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317d:	48 89 ce             	mov    %rcx,%rsi
  803180:	89 c7                	mov    %eax,%edi
  803182:	48 b8 9f 34 80 00 00 	movabs $0x80349f,%rax
  803189:	00 00 00 
  80318c:	ff d0                	callq  *%rax
}
  80318e:	c9                   	leaveq 
  80318f:	c3                   	retq   

0000000000803190 <shutdown>:

int
shutdown(int s, int how)
{
  803190:	55                   	push   %rbp
  803191:	48 89 e5             	mov    %rsp,%rbp
  803194:	48 83 ec 20          	sub    $0x20,%rsp
  803198:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80319b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80319e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031a1:	89 c7                	mov    %eax,%edi
  8031a3:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b6:	79 05                	jns    8031bd <shutdown+0x2d>
		return r;
  8031b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031bb:	eb 16                	jmp    8031d3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8031bd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c3:	89 d6                	mov    %edx,%esi
  8031c5:	89 c7                	mov    %eax,%edi
  8031c7:	48 b8 03 35 80 00 00 	movabs $0x803503,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
}
  8031d3:	c9                   	leaveq 
  8031d4:	c3                   	retq   

00000000008031d5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8031d5:	55                   	push   %rbp
  8031d6:	48 89 e5             	mov    %rsp,%rbp
  8031d9:	48 83 ec 10          	sub    $0x10,%rsp
  8031dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8031e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031e5:	48 89 c7             	mov    %rax,%rdi
  8031e8:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
  8031f4:	83 f8 01             	cmp    $0x1,%eax
  8031f7:	75 17                	jne    803210 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8031f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031fd:	8b 40 0c             	mov    0xc(%rax),%eax
  803200:	89 c7                	mov    %eax,%edi
  803202:	48 b8 43 35 80 00 00 	movabs $0x803543,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	eb 05                	jmp    803215 <devsock_close+0x40>
	else
		return 0;
  803210:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803215:	c9                   	leaveq 
  803216:	c3                   	retq   

0000000000803217 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803217:	55                   	push   %rbp
  803218:	48 89 e5             	mov    %rsp,%rbp
  80321b:	48 83 ec 20          	sub    $0x20,%rsp
  80321f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803222:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803226:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803229:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80322c:	89 c7                	mov    %eax,%edi
  80322e:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  803235:	00 00 00 
  803238:	ff d0                	callq  *%rax
  80323a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803241:	79 05                	jns    803248 <connect+0x31>
		return r;
  803243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803246:	eb 1b                	jmp    803263 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803248:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80324b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80324f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803252:	48 89 ce             	mov    %rcx,%rsi
  803255:	89 c7                	mov    %eax,%edi
  803257:	48 b8 70 35 80 00 00 	movabs $0x803570,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
}
  803263:	c9                   	leaveq 
  803264:	c3                   	retq   

0000000000803265 <listen>:

int
listen(int s, int backlog)
{
  803265:	55                   	push   %rbp
  803266:	48 89 e5             	mov    %rsp,%rbp
  803269:	48 83 ec 20          	sub    $0x20,%rsp
  80326d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803270:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803273:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803276:	89 c7                	mov    %eax,%edi
  803278:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
  803284:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803287:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80328b:	79 05                	jns    803292 <listen+0x2d>
		return r;
  80328d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803290:	eb 16                	jmp    8032a8 <listen+0x43>
	return nsipc_listen(r, backlog);
  803292:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803298:	89 d6                	mov    %edx,%esi
  80329a:	89 c7                	mov    %eax,%edi
  80329c:	48 b8 d4 35 80 00 00 	movabs $0x8035d4,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
}
  8032a8:	c9                   	leaveq 
  8032a9:	c3                   	retq   

00000000008032aa <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8032aa:	55                   	push   %rbp
  8032ab:	48 89 e5             	mov    %rsp,%rbp
  8032ae:	48 83 ec 20          	sub    $0x20,%rsp
  8032b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8032be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c2:	89 c2                	mov    %eax,%edx
  8032c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c8:	8b 40 0c             	mov    0xc(%rax),%eax
  8032cb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8032cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8032d4:	89 c7                	mov    %eax,%edi
  8032d6:	48 b8 14 36 80 00 00 	movabs $0x803614,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
}
  8032e2:	c9                   	leaveq 
  8032e3:	c3                   	retq   

00000000008032e4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8032e4:	55                   	push   %rbp
  8032e5:	48 89 e5             	mov    %rsp,%rbp
  8032e8:	48 83 ec 20          	sub    $0x20,%rsp
  8032ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8032f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fc:	89 c2                	mov    %eax,%edx
  8032fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803302:	8b 40 0c             	mov    0xc(%rax),%eax
  803305:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803309:	b9 00 00 00 00       	mov    $0x0,%ecx
  80330e:	89 c7                	mov    %eax,%edi
  803310:	48 b8 e0 36 80 00 00 	movabs $0x8036e0,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
}
  80331c:	c9                   	leaveq 
  80331d:	c3                   	retq   

000000000080331e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80331e:	55                   	push   %rbp
  80331f:	48 89 e5             	mov    %rsp,%rbp
  803322:	48 83 ec 10          	sub    $0x10,%rsp
  803326:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80332a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80332e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803332:	48 be 47 49 80 00 00 	movabs $0x804947,%rsi
  803339:	00 00 00 
  80333c:	48 89 c7             	mov    %rax,%rdi
  80333f:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax
	return 0;
  80334b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803350:	c9                   	leaveq 
  803351:	c3                   	retq   

0000000000803352 <socket>:

int
socket(int domain, int type, int protocol)
{
  803352:	55                   	push   %rbp
  803353:	48 89 e5             	mov    %rsp,%rbp
  803356:	48 83 ec 20          	sub    $0x20,%rsp
  80335a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80335d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803360:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803363:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803366:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803369:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336c:	89 ce                	mov    %ecx,%esi
  80336e:	89 c7                	mov    %eax,%edi
  803370:	48 b8 98 37 80 00 00 	movabs $0x803798,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803383:	79 05                	jns    80338a <socket+0x38>
		return r;
  803385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803388:	eb 11                	jmp    80339b <socket+0x49>
	return alloc_sockfd(r);
  80338a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338d:	89 c7                	mov    %eax,%edi
  80338f:	48 b8 34 30 80 00 00 	movabs $0x803034,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 10          	sub    $0x10,%rsp
  8033a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8033a8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033af:	00 00 00 
  8033b2:	8b 00                	mov    (%rax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	75 1f                	jne    8033d7 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8033b8:	bf 02 00 00 00       	mov    $0x2,%edi
  8033bd:	48 b8 4b 21 80 00 00 	movabs $0x80214b,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	89 c2                	mov    %eax,%edx
  8033cb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033d2:	00 00 00 
  8033d5:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8033d7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033de:	00 00 00 
  8033e1:	8b 00                	mov    (%rax),%eax
  8033e3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033eb:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8033f2:	00 00 00 
  8033f5:	89 c7                	mov    %eax,%edi
  8033f7:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803403:	ba 00 00 00 00       	mov    $0x0,%edx
  803408:	be 00 00 00 00       	mov    $0x0,%esi
  80340d:	bf 00 00 00 00       	mov    $0x0,%edi
  803412:	48 b8 80 1f 80 00 00 	movabs $0x801f80,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
}
  80341e:	c9                   	leaveq 
  80341f:	c3                   	retq   

0000000000803420 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803420:	55                   	push   %rbp
  803421:	48 89 e5             	mov    %rsp,%rbp
  803424:	48 83 ec 30          	sub    $0x30,%rsp
  803428:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80342b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80342f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803433:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80343a:	00 00 00 
  80343d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803440:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803442:	bf 01 00 00 00       	mov    $0x1,%edi
  803447:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  80344e:	00 00 00 
  803451:	ff d0                	callq  *%rax
  803453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803456:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345a:	78 3e                	js     80349a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80345c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803463:	00 00 00 
  803466:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80346a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346e:	8b 40 10             	mov    0x10(%rax),%eax
  803471:	89 c2                	mov    %eax,%edx
  803473:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347b:	48 89 ce             	mov    %rcx,%rsi
  80347e:	48 89 c7             	mov    %rax,%rdi
  803481:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  803488:	00 00 00 
  80348b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80348d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803491:	8b 50 10             	mov    0x10(%rax),%edx
  803494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803498:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80349a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80349d:	c9                   	leaveq 
  80349e:	c3                   	retq   

000000000080349f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80349f:	55                   	push   %rbp
  8034a0:	48 89 e5             	mov    %rsp,%rbp
  8034a3:	48 83 ec 10          	sub    $0x10,%rsp
  8034a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034ae:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8034b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b8:	00 00 00 
  8034bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034be:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8034c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c7:	48 89 c6             	mov    %rax,%rsi
  8034ca:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8034d1:	00 00 00 
  8034d4:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8034e0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e7:	00 00 00 
  8034ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034ed:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8034f0:	bf 02 00 00 00       	mov    $0x2,%edi
  8034f5:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
}
  803501:	c9                   	leaveq 
  803502:	c3                   	retq   

0000000000803503 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803503:	55                   	push   %rbp
  803504:	48 89 e5             	mov    %rsp,%rbp
  803507:	48 83 ec 10          	sub    $0x10,%rsp
  80350b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80350e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803511:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803518:	00 00 00 
  80351b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80351e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803520:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803527:	00 00 00 
  80352a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80352d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803530:	bf 03 00 00 00       	mov    $0x3,%edi
  803535:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  80353c:	00 00 00 
  80353f:	ff d0                	callq  *%rax
}
  803541:	c9                   	leaveq 
  803542:	c3                   	retq   

0000000000803543 <nsipc_close>:

int
nsipc_close(int s)
{
  803543:	55                   	push   %rbp
  803544:	48 89 e5             	mov    %rsp,%rbp
  803547:	48 83 ec 10          	sub    $0x10,%rsp
  80354b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80354e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803555:	00 00 00 
  803558:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80355b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80355d:	bf 04 00 00 00       	mov    $0x4,%edi
  803562:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
}
  80356e:	c9                   	leaveq 
  80356f:	c3                   	retq   

0000000000803570 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803570:	55                   	push   %rbp
  803571:	48 89 e5             	mov    %rsp,%rbp
  803574:	48 83 ec 10          	sub    $0x10,%rsp
  803578:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80357b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80357f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803582:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803589:	00 00 00 
  80358c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80358f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803591:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803598:	48 89 c6             	mov    %rax,%rsi
  80359b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8035a2:	00 00 00 
  8035a5:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8035b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b8:	00 00 00 
  8035bb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035be:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8035c1:	bf 05 00 00 00       	mov    $0x5,%edi
  8035c6:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   

00000000008035d4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8035d4:	55                   	push   %rbp
  8035d5:	48 89 e5             	mov    %rsp,%rbp
  8035d8:	48 83 ec 10          	sub    $0x10,%rsp
  8035dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035df:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8035e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035e9:	00 00 00 
  8035ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035ef:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8035f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f8:	00 00 00 
  8035fb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803601:	bf 06 00 00 00       	mov    $0x6,%edi
  803606:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
}
  803612:	c9                   	leaveq 
  803613:	c3                   	retq   

0000000000803614 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803614:	55                   	push   %rbp
  803615:	48 89 e5             	mov    %rsp,%rbp
  803618:	48 83 ec 30          	sub    $0x30,%rsp
  80361c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80361f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803623:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803626:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803629:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803630:	00 00 00 
  803633:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803636:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803638:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80363f:	00 00 00 
  803642:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803645:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803648:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364f:	00 00 00 
  803652:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803655:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803658:	bf 07 00 00 00       	mov    $0x7,%edi
  80365d:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
  803669:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803670:	78 69                	js     8036db <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803672:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803679:	7f 08                	jg     803683 <nsipc_recv+0x6f>
  80367b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803681:	7e 35                	jle    8036b8 <nsipc_recv+0xa4>
  803683:	48 b9 4e 49 80 00 00 	movabs $0x80494e,%rcx
  80368a:	00 00 00 
  80368d:	48 ba 63 49 80 00 00 	movabs $0x804963,%rdx
  803694:	00 00 00 
  803697:	be 61 00 00 00       	mov    $0x61,%esi
  80369c:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  8036a3:	00 00 00 
  8036a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ab:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  8036b2:	00 00 00 
  8036b5:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8036b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bb:	48 63 d0             	movslq %eax,%rdx
  8036be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c2:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8036c9:	00 00 00 
  8036cc:	48 89 c7             	mov    %rax,%rdi
  8036cf:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
	}

	return r;
  8036db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036de:	c9                   	leaveq 
  8036df:	c3                   	retq   

00000000008036e0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8036e0:	55                   	push   %rbp
  8036e1:	48 89 e5             	mov    %rsp,%rbp
  8036e4:	48 83 ec 20          	sub    $0x20,%rsp
  8036e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036ef:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8036f2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8036f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fc:	00 00 00 
  8036ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803702:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803704:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80370b:	7e 35                	jle    803742 <nsipc_send+0x62>
  80370d:	48 b9 84 49 80 00 00 	movabs $0x804984,%rcx
  803714:	00 00 00 
  803717:	48 ba 63 49 80 00 00 	movabs $0x804963,%rdx
  80371e:	00 00 00 
  803721:	be 6c 00 00 00       	mov    $0x6c,%esi
  803726:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  80372d:	00 00 00 
  803730:	b8 00 00 00 00       	mov    $0x0,%eax
  803735:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  80373c:	00 00 00 
  80373f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803742:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803745:	48 63 d0             	movslq %eax,%rdx
  803748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374c:	48 89 c6             	mov    %rax,%rsi
  80374f:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803756:	00 00 00 
  803759:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803765:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376c:	00 00 00 
  80376f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803772:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803775:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80377c:	00 00 00 
  80377f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803782:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803785:	bf 08 00 00 00       	mov    $0x8,%edi
  80378a:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 10          	sub    $0x10,%rsp
  8037a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037a3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8037a6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8037a9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b0:	00 00 00 
  8037b3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037b6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8037b8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037bf:	00 00 00 
  8037c2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037c5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8037c8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037cf:	00 00 00 
  8037d2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037d5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8037d8:	bf 09 00 00 00       	mov    $0x9,%edi
  8037dd:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
}
  8037e9:	c9                   	leaveq 
  8037ea:	c3                   	retq   

00000000008037eb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8037eb:	55                   	push   %rbp
  8037ec:	48 89 e5             	mov    %rsp,%rbp
  8037ef:	53                   	push   %rbx
  8037f0:	48 83 ec 38          	sub    $0x38,%rsp
  8037f4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037f8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8037fc:	48 89 c7             	mov    %rax,%rdi
  8037ff:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  803806:	00 00 00 
  803809:	ff d0                	callq  *%rax
  80380b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80380e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803812:	0f 88 bf 01 00 00    	js     8039d7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381c:	ba 07 04 00 00       	mov    $0x407,%edx
  803821:	48 89 c6             	mov    %rax,%rsi
  803824:	bf 00 00 00 00       	mov    $0x0,%edi
  803829:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
  803835:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803838:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80383c:	0f 88 95 01 00 00    	js     8039d7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803842:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803846:	48 89 c7             	mov    %rax,%rdi
  803849:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
  803855:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803858:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80385c:	0f 88 5d 01 00 00    	js     8039bf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803862:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803866:	ba 07 04 00 00       	mov    $0x407,%edx
  80386b:	48 89 c6             	mov    %rax,%rsi
  80386e:	bf 00 00 00 00       	mov    $0x0,%edi
  803873:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
  80387f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803882:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803886:	0f 88 33 01 00 00    	js     8039bf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80388c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803890:	48 89 c7             	mov    %rax,%rdi
  803893:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a7:	ba 07 04 00 00       	mov    $0x407,%edx
  8038ac:	48 89 c6             	mov    %rax,%rsi
  8038af:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b4:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8038bb:	00 00 00 
  8038be:	ff d0                	callq  *%rax
  8038c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038c7:	79 05                	jns    8038ce <pipe+0xe3>
		goto err2;
  8038c9:	e9 d9 00 00 00       	jmpq   8039a7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d2:	48 89 c7             	mov    %rax,%rdi
  8038d5:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
  8038e1:	48 89 c2             	mov    %rax,%rdx
  8038e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8038ee:	48 89 d1             	mov    %rdx,%rcx
  8038f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8038f6:	48 89 c6             	mov    %rax,%rsi
  8038f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038fe:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80390d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803911:	79 1b                	jns    80392e <pipe+0x143>
		goto err3;
  803913:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803914:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803918:	48 89 c6             	mov    %rax,%rsi
  80391b:	bf 00 00 00 00       	mov    $0x0,%edi
  803920:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803927:	00 00 00 
  80392a:	ff d0                	callq  *%rax
  80392c:	eb 79                	jmp    8039a7 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  80392e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803932:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803939:	00 00 00 
  80393c:	8b 12                	mov    (%rdx),%edx
  80393e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803944:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80394b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80394f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803956:	00 00 00 
  803959:	8b 12                	mov    (%rdx),%edx
  80395b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80395d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803961:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396c:	48 89 c7             	mov    %rax,%rdi
  80396f:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
  80397b:	89 c2                	mov    %eax,%edx
  80397d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803981:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803983:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803987:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80398b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80398f:	48 89 c7             	mov    %rax,%rdi
  803992:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  803999:	00 00 00 
  80399c:	ff d0                	callq  *%rax
  80399e:	89 03                	mov    %eax,(%rbx)
	return 0;
  8039a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a5:	eb 33                	jmp    8039da <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8039a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ab:	48 89 c6             	mov    %rax,%rsi
  8039ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b3:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8039ba:	00 00 00 
  8039bd:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8039bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c3:	48 89 c6             	mov    %rax,%rsi
  8039c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8039cb:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
err:
	return r;
  8039d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039da:	48 83 c4 38          	add    $0x38,%rsp
  8039de:	5b                   	pop    %rbx
  8039df:	5d                   	pop    %rbp
  8039e0:	c3                   	retq   

00000000008039e1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039e1:	55                   	push   %rbp
  8039e2:	48 89 e5             	mov    %rsp,%rbp
  8039e5:	53                   	push   %rbx
  8039e6:	48 83 ec 28          	sub    $0x28,%rsp
  8039ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8039f2:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8039f9:	00 00 00 
  8039fc:	48 8b 00             	mov    (%rax),%rax
  8039ff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a05:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0c:	48 89 c7             	mov    %rax,%rdi
  803a0f:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  803a16:	00 00 00 
  803a19:	ff d0                	callq  *%rax
  803a1b:	89 c3                	mov    %eax,%ebx
  803a1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a21:	48 89 c7             	mov    %rax,%rdi
  803a24:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
  803a30:	39 c3                	cmp    %eax,%ebx
  803a32:	0f 94 c0             	sete   %al
  803a35:	0f b6 c0             	movzbl %al,%eax
  803a38:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a3b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803a42:	00 00 00 
  803a45:	48 8b 00             	mov    (%rax),%rax
  803a48:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a4e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a54:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a57:	75 05                	jne    803a5e <_pipeisclosed+0x7d>
			return ret;
  803a59:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a5c:	eb 4a                	jmp    803aa8 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803a5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a61:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a64:	74 3d                	je     803aa3 <_pipeisclosed+0xc2>
  803a66:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a6a:	75 37                	jne    803aa3 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a6c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803a73:	00 00 00 
  803a76:	48 8b 00             	mov    (%rax),%rax
  803a79:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a7f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a85:	89 c6                	mov    %eax,%esi
  803a87:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  803a8e:	00 00 00 
  803a91:	b8 00 00 00 00       	mov    $0x0,%eax
  803a96:	49 b8 71 06 80 00 00 	movabs $0x800671,%r8
  803a9d:	00 00 00 
  803aa0:	41 ff d0             	callq  *%r8
	}
  803aa3:	e9 4a ff ff ff       	jmpq   8039f2 <_pipeisclosed+0x11>
}
  803aa8:	48 83 c4 28          	add    $0x28,%rsp
  803aac:	5b                   	pop    %rbx
  803aad:	5d                   	pop    %rbp
  803aae:	c3                   	retq   

0000000000803aaf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803aaf:	55                   	push   %rbp
  803ab0:	48 89 e5             	mov    %rsp,%rbp
  803ab3:	48 83 ec 30          	sub    $0x30,%rsp
  803ab7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803aba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803abe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ac1:	48 89 d6             	mov    %rdx,%rsi
  803ac4:	89 c7                	mov    %eax,%edi
  803ac6:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  803acd:	00 00 00 
  803ad0:	ff d0                	callq  *%rax
  803ad2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad9:	79 05                	jns    803ae0 <pipeisclosed+0x31>
		return r;
  803adb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ade:	eb 31                	jmp    803b11 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae4:	48 89 c7             	mov    %rax,%rdi
  803ae7:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803aee:	00 00 00 
  803af1:	ff d0                	callq  *%rax
  803af3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803afb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aff:	48 89 d6             	mov    %rdx,%rsi
  803b02:	48 89 c7             	mov    %rax,%rdi
  803b05:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  803b0c:	00 00 00 
  803b0f:	ff d0                	callq  *%rax
}
  803b11:	c9                   	leaveq 
  803b12:	c3                   	retq   

0000000000803b13 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b13:	55                   	push   %rbp
  803b14:	48 89 e5             	mov    %rsp,%rbp
  803b17:	48 83 ec 40          	sub    $0x40,%rsp
  803b1b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b1f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b23:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b2b:	48 89 c7             	mov    %rax,%rdi
  803b2e:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
  803b3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b46:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b4d:	00 
  803b4e:	e9 92 00 00 00       	jmpq   803be5 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b53:	eb 41                	jmp    803b96 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b55:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b5a:	74 09                	je     803b65 <devpipe_read+0x52>
				return i;
  803b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b60:	e9 92 00 00 00       	jmpq   803bf7 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6d:	48 89 d6             	mov    %rdx,%rsi
  803b70:	48 89 c7             	mov    %rax,%rdi
  803b73:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax
  803b7f:	85 c0                	test   %eax,%eax
  803b81:	74 07                	je     803b8a <devpipe_read+0x77>
				return 0;
  803b83:	b8 00 00 00 00       	mov    $0x0,%eax
  803b88:	eb 6d                	jmp    803bf7 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b8a:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803b96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9a:	8b 10                	mov    (%rax),%edx
  803b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba0:	8b 40 04             	mov    0x4(%rax),%eax
  803ba3:	39 c2                	cmp    %eax,%edx
  803ba5:	74 ae                	je     803b55 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ba7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803baf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb7:	8b 00                	mov    (%rax),%eax
  803bb9:	99                   	cltd   
  803bba:	c1 ea 1b             	shr    $0x1b,%edx
  803bbd:	01 d0                	add    %edx,%eax
  803bbf:	83 e0 1f             	and    $0x1f,%eax
  803bc2:	29 d0                	sub    %edx,%eax
  803bc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bc8:	48 98                	cltq   
  803bca:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803bcf:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd5:	8b 00                	mov    (%rax),%eax
  803bd7:	8d 50 01             	lea    0x1(%rax),%edx
  803bda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bde:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803be0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bed:	0f 82 60 ff ff ff    	jb     803b53 <devpipe_read+0x40>
	}
	return i;
  803bf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bf7:	c9                   	leaveq 
  803bf8:	c3                   	retq   

0000000000803bf9 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bf9:	55                   	push   %rbp
  803bfa:	48 89 e5             	mov    %rsp,%rbp
  803bfd:	48 83 ec 40          	sub    $0x40,%rsp
  803c01:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c05:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c09:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c11:	48 89 c7             	mov    %rax,%rdi
  803c14:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
  803c20:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c2c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c33:	00 
  803c34:	e9 91 00 00 00       	jmpq   803cca <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c39:	eb 31                	jmp    803c6c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c43:	48 89 d6             	mov    %rdx,%rsi
  803c46:	48 89 c7             	mov    %rax,%rdi
  803c49:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	85 c0                	test   %eax,%eax
  803c57:	74 07                	je     803c60 <devpipe_write+0x67>
				return 0;
  803c59:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5e:	eb 7c                	jmp    803cdc <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c60:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803c67:	00 00 00 
  803c6a:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c70:	8b 40 04             	mov    0x4(%rax),%eax
  803c73:	48 63 d0             	movslq %eax,%rdx
  803c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7a:	8b 00                	mov    (%rax),%eax
  803c7c:	48 98                	cltq   
  803c7e:	48 83 c0 20          	add    $0x20,%rax
  803c82:	48 39 c2             	cmp    %rax,%rdx
  803c85:	73 b4                	jae    803c3b <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8b:	8b 40 04             	mov    0x4(%rax),%eax
  803c8e:	99                   	cltd   
  803c8f:	c1 ea 1b             	shr    $0x1b,%edx
  803c92:	01 d0                	add    %edx,%eax
  803c94:	83 e0 1f             	and    $0x1f,%eax
  803c97:	29 d0                	sub    %edx,%eax
  803c99:	89 c6                	mov    %eax,%esi
  803c9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca3:	48 01 d0             	add    %rdx,%rax
  803ca6:	0f b6 08             	movzbl (%rax),%ecx
  803ca9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cad:	48 63 c6             	movslq %esi,%rax
  803cb0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb8:	8b 40 04             	mov    0x4(%rax),%eax
  803cbb:	8d 50 01             	lea    0x1(%rax),%edx
  803cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc2:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803cc5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cd2:	0f 82 61 ff ff ff    	jb     803c39 <devpipe_write+0x40>
	}

	return i;
  803cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803cdc:	c9                   	leaveq 
  803cdd:	c3                   	retq   

0000000000803cde <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803cde:	55                   	push   %rbp
  803cdf:	48 89 e5             	mov    %rsp,%rbp
  803ce2:	48 83 ec 20          	sub    $0x20,%rsp
  803ce6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf2:	48 89 c7             	mov    %rax,%rdi
  803cf5:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803cfc:	00 00 00 
  803cff:	ff d0                	callq  *%rax
  803d01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d09:	48 be a8 49 80 00 00 	movabs $0x8049a8,%rsi
  803d10:	00 00 00 
  803d13:	48 89 c7             	mov    %rax,%rdi
  803d16:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  803d1d:	00 00 00 
  803d20:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d26:	8b 50 04             	mov    0x4(%rax),%edx
  803d29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d2d:	8b 00                	mov    (%rax),%eax
  803d2f:	29 c2                	sub    %eax,%edx
  803d31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d35:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d3f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d46:	00 00 00 
	stat->st_dev = &devpipe;
  803d49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d4d:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803d54:	00 00 00 
  803d57:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d63:	c9                   	leaveq 
  803d64:	c3                   	retq   

0000000000803d65 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d65:	55                   	push   %rbp
  803d66:	48 89 e5             	mov    %rsp,%rbp
  803d69:	48 83 ec 10          	sub    $0x10,%rsp
  803d6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d75:	48 89 c6             	mov    %rax,%rsi
  803d78:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7d:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803d84:	00 00 00 
  803d87:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d8d:	48 89 c7             	mov    %rax,%rdi
  803d90:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803d97:	00 00 00 
  803d9a:	ff d0                	callq  *%rax
  803d9c:	48 89 c6             	mov    %rax,%rsi
  803d9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803da4:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803dab:	00 00 00 
  803dae:	ff d0                	callq  *%rax
}
  803db0:	c9                   	leaveq 
  803db1:	c3                   	retq   

0000000000803db2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803db2:	55                   	push   %rbp
  803db3:	48 89 e5             	mov    %rsp,%rbp
  803db6:	48 83 ec 20          	sub    $0x20,%rsp
  803dba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803dbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc0:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803dc3:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803dc7:	be 01 00 00 00       	mov    $0x1,%esi
  803dcc:	48 89 c7             	mov    %rax,%rdi
  803dcf:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  803dd6:	00 00 00 
  803dd9:	ff d0                	callq  *%rax
}
  803ddb:	c9                   	leaveq 
  803ddc:	c3                   	retq   

0000000000803ddd <getchar>:

int
getchar(void)
{
  803ddd:	55                   	push   %rbp
  803dde:	48 89 e5             	mov    %rsp,%rbp
  803de1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803de5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803de9:	ba 01 00 00 00       	mov    $0x1,%edx
  803dee:	48 89 c6             	mov    %rax,%rsi
  803df1:	bf 00 00 00 00       	mov    $0x0,%edi
  803df6:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
  803e02:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e09:	79 05                	jns    803e10 <getchar+0x33>
		return r;
  803e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0e:	eb 14                	jmp    803e24 <getchar+0x47>
	if (r < 1)
  803e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e14:	7f 07                	jg     803e1d <getchar+0x40>
		return -E_EOF;
  803e16:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e1b:	eb 07                	jmp    803e24 <getchar+0x47>
	return c;
  803e1d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e21:	0f b6 c0             	movzbl %al,%eax
}
  803e24:	c9                   	leaveq 
  803e25:	c3                   	retq   

0000000000803e26 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e26:	55                   	push   %rbp
  803e27:	48 89 e5             	mov    %rsp,%rbp
  803e2a:	48 83 ec 20          	sub    $0x20,%rsp
  803e2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e31:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e38:	48 89 d6             	mov    %rdx,%rsi
  803e3b:	89 c7                	mov    %eax,%edi
  803e3d:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  803e44:	00 00 00 
  803e47:	ff d0                	callq  *%rax
  803e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e50:	79 05                	jns    803e57 <iscons+0x31>
		return r;
  803e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e55:	eb 1a                	jmp    803e71 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5b:	8b 10                	mov    (%rax),%edx
  803e5d:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803e64:	00 00 00 
  803e67:	8b 00                	mov    (%rax),%eax
  803e69:	39 c2                	cmp    %eax,%edx
  803e6b:	0f 94 c0             	sete   %al
  803e6e:	0f b6 c0             	movzbl %al,%eax
}
  803e71:	c9                   	leaveq 
  803e72:	c3                   	retq   

0000000000803e73 <opencons>:

int
opencons(void)
{
  803e73:	55                   	push   %rbp
  803e74:	48 89 e5             	mov    %rsp,%rbp
  803e77:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e7b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e7f:	48 89 c7             	mov    %rax,%rdi
  803e82:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
  803e8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e95:	79 05                	jns    803e9c <opencons+0x29>
		return r;
  803e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e9a:	eb 5b                	jmp    803ef7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea0:	ba 07 04 00 00       	mov    $0x407,%edx
  803ea5:	48 89 c6             	mov    %rax,%rsi
  803ea8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ead:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
  803eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec0:	79 05                	jns    803ec7 <opencons+0x54>
		return r;
  803ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec5:	eb 30                	jmp    803ef7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecb:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803ed2:	00 00 00 
  803ed5:	8b 12                	mov    (%rdx),%edx
  803ed7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee8:	48 89 c7             	mov    %rax,%rdi
  803eeb:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  803ef2:	00 00 00 
  803ef5:	ff d0                	callq  *%rax
}
  803ef7:	c9                   	leaveq 
  803ef8:	c3                   	retq   

0000000000803ef9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ef9:	55                   	push   %rbp
  803efa:	48 89 e5             	mov    %rsp,%rbp
  803efd:	48 83 ec 30          	sub    $0x30,%rsp
  803f01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f09:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f0d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f12:	75 07                	jne    803f1b <devcons_read+0x22>
		return 0;
  803f14:	b8 00 00 00 00       	mov    $0x0,%eax
  803f19:	eb 4b                	jmp    803f66 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f1b:	eb 0c                	jmp    803f29 <devcons_read+0x30>
		sys_yield();
  803f1d:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803f24:	00 00 00 
  803f27:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803f29:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  803f30:	00 00 00 
  803f33:	ff d0                	callq  *%rax
  803f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3c:	74 df                	je     803f1d <devcons_read+0x24>
	if (c < 0)
  803f3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f42:	79 05                	jns    803f49 <devcons_read+0x50>
		return c;
  803f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f47:	eb 1d                	jmp    803f66 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f49:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f4d:	75 07                	jne    803f56 <devcons_read+0x5d>
		return 0;
  803f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f54:	eb 10                	jmp    803f66 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f59:	89 c2                	mov    %eax,%edx
  803f5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f5f:	88 10                	mov    %dl,(%rax)
	return 1;
  803f61:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f66:	c9                   	leaveq 
  803f67:	c3                   	retq   

0000000000803f68 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f68:	55                   	push   %rbp
  803f69:	48 89 e5             	mov    %rsp,%rbp
  803f6c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f73:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f7a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f81:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f8f:	eb 76                	jmp    804007 <devcons_write+0x9f>
		m = n - tot;
  803f91:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f98:	89 c2                	mov    %eax,%edx
  803f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9d:	29 c2                	sub    %eax,%edx
  803f9f:	89 d0                	mov    %edx,%eax
  803fa1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803fa4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fa7:	83 f8 7f             	cmp    $0x7f,%eax
  803faa:	76 07                	jbe    803fb3 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fac:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fb6:	48 63 d0             	movslq %eax,%rdx
  803fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fbc:	48 63 c8             	movslq %eax,%rcx
  803fbf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803fc6:	48 01 c1             	add    %rax,%rcx
  803fc9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fd0:	48 89 ce             	mov    %rcx,%rsi
  803fd3:	48 89 c7             	mov    %rax,%rdi
  803fd6:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  803fdd:	00 00 00 
  803fe0:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803fe2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fe5:	48 63 d0             	movslq %eax,%rdx
  803fe8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fef:	48 89 d6             	mov    %rdx,%rsi
  803ff2:	48 89 c7             	mov    %rax,%rdi
  803ff5:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  803ffc:	00 00 00 
  803fff:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  804001:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804004:	01 45 fc             	add    %eax,-0x4(%rbp)
  804007:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80400a:	48 98                	cltq   
  80400c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804013:	0f 82 78 ff ff ff    	jb     803f91 <devcons_write+0x29>
	}
	return tot;
  804019:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80401c:	c9                   	leaveq 
  80401d:	c3                   	retq   

000000000080401e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80401e:	55                   	push   %rbp
  80401f:	48 89 e5             	mov    %rsp,%rbp
  804022:	48 83 ec 08          	sub    $0x8,%rsp
  804026:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80402a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80402f:	c9                   	leaveq 
  804030:	c3                   	retq   

0000000000804031 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804031:	55                   	push   %rbp
  804032:	48 89 e5             	mov    %rsp,%rbp
  804035:	48 83 ec 10          	sub    $0x10,%rsp
  804039:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80403d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804045:	48 be b4 49 80 00 00 	movabs $0x8049b4,%rsi
  80404c:	00 00 00 
  80404f:	48 89 c7             	mov    %rax,%rdi
  804052:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  804059:	00 00 00 
  80405c:	ff d0                	callq  *%rax
	return 0;
  80405e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804063:	c9                   	leaveq 
  804064:	c3                   	retq   

0000000000804065 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804065:	55                   	push   %rbp
  804066:	48 89 e5             	mov    %rsp,%rbp
  804069:	48 83 ec 18          	sub    $0x18,%rsp
  80406d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804075:	48 c1 e8 15          	shr    $0x15,%rax
  804079:	48 89 c2             	mov    %rax,%rdx
  80407c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804083:	01 00 00 
  804086:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80408a:	83 e0 01             	and    $0x1,%eax
  80408d:	48 85 c0             	test   %rax,%rax
  804090:	75 07                	jne    804099 <pageref+0x34>
		return 0;
  804092:	b8 00 00 00 00       	mov    $0x0,%eax
  804097:	eb 53                	jmp    8040ec <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80409d:	48 c1 e8 0c          	shr    $0xc,%rax
  8040a1:	48 89 c2             	mov    %rax,%rdx
  8040a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040ab:	01 00 00 
  8040ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ba:	83 e0 01             	and    $0x1,%eax
  8040bd:	48 85 c0             	test   %rax,%rax
  8040c0:	75 07                	jne    8040c9 <pageref+0x64>
		return 0;
  8040c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c7:	eb 23                	jmp    8040ec <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8040d1:	48 89 c2             	mov    %rax,%rdx
  8040d4:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040db:	00 00 00 
  8040de:	48 c1 e2 04          	shl    $0x4,%rdx
  8040e2:	48 01 d0             	add    %rdx,%rax
  8040e5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040e9:	0f b7 c0             	movzwl %ax,%eax
}
  8040ec:	c9                   	leaveq 
  8040ed:	c3                   	retq   
