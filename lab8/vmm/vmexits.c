
#include <vmm/vmx.h>
#include <inc/error.h>
#include <vmm/vmexits.h>
#include <vmm/ept.h>
#include <inc/x86.h>
#include <inc/assert.h>
#include <kern/pmap.h>
#include <kern/console.h>
#include <kern/kclock.h>
#include <kern/multiboot.h>
#include <inc/string.h>
#include <inc/stdio.h>
#include <kern/syscall.h>
#include <kern/env.h>
#include <kern/cpu.h>

static int vmdisk_number = 0;	//this number assign to the vm
int
vmx_get_vmdisk_number() {
	return vmdisk_number;
}

void
vmx_incr_vmdisk_number() {
	vmdisk_number++;
}
bool
find_msr_in_region(uint32_t msr_idx, uintptr_t *area, int area_sz, struct vmx_msr_entry **msr_entry) {
	struct vmx_msr_entry *entry = (struct vmx_msr_entry *)area;
	int i;
	for(i=0; i<area_sz; ++i) {
		if(entry->msr_index == msr_idx) {
			*msr_entry = entry;
			return true;
		}
	}
	return false;
}

bool
handle_interrupt_window(struct Trapframe *tf, struct VmxGuestInfo *ginfo, uint32_t host_vector) {
	uint64_t rflags;
	uint32_t procbased_ctls_or;

	procbased_ctls_or = vmcs_read32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS );

        //disable the interrupt window exiting
        procbased_ctls_or &= ~(VMCS_PROC_BASED_VMEXEC_CTL_INTRWINEXIT);

        vmcs_write32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS,
		      procbased_ctls_or);
        //write back the host_vector, which can insert a virtual interrupt
	vmcs_write32( VMCS_32BIT_CONTROL_VMENTRY_INTERRUPTION_INFO , host_vector);
	return true;
}
bool
handle_interrupts(struct Trapframe *tf, struct VmxGuestInfo *ginfo, uint32_t host_vector) {
	uint64_t rflags;
	uint32_t procbased_ctls_or;
	rflags = vmcs_read64(VMCS_GUEST_RFLAGS);

	if ( !(rflags & (0x1 << 9)) ) {	//we have to wait the interrupt window open
		//get the interrupt info

		procbased_ctls_or = vmcs_read32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS);

		//disable the interrupt window exiting
		procbased_ctls_or |= VMCS_PROC_BASED_VMEXEC_CTL_INTRWINEXIT;

		vmcs_write32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS,
			      procbased_ctls_or);
	}
	else {	//revector the host vector to the guest vector

		vmcs_write32( VMCS_32BIT_CONTROL_VMENTRY_INTERRUPTION_INFO , host_vector);
	}



	return true;
}

bool
handle_rdmsr(struct Trapframe *tf, struct VmxGuestInfo *ginfo) {
	uint64_t msr = tf->tf_regs.reg_rcx;
	if(msr == EFER_MSR) {
		// TODO: setup msr_bitmap to ignore EFER_MSR
		uint64_t val;
		struct vmx_msr_entry *entry;
		bool r = find_msr_in_region(msr, ginfo->msr_guest_area, ginfo->msr_count, &entry);
		assert(r);
		val = entry->msr_value;

		tf->tf_regs.reg_rdx = val << 32;
		tf->tf_regs.reg_rax = val & 0xFFFFFFFF;

		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		return true;
	}

	return false;
}

bool
handle_wrmsr(struct Trapframe *tf, struct VmxGuestInfo *ginfo) {
	uint64_t msr = tf->tf_regs.reg_rcx;
	if(msr == EFER_MSR) {

		uint64_t cur_val, new_val;
		struct vmx_msr_entry *entry;
		bool r =
			find_msr_in_region(msr, ginfo->msr_guest_area, ginfo->msr_count, &entry);
		assert(r);
		cur_val = entry->msr_value;

		new_val = (tf->tf_regs.reg_rdx << 32)|tf->tf_regs.reg_rax;
		if(BIT(cur_val, EFER_LME) == 0 && BIT(new_val, EFER_LME) == 1) {
			// Long mode enable.
			uint32_t entry_ctls = vmcs_read32( VMCS_32BIT_CONTROL_VMENTRY_CONTROLS );
			entry_ctls |= VMCS_VMENTRY_x64_GUEST;
			vmcs_write32( VMCS_32BIT_CONTROL_VMENTRY_CONTROLS,
				      entry_ctls );

		}

		entry->msr_value = new_val;
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		return true;
	}

	return false;
}

