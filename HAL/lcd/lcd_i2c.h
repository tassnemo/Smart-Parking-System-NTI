#ifndef LCD_I2C_H
#define LCD_I2C_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * 16x2 LCD, AiP31068 native-I2C controller (SimulIDE part "Aip31068_i2c").
 *
 * This is NOT a PCF8574 backpack: there is no nibble mode, no EN strobe and no
 * backlight bit.  Each transaction is
 *      START | (ADDR<<1|W) | control | payload... | STOP
 * control 0x00 -> command bytes follow, 0x40 -> data bytes follow.
 *
 * LCD_Paint() keeps a 2x16 shadow and rewrites only the characters that
 * actually changed, in contiguous runs.  That is what satisfies FR-03
 * ("only changed characters rewritten") and TC-36 (no visible redraw).
 *
 * Blocking: only LCD_Init() uses _delay_ms, as NFR-02 requires.  Every other
 * entry point is a handful of I2C frames and returns immediately.
 * --------------------------------------------------------------------------*/

STD_ReturnType LCD_Init(void);

STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const char *Copy_pcText);

/* Write a 16-char, space-padded line with change detection.
 * Copy_pcText may be shorter than 16 chars; the rest is padded with spaces. */
STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText);

/* Drop the shadow so the next LCD_Paint rewrites everything (use after a
 * controller reset or a manual LCD_Clear). */
void LCD_InvalidateShadow(void);

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On);

#endif /* LCD_I2C_H */