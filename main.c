/* ============================================================================
 * main.c - INTEGRATION TEST BUILD, not the final firmware.
 *
 * What's wired in:
 *   slots -> lot_fsm -> display_task (LEDs + 7-seg + LCD)
 *   ticketing, triggered manually (see below) instead of through lane_fsm
 *
 * What's deliberately LEFT OUT, and why:
 *   - lane_fsm.c / g_entryLane / g_exitLane: lane_fsm.c calls
 *     BIL_OnExitAuthorized(), which doesn't exist yet (billing.c not written).
 *     Linking lane_fsm.c into this build would fail at link time with an
 *     undefined reference. Once billing.c exists, replace the manual
 *     "simulate entry" button below with real LANE_Run(&g_entryLane) /
 *     LANE_Run(&g_exitLane) calls reading the two loop potentiometers.
 *   - Timer0 CTC ISR (timer.c / MCAL): not written yet. SCHED_Tick() is
 *     instead driven by a _delay_ms(10) busy loop below. THIS VIOLATES
 *     NFR-02 and must be replaced with a real 10 ms Timer0 COMPA interrupt
 *     before this counts as the real firmware - it is here only so the
 *     scheduler has *something* calling it for this test.
 *   - buttons.c (debounced edge detection module): not written yet. The
 *     maintenance button is read and debounced inline, below, as a stand-in.
 * ==========================================================================*/

#include "config.h"
#include "STD_TYPES.h"

#include "scheduler.h"

#include "HAL/slots/slots.h"
#include "HAL/slotleds/slotleds.h"
#include "HAL/7seg/7seg.h"
#include "HAL/lcd/lcd_i2c.h"
#include "MCAL/dio/dio_interface.h"

#include "APP/lot/lot_fsm.h"
#include "APP/display/display_task.h"
#include "APP/ticketing/ticketing.h"

#include "softrtc.h"
#include "usart_interface.h"

#include <avr/interrupt.h>
#include <util/delay.h>

/* ---- TEMPORARY: manual "simulate a car entering" trigger --------------
 * Stands in for the entry lane until lane_fsm.c can link (needs billing.c).
 * Wired to the maintenance button (PD3) purely because it's already on the
 * canvas and free right now - NOT its real function. Replace/remove this
 * whole block once lane_fsm is integrated; the maintenance button's real
 * job is LOT_SetMaintenance(), not issuing tickets. -----------------------*/
#define TEST_TRIGGER_PORT   BTN_PORT
#define TEST_TRIGGER_PIN    BTN_MAINTENANCE_PIN
#define TEST_DEBOUNCE_TICKS 3u

static void TEST_PollManualTicketTrigger(void);
static void TASK_SlotsWrapper(void);

int main(void)
{
    /* ---- HAL / APP init, in dependency order ---- */
    (void)SLOT_Init();
    (void)LED_Init();          /* also calls SR_Init() internally */
    (void)SEG_Init();
    (void)LCD_Init();

    LOT_Init();
    (void)DISPLAY_Init();
    TKT_Init();

    (void)USART_Init();

    (void)DIO_Init(TEST_TRIGGER_PORT, TEST_TRIGGER_PIN, DIO_INPUT_PULLUP);

    /* ---- Scheduler ---- */
    (void)SCHED_Init();
    (void)SCHED_RegisterTask(TASK_SlotsWrapper, TASK_SLOTS_PERIOD, 0u);
    (void)SCHED_RegisterTask(LOT_Run,           1u,                1u);
    (void)SCHED_RegisterTask(DISPLAY_Task,      25u,               5u);
    (void)SCHED_RegisterTask(RTC_Tick10ms,      1u,                2u);

    sei();

    (void)USART_SendString((const uint8 *)"!EVT,BOOT\r\n");

    for (;;)
    {
        /* TEMPORARY tick source - see file header. Replace with Timer0. */
        _delay_ms(SYSTEM_TICK_MS);
        SCHED_Tick();

        TEST_PollManualTicketTrigger();
    }
}

/* SLOT_Poll returns STD_ReturnType; SCHED_TaskFunc is void(*)(void). */
static void TASK_SlotsWrapper(void)
{
    (void)SLOT_Poll();
}

/* Falling-edge, debounced over TEST_DEBOUNCE_TICKS consecutive LOW reads.
 * Fires TKT_OnEntryAuthorized() once per press - not gated on LOT_
 * CanAuthoriseEntry() at all, since this is exercising the ticket table and
 * UART frame in isolation, not the real authorisation path. */
static void TEST_PollManualTicketTrigger(void)
{
    static uint8 Local_u8LowCount = 0u;
    static uint8 Local_u8Armed    = 1u;   /* prevents re-fire while held */
    uint8 Local_u8Level = DIO_HIGH;

    (void)DIO_ReadPin(TEST_TRIGGER_PORT, TEST_TRIGGER_PIN, &Local_u8Level);

    if (Local_u8Level == DIO_LOW)
    {
        if (Local_u8LowCount < TEST_DEBOUNCE_TICKS)
        {
            Local_u8LowCount++;
        }

        if ((Local_u8LowCount >= TEST_DEBOUNCE_TICKS) && (Local_u8Armed != 0u))
        {
            TKT_OnEntryAuthorized();
            Local_u8Armed = 0u;   /* one ticket per press, not per tick */
        }
    }
    else
    {
        Local_u8LowCount = 0u;
        Local_u8Armed    = 1u;
    }
}