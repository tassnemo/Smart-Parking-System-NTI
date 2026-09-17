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
	.string	"?   "
	.section	.text.DISPLAY_Task,"ax",@progbits
.global	DISPLAY_Task
	.type	DISPLAY_Task, @function
DISPLAY_Task:
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 18 */
/* stack size = 22 */
.L__stack_usage = 22
	call LOT_GetMap
	std Y+18,r24
	call LOT_GetFree
	mov r16,r24
	call LOT_GetOccupied
	mov r17,r24
	call LIGHT_GetState
	mov r22,r24
	ldd r24,Y+18
	call LED_Update
	mov r24,r16
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
	ldi r25,lo8(48)
	add r25,r16
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
	subi r17,lo8(-(48))
	std Y+13,r17
	std Y+14,r25
	std Y+15,r25
	std Y+16,r25
	std Y+17,__zero_reg__
	movw r16,r28
	subi r16,-1
	sbci r17,-1
	movw r22,r16
	ldi r24,0
	call LCD_Paint
	lds r30,g_entryLane
	movw r22,r16
	ldi r26,lo8(.LC0)
	ldi r27,hi8(.LC0)
	cpi r30,lo8(9)
	brsh .L3
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(CSWTCH.1))
	sbci r31,hi8(-(CSWTCH.1))
	ld r26,Z
	ldd r27,Z+1
.L3:
	lds r30,g_exitLane
	cpi r30,lo8(9)
	brsh .L6
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(CSWTCH.1))
	sbci r31,hi8(-(CSWTCH.1))
	ld __tmp_reg__,Z+
	ld r31,Z
	mov r30,__tmp_reg__
.L4:
	ldi r24,lo8(73)
	std Y+1,r24
	ldi r24,lo8(78)
	std Y+2,r24
	ldi r24,lo8(58)
	std Y+3,r24
	ld r25,X+
	std Y+4,r25
	ld r25,X+
	std Y+5,r25
	ld r25,X+
	std Y+6,r25
	ld r25,X
	std Y+7,r25
	ldi r25,lo8(32)
	std Y+8,r25
	ldi r25,lo8(79)
	std Y+9,r25
	ldi r25,lo8(85)
	std Y+10,r25
	ldi r25,lo8(84)
	std Y+11,r25
	std Y+12,r24
	ld r24,Z
	std Y+13,r24
	ldd r24,Z+1
	std Y+14,r24
	ldd r24,Z+2
	std Y+15,r24
	ldd r24,Z+3
	std Y+16,r24
	std Y+17,__zero_reg__
	ldi r24,lo8(1)
	call LCD_Paint
/* epilogue start */
	adiw r28,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L6:
	ldi r30,lo8(.LC0)
	ldi r31,hi8(.LC0)
	rjmp .L4
	.size	DISPLAY_Task, .-DISPLAY_Task
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"IDLE"
.LC2:
	.string	"WAIT"
.LC3:
	.string	"AUTH"
.LC4:
	.string	"OPEN"
.LC5:
	.string	"PASS"
.LC6:
	.string	"CLOS"
.LC7:
	.string	"REJ "
.LC8:
	.string	"TIME"
	.section	.rodata.CSWTCH.1,"a"
	.type	CSWTCH.1, @object
	.size	CSWTCH.1, 18
CSWTCH.1:
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
