QEMU=qemu-system-riscv32
CC=clang
LINKER=ld.lld

CFLAGS=-c -std=c11 -O2 -g3 -Wall -Wextra --target=riscv32 -ffreestanding -nostdlib -mno-relax
QEMU_OPTION=-machine virt -bios default -nographic -serial mon:stdio --no-reboot

kernel: kernel.c kernel.ld
				$(CC) $(CFLAGS) -o kernel.o kernel.c
				$(LINKER) -m elf32lriscv -L/lib -Tkernel.ld -Map=kernel.map kernel.o -o kernel.elf

boot : kernel
				$(QEMU) $(QEMU_OPTION) -kernel kernel.elf
clean:
				rm *.elf *.map *.o