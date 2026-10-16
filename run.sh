#!/bin/bash
set -xue

CC="${CC:-riscv32-unknown-elf-gcc}"
CFLAGS="${CFLAGS:--std=c11 -O2 -g3 -Wall -Wextra -ffreestanding -nostdlib -fno-stack-protector -fno-pie -march=rv32imac -mabi=ilp32}"

$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf \
    kernel.c common.c

# QEMUのファイルパス
QEMU=qemu-system-riscv32

# QEMUを起動
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot
