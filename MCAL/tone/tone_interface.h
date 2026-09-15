#ifndef TONE_INTERFACE_H
#define TONE_INTERFACE_H

#include "STD_TYPES.h"

/*
 * MCAL TONE — Timer2 CTC, hardware toggle-on-compare-match on OC2 (PD7).
 * This is what actually makes the buzzer produce an audible tone instead
 * of a single click: OC2 is toggled by hardware on every compare match,
 * with no CPU/ISR involvement per toggle, at roughly 2 kHz.
 *
 * F_CPU = 8 MHz, prescaler /64 -> 125 kHz counter clock.
 * OCR2 = 31 -> toggle freq = 125000 / (2 * 32) ~= 1953 Hz (audible tone).
 */

/*
 * Description : Configure Timer2 CTC mode and OCR2, but leave the timer
 *               STOPPED and OC2 disconnected (silent) until TONE_Start.
 *               Also ensures PD7 is driven LOW via plain DIO so there's
 *               no residual level on the pin.
 */
STD_ReturnType TONE_Init(void);

/*
 * Description : Connect OC2 to the pin (toggle-on-compare) and start the
 *               timer clock. The pin now oscillates in hardware -- audible
 *               tone begins immediately, no further calls needed to sustain it.
 */
STD_ReturnType TONE_Start(void);

/*
 * Description : Disconnect OC2 from the pin, stop the timer clock, and
 *               force the pin back to a clean LOW via DIO.
 */
STD_ReturnType TONE_Stop(void);

#endif /* TONE_INTERFACE_H */