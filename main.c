#include "MCAL/pwm/pwm_private.h"

int main(void)
{
    PWM_DDRD |= (1u << PWM_PD5);

    PWM_TCCR1A = (1u << PWM_COM1A1) |
                 (1u << PWM_WGM11);

    PWM_TCCR1B = (1u << PWM_WGM13) |
                 (1u << PWM_WGM12) |
                 (1u << PWM_CS11);

    PWM_ICR1 = 19999u;

    PWM_OCR1A = 1000u;

    while (1)
    {
    }

    return 0;
}