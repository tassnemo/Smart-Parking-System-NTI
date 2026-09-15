# Driver & Module Plan — PRJ-02-PARKING

> This section documents the full driver/module inventory required to implement
> the spec, including modules that are implied by the requirements but not
> explicitly named in the layer diagram (§9.1) or module table (§9.3).

---

## MCAL (register-level — only layer allowed to touch hardware, NFR-08): "how do I even talk to this chip"

| Driver | Functions | Why | Time | Name | Check |
|---|---|---|---|---|---|
| `dio.c/h` | `DIO_Init(port,pin,dir)`, `DIO_Write`, `DIO_Read`, `DIO_ReadPort` | Must expose a whole-port read (not per-pin) to satisfy the single `PINC`-read requirement in FR-01 | Sept 14 | Tasneem | x |
| `adc.c/h` | `ADC_Init`, `ADC_Read(channel)` | 3 channels, single-conversion, prescaler 64, for reading the dials (potentiometers). The chip doesn't understand "a car is here"; it just reads a number 0–1023 from a voltage. ADC = Analog-to-Digital Converter. | Sept 15 |  Souad|  x  |
| `timer.c/h` | `TMR0_InitCTC()`, ISR for `OCR0` compare | Generates the 10 ms system tick everything else is scheduled from | Sept 14 | Tasneem | x |
| `pwm.c/h` | `PWM_Init()` (Timer1 mode 14), `PWM_SetPulse(channel, us)` | Only legal way to move a servo — writes `OCR1A`/`OCR1B` directly (NFR-05) | Sept 14 | Tasneem | x |
| `exti.c/h` | `EXTI_Init()`, minimal ISR stubs for INT0/INT1 that set a flag | ISRs must stay ≤10 lines (NFR-09); debounce logic lives above this layer | Sept 14 | Tasneem | x |
| `usart.c/h` | `USART_Init`, `USART_SendByte/String`, RX ISR → ring buffer | Needs the shared ring buffer from LIB, ≥32 bytes (NFR-14) | Sept 15 |  |  |
| `spi.c/h` | `SPI_Init`, `SPI_Transfer(byte)` | Master, mode 0, f/16, for the 74HC595 | Sept 15 |  |  |
| `i2c.c/h` | `I2C_Init`, `I2C_Start/Stop/Write/Read` | 100 kHz master for the PCF8574 → LCD path | Sept 15 |  |  |

## HAL (peripheral abstractions — no bit-banging outside this layer : "what does this specific accessory do")
| Module | Functions | Why / Notes | Time | Name | Check |
|---|---|---|---|---|---|
| `slots.c/h` | `SLOT_Poll()`, `SLOT_GetMap()`, `SLOT_CountFree()` | Owns `popcount6()` from §10.6, reads the 6 switches and keeps track of which spots are occupied. | Sept 14 | Tasneem | x |
| `barrier.c/h` | `BAR_Open(ch)`, `BAR_Close(ch)`, `BAR_IsMoving(ch)` | Thin wrapper over `pwm.c` so `lane_fsm` never touches `OCR1x` directly — "open the gate," "close the gate," using the PWM driver underneath. | Sept 14 | Tasneem | x |
| `seg7.c/h` | `SEG_Show(n)` | Decide and document: direct-segment drive vs BCD-to-decoder wiring — shows a number (0–6) on the single-digit display. | Sept 15 |  |  |
| `shiftreg.c/h` | `SR_Write(byte)` | Shifts 8 bits over SPI then pulses `RCLK`; caller is responsible for the FR-16 rate limit — a helper chip (74HC595) that lets you control that digit display using only 3 wires instead of 8. This module knows how to talk to it. | Sept 15 |  |  |
| `lcd_i2c.c/h` | `LCD_Init`, `LCD_SetCursor`, `LCD_Print`, `LCD_UpdateIfChanged(line, text)` | FR-03 requires "no visible flicker; only changed characters rewritten" — needs a shadow buffer of each line's current contents to diff against. Writes text to the LCD screen. | Sept 15 |  |  |
| `buttons.c/h` | `BTN_Debounce()`, polled from the 10 ms task | Keeps the EXTI ISR itself tiny per NFR-09 — cleans up button presses because real buttons "bounce" electrically and can register as multiple presses; this filters that out. | Sept 14 | Tasneem | x |
| `buzzer.c/h` | `BUZ_On()`, `BUZ_Off()`, `BUZ_Beep(times, ms)` | Makes the beep sound for rejected cars or errors. | Sept 14 | Tasneem | x |


