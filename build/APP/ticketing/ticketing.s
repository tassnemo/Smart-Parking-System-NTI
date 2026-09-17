	.file	"ticketing.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TKT_Init,"ax",@progbits
.global	TKT_Init
	.type	TKT_Init, @function
TKT_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(g_atTickets)
	ldi r31,hi8(g_atTickets)
.L2:
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+2,__zero_reg__
	std Z+3,__zero_reg__
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
	adiw r30,8
	ldi r24,hi8(g_atTickets+48)
	cpi r30,lo8(g_atTickets+48)
	cpc r31,r24
	brne .L2
	ldi r24,lo8(1)
	sts g_u16NextId,r24
	sts g_u16NextId+1,__zero_reg__
	sts g_u16TotalEntries,__zero_reg__
	sts g_u16TotalEntries+1,__zero_reg__
/* epilogue start */
	ret
	.size	TKT_Init, .-TKT_Init
	.section	.rodata.TKT_OnEntryAuthorized.str1.1,"aMS",@progbits,1
.LC0:
	.string	"=== PARKING TICKET ===\r\n"
.LC1:
	.string	"ID    : "
.LC2:
	.string	"\r\nTIME  : "
.LC3:
	.string	"\r\nSLOT  : suggest "
.LC4:
	.string	"\r\nFREE  : "
.LC5:
	.string	"\r\n======================\r\n"
	.section	.text.TKT_OnEntryAuthorized,"ax",@progbits
.global	TKT_OnEntryAuthorized
	.type	TKT_OnEntryAuthorized, @function
TKT_OnEntryAuthorized:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,17
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 17 */
/* stack size = 23 */
.L__stack_usage = 23
	ldi r30,lo8(g_atTickets)
	ldi r31,hi8(g_atTickets)
	ldi r16,0
.L6:
	ldd r15,Z+7
	cp r15, __zero_reg__
	brne .+2
	rjmp .L5
	subi r16,lo8(-(1))
	adiw r30,8
	cpi r16,lo8(6)
	brne .L6
.L4:
/* epilogue start */
	adiw r28,17
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
	ret
.L14:
	subi r18,-1
	sbci r19,-1
.L8:
	cpi r18,6
	cpc r19,__zero_reg__
	breq .L9
	mov r20,r22
	mov r0,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r0
	brpl 1b
	and r20,r24
	brne .L14
.L13:
	clr r15
	inc r15
	add r15,r18
.L9:
	movw r30,r16
	subi r30,lo8(-(g_atTickets))
	sbci r31,hi8(-(g_atTickets))
	std Z+6,r15
	ldi r24,lo8(1)
	std Z+7,r24
	lds r24,g_u16NextId
	lds r25,g_u16NextId+1
	cpi r24,15
	ldi r18,39
	cpc r25,r18
	brlo .+2
	rjmp .L15
	adiw r24,1
.L11:
	sts g_u16NextId,r24
	sts g_u16NextId+1,r25
	lds r24,g_u16TotalEntries
	lds r25,g_u16TotalEntries+1
	adiw r24,1
	sts g_u16TotalEntries,r24
	sts g_u16TotalEntries+1,r25
	call LOT_GetFree
	std Y+16,r24
	movw r24,r16
	subi r24,lo8(-(g_atTickets))
	sbci r25,hi8(-(g_atTickets))
	movw r14,r24
	movw r26,r24
	ld r30,X+
	ld r31,X+
	movw r24,r30
	ldi r22,lo8(-24)
	ldi r23,lo8(3)
	call __udivmodhi4
	movw r24,r22
	ldi r18,lo8(10)
	ldi r19,0
	movw r22,r18
	call __udivmodhi4
	subi r24,lo8(-(48))
	std Y+11,r24
	movw r24,r30
	ldi r22,lo8(100)
	ldi r23,0
	call __udivmodhi4
	movw r24,r22
	movw r22,r18
	call __udivmodhi4
	subi r24,lo8(-(48))
	std Y+12,r24
	movw r24,r30
	movw r22,r18
	call __udivmodhi4
	mov r20,r24
	movw r24,r22
	movw r22,r18
	call __udivmodhi4
	subi r24,lo8(-(48))
	std Y+13,r24
	subi r20,lo8(-(48))
	std Y+14,r20
	std Y+15,__zero_reg__
	movw r30,r14
	ldd r22,Z+2
	ldd r23,Z+3
	ldd r24,Z+4
	ldd r25,Z+5
	movw r14,r28
	ldi r31,-1
	sub r14,r31
	sbc r15,r31
	movw r20,r14
	call RTC_Format
	cp r24, __zero_reg__
	breq .L12
	ldi r24,lo8(45)
	std Y+1,r24
	std Y+2,r24
	std Y+3,r24
	ldi r25,lo8(58)
	std Y+4,r25
	std Y+5,r24
	std Y+6,r24
	std Y+7,r25
	std Y+8,r24
	std Y+9,r24
	std Y+10,__zero_reg__
.L12:
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call USART_SendString
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call USART_SendString
	movw r24,r28
	adiw r24,11
	call USART_SendString
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
	movw r24,r14
	call USART_SendString
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	call USART_SendString
	movw r30,r16
	subi r30,lo8(-(g_atTickets))
	sbci r31,hi8(-(g_atTickets))
	ldd r24,Z+6
	subi r24,lo8(-(48))
	call USART_SendByte
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	call USART_SendString
	ldd r24,Y+16
	subi r24,lo8(-(48))
	call USART_SendByte
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	call USART_SendString
	rjmp .L4
