#include "lane_fsm.h"
/* دوال التحكم في البوابات والبزر من طبقة الـ HAL */
extern void BAR_Open(uint8 Copy_u8Channel);
extern void BAR_Close(uint8 Copy_u8Channel);
extern void BUZ_On(void);
extern void BUZ_Off(void);
extern void BUZ_Beep(uint8 Copy_u8Count, uint16 Copy_u16DelayMs);

#define GATE_TRAVEL_TICKS   100u
#define GATE_HOLD_TICKS     500u
#define PASS_TIMEOUT_TICKS 2000u
#define REJECT_TICKS        200u

Lane_t g_entryLane;
Lane_t g_exitLane;

extern uint8 LOT_CanAuthoriseEntry(void);
extern void  TKT_OnEntryAuthorized(void);
extern void  BIL_OnExitAuthorized(void);

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry) {
    ln->state = LN_IDLE;
    ln->timerTicks = 0;
    ln->loopActive = 0;
    ln->servoCh = servoCh;
    ln->isEntry = isEntry;
    ln->passCount = 0;
    ln->faultFlag = 0;
    BAR_Close(ln->servoCh);
}

void LANE_Run(Lane_t *ln) {
    switch (ln->state) {
        case LN_IDLE:
            if (ln->loopActive) {
                ln->timerTicks = 20u;
                ln->state = LN_VEHICLE_WAIT;
            }
            break;

        case LN_VEHICLE_WAIT:
            if (!ln->loopActive) {
                ln->state = LN_IDLE;
            } else if (--ln->timerTicks == 0) {
                ln->state = LN_AUTHORISING;
            }
            break;

        case LN_AUTHORISING:
            if (ln->isEntry) {
                if (LOT_CanAuthoriseEntry()) {
                    TKT_OnEntryAuthorized();
                    BAR_Open(ln->servoCh);
                    ln->timerTicks = GATE_TRAVEL_TICKS;
                    ln->state = LN_GATE_OPENING;
                } else {
                    BUZ_On();
                    ln->timerTicks = REJECT_TICKS;
                    ln->state = LN_REJECTED;
                }
            } else {
                BIL_OnExitAuthorized();
                BAR_Open(ln->servoCh);
                ln->timerTicks = GATE_TRAVEL_TICKS;
                ln->state = LN_GATE_OPENING;
            }
            break;

        case LN_REJECTED:
            if (--ln->timerTicks == 0) {
                BUZ_Off();
                ln->state = LN_IDLE;
            }
            break;

        case LN_GATE_OPENING:
            if (--ln->timerTicks == 0) {
                ln->timerTicks = GATE_HOLD_TICKS;
                ln->state = LN_GATE_OPEN;
            }
            break;

        case LN_GATE_OPEN:
            if (ln->loopActive) {
                ln->timerTicks = PASS_TIMEOUT_TICKS;
                ln->state = LN_VEHICLE_PASSING;
            } else if (--ln->timerTicks == 0) {
                BAR_Close(ln->servoCh);
                ln->timerTicks = GATE_TRAVEL_TICKS;
                ln->state = LN_GATE_CLOSING;
            }
            break;

        case LN_VEHICLE_PASSING:
            if (!ln->loopActive) {
                ln->passCount++;
                BAR_Close(ln->servoCh);
                ln->timerTicks = GATE_TRAVEL_TICKS;
                ln->state = LN_GATE_CLOSING;
            } else if (--ln->timerTicks == 0) {
                ln->faultFlag = 1;
                BAR_Close(ln->servoCh);
                BUZ_Beep(3, 100);
                ln->state = LN_TIMEOUT;
            }
            break;

        case LN_GATE_CLOSING:
            if (--ln->timerTicks == 0) {
                ln->state = LN_IDLE;
            }
            break;

        case LN_TIMEOUT:
            if (!ln->loopActive) {
                ln->faultFlag = 0;
                ln->state = LN_IDLE;
            }
            break;
    }
}