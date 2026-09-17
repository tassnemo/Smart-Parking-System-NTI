	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TASK_SlotsWrapper,"ax",@progbits
	.type	TASK_SlotsWrapper, @function
TASK_SlotsWrapper:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp SLOT_Poll
	.size	TASK_SlotsWrapper, .-TASK_SlotsWrapper
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC0:
	.string	"!EVT,BOOT\r\n"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 1 */
.L__stack_usage = 1
	call SLOT_Init
	call LED_Init
	call SEG_Init
	call LCD_Init
	call LOT_Init
	call DISPLAY_Init
	call TKT_Init
	call USART_Init
	ldi r20,lo8(2)
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call DIO_Init
	call SCHED_Init
	ldi r20,0
	ldi r21,0
	ldi r22,lo8(1)
	ldi r23,0
	ldi r24,lo8(gs(TASK_SlotsWrapper))
	ldi r25,hi8(gs(TASK_SlotsWrapper))
	call SCHED_RegisterTask
	ldi r20,lo8(1)
	ldi r21,0
	movw r22,r20
	ldi r24,lo8(gs(LOT_Run))
	ldi r25,hi8(gs(LOT_Run))
	call SCHED_RegisterTask
	ldi r20,lo8(5)
	ldi r21,0
	ldi r22,lo8(25)
	ldi r23,0
	ldi r24,lo8(gs(DISPLAY_Task))
	ldi r25,hi8(gs(DISPLAY_Task))
	call SCHED_RegisterTask
	ldi r20,lo8(2)
	ldi r21,0
	ldi r22,lo8(1)
	ldi r23,0
	ldi r24,lo8(gs(RTC_Tick10ms))
	ldi r25,hi8(gs(RTC_Tick10ms))
	call SCHED_RegisterTask
/* #APP */
 ;  81 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call USART_SendString
	ldi r17,lo8(1)
.L9:
	ldi r24,lo8(19999)
	ldi r25,hi8(19999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	call SCHED_Tick
	std Y+1,r17
	movw r20,r28
	subi r20,-1
	sbci r21,-1
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call DIO_ReadPin
	ldd r24,Y+1
	cpse r24,__zero_reg__
	rjmp .L3
	lds r24,Local_u8LowCount.1
	cpi r24,lo8(3)
	brlo .L4
.L7:
	lds r24,Local_u8Armed.0
	cp r24, __zero_reg__
	breq .L9
	call TKT_OnEntryAuthorized
	sts Local_u8Armed.0,__zero_reg__
	rjmp .L9
.L4:
	subi r24,lo8(-(1))
	sts Local_u8LowCount.1,r24
	cpi r24,lo8(3)
	brne .L9
	rjmp .L7
.L3:
	sts Local_u8LowCount.1,__zero_reg__
	sts Local_u8Armed.0,r17
	rjmp .L9
	.size	main, .-main
	.section	.data.Local_u8Armed.0,"aw"
	.type	Local_u8Armed.0, @object
	.size	Local_u8Armed.0, 1
Local_u8Armed.0:
	.byte	1
	.section	.bss.Local_u8LowCount.1,"aw",@nobits
	.type	Local_u8LowCount.1, @object
	.size	Local_u8LowCount.1, 1
Local_u8LowCount.1:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
