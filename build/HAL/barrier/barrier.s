	.file	"barrier.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BAR_Init,"ax",@progbits
.global	BAR_Init
	.type	BAR_Init, @function
BAR_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	mov r25,r24
	ldi r24,lo8(1)
	cpi r25,lo8(2)
	brsh .L2
	ldi r24,0
.L2:
/* epilogue start */
	ret
	.size	BAR_Init, .-BAR_Init
	.section	.text.BAR_Open,"ax",@progbits
.global	BAR_Open
	.type	BAR_Open, @function
BAR_Open:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(-48)
	ldi r23,lo8(7)
	jmp PWM_SetPulse
	.size	BAR_Open, .-BAR_Open
	.section	.text.BAR_Close,"ax",@progbits
.global	BAR_Close
	.type	BAR_Close, @function
BAR_Close:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(-24)
	ldi r23,lo8(3)
	jmp PWM_SetPulse
	.size	BAR_Close, .-BAR_Close
	.section	.text.BAR_IsMoving,"ax",@progbits
.global	BAR_IsMoving
	.type	BAR_IsMoving, @function
BAR_IsMoving:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L8
	cpi r24,lo8(2)
	brsh .L8
	movw r30,r22
	st Z,__zero_reg__
	ldi r24,0
	ret
.L8:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	BAR_IsMoving, .-BAR_IsMoving
	.ident	"GCC: (GNU) 15.2.0"
