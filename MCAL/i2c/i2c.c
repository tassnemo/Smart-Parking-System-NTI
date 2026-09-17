#include "i2c_interface.h"
#include "dio_interface.h"
#include "config.h"
#include <util/delay.h>

/* ============================================================================
 * Software (bit-banged) I2C/TWI on PC0 = SCL, PC1 = SDA.
 *
 * WHY THIS EXISTS: the hardware TWI driver (register-level, TWCR/TWDR/TWSR)
 * was verified correct against the ATmega32 datasheet - correct register
 * addresses, correct bit positions, correct TWBR math for 100 kHz @ 8 MHz,
 * correct TWINT wait logic. Wiring and pull-ups were independently verified
 * with a plain-GPIO toggle test (PC0/PC1 visibly switched high/low). But a
 * Logic Analyzer capture on SDA/SCL during a real LCD transaction showed a
 * completely flat line - the hardware TWI peripheral is not being driven
 * onto the physical pins by this SimulIDE build's ATmega32 model.
 *
 * This file implements the exact same six-function API
 * (I2C_Init/Start/Stop/Write/ReadAck/ReadNack) using timed DIO_WritePin /
 * DIO_Init calls instead, so lcd_i2c.c, config.h and everything above this
 * layer needs ZERO changes.
 *
 * Open-drain emulation: I2C lines are only ever pulled LOW by an active
 * output, or "released" (switched to input + internal pull-up) so the
 * external 4.7k resistor pulls the line back HIGH. Neither line is ever
 * actively driven high - this matches real I2C electrical behaviour and
 * means a stuck slave holding the bus low can never cause a drive fight.
 *
 * Timing: ~100 kHz bit rate via short _delay_us() calls. These are NOT the
 * kind of blocking delay NFR-02 forbids (that rule targets >10 ms holds in
 * the super-loop) - a full byte transfer here costs on the order of tens of
 * microseconds, negligible against the 10 ms scheduler tick.
 * ==========================================================================*/

#define I2C_SCL_PORT    DIO_PORTC
#define I2C_SCL_PIN     DIO_PIN0
#define I2C_SDA_PORT    DIO_PORTC
#define I2C_SDA_PIN     DIO_PIN1

#define I2C_DELAY()          _delay_us(20)  /* ~25 kHz half-bit - generous
                                              * margin against bit-bang jitter
                                              * accumulating over long (16-byte)
                                              * transfers; still microseconds
                                              * against a 10 ms scheduler tick */
#define I2C_BUS_FREE_DELAY() _delay_us(60)  /* settling time after STOP so the
                                              * AiP31068 finishes executing the
                                              * last command/write before the
                                              * next START arrives */

static void I2C_SclLow(void)
{
    DIO_Init(I2C_SCL_PORT, I2C_SCL_PIN, DIO_OUTPUT);
    DIO_WritePin(I2C_SCL_PORT, I2C_SCL_PIN, DIO_LOW);
}

static void I2C_SclRelease(void)
{
    /* input + internal pull-up: lets the external 4.7k pull the line high */
    DIO_Init(I2C_SCL_PORT, I2C_SCL_PIN, DIO_INPUT_PULLUP);
}

static void I2C_SdaLow(void)
{
    DIO_Init(I2C_SDA_PORT, I2C_SDA_PIN, DIO_OUTPUT);
    DIO_WritePin(I2C_SDA_PORT, I2C_SDA_PIN, DIO_LOW);
}

static void I2C_SdaRelease(void)
{
    DIO_Init(I2C_SDA_PORT, I2C_SDA_PIN, DIO_INPUT_PULLUP);
}

static uint8 I2C_SdaRead(void)
{
    uint8 Local_u8Val = 0u;
    DIO_ReadPin(I2C_SDA_PORT, I2C_SDA_PIN, &Local_u8Val);
    return Local_u8Val;
}

static STD_ReturnType I2C_WriteBit(uint8 Copy_u8Bit)
{
    if (Copy_u8Bit != 0u) { I2C_SdaRelease(); } else { I2C_SdaLow(); }
    I2C_DELAY();

    I2C_SclRelease();             /* clock rises - slave samples SDA now */
    I2C_DELAY();

    I2C_SclLow();                 /* clock falls - safe to change SDA next */
    I2C_DELAY();

    return E_OK;
}

static uint8 I2C_ReadBit(void)
{
    uint8 Local_u8Bit;

    I2C_SdaRelease();              /* let the slave (or pull-up) drive SDA */
    I2C_DELAY();

    I2C_SclRelease();              /* clock rises - data is valid now */
    I2C_DELAY();
    Local_u8Bit = I2C_SdaRead();

    I2C_SclLow();
    I2C_DELAY();

    return Local_u8Bit;
}

STD_ReturnType I2C_Init(void)
{
    I2C_SclRelease();
    I2C_SdaRelease();
    I2C_DELAY();
    return E_OK;
}

STD_ReturnType I2C_Start(void)
{
    /* Idle: both lines high. START = SDA falls while SCL is still high. */
    I2C_SdaRelease();
    I2C_SclRelease();
    I2C_DELAY();

    I2C_SdaLow();
    I2C_DELAY();

    I2C_SclLow();                  /* park SCL low, ready to clock data */
    I2C_DELAY();

    return E_OK;
}

STD_ReturnType I2C_Stop(void)
{
    /* STOP = SDA rises while SCL is high. */
    I2C_SdaLow();
    I2C_DELAY();

    I2C_SclRelease();
    I2C_DELAY();

    I2C_SdaRelease();
    I2C_DELAY();
    I2C_BUS_FREE_DELAY();

    return E_OK;
}

STD_ReturnType I2C_Write(uint8 Copy_u8Data)
{
    sint8  Local_s8Index;
    uint8 Local_u8Ack;

    for (Local_s8Index = 7; Local_s8Index >= 0; Local_s8Index--)
    {
        I2C_WriteBit((uint8)((Copy_u8Data >> Local_s8Index) & 0x01u));
    }

    /* 9th clock: slave pulls SDA low to ACK */
    Local_u8Ack = I2C_ReadBit();

    return (Local_u8Ack == 0u) ? E_OK : E_NOK;
}

STD_ReturnType I2C_ReadAck(uint8 *Copy_pu8Data)
{
    uint8 Local_u8Index;
    uint8 Local_u8Data = 0u;

    if (Copy_pu8Data == NULL)
    {
        return E_NOK;
    }

    for (Local_u8Index = 0u; Local_u8Index < 8u; Local_u8Index++)
    {
        Local_u8Data = (uint8)((Local_u8Data << 1) | I2C_ReadBit());
    }

    I2C_WriteBit(0u);   /* master ACKs: tells the slave "send another byte" */

    *Copy_pu8Data = Local_u8Data;
    return E_OK;
}

STD_ReturnType I2C_ReadNack(uint8 *Copy_pu8Data)
{
    uint8 Local_u8Index;
    uint8 Local_u8Data = 0u;

    if (Copy_pu8Data == NULL)
    {
        return E_NOK;
    }

    for (Local_u8Index = 0u; Local_u8Index < 8u; Local_u8Index++)
    {
        Local_u8Data = (uint8)((Local_u8Data << 1) | I2C_ReadBit());
    }

    I2C_WriteBit(1u);   /* master NACKs: tells the slave "that's the last byte" */

    *Copy_pu8Data = Local_u8Data;
    return E_OK;
}