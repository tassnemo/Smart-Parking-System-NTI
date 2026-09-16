#include "MCAL/i2c/i2c_interface.h"
#include "MCAL/usart/usart_interface.h"
#include <avr/interrupt.h>

int main(void)
{
    uint8 result;

    USART_Init();
    sei();

    USART_SendString((const uint8 *)"I2C TEST START\r\n");

    if (I2C_Init() != E_OK)
    {
        USART_SendString((const uint8 *)"I2C INIT FAILED\r\n");
    }

    result = I2C_Start();

    if (result == E_OK)
    {
        USART_SendString((const uint8 *)"I2C START OK\r\n");

        result = I2C_Write(0x40u);

        if (result == E_OK)
        {
            USART_SendString((const uint8 *)"I2C DEVICE ACK\r\n");
        }
        else
        {
            USART_SendString((const uint8 *)"I2C DEVICE NACK\r\n");
        }

        I2C_Stop();
    }
    else
    {
        USART_SendString((const uint8 *)"I2C START FAILED\r\n");
    }

    while (1)
    {
    }

    return 0;
}