# 0 "APP/display/display_task.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/display/display_task.c"
# 1 "APP/display/display_task.h" 1



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
# 5 "APP/display/display_task.h" 2
# 21 "APP/display/display_task.h"
STD_ReturnType DISPLAY_Init(void);


void DISPLAY_Task(void);
# 2 "APP/display/display_task.c" 2
# 1 "APP/config.h" 1
# 3 "APP/display/display_task.c" 2
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
uint8 LOT_GetPeakOccupancy(void);
# 4 "APP/display/display_task.c" 2
# 1 "./HAL/slotleds/slotleds.h" 1
# 18 "./HAL/slotleds/slotleds.h"
STD_ReturnType LED_Init(void);


STD_ReturnType LED_Update(uint8 Copy_u8SlotMap, uint8 Copy_u8LampsOn);


STD_ReturnType LED_TestPattern(uint8 Copy_u8Pattern);
# 5 "APP/display/display_task.c" 2
# 1 "./HAL/7seg/7seg.h" 1
# 19 "./HAL/7seg/7seg.h"
STD_ReturnType SEG_Init(void);



STD_ReturnType SEG_Show(uint8 Copy_u8Value);

STD_ReturnType SEG_Blank(void);

uint8 SEG_GetShadow(void);
# 6 "APP/display/display_task.c" 2
# 1 "./HAL/lcd/lcd_i2c.h" 1
# 22 "./HAL/lcd/lcd_i2c.h"
STD_ReturnType LCD_Init(void);

STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const char *Copy_pcText);



STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText);



void LCD_InvalidateShadow(void);

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On);
# 7 "APP/display/display_task.c" 2
# 1 "./APP/light/light.h" 1





STD_ReturnType LIGHT_Init(void);
STD_ReturnType LIGHT_Run(void);
uint8 LIGHT_GetState(void);
# 8 "APP/display/display_task.c" 2



static void DISPLAY_PaintLine1(uint8 Copy_u8Free, uint8 Copy_u8Occupied);
static void DISPLAY_PaintLine2(void);

STD_ReturnType DISPLAY_Init(void)
{





    return 0u;
}

void DISPLAY_Task(void)
{
    uint8 Local_u8Map = LOT_GetMap();
    uint8 Local_u8Free = LOT_GetFree();
    uint8 Local_u8Occupied = LOT_GetOccupied();


    LED_Update(Local_u8Map, LIGHT_GetState());


    (void)SEG_Show(Local_u8Free);


    DISPLAY_PaintLine1(Local_u8Free, Local_u8Occupied);
    DISPLAY_PaintLine2();
}


static void DISPLAY_PaintLine1(uint8 Copy_u8Free, uint8 Copy_u8Occupied)
{
    char Local_acLine[16u + 1u];

    Local_acLine[0] = 'F';
    Local_acLine[1] = 'R';
    Local_acLine[2] = 'E';
    Local_acLine[3] = 'E';
    Local_acLine[4] = ':';
    Local_acLine[5] = (char)('0' + Copy_u8Free);
    Local_acLine[6] = ' ';
    Local_acLine[7] = ' ';
    Local_acLine[8] = 'O';
    Local_acLine[9] = 'C';
    Local_acLine[10] = 'C';
    Local_acLine[11] = ':';
    Local_acLine[12] = (char)('0' + Copy_u8Occupied);
    Local_acLine[13] = ' ';
    Local_acLine[14] = ' ';
    Local_acLine[15] = ' ';
    Local_acLine[16] = '\0';

    (void)LCD_Paint(0u, Local_acLine);
}






static void DISPLAY_PaintLine2(void)
{
    (void)LCD_Paint(1u, "IN:---  OUT:---");
}
