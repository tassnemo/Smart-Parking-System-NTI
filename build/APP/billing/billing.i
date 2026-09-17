# 0 "APP/billing/billing.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/billing/billing.c"
# 1 "APP/billing/billing.h" 1



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
# 5 "APP/billing/billing.h" 2
# 20 "APP/billing/billing.h"
void BIL_OnExitAuthorized(void);



uint16 BIL_GetTotalRevenue(void);
uint16 BIL_GetTotalExits(void);



void BIL_ClearStats(void);
# 2 "APP/billing/billing.c" 2
# 1 "./APP/ticketing/ticketing.h" 1




# 1 "APP/config.h" 1
# 6 "./APP/ticketing/ticketing.h" 2


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
# 3 "APP/billing/billing.c" 2
# 1 "LIB/softrtc.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/softrtc.h" 2

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
        char *Copy_pcBuf,
        uint8 Copy_u8BufSize);
# 4 "APP/billing/billing.c" 2
# 1 "MCAL/usart/usart_interface.h" 1





STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 5 "APP/billing/billing.c" 2
# 17 "APP/billing/billing.c"
static uint16 g_u16TotalRevenue = 0u;
static uint16 g_u16TotalExits = 0u;

static void BIL_FormatUint16(uint16 Copy_u16Value, char *Copy_pcBuf);
static void BIL_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf);
static void BIL_PrintReceipt(uint16 Copy_u16Id,
                              uint32 Copy_u32EntrySec,
                              uint32 Copy_u32ExitSec,
                              uint16 Copy_u16DwellMin,
                              uint16 Copy_u16Hours,
                              uint16 Copy_u16Fee);

void BIL_OnExitAuthorized(void)
{
    uint16 Local_u16Id;
    uint32 Local_u32EntrySec;
    uint32 Local_u32ExitSec;
    uint32 Local_u32DwellSec;
    uint16 Local_u16DwellMin;
    uint16 Local_u16ChargeableMin;
    uint16 Local_u16Hours;
    uint16 Local_u16Fee;
    uint32 Local_u32Sum;

    if (TKT_CloseOldest(&Local_u16Id, &Local_u32EntrySec) != 0u)
    {







        return;
    }

    Local_u32ExitSec = RTC_Seconds();



    Local_u32DwellSec = (Local_u32ExitSec >= Local_u32EntrySec)
                       ? (Local_u32ExitSec - Local_u32EntrySec)
                       : 0UL;

    Local_u16DwellMin = (uint16)(Local_u32DwellSec / 60UL);


    Local_u16ChargeableMin = (Local_u16DwellMin > 15u)
                            ? (uint16)(Local_u16DwellMin - 15u)
                            : 0u;



    Local_u16Hours = (uint16)((Local_u16ChargeableMin + 59u) / 60u);
   uint32 Local_u32Fee;

  Local_u32Fee = (uint32)Local_u16Hours * (uint32)10u;

if (Local_u32Fee > 120u)
{
    Local_u32Fee = 120u;
}

Local_u16Fee = (uint16)Local_u32Fee;


    Local_u32Sum = (uint32)g_u16TotalRevenue + (uint32)Local_u16Fee;
    g_u16TotalRevenue = (Local_u32Sum > 0xFFFFUL) ? 0xFFFFu : (uint16)Local_u32Sum;

    g_u16TotalExits++;

    BIL_PrintReceipt(Local_u16Id,
                      Local_u32EntrySec,
                      Local_u32ExitSec,
                      Local_u16DwellMin,
                      Local_u16Hours,
                      Local_u16Fee);
}

uint16 BIL_GetTotalRevenue(void)
{
    return g_u16TotalRevenue;
}

uint16 BIL_GetTotalExits(void)
{
    return g_u16TotalExits;
}

void BIL_ClearStats(void)
{
    g_u16TotalRevenue = 0u;
    g_u16TotalExits = 0u;
}





