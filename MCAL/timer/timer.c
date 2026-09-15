#include "timer_interface.h"
#include "timer_private.h"
#include <avr/interrupt.h>
static TMR0_CallbackType g_TMR0Callback = NULL;

STD_ReturnType TMR0_InitCTC(void)
{
    TMR_TCCR0 = (uint8)(1u << TMR_WGM01);

    TMR_TCNT0 = 0u;

    TMR_OCR0 = 77u;

    TMR_TIMSK |= (uint8)(1u << TMR_OCIE0);

    TMR_TIFR = (uint8)(1u << TMR_OCF0);

    return E_OK;
}

STD_ReturnType TMR0_Start(void)
{
    TMR_TCCR0 =
        (uint8)((TMR_TCCR0 & (uint8)~((1u << TMR_CS00) |
                                       (1u << TMR_CS01) |
                                       (1u << TMR_CS02))) |
                (uint8)((1u << TMR_CS02) |
                        (1u << TMR_CS00)));

    return E_OK;
}

STD_ReturnType TMR0_Stop(void)
{
    TMR_TCCR0 &=
        (uint8)~((1u << TMR_CS00) |
                 (1u << TMR_CS01) |
                 (1u << TMR_CS02));

    return E_OK;
}

STD_ReturnType TMR0_SetCompare(uint8 Copy_u8Value)
{
    TMR_OCR0 = Copy_u8Value;
    return E_OK;
}

STD_ReturnType TMR0_SetCallback(TMR0_CallbackType Copy_pfCallback)
{
    if (Copy_pfCallback == NULL)
    {
        return E_NOK;
    }

    g_TMR0Callback = Copy_pfCallback;

    return E_OK;
}

ISR(TIMER0_COMP_vect)
{
    if (g_TMR0Callback != NULL)
    {
        g_TMR0Callback();
    }
}