#include "buttons.h"
#include "MCAL/dio/dio_interface.h"

#define BTN_MAX_COUNT       8u
#define BTN_DEBOUNCE_COUNT  5u

static BTN_ConfigType g_btns[BTN_MAX_COUNT];

STD_ReturnType BTN_Init(uint8 Copy_u8Port,
                        uint8 Copy_u8Pin,
                        uint8 Copy_u8ActiveLevel)
{
    if (Copy_u8Pin >= BTN_MAX_COUNT)
    {
        return E_NOK;
    }
    if (DIO_Init(Copy_u8Port, Copy_u8Pin, DIO_INPUT_PULLUP) != E_OK)
{
    return E_NOK;
}

    g_btns[Copy_u8Pin].port = Copy_u8Port;
    g_btns[Copy_u8Pin].pin = Copy_u8Pin;
    g_btns[Copy_u8Pin].activeLevel = Copy_u8ActiveLevel;
    g_btns[Copy_u8Pin].rawState = BTN_RELEASED;
    g_btns[Copy_u8Pin].debouncedState = BTN_RELEASED;
    g_btns[Copy_u8Pin].counter = 0u;
    g_btns[Copy_u8Pin].initialized = 1u;

    return E_OK;
}

STD_ReturnType BTN_Update(void)
{
    uint8 i;
    uint8 readValue;
    BTN_StateType currentState;

    for (i = 0u; i < BTN_MAX_COUNT; i++)
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
            if (g_btns[i].counter < BTN_DEBOUNCE_COUNT)
            {
                g_btns[i].counter++;
            }

            if (g_btns[i].counter >= BTN_DEBOUNCE_COUNT)
            {
                g_btns[i].debouncedState = currentState;
            }
        }
    }

    return E_OK;
}

BTN_StateType BTN_GetState(uint8 Copy_u8Pin)
{
    if (Copy_u8Pin >= BTN_MAX_COUNT)
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