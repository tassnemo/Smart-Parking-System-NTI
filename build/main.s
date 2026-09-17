	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Task_Display,"ax",@progbits
	.type	Task_Display, @function
Task_Display:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp DISPLAY_Task
	.size	Task_Display, .-Task_Display
	.section	.text.MAIN_OnTick,"ax",@progbits
	.type	MAIN_OnTick, @function
MAIN_OnTick:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8TickFlag
	cp r24, __zero_reg__
	breq .L3
	ldi r24,lo8(1)
	sts g_u8TickOverrun,r24
.L3:
	ldi r24,lo8(1)
	sts g_u8TickFlag,r24
	jmp RTC_Tick10ms
	.size	MAIN_OnTick, .-MAIN_OnTick
	.section	.text.Task_Report,"ax",@progbits
	.type	Task_Report, @function
Task_Report:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp TELEM_Send
	.size	Task_Report, .-Task_Report
	.section	.text.Task_Loops,"ax",@progbits
	.type	Task_Loops, @function
Task_Loops:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(g_entryLoop)
	ldi r25,hi8(g_entryLoop)
	call LOOPSENSE_Run
	ldi r24,lo8(g_exitLoop)
	ldi r25,hi8(g_exitLoop)
	jmp LOOPSENSE_Run
	.size	Task_Loops, .-Task_Loops
	.section	.text.Task_Buttons,"ax",@progbits
	.type	Task_Buttons, @function
Task_Buttons:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	call BTN_Update
	ldi r24,lo8(3)
	call BTN_IsPressed
	mov r28,r24
	cp r24, __zero_reg__
	breq .L10
	lds r24,g_u8PrevMaintBtn
	cpse r24,__zero_reg__
	rjmp .L10
	call LOT_GetState
	movw r18,r24
	ldi r24,lo8(1)
	cpi r18,3
	cpc r19,__zero_reg__
	brne .L11
	ldi r24,0
.L11:
	call LOT_SetMaintenance
.L10:
	sts g_u8PrevMaintBtn,r28
	ldi r24,lo8(2)
	call BTN_IsPressed
	cp r24, __zero_reg__
	breq .L12
	ldi r24,lo8(44)
	ldi r25,lo8(1)
	sts g_u16ExitBtnHold,r24
	sts g_u16ExitBtnHold+1,r25
.L12:
/* epilogue start */
	pop r28
	jmp BUZ_Update
	.size	Task_Buttons, .-Task_Buttons
	.section	.rodata.Task_Console.str1.1,"aMS",@progbits,1
.LC0:
	.string	"ERR LONG\r\n"
	.section	.text.Task_Console,"ax",@progbits
	.type	Task_Console, @function
Task_Console:
	push r17
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 4 */
.L__stack_usage = 4
	ldi r17,lo8(1)
.L20:
	movw r24,r28
	adiw r24,1
	call USART_ReceiveByte
	cp r24, __zero_reg__
	breq .L27
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	ret
.L27:
	ldd r25,Y+1
	cpi r25,lo8(13)
	breq .L21
	cpi r25,lo8(10)
	brne .L22
.L21:
	lds r24,g_u8LineOverflow
	cp r24, __zero_reg__
	breq .L23
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call USART_SendString
.L24:
	sts g_u8LinePos,__zero_reg__
	sts g_u8LineOverflow,__zero_reg__
	rjmp .L20
.L23:
	lds r30,g_u8LinePos
	cp r30, __zero_reg__
	breq .L24
	ldi r31,0
	subi r30,lo8(-(g_acLine))
	sbci r31,hi8(-(g_acLine))
	st Z,__zero_reg__
	ldi r24,lo8(g_acLine)
	ldi r25,hi8(g_acLine)
	call CONSOLE_ParseLine
	rjmp .L24
.L22:
	lds r24,g_u8LinePos
	cpi r24,lo8(24)
	brsh .L26
	mov r30,r24
	ldi r31,0
	subi r30,lo8(-(g_acLine))
	sbci r31,hi8(-(g_acLine))
	st Z,r25
	subi r24,lo8(-(1))
	sts g_u8LinePos,r24
	rjmp .L20
