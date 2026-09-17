#include "console.h"
#include "APP/lot/lot_fsm.h"
#include "APP/billing/billing.h"
#include "APP/telemetry/telemetry.h"
#include "HAL/barrier/barrier.h"
#include "HAL/slots/slots.h"
#include "APP/ticketing/ticketing.h"
#include "MCAL/pwm/pwm_interface.h"
#include "MCAL/usart/usart_interface.h"
#include "config.h"
#include <string.h>


extern void  TKT_PrintOpenTickets(void);      /* TODO: add to ticketing.c */
extern uint8 LOT_GetPeakOccupancy(void);      /* TODO: add to lot_fsm.c   */
extern void  TKT_ClearStats(void);            /* TODO: add to ticketing.c */
extern uint16 TKT_GetTotalEntries(void);      /* already exists           */

/* ---- Live-tunable settings, defaults from config.h. See console.h's
   header comment -- a future config.c can wrap these for persistence
   without changing anything that calls the getters below. ---- */
static uint8 g_u8Tariff      = TARIFF_DEFAULT;
static uint8 g_u8Grace       = GRACE_DEFAULT_MINUTES;
static uint8 g_u8Hold        = GATE_HOLD_DEFAULT_SEC;
static uint8 g_u8Timeout     = PASS_TIMEOUT_DEFAULT_SEC;
static uint8 g_u8LightThresh = LIGHT_THRESHOLD_DEFAULT;

typedef void (*ConsoleHandler_t)(const char *Copy_pcArgs);

typedef struct
{
    const char       *name;
    ConsoleHandler_t   handler;
} ConsoleCmd_t;

/* ---------------- small helpers (no sprintf, matches telemetry.c's style) ---------------- */

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

/* Case-insensitive compare of the FIRST strlen(pattern) chars of str
   against pattern. Used to match a command word regardless of what
   (if anything) follows it in the line. */
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
    /* Whole pattern matched -- the char right after must be a space or
       end of string, so "SETX" never matches pattern "SET". */
    return ((*Copy_pcStr == '\0') || (*Copy_pcStr == ' ')) ? 1u : 0u;
}

/* Skip the first word of args (the sub-command already dispatched by the
   caller) and return a pointer to whatever comes after it, trimmed. */
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

/* Parses a decimal uint16 from the start of str. Returns E_NOK if str is
   empty or contains a non-digit before any digit is read. */
static STD_ReturnType CONSOLE_ParseUint(const char *Copy_pcStr, uint16 *Copy_pu16Out)
{
    uint16 Local_u16Value = 0u;
    uint8  Local_u8AnyDigit = 0u;

    while ((*Copy_pcStr >= '0') && (*Copy_pcStr <= '9'))
    {
        Local_u16Value = (uint16)((Local_u16Value * 10u) + (uint16)(*Copy_pcStr - '0'));
        Local_u8AnyDigit = 1u;
        Copy_pcStr++;
    }

    if (Local_u8AnyDigit == 0u)
    {
        return E_NOK;
    }

    *Copy_pu16Out = Local_u16Value;
    return E_OK;
}

