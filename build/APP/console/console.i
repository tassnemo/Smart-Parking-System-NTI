# 0 "APP/console/console.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/console/console.c"
# 1 "APP/console/console.h" 1



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
# 5 "APP/console/console.h" 2
# 23 "APP/console/console.h"
STD_ReturnType CONSOLE_Init(void);
STD_ReturnType CONSOLE_ParseLine(const char *Copy_pcLine);


uint8 CONSOLE_GetTariff(void);
uint8 CONSOLE_GetGrace(void);
uint8 CONSOLE_GetHold(void);
uint8 CONSOLE_GetTimeout(void);
uint8 CONSOLE_GetLightThresh(void);
# 2 "APP/console/console.c" 2
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
# 3 "APP/console/console.c" 2
# 1 "./APP/billing/billing.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "./APP/billing/billing.h" 2
# 20 "./APP/billing/billing.h"
void BIL_OnExitAuthorized(void);



uint16 BIL_GetTotalRevenue(void);
uint16 BIL_GetTotalExits(void);



void BIL_ClearStats(void);
# 4 "APP/console/console.c" 2
# 1 "./APP/telemetry/telemetry.h" 1
# 23 "./APP/telemetry/telemetry.h"
STD_ReturnType TELEM_BuildFrame(char *Copy_pu8Buf);




STD_ReturnType TELEM_Send(void);
# 5 "APP/console/console.c" 2
# 1 "./HAL/barrier/barrier.h" 1





STD_ReturnType BAR_Init(uint8 Copy_u8Channel);
STD_ReturnType BAR_Open(uint8 Copy_u8Channel);
STD_ReturnType BAR_Close(uint8 Copy_u8Channel);
STD_ReturnType BAR_IsMoving(uint8 Copy_u8Channel, uint8 *Copy_pu8Status);
# 6 "APP/console/console.c" 2
# 1 "./HAL/slots/slots.h" 1
# 20 "./HAL/slots/slots.h"
STD_ReturnType SLOT_Init(void);



STD_ReturnType SLOT_Poll(void);


uint8 SLOT_GetMap(void);



uint8 SLOT_CountFree(void);
# 7 "APP/console/console.c" 2
# 1 "./APP/ticketing/ticketing.h" 1







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
# 8 "APP/console/console.c" 2
# 1 "./MCAL/pwm/pwm_interface.h" 1
# 22 "./MCAL/pwm/pwm_interface.h"
STD_ReturnType PWM_Init(void);







STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel, uint16 Copy_u16PulseUs);
# 9 "APP/console/console.c" 2
# 1 "./MCAL/usart/usart_interface.h" 1





STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 10 "APP/console/console.c" 2

# 1 "C:/avr-gcc/avr/include/string.h" 1 3
# 46 "C:/avr-gcc/avr/include/string.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 1 3 4
# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4

# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 47 "C:/avr-gcc/avr/include/string.h" 2 3
# 125 "C:/avr-gcc/avr/include/string.h" 3
extern int ffs(int __val) __attribute__((__const__));





extern int ffsl(long __val) __attribute__((__const__));





