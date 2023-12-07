QEMU=qemu-system-riscv32
CC=clang
LINKER=ld.lld
OBJCOPY=llvm-objcopy

CFLAGS=-c -std=c11 -O2 -g3 -Wall -Wextra --target=riscv32 -ffreestanding -nostdlib -mno-relax

QEMU_OPTION=-machine virt -bios default -nographic -serial mon:stdio --no-reboot \
			-d unimp,guest_errors,int,cpu_reset -D qemu.log \
			-drive id=drive0,file=disk.tar,format=raw \
			-device virtio-blk-device,drive=drive0,bus=virtio-mmio-bus.0

COMMON_C_SRCS=common.c
KERNEL_C_SRCS=$(COMMON_C_SRCS) kernel.c
SHELL_C_SRCS=$(COMMON_C_SRCS) shell.c user.c 

KERNEL_OBJS=$(KERNEL_C_SRCS:.c=.o)
SHELL_OBJS=$(SHELL_C_SRCS:.c=.o)

image: disk/*
				cd disk && tar cf ../disk.tar --format=ustar ./*.txt
				
shell: $(SHELL_C_SRCS) user.ld
				$(CC) $(CFLAGS) $(SHELL_C_SRCS)
				$(LINKER) -m elf32lriscv -L/lib -Tuser.ld -Map=shell.map $(SHELL_OBJS) -o shell.elf
				$(OBJCOPY) --set-section-flags .bss=alloc,contents -O binary shell.elf shell.bin
				$(OBJCOPY) -Ibinary -Oelf32-littleriscv shell.bin shell.bin.o

kernel: shell $(KERNEL_C_SRCS) kernel.ld
				$(CC) $(CFLAGS) $(KERNEL_C_SRCS)
				$(LINKER) -m elf32lriscv -L/lib -Tkernel.ld -Map=kernel.map $(KERNEL_OBJS) shell.bin.o -o kernel.elf

boot : image kernel
				$(QEMU) $(QEMU_OPTION) -kernel kernel.elf

clean:
				rm *.elf *.map *.o *.bin *.tar

.PHONY: image shell kernel boot clean