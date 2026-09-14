#include "slots.h"
#include "MCAL/dio/dio_interface.h"

#define SLOT_PORT              DIO_PORTC
#define SLOT_MASK              0x3Fu
#define SLOT_DEBOUNCE_COUNT    1u

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
        if (DIO_Init(DIO_PORTC, pin, DIO_INPUT) != E_OK)
        {
            return E_NOK;
        }
    }

    return E_OK;
}
STD_ReturnType SLOT_Poll(void)
{
    uint8 portValue;
    uint8 rawMap;

    /*
     * Read all six slot sensors in ONE port read.
     * Sensors are active-low:
     * LOW  -> occupied -> bitmap bit = 1
     * HIGH -> free     -> bitmap bit = 0
     */
    (void)DIO_ReadPort(SLOT_PORT, &portValue);

   rawMap = (uint8)((~portValue >> 2u) & SLOT_MASK);

    if (rawMap == g_lastRawMap)
    {
        if (g_stableCount < SLOT_DEBOUNCE_COUNT)
        {
            g_stableCount++;
        }

        if (g_stableCount >= SLOT_DEBOUNCE_COUNT)
        {
            g_slotMap = rawMap;
        }
    }
    else
    {
        g_lastRawMap = rawMap;
        g_stableCount = 0u;
    }

    return E_OK;
}

uint8 SLOT_GetMap(void)
{
    return g_slotMap;
}

uint8 SLOT_CountFree(uint8 Copy_u8SlotMap)
{
    Copy_u8SlotMap &= SLOT_MASK;

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