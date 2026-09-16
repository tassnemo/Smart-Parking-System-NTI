#include "i2c_interface.h"
#include "i2c_private.h"
#include "config.h"

static STD_ReturnType I2C_WaitForInterrupt(void)
{
	uint16 Local_u16Timeout = I2C_TIMEOUT;

	while (((I2C_TWCR & (uint8)(1u << I2C_TWINT)) == 0u) &&
		   (Local_u16Timeout > 0u))
	{
		Local_u16Timeout--;
	}

	return (Local_u16Timeout == 0u) ? E_NOK : E_OK;
}

STD_ReturnType I2C_Init(void)
{
	uint32 Local_u32Twbr;

	/* Prescaler = 1: SCL = F_CPU / (16 + 2 * TWBR). */
	I2C_TWSR &= (uint8)~((1u << I2C_TWPS0) | (1u << I2C_TWPS1));
	Local_u32Twbr = (F_CPU / I2C_SCL_FREQUENCY - 16UL) / 2UL;
	if (Local_u32Twbr > 255UL)
	{
		return E_NOK;
	}

	I2C_TWBR = (uint8)Local_u32Twbr;
	I2C_TWAR = 0u;
	I2C_TWCR = (uint8)(1u << I2C_TWEN);

	return E_OK;
}

STD_ReturnType I2C_Start(void)
{
	I2C_TWCR = (uint8)((1u << I2C_TWINT) |
					   (1u << I2C_TWSTA) |
					   (1u << I2C_TWEN));

	if (I2C_WaitForInterrupt() != E_OK)
	{
		return E_NOK;
	}

	return (((I2C_TWSR & I2C_TWS_MASK) == I2C_STATUS_START) ||
			((I2C_TWSR & I2C_TWS_MASK) == I2C_STATUS_REP_START))
		   ? E_OK
		   : E_NOK;
}

STD_ReturnType I2C_Stop(void)
{
	I2C_TWCR = (uint8)((1u << I2C_TWINT) |
					   (1u << I2C_TWSTO) |
					   (1u << I2C_TWEN));

	return E_OK;
}

STD_ReturnType I2C_Write(uint8 Copy_u8Data)
{
	uint8 Local_u8Status;

	I2C_TWDR = Copy_u8Data;
	I2C_TWCR = (uint8)((1u << I2C_TWINT) |
					   (1u << I2C_TWEN));

	if (I2C_WaitForInterrupt() != E_OK)
	{
		return E_NOK;
	}

	Local_u8Status = I2C_TWSR & I2C_TWS_MASK;
	    return ((Local_u8Status == I2C_STATUS_MT_SLA_ACK) ||
		    (Local_u8Status == I2C_STATUS_MT_DATA_ACK))
		   ? E_OK
		   : E_NOK;
}

STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data)
{
	if (Copy_pu8Data == NULL)
	{
		return E_NOK;
	}

	I2C_TWCR = (uint8)((1u << I2C_TWINT) |
					   (1u << I2C_TWEA) |
					   (1u << I2C_TWEN));

	if (I2C_WaitForInterrupt() != E_OK ||
		(I2C_TWSR & I2C_TWS_MASK) != I2C_STATUS_MR_DATA_ACK)
	{
		return E_NOK;
	}

	*Copy_pu8Data = I2C_TWDR;
	return E_OK;
}

STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data)
{
	if (Copy_pu8Data == NULL)
	{
		return E_NOK;
	}

	I2C_TWCR = (uint8)((1u << I2C_TWINT) |
					   (1u << I2C_TWEN));

	if (I2C_WaitForInterrupt() != E_OK ||
		(I2C_TWSR & I2C_TWS_MASK) != I2C_STATUS_MR_DATA_NACK)
	{
		return E_NOK;
	}

	*Copy_pu8Data = I2C_TWDR;
	return E_OK;
}
