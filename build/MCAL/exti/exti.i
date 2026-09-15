# 0 "MCAL/exti/exti.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/exti/exti.c"
# 1 "MCAL/exti/exti_interface.h" 1



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
# 5 "MCAL/exti/exti_interface.h" 2
# 15 "MCAL/exti/exti_interface.h"
typedef void (*EXTI_CallbackType)(void);

STD_ReturnType EXTI_Init(void);
STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense);
STD_ReturnType EXTI_Enable(uint8 Copy_u8Int);
STD_ReturnType EXTI_Disable(uint8 Copy_u8Int);
STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int);
STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback);
# 2 "MCAL/exti/exti.c" 2
# 1 "MCAL/exti/exti_private.h" 1




# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 38 "C:/avr-gcc/avr/include/avr/interrupt.h" 3
# 1 "C:/avr-gcc/avr/include/avr/io.h" 1 3
# 99 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 1 3
# 126 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 37 "C:/avr-gcc/avr/include/inttypes.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 38 "C:/avr-gcc/avr/include/inttypes.h" 2 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 127 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 2 3
# 100 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 230 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/iom32.h" 1 3
# 720 "C:/avr-gcc/avr/include/avr/iom32.h" 3
       
# 721 "C:/avr-gcc/avr/include/avr/iom32.h" 3

       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
# 231 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 785 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/portpins.h" 1 3
# 786 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/common.h" 1 3
# 788 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/version.h" 1 3
# 790 "C:/avr-gcc/avr/include/avr/io.h" 2 3






# 1 "C:/avr-gcc/avr/include/avr/fuse.h" 1 3
# 248 "C:/avr-gcc/avr/include/avr/fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
} __fuse_t;
# 797 "C:/avr-gcc/avr/include/avr/io.h" 2 3


# 1 "C:/avr-gcc/avr/include/avr/lock.h" 1 3
# 800 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 39 "C:/avr-gcc/avr/include/avr/interrupt.h" 2 3
# 6 "MCAL/exti/exti_private.h" 2
# 3 "MCAL/exti/exti.c" 2


# 4 "MCAL/exti/exti.c"
static EXTI_CallbackType g_EXTICallback[3] =
{
    ((void *)0),
    ((void *)0),
    ((void *)0)
};

STD_ReturnType EXTI_Init(void)
{
    (*(volatile uint8 *)0x55u) = 0u;

    (*(volatile uint8 *)0x54u) &= (uint8)~(1u << 6u);

    (*(volatile uint8 *)0x5Bu) = 0u;

    (*(volatile uint8 *)0x5Au) =
        (uint8)((1u << 6u) |
                (1u << 7u) |
                (1u << 5u));

    return 0u;
}

STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense)
{
    if (Copy_u8Sense > 3u)
    {
        return 1u;
    }

    if (Copy_u8Int == 0u)
    {
        (*(volatile uint8 *)0x55u) =
            (uint8)(((*(volatile uint8 *)0x55u) & (uint8)~((1u << 0u) |
                                           (1u << 1u))) |
                    (uint8)(Copy_u8Sense << 0u));

        return 0u;
    }

    if (Copy_u8Int == 1u)
    {
        (*(volatile uint8 *)0x55u) =
            (uint8)(((*(volatile uint8 *)0x55u) & (uint8)~((1u << 2u) |
                                           (1u << 3u))) |
                    (uint8)(Copy_u8Sense << 2u));

        return 0u;
    }

    if (Copy_u8Int == 2u)
    {
        if (Copy_u8Sense == 0u ||
            Copy_u8Sense == 1u)
        {
            return 1u;
        }

        if (Copy_u8Sense == 2u)
        {
            (*(volatile uint8 *)0x54u) &= (uint8)~(1u << 6u);
        }
        else
        {
            (*(volatile uint8 *)0x54u) |= (uint8)(1u << 6u);
        }

        return 0u;
    }

    return 1u;
}

STD_ReturnType EXTI_Enable(uint8 Copy_u8Int)
{
    if (Copy_u8Int == 0u)
    {
        (*(volatile uint8 *)0x5Bu) |= (uint8)(1u << 6u);
        return 0u;
    }

    if (Copy_u8Int == 1u)
    {
        (*(volatile uint8 *)0x5Bu) |= (uint8)(1u << 7u);
        return 0u;
    }

    if (Copy_u8Int == 2u)
    {
        (*(volatile uint8 *)0x5Bu) |= (uint8)(1u << 5u);
        return 0u;
    }

    return 1u;
}

STD_ReturnType EXTI_Disable(uint8 Copy_u8Int)
{
    if (Copy_u8Int == 0u)
    {
        (*(volatile uint8 *)0x5Bu) &= (uint8)~(1u << 6u);
        return 0u;
    }

    if (Copy_u8Int == 1u)
    {
        (*(volatile uint8 *)0x5Bu) &= (uint8)~(1u << 7u);
        return 0u;
    }

    if (Copy_u8Int == 2u)
    {
        (*(volatile uint8 *)0x5Bu) &= (uint8)~(1u << 5u);
        return 0u;
    }

    return 1u;
}

STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int)
{
    if (Copy_u8Int == 0u)
    {
        (*(volatile uint8 *)0x5Au) = (uint8)(1u << 6u);
        return 0u;
    }

    if (Copy_u8Int == 1u)
    {
        (*(volatile uint8 *)0x5Au) = (uint8)(1u << 7u);
        return 0u;
    }

    if (Copy_u8Int == 2u)
    {
        (*(volatile uint8 *)0x5Au) = (uint8)(1u << 5u);
        return 0u;
    }

    return 1u;
}

STD_ReturnType EXTI_SetCallback(
    uint8 Copy_u8Int,
    EXTI_CallbackType Copy_pfCallback)
{
    if (Copy_u8Int > 2u || Copy_pfCallback == ((void *)0))
    {
        return 1u;
    }

    g_EXTICallback[Copy_u8Int] = Copy_pfCallback;

    return 0u;
}


# 160 "MCAL/exti/exti.c" 3
void __vector_1 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_1 (void)

# 161 "MCAL/exti/exti.c"
{
    if (g_EXTICallback[0u] != ((void *)0))
    {
        g_EXTICallback[0u]();
    }
}


# 168 "MCAL/exti/exti.c" 3
void __vector_2 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_2 (void)

# 169 "MCAL/exti/exti.c"
{
    if (g_EXTICallback[1u] != ((void *)0))
    {
        g_EXTICallback[1u]();
    }
}


# 176 "MCAL/exti/exti.c" 3
void __vector_3 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_3 (void)

# 177 "MCAL/exti/exti.c"
{
    if (g_EXTICallback[2u] != ((void *)0))
    {
        g_EXTICallback[2u]();
    }
}
