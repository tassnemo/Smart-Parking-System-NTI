# 0 "HAL/slotleds.h/slotleds.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/slotleds.h/slotleds.c"
# 1 "HAL/slotleds.h/slotleds.h" 1



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
# 5 "HAL/slotleds.h/slotleds.h" 2
# 18 "HAL/slotleds.h/slotleds.h"
STD_ReturnType LED_Init(void);


STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);


STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern);
# 2 "HAL/slotleds.h/slotleds.c" 2
# 1 "HAL/shiftreg/shiftreg.h" 1
# 20 "HAL/shiftreg/shiftreg.h"
STD_ReturnType SR_Init(void);



STD_ReturnType SR_Write(uint16 Copy_u16Data);


uint16 SR_GetShadow(void);
# 3 "HAL/slotleds.h/slotleds.c" 2
# 1 "APP/config.h" 1
# 4 "HAL/slotleds.h/slotleds.c" 2

static uint16 LED_u16Last = 0u;
static uint8 LED_u8Primed = 0u;

static uint16 LED_Compose(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);

STD_ReturnType LED_Init(void)
{
    if (SR_Init() != 0u)
    {
        return 1u;
    }

    LED_u16Last = 0u;
    LED_u8Primed = 0u;
    return 0u;
}

STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn)
{
    uint16 Local_u16Word = LED_Compose(Copy_u8SlotMap, Copy_u8LampsOn);

    if ((LED_u8Primed != 0u) && (Local_u16Word == LED_u16Last))
    {
        return 0u;
    }

    if (SR_Write(Local_u16Word) != 0u)
    {
        return 1u;
    }

    LED_u16Last = Local_u16Word;
    LED_u8Primed = 1u;
    return 0u;
}

STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern)
{
    uint16 Local_u16Word = 0u;
    uint8 Local_u8Slot;

    for (Local_u8Slot = 0u; Local_u8Slot < 6u; Local_u8Slot++)
    {
        if (Copy_u8Pattern == 1u)
        {
            Local_u16Word |= ((Local_u8Slot) < 4u ? (uint16)(1u << ((Local_u8Slot) * 2u)) : (uint16)(1u << (((Local_u8Slot) - 4u) * 2u + 8u)));
        }
        else if (Copy_u8Pattern == 2u)
        {
            Local_u16Word |= ((Local_u8Slot) < 4u ? (uint16)(1u << ((Local_u8Slot) * 2u + 1u)) : (uint16)(1u << (((Local_u8Slot) - 4u) * 2u + 9u)));
        }
        else
        {

        }
    }

    LED_u8Primed = 0u;
    return SR_Write(Local_u16Word);
}

static uint16 LED_Compose(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn)
{
    uint16 Local_u16Word = 0u;
    uint8 Local_u8Slot;

    Copy_u8SlotMap &= 0x3Fu;

    for (Local_u8Slot = 0u; Local_u8Slot < 6u; Local_u8Slot++)
    {
        if ((Copy_u8SlotMap & (uint8)(1u << Local_u8Slot)) != 0u)
        {
            Local_u16Word |= ((Local_u8Slot) < 4u ? (uint16)(1u << ((Local_u8Slot) * 2u)) : (uint16)(1u << (((Local_u8Slot) - 4u) * 2u + 8u)));
        }
        else
        {
            Local_u16Word |= ((Local_u8Slot) < 4u ? (uint16)(1u << ((Local_u8Slot) * 2u + 1u)) : (uint16)(1u << (((Local_u8Slot) - 4u) * 2u + 9u)));
        }
    }

    if (Copy_u8LampsOn != 0u)
    {
        Local_u16Word |= ((uint16)0x1000u);
    }

    return (uint16)(Local_u16Word & (uint16)(~((uint16)0xE000u)));
}