__extension__ extern int ffsll(long long __val) __attribute__((__const__));
# 150 "C:/avr-gcc/avr/include/string.h" 3
extern void *memccpy(void *, const void *, int, size_t);
# 162 "C:/avr-gcc/avr/include/string.h" 3
extern void *memchr(const void *, int, size_t) __attribute__((__pure__));
# 180 "C:/avr-gcc/avr/include/string.h" 3
extern int memcmp(const void *, const void *, size_t) __attribute__((__pure__));
# 191 "C:/avr-gcc/avr/include/string.h" 3
extern void *memcpy(void *, const void *, size_t);
# 203 "C:/avr-gcc/avr/include/string.h" 3
extern void *memmem(const void *, size_t, const void *, size_t) __attribute__((__pure__));
# 213 "C:/avr-gcc/avr/include/string.h" 3
extern void *memmove(void *, const void *, size_t);
# 225 "C:/avr-gcc/avr/include/string.h" 3
extern void *memrchr(const void *, int, size_t) __attribute__((__pure__));
# 235 "C:/avr-gcc/avr/include/string.h" 3
extern void *memset(void *, int, size_t);
# 248 "C:/avr-gcc/avr/include/string.h" 3
extern char *strcat(char *, const char *);
# 260 "C:/avr-gcc/avr/include/string.h" 3
extern char *strchr(const char *, int) __attribute__((__pure__));
# 272 "C:/avr-gcc/avr/include/string.h" 3
extern char *strchrnul(const char *, int) __attribute__((__pure__));
# 285 "C:/avr-gcc/avr/include/string.h" 3
extern int strcmp(const char *, const char *) __attribute__((__pure__));
# 303 "C:/avr-gcc/avr/include/string.h" 3
extern char *strcpy(char *, const char *);
# 318 "C:/avr-gcc/avr/include/string.h" 3
extern int strcasecmp(const char *, const char *) __attribute__((__pure__));
# 331 "C:/avr-gcc/avr/include/string.h" 3
extern char *strcasestr(const char *, const char *) __attribute__((__pure__));
# 342 "C:/avr-gcc/avr/include/string.h" 3
extern size_t strcspn(const char *__s, const char *__reject) __attribute__((__pure__));
# 362 "C:/avr-gcc/avr/include/string.h" 3
extern char *strdup(const char *s1);
# 378 "C:/avr-gcc/avr/include/string.h" 3
extern char *strndup(const char *s, size_t n);
# 391 "C:/avr-gcc/avr/include/string.h" 3
extern size_t strlcat(char *, const char *, size_t);
# 402 "C:/avr-gcc/avr/include/string.h" 3
extern size_t strlcpy(char *, const char *, size_t);
# 413 "C:/avr-gcc/avr/include/string.h" 3
extern size_t strlen(const char *) __attribute__((__pure__));
# 425 "C:/avr-gcc/avr/include/string.h" 3
extern char *strlwr(char *);
# 436 "C:/avr-gcc/avr/include/string.h" 3
extern char *strncat(char *, const char *, size_t);
# 448 "C:/avr-gcc/avr/include/string.h" 3
extern int strncmp(const char *, const char *, size_t) __attribute__((__pure__));
# 463 "C:/avr-gcc/avr/include/string.h" 3
extern char *strncpy(char *, const char *, size_t);
# 478 "C:/avr-gcc/avr/include/string.h" 3
extern int strncasecmp(const char *, const char *, size_t) __attribute__((__pure__));
# 492 "C:/avr-gcc/avr/include/string.h" 3
extern size_t strnlen(const char *, size_t) __attribute__((__pure__));
# 505 "C:/avr-gcc/avr/include/string.h" 3
extern char *strpbrk(const char *__s, const char *__accept) __attribute__((__pure__));
# 519 "C:/avr-gcc/avr/include/string.h" 3
extern char *strrchr(const char *, int) __attribute__((__pure__));
# 529 "C:/avr-gcc/avr/include/string.h" 3
extern char *strrev(char *);
# 547 "C:/avr-gcc/avr/include/string.h" 3
extern char *strsep(char **, const char *);
# 558 "C:/avr-gcc/avr/include/string.h" 3
extern size_t strspn(const char *__s, const char *__accept) __attribute__((__pure__));
# 571 "C:/avr-gcc/avr/include/string.h" 3
extern char *strstr(const char *, const char *) __attribute__((__pure__));
# 590 "C:/avr-gcc/avr/include/string.h" 3
extern char *strtok(char *, const char *);
# 607 "C:/avr-gcc/avr/include/string.h" 3
extern char *strtok_r(char *, const char *, char **);
# 620 "C:/avr-gcc/avr/include/string.h" 3
extern char *strupr(char *);



extern int strcoll(const char *s1, const char *s2);
extern char *strerror(int errnum);
extern size_t strxfrm(char *dest, const char *src, size_t n);
# 12 "APP/console/console.c" 2



# 14 "APP/console/console.c"
extern void TKT_PrintOpenTickets(void);
extern uint8 LOT_GetPeakOccupancy(void);
extern void TKT_ClearStats(void);
extern uint16 TKT_GetTotalEntries(void);




static uint8 g_u8Tariff = 10u;
static uint8 g_u8Grace = 15u;
static uint8 g_u8Hold = 5u;
static uint8 g_u8Timeout = 20u;
static uint8 g_u8LightThresh = 30u;

typedef void (*ConsoleHandler_t)(const char *Copy_pcArgs);

typedef struct
{
    const char *name;
    ConsoleHandler_t handler;
} ConsoleCmd_t;



static void CONSOLE_SendLine(const char *Copy_pcStr)
{
    (void)USART_SendString((const uint8 *)Copy_pcStr);
    (void)USART_SendString((const uint8 *)"\r\n");
}

static uint8 CONSOLE_CharUpper(char c)
{
    if ((c >= 'a') && (c <= 'z'))
    {
        return (uint8)(c - 'a' + 'A');
    }
    return (uint8)c;
}




