	.file	"telemetry.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TELEM_AppendStr,"ax",@progbits
	.type	TELEM_AppendStr, @function
TELEM_AppendStr:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	add r30,r22
	adc r31,__zero_reg__
.L2:
	movw r26,r20
	ld r24,X
	cp r24, __zero_reg__
	breq .L6
	cpi r22,lo8(111)
	brlo .L4
.L6:
	mov r24,r22
/* epilogue start */
	ret
.L4:
	subi r20,-1
	sbci r21,-1
	st Z+,r24
	subi r22,lo8(-(1))
	rjmp .L2
	.size	TELEM_AppendStr, .-TELEM_AppendStr
	.section	.text.TELEM_AppendUint,"ax",@progbits
	.type	TELEM_AppendUint, @function
TELEM_AppendUint:
	push r4
	push r5
	push r6
	push r7
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
/* stack size = 24 */
.L__stack_usage = 24
	movw r14,r24
	mov r17,r22
	movw r4,r18
	movw r6,r20
	cp r4,__zero_reg__
	cpc r5,__zero_reg__
	cpc r6,__zero_reg__
	cpc r7,__zero_reg__
	brne .L8
	cpi r22,lo8(111)
	brsh .L9
	movw r30,r24
	add r30,r22
	adc r31,__zero_reg__
	ldi r24,lo8(48)
	st Z,r24
	subi r17,lo8(-(1))
.L9:
	mov r24,r17
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
	pop r7
	pop r6
	pop r5
	pop r4
	ret
.L8:
	movw r12,r28
	ldi r24,-1
	sub r12,r24
	sbc r13,r24
	movw r10,r12
	ldi r16,0
.L12:
	movw r22,r4
	movw r24,r6
	ldi r18,lo8(10)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	subi r22,lo8(-(48))
	movw r30,r10
	st Z,r22
	subi r16,lo8(-(1))
	ldi r31,10
	cp r4,r31
	cpc r5,__zero_reg__
	cpc r6,__zero_reg__
	cpc r7,__zero_reg__
	brsh .L10
.L13:
	movw r26,r12
	add r26,r16
	adc r27,__zero_reg__
	movw r30,r14
	add r30,r17
	adc r31,__zero_reg__
.L11:
	cpi r17,lo8(111)
	brsh .L9
	ld r24,-X
	st Z+,r24
	subi r17,lo8(-(1))
	cp r26,r12
	cpc r27,r13
	brne .L11
	rjmp .L9
.L10:
	ldi r24,-1
	sub r10,r24
	sbc r11,r24
	movw r4,r18
	movw r6,r20
	cpi r16,lo8(10)
	brne .L12
	rjmp .L13
	.size	TELEM_AppendUint, .-TELEM_AppendUint
	.section	.text.TELEM_AppendHexByte,"ax",@progbits
	.type	TELEM_AppendHexByte, @function
TELEM_AppendHexByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r22,lo8(110)
	brsh .L18
	movw r26,r24
	add r26,r22
	adc r27,__zero_reg__
	mov r30,r20
	swap r30
	andi r30,lo8(15)
	ldi r31,0
	subi r30,lo8(-(Local_acHex.0))
	sbci r31,hi8(-(Local_acHex.0))
	ld r24,Z
	st X+,r24
	andi r20,lo8(15)
	mov r30,r20
	ldi r31,0
	subi r30,lo8(-(Local_acHex.0))
	sbci r31,hi8(-(Local_acHex.0))
	ld r24,Z
	st X,r24
	subi r22,lo8(-(2))
.L18:
	mov r24,r22
/* epilogue start */
	ret
	.size	TELEM_AppendHexByte, .-TELEM_AppendHexByte
	.section	.rodata.TELEM_BuildFrame.part.0.str1.1,"aMS",@progbits,1
.LC0:
	.string	"?"
.LC1:
	.string	"$PK,F="
.LC2:
	.string	",O="
.LC3:
	.string	",MAP="
.LC4:
	.string	",IN="
.LC5:
	.string	",OUT="
.LC6:
	.string	",T="
.LC7:
	.string	",X="
.LC8:
	.string	",REV="
.LC9:
	.string	",MODE="
.LC10:
	.string	",UP="
.LC11:
	.string	"*"
.LC12:
	.string	"\r\n"
	.section	.text.TELEM_BuildFrame.part.0,"ax",@progbits
	.type	TELEM_BuildFrame.part.0, @function
TELEM_BuildFrame.part.0:
	push r17
	push r28
	push r29
	rcall .
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 3 */
/* stack size = 6 */
.L__stack_usage = 6
	std Y+2,r24
	std Y+3,r25
	ldi r20,lo8(.LC1)
	ldi r21,hi8(.LC1)
	ldi r22,0
	call TELEM_AppendStr
	mov r17,r24
	call LOT_GetFree
	mov r18,r24
	ldi r19,0
	ldi r20,0
	ldi r21,0
	mov r22,r17
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendUint
	ldi r20,lo8(.LC2)
	ldi r21,hi8(.LC2)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call LOT_GetOccupied
	mov r18,r24
	ldi r19,0
	ldi r20,0
	ldi r21,0
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendUint
	ldi r20,lo8(.LC3)
	ldi r21,hi8(.LC3)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call SLOT_GetMap
	mov r20,r24
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendHexByte
	ldi r20,lo8(.LC4)
	ldi r21,hi8(.LC4)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	ldi r24,lo8(g_entryLane)
	ldi r25,hi8(g_entryLane)
	call LANE_GetState
	ldi r20,lo8(.LC0)
	ldi r21,hi8(.LC0)
	cpi r24,lo8(9)
	brsh .L20
	mov r30,r24
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(TELEM_LaneStateNames))
	sbci r31,hi8(-(TELEM_LaneStateNames))
	ld r20,Z
	ldd r21,Z+1
