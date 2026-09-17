# 0 "main.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "main.c"
# 1 "HAL/lcd/lcd_i2c.h" 1



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
# 5 "HAL/lcd/lcd_i2c.h" 2
# 22 "HAL/lcd/lcd_i2c.h"
STD_ReturnType LCD_Init(void);

STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const char *Copy_pcText);



STD_ReturnType LCD_Paint(uint8 Copy_u8Row, const char *Copy_pcText);



void LCD_InvalidateShadow(void);

STD_ReturnType LCD_DisplayOn(uint8 Copy_u8On);
# 2 "main.c" 2
# 1 "APP/config.h" 1
# 3 "main.c" 2

static void SR_Delay(void)
{
    volatile uint32 d;
    for (d = 0; d < 800000ul; d++) { }
}

int main(void)
{
    LCD_Init();



    LCD_Paint(0, "FREE:6  OCC:0");
    LCD_Paint(1, "IN:IDLE OUT:IDLE");
    SR_Delay();





    LCD_Paint(0, "FREE:3  OCC:3");
    LCD_Paint(1, "IN:OPEN OUT:IDLE");
    SR_Delay();


    LCD_Clear();
    SR_Delay();
    LCD_Paint(0, "FREE:3  OCC:3");
    LCD_Paint(1, "IN:OPEN OUT:IDLE");
    SR_Delay();




    LCD_SetCursor(0, 0);
    LCD_WriteString("RAW LINE 1 TEST");
    LCD_SetCursor(1, 0);
    LCD_WriteChar('X');
    LCD_WriteChar('Y');
    LCD_WriteChar('Z');

    while (1) { }
}
