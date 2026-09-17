#include "lcd_i2c.h"
#include "config.h"

static void SR_Delay(void)
{
    volatile uint32 d;
    for (d = 0; d < 800000ul; d++) { }
}

int main(void)
{
    LCD_Init();

    /* 1) Full initial paint — every char is "different" from an invalid
     *    shadow, so this should draw the whole 16x2 in one shot. */
    LCD_Paint(0, "FREE:6  OCC:0");
    LCD_Paint(1, "IN:IDLE OUT:IDLE");
    SR_Delay();

    /* 2) Partial update — only the digits after "FREE:" and "OCC:" change.
     *    You won't SEE a difference in behaviour (LCD hardware can't show
     *    "only some chars redrawn"), but this exercises the run-detection
     *    logic in LCD_Paint rather than a full rewrite. */
    LCD_Paint(0, "FREE:3  OCC:3");
    LCD_Paint(1, "IN:OPEN OUT:IDLE");
    SR_Delay();

    /* 3) Explicit clear + shadow invalidation, then repaint from scratch */
    LCD_Clear();
    SR_Delay();
    LCD_Paint(0, "FREE:3  OCC:3");
    LCD_Paint(1, "IN:OPEN OUT:IDLE");
    SR_Delay();

    /* 4) Bypass LCD_Paint entirely — raw cursor + char/string writes,
     *    to confirm the low-level primitives work independent of the
     *    shadow-diff layer above them. */
    LCD_SetCursor(0, 0);
    LCD_WriteString("RAW LINE 1 TEST");
    LCD_SetCursor(1, 0);
    LCD_WriteChar('X');
    LCD_WriteChar('Y');
    LCD_WriteChar('Z');

    while (1) { }
}