static void BIL_FormatUint16(uint16 Copy_u16Value, char *Copy_pcBuf)
{
    char Local_acTmp[6];
    uint8 Local_u8Count = 0u;
    uint8 Local_u8Index;

    if (Copy_u16Value == 0u)
    {
        Local_acTmp[Local_u8Count] = '0';
        Local_u8Count++;
    }
    else
    {
        while (Copy_u16Value > 0u)
        {
            Local_acTmp[Local_u8Count] = (char)('0' + (Copy_u16Value % 10u));
            Local_u8Count++;
            Copy_u16Value = (uint16)(Copy_u16Value / 10u);
        }
    }

    for (Local_u8Index = 0u; Local_u8Index < Local_u8Count; Local_u8Index++)
    {
        Copy_pcBuf[Local_u8Index] = Local_acTmp[Local_u8Count - 1u - Local_u8Index];
    }

    Copy_pcBuf[Local_u8Count] = '\0';
}



static void BIL_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf)
{
    Copy_pcBuf[0] = (char)('0' + (uint8)((Copy_u16Id / 1000u) % 10u));
    Copy_pcBuf[1] = (char)('0' + (uint8)((Copy_u16Id / 100u) % 10u));
    Copy_pcBuf[2] = (char)('0' + (uint8)((Copy_u16Id / 10u) % 10u));
    Copy_pcBuf[3] = (char)('0' + (uint8)( Copy_u16Id % 10u));
    Copy_pcBuf[4] = '\0';
}


static void BIL_PrintReceipt(uint16 Copy_u16Id,
                              uint32 Copy_u32EntrySec,
                              uint32 Copy_u32ExitSec,
                              uint16 Copy_u16DwellMin,
                              uint16 Copy_u16Hours,
                              uint16 Copy_u16Fee)
{
    char Local_acId[5];
    char Local_acIn[10];
    char Local_acOut[10];
    char Local_acNum[6];

    BIL_FormatId(Copy_u16Id, Local_acId);

    if (RTC_Format(Copy_u32EntrySec, Local_acIn, (uint8)sizeof(Local_acIn)) != 0u)
    {
        Local_acIn[0] = '\0';
    }

    if (RTC_Format(Copy_u32ExitSec, Local_acOut, (uint8)sizeof(Local_acOut)) != 0u)
    {
        Local_acOut[0] = '\0';
    }

    (void)USART_SendString((const uint8 *)"===== RECEIPT =====\r\n");

    (void)USART_SendString((const uint8 *)"ID    : ");
    (void)USART_SendString((const uint8 *)Local_acId);

    (void)USART_SendString((const uint8 *)"\r\nIN    : ");
    (void)USART_SendString((const uint8 *)Local_acIn);

    (void)USART_SendString((const uint8 *)"\r\nOUT   : ");
    (void)USART_SendString((const uint8 *)Local_acOut);

    BIL_FormatUint16(Copy_u16DwellMin, Local_acNum);
    (void)USART_SendString((const uint8 *)"\r\nDWELL : ");
    (void)USART_SendString((const uint8 *)Local_acNum);
    (void)USART_SendString((const uint8 *)" min");

    BIL_FormatUint16((uint16)15u, Local_acNum);
    (void)USART_SendString((const uint8 *)"\r\nGRACE : ");
    (void)USART_SendString((const uint8 *)Local_acNum);
    (void)USART_SendString((const uint8 *)" min");

    BIL_FormatUint16(Copy_u16Hours, Local_acNum);
    (void)USART_SendString((const uint8 *)"\r\nHOURS : ");
    (void)USART_SendString((const uint8 *)Local_acNum);

    BIL_FormatUint16(Copy_u16Fee, Local_acNum);
    (void)USART_SendString((const uint8 *)"\r\nFEE   : ");
    (void)USART_SendString((const uint8 *)Local_acNum);

    (void)USART_SendString((const uint8 *)"\r\n===================\r\n");
}
