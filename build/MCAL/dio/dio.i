# 0 "MCAL/dio/dio.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/dio/dio.c"
# 1 "MCAL/dio/dio_interface.h" 1



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
# 5 "MCAL/dio/dio_interface.h" 2
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 2 "MCAL/dio/dio.c" 2
# 1 "MCAL/dio/dio_private.h" 1
# 3 "MCAL/dio/dio.c" 2


STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction)
{
    if (Copy_u8Pin > 7u)
    {
        return 1u;
    }

    switch (Copy_u8Port)
    {
        case 0u:
            if (Copy_u8Direction == 1u)
            {
                (*(volatile uint8 *)0x3A) |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == 2u)
            {
                (*(volatile uint8 *)0x3A) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x3B) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x3A) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x3B) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        case 1u:
            if (Copy_u8Direction == 1u)
            {
                (*(volatile uint8 *)0x37) |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == 2u)
            {
                (*(volatile uint8 *)0x37) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x38) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x37) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x38) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        case 2u:
            if (Copy_u8Direction == 1u)
            {
                (*(volatile uint8 *)0x34) |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == 2u)
            {
                (*(volatile uint8 *)0x34) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x35) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x34) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x35) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        case 3u:
            if (Copy_u8Direction == 1u)
            {
                (*(volatile uint8 *)0x31) |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == 2u)
            {
                (*(volatile uint8 *)0x31) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x32) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x31) &= (uint8)(~(1u << Copy_u8Pin));
                (*(volatile uint8 *)0x32) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        default:
            return 1u;
    }
}

STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value)
{
    if (Copy_u8Pin > 7u)
    {
        return 1u;
    }

    switch (Copy_u8Port)
    {
        case 0u:
            if (Copy_u8Value == 1u)
            {
                (*(volatile uint8 *)0x3B) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x3B) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        case 1u:
            if (Copy_u8Value == 1u)
            {
                (*(volatile uint8 *)0x38) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x38) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        case 2u:
            if (Copy_u8Value == 1u)
            {
                (*(volatile uint8 *)0x35) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x35) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        case 3u:
            if (Copy_u8Value == 1u)
            {
                (*(volatile uint8 *)0x32) |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                (*(volatile uint8 *)0x32) &= (uint8)(~(1u << Copy_u8Pin));
            }
            return 0u;

        default:
            return 1u;
    }
}

STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value)
{
    if (Copy_pu8Value == ((void *)0))
    {
        return 1u;
    }

    if (Copy_u8Pin > 7u)
    {
        return 1u;
    }

    switch (Copy_u8Port)
    {
        case 0u:
            *Copy_pu8Value = (uint8)(((*(volatile uint8 *)0x39) >> Copy_u8Pin) & 0x01u);
            return 0u;

        case 1u:
            *Copy_pu8Value = (uint8)(((*(volatile uint8 *)0x36) >> Copy_u8Pin) & 0x01u);
            return 0u;

        case 2u:
            *Copy_pu8Value = (uint8)(((*(volatile uint8 *)0x33) >> Copy_u8Pin) & 0x01u);
            return 0u;

        case 3u:
            *Copy_pu8Value = (uint8)(((*(volatile uint8 *)0x30) >> Copy_u8Pin) & 0x01u);
            return 0u;

        default:
            return 1u;
    }
}

STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value)
{
    switch (Copy_u8Port)
    {
        case 0u:
            (*(volatile uint8 *)0x3B) = Copy_u8Value;
            return 0u;

        case 1u:
            (*(volatile uint8 *)0x38) = Copy_u8Value;
            return 0u;

        case 2u:
            (*(volatile uint8 *)0x35) = Copy_u8Value;
            return 0u;

        case 3u:
            (*(volatile uint8 *)0x32) = Copy_u8Value;
            return 0u;

        default:
            return 1u;
    }
}

STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value)
{
    if (Copy_pu8Value == ((void *)0))
    {
        return 1u;
    }

    switch (Copy_u8Port)
    {
        case 0u:
            *Copy_pu8Value = (*(volatile uint8 *)0x39);
            return 0u;

        case 1u:
            *Copy_pu8Value = (*(volatile uint8 *)0x36);
            return 0u;

        case 2u:
            *Copy_pu8Value = (*(volatile uint8 *)0x33);
            return 0u;

        case 3u:
            *Copy_pu8Value = (*(volatile uint8 *)0x30);
            return 0u;

        default:
            return 1u;
    }
}

STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
    if (Copy_u8Pin > 7u)
    {
        return 1u;
    }

    switch (Copy_u8Port)
    {
        case 0u:
            (*(volatile uint8 *)0x3B) ^= (uint8)(1u << Copy_u8Pin);
            return 0u;

        case 1u:
            (*(volatile uint8 *)0x38) ^= (uint8)(1u << Copy_u8Pin);
            return 0u;

        case 2u:
            (*(volatile uint8 *)0x35) ^= (uint8)(1u << Copy_u8Pin);
            return 0u;

        case 3u:
            (*(volatile uint8 *)0x32) ^= (uint8)(1u << Copy_u8Pin);
            return 0u;

        default:
            return 1u;
    }
}
