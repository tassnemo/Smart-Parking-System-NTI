#ifndef TICKETING_H
#define TICKETING_H

#include "STD_TYPES.h"
#include "config.h"

/* DD-02 Ticket_t, verbatim from the spec. */
typedef struct
{
    uint16 id;         /* 1..9999, wraps to 1                 */
    uint32 entrySec;   /* RTC seconds at issue                 */
    uint8  slotHint;   /* slot suggested at entry, 0 = none    */
    uint8  active;     /* 1 = open, 0 = free row               */
} Ticket_t;

/* Fixed array, no malloc (NFR-16). Reserved at compile time (NFR-10). */

void TKT_Init(void);

/* Called directly by lane_fsm.c on L4 (entry authorised). Claims a free
 * ticket row, timestamps it via softrtc, and prints the §18.3 ticket frame
 * over UART. Signature has no parameters/return because lane_fsm's
 * "extern void TKT_OnEntryAuthorized(void);" is already fixed by lane_fsm.c -
 * this module owns everything the frame needs (RTC, free count, slot map). */
void TKT_OnEntryAuthorized(void);

/* Closes the ticket with the OLDEST entrySec (FR-10: "close the oldest open
 * ticket") and reports it via the out params for billing.c to compute the
 * fee from. Returns E_NOK if no ticket is currently open. */
STD_ReturnType TKT_CloseOldest(uint16 *Copy_pu16Id, uint32 *Copy_pu32EntrySec);

/* Read-only lookup by ID, e.g. for a future TICKETS? console command. */
const Ticket_t *TKT_Find(uint16 Copy_u16Id);

/* For FR-14's occupancy-vs-ticket consistency check. */
uint8 TKT_GetOpenCount(void);

/* For STATUS/COUNTS? telemetry (§18.1, §18.2). */
uint16 TKT_GetNextId(void);
uint16 TKT_GetTotalEntries(void);
void TKT_PrintOpenTickets(void);
void TKT_ClearStats(void);

#endif /* TICKETING_H */