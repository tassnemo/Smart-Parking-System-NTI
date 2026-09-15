	.file	"scheduler.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SCHED_Init,"ax",@progbits
.global	SCHED_Init
	.type	SCHED_Init, @function
SCHED_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(g_tasks)
	ldi r31,hi8(g_tasks)
.L2:
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+2,__zero_reg__
	std Z+3,__zero_reg__
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	adiw r30,7
	ldi r24,hi8(g_tasks+84)
	cpi r30,lo8(g_tasks+84)
	cpc r31,r24
	brne .L2
	sts g_taskCount,__zero_reg__
	sts g_tickCount,__zero_reg__
	sts g_tickCount+1,__zero_reg__
	sts g_tickCount+2,__zero_reg__
	sts g_tickCount+3,__zero_reg__
	ldi r24,0
/* epilogue start */
	ret
	.size	SCHED_Init, .-SCHED_Init
	.section	.text.SCHED_RegisterTask,"ax",@progbits
.global	SCHED_RegisterTask
	.type	SCHED_RegisterTask, @function
SCHED_RegisterTask:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r18,r24
	or r24,r25
	breq .L8
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L8
	lds r25,g_taskCount
	cpi r25,lo8(12)
	brsh .L8
	ldi r24,lo8(7)
	mul r25,r24
	movw r30,r0
	clr __zero_reg__
	subi r30,lo8(-(g_tasks))
	sbci r31,hi8(-(g_tasks))
	st Z,r18
	std Z+1,r19
	std Z+2,r22
	std Z+3,r23
	std Z+4,r20
	std Z+5,r21
	ldi r24,lo8(1)
	std Z+6,r24
	subi r25,lo8(-(1))
	sts g_taskCount,r25
	ldi r24,0
	ret
.L8:
	ldi r24,lo8(1)
/* epilogue start */
	ret
	.size	SCHED_RegisterTask, .-SCHED_RegisterTask
	.section	.text.SCHED_Tick,"ax",@progbits
.global	SCHED_Tick
	.type	SCHED_Tick, @function
SCHED_Tick:
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 3 */
.L__stack_usage = 3
	lds r24,g_tickCount
	lds r25,g_tickCount+1
	lds r26,g_tickCount+2
	lds r27,g_tickCount+3
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sts g_tickCount,r24
	sts g_tickCount+1,r25
	sts g_tickCount+2,r26
	sts g_tickCount+3,r27
	ldi r17,0
.L10:
	lds r24,g_taskCount
	cp r17,r24
	brlo .L12
/* epilogue start */
	pop r29
	pop r28
	pop r17
	ret
.L12:
	ldi r24,lo8(7)
	mul r17,r24
	movw r28,r0
	clr __zero_reg__
	subi r28,lo8(-(g_tasks))
	sbci r29,hi8(-(g_tasks))
	ldd r24,Y+6
	cp r24, __zero_reg__
	breq .L11
	ldd r18,Y+4
	ldd r19,Y+5
	lds r22,g_tickCount
	lds r23,g_tickCount+1
	lds r24,g_tickCount+2
	lds r25,g_tickCount+3
	add r22,r18
	adc r23,r19
	adc r24,__zero_reg__
	adc r25,__zero_reg__
	ldd r18,Y+2
	ldd r19,Y+3
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	or r22,r23
	or r22,r24
	or r22,r25
	brne .L11
	ld r30,Y
	ldd r31,Y+1
	icall
.L11:
	subi r17,lo8(-(1))
	rjmp .L10
	.size	SCHED_Tick, .-SCHED_Tick
	.section	.text.SCHED_GetTickCount,"ax",@progbits
.global	SCHED_GetTickCount
	.type	SCHED_GetTickCount, @function
SCHED_GetTickCount:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r22,g_tickCount
	lds r23,g_tickCount+1
	lds r24,g_tickCount+2
	lds r25,g_tickCount+3
/* epilogue start */
	ret
	.size	SCHED_GetTickCount, .-SCHED_GetTickCount
	.section	.bss.g_tickCount,"aw",@nobits
	.type	g_tickCount, @object
	.size	g_tickCount, 4
g_tickCount:
	.zero	4
	.section	.bss.g_taskCount,"aw",@nobits
	.type	g_taskCount, @object
	.size	g_taskCount, 1
g_taskCount:
	.zero	1
	.section	.bss.g_tasks,"aw",@nobits
	.type	g_tasks, @object
	.size	g_tasks, 84
g_tasks:
	.zero	84
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
