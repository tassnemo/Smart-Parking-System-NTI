# 0 "APP/telemetry/telemetry.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/telemetry/telemetry.c"
# 1 "APP/telemetry/telemetry.h" 1



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
# 5 "APP/telemetry/telemetry.h" 2
# 23 "APP/telemetry/telemetry.h"
STD_ReturnType TELEM_BuildFrame(char *Copy_pu8Buf);




STD_ReturnType TELEM_Send(void);
# 2 "APP/telemetry/telemetry.c" 2
# 1 "./LIB/checksum/checksum.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "./LIB/checksum/checksum.h" 2

uint8 XOR_Checksum(const uint8 *Copy_pu8Buf, uint16 Copy_u16Len);
# 3 "APP/telemetry/telemetry.c" 2
# 1 "./APP/lane/lane_fsm.h" 1



# 1 "APP/../LIB/STD_TYPES.h" 1
# 5 "./APP/lane/lane_fsm.h" 2

typedef enum {
    LN_IDLE = 0,
    LN_VEHICLE_WAIT,
    LN_AUTHORISING,
    LN_GATE_OPENING,
    LN_GATE_OPEN,
    LN_VEHICLE_PASSING,
    LN_GATE_CLOSING,
    LN_REJECTED,
    LN_TIMEOUT
} LaneState_t;

typedef struct {
    LaneState_t state;
    uint16 timerTicks;
    uint8 loopActive;
    uint8 servoCh;
    uint8 isEntry;
    uint16 passCount;
    uint8 faultFlag;
} Lane_t;

extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry);
void LANE_Run(Lane_t *ln);
void LANE_RequestOpen(Lane_t *ln, uint8 Copy_u8LoopActive);
LaneState_t LANE_GetState(const Lane_t *ln);
# 4 "APP/telemetry/telemetry.c" 2
# 1 "./APP/lot/lot_fsm.h" 1




# 1 "APP/config.h" 1
# 6 "./APP/lot/lot_fsm.h" 2

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
uint8 LOT_GetPeakOccupancy(void);
# 5 "APP/telemetry/telemetry.c" 2
# 1 "./MCAL/usart/usart_interface.h" 1





STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 6 "APP/telemetry/telemetry.c" 2


extern uint8 SLOT_GetMap(void);
extern uint16 TKT_GetTotalEntries(void);
extern uint16 BIL_GetTotalExits(void);
extern uint16 BIL_GetTotalRevenue(void);
extern uint32 RTC_Seconds(void);


static const char *const TELEM_LaneStateNames[] =
{
    "IDLE", "WAIT", "AUTH", "OPENING", "OPEN",
    "PASS", "CLOSING", "REJECT", "TIMEOUT"
};



static const char *const TELEM_ModeNames[] =
{
    "INIT", "OPER", "FULL", "MAINT", "FAULT"
};


static uint8 TELEM_AppendUint(char *buf, uint8 pos, uint32 value);
static uint8 TELEM_AppendHexByte(char *buf, uint8 pos, uint8 value);
static uint8 TELEM_AppendStr(char *buf, uint8 pos, const char *str);


static const char *TELEM_LaneStateName(LaneState_t state)
{
    uint8 Local_u8Idx = (uint8)state;

    if (Local_u8Idx >= (uint8)(sizeof(TELEM_LaneStateNames) / sizeof(TELEM_LaneStateNames[0])))
    {
        return "?";
    }
    return TELEM_LaneStateNames[Local_u8Idx];
}

static const char *TELEM_ModeName(LotState_t state)
{
    uint8 Local_u8Idx = (uint8)state;

    if (Local_u8Idx >= (uint8)(sizeof(TELEM_ModeNames) / sizeof(TELEM_ModeNames[0])))
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

    if (Copy_pu8Buf == ((void *)0))
    {
        return 1u;
    }

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "$PK,F=");
    Local_u8ChecksumStart = Local_u8Pos;

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

    Local_u8ChecksumEnd = Local_u8Pos;

    Local_u8Checksum = XOR_Checksum((const uint8 *)&Copy_pu8Buf[Local_u8ChecksumStart],
                                     (uint8)(Local_u8ChecksumEnd - Local_u8ChecksumStart));

    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "*");
    Local_u8Pos = TELEM_AppendHexByte(Copy_pu8Buf, Local_u8Pos, Local_u8Checksum);
    Local_u8Pos = TELEM_AppendStr(Copy_pu8Buf, Local_u8Pos, "\r\n");



    Copy_pu8Buf[Local_u8Pos] = '\0';

    return 0u;
}

STD_ReturnType TELEM_Send(void)
{
    char Local_acFrame[112u];

    if (TELEM_BuildFrame(Local_acFrame) != 0u)
    {
        return 1u;
    }

    return USART_SendString((const uint8 *)Local_acFrame);
}






static uint8 TELEM_AppendStr(char *buf, uint8 pos, const char *str)
{
    while ((*str != '\0') && (pos < (uint8)(112u - 1u)))
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
        if (pos < (uint8)(112u - 1u))
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
        if (pos >= (uint8)(112u - 1u))
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

    if (pos < (uint8)(112u - 2u))
    {
        buf[pos] = Local_acHex[(value >> 4u) & 0x0Fu];
        buf[pos + 1u] = Local_acHex[value & 0x0Fu];
        pos = (uint8)(pos + 2u);
    }
    return pos;
}
