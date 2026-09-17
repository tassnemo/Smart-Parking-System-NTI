	.file	"console.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.CONSOLE_SkipWord,"ax",@progbits
	.type	CONSOLE_SkipWord, @function
CONSOLE_SkipWord:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L2:
	movw r30,r24
	ld r20,Z
	movw r18,r24
	adiw r24,1
	andi r20,lo8(-33)
	brne .L2
.L3:
	movw r24,r18
	subi r18,-1
	sbci r19,-1
	movw r30,r24
	ld r20,Z
	cpi r20,lo8(32)
	breq .L3
/* epilogue start */
	ret
	.size	CONSOLE_SkipWord, .-CONSOLE_SkipWord
	.section	.text.CONSOLE_ParseUint,"ax",@progbits
	.type	CONSOLE_ParseUint, @function
CONSOLE_ParseUint:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldi r18,0
	ldi r24,0
	ldi r25,0
	ldi r21,lo8(10)
.L8:
	ld r19,Z
	ldi r20,lo8(-48)
	add r20,r19
	cpi r20,lo8(10)
	brlo .L9
	cp r18, __zero_reg__
	breq .L11
	movw r30,r22
	st Z,r24
	std Z+1,r25
	ldi r24,0
	ret
.L9:
	adiw r30,1
	mul r21,r24
	movw r26,r0
	mul r21,r25
	add r27,r0
	clr __zero_reg__
	movw r24,r26
	sbiw r24,48
	add r24,r19
	adc r25,__zero_reg__
	sbrc r19,7
	dec r25
	ldi r18,lo8(1)
	rjmp .L8
.L11:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	CONSOLE_ParseUint, .-CONSOLE_ParseUint
	.section	.text.CONSOLE_Handle_Tickets,"ax",@progbits
	.type	CONSOLE_Handle_Tickets, @function
CONSOLE_Handle_Tickets:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp TKT_PrintOpenTickets
	.size	CONSOLE_Handle_Tickets, .-CONSOLE_Handle_Tickets
	.section	.text.CONSOLE_Handle_Status,"ax",@progbits
	.type	CONSOLE_Handle_Status, @function
CONSOLE_Handle_Status:
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	subi r28,112
	sbc r29,__zero_reg__
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 112 */
/* stack size = 114 */
.L__stack_usage = 114
	movw r24,r28
	adiw r24,1
	call TELEM_BuildFrame
	cpse r24,__zero_reg__
	rjmp .L13
	movw r24,r28
	adiw r24,1
	call USART_SendString
.L13:
/* epilogue start */
	subi r28,-112
	sbci r29,-1
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	ret
	.size	CONSOLE_Handle_Status, .-CONSOLE_Handle_Status
	.section	.rodata.CONSOLE_SendLine.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\r\n"
	.section	.text.CONSOLE_SendLine,"ax",@progbits
	.type	CONSOLE_SendLine, @function
CONSOLE_SendLine:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call USART_SendString
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	jmp USART_SendString
	.size	CONSOLE_SendLine, .-CONSOLE_SendLine
	.section	.rodata.CONSOLE_Handle_Help.str1.1,"aMS",@progbits,1
.LC1:
	.string	"STATUS SLOTS? FREE? TICKETS? STATS?"
.LC2:
	.string	"SET TARIFF/GRACE/HOLD/TIMEOUT/LIGHT <n>"
.LC3:
	.string	"OPEN IN/OUT  CLOSE IN/OUT  (maintenance only)"
.LC4:
	.string	"MAINT ON/OFF  CLRSTATS  HELP"
	.section	.text.CONSOLE_Handle_Help,"ax",@progbits
	.type	CONSOLE_Handle_Help, @function
CONSOLE_Handle_Help:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call CONSOLE_SendLine
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call CONSOLE_SendLine
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	call CONSOLE_SendLine
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	jmp CONSOLE_SendLine
	.size	CONSOLE_Handle_Help, .-CONSOLE_Handle_Help
	.section	.rodata.CONSOLE_Handle_ClrStats.str1.1,"aMS",@progbits,1
.LC5:
	.string	"OK"
	.section	.text.CONSOLE_Handle_ClrStats,"ax",@progbits
	.type	CONSOLE_Handle_ClrStats, @function
