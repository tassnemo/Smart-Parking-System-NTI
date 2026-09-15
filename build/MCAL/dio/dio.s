	.file	"dio.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.DIO_Init,"ax",@progbits
.global	DIO_Init
	.type	DIO_Init, @function
DIO_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r22,lo8(8)
	brsh .L17
	cpi r24,lo8(2)
	brne .+2
	rjmp .L3
	brsh .L4
	cpse r24,__zero_reg__
	rjmp .L18
	ldi r24,lo8(1)
	rjmp 2f
	1:
	lsl r24
	2:
	dec r22
	brpl 1b
	cpi r20,lo8(1)
	brne .L8
	in r25,0x1a
	or r24,r25
	out 0x1a,r24
.L9:
	ldi r24,0
	ret
.L4:
	cpi r24,lo8(3)
	brne .+2
	rjmp .L7
.L17:
	ldi r24,lo8(1)
/* epilogue start */
	ret
.L8:
	mov r18,r24
	com r18
	cpi r20,lo8(2)
	brne .L10
	in r25,0x1a
	and r25,r18
	out 0x1a,r25
	in r25,0x1b
	or r24,r25
.L19:
	out 0x1b,r24
	rjmp .L9
.L10:
	in r24,0x1a
	and r24,r18
	out 0x1a,r24
	in r24,0x1b
	and r24,r18
	rjmp .L19
.L18:
	ldi r24,lo8(1)
	rjmp 2f
	1:
	lsl r24
	2:
	dec r22
	brpl 1b
	cpi r20,lo8(1)
	brne .L11
	in r25,0x17
	or r24,r25
	out 0x17,r24
	rjmp .L9
.L11:
	mov r18,r24
	com r18
	cpi r20,lo8(2)
	brne .L12
	in r25,0x17
	and r25,r18
	out 0x17,r25
	in r25,0x18
	or r24,r25
.L21:
	out 0x18,r24
	rjmp .L9
.L12:
	in r24,0x17
	and r24,r18
	out 0x17,r24
	in r24,0x18
	and r24,r18
	rjmp .L21
.L3:
	ldi r24,lo8(1)
	rjmp 2f
	1:
	lsl r24
	2:
	dec r22
	brpl 1b
	cpi r20,lo8(1)
	brne .L13
	in r25,0x14
	or r24,r25
	out 0x14,r24
	rjmp .L9
.L13:
	mov r18,r24
	com r18
	cpi r20,lo8(2)
	brne .L14
	in r25,0x14
	and r25,r18
	out 0x14,r25
	in r25,0x15
	or r24,r25
.L20:
	out 0x15,r24
	rjmp .L9
.L14:
	in r24,0x14
	and r24,r18
	out 0x14,r24
	in r24,0x15
	and r24,r18
	rjmp .L20
.L7:
	ldi r24,lo8(1)
	ldi r25,0
	movw r18,r24
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	cpi r20,lo8(1)
	brne .L15
	in r24,0x11
	or r24,r18
	out 0x11,r24
	rjmp .L9
.L15:
	mov r25,r18
	com r25
	in r24,0x11
	and r24,r25
	out 0x11,r24
	in r24,0x12
	cpi r20,lo8(2)
	brne .L16
	or r24,r18
.L22:
	out 0x12,r24
	rjmp .L9
.L16:
	and r24,r25
	rjmp .L22
	.size	DIO_Init, .-DIO_Init
	.section	.text.DIO_WritePin,"ax",@progbits
.global	DIO_WritePin
	.type	DIO_WritePin, @function
DIO_WritePin:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r22,lo8(8)
	brsh .L35
	cpi r24,lo8(2)
	breq .L25
	brsh .L26
	cpse r24,__zero_reg__
	rjmp .L36
	ldi r24,lo8(1)
	ldi r25,0
	movw r18,r24
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	mov r22,r18
	in r24,0x1b
	cpi r20,lo8(1)
	brne .L30
	or r24,r18
	out 0x1b,r24
.L31:
	ldi r24,0
	ret
.L26:
	cpi r24,lo8(3)
	breq .L29
.L35:
	ldi r24,lo8(1)
/* epilogue start */
	ret
.L30:
	com r22
	and r22,r24
	out 0x1b,r22
	rjmp .L31
.L36:
	ldi r24,lo8(1)
	ldi r25,0
	movw r18,r24
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	mov r22,r18
	in r24,0x18
	cpi r20,lo8(1)
	brne .L32
	or r24,r18
	out 0x18,r24
	rjmp .L31
.L32:
	com r22
	and r22,r24
	out 0x18,r22
	rjmp .L31
