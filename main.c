/* ============================================================================
 * TEST 1 - 74HC4094 chain bring-up
 *
 * Build alone. No inputs, no interrupts. Verifies: OE wiring, strobe polarity,
 * SPI mode, cascade order and every LED net name.
 *
 * Expected behaviour:
 *   Phase A  walking bit, 300 ms per step, in this exact order:
 *              led1r led1g led2r led2g led3r led3g led4r led4g
 *              led5r led5g led6r led6g lightled   (then 3 dark steps)
 *   Phase B  all red 700 ms, all green 700 ms, lamp only 700 ms, all off 700 ms
 *   repeat forever.
 *
 * Diagnosis table:
 *   nothing ever lights ................ OE tied to GND (audit A-1), or STR
 *                                        never pulsed / SPI never initialised
 *   everything lights and stays on ..... STR stuck HIGH (latch transparent)
 *   order starts at led5r, not led1r ... the two bytes in SR_Write are swapped
 *   bits land in the wrong half of a
 *   chip / mirrored within a byte ...... SPI is LSB-first (clear DORD) or the
 *                                        4094 is falling-edge clocked -> use
 *                                        SPI mode 2 (SPI_CLOCK_MODE in config)
 *   lamp step lights nothing ........... net name mismatch lighted/lightled
 *                                        (audit A-3)
 * ==========================================================================*/

#include "config.h"
#include "STD_TYPES.h"
#include "shiftreg.h"
#include <util/delay.h>

#define TEST_CHAIN_BITS     13u     /* 12 slot LEDs + lot lamp */

int main(void)
{
    uint8 Local_u8Bit;

    if (SR_Init() != E_OK)
    {
        /* SPI or DIO refused: stop here, the chain cannot be tested. */
        while (1) { }
    }

    while (1)
    {
        /* ---- Phase A : walking bit over the whole 16-bit word ---- */
        for (Local_u8Bit = 0u; Local_u8Bit < 16u; Local_u8Bit++)
        {
            (void)SR_Write((uint16)(1u << Local_u8Bit));
            _delay_ms(300);
        }

        (void)SR_Write(0x0000u);
        _delay_ms(500);

        /* ---- Phase B : block patterns ---- */
        (void)SR_Write(0x0555u);            /* every red   : bits 0,2,4,6,8,10 */
        _delay_ms(700);

        (void)SR_Write(0x0AAAu);            /* every green : bits 1,3,5,7,9,11 */
        _delay_ms(700);

        (void)SR_Write(SR_BIT_LOT_LAMP);    /* lamp only   : bit 12            */
        _delay_ms(700);

        (void)SR_Write(0x0000u);
        _delay_ms(700);

        (void)TEST_CHAIN_BITS;              /* documentation only */
    }
}