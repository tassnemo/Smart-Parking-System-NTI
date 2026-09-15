#ifndef BUZZER_H
#define BUZZER_H

#include "LIB/STD_TYPES.h"

STD_ReturnType BUZ_Init(uint8 Copy_u8Pin);
STD_ReturnType BUZ_On(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Off(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Beep(uint8 Copy_u8Pin,
                        uint8 Copy_u8Times,
                        uint16 Copy_u16Ms);

STD_ReturnType BUZ_Update(void);

#endif