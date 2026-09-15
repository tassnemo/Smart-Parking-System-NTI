#include "pwm_interface.h"
#include "pwm_private.h"

STD_ReturnType PWM_Init(void)
{
    /* Servo pins as outputs: PD5 = OC1A (entry), PD4 = OC1B (exit) */
    PWM_DDRD |= (uint8)((1u << PWM_PD5) | (1u << PWM_PD4));

    /* Non-inverting mode on both OC1A and OC1B, Fast PWM (mode 14, ICR1=TOP):
       COM1A1=1 COM1A0=0, COM1B1=1 COM1B0=0, WGM11=1 WGM10=0 */
    PWM_TCCR1A = (uint8)((1u << PWM_COM1A1) | (1u << PWM_COM1B1) | (1u << PWM_WGM11));

    /* WGM13=1 WGM12=1 (completes mode 14), prescaler /8: CS11=1 */
    PWM_TCCR1B = (uint8)((1u << PWM_WGM13) | (1u << PWM_WGM12) | (1u << PWM_CS11));

    /* 20 ms frame: 8MHz / 8 = 1MHz tick (1us/tick), 20000 ticks = 20ms */
    PWM_ICR1 = 19999u;

    /* Park both barriers CLOSED on init */
    PWM_OCR1A = PWM_SERVO_CLOSED_US;
    PWM_OCR1B = PWM_SERVO_CLOSED_US;

    return E_OK;
}

STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel, uint16 Copy_u16PulseUs)
{
    switch (Copy_u8Channel)
    {
        case PWM_CH_ENTRY:
            PWM_OCR1A = Copy_u16PulseUs;
            return E_OK;

        case PWM_CH_EXIT:
            PWM_OCR1B = Copy_u16PulseUs;
            return E_OK;

        default:
            return E_NOK;
    }
}