# 0 "HAL/barrier/barrier.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/barrier/barrier.c"
# 1 "HAL/barrier/barrier.h" 1



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
# 5 "HAL/barrier/barrier.h" 2

STD_ReturnType BAR_Init(uint8 Copy_u8Channel);
STD_ReturnType BAR_Open(uint8 Copy_u8Channel);
STD_ReturnType BAR_Close(uint8 Copy_u8Channel);
STD_ReturnType BAR_IsMoving(uint8 Copy_u8Channel, uint8 *Copy_pu8Status);
# 2 "HAL/barrier/barrier.c" 2
# 1 "./MCAL/pwm/pwm_interface.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "./MCAL/pwm/pwm_interface.h" 2
# 1 "APP/config.h" 1
# 6 "./MCAL/pwm/pwm_interface.h" 2
# 22 "./MCAL/pwm/pwm_interface.h"
STD_ReturnType PWM_Init(void);







STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel, uint16 Copy_u16PulseUs);
# 3 "HAL/barrier/barrier.c" 2
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 1 3 4
# 160 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4

# 160 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 344 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int wchar_t;
# 4 "HAL/barrier/barrier.c" 2


# 5 "HAL/barrier/barrier.c"
STD_ReturnType BAR_Init(uint8 Copy_u8Channel)
{
    if (Copy_u8Channel != 0u &&
        Copy_u8Channel != 1u)
    {
        return 1u;
    }

    return 0u;
}

STD_ReturnType BAR_Open(uint8 Copy_u8Channel)
{
    return PWM_SetPulse(Copy_u8Channel, 2000u);
}

STD_ReturnType BAR_Close(uint8 Copy_u8Channel)
{
    return PWM_SetPulse(Copy_u8Channel, 1500u);
}

STD_ReturnType BAR_IsMoving(uint8 Copy_u8Channel, uint8 *Copy_pu8Status)
{
    if (Copy_pu8Status == 
# 28 "HAL/barrier/barrier.c" 3 4
                         ((void *)0)
# 28 "HAL/barrier/barrier.c"
                             )
    {
        return 1u;
    }

    if (Copy_u8Channel != 0u &&
        Copy_u8Channel != 1u)
    {
        return 1u;
    }

    *Copy_pu8Status = 0u;

    return 0u;
}