static void CONSOLE_AppendUint(char *Copy_pcBuf, uint8 *Copy_pu8Pos, uint16 Copy_u16Value)
{
    char  Local_acTmp[6];
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

/* ---------------- command handlers ---------------- */

static void CONSOLE_Handle_Status(const char *Copy_pcArgs)
{
    char Local_acFrame[TELEM_FRAME_MAX_LEN];
    (void)Copy_pcArgs;

    if (TELEM_BuildFrame(Local_acFrame) == E_OK)
    {
        (void)USART_SendString((const uint8 *)Local_acFrame);
    }
}

static void CONSOLE_Handle_Slots(const char *Copy_pcArgs)
{
    uint8 Local_u8Map;
    char  Local_acLine[16];
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

    /* §18.2: "slot 1 leftmost" -- slot 1 is bit 0, so print from bit 5 down to bit 0 */
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
    char  Local_acLine[10];
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
    /* TODO: ticketing.c does not yet expose a way to iterate open tickets
       without reaching into its private array (which would break the
       layer rule). TKT_PrintOpenTickets() must be added there -- see the
       contract comment at the top of this file. Calling it here now so
       the console command exists end-to-end the moment that function is
       written; until then this will fail to link. */
    TKT_PrintOpenTickets();
}

static void CONSOLE_Handle_Stats(const char *Copy_pcArgs)
{
    char  Local_acLine[32];
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
    /* TODO: LOT_GetPeakOccupancy() must be added to lot_fsm.c -- see the
       contract comment at the top of this file. Calling it now so this
       command is complete the moment that function exists. */
    CONSOLE_AppendUint(Local_acLine, &Local_u8Pos, LOT_GetPeakOccupancy());
    Local_acLine[Local_u8Pos] = '\0';

    CONSOLE_SendLine(Local_acLine);
}

/* Shared body for all five "SET <NAME> <n>" commands -- range-checks and
   stores Copy_u16Value into *Copy_pu8Target if it fits in [min,max]. */
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
    uint16      Local_u16Value;

    if (CONSOLE_MatchWord(Copy_pcArgs, "TARIFF"))
    {
        Local_pcRest = CONSOLE_SkipWord(Copy_pcArgs);
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != E_OK)
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
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != E_OK)
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
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != E_OK)
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
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != E_OK)
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
        if (CONSOLE_ParseUint(Local_pcRest, &Local_u16Value) != E_OK)
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
        BAR_Open(PWM_CH_ENTRY);
        CONSOLE_SendLine("OK");
        return;
    }
    if (CONSOLE_MatchWord(Copy_pcArgs, "OUT"))
    {
        BAR_Open(PWM_CH_EXIT);
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
        BAR_Close(PWM_CH_ENTRY);
        CONSOLE_SendLine("OK");
        return;
    }
    if (CONSOLE_MatchWord(Copy_pcArgs, "OUT"))
    {
        BAR_Close(PWM_CH_EXIT);
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
    /* TODO: TKT_ClearStats() must be added to ticketing.c -- §18.2 says
       CLRSTATS zeroes totals but NOT nextTicketId, so this must reset
       totalEntries specifically, not the whole ticket table. See the
       contract comment at the top of this file. */
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

/* ---------------- dispatch table ---------------- */

static const ConsoleCmd_t CONSOLE_Commands[] =
{
    { "STATUS",   CONSOLE_Handle_Status   },
    { "SLOTS?",   CONSOLE_Handle_Slots    },
    { "FREE?",    CONSOLE_Handle_Free     },
    { "TICKETS?", CONSOLE_Handle_Tickets  },
    { "STATS?",   CONSOLE_Handle_Stats    },
    { "SET",      CONSOLE_Handle_Set      },
    { "OPEN",     CONSOLE_Handle_Open     },
    { "CLOSE",    CONSOLE_Handle_Close    },
    { "MAINT",    CONSOLE_Handle_Maint    },
    { "CLRSTATS", CONSOLE_Handle_ClrStats },
    { "HELP",     CONSOLE_Handle_Help     }
};

#define CONSOLE_NUM_COMMANDS (sizeof(CONSOLE_Commands) / sizeof(CONSOLE_Commands[0]))

/* ---------------- public API ---------------- */

STD_ReturnType CONSOLE_Init(void)
{
    g_u8Tariff      = TARIFF_DEFAULT;
    g_u8Grace       = GRACE_DEFAULT_MINUTES;
    g_u8Hold        = GATE_HOLD_DEFAULT_SEC;
    g_u8Timeout     = PASS_TIMEOUT_DEFAULT_SEC;
    g_u8LightThresh = LIGHT_THRESHOLD_DEFAULT;

    return E_OK;
}

STD_ReturnType CONSOLE_ParseLine(const char *Copy_pcLine)
{
    uint8 Local_u8Index;
    uint8 Local_u8Len;

    if (Copy_pcLine == NULL)
    {
        return E_NOK;
    }

    Local_u8Len = (uint8)strlen(Copy_pcLine);
    if (Local_u8Len > CONSOLE_MAX_LINE_LEN)
    {
        CONSOLE_SendLine("ERR LONG");
        return E_OK;
    }

    for (Local_u8Index = 0u; Local_u8Index < CONSOLE_NUM_COMMANDS; Local_u8Index++)
    {
        if (CONSOLE_MatchWord(Copy_pcLine, CONSOLE_Commands[Local_u8Index].name))
        {
            const char *Local_pcArgs = CONSOLE_SkipWord(Copy_pcLine);
            CONSOLE_Commands[Local_u8Index].handler(Local_pcArgs);
            return E_OK;
        }
    }

    CONSOLE_SendLine("ERR CMD");
    return E_OK;
}

/* ---------------- getters used by billing.c and elsewhere ---------------- */

uint8 CONSOLE_GetTariff(void)      { return g_u8Tariff;      }
uint8 CONSOLE_GetGrace(void)       { return g_u8Grace;       }
uint8 CONSOLE_GetHold(void)        { return g_u8Hold;        }
uint8 CONSOLE_GetTimeout(void)     { return g_u8Timeout;     }
uint8 CONSOLE_GetLightThresh(void) { return g_u8LightThresh; }