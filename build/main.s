	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC0:
	.string	"I2C TEST START\r\n"
.LC1:
	.string	"I2C INIT FAILED\r\n"
.LC2:
	.string	"I2C START OK\r\n"
.LC3:
	.string	"I2C DEVICE ACK\r\n"
.LC4:
	.string	"I2C DEVICE NACK\r\n"
.LC5:
	.string	"I2C START FAILED\r\n"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call USART_Init
/* #APP */
 ;  10 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call USART_SendString
	call I2C_Init
	cp r24, __zero_reg__
	breq .L2
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call USART_SendString
.L2:
	call I2C_Start
	cpse r24,__zero_reg__
	rjmp .L3
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call USART_SendString
	ldi r24,lo8(64)
	call I2C_Write
	cpse r24,__zero_reg__
	rjmp .L4
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
.L11:
	call USART_SendString
	call I2C_Stop
.L6:
.L10:
	rjmp .L10
.L4:
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	rjmp .L11
.L3:
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	call USART_SendString
	rjmp .L6
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
