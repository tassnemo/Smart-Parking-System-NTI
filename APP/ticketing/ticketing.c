#include "ticketing.h"
#include "softrtc.h"
#include "usart_interface.h"

/* ----------------------------------------------------------------------------
 * Cross-module reads. Declared extern here rather than pulled in via a full
 * header, to avoid ticketing.c depending on lot_fsm.h's whole interface for
 * two read-only getters it already has (§9.3: lot_fsm owns freeCount, slots
 * owns slotMap - ticketing only ever READS them, never writes).
 * --------------------------------------------------------------------------*/
extern uint8 LOT_GetFree(void);
extern uint8 SLOT_GetMap(void);

static Ticket_t g_atTickets[TICKET_MAX];
static uint16   g_u16NextId;
static uint16   g_u16TotalEntries;

static uint8 TKT_FindFreeRow(void);
static uint8 TKT_FindNearestFreeSlot(void);
static void  TKT_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf);
static void  TKT_PrintEntryFrame(const Ticket_t *Copy_pTkt, uint8 Copy_u8Free);

void TKT_Init(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < TICKET_MAX; Local_u8Index++)
    {
        g_atTickets[Local_u8Index].id       = 0u;
        g_atTickets[Local_u8Index].entrySec = 0u;
        g_atTickets[Local_u8Index].slotHint = 0u;
        g_atTickets[Local_u8Index].active   = 0u;
    }

    g_u16NextId       = TICKET_ID_FIRST;
    g_u16TotalEntries = 0u;
}

void TKT_OnEntryAuthorized(void)
{
    uint8 Local_u8Row = TKT_FindFreeRow();

    if (Local_u8Row >= TICKET_MAX)
    {
        /* Table full despite the lane FSM having already been granted entry
         * by LOT_CanAuthoriseEntry(). Can only happen if TICKET_MAX and
         * SLOT_COUNT ever fall out of lockstep - both are 6 in config.h, so
         * this path is defensive only. Nothing safe to print without a row;
         * document this assumption in the report rather than silently
         * inventing a ticket. */
        return;
    }

    g_atTickets[Local_u8Row].id       = g_u16NextId;
    g_atTickets[Local_u8Row].entrySec = RTC_Seconds();
    g_atTickets[Local_u8Row].slotHint = TKT_FindNearestFreeSlot();
    g_atTickets[Local_u8Row].active   = 1u;

    /* FR-07: 1 -> 9999 -> 1, no repeat within a session. */
    g_u16NextId = (uint16)((g_u16NextId >= TICKET_ID_LAST)
                          ? TICKET_ID_FIRST
                          : (uint16)(g_u16NextId + 1u));

    g_u16TotalEntries++;

    TKT_PrintEntryFrame(&g_atTickets[Local_u8Row], LOT_GetFree());
}

STD_ReturnType TKT_CloseOldest(uint16 *Copy_pu16Id, uint32 *Copy_pu32EntrySec)
{
    uint8  Local_u8Index;
    uint8  Local_u8OldestRow  = TICKET_MAX;      /* sentinel: none found yet */
    uint32 Local_u32OldestSec = 0xFFFFFFFFUL;

    if ((Copy_pu16Id == 0) || (Copy_pu32EntrySec == 0))
    {
        return E_NOK;
    }

    for (Local_u8Index = 0u; Local_u8Index < TICKET_MAX; Local_u8Index++)
    {
        if ((g_atTickets[Local_u8Index].active != 0u) &&
            (g_atTickets[Local_u8Index].entrySec < Local_u32OldestSec))
        {
            Local_u32OldestSec = g_atTickets[Local_u8Index].entrySec;
            Local_u8OldestRow  = Local_u8Index;
        }
    }

    if (Local_u8OldestRow >= TICKET_MAX)
    {
        return E_NOK;   /* nothing open - FR-14 mismatch territory */
    }

    *Copy_pu16Id       = g_atTickets[Local_u8OldestRow].id;
    *Copy_pu32EntrySec = g_atTickets[Local_u8OldestRow].entrySec;

    g_atTickets[Local_u8OldestRow].active = 0u;

    return E_OK;
}

