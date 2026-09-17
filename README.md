# Project 02 — Smart Parking System

> Part of the **Embedded Systems Projects Book** — see the
> [book README](../README.md) for the shared platform baseline, layer rules and
> common rubric. Everything in this file is *in addition to* those rules.

---

## 1. Project Identity

| Field | Value |
|-------|-------|
| **Project code** | `PRJ-02-PARKING` |
| **Name** | Tasneem Hossam Eldin Hassan Salem |
| **Name** | Souad Mostafa Kamel|
| **Name** | Haneen Yasser Saeed |
| **Build window** | Days 11 – 15 (Sept 13 – Sept 17, 2026) |
| **Demo & submission** | Sept 17, 2026 |
| **Dominant skill** | Slot arbitration + timed gate sequencing (two concurrent lane FSMs) |
| **MCU** | ATmega32A @ 8 MHz |
| **Simulator** | SimulIDE 1.x |

---

![alt text](<■ SimulIDE_2.0.0--260501 - New Circuit 9_17_2026 5_40_42 PM.png>)

## 2. Description

### In one sentence

**You are building the controller for a small car park: 6 spaces, one way in,
one way out.**

### What the circuit looks like

```
                 ENTRY LANE                    EXIT LANE
                      |                            |
                 [ barrier ]                  [ barrier ]
                      |                            |
      +---------------+----------------------------+--------+
      |   [1]  [2]  [3]  [4]  [5]  [6]   <- 6 parking spaces |
      +--------------------------------------------------------+
```

| Part | Stands for |
|------|-----------|
| 6 switches | The 6 spaces. Switch on = a car is parked there |
| 2 potentiometers | "A car is waiting at this barrier" |
| 2 servo motors | The two barriers |
| 7-segment digit | How many spaces are free |
| LCD + serial + 74HC595 | Display, tickets, and the free-slot digit |

### What the firmware does

1. Count the free spaces, all the time.
2. A car arrives at the **entry** barrier. If at least one space is free, lift
   the barrier. If the park is full, leave it down and light the `FULL` sign.
3. When the car goes in, print a **ticket** over the serial link: a ticket
   number and the time it entered.
4. A car arrives at the **exit** barrier. Lift it, work out how long that car
   stayed, multiply by the stored tariff, and that is the **fee**.
5. Show free / occupied counts on the LCD and the 7-segment digit.
6. Keep the running totals and the tariff in RAM, tunable over the console.

### The one thing you actually have to get right: two things happening at once

A car can be **leaving while another one is arriving**. Both barriers must be
able to be moving at the same moment.

Here is the trap. The obvious way to hold a gate open for five seconds is:

```c
barrier_open();
_delay_ms(5000);        /* <-- do NOT do this */
barrier_close();
```

That line freezes the **entire program** for five seconds. During those five
seconds the exit lane is dead: it cannot see a car, cannot lift its barrier,
cannot print a ticket. The LCD stops. The serial console stops. Everything
stops.

**The fix:** never wait. Instead, each lane remembers *what step it is on* and
*how long it has been on that step*:

```
  IDLE  ->  CAR_DETECTED  ->  OPENING  ->  OPEN(5 s)  ->  CLOSING  ->  IDLE
```

Every 10 ms, each lane gets a turn: it looks at its own step, decides whether it
is time to move to the next one, and returns immediately. Nothing ever blocks.
With two lanes, both move forward on every single tick — so they genuinely run
at the same time, on one CPU, with no operating system.

You will write this lane machine **once** and use it **twice** — one copy for
entry, one for exit, each with its own variables. Copying and pasting the logic
into two near-identical functions loses marks.

### The rest of it

- The **LCD** shows free and occupied counts; the **7-segment** shows free
  spaces.
- The **serial link** issues tickets and prints fees, and accepts commands to
  change the tariff.
- The **74HC595** drives the free-slot 7-segment digit over SPI.
> **Note on saving.** There is no non-volatile memory in this project — SimulIDE
> has no part that could provide it. Everything below starts from its compiled-in
> default on each power-up, and anything tunable is tuned live over the serial
> console. See the book README, §4.

---

## 3. Objectives

1. Write **one** reusable FSM type and instantiate it for two independent lanes.
2. Generate accurate servo control pulses with Timer1 Fast PWM (ICR1 top).
3. Maintain a bit-mapped occupancy register and derive counts from it with
   bitwise operations only.
4. Implement timestamping and elapsed-time arithmetic from a 1 Hz software RTC.
5. Design a ticket record and keep rolling statistics in a fixed-size table.
6. Drive a multiplexed display (LCD + 7-segment) without flicker from a
   scheduler.
7. Handle sensor faults and passage timeouts without deadlocking a lane.

---

## 4. Learning Outcomes

| ID | Outcome |
|----|---------|
| LO-1 | Configure Timer1 Fast PWM mode 14 (`ICR1` as TOP) for a 20 ms / 1–2 ms servo frame and explain each register bit |
| LO-2 | Explain why two blocking `_delay_ms(5000)` gate holds cannot coexist, and refactor to tick-counted timers |
| LO-3 | Pack six occupancy bits into one `uint8_t` and count set bits without a loop-per-slot |
| LO-4 | Build a 1 Hz time base from the 10 ms tick and use it for dwell-time billing |
| LO-5 | Design a fixed-size ticket table with no dynamic memory and handle table-full gracefully |
| LO-6 | Detect and recover from a stuck lane (vehicle never clears the loop) |
| LO-7 | Multiplex an LCD and a 7-segment display from independent scheduler tasks |

---

## 5. Estimated Duration

| Phase | Hours | Course day |
|-------|:-----:|-----------|
| Requirements analysis & pin freeze | 3 | Day 11 |
| Lane FSM & architecture design | 5 | Day 11 |
| Slot sensors, 7-segment, LCD bring-up | 6 | Day 12 |
| Timer1 servo PWM + lane sequencing | 7 | Day 13 |
| Ticketing, billing, 74HC595, UART | 6 | Day 14 |
| Testing & debugging | 4 | Day 15 |
| Documentation, report, video | 4 | Day 15 + evening |
| **Total** | **35 h** | |

---

## 6. Hardware Components

| # | Component | Qty | SimulIDE part | Purpose |
|---|-----------|:---:|---------------|---------|
| 1 | ATmega32A | 1 | `atmega32` | Controller |
| 2 | Slot sensor (switch / IR) | 6 | `Switch` or `Push` | Slot 1 – 6 occupancy |
| 3 | Potentiometer 10 kΩ | 2 | `Potentiometer` | Entry & exit loop proximity |
| 4 | Potentiometer 10 kΩ | 1 | `Potentiometer` | Ambient light (lot lamps) |
| 5 | Servo motor | 2 | `Servo` | Entry & exit barriers |
| 6 | 7-segment, common cathode | 1 | `7Segment` | Free-slot count |
| 7 | LED (green / red) | 2 | `Led` | `VACANT` / `FULL` sign |
| 8 | LED (white) | 1 | `Led` | Lot lighting |
| 9 | Push button | 2 | `Push` | Exit request, maintenance |
| 10 | Buzzer | 1 | `Buzzer` | Reject / error tone |
| 11 | 16×2 LCD + PCF8574 | 1 | `Lcd` + `I2CToParallel` | Operator display |
| 12 | 74HC595 shift register | 1 | `74HC595` | Free-slot 7-segment digit |
| 13 | Serial terminal | 1 | `SerialPort` | Ticket printer / console |

---

## 7. Pin Map

| Signal | Pin | Port bit | Direction | Notes |
|--------|-----|----------|-----------|-------|
| Entry loop sensor | 40 | `PA0` / ADC0 | Analog in | > 600 = vehicle present |
| Exit loop sensor | 39 | `PA1` / ADC1 | Analog in | > 600 = vehicle present |
| Ambient light | 38 | `PA2` / ADC2 | Analog in | < 300 = switch lot lamps on |
| 7-segment `a`…`d` | 1 – 4 | `PB0`…`PB3` | Out | BCD → decoder, or direct segments |
| 74HC595 `RCLK` | 5 | `PB4` | Out | Rising edge latches the shift register |
| SPI `MOSI` | 6 | `PB5` | Out | |
| SPI `MISO` | 7 | `PB6` | In | |
| SPI `SCK` | 8 | `PB7` | Out | |
| I2C `SCL` | 22 | `PC0` | Out | 4.7 kΩ pull-up |
| I2C `SDA` | 23 | `PC1` | Bidir | 4.7 kΩ pull-up |
| Slot 1 – 6 sensors | 24 – 29 | `PC2`…`PC7` | In, pull-up | Low = occupied |
| USART `RXD` | 14 | `PD0` | In | 9600 8N1 |
| USART `TXD` | 15 | `PD1` | Out | 9600 8N1 |
| Exit request button | 16 | `PD2` / INT0 | In, pull-up | Falling edge |
| Maintenance button | 17 | `PD3` / INT1 | In, pull-up | Falling edge |
| Exit barrier servo | 18 | `PD4` / OC1B | Out | 20 ms PWM |
| Entry barrier servo | 19 | `PD5` / OC1A | Out | 20 ms PWM |
| `FULL` sign LED | 20 | `PD6` | Out | Red |
| Buzzer | 21 | `PD7` / OC2 | Out | Reject tone |

> `PC2` – `PC7` carry the slot sensors, so the **`JTAGEN` fuse must be cleared**
> (or `JTD` set twice in `MCUCSR` within four cycles). Without this, slots 1 – 4
> will read garbage. Document your method.

---

## 8. Peripherals Used

| Peripheral | Configuration | Role |
|------------|---------------|------|
| **GPIO** | `PC2..PC7` in + pull-up; `PB0..PB3`, `PD6`, `PD7` out | Slots, display, signs |
| **ADC** | Single conversion, prescaler 64, AVCC ref | 3 analog channels |
| **Timer0** | CTC, prescaler 1024, `OCR0 = 77`, `OCIE0` | 10 ms system tick |
| **Timer1** | Fast PWM mode 14, prescaler 8, `ICR1 = 19999` | Two servo channels, 20 ms frame, 1 µs resolution |
| **Timer2** | Fast PWM (bonus) | Buzzer tone |
| **INT0 / INT1** | Falling edge | Exit request, maintenance |
| **USART** | 9600 8N1, RX interrupt | Ticket output + console |
| **SPI** | Master, Mode 0, f/16 | 74HC595 shift register |
| **I2C (TWI)** | Master, 100 kHz | PCF8574 → LCD |

### Servo timing derivation (put this in your report)

```
F_CPU = 8 MHz, prescaler 8  →  timer tick = 1 µs
ICR1  = 19999               →  period = 20 000 µs = 20 ms  ✓
OCR1x = 1000                →  1.0 ms pulse  →   0°  (barrier DOWN / closed)
OCR1x = 2000                →  2.0 ms pulse  →  90°  (barrier UP / open)
```

---

## 9. Software Architecture

### 9.1 Layer view

```
┌───────────────────────────────────────────────────────────────────┐
│ APP                                                               │
│  ┌───────────┐ ┌───────────┐ ┌──────────┐ ┌──────────┐ ┌───────┐  │
│  │ lot_fsm   │ │ lane_fsm  │ │ ticketing│ │ billing  │ │console│  │
│  │ (1 inst)  │ │ (2 inst)  │ │          │ │          │ │       │  │
│  └─────┬─────┘ └─────┬─────┘ └────┬─────┘ └────┬─────┘ └───┬───┘  │
│        └─────────────┴──── scheduler (10 ms) ──┴───────────┘      │
├───────────────────────────────────────────────────────────────────┤
│ HAL                                                               │
│  slots.c  barrier.c  seg7.c  lcd_i2c.c  shiftreg.c  buttons.c   │
├───────────────────────────────────────────────────────────────────┤
│ MCAL                                                              │
│  dio.c  adc.c  timer.c  pwm.c  exti.c  usart.c  spi.c  i2c.c      │
├───────────────────────────────────────────────────────────────────┤
│ LIB    STD_TYPES.h  BIT_MATH.h  ring_buffer.c  softrtc.c          │
└───────────────────────────────────────────────────────────────────┘
```

### 9.2 The reusable lane state machine

This is the centrepiece of the design. **One** type, **two** instances:

