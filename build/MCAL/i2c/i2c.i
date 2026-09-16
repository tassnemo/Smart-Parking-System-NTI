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
# 1 "MCAL/i2c/i2c_private.h" 1
# 3 "MCAL/i2c/i2c.c" 2
# 1 "APP/config.h" 1
# 4 "MCAL/i2c/i2c.c" 2

static STD_ReturnType I2C_WaitForInterrupt(void)
{
 uint16 Local_u16Timeout = 65535u;

 while ((((*(volatile uint8 *)0x56) & (uint8)(1u << 7u)) == 0u) &&
     (Local_u16Timeout > 0u))
 {
  Local_u16Timeout--;
 }

 return (Local_u16Timeout == 0u) ? 1u : 0u;
}

STD_ReturnType I2C_Init(void)
{
 uint32 Local_u32Twbr;


 (*(volatile uint8 *)0x21) &= (uint8)~((1u << 0u) | (1u << 1u));
 Local_u32Twbr = (8000000UL / 100000UL - 16UL) / 2UL;
 if (Local_u32Twbr > 255UL)
 {
  return 1u;
 }

 (*(volatile uint8 *)0x20) = (uint8)Local_u32Twbr;
 (*(volatile uint8 *)0x22) = 0u;
 (*(volatile uint8 *)0x56) = (uint8)(1u << 2u);

 return 0u;
}

STD_ReturnType I2C_Start(void)
{
 (*(volatile uint8 *)0x56) = (uint8)((1u << 7u) |
        (1u << 5u) |
        (1u << 2u));

 if (I2C_WaitForInterrupt() != 0u)
 {
  return 1u;
 }

 return ((((*(volatile uint8 *)0x21) & 0xF8u) == 0x08u) ||
   (((*(volatile uint8 *)0x21) & 0xF8u) == 0x10u))
     ? 0u
     : 1u;
}

STD_ReturnType I2C_Stop(void)
{
 (*(volatile uint8 *)0x56) = (uint8)((1u << 7u) |
        (1u << 4u) |
        (1u << 2u));

 return 0u;
}

STD_ReturnType I2C_Write(uint8 Copy_u8Data)
{
 uint8 Local_u8Status;

 (*(volatile uint8 *)0x23) = Copy_u8Data;
 (*(volatile uint8 *)0x56) = (uint8)((1u << 7u) |
        (1u << 2u));

 if (I2C_WaitForInterrupt() != 0u)
 {
  return 1u;
 }

 Local_u8Status = (*(volatile uint8 *)0x21) & 0xF8u;
     return ((Local_u8Status == 0x18u) ||
      (Local_u8Status == 0x28u))
     ? 0u
     : 1u;
}

STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data)
{
 if (Copy_pu8Data == ((void *)0))
 {
  return 1u;
 }

 (*(volatile uint8 *)0x56) = (uint8)((1u << 7u) |
        (1u << 6u) |
        (1u << 2u));

 if (I2C_WaitForInterrupt() != 0u ||
  ((*(volatile uint8 *)0x21) & 0xF8u) != 0x50u)
 {
  return 1u;
 }

 *Copy_pu8Data = (*(volatile uint8 *)0x23);
 return 0u;
}

STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data)
{
 if (Copy_pu8Data == ((void *)0))
 {
  return 1u;
 }

 (*(volatile uint8 *)0x56) = (uint8)((1u << 7u) |
        (1u << 2u));

 if (I2C_WaitForInterrupt() != 0u ||
  ((*(volatile uint8 *)0x21) & 0xF8u) != 0x58u)
 {
  return 1u;
 }

 *Copy_pu8Data = (*(volatile uint8 *)0x23);
 return 0u;
}