.L26:
	sts g_u8LineOverflow,r17
	rjmp .L20
	.size	Task_Console, .-Task_Console
	.section	.rodata.MAIN_SendEvent.str1.1,"aMS",@progbits,1
.LC1:
	.string	"!EVT,"
.LC2:
	.string	"\r\n"
	.section	.text.MAIN_SendEvent,"ax",@progbits
	.type	MAIN_SendEvent, @function
MAIN_SendEvent:
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
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call USART_SendString
	ldd r24,Y+1
	ldd r25,Y+2
	call USART_SendString
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	jmp USART_SendString
	.size	MAIN_SendEvent, .-MAIN_SendEvent
	.section	.rodata.Task_Lot.str1.1,"aMS",@progbits,1
.LC3:
	.string	"LOT,FULL"
.LC4:
	.string	"LOT,VACANT"
.LC5:
	.string	"LOT,FAULT"
	.section	.text.Task_Lot,"ax",@progbits
	.type	Task_Lot, @function
Task_Lot:
	push r16
	push r17
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 3 */
.L__stack_usage = 3
	call LOT_Run
	call LOT_GetState
	movw r16,r24
	call LOT_GetFree
	ldi r28,lo8(1)
	cpse r24,__zero_reg__
	ldi r28,0
.L36:
	ldi r24,lo8(1)
	cpi r16,3
	cpc r17,__zero_reg__
	brne .L37
	ldi r24,0
.L37:
	and r28,r24
	lds r24,g_u8PrevFullSign
	cp r24,r28
	breq .L38
	mov r20,r28
	ldi r22,lo8(6)
	ldi r24,lo8(3)
	call DIO_WritePin
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	cpse r28,__zero_reg__
	rjmp .L39
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
.L39:
	call MAIN_SendEvent
	sts g_u8PrevFullSign,r28
.L38:
	lds r24,g_PrevLotState
	lds r25,g_PrevLotState+1
	cp r24,r16
	cpc r25,r17
	breq .L35
	cpi r16,4
	cpc r17,__zero_reg__
	brne .L41
	ldi r24,0
	call BAR_Open
	ldi r24,lo8(1)
	call BAR_Open
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	call MAIN_SendEvent
.L41:
	sts g_PrevLotState,r16
	sts g_PrevLotState+1,r17
.L35:
/* epilogue start */
	pop r28
	pop r17
	pop r16
	ret
	.size	Task_Lot, .-Task_Lot
	.section	.rodata.Task_Lanes.str1.1,"aMS",@progbits,1
.LC6:
	.string	"MAINT,ON"
.LC7:
	.string	"MAINT,OFF"
.LC8:
	.string	"!EVT,ENTRY,GRANT,"
.LC9:
	.string	"ENTRY,REJECT"
.LC10:
	.string	"LANE,TIMEOUT,IN"
.LC11:
	.string	"LANE,TIMEOUT,OUT"
	.section	.text.Task_Lanes,"ax",@progbits
	.type	Task_Lanes, @function
Task_Lanes:
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 8 */
.L__stack_usage = 8
	call LOT_GetState
	movw r18,r24
	lds r25,g_u8InMaintenance
	cpi r18,3
	cpc r19,__zero_reg__
	brne .L47
	cpse r25,__zero_reg__
	rjmp .L46
	ldi r24,lo8(1)
	sts g_u8InMaintenance,r24
	sts g_entryLane,__zero_reg__
	sts g_entryLane+1,__zero_reg__
	sts g_entryLane+2,__zero_reg__
	sts g_entryLane+3,__zero_reg__
	sts g_entryLane+4,__zero_reg__
	sts g_exitLane,__zero_reg__
	sts g_exitLane+1,__zero_reg__
	sts g_exitLane+2,__zero_reg__
	sts g_exitLane+3,__zero_reg__
	sts g_exitLane+4,__zero_reg__
	ldi r24,0
	call BAR_Open
	ldi r24,lo8(1)
	call BAR_Open
	ldi r24,lo8(.LC6)
	ldi r25,hi8(.LC6)
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	jmp MAIN_SendEvent
.L47:
	cp r25, __zero_reg__
	breq .L50
	sts g_u8InMaintenance,__zero_reg__
	ldi r24,0
	call BAR_Close
	ldi r24,lo8(1)
	call BAR_Close
	ldi r24,lo8(.LC7)
	ldi r25,hi8(.LC7)
	call MAIN_SendEvent
