	.file	"light.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LIGHT_Init,"ax",@progbits
.global	LIGHT_Init
	.type	LIGHT_Init, @function
LIGHT_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_u8LampsOn,__zero_reg__
	ldi r24,0
/* epilogue start */
	ret
	.size	LIGHT_Init, .-LIGHT_Init
	.section	.text.LIGHT_Run,"ax",@progbits
.global	LIGHT_Run
	.type	LIGHT_Run, @function
LIGHT_Run:
	push r14
	push r15
	push r17
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 7 */
.L__stack_usage = 7
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,lo8(2)
	call ADC_ReadChannel
	mov r17,r24
	cpse r24,__zero_reg__
	rjmp .L7
	call CONSOLE_GetLightThresh
	mov r18,r24
	ldd r14,Y+1
	ldd r15,Y+2
	lds r24,g_u8LampsOn
	cpse r24,__zero_reg__
	rjmp .L4
	ldi r19,0
	ldi r26,lo8(-1)
	ldi r27,lo8(3)
	call __umulhisi3
	ldi r18,lo8(100)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	cp r14,r18
	cpc r15,r19
	brsh .L2
	ldi r24,lo8(1)
	sts g_u8LampsOn,r24
.L2:
	mov r24,r17
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r15
	pop r14
	ret
.L4:
	subi r18,lo8(-(10))
	cpi r18,lo8(101)
	brlo .L6
	ldi r18,lo8(100)
.L6:
	ldi r19,0
	ldi r26,lo8(-1)
	ldi r27,lo8(3)
	call __umulhisi3
	ldi r18,lo8(100)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	cp r14,r18
	cpc r15,r19
	brlo .L2
	sts g_u8LampsOn,__zero_reg__
	rjmp .L2
.L7:
	ldi r17,lo8(1)
	rjmp .L2
	.size	LIGHT_Run, .-LIGHT_Run
	.section	.text.LIGHT_GetState,"ax",@progbits
.global	LIGHT_GetState
	.type	LIGHT_GetState, @function
LIGHT_GetState:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8LampsOn
/* epilogue start */
	ret
	.size	LIGHT_GetState, .-LIGHT_GetState
	.section	.bss.g_u8LampsOn,"aw",@nobits
	.type	g_u8LampsOn, @object
	.size	g_u8LampsOn, 1
g_u8LampsOn:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
