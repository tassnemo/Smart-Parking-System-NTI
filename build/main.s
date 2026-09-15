	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 2 */
.L__stack_usage = 2
	std Y+1,__zero_reg__
	std Y+2,__zero_reg__
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call ADC_Init
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(1)
	call DIO_Init
.L6:
	ldi r20,0
.L5:
	ldi r22,0
	ldi r24,lo8(1)
	call DIO_WritePin
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,0
	call ADC_ReadChannel
	ldd r24,Y+1
	ldd r25,Y+2
	cpi r24,1
	sbci r25,2
	brlo .L6
	ldi r20,lo8(1)
	rjmp .L5
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.0"
