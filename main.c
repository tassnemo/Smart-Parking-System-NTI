/*******************************************************************************
 * PRJ-02-PARKING  --  Smart Parking System
 * File        : main.c
 * Target      : ATmega32A @ 8 MHz, SimulIDE 1.x
 *
 * Responsibilities of this file ONLY:
 *   1. Disable JTAG so PC2..PC7 work as slot-sensor inputs (see §7 note).
 *   2. Bring up MCAL -> HAL -> APP in a fixed, checked order.
 *   3. Register the nine tasks of §19 with the cooperative scheduler.
 *   4. Run the non-blocking super-loop: wait for the 10 ms tick flag set by
 *      the Timer0 ISR callback, then dispatch. Nothing here ever blocks.
 *   5. Own the few cross-module glue behaviours that belong to no single
 *      module: maintenance mode, the FULL sign, the console line assembler,
 *      the FR-14 consistency check and the !EVT event stream.
 *
 * NFR-02: no _delay_ms anywhere in this file.
 * NFR-16/17: no dynamic memory, no recursion. Worst-case call depth from the
 *            super-loop is 5 (main -> SCHED_Tick -> Task_Display ->
 *            DISPLAY_Task -> LCD_Paint -> LCD_SendRun).
 ******************************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/atomic.h>

#include "STD_TYPES.h"
#include "config.h"

/* ---- LIB ---- */
#include "scheduler.h"
#include "softrtc.h"

/* ---- MCAL ---- */
#include "MCAL/dio/dio_interface.h"
#include "MCAL/adc/ADC_interface.h"
#include "MCAL/timer/timer_interface.h"
#include "MCAL/pwm/pwm_interface.h"
#include "MCAL/usart/usart_interface.h"

/* ---- HAL ---- */
#include "HAL/slots/slots.h"
#include "HAL/barrier/barrier.h"
#include "HAL/7seg/7seg.h"
#include "HAL/lcd/lcd_i2c.h"
#include "HAL/slotleds/slotleds.h"
#include "HAL/buttons/buttons.h"
#include "HAL/buzzer/buzzer.h"

/* ---- APP ---- */
#include "APP/lot/lot_fsm.h"
#include "APP/lane/lane_fsm.h"
#include "APP/loopsense/loopsense.h"
#include "APP/ticketing/ticketing.h"
#include "APP/billing/billing.h"
#include "APP/light/light.h"
#include "APP/display/display_task.h"
#include "APP/telemetry/telemetry.h"
#include "APP/console/console.h"

/* =============================================================================
 * Local configuration (keep the numbers here, not sprinkled in the code).
 * Periods are in 10 ms scheduler ticks and mirror §19 exactly.
 * ===========================================================================*/
#define MAIN_TICKS_10MS          1u
#define MAIN_TICKS_20MS          2u
#define MAIN_TICKS_50MS          5u
#define MAIN_TICKS_250MS        25u
#define MAIN_TICKS_1S          100u
#define MAIN_TICKS_5S          500u

#define MAIN_OFF_LANES           0u
#define MAIN_OFF_BUTTONS         0u
#define MAIN_OFF_LOT             1u
#define MAIN_OFF_SLOTS           2u
#define MAIN_OFF_LOOPS           3u
#define MAIN_OFF_CONSOLE         4u
#define MAIN_OFF_DISPLAY         5u
#define MAIN_OFF_1HZ             7u
#define MAIN_OFF_REPORT         11u

/* Pins owned by main (signs only -- everything else lives in a HAL module). */
#define MAIN_FULLSIGN_PORT      DIO_PORTD
#define MAIN_FULLSIGN_PIN       6u

/* Polled, debounced buttons (INT0/INT1 edges are not used -- polling at 10 ms
 * with buttons.c's 5-sample debounce is both simpler and ISR-rule friendly). */
#define MAIN_BTN_EXIT_PIN       2u      /* PD2 */
#define MAIN_BTN_MAINT_PIN      3u      /* PD3 */

