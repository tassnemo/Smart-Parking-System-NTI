#include "buzzer.h"
#include "MCAL/dio/dio_interface.h"
#include "MCAL/tone/tone_interface.h"

#define BUZ_PORT DIO_PORTD
#define BUZ_TONE_PIN 7u   /* PD7/OC2 -- the only pin TONE_Start/Stop can drive */

#define BUZ_TICK_MS 10u

static uint8 g_buzPin = 0u;
static uint8 g_buzActive = 0u;
static uint8 g_buzState = 0u;

static uint8 g_buzBeepCount = 0u;
static uint8 g_buzTargetBeepCount = 0u;

static uint16 g_buzTickCount = 0u;
static uint16 g_buzTicksPerPhase = 0u;
static uint16 g_buzElapsedMs = 0u;
static uint16 g_buzDurationMs = 0u;

STD_ReturnType BUZ_Init(uint8 Copy_u8Pin)
{
    /* Timer2's OC2 output is hardwired to PD7 -- BUZ_On/Off now go through
       TONE_Start/Stop instead of plain DIO, so only pin 7 is valid here. */
    if (Copy_u8Pin != BUZ_TONE_PIN)
    {
        return E_NOK;
    }

    if (TONE_Init() != E_OK)
    {
        return E_NOK;
    }

    g_buzPin = Copy_u8Pin;
    g_buzActive = 0u;
    g_buzState = 0u;
    g_buzBeepCount = 0u;
    g_buzTargetBeepCount = 0u;
    g_buzElapsedMs = 0u;
    g_buzDurationMs = 0u;

    return E_OK;
}


STD_ReturnType BUZ_On(uint8 Copy_u8Pin)
{
    if (Copy_u8Pin != BUZ_TONE_PIN)
    {
        return E_NOK;
    }

    return TONE_Start();   /* hardware now oscillates PD7 -- audible tone */
}


STD_ReturnType BUZ_Off(uint8 Copy_u8Pin)
{
    if (Copy_u8Pin != BUZ_TONE_PIN)
    {
        return E_NOK;
    }

    return TONE_Stop();
}


STD_ReturnType BUZ_Beep(uint8 Copy_u8Pin,
                        uint8 Copy_u8Times,
                        uint16 Copy_u16Ms)
{
    if (g_buzActive == 1u)
        return E_NOK;

    if (Copy_u8Times == 0u || Copy_u16Ms == 0u)
        return E_NOK;

    if (Copy_u8Pin != g_buzPin)
        return E_NOK;

    if ((Copy_u16Ms % BUZ_TICK_MS) != 0u)
        return E_NOK;

    g_buzActive = 1u;
    g_buzState = 1u;

    g_buzBeepCount = 0u;
    g_buzTargetBeepCount = Copy_u8Times;

    g_buzTickCount = 0u;
    g_buzTicksPerPhase = Copy_u16Ms / BUZ_TICK_MS;

    BUZ_On(g_buzPin);

    return E_OK;
}

STD_ReturnType BUZ_Update(void)
{
    if (g_buzActive == 0u)
        return E_OK;

    g_buzTickCount++;

    if (g_buzTickCount < g_buzTicksPerPhase)
        return E_OK;

    g_buzTickCount = 0u;

    if (g_buzState == 1u)
    {
        /* ON -> OFF */
        BUZ_Off(g_buzPin);
        g_buzState = 0u;
        g_buzBeepCount++;
    }
    else
    {
        /* OFF -> ON or finish */
        if (g_buzBeepCount >= g_buzTargetBeepCount)
        {
            g_buzActive = 0u;
            return E_OK;
        }

        BUZ_On(g_buzPin);
        g_buzState = 1u;
    }

    return E_OK;
}