```c
typedef struct {
    LaneState_t state;       /* current state                        */
    uint16_t    timerTicks;  /* generic countdown, 10 ms units       */
    uint8_t     loopActive;  /* debounced proximity input            */
    uint8_t     servoCh;     /* PWM_CH_ENTRY or PWM_CH_EXIT          */
    uint8_t     isEntry;     /* 1 = entry lane, 0 = exit lane        */
    uint16_t    passCount;   /* vehicles handled since boot          */
    uint8_t     faultFlag;   /* passage timeout latched              */
} Lane_t;

Lane_t g_entryLane, g_exitLane;

void LANE_Init(Lane_t *ln, uint8_t servoCh, uint8_t isEntry);
void LANE_Run (Lane_t *ln);      /* called every 10 ms, per instance */
```

`LANE_Run` contains no delays and no global state — everything it needs is in
its own `Lane_t`. **Copy-pasting the lane logic into two separate functions
loses the Architecture marks.**

### 9.3 Module responsibilities

| Module | Owns | Public API (suggested) |
|--------|------|------------------------|
| `lot_fsm` | Lot-level mode, free-count, FULL logic | `LOT_Init`, `LOT_Run`, `LOT_GetFree` |
| `lane_fsm` | The reusable lane FSM | `LANE_Init`, `LANE_Run`, `LANE_RequestOpen` |
| `ticketing` | Fixed ticket table, ID numbering | `TKT_Issue`, `TKT_Close`, `TKT_Find` |
| `billing` | Tariff arithmetic | `BIL_Compute(entrySec, exitSec)` |
| `slots` | Debounced occupancy bitmap | `SLOT_Poll`, `SLOT_GetMap`, `SLOT_CountFree` |
| `barrier` | Servo angle abstraction | `BAR_Open`, `BAR_Close`, `BAR_IsMoving` |
| `seg7` | Free-count digit | `SEG_Show(n)` |
| `softrtc` | 1 Hz counter from the tick | `RTC_Seconds`, `RTC_Format` |

### 9.4 Concurrency contract

- Both lanes are dispatched from the **same** 10 ms task, one after the other.
- `LANE_Run` never spins; every wait is `if (--ln->timerTicks == 0)`.
- Servo pulse generation is pure hardware (Timer1) — the CPU only writes `OCR1A`
  / `OCR1B` once per transition.
- The occupancy bitmap is written by `SLOT_Poll` only; every other module reads
  a snapshot taken at the top of the tick.

---

## 10. Data Dictionary (required data)

### 10.1 Runtime lot data — `DD-01 LotData_t`

```c
#define SLOT_COUNT   6u
#define TICKET_MAX   6u          /* one open ticket per slot            */

typedef struct {
    uint8_t  slotMap;            /* bit n = 1 → slot n occupied         */
    uint8_t  freeCount;          /* 0..6, derived from slotMap          */
    uint8_t  occupiedCount;      /* SLOT_COUNT - freeCount              */
    uint16_t entryLoopRaw;       /* ADC0                                */
    uint16_t exitLoopRaw;        /* ADC1                                */
    uint16_t lightRaw;           /* ADC2                                */
    uint8_t  lampsOn : 1;
    uint8_t  fullSign: 1;
    uint8_t  reserved: 6;
    uint8_t  mode;               /* LotState_t                          */
    uint32_t upTimeSec;          /* software RTC, seconds since boot    */
} LotData_t;
```

### 10.2 Ticket record — `DD-02 Ticket_t`

```c
typedef struct {
    uint16_t id;                 /* 1..9999, wraps to 1                 */
    uint32_t entrySec;           /* RTC seconds at issue                */
    uint8_t  slotHint;           /* slot suggested at entry, 0 = none   */
    uint8_t  active;             /* 1 = open, 0 = free row              */
} Ticket_t;

Ticket_t g_tickets[TICKET_MAX];  /* static, no malloc                   */
```

### 10.3 Running statistics — `DD-03 ParkCfg_t`

```c
#define PRK_MAGIC   0x5041u      /* 'P','A'                             */
#define PRK_VERSION 0x01u

typedef struct {
    uint16_t magic;
    uint8_t  version;
    uint8_t  tariffPerHour;      /* currency units/hour  (default 10)   */
    uint8_t  freeMinutes;        /* grace period          (default 15)  */
    uint8_t  gateHoldSec;        /* barrier open hold     (default 5)   */
    uint8_t  passTimeoutSec;     /* stuck-lane timeout    (default 20)  */
    uint8_t  lightThresh;        /* lamp on below this %  (default 30)  */
    uint16_t nextTicketId;       /* wraps 1..9999, resets at power-on   */
    uint16_t totalEntries;
    uint16_t totalExits;
    uint16_t totalRevenue;
    uint8_t  peakOccupancy;
    uint8_t  checksum;
} ParkCfg_t;                     /* 18 bytes                            */
```

### 10.4 Enumerations — `DD-04`

```c
typedef enum { LOT_INIT = 0, LOT_OPERATIONAL, LOT_FULL,
               LOT_MAINTENANCE, LOT_FAULT }                LotState_t;

typedef enum { LN_IDLE = 0, LN_VEHICLE_WAIT, LN_AUTHORISING,
               LN_GATE_OPENING, LN_GATE_OPEN, LN_VEHICLE_PASSING,
               LN_GATE_CLOSING, LN_REJECTED, LN_TIMEOUT }  LaneState_t;
```

### 10.5 Derived constants — `DD-05`

| Constant | Value | Meaning |
|----------|-------|---------|
| `LOOP_PRESENT_RAW` | 600 | ADC code above which a vehicle is detected |
| `LOOP_CLEAR_RAW` | 400 | ADC code below which the loop is clear (hysteresis) |
| `SERVO_CLOSED_US` | 1000 | `OCR1x` for barrier down |
| `SERVO_OPEN_US` | 2000 | `OCR1x` for barrier up |
| `GATE_TRAVEL_TICKS` | 100 | 1 s servo travel allowance |
| `GATE_HOLD_TICKS` | 500 | 5 s open hold (from `gateHoldSec`) |
| `PASS_TIMEOUT_TICKS` | 2000 | 20 s stuck-lane limit |
| `REJECT_TICKS` | 200 | 2 s reject display + buzzer |
| `SLOT_DEBOUNCE_TICKS` | 5 | 50 ms slot sensor debounce |

### 10.6 Slot bitmap helpers

