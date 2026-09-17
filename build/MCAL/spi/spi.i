# 0 "MCAL/spi/spi.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/spi/spi.c"
# 1 "MCAL/spi/spi_interface.h" 1



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
# 5 "MCAL/spi/spi_interface.h" 2

STD_ReturnType SPI_Init(void);
STD_ReturnType SPI_Transfer(uint8 Copy_u8Data, uint8 *Copy_pu8Received);
# 2 "MCAL/spi/spi.c" 2
# 1 "MCAL/spi/spi_private.h" 1
# 3 "MCAL/spi/spi.c" 2

STD_ReturnType SPI_Init(void)
{

 (*(volatile uint8 *)0x37) |= (uint8)((1u << 5u) | (1u << 7u));
 (*(volatile uint8 *)0x37) &= (uint8)~(1u << 6u);


 (*(volatile uint8 *)0x2D) = (uint8)((1u << 6u) |
        (1u << 4u) |
        (1u << 0u));
 (*(volatile uint8 *)0x2E) &= (uint8)~(1u << 0u);

 return 0u;
}

STD_ReturnType SPI_Transfer(uint8 Copy_u8Data, uint8 *Copy_pu8Received)
{
 if (Copy_pu8Received == ((void *)0))
 {
  return 1u;
 }

 (*(volatile uint8 *)0x2F) = Copy_u8Data;


   while (((*(volatile uint8 *)0x2E) & (1u << 7u)) == 0u)
    {

    }


 *Copy_pu8Received = (*(volatile uint8 *)0x2F);

 return 0u;
}