.L25:
	ldi r24,lo8(1)
	ldi r25,0
	movw r18,r24
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	mov r22,r18
	in r24,0x15
	cpi r20,lo8(1)
	brne .L33
	or r24,r18
	out 0x15,r24
	rjmp .L31
.L33:
	com r22
	and r22,r24
	out 0x15,r22
	rjmp .L31
.L29:
	ldi r24,lo8(1)
	ldi r25,0
	movw r18,r24
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	mov r22,r18
	in r24,0x12
	cpi r20,lo8(1)
	brne .L34
	or r24,r18
	out 0x12,r24
	rjmp .L31
.L34:
	com r22
	and r22,r24
	out 0x12,r22
	rjmp .L31
	.size	DIO_WritePin, .-DIO_WritePin
	.section	.text.DIO_ReadPin,"ax",@progbits
.global	DIO_ReadPin
	.type	DIO_ReadPin, @function
DIO_ReadPin:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r20
	sbiw r30,0
	breq .L46
	cpi r22,lo8(8)
	brsh .L46
	cpi r24,lo8(2)
	breq .L39
	brsh .L40
	cpse r24,__zero_reg__
	rjmp .L47
	in r24,0x19
.L48:
	ldi r25,0
	rjmp 2f
	1:
	asr r25
	ror r24
	2:
	dec r22
	brpl 1b
	andi r24,lo8(1)
	st Z,r24
	ldi r24,0
	ret
.L40:
	cpi r24,lo8(3)
	breq .L43
.L46:
	ldi r24,lo8(1)
/* epilogue start */
	ret
.L47:
	in r24,0x16
	rjmp .L48
.L39:
	in r24,0x13
	rjmp .L48
.L43:
	in r24,0x10
	rjmp .L48
	.size	DIO_ReadPin, .-DIO_ReadPin
	.section	.text.DIO_WritePort,"ax",@progbits
.global	DIO_WritePort
	.type	DIO_WritePort, @function
DIO_WritePort:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(2)
	breq .L50
	brsh .L51
	cpse r24,__zero_reg__
	rjmp .L57
	out 0x1b,r22
.L56:
	ldi r24,0
/* epilogue start */
	ret
.L51:
	cpi r24,lo8(3)
	breq .L54
	ldi r24,lo8(1)
	ret
.L57:
	out 0x18,r22
	rjmp .L56
.L50:
	out 0x15,r22
	rjmp .L56
.L54:
	out 0x12,r22
	rjmp .L56
	.size	DIO_WritePort, .-DIO_WritePort
	.section	.text.DIO_ReadPort,"ax",@progbits
.global	DIO_ReadPort
	.type	DIO_ReadPort, @function
DIO_ReadPort:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r22
	sbiw r30,0
	breq .L66
	cpi r24,lo8(2)
	breq .L60
	brsh .L61
	cpse r24,__zero_reg__
	rjmp .L67
	in r24,0x19
.L68:
	st Z,r24
	ldi r24,0
	ret
.L61:
	cpi r24,lo8(3)
	breq .L64
.L66:
	ldi r24,lo8(1)
/* epilogue start */
	ret
.L67:
	in r24,0x16
	rjmp .L68
.L60:
	in r24,0x13
	rjmp .L68
.L64:
	in r24,0x10
	rjmp .L68
	.size	DIO_ReadPort, .-DIO_ReadPort
	.section	.text.DIO_TogglePin,"ax",@progbits
.global	DIO_TogglePin
	.type	DIO_TogglePin, @function
DIO_TogglePin:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r22,lo8(8)
	brsh .L77
	cpi r24,lo8(2)
	breq .L71
	brsh .L72
	cpse r24,__zero_reg__
	rjmp .L78
	in r24,0x1b
	ldi r18,lo8(1)
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	eor r24,r18
	out 0x1b,r24
.L76:
	ldi r24,0
	ret
.L72:
	cpi r24,lo8(3)
	breq .L75
.L77:
	ldi r24,lo8(1)
/* epilogue start */
	ret
.L78:
	in r24,0x18
	ldi r18,lo8(1)
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	eor r24,r18
	out 0x18,r24
	rjmp .L76
.L71:
	in r24,0x15
	ldi r18,lo8(1)
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	eor r24,r18
	out 0x15,r24
	rjmp .L76
.L75:
	in r24,0x12
	ldi r18,lo8(1)
	rjmp 2f
	1:
	lsl r18
	2:
	dec r22
	brpl 1b
	eor r24,r18
	out 0x12,r24
	rjmp .L76
	.size	DIO_TogglePin, .-DIO_TogglePin
	.ident	"GCC: (GNU) 15.2.0"
