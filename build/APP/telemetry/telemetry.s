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
	movw r18,r24
	movw r30,r20
	sub r22,r20
.L2:
	mov r24,r22
	add r24,r30
	ld r25,Z
	cpse r25,__zero_reg__
	rjmp .L3
/* epilogue start */
	ret
.L3:
	adiw r30,1
	movw r26,r18
	add r26,r24
	adc r27,__zero_reg__
	st X,r25
	rjmp .L2
	.size	TELEM_AppendStr, .-TELEM_AppendStr
	.section	.text.TELEM_AppendUint,"ax",@progbits
	.type	TELEM_AppendUint, @function
TELEM_AppendUint:
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
/* stack size = 22 */
.L__stack_usage = 22
	movw r10,r24
	mov r17,r22
	movw r12,r18
	movw r14,r20
	cp r12,__zero_reg__
	cpc r13,__zero_reg__
	cpc r14,__zero_reg__
	cpc r15,__zero_reg__
	brne .L9
	movw r30,r24
	add r30,r22
	adc r31,__zero_reg__
	ldi r24,lo8(48)
	st Z,r24
	ldi r24,lo8(1)
	add r24,r22
.L4:
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
	ret
.L9:
	ldi r16,0
	movw r8,r28
	ldi r24,-1
	sub r8,r24
	sbc r9,r24
.L5:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(10)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r30,r8
	add r30,r16
	adc r31,__zero_reg__
	subi r22,lo8(-(48))
	st Z,r22
	movw r24,r12
	movw r26,r14
	movw r12,r18
	movw r14,r20
	subi r16,lo8(-(1))
	sbiw r24,10
	cpc r26,__zero_reg__
	cpc r27,__zero_reg__
	brsh .L5
	movw r30,r8
	add r30,r16
	adc r31,__zero_reg__
	mov r24,r17
.L7:
	cp r8,r30
	cpc r9,r31
	brne .L8
	mov r24,r17
	add r24,r16
	rjmp .L4
.L8:
	movw r26,r10
	add r26,r24
	adc r27,__zero_reg__
	ld r25,-Z
	st X,r25
	subi r24,lo8(-(1))
	rjmp .L7
	.size	TELEM_AppendUint, .-TELEM_AppendUint
	.section	.rodata.TELEM_BuildFrame.part.0.str1.1,"aMS",@progbits,1
.LC0:
	.string	"$PK,F="
.LC1:
	.string	",O="
.LC2:
	.string	",MAP="
.LC3:
	.string	",IN="
.LC4:
	.string	",OUT="
.LC5:
	.string	",T="
.LC6:
	.string	",X="
.LC7:
	.string	",REV="
.LC8:
	.string	",MODE="
.LC9:
	.string	",UP="
.LC10:
	.string	"*"
.LC11:
	.string	"\r\n"
	.section	.text.TELEM_BuildFrame.part.0,"ax",@progbits
	.type	TELEM_BuildFrame.part.0, @function
