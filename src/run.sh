#!/bin/bash
set -xue

# QEMUの実行バイナリへのパス
QEMU=qemu-system-riscv32

# QEMUを起動
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot