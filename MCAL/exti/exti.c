#include <stddef.h>
#include <avr/interrupt.h>

#include "exti_interface.h"
#include "exti_private.h"

static EXTI_CallbackType g_EXTICallback[3] = {NULL, NULL, NULL};

STD_ReturnType EXTI_Init(void)
{
    EXTI_MCUCR = 0u;
    EXTI_MCUCSR &= (uint8)(~(1u << EXTI_ISC2));
    EXTI_GICR = 0u;
    EXTI_GIFR = 0u;

    return E_OK;
}

STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense)
{
    switch (Copy_u8Int)
    {
        case EXTI_INT0:
            if (Copy_u8Sense > EXTI_RISING_EDGE)
            {
                return E_NOK;
            }
            EXTI_MCUCR &= (uint8)(~((1u << EXTI_ISC00) | (1u << EXTI_ISC01)));
            EXTI_MCUCR |= (uint8)((Copy_u8Sense & 0x03u) << EXTI_ISC00);
            return E_OK;

        case EXTI_INT1:
            if (Copy_u8Sense > EXTI_RISING_EDGE)
            {
                return E_NOK;
            }
            EXTI_MCUCR &= (uint8)(~((1u << EXTI_ISC10) | (1u << EXTI_ISC11)));
            EXTI_MCUCR |= (uint8)((Copy_u8Sense & 0x03u) << EXTI_ISC10);
            return E_OK;

        case EXTI_INT2:
            if ((Copy_u8Sense != EXTI_FALLING_EDGE) && (Copy_u8Sense != EXTI_RISING_EDGE))
            {
                return E_NOK;
            }
            EXTI_MCUCSR &= (uint8)(~(1u << EXTI_ISC2));
            EXTI_MCUCSR |= (uint8)((Copy_u8Sense & 0x01u) << EXTI_ISC2);
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType EXTI_Enable(uint8 Copy_u8Int)
{
    switch (Copy_u8Int)
    {
        case EXTI_INT0:
            EXTI_GICR |= (uint8)(1u << EXTI_INT0_BIT);
            return E_OK;

        case EXTI_INT1:
            EXTI_GICR |= (uint8)(1u << EXTI_INT1_BIT);
            return E_OK;

        case EXTI_INT2:
            EXTI_GICR |= (uint8)(1u << EXTI_INT2_BIT);
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType EXTI_Disable(uint8 Copy_u8Int)
{
    switch (Copy_u8Int)
    {
        case EXTI_INT0:
            EXTI_GICR &= (uint8)(~(1u << EXTI_INT0_BIT));
            return E_OK;

        case EXTI_INT1:
            EXTI_GICR &= (uint8)(~(1u << EXTI_INT1_BIT));
            return E_OK;

        case EXTI_INT2:
            EXTI_GICR &= (uint8)(~(1u << EXTI_INT2_BIT));
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int)
{
    switch (Copy_u8Int)
    {
        case EXTI_INT0:
            EXTI_GIFR |= (uint8)(1u << EXTI_INTF0);
            return E_OK;

        case EXTI_INT1:
            EXTI_GIFR |= (uint8)(1u << EXTI_INTF1);
            return E_OK;

        case EXTI_INT2:
            EXTI_GIFR |= (uint8)(1u << EXTI_INTF2);
            return E_OK;

        default:
            return E_NOK;
    }
}

STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback)
{
    if (Copy_pfCallback == NULL)
    {
        return E_NOK;
    }

    if (Copy_u8Int > EXTI_INT2)
    {
        return E_NOK;
    }

    g_EXTICallback[Copy_u8Int] = Copy_pfCallback;
    return E_OK;
}

ISR(INT0_vect)
{
    if (g_EXTICallback[EXTI_INT0] != NULL)
    {
        g_EXTICallback[EXTI_INT0]();
    }
}

ISR(INT1_vect)
{
    if (g_EXTICallback[EXTI_INT1] != NULL)
    {
        g_EXTICallback[EXTI_INT1]();
    }
}

ISR(INT2_vect)
{
    if (g_EXTICallback[EXTI_INT2] != NULL)
    {
        g_EXTICallback[EXTI_INT2]();
    }
}