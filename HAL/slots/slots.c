#include "slots.h"
#include "config.h"
#include "dio_interface.h"

/* ----------------------------------------------------------------------------
 * MCAL adaptation. If your dio_interface.h names the port-wide read or the
 * pull-up input mode differently, change these two lines only - the same
 * convention is already used by Tests/main_test_slots.c.
 * --------------------------------------------------------------------------*/
#define SLOT_PORT_READ(port, pval)      DIO_ReadPort((port), (pval))
#define SLOT_PIN_MODE_PULLUP            DIO_INPUT_PULLUP

static uint8 SLOT_u8PublishedMap = 0u;   /* last debounced, published bitmap */
static uint8 SLOT_u8Candidate    = 0u;   /* raw value currently being timed  */
static uint8 SLOT_u8SampleCount  = 0u;

static uint8 SLOT_Popcount6(uint8 Copy_u8Map);

STD_ReturnType SLOT_Init(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < SLOT_COUNT; Local_u8Index++)
    {
        if (DIO_Init(SLOT_PORT,
                     (uint8)(SLOT_FIRST_PIN + Local_u8Index),
                     SLOT_PIN_MODE_PULLUP) != E_OK)
        {
            return E_NOK;
        }
    }

    SLOT_u8PublishedMap = 0u;
    SLOT_u8Candidate    = 0u;
    SLOT_u8SampleCount  = 0u;
    return E_OK;
}

STD_ReturnType SLOT_Poll(void)
{
    uint8 Local_u8Port = 0u;
    uint8 Local_u8Raw;

    /* ONE PINC read, then pure bit masking (TC-07) - low = occupied, so the
     * raw port value is inverted before it means anything. */
    if (SLOT_PORT_READ(SLOT_PORT, &Local_u8Port) != E_OK)
    {
        return E_NOK;
    }

    Local_u8Raw = (uint8)((uint8)(~Local_u8Port & SLOT_MASK) >> SLOT_FIRST_PIN);
    Local_u8Raw &= SLOT_MAP_MASK;

    if (Local_u8Raw != SLOT_u8Candidate)
    {
        /* Sensors moved: restart the debounce window on the new value. */
        SLOT_u8Candidate   = Local_u8Raw;
        SLOT_u8SampleCount = 1u;
    }
    else if (SLOT_u8SampleCount < SLOT_DEBOUNCE_SAMPLES)
    {
        SLOT_u8SampleCount++;
        if (SLOT_u8SampleCount >= SLOT_DEBOUNCE_SAMPLES)
        {
            /* SLOT_DEBOUNCE_SAMPLES x TASK_SLOTS_PERIOD_MS = 50 ms (FR-01). */
            SLOT_u8PublishedMap = SLOT_u8Candidate;
        }
    }
    else
    {
        /* already stable and already published - nothing to do */
    }

    return E_OK;
}

uint8 SLOT_GetMap(void)
{
    return SLOT_u8PublishedMap;
}

uint8 SLOT_CountFree(void)
{
    return (uint8)(SLOT_COUNT - SLOT_Popcount6(SLOT_u8PublishedMap));
}

/* Required by FR-02: free count derived without a per-slot loop. */
static uint8 SLOT_Popcount6(uint8 Copy_u8Map)
{
    Copy_u8Map &= SLOT_MAP_MASK;
    Copy_u8Map  = (uint8)(Copy_u8Map - ((Copy_u8Map >> 1) & 0x55u));
    Copy_u8Map  = (uint8)((Copy_u8Map & 0x33u) + ((Copy_u8Map >> 2) & 0x33u));
    return (uint8)((Copy_u8Map + (Copy_u8Map >> 4)) & 0x0Fu);
}