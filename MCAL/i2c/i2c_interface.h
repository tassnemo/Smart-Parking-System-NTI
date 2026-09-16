#ifndef I2C_INTERFACE_H
#define I2C_INTERFACE_H

#include "STD_TYPES.h"

STD_ReturnType I2C_Init(void);
STD_ReturnType I2C_Start(void);
STD_ReturnType I2C_Stop(void);
STD_ReturnType I2C_Write(uint8 Copy_u8Data);
STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data);
STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data);

#endif /* I2C_INTERFACE_H */
