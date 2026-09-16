#ifndef DISPLAY_TASK_H
#define DISPLAY_TASK_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * Task_Display (§19): period 25 ticks (250 ms), offset 5.
 *
 * Reads the lot's published state (LOT_GetMap / LOT_GetFree / LOT_GetOccupied)
 * and drives the three visual outputs from it:
 *      - slot LEDs + lot lamp   (HAL/slotleds  -> the 4094 chain)
 *      - free-slot digit        (HAL/seg7      -> the 4511 decoder)
 *      - LCD line 1 / line 2    (HAL/lcd       -> the AiP31068)
 *
 * This task OWNS the display refresh rate; it does not own slot polling
 * (Task_Slots / slots.c) or lot-mode decisions (Task_LotFSM / lot_fsm.c) -
 * it only reads their published outputs, per §9.4's snapshot rule.
 * --------------------------------------------------------------------------*/

/* Call once at boot, after SLOT_Init/LED_Init/SEG_Init/LCD_Init/LOT_Init. */
STD_ReturnType DISPLAY_Init(void);

/* Register with the scheduler: period 25 ticks, offset 5 (see main.c). */
void DISPLAY_Task(void);

#endif /* DISPLAY_TASK_H */