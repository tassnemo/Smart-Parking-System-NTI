# 0 "MCAL/i2c/i2c.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/i2c/i2c.c"
# 1 "MCAL/i2c/i2c_interface.h" 1



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
# 5 "MCAL/i2c/i2c_interface.h" 2

STD_ReturnType I2C_Init(void);
STD_ReturnType I2C_Start(void);
STD_ReturnType I2C_Stop(void);
STD_ReturnType I2C_Write(uint8 Copy_u8Data);
STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data);
STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data);
# 2 "MCAL/i2c/i2c.c" 2
# 1 "MCAL/dio/dio_interface.h" 1
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 3 "MCAL/i2c/i2c.c" 2
# 1 "APP/config.h" 1
# 4 "MCAL/i2c/i2c.c" 2
# 1 "C:/avr-gcc/avr/include/util/delay.h" 1 3
# 49 "C:/avr-gcc/avr/include/util/delay.h" 3
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
# 50 "C:/avr-gcc/avr/include/util/delay.h" 2 3
# 1 "C:/avr-gcc/avr/include/util/delay_basic.h" 1 3
# 37 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 38 "C:/avr-gcc/avr/include/util/delay_basic.h" 2 3


static __inline__ void _delay_loop_1(uint8_t __count) __attribute__((__always_inline__));
static __inline__ void _delay_loop_2(uint16_t __count) __attribute__((__always_inline__));
# 80 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
void
_delay_loop_1(uint8_t __count)
{
 __asm__ volatile (
  "1: dec %0" "\n\t"
  "brne 1b"
  : "=r" (__count)
  : "0" (__count)
 );
}
# 102 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
void
_delay_loop_2(uint16_t __count)
{
# 113 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
 __asm__ volatile (
  "1: sbiw %0,1" "\n\t"
  "brne 1b"
  : "+w" (__count)
 );

}
# 51 "C:/avr-gcc/avr/include/util/delay.h" 2 3
# 151 "C:/avr-gcc/avr/include/util/delay.h" 3
static __inline__ __attribute__((__always_inline__)) void _delay_ms(double __ms);

void
_delay_ms(double __ms)
{
 double __tmp ;


 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(uint32_t);
 __tmp = ((
# 161 "C:/avr-gcc/avr/include/util/delay.h"
          8000000UL
# 161 "C:/avr-gcc/avr/include/util/delay.h" 3
               ) / 1e3) * __ms;
# 171 "C:/avr-gcc/avr/include/util/delay.h" 3
  __ticks_dc = (uint32_t)(__builtin_ceil(__builtin_fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 197 "C:/avr-gcc/avr/include/util/delay.h" 3
}
# 234 "C:/avr-gcc/avr/include/util/delay.h" 3
static __inline__ __attribute__((__always_inline__)) void _delay_us(double __us);

void
_delay_us(double __us)
{
 double __tmp ;


 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(uint32_t);
 __tmp = ((
# 244 "C:/avr-gcc/avr/include/util/delay.h"
          8000000UL
# 244 "C:/avr-gcc/avr/include/util/delay.h" 3
               ) / 1e6) * __us;
# 254 "C:/avr-gcc/avr/include/util/delay.h" 3
  __ticks_dc = (uint32_t)(__builtin_ceil(__builtin_fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 281 "C:/avr-gcc/avr/include/util/delay.h" 3
}
# 5 "MCAL/i2c/i2c.c" 2
# 50 "MCAL/i2c/i2c.c"

# 50 "MCAL/i2c/i2c.c"
static void I2C_SclLow(void)
{
    DIO_Init(2u, 0u, 1u);
    DIO_WritePin(2u, 0u, 0u);
}

static void I2C_SclRelease(void)
{

    DIO_Init(2u, 0u, 2u);
}

static void I2C_SdaLow(void)
{
    DIO_Init(2u, 1u, 1u);
    DIO_WritePin(2u, 1u, 0u);
}

static void I2C_SdaRelease(void)
{
    DIO_Init(2u, 1u, 2u);
}

static uint8 I2C_SdaRead(void)
{
    uint8 Local_u8Val = 0u;
    DIO_ReadPin(2u, 1u, &Local_u8Val);
    return Local_u8Val;
}

static STD_ReturnType I2C_WriteBit(uint8 Copy_u8Bit)
{
    if (Copy_u8Bit != 0u) { I2C_SdaRelease(); } else { I2C_SdaLow(); }
    _delay_us(20);

    I2C_SclRelease();
    _delay_us(20);

    I2C_SclLow();
    _delay_us(20);

    return 0u;
}

static uint8 I2C_ReadBit(void)
{
    uint8 Local_u8Bit;

    I2C_SdaRelease();
    _delay_us(20);

    I2C_SclRelease();
    _delay_us(20);
    Local_u8Bit = I2C_SdaRead();

    I2C_SclLow();
    _delay_us(20);

    return Local_u8Bit;
}

STD_ReturnType I2C_Init(void)
{
    I2C_SclRelease();
    I2C_SdaRelease();
    _delay_us(20);
    return 0u;
}

STD_ReturnType I2C_Start(void)
{

    I2C_SdaRelease();
    I2C_SclRelease();
    _delay_us(20);

    I2C_SdaLow();
    _delay_us(20);

    I2C_SclLow();
    _delay_us(20);

    return 0u;
}

STD_ReturnType I2C_Stop(void)
{

    I2C_SdaLow();
    _delay_us(20);

    I2C_SclRelease();
    _delay_us(20);

    I2C_SdaRelease();
    _delay_us(20);
    _delay_us(60);

    return 0u;
}

STD_ReturnType I2C_Write(uint8 Copy_u8Data)
{
    sint8 Local_s8Index;
    uint8 Local_u8Ack;

    for (Local_s8Index = 7; Local_s8Index >= 0; Local_s8Index--)
    {
        I2C_WriteBit((uint8)((Copy_u8Data >> Local_s8Index) & 0x01u));
    }


    Local_u8Ack = I2C_ReadBit();

    return (Local_u8Ack == 0u) ? 0u : 1u;
}

STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data)
{
    uint8 Local_u8Index;
    uint8 Local_u8Data = 0u;

    if (Copy_pu8Data == ((void *)0))
    {
        return 1u;
    }

    for (Local_u8Index = 0u; Local_u8Index < 8u; Local_u8Index++)
    {
        Local_u8Data = (uint8)((Local_u8Data << 1) | I2C_ReadBit());
    }

    I2C_WriteBit(0u);

    *Copy_pu8Data = Local_u8Data;
    return 0u;
}

STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data)
{
    uint8 Local_u8Index;
    uint8 Local_u8Data = 0u;

    if (Copy_pu8Data == ((void *)0))
    {
        return 1u;
    }

    for (Local_u8Index = 0u; Local_u8Index < 8u; Local_u8Index++)
    {
        Local_u8Data = (uint8)((Local_u8Data << 1) | I2C_ReadBit());
    }

    I2C_WriteBit(1u);

    *Copy_pu8Data = Local_u8Data;
    return 0u;
}
