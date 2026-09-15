# 0 "HAL/buzzer/buzzer.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/buzzer/buzzer.c"
# 1 "HAL/buzzer/buzzer.h" 1



# 1 "./LIB/STD_TYPES.h" 1



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
# 23 "./LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 5 "HAL/buzzer/buzzer.h" 2

STD_ReturnType BUZ_Init(uint8 Copy_u8Pin);
STD_ReturnType BUZ_On(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Off(uint8 Copy_u8Pin);
# 2 "HAL/buzzer/buzzer.c" 2
# 1 "./MCAL/dio/dio_interface.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "./MCAL/dio/dio_interface.h" 2
# 27 "./MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 3 "HAL/buzzer/buzzer.c" 2



STD_ReturnType BUZ_Init(uint8 Copy_u8Pin)
{
    return DIO_Init(3u, Copy_u8Pin, 1u);
}

STD_ReturnType BUZ_On(uint8 Copy_u8Pin)
{
    return DIO_WritePin(3u, Copy_u8Pin, 1u);
}

STD_ReturnType BUZ_Off(uint8 Copy_u8Pin)
{
    return DIO_WritePin(3u, Copy_u8Pin, 0u);
}
