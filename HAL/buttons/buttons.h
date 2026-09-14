#ifndef BUTTONS_H
#define BUTTONS_H

#include "LIB/STD_TYPES.h"

typedef enum
{
    BTN_RELEASED = 0u,
    BTN_PRESSED  = 1u
} BTN_StateType;


typedef struct
{
    uint8 pin;
    uint8 activeLevel;  /* 1 for active-high, 0 for active-low */
    uint8 initialized;
    uint8 port;
    BTN_StateType rawState;
    BTN_StateType debouncedState;

    uint8 counter;
} BTN_ConfigType;

STD_ReturnType BTN_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8ActiveLevel);
STD_ReturnType BTN_Update(void);
BTN_StateType BTN_GetState(uint8 Copy_u8Pin);
uint8 BTN_IsPressed(uint8 Copy_u8Pin);

#endif