# 0 "MCAL/adc/ADC.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/adc/ADC.c"
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
# 2 "MCAL/adc/ADC.c" 2
# 1 "MCAL/adc/ADC_interface.h" 1
# 39 "MCAL/adc/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 3 "MCAL/adc/ADC.c" 2
# 1 "MCAL/adc/ADC_private.h" 1
# 4 "MCAL/adc/ADC.c" 2

STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler)
{
    if ((Copy_u8Ref != 0u &&
         Copy_u8Ref != 1u &&
         Copy_u8Ref != 3u) ||
        (Copy_u8Prescaler < 1u ||
         Copy_u8Prescaler > 7u))
    {
        return 1u;
    }


    (*(volatile uint8 *)0x27u) = (uint8)((Copy_u8Ref << 6u) |
                        (0u << 5u));


    (*(volatile uint8 *)0x26u) = (uint8)((Copy_u8Prescaler & 0x07u) |
                         (1u << 7u));

    return 0u;
}

STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel,
                               uint16 *Copy_pu16Reading)
{
    if (Copy_u8Channel > 7u ||
        Copy_pu16Reading == ((void *)0))
    {
        return 1u;
    }


    (*(volatile uint8 *)0x27u) = (uint8)(((*(volatile uint8 *)0x27u) & 0xE0u) |
                        (Copy_u8Channel & 0x1Fu));


    (*(volatile uint8 *)0x26u) |= (uint8)(1u << 4u);


    (*(volatile uint8 *)0x26u) |= (uint8)(1u << 6u);


    while (((*(volatile uint8 *)0x26u) & (uint8)(1u << 4u)) == 0u)
    {

    }


    (*(volatile uint8 *)0x26u) |= (uint8)(1u << 4u);


    *Copy_pu16Reading = (uint16)((*(volatile uint8 *)0x24u) |
                          ((uint16)(*(volatile uint8 *)0x25u) << 8u));

    return 0u;
}

STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel)
{
    if (Copy_u8Channel > 7u)
    {
        return 1u;
    }


    if (((*(volatile uint8 *)0x26u) & (uint8)(1u << 6u)) != 0u)
    {
        return 1u;
    }


    (*(volatile uint8 *)0x27u) = (uint8)(((*(volatile uint8 *)0x27u) & 0xE0u) |
                        (Copy_u8Channel & 0x1Fu));


    (*(volatile uint8 *)0x26u) |= (uint8)(1u << 4u);


    (*(volatile uint8 *)0x26u) |= (uint8)(1u << 6u);

    return 0u;
}

STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading)
{
    if (Copy_pu16Reading == ((void *)0))
    {
        return 1u;
    }


    if (((*(volatile uint8 *)0x26u) & (uint8)(1u << 4u)) == 0u)
    {
        return 1u;
    }


    (*(volatile uint8 *)0x26u) |= (uint8)(1u << 4u);


    *Copy_pu16Reading = (uint16)((*(volatile uint8 *)0x24u) |
                          ((uint16)(*(volatile uint8 *)0x25u) << 8u));

    return 0u;
}

STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State)
{
    if (Copy_u8State == 1u)
    {
        (*(volatile uint8 *)0x26u) |= (uint8)(1u << 3u);
        return 0u;
    }

    if (Copy_u8State == 0u)
    {
        (*(volatile uint8 *)0x26u) &= (uint8)~(1u << 3u);
        return 0u;
    }

    return 1u;
}