```c
/* free count without a per-slot loop — required by FR-02 */
static uint8_t popcount6(uint8_t m)
{
    m = (uint8_t)(m - ((m >> 1) & 0x55u));
    m = (uint8_t)((m & 0x33u) + ((m >> 2) & 0x33u));
    return (uint8_t)((m + (m >> 4)) & 0x0Fu);
}
#define SLOT_FREE(map)  (uint8_t)(SLOT_COUNT - popcount6((map) & 0x3Fu))
```

---

## 11. System Specifications

### 11.1 Lot capacity

| Parameter | Value |
|-----------|-------|
| Total slots | 6 |
| Slot numbering | 1 – 6 (bit 0 – bit 5 of `slotMap`) |
| Sensor polarity | Pull-up input; **low = occupied** |
| Slot debounce | 50 ms |
| Concurrent open tickets | 6 |

### 11.2 Occupancy states

| Free slots | Sign | Entry barrier |
|:----------:|------|---------------|
| 6 – 1 | `VACANT` (green) | May open |
| 0 | `FULL` (red) | Refuses to open |

### 11.3 Lane timing

| Phase | Duration | Source |
|-------|----------|--------|
| Vehicle detect debounce | 200 ms | Fixed |
| Authorisation decision | ≤ 100 ms | Computed |
| Gate travel (open or close) | 1 s | `GATE_TRAVEL_TICKS` |
| Gate hold open | 5 s (configurable 2 – 15 s) | `gateHoldSec` |
| Passage timeout | 20 s (configurable 10 – 60 s) | `passTimeoutSec` |
| Reject display | 2 s | `REJECT_TICKS` |

### 11.4 Tariff rules

| Rule | Value |
|------|-------|
| Grace period | First 15 min free |
| Rate | 10 units per started hour after the grace period |
| Rounding | Any part of an hour counts as a full hour |
| Maximum daily charge | 120 units (cap) |

Worked example: entry `00:10:00`, exit `01:50:00` → dwell 100 min → 100 − 15 =
85 min chargeable → `ceil(85/60)` = 2 hours → **20 units**.

---

## 12. Inputs & Outputs

### 12.1 Inputs

| ID | Name | Channel | Type | Sample rate |
|----|------|---------|------|-------------|
| IN-1 | Entry loop proximity | ADC0 | Analog 0 – 1023 | 20 Hz |
| IN-2 | Exit loop proximity | ADC1 | Analog 0 – 1023 | 20 Hz |
| IN-3 | Ambient light | ADC2 | Analog 0 – 1023 | 1 Hz |
| IN-4 | Slot 1 – 6 sensors | `PC2`…`PC7` | Digital, active low | 20 Hz |
| IN-5 | Exit request | `PD2`/INT0 | Digital, edge | Interrupt |
| IN-6 | Maintenance | `PD3`/INT1 | Digital, edge | Interrupt |
| IN-7 | Console commands | USART RX | ASCII line | Interrupt |

### 12.2 Outputs

| ID | Name | Pin | Type | Meaning |
|----|------|-----|------|---------|
| OUT-1 | Entry barrier | `PD5`/OC1A | PWM | 1 ms closed, 2 ms open |
| OUT-2 | Exit barrier | `PD4`/OC1B | PWM | 1 ms closed, 2 ms open |
| OUT-3 | 7-segment digit | `PB0`…`PB3` | Digital | Free-slot count 0 – 6 |
| OUT-4 | `FULL` sign | `PD6` | Digital | On when free = 0 |
| OUT-5 | Lot lamps | `PB0` (shared, or spare) | Digital | Ambient-light driven |
| OUT-6 | Buzzer | `PD7` | Digital / PWM | Reject / fault tone |
| OUT-7 | LCD | I2C | 16×2 text | Counts and lane status |
| OUT-8 | Tickets & telemetry | USART TX | ASCII | Ticket print + 5 s frame |

---

## 13. Functional Requirements

### FR-01 — Slot occupancy scanning

The system **shall** scan all six slot sensors every **50 ms** and maintain
`slotMap` as a bitmap where bit *n* set means slot *n+1* is occupied.

**Acceptance criteria**
- Each slot input is debounced for 50 ms; a bounce shorter than that produces no
  change.
- All six pins are read in a **single** `PINC` read, then masked — six separate
  reads lose the mark.
- The bitmap is displayed in the `STATUS` response as two hex digits.

### FR-02 — Free-slot calculation

The system **shall** derive `freeCount` from `slotMap` on every scan, without a
per-slot `if` chain.

**Acceptance criteria**
- Uses a bit-counting expression (see §10.6) or an equivalent table lookup.
- `freeCount + occupiedCount == 6` at all times.
- Updates within 50 ms of any sensor change.

### FR-03 — Free-slot display

The 7-segment display **shall** show `freeCount` (0 – 6) and the LCD **shall**
show both counts, refreshed every **250 ms**.

**Acceptance criteria**
- LCD line 1: `FREE:3  OCC:3`
- LCD line 2: shows the active lane phase, e.g. `IN:OPEN  OUT:IDLE`
- No visible flicker; only changed characters rewritten.

### FR-04 — `FULL` indication

When `freeCount == 0` the system **shall** light the `FULL` sign and extinguish
the `VACANT` sign within **100 ms**.

**Acceptance criteria**
- The lot FSM enters `LOT_FULL`.
- The transition is logged as `!EVT,LOT,FULL` / `!EVT,LOT,VACANT`.

### FR-05 — Entry vehicle detection

The entry lane **shall** detect a vehicle when ADC0 > 600 for **200 ms**
continuously, and consider the loop clear when ADC0 < 400 for 200 ms.

**Acceptance criteria**
- The 200-point hysteresis band prevents oscillation at the threshold.
- Detection latency ≤ 250 ms.
- A vehicle detected while the lane is not `LN_IDLE` is ignored, not queued.

### FR-06 — Entry authorisation

On entry detection the system **shall** authorise the vehicle **only if**
`freeCount > 0` **and** an open-ticket row is available.

**Acceptance criteria**
- Authorised → issue ticket (FR-07), then open the barrier (FR-08).
- Refused → `LN_REJECTED` for 2 s: buzzer 2 s, LCD `LOT FULL — NO ENTRY`,
  barrier stays closed, `!EVT,ENTRY,REJECT` sent.
- The decision completes within 100 ms of detection.

### FR-07 — Ticket issue

On authorisation the system **shall** claim a free slot in the fixed ticket table and fill it with the next sequential
ID and the current RTC time, and transmit it over UART.

