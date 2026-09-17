# 0 "main.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "main.c"
# 22 "main.c"
# 1 "C:/avr-gcc/avr/include/avr/io.h" 1 3
# 99 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 1 3
# 126 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 37 "C:/avr-gcc/avr/include/inttypes.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 38 "C:/avr-gcc/avr/include/inttypes.h" 2 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 127 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 2 3
# 100 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 230 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/iom32.h" 1 3
# 720 "C:/avr-gcc/avr/include/avr/iom32.h" 3
       
# 721 "C:/avr-gcc/avr/include/avr/iom32.h" 3

       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
# 231 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 785 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/portpins.h" 1 3
# 786 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/common.h" 1 3
# 788 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/version.h" 1 3
# 790 "C:/avr-gcc/avr/include/avr/io.h" 2 3






# 1 "C:/avr-gcc/avr/include/avr/fuse.h" 1 3
# 248 "C:/avr-gcc/avr/include/avr/fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
} __fuse_t;
# 797 "C:/avr-gcc/avr/include/avr/io.h" 2 3


# 1 "C:/avr-gcc/avr/include/avr/lock.h" 1 3
# 800 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 23 "main.c" 2
# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 24 "main.c" 2
# 1 "C:/avr-gcc/avr/include/util/atomic.h" 1 3
# 42 "C:/avr-gcc/avr/include/util/atomic.h" 3
static __inline__ uint8_t __iSeiRetVal(void)
{
    __asm__ __volatile__ ("sei" ::: "memory");
    return 1;
}

static __inline__ uint8_t __iCliRetVal(void)
{
    __asm__ __volatile__ ("cli" ::: "memory");
    return 1;
}

static __inline__ void __iSeiParam(const uint8_t *__s)
{
    __asm__ __volatile__ ("sei" ::: "memory");
    __asm__ volatile ("" ::: "memory");
    (void)__s;
}

static __inline__ void __iCliParam(const uint8_t *__s)
{
    __asm__ __volatile__ ("cli" ::: "memory");
    __asm__ volatile ("" ::: "memory");
    (void)__s;
}

static __inline__ void __iRestore(const uint8_t *__s)
{
    (*(volatile uint8_t *)((0x3F) + 0x20)) = *__s;
    __asm__ volatile ("" ::: "memory");
}
# 25 "main.c" 2

# 1 "LIB/STD_TYPES.h" 1




# 4 "LIB/STD_TYPES.h"
typedef unsigned char uint8;
typedef signed char sint8;
typedef unsigned short uint16;
typedef signed short sint16;
typedef unsigned long uint32;
typedef signed long sint32;
typedef unsigned long long uint64;
typedef signed long long sint64;

typedef float float32;
typedef double float64;
# 23 "LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 27 "main.c" 2
# 1 "APP/config.h" 1
# 28 "main.c" 2


# 1 "APP/scheduler/scheduler.h" 1
# 20 "APP/scheduler/scheduler.h"
typedef void (*SCHED_TaskFunc)(void);





STD_ReturnType SCHED_Init(void);
# 37 "APP/scheduler/scheduler.h"
STD_ReturnType SCHED_RegisterTask(SCHED_TaskFunc Copy_pfFunc,
                                   uint16 Copy_u16Period,
                                   uint16 Copy_u16Offset);







void SCHED_Tick(void);





uint32 SCHED_GetTickCount(void);
# 31 "main.c" 2
# 1 "LIB/softrtc.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/softrtc.h" 2

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
        char *Copy_pcBuf,
        uint8 Copy_u8BufSize);
# 32 "main.c" 2


# 1 "MCAL/dio/dio_interface.h" 1
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 35 "main.c" 2
# 1 "MCAL/adc/ADC_interface.h" 1
# 39 "MCAL/adc/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 36 "main.c" 2
# 1 "MCAL/timer/timer_interface.h" 1





typedef void (*TMR0_CallbackType)(void);

