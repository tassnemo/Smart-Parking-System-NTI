#include "shiftreg.h"
#include "config.h"
#include "dio_interface.h"
#include "spi_interface.h"

static uint16 SR_u16Shadow = 0u;

static STD_ReturnType SR_StrobePulse(void);

STD_ReturnType SR_Init(void)
{
    if (SPI_Init() != E_OK)
    {
        return E_NOK;
    }

    if (DIO_Init(SHIFTREG_RCLK_PORT,
                 SHIFTREG_RCLK_PIN,
                 DIO_OUTPUT) != E_OK)
    {
        return E_NOK;
    }

    /* STR idle LOW: the 4094 output latch is transparent while STR is HIGH,
     * so it must rest LOW or the outputs follow the shifting data. */
    if (DIO_WritePin(SHIFTREG_RCLK_PORT,
                     SHIFTREG_RCLK_PIN,
                     DIO_LOW) != E_OK)
    {
        return E_NOK;
    }

    /* Known state: every LED off, lot lamp off. */
    SR_u16Shadow = 0xFFFFu;          /* force the first write through */
    return SR_Write(0x0000u);
}

STD_ReturnType SR_Write(uint16 Copy_u16Data)
{
    uint8 Local_u8Dummy;
    uint8 Local_u8Index;
    uint8 Local_au8Bytes[SHIFTREG_COUNT];

    /* Highest register in the chain is loaded first. */
    Local_au8Bytes[0] = (uint8)(Copy_u16Data >> 8);   /* U2 : 744094-142 */
    Local_au8Bytes[1] = (uint8)(Copy_u16Data & 0xFFu);/* U1 : 744094-150 */

    for (Local_u8Index = 0u; Local_u8Index < SHIFTREG_COUNT; Local_u8Index++)
    {
        if (SPI_Transfer(Local_au8Bytes[Local_u8Index],
                         &Local_u8Dummy) != E_OK)
        {
            return E_NOK;
        }
    }

    if (SR_StrobePulse() != E_OK)
    {
        return E_NOK;
    }

    SR_u16Shadow = Copy_u16Data;
    return E_OK;
}

uint16 SR_GetShadow(void)
{
    return SR_u16Shadow;
}

static STD_ReturnType SR_StrobePulse(void)
{
    if (DIO_WritePin(SHIFTREG_RCLK_PORT,
                     SHIFTREG_RCLK_PIN,
                     DIO_HIGH) != E_OK)
    {
        return E_NOK;
    }

    /* One DIO write is already several CPU cycles wide at 8 MHz, which clears
     * the 4094 strobe pulse-width requirement. No delay, no blocking. */

    return DIO_WritePin(SHIFTREG_RCLK_PORT,
                        SHIFTREG_RCLK_PIN,
                        DIO_LOW);
}