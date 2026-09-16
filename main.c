#include "MCAL/pwm/pwm_interface.h"
#include <util/delay.h>

int main(void)
{
    PWM_Init();

    while (1)
    {
        PWM_SetPulse(PWM_CH_ENTRY, 1000u);
        _delay_ms(2000);

        PWM_SetPulse(PWM_CH_ENTRY, 1500u);
        _delay_ms(2000);
    }

    return 0;
}