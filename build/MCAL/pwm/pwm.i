# 0 "MCAL/pwm/pwm.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/pwm/pwm.c"
# 1 "MCAL/pwm/pwm_interface.h" 1



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
# 5 "MCAL/pwm/pwm_interface.h" 2
# 27 "MCAL/pwm/pwm_interface.h"
STD_ReturnType PWM_Init(void);







STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel, uint16 Copy_u16PulseUs);
# 2 "MCAL/pwm/pwm.c" 2
# 1 "MCAL/pwm/pwm_private.h" 1
# 3 "MCAL/pwm/pwm.c" 2

STD_ReturnType PWM_Init(void)
{
    (*(volatile uint8 *)0x31) |=
        (uint8)((1u << 5u) |
                (1u << 4u));

    (*(volatile uint8 *)0x4F) =
        (uint8)((1u << 7u) |
                (1u << 5u) |
                (1u << 1u));

    (*(volatile uint8 *)0x4E) =
        (uint8)((1u << 4u) |
                (1u << 3u) |
                (1u << 1u));

    (*(volatile uint8 *)0x47) = (uint8)(19999u >> 8u);
    (*(volatile uint8 *)0x46) = (uint8)(19999u & 0xFFu);

    (*(volatile uint8 *)0x4B) = 0u;
    (*(volatile uint8 *)0x4A) = 2000u;

    (*(volatile uint8 *)0x49) = 0u;
    (*(volatile uint8 *)0x48) = 1000u;

    return 0u;
}

STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel,
                            uint16 Copy_u16PulseUs)
{
    if (Copy_u16PulseUs < 1000u ||
        Copy_u16PulseUs > 2000u)
    {
        return 1u;
    }

    if (Copy_u8Channel == 0u)
    {
        (*(volatile uint8 *)0x4B) = (uint8)(Copy_u16PulseUs >> 8u);
        (*(volatile uint8 *)0x4A) = (uint8)(Copy_u16PulseUs & 0xFFu);
        return 0u;
    }

    if (Copy_u8Channel == 1u)
    {
        (*(volatile uint8 *)0x49) = (uint8)(Copy_u16PulseUs >> 8u);
        (*(volatile uint8 *)0x48) = (uint8)(Copy_u16PulseUs & 0xFFu);
        return 0u;
    }

    return 1u;
}