CONSOLE_Handle_ClrStats:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call BIL_ClearStats
	call TKT_ClearStats
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	jmp CONSOLE_SendLine
	.size	CONSOLE_Handle_ClrStats, .-CONSOLE_Handle_ClrStats
	.section	.text.CONSOLE_Handle_Slots,"ax",@progbits
	.type	CONSOLE_Handle_Slots, @function
CONSOLE_Handle_Slots:
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,16
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 16 */
/* stack size = 18 */
.L__stack_usage = 18
	call SLOT_GetMap
	ldi r25,lo8(83)
	std Y+1,r25
	ldi r18,lo8(76)
	std Y+2,r18
	ldi r18,lo8(79)
	std Y+3,r18
	ldi r18,lo8(84)
	std Y+4,r18
	std Y+5,r25
	ldi r25,lo8(61)
	std Y+6,r25
	movw r30,r28
	adiw r30,7
	ldi r18,lo8(5)
	ldi r19,0
	ldi r22,lo8(1)
.L20:
	mov r20,r22
	mov r0,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r0
	brpl 1b
	and r20,r24
	breq .L21
	ldi r25,lo8(49)
.L19:
	st Z+,r25
	subi r18,1
	sbc r19,__zero_reg__
	brcc .L20
	std Y+13,__zero_reg__
	movw r24,r28
	adiw r24,1
	call CONSOLE_SendLine
/* epilogue start */
	adiw r28,16
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	ret
.L21:
	ldi r25,lo8(48)
	rjmp .L19
	.size	CONSOLE_Handle_Slots, .-CONSOLE_Handle_Slots
	.section	.text.CONSOLE_AppendUint,"ax",@progbits
	.type	CONSOLE_AppendUint, @function
CONSOLE_AppendUint:
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
	movw r16,r24
	movw r30,r22
	movw r18,r20
	or r20,r21
	brne .L28
	ld r24,Z
	movw r26,r16
	add r26,r24
	adc r27,__zero_reg__
	ldi r24,lo8(48)
	st X,r24
	ld r24,Z
	subi r24,lo8(-(1))
	st Z,r24
.L23:
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
.L28:
	ldi r20,0
	movw r14,r28
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
.L24:
	movw r24,r18
	ldi r22,lo8(10)
	ldi r23,0
	call __udivmodhi4
	movw r26,r14
	add r26,r20
	adc r27,__zero_reg__
	subi r24,lo8(-(48))
	st X,r24
	subi r20,lo8(-(1))
	movw r24,r18
	movw r18,r22
	sbiw r24,10
	brsh .L24
	add r20,r14
	mov r21,r15
	adc r21,__zero_reg__
.L26:
	cp r14,r20
	cpc r15,r21
	breq .L23
	ld r24,Z
	add r24,r16
	mov r25,r17
	adc r25,__zero_reg__
	movw r26,r20
	ld r18,-X
	movw r20,r26
	movw r26,r24
	st X,r18
	ld r24,Z
	subi r24,lo8(-(1))
	st Z,r24
	rjmp .L26
	.size	CONSOLE_AppendUint, .-CONSOLE_AppendUint
	.section	.text.CONSOLE_Handle_Stats,"ax",@progbits
	.type	CONSOLE_Handle_Stats, @function
CONSOLE_Handle_Stats:
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,33
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 33 */
/* stack size = 36 */
.L__stack_usage = 36
	ldi r24,lo8(83)
	std Y+1,r24
	ldi r25,lo8(84)
	std Y+2,r25
	ldi r18,lo8(65)
	std Y+3,r18
	std Y+4,r25
	std Y+5,r24
	ldi r24,lo8(6)
	std Y+33,r24
	ldi r24,lo8(61)
	std Y+6,r24
	call TKT_GetTotalEntries
	movw r20,r24
	movw r22,r28
	subi r22,-33
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call CONSOLE_AppendUint
	ldd r24,Y+33
	ldi r25,lo8(1)
	add r25,r24
	std Y+33,r25
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	ldi r17,lo8(44)
	st Z,r17
	call BIL_GetTotalExits
	movw r20,r24
	movw r22,r28
	subi r22,-33
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call CONSOLE_AppendUint
	ldd r24,Y+33
	ldi r25,lo8(1)
	add r25,r24
	std Y+33,r25
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,r17
	call BIL_GetTotalRevenue
	movw r20,r24
	movw r22,r28
	subi r22,-33
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call CONSOLE_AppendUint
	ldd r24,Y+33
	ldi r25,lo8(1)
	add r25,r24
	std Y+33,r25
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,r17
	call LOT_GetPeakOccupancy
	mov r20,r24
	ldi r21,0
	movw r22,r28
	subi r22,-33
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call CONSOLE_AppendUint
	ldd r24,Y+33
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,__zero_reg__
	movw r24,r28
	adiw r24,1
	call CONSOLE_SendLine
