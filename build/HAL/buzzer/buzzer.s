	.file	"buzzer.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BUZ_Init,"ax",@progbits
.global	BUZ_Init
	.type	BUZ_Init, @function
BUZ_Init:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	cpi r24,lo8(7)
	breq .L2
.L4:
	ldi r24,lo8(1)
.L1:
/* epilogue start */
	pop r28
	ret
.L2:
	call TONE_Init
	cpse r24,__zero_reg__
	rjmp .L4
	sts g_buzPin,r28
	sts g_buzActive,__zero_reg__
	sts g_buzState,__zero_reg__
	sts g_buzBeepCount,__zero_reg__
	sts g_buzTargetBeepCount,__zero_reg__
	rjmp .L1
	.size	BUZ_Init, .-BUZ_Init
	.section	.text.BUZ_On,"ax",@progbits
.global	BUZ_On
	.type	BUZ_On, @function
BUZ_On:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(7)
	brne .L6
	jmp TONE_Start
.L6:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	BUZ_On, .-BUZ_On
	.section	.text.BUZ_Off,"ax",@progbits
.global	BUZ_Off
	.type	BUZ_Off, @function
BUZ_Off:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(7)
	brne .L8
	jmp TONE_Stop
.L8:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	BUZ_Off, .-BUZ_Off
	.section	.text.BUZ_Beep,"ax",@progbits
.global	BUZ_Beep
	.type	BUZ_Beep, @function
BUZ_Beep:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	mov r19,r22
	lds r25,g_buzActive
	cpi r25,lo8(1)
	breq .L9
	cp r22, __zero_reg__
	breq .L14
	cp r20,__zero_reg__
	cpc r21,__zero_reg__
	breq .L14
	lds r18,g_buzPin
	cpse r18,r24
	rjmp .L14
	movw r24,r20
	ldi r22,lo8(10)
	ldi r23,0
	call __udivmodhi4
	or r24,r25
	brne .L14
	ldi r24,lo8(1)
	sts g_buzActive,r24
	sts g_buzState,r24
	sts g_buzBeepCount,__zero_reg__
	sts g_buzTargetBeepCount,r19
	sts g_buzTickCount,__zero_reg__
	sts g_buzTickCount+1,__zero_reg__
	sts g_buzTicksPerPhase,r22
	sts g_buzTicksPerPhase+1,r23
	mov r24,r18
	call BUZ_On
	ldi r25,0
.L9:
	mov r24,r25
/* epilogue start */
	ret
.L14:
	ldi r25,lo8(1)
	rjmp .L9
	.size	BUZ_Beep, .-BUZ_Beep
	.section	.text.BUZ_Update,"ax",@progbits
.global	BUZ_Update
	.type	BUZ_Update, @function
BUZ_Update:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_buzActive
	cp r24, __zero_reg__
	breq .L20
	lds r24,g_buzTickCount
	lds r25,g_buzTickCount+1
	adiw r24,1
	sts g_buzTickCount,r24
	sts g_buzTickCount+1,r25
	lds r18,g_buzTicksPerPhase
	lds r19,g_buzTicksPerPhase+1
	cp r24,r18
	cpc r25,r19
	brlo .L20
	sts g_buzTickCount,__zero_reg__
	sts g_buzTickCount+1,__zero_reg__
	lds r24,g_buzState
	cpi r24,lo8(1)
	brne .L22
	lds r24,g_buzPin
	call BUZ_Off
	sts g_buzState,__zero_reg__
	lds r24,g_buzBeepCount
	subi r24,lo8(-(1))
	sts g_buzBeepCount,r24
.L20:
	ldi r24,0
/* epilogue start */
	ret
.L22:
	lds r25,g_buzBeepCount
	lds r24,g_buzTargetBeepCount
	cp r25,r24
	brlo .L23
	sts g_buzActive,__zero_reg__
	rjmp .L20
.L23:
	lds r24,g_buzPin
	call BUZ_On
	ldi r24,lo8(1)
	sts g_buzState,r24
	rjmp .L20
	.size	BUZ_Update, .-BUZ_Update
	.section	.bss.g_buzTicksPerPhase,"aw",@nobits
	.type	g_buzTicksPerPhase, @object
	.size	g_buzTicksPerPhase, 2
g_buzTicksPerPhase:
	.zero	2
	.section	.bss.g_buzTickCount,"aw",@nobits
	.type	g_buzTickCount, @object
	.size	g_buzTickCount, 2
g_buzTickCount:
	.zero	2
	.section	.bss.g_buzTargetBeepCount,"aw",@nobits
	.type	g_buzTargetBeepCount, @object
	.size	g_buzTargetBeepCount, 1
g_buzTargetBeepCount:
	.zero	1
	.section	.bss.g_buzBeepCount,"aw",@nobits
	.type	g_buzBeepCount, @object
	.size	g_buzBeepCount, 1
g_buzBeepCount:
	.zero	1
	.section	.bss.g_buzState,"aw",@nobits
	.type	g_buzState, @object
	.size	g_buzState, 1
g_buzState:
	.zero	1
	.section	.bss.g_buzActive,"aw",@nobits
	.type	g_buzActive, @object
	.size	g_buzActive, 1
g_buzActive:
	.zero	1
	.section	.bss.g_buzPin,"aw",@nobits
	.type	g_buzPin, @object
	.size	g_buzPin, 1
g_buzPin:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
