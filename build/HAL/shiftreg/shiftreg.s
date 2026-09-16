	.file	"shiftreg.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
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
	rjmp .L3
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_Init
	cpse r24,__zero_reg__
	rjmp .L3
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	jmp DIO_WritePin
.L3:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	SR_Init, .-SR_Init
	.section	.text.SR_Write,"ax",@progbits
.global	SR_Write
	.type	SR_Write, @function
SR_Write:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call SPI_Transfer
	cp r24, __zero_reg__
	breq .L6
.L8:
	ldi r24,lo8(1)
.L5:
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L6:
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_WritePin
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call DIO_WritePin
	rjmp .L5
	.size	SR_Write, .-SR_Write
	.ident	"GCC: (GNU) 15.2.0"