/* epilogue start */
	adiw r28,33
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	ret
	.size	CONSOLE_Handle_Stats, .-CONSOLE_Handle_Stats
	.section	.text.CONSOLE_Handle_Free,"ax",@progbits
	.type	CONSOLE_Handle_Free, @function
CONSOLE_Handle_Free:
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,11
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 11 */
/* stack size = 13 */
.L__stack_usage = 13
	ldi r24,lo8(70)
	std Y+1,r24
	ldi r24,lo8(82)
	std Y+2,r24
	ldi r24,lo8(69)
	std Y+3,r24
	std Y+4,r24
	ldi r24,lo8(5)
	std Y+11,r24
	ldi r24,lo8(61)
	std Y+5,r24
	call LOT_GetFree
	mov r20,r24
	ldi r21,0
	movw r22,r28
	subi r22,-11
	sbci r23,-1
	movw r24,r28
	adiw r24,1
	call CONSOLE_AppendUint
	ldd r24,Y+11
	movw r30,r28
	adiw r30,1
	add r30,r24
	adc r31,__zero_reg__
	st Z,__zero_reg__
	movw r24,r28
	adiw r24,1
	call CONSOLE_SendLine
/* epilogue start */
	adiw r28,11
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	ret
	.size	CONSOLE_Handle_Free, .-CONSOLE_Handle_Free
	.section	.rodata.CONSOLE_ApplySetting.str1.1,"aMS",@progbits,1
.LC6:
	.string	"ERR RANGE"
	.section	.text.CONSOLE_ApplySetting,"ax",@progbits
	.type	CONSOLE_ApplySetting, @function
CONSOLE_ApplySetting:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r22,r20
	cpc r23,r21
	brlo .L33
	cp r18,r22
	cpc r19,r23
	brsh .L34
.L33:
	ldi r24,lo8(.LC6)
	ldi r25,hi8(.LC6)
.L35:
	jmp CONSOLE_SendLine
.L34:
	movw r30,r24
	st Z,r22
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	rjmp .L35
	.size	CONSOLE_ApplySetting, .-CONSOLE_ApplySetting
	.section	.text.CONSOLE_MatchWord,"ax",@progbits
	.type	CONSOLE_MatchWord, @function
CONSOLE_MatchWord:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
.L37:
	movw r26,r22
	ld r25,X
	ld r24,Z
	cpse r25,__zero_reg__
	rjmp .L41
	andi r24,lo8(-33)
	ldi r25,lo8(1)
	cpse r24,__zero_reg__
	rjmp .L44
.L36:
	mov r24,r25
/* epilogue start */
	ret
.L41:
	cp r24, __zero_reg__
	breq .L44
	subi r22,-1
	sbci r23,-1
	adiw r30,1
	ldi r18,lo8(-97)
	add r18,r24
	cpi r18,lo8(26)
	brsh .L39
	subi r24,lo8(-(-32))
.L39:
	ldi r18,lo8(-97)
	add r18,r25
	cpi r18,lo8(26)
	brsh .L40
	subi r25,lo8(-(-32))
.L40:
	cp r25,r24
	breq .L37
.L44:
	ldi r25,0
	rjmp .L36
	.size	CONSOLE_MatchWord, .-CONSOLE_MatchWord
	.section	.rodata.CONSOLE_Handle_Maint.str1.1,"aMS",@progbits,1
.LC7:
	.string	"ON"
.LC8:
	.string	"OFF"
.LC9:
	.string	"ERR CMD"
	.section	.text.CONSOLE_Handle_Maint,"ax",@progbits
	.type	CONSOLE_Handle_Maint, @function
CONSOLE_Handle_Maint:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+1,r24
	std Y+2,r25
	ldi r22,lo8(.LC7)
	ldi r23,hi8(.LC7)
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L49
	ldi r24,lo8(1)
