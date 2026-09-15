#ifndef BARRIER_H
#define BARRIER_H

#include "LIB/STD_TYPES.h"

STD_ReturnType BAR_Init(uint8 Copy_u8Channel);
STD_ReturnType BAR_Open(uint8 Copy_u8Channel);
STD_ReturnType BAR_Close(uint8 Copy_u8Channel);
STD_ReturnType BAR_IsMoving(uint8 Copy_u8Channel, uint8 *Copy_pu8Status);

#endif