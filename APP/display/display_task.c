#include "display_task.h"
#include "config.h"
#include "lot_fsm.h"
#include "HAL/slotleds/slotleds.h"
#include "HAL/7seg/7seg.h"
#include "HAL/lcd/lcd_i2c.h"

/* Lot lamp: driven by ambient-light hysteresis, FR-12. That task/module isn't
 * written yet in this project, so the lamp is held OFF here rather than
 * guessing a value. Replace this with a real LIGHT_LampsOn() call once the
 * light-sensor task exists - do not leave it hardcoded in the final build. */
#define DISPLAY_LAMPS_ON_PLACEHOLDER   0u

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
    (void)LED_Update(Local_u8Map, DISPLAY_LAMPS_ON_PLACEHOLDER);

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

/* "IN:---  OUT:---" - PLACEHOLDER. §19/FR-03 want the live lane phase here
 * (e.g. "IN:OPEN  OUT:IDLE"), but that needs LANE_GetStateName() from
 * lane_fsm.c, which doesn't exist in this project yet. Replace this whole
 * function once lane_fsm.c exposes per-lane state - do not ship this dashed
 * placeholder in the final build, TC-36/demo will show it as static text. */
static void DISPLAY_PaintLine2(void)
{
    (void)LCD_Paint(1u, "IN:---  OUT:---");
}