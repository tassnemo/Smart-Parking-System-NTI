#include "MCAL/adc/ADC_interface.h"
#include "MCAL/dio/dio_interface.h"

int main(void)
{
    uint16 adcValue = 0u;

    ADC_Init(ADC_REF_AVCC, ADC_PRESC_64);

    DIO_Init(DIO_PORTB, 0u, DIO_OUTPUT);
    DIO_WritePin(DIO_PORTB, 0u, STD_LOW);

    while (1)
    {
        ADC_ReadChannel(ADC_CHANNEL_0, &adcValue);

        if (adcValue > 512u)
        {
            DIO_WritePin(DIO_PORTB, 0u, STD_HIGH);
        }
        else
        {
            DIO_WritePin(DIO_PORTB, 0u, STD_LOW);
        }
    }

    return 0;
}