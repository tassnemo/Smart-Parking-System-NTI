#ifndef SLOTS_H
#define SLOTS_H

#include "LIB/STD_TYPES.h"

STD_ReturnType SLOT_Init(void);
STD_ReturnType SLOT_Poll(void);
uint8 SLOT_CountFree(uint8 Copy_u8SlotMap);
uint8 SLOT_IsOccupied(uint8 Copy_u8SlotMap, uint8 Copy_u8Index);
uint8 SLOT_GetMap(void);

#endif