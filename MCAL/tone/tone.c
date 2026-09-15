#include "tone_interface.h"
#include "tone_private.h"

STD_ReturnType TONE_Init(void)
{
    /* PD7/OC2 as output */
    TONE_DDRD |= (uint8)(1u << TONE_PD7);

    /* Set the compare value for ~2kHz, but leave COM bits at 00
       (OC2 disconnected) and CS bits at 000 (timer stopped) --
       silent until TONE_Start is called. */
    TONE_OCR2  = 31u;
    TONE_TCNT2 = 0u;
    TONE_TCCR2 = (uint8)(1u << TONE_WGM21);   /* CTC mode, timer stopped, OC2 disconnected */

    /* Force the pin to a clean LOW while disconnected */
    TONE_PORTD &= (uint8)(~(1u << TONE_PD7));

    return E_OK;
}

STD_ReturnType TONE_Start(void)
{
    /* Connect OC2 (toggle on compare match) AND start the clock (/64)
       in one write: WGM21 | COM20 | CS22 */
    TONE_TCCR2 = (uint8)((1u << TONE_WGM21) | (1u << TONE_COM20) | (1u << TONE_CS22));

    return E_OK;
}

STD_ReturnType TONE_Stop(void)
{
    /* Disconnect OC2 and stop the clock -- back to CTC-configured-but-idle */
    TONE_TCCR2 = (uint8)(1u << TONE_WGM21);

    /* Force a clean LOW -- OC2 may have left the pin HIGH when disconnected */
    TONE_PORTD &= (uint8)(~(1u << TONE_PD7));

    return E_OK;
}