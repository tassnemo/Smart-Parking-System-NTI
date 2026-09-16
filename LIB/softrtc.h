#ifndef SOFTRTC_H_
#define SOFTRTC_H_

#include "STD_TYPES.h"

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
						  char *Copy_pcBuf,
						  uint8 Copy_u8BufSize);

#endif /* SOFTRTC_H_ */