STD_ReturnType TMR0_InitCTC(void);
STD_ReturnType TMR0_Start(void);
STD_ReturnType TMR0_Stop(void);
STD_ReturnType TMR0_SetCompare(uint8 Copy_u8Value);
STD_ReturnType TMR0_SetCallback(TMR0_CallbackType Copy_pfCallback);
# 37 "main.c" 2
# 1 "MCAL/pwm/pwm_interface.h" 1
# 22 "MCAL/pwm/pwm_interface.h"
STD_ReturnType PWM_Init(void);







STD_ReturnType PWM_SetPulse(uint8 Copy_u8Channel, uint16 Copy_u16PulseUs);
# 38 "main.c" 2
# 1 "MCAL/usart/usart_interface.h" 1





STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 39 "main.c" 2


# 1 "HAL/slots/slots.h" 1
# 20 "HAL/slots/slots.h"
STD_ReturnType SLOT_Init(void);



STD_ReturnType SLOT_Poll(void);


uint8 SLOT_GetMap(void);



uint8 SLOT_CountFree(void);
# 42 "main.c" 2
# 1 "HAL/barrier/barrier.h" 1



# 1 "./LIB/STD_TYPES.h" 1
# 5 "HAL/barrier/barrier.h" 2

STD_ReturnType BAR_Init(uint8 Copy_u8Channel);
STD_ReturnType BAR_Open(uint8 Copy_u8Channel);
STD_ReturnType BAR_Close(uint8 Copy_u8Channel);
STD_ReturnType BAR_IsMoving(uint8 Copy_u8Channel, uint8 *Copy_pu8Status);
# 43 "main.c" 2
# 1 "HAL/7seg/7seg.h" 1
# 19 "HAL/7seg/7seg.h"
STD_ReturnType SEG_Init(void);



STD_ReturnType SEG_Show(uint8 Copy_u8Value);

STD_ReturnType SEG_Blank(void);

uint8 SEG_GetShadow(void);
# 44 "main.c" 2
# 1 "HAL/lcd/lcd_i2c.h" 1
# 22 "HAL/lcd/lcd_i2c.h"
STD_ReturnType LCD_Init(void);

STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const char *Copy_pcText);



STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText);



void LCD_InvalidateShadow(void);

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On);
# 45 "main.c" 2
# 1 "HAL/slotleds/slotleds.h" 1
# 18 "HAL/slotleds/slotleds.h"
STD_ReturnType LED_Init(void);


STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);


STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern);
# 46 "main.c" 2
# 1 "HAL/buttons/buttons.h" 1





typedef enum
{
    BTN_RELEASED = 0u,
    BTN_PRESSED = 1u
} BTN_StateType;


typedef struct
{
    uint8 pin;
    uint8 activeLevel;
    uint8 initialized;
    uint8 port;
    BTN_StateType rawState;
    BTN_StateType debouncedState;

    uint8 counter;
} BTN_ConfigType;

STD_ReturnType BTN_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8ActiveLevel);
STD_ReturnType BTN_Update(void);
BTN_StateType BTN_GetState(uint8 Copy_u8Pin);
uint8 BTN_IsPressed(uint8 Copy_u8Pin);
# 47 "main.c" 2
# 1 "HAL/buzzer/buzzer.h" 1





