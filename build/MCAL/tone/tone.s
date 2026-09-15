	.file	"tone.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TONE_Init,"ax",@progbits
.global	TONE_Init
	.type	TONE_Init, @function
TONE_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x11,7
	ldi r24,lo8(31)
	out 0x23,r24
	out 0x24,__zero_reg__
	ldi r24,lo8(8)
	out 0x25,r24
	cbi 0x12,7
	ldi r24,0
/* epilogue start */
	ret
	.size	TONE_Init, .-TONE_Init
	.section	.text.TONE_Start,"ax",@progbits
.global	TONE_Start
	.type	TONE_Start, @function
TONE_Start:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(28)
	out 0x25,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	TONE_Start, .-TONE_Start
	.section	.text.TONE_Stop,"ax",@progbits
.global	TONE_Stop
	.type	TONE_Stop, @function
TONE_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(8)
	out 0x25,r24
	cbi 0x12,7
	ldi r24,0
/* epilogue start */
	ret
	.size	TONE_Stop, .-TONE_Stop
	.ident	"GCC: (GNU) 15.2.0"
