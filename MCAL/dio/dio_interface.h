#ifndef DIO_INTERFACE_H
#define DIO_INTERFACE_H

#include "STD_TYPES.h"

#define DIO_PORTA 0u
#define DIO_PORTB 1u
#define DIO_PORTC 2u
#define DIO_PORTD 3u

#define DIO_PIN0 0u
#define DIO_PIN1 1u
#define DIO_PIN2 2u
#define DIO_PIN3 3u
#define DIO_PIN4 4u
#define DIO_PIN5 5u
#define DIO_PIN6 6u
#define DIO_PIN7 7u

#define DIO_INPUT  0u
#define DIO_OUTPUT 1u
#define DIO_INPUT_PULLUP  2u

#define DIO_LOW  0u
#define DIO_HIGH 1u

STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);

#endif