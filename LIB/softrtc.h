#ifndef SOFTRTC_H_
#define SOFTRTC_H_

#include "STD_TYPES.h"

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
void RTC_Format(uint32 Copy_u32Sec, char *Copy_pcBuf);

#endif /* SOFTRTC_H_ */