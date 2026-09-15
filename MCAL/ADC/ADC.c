#include "STD_TYPES.h"
#include "ADC_interface.h"
#include "ADC_private.h"

STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler)
{
    if ((Copy_u8Ref != ADC_REF_AREF &&
         Copy_u8Ref != ADC_REF_AVCC &&
         Copy_u8Ref != ADC_REF_INTERNAL_2V56) ||
        (Copy_u8Prescaler < ADC_PRESC_2 ||
         Copy_u8Prescaler > ADC_PRESC_128))
    {
        return E_NOK;
    }

    /* Set reference voltage and right-adjust the result */
    ADC_ADMUX = (uint8)((Copy_u8Ref << 6u) |
                        (ADC_RIGHT_ADJUST << 5u));

    /* Enable ADC and set prescaler */
    ADC_ADCSRA = (uint8)((Copy_u8Prescaler & 0x07u) |
                         (1u << ADC_ADEN));

    return E_OK;
}

STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel,
                               uint16 *Copy_pu16Reading)
{
    if (Copy_u8Channel > ADC_CHANNEL_7 ||
        Copy_pu16Reading == NULL)
    {
        return E_NOK;
    }

    /* Select channel while preserving reference/adjustment bits */
    ADC_ADMUX = (uint8)((ADC_ADMUX & 0xE0u) |
                        (Copy_u8Channel & 0x1Fu));

    /* Clear any previous conversion-complete flag */
    ADC_ADCSRA |= (uint8)(1u << ADC_ADIF);

    /* Start conversion */
    ADC_ADCSRA |= (uint8)(1u << ADC_ADSC);

    /* Wait until conversion completes */
    while ((ADC_ADCSRA & (uint8)(1u << ADC_ADIF)) == 0u)
    {
        /* Wait */
    }

    /* Clear ADIF */
    ADC_ADCSRA |= (uint8)(1u << ADC_ADIF);

    /* ADCL must be read before ADCH */
    *Copy_pu16Reading = (uint16)(ADC_ADCL |
                          ((uint16)ADC_ADCH << 8u));

    return E_OK;
}

STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel)
{
    if (Copy_u8Channel > ADC_CHANNEL_7)
    {
        return E_NOK;
    }

    /* Do not start another conversion while one is running */
    if ((ADC_ADCSRA & (uint8)(1u << ADC_ADSC)) != 0u)
    {
        return E_NOK;
    }

    /* Select channel */
    ADC_ADMUX = (uint8)((ADC_ADMUX & 0xE0u) |
                        (Copy_u8Channel & 0x1Fu));

    /* Clear previous ADIF */
    ADC_ADCSRA |= (uint8)(1u << ADC_ADIF);

    /* Start conversion */
    ADC_ADCSRA |= (uint8)(1u << ADC_ADSC);

    return E_OK;
}

STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading)
{
    if (Copy_pu16Reading == NULL)
    {
        return E_NOK;
    }

    /* Conversion not finished yet */
    if ((ADC_ADCSRA & (uint8)(1u << ADC_ADIF)) == 0u)
    {
        return E_NOK;
    }

    /* Clear ADIF */
    ADC_ADCSRA |= (uint8)(1u << ADC_ADIF);

    /* ADCL must be read before ADCH */
    *Copy_pu16Reading = (uint16)(ADC_ADCL |
                          ((uint16)ADC_ADCH << 8u));

    return E_OK;
}

STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State)
{
    if (Copy_u8State == 1u)
    {
        ADC_ADCSRA |= (uint8)(1u << ADC_ADIE);
        return E_OK;
    }

    if (Copy_u8State == 0u)
    {
        ADC_ADCSRA &= (uint8)~(1u << ADC_ADIE);
        return E_OK;
    }

    return E_NOK;
}