.L20:
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	ldi r20,lo8(.LC5)
	ldi r21,hi8(.LC5)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	ldi r24,lo8(g_exitLane)
	ldi r25,hi8(g_exitLane)
	call LANE_GetState
	ldi r20,lo8(.LC0)
	ldi r21,hi8(.LC0)
	cpi r24,lo8(9)
	brsh .L21
	mov r30,r24
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(TELEM_LaneStateNames))
	sbci r31,hi8(-(TELEM_LaneStateNames))
	ld r20,Z
	ldd r21,Z+1
.L21:
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	ldi r20,lo8(.LC6)
	ldi r21,hi8(.LC6)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call TKT_GetTotalEntries
	movw r18,r24
	ldi r20,0
	ldi r21,0
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendUint
	ldi r20,lo8(.LC7)
	ldi r21,hi8(.LC7)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call BIL_GetTotalExits
	movw r18,r24
	ldi r20,0
	ldi r21,0
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendUint
	ldi r20,lo8(.LC8)
	ldi r21,hi8(.LC8)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call BIL_GetTotalRevenue
	movw r18,r24
	ldi r20,0
	ldi r21,0
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendUint
	ldi r20,lo8(.LC9)
	ldi r21,hi8(.LC9)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call LOT_GetState
	ldi r20,lo8(.LC0)
	ldi r21,hi8(.LC0)
	cpi r24,lo8(5)
	brsh .L22
	mov r30,r24
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(TELEM_ModeNames))
	sbci r31,hi8(-(TELEM_ModeNames))
	ld r20,Z
	ldd r21,Z+1
.L22:
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	ldi r20,lo8(.LC10)
	ldi r21,hi8(.LC10)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	std Y+1,r24
	call RTC_Seconds
	movw r18,r22
	movw r20,r24
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendUint
	std Y+1,r24
	mov r22,r24
	sub r22,r17
	ldi r23,0
	ldd r24,Y+2
	ldd r25,Y+3
	add r24,r17
	adc r25,__zero_reg__
	call XOR_Checksum
	mov r17,r24
	ldi r20,lo8(.LC11)
	ldi r21,hi8(.LC11)
	ldd r22,Y+1
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	mov r20,r17
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendHexByte
	ldi r20,lo8(.LC12)
	ldi r21,hi8(.LC12)
	mov r22,r24
	ldd r24,Y+2
	ldd r25,Y+3
	call TELEM_AppendStr
	ldd r18,Y+2
	ldd r19,Y+3
	add r18,r24
	adc r19,__zero_reg__
	movw r30,r18
	st Z,__zero_reg__
	ldi r24,0
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	ret
	.size	TELEM_BuildFrame.part.0, .-TELEM_BuildFrame.part.0
	.section	.text.TELEM_BuildFrame,"ax",@progbits
.global	TELEM_BuildFrame
	.type	TELEM_BuildFrame, @function
TELEM_BuildFrame:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L27
	jmp TELEM_BuildFrame.part.0
.L27:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	TELEM_BuildFrame, .-TELEM_BuildFrame
	.section	.text.TELEM_Send,"ax",@progbits
.global	TELEM_Send
	.type	TELEM_Send, @function
TELEM_Send:
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
	call TELEM_BuildFrame.part.0
	movw r24,r28
	adiw r24,1
	call USART_SendString
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
	.size	TELEM_Send, .-TELEM_Send
	.section	.rodata.Local_acHex.0,"a"
	.type	Local_acHex.0, @object
	.size	Local_acHex.0, 17
Local_acHex.0:
	.string	"0123456789ABCDEF"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC13:
	.string	"INIT"
.LC14:
	.string	"OPER"
.LC15:
	.string	"FULL"
.LC16:
	.string	"MAINT"
.LC17:
	.string	"FAULT"
	.section	.rodata.TELEM_ModeNames,"a"
	.type	TELEM_ModeNames, @object
	.size	TELEM_ModeNames, 10
TELEM_ModeNames:
	.word	.LC13
	.word	.LC14
	.word	.LC15
	.word	.LC16
	.word	.LC17
	.section	.rodata.str1.1
.LC18:
	.string	"IDLE"
.LC19:
	.string	"WAIT"
.LC20:
	.string	"AUTH"
.LC21:
	.string	"OPENING"
.LC22:
	.string	"OPEN"
.LC23:
	.string	"PASS"
.LC24:
	.string	"CLOSING"
.LC25:
	.string	"REJECT"
.LC26:
	.string	"TIMEOUT"
	.section	.rodata.TELEM_LaneStateNames,"a"
	.type	TELEM_LaneStateNames, @object
	.size	TELEM_LaneStateNames, 18
TELEM_LaneStateNames:
	.word	.LC18
	.word	.LC19
	.word	.LC20
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