#define MAIN_BUZZER_PIN         7u      /* PD7 / OC2 -- the only tone-capable pin */

/* A press of the exit-request button emulates a vehicle sitting on the exit
 * loop for this long, so the normal lane FSM path runs unchanged (FR-09). */
#define MAIN_EXIT_BTN_HOLD_TICKS  300u  /* 3 s */

/* FR-14: mismatch must persist longer than this before it is reported. */
#define MAIN_MISMATCH_LIMIT_SEC   30u

/* Console line assembly (§18.2: <= 24 chars, CR / LF / CRLF all accepted). */
#define MAIN_LINE_BUF_SIZE      (CONSOLE_MAX_LINE + 2u)

/* =============================================================================
 * Module-scope state
 * ===========================================================================*/
static volatile uint8 g_u8TickFlag     = 0u;   /* set by the Timer0 callback  */
static volatile uint8 g_u8TickOverrun  = 0u;   /* a tick arrived while busy   */
static uint16         g_u16OverrunCnt  = 0u;   /* reported by !EVT,SCHED,OVR  */

/* The two lane instances (declared in lane_fsm.c, used by telemetry.c). */
extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

/* One loop-sensor conditioner per lane. */
static LoopSense_t g_entryLoop;
static LoopSense_t g_exitLoop;

/* Edge/latch bookkeeping for the glue logic. */
static uint8  g_u8PrevMaintBtn   = 0u;
static uint16 g_u16ExitBtnHold   = 0u;
static uint8  g_u8PrevFullSign   = 0xFFu;      /* force first evaluation      */
static LotState_t g_PrevLotState = LOT_INIT;
static LaneState_t g_PrevEntryState = LN_IDLE;
static LaneState_t g_PrevExitState  = LN_IDLE;
static uint8  g_u8InMaintenance  = 0u;

/* FR-14 consistency check. */
static uint8  g_u8MismatchSec    = 0u;
static uint8  g_u8MismatchLogged = 0u;

/* Console line assembler. */
static char   g_acLine[MAIN_LINE_BUF_SIZE];
static uint8  g_u8LinePos        = 0u;
static uint8  g_u8LineOverflow   = 0u;

/* =============================================================================
 * Small helpers (no sprintf -- matches telemetry.c / billing.c house style)
 * ===========================================================================*/
static void MAIN_Send(const char *Copy_pcStr)
{
    (void)USART_SendString((const uint8 *)Copy_pcStr);
}

static void MAIN_SendUint16(uint16 Copy_u16Value)
{
    char  Local_acTmp[6];
    uint8 Local_u8Count = 0u;
    uint8 Local_u8i;

    if (Copy_u16Value == 0u)
    {
        (void)USART_SendByte((uint8)'0');
        return;
    }

    while (Copy_u16Value > 0u)
    {
        Local_acTmp[Local_u8Count] = (char)('0' + (Copy_u16Value % 10u));
        Local_u8Count++;
        Copy_u16Value = (uint16)(Copy_u16Value / 10u);
    }

    for (Local_u8i = Local_u8Count; Local_u8i > 0u; Local_u8i--)
    {
        (void)USART_SendByte((uint8)Local_acTmp[Local_u8i - 1u]);
    }
}

/* §18.4 asynchronous event, e.g. MAIN_SendEvent("LOT,FULL") -> "!EVT,LOT,FULL" */
static void MAIN_SendEvent(const char *Copy_pcBody)
{
    MAIN_Send("!EVT,");
    MAIN_Send(Copy_pcBody);
    MAIN_Send("\r\n");
}