## LIB


| Module | Functions | Why | Time | Name | Check |
|---|---|---|---|---|---|
| `ring_buffer.c/h` | `RB_Push`, `RB_Pop`, `RB_IsEmpty/Full` | Shared by UART RX (and TX) — a small storage queue for incoming serial text, so you don't lose characters while your program is busy doing something else. | Sept 14 | Tasneem | x |
| `softrtc.c/h` | `RTC_Tick()`, `RTC_Seconds()`, `RTC_Format(sec, buf)` | Drives ticket timestamps and the `HHH:MM:SS` fields in §18.3 — a simple clock built from the 10 ms heartbeat, counting up seconds since power-on. Used to timestamp tickets. | Sept 15 | souad |  x  |
| `checksum.c/h` | `XOR_Checksum(buf, len)` | Shared by the telemetry frame (§18.1) and `ParkCfg_t` (§10.3) checksum field — a tiny error-checking calculation, used to make sure transmitted data wasn't corrupted. | Sept 15 | Souad |  x  |

## APP : the actual "parking lot" logic

| Module | Functions | Why | Time | Name | Check |
|---|---|---|---|---|---|
| `lane_fsm.c/h` | `LANE_Init`, `LANE_Run`, `LANE_RequestOpen` | One `Lane_t` type, instantiated twice (entry/exit), the state machine described above. One gate = one instance of this. It answers: is a car here, should we let it in/out, is the gate opening/holding/closing, did something get stuck. | Started Sept 14, hardened Sept 15 | Souad |  x |
| `lot_fsm.c/h` | `LOT_Init`, `LOT_Run`, `LOT_GetFree` | Owns the lot-level transitions in §17.1, the "big picture" mode: is the lot operating normally, full, under maintenance, or broken. | Sept 15 |Souad  |   x|
| `ticketing.c/h` | `TKT_Issue`, `TKT_Close`, `TKT_Find` | Fixed `TICKET_MAX` array, no malloc (NFR-16), hands out ticket numbers and remembers which tickets are still "open" — which car hasn't left yet. | Sept 16 |  |  |
| `billing.c/h` | `BIL_Compute(entrySec, exitSec)` | Integer-only; grace period, ceil-to-hour, daily cap — the math: how long was the car parked, how much do they owe. | Sept 16 |  |  |
| `console.c/h` | `CONSOLE_ParseLine(line)` + dispatch table | Table-driven `{name, handler}` mapping to keep §18.2's ~18 commands out of a giant `if/else` chain — reads typed commands like `SET TARIFF 25` and does something with them. | Sept 16 |  |  |
| `telemetry.c/h` | `TELEM_BuildFrame(buf)`, `TELEM_Send()` | Owns FR-15's periodic status frame; uses shared `checksum.c` — periodically prints a status summary automatically, without being asked. | Sept 16 |  |  |
| `config.c/h` | `CFG_LoadDefaults`, `CFG_Validate`, `CFG_MarkDirty`, `CFG_MaybeWrite` | Owns FR-16's rate-limited republish and FR-17's boot validation/fallback — holds all your adjustable settings (price per hour, grace period, etc.) and their default values. | Sept 16 |  |  |
| `scheduler.c/h` | `SCHED_Init`, `SCHED_Tick()`, task table `{period, offset, lastRun, fn}` | Implements the dispatch table implied by §19 and the "scheduler (10 ms)" bar in §9.1 — the "traffic cop" that decides, every 10 ms, which pieces of code get to run. Some things (like checking the gates) run every tick; others (like updating the display) only need to run every 250 ms, since redrawing a screen 100 times a second is wasteful. | Core built Sept 14, entries added Sept 15/16 | Tasneem | x |
| `main.c` | Init sequence, `sei()`, super-loop calling `SCHED_Tick()` | — | — |  |  |

All five trace directly back to a graded FR/NFR or listed hardware component —
none of them add functionality beyond what the spec already requires.
