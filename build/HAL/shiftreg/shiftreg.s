	.file	"shiftreg.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SR_Write,"ax",@progbits
.global	SR_Write
	.type	SR_Write, @function
SR_Write:
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	rcall .
	rcall .
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 5 */
/* stack size = 13 */
.L__stack_usage = 13
	movw r12,r24
	std Y+1,r13
	std Y+2,r24
	movw r16,r28
	subi r16,-1
	sbci r17,-1
	movw r14,r28
	ldi r24,3
	add r14,r24
	adc r15,__zero_reg__
	std Y+5,r14
	std Y+4,r15
.L4:
	ldd r22,Y+5
	ldd r23,Y+4
	movw r30,r16
	ld r24,Z
	call SPI_Transfer
	cp r24, __zero_reg__
	breq .L2
.L5:
	ldi r24,lo8(1)
.L1:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	ret
.L2:
	subi r16,-1
	sbci r17,-1
	cp r16,r14
	cpc r17,r15
	brne .L4
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_WritePin
	cpse r24,__zero_reg__
	rjmp .L5
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_WritePin
	cpse r24,__zero_reg__
	rjmp .L5
	sts SR_u16Shadow,r12
	sts SR_u16Shadow+1,r13
	rjmp .L1
	.size	SR_Write, .-SR_Write
	.section	.text.SR_Init,"ax",@progbits
.global	SR_Init
	.type	SR_Init, @function
SR_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call SPI_Init
	cpse r24,__zero_reg__
	rjmp .L9
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_Init
	cpse r24,__zero_reg__
	rjmp .L9
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_WritePin
	cpse r24,__zero_reg__
	rjmp .L9
	ldi r24,lo8(-1)
	ldi r25,lo8(-1)
	sts SR_u16Shadow,r24
	sts SR_u16Shadow+1,r25
	adiw r24,1
	jmp SR_Write
.L9:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	SR_Init, .-SR_Init
	.section	.text.SR_GetShadow,"ax",@progbits
.global	SR_GetShadow
	.type	SR_GetShadow, @function
SR_GetShadow:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,SR_u16Shadow
	lds r25,SR_u16Shadow+1
/* epilogue start */
	ret
	.size	SR_GetShadow, .-SR_GetShadow
	.section	.bss.SR_u16Shadow,"aw",@nobits
	.type	SR_u16Shadow, @object
	.size	SR_u16Shadow, 2
SR_u16Shadow:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