static uint8 CONSOLE_MatchWord(const char *Copy_pcStr, const char *Copy_pcPattern)
{
    while (*Copy_pcPattern != '\0')
    {
        if (*Copy_pcStr == '\0')
        {
            return 0u;
        }
        if (CONSOLE_CharUpper(*Copy_pcStr) != CONSOLE_CharUpper(*Copy_pcPattern))
        {
            return 0u;
        }
        Copy_pcStr++;
        Copy_pcPattern++;
    }


    return ((*Copy_pcStr == '\0') || (*Copy_pcStr == ' ')) ? 1u : 0u;
}



static const char *CONSOLE_SkipWord(const char *Copy_pcStr)
{
    while ((*Copy_pcStr != '\0') && (*Copy_pcStr != ' '))
    {
        Copy_pcStr++;
    }
    while (*Copy_pcStr == ' ')
    {
        Copy_pcStr++;
    }
    return Copy_pcStr;
}



static STD_ReturnType CONSOLE_ParseUint(const char *Copy_pcStr, uint16 *Copy_pu16Out)
{
    uint16 Local_u16Value = 0u;
    uint8 Local_u8AnyDigit = 0u;

    while ((*Copy_pcStr >= '0') && (*Copy_pcStr <= '9'))
    {
        Local_u16Value = (uint16)((Local_u16Value * 10u) + (uint16)(*Copy_pcStr - '0'));
        Local_u8AnyDigit = 1u;
        Copy_pcStr++;
    }

    if (Local_u8AnyDigit == 0u)
    {
        return 1u;
    }

    *Copy_pu16Out = Local_u16Value;
    return 0u;
}

static void CONSOLE_AppendUint(char *Copy_pcBuf, uint8 *Copy_pu8Pos, uint16 Copy_u16Value)
{
    char Local_acTmp[6];
    uint8 Local_u8Count = 0u;
    uint8 Local_u8i;

    if (Copy_u16Value == 0u)
    {
        Copy_pcBuf[*Copy_pu8Pos] = '0';
        (*Copy_pu8Pos)++;
        return;
    }

    while (Copy_u16Value > 0u)
    {
        Local_acTmp[Local_u8Count] = (char)('0' + (Copy_u16Value % 10u));
        Local_u8Count++;
        Copy_u16Value = (uint16)(Copy_u16Value / 10u);
    }

    for (Local_u8i = Local_u8Count; Local_u8i > 0u; Local_u8i--)
    {
        Copy_pcBuf[*Copy_pu8Pos] = Local_acTmp[Local_u8i - 1u];
        (*Copy_pu8Pos)++;
    }
}



static void CONSOLE_Handle_Status(const char *Copy_pcArgs)
{
    char Local_acFrame[64u];
    (void)Copy_pcArgs;

    if (TELEM_BuildFrame(Local_acFrame) == 0u)
    {
        (void)USART_SendString((const uint8 *)Local_acFrame);
    }
}

static void CONSOLE_Handle_Slots(const char *Copy_pcArgs)
{
    uint8 Local_u8Map;
    char Local_acLine[16];
    uint8 Local_u8Pos = 0u;
    sint8 Local_s8Bit;
    (void)Copy_pcArgs;

    Local_u8Map = SLOT_GetMap();

    Local_acLine[Local_u8Pos++] = 'S';
    Local_acLine[Local_u8Pos++] = 'L';
    Local_acLine[Local_u8Pos++] = 'O';
    Local_acLine[Local_u8Pos++] = 'T';
    Local_acLine[Local_u8Pos++] = 'S';
    Local_acLine[Local_u8Pos++] = '=';


    for (Local_s8Bit = 5; Local_s8Bit >= 0; Local_s8Bit--)
    {
        Local_acLine[Local_u8Pos++] = ((Local_u8Map & (uint8)(1u << Local_s8Bit)) != 0u)
                                     ? '1' : '0';
    }
    Local_acLine[Local_u8Pos] = '\0';

    CONSOLE_SendLine(Local_acLine);
}

static void CONSOLE_Handle_Free(const char *Copy_pcArgs)
{
    char Local_acLine[10];
    uint8 Local_u8Pos = 0u;
    (void)Copy_pcArgs;

    Local_acLine[Local_u8Pos++] = 'F';
    Local_acLine[Local_u8Pos++] = 'R';
    Local_acLine[Local_u8Pos++] = 'E';
    Local_acLine[Local_u8Pos++] = 'E';
    Local_acLine[Local_u8Pos++] = '=';
    CONSOLE_AppendUint(Local_acLine, &Local_u8Pos, LOT_GetFree());
    Local_acLine[Local_u8Pos] = '\0';

    CONSOLE_SendLine(Local_acLine);
}

static void CONSOLE_Handle_Tickets(const char *Copy_pcArgs)
{
    (void)Copy_pcArgs;






    TKT_PrintOpenTickets();
}

