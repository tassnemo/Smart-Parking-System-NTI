#include "barrier.h"
#include "MCAL/pwm/pwm_interface.h"
#include <stddef.h>

#define BAR_SERVO_CLOSED_US   1000u
#define BAR_SERVO_OPEN_US     2000u

STD_ReturnType BAR_Init(uint8 Copy_u8Channel)
{
    (void)Copy_u8Channel;
    return E_OK;
}

STD_ReturnType BAR_Open(uint8 Copy_u8Channel)
{
    return PWM_SetPulse(Copy_u8Channel, BAR_SERVO_OPEN_US);
}

STD_ReturnType BAR_Close(uint8 Copy_u8Channel)
{
    return PWM_SetPulse(Copy_u8Channel, BAR_SERVO_CLOSED_US);
}

STD_ReturnType BAR_IsMoving(uint8 Copy_u8Channel, uint8 *Copy_pu8Status)
{
    if (Copy_pu8Status == NULL)
    {
        return E_NOK;
    }

    (void)Copy_u8Channel;

    /*
     * Servo movement is handled by the lane FSM timing.
     * No blocking or hardware polling is required here.
     */
    *Copy_pu8Status = STD_LOW;

    return E_OK;
}