bool
handle_eptviolation(uint64_t *eptrt, struct VmxGuestInfo *ginfo) {
	uint64_t gpa = vmcs_read64(VMCS_64BIT_GUEST_PHYSICAL_ADDR);
	int r;
	if(gpa < 0xA0000 || (gpa >= 0x100000 && gpa < ginfo->phys_sz))
	{
		// Allocate a new page to the guest.
		struct PageInfo *p = page_alloc(0);
		if(!p) {
			cprintf("vmm: handle_eptviolation: Failed to allocate a page for guest---out of memory.\n");
			return false;
		}
		r = ept_page_insert(eptrt,
				    p, (void *)ROUNDDOWN(gpa, PGSIZE), __EPTE_FULL, 0);
		assert(r >= 0);
		/* cprintf("EPT violation for gpa:%x mapped KVA:%x\n", gpa, page2kva(p)); */
		return true;
	} else if (gpa >= CGA_BUF && gpa < CGA_BUF + PGSIZE) {
		// FIXME: This give direct access to VGA MMIO region.
		r = ept_page_insert(eptrt, pa2page(PADDR(((void *) (KERNBASE + CGA_BUF)))),
				    (void *)CGA_BUF, __EPTE_FULL, 0);

		assert(r >= 0);
		return true;
	}
	cprintf("vmm: handle_eptviolation: Case 2, gpa %x\n", gpa);
	return false;
}

bool
handle_ioinstr(struct Trapframe *tf, struct VmxGuestInfo *ginfo) {
	static int port_iortc;

	uint64_t qualification = vmcs_read64(VMCS_VMEXIT_QUALIFICATION);
	int port_number = (qualification >> 16) & 0xFFFF;
	bool is_in = BIT(qualification, 3);
	bool handled = false;

	// handle reading physical memory from the CMOS.
	if(port_number == IO_RTC) {
		if(!is_in) {
			port_iortc = tf->tf_regs.reg_rax;
			handled = true;
		}
	} else if (port_number == IO_RTC + 1) {
		if(is_in) {
			if(port_iortc == NVRAM_BASELO) {
				tf->tf_regs.reg_rax = 640 & 0xFF;
				handled = true;
			} else if (port_iortc == NVRAM_BASEHI) {
				tf->tf_regs.reg_rax = (640 >> 8) & 0xFF;
				handled = true;
			} else if (port_iortc == NVRAM_EXTLO) {
				tf->tf_regs.reg_rax = ((ginfo->phys_sz / 1024) - 1024) & 0xFF;
				handled = true;
			} else if (port_iortc == NVRAM_EXTHI) {
				tf->tf_regs.reg_rax = (((ginfo->phys_sz / 1024) - 1024) >> 8) & 0xFF;
				handled = true;
			}
		}

	}
	if(handled) {
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		return true;
	} else {
		cprintf("%x %x\n", qualification, port_iortc);
		return false;
	}
}

// Emulate a cpuid instruction.
// It is sufficient to issue the cpuid instruction here and collect the return value.
// You can store the output of the instruction in Trapframe tf,
//  but you should hide the presence of vmx from the guest if processor features are requested.
//
// Return true if the exit is handled properly, false if the VM should be terminated.
//
// Finally, you need to increment the program counter in the trap frame.
//
// Hint: The TA's solution does not hard-code the length of the cpuid instruction.
bool
handle_cpuid(struct Trapframe *tf, struct VmxGuestInfo *ginfo)
{
	/* Your code here */
	uint32_t in = (uint32_t) tf->tf_regs.reg_rax;
	uint32_t eax, ebx, ecx, edx;
	cpuid (in, &eax, &ebx, &ecx, &edx);
	if (in == 1) {
		ecx = ecx & ~32; // OS doesn't support virtual machine extension.
	}
	tf->tf_regs.reg_rax = (uint64_t)eax;
	tf->tf_regs.reg_rbx = (uint64_t)ebx;
	tf->tf_regs.reg_rcx = (uint64_t)ecx;
	tf->tf_regs.reg_rdx = (uint64_t)edx;
	tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
	cprintf("Handle cpuid implemented\n");
	return true;
}

// Handle vmcall traps from the guest.
// We currently support 3 traps: read the virtual e820 map,
//   and use host-level IPC (send andrecv).
//
// Return true if the exit is handled properly, false if the VM should be terminated.
//
// Finally, you need to increment the program counter in the trap frame.
//
// Hint: The TA's solution does not hard-code the length of the cpuid instruction.//

