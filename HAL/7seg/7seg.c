#include "7seg.h"
#include "config.h"
#include "dio_interface.h"

static const uint8 SEG_au8Pins[4] =
{
    SEG7_A_PIN, SEG7_B_PIN, SEG7_C_PIN, SEG7_D_PIN
};

static uint8 SEG_u8Shadow  = SEG7_BLANK_CODE;
static uint8 SEG_u8Primed  = 0u;

static STD_ReturnType SEG_WriteNibble(uint8 Copy_u8Code);

STD_ReturnType SEG_Init(void)
{
    uint8 Local_u8Index;

    for (Local_u8Index = 0u; Local_u8Index < 4u; Local_u8Index++)
    {
        if (DIO_Init(SEG7_PORT,
                     SEG_au8Pins[Local_u8Index],
                     DIO_OUTPUT) != E_OK)
        {
            return E_NOK;
        }
    }

    SEG_u8Primed = 0u;
    return SEG_Blank();
}

STD_ReturnType SEG_Show(uint8 Copy_u8Value)
{
    uint8 Local_u8Code = (Copy_u8Value > SEG7_MAX_DIGIT)
                       ? SEG7_BLANK_CODE
                       : Copy_u8Value;

    if ((SEG_u8Primed != 0u) && (Local_u8Code == SEG_u8Shadow))
    {
        return E_OK;                 /* digit unchanged - no pin toggling */
    }

    if (SEG_WriteNibble(Local_u8Code) != E_OK)
    {
        return E_NOK;
    }

    SEG_u8Shadow = Local_u8Code;
    SEG_u8Primed = 1u;
    return E_OK;
}

STD_ReturnType SEG_Blank(void)
{
    return SEG_Show(SEG7_BLANK_CODE);
}

uint8 SEG_GetShadow(void)
{
    return SEG_u8Shadow;
}

static STD_ReturnType SEG_WriteNibble(uint8 Copy_u8Code)
{
    uint8 Local_u8Index;
    uint8 Local_u8Level;

    for (Local_u8Index = 0u; Local_u8Index < 4u; Local_u8Index++)
    {
        Local_u8Level = ((Copy_u8Code & (uint8)(1u << Local_u8Index)) != 0u)
                      ? DIO_HIGH
                      : DIO_LOW;

        if (DIO_WritePin(SEG7_PORT,
                         SEG_au8Pins[Local_u8Index],
                         Local_u8Level) != E_OK)
        {
            return E_NOK;
        }
    }

    return E_OK;
}