.L52:
	call LOT_SetMaintenance
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
.L51:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	jmp CONSOLE_SendLine
.L49:
	ldi r22,lo8(.LC8)
	ldi r23,hi8(.LC8)
	ldd r24,Y+1
	ldd r25,Y+2
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L50
	ldi r24,0
	rjmp .L52
.L50:
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	rjmp .L51
	.size	CONSOLE_Handle_Maint, .-CONSOLE_Handle_Maint
	.section	.rodata.CONSOLE_Handle_Close.str1.1,"aMS",@progbits,1
.LC10:
	.string	"ERR MODE"
.LC11:
	.string	"IN"
.LC12:
	.string	"OUT"
	.section	.text.CONSOLE_Handle_Close,"ax",@progbits
	.type	CONSOLE_Handle_Close, @function
CONSOLE_Handle_Close:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+1,r24
	std Y+2,r25
	call LOT_GetState
	sbiw r24,3
	breq .L54
	ldi r24,lo8(.LC10)
	ldi r25,hi8(.LC10)
.L57:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	jmp CONSOLE_SendLine
.L54:
	ldi r22,lo8(.LC11)
	ldi r23,hi8(.LC11)
	ldd r24,Y+1
	ldd r25,Y+2
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L55
	ldi r24,0
.L58:
	call BAR_Close
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	rjmp .L57
.L55:
	ldi r22,lo8(.LC12)
	ldi r23,hi8(.LC12)
	ldd r24,Y+1
	ldd r25,Y+2
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L56
	ldi r24,lo8(1)
	rjmp .L58
.L56:
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	rjmp .L57
	.size	CONSOLE_Handle_Close, .-CONSOLE_Handle_Close
	.section	.text.CONSOLE_Handle_Open,"ax",@progbits
	.type	CONSOLE_Handle_Open, @function
CONSOLE_Handle_Open:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+1,r24
	std Y+2,r25
	call LOT_GetState
	sbiw r24,3
	breq .L60
	ldi r24,lo8(.LC10)
	ldi r25,hi8(.LC10)
.L63:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	jmp CONSOLE_SendLine
.L60:
	ldi r22,lo8(.LC11)
	ldi r23,hi8(.LC11)
	ldd r24,Y+1
	ldd r25,Y+2
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L61
	ldi r24,0
.L64:
	call BAR_Open
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	rjmp .L63
.L61:
	ldi r22,lo8(.LC12)
	ldi r23,hi8(.LC12)
	ldd r24,Y+1
	ldd r25,Y+2
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L62
	ldi r24,lo8(1)
	rjmp .L64
.L62:
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	rjmp .L63
	.size	CONSOLE_Handle_Open, .-CONSOLE_Handle_Open
	.section	.rodata.CONSOLE_Handle_Set.str1.1,"aMS",@progbits,1
.LC13:
	.string	"TARIFF"
.LC14:
	.string	"GRACE"
.LC15:
	.string	"HOLD"
.LC16:
	.string	"TIMEOUT"
.LC17:
	.string	"LIGHT"
	.section	.text.CONSOLE_Handle_Set,"ax",@progbits
	.type	CONSOLE_Handle_Set, @function
CONSOLE_Handle_Set:
	push r16
	push r17
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 6 */
.L__stack_usage = 6
	movw r16,r24
	ldi r22,lo8(.LC13)
	ldi r23,hi8(.LC13)
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L66
	movw r24,r16
	call CONSOLE_SkipWord
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call CONSOLE_ParseUint
	cp r24, __zero_reg__
	breq .L67
.L69:
	ldi r24,lo8(.LC6)
	ldi r25,hi8(.LC6)
.L73:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	jmp CONSOLE_SendLine
.L67:
	ldd r22,Y+1
	ldd r23,Y+2
	ldi r18,lo8(100)
	ldi r19,0
	ldi r20,lo8(1)
	ldi r21,0
	ldi r24,lo8(g_u8Tariff)
	ldi r25,hi8(g_u8Tariff)
.L74:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	jmp CONSOLE_ApplySetting
.L66:
	ldi r22,lo8(.LC14)
	ldi r23,hi8(.LC14)
	movw r24,r16
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L68
	movw r24,r16
	call CONSOLE_SkipWord
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call CONSOLE_ParseUint
	cpse r24,__zero_reg__
	rjmp .L69
	ldd r22,Y+1
	ldd r23,Y+2
	ldi r18,lo8(60)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	ldi r24,lo8(g_u8Grace)
	ldi r25,hi8(g_u8Grace)
	rjmp .L74
