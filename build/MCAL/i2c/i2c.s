	.file	"i2c.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.I2C_WaitForInterrupt,"ax",@progbits
	.type	I2C_WaitForInterrupt, @function
I2C_WaitForInterrupt:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r18,lo8(-1)
	ldi r19,lo8(-1)
.L2:
	in __tmp_reg__,0x36
	sbrc __tmp_reg__,7
	rjmp .L3
	cp r18,__zero_reg__
	cpc r19,__zero_reg__
	brne .L4
.L3:
	ldi r24,lo8(1)
	or r18,r19
	breq .L5
	ldi r24,0
.L5:
/* epilogue start */
	ret
.L4:
	subi r18,1
	sbc r19,__zero_reg__
	rjmp .L2
	.size	I2C_WaitForInterrupt, .-I2C_WaitForInterrupt
	.section	.text.I2C_Init,"ax",@progbits
.global	I2C_Init
	.type	I2C_Init, @function
I2C_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x1
	andi r24,lo8(-4)
	out 0x1,r24
	ldi r24,lo8(32)
	out 0,r24
	out 0x2,__zero_reg__
	ldi r24,lo8(4)
	out 0x36,r24
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
	ldi r24,lo8(-92)
	out 0x36,r24
	call I2C_WaitForInterrupt
	cpse r24,__zero_reg__
	rjmp .L10
	in r24,0x1
	andi r24,lo8(-8)
	cpi r24,lo8(8)
	breq .L14
	in r25,0x1
	andi r25,lo8(-8)
	ldi r24,lo8(1)
	cpi r25,lo8(16)
	brne .L10
.L14:
	ldi r24,0
.L10:
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
	ldi r24,lo8(-108)
	out 0x36,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	I2C_Stop, .-I2C_Stop
	.section	.text.I2C_Write,"ax",@progbits
.global	I2C_Write
	.type	I2C_Write, @function
I2C_Write:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	out 0x3,r24
	ldi r24,lo8(-124)
	out 0x36,r24
	call I2C_WaitForInterrupt
	cpse r24,__zero_reg__
	rjmp .L16
	in r25,0x1
	andi r25,lo8(-8)
	ldi r24,lo8(1)
	cpi r25,lo8(40)
	brne .L18
	ldi r24,0
.L18:
	ldi r18,lo8(1)
	cpi r25,lo8(24)
	brne .L19
	ldi r18,0
.L19:
	and r24,r18
.L16:
/* epilogue start */
	ret
	.size	I2C_Write, .-I2C_Write
	.section	.text.I2C_ReadAck,"ax",@progbits
.global	I2C_ReadAck
	.type	I2C_ReadAck, @function
I2C_ReadAck:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	or r24,r25
	brne .L21
.L23:
	ldi r24,lo8(1)
.L20:
/* epilogue start */
	pop r29
	pop r28
	ret
.L21:
	ldi r24,lo8(-60)
	out 0x36,r24
	call I2C_WaitForInterrupt
	cpse r24,__zero_reg__
	rjmp .L23
	in r25,0x1
	andi r25,lo8(-8)
	cpi r25,lo8(80)
	brne .L23
	in r25,0x3
	st Y,r25
	rjmp .L20
	.size	I2C_ReadAck, .-I2C_ReadAck
	.section	.text.I2C_ReadNack,"ax",@progbits
.global	I2C_ReadNack
	.type	I2C_ReadNack, @function
I2C_ReadNack:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	or r24,r25
	brne .L25
.L27:
	ldi r24,lo8(1)
.L24:
/* epilogue start */
	pop r29
	pop r28
	ret
.L25:
	ldi r24,lo8(-124)
	out 0x36,r24
	call I2C_WaitForInterrupt
	cpse r24,__zero_reg__
	rjmp .L27
	in r25,0x1
	andi r25,lo8(-8)
	cpi r25,lo8(88)
	brne .L27
	in r25,0x3
	st Y,r25
	rjmp .L24
	.size	I2C_ReadNack, .-I2C_ReadNack
	.ident	"GCC: (GNU) 15.2.0"
