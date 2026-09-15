# 0 "HAL/buzzer/buzzer.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/buzzer/buzzer.c"
# 1 "HAL/buzzer/buzzer.h" 1



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
# 5 "HAL/buzzer/buzzer.h" 2

STD_ReturnType BUZ_Init(uint8 Copy_u8Pin);
STD_ReturnType BUZ_On(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Off(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Beep(uint8 Copy_u8Pin,
                        uint8 Copy_u8Times,
                        uint16 Copy_u16Ms);

STD_ReturnType BUZ_Update(void);
# 2 "HAL/buzzer/buzzer.c" 2
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
# 3 "HAL/buzzer/buzzer.c" 2
# 1 "./MCAL/tone/tone_interface.h" 1
# 22 "./MCAL/tone/tone_interface.h"
STD_ReturnType TONE_Init(void);






STD_ReturnType TONE_Start(void);





STD_ReturnType TONE_Stop(void);
# 4 "HAL/buzzer/buzzer.c" 2






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


    if (Copy_u8Pin != 7u)
    {
        return 1u;
    }

    if (TONE_Init() != 0u)
    {
        return 1u;
    }

    g_buzPin = Copy_u8Pin;
    g_buzActive = 0u;
    g_buzState = 0u;
    g_buzBeepCount = 0u;
    g_buzTargetBeepCount = 0u;
    g_buzElapsedMs = 0u;
    g_buzDurationMs = 0u;

    return 0u;
}


STD_ReturnType BUZ_On(uint8 Copy_u8Pin)
{
    if (Copy_u8Pin != 7u)
    {
        return 1u;
    }

    return TONE_Start();
}


STD_ReturnType BUZ_Off(uint8 Copy_u8Pin)
{
    if (Copy_u8Pin != 7u)
    {
        return 1u;
    }

    return TONE_Stop();
}


STD_ReturnType BUZ_Beep(uint8 Copy_u8Pin,
                        uint8 Copy_u8Times,
                        uint16 Copy_u16Ms)
{
    if (g_buzActive == 1u)
        return 1u;

    if (Copy_u8Times == 0u || Copy_u16Ms == 0u)
        return 1u;

    if (Copy_u8Pin != g_buzPin)
        return 1u;

    if ((Copy_u16Ms % 10u) != 0u)
        return 1u;

    g_buzActive = 1u;
    g_buzState = 1u;

    g_buzBeepCount = 0u;
    g_buzTargetBeepCount = Copy_u8Times;

    g_buzTickCount = 0u;
    g_buzTicksPerPhase = Copy_u16Ms / 10u;

    BUZ_On(g_buzPin);

    return 0u;
}

STD_ReturnType BUZ_Update(void)
{
    if (g_buzActive == 0u)
        return 0u;

    g_buzTickCount++;

    if (g_buzTickCount < g_buzTicksPerPhase)
        return 0u;

    g_buzTickCount = 0u;

    if (g_buzState == 1u)
    {

        BUZ_Off(g_buzPin);
        g_buzState = 0u;
        g_buzBeepCount++;
    }
    else
    {

        if (g_buzBeepCount >= g_buzTargetBeepCount)
        {
            g_buzActive = 0u;
            return 0u;
        }

        BUZ_On(g_buzPin);
        g_buzState = 1u;
    }

    return 0u;
}
