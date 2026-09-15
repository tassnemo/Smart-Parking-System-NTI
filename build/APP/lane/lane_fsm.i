# 0 "APP/lane/lane_fsm.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/lane/lane_fsm.c"
# 1 "APP/lane/lane_fsm.h" 1



# 1 "APP/../LIB/STD_TYPES.h" 1



typedef unsigned char uint8;
typedef signed char sint8;
typedef unsigned short uint16;
typedef signed short sint16;
typedef unsigned long uint32;
typedef signed long sint32;
typedef unsigned long long uint64;
typedef signed long long sint64;

typedef float float32;
typedef double float64;
# 23 "APP/../LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 5 "APP/lane/lane_fsm.h" 2

typedef enum {
    LN_IDLE = 0,
    LN_VEHICLE_WAIT,
    LN_AUTHORISING,
    LN_GATE_OPENING,
    LN_GATE_OPEN,
    LN_VEHICLE_PASSING,
    LN_GATE_CLOSING,
    LN_REJECTED,
    LN_TIMEOUT
} LaneState_t;

typedef struct {
    LaneState_t state;
    uint16 timerTicks;
    uint8 loopActive;
    uint8 servoCh;
    uint8 isEntry;
    uint16 passCount;
    uint8 faultFlag;
} Lane_t;

extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry);
void LANE_Run(Lane_t *ln);
# 2 "APP/lane/lane_fsm.c" 2

extern void BAR_Open(uint8 Copy_u8Channel);
extern void BAR_Close(uint8 Copy_u8Channel);
extern void BUZ_On(void);
extern void BUZ_Off(void);
extern void BUZ_Beep(uint8 Copy_u8Count, uint16 Copy_u16DelayMs);






Lane_t g_entryLane;
Lane_t g_exitLane;

extern uint8 LOT_CanAuthoriseEntry(void);
extern void TKT_OnEntryAuthorized(void);
extern void BIL_OnExitAuthorized(void);

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
                    ln->timerTicks = 100u;
                    ln->state = LN_GATE_OPENING;
                } else {
                    BUZ_On();
                    ln->timerTicks = 200u;
                    ln->state = LN_REJECTED;
                }
            } else {
                BIL_OnExitAuthorized();
                BAR_Open(ln->servoCh);
                ln->timerTicks = 100u;
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
                ln->timerTicks = 500u;
                ln->state = LN_GATE_OPEN;
            }
            break;

        case LN_GATE_OPEN:
            if (ln->loopActive) {
                ln->timerTicks = 2000u;
                ln->state = LN_VEHICLE_PASSING;
            } else if (--ln->timerTicks == 0) {
                BAR_Close(ln->servoCh);
                ln->timerTicks = 100u;
                ln->state = LN_GATE_CLOSING;
            }
            break;

        case LN_VEHICLE_PASSING:
            if (!ln->loopActive) {
                ln->passCount++;
                BAR_Close(ln->servoCh);
                ln->timerTicks = 100u;
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
