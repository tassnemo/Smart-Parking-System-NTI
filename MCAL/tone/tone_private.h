#ifndef TONE_PRIVATE_H
#define TONE_PRIVATE_H

#include "STD_TYPES.h"

/* ---------------- Timer2 registers (ATmega32) ---------------- */
#define TONE_TCCR2  (*(volatile uint8 *)0x45)
#define TONE_TCNT2  (*(volatile uint8 *)0x44)
#define TONE_OCR2   (*(volatile uint8 *)0x43)

/* ---------------- TCCR2 bits ---------------- */
#define TONE_FOC2   7u
#define TONE_WGM20  6u
#define TONE_COM21  5u
#define TONE_COM20  4u
#define TONE_WGM21  3u
#define TONE_CS22   2u
#define TONE_CS21   1u
#define TONE_CS20   0u

/* CTC mode (TOP = OCR2): WGM21=1, WGM20=0
   Toggle OC2 on compare match: COM21=0, COM20=1
   Prescaler /64: CS22=1, CS21=0, CS20=0 */

/* ---------------- Pin: OC2 lives on PD7 ---------------- */
#define TONE_DDRD   (*(volatile uint8 *)0x31)
#define TONE_PORTD  (*(volatile uint8 *)0x32)
#define TONE_PD7    7u

#endif /* TONE_PRIVATE_H */