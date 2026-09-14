#ifndef DIO_PRIVATE_H
#define DIO_PRIVATE_H

#include "STD_TYPES.h"

#define DIO_PORTA_REG (*(volatile uint8 *)0x3B) /* PORTA */
#define DIO_DDRA_REG  (*(volatile uint8 *)0x3A) /* DDRA */
#define DIO_PINA_REG  (*(volatile uint8 *)0x39) /* PINA */

#define DIO_PORTB_REG (*(volatile uint8 *)0x38) /* PORTB */
#define DIO_DDRB_REG  (*(volatile uint8 *)0x37) /* DDRB */
#define DIO_PINB_REG  (*(volatile uint8 *)0x36) /* PINB */

#define DIO_PORTC_REG (*(volatile uint8 *)0x35) /* PORTC */
#define DIO_DDRC_REG  (*(volatile uint8 *)0x34) /* DDRC */
#define DIO_PINC_REG  (*(volatile uint8 *)0x33) /* PINC */

#define DIO_PORTD_REG (*(volatile uint8 *)0x32) /* PORTD */
#define DIO_DDRD_REG  (*(volatile uint8 *)0x31) /* DDRD */
#define DIO_PIND_REG  (*(volatile uint8 *)0x30) /* PIND */

#endif