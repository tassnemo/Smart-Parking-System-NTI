	.file	"display_task.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.DISPLAY_Init,"ax",@progbits
.global	DISPLAY_Init
	.type	DISPLAY_Init, @function
DISPLAY_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,0
/* epilogue start */
	ret
	.size	DISPLAY_Init, .-DISPLAY_Init
	.section	.rodata.DISPLAY_Task.str1.1,"aMS",@progbits,1
.LC0:
	.string	"IN:---  OUT:---"
	.section	.text.DISPLAY_Task,"ax",@progbits
.global	DISPLAY_Task
	.type	DISPLAY_Task, @function
DISPLAY_Task:
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,20
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 20 */
/* stack size = 22 */
.L__stack_usage = 22
	call LOT_GetMap
	std Y+19,r24
	call LOT_GetFree
	std Y+18,r24
	call LOT_GetOccupied
	std Y+20,r24
	ldi r22,0
	ldd r24,Y+19
	call LED_Update
	ldd r24,Y+18
	call SEG_Show
	ldi r24,lo8(70)
	std Y+1,r24
	ldi r24,lo8(82)
	std Y+2,r24
	ldi r24,lo8(69)
	std Y+3,r24
	std Y+4,r24
	ldi r24,lo8(58)
	std Y+5,r24
	ldd r25,Y+18
	subi r25,lo8(-(48))
	std Y+6,r25
	ldi r25,lo8(32)
	std Y+7,r25
	std Y+8,r25
	ldi r18,lo8(79)
	std Y+9,r18
	ldi r18,lo8(67)
	std Y+10,r18
	std Y+11,r18
	std Y+12,r24
	ldd r24,Y+20
	subi r24,lo8(-(48))
	std Y+13,r24
	std Y+14,r25
	std Y+15,r25
	std Y+16,r25
	std Y+17,__zero_reg__
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,0
	call LCD_Paint
	ldi r22,lo8(.LC0)
	ldi r23,hi8(.LC0)
	ldi r24,lo8(1)
/* epilogue start */
	adiw r28,20
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	jmp LCD_Paint
	.size	DISPLAY_Task, .-DISPLAY_Task
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
