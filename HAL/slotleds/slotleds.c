#include "slotleds.h"
#include "shiftreg.h"
#include "config.h"

static uint16 LED_u16Last  = 0u;
static uint8  LED_u8Primed = 0u;

static uint16 LED_Compose(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);

STD_ReturnType LED_Init(void)
{
    if (SR_Init() != E_OK)
    {
        return E_NOK;
    }

    LED_u16Last  = 0u;
    LED_u8Primed = 0u;
    return E_OK;
}

STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn)
{
    uint16 Local_u16Word = LED_Compose(Copy_u8SlotMap, Copy_u8LampsOn);

    if ((LED_u8Primed != 0u) && (Local_u16Word == LED_u16Last))
    {
        return E_OK;                 /* nothing changed - no bus traffic */
    }

    if (SR_Write(Local_u16Word) != E_OK)
    {
        return E_NOK;
    }

    LED_u16Last  = Local_u16Word;
    LED_u8Primed = 1u;
    return E_OK;
}

STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern)
{
    uint16 Local_u16Word = 0u;
    uint8  Local_u8Slot;

    for (Local_u8Slot = 0u; Local_u8Slot < SR_SLOT_LED_PAIRS; Local_u8Slot++)
    {
        if (Copy_u8Pattern == LED_PATTERN_RED)
        {
            Local_u16Word |= SR_BIT_SLOT_RED(Local_u8Slot);
        }
        else if (Copy_u8Pattern == LED_PATTERN_GREEN)
        {
            Local_u16Word |= SR_BIT_SLOT_GREEN(Local_u8Slot);
        }
        else
        {
            /* LED_PATTERN_OFF: leave the word clear */
        }
    }

    LED_u8Primed = 0u;               /* force the next LED_Update through */
    return SR_Write(Local_u16Word);
}

static uint16 LED_Compose(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn)
{
    uint16 Local_u16Word = 0u;
    uint8  Local_u8Slot;

    Copy_u8SlotMap &= SLOT_MAP_MASK;

    for (Local_u8Slot = 0u; Local_u8Slot < SR_SLOT_LED_PAIRS; Local_u8Slot++)
    {
        if ((Copy_u8SlotMap & (uint8)(1u << Local_u8Slot)) != 0u)
        {
            Local_u16Word |= SR_BIT_SLOT_RED(Local_u8Slot);
        }
        else
        {
            Local_u16Word |= SR_BIT_SLOT_GREEN(Local_u8Slot);
        }
    }

    if (Copy_u8LampsOn != 0u)
    {
        Local_u16Word |= SR_BIT_LOT_LAMP;
    }

    return (uint16)(Local_u16Word & (uint16)(~SR_SPARE_MASK));
}