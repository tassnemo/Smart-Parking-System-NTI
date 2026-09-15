#ifndef SCHEDULER_H
#define SCHEDULER_H

#include "STD_TYPES.h"

/*
 * APP scheduler — cooperative, tick-driven task dispatcher.
 * Call SCHED_Tick() once every 10 ms (register it as the TMR0 callback).
 * All periods/offsets below are expressed in TICKS (1 tick = 10 ms),
 * matching the README's §19 task table directly:
 *   10 ms  -> 1 tick
 *   50 ms  -> 5 ticks
 *   250 ms -> 25 ticks
 *   1 s    -> 100 ticks
 *   5 s    -> 500 ticks
 */

#define SCHED_MAX_TASKS 12u

typedef void (*SCHED_TaskFunc)(void);

/*
 * Description : Reset the scheduler's internal tick counter and task table.
 *               Call once at boot, before any SCHED_RegisterTask calls.
 */
STD_ReturnType SCHED_Init(void);

/*
 * Description : Register a task to run periodically.
 * Parameters  : Copy_pfFunc     - function to call, must not be NULL
 *               Copy_u16Period  - how often, in ticks (10ms units). Must be > 0.
 *               Copy_u16Offset  - phase offset in ticks, spreads tasks that
 *                                 share a period so they don't all fire on
 *                                 the same tick (matches §19's Offset column)
 * Return      : E_NOK if the table is full, period is 0, or func is NULL.
 */
STD_ReturnType SCHED_RegisterTask(SCHED_TaskFunc Copy_pfFunc,
                                   uint16 Copy_u16Period,
                                   uint16 Copy_u16Offset);

/*
 * Description : Call every 10 ms (from the TMR0 ISR callback). Advances the
 *               internal tick count and runs every task whose period has
 *               elapsed. Must return quickly -- if the sum of all due tasks'
 *               work exceeds ~10ms, ticks will jitter (see NFR-11).
 */
void SCHED_Tick(void);

/*
 * Description : Number of ticks SCHED_Tick has been called since SCHED_Init.
 *               Useful for other modules needing raw tick timing.
 */
uint32 SCHED_GetTickCount(void);

#endif /* SCHEDULER_H */