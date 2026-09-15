# 0 "APP/scheduler/scheduler.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/scheduler/scheduler.c"
# 1 "APP/scheduler/scheduler.h" 1



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
# 5 "APP/scheduler/scheduler.h" 2
# 20 "APP/scheduler/scheduler.h"
typedef void (*SCHED_TaskFunc)(void);





STD_ReturnType SCHED_Init(void);
# 37 "APP/scheduler/scheduler.h"
STD_ReturnType SCHED_RegisterTask(SCHED_TaskFunc Copy_pfFunc,
                                   uint16 Copy_u16Period,
                                   uint16 Copy_u16Offset);







void SCHED_Tick(void);





uint32 SCHED_GetTickCount(void);
# 2 "APP/scheduler/scheduler.c" 2
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 1 3 4
# 160 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4

# 160 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 344 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int wchar_t;
# 3 "APP/scheduler/scheduler.c" 2


# 4 "APP/scheduler/scheduler.c"
typedef struct
{
    SCHED_TaskFunc func;
    uint16 period;
    uint16 offset;
    uint8 used;
} SCHED_TaskEntry_t;

static SCHED_TaskEntry_t g_tasks[12u];
static uint8 g_taskCount = 0u;
static uint32 g_tickCount = 0u;

STD_ReturnType SCHED_Init(void)
{
    uint8 i;

    for (i = 0u; i < 12u; i++)
    {
        g_tasks[i].func = 
# 22 "APP/scheduler/scheduler.c" 3 4
                           ((void *)0)
# 22 "APP/scheduler/scheduler.c"
                               ;
        g_tasks[i].period = 0u;
        g_tasks[i].offset = 0u;
        g_tasks[i].used = 0u;
    }

    g_taskCount = 0u;
    g_tickCount = 0u;

    return 0u;
}

STD_ReturnType SCHED_RegisterTask(SCHED_TaskFunc Copy_pfFunc,
                                   uint16 Copy_u16Period,
                                   uint16 Copy_u16Offset)
{
    if ((Copy_pfFunc == 
# 38 "APP/scheduler/scheduler.c" 3 4
                       ((void *)0)
# 38 "APP/scheduler/scheduler.c"
                           ) || (Copy_u16Period == 0u))
    {
        return 1u;
    }

    if (g_taskCount >= 12u)
    {
        return 1u;
    }

    g_tasks[g_taskCount].func = Copy_pfFunc;
    g_tasks[g_taskCount].period = Copy_u16Period;
    g_tasks[g_taskCount].offset = Copy_u16Offset;
    g_tasks[g_taskCount].used = 1u;
    g_taskCount++;

    return 0u;
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
