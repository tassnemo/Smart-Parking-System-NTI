# 0 "main.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "main.c"
# 1 "MCAL/pwm/pwm_private.h" 1



# 1 "LIB/STD_TYPES.h" 1



typedef unsigned char uint8;
typedef signed char sint8;
typedef unsigned short uint16;
typedef signed short sint16;
typedef unsigned long uint32;
typedef signed long sint32;
typedef unsigned long long uint64;
typedef signed long long sint64;

typedef float float32;
typedef double float64;
# 23 "LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 5 "MCAL/pwm/pwm_private.h" 2
# 2 "main.c" 2

int main(void)
{
    (*(volatile uint8 *)0x31) |= (1u << 5u);

    (*(volatile uint8 *)0x4F) = (1u << 7u) |
                 (1u << 1u);

    (*(volatile uint8 *)0x4E) = (1u << 4u) |
                 (1u << 3u) |
                 (1u << 1u);

    (*(volatile uint16 *)0x46) = 19999u;

    (*(volatile uint16 *)0x4A) = 1000u;

    while (1)
    {
    }

    return 0;
}
