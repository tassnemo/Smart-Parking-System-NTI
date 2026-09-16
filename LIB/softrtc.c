#include "softrtc.h"
#include <util/atomic.h>
#include "config.h"

static volatile uint32 g_u32UptimeSec = 0;
static uint8 g_u8SubTick = 0;

void RTC_Tick10ms(void) {
    if (++g_u8SubTick >= (1000u / SYSTEM_TICK_MS)) {
        g_u8SubTick = 0;
        g_u32UptimeSec++;
    }
}

uint32 RTC_Seconds(void) {
    uint32 Local_u32Seconds;

    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        Local_u32Seconds = g_u32UptimeSec;
    }

    return Local_u32Seconds;
}

STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
                          char *Copy_pcBuf,
                          uint8 Copy_u8BufSize) {
    uint32 Local_u32Hours = Copy_u32Sec / 3600u;
    uint8 Local_u8Minutes = (uint8)((Copy_u32Sec % 3600u) / 60u);
    uint8 Local_u8Seconds = (uint8)(Copy_u32Sec % 60u);

    if ((Copy_pcBuf == NULL) || (Copy_u8BufSize < 10u))
    {
        return E_NOK;
    }

    Copy_pcBuf[0] = (char)('0' + (Local_u32Hours / 100u) % 10u);
    Copy_pcBuf[1] = (char)('0' + (Local_u32Hours / 10u) % 10u);
    Copy_pcBuf[2] = (char)('0' + Local_u32Hours % 10u);
    Copy_pcBuf[3] = ':';
    Copy_pcBuf[4] = (char)('0' + Local_u8Minutes / 10u);
    Copy_pcBuf[5] = (char)('0' + Local_u8Minutes % 10u);
    Copy_pcBuf[6] = ':';
    Copy_pcBuf[7] = (char)('0' + Local_u8Seconds / 10u);
    Copy_pcBuf[8] = (char)('0' + Local_u8Seconds % 10u);
    Copy_pcBuf[9] = '\0';

    return E_OK;
}