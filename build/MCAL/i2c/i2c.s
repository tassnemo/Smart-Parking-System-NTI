	.file	"i2c.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.I2C_SclRelease,"ax",@progbits
	.type	I2C_SclRelease, @function
I2C_SclRelease:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(2)
	ldi r22,0
	ldi r24,lo8(2)
	jmp DIO_Init
	.size	I2C_SclRelease, .-I2C_SclRelease
	.section	.text.I2C_SdaRelease,"ax",@progbits
	.type	I2C_SdaRelease, @function
I2C_SdaRelease:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(2)
	ldi r22,lo8(1)
	ldi r24,lo8(2)
	jmp DIO_Init
	.size	I2C_SdaRelease, .-I2C_SdaRelease
	.section	.text.I2C_SdaLow,"ax",@progbits
	.type	I2C_SdaLow, @function
I2C_SdaLow:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,lo8(1)
	ldi r24,lo8(2)
	call DIO_Init
	ldi r20,0
	ldi r22,lo8(1)
	ldi r24,lo8(2)
	jmp DIO_WritePin
	.size	I2C_SdaLow, .-I2C_SdaLow
	.section	.text.I2C_SclLow,"ax",@progbits
	.type	I2C_SclLow, @function
I2C_SclLow:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(2)
	call DIO_Init
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(2)
	jmp DIO_WritePin
	.size	I2C_SclLow, .-I2C_SclLow
	.section	.text.I2C_ReadBit,"ax",@progbits
	.type	I2C_ReadBit, @function
I2C_ReadBit:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	call I2C_SdaRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SclRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	std Y+1,__zero_reg__
	movw r20,r28
	subi r20,-1
	sbci r21,-1
	ldi r22,lo8(1)
	ldi r24,lo8(2)
	call DIO_ReadPin
	ldd r24,Y+1
	std Y+2,r24
	call I2C_SclLow
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	ldd r24,Y+2
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	I2C_ReadBit, .-I2C_ReadBit
	.section	.text.I2C_WriteBit.isra.0,"ax",@progbits
	.type	I2C_WriteBit.isra.0, @function
I2C_WriteBit.isra.0:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r24, __zero_reg__
	breq .L7
	call I2C_SdaRelease
.L8:
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SclRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SclLow
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
/* epilogue start */
	ret
.L7:
	call I2C_SdaLow
	rjmp .L8
	.size	I2C_WriteBit.isra.0, .-I2C_WriteBit.isra.0
	.section	.text.I2C_Init,"ax",@progbits
.global	I2C_Init
	.type	I2C_Init, @function
I2C_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call I2C_SclRelease
	call I2C_SdaRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	ldi r24,0
/* epilogue start */
	ret
	.size	I2C_Init, .-I2C_Init
	.section	.text.I2C_Start,"ax",@progbits
.global	I2C_Start
	.type	I2C_Start, @function
I2C_Start:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call I2C_SdaRelease
	call I2C_SclRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SdaLow
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SclLow
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	ldi r24,0
/* epilogue start */
	ret
	.size	I2C_Start, .-I2C_Start
	.section	.text.I2C_Stop,"ax",@progbits
.global	I2C_Stop
	.type	I2C_Stop, @function
I2C_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call I2C_SdaLow
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SclRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	call I2C_SdaRelease
	ldi r24,lo8(53)
1:	dec r24
	brne 1b
	nop
	ldi r24,lo8(-96)
1:	dec r24
	brne 1b
	ldi r24,0
/* epilogue start */
	ret
	.size	I2C_Stop, .-I2C_Stop
	.section	.text.I2C_Write,"ax",@progbits
.global	I2C_Write
	.type	I2C_Write, @function
I2C_Write:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	ldi r28,lo8(7)
	ldi r29,0
	mov r16,r24
	ldi r17,0
.L13:
	movw r24,r16
	mov r0,r28
	rjmp 2f
	1:
	asr r25
	ror r24
	2:
	dec r0
	brpl 1b
	andi r24,lo8(1)
	call I2C_WriteBit.isra.0
	sbiw r28,1
	brcc .L13
	call I2C_ReadBit
	mov r25,r24
	ldi r24,lo8(1)
	cpse r25,__zero_reg__
	rjmp .L14
	ldi r24,0
.L14:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	I2C_Write, .-I2C_Write
	.section	.text.I2C_ReadAck,"ax",@progbits
.global	I2C_ReadAck
	.type	I2C_ReadAck, @function
I2C_ReadAck:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r16,r24
	ldi r28,lo8(1)
	or r24,r25
	breq .L16
	ldi r28,lo8(8)
	ldi r29,0
.L18:
	call I2C_ReadBit
	lsl r29
	or r29,r24
	subi r28,lo8(1)
	brne .L18
	ldi r24,0
	call I2C_WriteBit.isra.0
	movw r30,r16
	st Z,r29
.L16:
	mov r24,r28
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	I2C_ReadAck, .-I2C_ReadAck
	.section	.text.I2C_ReadNack,"ax",@progbits
.global	I2C_ReadNack
	.type	I2C_ReadNack, @function
I2C_ReadNack:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r16,r24
	ldi r28,lo8(1)
	or r24,r25
	breq .L21
	ldi r28,lo8(8)
	ldi r29,0
.L23:
	call I2C_ReadBit
	lsl r29
	or r29,r24
	subi r28,lo8(1)
	brne .L23
	ldi r24,lo8(1)
	call I2C_WriteBit.isra.0
	movw r30,r16
	st Z,r29
.L21:
	mov r24,r28
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	I2C_ReadNack, .-I2C_ReadNack
	.ident	"GCC: (GNU) 15.2.0"
