	.file	"loopsense.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LOOPSENSE_Init,"ax",@progbits
.global	LOOPSENSE_Init
	.type	LOOPSENSE_Init, @function
LOOPSENSE_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L4
	cp r20,__zero_reg__
	cpc r21,__zero_reg__
	breq .L4
	st Z,r22
	std Z+1,r20
	std Z+2,r21
	std Z+3,__zero_reg__
	std Z+4,__zero_reg__
	ldi r24,0
	ret
.L4:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	LOOPSENSE_Init, .-LOOPSENSE_Init
	.section	.text.LOOPSENSE_Run,"ax",@progbits
.global	LOOPSENSE_Run
	.type	LOOPSENSE_Run, @function
LOOPSENSE_Run:
	push r16
	push r17
	push r28
	push r29
	rcall .
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 3 */
/* stack size = 7 */
.L__stack_usage = 7
	movw r16,r24
	sbiw r24,0
	brne .L6
.L8:
	ldi r24,lo8(1)
	std Y+3,r24
.L5:
	ldd r24,Y+3
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L6:
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	movw r30,r24
	ld r24,Z
	call ADC_ReadChannel
	std Y+3,r24
	cpse r24,__zero_reg__
	rjmp .L8
	movw r30,r16
	ldd r24,Z+3
	ldd r18,Y+1
	ldd r19,Y+2
	cpse r24,__zero_reg__
	rjmp .L9
	cpi r18,89
	sbci r19,2
	brsh .L15
.L11:
	movw r30,r16
	std Z+4,__zero_reg__
	rjmp .L5
.L9:
	ldi r22,lo8(1)
	cpi r18,-112
	sbci r19,1
	brsh .L12
	ldi r22,0
.L12:
	cp r24,r22
	breq .L11
.L10:
	movw r30,r16
	ldd r24,Z+4
	subi r24,lo8(-(1))
	std Z+4,r24
	cpi r24,lo8(4)
	brlo .L5
	std Z+3,r22
	std Z+4,__zero_reg__
	ldd r24,Z+1
	ldd r25,Z+2
	call LANE_RequestOpen
	rjmp .L5
.L15:
	ldi r22,lo8(1)
	rjmp .L10
	.size	LOOPSENSE_Run, .-LOOPSENSE_Run
	.ident	"GCC: (GNU) 15.2.0"
