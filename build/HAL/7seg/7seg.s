	.file	"7seg.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SEG_Show,"ax",@progbits
.global	SEG_Show
	.type	SEG_Show, @function
SEG_Show:
	push r14
	push r15
	push r16
	push r17
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 5 */
.L__stack_usage = 5
	mov r28,r24
	cpi r24,lo8(7)
	brlo .L2
	ldi r28,lo8(15)
.L2:
	lds r24,SEG_u8Primed
	cp r24, __zero_reg__
	breq .L3
	lds r24,SEG_u8Shadow
	cpse r24,r28
	rjmp .L3
.L4:
	ldi r24,0
.L1:
/* epilogue start */
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L3:
	ldi r24,lo8(SEG_au8Pins)
	mov r14,r24
	ldi r24,hi8(SEG_au8Pins)
	mov r15,r24
	ldi r16,0
	ldi r17,0
.L7:
	ldi r24,lo8(1)
	mov r0,r16
	rjmp 2f
	1:
	lsl r24
	2:
	dec r0
	brpl 1b
	and r24,r28
	ldi r20,lo8(1)
	cpse r24,__zero_reg__
	rjmp .L5
	ldi r20,0
.L5:
	movw r30,r14
	ld r22,Z
	ldi r24,lo8(1)
	call DIO_WritePin
	cpse r24,__zero_reg__
	rjmp .L10
	ldi r31,-1
	sub r14,r31
	sbc r15,r31
	subi r16,-1
	sbci r17,-1
	cpi r16,4
	cpc r17,__zero_reg__
	brne .L7
	sts SEG_u8Shadow,r28
	ldi r24,lo8(1)
	sts SEG_u8Primed,r24
	rjmp .L4
.L10:
	ldi r24,lo8(1)
	rjmp .L1
	.size	SEG_Show, .-SEG_Show
	.section	.text.SEG_Blank,"ax",@progbits
.global	SEG_Blank
	.type	SEG_Blank, @function
SEG_Blank:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(15)
	jmp SEG_Show
	.size	SEG_Blank, .-SEG_Blank
	.section	.text.SEG_Init,"ax",@progbits
.global	SEG_Init
	.type	SEG_Init, @function
SEG_Init:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	ldi r28,lo8(SEG_au8Pins)
	ldi r29,hi8(SEG_au8Pins)
.L19:
	ldi r20,lo8(1)
	ld r22,Y
	ldi r24,lo8(1)
	call DIO_Init
	cpse r24,__zero_reg__
	rjmp .L18
	adiw r28,1
	ldi r24,hi8(SEG_au8Pins+4)
	cpi r28,lo8(SEG_au8Pins+4)
	cpc r29,r24
	brne .L19
	sts SEG_u8Primed,__zero_reg__
/* epilogue start */
	pop r29
	pop r28
	jmp SEG_Blank
.L18:
	ldi r24,lo8(1)
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	SEG_Init, .-SEG_Init
	.section	.text.SEG_GetShadow,"ax",@progbits
.global	SEG_GetShadow
	.type	SEG_GetShadow, @function
SEG_GetShadow:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,SEG_u8Shadow
/* epilogue start */
	ret
	.size	SEG_GetShadow, .-SEG_GetShadow
	.section	.bss.SEG_u8Primed,"aw",@nobits
	.type	SEG_u8Primed, @object
	.size	SEG_u8Primed, 1
SEG_u8Primed:
	.zero	1
	.section	.data.SEG_u8Shadow,"aw"
	.type	SEG_u8Shadow, @object
	.size	SEG_u8Shadow, 1
SEG_u8Shadow:
	.byte	15
	.section	.rodata.SEG_au8Pins,"a"
	.type	SEG_au8Pins, @object
	.size	SEG_au8Pins, 4
SEG_au8Pins:
	.base64	"AAECAw=="
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
