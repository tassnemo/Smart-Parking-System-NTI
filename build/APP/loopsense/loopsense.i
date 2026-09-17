# 0 "APP/loopsense/loopsense.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/loopsense/loopsense.c"
# 1 "APP/loopsense/loopsense.h" 1



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
# 5 "APP/loopsense/loopsense.h" 2
# 1 "./APP/lane/lane_fsm.h" 1



# 1 "APP/../LIB/STD_TYPES.h" 1
# 5 "./APP/lane/lane_fsm.h" 2

typedef enum {
    LN_IDLE = 0,
    LN_VEHICLE_WAIT,
    LN_AUTHORISING,
    LN_GATE_OPENING,
    LN_GATE_OPEN,
    LN_VEHICLE_PASSING,
    LN_GATE_CLOSING,
    LN_REJECTED,
    LN_TIMEOUT
} LaneState_t;

typedef struct {
    LaneState_t state;
    uint16 timerTicks;
    uint8 loopActive;
    uint8 servoCh;
    uint8 isEntry;
    uint16 passCount;
    uint8 faultFlag;
} Lane_t;

extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry);
void LANE_Run(Lane_t *ln);
void LANE_RequestOpen(Lane_t *ln, uint8 Copy_u8LoopActive);
LaneState_t LANE_GetState(const Lane_t *ln);
# 6 "APP/loopsense/loopsense.h" 2
# 24 "APP/loopsense/loopsense.h"
typedef struct
{
    uint8 adcChannel;
    Lane_t *lane;
    uint8 confirmedActive;
    uint8 candidateCount;
} LoopSense_t;







STD_ReturnType LOOPSENSE_Init(LoopSense_t *ls, uint8 adcChannel, Lane_t *lane);







STD_ReturnType LOOPSENSE_Run(LoopSense_t *ls);
# 2 "APP/loopsense/loopsense.c" 2
# 1 "./MCAL/adc/ADC_interface.h" 1




# 1 "LIB/STD_TYPES.h" 1
# 6 "./MCAL/adc/ADC_interface.h" 2
# 39 "./MCAL/adc/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 3 "APP/loopsense/loopsense.c" 2
# 12 "APP/loopsense/loopsense.c"
STD_ReturnType LOOPSENSE_Init(LoopSense_t *ls, uint8 adcChannel, Lane_t *lane)
{
    if ((ls == ((void *)0)) || (lane == ((void *)0)))
    {
        return 1u;
    }

    ls->adcChannel = adcChannel;
    ls->lane = lane;
    ls->confirmedActive = 0u;
    ls->candidateCount = 0u;

    return 0u;
}

STD_ReturnType LOOPSENSE_Run(LoopSense_t *ls)
{
    uint16 Local_u16Raw;
    uint8 Local_u8CandidateState;

    if (ls == ((void *)0))
    {
        return 1u;
    }

    if (ADC_ReadChannel(ls->adcChannel, &Local_u16Raw) != 0u)
    {
        return 1u;
    }





    if (ls->confirmedActive == 0u)
    {
        Local_u8CandidateState = (Local_u16Raw > 600u) ? 1u : 0u;
    }
    else
    {
        Local_u8CandidateState = (Local_u16Raw < 400u) ? 0u : 1u;
    }

    if (Local_u8CandidateState == ls->confirmedActive)
    {



        ls->candidateCount = 0u;
        return 0u;
    }

    ls->candidateCount++;

    if (ls->candidateCount >= 4u)
    {
        ls->confirmedActive = Local_u8CandidateState;
        ls->candidateCount = 0u;



        LANE_RequestOpen(ls->lane, ls->confirmedActive);
    }

    return 0u;
}