.L50:
	lds r22,g_entryLoop+3
	ldi r24,lo8(g_entryLane)
	ldi r25,hi8(g_entryLane)
	call LANE_RequestOpen
	lds r24,g_exitLoop+3
	ldi r22,lo8(1)
	cpse r24,__zero_reg__
	rjmp .L51
	lds r24,g_u16ExitBtnHold
	lds r25,g_u16ExitBtnHold+1
	or r24,r25
	brne .L51
	ldi r22,0
.L51:
	ldi r24,lo8(g_exitLane)
	ldi r25,hi8(g_exitLane)
	call LANE_RequestOpen
	lds r24,g_u16ExitBtnHold
	lds r25,g_u16ExitBtnHold+1
	sbiw r24,0
	breq .L53
	sbiw r24,1
	sts g_u16ExitBtnHold,r24
	sts g_u16ExitBtnHold+1,r25
.L53:
	ldi r24,lo8(g_entryLane)
	ldi r25,hi8(g_entryLane)
	call LANE_Run
	ldi r24,lo8(g_exitLane)
	ldi r25,hi8(g_exitLane)
	call LANE_Run
	ldi r24,lo8(g_entryLane)
	ldi r25,hi8(g_entryLane)
	call LANE_GetState
	movw r16,r24
	ldi r24,lo8(g_exitLane)
	ldi r25,hi8(g_exitLane)
	call LANE_GetState
	movw r12,r24
	lds r24,g_PrevEntryState
	lds r25,g_PrevEntryState+1
	cp r24,r16
	cpc r25,r17
	brne .+2
	rjmp .L54
	cpi r16,3
	cpc r17,__zero_reg__
	breq .+2
	rjmp .L55
	ldi r24,lo8(.LC8)
	ldi r25,hi8(.LC8)
	call USART_SendString
	call TKT_GetNextId
	movw r28,r24
	sbiw r28,1
	sbiw r24,2
	brsh .L56
	ldi r28,lo8(15)
	ldi r29,lo8(39)
.L56:
	movw r24,r28
	ldi r22,lo8(-24)
	ldi r23,lo8(3)
	call __udivmodhi4
	movw r24,r22
	ldi r18,lo8(10)
	mov r14,r18
	mov r15,__zero_reg__
	movw r22,r14
	call __udivmodhi4
	subi r24,lo8(-(48))
	call USART_SendByte
	movw r24,r28
	ldi r22,lo8(100)
	ldi r23,0
	call __udivmodhi4
	movw r24,r22
	movw r22,r14
	call __udivmodhi4
	subi r24,lo8(-(48))
	call USART_SendByte
	movw r24,r28
	movw r22,r14
	call __udivmodhi4
	mov r28,r24
	movw r24,r22
	movw r22,r14
	call __udivmodhi4
	subi r24,lo8(-(48))
	call USART_SendByte
	ldi r24,lo8(48)
	add r24,r28
	call USART_SendByte
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
.L57:
	sts g_PrevEntryState,r16
	sts g_PrevEntryState+1,r17
.L54:
	lds r24,g_PrevExitState
	lds r25,g_PrevExitState+1
	cp r24,r12
	cpc r25,r13
	breq .L46
	ldi r24,8
	cp r12,r24
	cpc r13,__zero_reg__
	brne .L60
	ldi r24,lo8(.LC11)
	ldi r25,hi8(.LC11)
	call MAIN_SendEvent
