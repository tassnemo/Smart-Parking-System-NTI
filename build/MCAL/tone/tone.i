# 0 "MCAL/tone/tone.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/tone/tone.c"
# 1 "MCAL/tone/tone_interface.h" 1



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
# 5 "MCAL/tone/tone_interface.h" 2
# 22 "MCAL/tone/tone_interface.h"
STD_ReturnType TONE_Init(void);






STD_ReturnType TONE_Start(void);





STD_ReturnType TONE_Stop(void);
# 2 "MCAL/tone/tone.c" 2
# 1 "MCAL/tone/tone_private.h" 1
# 3 "MCAL/tone/tone.c" 2

STD_ReturnType TONE_Init(void)
{

    (*(volatile uint8 *)0x31) |= (uint8)(1u << 7u);




    (*(volatile uint8 *)0x43) = 31u;
    (*(volatile uint8 *)0x44) = 0u;
    (*(volatile uint8 *)0x45) = (uint8)(1u << 3u);


    (*(volatile uint8 *)0x32) &= (uint8)(~(1u << 7u));

    return 0u;
}

STD_ReturnType TONE_Start(void)
{


    (*(volatile uint8 *)0x45) = (uint8)((1u << 3u) | (1u << 4u) | (1u << 2u));

    return 0u;
}

STD_ReturnType TONE_Stop(void)
{

    (*(volatile uint8 *)0x45) = (uint8)(1u << 3u);


    (*(volatile uint8 *)0x32) &= (uint8)(~(1u << 7u));

    return 0u;
}
