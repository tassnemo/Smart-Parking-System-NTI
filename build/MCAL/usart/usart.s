	.file	"usart.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.USART_Init,"ax",@progbits
.global	USART_Init
	.type	USART_Init, @function
USART_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(64)
	ldi r21,0
	ldi r22,lo8(g_USARTRxStorage)
	ldi r23,hi8(g_USARTRxStorage)
	ldi r24,lo8(g_USARTRxBuffer)
	ldi r25,hi8(g_USARTRxBuffer)
	call RingBuffer_Init
	cpse r24,__zero_reg__
	rjmp .L3
	out 0xa,__zero_reg__
	cbi 0xb,1
	out 0x20,__zero_reg__
	ldi r25,lo8(51)
	out 0x9,r25
	ldi r25,lo8(-122)
	out 0x20,r25
	ldi r25,lo8(-104)
	out 0xa,r25
	ret
.L3:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	USART_Init, .-USART_Init
	.section	.text.USART_SendByte,"ax",@progbits
.global	USART_SendByte
	.type	USART_SendByte, @function
USART_SendByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L5:
	sbis 0xb,5
	rjmp .L5
	out 0xc,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	USART_SendByte, .-USART_SendByte
	.section	.text.USART_ReceiveByte,"ax",@progbits
.global	USART_ReceiveByte
	.type	USART_ReceiveByte, @function
USART_ReceiveByte:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	sbiw r24,0
	breq .L10
	in r28,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	movw r22,r24
	ldi r24,lo8(g_USARTRxBuffer)
	ldi r25,hi8(g_USARTRxBuffer)
	call RingBuffer_Pop
	out __SREG__,r28
.L8:
/* epilogue start */
	pop r28
	ret
.L10:
	ldi r24,lo8(1)
	rjmp .L8
	.size	USART_ReceiveByte, .-USART_ReceiveByte
	.section	.text.USART_SendString,"ax",@progbits
.global	USART_SendString
	.type	USART_SendString, @function
USART_SendString:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	or r24,r25
	brne .L13
	ldi r24,lo8(1)
	rjmp .L11
.L14:
	adiw r28,1
	call USART_SendByte
.L13:
	ld r24,Y
	cpse r24,__zero_reg__
	rjmp .L14
.L11:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	USART_SendString, .-USART_SendString
	.section	.text.__vector_13,"ax",@progbits
.global	__vector_13
	.type	__vector_13, @function
__vector_13:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	in r22,0xc
	ldi r24,lo8(g_USARTRxBuffer)
	ldi r25,hi8(g_USARTRxBuffer)
	call RingBuffer_Push
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_13, .-__vector_13
	.section	.bss.g_USARTRxBuffer,"aw",@nobits
	.type	g_USARTRxBuffer, @object
	.size	g_USARTRxBuffer, 10
g_USARTRxBuffer:
	.zero	10
	.section	.bss.g_USARTRxStorage,"aw",@nobits
	.type	g_USARTRxStorage, @object
	.size	g_USARTRxStorage, 64
g_USARTRxStorage:
	.zero	64
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
