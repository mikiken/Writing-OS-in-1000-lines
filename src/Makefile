QEMU=qemu-system-riscv32
CC=clang
LINKER=ld.lld

CFLAGS=-c -std=c11 -O2 -g3 -Wall -Wextra --target=riscv32 -ffreestanding -nostdlib -mno-relax
QEMU_OPTION=-machine virt -bios default -nographic -serial mon:stdio --no-reboot

C_SOURCE=$(wildcard *.c)
OBJECT=$(C_SOURCE:.c=.o)

kernel: $(C_SOURCE) kernel.ld
				$(CC) $(CFLAGS) $(C_SOURCE)
				$(LINKER) -m elf32lriscv -L/lib -Tkernel.ld -Map=kernel.map $(OBJECT) -o kernel.elf

boot : kernel
				$(QEMU) $(QEMU_OPTION) -kernel kernel.elf
clean:
				rm *.elf *.map *.o

.PHONY: kernel boot clean