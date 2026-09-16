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
	in r18,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldd r20,Z+8
	ldd r21,Z+9
	ldd r24,Z+2
	ldd r25,Z+3
	cp r20,r24
	cpc r21,r25
	brsh .L11
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
	ldd r20,Z+2
	ldd r21,Z+3
	cp r24,r20
	cpc r25,r21
	brlo .L9
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
.L9:
	ldd r24,Z+8
	ldd r25,Z+9
	adiw r24,1
	std Z+8,r24
	std Z+9,r25
	ldi r24,0
.L8:
	out __SREG__,r18
	ret
.L11:
	ldi r24,lo8(1)
	rjmp .L8
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
	breq .L17
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L17
	in r18,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldd r24,Z+8
	ldd r25,Z+9
	or r24,r25
	breq .L18
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
	ldd r20,Z+2
	ldd r21,Z+3
	cp r24,r20
	cpc r25,r21
	brlo .L15
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
.L15:
	ldd r24,Z+8
	ldd r25,Z+9
	sbiw r24,1
	std Z+8,r24
	std Z+9,r25
	ldi r24,0
.L14:
	out __SREG__,r18
	ret
.L18:
	ldi r24,lo8(1)
	rjmp .L14
.L17:
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
	breq .L23
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L23
	in r24,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r25,lo8(1)
	ldd r18,Z+8
	ldd r19,Z+9
	or r18,r19
	breq .L21
	ldi r25,0
.L21:
	movw r30,r22
	st Z,r25
	out __SREG__,r24
	ldi r24,0
	ret
.L23:
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
	breq .L31
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L31
	in r19,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r18,lo8(1)
	movw r30,r24
	ldd r20,Z+8
	ldd r21,Z+9
	ldd r24,Z+2
	ldd r25,Z+3
	cp r20,r24
	cpc r21,r25
	brsh .L29
	ldi r18,0
.L29:
	movw r30,r22
	st Z,r18
	out __SREG__,r19
	ldi r24,0
	ret
.L31:
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
	breq .L35
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L35
	in r18,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	movw r30,r24
	ldd r24,Z+8
	ldd r25,Z+9
	movw r30,r22
	st Z,r24
	std Z+1,r25
	out __SREG__,r18
	ldi r24,0
	ret
.L35:
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
	breq .L38
	in r24,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
	std Z+8,__zero_reg__
	std Z+9,__zero_reg__
	out __SREG__,r24
	ldi r24,0
	ret
.L38:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	RingBuffer_Clear, .-RingBuffer_Clear
	.ident	"GCC: (GNU) 15.2.0"
