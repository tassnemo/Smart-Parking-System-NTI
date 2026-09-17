#ifndef LIGHT_H
#define LIGHT_H

#include "STD_TYPES.h"

STD_ReturnType LIGHT_Init(void);
STD_ReturnType LIGHT_Run(void);
uint8 LIGHT_GetState(void);

#endif /* LIGHT_H */