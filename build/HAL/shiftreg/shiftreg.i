# 0 "HAL/shiftreg/shiftreg.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/shiftreg/shiftreg.c"
# 1 "HAL/shiftreg/shiftreg.h" 1



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
# 5 "HAL/shiftreg/shiftreg.h" 2

STD_ReturnType SR_Init(void);
STD_ReturnType SR_Write(uint8 Copy_u8Data);
# 2 "HAL/shiftreg/shiftreg.c" 2
# 1 "APP/config.h" 1
# 3 "HAL/shiftreg/shiftreg.c" 2
# 1 "MCAL/dio/dio_interface.h" 1
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 4 "HAL/shiftreg/shiftreg.c" 2
# 1 "MCAL/spi/spi_interface.h" 1





STD_ReturnType SPI_Init(void);
STD_ReturnType SPI_Transfer(uint8 Copy_u8Data, uint8 *Copy_pu8Received);
# 5 "HAL/shiftreg/shiftreg.c" 2

STD_ReturnType SR_Init(void)
{
    if (SPI_Init() != 0u)
    {
        return 1u;
    }

    if (DIO_Init(1u,
                 4u,
                 1u) != 0u)
    {
        return 1u;
    }

    return DIO_WritePin(1u,
                        4u,
                        0u);
}

STD_ReturnType SR_Write(uint8 Copy_u8Data)
{
    uint8 Local_u8Received;

    if (SPI_Transfer(Copy_u8Data, &Local_u8Received) != 0u)
    {
        return 1u;
    }

    if (DIO_WritePin(1u,
                     4u,
                     1u) != 0u)
    {
        return 1u;
    }

    return DIO_WritePin(1u,
                        4u,
                        0u);
}
