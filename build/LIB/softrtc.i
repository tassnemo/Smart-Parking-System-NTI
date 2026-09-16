# 0 "LIB/softrtc.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "LIB/softrtc.c"
# 1 "LIB/softrtc.h" 1



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
# 5 "LIB/softrtc.h" 2

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
        char *Copy_pcBuf,
        uint8 Copy_u8BufSize);
# 2 "LIB/softrtc.c" 2
# 1 "C:/avr-gcc/avr/include/util/atomic.h" 1 3
# 37 "C:/avr-gcc/avr/include/util/atomic.h" 3
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
# 38 "C:/avr-gcc/avr/include/util/atomic.h" 2 3
# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 39 "C:/avr-gcc/avr/include/util/atomic.h" 2 3



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
# 3 "LIB/softrtc.c" 2
# 1 "APP/config.h" 1
# 4 "LIB/softrtc.c" 2


# 5 "LIB/softrtc.c"
static volatile uint32 g_u32UptimeSec = 0;
static uint8 g_u8SubTick = 0;

void RTC_Tick10ms(void) {
    if (++g_u8SubTick >= (1000u / 10u)) {
        g_u8SubTick = 0;
        g_u32UptimeSec++;
    }
}

uint32 RTC_Seconds(void) {
    uint32 Local_u32Seconds;

    
# 18 "LIB/softrtc.c" 3
   for ( uint8_t sreg_save __attribute__((__cleanup__(__iRestore))) = (*(volatile uint8_t *)((0x3F) + 0x20)), __ToDo = __iCliRetVal(); __ToDo ; __ToDo = 0 )
    
# 19 "LIB/softrtc.c"
   {
        Local_u32Seconds = g_u32UptimeSec;
    }

    return Local_u32Seconds;
}

STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
                          char *Copy_pcBuf,
                          uint8 Copy_u8BufSize) {
    uint32 Local_u32Hours = Copy_u32Sec / 3600u;
    uint8 Local_u8Minutes = (uint8)((Copy_u32Sec % 3600u) / 60u);
    uint8 Local_u8Seconds = (uint8)(Copy_u32Sec % 60u);

    if ((Copy_pcBuf == ((void *)0)) || (Copy_u8BufSize < 10u))
    {
        return 1u;
    }

    Copy_pcBuf[0] = (char)('0' + (Local_u32Hours / 100u) % 10u);
    Copy_pcBuf[1] = (char)('0' + (Local_u32Hours / 10u) % 10u);
    Copy_pcBuf[2] = (char)('0' + Local_u32Hours % 10u);
    Copy_pcBuf[3] = ':';
    Copy_pcBuf[4] = (char)('0' + Local_u8Minutes / 10u);
    Copy_pcBuf[5] = (char)('0' + Local_u8Minutes % 10u);
    Copy_pcBuf[6] = ':';
    Copy_pcBuf[7] = (char)('0' + Local_u8Seconds / 10u);
    Copy_pcBuf[8] = (char)('0' + Local_u8Seconds % 10u);
    Copy_pcBuf[9] = '\0';

    return 0u;
}
