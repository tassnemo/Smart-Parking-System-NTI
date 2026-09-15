	.file	"buzzer.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BUZ_Init,"ax",@progbits
.global	BUZ_Init
	.type	BUZ_Init, @function
BUZ_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	mov r22,r24
	ldi r24,lo8(3)
	jmp DIO_Init
	.size	BUZ_Init, .-BUZ_Init
	.section	.text.BUZ_On,"ax",@progbits
.global	BUZ_On
	.type	BUZ_On, @function
BUZ_On:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	mov r22,r24
	ldi r24,lo8(3)
	jmp DIO_WritePin
	.size	BUZ_On, .-BUZ_On
	.section	.text.BUZ_Off,"ax",@progbits
.global	BUZ_Off
	.type	BUZ_Off, @function
BUZ_Off:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,0
	mov r22,r24
	ldi r24,lo8(3)
	jmp DIO_WritePin
	.size	BUZ_Off, .-BUZ_Off
	.ident	"GCC: (GNU) 15.2.0"
