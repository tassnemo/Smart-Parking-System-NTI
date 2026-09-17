# 0 "main.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "main.c"
# 24 "main.c"
# 1 "APP/config.h" 1
# 25 "main.c" 2
# 1 "LIB/STD_TYPES.h" 1



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
# 26 "main.c" 2

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
# 28 "main.c" 2

# 1 "HAL/slots/slots.h" 1
# 20 "HAL/slots/slots.h"
STD_ReturnType SLOT_Init(void);



STD_ReturnType SLOT_Poll(void);


uint8 SLOT_GetMap(void);



uint8 SLOT_CountFree(void);
# 30 "main.c" 2
# 1 "HAL/slotleds/slotleds.h" 1
# 18 "HAL/slotleds/slotleds.h"
STD_ReturnType LED_Init(void);


STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);


STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern);
# 31 "main.c" 2
# 1 "HAL/7seg/7seg.h" 1
# 19 "HAL/7seg/7seg.h"
STD_ReturnType SEG_Init(void);



STD_ReturnType SEG_Show(uint8 Copy_u8Value);

STD_ReturnType SEG_Blank(void);

uint8 SEG_GetShadow(void);
# 32 "main.c" 2
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
# 33 "main.c" 2
# 1 "MCAL/dio/dio_interface.h" 1
# 27 "MCAL/dio/dio_interface.h"
STD_ReturnType DIO_Init(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);
STD_ReturnType DIO_WritePin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPin(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);
STD_ReturnType DIO_WritePort(uint8 Copy_u8Port, uint8 Copy_u8Value);
STD_ReturnType DIO_ReadPort(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
STD_ReturnType DIO_TogglePin(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 34 "main.c" 2

# 1 "APP/lot/lot_fsm.h" 1



# 1 "./LIB/STD_TYPES.h" 1
# 5 "APP/lot/lot_fsm.h" 2


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
# 36 "main.c" 2
# 1 "APP/display/display_task.h" 1
# 21 "APP/display/display_task.h"
STD_ReturnType DISPLAY_Init(void);


void DISPLAY_Task(void);
# 37 "main.c" 2
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
# 38 "main.c" 2

# 1 "LIB/softrtc.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/softrtc.h" 2

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
STD_ReturnType RTC_Format(uint32 Copy_u32Sec,
        char *Copy_pcBuf,
        uint8 Copy_u8BufSize);
# 40 "main.c" 2
# 1 "MCAL/usart/usart_interface.h" 1





STD_ReturnType USART_Init(void);

STD_ReturnType USART_SendByte(uint8 Copy_u8Data);

STD_ReturnType USART_ReceiveByte(uint8 *Copy_pu8Data);

STD_ReturnType USART_SendString(const uint8 *Copy_pu8String);
# 41 "main.c" 2

# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 38 "C:/avr-gcc/avr/include/avr/interrupt.h" 3
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
# 39 "C:/avr-gcc/avr/include/avr/interrupt.h" 2 3
# 43 "main.c" 2
# 1 "C:/avr-gcc/avr/include/util/delay.h" 1 3
# 50 "C:/avr-gcc/avr/include/util/delay.h" 3
# 1 "C:/avr-gcc/avr/include/util/delay_basic.h" 1 3
# 40 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
static __inline__ void _delay_loop_1(uint8_t __count) __attribute__((__always_inline__));
static __inline__ void _delay_loop_2(uint16_t __count) __attribute__((__always_inline__));
# 80 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
void
_delay_loop_1(uint8_t __count)
{
 __asm__ volatile (
  "1: dec %0" "\n\t"
  "brne 1b"
  : "=r" (__count)
  : "0" (__count)
 );
}
# 102 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
void
_delay_loop_2(uint16_t __count)
{
# 113 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
 __asm__ volatile (
  "1: sbiw %0,1" "\n\t"
  "brne 1b"
  : "+w" (__count)
 );

}
# 51 "C:/avr-gcc/avr/include/util/delay.h" 2 3
# 151 "C:/avr-gcc/avr/include/util/delay.h" 3
static __inline__ __attribute__((__always_inline__)) void _delay_ms(double __ms);

void
_delay_ms(double __ms)
{
 double __tmp ;


 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(uint32_t);
 __tmp = ((
# 161 "C:/avr-gcc/avr/include/util/delay.h"
          8000000UL
# 161 "C:/avr-gcc/avr/include/util/delay.h" 3
               ) / 1e3) * __ms;
# 171 "C:/avr-gcc/avr/include/util/delay.h" 3
  __ticks_dc = (uint32_t)(__builtin_ceil(__builtin_fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 197 "C:/avr-gcc/avr/include/util/delay.h" 3
}
# 234 "C:/avr-gcc/avr/include/util/delay.h" 3
static __inline__ __attribute__((__always_inline__)) void _delay_us(double __us);

void
_delay_us(double __us)
{
 double __tmp ;


 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(uint32_t);
 __tmp = ((
# 244 "C:/avr-gcc/avr/include/util/delay.h"
          8000000UL
# 244 "C:/avr-gcc/avr/include/util/delay.h" 3
               ) / 1e6) * __us;
# 254 "C:/avr-gcc/avr/include/util/delay.h" 3
  __ticks_dc = (uint32_t)(__builtin_ceil(__builtin_fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 281 "C:/avr-gcc/avr/include/util/delay.h" 3
}
# 44 "main.c" 2
# 55 "main.c"

# 55 "main.c"
static void TEST_PollManualTicketTrigger(void);
static void TASK_SlotsWrapper(void);

int main(void)
{

    (void)SLOT_Init();
    (void)LED_Init();
    (void)SEG_Init();
    (void)LCD_Init();

    LOT_Init();
    (void)DISPLAY_Init();
    TKT_Init();

    (void)USART_Init();

    (void)DIO_Init(3u, 3u, 2u);


    (void)SCHED_Init();
    (void)SCHED_RegisterTask(TASK_SlotsWrapper, 1u, 0u);
    (void)SCHED_RegisterTask(LOT_Run, 1u, 1u);
    (void)SCHED_RegisterTask(DISPLAY_Task, 25u, 5u);
    (void)SCHED_RegisterTask(RTC_Tick10ms, 1u, 2u);

    
# 81 "main.c" 3
   __asm__ __volatile__ ("sei" ::: "memory")
# 81 "main.c"
        ;

    (void)USART_SendString((const uint8 *)"!EVT,BOOT\r\n");

    for (;;)
    {

        _delay_ms(10u);
        SCHED_Tick();

        TEST_PollManualTicketTrigger();
    }
}


static void TASK_SlotsWrapper(void)
{
    (void)SLOT_Poll();
}





static void TEST_PollManualTicketTrigger(void)
{
    static uint8 Local_u8LowCount = 0u;
    static uint8 Local_u8Armed = 1u;
    uint8 Local_u8Level = 1u;

    (void)DIO_ReadPin(3u, 3u, &Local_u8Level);

    if (Local_u8Level == 0u)
    {
        if (Local_u8LowCount < 3u)
        {
            Local_u8LowCount++;
        }

        if ((Local_u8LowCount >= 3u) && (Local_u8Armed != 0u))
        {
            TKT_OnEntryAuthorized();
            Local_u8Armed = 0u;
        }
    }
    else
    {
        Local_u8LowCount = 0u;
        Local_u8Armed = 1u;
    }
}
