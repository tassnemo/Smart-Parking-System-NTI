#ifndef CONFIG_H
#define CONFIG_H

/* ============================================================================
 * PRJ-02-PARKING  -  central configuration
 *
 * This file is aligned with the SimulIDE schematic "parking_sim2", NOT with the
 * generic component list in the project brief.  Differences that are deliberate
 * are marked [DEV-n] and are explained in Docs/CIRCUIT_AUDIT.md.
 *
 * Port index convention used by the DIO driver:  0 = A, 1 = B, 2 = C, 3 = D
 * ==========================================================================*/

/* =========================
 * System
 * ========================= */
#define F_CPU                       8000000UL

#define SYSTEM_TICK_MS              10u
#define TICKS_PER_SECOND            (1000u / SYSTEM_TICK_MS)        /* 100 */
#define SEC_TO_TICKS(s)             ((uint16)((s) * TICKS_PER_SECOND))
#define MS_TO_TICKS(ms)             ((uint16)((ms) / SYSTEM_TICK_MS))

/* Timer0 CTC 10 ms tick: 8 MHz / 1024 = 7812.5 Hz -> OCR0 = 77 (9.98 ms) */
#define TICK_TIMER_OCR0             77u

/* =========================
 * Parking lot
 * ========================= */
#define SLOT_COUNT                  6u
#define TICKET_MAX                  6u

/* =========================
 * ADC channels  (PA0/PA1/PA2, pots "entry" / "exit" / "light")
 * ========================= */
#define ADC_ENTRY_LOOP_CHANNEL      0u
#define ADC_EXIT_LOOP_CHANNEL       1u
#define ADC_LIGHT_CHANNEL           2u

#define LOOP_PRESENT_RAW            600u
#define LOOP_CLEAR_RAW              400u

/* [FIX-1] The loop sensors are sampled by Task_Loops every 50 ms, so the
 * 200 ms confirmation of FR-05 is 4 CONSECUTIVE SAMPLES, not 20 ticks.
 * The old value (20) gave a 1 s detection latency and failed TC-10.          */
#define TASK_LOOPS_PERIOD_MS        50u
#define LOOP_DEBOUNCE_SAMPLES       4u      /* 4 x 50 ms = 200 ms */

/* =========================
 * Slot sensors  (car1..car6 -> PC2..PC7, switch to GND, internal pull-up)
 * slotMap = (uint8)((~PINC & SLOT_MASK) >> SLOT_FIRST_PIN)   -> ONE PINC read
 * ========================= */
#define SLOT_PORT                   2u      /* PORTC */
#define SLOT_FIRST_PIN              2u
#define SLOT_MASK                   0xFCu   /* PC2..PC7 */
#define SLOT_MAP_MASK               0x3Fu   /* 6 valid bits after the shift */

/* [FIX-2] Slots are sampled every 10 ms and need 5 equal samples = 50 ms
 * debounce (FR-01 / TC-06).  The old 5 "ticks" at a 50 ms task period gave
 * 250 ms and broke the "updates within 50 ms" acceptance criterion.          */
#define TASK_SLOTS_PERIOD_MS        10u
#define SLOT_DEBOUNCE_SAMPLES       5u      /* 5 x 10 ms = 50 ms */

/* =========================
 * Servo / Timer1  (Fast PWM mode 14, ICR1 TOP, prescaler 8 -> 1 us/tick)
 * OC1A = PD5 = entry barrier ("entryb")
 * OC1B = PD4 = exit  barrier ("exitb")
 * ========================= */
#define PWM_CH_ENTRY                0u      /* -> OCR1A */
#define PWM_CH_EXIT                 1u      /* -> OCR1B */

#define SERVO_CLOSED_US             1500u
#define SERVO_OPEN_US               2000u

#define PWM_TOP                     19999u  /* 20.000 ms frame */
#define PWM_PRESCALER               8u

/* =========================
 * Lane timing
 * ========================= */
#define GATE_TRAVEL_TICKS           100u    /* 1 s */
#define GATE_HOLD_DEFAULT_SEC       5u
#define GATE_HOLD_MIN_SEC           2u
#define GATE_HOLD_MAX_SEC           15u

#define PASS_TIMEOUT_DEFAULT_SEC    20u
#define PASS_TIMEOUT_MIN_SEC        10u
#define PASS_TIMEOUT_MAX_SEC        60u

