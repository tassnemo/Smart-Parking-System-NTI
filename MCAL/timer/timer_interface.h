#ifndef TIMER_INTERFACE_H
#define TIMER_INTERFACE_H

#include "STD_TYPES.h"

typedef void (*TMR0_CallbackType)(void);

STD_ReturnType TMR0_InitCTC(void);
STD_ReturnType TMR0_Start(void);
STD_ReturnType TMR0_Stop(void);
STD_ReturnType TMR0_SetCompare(uint8 Copy_u8Value);
STD_ReturnType TMR0_SetCallback(TMR0_CallbackType Copy_pfCallback);

#endif