#ifndef KERNEL_H
#define KERNEL_H

struct sbiret {
    long error;
    long value;
};

void kernel_main(void);

#endif
