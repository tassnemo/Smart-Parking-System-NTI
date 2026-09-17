# 0 "APP/ticketing/ticketing.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/ticketing/ticketing.c"
# 1 "APP/ticketing/ticketing.h" 1



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
# 5 "APP/ticketing/ticketing.h" 2
# 1 "APP/config.h" 1
# 6 "APP/ticketing/ticketing.h" 2


typedef struct
{
    uint16 id;
    uint32 entrySec;
    uint8 slotHint;
    uint8 active;
} Ticket_t;



void TKT_Init(void);






void TKT_OnEntryAuthorized(void);




STD_ReturnType TKT_CloseOldest(uint16 *Copy_pu16Id, uint32 *Copy_pu32EntrySec);


const Ticket_t *TKT_Find(uint16 Copy_u16Id);


uint8 TKT_GetOpenCount(void);


uint16 TKT_GetNextId(void);
uint16 TKT_GetTotalEntries(void);
void TKT_PrintOpenTickets(void);
void TKT_ClearStats(void);
# 2 "APP/ticketing/ticketing.c" 2
# 1 "LIB/softrtc.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/softrtc.h" 2

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
        char *Copy_pcBuf,
        uint8 Copy_u8BufSize);
# 3 "APP/ticketing/ticketing.c" 2
# 1 "MCAL/usart/usart_interface.h" 1





STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 4 "APP/ticketing/ticketing.c" 2
# 12 "APP/ticketing/ticketing.c"
extern uint8 LOT_GetFree(void);
extern uint8 SLOT_GetMap(void);

static Ticket_t g_atTickets[6u];
static uint16 g_u16NextId;
static uint16 g_u16TotalEntries;

static uint8 TKT_FindFreeRow(void);
static uint8 TKT_FindNearestFreeSlot(void);
static void TKT_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf);
static void TKT_PrintEntryFrame(const Ticket_t *Copy_pTkt, uint8 Copy_u8Free);

void TKT_Init(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < 6u; Local_u8Index++)
    {
        g_atTickets[Local_u8Index].id = 0u;
        g_atTickets[Local_u8Index].entrySec = 0u;
        g_atTickets[Local_u8Index].slotHint = 0u;
        g_atTickets[Local_u8Index].active = 0u;
    }

    g_u16NextId = 1u;
    g_u16TotalEntries = 0u;
}

void TKT_OnEntryAuthorized(void)
{
    uint8 Local_u8Row = TKT_FindFreeRow();

    if (Local_u8Row >= 6u)
    {






        return;
    }

    g_atTickets[Local_u8Row].id = g_u16NextId;
    g_atTickets[Local_u8Row].entrySec = RTC_Seconds();
    g_atTickets[Local_u8Row].slotHint = TKT_FindNearestFreeSlot();
    g_atTickets[Local_u8Row].active = 1u;


    g_u16NextId = (uint16)((g_u16NextId >= 9999u)
                          ? 1u
                          : (uint16)(g_u16NextId + 1u));

    g_u16TotalEntries++;

    TKT_PrintEntryFrame(&g_atTickets[Local_u8Row], LOT_GetFree());
}

STD_ReturnType TKT_CloseOldest(uint16 *Copy_pu16Id, uint32 *Copy_pu32EntrySec)
{
    uint8 Local_u8Index;
    uint8 Local_u8OldestRow = 6u;
    uint32 Local_u32OldestSec = 0xFFFFFFFFUL;

    if ((Copy_pu16Id == 0) || (Copy_pu32EntrySec == 0))
    {
        return 1u;
    }

    for (Local_u8Index = 0u; Local_u8Index < 6u; Local_u8Index++)
    {
        if ((g_atTickets[Local_u8Index].active != 0u) &&
            (g_atTickets[Local_u8Index].entrySec < Local_u32OldestSec))
        {
            Local_u32OldestSec = g_atTickets[Local_u8Index].entrySec;
            Local_u8OldestRow = Local_u8Index;
        }
    }

    if (Local_u8OldestRow >= 6u)
    {
        return 1u;
    }

    *Copy_pu16Id = g_atTickets[Local_u8OldestRow].id;
    *Copy_pu32EntrySec = g_atTickets[Local_u8OldestRow].entrySec;

    g_atTickets[Local_u8OldestRow].active = 0u;

    return 0u;
}

