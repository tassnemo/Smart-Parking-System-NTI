# 0 "MCAL/usart/usart.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/usart/usart.c"
# 1 "MCAL/usart/usart_interface.h" 1



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
# 5 "MCAL/usart/usart_interface.h" 2

STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 2 "MCAL/usart/usart.c" 2
# 1 "MCAL/usart/usart_private.h" 1




# 1 "APP/config.h" 1
# 6 "MCAL/usart/usart_private.h" 2
# 3 "MCAL/usart/usart.c" 2
# 1 "LIB/ring_buffer.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/ring_buffer.h" 2

typedef struct
{
    uint8 *buffer;
    uint16 capacity;
    uint16 head;
    uint16 tail;
    uint16 count;
} RingBuffer;

STD_ReturnType RingBuffer_Init(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Array,
    uint16 Copy_u16Capacity
);

STD_ReturnType RingBuffer_Push(
    RingBuffer *Copy_pstBuffer,
    uint8 Copy_u8Data
);

STD_ReturnType RingBuffer_Pop(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Data
);

STD_ReturnType RingBuffer_IsEmpty(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
);

STD_ReturnType RingBuffer_IsFull(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
);

STD_ReturnType RingBuffer_Size(
    RingBuffer *Copy_pstBuffer,
    uint16 *Copy_pu16Size
);

STD_ReturnType RingBuffer_Clear(
    RingBuffer *Copy_pstBuffer
);
# 4 "MCAL/usart/usart.c" 2
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
# 5 "MCAL/usart/usart.c" 2
# 1 "C:/avr-gcc/avr/include/util/atomic.h" 1 3
# 42 "C:/avr-gcc/avr/include/util/atomic.h" 3
static __inline__ uint8_t __iSeiRetVal(void)
{
    __asm__ __volatile__ ("sei" ::: "memory");
    return 1;
}

static __inline__ uint8_t __iCliRetVal(void)
{
    __asm__ __volatile__ ("cli" ::: "memory");
    return 1;
}

static __inline__ void __iSeiParam(const uint8_t *__s)
{
    __asm__ __volatile__ ("sei" ::: "memory");
    __asm__ volatile ("" ::: "memory");
    (void)__s;
}

static __inline__ void __iCliParam(const uint8_t *__s)
{
    __asm__ __volatile__ ("cli" ::: "memory");
    __asm__ volatile ("" ::: "memory");
    (void)__s;
}

static __inline__ void __iRestore(const uint8_t *__s)
{
    (*(volatile uint8_t *)((0x3F) + 0x20)) = *__s;
    __asm__ volatile ("" ::: "memory");
}
# 6 "MCAL/usart/usart.c" 2


# 7 "MCAL/usart/usart.c"
static uint8 g_USARTRxStorage[64u];
static RingBuffer g_USARTRxBuffer;

STD_ReturnType USART_Init(void)
{
    if (RingBuffer_Init(&g_USARTRxBuffer,
                        g_USARTRxStorage,
                        64u) != 0u)
    {
        return 1u;
    }


    (*(volatile uint8 *)0x2A) = 0u;


    (*(volatile uint8 *)0x2B) &= (uint8)~(1u << 1u);


    (*(volatile uint8 *)0x40) = 0u;
    (*(volatile uint8 *)0x29) = (uint8)((8000000UL / (16UL * 9600UL)) - 1UL);
# 37 "MCAL/usart/usart.c"
    (*(volatile uint8 *)0x40) =
        (uint8)((1u << 7u) |
                (1u << 2u) |
                (1u << 1u));





    (*(volatile uint8 *)0x2A) =
        (uint8)((1u << 4u) |
                (1u << 3u) |
                (1u << 7u));

    return 0u;
}

STD_ReturnType USART_SendByte(uint8 Copy_u8Data)
{
    while (((*(volatile uint8 *)0x2B) & (uint8)(1u << 5u)) == 0u)
    {

    }

    (*(volatile uint8 *)0x2C) = Copy_u8Data;

    return 0u;
}

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data)
{
    STD_ReturnType Local_u8Result;

    if (Copy_pu8Data == ((void *)0))
    {
        return 1u;
    }


    
# 76 "MCAL/usart/usart.c" 3
   for ( uint8_t sreg_save __attribute__((__cleanup__(__iRestore))) = (*(volatile uint8_t *)((0x3F) + 0x20)), __ToDo = __iCliRetVal(); __ToDo ; __ToDo = 0 )
    
# 77 "MCAL/usart/usart.c"
   {
        Local_u8Result = RingBuffer_Pop(&g_USARTRxBuffer, Copy_pu8Data);
    }

    return Local_u8Result;
}

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String)
{
    if (Copy_pu8String == ((void *)0))
    {
        return 1u;
    }

    while (*Copy_pu8String != '\0')
    {
        if (USART_SendByte(*Copy_pu8String) != 0u)
        {
            return 1u;
        }

        Copy_pu8String++;
    }

    return 0u;
}


# 104 "MCAL/usart/usart.c" 3
void __vector_13 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_13 (void)

# 105 "MCAL/usart/usart.c"
{
    (void)RingBuffer_Push(&g_USARTRxBuffer, (*(volatile uint8 *)0x2C));
}
