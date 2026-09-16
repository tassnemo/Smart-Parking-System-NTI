#include "shiftreg.h"
#include "config.h"
#include "dio_interface.h"
#include "spi_interface.h"

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

    return DIO_WritePin(SHIFTREG_RCLK_PORT,
                        SHIFTREG_RCLK_PIN,
                        DIO_LOW);
}

STD_ReturnType SR_Write(uint8 Copy_u8Data)
{
    uint8 Local_u8Received;

    if (SPI_Transfer(Copy_u8Data, &Local_u8Received) != E_OK)
    {
        return E_NOK;
    }

    if (DIO_WritePin(SHIFTREG_RCLK_PORT,
                     SHIFTREG_RCLK_PIN,
                     DIO_HIGH) != E_OK)
    {
        return E_NOK;
    }

    return DIO_WritePin(SHIFTREG_RCLK_PORT,
                        SHIFTREG_RCLK_PIN,
                        DIO_LOW);
}