#define REJECT_TICKS                200u    /* 2 s */
#define FEE_DISPLAY_TICKS           300u    /* 3 s  (FR-10) */
#define TIMEOUT_BEEP_COUNT          3u
#define TIMEOUT_BEEP_TICKS          15u     /* 150 ms on / 150 ms off */

/* =========================
 * Lighting
 * ========================= */
#define LIGHT_THRESHOLD_DEFAULT     30u     /* percent */
#define LIGHT_HYSTERESIS_PERCENT    10u
#define LIGHT_PCT_TO_RAW(p)         ((uint16)(((uint32)(p) * 1023u) / 100u))

/* =========================
 * Tariff
 * ========================= */
#define TARIFF_DEFAULT              10u
#define TARIFF_MIN                  1u
#define TARIFF_MAX                  100u

#define GRACE_DEFAULT_MINUTES       15u
#define GRACE_MIN_MINUTES           0u
#define GRACE_MAX_MINUTES           60u

#define DAILY_CAP                   120u    /* keep fee maths in uint16 */

/* =========================
 * Ticket IDs
 * ========================= */
#define TICKET_ID_FIRST             1u
#define TICKET_ID_LAST              9999u

/* =========================
 * Configuration blob
 * ========================= */
#define PRK_MAGIC                   0x5041u
#define PRK_VERSION                 0x01u

/* =========================
 * UART  (PD0 rx / PD1 tx -> SerialPort component)
 * ========================= */
#define UART_BAUD_RATE              9600UL
#define UART_RX_BUFFER_SIZE         64u
#define UART_TX_BUFFER_SIZE         128u    /* ticket/receipt frames are long */
#define CONSOLE_MAX_LINE            24u

/* =========================
 * SPI  ->  74HC4094 chain          [DEV-1] brief says 74HC595
 * PB5 MOSI = "data", PB7 SCK = "clock", PB4 = "strobe" (4094 STR, active HIGH)
 * PB6 MISO is unused (master, no slave output).
 *
 * 4094 vs 595:
 *   - STR is a LEVEL-sensitive transparent latch: idle LOW, pulse HIGH to
 *     publish, then back LOW.  Same waveform as RCLK, different semantics.
 *   - OE is ACTIVE HIGH and MUST be wired to VCC.  Tied to GND the outputs
 *     are high-Z and nothing ever lights up.   <-- see CIRCUIT_AUDIT A-1
 *   - Cascade is U1.QS' -> U2.D ("overflow" net).
 * ========================= */
#define SHIFTREG_RCLK_PORT          1u      /* PORTB */
#define SHIFTREG_RCLK_PIN           4u      /* "strobe" */
#define SHIFTREG_COUNT              2u      /* U1 = 744094-150, U2 = 744094-142 */

/* SPI master, Mode 0 (sample on rising SCK), MSB first, fosc/16 = 500 kHz.
 * If the SimulIDE 4094 symbol shows an INVERTED clock pin (-CK), use Mode 2
 * (CPOL = 1, CPHA = 0) instead - one line in SPI_Init.                       */
#define SPI_CLOCK_MODE              0u
#define SPI_PRESCALER               16u

/* ---- Shift register bit map ------------------------------------------------
 * The 16-bit word is transmitted HIGH BYTE FIRST: the first bits clocked out
 * travel through U1 and land in U2.
 *
 * U1 (744094-150) = LOW byte           U2 (744094-142) = HIGH byte
 *   Q0 led1r  Q1 led1g                   Q0 led5r  Q1 led5g
 *   Q2 led2r  Q3 led2g                   Q2 led6r  Q3 led6g
 *   Q4 led3r  Q5 led3g                   Q4 lightled   (lot lamp)
 *   Q6 led4r  Q7 led4g                   Q5..Q7 spare
 * -------------------------------------------------------------------------*/
#define SR_SLOT_LED_PAIRS           6u
#define SR_BIT_SLOT_RED(i)          ((i) < 4u ? (uint16)(1u << ((i) * 2u))       \
                                              : (uint16)(1u << (((i) - 4u) * 2u + 8u)))
#define SR_BIT_SLOT_GREEN(i)        ((i) < 4u ? (uint16)(1u << ((i) * 2u + 1u))  \
                                              : (uint16)(1u << (((i) - 4u) * 2u + 9u)))
#define SR_BIT_LOT_LAMP             ((uint16)0x1000u)   /* U2.Q4 */
#define SR_SPARE_MASK               ((uint16)0xE000u)   /* U2.Q5..Q7 */