**Acceptance criteria**
- `nextTicketId` increments 1 → 9999 → 1, so IDs do not repeat inside one
  session. They restart at 1 after a power cycle — say so in your report, and
  note that a real car park needs storage to avoid it.
- The ticket row is marked `active = 1`; `TICKET_MAX` open tickets → refuse.
- Printed frame per §18.3.

### FR-08 — Entry barrier sequence

The entry barrier **shall** follow: `OPENING (1 s) → OPEN (hold 5 s or until the
loop clears) → CLOSING (1 s) → IDLE`.

**Acceptance criteria**
- The barrier begins closing as soon as the loop clears, even before the 5 s hold
  expires.
- The barrier **shall not** close while the loop still reports a vehicle.
- Servo angles come from `OCR1A` only; no bit-banged pulses.
- No `_delay_ms` is used in any phase — TC-25 will look for it.

### FR-09 — Exit request and barrier sequence

Pressing the exit button, or detecting a vehicle on the exit loop, **shall** run
the same lane sequence on the exit barrier.

**Acceptance criteria**
- The exit lane runs concurrently with the entry lane: with both loops active,
  both barriers open and close on their own timers.
- Exiting is never refused (a car inside must always be able to leave), even in
  `LOT_FULL`.

### FR-10 — Fee calculation

On exit the system **shall** close the oldest open ticket, compute the fee per
§11.4, and report it.

**Acceptance criteria**
- Grace period, hourly rounding-up and the daily cap are all applied.
- Integer arithmetic only.
- `totalRevenue` accumulates and saturates at 65 535.
- Result printed per §18.3; LCD shows `FEE: 20  ID:0042` for 3 s.

### FR-11 — Passage timeout / stuck lane

If a lane stays in `LN_GATE_OPEN` or `LN_VEHICLE_PASSING` for more than
`passTimeoutSec` (default 20 s), the system **shall** enter `LN_TIMEOUT`.

**Acceptance criteria**
- Barrier is forced closed; buzzer sounds 3 short beeps.
- `!EVT,LANE,TIMEOUT,IN` (or `OUT`) is sent.
- The lane returns to `LN_IDLE` automatically once the loop reads clear.
- The **other** lane keeps operating normally throughout — this is the key test
  of true concurrency.

### FR-12 — Lot lighting

The system **shall** switch the lot lamps on when the ambient light reading falls
below `lightThresh` % and off when it rises 10 % above it.

**Acceptance criteria**
- 10 % hysteresis band; no chatter at the threshold.
- Sampled at 1 Hz — faster is wasted CPU.

### FR-13 — Maintenance mode

Pressing the maintenance button **shall** toggle `LOT_MAINTENANCE`.

**Acceptance criteria**
- Both barriers are driven **open** and held open.
- LCD shows `MAINTENANCE MODE`; ticketing and billing are suspended.
- Slot scanning and telemetry continue.
- Leaving maintenance closes both barriers and resumes normal operation.

### FR-14 — Occupancy vs. ticket consistency check

Every 5 s the system **shall** compare the number of open tickets with
`occupiedCount`.

**Acceptance criteria**
- A mismatch lasting more than 30 s raises `!EVT,LOT,MISMATCH,<tickets>,<occ>`
  and shows `CHECK LOT` on the LCD.
- The mismatch is a warning, not a fault — the lot keeps operating.

### FR-15 — Telemetry

Every **5 s** the system **shall** transmit the status frame of §18.1.

**Acceptance criteria**
- Within ±100 ms of the boundary; non-blocking transmission.
- Checksum valid on every frame.

### FR-16 — Running statistics

The system **shall** re-validate `ParkCfg_t` and republish it to the display whenever
`totalEntries`, `totalExits` or `nextTicketId` changes, rate-limited to **one
write per 10 s**.

**Acceptance criteria**
- Refresh sequence: eight bits over SPI, then a single `RCLK` rising edge.
- Rate limiting is mandatory — an unthrottled refresh per car wastes bus time
  endurance and is a design defect, not a style issue.
- `COUNTS?` reports `nextTicketId` and the totals on demand, and they track
  stopped.

### FR-17 — Boot restore and validation

At startup the system **shall** load `ParkCfg_t`, validating magic, version and
checksum, and fall back to defaults on any failure.

**Acceptance criteria**
- `!EVT,CFG,DEFAULT` on fallback; defaults are written back immediately.
- Boot to first LCD frame ≤ 500 ms.
- Open tickets are **not** restored — after a reboot the lot rebuilds its ticket
  table from `slotMap` with unknown entry times, and charges those vehicles the
  minimum fee. Document this decision.

### FR-18 — Console command set

The system **shall** implement the commands of §18.2, with the same robustness
rules as the book standard (case-insensitive, ≤ 24 chars, one response line,
`ERR …` vocabulary).

---

## 14. Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| **NFR-01** | Compiles with `avr-gcc -std=c99 -Wall -Wextra -Os`, zero warnings. |
| **NFR-02** | No blocking delay > 10 ms in the super-loop; `_delay_ms` only in `*_Init()`. |
| **NFR-03** | Both lanes must be able to be in a non-idle state simultaneously. Any design that serialises them fails. |
| **NFR-04** | The lane FSM is written **once** and instantiated twice — no duplicated logic. |
| **NFR-05** | Servo pulses are generated by Timer1 hardware; software pulse timing is not accepted. |
| **NFR-06** | No floating-point arithmetic; fee maths is integer-only. |
| **NFR-07** | No magic numbers: all thresholds, timings and pins live in `config.h`. |
| **NFR-08** | Layer rule: hardware registers touched only in `MCAL/*.c`. |
| **NFR-09** | ISRs ≤ 10 lines, no bus transactions inside. |
| **NFR-10** | The ticket table is a fixed array of `TICKET_MAX` entries, reserved at compile time. A full table is handled by refusing entry, never by growing the table. |
| **NFR-11** | Scheduler tick jitter ≤ ±1 ms; CPU load ≤ 60 %. |
| **NFR-12** | `.data + .bss` ≤ 1 KB (`avr-size -C --mcu=atmega32`). |
| **NFR-14** | UART RX ring buffer ≥ 32 bytes, interrupt driven, no byte loss at 9600 bps. |
| **NFR-15** | A stuck sensor never deadlocks the system — every wait state has a timeout. |
| **NFR-16** | **No dynamic memory.** `malloc`, `calloc`, `realloc`, `free`, `alloca` and variable-length arrays are banned. Every buffer, table, queue and log is a fixed-size array whose length is a `#define` in `config.h`. Prove it: `avr-nm main.elf \| grep -i malloc` must print nothing. |
| **NFR-17** | **No recursion.** No function may call itself, directly or through any chain of calls — the call graph must be acyclic. Every search, scan, parse and traversal is written as a loop. State your worst-case stack depth in the report. |

