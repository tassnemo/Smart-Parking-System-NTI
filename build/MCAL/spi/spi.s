	.file	"spi.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SPI_Init,"ax",@progbits
.global	SPI_Init
	.type	SPI_Init, @function
SPI_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x17
	ori r24,lo8(-96)
	out 0x17,r24
	cbi 0x17,6
	ldi r24,lo8(81)
	out 0xd,r24
	cbi 0xe,0
	ldi r24,0
/* epilogue start */
	ret
	.size	SPI_Init, .-SPI_Init
	.section	.text.SPI_Transfer,"ax",@progbits
.global	SPI_Transfer
	.type	SPI_Transfer, @function
SPI_Transfer:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L5
	out 0xf,r24
.L4:
	sbis 0xe,7
	rjmp .L4
	in r24,0xf
	movw r30,r22
	st Z,r24
	ldi r24,0
	ret
.L5:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	SPI_Transfer, .-SPI_Transfer
	.ident	"GCC: (GNU) 15.2.0"
