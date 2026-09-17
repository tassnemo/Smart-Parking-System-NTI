	.file	"lcd_i2c.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LCD_SendCommand,"ax",@progbits
	.type	LCD_SendCommand, @function
LCD_SendCommand:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	std Y+1,r24
	call I2C_Start
	cpse r24,__zero_reg__
	rjmp .L3
	ldi r24,lo8(124)
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L3
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L3
	ldd r24,Y+1
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L3
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	jmp I2C_Stop
.L3:
	ldi r24,lo8(1)
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	LCD_SendCommand, .-LCD_SendCommand
	.section	.text.LCD_Init,"ax",@progbits
.global	LCD_Init
	.type	LCD_Init, @function
LCD_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call I2C_Init
	cp r24, __zero_reg__
	breq .L6
.L8:
	ldi r24,lo8(1)
	ret
.L6:
	ldi r18,lo8(79999)
	ldi r24,hi8(79999)
	ldi r25,hlo8(79999)
1:	subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(56)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r24,lo8(9999)
	ldi r25,hi8(9999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(56)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r24,lo8(1999)
	ldi r25,hi8(1999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(56)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r24,lo8(8)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r24,lo8(1)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r24,lo8(3999)
	ldi r25,hi8(3999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(6)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	ldi r24,lo8(12)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L8
	sts LCD_u8ShadowValid,__zero_reg__
/* epilogue start */
	ret
	.size	LCD_Init, .-LCD_Init
	.section	.text.LCD_Clear,"ax",@progbits
.global	LCD_Clear
	.type	LCD_Clear, @function
LCD_Clear:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(1)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L11
	sts LCD_u8ShadowValid,__zero_reg__
	ret
.L11:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	LCD_Clear, .-LCD_Clear
	.section	.text.LCD_SetCursor,"ax",@progbits
.global	LCD_SetCursor
	.type	LCD_SetCursor, @function
LCD_SetCursor:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(2)
	brsh .L12
	cpi r22,lo8(16)
	brsh .L12
	swap r24
	lsl r24
	lsl r24
	andi r24,lo8(-64)
	or r24,r22
	ori r24,lo8(-128)
	jmp LCD_SendCommand
.L12:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	LCD_SetCursor, .-LCD_SetCursor
	.section	.text.LCD_WriteChar,"ax",@progbits
.global	LCD_WriteChar
	.type	LCD_WriteChar, @function
LCD_WriteChar:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	std Y+1,r24
	call I2C_Start
	cpse r24,__zero_reg__
	rjmp .L18
	ldi r24,lo8(124)
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L18
	ldi r24,lo8(64)
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L18
	ldd r24,Y+1
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L18
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	jmp I2C_Stop
.L18:
	ldi r24,lo8(1)
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	LCD_WriteChar, .-LCD_WriteChar
	.section	.text.LCD_WriteString,"ax",@progbits
.global	LCD_WriteString
	.type	LCD_WriteString, @function
LCD_WriteString:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	sbiw r24,0
	brne .L21
.L24:
	ldi r24,lo8(1)
.L20:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L21:
	movw r28,r24
	movw r16,r24
	subi r16,-17
	sbci r17,-1
.L23:
	ld r24,Y
	cp r24, __zero_reg__
	breq .L20
	adiw r28,1
	cp r28,r16
	cpc r29,r17
	brne .L25
	ldi r24,0
	rjmp .L20
.L25:
	call LCD_WriteChar
	cp r24, __zero_reg__
	breq .L23
	rjmp .L24
	.size	LCD_WriteString, .-LCD_WriteString
	.section	.text.LCD_Paint,"ax",@progbits
.global	LCD_Paint
	.type	LCD_Paint, @function
LCD_Paint:
	push r4
	push r5
	push r6
	push r7
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 18 */
/* stack size = 34 */
.L__stack_usage = 34
	mov r9,r24
	ldi r24,lo8(2)
	cp r9,r24
	brlo .L28
.L30:
	ldi r24,lo8(1)
.L27:
/* epilogue start */
	adiw r28,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	pop r5
	pop r4
	ret
.L28:
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L30
	movw r10,r28
	ldi r30,-1
	sub r10,r30
	sbc r11,r30
	movw r30,r22
	movw r18,r22
	subi r18,-16
	sbci r19,-1
	movw r26,r10
	ldi r25,0
	movw r12,r10
.L32:
	cpse r25,__zero_reg__
	rjmp .L60
	ld r24,Z
	cp r24, __zero_reg__
	breq .L44
.L31:
	st X+,r24
	adiw r30,1
	cp r30,r18
	cpc r31,r19
	brne .L32
	mov r16,r9
	ldi r17,0
	neg r17
	neg r16
	sbc r17,__zero_reg__
	andi r16,lo8(16)
	ldi r17,0
	subi r16,lo8(-(LCD_au8Shadow))
	sbci r17,hi8(-(LCD_au8Shadow))
	ldi r25,lo8(16)
	mov r14,r25
	mov r8,__zero_reg__
	std Y+17,r16
	std Y+18,r17
	clr r5
	bst r9,0
	bld r5,6
	bst r9,1
	bld r5,7
.L40:
	ldi r31,lo8(16)
	cp r8,r31
	breq .L33
	lds r24,LCD_u8ShadowValid
	cp r24, __zero_reg__
	breq .L34
	movw r30,r10
	ld r25,Z
	movw r30,r16
	ld r24,Z
	cp r25,r24
	breq .L33
.L34:
	ldi r31,lo8(16)
	cpse r14,r31
	rjmp .L36
	mov r14,r8
	rjmp .L36
.L44:
	ldi r25,lo8(1)
.L60:
	ldi r24,lo8(32)
	rjmp .L31
.L33:
	ldi r24,lo8(16)
	cpse r14,r24
	rjmp .L37
.L38:
	ldi r24,lo8(16)
	mov r14,r24
.L36:
	inc r8
	ldi r24,-1
	sub r10,r24
	sbc r11,r24
	subi r16,-1
	sbci r17,-1
	ldi r30,lo8(17)
	cpse r8,r30
	rjmp .L40
	ldi r24,lo8(16)
	movw r30,r12
	ldd r26,Y+17
	ldd r27,Y+18
	0:
	ld r0,Z+
	st X+,r0
	dec r24
	brne 0b
	ldi r31,lo8(1)
	cp r9,r31
	breq .L41
.L42:
	ldi r24,0
	rjmp .L27
.L37:
	mov r4,r8
	sub r4,r14
	cp r8,r14
	breq .L38
	mov r24,r5
	or r24,r14
	ori r24,lo8(-128)
	call LCD_SendCommand
	cpse r24,__zero_reg__
	rjmp .L30
	add r14,r12
	mov r15,r13
	adc r15,__zero_reg__
	movw r6,r14
.L39:
	movw r30,r6
	ld r24,Z
	call LCD_WriteChar
	cpse r24,__zero_reg__
	rjmp .L30
	ldi r31,-1
	sub r6,r31
	sbc r7,r31
	mov r24,r6
	sub r24,r14
	cp r24,r4
	brlo .L39
	rjmp .L38
.L41:
	sts LCD_u8ShadowValid,r9
	rjmp .L42
	.size	LCD_Paint, .-LCD_Paint
	.section	.text.LCD_InvalidateShadow,"ax",@progbits
.global	LCD_InvalidateShadow
	.type	LCD_InvalidateShadow, @function
LCD_InvalidateShadow:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts LCD_u8ShadowValid,__zero_reg__
/* epilogue start */
	ret
	.size	LCD_InvalidateShadow, .-LCD_InvalidateShadow
	.section	.text.LCD_DisplayOn,"ax",@progbits
.global	LCD_DisplayOn
	.type	LCD_DisplayOn, @function
LCD_DisplayOn:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r24, __zero_reg__
	breq .L64
	ldi r24,lo8(12)
.L63:
	jmp LCD_SendCommand
.L64:
	ldi r24,lo8(8)
	rjmp .L63
	.size	LCD_DisplayOn, .-LCD_DisplayOn
	.section	.bss.LCD_u8ShadowValid,"aw",@nobits
	.type	LCD_u8ShadowValid, @object
	.size	LCD_u8ShadowValid, 1
LCD_u8ShadowValid:
	.zero	1
	.section	.bss.LCD_au8Shadow,"aw",@nobits
	.type	LCD_au8Shadow, @object
	.size	LCD_au8Shadow, 32
LCD_au8Shadow:
	.zero	32
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
