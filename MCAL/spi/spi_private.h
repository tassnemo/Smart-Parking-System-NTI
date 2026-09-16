#ifndef SPI_PRIVATE_H
#define SPI_PRIVATE_H

#include "STD_TYPES.h"

/* ---------------- SPI registers (ATmega32) ---------------- */
#define SPI_SPCR (*(volatile uint8 *)0x2D)
#define SPI_SPSR (*(volatile uint8 *)0x2E)
#define SPI_SPDR (*(volatile uint8 *)0x2F)
#define SPI_DDRB (*(volatile uint8 *)0x37)

#define SPI_MOSI_PIN 5u
#define SPI_MISO_PIN 6u
#define SPI_SCK_PIN  7u

/* ---------------- SPCR bits ---------------- */
#define SPI_SPIE 7u
#define SPI_SPE  6u
#define SPI_DORD 5u
#define SPI_MSTR 4u
#define SPI_CPOL 3u
#define SPI_CPHA 2u
#define SPI_SPR1 1u
#define SPI_SPR0 0u

/* ---------------- SPSR bits ---------------- */
#define SPI_SPIF 7u
#define SPI_WCOL 6u
#define SPI_SPI2X 0u

#endif /* SPI_PRIVATE_H */
