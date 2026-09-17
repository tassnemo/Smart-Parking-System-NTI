	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SR_Delay,"ax",@progbits
	.type	SR_Delay, @function
SR_Delay:
	push r28
	push r29
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 4 */
/* stack size = 6 */
.L__stack_usage = 6
	std Y+1,__zero_reg__
	std Y+2,__zero_reg__
	std Y+3,__zero_reg__
	std Y+4,__zero_reg__
.L2:
	ldd r24,Y+1
	ldd r25,Y+2
	ldd r26,Y+3
	ldd r27,Y+4
	cpi r25,53
	sbci r26,12
	cpc r27,__zero_reg__
	brlo .L3
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L3:
	ldd r24,Y+1
	ldd r25,Y+2
	ldd r26,Y+3
	ldd r27,Y+4
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	std Y+1,r24
	std Y+2,r25
	std Y+3,r26
	std Y+4,r27
	rjmp .L2
	.size	SR_Delay, .-SR_Delay
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC0:
	.string	"FREE:6  OCC:0"
.LC1:
	.string	"IN:IDLE OUT:IDLE"
.LC2:
	.string	"FREE:3  OCC:3"
.LC3:
	.string	"IN:OPEN OUT:IDLE"
.LC4:
	.string	"RAW LINE 1 TEST"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call LCD_Init
	ldi r22,lo8(.LC0)
	ldi r23,hi8(.LC0)
	ldi r24,0
	call LCD_Paint
	ldi r22,lo8(.LC1)
	ldi r23,hi8(.LC1)
	ldi r24,lo8(1)
	call LCD_Paint
	call SR_Delay
	ldi r22,lo8(.LC2)
	ldi r23,hi8(.LC2)
	ldi r24,0
	call LCD_Paint
	ldi r22,lo8(.LC3)
	ldi r23,hi8(.LC3)
	ldi r24,lo8(1)
	call LCD_Paint
	call SR_Delay
	call LCD_Clear
	call SR_Delay
	ldi r22,lo8(.LC2)
	ldi r23,hi8(.LC2)
	ldi r24,0
	call LCD_Paint
	ldi r22,lo8(.LC3)
	ldi r23,hi8(.LC3)
	ldi r24,lo8(1)
	call LCD_Paint
	call SR_Delay
	ldi r22,0
	ldi r24,0
	call LCD_SetCursor
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	call LCD_WriteString
	ldi r22,0
	ldi r24,lo8(1)
	call LCD_SetCursor
	ldi r24,lo8(88)
	call LCD_WriteChar
	ldi r24,lo8(89)
	call LCD_WriteChar
	ldi r24,lo8(90)
	call LCD_WriteChar
.L5:
	rjmp .L5
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
