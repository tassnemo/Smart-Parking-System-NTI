#ifndef PWM_PRIVATE_H
#define PWM_PRIVATE_H

#include "STD_TYPES.h"

/* ---------------- Timer1 registers (ATmega32) ---------------- */
#define PWM_TCCR1A  (*(volatile uint8  *)0x4F)
#define PWM_TCCR1B  (*(volatile uint8  *)0x4E)
#define PWM_ICR1    (*(volatile uint16 *)0x46) /* ICR1L=0x46, ICR1H=0x47 */
#define PWM_OCR1A   (*(volatile uint16 *)0x4A) /* OCR1AL=0x4A, OCR1AH=0x4B */
#define PWM_OCR1B   (*(volatile uint16 *)0x48) /* OCR1BL=0x48, OCR1BH=0x49 */

/* ---------------- DDRD (servo output pins live on Port D) ---------------- */
#define PWM_DDRD    (*(volatile uint8  *)0x31)
#define PWM_PD4     4u   /* OC1B - exit barrier  */
#define PWM_PD5     5u   /* OC1A - entry barrier */

/* ---------------- TCCR1A bits ---------------- */
#define PWM_COM1A1  7u
#define PWM_COM1A0  6u
#define PWM_COM1B1  5u
#define PWM_COM1B0  4u
#define PWM_WGM11   1u
#define PWM_WGM10   0u

/* ---------------- TCCR1B bits ---------------- */
#define PWM_WGM13   4u
#define PWM_WGM12   3u
#define PWM_CS12    2u
#define PWM_CS11    1u
#define PWM_CS10    0u

/* Fast PWM mode 14 (ICR1 = TOP): WGM13:10 = 1110 -> WGM13=1,WGM12=1,WGM11=1,WGM10=0 */
/* Prescaler /8: CS12:10 = 010 -> CS11=1 only     

*/

#define PWM_SERVO_CLOSED_US  1000u
#define PWM_SERVO_OPEN_US    2000u
#define PWM_TIMER1_TOP       19999u

#endif /* PWM_PRIVATE_H */