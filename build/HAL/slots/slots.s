	.file	"slots.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SLOT_Init,"ax",@progbits
.global	SLOT_Init
	.type	SLOT_Init, @function
SLOT_Init:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	sts g_slotMap,__zero_reg__
	sts g_lastRawMap,__zero_reg__
	sts g_stableCount,__zero_reg__
	ldi r28,lo8(2)
.L3:
	ldi r20,lo8(2)
	mov r22,r28
	ldi r24,lo8(2)
	call DIO_Init
	cpse r24,__zero_reg__
	rjmp .L4
	subi r28,lo8(-(1))
	cpi r28,lo8(8)
	brne .L3
.L1:
/* epilogue start */
	pop r28
	ret
.L4:
	ldi r24,lo8(1)
	rjmp .L1
	.size	SLOT_Init, .-SLOT_Init
	.section	.text.SLOT_Poll,"ax",@progbits
.global	SLOT_Poll
	.type	SLOT_Poll, @function
SLOT_Poll:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,lo8(2)
	call DIO_ReadPort
	ldd r24,Y+1
	com r24
	lsr r24
	lsr r24
	lds r25,g_lastRawMap
	cpse r25,r24
	rjmp .L7
	lds r25,g_stableCount
	cpse r25,__zero_reg__
	rjmp .L8
	ldi r25,lo8(1)
	sts g_stableCount,r25
.L8:
	sts g_slotMap,r24
	rjmp .L10
.L7:
	sts g_lastRawMap,r24
	sts g_stableCount,__zero_reg__
.L10:
	ldi r24,0
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	SLOT_Poll, .-SLOT_Poll
	.section	.text.SLOT_GetMap,"ax",@progbits
.global	SLOT_GetMap
	.type	SLOT_GetMap, @function
SLOT_GetMap:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_slotMap
/* epilogue start */
	ret
	.size	SLOT_GetMap, .-SLOT_GetMap
	.section	.text.SLOT_CountFree,"ax",@progbits
.global	SLOT_CountFree
	.type	SLOT_CountFree, @function
SLOT_CountFree:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	andi r24,lo8(63)
	mov r25,r24
	lsr r25
	andi r25,lo8(85)
	sub r24,r25
	mov r25,r24
	andi r25,lo8(51)
	lsr r24
	lsr r24
	andi r24,lo8(51)
	add r25,r24
	mov r24,r25
	swap r24
	andi r24,lo8(15)
	add r24,r25
	andi r24,lo8(15)
	ldi r25,lo8(6)
	sub r25,r24
	mov r24,r25
/* epilogue start */
	ret
	.size	SLOT_CountFree, .-SLOT_CountFree
	.section	.text.SLOT_IsOccupied,"ax",@progbits
.global	SLOT_IsOccupied
	.type	SLOT_IsOccupied, @function
SLOT_IsOccupied:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r22,lo8(6)
	brsh .L16
	ldi r18,lo8(1)
	ldi r19,0
	movw r20,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r22
	brpl 1b
	mov r22,r20
	and r22,r24
	ldi r24,lo8(1)
	cpse r22,__zero_reg__
	rjmp .L13
.L16:
	ldi r24,0
.L13:
/* epilogue start */
	ret
	.size	SLOT_IsOccupied, .-SLOT_IsOccupied
	.section	.bss.g_stableCount,"aw",@nobits
	.type	g_stableCount, @object
	.size	g_stableCount, 1
g_stableCount:
	.zero	1
	.section	.bss.g_lastRawMap,"aw",@nobits
	.type	g_lastRawMap, @object
	.size	g_lastRawMap, 1
g_lastRawMap:
	.zero	1
	.section	.bss.g_slotMap,"aw",@nobits
	.type	g_slotMap, @object
	.size	g_slotMap, 1
g_slotMap:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