static void CONSOLE_Handle_Stats(const char *Copy_pcArgs)
{
    char Local_acLine[32];
    uint8 Local_u8Pos = 0u;
    (void)Copy_pcArgs;

    Local_acLine[Local_u8Pos++] = 'S';
    Local_acLine[Local_u8Pos++] = 'T';
    Local_acLine[Local_u8Pos++] = 'A';
    Local_acLine[Local_u8Pos++] = 'T';
    Local_acLine[Local_u8Pos++] = 'S';
    Local_acLine[Local_u8Pos++] = '=';
    CONSOLE_AppendUint(Local_acLine, &Local_u8Pos, TKT_GetTotalEntries());
    Local_acLine[Local_u8Pos++] = ',';
    CONSOLE_AppendUint(Local_acLine, &Local_u8Pos, BIL_GetTotalExits());
    Local_acLine[Local_u8Pos++] = ',';
    CONSOLE_AppendUint(Local_acLine, &Local_u8Pos, BIL_GetTotalRevenue());
    Local_acLine[Local_u8Pos++] = ',';



    CONSOLE_AppendUint(Local_acLine, &Local_u8Pos, LOT_GetPeakOccupancy());
    Local_acLine[Local_u8Pos] = '\0';

    CONSOLE_SendLine(Local_acLine);
}



static void CONSOLE_ApplySetting(uint8 *Copy_pu8Target,
                                  uint16 Copy_u16Value,
                                  uint16 Copy_u16Min,
                                  uint16 Copy_u16Max)
{
    if ((Copy_u16Value < Copy_u16Min) || (Copy_u16Value > Copy_u16Max))
    {
        CONSOLE_SendLine("ERR RANGE");
        return;
    }

    *Copy_pu8Target = (uint8)Copy_u16Value;
    CONSOLE_SendLine("OK");
}

static void CONSOLE_Handle_Set(const char *Copy_pcArgs)
{
    const char *Local_pcRest;
    uint16 Local_u16Value;

    if (CONSOLE_MatchWord(Copy_pcArgs, "TARIFF"))
    {
        Local_pcRest = CONSOLE_SkipWord(Copy_pcArgs);
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != 0u)
        {
            CONSOLE_SendLine("ERR RANGE");
            return;
        }
        CONSOLE_ApplySetting(&g_u8Tariff, Local_u16Value, 1u, 100u);
        return;
    }

    if (CONSOLE_MatchWord(Copy_pcArgs, "GRACE"))
    {
        Local_pcRest = CONSOLE_SkipWord(Copy_pcArgs);
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != 0u)
        {
            CONSOLE_SendLine("ERR RANGE");
            return;
        }
        CONSOLE_ApplySetting(&g_u8Grace, Local_u16Value, 0u, 60u);
        return;
    }

    if (CONSOLE_MatchWord(Copy_pcArgs, "HOLD"))
    {
        Local_pcRest = CONSOLE_SkipWord(Copy_pcArgs);
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != 0u)
        {
            CONSOLE_SendLine("ERR RANGE");
            return;
        }
        CONSOLE_ApplySetting(&g_u8Hold, Local_u16Value, 2u, 15u);
        return;
    }

    if (CONSOLE_MatchWord(Copy_pcArgs, "TIMEOUT"))
    {
        Local_pcRest = CONSOLE_SkipWord(Copy_pcArgs);
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != 0u)
        {
            CONSOLE_SendLine("ERR RANGE");
            return;
        }
        CONSOLE_ApplySetting(&g_u8Timeout, Local_u16Value, 10u, 60u);
        return;
    }

    if (CONSOLE_MatchWord(Copy_pcArgs, "LIGHT"))
    {
        Local_pcRest = CONSOLE_SkipWord(Copy_pcArgs);
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != 0u)
        {
            CONSOLE_SendLine("ERR RANGE");
            return;
        }
        CONSOLE_ApplySetting(&g_u8LightThresh, Local_u16Value, 0u, 100u);
        return;
    }

    CONSOLE_SendLine("ERR CMD");
}

static void CONSOLE_Handle_Open(const char *Copy_pcArgs)
{
    if (LOT_GetState() != LOT_MAINTENANCE)
    {
        CONSOLE_SendLine("ERR MODE");
        return;
    }

    if (CONSOLE_MatchWord(Copy_pcArgs, "IN"))
    {
        BAR_Open(0u);
        CONSOLE_SendLine("OK");
        return;
    }
    if (CONSOLE_MatchWord(Copy_pcArgs, "OUT"))
    {
        BAR_Open(1u);
        CONSOLE_SendLine("OK");
        return;
    }

    CONSOLE_SendLine("ERR CMD");
}

