#ifndef TIMER_PRIVATE_H
#define TIMER_PRIVATE_H

#include "STD_TYPES.h"

#define TMR_TCCR0   (*(volatile uint8 *)0x53)
#define TMR_TCNT0   (*(volatile uint8 *)0x52)
#define TMR_OCR0    (*(volatile uint8 *)0x5C)
#define TMR_TIMSK   (*(volatile uint8 *)0x59)
#define TMR_TIFR    (*(volatile uint8 *)0x58)
#define TMR_OCF0 1u
#define TMR_CS00 0u
#define TMR_CS01 1u
#define TMR_CS02 2u
#define TMR_WGM01 3u
#define TMR_COM00 4u
#define TMR_COM01 5u
#define TMR_OCIE0 1u

#endif