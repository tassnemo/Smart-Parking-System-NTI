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
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x11,5
	ldi r24,lo8(-126)
	out 0x2f,r24
	ldi r24,lo8(26)
	out 0x2e,r24
	ldi r24,lo8(31)
	ldi r25,lo8(78)
	out 0x26+1,r25
	out 0x26,r24
	ldi r24,lo8(-24)
	ldi r25,lo8(3)
	out 0x2a+1,r25
	out 0x2a,r24
.L2:
	rjmp .L2
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.0"
