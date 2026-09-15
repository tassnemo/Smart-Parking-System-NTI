#include "exti_interface.h"
#include "exti_private.h"

static EXTI_CallbackType g_EXTICallback[3] =
{
    NULL,
    NULL,
    NULL
};

STD_ReturnType EXTI_Init(void)
{
    EXTI_MCUCR = 0u;

    EXTI_MCUCSR &= (uint8)~(1u << EXTI_ISC2);

    EXTI_GICR = 0u;

    EXTI_GIFR =
        (uint8)((1u << EXTI_INTF0) |
                (1u << EXTI_INTF1) |
                (1u << EXTI_INTF2));

    return E_OK;
}

STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense)
{
    if (Copy_u8Sense > EXTI_RISING_EDGE)
    {
        return E_NOK;
    }

    if (Copy_u8Int == EXTI_INT0)
    {
        EXTI_MCUCR =
            (uint8)((EXTI_MCUCR & (uint8)~((1u << EXTI_ISC00) |
                                           (1u << EXTI_ISC01))) |
                    (uint8)(Copy_u8Sense << EXTI_ISC00));

        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT1)
    {
        EXTI_MCUCR =
            (uint8)((EXTI_MCUCR & (uint8)~((1u << EXTI_ISC10) |
                                           (1u << EXTI_ISC11))) |
                    (uint8)(Copy_u8Sense << EXTI_ISC10));

        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT2)
    {
        if (Copy_u8Sense == EXTI_LOW_LEVEL ||
            Copy_u8Sense == EXTI_ANY_CHANGE)
        {
            return E_NOK;
        }

        if (Copy_u8Sense == EXTI_FALLING_EDGE)
        {
            EXTI_MCUCSR &= (uint8)~(1u << EXTI_ISC2);
        }
        else
        {
            EXTI_MCUCSR |= (uint8)(1u << EXTI_ISC2);
        }

        return E_OK;
    }

    return E_NOK;
}

STD_ReturnType EXTI_Enable(uint8 Copy_u8Int)
{
    if (Copy_u8Int == EXTI_INT0)
    {
        EXTI_GICR |= (uint8)(1u << EXTI_INT0_ENABLE);
        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT1)
    {
        EXTI_GICR |= (uint8)(1u << EXTI_INT1_ENABLE);
        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT2)
    {
        EXTI_GICR |= (uint8)(1u << EXTI_INT2_ENABLE);
        return E_OK;
    }

    return E_NOK;
}

STD_ReturnType EXTI_Disable(uint8 Copy_u8Int)
{
    if (Copy_u8Int == EXTI_INT0)
    {
        EXTI_GICR &= (uint8)~(1u << EXTI_INT0_ENABLE);
        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT1)
    {
        EXTI_GICR &= (uint8)~(1u << EXTI_INT1_ENABLE);
        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT2)
    {
        EXTI_GICR &= (uint8)~(1u << EXTI_INT2_ENABLE);
        return E_OK;
    }

    return E_NOK;
}

STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int)
{
    if (Copy_u8Int == EXTI_INT0)
    {
        EXTI_GIFR = (uint8)(1u << EXTI_INTF0);
        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT1)
    {
        EXTI_GIFR = (uint8)(1u << EXTI_INTF1);
        return E_OK;
    }

    if (Copy_u8Int == EXTI_INT2)
    {
        EXTI_GIFR = (uint8)(1u << EXTI_INTF2);
        return E_OK;
    }

    return E_NOK;
}

STD_ReturnType EXTI_SetCallback(
    uint8 Copy_u8Int,
    EXTI_CallbackType Copy_pfCallback)
{
    if (Copy_u8Int > EXTI_INT2 || Copy_pfCallback == NULL)
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