	.file	"slotleds.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LED_Init,"ax",@progbits
.global	LED_Init
	.type	LED_Init, @function
LED_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call SR_Init
	cpse r24,__zero_reg__
	rjmp .L3
	sts LED_u16Last,__zero_reg__
	sts LED_u16Last+1,__zero_reg__
	sts LED_u8Primed,__zero_reg__
	ret
.L3:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	LED_Init, .-LED_Init
	.section	.text.LED_Update,"ax",@progbits
.global	LED_Update
	.type	LED_Update, @function
LED_Update:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	andi r24,lo8(63)
	ldi r20,0
	ldi r21,0
	movw r18,r20
	movw r28,r18
	ldi r30,lo8(1)
	ldi r31,0
.L7:
	mov r26,r30
	mov r0,r18
	rjmp 2f
	1:
	lsl r26
	2:
	dec r0
	brpl 1b
	and r26,r24
	breq .L5
	movw r26,r30
	mov r0,r20
	rjmp 2f
	1:
	lsl r26
	rol r27
	2:
	dec r0
	brpl 1b
.L20:
	or r28,r26
	or r29,r27
	subi r18,-1
	sbci r19,-1
	subi r20,-2
	sbci r21,-1
	cpi r18,6
	cpc r19,__zero_reg__
	brne .L7
	cpse r22,__zero_reg__
	ori r29,lo8(16)
.L8:
	lds r24,LED_u8Primed
	cp r24, __zero_reg__
	breq .L9
	lds r24,LED_u16Last
	lds r25,LED_u16Last+1
	cp r24,r28
	cpc r25,r29
	breq .L10
.L9:
	movw r24,r28
	call SR_Write
	cpse r24,__zero_reg__
	rjmp .L12
	sts LED_u16Last,r28
	sts LED_u16Last+1,r29
	ldi r24,lo8(1)
	sts LED_u8Primed,r24
.L10:
	ldi r24,0
.L4:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L5:
	movw r26,r20
	inc r26
	movw r16,r30
	rjmp 2f
	1:
	lsl r16
	rol r17
	2:
	dec r26
	brpl 1b
	movw r26,r16
	rjmp .L20
.L12:
	ldi r24,lo8(1)
	rjmp .L4
	.size	LED_Update, .-LED_Update
	.section	.text.LED_TestPattern,"ax",@progbits
.global	LED_TestPattern
	.type	LED_TestPattern, @function
LED_TestPattern:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	mov r22,r24
	ldi r18,0
	ldi r19,0
	movw r24,r18
	ldi r30,lo8(1)
	ldi r31,0
.L24:
	cpi r22,lo8(1)
	brne .L22
	movw r20,r30
	mov r0,r18
	rjmp 2f
	1:
	lsl r20
	rol r21
	2:
	dec r0
	brpl 1b
.L26:
	or r24,r20
	or r25,r21
.L23:
	subi r18,-2
	sbci r19,-1
	cpi r18,12
	cpc r19,__zero_reg__
	brne .L24
	sts LED_u8Primed,__zero_reg__
	jmp SR_Write
.L22:
	cpi r22,lo8(2)
	brne .L23
	movw r20,r18
	inc r20
	movw r26,r30
	rjmp 2f
	1:
	lsl r26
	rol r27
	2:
	dec r20
	brpl 1b
	movw r20,r26
	rjmp .L26
	.size	LED_TestPattern, .-LED_TestPattern
	.section	.bss.LED_u8Primed,"aw",@nobits
	.type	LED_u8Primed, @object
	.size	LED_u8Primed, 1
LED_u8Primed:
	.zero	1
	.section	.bss.LED_u16Last,"aw",@nobits
	.type	LED_u16Last, @object
	.size	LED_u16Last, 2
LED_u16Last:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
