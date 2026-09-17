#include "loopsense.h"
#include "MCAL/adc/ADC_interface.h"

/* FR-05 thresholds -- must match config.h's DD-05 constants */
#define LOOP_PRESENT_RAW      600u
#define LOOP_CLEAR_RAW        400u

/* This module is called every 50ms (Task_Loops' period per README §19).
 * 200ms / 50ms = 4 consecutive confirming samples before a state flips. */
#define LOOPSENSE_CONFIRM_SAMPLES  4u

STD_ReturnType LOOPSENSE_Init(LoopSense_t *ls, uint8 adcChannel, Lane_t *lane)
{
    if ((ls == NULL) || (lane == NULL))
    {
        return E_NOK;
    }

    ls->adcChannel      = adcChannel;
    ls->lane             = lane;
    ls->confirmedActive  = 0u;
    ls->candidateCount   = 0u;

    return E_OK;
}

STD_ReturnType LOOPSENSE_Run(LoopSense_t *ls)
{
    uint16 Local_u16Raw;
    uint8  Local_u8CandidateState;

    if (ls == NULL)
    {
        return E_NOK;
    }

    if (ADC_ReadChannel(ls->adcChannel, &Local_u16Raw) != E_OK)
    {
        return E_NOK;
    }

    /* Decide what this single sample is voting for, relative to the
       CURRENTLY confirmed state -- this is what creates the hysteresis
       dead band. A reading between 400-600 votes for "stay the same",
       so it never accumulates toward a flip in either direction. */
    if (ls->confirmedActive == 0u)
    {
        Local_u8CandidateState = (Local_u16Raw > LOOP_PRESENT_RAW) ? 1u : 0u;
    }
    else
    {
        Local_u8CandidateState = (Local_u16Raw < LOOP_CLEAR_RAW) ? 0u : 1u;
    }

    if (Local_u8CandidateState == ls->confirmedActive)
    {
        /* This sample doesn't support a change -- reset the counter.
           Covers both "still in the dead band" and "reading went back
           toward the confirmed state before 200ms was reached". */
        ls->candidateCount = 0u;
        return E_OK;
    }

    ls->candidateCount++;

    if (ls->candidateCount >= LOOPSENSE_CONFIRM_SAMPLES)
    {
        ls->confirmedActive = Local_u8CandidateState;
        ls->candidateCount  = 0u;

        /* Only call LANE_RequestOpen on an actual confirmed change --
           not every 50ms sample -- so the lane FSM sees a clean edge. */
        LANE_RequestOpen(ls->lane, ls->confirmedActive);
    }

    return E_OK;
}