#!/bin/bash
set -xue

CC="${CC:-/opt/homebrew/opt/llvm/bin/clang}"
CFLAGS="${CFLAGS:---target=riscv32 -march=rv32imac -mabi=ilp32 -std=c11 -O2 -g3 -Wall -Wextra -ffreestanding -nostdlib -fno-stack-protector -fno-pie -fuse-ld=lld}"

# Build the shell application and embed it into an object file.
OBJCOPY="${OBJCOPY:-/opt/homebrew/opt/llvm/bin/llvm-objcopy}"
$CC $CFLAGS -Wl,-Tuser.ld -Wl,-Map=shell.map -o shell.elf \
    shell.c user.c common.c
$OBJCOPY --set-section-flags .bss=alloc,contents -O binary shell.elf shell.bin
$OBJCOPY -Ibinary -Oelf32-littleriscv shell.bin shell.bin.o

$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf \
    boot.S kernel.c common.c shell.bin.o

# QEMUのファイルパス
QEMU=qemu-system-riscv32

# QEMUを起動
$QEMU -machine virt -bios default -kernel kernel.elf -nographic -serial mon:stdio --no-reboot