/* Zero-padded 4-digit ticket id, same style as ticketing.c/billing.c. */
static void MAIN_SendId(uint16 Copy_u16Id)
{
    (void)USART_SendByte((uint8)('0' + (uint8)((Copy_u16Id / 1000u) % 10u)));
    (void)USART_SendByte((uint8)('0' + (uint8)((Copy_u16Id / 100u)  % 10u)));
    (void)USART_SendByte((uint8)('0' + (uint8)((Copy_u16Id / 10u)   % 10u)));
    (void)USART_SendByte((uint8)('0' + (uint8)( Copy_u16Id          % 10u)));
}

/* The id just issued is nextTicketId - 1, with FR-07's 1..9999 wrap undone. */
static uint16 MAIN_LastIssuedId(void)
{
    uint16 Local_u16Next = TKT_GetNextId();

    return (Local_u16Next <= TICKET_ID_FIRST)
         ? (uint16)TICKET_ID_LAST
         : (uint16)(Local_u16Next - 1u);
}

/* JTAG occupies PC2..PC7, which carry the slot sensors. JTD must be written
 * twice within four cycles; this is the one register main.c is allowed to
 * touch, because it is a core-fuse override with no natural MCAL owner. */
static void MAIN_DisableJtag(void)
{
    MCUCSR |= (1u << JTD);
    MCUCSR |= (1u << JTD);
}

/* =============================================================================
 * Timer0 ISR callback -- kept to two statements (NFR-09)
 * ===========================================================================*/
static void MAIN_OnTick(void)
{
    if (g_u8TickFlag != 0u)
    {
        g_u8TickOverrun = 1u;      /* previous tick's work has not finished */
    }

    g_u8TickFlag = 1u;
    RTC_Tick10ms();                /* 100 ticks -> 1 s, LO-4 */
}

/* =============================================================================
 * T-1  Task_Lanes -- 10 ms, the centrepiece (NFR-03: both lanes advance here)
 * ===========================================================================*/
static void Task_Lanes(void)
{
    uint8 Local_u8ExitActive;
    LaneState_t Local_EntryState;
    LaneState_t Local_ExitState;

    /* FR-13 / L14: in maintenance both barriers are held open and the lanes
     * are parked in IDLE. Ticketing and billing are therefore suspended, since
     * neither can be reached without LN_AUTHORISING. */
    if (LOT_GetState() == LOT_MAINTENANCE)
    {
        if (g_u8InMaintenance == 0u)
        {
            g_u8InMaintenance = 1u;

            g_entryLane.state = LN_IDLE;
            g_entryLane.timerTicks = 0u;
            g_entryLane.loopActive = 0u;

            g_exitLane.state = LN_IDLE;
            g_exitLane.timerTicks = 0u;
            g_exitLane.loopActive = 0u;

            (void)BAR_Open(PWM_CH_ENTRY);
            (void)BAR_Open(PWM_CH_EXIT);

            MAIN_SendEvent("MAINT,ON");
        }
        return;
    }

    if (g_u8InMaintenance != 0u)
    {
        g_u8InMaintenance = 0u;

        (void)BAR_Close(PWM_CH_ENTRY);
        (void)BAR_Close(PWM_CH_EXIT);

        MAIN_SendEvent("MAINT,OFF");
    }

    /* Feed both lanes their debounced loop state. loopsense.c already calls
     * LANE_RequestOpen on a confirmed edge; re-asserting the same value here
     * every tick costs nothing and lets the exit lane OR in the push button
     * without either source clobbering the other. */
    LANE_RequestOpen(&g_entryLane, g_entryLoop.confirmedActive);

    Local_u8ExitActive = (uint8)((g_exitLoop.confirmedActive != 0u) ||
                                 (g_u16ExitBtnHold != 0u));
    LANE_RequestOpen(&g_exitLane, Local_u8ExitActive);

    if (g_u16ExitBtnHold != 0u)
    {
        g_u16ExitBtnHold--;
    }

    /* One FSM, two instances (NFR-04). */
    LANE_Run(&g_entryLane);
    LANE_Run(&g_exitLane);

    /* ---- §18.4 events derived from the lane transitions ---- */
    Local_EntryState = LANE_GetState(&g_entryLane);
    Local_ExitState  = LANE_GetState(&g_exitLane);

    if (Local_EntryState != g_PrevEntryState)
    {
        if (Local_EntryState == LN_GATE_OPENING)
        {
            MAIN_Send("!EVT,ENTRY,GRANT,");
            MAIN_SendId(MAIN_LastIssuedId());
            MAIN_Send("\r\n");
        }
        else if (Local_EntryState == LN_REJECTED)
        {
            MAIN_SendEvent("ENTRY,REJECT");
        }
        else if (Local_EntryState == LN_TIMEOUT)
        {
            MAIN_SendEvent("LANE,TIMEOUT,IN");
        }
        else
        {
            /* no event for the remaining transitions */
        }

        g_PrevEntryState = Local_EntryState;
    }

    if (Local_ExitState != g_PrevExitState)
    {
        if (Local_ExitState == LN_TIMEOUT)
        {
            MAIN_SendEvent("LANE,TIMEOUT,OUT");
        }

        g_PrevExitState = Local_ExitState;
    }
}

