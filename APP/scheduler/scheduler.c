#include "scheduler.h"
#include <stddef.h>

typedef struct
{
    SCHED_TaskFunc func;
    uint16         period;    /* in ticks */
    uint16         offset;    /* in ticks */
    uint8          used;      /* 1 = this slot holds a real task */
} SCHED_TaskEntry_t;

static SCHED_TaskEntry_t g_tasks[SCHED_MAX_TASKS];
static uint8             g_taskCount = 0u;
static uint32            g_tickCount = 0u;

STD_ReturnType SCHED_Init(void)
{
    uint8 i;

    for (i = 0u; i < SCHED_MAX_TASKS; i++)
    {
        g_tasks[i].func   = NULL;
        g_tasks[i].period = 0u;
        g_tasks[i].offset = 0u;
        g_tasks[i].used   = 0u;
    }

    g_taskCount = 0u;
    g_tickCount = 0u;

    return E_OK;
}

STD_ReturnType SCHED_RegisterTask(SCHED_TaskFunc Copy_pfFunc,
                                   uint16 Copy_u16Period,
                                   uint16 Copy_u16Offset)
{
    if ((Copy_pfFunc == NULL) || (Copy_u16Period == 0u))
    {
        return E_NOK;
    }

    if (g_taskCount >= SCHED_MAX_TASKS)
    {
        return E_NOK;   /* table full -- fixed size, no dynamic growth (NFR-16) */
    }

    g_tasks[g_taskCount].func   = Copy_pfFunc;
    g_tasks[g_taskCount].period = Copy_u16Period;
    g_tasks[g_taskCount].offset = Copy_u16Offset;
    g_tasks[g_taskCount].used   = 1u;
    g_taskCount++;

    return E_OK;
}

void SCHED_Tick(void)
{
    uint8 i;

    g_tickCount++;

    for (i = 0u; i < g_taskCount; i++)
    {
        if (g_tasks[i].used == 0u)
        {
            continue;
        }

        /* Due when (tickCount + offset) is an exact multiple of period.
           The offset staggers tasks that share a period so they don't
           all run on the same tick -- matches the Offset column in §19. */
        if (((g_tickCount + g_tasks[i].offset) % g_tasks[i].period) == 0u)
        {
            g_tasks[i].func();
        }
    }
}

uint32 SCHED_GetTickCount(void)
{
    return g_tickCount;
}