#ifndef LOOPSENSE_H
#define LOOPSENSE_H

#include "LIB/STD_TYPES.h"
#include "APP/lane/lane_fsm.h"   /* for Lane_t and LANE_RequestOpen */

/*
 * APP loopsense -- bridges the raw ADC loop sensors to the lane FSM.
 * Owns FR-05's detection logic: ADC > 600 for 200ms confirms "vehicle
 * present", ADC < 400 for 200ms confirms "loop clear", with a dead
 * band between 400-600 where nothing changes (the hysteresis).
 *
 * This does NOT live inside lane_fsm.c: the lane FSM must stay pure
 * state-machine logic with zero ADC/register knowledge (NFR-08's layer
 * rule). This file is the only thing that reads ADC0/ADC1 and turns
 * that into the single boolean lane_fsm actually understands.
 *
 * Call LOOPSENSE_Run once per loop, from a task that runs every 50ms
 * (matches Task_Loops' period in the README's §19 schedule). The 200ms
 * confirm window is expressed as a sample COUNT, not raw 10ms ticks,
 * so it must be called at a consistent, known period.
 */

typedef struct
{
    uint8   adcChannel;        /* which ADC channel this loop reads       */
    Lane_t *lane;               /* which lane's LANE_RequestOpen to drive  */
    uint8   confirmedActive;    /* last state actually sent to the lane    */
    uint8   candidateCount;     /* consecutive samples supporting a flip   */
} LoopSense_t;

/*
 * Description : Initialise one loop sensor's debounce state.
 * Parameters  : ls          - the LoopSense_t instance to initialise
 *               adcChannel  - ADC_CHANNEL_0 / ADC_CHANNEL_1, etc.
 *               lane        - pointer to the Lane_t this loop drives
 */
STD_ReturnType LOOPSENSE_Init(LoopSense_t *ls, uint8 adcChannel, Lane_t *lane);

/*
 * Description : Read this loop's ADC channel, apply the 200ms/hysteresis
 *               confirm logic, and call LANE_RequestOpen on this loop's
 *               lane ONLY when the confirmed state actually changes.
 *               Call once per loop, every 50ms.
 */
STD_ReturnType LOOPSENSE_Run(LoopSense_t *ls);

#endif /* LOOPSENSE_H */