/* =============================================================================
 * T-2  Task_Buttons -- 10 ms: debounce, edges, buzzer phase machine
 * ===========================================================================*/
static void Task_Buttons(void)
{
    uint8 Local_u8Maint;

    (void)BTN_Update();

    /* Maintenance button: toggle on the press edge only (FR-13). */
    Local_u8Maint = BTN_IsPressed(MAIN_BTN_MAINT_PIN);

    if ((Local_u8Maint != 0u) && (g_u8PrevMaintBtn == 0u))
    {
        LOT_SetMaintenance((uint8)((LOT_GetState() == LOT_MAINTENANCE) ? 0u : 1u));
    }
    g_u8PrevMaintBtn = Local_u8Maint;

    /* Exit request button: arm a virtual loop occupancy so the exit lane runs
     * its normal sequence (FR-09). Re-pressing simply re-arms the hold. */
    if (BTN_IsPressed(MAIN_BTN_EXIT_PIN) != 0u)
    {
        g_u16ExitBtnHold = MAIN_EXIT_BTN_HOLD_TICKS;
    }

    /* Non-blocking beep sequencer -- BUZ_Beep() only arms it (FR-11). */
    (void)BUZ_Update();
}

/* =============================================================================
 * T-3 / T-4  Task_Lot -- 50 ms: slot scan, counts, lot mode, FULL sign
 * LOT_Run() already calls SLOT_Poll() internally, so slots and the lot FSM
 * share one task rather than running twice at two rates.
 * ===========================================================================*/
static void Task_Lot(void)
{
    LotState_t Local_State;
    uint8      Local_u8FullSign;

    LOT_Run();

    Local_State = LOT_GetState();

    /* FR-04: FULL sign follows freeCount, and is forced off in maintenance so
     * the panel does not lie while the barriers are parked open. */
    Local_u8FullSign = (uint8)((LOT_GetFree() == 0u) &&
                               (Local_State != LOT_MAINTENANCE));

    if (Local_u8FullSign != g_u8PrevFullSign)
    {
        (void)DIO_WritePin(MAIN_FULLSIGN_PORT,
                           MAIN_FULLSIGN_PIN,
                           (Local_u8FullSign != 0u) ? DIO_HIGH : DIO_LOW);

        MAIN_SendEvent((Local_u8FullSign != 0u) ? "LOT,FULL" : "LOT,VACANT");

        g_u8PrevFullSign = Local_u8FullSign;
    }

    if (Local_State != g_PrevLotState)
    {
        if (Local_State == LOT_FAULT)
        {
            /* §15 fail-safe: a fault opens both barriers. A barrier stuck down
             * traps vehicles; stuck up only loses revenue. */
            (void)BAR_Open(PWM_CH_ENTRY);
            (void)BAR_Open(PWM_CH_EXIT);
            MAIN_SendEvent("LOT,FAULT");
        }

        g_PrevLotState = Local_State;
    }
}

