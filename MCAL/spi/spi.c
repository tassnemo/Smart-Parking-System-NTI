#include "spi_interface.h"
#include "spi_private.h"

STD_ReturnType SPI_Init(void)
{
	/* PB5/MOSI and PB7/SCK are outputs; PB6/MISO remains an input. */
	SPI_DDRB |= (uint8)((1u << SPI_MOSI_PIN) | (1u << SPI_SCK_PIN));
	SPI_DDRB &= (uint8)~(1u << SPI_MISO_PIN);

	/* Master, mode 0, MSB first, clock = F_CPU / 16. */
	SPI_SPCR = (uint8)((1u << SPI_SPE) |
					   (1u << SPI_MSTR) |
					   (1u << SPI_SPR0));
	SPI_SPSR &= (uint8)~(1u << SPI_SPI2X);

	return E_OK;
}

STD_ReturnType SPI_Transfer(uint8 Copy_u8Data, uint8 *Copy_pu8Received)
{
	if (Copy_pu8Received == NULL)
	{
		return E_NOK;
	}

	SPI_SPDR = Copy_u8Data;

	while ((SPI_SPSR & (uint8)(1u << SPI_SPIF)) == 0u)
	{
		/* Wait for the byte transfer to complete. */
	}

	*Copy_pu8Received = SPI_SPDR;

	return E_OK;
}
