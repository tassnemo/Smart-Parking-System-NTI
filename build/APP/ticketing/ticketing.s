	.file	"ticketing.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TKT_AppendUint32,"ax",@progbits
	.type	TKT_AppendUint32, @function
TKT_AppendUint32:
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
	sbiw r28,10
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 10 */
/* stack size = 23 */
.L__stack_usage = 23
	movw r10,r24
	movw r16,r22
	movw r12,r18
	movw r14,r20
	cp r12,__zero_reg__
	cpc r13,__zero_reg__
	cpc r14,__zero_reg__
	cpc r15,__zero_reg__
	brne .L6
	movw r26,r22
	ld r24,X
	movw r30,r10
	add r30,r24
	adc r31,__zero_reg__
	ldi r24,lo8(48)
	st Z,r24
	ld r24,X
	subi r24,lo8(-(1))
	st X,r24
.L1:
/* epilogue start */
	adiw r28,10
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
	ret
.L6:
	mov r7,__zero_reg__
	movw r8,r28
	ldi r27,-1
	sub r8,r27
	sbc r9,r27
.L2:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(10)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r30,r8
	add r30,r7
	adc r31,__zero_reg__
	subi r22,lo8(-(48))
	st Z,r22
	inc r7
	movw r24,r12
	movw r26,r14
	movw r12,r18
	movw r14,r20
	sbiw r24,10
	cpc r26,__zero_reg__
	cpc r27,__zero_reg__
	brsh .L2
	movw r30,r8
	add r30,r7
	adc r31,__zero_reg__
.L4:
	cp r8,r30
	cpc r9,r31
	breq .L1
	movw r26,r16
	ld r24,X
	movw r26,r10
	add r26,r24
	adc r27,__zero_reg__
	ld r24,-Z
	st X,r24
	movw r26,r16
	ld r24,X
	subi r24,lo8(-(1))
	st X,r24
	rjmp .L4
	.size	TKT_AppendUint32, .-TKT_AppendUint32
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
.L9:
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
	brne .L9
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
.L13:
	ldd r15,Z+7
	cp r15, __zero_reg__
	brne .+2
	rjmp .L12
	subi r16,lo8(-(1))
	adiw r30,8
	cpi r16,lo8(6)
	brne .L13
.L11:
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
.L21:
	subi r18,-1
	sbci r19,-1
.L15:
	cpi r18,6
	cpc r19,__zero_reg__
	breq .L16
	mov r20,r22
	mov r0,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r0
	brpl 1b
	and r20,r24
	brne .L21
.L20:
	clr r15
	inc r15
	add r15,r18
.L16:
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
	rjmp .L22
	adiw r24,1
.L18:
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
	breq .L19
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
.L19:
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
	rjmp .L11
.L22:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L18
.L12:
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
	rjmp .L20
	ldi r18,lo8(1)
	ldi r19,0
	movw r22,r18
	rjmp .L15
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
	rjmp .L37
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L37
	ldi r26,lo8(g_atTickets)
	ldi r27,hi8(g_atTickets)
	ldi r24,lo8(-1)
	mov r15,r24
	mov r14,r15
	movw r12,r14
	ldi r30,lo8(6)
	ldi r25,0
.L33:
	adiw r26,7
	ld r24,X
	sbiw r26,7
	cp r24, __zero_reg__
	breq .L32
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
	brsh .L32
	movw r12,r8
	movw r14,r10
	mov r30,r25
.L32:
	subi r25,lo8(-(1))
	adiw r26,8
	cpi r25,lo8(6)
	brne .L33
	cpi r30,lo8(6)
	brsh .L37
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
.L30:
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
.L37:
	ldi r24,lo8(1)
	rjmp .L30
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
.L45:
	ldd r20,Z+7
	cp r20, __zero_reg__
	breq .L43
	ld r20,Z
	ldd r21,Z+1
	cp r20,r24
	cpc r21,r25
	brne .L43
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
.L43:
	subi r18,-1
	sbci r19,-1
	adiw r30,8
	cpi r18,6
	cpc r19,__zero_reg__
	brne .L45
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
.L52:
	ldd r25,Z+7
	cpse r25,__zero_reg__
	subi r24,lo8(-(1))
.L51:
	adiw r30,8
	ldi r25,hi8(g_atTickets+48)
	cpi r30,lo8(g_atTickets+48)
	cpc r31,r25
	brne .L52
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
	.section	.text.TKT_PrintOpenTickets,"ax",@progbits
.global	TKT_PrintOpenTickets
	.type	TKT_PrintOpenTickets, @function
TKT_PrintOpenTickets:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,25
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 25 */
/* stack size = 31 */
.L__stack_usage = 31
	ldi r16,lo8(g_atTickets)
	ldi r17,hi8(g_atTickets)
	ldi r25,lo8(84)
	mov r14,r25
	ldi r25,lo8(44)
	mov r15,r25
.L61:
	movw r30,r16
	ldd r24,Z+7
	cp r24, __zero_reg__
	brne .+2
	rjmp .L60
	std Y+1,r14
	ldi r31,lo8(75)
	std Y+2,r31
	std Y+3,r14
	ldi r24,lo8(4)
	std Y+25,r24
	std Y+4,r15
	movw r30,r16
	ld r18,Z
	ldd r19,Z+1
	ldi r20,0
	ldi r21,0
	movw r22,r28
	subi r22,-25
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call TKT_AppendUint32
	ldd r24,Y+25
	ldi r25,lo8(1)
	add r25,r24
	std Y+25,r25
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,r15
	movw r30,r16
	ldd r18,Z+2
	ldd r19,Z+3
	ldd r20,Z+4
	ldd r21,Z+5
	movw r22,r28
	subi r22,-25
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call TKT_AppendUint32
	ldd r24,Y+25
	ldi r25,lo8(1)
	add r25,r24
	std Y+25,r25
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,r15
	movw r30,r16
	ldd r18,Z+6
	ldi r19,0
	ldi r20,0
	ldi r21,0
	movw r22,r28
	subi r22,-25
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call TKT_AppendUint32
	ldd r24,Y+25
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	ldi r25,lo8(13)
	st Z,r25
	ldi r25,lo8(1)
	add r25,r24
	movw r30,r28
	adiw r30,1
	add r30,r25
	adc r31,__zero_reg__
	ldi r25,lo8(10)
	st Z,r25
	subi r24,lo8(-(2))
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,__zero_reg__
	movw r24,r28
	adiw r24,1
	call USART_SendString
.L60:
	subi r16,-8
	sbci r17,-1
	ldi r30,hi8(g_atTickets+48)
	cpi r16,lo8(g_atTickets+48)
	cpc r17,r30
	breq .+2
	rjmp .L61
/* epilogue start */
	adiw r28,25
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
	.size	TKT_PrintOpenTickets, .-TKT_PrintOpenTickets
	.section	.text.TKT_ClearStats,"ax",@progbits
.global	TKT_ClearStats
	.type	TKT_ClearStats, @function
TKT_ClearStats:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_u16TotalEntries,__zero_reg__
	sts g_u16TotalEntries+1,__zero_reg__
/* epilogue start */
	ret
	.size	TKT_ClearStats, .-TKT_ClearStats
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
