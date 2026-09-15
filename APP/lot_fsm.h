#ifndef LOT_FSM_H_
#define LOT_FSM_H_

#include "../LIB/STD_TYPES.h"

typedef enum {
    LOT_INIT = 0,
    LOT_OPERATIONAL,
    LOT_FULL,
    LOT_MAINTENANCE,
    LOT_FAULT
} LotState_t;

void LOT_Init(void);
void LOT_Run(void);
uint8 LOT_GetFree(void);
uint8 LOT_CanAuthoriseEntry(void);
LotState_t LOT_GetState(void);

#endif /* LOT_FSM_H_ */