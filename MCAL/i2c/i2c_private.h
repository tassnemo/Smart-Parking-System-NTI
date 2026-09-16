#ifndef I2C_PRIVATE_H
#define I2C_PRIVATE_H

#include "STD_TYPES.h"

/* ---------------- TWI registers (ATmega32) ---------------- */
#define I2C_TWBR (*(volatile uint8 *)0x20)
#define I2C_TWSR (*(volatile uint8 *)0x21)
#define I2C_TWAR (*(volatile uint8 *)0x22)
#define I2C_TWDR (*(volatile uint8 *)0x23)
#define I2C_TWCR (*(volatile uint8 *)0x56)

/* ---------------- TWSR bits and status values ---------------- */
#define I2C_TWPS0 0u
#define I2C_TWPS1 1u
#define I2C_TWS_MASK 0xF8u

#define I2C_STATUS_START         0x08u
#define I2C_STATUS_REP_START     0x10u
#define I2C_STATUS_MT_SLA_ACK    0x18u
#define I2C_STATUS_MT_DATA_ACK   0x28u
#define I2C_STATUS_MR_SLA_ACK    0x40u
#define I2C_STATUS_MR_DATA_ACK   0x50u
#define I2C_STATUS_MR_DATA_NACK  0x58u

/* ---------------- TWCR bits ---------------- */
#define I2C_TWINT 7u
#define I2C_TWEA  6u
#define I2C_TWSTA 5u
#define I2C_TWSTO 4u
#define I2C_TWEN  2u

#endif /* I2C_PRIVATE_H */
