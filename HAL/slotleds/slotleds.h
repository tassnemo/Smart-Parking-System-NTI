#ifndef SLOTLEDS_H
#define SLOTLEDS_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * The 12 bi-colour slot LEDs and the lot lamp all hang off the 4094 chain.
 * This module owns the meaning of the bits; shiftreg.c only owns the wires.
 *
 *   slot occupied -> red on,   green off
 *   slot free     -> green on, red off
 *   lampsOn       -> lot lamp ("lightled") on
 *
 * LED_Update() writes the chain only when the composed word changes, so a
 * static lot costs zero SPI traffic (see config.h FIX-3).
 * --------------------------------------------------------------------------*/

STD_ReturnType LED_Init(void);

/* Copy_u8SlotMap: bit n = 1 -> slot n+1 occupied (6 valid bits). */
STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);

/* Maintenance / lamp-test helper: all red, all green, or all off. */
STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern);

#define LED_PATTERN_OFF     0u
#define LED_PATTERN_RED     1u
#define LED_PATTERN_GREEN   2u

#endif /* SLOTLEDS_H */