.L60:
	sts g_PrevExitState,r12
	sts g_PrevExitState+1,r13
.L46:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	ret
.L55:
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	cpi r16,7
	cpc r17,__zero_reg__
	breq .L69
	cpi r16,8
	cpc r17,__zero_reg__
	brne .L57
	ldi r24,lo8(.LC10)
	ldi r25,hi8(.LC10)
.L69:
	call MAIN_SendEvent
	rjmp .L57
	.size	Task_Lanes, .-Task_Lanes
	.section	.text.MAIN_SendUint16,"ax",@progbits
	.type	MAIN_SendUint16, @function
MAIN_SendUint16:
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
	movw r18,r24
	or r24,r25
	brne .L74
	ldi r24,lo8(48)
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
	jmp USART_SendByte
.L74:
	ldi r20,0
	ldi r30,lo8(10)
	ldi r31,0
	movw r14,r28
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
.L71:
	movw r24,r18
	movw r22,r30
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
	brsh .L71
	movw r16,r14
	add r16,r20
	adc r17,__zero_reg__
.L72:
	cp r14,r16
	cpc r15,r17
	brne .L73
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
.L73:
	movw r30,r16
	ld r24,-Z
	movw r16,r30
	call USART_SendByte
	rjmp .L72
	.size	MAIN_SendUint16, .-MAIN_SendUint16
	.section	.rodata.Task_1Hz.str1.1,"aMS",@progbits,1
.LC12:
	.string	"!EVT,LOT,MISMATCH,"
.LC13:
	.string	"!EVT,SCHED,OVR,"
	.section	.text.Task_1Hz,"ax",@progbits
	.type	Task_1Hz, @function
Task_1Hz:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	call LIGHT_Run
	call TKT_GetOpenCount
	mov r29,r24
	call LOT_GetOccupied
	mov r28,r24
	cp r29,r24
	brne .+2
	rjmp .L77
	lds r24,g_u8MismatchSec
	cpi r24,lo8(-1)
	brne .L78
.L81:
	lds r24,g_u8MismatchLogged
	cpse r24,__zero_reg__
	rjmp .L82
	ldi r24,lo8(.LC12)
	ldi r25,hi8(.LC12)
	call USART_SendString
	mov r24,r29
	ldi r25,0
	call MAIN_SendUint16
	ldi r24,lo8(44)
	call USART_SendByte
	mov r24,r28
	ldi r25,0
	call MAIN_SendUint16
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
	ldi r24,lo8(1)
	sts g_u8MismatchLogged,r24
	rjmp .L82
.L78:
	subi r24,lo8(-(1))
	sts g_u8MismatchSec,r24
	cpi r24,lo8(31)
	brsh .L81
.L82:
	lds r24,g_u16OverrunCnt
	lds r25,g_u16OverrunCnt+1
	or r24,r25
	breq .L76
	ldi r24,lo8(.LC13)
	ldi r25,hi8(.LC13)
	call USART_SendString
	lds r24,g_u16OverrunCnt
	lds r25,g_u16OverrunCnt+1
	call MAIN_SendUint16
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
	sts g_u16OverrunCnt,__zero_reg__
	sts g_u16OverrunCnt+1,__zero_reg__
.L76:
/* epilogue start */
	pop r29
	pop r28
	ret
.L77:
	sts g_u8MismatchSec,__zero_reg__
	sts g_u8MismatchLogged,__zero_reg__
	rjmp .L82
	.size	Task_1Hz, .-Task_1Hz
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC14:
	.string	"SMART PARKING   "
.LC15:
	.string	"BOOTING...      "
.LC16:
	.string	"!EVT,BOOT,CAUSE="
.LC17:
	.string	"BOOT"
.LC18:
	.string	"CFG,DEFAULT"
