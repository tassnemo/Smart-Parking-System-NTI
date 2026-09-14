#include "buzzer.h"
#include "MCAL/dio/dio_interface.h"

#define BUZ_PORT DIO_PORTD

STD_ReturnType BUZ_Init(uint8 Copy_u8Pin)
{
    return DIO_Init(BUZ_PORT, Copy_u8Pin, DIO_OUTPUT);
}

STD_ReturnType BUZ_On(uint8 Copy_u8Pin)
{
    return DIO_WritePin(BUZ_PORT, Copy_u8Pin, DIO_HIGH);
}

STD_ReturnType BUZ_Off(uint8 Copy_u8Pin)
{
    return DIO_WritePin(BUZ_PORT, Copy_u8Pin, DIO_LOW);
}
