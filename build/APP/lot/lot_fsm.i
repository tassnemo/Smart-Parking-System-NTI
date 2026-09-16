# 0 "APP/lot/lot_fsm.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/lot/lot_fsm.c"
# 1 "APP/lot/lot_fsm.h" 1



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
# 5 "APP/lot/lot_fsm.h" 2
# 1 "APP/config.h" 1
# 6 "APP/lot/lot_fsm.h" 2

typedef enum
{
    LOT_INIT = 0u,
    LOT_OPERATIONAL,
    LOT_FULL,
    LOT_MAINTENANCE,
    LOT_FAULT
} LotState_t;

void LOT_Init(void);
void LOT_Run(void);

uint8 LOT_GetMap(void);
uint8 LOT_GetFree(void);
uint8 LOT_GetOccupied(void);
LotState_t LOT_GetState(void);

uint8 LOT_CanAuthoriseEntry(void);

void LOT_SetMaintenance(uint8 Copy_u8Enabled);
void LOT_SetFault(uint8 Copy_u8Enabled);
# 2 "APP/lot/lot_fsm.c" 2

# 1 "./HAL/slots/slots.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "./HAL/slots/slots.h" 2
# 20 "./HAL/slots/slots.h"
STD_ReturnType SLOT_Init(void);



STD_ReturnType SLOT_Poll(void);


uint8 SLOT_GetMap(void);



uint8 SLOT_CountFree(void);
# 4 "APP/lot/lot_fsm.c" 2

static LotState_t g_LotState = LOT_INIT;
static uint8 g_u8SlotMap = 0u;
static uint8 g_u8FreeSlots = 6u;
static uint8 g_u8OccupiedSlots = 0u;

static uint8 LOT_Popcount6(uint8 Copy_u8Value)
{
    Copy_u8Value = (uint8)(
        Copy_u8Value - ((Copy_u8Value >> 1u) & 0x55u)
    );

    Copy_u8Value = (uint8)(
        (Copy_u8Value & 0x33u) +
        ((Copy_u8Value >> 2u) & 0x33u)
    );

    return (uint8)((Copy_u8Value + (Copy_u8Value >> 4u)) & 0x0Fu);
}

void LOT_Init(void)
{
    g_LotState = LOT_INIT;
    g_u8SlotMap = 0u;
    g_u8FreeSlots = 6u;
    g_u8OccupiedSlots = 0u;
}

void LOT_Run(void)
{
    uint8 u8Occupied;

    if (SLOT_Poll() != 0u)
    {
        g_LotState = LOT_FAULT;
        return;
    }

    g_u8SlotMap = SLOT_GetMap();

    u8Occupied = LOT_Popcount6(g_u8SlotMap);
    g_u8OccupiedSlots = u8Occupied;
    g_u8FreeSlots = (uint8)(6u - u8Occupied);

    if (g_LotState == LOT_MAINTENANCE)
    {
        return;
    }

    if (g_LotState == LOT_FAULT)
    {
        return;
    }

    if (g_u8FreeSlots == 0u)
    {
        g_LotState = LOT_FULL;
    }
    else
    {
        g_LotState = LOT_OPERATIONAL;
    }
}

uint8 LOT_GetMap(void)
{
    return g_u8SlotMap;
}

uint8 LOT_GetFree(void)
{
    return g_u8FreeSlots;
}

uint8 LOT_GetOccupied(void)
{
    return g_u8OccupiedSlots;
}

LotState_t LOT_GetState(void)
{
    return g_LotState;
}

uint8 LOT_CanAuthoriseEntry(void)
{
    return (uint8)(
        (g_LotState == LOT_OPERATIONAL) &&
        (g_u8FreeSlots > 0u)
    );
}

void LOT_SetMaintenance(uint8 Copy_u8Enabled)
{
    if (Copy_u8Enabled != 0u)
    {
        g_LotState = LOT_MAINTENANCE;
    }
    else
    {
        g_LotState = (g_u8FreeSlots == 0u)
                   ? LOT_FULL
                   : LOT_OPERATIONAL;
    }
}

void LOT_SetFault(uint8 Copy_u8Enabled)
{
    if (Copy_u8Enabled != 0u)
    {
        g_LotState = LOT_FAULT;
    }
    else
    {
        g_LotState = (g_u8FreeSlots == 0u)
                   ? LOT_FULL
                   : LOT_OPERATIONAL;
    }
}
