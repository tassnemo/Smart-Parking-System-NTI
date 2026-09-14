#ifndef EXTI_INTERFACE_H
#define EXTI_INTERFACE_H

#include "STD_TYPES.h"

#define EXTI_INT0 0u
#define EXTI_INT1 1u
#define EXTI_INT2 2u

#define EXTI_LOW_LEVEL     0u
#define EXTI_ANY_CHANGE    1u
#define EXTI_FALLING_EDGE  2u
#define EXTI_RISING_EDGE   3u

typedef void (*EXTI_CallbackType)(void);

STD_ReturnType EXTI_Init(void);
STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense);
STD_ReturnType EXTI_Enable(uint8 Copy_u8Int);
STD_ReturnType EXTI_Disable(uint8 Copy_u8Int);
STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int);
STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback);

#endif