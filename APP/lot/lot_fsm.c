#include "lot_fsm.h"
#include "config.h"
#include "HAL/slots/slots.h"

static LotState_t g_LotState = LOT_INIT;
static uint8 g_u8SlotMap = 0u;
static uint8 g_u8FreeSlots = SLOT_COUNT;
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
    g_u8FreeSlots = SLOT_COUNT;
    g_u8OccupiedSlots = 0u;
}

void LOT_Run(void)
{
    uint8 u8Occupied;

    if (SLOT_Poll() != E_OK)
    {
        g_LotState = LOT_FAULT;
        return;
    }

    g_u8SlotMap = SLOT_GetMap();

    u8Occupied = LOT_Popcount6(g_u8SlotMap);
    g_u8OccupiedSlots = u8Occupied;
    g_u8FreeSlots = (uint8)(SLOT_COUNT - u8Occupied);

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