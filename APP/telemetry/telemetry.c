#include "telemetry.h"
#include "LIB/checksum/checksum.h"
#include "APP/lane/lane_fsm.h"
#include "APP/lot/lot_fsm.h"
#include "MCAL/usart/usart_interface.h"
#include <string.h>

/* ---- Contract: getters this module needs from modules built elsewhere.
   lot_fsm.h and ticketing.h already exist and are included/matched here;
   billing.h's getter is still assumed -- rename BIL_GetTotalExits and
   BIL_GetTotalRevenue below if your actual billing.c uses different names. ---- */
/* LOT_GetFree, LOT_GetState  -- from lot_fsm.h (included above)          */
/* SLOT_GetMap                -- already declared in slots.h; include it  */
/* TKT_GetTotalEntries        -- from ticketing.h (include it separately) */
extern uint8  SLOT_GetMap(void);            /* slots   */
extern uint16 TKT_GetTotalEntries(void);     /* ticketing -- already exists */
extern uint16 BIL_GetTotalExits(void);       /* billing -- billing owns exit counting, not ticketing */
extern uint16 BIL_GetTotalRevenue(void);     /* billing */
extern uint32 RTC_Seconds(void);             /* softrtc */

/* Matches LaneState_t's declaration order in lane_fsm.h (DD-04) */
static const char *const TELEM_LaneStateNames[] =
{
    "IDLE", "WAIT", "AUTH", "OPENING", "OPEN",
    "PASS", "CLOSING", "REJECT", "TIMEOUT"
};

/* Matches LotState_t's declaration order (DD-04) and §18.1's MODE vocabulary */
static const char *const TELEM_ModeNames[] =
{
    "INIT", "OPER", "FULL", "MAINT", "FAULT"
};

static uint8 TELEM_AppendUint(char *buf, uint8 pos, uint32 value);
static uint8 TELEM_AppendHexByte(char *buf, uint8 pos, uint8 value);
static uint8 TELEM_AppendStr(char *buf, uint8 pos, const char *str);

STD_ReturnType TELEM_BuildFrame(char *Copy_pu8Buf)
{
    uint8 Local_u8Pos = 0u;
    uint8 Local_u8ChecksumStart;
    uint8 Local_u8ChecksumEnd;
    uint8 Local_u8Checksum;

    if (Copy_pu8Buf == NULL)
    {
        return E_NOK;
    }

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "$PK,F=");
    Local_u8ChecksumStart = Local_u8Pos;   /* checksum covers everything AFTER '$' */

    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, LOT_GetFree());
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",O=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, LOT_GetOccupied());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",MAP=");
    Local_u8Pos = TELEM_AppendHexByte(Copy_pu8Buf, Local_u8Pos, SLOT_GetMap());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",IN=");
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos,
                                   TELEM_LaneStateNames[LANE_GetState(&g_entryLane)]);

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",OUT=");
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos,
                                   TELEM_LaneStateNames[LANE_GetState(&g_exitLane)]);

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",T=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, TKT_GetTotalEntries());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",X=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, BIL_GetTotalExits());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",REV=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, BIL_GetTotalRevenue());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",MODE=");
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, TELEM_ModeNames[(uint8)LOT_GetState()]);

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",UP=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, RTC_Seconds());

    Local_u8ChecksumEnd = Local_u8Pos;   /* checksum covers up to just before '*' */

    Local_u8Checksum = XOR_Checksum((const uint8 *)&Copy_pu8Buf[Local_u8ChecksumStart],
                                     (uint8)(Local_u8ChecksumEnd - Local_u8ChecksumStart));

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "*");
    Local_u8Pos = TELEM_AppendHexByte(Copy_pu8Buf, Local_u8Pos, Local_u8Checksum);
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "\r\n");

    Copy_pu8Buf[Local_u8Pos] = '\0';

    return E_OK;
}

STD_ReturnType TELEM_Send(void)
{
    char Local_acFrame[TELEM_FRAME_MAX_LEN];

    if (TELEM_BuildFrame(Local_acFrame) != E_OK)
    {
        return E_NOK;
    }

return USART_SendString((const uint8 *)Local_acFrame);
}

/* ---------------- Manual formatting helpers (no sprintf dependency) ---------------- */

static uint8 TELEM_AppendStr(char *buf, uint8 pos, const char *str)
{
    while (*str != '\0')
    {
        buf[pos] = *str;
        pos++;
        str++;
    }
    return pos;
}

static uint8 TELEM_AppendUint(char *buf, uint8 pos, uint32 value)
{
    char Local_acDigits[10];
    uint8 Local_u8Count = 0u;
    uint8 Local_u8i;

    if (value == 0u)
    {
        buf[pos] = '0';
        return (uint8)(pos + 1u);
    }

    while (value > 0u)
    {
        Local_acDigits[Local_u8Count] = (char)('0' + (value % 10u));
        value /= 10u;
        Local_u8Count++;
    }

    for (Local_u8i = Local_u8Count; Local_u8i > 0u; Local_u8i--)
    {
        buf[pos] = Local_acDigits[Local_u8i - 1u];
        pos++;
    }

    return pos;
}

static uint8 TELEM_AppendHexByte(char *buf, uint8 pos, uint8 value)
{
    static const char Local_acHex[] = "0123456789ABCDEF";

    buf[pos]     = Local_acHex[(value >> 4u) & 0x0Fu];
    buf[pos + 1u] = Local_acHex[value & 0x0Fu];

    return (uint8)(pos + 2u);
}