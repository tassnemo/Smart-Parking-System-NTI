	.file	"softrtc.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.RTC_Tick10ms,"ax",@progbits
.global	RTC_Tick10ms
	.type	RTC_Tick10ms, @function
RTC_Tick10ms:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8SubTick
	subi r24,lo8(-(1))
	cpi r24,lo8(100)
	brsh .L2
	sts g_u8SubTick,r24
	ret
.L2:
	sts g_u8SubTick,__zero_reg__
	lds r24,g_u32UptimeSec
	lds r25,g_u32UptimeSec+1
	lds r26,g_u32UptimeSec+2
	lds r27,g_u32UptimeSec+3
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sts g_u32UptimeSec,r24
	sts g_u32UptimeSec+1,r25
	sts g_u32UptimeSec+2,r26
	sts g_u32UptimeSec+3,r27
/* epilogue start */
	ret
	.size	RTC_Tick10ms, .-RTC_Tick10ms
	.section	.text.RTC_Seconds,"ax",@progbits
.global	RTC_Seconds
	.type	RTC_Seconds, @function
RTC_Seconds:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r18,__SREG__
/* #APP */
 ;  50 "C:/avr-gcc/avr/include/util/atomic.h" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r22,g_u32UptimeSec
	lds r23,g_u32UptimeSec+1
	lds r24,g_u32UptimeSec+2
	lds r25,g_u32UptimeSec+3
	out __SREG__,r18
/* epilogue start */
	ret
	.size	RTC_Seconds, .-RTC_Seconds
	.section	.text.RTC_Format,"ax",@progbits
.global	RTC_Format
	.type	RTC_Format, @function
RTC_Format:
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
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
/* stack size = 19 */
.L__stack_usage = 19
	std Y+1,r22
	std Y+2,r23
	std Y+3,r24
	std Y+4,r25
	std Y+10,r20
	std Y+11,r21
	or r20,r21
	brne .+2
	rjmp .L8
	cpi r18,lo8(10)
	brsh .+2
	rjmp .L8
	ldi r18,lo8(16)
	ldi r19,lo8(14)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	std Y+5,r18
	std Y+6,r19
	std Y+7,r20
	std Y+8,r21
	ldi r18,lo8(60)
	mov r12,r18
	mov r13,__zero_reg__
	mov r14,__zero_reg__
	mov r15,__zero_reg__
	movw r20,r14
	movw r18,r12
	call __udivmodsi4
	std Y+9,r18
	ldd r22,Y+1
	ldd r23,Y+2
	ldd r24,Y+3
	ldd r25,Y+4
	movw r20,r14
	movw r18,r12
	call __udivmodsi4
	mov r11,r22
	ldd r22,Y+1
	ldd r23,Y+2
	ldd r24,Y+3
	ldd r25,Y+4
	ldi r18,lo8(64)
	ldi r19,lo8(126)
	ldi r20,lo8(5)
	ldi r21,0
	call __udivmodsi4
	ldi r22,lo8(10)
	mov r12,r22
	movw r22,r18
	movw r24,r20
	movw r20,r14
	movw r18,r12
	call __udivmodsi4
	subi r22,lo8(-(48))
	ldd r30,Y+10
	ldd r31,Y+11
	st Z,r22
	ldd r22,Y+5
	ldd r23,Y+6
	ldd r24,Y+7
	ldd r25,Y+8
	movw r20,r14
	movw r18,r12
	call __udivmodsi4
	mov r10,r22
	movw r22,r18
	movw r24,r20
	movw r20,r14
	movw r18,r12
	call __udivmodsi4
	subi r22,lo8(-(48))
	ldd r30,Y+10
	ldd r31,Y+11
	std Z+1,r22
	ldi r24,lo8(48)
	add r24,r10
	std Z+2,r24
	ldi r19,lo8(58)
	std Z+3,r19
	ldd r24,Y+9
	ldi r22,lo8(10)
	call __udivmodqi4
	subi r24,lo8(-(48))
	std Z+4,r24
	subi r25,lo8(-(48))
	std Z+5,r25
	std Z+6,r19
	mov r24,r11
	call __udivmodqi4
	subi r24,lo8(-(48))
	std Z+7,r24
	subi r25,lo8(-(48))
	std Z+8,r25
	std Z+9,__zero_reg__
	ldi r24,0
.L5:
/* epilogue start */
	adiw r28,11
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	ret
.L8:
	ldi r24,lo8(1)
	rjmp .L5
	.size	RTC_Format, .-RTC_Format
	.section	.bss.g_u8SubTick,"aw",@nobits
	.type	g_u8SubTick, @object
	.size	g_u8SubTick, 1
g_u8SubTick:
	.zero	1
	.section	.bss.g_u32UptimeSec,"aw",@nobits
	.type	g_u32UptimeSec, @object
	.size	g_u32UptimeSec, 4
g_u32UptimeSec:
	.zero	4
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
