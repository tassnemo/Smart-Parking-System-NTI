#ifndef USART_INTERFACE_H
#define USART_INTERFACE_H

#include "STD_TYPES.h"

STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);

#endif /* USART_INTERFACE_H */