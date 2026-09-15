	.file	"checksum.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.XOR_Checksum,"ax",@progbits
.global	XOR_Checksum
	.type	XOR_Checksum, @function
XOR_Checksum:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	add r22,r24
	adc r23,r25
	ldi r18,0
.L2:
	cp r24,r22
	cpc r25,r23
	brne .L3
	mov r24,r18
/* epilogue start */
	ret
.L3:
	movw r30,r24
	ld r24,Z+
	eor r18,r24
	movw r24,r30
	rjmp .L2
	.size	XOR_Checksum, .-XOR_Checksum
	.ident	"GCC: (GNU) 15.2.0"