.L68:
	ldi r22,lo8(.LC15)
	ldi r23,hi8(.LC15)
	movw r24,r16
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L70
	movw r24,r16
	call CONSOLE_SkipWord
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call CONSOLE_ParseUint
	cpse r24,__zero_reg__
	rjmp .L69
	ldd r22,Y+1
	ldd r23,Y+2
	ldi r18,lo8(15)
	ldi r19,0
	ldi r20,lo8(2)
	ldi r21,0
	ldi r24,lo8(g_u8Hold)
	ldi r25,hi8(g_u8Hold)
	rjmp .L74
.L70:
	ldi r22,lo8(.LC16)
	ldi r23,hi8(.LC16)
	movw r24,r16
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L71
	movw r24,r16
	call CONSOLE_SkipWord
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call CONSOLE_ParseUint
	cpse r24,__zero_reg__
	rjmp .L69
	ldd r22,Y+1
	ldd r23,Y+2
	ldi r18,lo8(60)
	ldi r19,0
	ldi r20,lo8(10)
	ldi r21,0
	ldi r24,lo8(g_u8Timeout)
	ldi r25,hi8(g_u8Timeout)
	rjmp .L74
.L71:
	ldi r22,lo8(.LC17)
	ldi r23,hi8(.LC17)
	movw r24,r16
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L72
	movw r24,r16
	call CONSOLE_SkipWord
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call CONSOLE_ParseUint
	cpse r24,__zero_reg__
	rjmp .L69
	ldd r22,Y+1
	ldd r23,Y+2
	ldi r18,lo8(100)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	ldi r24,lo8(g_u8LightThresh)
	ldi r25,hi8(g_u8LightThresh)
	rjmp .L74
.L72:
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	rjmp .L73
	.size	CONSOLE_Handle_Set, .-CONSOLE_Handle_Set
	.section	.text.CONSOLE_Init,"ax",@progbits
.global	CONSOLE_Init
	.type	CONSOLE_Init, @function
CONSOLE_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(10)
	sts g_u8Tariff,r24
	ldi r24,lo8(15)
	sts g_u8Grace,r24
	ldi r24,lo8(5)
	sts g_u8Hold,r24
	ldi r24,lo8(20)
	sts g_u8Timeout,r24
	ldi r24,lo8(30)
	sts g_u8LightThresh,r24
	ldi r24,0
/* epilogue start */
	ret
	.size	CONSOLE_Init, .-CONSOLE_Init
	.section	.rodata.CONSOLE_ParseLine.str1.1,"aMS",@progbits,1
.LC18:
	.string	"ERR LONG"
	.section	.text.CONSOLE_ParseLine,"ax",@progbits
.global	CONSOLE_ParseLine
	.type	CONSOLE_ParseLine, @function
CONSOLE_ParseLine:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 6 */
.L__stack_usage = 6
	movw r16,r24
	ldi r24,lo8(1)
	cp r16,__zero_reg__
	cpc r17,__zero_reg__
	breq .L76
	movw r30,r16
	0:
	ld __tmp_reg__,Z+
	tst __tmp_reg__
	brne 0b
	sbiw r30,1
	sub r30,r16
	ldi r24,lo8(.LC18)
	ldi r25,hi8(.LC18)
	cpi r30,lo8(25)
	brsh .L84
	ldi r19,lo8(CONSOLE_Commands)
	mov r14,r19
	ldi r19,hi8(CONSOLE_Commands)
	mov r15,r19
	ldi r28,0
	ldi r29,0
.L81:
	movw r30,r14
	ld r22,Z
	ldd r23,Z+1
	movw r24,r16
	call CONSOLE_MatchWord
	cp r24, __zero_reg__
	breq .L80
	movw r24,r16
	call CONSOLE_SkipWord
	lsl r28
	rol r29
	lsl r28
	rol r29
	subi r28,lo8(-(CONSOLE_Commands))
	sbci r29,hi8(-(CONSOLE_Commands))
	ldd r30,Y+2
	ldd r31,Y+3
	icall
.L79:
	ldi r24,0