TELEM_BuildFrame.part.0:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r28,r24
	ldi r20,lo8(.LC0)
	ldi r21,hi8(.LC0)
	ldi r22,0
	call TELEM_AppendStr
	mov r17,r24
	call LOT_GetFree
	mov r18,r24
	ldi r19,0
	ldi r20,0
	ldi r21,0
	mov r22,r17
	movw r24,r28
	call TELEM_AppendUint
	ldi r20,lo8(.LC1)
	ldi r21,hi8(.LC1)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call LOT_GetOccupied
	mov r18,r24
	ldi r19,0
	ldi r20,0
	ldi r21,0
	mov r22,r16
	movw r24,r28
	call TELEM_AppendUint
	ldi r20,lo8(.LC2)
	ldi r21,hi8(.LC2)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call SLOT_GetMap
	movw r26,r28
	add r26,r16
	adc r27,__zero_reg__
	mov r30,r24
	swap r30
	andi r30,lo8(15)
	ldi r31,0
	subi r30,lo8(-(Local_acHex.0))
	sbci r31,hi8(-(Local_acHex.0))
	ld r25,Z
	st X+,r25
	andi r24,lo8(15)
	mov r30,r24
	ldi r31,0
	subi r30,lo8(-(Local_acHex.0))
	sbci r31,hi8(-(Local_acHex.0))
	ld r24,Z
	st X,r24
	ldi r22,lo8(2)
	add r22,r16
	ldi r20,lo8(.LC3)
	ldi r21,hi8(.LC3)
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	ldi r24,lo8(g_entryLane)
	ldi r25,hi8(g_entryLane)
	call LANE_GetState
	movw r30,r24
	lsl r30
	rol r31
	subi r30,lo8(-(TELEM_LaneStateNames))
	sbci r31,hi8(-(TELEM_LaneStateNames))
	ld r20,Z
	ldd r21,Z+1
	mov r22,r16
	movw r24,r28
	call TELEM_AppendStr
	ldi r20,lo8(.LC4)
	ldi r21,hi8(.LC4)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	ldi r24,lo8(g_exitLane)
	ldi r25,hi8(g_exitLane)
	call LANE_GetState
	movw r30,r24
	lsl r30
	rol r31
	subi r30,lo8(-(TELEM_LaneStateNames))
	sbci r31,hi8(-(TELEM_LaneStateNames))
	ld r20,Z
	ldd r21,Z+1
	mov r22,r16
	movw r24,r28
	call TELEM_AppendStr
	ldi r20,lo8(.LC5)
	ldi r21,hi8(.LC5)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call TKT_GetTotalEntries
	movw r18,r24
	ldi r20,0
	ldi r21,0
	mov r22,r16
	movw r24,r28
	call TELEM_AppendUint
	ldi r20,lo8(.LC6)
	ldi r21,hi8(.LC6)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call BIL_GetTotalExits
	movw r18,r24
	ldi r20,0
	ldi r21,0
	mov r22,r16
	movw r24,r28
	call TELEM_AppendUint
	ldi r20,lo8(.LC7)
	ldi r21,hi8(.LC7)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call BIL_GetTotalRevenue
	movw r18,r24
	ldi r20,0
	ldi r21,0
	mov r22,r16
	movw r24,r28
	call TELEM_AppendUint
	ldi r20,lo8(.LC8)
	ldi r21,hi8(.LC8)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call LOT_GetState
	mov r30,r24
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(TELEM_ModeNames))
	sbci r31,hi8(-(TELEM_ModeNames))
	ld r20,Z
	ldd r21,Z+1
	mov r22,r16
	movw r24,r28
	call TELEM_AppendStr
	ldi r20,lo8(.LC9)
	ldi r21,hi8(.LC9)
	mov r22,r24
	movw r24,r28
	call TELEM_AppendStr
	mov r16,r24
	call RTC_Seconds
	movw r18,r22
	movw r20,r24
	mov r22,r16
	movw r24,r28
	call TELEM_AppendUint
	mov r16,r24
	mov r22,r24
	sub r22,r17
	ldi r23,0
	movw r24,r28
	add r24,r17
	adc r25,__zero_reg__
	call XOR_Checksum
	mov r17,r24
	ldi r20,lo8(.LC10)
	ldi r21,hi8(.LC10)
	mov r22,r16
	movw r24,r28
	call TELEM_AppendStr
	movw r26,r28
	add r26,r24
	adc r27,__zero_reg__
	mov r30,r17
	swap r30
	andi r30,lo8(15)
	ldi r31,0
	subi r30,lo8(-(Local_acHex.0))
	sbci r31,hi8(-(Local_acHex.0))
	ld r25,Z
	st X+,r25
	andi r17,lo8(15)
	mov r30,r17
	ldi r31,0
	subi r30,lo8(-(Local_acHex.0))
	sbci r31,hi8(-(Local_acHex.0))
	ld r25,Z
	st X,r25
	ldi r22,lo8(2)
	add r22,r24
	ldi r20,lo8(.LC11)
	ldi r21,hi8(.LC11)
	movw r24,r28
	call TELEM_AppendStr
	add r28,r24
	adc r29,__zero_reg__
	st Y,__zero_reg__
	ldi r24,0
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
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
	breq .L13
	jmp TELEM_BuildFrame.part.0
.L13:
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
	subi r28,64
	sbc r29,__zero_reg__
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 64 */
/* stack size = 66 */
.L__stack_usage = 66
	movw r24,r28
	adiw r24,1
	call TELEM_BuildFrame.part.0
	movw r24,r28
	adiw r24,1
	call USART_SendString
/* epilogue start */
	subi r28,-64
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
.LC12:
	.string	"INIT"
.LC13:
	.string	"OPER"
.LC14:
	.string	"FULL"
.LC15:
	.string	"MAINT"
.LC16:
	.string	"FAULT"
	.section	.rodata.TELEM_ModeNames,"a"
	.type	TELEM_ModeNames, @object
	.size	TELEM_ModeNames, 10
TELEM_ModeNames:
	.word	.LC12
	.word	.LC13
	.word	.LC14
	.word	.LC15
	.word	.LC16
	.section	.rodata.str1.1
.LC17:
	.string	"IDLE"
.LC18:
	.string	"WAIT"
.LC19:
	.string	"AUTH"
.LC20:
	.string	"OPENING"
.LC21:
	.string	"OPEN"
.LC22:
	.string	"PASS"
.LC23:
	.string	"CLOSING"
.LC24:
	.string	"REJECT"
.LC25:
	.string	"TIMEOUT"
	.section	.rodata.TELEM_LaneStateNames,"a"
	.type	TELEM_LaneStateNames, @object
	.size	TELEM_LaneStateNames, 18
TELEM_LaneStateNames:
	.word	.LC17
	.word	.LC18
	.word	.LC19
	.word	.LC20
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LC25
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
