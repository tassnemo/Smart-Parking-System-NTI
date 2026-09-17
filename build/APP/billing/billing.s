	.file	"billing.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BIL_FormatUint16,"ax",@progbits
	.type	BIL_FormatUint16, @function
BIL_FormatUint16:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	rcall .
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 6 */
/* stack size = 12 */
.L__stack_usage = 12
	movw r30,r24
	movw r16,r22
	movw r14,r28
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
	sbiw r30,0
	brne .L6
	ldi r24,lo8(48)
	std Y+1,r24
	ldi r18,lo8(1)
.L3:
	mov r24,r18
	ldi r25,0
	movw r30,r14
	add r30,r18
	adc r31,__zero_reg__
	movw r26,r16
.L4:
	cp r14,r30
	cpc r15,r31
	brne .L5
	add r16,r24
	adc r17,r25
	movw r30,r16
	st Z,__zero_reg__
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L6:
	ldi r18,0
.L2:
	movw r24,r30
	ldi r22,lo8(10)
	ldi r23,0
	call __udivmodhi4
	movw r26,r14
	add r26,r18
	adc r27,__zero_reg__
	subi r24,lo8(-(48))
	st X,r24
	subi r18,lo8(-(1))
	movw r24,r30
	movw r30,r22
	sbiw r24,10
	brsh .L2
	rjmp .L3
.L5:
	ld r18,-Z
	st X+,r18
	rjmp .L4
	.size	BIL_FormatUint16, .-BIL_FormatUint16
	.section	.rodata.BIL_OnExitAuthorized.str1.1,"aMS",@progbits,1
.LC0:
	.string	"===== RECEIPT =====\r\n"
.LC1:
	.string	"ID    : "
.LC2:
	.string	"\r\nIN    : "
.LC3:
	.string	"\r\nOUT   : "
.LC4:
	.string	"\r\nDWELL : "
.LC5:
	.string	" min"
.LC6:
	.string	"\r\nGRACE : "
.LC7:
	.string	"\r\nHOURS : "
.LC8:
	.string	"\r\nFEE   : "
.LC9:
	.string	"\r\n===================\r\n"
	.section	.text.BIL_OnExitAuthorized,"ax",@progbits
.global	BIL_OnExitAuthorized
	.type	BIL_OnExitAuthorized, @function
BIL_OnExitAuthorized:
	push r4
	push r5
	push r6
	push r7
	push r8
	push r9
	push r10
	push r11
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,41
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 41 */
/* stack size = 55 */
.L__stack_usage = 55
	movw r22,r28
	subi r22,-32
	sbci r23,-1
	movw r24,r28
	adiw r24,36
	call TKT_CloseOldest
	cpse r24,__zero_reg__
	rjmp .L8
	call RTC_Seconds
	movw r8,r22
	movw r10,r24
	ldd r4,Y+32
	ldd r5,Y+33
	ldd r6,Y+34
	ldd r7,Y+35
	ldi r16,0
	ldi r17,0
	movw r18,r16
	cp r8,r4
	cpc r9,r5
	cpc r10,r6
	cpc r11,r7
	brlo .L10
	sub r22,r4
	sbc r23,r5
	sbc r24,r6
	sbc r25,r7
	ldi r18,lo8(60)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r16,r18
	cpi r18,15
	cpc r19,__zero_reg__
	brsh .L11
	ldi r18,lo8(15)
	ldi r19,0
.L11:
	subi r18,15
	sbc r19,__zero_reg__
.L10:
	movw r24,r18
	adiw r24,59
	ldi r22,lo8(60)
	ldi r23,0
	call __udivmodhi4
	std Y+38,r22
	std Y+39,r23
	movw r18,r22
	ldi r26,lo8(10)
	ldi r27,0
	call __umulhisi3
	cpi r22,121
	cpc r23,__zero_reg__
	cpc r24,__zero_reg__
	cpc r25,__zero_reg__
	brlo .L12
	ldi r22,lo8(120)
	ldi r23,0
	ldi r24,0
	ldi r25,0
.L12:
	std Y+40,r22
	std Y+41,r23
	lds r18,g_u16TotalRevenue
	lds r19,g_u16TotalRevenue+1
	movw r26,r24
	movw r24,r22
	add r24,r18
	adc r25,r19
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sbiw r26,0
	breq .L13
	ldi r24,lo8(-1)
	ldi r25,lo8(-1)
