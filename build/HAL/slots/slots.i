# 0 "HAL/slots/slots.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/slots/slots.c"
# 1 "HAL/slots/slots.h" 1



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
# 5 "HAL/slots/slots.h" 2

STD_ReturnType SLOT_Init(void);
STD_ReturnType SLOT_Poll(void);
uint8 SLOT_CountFree(uint8 Copy_u8SlotMap);
uint8 SLOT_IsOccupied(uint8 Copy_u8SlotMap, uint8 Copy_u8Index);
uint8 SLOT_GetMap(void);
# 2 "HAL/slots/slots.c" 2
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
# 3 "HAL/slots/slots.c" 2





static uint8 g_slotMap = 0u;
static uint8 g_lastRawMap = 0u;
static uint8 g_stableCount = 0u;

STD_ReturnType SLOT_Init(void)
{
    g_slotMap = 0u;
    g_lastRawMap = 0u;
    g_stableCount = 0u;

    for (uint8 pin = 2u; pin <= 7u; pin++)
    {
        if (DIO_Init(2u, pin, 2u) != 0u)
        {
            return 1u;
        }
    }

    return 0u;
}
STD_ReturnType SLOT_Poll(void)
{
    uint8 portValue;
    uint8 rawMap;







    (void)DIO_ReadPort(2u, &portValue);

   rawMap = (uint8)((~portValue >> 2u) & 0x3Fu);

    if (rawMap == g_lastRawMap)
    {
        if (g_stableCount < 1u)
        {
            g_stableCount++;
        }

        if (g_stableCount >= 1u)
        {
            g_slotMap = rawMap;
        }
    }
    else
    {
        g_lastRawMap = rawMap;
        g_stableCount = 0u;
    }

    return 0u;
}

uint8 SLOT_GetMap(void)
{
    return g_slotMap;
}

uint8 SLOT_CountFree(uint8 Copy_u8SlotMap)
{
    Copy_u8SlotMap &= 0x3Fu;

    Copy_u8SlotMap =
        (uint8)(Copy_u8SlotMap - ((Copy_u8SlotMap >> 1) & 0x55u));

    Copy_u8SlotMap =
        (uint8)((Copy_u8SlotMap & 0x33u) +
                ((Copy_u8SlotMap >> 2) & 0x33u));

    Copy_u8SlotMap =
        (uint8)((Copy_u8SlotMap +
                (Copy_u8SlotMap >> 4)) & 0x0Fu);

    return (uint8)(6u - Copy_u8SlotMap);
}

uint8 SLOT_IsOccupied(uint8 Copy_u8SlotMap, uint8 Copy_u8Index)
{
    if (Copy_u8Index >= 6u)
    {
        return 0u;
    }

    return (Copy_u8SlotMap & (uint8)(1u << Copy_u8Index)) ? 1u : 0u;
}