.LC19:
	.string	"LOT,FAULT,INIT"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,19
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 19 */
/* stack size = 19 */
.L__stack_usage = 19
	in r18,0x34
	std Y+18,r18
	out 0x34,__zero_reg__
	in r24,0x34
	ori r24,lo8(-128)
	out 0x34,r24
	in r24,0x34
	ori r24,lo8(-128)
	out 0x34,r24
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call ADC_Init
	std Y+1,r24
	call PWM_Init
	std Y+2,r24
	call USART_Init
	std Y+3,r24
	call TMR0_InitCTC
	mov r17,r24
	ldi r24,lo8(gs(MAIN_OnTick))
	ldi r25,hi8(gs(MAIN_OnTick))
	call TMR0_SetCallback
	std Y+19,r24
	call SLOT_Init
	std Y+4,r24
	call SEG_Init
	std Y+5,r24
	call LED_Init
	std Y+6,r24
	call LCD_Init
	std Y+7,r24
	ldi r24,lo8(7)
	call BUZ_Init
	std Y+8,r24
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,lo8(3)
	call BTN_Init
	std Y+9,r24
	ldi r20,0
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call BTN_Init
	std Y+10,r24
	ldi r24,0
	call BAR_Init
	std Y+11,r24
	ldi r24,lo8(1)
	call BAR_Init
	std Y+12,r24
	ldi r24,0
	call BAR_Close
	ldi r24,lo8(1)
	call BAR_Close
	ldi r20,lo8(1)
	ldi r22,lo8(6)
	ldi r24,lo8(3)
	call DIO_Init
	std Y+13,r24
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(3)
	call DIO_WritePin
	call LOT_Init
	call TKT_Init
	call LIGHT_Init
	std Y+14,r24
	call CONSOLE_Init
	std Y+15,r24
	call DISPLAY_Init
	std Y+16,r24
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(g_entryLane)
	ldi r25,hi8(g_entryLane)
	call LANE_Init
	ldi r20,0
	ldi r22,lo8(1)
	ldi r24,lo8(g_exitLane)
	ldi r25,hi8(g_exitLane)
	call LANE_Init
	ldi r20,lo8(g_entryLane)
	ldi r21,hi8(g_entryLane)
	ldi r22,0
	ldi r24,lo8(g_entryLoop)
	ldi r25,hi8(g_entryLoop)
	call LOOPSENSE_Init
	std Y+17,r24
	ldi r20,lo8(g_exitLane)
	ldi r21,hi8(g_exitLane)
	ldi r22,lo8(1)
	ldi r24,lo8(g_exitLoop)
	ldi r25,hi8(g_exitLoop)
	call LOOPSENSE_Init
	cpse r24,__zero_reg__
	rjmp .L100
	ldd r24,Y+4
	ldd r20,Y+5
	or r24,r20
	ldd r25,Y+6
	or r24,r25
	ldd r18,Y+7
	or r24,r18
	ldd r20,Y+8
	or r24,r20
	ldd r25,Y+9
	or r24,r25
	ldd r18,Y+10
	or r24,r18
	ldd r20,Y+11
	or r24,r20
	ldd r25,Y+12
	or r24,r25
	ldd r18,Y+13
	or r24,r18
	ldd r20,Y+14
	or r24,r20
	ldd r25,Y+15
	or r24,r25
	ldd r18,Y+16
	or r24,r18
	ldd r20,Y+17
	or r24,r20
	ldd r25,Y+1
	ldd r18,Y+2
	or r25,r18
	ldd r20,Y+3
	or r25,r20
	or r25,r17
	ldd r18,Y+19
	or r25,r18
	or r24,r25
	ldi r17,lo8(1)
	cpse r24,__zero_reg__
	rjmp .L88
	ldi r17,0
.L88:
	call SCHED_Init
	cp r24, __zero_reg__
	brne .+2
	rjmp .L90
.L92:
	ldi r20,lo8(1)
	std Y+1,r20
.L91:
	ldi r22,lo8(.LC14)
	ldi r23,hi8(.LC14)
	ldi r24,0
	call LCD_Paint
	ldi r22,lo8(.LC15)
	ldi r23,hi8(.LC15)
	ldi r24,lo8(1)
	call LCD_Paint
	call LOT_Run
	call DISPLAY_Task
	call TMR0_Start
