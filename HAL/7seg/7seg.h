#ifndef SEG7_H
#define SEG7_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * Free-slot digit, driven through a 74HC4511 BCD-to-7-segment decoder.
 *
 *   PB0..PB3 -> A,B,C,D      LT = HIGH (no lamp test)
 *   LE = LOW (transparent)   BL = HIGH (not blanked)
 *
 * Because LE is tied low the digit follows the nibble continuously: there is
 * no latch pulse and no multiplexing, hence no flicker by construction (TC-36).
 *
 * PB4/PB5/PB7 carry SPI, so the nibble is written pin by pin - never as a
 * whole-port write.
 * --------------------------------------------------------------------------*/

STD_ReturnType SEG_Init(void);

/* 0..9 displayed; anything above SEG7_MAX_DIGIT blanks the digit, which is the
 * 4511's own behaviour for codes 10..15. */
STD_ReturnType SEG_Show(uint8 Copy_u8Value);

STD_ReturnType SEG_Blank(void);

uint8 SEG_GetShadow(void);

#endif /* SEG7_H */