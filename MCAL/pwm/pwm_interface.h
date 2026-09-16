#ifndef PWM_INTERFACE_H
#define PWM_INTERFACE_H

#include "STD_TYPES.h"
#include "config.h"

/*
 * MCAL PWM — Timer1 Fast PWM (mode 14), two channels for the barrier servos.
 * F_CPU = 8 MHz, prescaler = 8  =>  1 timer tick = 1 us.
 * ICR1 = 19999 => 20000 us period = 20 ms frame (standard servo frame rate).
 *
 * Servo angle is set purely by writing OCR1A / OCR1B in microseconds:
 *   1000 us -> 0 deg  (barrier CLOSED)
 *   2000 us -> 90 deg (barrier OPEN)
 */

/*
 * Description : Configure Timer1 for Fast PWM mode 14, 20 ms frame,
 *               enable both OC1A/OC1B outputs, set DDR for PD4/PD5,
 *               and park both servos at PWM_SERVO_CLOSED_US.
 */
STD_ReturnType PWM_Init(void);

/*
 * Description : Set the pulse width (in microseconds) for one servo channel.
 * Parameters  : Copy_u8Channel   - PWM_CH_ENTRY or PWM_CH_EXIT
 *               Copy_u16PulseUs  - pulse width in microseconds (typically 1000-2000)
 * Return      : E_NOK for an unknown channel.
 */
STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel, uint16 Copy_u16PulseUs);

#endif /* PWM_INTERFACE_H */