STD_ReturnType BUZ_Init(uint8 Copy_u8Pin);
STD_ReturnType BUZ_On(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Off(uint8 Copy_u8Pin);
STD_ReturnType BUZ_Beep(uint8 Copy_u8Pin,
                        uint8 Copy_u8Times,
                        uint16 Copy_u16Ms);

STD_ReturnType BUZ_Update(void);
# 48 "main.c" 2


# 1 "APP/lot/lot_fsm.h" 1






typedef enum
{
    LOT_INIT = 0u,
    LOT_OPERATIONAL,
    LOT_FULL,
    LOT_MAINTENANCE,
    LOT_FAULT
} LotState_t;

void LOT_Init(void);
void LOT_Run(void);

uint8 LOT_GetMap(void);
uint8 LOT_GetFree(void);
uint8 LOT_GetOccupied(void);
LotState_t LOT_GetState(void);

uint8 LOT_CanAuthoriseEntry(void);

void LOT_SetMaintenance(uint8 Copy_u8Enabled);
void LOT_SetFault(uint8 Copy_u8Enabled);
uint8 LOT_GetPeakOccupancy(void);
# 51 "main.c" 2
# 1 "APP/lane/lane_fsm.h" 1



# 1 "APP/../LIB/STD_TYPES.h" 1
# 5 "APP/lane/lane_fsm.h" 2

typedef enum {
    LN_IDLE = 0,
    LN_VEHICLE_WAIT,
    LN_AUTHORISING,
    LN_GATE_OPENING,
    LN_GATE_OPEN,
    LN_VEHICLE_PASSING,
    LN_GATE_CLOSING,
    LN_REJECTED,
    LN_TIMEOUT
} LaneState_t;

typedef struct {
    LaneState_t state;
    uint16 timerTicks;
    uint8 loopActive;
    uint8 servoCh;
    uint8 isEntry;
    uint16 passCount;
    uint8 faultFlag;
} Lane_t;

extern Lane_t g_entryLane;
extern Lane_t g_exitLane;

void LANE_Init(Lane_t *ln, uint8 servoCh, uint8 isEntry);
void LANE_Run(Lane_t *ln);
void LANE_RequestOpen(Lane_t *ln, uint8 Copy_u8LoopActive);
LaneState_t LANE_GetState(const Lane_t *ln);
# 52 "main.c" 2
# 1 "APP/loopsense/loopsense.h" 1




# 1 "./APP/lane/lane_fsm.h" 1
# 6 "APP/loopsense/loopsense.h" 2
# 24 "APP/loopsense/loopsense.h"
typedef struct
{
    uint8 adcChannel;
    Lane_t *lane;
    uint8 confirmedActive;
    uint8 candidateCount;
} LoopSense_t;







STD_ReturnType LOOPSENSE_Init(LoopSense_t *ls, uint8 adcChannel, Lane_t *lane);







STD_ReturnType LOOPSENSE_Run(LoopSense_t *ls);
# 53 "main.c" 2
# 1 "APP/ticketing/ticketing.h" 1







typedef struct
{
    uint16 id;
    uint32 entrySec;
    uint8 slotHint;
    uint8 active;
} Ticket_t;



void TKT_Init(void);






void TKT_OnEntryAuthorized(void);




STD_ReturnType TKT_CloseOldest(uint16 *Copy_pu16Id, uint32 *Copy_pu32EntrySec);


const Ticket_t *TKT_Find(uint16 Copy_u16Id);


uint8 TKT_GetOpenCount(void);


uint16 TKT_GetNextId(void);
uint16 TKT_GetTotalEntries(void);
void TKT_PrintOpenTickets(void);
void TKT_ClearStats(void);
# 54 "main.c" 2
# 1 "APP/billing/billing.h" 1
# 20 "APP/billing/billing.h"
void BIL_OnExitAuthorized(void);



uint16 BIL_GetTotalRevenue(void);
uint16 BIL_GetTotalExits(void);



void BIL_ClearStats(void);
# 55 "main.c" 2
# 1 "APP/light/light.h" 1





STD_ReturnType LIGHT_Init(void);
STD_ReturnType LIGHT_Run(void);
uint8 LIGHT_GetState(void);
# 56 "main.c" 2
# 1 "APP/display/display_task.h" 1
# 21 "APP/display/display_task.h"
STD_ReturnType DISPLAY_Init(void);


void DISPLAY_Task(void);
# 57 "main.c" 2
# 1 "APP/telemetry/telemetry.h" 1
# 23 "APP/telemetry/telemetry.h"
STD_ReturnType TELEM_BuildFrame(char *Copy_pu8Buf);




STD_ReturnType TELEM_Send(void);
# 58 "main.c" 2
# 1 "APP/console/console.h" 1
# 23 "APP/console/console.h"
STD_ReturnType CONSOLE_Init(void);
STD_ReturnType CONSOLE_ParseLine(const char *Copy_pcLine);


uint8 CONSOLE_GetTariff(void);
uint8 CONSOLE_GetGrace(void);
uint8 CONSOLE_GetHold(void);
uint8 CONSOLE_GetTimeout(void);
uint8 CONSOLE_GetLightThresh(void);
# 59 "main.c" 2
# 105 "main.c"
static volatile uint8 g_u8TickFlag = 0u;
static volatile uint8 g_u8TickOverrun = 0u;
static uint16 g_u16OverrunCnt = 0u;


extern Lane_t g_entryLane;
extern Lane_t g_exitLane;


static LoopSense_t g_entryLoop;
static LoopSense_t g_exitLoop;


static uint8 g_u8PrevMaintBtn = 0u;
static uint16 g_u16ExitBtnHold = 0u;
static uint8 g_u8PrevFullSign = 0xFFu;
static LotState_t g_PrevLotState = LOT_INIT;
static LaneState_t g_PrevEntryState = LN_IDLE;
static LaneState_t g_PrevExitState = LN_IDLE;
static uint8 g_u8InMaintenance = 0u;


static uint8 g_u8MismatchSec = 0u;
static uint8 g_u8MismatchLogged = 0u;


static char g_acLine[(24u + 2u)];
static uint8 g_u8LinePos = 0u;
static uint8 g_u8LineOverflow = 0u;




static void MAIN_Send(const char *Copy_pcStr)
{
    (void)USART_SendString((const uint8 *)Copy_pcStr);
}

static void MAIN_SendUint16(uint16 Copy_u16Value)
{
    char Local_acTmp[6];
    uint8 Local_u8Count = 0u;
    uint8 Local_u8i;

    if (Copy_u16Value == 0u)
    {
        (void)USART_SendByte((uint8)'0');
        return;
    }

    while (Copy_u16Value > 0u)
    {
        Local_acTmp[Local_u8Count] = (char)('0' + (Copy_u16Value % 10u));
        Local_u8Count++;
        Copy_u16Value = (uint16)(Copy_u16Value / 10u);
    }

    for (Local_u8i = Local_u8Count; Local_u8i > 0u; Local_u8i--)
    {
        (void)USART_SendByte((uint8)Local_acTmp[Local_u8i - 1u]);
    }
}


static void MAIN_SendEvent(const char *Copy_pcBody)
{
    MAIN_Send("!EVT,");
    MAIN_Send(Copy_pcBody);
    MAIN_Send("\r\n");
}


static void MAIN_SendId(uint16 Copy_u16Id)
{
    (void)USART_SendByte((uint8)('0' + (uint8)((Copy_u16Id / 1000u) % 10u)));
    (void)USART_SendByte((uint8)('0' + (uint8)((Copy_u16Id / 100u) % 10u)));
    (void)USART_SendByte((uint8)('0' + (uint8)((Copy_u16Id / 10u) % 10u)));
    (void)USART_SendByte((uint8)('0' + (uint8)( Copy_u16Id % 10u)));
}


static uint16 MAIN_LastIssuedId(void)
{
    uint16 Local_u16Next = TKT_GetNextId();

    return (Local_u16Next <= 1u)
         ? (uint16)9999u
         : (uint16)(Local_u16Next - 1u);
}




static void MAIN_DisableJtag(void)
{
    
# 200 "main.c" 3
   (*(volatile uint8_t *)((0x34) + 0x20)) 
# 200 "main.c"
          |= (1u << 
# 200 "main.c" 3
                    7
# 200 "main.c"
                       );
    
# 201 "main.c" 3
   (*(volatile uint8_t *)((0x34) + 0x20)) 
# 201 "main.c"
          |= (1u << 
# 201 "main.c" 3
                    7
# 201 "main.c"
                       );
}




static void MAIN_OnTick(void)
{
    if (g_u8TickFlag != 0u)
    {
        g_u8TickOverrun = 1u;
    }

    g_u8TickFlag = 1u;
    RTC_Tick10ms();
}




static void Task_Lanes(void)
{
    uint8 Local_u8ExitActive;
    LaneState_t Local_EntryState;
    LaneState_t Local_ExitState;




    if (LOT_GetState() == LOT_MAINTENANCE)
    {
        if (g_u8InMaintenance == 0u)
        {
            g_u8InMaintenance = 1u;

            g_entryLane.state = LN_IDLE;
            g_entryLane.timerTicks = 0u;
            g_entryLane.loopActive = 0u;

            g_exitLane.state = LN_IDLE;
            g_exitLane.timerTicks = 0u;
            g_exitLane.loopActive = 0u;

            (void)BAR_Open(0u);
            (void)BAR_Open(1u);

            MAIN_SendEvent("MAINT,ON");
        }
        return;
    }

    if (g_u8InMaintenance != 0u)
    {
        g_u8InMaintenance = 0u;

        (void)BAR_Close(0u);
        (void)BAR_Close(1u);

        MAIN_SendEvent("MAINT,OFF");
    }





    LANE_RequestOpen(&g_entryLane, g_entryLoop.confirmedActive);

    Local_u8ExitActive = (uint8)((g_exitLoop.confirmedActive != 0u) ||
                                 (g_u16ExitBtnHold != 0u));
    LANE_RequestOpen(&g_exitLane, Local_u8ExitActive);

    if (g_u16ExitBtnHold != 0u)
    {
        g_u16ExitBtnHold--;
    }


    LANE_Run(&g_entryLane);
    LANE_Run(&g_exitLane);


    Local_EntryState = LANE_GetState(&g_entryLane);
    Local_ExitState = LANE_GetState(&g_exitLane);

    if (Local_EntryState != g_PrevEntryState)
    {
        if (Local_EntryState == LN_GATE_OPENING)
        {
            MAIN_Send("!EVT,ENTRY,GRANT,");
            MAIN_SendId(MAIN_LastIssuedId());
            MAIN_Send("\r\n");
        }
        else if (Local_EntryState == LN_REJECTED)
        {
            MAIN_SendEvent("ENTRY,REJECT");
        }
        else if (Local_EntryState == LN_TIMEOUT)
        {
            MAIN_SendEvent("LANE,TIMEOUT,IN");
        }
        else
        {

        }

        g_PrevEntryState = Local_EntryState;
    }

    if (Local_ExitState != g_PrevExitState)
    {
        if (Local_ExitState == LN_TIMEOUT)
        {
            MAIN_SendEvent("LANE,TIMEOUT,OUT");
        }

        g_PrevExitState = Local_ExitState;
    }
}




static void Task_Buttons(void)
{
    uint8 Local_u8Maint;

    (void)BTN_Update();


    Local_u8Maint = BTN_IsPressed(3u);

    if ((Local_u8Maint != 0u) && (g_u8PrevMaintBtn == 0u))
    {
        LOT_SetMaintenance((uint8)((LOT_GetState() == LOT_MAINTENANCE) ? 0u : 1u));
    }
    g_u8PrevMaintBtn = Local_u8Maint;



    if (BTN_IsPressed(2u) != 0u)
    {
        g_u16ExitBtnHold = 300u;
    }


    (void)BUZ_Update();
}






static void Task_Lot(void)
{
    LotState_t Local_State;
    uint8 Local_u8FullSign;

    LOT_Run();

    Local_State = LOT_GetState();



    Local_u8FullSign = (uint8)((LOT_GetFree() == 0u) &&
                               (Local_State != LOT_MAINTENANCE));

    if (Local_u8FullSign != g_u8PrevFullSign)
    {
        (void)DIO_WritePin(3u,
                           6u,
                           (Local_u8FullSign != 0u) ? 1u : 0u);

        MAIN_SendEvent((Local_u8FullSign != 0u) ? "LOT,FULL" : "LOT,VACANT");

        g_u8PrevFullSign = Local_u8FullSign;
    }

    if (Local_State != g_PrevLotState)
    {
        if (Local_State == LOT_FAULT)
        {


            (void)BAR_Open(0u);
            (void)BAR_Open(1u);
            MAIN_SendEvent("LOT,FAULT");
        }

        g_PrevLotState = Local_State;
    }
}




static void Task_Loops(void)
{
    (void)LOOPSENSE_Run(&g_entryLoop);
    (void)LOOPSENSE_Run(&g_exitLoop);
}




static void Task_Display(void)
{
    DISPLAY_Task();
}




static void Task_1Hz(void)
{
    uint8 Local_u8Tickets;
    uint8 Local_u8Occupied;

    (void)LIGHT_Run();

    Local_u8Tickets = TKT_GetOpenCount();
    Local_u8Occupied = LOT_GetOccupied();

    if (Local_u8Tickets != Local_u8Occupied)
    {
        if (g_u8MismatchSec < 0xFFu)
        {
            g_u8MismatchSec++;
        }

        if ((g_u8MismatchSec > 30u) &&
            (g_u8MismatchLogged == 0u))
        {

            MAIN_Send("!EVT,LOT,MISMATCH,");
            MAIN_SendUint16((uint16)Local_u8Tickets);
            (void)USART_SendByte((uint8)',');
            MAIN_SendUint16((uint16)Local_u8Occupied);
            MAIN_Send("\r\n");

            g_u8MismatchLogged = 1u;
        }
    }
    else
    {
        g_u8MismatchSec = 0u;
        g_u8MismatchLogged = 0u;
    }


    if (g_u16OverrunCnt != 0u)
    {
        MAIN_Send("!EVT,SCHED,OVR,");
        MAIN_SendUint16(g_u16OverrunCnt);
        MAIN_Send("\r\n");
        g_u16OverrunCnt = 0u;
    }
}




static void Task_Report(void)
{
    (void)TELEM_Send();
}





static void Task_Console(void)
{
    uint8 Local_u8Byte;

    while (USART_ReceiveByte(&Local_u8Byte) == 0u)
    {
        if ((Local_u8Byte == (uint8)'\r') || (Local_u8Byte == (uint8)'\n'))
        {
            if (g_u8LineOverflow != 0u)
            {
                MAIN_Send("ERR LONG\r\n");
            }
            else if (g_u8LinePos > 0u)
            {
                g_acLine[g_u8LinePos] = '\0';
                (void)CONSOLE_ParseLine(g_acLine);
            }
            else
            {

            }

            g_u8LinePos = 0u;
            g_u8LineOverflow = 0u;
        }
        else if (g_u8LinePos < 24u)
        {
            g_acLine[g_u8LinePos] = (char)Local_u8Byte;
            g_u8LinePos++;
        }
        else
        {

            g_u8LineOverflow = 1u;
        }
    }
}




static STD_ReturnType MAIN_InitMcal(void)
{
    STD_ReturnType Local_u8Result = 0u;

    if (ADC_Init(1u, 6u) != 0u) { Local_u8Result = 1u; }
    if (PWM_Init() != 0u) { Local_u8Result = 1u; }
    if (USART_Init() != 0u) { Local_u8Result = 1u; }


    if (TMR0_InitCTC() != 0u) { Local_u8Result = 1u; }
    if (TMR0_SetCallback(MAIN_OnTick) != 0u) { Local_u8Result = 1u; }




    return Local_u8Result;
}

static STD_ReturnType MAIN_InitHal(void)
{
    STD_ReturnType Local_u8Result = 0u;

    if (SLOT_Init() != 0u) { Local_u8Result = 1u; }
    if (SEG_Init() != 0u) { Local_u8Result = 1u; }
    if (LED_Init() != 0u) { Local_u8Result = 1u; }
    if (LCD_Init() != 0u) { Local_u8Result = 1u; }
    if (BUZ_Init(7u) != 0u) { Local_u8Result = 1u; }

    if (BTN_Init(3u, 2u, 0u) != 0u)
    {
        Local_u8Result = 1u;
    }
    if (BTN_Init(3u, 3u, 0u) != 0u)
    {
        Local_u8Result = 1u;
    }

    if (BAR_Init(0u) != 0u) { Local_u8Result = 1u; }
    if (BAR_Init(1u) != 0u) { Local_u8Result = 1u; }


    (void)BAR_Close(0u);
    (void)BAR_Close(1u);


    if (DIO_Init(3u, 6u, 1u) != 0u)
    {
        Local_u8Result = 1u;
    }
    (void)DIO_WritePin(3u, 6u, 0u);

    return Local_u8Result;
}

static STD_ReturnType MAIN_InitApp(void)
{
    STD_ReturnType Local_u8Result = 0u;

    LOT_Init();
    TKT_Init();

    if (LIGHT_Init() != 0u) { Local_u8Result = 1u; }
    if (CONSOLE_Init() != 0u) { Local_u8Result = 1u; }
    if (DISPLAY_Init() != 0u) { Local_u8Result = 1u; }


    LANE_Init(&g_entryLane, 0u, 1u);
    LANE_Init(&g_exitLane, 1u, 0u);

    if (LOOPSENSE_Init(&g_entryLoop, 0u, &g_entryLane) != 0u)
    {
        Local_u8Result = 1u;
    }
    if (LOOPSENSE_Init(&g_exitLoop, 1u, &g_exitLane) != 0u)
    {
        Local_u8Result = 1u;
    }

    return Local_u8Result;
}

static STD_ReturnType MAIN_InitScheduler(void)
{
    STD_ReturnType Local_u8Result = 0u;

    if (SCHED_Init() != 0u) { return 1u; }

    if (SCHED_RegisterTask(Task_Lanes, 1u, 0u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_Buttons, 1u, 0u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_Lot, 5u, 1u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_Loops, 5u, 3u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_Console, 2u, 4u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_Display, 25u, 5u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_1Hz, 100u, 7u) != 0u) { Local_u8Result = 1u; }
    if (SCHED_RegisterTask(Task_Report, 500u, 11u) != 0u) { Local_u8Result = 1u; }

    return Local_u8Result;
}




int main(void)
{
    uint8 Local_u8ResetCause = 
# 617 "main.c" 3
                              (*(volatile uint8_t *)((0x34) + 0x20))
# 617 "main.c"
                                    ;
     
# 618 "main.c" 3
    (*(volatile uint8_t *)((0x34) + 0x20)) 
# 618 "main.c"
           = 0u;
    STD_ReturnType Local_u8InitResult = 0u;
    uint8 Local_u8Tick;


    MAIN_DisableJtag();

    if (MAIN_InitMcal() != 0u) { Local_u8InitResult = 1u; }
    if (MAIN_InitHal() != 0u) { Local_u8InitResult = 1u; }
    if (MAIN_InitApp() != 0u) { Local_u8InitResult = 1u; }
    if (MAIN_InitScheduler() != 0u) { Local_u8InitResult = 1u; }



    (void)LCD_Paint(0u, "SMART PARKING   ");
    (void)LCD_Paint(1u, "BOOTING...      ");

    LOT_Run();
    DISPLAY_Task();

    (void)TMR0_Start();
    
# 639 "main.c" 3
   __asm__ __volatile__ ("sei" ::: "memory")
# 639 "main.c"
        ;
    MAIN_Send("!EVT,BOOT,CAUSE=");
    MAIN_SendUint16((uint16)Local_u8ResetCause);
    MAIN_Send("\r\n");

    MAIN_SendEvent("BOOT");




    MAIN_SendEvent("CFG,DEFAULT");

    if (Local_u8InitResult != 0u)
    {


        LOT_SetFault(1u);
        MAIN_SendEvent("LOT,FAULT,INIT");
    }


    for (;;)
    {
        
# 662 "main.c" 3
       for ( uint8_t sreg_save __attribute__((__cleanup__(__iRestore))) = (*(volatile uint8_t *)((0x3F) + 0x20)), __ToDo = __iCliRetVal(); __ToDo ; __ToDo = 0 )
        
# 663 "main.c"
       {
            Local_u8Tick = g_u8TickFlag;
            g_u8TickFlag = 0u;

            if (g_u8TickOverrun != 0u)
            {
                g_u8TickOverrun = 0u;
                if (g_u16OverrunCnt < 0xFFFFu)
                {
                    g_u16OverrunCnt++;
                }
            }
        }

        if (Local_u8Tick != 0u)
        {
            SCHED_Tick();
        }



    }

    return 0;
}
