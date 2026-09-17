#include "display_task.h"
#include "config.h"
#include "lot_fsm.h"
#include "HAL/slotleds/slotleds.h"
#include "HAL/7seg/7seg.h"
#include "HAL/lcd/lcd_i2c.h"
#include "APP/light/light.h"
#include "APP/lane/lane_fsm.h"   



static void DISPLAY_PaintLine1(uint8 Copy_u8Free, uint8 Copy_u8Occupied);
static void DISPLAY_PaintLine2(void);

STD_ReturnType DISPLAY_Init(void)
{
    /* Nothing owned locally - this task only reads other modules' state and
     * writes through HAL calls that already init themselves. Kept as a
     * function (rather than skipped) so main.c's init list stays uniform and
       so a future per-task flag (e.g. "force full repaint next tick") has
       somewhere to go without changing the call site. */
    return E_OK;
}

void DISPLAY_Task(void)
{
    uint8 Local_u8Map      = LOT_GetMap();
    uint8 Local_u8Free     = LOT_GetFree();
    uint8 Local_u8Occupied = LOT_GetOccupied();

    /* --- slot LEDs + lot lamp (4094 chain) --- */
    LED_Update(Local_u8Map, LIGHT_GetState());

    /* --- free-slot digit (4511 decoder) --- */
    (void)SEG_Show(Local_u8Free);

    /* --- LCD --- */
    DISPLAY_PaintLine1(Local_u8Free, Local_u8Occupied);
    DISPLAY_PaintLine2();
}

/* "FREE:3  OCC:3  " per FR-03 */
static void DISPLAY_PaintLine1(uint8 Copy_u8Free, uint8 Copy_u8Occupied)
{
    char Local_acLine[LCD_COLS + 1u];

    Local_acLine[0]  = 'F';
    Local_acLine[1]  = 'R';
    Local_acLine[2]  = 'E';
    Local_acLine[3]  = 'E';
    Local_acLine[4]  = ':';
    Local_acLine[5]  = (char)('0' + Copy_u8Free);
    Local_acLine[6]  = ' ';
    Local_acLine[7]  = ' ';
    Local_acLine[8]  = 'O';
    Local_acLine[9]  = 'C';
    Local_acLine[10] = 'C';
    Local_acLine[11] = ':';
    Local_acLine[12] = (char)('0' + Copy_u8Occupied);
    Local_acLine[13] = ' ';
    Local_acLine[14] = ' ';
    Local_acLine[15] = ' ';
    Local_acLine[16] = '\0';

    (void)LCD_Paint(0u, Local_acLine);
}




extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

static const char *LANE_Name(uint8 state)
{
    switch (state)
    {
        case LN_IDLE:            return "IDLE";
        case LN_VEHICLE_WAIT:    return "WAIT";
        case LN_AUTHORISING:     return "AUTH";
        case LN_GATE_OPENING:    return "OPEN";
        case LN_GATE_OPEN:       return "OPEN";
        case LN_VEHICLE_PASSING: return "PASS";
        case LN_GATE_CLOSING:    return "CLOS";
        case LN_REJECTED:        return "REJ ";
        case LN_TIMEOUT:         return "TIME";
        default:                 return "?   ";
    }
}

static void DISPLAY_PaintLine2(void)
{
    char line[LCD_COLS + 1u];
    const char *in  = LANE_Name((uint8)g_entryLane.state);
    const char *out = LANE_Name((uint8)g_exitLane.state);

    line[0]  = 'I'; line[1]  = 'N';  line[2]  = ':';
    line[3]  = in[0]; line[4]  = in[1]; line[5]  = in[2]; line[6]  = in[3];
    line[7]  = ' ';
    line[8]  = 'O'; line[9]  = 'U';  line[10] = 'T'; line[11] = ':';
    line[12] = out[0]; line[13] = out[1]; line[14] = out[2]; line[15] = out[3];
    line[16] = '\0';

    (void)LCD_Paint(1u, line);
}