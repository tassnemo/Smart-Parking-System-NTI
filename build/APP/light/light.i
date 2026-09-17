# 0 "APP/light/light.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/light/light.c"
# 1 "APP/light/light.h" 1



# 1 "LIB/STD_TYPES.h" 1



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
# 23 "LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 5 "APP/light/light.h" 2

STD_ReturnType LIGHT_Init(void);
STD_ReturnType LIGHT_Run(void);
uint8 LIGHT_GetState(void);
# 2 "APP/light/light.c" 2
# 1 "APP/config.h" 1
# 3 "APP/light/light.c" 2
# 1 "MCAL/adc/adc_interface.h" 1
# 39 "MCAL/adc/adc_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 4 "APP/light/light.c" 2
# 1 "./APP/console/console.h" 1



# 1 "./LIB/STD_TYPES.h" 1
# 5 "./APP/console/console.h" 2
# 23 "./APP/console/console.h"
STD_ReturnType CONSOLE_Init(void);
STD_ReturnType CONSOLE_ParseLine(const char *Copy_pcLine);


uint8 CONSOLE_GetTariff(void);
uint8 CONSOLE_GetGrace(void);
uint8 CONSOLE_GetHold(void);
uint8 CONSOLE_GetTimeout(void);
uint8 CONSOLE_GetLightThresh(void);
# 5 "APP/light/light.c" 2

static uint8 g_u8LampsOn = 0u;

STD_ReturnType LIGHT_Init(void)
{
    g_u8LampsOn = 0u;
    return 0u;
}

STD_ReturnType LIGHT_Run(void)
{
    uint16 Local_u16Raw;
    uint16 Local_u16OnThreshold;
    uint16 Local_u16OffThreshold;
    uint8 Local_u8Threshold;
    uint8 Local_u8OffThreshold;


    if (ADC_ReadChannel(2u, &Local_u16Raw) != 0u)
    {
        return 1u;
    }

    Local_u8Threshold = CONSOLE_GetLightThresh();


    Local_u16OnThreshold =
        ((uint16)(((uint32)(Local_u8Threshold) * 1023u) / 100u));


    Local_u8OffThreshold =
        (uint8)(Local_u8Threshold + 10u);

    if (Local_u8OffThreshold > 100u)
    {
        Local_u8OffThreshold = 100u;
    }

    Local_u16OffThreshold =
        ((uint16)(((uint32)(Local_u8OffThreshold) * 1023u) / 100u));





    if (g_u8LampsOn == 0u)
    {
        if (Local_u16Raw < Local_u16OnThreshold)
        {
            g_u8LampsOn = 1u;
        }
    }





    else
    {
        if (Local_u16Raw >= Local_u16OffThreshold)
        {
            g_u8LampsOn = 0u;
        }
    }

    return 0u;
}

uint8 LIGHT_GetState(void)
{
    return g_u8LampsOn;
}
