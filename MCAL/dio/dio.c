#include "dio_interface.h"
#include "dio_private.h"


STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction)
{
    if (Copy_u8Pin > 7u)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
        case DIO_PORTA:
            if (Copy_u8Direction == DIO_OUTPUT)
            {
                DIO_DDRA_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == DIO_INPUT_PULLUP)
            {
                DIO_DDRA_REG &= (uint8)(~(1u << Copy_u8Pin));  /* input */
                DIO_PORTA_REG |= (uint8)(1u << Copy_u8Pin);    /* enable pull-up */
            }
            else
            {
                DIO_DDRA_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTA_REG &= (uint8)(~(1u << Copy_u8Pin)); /* plain input, Hi-Z */
            }
            return E_OK;

        case DIO_PORTB:
            if (Copy_u8Direction == DIO_OUTPUT)
            {
                DIO_DDRB_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == DIO_INPUT_PULLUP)
            {
                DIO_DDRB_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTB_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_DDRB_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTB_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        case DIO_PORTC:
            if (Copy_u8Direction == DIO_OUTPUT)
            {
                DIO_DDRC_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == DIO_INPUT_PULLUP)
            {
                DIO_DDRC_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTC_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_DDRC_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTC_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        case DIO_PORTD:
            if (Copy_u8Direction == DIO_OUTPUT)
            {
                DIO_DDRD_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else if (Copy_u8Direction == DIO_INPUT_PULLUP)
            {
                DIO_DDRD_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTD_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_DDRD_REG &= (uint8)(~(1u << Copy_u8Pin));
                DIO_PORTD_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value)
{
    if (Copy_u8Pin > 7u)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
        case DIO_PORTA:
            if (Copy_u8Value == DIO_HIGH)
            {
                DIO_PORTA_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_PORTA_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        case DIO_PORTB:
            if (Copy_u8Value == DIO_HIGH)
            {
                DIO_PORTB_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_PORTB_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        case DIO_PORTC:
            if (Copy_u8Value == DIO_HIGH)
            {
                DIO_PORTC_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_PORTC_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        case DIO_PORTD:
            if (Copy_u8Value == DIO_HIGH)
            {
                DIO_PORTD_REG |= (uint8)(1u << Copy_u8Pin);
            }
            else
            {
                DIO_PORTD_REG &= (uint8)(~(1u << Copy_u8Pin));
            }
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value)
{
    if (Copy_pu8Value == NULL)
    {
        return E_NOK;
    }

    if (Copy_u8Pin > 7u)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
        case DIO_PORTA:
            *Copy_pu8Value = (uint8)((DIO_PINA_REG >> Copy_u8Pin) & 0x01u);
            return E_OK;

        case DIO_PORTB:
            *Copy_pu8Value = (uint8)((DIO_PINB_REG >> Copy_u8Pin) & 0x01u);
            return E_OK;

        case DIO_PORTC:
            *Copy_pu8Value = (uint8)((DIO_PINC_REG >> Copy_u8Pin) & 0x01u);
            return E_OK;

        case DIO_PORTD:
            *Copy_pu8Value = (uint8)((DIO_PIND_REG >> Copy_u8Pin) & 0x01u);
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value)
{
    switch (Copy_u8Port)
    {
        case DIO_PORTA:
            DIO_PORTA_REG = Copy_u8Value;
            return E_OK;

        case DIO_PORTB:
            DIO_PORTB_REG = Copy_u8Value;
            return E_OK;

        case DIO_PORTC:
            DIO_PORTC_REG = Copy_u8Value;
            return E_OK;

        case DIO_PORTD:
            DIO_PORTD_REG = Copy_u8Value;
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value)
{
    if (Copy_pu8Value == NULL)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
        case DIO_PORTA:
            *Copy_pu8Value = DIO_PINA_REG;
            return E_OK;

        case DIO_PORTB:
            *Copy_pu8Value = DIO_PINB_REG;
            return E_OK;

        case DIO_PORTC:
            *Copy_pu8Value = DIO_PINC_REG;
            return E_OK;

        case DIO_PORTD:
            *Copy_pu8Value = DIO_PIND_REG;
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
    if (Copy_u8Pin > 7u)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
        case DIO_PORTA:
            DIO_PORTA_REG ^= (uint8)(1u << Copy_u8Pin);
            return E_OK;

        case DIO_PORTB:
            DIO_PORTB_REG ^= (uint8)(1u << Copy_u8Pin);
            return E_OK;

        case DIO_PORTC:
            DIO_PORTC_REG ^= (uint8)(1u << Copy_u8Pin);
            return E_OK;

        case DIO_PORTD:
            DIO_PORTD_REG ^= (uint8)(1u << Copy_u8Pin);
            return E_OK;

        default:
            return E_NOK;
    }
}