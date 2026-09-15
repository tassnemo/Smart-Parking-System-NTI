	.file	"buttons.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BTN_Init,"ax",@progbits
.global	BTN_Init
	.type	BTN_Init, @function
BTN_Init:
	push r28
	push r29
	rcall .
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 3 */
/* stack size = 5 */
.L__stack_usage = 5
	std Y+1,r24
	std Y+3,r22
	std Y+2,r20
	cpi r22,lo8(8)
	brlo .L2
.L4:
	ldi r24,lo8(1)
.L1:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L2:
	ldi r20,lo8(2)
	ldd r22,Y+3
	ldd r24,Y+1
	call DIO_Init
	cpse r24,__zero_reg__
	rjmp .L4
	ldd r25,Y+3
	ldi r18,lo8(9)
	mul r25,r18
	movw r30,r0
	clr __zero_reg__
	subi r30,lo8(-(g_btns))
	sbci r31,hi8(-(g_btns))
	ldd r18,Y+1
	std Z+3,r18
	st Z,r25
	ldd r25,Y+2
	std Z+1,r25
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
	std Z+8,__zero_reg__
	ldi r25,lo8(1)
	std Z+2,r25
	rjmp .L1
	.size	BTN_Init, .-BTN_Init
	.section	.text.BTN_Update,"ax",@progbits
.global	BTN_Update
	.type	BTN_Update, @function
BTN_Update:
	push r16
	push r17
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 5 */
.L__stack_usage = 5
	ldi r16,lo8(g_btns)
	ldi r17,hi8(g_btns)
.L13:
	movw r30,r16
	ldd r24,Z+2
	cp r24, __zero_reg__
	breq .L7
	movw r20,r28
	subi r20,-1
	sbci r21,-1
	ld r22,Z
	ldd r24,Z+3
	call DIO_ReadPin
	ldi r24,lo8(1)
	ldi r25,0
	movw r30,r16
	ldd r19,Z+1
	ldd r18,Y+1
	cpse r19,r18
	ldi r24,0
.L8:
	movw r30,r16
	ldd r18,Z+4
	ldd r19,Z+5
	cp r18,r24
	cpc r19,r25
	breq .L9
	std Z+4,r24
	std Z+5,__zero_reg__
	std Z+8,__zero_reg__
.L7:
	subi r16,-9
	sbci r17,-1
	ldi r31,hi8(g_btns+72)
	cpi r16,lo8(g_btns+72)
	cpc r17,r31
	brne .L13
	ldi r24,0
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L9:
	ldd r18,Z+8
	cpi r18,lo8(5)
	brlo .L10
.L11:
	movw r30,r16
	std Z+6,r24
	std Z+7,__zero_reg__
	rjmp .L7
.L10:
	subi r18,lo8(-(1))
	std Z+8,r18
	cpi r18,lo8(5)
	brne .L7
	rjmp .L11
	.size	BTN_Update, .-BTN_Update
	.section	.text.BTN_GetState,"ax",@progbits
.global	BTN_GetState
	.type	BTN_GetState, @function
BTN_GetState:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(8)
	brsh .L21
	ldi r25,lo8(9)
	mul r24,r25
	movw r30,r0
	clr __zero_reg__
	subi r30,lo8(-(g_btns))
	sbci r31,hi8(-(g_btns))
	ldd r24,Z+2
	cp r24, __zero_reg__
	breq .L21
	ldd r24,Z+6
	ldd r25,Z+7
	ret
.L21:
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	BTN_GetState, .-BTN_GetState
	.section	.text.BTN_IsPressed,"ax",@progbits
.global	BTN_IsPressed
	.type	BTN_IsPressed, @function
BTN_IsPressed:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call BTN_GetState
	movw r18,r24
	ldi r24,lo8(1)
	cpi r18,1
	cpc r19,__zero_reg__
	breq .L23
	ldi r24,0
.L23:
/* epilogue start */
	ret
	.size	BTN_IsPressed, .-BTN_IsPressed
	.section	.bss.g_btns,"aw",@nobits
	.type	g_btns, @object
	.size	g_btns, 72
g_btns:
	.zero	72
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
