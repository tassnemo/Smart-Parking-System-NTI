	.file	"exti.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.EXTI_Init,"ax",@progbits
.global	EXTI_Init
	.type	EXTI_Init, @function
EXTI_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	out 0x35,__zero_reg__
	in r24,0x34
	andi r24,lo8(-65)
	out 0x34,r24
	out 0x3b,__zero_reg__
	ldi r24,lo8(-32)
	out 0x3a,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	EXTI_Init, .-EXTI_Init
	.section	.text.EXTI_SetSense,"ax",@progbits
.global	EXTI_SetSense
	.type	EXTI_SetSense, @function
EXTI_SetSense:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r22,lo8(4)
	brsh .L10
	cpi r24,lo8(1)
	brsh .L4
	in r24,0x35
	andi r24,lo8(-4)
	or r24,r22
	out 0x35,r24
.L5:
	ldi r24,0
	ret
.L4:
	brne .L6
	in r24,0x35
	lsl r22
	lsl r22
	andi r24,lo8(-13)
	or r22,r24
	out 0x35,r22
	rjmp .L5
.L6:
	cpi r24,lo8(2)
	brne .L10
	cpi r22,lo8(2)
	brlo .L10
	brne .L7
	in r24,0x34
	andi r24,lo8(-65)
.L11:
	out 0x34,r24
	rjmp .L5
.L7:
	in r24,0x34
	ori r24,lo8(64)
	rjmp .L11
.L10:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	EXTI_SetSense, .-EXTI_SetSense
	.section	.text.EXTI_Enable,"ax",@progbits
.global	EXTI_Enable
	.type	EXTI_Enable, @function
EXTI_Enable:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	brsh .L13
	in r24,0x3b
	ori r24,lo8(64)
.L18:
	out 0x3b,r24
	ldi r24,0
	ret
.L13:
	brne .L15
	in r24,0x3b
	ori r24,lo8(-128)
	rjmp .L18
.L15:
	cpi r24,lo8(2)
	brne .L17
	in r24,0x3b
	ori r24,lo8(32)
	rjmp .L18
.L17:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	EXTI_Enable, .-EXTI_Enable
	.section	.text.EXTI_Disable,"ax",@progbits
.global	EXTI_Disable
	.type	EXTI_Disable, @function
EXTI_Disable:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	brsh .L20
	in r24,0x3b
	andi r24,lo8(-65)
.L25:
	out 0x3b,r24
	ldi r24,0
	ret
.L20:
	brne .L22
	in r24,0x3b
	andi r24,lo8(127)
	rjmp .L25
.L22:
	cpi r24,lo8(2)
	brne .L24
	in r24,0x3b
	andi r24,lo8(-33)
	rjmp .L25
.L24:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	EXTI_Disable, .-EXTI_Disable
	.section	.text.EXTI_ClearFlag,"ax",@progbits
.global	EXTI_ClearFlag
	.type	EXTI_ClearFlag, @function
EXTI_ClearFlag:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	brsh .L27
	ldi r24,lo8(64)
.L32:
	out 0x3a,r24
	ldi r24,0
	ret
.L27:
	brne .L29
	ldi r24,lo8(-128)
	rjmp .L32
.L29:
	cpi r24,lo8(2)
	brne .L31
	ldi r24,lo8(32)
	rjmp .L32
.L31:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	EXTI_ClearFlag, .-EXTI_ClearFlag
	.section	.text.EXTI_SetCallback,"ax",@progbits
.global	EXTI_SetCallback
	.type	EXTI_SetCallback, @function
EXTI_SetCallback:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L36
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L36
	mov r30,r24
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(g_EXTICallback))
	sbci r31,hi8(-(g_EXTICallback))
	st Z,r22
	std Z+1,r23
	ldi r24,0
	ret
.L36:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	EXTI_SetCallback, .-EXTI_SetCallback
	.section	.text.__vector_1,"ax",@progbits
.global	__vector_1
	.type	__vector_1, @function
__vector_1:
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
	lds r30,g_EXTICallback
	lds r31,g_EXTICallback+1
	sbiw r30,0
	breq .L37
	icall
.L37:
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
	.size	__vector_1, .-__vector_1
	.section	.text.__vector_2,"ax",@progbits
.global	__vector_2
	.type	__vector_2, @function
__vector_2:
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
	lds r30,g_EXTICallback+2
	lds r31,g_EXTICallback+3
	sbiw r30,0
	breq .L42
	icall
.L42:
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
	.size	__vector_2, .-__vector_2
	.section	.text.__vector_3,"ax",@progbits
.global	__vector_3
	.type	__vector_3, @function
__vector_3:
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
	lds r30,g_EXTICallback+4
	lds r31,g_EXTICallback+5
	sbiw r30,0
	breq .L47
	icall
.L47:
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
	.size	__vector_3, .-__vector_3
	.section	.bss.g_EXTICallback,"aw",@nobits
	.type	g_EXTICallback, @object
	.size	g_EXTICallback, 6
g_EXTICallback:
	.zero	6
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