/* #APP */
 ;  639 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(.LC16)
	ldi r25,hi8(.LC16)
	call USART_SendString
	ldd r20,Y+18
	mov r24,r20
	ldi r25,0
	call MAIN_SendUint16
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
	ldi r24,lo8(.LC17)
	ldi r25,hi8(.LC17)
	call MAIN_SendEvent
	ldi r24,lo8(.LC18)
	ldi r25,hi8(.LC18)
	call MAIN_SendEvent
	ldd r24,Y+1
	cp r24, __zero_reg__
	breq .L98
	ldi r24,lo8(1)
	call LOT_SetFault
	ldi r24,lo8(.LC19)
	ldi r25,hi8(.LC19)
	call MAIN_SendEvent
.L98:
	in r19,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r18,g_u8TickFlag
	sts g_u8TickFlag,__zero_reg__
	lds r24,g_u8TickOverrun
	cp r24, __zero_reg__
	breq .L96
	sts g_u8TickOverrun,__zero_reg__
	lds r24,g_u16OverrunCnt
	lds r25,g_u16OverrunCnt+1
	cpi r24,-1
	cpc r25,r24
	breq .L96
	adiw r24,1
	sts g_u16OverrunCnt,r24
	sts g_u16OverrunCnt+1,r25
.L96:
	out __SREG__,r19
	cp r18, __zero_reg__
	breq .L98
	call SCHED_Tick
	rjmp .L98
.L100:
	ldi r17,lo8(1)
	rjmp .L88
.L90:
	ldi r20,0
	ldi r21,0
	ldi r22,lo8(1)
	ldi r23,0
	ldi r24,lo8(gs(Task_Lanes))
	ldi r25,hi8(gs(Task_Lanes))
	call SCHED_RegisterTask
	std Y+1,r24
	ldi r20,0
	ldi r21,0
	ldi r22,lo8(1)
	ldi r23,0
	ldi r24,lo8(gs(Task_Buttons))
	ldi r25,hi8(gs(Task_Buttons))
	call SCHED_RegisterTask
	std Y+2,r24
	ldi r20,lo8(1)
	ldi r21,0
	ldi r22,lo8(5)
	ldi r23,0
	ldi r24,lo8(gs(Task_Lot))
	ldi r25,hi8(gs(Task_Lot))
	call SCHED_RegisterTask
	std Y+3,r24
	ldi r20,lo8(3)
	ldi r21,0
	ldi r22,lo8(5)
	ldi r23,0
	ldi r24,lo8(gs(Task_Loops))
	ldi r25,hi8(gs(Task_Loops))
	call SCHED_RegisterTask
	std Y+4,r24
	ldi r20,lo8(4)
	ldi r21,0
	ldi r22,lo8(2)
	ldi r23,0
	ldi r24,lo8(gs(Task_Console))
	ldi r25,hi8(gs(Task_Console))
	call SCHED_RegisterTask
	std Y+5,r24
	ldi r20,lo8(5)
	ldi r21,0
	ldi r22,lo8(25)
	ldi r23,0
	ldi r24,lo8(gs(Task_Display))
	ldi r25,hi8(gs(Task_Display))
	call SCHED_RegisterTask
	std Y+6,r24
	ldi r20,lo8(7)
	ldi r21,0
	ldi r22,lo8(100)
	ldi r23,0
	ldi r24,lo8(gs(Task_1Hz))
	ldi r25,hi8(gs(Task_1Hz))
	call SCHED_RegisterTask
	std Y+7,r24
	ldi r20,lo8(11)
	ldi r21,0
	ldi r22,lo8(-12)
	ldi r23,lo8(1)
	ldi r24,lo8(gs(Task_Report))
	ldi r25,hi8(gs(Task_Report))
	call SCHED_RegisterTask
	cpse r24,__zero_reg__
	rjmp .L92
	ldd r24,Y+1
	ldd r25,Y+2
	or r24,r25
	ldd r18,Y+3
	or r24,r18
	ldd r20,Y+4
	or r24,r20
	ldd r25,Y+5
	or r24,r25
	ldd r18,Y+6
	or r24,r18
	ldd r20,Y+7
	or r24,r20
	ldi r25,lo8(1)
	std Y+1,r25
	cpse r24,__zero_reg__
	rjmp .L93
	std Y+1,__zero_reg__