/* =============================================================================
 * T-5  Task_Loops -- 50 ms: ADC0/ADC1 with the 600/400 hysteresis band (FR-05)
 * ===========================================================================*/
static void Task_Loops(void)
{
    (void)LOOPSENSE_Run(&g_entryLoop);
    (void)LOOPSENSE_Run(&g_exitLoop);
}

/* =============================================================================
 * T-6  Task_Display -- 250 ms: LCD + 7-segment + slot LEDs (FR-03)
 * ===========================================================================*/
static void Task_Display(void)
{
    DISPLAY_Task();
}

/* =============================================================================
 * T-7  Task_1Hz -- lighting (FR-12) and the occupancy/ticket check (FR-14)
 * ===========================================================================*/
static void Task_1Hz(void)
{
    uint8 Local_u8Tickets;
    uint8 Local_u8Occupied;

    (void)LIGHT_Run();

    Local_u8Tickets  = TKT_GetOpenCount();
    Local_u8Occupied = LOT_GetOccupied();

    if (Local_u8Tickets != Local_u8Occupied)
    {
        if (g_u8MismatchSec < 0xFFu)
        {
            g_u8MismatchSec++;
        }

        if ((g_u8MismatchSec > MAIN_MISMATCH_LIMIT_SEC) &&
            (g_u8MismatchLogged == 0u))
        {
            /* A warning, not a fault -- the lot keeps operating. */
            MAIN_Send("!EVT,LOT,MISMATCH,");
            MAIN_SendUint16((uint16)Local_u8Tickets);
            (void)USART_SendByte((uint8)',');
            MAIN_SendUint16((uint16)Local_u8Occupied);
            MAIN_Send("\r\n");

            g_u8MismatchLogged = 1u;
        }
    }
    else
    {
        g_u8MismatchSec    = 0u;
        g_u8MismatchLogged = 0u;
    }

    /* Scheduler health (B5 groundwork): report overruns once per second. */
    if (g_u16OverrunCnt != 0u)
    {
        MAIN_Send("!EVT,SCHED,OVR,");
        MAIN_SendUint16(g_u16OverrunCnt);
        MAIN_Send("\r\n");
        g_u16OverrunCnt = 0u;
    }
}

/* =============================================================================
 * T-8  Task_Report -- 5 s telemetry frame (FR-15, §18.1)
 * ===========================================================================*/
static void Task_Report(void)
{
    (void)TELEM_Send();
}

/* =============================================================================
 * T-9  Task_Console -- 20 ms: drain the RX ring, assemble one line, parse it
 * The ring buffer is filled by the USART RX ISR, so nothing here blocks.
 * ===========================================================================*/
static void Task_Console(void)
{
    uint8 Local_u8Byte;

    while (USART_ReceiveByte(&Local_u8Byte) == E_OK)
    {
        if ((Local_u8Byte == (uint8)'\r') || (Local_u8Byte == (uint8)'\n'))
        {
            if (g_u8LineOverflow != 0u)
            {
                MAIN_Send("ERR LONG\r\n");
            }
            else if (g_u8LinePos > 0u)
            {
                g_acLine[g_u8LinePos] = '\0';
                (void)CONSOLE_ParseLine(g_acLine);
            }
            else
            {
                /* bare CR/LF, or the LF of a CRLF pair: ignore silently */
            }

            g_u8LinePos      = 0u;
            g_u8LineOverflow = 0u;
        }
        else if (g_u8LinePos < CONSOLE_MAX_LINE)
        {
            g_acLine[g_u8LinePos] = (char)Local_u8Byte;
            g_u8LinePos++;
        }
        else
        {
            /* §18.2: over-long lines are rejected, not silently truncated */
            g_u8LineOverflow = 1u;
        }
    }
}

/* =============================================================================
 * Initialisation
 * ===========================================================================*/
