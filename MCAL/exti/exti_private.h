#ifndef EXTI_PRIVATE_H
#define EXTI_PRIVATE_H

#include "STD_TYPES.h"

#define EXTI_MCUCR  (*(volatile uint8 *)0x55)
#define EXTI_MCUCSR (*(volatile uint8 *)0x54)
#define EXTI_GICR   (*(volatile uint8 *)0x5B)
#define EXTI_GIFR   (*(volatile uint8 *)0x5A)
#define EXTI_SREG   (*(volatile uint8 *)0x5F)

#define EXTI_ISC00 0u
#define EXTI_ISC01 1u
#define EXTI_ISC10 2u
#define EXTI_ISC11 3u
#define EXTI_ISC2  6u

#define EXTI_INT0_BIT 6u
#define EXTI_INT1_BIT 7u
#define EXTI_INT2_BIT 5u

#define EXTI_INTF0 6u
#define EXTI_INTF1 7u
#define EXTI_INTF2 5u

#define EXTI_SREG_I 7u

#endif