#include "billing.h"
#include "APP/ticketing/ticketing.h"
#include "softrtc.h"
#include "usart_interface.h"
#include "config.h"

/* ----------------------------------------------------------------------------
 * NOTE for later: TARIFF_DEFAULT / GRACE_DEFAULT_MINUTES are compile-time
 * constants from config.h. Once console.c owns a live-tunable tariff/grace
 * (SET TARIFF / SET GRACE), replace these two reads with calls into
 * console.c's getters so a runtime change actually affects the next fee
 * calculated - right now, like lane_fsm.c's own GATE_HOLD_TICKS, this reads
 * the compiled-in default every time. Flagging so it isn't mistaken for
 * "SET TARIFF has no effect" once console exists.
 * --------------------------------------------------------------------------*/

static uint16 g_u16TotalRevenue = 0u;
static uint16 g_u16TotalExits   = 0u;

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

    if (TKT_CloseOldest(&Local_u16Id, &Local_u32EntrySec) != E_OK)
    {
        /* No open ticket to close. Real cause: either a bug upstream (exit
         * granted with occupiedCount == 0), or - per FR-17 - a vehicle that
         * was already parked before a reboot and never got a ticket rebuilt
         * for it (that rebuild-from-slotMap logic isn't written yet). No
         * fee can be computed without an entry time, so nothing is charged
         * and nothing is printed. Document this as a known limitation until
         * FR-17's boot-restore/ticket-rebuild path exists. */
        return;
    }

    Local_u32ExitSec = RTC_Seconds();

    /* Defensive: RTC only moves forward, but guard against a corrupted or
     * stale entrySec producing an underflowed (huge) dwell time. */
    Local_u32DwellSec = (Local_u32ExitSec >= Local_u32EntrySec)
                       ? (Local_u32ExitSec - Local_u32EntrySec)
                       : 0UL;

    Local_u16DwellMin = (uint16)(Local_u32DwellSec / 60UL);

    /* §11.4: first GRACE_DEFAULT_MINUTES free. */
    Local_u16ChargeableMin = (Local_u16DwellMin > GRACE_DEFAULT_MINUTES)
                            ? (uint16)(Local_u16DwellMin - GRACE_DEFAULT_MINUTES)
                            : 0u;

    /* §11.4: any part of an hour counts as a full hour - integer ceiling,
     * no floating point (NFR-06). */
    Local_u16Hours = (uint16)((Local_u16ChargeableMin + 59u) / 60u);
   uint32 Local_u32Fee;

  Local_u32Fee = (uint32)Local_u16Hours * (uint32)TARIFF_DEFAULT;

if (Local_u32Fee > DAILY_CAP)
{
    Local_u32Fee = DAILY_CAP;
}

Local_u16Fee = (uint16)Local_u32Fee;

    /* FR-10: totalRevenue saturates at 65535, does not wrap. */
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
    g_u16TotalExits   = 0u;
}

/* ======================================================================== */

/* No leading zeros, natural width, NUL-terminated. Buf must be >= 6 bytes
 * (max "65535" + NUL). Used for DWELL/HOURS/FEE per §18.3's unpadded style. */
static void BIL_FormatUint16(uint16 Copy_u16Value, char *Copy_pcBuf)
{
    char  Local_acTmp[6];
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

/* Zero-padded 4-digit ID, matching ticketing.c's own TKT_FormatId style and
 * §18.3's "ID : 0042" format. */
static void BIL_FormatId(uint16 Copy_u16Id, char *Copy_pcBuf)
{
    Copy_pcBuf[0] = (char)('0' + (uint8)((Copy_u16Id / 1000u) % 10u));
    Copy_pcBuf[1] = (char)('0' + (uint8)((Copy_u16Id / 100u)  % 10u));
    Copy_pcBuf[2] = (char)('0' + (uint8)((Copy_u16Id / 10u)   % 10u));
    Copy_pcBuf[3] = (char)('0' + (uint8)( Copy_u16Id          % 10u));
    Copy_pcBuf[4] = '\0';
}

/* §18.3 exit receipt, field-for-field. */
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

    if (RTC_Format(Copy_u32EntrySec, Local_acIn, (uint8)sizeof(Local_acIn)) != E_OK)
    {
        Local_acIn[0] = '\0';
    }

    if (RTC_Format(Copy_u32ExitSec, Local_acOut, (uint8)sizeof(Local_acOut)) != E_OK)
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

    BIL_FormatUint16((uint16)GRACE_DEFAULT_MINUTES, Local_acNum);
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