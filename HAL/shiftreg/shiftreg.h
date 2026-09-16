#ifndef SHIFTREG_H
#define SHIFTREG_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * 74HC4094 x 2, cascaded:   PB5 (data) -> U1.D , U1.QS' -> U2.D ("overflow")
 *                           PB7 (clock) -> both CK
 *                           PB4 (strobe) -> both STR
 *                           OE of both -> VCC   (active HIGH, see audit A-1)
 *
 * Word layout (see config.h for the full bit map):
 *      bits 0..7   = U1 (744094-150)  slot 1..4 red/green
 *      bits 8..15  = U2 (744094-142)  slot 5..6 red/green + lot lamp
 *
 * The high byte is transmitted first because the first bits clocked out pass
 * through U1 and end up in U2.
 * --------------------------------------------------------------------------*/

STD_ReturnType SR_Init(void);

/* Shift 16 bits into the chain and pulse STR once so both registers publish
 * on the same edge (no partial-update flicker). */
STD_ReturnType SR_Write(uint16 Copy_u16Data);

/* Last word actually driven onto the chain. */
uint16 SR_GetShadow(void);

#endif /* SHIFTREG_H */