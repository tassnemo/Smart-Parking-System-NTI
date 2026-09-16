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
	call SR_Init
	ldi r16,lo8(1)
	ldi r17,0
	cpse r24,__zero_reg__
.L3:
	rjmp .L3
.L2:
	ldi r28,0
	ldi r29,0
.L4:
	movw r24,r16
	mov r0,r28
	rjmp 2f
	1:
	lsl r24
	rol r25
	2:
	dec r0
	brpl 1b
	call SR_Write
	ldi r24,lo8(479999)
	ldi r25,hi8(479999)
	ldi r18,hlo8(479999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	adiw r28,1
	cpi r28,16
	cpc r29,__zero_reg__
	brne .L4
	ldi r24,0
	ldi r25,0
	call SR_Write
	ldi r24,lo8(799999)
	ldi r25,hi8(799999)
	ldi r18,hlo8(799999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(85)
	ldi r25,lo8(5)
	call SR_Write
	ldi r24,lo8(1119999)
	ldi r25,hi8(1119999)
	ldi r18,hlo8(1119999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(-86)
	ldi r25,lo8(10)
	call SR_Write
	ldi r24,lo8(1119999)
	ldi r25,hi8(1119999)
	ldi r18,hlo8(1119999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	ldi r24,0
	ldi r25,lo8(16)
	call SR_Write
	ldi r24,lo8(1119999)
	ldi r25,hi8(1119999)
	ldi r18,hlo8(1119999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	ldi r24,0
	ldi r25,0
	call SR_Write
	ldi r24,lo8(1119999)
	ldi r25,hi8(1119999)
	ldi r18,hlo8(1119999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	rjmp .L2
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.0"
