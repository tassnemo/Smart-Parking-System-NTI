#ifndef SPI_INTERFACE_H
#define SPI_INTERFACE_H

#include "STD_TYPES.h"

STD_ReturnType SPI_Init(void);
STD_ReturnType SPI_Transfer(uint8 Copy_u8Data, uint8 *Copy_pu8Received);

#endif /* SPI_INTERFACE_H */
