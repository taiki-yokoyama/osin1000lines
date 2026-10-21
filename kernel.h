#ifndef KERNEL_H
#define KERNEL_H

#include "common.h"

struct sbiret {
    long error;
    long value;
};

#define READ_CSR(reg)                                                          \
    ({                                                                         \
        unsigned long __tmp;                                                   \
        __asm__ __volatile__("csrr %0, " #reg : "=r"(__tmp));                  \
        __tmp;                                                                 \
    })

#define WRITE_CSR(reg, value)                                                  \
    do {                                                                       \
        uint32_t __tmp = (value);                                              \
        __asm__ __volatile__("csrw " #reg ", %0" :: "r"(__tmp));              \
    } while (0)

#define PANIC(fmt, ...)                                                        \
    do {                                                                       \
        printf("PANIC: %s:%d: " fmt, __FILE__, __LINE__, ##__VA_ARGS__);       \
        for (;;)                                                                \
            __asm__ __volatile__("wfi");                                      \
    } while (0)

void kernel_main(void);

#endif
