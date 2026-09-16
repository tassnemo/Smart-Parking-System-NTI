# 0 "HAL/slots/slots.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/slots/slots.c"
# 1 "HAL/slots/slots.h" 1



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
# 5 "HAL/slots/slots.h" 2
# 20 "HAL/slots/slots.h"
STD_ReturnType SLOT_Init(void);



STD_ReturnType SLOT_Poll(void);


uint8 SLOT_GetMap(void);



uint8 SLOT_CountFree(void);
# 2 "HAL/slots/slots.c" 2
# 1 "APP/config.h" 1
# 3 "HAL/slots/slots.c" 2
# 1 "MCAL/dio/dio_interface.h" 1
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 4 "HAL/slots/slots.c" 2
# 13 "HAL/slots/slots.c"
static uint8 SLOT_u8PublishedMap = 0u;
static uint8 SLOT_u8Candidate = 0u;
static uint8 SLOT_u8SampleCount = 0u;

static uint8 SLOT_Popcount6(uint8 Copy_u8Map);

STD_ReturnType SLOT_Init(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < 6u; Local_u8Index++)
    {
        if (DIO_Init(2u,
                     (uint8)(2u + Local_u8Index),
                     2u) != 0u)
        {
            return 1u;
        }
    }

    SLOT_u8PublishedMap = 0u;
    SLOT_u8Candidate = 0u;
    SLOT_u8SampleCount = 0u;
    return 0u;
}

STD_ReturnType SLOT_Poll(void)
{
    uint8 Local_u8Port = 0u;
    uint8 Local_u8Raw;



    if (DIO_ReadPort((2u), (&Local_u8Port)) != 0u)
    {
        return 1u;
    }

    Local_u8Raw = (uint8)((uint8)(~Local_u8Port & 0xFCu) >> 2u);
    Local_u8Raw &= 0x3Fu;

    if (Local_u8Raw != SLOT_u8Candidate)
    {

        SLOT_u8Candidate = Local_u8Raw;
        SLOT_u8SampleCount = 1u;
    }
    else if (SLOT_u8SampleCount < 5u)
    {
        SLOT_u8SampleCount++;
        if (SLOT_u8SampleCount >= 5u)
        {

            SLOT_u8PublishedMap = SLOT_u8Candidate;
        }
    }
    else
    {

    }

    return 0u;
}

uint8 SLOT_GetMap(void)
{
    return SLOT_u8PublishedMap;
}

uint8 SLOT_CountFree(void)
{
    return (uint8)(6u - SLOT_Popcount6(SLOT_u8PublishedMap));
}


static uint8 SLOT_Popcount6(uint8 Copy_u8Map)
{
    Copy_u8Map &= 0x3Fu;
    Copy_u8Map = (uint8)(Copy_u8Map - ((Copy_u8Map >> 1) & 0x55u));
    Copy_u8Map = (uint8)((Copy_u8Map & 0x33u) + ((Copy_u8Map >> 2) & 0x33u));
    return (uint8)((Copy_u8Map + (Copy_u8Map >> 4)) & 0x0Fu);
}
