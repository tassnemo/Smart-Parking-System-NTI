	.file	"slots.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SLOT_Init,"ax",@progbits
.global	SLOT_Init
	.type	SLOT_Init, @function
SLOT_Init:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	ldi r28,lo8(2)
.L3:
	ldi r20,lo8(2)
	mov r22,r28
	ldi r24,lo8(2)
	call DIO_Init
	cpse r24,__zero_reg__
	rjmp .L4
	subi r28,lo8(-(1))
	cpi r28,lo8(8)
	brne .L3
	sts SLOT_u8PublishedMap,__zero_reg__
	sts SLOT_u8Candidate,__zero_reg__
	sts SLOT_u8SampleCount,__zero_reg__
.L1:
/* epilogue start */
	pop r28
	ret
.L4:
	ldi r24,lo8(1)
	rjmp .L1
	.size	SLOT_Init, .-SLOT_Init
	.section	.text.SLOT_Poll,"ax",@progbits
.global	SLOT_Poll
	.type	SLOT_Poll, @function
SLOT_Poll:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	std Y+1,__zero_reg__
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,lo8(2)
	call DIO_ReadPort
	cpse r24,__zero_reg__
	rjmp .L12
	ldd r25,Y+1
	com r25
	lsr r25
	lsr r25
	lds r18,SLOT_u8Candidate
	cp r18,r25
	breq .L8
	sts SLOT_u8Candidate,r25
	ldi r25,lo8(1)
	sts SLOT_u8SampleCount,r25
.L6:
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L8:
	lds r25,SLOT_u8SampleCount
	cpi r25,lo8(5)
	brsh .L6
	subi r25,lo8(-(1))
	sts SLOT_u8SampleCount,r25
	cpi r25,lo8(5)
	brne .L6
	sts SLOT_u8PublishedMap,r18
	rjmp .L6
.L12:
	ldi r24,lo8(1)
	rjmp .L6
	.size	SLOT_Poll, .-SLOT_Poll
	.section	.text.SLOT_GetMap,"ax",@progbits
.global	SLOT_GetMap
	.type	SLOT_GetMap, @function
SLOT_GetMap:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,SLOT_u8PublishedMap
/* epilogue start */
	ret
	.size	SLOT_GetMap, .-SLOT_GetMap
	.section	.text.SLOT_CountFree,"ax",@progbits
.global	SLOT_CountFree
	.type	SLOT_CountFree, @function
SLOT_CountFree:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r25,SLOT_u8PublishedMap
	andi r25,lo8(63)
	mov r24,r25
	lsr r24
	andi r24,lo8(85)
	sub r25,r24
	mov r24,r25
	andi r24,lo8(51)
	lsr r25
	lsr r25
	andi r25,lo8(51)
	add r25,r24
	mov r24,r25
	swap r24
	andi r24,lo8(15)
	add r24,r25
	andi r24,lo8(15)
	ldi r25,lo8(6)
	sub r25,r24
	mov r24,r25
/* epilogue start */
	ret
	.size	SLOT_CountFree, .-SLOT_CountFree
	.section	.bss.SLOT_u8SampleCount,"aw",@nobits
	.type	SLOT_u8SampleCount, @object
	.size	SLOT_u8SampleCount, 1
SLOT_u8SampleCount:
	.zero	1
	.section	.bss.SLOT_u8Candidate,"aw",@nobits
	.type	SLOT_u8Candidate, @object
	.size	SLOT_u8Candidate, 1
SLOT_u8Candidate:
	.zero	1
	.section	.bss.SLOT_u8PublishedMap,"aw",@nobits
	.type	SLOT_u8PublishedMap, @object
	.size	SLOT_u8PublishedMap, 1
SLOT_u8PublishedMap:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
