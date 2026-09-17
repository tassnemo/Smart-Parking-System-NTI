	.file	"pwm.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.PWM_Init,"ax",@progbits
.global	PWM_Init
	.type	PWM_Init, @function
PWM_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x11
	ori r24,lo8(48)
	out 0x11,r24
	ldi r24,lo8(-94)
	out 0x2f,r24
	ldi r24,lo8(26)
	out 0x2e,r24
	ldi r24,lo8(78)
	out 0x27,r24
	ldi r24,lo8(31)
	out 0x26,r24
	ldi r25,lo8(3)
	out 0x2b,r25
	ldi r24,lo8(-24)
	out 0x2a,r24
	out 0x29,r25
	out 0x28,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	PWM_Init, .-PWM_Init
	.section	.text.PWM_SetPulse,"ax",@progbits
.global	PWM_SetPulse
	.type	PWM_SetPulse, @function
PWM_SetPulse:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r18,r22
	subi r18,-24
	sbci r19,3
	cpi r18,-23
	sbci r19,3
	brsh .L7
	cpi r24,lo8(1)
	brsh .L4
	out 0x2b,r23
	out 0x2a,r22
.L5:
	ldi r24,0
	ret
.L4:
	brne .L7
	out 0x29,r23
	out 0x28,r22
	rjmp .L5
.L7:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	PWM_SetPulse, .-PWM_SetPulse
	.ident	"GCC: (GNU) 15.2.0"
