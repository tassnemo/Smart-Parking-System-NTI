# 0 "HAL/7seg/7seg.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/7seg/7seg.c"
# 1 "HAL/7seg/7seg.h" 1



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
# 5 "HAL/7seg/7seg.h" 2
# 19 "HAL/7seg/7seg.h"
STD_ReturnType SEG_Init(void);



STD_ReturnType SEG_Show(uint8 Copy_u8Value);

STD_ReturnType SEG_Blank(void);

uint8 SEG_GetShadow(void);
# 2 "HAL/7seg/7seg.c" 2
# 1 "APP/config.h" 1
# 3 "HAL/7seg/7seg.c" 2
# 1 "MCAL/dio/dio_interface.h" 1
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 4 "HAL/7seg/7seg.c" 2

static const uint8 SEG_au8Pins[4] =
{
    0u, 1u, 2u, 3u
};

static uint8 SEG_u8Shadow = 0x0Fu;
static uint8 SEG_u8Primed = 0u;

static STD_ReturnType SEG_WriteNibble(uint8 Copy_u8Code);

STD_ReturnType SEG_Init(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < 4u; Local_u8Index++)
    {
        if (DIO_Init(1u,
                     SEG_au8Pins[Local_u8Index],
                     1u) != 0u)
        {
            return 1u;
        }
    }

    SEG_u8Primed = 0u;
    return SEG_Blank();
}

STD_ReturnType SEG_Show(uint8 Copy_u8Value)
{
    uint8 Local_u8Code = (Copy_u8Value > 9u)
                       ? 0x0Fu
                       : Copy_u8Value;

    if ((SEG_u8Primed != 0u) && (Local_u8Code == SEG_u8Shadow))
    {
        return 0u;
    }

    if (SEG_WriteNibble(Local_u8Code) != 0u)
    {
        return 1u;
    }

    SEG_u8Shadow = Local_u8Code;
    SEG_u8Primed = 1u;
    return 0u;
}

STD_ReturnType SEG_Blank(void)
{
    return SEG_Show(0x0Fu);
}

uint8 SEG_GetShadow(void)
{
    return SEG_u8Shadow;
}

static STD_ReturnType SEG_WriteNibble(uint8 Copy_u8Code)
{
    uint8 Local_u8Index;
    uint8 Local_u8Level;

    for (Local_u8Index = 0u; Local_u8Index < 4u; Local_u8Index++)
    {
        Local_u8Level = ((Copy_u8Code & (uint8)(1u << Local_u8Index)) != 0u)
                      ? 1u
                      : 0u;

        if (DIO_WritePin(1u,
                         SEG_au8Pins[Local_u8Index],
                         Local_u8Level) != 0u)
        {
            return 1u;
        }
    }

    return 0u;
}