.L15:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L11
.L5:
	ldi r18,lo8(8)
	mul r16,r18
	movw r16,r0
	clr __zero_reg__
	movw r24,r16
	subi r24,lo8(-(g_atTickets))
	sbci r25,hi8(-(g_atTickets))
	std Y+16,r24
	std Y+17,r25
	lds r24,g_u16NextId
	lds r25,g_u16NextId+1
	ldd r26,Y+16
	ldd r27,Y+17
	st X+,r24
	st X+,r25
	call RTC_Seconds
	ldd r30,Y+16
	ldd r31,Y+17
	std Z+2,r22
	std Z+3,r23
	std Z+4,r24
	std Z+5,r25
	call SLOT_GetMap
	mov r18,r24
	andi r18,1<<0
	sbrs r24,0
	rjmp .L13
	ldi r18,lo8(1)
	ldi r19,0
	movw r22,r18
	rjmp .L8
	.size	TKT_OnEntryAuthorized, .-TKT_OnEntryAuthorized
	.section	.text.TKT_CloseOldest,"ax",@progbits
.global	TKT_CloseOldest
	.type	TKT_CloseOldest, @function
TKT_CloseOldest:
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 10 */
.L__stack_usage = 10
	movw r18,r24
	or r24,r25
	brne .+2
	rjmp .L30
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L30
	ldi r26,lo8(g_atTickets)
	ldi r27,hi8(g_atTickets)
	ldi r24,lo8(-1)
	mov r15,r24
	mov r14,r15
	movw r12,r14
	ldi r30,lo8(6)
	ldi r25,0
.L26:
	adiw r26,7
	ld r24,X
	sbiw r26,7
	cp r24, __zero_reg__
	breq .L25
	adiw r26,2
	ld r8,X+
	ld r9,X+
	ld r10,X+
	ld r11,X+
	sbiw r26,6
	cp r8,r12
	cpc r9,r13
	cpc r10,r14
	cpc r11,r15
	brsh .L25
	movw r12,r8
	movw r14,r10
	mov r30,r25
.L25:
	subi r25,lo8(-(1))
	adiw r26,8
	cpi r25,lo8(6)
	brne .L26
	cpi r30,lo8(6)
	brsh .L30
	ldi r24,lo8(8)
	mul r30,r24
	movw r30,r0
	clr __zero_reg__
	subi r30,lo8(-(g_atTickets))
	sbci r31,hi8(-(g_atTickets))
	ld r24,Z
	ldd r25,Z+1
	movw r26,r18
	st X+,r24
	st X+,r25
	ldd r24,Z+2
	ldd r25,Z+3
	ldd r26,Z+4
	ldd r27,Z+5
	movw r28,r22
	st Y,r24
	std Y+1,r25
	std Y+2,r26
	std Y+3,r27
	std Z+7,__zero_reg__
	ldi r24,0
.L23:
/* epilogue start */
	pop r29
	pop r28
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	ret
.L30:
	ldi r24,lo8(1)
	rjmp .L23
	.size	TKT_CloseOldest, .-TKT_CloseOldest
	.section	.text.TKT_Find,"ax",@progbits
.global	TKT_Find
	.type	TKT_Find, @function
TKT_Find:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(g_atTickets)
	ldi r31,hi8(g_atTickets)
	ldi r18,0
	ldi r19,0
.L38:
	ldd r20,Z+7
	cp r20, __zero_reg__
	breq .L36
	ld r20,Z
	ldd r21,Z+1
	cp r20,r24
	cpc r21,r25
	brne .L36
	movw r24,r18
	ldi r18,3
	1:
	lsl r24
	rol r25
	dec r18
	brne 1b
	subi r24,lo8(-(g_atTickets))
	sbci r25,hi8(-(g_atTickets))
	ret
.L36:
	subi r18,-1
	sbci r19,-1
	adiw r30,8
	cpi r18,6
	cpc r19,__zero_reg__
	brne .L38
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	TKT_Find, .-TKT_Find
	.section	.text.TKT_GetOpenCount,"ax",@progbits
.global	TKT_GetOpenCount
	.type	TKT_GetOpenCount, @function
TKT_GetOpenCount:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(g_atTickets)
	ldi r31,hi8(g_atTickets)
	ldi r24,0
.L45:
	ldd r25,Z+7
	cpse r25,__zero_reg__
	subi r24,lo8(-(1))
.L44:
	adiw r30,8
	ldi r25,hi8(g_atTickets+48)
	cpi r30,lo8(g_atTickets+48)
	cpc r31,r25
	brne .L45
/* epilogue start */
	ret
	.size	TKT_GetOpenCount, .-TKT_GetOpenCount
	.section	.text.TKT_GetNextId,"ax",@progbits
.global	TKT_GetNextId
	.type	TKT_GetNextId, @function
TKT_GetNextId:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u16NextId
	lds r25,g_u16NextId+1
/* epilogue start */
	ret
	.size	TKT_GetNextId, .-TKT_GetNextId
	.section	.text.TKT_GetTotalEntries,"ax",@progbits
.global	TKT_GetTotalEntries
	.type	TKT_GetTotalEntries, @function
TKT_GetTotalEntries:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u16TotalEntries
	lds r25,g_u16TotalEntries+1
/* epilogue start */
	ret
	.size	TKT_GetTotalEntries, .-TKT_GetTotalEntries
	.section	.bss.g_u16TotalEntries,"aw",@nobits
	.type	g_u16TotalEntries, @object
	.size	g_u16TotalEntries, 2
g_u16TotalEntries:
	.zero	2
	.section	.bss.g_u16NextId,"aw",@nobits
	.type	g_u16NextId, @object
	.size	g_u16NextId, 2
g_u16NextId:
	.zero	2
	.section	.bss.g_atTickets,"aw",@nobits
	.type	g_atTickets, @object
	.size	g_atTickets, 48
g_atTickets:
	.zero	48
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
