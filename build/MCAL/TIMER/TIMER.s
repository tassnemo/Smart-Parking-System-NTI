	.file	"timer.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TMR0_InitCTC,"ax",@progbits
.global	TMR0_InitCTC
	.type	TMR0_InitCTC, @function
TMR0_InitCTC:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(8)
	out 0x33,r24
	out 0x32,__zero_reg__
	ldi r24,lo8(77)
	out 0x3c,r24
	in r24,0x39
	ori r24,lo8(2)
	out 0x39,r24
	ldi r24,lo8(2)
	out 0x38,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	TMR0_InitCTC, .-TMR0_InitCTC
	.section	.text.TMR0_Start,"ax",@progbits
.global	TMR0_Start
	.type	TMR0_Start, @function
TMR0_Start:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x33
	andi r24,lo8(-8)
	ori r24,lo8(5)
	out 0x33,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	TMR0_Start, .-TMR0_Start
	.section	.text.TMR0_Stop,"ax",@progbits
.global	TMR0_Stop
	.type	TMR0_Stop, @function
TMR0_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x33
	andi r24,lo8(-8)
	out 0x33,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	TMR0_Stop, .-TMR0_Stop
	.section	.text.TMR0_SetCompare,"ax",@progbits
.global	TMR0_SetCompare
	.type	TMR0_SetCompare, @function
TMR0_SetCompare:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	out 0x3c,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	TMR0_SetCompare, .-TMR0_SetCompare
	.section	.text.TMR0_SetCallback,"ax",@progbits
.global	TMR0_SetCallback
	.type	TMR0_SetCallback, @function
TMR0_SetCallback:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L7
	sts g_TMR0Callback,r24
	sts g_TMR0Callback+1,r25
	ldi r24,0
	ret
.L7:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	TMR0_SetCallback, .-TMR0_SetCallback
	.section	.text.__vector_10,"ax",@progbits
.global	__vector_10
	.type	__vector_10, @function
__vector_10:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	lds r30,g_TMR0Callback
	lds r31,g_TMR0Callback+1
	sbiw r30,0
	breq .L8
	icall
.L8:
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_10, .-__vector_10
	.section	.bss.g_TMR0Callback,"aw",@nobits
	.type	g_TMR0Callback, @object
	.size	g_TMR0Callback, 2
g_TMR0Callback:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
