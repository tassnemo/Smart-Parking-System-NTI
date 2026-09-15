#ifndef ADC_PRIVATE_H
#define ADC_PRIVATE_H

#include "STD_TYPES.h"

/* ADC registers */
#define ADC_ADMUX   (*(volatile uint8 *)0x27u)
#define ADC_ADCSRA  (*(volatile uint8 *)0x26u)
#define ADC_ADCH    (*(volatile uint8 *)0x25u)
#define ADC_ADCL    (*(volatile uint8 *)0x24u)

/* ADCSRA bit positions */
#define ADC_ADEN    7u
#define ADC_ADSC    6u
#define ADC_ADIF    4u
#define ADC_ADIE    3u

#endif /* ADC_PRIVATE_H */
