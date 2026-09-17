#ifndef CONSOLE_H
#define CONSOLE_H

#include "LIB/STD_TYPES.h"

/*
 * APP console -- implements §18.2's command set (FR-18), case-insensitive,
 * lines up to CONSOLE_MAX_LINE_LEN chars, one response line per command,
 * ERR vocabulary per the book standard.
 *
 * This module also OWNS the live-tunable settings (tariff, grace, hold,
 * timeout, light threshold) -- billing.c's own comment already expects
 * this ("replace these two reads with calls into console.c's getters").
 * A real config.c (FR-16/FR-17, persistence + validation) can wrap these
 * later without changing this module's public API.
 *
 * Call CONSOLE_ParseLine once per complete line assembled by the USART
 * RX ring buffer (on \r or \n), from a task around 20ms per Task_Console.
 */

#define CONSOLE_MAX_LINE_LEN  24u   /* FR-18: >24 chars -> ERR LONG */

STD_ReturnType CONSOLE_Init(void);
STD_ReturnType CONSOLE_ParseLine(const char *Copy_pcLine);

/* ---- Live-tunable settings getters (billing.c and others read these) ---- */
uint8  CONSOLE_GetTariff(void);       /* units/hour,    default from config.h */
uint8  CONSOLE_GetGrace(void);        /* minutes,       default from config.h */
uint8  CONSOLE_GetHold(void);         /* seconds,       default from config.h */
uint8  CONSOLE_GetTimeout(void);      /* seconds,       default from config.h */
uint8  CONSOLE_GetLightThresh(void);  /* percent,       default from config.h */

#endif /* CONSOLE_H */