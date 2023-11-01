#pragma once

struct sbiret {
    long error;
    long value;
};

#define PANIC(fmt, ...)                                                       \
    {                                                                         \
        printf("PANIC: %s:%d: " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__); \
        while (1) {}                                                          \
    }
