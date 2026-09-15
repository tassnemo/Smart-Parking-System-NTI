	.file	"lot_fsm.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LOT_Init,"ax",@progbits
.global	LOT_Init
	.type	LOT_Init, @function
LOT_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_LotState,__zero_reg__
	sts g_LotState+1,__zero_reg__
	sts g_u8SlotMap,__zero_reg__
	ldi r24,lo8(6)
	sts g_u8FreeSlots,r24
	sts g_u8OccupiedSlots,__zero_reg__
/* epilogue start */
	ret
	.size	LOT_Init, .-LOT_Init
	.section	.text.LOT_Run,"ax",@progbits
.global	LOT_Run
	.type	LOT_Run, @function
LOT_Run:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call SLOT_Poll
	cp r24, __zero_reg__
	breq .L3
	ldi r24,lo8(4)
.L6:
	sts g_LotState,r24
	sts g_LotState+1,__zero_reg__
.L2:
/* epilogue start */
	ret
.L3:
	call SLOT_GetMap
	sts g_u8SlotMap,r24
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
	sts g_u8OccupiedSlots,r24
	ldi r25,lo8(6)
	sub r25,r24
	sts g_u8FreeSlots,r25
	lds r18,g_LotState
	lds r19,g_LotState+1
	subi r18,3
	sbc r19,__zero_reg__
	cpi r18,2
	cpc r19,__zero_reg__
	brlo .L2
	cpi r24,lo8(6)
	brne .L5
	ldi r24,lo8(2)
	rjmp .L6
.L5:
	ldi r24,lo8(1)
	rjmp .L6
	.size	LOT_Run, .-LOT_Run
	.section	.text.LOT_GetMap,"ax",@progbits
.global	LOT_GetMap
	.type	LOT_GetMap, @function
LOT_GetMap:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8SlotMap
/* epilogue start */
	ret
	.size	LOT_GetMap, .-LOT_GetMap
	.section	.text.LOT_GetFree,"ax",@progbits
.global	LOT_GetFree
	.type	LOT_GetFree, @function
LOT_GetFree:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8FreeSlots
/* epilogue start */
	ret
	.size	LOT_GetFree, .-LOT_GetFree
	.section	.text.LOT_GetOccupied,"ax",@progbits
.global	LOT_GetOccupied
	.type	LOT_GetOccupied, @function
LOT_GetOccupied:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_u8OccupiedSlots
/* epilogue start */
	ret
	.size	LOT_GetOccupied, .-LOT_GetOccupied
	.section	.text.LOT_GetState,"ax",@progbits
.global	LOT_GetState
	.type	LOT_GetState, @function
LOT_GetState:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_LotState
	lds r25,g_LotState+1
/* epilogue start */
	ret
	.size	LOT_GetState, .-LOT_GetState
	.section	.text.LOT_CanAuthoriseEntry,"ax",@progbits
.global	LOT_CanAuthoriseEntry
	.type	LOT_CanAuthoriseEntry, @function
LOT_CanAuthoriseEntry:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_LotState
	lds r25,g_LotState+1
	sbiw r24,1
	brne .L14
	ldi r24,lo8(1)
	lds r25,g_u8FreeSlots
	cpse r25,__zero_reg__
	rjmp .L12
.L14:
	ldi r24,0
.L12:
/* epilogue start */
	ret
	.size	LOT_CanAuthoriseEntry, .-LOT_CanAuthoriseEntry
	.section	.text.LOT_SetMaintenance,"ax",@progbits
.global	LOT_SetMaintenance
	.type	LOT_SetMaintenance, @function
LOT_SetMaintenance:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpse r24,__zero_reg__
	rjmp .L18
	lds r24,g_u8FreeSlots
	cpse r24,__zero_reg__
	rjmp .L19
	ldi r24,lo8(2)
.L16:
	sts g_LotState,r24
	sts g_LotState+1,__zero_reg__
/* epilogue start */
	ret
.L19:
	ldi r24,lo8(1)
	rjmp .L16
.L18:
	ldi r24,lo8(3)
	rjmp .L16
	.size	LOT_SetMaintenance, .-LOT_SetMaintenance
	.section	.text.LOT_SetFault,"ax",@progbits
.global	LOT_SetFault
	.type	LOT_SetFault, @function
LOT_SetFault:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpse r24,__zero_reg__
	rjmp .L23
	lds r24,g_u8FreeSlots
	cpse r24,__zero_reg__
	rjmp .L24
	ldi r24,lo8(2)
.L21:
	sts g_LotState,r24
	sts g_LotState+1,__zero_reg__
/* epilogue start */
	ret
.L24:
	ldi r24,lo8(1)
	rjmp .L21
.L23:
	ldi r24,lo8(4)
	rjmp .L21
	.size	LOT_SetFault, .-LOT_SetFault
	.section	.bss.g_u8OccupiedSlots,"aw",@nobits
	.type	g_u8OccupiedSlots, @object
	.size	g_u8OccupiedSlots, 1
g_u8OccupiedSlots:
	.zero	1
	.section	.data.g_u8FreeSlots,"aw"
	.type	g_u8FreeSlots, @object
	.size	g_u8FreeSlots, 1
g_u8FreeSlots:
	.byte	6
	.section	.bss.g_u8SlotMap,"aw",@nobits
	.type	g_u8SlotMap, @object
	.size	g_u8SlotMap, 1
g_u8SlotMap:
	.zero	1
	.section	.bss.g_LotState,"aw",@nobits
	.type	g_LotState, @object
	.size	g_LotState, 2
g_LotState:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
