#include "lcd_i2c.h"
#include "config.h"
#include "i2c_interface.h"

#include <util/delay.h>          /* _delay_ms - LCD_Init() only (NFR-02) */

/* ----------------------------------------------------------------------------
 * MCAL adaptation layer.
 * --------------------------------------------------------------------------*/
#define LCD_I2C_INIT()          I2C_Init()
#define LCD_I2C_START()         I2C_Start()
#define I2C_WRITE_BIT            0x00u
#define LCD_I2C_ADDR_W(a)       I2C_Write((uint8)(((a) << 1) | I2C_WRITE_BIT))
#define LCD_I2C_BYTE(b)         I2C_Write(b)
#define LCD_I2C_STOP()          I2C_Stop()

/* HD44780-compatible instruction set used by the AiP31068 */
#define LCD_CMD_CLEAR           0x01u
#define LCD_CMD_HOME            0x02u
#define LCD_CMD_ENTRY_MODE      0x06u   /* increment, no shift            */
#define LCD_CMD_DISPLAY_OFF     0x08u
#define LCD_CMD_DISPLAY_ON      0x0Cu   /* display on, cursor off, no blink */
#define LCD_CMD_FUNCTION_SET    0x38u   /* 8-bit iface, 2 lines, 5x8 font  */
#define LCD_CMD_SET_DDRAM       0x80u

static uint8 LCD_au8Shadow[LCD_ROWS][LCD_COLS];
static uint8 LCD_u8ShadowValid = 0u;

static STD_ReturnType LCD_SendCommand(uint8 Copy_u8Cmd);
static STD_ReturnType LCD_SendRun(uint8 Copy_u8Row,
                                  uint8 Copy_u8Col,
                                  const uint8 *Copy_pu8Data,
                                  uint8 Copy_u8Len);
static uint8          LCD_RowAddress(uint8 Copy_u8Row);

/* ======================================================================== */

STD_ReturnType LCD_Init(void)
{
    if (LCD_I2C_INIT() != E_OK)
    {
        return E_NOK;
    }

    /* AiP31068 needs the supply to settle before it accepts anything. */
    _delay_ms(50);

    if (LCD_SendCommand(LCD_CMD_FUNCTION_SET) != E_OK) { return E_NOK; }
    _delay_ms(5);
    if (LCD_SendCommand(LCD_CMD_FUNCTION_SET) != E_OK) { return E_NOK; }
    _delay_ms(1);
    if (LCD_SendCommand(LCD_CMD_FUNCTION_SET) != E_OK) { return E_NOK; }

    if (LCD_SendCommand(LCD_CMD_DISPLAY_OFF)  != E_OK) { return E_NOK; }
    if (LCD_SendCommand(LCD_CMD_CLEAR)        != E_OK) { return E_NOK; }
    _delay_ms(2);                                   /* clear is slow */
    if (LCD_SendCommand(LCD_CMD_ENTRY_MODE)   != E_OK) { return E_NOK; }
    if (LCD_SendCommand(LCD_CMD_DISPLAY_ON)   != E_OK) { return E_NOK; }

    LCD_InvalidateShadow();
    return E_OK;
}

STD_ReturnType LCD_Clear(void)
{
    if (LCD_SendCommand(LCD_CMD_CLEAR) != E_OK)
    {
        return E_NOK;
    }

    /* The controller needs ~1.5 ms; we do not block. The next LCD_Paint runs
     * 250 ms later at the earliest, so the delay is naturally absorbed. */
    LCD_InvalidateShadow();
    return E_OK;
}

STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col)
{
    if ((Copy_u8Row >= LCD_ROWS) || (Copy_u8Col >= LCD_COLS))
    {
        return E_NOK;
    }

    return LCD_SendCommand((uint8)(LCD_CMD_SET_DDRAM
                                   | LCD_RowAddress(Copy_u8Row)
                                   | Copy_u8Col));
}

STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char)
{
    if (LCD_I2C_START() != E_OK)                        { return E_NOK; }
    if (LCD_I2C_ADDR_W(LCD_I2C_ADDRESS) != E_OK)        { return E_NOK; }
    if (LCD_I2C_BYTE(LCD_CTRL_DATA) != E_OK)            { return E_NOK; }
    if (LCD_I2C_BYTE(Copy_u8Char) != E_OK)              { return E_NOK; }

    return LCD_I2C_STOP();
}

/* ----------------------------------------------------------------------------
 * IMPORTANT: this AiP31068 component does NOT support multiple data bytes
 * bursted inside one START..STOP transaction - only the first byte of a
 * burst actually lands (confirmed: LCD_WriteChar, called once per byte in
 * separate transactions, is 100% reliable; a single-transaction multi-byte
 * write corrupts after byte 1). So every character - here and in
 * LCD_SendRun() below - gets its own full START/address/control/byte/STOP
 * cycle via LCD_WriteChar(). The controller's own internal DDRAM address
 * counter auto-increments and persists across STOP, so we do not need to
 * re-send LCD_SetCursor() between characters of the same run.
 * --------------------------------------------------------------------------*/