.L93:
	ldd r18,Y+1
	or r18,r17
	std Y+1,r18
	rjmp .L91
	.size	main, .-main
	.section	.bss.g_u8LineOverflow,"aw",@nobits
	.type	g_u8LineOverflow, @object
	.size	g_u8LineOverflow, 1
g_u8LineOverflow:
	.zero	1
	.section	.bss.g_u8LinePos,"aw",@nobits
	.type	g_u8LinePos, @object
	.size	g_u8LinePos, 1
g_u8LinePos:
	.zero	1
	.section	.bss.g_acLine,"aw",@nobits
	.type	g_acLine, @object
	.size	g_acLine, 26
g_acLine:
	.zero	26
	.section	.bss.g_u8MismatchLogged,"aw",@nobits
	.type	g_u8MismatchLogged, @object
	.size	g_u8MismatchLogged, 1
g_u8MismatchLogged:
	.zero	1
	.section	.bss.g_u8MismatchSec,"aw",@nobits
	.type	g_u8MismatchSec, @object
	.size	g_u8MismatchSec, 1
g_u8MismatchSec:
	.zero	1
	.section	.bss.g_u8InMaintenance,"aw",@nobits
	.type	g_u8InMaintenance, @object
	.size	g_u8InMaintenance, 1
g_u8InMaintenance:
	.zero	1
	.section	.bss.g_PrevExitState,"aw",@nobits
	.type	g_PrevExitState, @object
	.size	g_PrevExitState, 2
g_PrevExitState:
	.zero	2
	.section	.bss.g_PrevEntryState,"aw",@nobits
	.type	g_PrevEntryState, @object
	.size	g_PrevEntryState, 2
g_PrevEntryState:
	.zero	2
	.section	.bss.g_PrevLotState,"aw",@nobits
	.type	g_PrevLotState, @object
	.size	g_PrevLotState, 2
g_PrevLotState:
	.zero	2
	.section	.data.g_u8PrevFullSign,"aw"
	.type	g_u8PrevFullSign, @object
	.size	g_u8PrevFullSign, 1
g_u8PrevFullSign:
	.byte	-1
	.section	.bss.g_u16ExitBtnHold,"aw",@nobits
	.type	g_u16ExitBtnHold, @object
	.size	g_u16ExitBtnHold, 2
g_u16ExitBtnHold:
	.zero	2
	.section	.bss.g_u8PrevMaintBtn,"aw",@nobits
	.type	g_u8PrevMaintBtn, @object
	.size	g_u8PrevMaintBtn, 1
g_u8PrevMaintBtn:
	.zero	1
	.section	.bss.g_exitLoop,"aw",@nobits
	.type	g_exitLoop, @object
	.size	g_exitLoop, 5
g_exitLoop:
	.zero	5
	.section	.bss.g_entryLoop,"aw",@nobits
	.type	g_entryLoop, @object
	.size	g_entryLoop, 5
g_entryLoop:
	.zero	5
	.section	.bss.g_u16OverrunCnt,"aw",@nobits
	.type	g_u16OverrunCnt, @object
	.size	g_u16OverrunCnt, 2
g_u16OverrunCnt:
	.zero	2
	.section	.bss.g_u8TickOverrun,"aw",@nobits
	.type	g_u8TickOverrun, @object
	.size	g_u8TickOverrun, 1
g_u8TickOverrun:
	.zero	1
	.section	.bss.g_u8TickFlag,"aw",@nobits
	.type	g_u8TickFlag, @object
	.size	g_u8TickFlag, 1
g_u8TickFlag:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
