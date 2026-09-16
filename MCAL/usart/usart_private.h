#ifndef USART_PRIVATE_H
#define USART_PRIVATE_H

#include "STD_TYPES.h"
#include "config.h"

/* ---------------- USART Registers (ATmega32) ---------------- */

#define USART_UDR      (*(volatile uint8 *)0x2C)

#define USART_UCSRA    (*(volatile uint8 *)0x2B)
#define USART_UCSRB    (*(volatile uint8 *)0x2A)
#define USART_UCSRC    (*(volatile uint8 *)0x40)

#define USART_UBRRL    (*(volatile uint8 *)0x29)
#define USART_UBRRH    (*(volatile uint8 *)0x40)

/* ---------------- UCSRA bits ---------------- */

#define USART_RXC     7u
#define USART_TXC     6u
#define USART_UDRE    5u
#define USART_FE      4u
#define USART_DOR     3u
#define USART_PE      2u
#define USART_U2X     1u
#define USART_MPCM    0u

/* ---------------- UCSRB bits ---------------- */

#define USART_RXCIE   7u
#define USART_TXCIE   6u
#define USART_UDRIE   5u
#define USART_RXEN    4u
#define USART_TXEN    3u
#define USART_UCSZ2   2u
#define USART_RXB8    1u
#define USART_TXB8    0u

/* ---------------- UCSRC bits ---------------- */

#define USART_URSEL    7u
#define USART_UMSEL    6u
#define USART_UPM1     5u
#define USART_UPM0     4u
#define USART_USBS     3u
#define USART_UCSZ1    2u
#define USART_UCSZ0    1u
#define USART_UCPOL    0u

/* ---------------- Configuration ---------------- */

/* Normal asynchronous mode: UBRR = F_CPU / (16 * BAUD) - 1 */
#define USART_UBRR_VALUE \
	((F_CPU / (16UL * UART_BAUD_RATE)) - 1UL)

#endif /* USART_PRIVATE_H */