static void CONSOLE_Handle_Close(const char *Copy_pcArgs)
{
    if (LOT_GetState() != LOT_MAINTENANCE)
    {
        CONSOLE_SendLine("ERR MODE");
        return;
    }

    if (CONSOLE_MatchWord(Copy_pcArgs, "IN"))
    {
        BAR_Close(0u);
        CONSOLE_SendLine("OK");
        return;
    }
    if (CONSOLE_MatchWord(Copy_pcArgs, "OUT"))
    {
        BAR_Close(1u);
        CONSOLE_SendLine("OK");
        return;
    }

    CONSOLE_SendLine("ERR CMD");
}

static void CONSOLE_Handle_Maint(const char *Copy_pcArgs)
{
    if (CONSOLE_MatchWord(Copy_pcArgs, "ON"))
    {
        LOT_SetMaintenance(1u);
        CONSOLE_SendLine("OK");
        return;
    }
    if (CONSOLE_MatchWord(Copy_pcArgs, "OFF"))
    {
        LOT_SetMaintenance(0u);
        CONSOLE_SendLine("OK");
        return;
    }

    CONSOLE_SendLine("ERR CMD");
}

static void CONSOLE_Handle_ClrStats(const char *Copy_pcArgs)
{
    (void)Copy_pcArgs;

    BIL_ClearStats();




    TKT_ClearStats();

    CONSOLE_SendLine("OK");
}

static void CONSOLE_Handle_Help(const char *Copy_pcArgs)
{
    (void)Copy_pcArgs;

    CONSOLE_SendLine("STATUS SLOTS? FREE? TICKETS? STATS?");
    CONSOLE_SendLine("SET TARIFF/GRACE/HOLD/TIMEOUT/LIGHT <n>");
    CONSOLE_SendLine("OPEN IN/OUT  CLOSE IN/OUT  (maintenance only)");
    CONSOLE_SendLine("MAINT ON/OFF  CLRSTATS  HELP");
}



static const ConsoleCmd_t CONSOLE_Commands[] =
{
    { "STATUS", CONSOLE_Handle_Status },
    { "SLOTS?", CONSOLE_Handle_Slots },
    { "FREE?", CONSOLE_Handle_Free },
    { "TICKETS?", CONSOLE_Handle_Tickets },
    { "STATS?", CONSOLE_Handle_Stats },
    { "SET", CONSOLE_Handle_Set },
    { "OPEN", CONSOLE_Handle_Open },
    { "CLOSE", CONSOLE_Handle_Close },
    { "MAINT", CONSOLE_Handle_Maint },
    { "CLRSTATS", CONSOLE_Handle_ClrStats },
    { "HELP", CONSOLE_Handle_Help }
};





STD_ReturnType CONSOLE_Init(void)
{
    g_u8Tariff = 10u;
    g_u8Grace = 15u;
    g_u8Hold = 5u;
    g_u8Timeout = 20u;
    g_u8LightThresh = 30u;

    return 0u;
}

STD_ReturnType CONSOLE_ParseLine(const char *Copy_pcLine)
{
    uint8 Local_u8Index;
    uint8 Local_u8Len;

    if (Copy_pcLine == 
# 450 "APP/console/console.c" 3 4
                      ((void *)0)
# 450 "APP/console/console.c"
                          )
    {
        return 1u;
    }

    Local_u8Len = (uint8)strlen(Copy_pcLine);
    if (Local_u8Len > 24u)
    {
        CONSOLE_SendLine("ERR LONG");
        return 0u;
    }

    for (Local_u8Index = 0u; Local_u8Index < (sizeof(CONSOLE_Commands) / sizeof(CONSOLE_Commands[0])); Local_u8Index++)
    {
        if (CONSOLE_MatchWord(Copy_pcLine, CONSOLE_Commands[Local_u8Index].name))
        {
            const char *Local_pcArgs = CONSOLE_SkipWord(Copy_pcLine);
            CONSOLE_Commands[Local_u8Index].handler(Local_pcArgs);
            return 0u;
        }
    }

    CONSOLE_SendLine("ERR CMD");
    return 0u;
}



uint8 CONSOLE_GetTariff(void) { return g_u8Tariff; }
uint8 CONSOLE_GetGrace(void) { return g_u8Grace; }
uint8 CONSOLE_GetHold(void) { return g_u8Hold; }
uint8 CONSOLE_GetTimeout(void) { return g_u8Timeout; }
uint8 CONSOLE_GetLightThresh(void) { return g_u8LightThresh; }
