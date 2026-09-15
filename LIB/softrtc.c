#include <stdio.h>
#include "softrtc.h"

static volatile uint32 g_u32UptimeSec = 0;
static uint8 g_u8SubTick = 0;

void RTC_Tick10ms(void) {
    if (++g_u8SubTick >= 100u) {
        g_u8SubTick = 0;
        g_u32UptimeSec++;
    }
}

uint32 RTC_Seconds(void) {
    return g_u32UptimeSec;
}

void RTC_Format(uint32 Copy_u32Sec, char *Copy_pcBuf) {
    uint32 Local_u32Hours = Copy_u32Sec / 3600u;
    uint8 Local_u8Minutes = (uint8)((Copy_u32Sec % 3600u) / 60u);
    uint8 Local_u8Seconds = (uint8)(Copy_u32Sec % 60u);

    sprintf(Copy_pcBuf, "%03lu:%02u:%02u", (unsigned long)Local_u32Hours, Local_u8Minutes, Local_u8Seconds);
}