---

## 15. Operating Modes

| Mode | Entered by | Entry barrier | Exit barrier | Ticketing |
|------|-----------|---------------|--------------|-----------|
| `LOT_INIT` | Power-on | Closed | Closed | Off |
| `LOT_OPERATIONAL` | Init complete | On demand | On demand | Active |
| `LOT_FULL` | `freeCount == 0` | Refuses | On demand | Exit only |
| `LOT_MAINTENANCE` | Maintenance button / `MAINT ON` | Held open | Held open | Suspended |
| `LOT_FAULT` | Servo or sensor failure | Held open (fail-safe) | Held open | Suspended |

> **Fail-safe rationale:** on a fault the barriers *open*. A barrier stuck down
> traps vehicles; a barrier stuck up loses revenue. Safety beats revenue —
> state this in your report.

---

## 16. System Flow

```
        ┌──────────────┐
        │  Power ON    │
        └──────┬───────┘
               ▼
   ┌───────────────────────────────┐
   │ MCAL init: DIO, ADC, T0, T1,  │
   │ EXTI, USART, SPI, I2C         │
   │ Barriers driven CLOSED        │
   └──────┬────────────────────────┘
          ▼
   ┌───────────────────────────────┐    invalid   ┌────────────────┐
   │ Load ParkCfg_t, verify CRC    ├─────────────▶│ Load defaults, │
   └──────┬────────────────────────┘              │ log it         │
          │ valid                                 └───────┬────────┘
          ▼◀──────────────────────────────────────────────┘
   ┌───────────────────────────────┐
   │ Scan slots, rebuild counts    │
   │ LCD splash, sei()             │
   └──────┬────────────────────────┘
          ▼
╔═══════════════════════════════════════════════════════════╗
║              SUPER-LOOP (dispatch on 10 ms tick)          ║
║                                                           ║
║   10 ms  → LANE_Run(&entry);  LANE_Run(&exit);            ║
║   10 ms  → buttons, lot FSM                               ║
║   50 ms  → slot scan + free count                         ║
║   50 ms  → ADC loop sensors                               ║
║  250 ms  → LCD + 7-segment repaint                        ║
║    1 s   → RTC tick, lot lighting, consistency check      ║
║    5 s   → telemetry frame                                ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 17. State Machine

### 17.1 Lot-level FSM

```
      ┌────────────┐  init done   ┌───────────────────┐
      │  LOT_INIT  ├─────────────▶│  LOT_OPERATIONAL  │
      └────────────┘              └────┬──────────┬───┘
                                       │          │
                       free == 0       │          │  MAINT button
                                       ▼          ▼
                              ┌────────────┐  ┌──────────────────┐
                              │  LOT_FULL  │  │ LOT_MAINTENANCE  │
                              └─────┬──────┘  └────────┬─────────┘
                       free > 0     │                  │ MAINT button
                                    └──────┬───────────┘
                                           ▼
                                   LOT_OPERATIONAL
                                           │
                     servo/sensor failure  ▼
                                    ┌─────────────┐
                                    │  LOT_FAULT  │  (barriers open)
                                    └─────────────┘
```

### 17.2 Lane FSM (one instance per lane)

```
                    ┌────────────┐
        ┌──────────▶│  LN_IDLE   │◀────────────┐
        │           └─────┬──────┘             │
        │      loop active│ 200 ms             │ loop clear
        │                 ▼                    │
        │        ┌─────────────────┐           │
        │        │ LN_VEHICLE_WAIT │           │
        │        └────────┬────────┘           │
        │                 ▼                    │
        │        ┌─────────────────┐           │
        │        │ LN_AUTHORISING  │           │
        │        └───┬─────────┬───┘           │
        │   refused  │         │ granted       │
        │            ▼         ▼               │
        │    ┌────────────┐  ┌──────────────┐  │
        └────┤LN_REJECTED │  │LN_GATE_OPENING│ │
       2 s   └────────────┘  └───────┬───────┘ │
                                     │ 1 s     │
                                     ▼         │
                             ┌───────────────┐ │
                             │ LN_GATE_OPEN  │ │
                             └───────┬───────┘ │
                       loop active   │ hold 5 s│
                                     ▼         │
                          ┌─────────────────────┐
                          │ LN_VEHICLE_PASSING  │
                          └──────┬──────────┬───┘
                    loop clear   │          │ 20 s timeout
                                 ▼          ▼
                     ┌────────────────┐  ┌────────────┐
                     │ LN_GATE_CLOSING│  │ LN_TIMEOUT │
                     └────────┬───────┘  └──────┬─────┘
                          1 s │                 │ loop clear
                              └────────┬────────┘
                                       ▼
                                   LN_IDLE