static STD_ReturnType MAIN_InitMcal(void)
{
    STD_ReturnType Local_u8Result = E_OK;

    if (ADC_Init(ADC_REF_AVCC, ADC_PRESC_64) != E_OK) { Local_u8Result = E_NOK; }
    if (PWM_Init()                            != E_OK) { Local_u8Result = E_NOK; }
    if (USART_Init()                          != E_OK) { Local_u8Result = E_NOK; }

    /* 10 ms system tick: CTC, prescaler 1024, OCR0 = 77 (§8). */
    if (TMR0_InitCTC()                        != E_OK) { Local_u8Result = E_NOK; }
    if (TMR0_SetCallback(MAIN_OnTick)         != E_OK) { Local_u8Result = E_NOK; }

    /* SPI and I2C are initialised by their HAL owners (LED_Init -> SR_Init,
     * LCD_Init) so the bus is never brought up twice. */

    return Local_u8Result;
}

static STD_ReturnType MAIN_InitHal(void)
{
    STD_ReturnType Local_u8Result = E_OK;

    if (SLOT_Init()                != E_OK) { Local_u8Result = E_NOK; }
    if (SEG_Init()                 != E_OK) { Local_u8Result = E_NOK; }
    if (LED_Init()                 != E_OK) { Local_u8Result = E_NOK; }
    if (LCD_Init()                 != E_OK) { Local_u8Result = E_NOK; }
    if (BUZ_Init(MAIN_BUZZER_PIN)  != E_OK) { Local_u8Result = E_NOK; }

    if (BTN_Init(DIO_PORTD, MAIN_BTN_EXIT_PIN,  DIO_LOW) != E_OK)
    {
        Local_u8Result = E_NOK;
    }
    if (BTN_Init(DIO_PORTD, MAIN_BTN_MAINT_PIN, DIO_LOW) != E_OK)
    {
        Local_u8Result = E_NOK;
    }

    if (BAR_Init(PWM_CH_ENTRY) != E_OK) { Local_u8Result = E_NOK; }
    if (BAR_Init(PWM_CH_EXIT)  != E_OK) { Local_u8Result = E_NOK; }

    /* §16: barriers are driven CLOSED before interrupts are enabled. */
    (void)BAR_Close(PWM_CH_ENTRY);
    (void)BAR_Close(PWM_CH_EXIT);

    /* FULL sign output, off at boot. */
    if (DIO_Init(MAIN_FULLSIGN_PORT, MAIN_FULLSIGN_PIN, DIO_OUTPUT) != E_OK)
    {
        Local_u8Result = E_NOK;
    }
    (void)DIO_WritePin(MAIN_FULLSIGN_PORT, MAIN_FULLSIGN_PIN, DIO_LOW);

    return Local_u8Result;
}

static STD_ReturnType MAIN_InitApp(void)
{
    STD_ReturnType Local_u8Result = E_OK;

    LOT_Init();
    TKT_Init();

    if (LIGHT_Init()   != E_OK) { Local_u8Result = E_NOK; }
    if (CONSOLE_Init() != E_OK) { Local_u8Result = E_NOK; }
    if (DISPLAY_Init() != E_OK) { Local_u8Result = E_NOK; }

    /* One type, two instances -- NFR-04. */
    LANE_Init(&g_entryLane, PWM_CH_ENTRY, 1u);
    LANE_Init(&g_exitLane,  PWM_CH_EXIT,  0u);

    if (LOOPSENSE_Init(&g_entryLoop, ADC_CHANNEL_0, &g_entryLane) != E_OK)
    {
        Local_u8Result = E_NOK;
    }
    if (LOOPSENSE_Init(&g_exitLoop, ADC_CHANNEL_1, &g_exitLane) != E_OK)
    {
        Local_u8Result = E_NOK;
    }

    return Local_u8Result;
}