const Ticket_t *TKT_Find(uint16 Copy_u16Id)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < TICKET_MAX; Local_u8Index++)
    {
        if ((g_atTickets[Local_u8Index].active != 0u) &&
            (g_atTickets[Local_u8Index].id == Copy_u16Id))
        {
            return &g_atTickets[Local_u8Index];
        }
    }

    return 0;
}

uint8 TKT_GetOpenCount(void)
{
    uint8 Local_u8Index;
    uint8 Local_u8Count = 0u;

    for (Local_u8Index = 0u; Local_u8Index < TICKET_MAX; Local_u8Index++)
    {
        if (g_atTickets[Local_u8Index].active != 0u)
        {
            Local_u8Count++;
        }
    }

    return Local_u8Count;
}

uint16 TKT_GetNextId(void)
{
    return g_u16NextId;
}

uint16 TKT_GetTotalEntries(void)
{
    return g_u16TotalEntries;
}

/* ======================================================================== */

static uint8 TKT_FindFreeRow(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < TICKET_MAX; Local_u8Index++)
    {
        if (g_atTickets[Local_u8Index].active == 0u)
        {
            return Local_u8Index;
        }
    }

    return TICKET_MAX;   /* sentinel: table full */
}

/* B1 groundwork: lowest-numbered currently-free slot, 1-based; 0 if none. */
static uint8 TKT_FindNearestFreeSlot(void)
{
    uint8 Local_u8Map = SLOT_GetMap();
    uint8 Local_u8Slot;

    for (Local_u8Slot = 0u; Local_u8Slot < SLOT_COUNT; Local_u8Slot++)
    {
        if ((Local_u8Map & (uint8)(1u << Local_u8Slot)) == 0u)
        {
            return (uint8)(Local_u8Slot + 1u);
        }
    }

    return 0u;   /* none free - shouldn't happen if authorisation was correct */
}

static void TKT_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf)
{
    Copy_pcBuf[0] = (char)('0' + (uint8)((Copy_u16Id / 1000u) % 10u));
    Copy_pcBuf[1] = (char)('0' + (uint8)((Copy_u16Id / 100u)  % 10u));
    Copy_pcBuf[2] = (char)('0' + (uint8)((Copy_u16Id / 10u)   % 10u));
    Copy_pcBuf[3] = (char)('0' + (uint8)( Copy_u16Id          % 10u));
    Copy_pcBuf[4] = '\0';
}

/* §18.3 entry frame, field-for-field. */
static void TKT_PrintEntryFrame(const Ticket_t *Copy_pTkt, uint8 Copy_u8Free)
{
    char Local_acId[5];
    char Local_acTime[10];

    TKT_FormatId(Copy_pTkt->id, Local_acId);

    if (RTC_Format(Copy_pTkt->entrySec,
                   Local_acTime,
                   (uint8)sizeof(Local_acTime)) != E_OK)
    {
        /* Buffer was rejected (shouldn't happen - sizeof is fixed at 10 and
         * RTC_Format requires >=10). Fall back to a safe placeholder rather
         * than print garbage from an unfilled buffer. */
        Local_acTime[0] = '-'; Local_acTime[1] = '-'; Local_acTime[2] = '-';
        Local_acTime[3] = ':'; Local_acTime[4] = '-'; Local_acTime[5] = '-';
        Local_acTime[6] = ':'; Local_acTime[7] = '-'; Local_acTime[8] = '-';
        Local_acTime[9] = '\0';
    }

    (void)USART_SendString((const uint8 *)"=== PARKING TICKET ===\r\n");
    (void)USART_SendString((const uint8 *)"ID    : ");
    (void)USART_SendString((const uint8 *)Local_acId);
    (void)USART_SendString((const uint8 *)"\r\nTIME  : ");
    (void)USART_SendString((const uint8 *)Local_acTime);
    (void)USART_SendString((const uint8 *)"\r\nSLOT  : suggest ");
    (void)USART_SendByte((uint8)('0' + Copy_pTkt->slotHint));
    (void)USART_SendString((const uint8 *)"\r\nFREE  : ");
    (void)USART_SendByte((uint8)('0' + Copy_u8Free));
    (void)USART_SendString((const uint8 *)"\r\n======================\r\n");
}