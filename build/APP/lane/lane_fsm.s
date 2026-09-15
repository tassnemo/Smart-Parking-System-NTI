	.file	"lane_fsm.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LANE_Init,"ax",@progbits
.global	LANE_Init
	.type	LANE_Init, @function
LANE_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	mov r24,r22
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+2,__zero_reg__
	std Z+3,__zero_reg__
	std Z+4,__zero_reg__
	std Z+5,r22
	std Z+6,r20
	std Z+7,__zero_reg__
	std Z+8,__zero_reg__
	std Z+9,__zero_reg__
	jmp BAR_Close
	.size	LANE_Init, .-LANE_Init
	.section	.text.LANE_Run,"ax",@progbits
.global	LANE_Run
	.type	LANE_Run, @function
LANE_Run:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	ld r30,Y
	ldd r31,Y+1
	cpi r30,9
	cpc r31,__zero_reg__
	brsh .L3
	subi r30,lo8(-(gs(.L5)))
	sbci r31,hi8(-(gs(.L5)))
	jmp __tablejump2__
	.section	.jumptables.gcc.LANE_Run,"a",@progbits
	.p2align	1
	.type	.L5, @object
.L5:
	.word gs(.L13)
	.word gs(.L12)
	.word gs(.L11)
	.word gs(.L10)
	.word gs(.L9)
	.word gs(.L8)
	.word gs(.L7)
	.word gs(.L6)
	.word gs(.L4)
	.section	.text.LANE_Run
.L13:
	ldd r24,Y+4
	cp r24, __zero_reg__
	breq .L2
	ldi r24,lo8(20)
	std Y+2,r24
	std Y+3,__zero_reg__
	ldi r24,lo8(1)
.L27:
	st Y,r24
	std Y+1,__zero_reg__
.L2:
/* epilogue start */
	pop r29
	pop r28
	ret
.L12:
	ldd r24,Y+4
	cpse r24,__zero_reg__
	rjmp .L16
.L3:
	st Y,__zero_reg__
	std Y+1,__zero_reg__
	rjmp .L2
.L16:
	ldd r24,Y+2
	ldd r25,Y+3
	sbiw r24,1
	std Y+2,r24
	std Y+3,r25
	or r24,r25
	brne .L2
	ldi r24,lo8(2)
	rjmp .L27
.L11:
	ldd r24,Y+6
	cp r24, __zero_reg__
	breq .L18
	call LOT_CanAuthoriseEntry
	cp r24, __zero_reg__
	breq .L19
	call TKT_OnEntryAuthorized
.L28:
	ldd r24,Y+5
	call BAR_Open
	ldi r24,lo8(100)
	std Y+2,r24
	std Y+3,__zero_reg__
	ldi r24,lo8(3)
	rjmp .L27
.L19:
	ldi r24,lo8(7)
	call BUZ_On
	ldi r24,lo8(-56)
	std Y+2,r24
	std Y+3,__zero_reg__
	ldi r24,lo8(7)
	rjmp .L27
.L18:
	call BIL_OnExitAuthorized
	rjmp .L28
.L6:
	ldd r24,Y+2
	ldd r25,Y+3
	sbiw r24,1
	std Y+2,r24
	std Y+3,r25
	or r24,r25
	brne .L2
	ldi r24,lo8(7)
	call BUZ_Off
	rjmp .L3
.L10:
	ldd r24,Y+2
	ldd r25,Y+3
	sbiw r24,1
	breq .L20
	std Y+2,r24
	std Y+3,r25
	rjmp .L2
.L20:
	ldi r24,lo8(-12)
	ldi r25,lo8(1)
	std Y+2,r24
	std Y+3,r25
	ldi r24,lo8(4)
	rjmp .L27
.L9:
	ldd r24,Y+4
	cp r24, __zero_reg__
	breq .L29
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	std Y+2,r24
	std Y+3,r25
	ldi r24,lo8(5)
	rjmp .L27
.L8:
	ldd r24,Y+4
	cpse r24,__zero_reg__
	rjmp .L22
	ldd r24,Y+7
	ldd r25,Y+8
	adiw r24,1
	std Y+7,r24
	std Y+8,r25
.L29:
	ldd r24,Y+5
	call BAR_Close
	ldi r24,lo8(100)
	std Y+2,r24
	std Y+3,__zero_reg__
	ldi r24,lo8(6)
	rjmp .L27
.L22:
	ldd r24,Y+2
	ldd r25,Y+3
	sbiw r24,1
	std Y+2,r24
	std Y+3,r25
	or r24,r25
	breq .+2
	rjmp .L2
	ldi r24,lo8(1)
	std Y+9,r24
	ldd r24,Y+5
	call BAR_Close
	ldi r20,lo8(100)
	ldi r21,0
	ldi r22,lo8(3)
	ldi r24,lo8(7)
	call BUZ_Beep
	ldi r24,lo8(8)
	rjmp .L27
.L7:
	ldd r24,Y+2
	ldd r25,Y+3
	sbiw r24,1
	std Y+2,r24
	std Y+3,r25
	or r24,r25
	brne .+2
	rjmp .L3
	rjmp .L2
.L4:
	ldd r24,Y+4
	cpse r24,__zero_reg__
	rjmp .L2
	std Y+9,__zero_reg__
	rjmp .L3
	.size	LANE_Run, .-LANE_Run
	.section	.text.LANE_RequestOpen,"ax",@progbits
.global	LANE_RequestOpen
	.type	LANE_RequestOpen, @function
LANE_RequestOpen:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	std Z+4,r22
/* epilogue start */
	ret
	.size	LANE_RequestOpen, .-LANE_RequestOpen
	.section	.text.LANE_GetState,"ax",@progbits
.global	LANE_GetState
	.type	LANE_GetState, @function
LANE_GetState:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ld r24,Z
	ldd r25,Z+1
/* epilogue start */
	ret
	.size	LANE_GetState, .-LANE_GetState
.global	g_exitLane
	.section	.bss.g_exitLane,"aw",@nobits
	.type	g_exitLane, @object
	.size	g_exitLane, 10
g_exitLane:
	.zero	10
.global	g_entryLane
	.section	.bss.g_entryLane,"aw",@nobits
	.type	g_entryLane, @object
	.size	g_entryLane, 10
g_entryLane:
	.zero	10
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