/* =========================
 * 7-segment  ->  74HC4511 BCD decoder      [DEV-2] brief allows "BCD -> decoder"
 * PB0..PB3 = A,B,C,D.  LT and BL are tied HIGH (inactive), LE tied LOW
 * (transparent), so the digit follows the nibble with no latch pulse.
 * Codes 10..15 blank the display - that is how SEG_Blank() works.
 *
 * IMPORTANT: PB4/PB5/PB7 on the same port carry SPI.  seg7 writes the four
 * pins INDIVIDUALLY; never do a whole-PORTB write.
 * ========================= */
#define SEG7_PORT                   1u      /* PORTB */
#define SEG7_A_PIN                  0u
#define SEG7_B_PIN                  1u
#define SEG7_C_PIN                  2u
#define SEG7_D_PIN                  3u
#define SEG7_BLANK_CODE             0x0Fu
#define SEG7_MAX_DIGIT              9u

/* =========================
 * I2C / TWI  ->  AiP31068 LCD      [DEV-3] brief says PCF8574 + HD44780
 * PC0 = SCL, PC1 = SDA, both need 4.7k pull-ups to VCC.
 *
 * The AiP31068 is a NATIVE I2C character controller: there is no nibble
 * mode and no backlight/EN bit shuffling.  Every frame is
 *      START, (addr<<1|W), control byte, payload..., STOP
 * control 0x00 = commands follow, 0x40 = data follows.
 * ========================= */
#define I2C_SCL_FREQUENCY           100000UL
#define I2C_TIMEOUT                 65535u

#define LCD_I2C_ADDRESS             0x3Eu   /* 7-bit; bus shows 0x7C on write  */
#define LCD_CTRL_COMMAND            0x00u
#define LCD_CTRL_DATA               0x40u
#define LCD_COLS                    16u
#define LCD_ROWS                    2u
#define LCD_ROW0_ADDR               0x00u
#define LCD_ROW1_ADDR               0x40u

/* =========================
 * Buttons  (to GND, internal pull-up, falling edge)
 * ========================= */
#define BTN_PORT                    3u      /* PORTD */
#define BTN_EXIT_PIN                2u      /* INT0, net "exitbtn"  */
#define BTN_MAINTENANCE_PIN         3u      /* INT1, net "maintbtn" */
#define BTN_DEBOUNCE_TICKS          3u      /* 30 ms in software, ISR only flags */

/* =========================
 * Indicators
 * ========================= */
#define FULL_SIGN_PORT              3u      /* PD6, net "fled" (red) */
#define FULL_SIGN_PIN               6u

/* [DEV-4] There is no discrete green VACANT lamp on the canvas.  VACANT is
 * shown by the per-slot green LEDs on the shift register chain.  If you add a
 * dedicated green LED, PA3 is free - enable the two defines below.           */
/* #define VACANT_SIGN_PORT         0u */
/* #define VACANT_SIGN_PIN          3u */

#define BUZZER_PORT                 3u      /* PD7 / OC2 */
#define BUZZER_PIN                  7u

/* =========================
 * Scheduler periods (units of SYSTEM_TICK_MS)
 * ========================= */
#define TASK_LANES_PERIOD           1u      /*  10 ms */
#define TASK_BUTTONS_PERIOD         1u      /*  10 ms */
#define TASK_LOT_PERIOD             1u      /*  10 ms */
#define TASK_SLOTS_PERIOD           1u      /*  10 ms  [FIX-2] was 5  */
#define TASK_LOOPS_PERIOD           5u      /*  50 ms */
#define TASK_DISPLAY_PERIOD         25u     /* 250 ms */
#define TASK_1HZ_PERIOD             100u    /*   1 s  */
#define TASK_REPORT_PERIOD          500u    /*   5 s  */
#define TASK_CONSOLE_PERIOD         2u      /*  20 ms */

/* [FIX-3] FR-16 rate-limits the shift-register refresh to one write per 10 s.
 * That rule was written for a 595 driving a digit; here the chain drives the
 * slot status LEDs, which must track the sensors.  The driver writes only when
 * the 16-bit word actually CHANGES (see slotleds.c), which is strictly better
 * than a timer and costs nothing when the lot is idle.  Document this.       */
#define SR_WRITE_ON_CHANGE_ONLY     1u

#endif /* CONFIG_H */