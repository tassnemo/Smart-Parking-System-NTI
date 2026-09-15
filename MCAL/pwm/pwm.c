#include "pwm_interface.h"
#include "pwm_private.h"

STD_ReturnType PWM_Init(void)
{
    PWM_DDRD |=
        (uint8)((1u << PWM_PD5) |
                (1u << PWM_PD4));

    PWM_TCCR1A =
        (uint8)((1u << PWM_COM1A1) |
                (1u << PWM_COM1B1) |
                (1u << PWM_WGM11));

    PWM_TCCR1B =
        (uint8)((1u << PWM_WGM13) |
                (1u << PWM_WGM12) |
                (1u << PWM_CS11));

   PWM_ICR1H = (uint8)(PWM_TIMER1_TOP >> 8u);
   PWM_ICR1L = (uint8)(PWM_TIMER1_TOP & 0xFFu);

   PWM_OCR1AH = (uint8)(PWM_SERVO_CLOSED_US >> 8u);
   PWM_OCR1AL = (uint8)(PWM_SERVO_CLOSED_US & 0xFFu);

   PWM_OCR1BH = (uint8)(PWM_SERVO_CLOSED_US >> 8u);
   PWM_OCR1BL = (uint8)(PWM_SERVO_CLOSED_US & 0xFFu);

    return E_OK;
}

STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel,
                            uint16 Copy_u16PulseUs)
{
    if (Copy_u16PulseUs < PWM_SERVO_CLOSED_US ||
        Copy_u16PulseUs > PWM_SERVO_OPEN_US)
    {
        return E_NOK;
    }

    if (Copy_u8Channel == PWM_CH_ENTRY)
    {
        PWM_OCR1AH = (uint8)(Copy_u16PulseUs >> 8u);
        PWM_OCR1AL = (uint8)(Copy_u16PulseUs & 0xFFu);
        return E_OK;
    }

    if (Copy_u8Channel == PWM_CH_EXIT)
    {
        PWM_OCR1BH = (uint8)(Copy_u16PulseUs >> 8u);
        PWM_OCR1BL = (uint8)(Copy_u16PulseUs & 0xFFu);
        return E_OK;
    }

    return E_NOK;
}