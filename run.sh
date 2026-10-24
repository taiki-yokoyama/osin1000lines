#!/bin/bash
set -xue

CC="${CC:-/opt/homebrew/opt/llvm/bin/clang}"
CFLAGS="${CFLAGS:---target=riscv32 -march=rv32imac -mabi=ilp32 -std=c11 -O2 -g3 -Wall -Wextra -ffreestanding -nostdlib -fno-stack-protector -fno-pie -fuse-ld=lld}"

$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf \
    boot.S kernel.c common.c

# QEMUのファイルパス
QEMU=qemu-system-riscv32

# QEMUを起動
$QEMU -machine virt -bios default -kernel kernel.elf -nographic -serial mon:stdio --no-reboot