STD_ReturnType LCD_WriteString(const char *Copy_pcText)
{
    uint8 Local_u8Index = 0u;

    if (Copy_pcText == 0)
    {
        return E_NOK;
    }

    while ((Copy_pcText[Local_u8Index] != '\0') && (Local_u8Index < LCD_COLS))
    {
        if (LCD_WriteChar((uint8)Copy_pcText[Local_u8Index]) != E_OK)
        {
            return E_NOK;
        }
        Local_u8Index++;
    }

    return E_OK;
}

STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText)
{
    uint8 Local_au8Line[LCD_COLS];
    uint8 Local_u8Col;
    uint8 Local_u8RunStart;
    uint8 Local_u8Ended;

    if ((Copy_u8Row >= LCD_ROWS) || (Copy_pcText == 0))
    {
        return E_NOK;
    }

    /* Build the space-padded 16-char image of the line. */
    Local_u8Ended = 0u;
    for (Local_u8Col = 0u; Local_u8Col < LCD_COLS; Local_u8Col++)
    {
        if ((Local_u8Ended == 0u) && (Copy_pcText[Local_u8Col] == '\0'))
        {
            Local_u8Ended = 1u;
        }
        Local_au8Line[Local_u8Col] = (Local_u8Ended != 0u)
                                   ? (uint8)' '
                                   : (uint8)Copy_pcText[Local_u8Col];
    }

    /* Walk the line and push only contiguous runs of changed characters. */
    Local_u8Col      = 0u;
    Local_u8RunStart = LCD_COLS;

    while (Local_u8Col <= LCD_COLS)
    {
        uint8 Local_u8Differs =
            (Local_u8Col < LCD_COLS)
            && ((LCD_u8ShadowValid == 0u)
                || (Local_au8Line[Local_u8Col]
                    != LCD_au8Shadow[Copy_u8Row][Local_u8Col]));

        if ((Local_u8Differs != 0u) && (Local_u8RunStart == LCD_COLS))
        {
            Local_u8RunStart = Local_u8Col;
        }
        else if ((Local_u8Differs == 0u) && (Local_u8RunStart != LCD_COLS))
        {
            if (LCD_SendRun(Copy_u8Row,
                            Local_u8RunStart,
                            &Local_au8Line[Local_u8RunStart],
                            (uint8)(Local_u8Col - Local_u8RunStart)) != E_OK)
            {
                return E_NOK;
            }
            Local_u8RunStart = LCD_COLS;
        }
        else
        {
            /* inside a run, or inside unchanged text: nothing to do */
        }

        Local_u8Col++;
    }

    for (Local_u8Col = 0u; Local_u8Col < LCD_COLS; Local_u8Col++)
    {
        LCD_au8Shadow[Copy_u8Row][Local_u8Col] = Local_au8Line[Local_u8Col];
    }

    if (Copy_u8Row == (uint8)(LCD_ROWS - 1u))
    {
        LCD_u8ShadowValid = 1u;
    }

    return E_OK;
}

void LCD_InvalidateShadow(void)
{
    LCD_u8ShadowValid = 0u;
}

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On)
{
    return LCD_SendCommand((Copy_u8On != 0u) ? LCD_CMD_DISPLAY_ON
                                             : LCD_CMD_DISPLAY_OFF);
}

/* ======================================================================== */

static STD_ReturnType LCD_SendCommand(uint8 Copy_u8Cmd)
{
    if (LCD_I2C_START() != E_OK)                        { return E_NOK; }
    if (LCD_I2C_ADDR_W(LCD_I2C_ADDRESS) != E_OK)        { return E_NOK; }
    if (LCD_I2C_BYTE(LCD_CTRL_COMMAND) != E_OK)         { return E_NOK; }
    if (LCD_I2C_BYTE(Copy_u8Cmd) != E_OK)               { return E_NOK; }

    return LCD_I2C_STOP();
}

static STD_ReturnType LCD_SendRun(uint8 Copy_u8Row,
                                  uint8 Copy_u8Col,
                                  const uint8 *Copy_pu8Data,
                                  uint8 Copy_u8Len)
{
    uint8 Local_u8Index;

    if (Copy_u8Len == 0u)
    {
        return E_OK;
    }

    if (LCD_SendCommand((uint8)(LCD_CMD_SET_DDRAM
                                | LCD_RowAddress(Copy_u8Row)
                                | Copy_u8Col)) != E_OK)
    {
        return E_NOK;
    }

    /* One full transaction per character - see the note above LCD_WriteString.
     * DDRAM address auto-increments internally between these transactions. */
    for (Local_u8Index = 0u; Local_u8Index < Copy_u8Len; Local_u8Index++)
    {
        if (LCD_WriteChar(Copy_pu8Data[Local_u8Index]) != E_OK)
        {
            return E_NOK;
        }
    }

    return E_OK;
}

static uint8 LCD_RowAddress(uint8 Copy_u8Row)
{
    return (Copy_u8Row == 0u) ? LCD_ROW0_ADDR : LCD_ROW1_ADDR;
}