static STD_ReturnType MAIN_InitScheduler(void)
{
    STD_ReturnType Local_u8Result = E_OK;

    if (SCHED_Init() != E_OK) { return E_NOK; }

    if (SCHED_RegisterTask(Task_Lanes,   MAIN_TICKS_10MS,  MAIN_OFF_LANES)   != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_Buttons, MAIN_TICKS_10MS,  MAIN_OFF_BUTTONS) != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_Lot,     MAIN_TICKS_50MS,  MAIN_OFF_LOT)     != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_Loops,   MAIN_TICKS_50MS,  MAIN_OFF_LOOPS)   != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_Console, MAIN_TICKS_20MS,  MAIN_OFF_CONSOLE) != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_Display, MAIN_TICKS_250MS, MAIN_OFF_DISPLAY) != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_1Hz,     MAIN_TICKS_1S,    MAIN_OFF_1HZ)     != E_OK) { Local_u8Result = E_NOK; }
    if (SCHED_RegisterTask(Task_Report,  MAIN_TICKS_5S,    MAIN_OFF_REPORT)  != E_OK) { Local_u8Result = E_NOK; }

    return Local_u8Result;
}

/* =============================================================================
 * Entry point
 * ===========================================================================*/
int main(void)
{
    uint8 Local_u8ResetCause = MCUCSR;
     MCUCSR = 0u;   /* clear it for next time */
    STD_ReturnType Local_u8InitResult = E_OK;
    uint8          Local_u8Tick;

    /* PC2..PC7 are the slot sensors -- JTAG must go first of all. */
    MAIN_DisableJtag();

    if (MAIN_InitMcal()      != E_OK) { Local_u8InitResult = E_NOK; }
    if (MAIN_InitHal()       != E_OK) { Local_u8InitResult = E_NOK; }
    if (MAIN_InitApp()       != E_OK) { Local_u8InitResult = E_NOK; }
    if (MAIN_InitScheduler() != E_OK) { Local_u8InitResult = E_NOK; }

    /* Splash + first counts before the tick starts, so boot-to-first-frame
     * stays well inside FR-17's 500 ms. */
    (void)LCD_Paint(0u, "SMART PARKING   ");
    (void)LCD_Paint(1u, "BOOTING...      ");

    LOT_Run();                      /* prime slotMap / freeCount / occupied   */
    DISPLAY_Task();                 /* first real LCD + 7-seg + LED frame     */

    (void)TMR0_Start();
    sei();
    MAIN_Send("!EVT,BOOT,CAUSE=");
    MAIN_SendUint16((uint16)Local_u8ResetCause);
    MAIN_Send("\r\n");

    MAIN_SendEvent("BOOT");

    /* There is no EEPROM in this build (see the README note on saving), so the
     * configuration is always the compiled-in default -- report it as such
     * rather than pretending a stored image was validated (FR-17/TC-01). */
    MAIN_SendEvent("CFG,DEFAULT");

    if (Local_u8InitResult != E_OK)
    {
        /* Something refused to come up. Fail safe: barriers open, lot in
         * FAULT, but the console and telemetry stay alive for diagnosis. */
        LOT_SetFault(1u);
        MAIN_SendEvent("LOT,FAULT,INIT");
    }

    /* ---------------- super-loop: dispatch, never block (NFR-02) ---------- */
    for (;;)
    {
        ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
        {
            Local_u8Tick = g_u8TickFlag;
            g_u8TickFlag = 0u;

            if (g_u8TickOverrun != 0u)
            {
                g_u8TickOverrun = 0u;
                if (g_u16OverrunCnt < 0xFFFFu)
                {
                    g_u16OverrunCnt++;
                }
            }
        }

        if (Local_u8Tick != 0u)
        {
            SCHED_Tick();           /* runs every task whose period is due */
        }

        /* Idle here. Nothing else runs outside the tick -- that is what keeps
         * both lanes genuinely concurrent on one CPU with no RTOS. */
    }

    return 0;                       /* never reached */
}