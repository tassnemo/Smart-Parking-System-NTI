# 0 "HAL/buttons/buttons.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/buttons/buttons.c"
# 1 "HAL/buttons/buttons.h" 1



# 1 "./LIB/STD_TYPES.h" 1



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
# 23 "./LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 5 "HAL/buttons/buttons.h" 2

typedef enum
{
    BTN_RELEASED = 0u,
    BTN_PRESSED = 1u
} BTN_StateType;


typedef struct
{
    uint8 pin;
    uint8 activeLevel;
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
# 2 "HAL/buttons/buttons.c" 2
# 1 "./MCAL/dio/dio_interface.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "./MCAL/dio/dio_interface.h" 2
# 27 "./MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 3 "HAL/buttons/buttons.c" 2




static BTN_ConfigType g_btns[8u];

STD_ReturnType BTN_Init(uint8 Copy_u8Port,
                        uint8 Copy_u8Pin,
                        uint8 Copy_u8ActiveLevel)
{
    if (Copy_u8Pin >= 8u)
    {
        return 1u;
    }
    if (DIO_Init(Copy_u8Port, Copy_u8Pin, 2u) != 0u)
{
    return 1u;
}

    g_btns[Copy_u8Pin].port = Copy_u8Port;
    g_btns[Copy_u8Pin].pin = Copy_u8Pin;
    g_btns[Copy_u8Pin].activeLevel = Copy_u8ActiveLevel;
    g_btns[Copy_u8Pin].rawState = BTN_RELEASED;
    g_btns[Copy_u8Pin].debouncedState = BTN_RELEASED;
    g_btns[Copy_u8Pin].counter = 0u;
    g_btns[Copy_u8Pin].initialized = 1u;

    return 0u;
}

STD_ReturnType BTN_Update(void)
{
    uint8 i;
    uint8 readValue;
    BTN_StateType currentState;

    for (i = 0u; i < 8u; i++)
    {
        if (g_btns[i].initialized == 0u)
        {
            continue;
        }

        (void)DIO_ReadPin(g_btns[i].port,
                          g_btns[i].pin,
                          &readValue);

        if (readValue == g_btns[i].activeLevel)
        {
            currentState = BTN_PRESSED;
        }
        else
        {
            currentState = BTN_RELEASED;
        }

        if (currentState != g_btns[i].rawState)
        {
            g_btns[i].rawState = currentState;
            g_btns[i].counter = 0u;
        }
        else
        {
            if (g_btns[i].counter < 5u)
            {
                g_btns[i].counter++;
            }

            if (g_btns[i].counter >= 5u)
            {
                g_btns[i].debouncedState = currentState;
            }
        }
    }

    return 0u;
}

BTN_StateType BTN_GetState(uint8 Copy_u8Pin)
{
    if (Copy_u8Pin >= 8u)
    {
        return BTN_RELEASED;
    }

    if (g_btns[Copy_u8Pin].initialized == 0u)
    {
        return BTN_RELEASED;
    }

    return g_btns[Copy_u8Pin].debouncedState;
}

uint8 BTN_IsPressed(uint8 Copy_u8Pin)
{
    return (BTN_GetState(Copy_u8Pin) == BTN_PRESSED) ? 1u : 0u;
}
