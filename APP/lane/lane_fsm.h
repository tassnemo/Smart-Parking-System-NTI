#ifndef LANE_FSM_H_
#define LANE_FSM_H_

#include "../LIB/STD_TYPES.h"

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
    uint16      timerTicks;
    uint8       loopActive;
    uint8       servoCh;
    uint8       isEntry;
    uint16      passCount;
    uint8       faultFlag;
} Lane_t;

extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry);
void LANE_Run(Lane_t *ln);
void LANE_RequestOpen(Lane_t *ln, uint8 Copy_u8LoopActive);
LaneState_t LANE_GetState(const Lane_t *ln);

#endif /* LANE_FSM_H_ */