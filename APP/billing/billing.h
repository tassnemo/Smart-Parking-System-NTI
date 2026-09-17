#ifndef BILLING_H
#define BILLING_H

#include "STD_TYPES.h"

/* ----------------------------------------------------------------------------
 * Tariff arithmetic (§11.4): 15 min grace, 10 units/started hour after grace,
 * daily cap 120. Integer-only (NFR-06).
 *
 * BIL_OnExitAuthorized() is called directly by lane_fsm.c on L5 (exit lane,
 * always granted). It closes the oldest open ticket via ticketing.c, computes
 * the fee, prints the §18.3 receipt over UART, and updates running totals.
 * Signature has no parameters/return for the same reason as
 * TKT_OnEntryAuthorized(): lane_fsm.c's "extern void BIL_OnExitAuthorized
 * (void);" is already fixed, so this module owns everything the receipt
 * needs (the closed ticket's id/entrySec, and RTC_Seconds() for the exit
 * time).
 * --------------------------------------------------------------------------*/

void BIL_OnExitAuthorized(void);

/* For STATUS/STATS? telemetry (§18.1, §18.2). Revenue saturates at 65535
 * per FR-10; does not wrap. */
uint16 BIL_GetTotalRevenue(void);
uint16 BIL_GetTotalExits(void);

/* CLRSTATS (§18.2): zero totals and revenue, NOT nextTicketId (that stays
 * ticketing.c's own counter, untouched by this call). */
void BIL_ClearStats(void);

#endif /* BILLING_H */