```

### 17.3 Lane transition table

| # | From | Event / guard | To | Actions |
|---|------|---------------|----|---------|
| L1 | `LN_IDLE` | Loop raw > 600 for 200 ms | `LN_VEHICLE_WAIT` | Start 200 ms confirm timer |
| L2 | `LN_VEHICLE_WAIT` | Confirm expired | `LN_AUTHORISING` | — |
| L3 | `LN_AUTHORISING` | Entry ∧ (`free == 0` ∨ ticket table full) | `LN_REJECTED` | Buzzer, LCD message, `!EVT,ENTRY,REJECT` |
| L4 | `LN_AUTHORISING` | Entry ∧ slot available | `LN_GATE_OPENING` | Issue ticket, print, `OCR1A = 2000` |
| L5 | `LN_AUTHORISING` | Exit lane (always granted) | `LN_GATE_OPENING` | Close ticket, compute fee, print, `OCR1B = 2000` |
| L6 | `LN_REJECTED` | 2 s elapsed | `LN_IDLE` | Silence buzzer |
| L7 | `LN_GATE_OPENING` | 1 s travel elapsed | `LN_GATE_OPEN` | Start hold timer |
| L8 | `LN_GATE_OPEN` | Loop active | `LN_VEHICLE_PASSING` | Start timeout timer |
| L9 | `LN_GATE_OPEN` | Hold expired ∧ loop clear | `LN_GATE_CLOSING` | `OCR1x = 1000` |
| L10 | `LN_VEHICLE_PASSING` | Loop clear | `LN_GATE_CLOSING` | Increment `passCount`, update stats |
| L11 | `LN_VEHICLE_PASSING` | Timeout expired | `LN_TIMEOUT` | Force close, 3 beeps, log |
| L12 | `LN_GATE_CLOSING` | 1 s travel elapsed | `LN_IDLE` | — |
| L13 | `LN_TIMEOUT` | Loop clear | `LN_IDLE` | Clear fault flag |
| L14 | any | `LOT_MAINTENANCE` entered | `LN_IDLE` | Force barrier open, suspend lane |

---

## 18. UART Protocol

**Link:** 9600 8N1. Device sends `\r\n`; accepts `\r`, `\n`, `\r\n`.

### 18.1 Telemetry frame (every 5 s)

```
$PK,F=3,O=3,MAP=2A,IN=IDLE,OUT=OPEN,T=42,X=39,REV=380,MODE=OPER,UP=3600*5E
```

| Field | Meaning |
|-------|---------|
| `F` / `O` | Free / occupied slot count |
| `MAP` | `slotMap` as 2 hex digits |
| `IN` / `OUT` | Entry / exit lane state name |
| `T` / `X` | Total entries / total exits |
| `REV` | Cumulative revenue |
| `MODE` | `OPER` \| `FULL` \| `MAINT` \| `FAULT` |
| `UP` | Uptime seconds |
| `*5E` | XOR checksum between `$` and `*` |

### 18.2 Command set

| Command | Response | Effect |
|---------|----------|--------|
| `STATUS` | telemetry frame | Immediate report |
| `SLOTS?` | `SLOTS=101010` | Bitmap, slot 1 leftmost |
| `FREE?` | `FREE=3` | |
| `TICKETS?` | one line per open ticket | `TKT,id,entrySec,slotHint` |
| `STATS?` | `STATS=42,39,380,5` | entries, exits, revenue, peak |
| `SET TARIFF <n>` | `OK` / `ERR RANGE` | 1 – 100 units/hour |
| `SET GRACE <n>` | `OK` / `ERR RANGE` | 0 – 60 minutes |
| `SET HOLD <n>` | `OK` / `ERR RANGE` | 2 – 15 s barrier hold |
| `SET TIMEOUT <n>` | `OK` / `ERR RANGE` | 10 – 60 s passage timeout |
| `SET LIGHT <n>` | `OK` / `ERR RANGE` | 0 – 100 % lamp threshold |
| `OPEN IN` / `OPEN OUT` | `OK` / `ERR MODE` | Manual barrier open (maintenance only) |
| `CLOSE IN` / `CLOSE OUT` | `OK` / `ERR MODE` | |
| `MAINT ON` / `MAINT OFF` | `OK` | Enter / leave maintenance |
| `CLRSTATS` | `OK` | Zero totals and revenue (not `nextTicketId`) |
| `HELP` | command list | |

### 18.3 Ticket & receipt frames

Issued at entry:
```
=== PARKING TICKET ===
ID    : 0042
TIME  : 000:12:35
SLOT  : suggest 4
FREE  : 2
======================
```

Printed at exit:
```
===== RECEIPT =====
ID    : 0042
IN    : 000:12:35
OUT   : 001:52:10
DWELL : 99 min
GRACE : 15 min
HOURS : 2
FEE   : 20
===================
```

### 18.4 Asynchronous events

```
!EVT,BOOT
!EVT,ENTRY,GRANT,0042
!EVT,ENTRY,REJECT
!EVT,EXIT,FEE,0042,20
!EVT,LOT,FULL
!EVT,LOT,VACANT
!EVT,LANE,TIMEOUT,IN
!EVT,LOT,MISMATCH,4,3
!EVT,MAINT,ON
!EVT,SAVE,OK
```

---

## 19. Task Scheduling

| ID | Task | Period | Offset | Budget | Work |
|----|------|:------:|:------:|:------:|------|
| T-1 | `Task_Lanes` | 10 ms | 0 | 300 µs | `LANE_Run` ×2 |
| T-2 | `Task_Buttons` | 10 ms | 0 | 100 µs | Debounce, edges |
| T-3 | `Task_LotFSM` | 10 ms | 1 | 150 µs | Lot-level `switch` |
| T-4 | `Task_Slots` | 50 ms | 2 | 200 µs | `PINC` read, debounce, popcount |
| T-5 | `Task_Loops` | 50 ms | 3 | 400 µs | ADC0/ADC1 + hysteresis |
| T-6 | `Task_Display` | 250 ms | 5 | 4 ms | LCD + 7-segment |
| T-7 | `Task_1Hz` | 1 s | 7 | 500 µs | RTC, lighting, consistency check |
| T-8 | `Task_Report` | 5 s | 11 | 2 ms | Telemetry frame |
| T-9 | `Task_Console` | 20 ms | 4 | 500 µs | Parse one line |

Show the worst-case tick sum in your report; it must be under 10 ms.

---

## 20. Testing Requirements

| ID | Test | Method | Pass criterion |
|----|------|--------|----------------|
| TC-01 | Cold boot | Power on | Defaults loaded, `!EVT,CFG,DEFAULT` |
| TC-02 | Live tariff change | `SET TARIFF 25`, then exit a car | Fee computed at the new tariff |
| TC-03 | Corrupted config | Flip a byte | Defaults, no crash |
| TC-04 | Ticket ID sequence | Issue 3 tickets | IDs 1, 2, 3 with no repeat or gap |
| TC-05 | Slot bitmap | Occupy slots 1, 3, 5 | `MAP=15`, `FREE=3` |
| TC-06 | Slot debounce | Chatter one sensor 20 ms | No count change |
| TC-07 | Single `PINC` read | Code inspection | One read, then masks |
| TC-08 | Free count | Occupy all 6 | `FREE=0`, `FULL` sign lit ≤ 100 ms |
| TC-09 | Vacant restore | Free one slot | Sign flips within 100 ms |
| TC-10 | Entry detect | Ramp ADC0 past 600 | `LN_VEHICLE_WAIT` within 250 ms |
| TC-11 | Entry hysteresis | Hold ADC0 at 500 | No state change for 30 s |
| TC-12 | Entry granted | Free slots, trigger loop | Ticket printed, barrier opens |
| TC-13 | Entry refused | Fill lot, trigger loop | `LN_REJECTED`, buzzer 2 s, barrier stays down |
| TC-14 | Servo pulse width | Scope `PD5` | 1.00 ms closed, 2.00 ms open, 20 ms frame |
| TC-15 | Gate travel timing | Time `OPENING` phase | 1 s ±50 ms |
| TC-16 | Early close | Clear loop after 2 s | Barrier closes immediately, not at 5 s |
| TC-17 | Close blocked | Hold loop active | Barrier stays open past the hold |
| TC-18 | Passage timeout | Hold loop active 25 s | `LN_TIMEOUT`, forced close, 3 beeps |
| TC-19 | **Concurrency** | Trigger both loops together | Both lanes advance independently; neither stalls |
| TC-20 | Concurrency under timeout | Stick the entry loop, run an exit cycle | Exit completes normally |
| TC-21 | Exit always allowed | Fill lot, request exit | Exit barrier opens |
| TC-22 | Fee — inside grace | Exit after 10 min | Fee 0 |
| TC-23 | Fee — 1 hour | Exit after 70 min | Fee 10 (55 min chargeable → 1 h) |
| TC-24 | Fee — rounding | Exit after 100 min | Fee 20 |
| TC-25 | Fee — daily cap | Exit after 20 h | Fee 120 |
| TC-26 | No blocking delay | `grep -R "_delay_ms" APP HAL` | Only in `*_Init()` |
| TC-27 | Single lane FSM | Code inspection | One `LANE_Run`, two instances |
| TC-28 | Ticket table full | Issue 6 tickets, try a 7th | Refused with `!EVT,ENTRY,REJECT` |
| TC-29 | Lot lighting | Drop ADC2 below threshold | Lamps on; hysteresis holds at threshold |
| TC-30 | Maintenance mode | Press maintenance | Both barriers open and held, ticketing off |
| TC-31 | Maintenance exit | Press again | Barriers close, normal operation |
| TC-32 | Consistency warning | Force map/ticket mismatch 35 s | `!EVT,LOT,MISMATCH` + LCD warning |
| TC-33 | Telemetry cadence | Capture 60 s | 12 frames ±1, all checksums valid |
| TC-34 | Console bad input | `FOO`, 40-char line, `SET TARIFF 999` | `ERR CMD`, `ERR LONG`, `ERR RANGE` |
| TC-35 | Manual open guard | `OPEN IN` outside maintenance | `ERR MODE` |
| TC-36 | Display flicker | Watch 60 s | No visible redraw |
| TC-37 | Tick jitter | Scope tick pin | 10 ms ±1 ms |
| TC-38 | CPU load | Busy-pin duty | ≤ 60 % |
| TC-39 | RAM budget | `avr-size -C` | `.data + .bss` ≤ 1024 B |
| TC-40 | Soak | 10 min of random entries/exits | No hang, counts stay consistent |
| TC-41 | **No heap linked** | `avr-nm main.elf \| grep -i malloc` | Prints nothing |
| TC-42 | **No recursion** | Inspect the call graph; state the deepest chain | Acyclic, depth stated in the report |

---

## 21. Bonus Features

Maximum **+20**; final score capped at 100.

| # | Feature | Marks | Requirement |
|---|---------|:-----:|-------------|
| B1 | Slot-guidance display | +10 | LCD names the nearest free slot at entry; the ticket carries it |
| B2 | Event log | +10 | 32-entry ring in RAM, dumped by `LOG?` over UART |
| B3 | Reserved / VIP slot | +5 | Slot 6 reserved; entry granted only against a PIN typed on the console |
| B4 | Two-digit 7-segment | +10 | Multiplexed pair showing free count and lot ID without flicker |
| B5 | True cooperative scheduler | +15 | Task table with period/offset, overrun counter reported over UART |
| B6 | Watchdog recovery | +10 | WDT 250 ms, kicked in the dispatcher, `MCUCSR` reason logged |
| B7 | DS1307 real-time clock | +10 | Real wall-clock timestamps on tickets over the same I2C bus |
| B8 | Barrier obstruction detect | +10 | If the loop re-activates while closing, reopen and log `!EVT,LANE,OBSTRUCT` |

---

## 22. Deliverables

| # | Item | Detail |
|---|------|--------|
| 1 | Source code | Layered per §9.1; one lane FSM, two instances |
| 2 | `Simulation/parking.sim1` | Runs unmodified |
| 3 | `Docs/flowchart.png` | Matches §16 |
| 4 | `Docs/state_machine.png` | **Both** FSMs of §17 with transition tables |
| 5 | `Docs/test_report.md` | All 42 `TC` rows with evidence |
| 6 | Final report | 15 – 20 pages incl. servo timing derivation, fee-maths worked examples, timing budget |
| 7 | Demo video | 5 – 10 min: entry, exit, full, timeout, **simultaneous lanes**, fee calculation |
| 8 | Live defence | Any member, any file |

---

## 23. Evaluation Rubric

| Item | Marks | Full-mark criteria |
|------|:-----:|--------------------|
| GPIO | 5 | Single `PINC` read + masks; own DIO driver |
| ADC | 10 | Two loop channels with hysteresis, plus ambient light |
| Timer | 10 | 10 ms tick **and** Timer1 servo PWM correct to ±50 µs |
| Interrupts | 5 | Short ISRs, debounce outside, `volatile` discipline |
| USART | 10 | Frame, ticket, receipt and parser all per §18 |
| SPI | 10 | 74HC595 free-slot digit correct: shift then latch, no flicker |
| I2C | 10 | LCD via PCF8574, flicker-free |
| Application logic | 20 | Two lanes genuinely concurrent; fee maths exact on all four cases |
| Architecture | 10 | One reusable `Lane_t`; layer rule respected |
| Testing | 10 | 41 cases executed with evidence |
| Documentation & demo | 10 | Diagrams match code; concurrency demonstrated live |
| **Total** | **100** | Bonus up to +20, capped at 100 |

---


