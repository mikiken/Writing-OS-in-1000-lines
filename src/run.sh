#!/bin/bash
set -xue

# QEMUの実行バイナリへのパス
QEMU=qemu-system-riscv32

CC=clang
LINKER=ld.lld

# コンパイルオプション
CFLAGS="-c -std=c11 -O2 -g3 -Wall -Wextra --target=riscv32 -ffreestanding -nostdlib -mno-relax"

# カーネルをビルド
$CC $CFLAGS -o kernel.o kernel.c
$LINKER -m elf32lriscv -L/lib -Tkernel.ld -Map=kernel.map kernel.o -o kernel.elf

# QEMUを起動
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot -kernel kernel.elf
