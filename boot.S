.section .text.boot
.global boot
.type boot, @function
boot:
    la sp, __stack_top
    call kernel_main

1:
    wfi
    j 1b
.size boot, .-boot
