#include "telemetry.h"
#include "LIB/checksum/checksum.h"
#include "APP/lane/lane_fsm.h"
#include "APP/lot/lot_fsm.h"
#include "MCAL/usart/usart_interface.h"

/* ---- Contract: getters this module needs from modules built elsewhere ---- */
extern uint8  SLOT_GetMap(void);            /* slots   */
extern uint16 TKT_GetTotalEntries(void);    /* ticketing */
extern uint16 BIL_GetTotalExits(void);      /* billing */
extern uint16 BIL_GetTotalRevenue(void);    /* billing */
extern uint32 RTC_Seconds(void);            /* softrtc */

/* Matches LaneState_t's declaration order in lane_fsm.h (DD-04) */
static const char *const TELEM_LaneStateNames[] =
{
    "IDLE", "WAIT", "AUTH", "OPENING", "OPEN",
    "PASS", "CLOSING", "REJECT", "TIMEOUT"
};
#define TELEM_LANE_NAME_COUNT  (sizeof(TELEM_LaneStateNames) / sizeof(TELEM_LaneStateNames[0]))

/* Matches LotState_t's declaration order (DD-04) and §18.1's MODE vocabulary */
static const char *const TELEM_ModeNames[] =
{
    "INIT", "OPER", "FULL", "MAINT", "FAULT"
};
#define TELEM_MODE_NAME_COUNT  (sizeof(TELEM_ModeNames) / sizeof(TELEM_ModeNames[0]))

static uint8 TELEM_AppendUint(char *buf, uint8 pos, uint32 value);
static uint8 TELEM_AppendHexByte(char *buf, uint8 pos, uint8 value);
static uint8 TELEM_AppendStr(char *buf, uint8 pos, const char *str);

/* ---- Bounds-checked name lookups (the actual crash fix) ----------------- */
static const char *TELEM_LaneStateName(LaneState_t state)
{
    uint8 Local_u8Idx = (uint8)state;

    if (Local_u8Idx >= (uint8)TELEM_LANE_NAME_COUNT)
    {
        return "?";    /* never walk off the end of the table */
    }
    return TELEM_LaneStateNames[Local_u8Idx];
}

static const char *TELEM_ModeName(LotState_t state)
{
    uint8 Local_u8Idx = (uint8)state;

    if (Local_u8Idx >= (uint8)TELEM_MODE_NAME_COUNT)
    {
        return "?";
    }
    return TELEM_ModeNames[Local_u8Idx];
}

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
    Local_u8ChecksumStart = Local_u8Pos;   /* checksum starts AFTER "PK,F=" */

    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, LOT_GetFree());
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",O=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, LOT_GetOccupied());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",MAP=");
    Local_u8Pos = TELEM_AppendHexByte(Copy_pu8Buf, Local_u8Pos, SLOT_GetMap());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",IN=");
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos,
                                  TELEM_LaneStateName(LANE_GetState(&g_entryLane)));

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",OUT=");
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos,
                                  TELEM_LaneStateName(LANE_GetState(&g_exitLane)));

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",T=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, TKT_GetTotalEntries());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",X=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, BIL_GetTotalExits());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",REV=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, BIL_GetTotalRevenue());

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",MODE=");
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos,
                                  TELEM_ModeName(LOT_GetState()));

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, ",UP=");
    Local_u8Pos = TELEM_AppendUint(Copy_pu8Buf, Local_u8Pos, RTC_Seconds());

    Local_u8ChecksumEnd = Local_u8Pos;   /* checksum ends just before '*' */

    Local_u8Checksum = XOR_Checksum((const uint8 *)&Copy_pu8Buf[Local_u8ChecksumStart],
                                     (uint8)(Local_u8ChecksumEnd - Local_u8ChecksumStart));

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "*");
    Local_u8Pos = TELEM_AppendHexByte(Copy_pu8Buf, Local_u8Pos, Local_u8Checksum);
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "\r\n");

    /* pos is guaranteed <= TELEM_FRAME_MAX_LEN - 1 by the append helpers,
       so this write is always in range. */
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

/* ---------------- Manual formatting helpers (no sprintf dependency) -------
 * Every append is bounded by TELEM_FRAME_MAX_LEN - 1 so the caller's '\0'
 * write at buf[pos] is always legal. Overflow silently drops the tail
 * instead of corrupting adjacent memory. -------------------------------- */

static uint8 TELEM_AppendStr(char *buf, uint8 pos, const char *str)
{
    while ((*str != '\0') && (pos < (uint8)(TELEM_FRAME_MAX_LEN - 1u)))
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
        if (pos < (uint8)(TELEM_FRAME_MAX_LEN - 1u))
        {
            buf[pos] = '0';
            pos++;
        }
        return pos;
    }

    while ((value > 0u) && (Local_u8Count < (uint8)sizeof(Local_acDigits)))
    {
        Local_acDigits[Local_u8Count] = (char)('0' + (value % 10u));
        value /= 10u;
        Local_u8Count++;
    }

    for (Local_u8i = Local_u8Count; Local_u8i > 0u; Local_u8i--)
    {
        if (pos >= (uint8)(TELEM_FRAME_MAX_LEN - 1u))
        {
            break;
        }
        buf[pos] = Local_acDigits[Local_u8i - 1u];
        pos++;
    }

    return pos;
}

static uint8 TELEM_AppendHexByte(char *buf, uint8 pos, uint8 value)
{
    static const char Local_acHex[] = "0123456789ABCDEF";

    if (pos < (uint8)(TELEM_FRAME_MAX_LEN - 2u))
    {
        buf[pos]      = Local_acHex[(value >> 4u) & 0x0Fu];
        buf[pos + 1u] = Local_acHex[value & 0x0Fu];
        pos = (uint8)(pos + 2u);
    }
    return pos;
}