# 0 "HAL/lcd/lcd_i2c.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/lcd/lcd_i2c.c"
# 1 "HAL/lcd/lcd_i2c.h" 1



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
# 5 "HAL/lcd/lcd_i2c.h" 2
# 22 "HAL/lcd/lcd_i2c.h"
STD_ReturnType LCD_Init(void);

STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const char *Copy_pcText);



STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText);



void LCD_InvalidateShadow(void);

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On);
# 2 "HAL/lcd/lcd_i2c.c" 2
# 1 "APP/config.h" 1
# 3 "HAL/lcd/lcd_i2c.c" 2
# 1 "MCAL/i2c/i2c_interface.h" 1





STD_ReturnType I2C_Init(void);
STD_ReturnType I2C_Start(void);
STD_ReturnType I2C_Stop(void);
STD_ReturnType I2C_Write(uint8 Copy_u8Data);
STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data);
STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data);
# 4 "HAL/lcd/lcd_i2c.c" 2

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
# 6 "HAL/lcd/lcd_i2c.c" 2
# 26 "HAL/lcd/lcd_i2c.c"

# 26 "HAL/lcd/lcd_i2c.c"
static uint8 LCD_au8Shadow[2u][16u];
static uint8 LCD_u8ShadowValid = 0u;

static STD_ReturnType LCD_SendCommand(uint8 Copy_u8Cmd);
static STD_ReturnType LCD_SendRun(uint8 Copy_u8Row,
                                  uint8 Copy_u8Col,
                                  const uint8 *Copy_pu8Data,
                                  uint8 Copy_u8Len);
static uint8 LCD_RowAddress(uint8 Copy_u8Row);



STD_ReturnType LCD_Init(void)
{
    if (I2C_Init() != 0u)
    {
        return 1u;
    }


    _delay_ms(50);

    if (LCD_SendCommand(0x38u) != 0u) { return 1u; }
    _delay_ms(5);
    if (LCD_SendCommand(0x38u) != 0u) { return 1u; }
    _delay_ms(1);
    if (LCD_SendCommand(0x38u) != 0u) { return 1u; }

    if (LCD_SendCommand(0x08u) != 0u) { return 1u; }
    if (LCD_SendCommand(0x01u) != 0u) { return 1u; }
    _delay_ms(2);
    if (LCD_SendCommand(0x06u) != 0u) { return 1u; }
    if (LCD_SendCommand(0x0Cu) != 0u) { return 1u; }

    LCD_InvalidateShadow();
    return 0u;
}

STD_ReturnType LCD_Clear(void)
{
    if (LCD_SendCommand(0x01u) != 0u)
    {
        return 1u;
    }



    LCD_InvalidateShadow();
    return 0u;
}

STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col)
{
    if ((Copy_u8Row >= 2u) || (Copy_u8Col >= 16u))
    {
        return 1u;
    }

    return LCD_SendCommand((uint8)(0x80u
                                   | LCD_RowAddress(Copy_u8Row)
                                   | Copy_u8Col));
}

STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char)
{
    if (I2C_Start() != 0u) { return 1u; }
    if (I2C_Write((uint8)(((0x3Eu) << 1) | 0x00u)) != 0u) { return 1u; }
    if (I2C_Write(0x40u) != 0u) { return 1u; }
    if (I2C_Write(Copy_u8Char) != 0u) { return 1u; }

    return I2C_Stop();
}
# 110 "HAL/lcd/lcd_i2c.c"
STD_ReturnType LCD_WriteString(const char *Copy_pcText)
{
    uint8 Local_u8Index = 0u;

    if (Copy_pcText == 0)
    {
        return 1u;
    }

    while ((Copy_pcText[Local_u8Index] != '\0') && (Local_u8Index < 16u))
    {
        if (LCD_WriteChar((uint8)Copy_pcText[Local_u8Index]) != 0u)
        {
            return 1u;
        }
        Local_u8Index++;
    }

    return 0u;
}

STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText)
{
    uint8 Local_au8Line[16u];
    uint8 Local_u8Col;
    uint8 Local_u8RunStart;
    uint8 Local_u8Ended;

    if ((Copy_u8Row >= 2u) || (Copy_pcText == 0))
    {
        return 1u;
    }


    Local_u8Ended = 0u;
    for (Local_u8Col = 0u; Local_u8Col < 16u; Local_u8Col++)
    {
        if ((Local_u8Ended == 0u) && (Copy_pcText[Local_u8Col] == '\0'))
        {
            Local_u8Ended = 1u;
        }
        Local_au8Line[Local_u8Col] = (Local_u8Ended != 0u)
                                   ? (uint8)' '
                                   : (uint8)Copy_pcText[Local_u8Col];
    }


    Local_u8Col = 0u;
    Local_u8RunStart = 16u;

    while (Local_u8Col <= 16u)
    {
        uint8 Local_u8Differs =
            (Local_u8Col < 16u)
            && ((LCD_u8ShadowValid == 0u)
                || (Local_au8Line[Local_u8Col]
                    != LCD_au8Shadow[Copy_u8Row][Local_u8Col]));

        if ((Local_u8Differs != 0u) && (Local_u8RunStart == 16u))
        {
            Local_u8RunStart = Local_u8Col;
        }
        else if ((Local_u8Differs == 0u) && (Local_u8RunStart != 16u))
        {
            if (LCD_SendRun(Copy_u8Row,
                            Local_u8RunStart,
                            &Local_au8Line[Local_u8RunStart],
                            (uint8)(Local_u8Col - Local_u8RunStart)) != 0u)
            {
                return 1u;
            }
            Local_u8RunStart = 16u;
        }
        else
        {

        }

        Local_u8Col++;
    }

    for (Local_u8Col = 0u; Local_u8Col < 16u; Local_u8Col++)
    {
        LCD_au8Shadow[Copy_u8Row][Local_u8Col] = Local_au8Line[Local_u8Col];
    }

    if (Copy_u8Row == (uint8)(2u - 1u))
    {
        LCD_u8ShadowValid = 1u;
    }

    return 0u;
}

void LCD_InvalidateShadow(void)
{
    LCD_u8ShadowValid = 0u;
}

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On)
{
    return LCD_SendCommand((Copy_u8On != 0u) ? 0x0Cu
                                             : 0x08u);
}



static STD_ReturnType LCD_SendCommand(uint8 Copy_u8Cmd)
{
    if (I2C_Start() != 0u) { return 1u; }
    if (I2C_Write((uint8)(((0x3Eu) << 1) | 0x00u)) != 0u) { return 1u; }
    if (I2C_Write(0x00u) != 0u) { return 1u; }
    if (I2C_Write(Copy_u8Cmd) != 0u) { return 1u; }

    return I2C_Stop();
}

static STD_ReturnType LCD_SendRun(uint8 Copy_u8Row,
                                  uint8 Copy_u8Col,
                                  const uint8 *Copy_pu8Data,
                                  uint8 Copy_u8Len)
{
    uint8 Local_u8Index;

    if (Copy_u8Len == 0u)
    {
        return 0u;
    }

    if (LCD_SendCommand((uint8)(0x80u
                                | LCD_RowAddress(Copy_u8Row)
                                | Copy_u8Col)) != 0u)
    {
        return 1u;
    }



    for (Local_u8Index = 0u; Local_u8Index < Copy_u8Len; Local_u8Index++)
    {
        if (LCD_WriteChar(Copy_pu8Data[Local_u8Index]) != 0u)
        {
            return 1u;
        }
    }

    return 0u;
}

static uint8 LCD_RowAddress(uint8 Copy_u8Row)
{
    return (Copy_u8Row == 0u) ? 0x00u : 0x40u;
}
