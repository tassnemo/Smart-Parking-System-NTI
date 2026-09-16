#ifndef SLOTS_H
#define SLOTS_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * Debounced 6-slot occupancy bitmap (FR-01, FR-02).
 *
 * SLOT_Poll() does the whole read-and-debounce pass:
 *      one PINC read -> invert -> mask -> shift -> per-sample debounce
 * and is meant to be called from Task_Slots every SLOT_Poll is called at
 * TASK_SLOTS_PERIOD_MS (10 ms); SLOT_DEBOUNCE_SAMPLES consecutive identical
 * samples (5 => 50 ms) before the public bitmap moves (config.h).
 *
 * SLOT_GetMap() / SLOT_CountFree() read the last DEBOUNCED, PUBLISHED
 * snapshot - they never re-read hardware, so every module that reads them in
 * the same 10 ms tick sees the same value (§9.4 concurrency contract).
 * --------------------------------------------------------------------------*/

STD_ReturnType SLOT_Init(void);

/* Call once per Task_Slots tick. Updates the internal debounce state and,
 * once a change survives SLOT_DEBOUNCE_SAMPLES samples, the public snapshot. */
STD_ReturnType SLOT_Poll(void);

/* bit n = 1 -> slot n+1 occupied, bits 0..5 valid (SLOT_MAP_MASK). */
uint8 SLOT_GetMap(void);

/* SLOT_COUNT - popcount(map), derived with the bit-counting expression of
 * §10.6 - no per-slot if-chain (FR-02). */
uint8 SLOT_CountFree(void);

#endif /* SLOTS_H */