.L13:
	sts g_u16TotalRevenue,r24
	sts g_u16TotalRevenue+1,r25
	lds r24,g_u16TotalExits
	lds r25,g_u16TotalExits+1
	adiw r24,1
	sts g_u16TotalExits,r24
	sts g_u16TotalExits+1,r25
	ldd r30,Y+36
	ldd r31,Y+37
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
	std Y+27,r24
	movw r24,r30
	ldi r22,lo8(100)
	ldi r23,0
	call __udivmodhi4
	movw r24,r22
	movw r22,r18
	call __udivmodhi4
	subi r24,lo8(-(48))
	std Y+28,r24
	movw r24,r30
	movw r22,r18
	call __udivmodhi4
	mov r20,r24
	movw r24,r22
	movw r22,r18
	call __udivmodhi4
	subi r24,lo8(-(48))
	std Y+29,r24
	subi r20,lo8(-(48))
	std Y+30,r20
	std Y+31,__zero_reg__
	movw r14,r28
	ldi r24,11
	add r14,r24
	adc r15,__zero_reg__
	movw r20,r14
	movw r22,r4
	movw r24,r6
	call RTC_Format
	mov r7,r14
	mov r6,r15
	cpse r24,__zero_reg__
	std Y+11,__zero_reg__
.L14:
	ldi r18,lo8(10)
	movw r14,r28
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
	movw r20,r14
	movw r22,r8
	movw r24,r10
	call RTC_Format
	cpse r24,__zero_reg__
	std Y+1,__zero_reg__
.L15:
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call USART_SendString
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call USART_SendString
	movw r24,r28
	adiw r24,27
	call USART_SendString
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
	mov r24,r7
	mov r25,r6
	call USART_SendString
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	call USART_SendString
	movw r24,r14
	call USART_SendString
	movw r22,r28
	subi r22,-21
	sbci r23,-1
	movw r24,r16
	call BIL_FormatUint16
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	call USART_SendString
	movw r24,r28
	adiw r24,21
	call USART_SendString
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	call USART_SendString
	movw r22,r28
	subi r22,-21
	sbci r23,-1
	ldi r24,lo8(15)
	ldi r25,0
	call BIL_FormatUint16
	ldi r24,lo8(.LC6)
	ldi r25,hi8(.LC6)
	call USART_SendString
	movw r24,r28
	adiw r24,21
	call USART_SendString
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	call USART_SendString
	movw r22,r28
	subi r22,-21
	sbci r23,-1
	ldd r24,Y+38
	ldd r25,Y+39
	call BIL_FormatUint16
	ldi r24,lo8(.LC7)
	ldi r25,hi8(.LC7)
	call USART_SendString
	movw r24,r28
	adiw r24,21
	call USART_SendString
	movw r22,r28
	subi r22,-21
	sbci r23,-1
	ldd r24,Y+40
	ldd r25,Y+41
	call BIL_FormatUint16
	ldi r24,lo8(.LC8)
	ldi r25,hi8(.LC8)
	call USART_SendString
	movw r24,r28
	adiw r24,21
	call USART_SendString
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	call USART_SendString
.L8:
/* epilogue start */
	adiw r28,41
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
	pop r11
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	pop r5
	pop r4
	ret
	.size	BIL_OnExitAuthorized, .-BIL_OnExitAuthorized
	.section	.text.BIL_GetTotalRevenue,"ax",@progbits
.global	BIL_GetTotalRevenue
	.type	BIL_GetTotalRevenue, @function
BIL_GetTotalRevenue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u16TotalRevenue
	lds r25,g_u16TotalRevenue+1
/* epilogue start */
	ret
	.size	BIL_GetTotalRevenue, .-BIL_GetTotalRevenue
	.section	.text.BIL_GetTotalExits,"ax",@progbits
.global	BIL_GetTotalExits
	.type	BIL_GetTotalExits, @function
BIL_GetTotalExits:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u16TotalExits
	lds r25,g_u16TotalExits+1
/* epilogue start */
	ret
	.size	BIL_GetTotalExits, .-BIL_GetTotalExits
	.section	.text.BIL_ClearStats,"ax",@progbits
.global	BIL_ClearStats
	.type	BIL_ClearStats, @function
BIL_ClearStats:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_u16TotalRevenue,__zero_reg__
	sts g_u16TotalRevenue+1,__zero_reg__
	sts g_u16TotalExits,__zero_reg__
	sts g_u16TotalExits+1,__zero_reg__
/* epilogue start */
	ret
	.size	BIL_ClearStats, .-BIL_ClearStats
	.section	.bss.g_u16TotalExits,"aw",@nobits
	.type	g_u16TotalExits, @object
	.size	g_u16TotalExits, 2
g_u16TotalExits:
	.zero	2
	.section	.bss.g_u16TotalRevenue,"aw",@nobits
	.type	g_u16TotalRevenue, @object
	.size	g_u16TotalRevenue, 2
g_u16TotalRevenue:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
