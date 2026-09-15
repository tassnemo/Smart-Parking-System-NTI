#include "lot_fsm.h"
#include "../MCAL/GPIO/GPIO_interface.h"

#define FULL_LED_PORT   GPIO_PORTD
#define FULL_LED_PIN    GPIO_PIN6

extern uint8 SLOT_CountFree(void);

static LotState_t g_lotState = LOT_INIT;
static uint8 g_u8FreeSlots = 6;

void LOT_Init(void) {
    GPIO_SetPinDirection(FULL_LED_PORT, FULL_LED_PIN, GPIO_OUTPUT);
    GPIO_SetPinValue(FULL_LED_PORT, FULL_LED_PIN, GPIO_LOW);
    g_lotState = LOT_OPERATIONAL;
}

uint8 LOT_GetFree(void) {
    return g_u8FreeSlots;
}

uint8 LOT_CanAuthoriseEntry(void) {
    return (g_lotState == LOT_OPERATIONAL && g_u8FreeSlots > 0);
}

LotState_t LOT_GetState(void) {
    return g_lotState;
}

void LOT_Run(void) {
    g_u8FreeSlots = SLOT_CountFree();

    switch (g_lotState) {
        case LOT_OPERATIONAL:
            GPIO_SetPinValue(FULL_LED_PORT, FULL_LED_PIN, GPIO_LOW);
            if (g_u8FreeSlots == 0) {
                g_lotState = LOT_FULL;
                GPIO_SetPinValue(FULL_LED_PORT, FULL_LED_PIN, GPIO_HIGH);
            }
            break;

        case LOT_FULL:
            GPIO_SetPinValue(FULL_LED_PORT, FULL_LED_PIN, GPIO_HIGH);
            if (g_u8FreeSlots > 0) {
                g_lotState = LOT_OPERATIONAL;
                GPIO_SetPinValue(FULL_LED_PORT, FULL_LED_PIN, GPIO_LOW);
            }
            break;

        case LOT_MAINTENANCE:
        case LOT_FAULT:
        case LOT_INIT:
            break;
    }
}