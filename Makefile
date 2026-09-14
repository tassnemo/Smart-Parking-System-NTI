.RECIPEPREFIX := >

CC = avr-gcc
OBJCOPY = avr-objcopy

MCU = atmega32
CFLAGS = -Wall -Os -mmcu=$(MCU) -I. -I./LIB
TARGET = app

SOURCES =main.c \
          LIB/ring_buffer.c \
          MCAL/exti/exti.c \
          MCAL/timer/timer.c \
          MCAL/pwm/pwm.c \
          MCAL/dio/dio.c
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET).hex

$(TARGET).elf: $(OBJECTS)
>$(CC) -mmcu=$(MCU) -o $@ $(OBJECTS)

$(TARGET).hex: $(TARGET).elf
>$(OBJCOPY) -O ihex -R .eeprom $< $@

%.o: %.c
>$(CC) $(CFLAGS) -c $< -o $@

clean:
>rm -f $(OBJECTS) $(TARGET).elf $(TARGET).hex