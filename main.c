#include <avr/interrupt.h>

#include "LIB/STD_TYPES.h"

void Entry_ISR(void)
{
    /* parking logic or lane flag set */
}

int main(void)
{
    /* init hardware */
    sei();

    while (1)
    {
    }
    return 0;
}