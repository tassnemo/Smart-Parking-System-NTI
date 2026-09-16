#include "HAL/barrier/barrier.h"
#include "MCAL/pwm/pwm_interface.h"
#include <util/delay.h>

int main(void)
{
    PWM_Init();
    BAR_Init(PWM_CH_ENTRY);
    BAR_Init(PWM_CH_EXIT);

    while (1)
    {
        BAR_Open(PWM_CH_ENTRY);
        _delay_ms(2000);

        BAR_Close(PWM_CH_ENTRY);
        _delay_ms(2000);

        BAR_Open(PWM_CH_EXIT);
        _delay_ms(2000);

        BAR_Close(PWM_CH_EXIT);
        _delay_ms(2000);
    }

    return 0;
}