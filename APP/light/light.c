#include "light.h"
#include "config.h"
#include "adc_interface.h"
#include "APP/console/console.h"

static uint8 g_u8LampsOn = 0u;

STD_ReturnType LIGHT_Init(void)
{
    g_u8LampsOn = 0u;
    return E_OK;
}

STD_ReturnType LIGHT_Run(void)
{
    uint16 Local_u16Raw;
    uint16 Local_u16OnThreshold;
    uint16 Local_u16OffThreshold;
    uint8  Local_u8Threshold;
    uint8  Local_u8OffThreshold;

    /* Read ambient light sensor on ADC2 */
    if (ADC_ReadChannel(LIGHT_ADC_CHANNEL, &Local_u16Raw) != E_OK)
    {
        return E_NOK;
    }

    Local_u8Threshold = CONSOLE_GetLightThresh();

    /* ON threshold */
    Local_u16OnThreshold =
        LIGHT_PCT_TO_RAW(Local_u8Threshold);

    /* OFF threshold = threshold + hysteresis */
    Local_u8OffThreshold =
        (uint8)(Local_u8Threshold + LIGHT_HYSTERESIS_PERCENT);

    if (Local_u8OffThreshold > 100u)
    {
        Local_u8OffThreshold = 100u;
    }

    Local_u16OffThreshold =
        LIGHT_PCT_TO_RAW(Local_u8OffThreshold);

    /*
     * Lamps OFF:
     * turn them ON when ambient light falls below threshold.
     */
    if (g_u8LampsOn == 0u)
    {
        if (Local_u16Raw < Local_u16OnThreshold)
        {
            g_u8LampsOn = 1u;
        }
    }

    /*
     * Lamps ON:
     * keep them ON until light rises above threshold + hysteresis.
     */
    else
    {
        if (Local_u16Raw >= Local_u16OffThreshold)
        {
            g_u8LampsOn = 0u;
        }
    }

    return E_OK;
}

uint8 LIGHT_GetState(void)
{
    return g_u8LampsOn;
}