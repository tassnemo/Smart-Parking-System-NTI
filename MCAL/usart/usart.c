#include "usart_interface.h"
#include "usart_private.h"
#include "ring_buffer.h"
#include <avr/interrupt.h>
#include <util/atomic.h>

static uint8 g_USARTRxStorage[UART_RX_BUFFER_SIZE];
static RingBuffer g_USARTRxBuffer;

STD_ReturnType USART_Init(void)
{
    if (RingBuffer_Init(&g_USARTRxBuffer,
                        g_USARTRxStorage,
                        UART_RX_BUFFER_SIZE) != E_OK)
    {
        return E_NOK;
    }

    /* Disable USART while configuring */
    USART_UCSRB = 0u;

    /* Select normal asynchronous mode. */
    USART_UCSRA &= (uint8)~(1u << USART_U2X);

    /* Baud rate = 9600 baud @ 8 MHz, normal mode */
    USART_UBRRH = 0u;
    USART_UBRRL = (uint8)USART_UBRR_VALUE;

    /*
     * UCSRC:
     * URSEL = 1 -> write UCSRC
     * UMSEL = 0 -> asynchronous
     * UPM1:0 = 00 -> no parity
     * USBS = 0 -> 1 stop bit
     * UCSZ1:0 = 11 -> 8-bit data
     */
    USART_UCSRC =
        (uint8)((1u << USART_URSEL) |
                (1u << USART_UCSZ1) |
                (1u << USART_UCSZ0));

    /*
     * Enable transmitter and receiver.
     * UCSZ2 = 0 -> 8-bit data.
     */
    USART_UCSRB =
        (uint8)((1u << USART_RXEN) |
                (1u << USART_TXEN) |
                (1u << USART_RXCIE));

    return E_OK;
}

STD_ReturnType USART_SendByte(uint8 Copy_u8Data)
{
    while ((USART_UCSRA & (uint8)(1u << USART_UDRE)) == 0u)
    {
        /* Wait until transmit buffer is empty */
    }

    USART_UDR = Copy_u8Data;

    return E_OK;
}

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data)
{
    STD_ReturnType Local_u8Result;

    if (Copy_pu8Data == NULL)
    {
        return E_NOK;
    }

    /* The RX ISR fills the queue; do not block the scheduler here. */
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        Local_u8Result = RingBuffer_Pop(&g_USARTRxBuffer, Copy_pu8Data);
    }

    return Local_u8Result;
}

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String)
{
    if (Copy_pu8String == NULL)
    {
        return E_NOK;
    }

    while (*Copy_pu8String != '\0')
    {
        if (USART_SendByte(*Copy_pu8String) != E_OK)
        {
            return E_NOK;
        }

        Copy_pu8String++;
    }

    return E_OK;
}

ISR(USART_RXC_vect)
{
    (void)RingBuffer_Push(&g_USARTRxBuffer, USART_UDR);
}