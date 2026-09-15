	.file	"ring_buffer.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.RingBuffer_Init,"ax",@progbits
.global	RingBuffer_Init
	.type	RingBuffer_Init, @function
RingBuffer_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L5
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L5
	cp r20,__zero_reg__
	cpc r21,__zero_reg__
	breq .L5
	st Z,r22
	std Z+1,r23
	std Z+2,r20
	std Z+3,r21
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
	std Z+8,__zero_reg__
	std Z+9,__zero_reg__
	ldi r24,0
	ret
.L5:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_Init, .-RingBuffer_Init
	.section	.text.RingBuffer_Push,"ax",@progbits
.global	RingBuffer_Push
	.type	RingBuffer_Push, @function
RingBuffer_Push:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L10
	ldd r18,Z+8
	ldd r19,Z+9
	ldd r24,Z+2
	ldd r25,Z+3
	cp r18,r24
	cpc r19,r25
	brsh .L10
	ld r26,Z
	ldd r27,Z+1
	ldd r24,Z+4
	ldd r25,Z+5
	add r26,r24
	adc r27,r25
	st X,r22
	ldd r24,Z+4
	ldd r25,Z+5
	adiw r24,1
	std Z+4,r24
	std Z+5,r25
	ldd r18,Z+2
	ldd r19,Z+3
	cp r24,r18
	cpc r25,r19
	brlo .L8
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
.L8:
	ldd r24,Z+8
	ldd r25,Z+9
	adiw r24,1
	std Z+8,r24
	std Z+9,r25
	ldi r24,0
	ret
.L10:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_Push, .-RingBuffer_Push
	.section	.text.RingBuffer_Pop,"ax",@progbits
.global	RingBuffer_Pop
	.type	RingBuffer_Pop, @function
RingBuffer_Pop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L16
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L16
	ldd r24,Z+8
	ldd r25,Z+9
	or r24,r25
	breq .L16
	ld r26,Z
	ldd r27,Z+1
	ldd r24,Z+6
	ldd r25,Z+7
	add r26,r24
	adc r27,r25
	ld r24,X
	movw r26,r22
	st X,r24
	ldd r24,Z+6
	ldd r25,Z+7
	adiw r24,1
	std Z+6,r24
	std Z+7,r25
	ldd r18,Z+2
	ldd r19,Z+3
	cp r24,r18
	cpc r25,r19
	brlo .L13
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
.L13:
	ldd r24,Z+8
	ldd r25,Z+9
	sbiw r24,1
	std Z+8,r24
	std Z+9,r25
	ldi r24,0
	ret
.L16:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_Pop, .-RingBuffer_Pop
	.section	.text.RingBuffer_IsEmpty,"ax",@progbits
.global	RingBuffer_IsEmpty
	.type	RingBuffer_IsEmpty, @function
RingBuffer_IsEmpty:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L21
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L21
	ldi r25,lo8(1)
	ldd r18,Z+8
	ldd r19,Z+9
	or r18,r19
	breq .L19
	ldi r25,0
.L19:
	movw r30,r22
	st Z,r25
	ldi r24,0
	ret
.L21:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_IsEmpty, .-RingBuffer_IsEmpty
	.section	.text.RingBuffer_IsFull,"ax",@progbits
.global	RingBuffer_IsFull
	.type	RingBuffer_IsFull, @function
RingBuffer_IsFull:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L29
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L29
	ldi r18,lo8(1)
	movw r30,r24
	ldd r20,Z+8
	ldd r21,Z+9
	ldd r24,Z+2
	ldd r25,Z+3
	cp r20,r24
	cpc r21,r25
	brsh .L27
	ldi r18,0
.L27:
	movw r30,r22
	st Z,r18
	ldi r24,0
	ret
.L29:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_IsFull, .-RingBuffer_IsFull
	.section	.text.RingBuffer_Size,"ax",@progbits
.global	RingBuffer_Size
	.type	RingBuffer_Size, @function
RingBuffer_Size:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L33
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L33
	movw r30,r24
	ldd r24,Z+8
	ldd r25,Z+9
	movw r30,r22
	st Z,r24
	std Z+1,r25
	ldi r24,0
	ret
.L33:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_Size, .-RingBuffer_Size
	.section	.text.RingBuffer_Clear,"ax",@progbits
.global	RingBuffer_Clear
	.type	RingBuffer_Clear, @function
RingBuffer_Clear:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L36
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
	std Z+8,__zero_reg__
	std Z+9,__zero_reg__
	ldi r24,0
	ret
.L36:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_Clear, .-RingBuffer_Clear
	.ident	"GCC: (GNU) 15.2.0"
