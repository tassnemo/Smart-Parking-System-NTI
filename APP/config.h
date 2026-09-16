#ifndef CONFIG_H
#define CONFIG_H

/* =========================
 * System
 * ========================= */
#define F_CPU                       8000000UL

#define SYSTEM_TICK_MS              10u

/* =========================
 * Parking lot
 * ========================= */
#define SLOT_COUNT                  6u
#define TICKET_MAX                  6u

/* =========================
 * ADC channels
 * ========================= */
#define ADC_ENTRY_LOOP_CHANNEL      0u
#define ADC_EXIT_LOOP_CHANNEL       1u
#define ADC_LIGHT_CHANNEL           2u

#define LOOP_PRESENT_RAW            600u
#define LOOP_CLEAR_RAW              400u

/* Number of 10 ms samples required */
#define LOOP_DEBOUNCE_TICKS         20u

/* =========================
 * Slot sensors
 * PC2 ... PC7
 * ========================= */
#define SLOT_PORT                   2u
#define SLOT_FIRST_PIN              2u
#define SLOT_MASK                   0xFCu

#define SLOT_DEBOUNCE_TICKS         5u

/* =========================
 * Servo / Timer1
 * ========================= */
#define PWM_CH_ENTRY                0u
#define PWM_CH_EXIT                 1u

#define SERVO_CLOSED_US             1000u
#define SERVO_OPEN_US               2000u

#define PWM_TOP                     19999u

/* =========================
 * Lane timing
 * ========================= */
#define GATE_TRAVEL_TICKS           100u    /* 1 second */
#define GATE_HOLD_DEFAULT_SEC       5u

#define GATE_HOLD_MIN_SEC           2u
#define GATE_HOLD_MAX_SEC           15u

#define PASS_TIMEOUT_DEFAULT_SEC    20u
#define PASS_TIMEOUT_MIN_SEC        10u
#define PASS_TIMEOUT_MAX_SEC        60u

#define REJECT_TICKS                200u    /* 2 seconds */

/* =========================
 * Lighting
 * ========================= */
#define LIGHT_THRESHOLD_DEFAULT     30u
#define LIGHT_HYSTERESIS_PERCENT    10u

/* =========================
 * Tariff
 * ========================= */
#define TARIFF_DEFAULT              10u
#define TARIFF_MIN                  1u
#define TARIFF_MAX                  100u

#define GRACE_DEFAULT_MINUTES       15u
#define GRACE_MIN_MINUTES           0u
#define GRACE_MAX_MINUTES           60u

#define DAILY_CAP                   120u

/* =========================
 * Ticket IDs
 * ========================= */
#define TICKET_ID_FIRST             1u
#define TICKET_ID_LAST              9999u

/* =========================
 * Configuration
 * ========================= */
#define PRK_MAGIC                   0x5041u
#define PRK_VERSION                 0x01u

/* =========================
 * UART
 * ========================= */
#define UART_BAUD_RATE              9600UL
#define UART_RX_BUFFER_SIZE         64u
#define CONSOLE_MAX_LINE            24u

/* =========================
 * SPI / 74HC595
 * ========================= */
#define SHIFTREG_RCLK_PORT          1u
#define SHIFTREG_RCLK_PIN           4u

/* =========================
 * I2C / TWI
 * ========================= */
#define I2C_SCL_FREQUENCY           100000UL
#define I2C_TIMEOUT                 65535u

/* =========================
 * Buttons
 * ========================= */
#define BTN_EXIT_PIN                2u
#define BTN_MAINTENANCE_PIN         3u

/* =========================
 * Indicators
 * ========================= */
#define FULL_SIGN_PORT              3u
#define FULL_SIGN_PIN               6u

#define BUZZER_PORT                 3u
#define BUZZER_PIN                  7u

/* =========================
 * Scheduler periods
 * ========================= */
#define TASK_LANES_PERIOD           1u
#define TASK_BUTTONS_PERIOD         1u
#define TASK_LOT_PERIOD             1u
#define TASK_SLOTS_PERIOD           5u
#define TASK_LOOPS_PERIOD           5u
#define TASK_DISPLAY_PERIOD         25u
#define TASK_1HZ_PERIOD             100u
#define TASK_REPORT_PERIOD          500u
#define TASK_CONSOLE_PERIOD         2u

#endif