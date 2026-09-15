#include "lane_fsm.h"

#include "HAL/barrier/barrier.h"
#include "HAL/buzzer/buzzer.h"

#define BUZ_PIN              7u

#define GATE_TRAVEL_TICKS   100u
#define GATE_HOLD_TICKS     500u
#define PASS_TIMEOUT_TICKS 2000u
#define REJECT_TICKS        200u

Lane_t g_entryLane;
Lane_t g_exitLane;

extern uint8 LOT_CanAuthoriseEntry(void);
extern void  TKT_OnEntryAuthorized(void);
extern void  BIL_OnExitAuthorized(void);

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry)
{
    ln->state = LN_IDLE;
    ln->timerTicks = 0u;
    ln->loopActive = 0u;
    ln->servoCh = servoCh;
    ln->isEntry = isEntry;
    ln->passCount = 0u;
    ln->faultFlag = 0u;

    BAR_Close(ln->servoCh);
}

void LANE_Run(Lane_t *ln)
{
    switch (ln->state)
    {
        case LN_IDLE:

            if (ln->loopActive)
            {
                ln->timerTicks = 20u;
                ln->state = LN_VEHICLE_WAIT;
            }

            break;


        case LN_VEHICLE_WAIT:

            if (!ln->loopActive)
            {
                ln->state = LN_IDLE;
            }
            else if (--ln->timerTicks == 0u)
            {
                ln->state = LN_AUTHORISING;
            }

            break;


        case LN_AUTHORISING:

            if (ln->isEntry)
            {
                if (LOT_CanAuthoriseEntry())
                {
                    TKT_OnEntryAuthorized();

                    BAR_Open(ln->servoCh);

                    ln->timerTicks = GATE_TRAVEL_TICKS;
                    ln->state = LN_GATE_OPENING;
                }
                else
                {
                    BUZ_On(BUZ_PIN);

                    ln->timerTicks = REJECT_TICKS;
                    ln->state = LN_REJECTED;
                }
            }
            else
            {
                BIL_OnExitAuthorized();

                BAR_Open(ln->servoCh);

                ln->timerTicks = GATE_TRAVEL_TICKS;
                ln->state = LN_GATE_OPENING;
            }

            break;


        case LN_REJECTED:

            if (--ln->timerTicks == 0u)
            {
                BUZ_Off(BUZ_PIN);
                ln->state = LN_IDLE;
            }

            break;


        case LN_GATE_OPENING:

            if (--ln->timerTicks == 0u)
            {
                ln->timerTicks = GATE_HOLD_TICKS;
                ln->state = LN_GATE_OPEN;
            }

            break;


      case LN_GATE_OPEN:
         if (ln->loopActive)
        {
          ln->timerTicks = PASS_TIMEOUT_TICKS;
          ln->state = LN_VEHICLE_PASSING;
        }
       else
       {
          /* loop already clear -- close now, don't wait for the hold */
          BAR_Close(ln->servoCh);
          ln->timerTicks = GATE_TRAVEL_TICKS;
          ln->state = LN_GATE_CLOSING;
       }
        break;


        case LN_VEHICLE_PASSING:

            if (!ln->loopActive)
            {
                ln->passCount++;

                BAR_Close(ln->servoCh);

                ln->timerTicks = GATE_TRAVEL_TICKS;
                ln->state = LN_GATE_CLOSING;
            }
            else if (--ln->timerTicks == 0u)
            {
                ln->faultFlag = 1u;

                BAR_Close(ln->servoCh);

                BUZ_Beep(BUZ_PIN, 3u, 100u);

                ln->state = LN_TIMEOUT;
            }

            break;


        case LN_GATE_CLOSING:

            if (--ln->timerTicks == 0u)
            {
                ln->state = LN_IDLE;
            }

            break;


        case LN_TIMEOUT:

            if (!ln->loopActive)
            {
                ln->faultFlag = 0u;
                ln->state = LN_IDLE;
            }

            break;


        default:

            ln->state = LN_IDLE;
            break;
    }
}


void LANE_RequestOpen(Lane_t *ln, uint8 Copy_u8LoopActive)
{
    ln->loopActive = Copy_u8LoopActive;
}

LaneState_t LANE_GetState(const Lane_t *ln)
{
    return ln->state;
}