

.RECIPEPREFIX := >

MCU      ?= atmega32
F_CPU    ?= 8000000UL
TARGET   ?= program

BUILD_DIR := build

CC      := avr-gcc
OBJCOPY := avr-objcopy
OBJDUMP := avr-objdump
SIZE    := avr-size

CFLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -std=gnu99 \
          -ffunction-sections -fdata-sections -MMD -MP

LDFLAGS := -mmcu=$(MCU) -Wl,--gc-sections \
           -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

SRCS := $(wildcard *.c)
SRCS += $(wildcard */*.c)
SRCS += $(wildcard */*/*.c)
SRCS += $(wildcard */*/*/*.c)
SRCS += $(wildcard */*/*/*/*.c)
SRCS := $(filter-out $(BUILD_DIR)/%,$(SRCS))

HDRS := $(wildcard *.h)
HDRS += $(wildcard */*.h)
HDRS += $(wildcard */*/*.h)
HDRS += $(wildcard */*/*/*.h)
HDRS += $(wildcard */*/*/*/*.h)
HDRS := $(filter-out $(BUILD_DIR)/%,$(HDRS))

ifeq ($(strip $(SRCS)),)
$(error No .c files found)
endif

OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))
PREPROCS := $(patsubst %.c,$(BUILD_DIR)/%.i,$(SRCS))
ASMS := $(patsubst %.c,$(BUILD_DIR)/%.s,$(SRCS))
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(sort . LIB MCAL HAL Logic $(dir $(SRCS)) $(dir $(HDRS)))
INCLUDES := $(addprefix -I,$(INC_DIRS))

.PHONY: all clean size verify

all: $(BUILD_DIR)/$(TARGET).elf \
     $(BUILD_DIR)/$(TARGET).hex \
     $(BUILD_DIR)/$(TARGET).bin \
     $(PREPROCS) \
     $(ASMS) \
     size

$(BUILD_DIR)/%.i: %.c
>mkdir -p $(dir $@)
>$(CC) $(CFLAGS) $(INCLUDES) -E $< -o $@

$(BUILD_DIR)/%.s: %.c
>mkdir -p $(dir $@)
>$(CC) $(CFLAGS) $(INCLUDES) -S $< -o $@

$(BUILD_DIR)/%.o: %.c
>mkdir -p $(dir $@)
>$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
>mkdir -p $(BUILD_DIR)
>$(CC) $(LDFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
>$(OBJCOPY) -O ihex -R .eeprom $< $@
>@echo HEX ready: $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
>$(OBJCOPY) -O binary -R .eeprom $< $@
>@echo BIN ready: $@

size: $(BUILD_DIR)/$(TARGET).elf
>$(SIZE) $<

verify: all
>@echo BUILD_OK MCU=$(MCU) F_CPU=$(F_CPU) SRCS=$(SRCS)

clean:
>rm -rf $(BUILD_DIR)
>@echo Cleaned $(BUILD_DIR)

-include $(DEPS)