bool
handle_vmcall(struct Trapframe *tf, struct VmxGuestInfo *gInfo, uint64_t *eptrt)
{
	bool handled = false;
	multiboot_info_t mbinfo;
	int perm, r;
	void *gpa_pg, *hva_pg;
	envid_t to_env;
	uint32_t val;
	int ret;
	// phys address of the multiboot map in the guest.
	memory_map_t boot_map[3];
	uint64_t multiboot_map_addr = 0x6000;
	switch(tf->tf_regs.reg_rax) {
	case VMX_VMCALL_MBMAP:
		// Craft a multiboot (e820) memory map for the guest.
		//
		// Create three  memory mapping segments: 640k of low mem, the I/O hole (unusable), and
		//   high memory (phys_size - 1024k).
		//
		// Once the map is ready, find the kernel virtual address of the guest page (if present),
		//   or allocate one and map it at the multiboot_map_addr (0x6000).
		// Copy the mbinfo and memory_map_t (segment descriptions) into the guest page, and return
		//   a pointer to this region in rbx (as a guest physical address).
		/* Your code here */
		boot_map[0].size = 20;
		boot_map[0].base_addr_low = 0x0;
		boot_map[0].base_addr_high = 0x0;
		boot_map[0].length_low = IOPHYSMEM;
		boot_map[0].length_high = 0x0;
		boot_map[0].type = MB_TYPE_USABLE;

		boot_map[1].size = 20;
		boot_map[1].base_addr_low = IOPHYSMEM;
		boot_map[1].base_addr_high = 0x0;
		boot_map[1].length_low = EXTPHYSMEM - IOPHYSMEM;
		boot_map[1].length_high = 0x0;
		boot_map[1].type = MB_TYPE_RESERVED;

		boot_map[2].size = 20;
		boot_map[2].base_addr_low = EXTPHYSMEM;
		boot_map[2].base_addr_high = 0x0;
		boot_map[2].length_low = (gInfo->phys_sz - EXTPHYSMEM) & (0xffffffff);
		boot_map[2].length_high = ((gInfo->phys_sz - EXTPHYSMEM) >> 32) & (0xffffffff);
		boot_map[2].type = MB_TYPE_USABLE;

		mbinfo.mmap_length = sizeof(boot_map);
		mbinfo.mmap_addr =  multiboot_map_addr + sizeof(multiboot_info_t);
		mbinfo.flags = MB_FLAG_MMAP;

		struct PageInfo* pp = page_alloc(0);
		if(!pp) {
			handled = false;
			cprintf("e820 map hypercall not implemented\n");
			break;
		}

		pp->pp_ref++;
		uintptr_t host_va = (uintptr_t)page2kva(pp);
		memmove((void *)host_va,(void *)& mbinfo, (size_t)sizeof(multiboot_info_t));
		memmove(((void *)host_va + sizeof(multiboot_info_t)), (void *)boot_map, sizeof(boot_map));
		ept_page_insert((epte_t*) eptrt, pp, (void *)multiboot_map_addr, __EPTE_FULL, 1);
		//ept_map_hva2gpa((epte_t*) eptrt, (void *) host_va, (void *)multiboot_map_addr, __EPTE_FULL, 1);

		tf->tf_regs.reg_rbx = (uint64_t) multiboot_map_addr;
		cprintf("e820 map hypercall implemented\n");
		handled = true;
		break;

	case VMX_VMCALL_IPCSEND:
		// Issue the sys_ipc_send call to the host.
		//
		// If the requested environment is VMX_HOST_FS_ENV, this call should
		//  find an environment in the host OS that is of type ENV_TYPE_FS, and
		//  send the message to that environment.
		//
		// The input should be a guest physical address; you will need to convert
		//  this to a host virtual address for the IPC to work properly.
		/* Your code here */
		ret = syscall(SYS_ipc_try_send,(uint64_t) tf->tf_regs.reg_rdx, (uint64_t)tf->tf_regs.reg_rcx,
						(uint64_t)tf->tf_regs.reg_rbx, (uint64_t)tf->tf_regs.reg_rdi, (uint64_t)0);
		tf->tf_regs.reg_rax = (uint64_t) ret;

		handled = true;
		break;

	case VMX_VMCALL_IPCRECV:
		// Issue the sys_ipc_recv call for the guest.
		// NB: because recv can call schedule, clobbering the VMCS,
		// you should go ahead and increment rip before this call.
		/* Your code here */
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		ret = syscall(SYS_ipc_recv, (uint64_t)tf->tf_regs.reg_rdx, (uint64_t)0, (uint64_t)0, (uint64_t)0,(uint64_t)0);
		tf->tf_regs.reg_rax = (uint64_t) ret;

		handled = true;
		break;
	case VMX_VMCALL_LAPICEOI:
		lapic_eoi();
		handled = true;
		break;
	case VMX_VMCALL_BACKTOHOST:
		cprintf("Now back to the host, VM halt in the background, run vmmanager to resume the VM.\n");
		curenv->env_status = ENV_NOT_RUNNABLE;	//mark the guest not runable
		ENV_CREATE(user_sh, ENV_TYPE_USER);	//create a new host shell
		handled = true;
		break;
	case VMX_VMCALL_GETDISKIMGNUM:	//alloc a number to guest
		tf->tf_regs.reg_rax = vmdisk_number;
		handled = true;
		break;

	}
	if(handled) {
		/* Advance the program counter by the length of the vmcall instruction.
		 *
		 * Hint: The TA solution does not hard-code the length of the vmcall instruction.
		 */
		/* Your code here */
	}
	return handled;
}
