#ifndef TELEMETRY_H
#define TELEMETRY_H

#include "LIB/STD_TYPES.h"

/*
 * APP telemetry -- owns FR-15's periodic status frame (§18.1):
 *   $PK,F=3,O=3,MAP=2A,IN=IDLE,OUT=OPEN,T=42,X=39,REV=380,MODE=OPER,UP=3600*5E
 *
 * Call TELEM_Send() from a scheduler task registered at 5s (500 ticks),
 * per Task_Report in §19. Uses the shared CHECKSUM_Xor (checksum.c) so
 * the same XOR logic isn't duplicated against ParkCfg_t's checksum.
 */

#define TELEM_FRAME_MAX_LEN  64u   /* generous headroom over the example frame */

/*
 * Description : Build the full frame (including $, checksum, * and \r\n)
 *               into Copy_pu8Buf. Caller must supply a buffer at least
 *               TELEM_FRAME_MAX_LEN bytes long.
 * Return      : E_NOK if Copy_pu8Buf is NULL.
 */
STD_ReturnType TELEM_BuildFrame(char *Copy_pu8Buf);

/*
 * Description : Build the frame and transmit it over USART.
 */
STD_ReturnType TELEM_Send(void);

#endif /* TELEMETRY_H */