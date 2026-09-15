#ifndef EXTI_PRIVATE_H
#define EXTI_PRIVATE_H

#include "STD_TYPES.h"
#include <avr/interrupt.h>

#define EXTI_MCUCR      (*(volatile uint8 *)0x55u)
#define EXTI_MCUCSR     (*(volatile uint8 *)0x54u)
#define EXTI_GICR       (*(volatile uint8 *)0x5Bu)
#define EXTI_GIFR       (*(volatile uint8 *)0x5Au)

#define EXTI_ISC00      0u
#define EXTI_ISC01      1u
#define EXTI_ISC10      2u
#define EXTI_ISC11      3u
#define EXTI_ISC2       6u

#define EXTI_INT0_ENABLE 6u
#define EXTI_INT1_ENABLE 7u
#define EXTI_INT2_ENABLE 5u

#define EXTI_INTF0      6u
#define EXTI_INTF1      7u
#define EXTI_INTF2      5u

#endif