.L76:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L80:
	adiw r28,1
	ldi r31,4
	add r14,r31
	adc r15,__zero_reg__
	cpi r28,11
	cpc r29,__zero_reg__
	brne .L81
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
.L84:
	call CONSOLE_SendLine
	rjmp .L79
	.size	CONSOLE_ParseLine, .-CONSOLE_ParseLine
	.section	.text.CONSOLE_GetTariff,"ax",@progbits
.global	CONSOLE_GetTariff
	.type	CONSOLE_GetTariff, @function
CONSOLE_GetTariff:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8Tariff
/* epilogue start */
	ret
	.size	CONSOLE_GetTariff, .-CONSOLE_GetTariff
	.section	.text.CONSOLE_GetGrace,"ax",@progbits
.global	CONSOLE_GetGrace
	.type	CONSOLE_GetGrace, @function
CONSOLE_GetGrace:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8Grace
/* epilogue start */
	ret
	.size	CONSOLE_GetGrace, .-CONSOLE_GetGrace
	.section	.text.CONSOLE_GetHold,"ax",@progbits
.global	CONSOLE_GetHold
	.type	CONSOLE_GetHold, @function
CONSOLE_GetHold:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8Hold
/* epilogue start */
	ret
	.size	CONSOLE_GetHold, .-CONSOLE_GetHold
	.section	.text.CONSOLE_GetTimeout,"ax",@progbits
.global	CONSOLE_GetTimeout
	.type	CONSOLE_GetTimeout, @function
CONSOLE_GetTimeout:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8Timeout
/* epilogue start */
	ret
	.size	CONSOLE_GetTimeout, .-CONSOLE_GetTimeout
	.section	.text.CONSOLE_GetLightThresh,"ax",@progbits
.global	CONSOLE_GetLightThresh
	.type	CONSOLE_GetLightThresh, @function
CONSOLE_GetLightThresh:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8LightThresh
/* epilogue start */
	ret
	.size	CONSOLE_GetLightThresh, .-CONSOLE_GetLightThresh
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC19:
	.string	"STATUS"
.LC20:
	.string	"SLOTS?"
.LC21:
	.string	"FREE?"
.LC22:
	.string	"TICKETS?"
.LC23:
	.string	"STATS?"
.LC24:
	.string	"SET"
.LC25:
	.string	"OPEN"
.LC26:
	.string	"CLOSE"
.LC27:
	.string	"MAINT"
.LC28:
	.string	"CLRSTATS"
.LC29:
	.string	"HELP"
	.section	.rodata.CONSOLE_Commands,"a"
	.type	CONSOLE_Commands, @object
	.size	CONSOLE_Commands, 44
CONSOLE_Commands:
	.word	.LC19
	.word	gs(CONSOLE_Handle_Status)
	.word	.LC20
	.word	gs(CONSOLE_Handle_Slots)
	.word	.LC21
	.word	gs(CONSOLE_Handle_Free)
	.word	.LC22
	.word	gs(CONSOLE_Handle_Tickets)
	.word	.LC23
	.word	gs(CONSOLE_Handle_Stats)
	.word	.LC24
	.word	gs(CONSOLE_Handle_Set)
	.word	.LC25
	.word	gs(CONSOLE_Handle_Open)
	.word	.LC26
	.word	gs(CONSOLE_Handle_Close)
	.word	.LC27
	.word	gs(CONSOLE_Handle_Maint)
	.word	.LC28
	.word	gs(CONSOLE_Handle_ClrStats)
	.word	.LC29
	.word	gs(CONSOLE_Handle_Help)
	.section	.data.g_u8LightThresh,"aw"
	.type	g_u8LightThresh, @object
	.size	g_u8LightThresh, 1
g_u8LightThresh:
	.byte	30
	.section	.data.g_u8Timeout,"aw"
	.type	g_u8Timeout, @object
	.size	g_u8Timeout, 1
g_u8Timeout:
	.byte	20
	.section	.data.g_u8Hold,"aw"
	.type	g_u8Hold, @object
	.size	g_u8Hold, 1
g_u8Hold:
	.byte	5
	.section	.data.g_u8Grace,"aw"
	.type	g_u8Grace, @object
	.size	g_u8Grace, 1
g_u8Grace:
	.byte	15
	.section	.data.g_u8Tariff,"aw"
	.type	g_u8Tariff, @object
	.size	g_u8Tariff, 1
g_u8Tariff:
	.byte	10
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