const Ticket_t *TKT_Find(uint16 Copy_u16Id)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < 6u; Local_u8Index++)
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

    for (Local_u8Index = 0u; Local_u8Index < 6u; Local_u8Index++)
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



static uint8 TKT_FindFreeRow(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < 6u; Local_u8Index++)
    {
        if (g_atTickets[Local_u8Index].active == 0u)
        {
            return Local_u8Index;
        }
    }

    return 6u;
}


static uint8 TKT_FindNearestFreeSlot(void)
{
    uint8 Local_u8Map = SLOT_GetMap();
    uint8 Local_u8Slot;

    for (Local_u8Slot = 0u; Local_u8Slot < 6u; Local_u8Slot++)
    {
        if ((Local_u8Map & (uint8)(1u << Local_u8Slot)) == 0u)
        {
            return (uint8)(Local_u8Slot + 1u);
        }
    }

    return 0u;
}

static void TKT_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf)
{
    Copy_pcBuf[0] = (char)('0' + (uint8)((Copy_u16Id / 1000u) % 10u));
    Copy_pcBuf[1] = (char)('0' + (uint8)((Copy_u16Id / 100u) % 10u));
    Copy_pcBuf[2] = (char)('0' + (uint8)((Copy_u16Id / 10u) % 10u));
    Copy_pcBuf[3] = (char)('0' + (uint8)( Copy_u16Id % 10u));
    Copy_pcBuf[4] = '\0';
}


static void TKT_PrintEntryFrame(const Ticket_t *Copy_pTkt, uint8 Copy_u8Free)
{
    char Local_acId[5];
    char Local_acTime[10];

    TKT_FormatId(Copy_pTkt->id, Local_acId);

    if (RTC_Format(Copy_pTkt->entrySec,
                   Local_acTime,
                   (uint8)sizeof(Local_acTime)) != 0u)
    {



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
# 240 "APP/ticketing/ticketing.c"
static void TKT_AppendUint32(char *Copy_pcBuf, uint8 *Copy_pu8Pos, uint32 Copy_u32Value)
{
    char Local_acTmp[10];
    uint8 Local_u8Count = 0u;
    uint8 Local_u8i;

    if (Copy_u32Value == 0u)
    {
        Copy_pcBuf[*Copy_pu8Pos] = '0';
        (*Copy_pu8Pos)++;
        return;
    }

    while (Copy_u32Value > 0u)
    {
        Local_acTmp[Local_u8Count] = (char)('0' + (Copy_u32Value % 10u));
        Local_u8Count++;
        Copy_u32Value /= 10u;
    }

    for (Local_u8i = Local_u8Count; Local_u8i > 0u; Local_u8i--)
    {
        Copy_pcBuf[*Copy_pu8Pos] = Local_acTmp[Local_u8i - 1u];
        (*Copy_pu8Pos)++;
    }
}


void TKT_PrintOpenTickets(void)
{
    char Local_acLine[24];
    uint8 Local_u8Pos;
    uint8 Local_u8i;

    for (Local_u8i = 0u; Local_u8i < 6u; Local_u8i++)
    {
        if (g_atTickets[Local_u8i].active == 0u)
        {
            continue;
        }

        Local_u8Pos = 0u;
        Local_acLine[Local_u8Pos++] = 'T';
        Local_acLine[Local_u8Pos++] = 'K';
        Local_acLine[Local_u8Pos++] = 'T';
        Local_acLine[Local_u8Pos++] = ',';

        TKT_AppendUint32(Local_acLine, &Local_u8Pos, (uint32)g_atTickets[Local_u8i].id);
        Local_acLine[Local_u8Pos++] = ',';

        TKT_AppendUint32(Local_acLine, &Local_u8Pos, g_atTickets[Local_u8i].entrySec);
        Local_acLine[Local_u8Pos++] = ',';

        TKT_AppendUint32(Local_acLine, &Local_u8Pos, (uint32)g_atTickets[Local_u8i].slotHint);

        Local_acLine[Local_u8Pos++] = '\r';
        Local_acLine[Local_u8Pos++] = '\n';
        Local_acLine[Local_u8Pos] = '\0';

        (void)USART_SendString((const uint8 *)Local_acLine);
    }
}




void TKT_ClearStats(void)
{
    g_u16TotalEntries = 0u;
}
