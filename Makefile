.RECIPEPREFIX := >

CC = avr-gcc
OBJCOPY = avr-objcopy

MCU = atmega32
CFLAGS = -Wall -Os -mmcu=$(MCU) -I. -I./LIB
BUILD_DIR = build
TARGET = $(BUILD_DIR)/app

SOURCES := main.c \
           LIB/ring_buffer.c \
           MCAL/exti/exti.c \
           MCAL/timer/timer.c \
           MCAL/pwm/pwm.c \
           MCAL/dio/dio.c \
           HAL/buzzer/buzzer.c \
           HAL/buttons/buttons.c \
           HAL/barrier/barrier.c \
           HAL/slots/slots.c

OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SOURCES))

all: $(TARGET).hex

$(TARGET).elf: $(OBJECTS)
>mkdir -p $(dir $@)
>$(CC) -mmcu=$(MCU) -o $@ $(OBJECTS)

$(TARGET).hex: $(TARGET).elf
>$(OBJCOPY) -O ihex -R .eeprom $< $@

$(BUILD_DIR)/%.o: %.c
>mkdir -p $(dir $@)
>$(CC) $(CFLAGS) -c $< -o $@

clean:
>rm -rf $(BUILD_DIR)