.data
.equ fopen, 4 
.equ ioctl, 54

lcd_driver: .asciz "/dev/lcd_1602"


// lcd api
.equ clear, 1

init_display:
	ldr r0, =lcd_driver 
	mov r1, #0 
	mov r2, #00700
	ldr r7, =fopen 
	swi 0 // call for file opening

	ldr r7, =ioctl 	
	mov r5, r0 // file descriptor for lcd driver
	ldr r1, =clear
	swi 0 // call for clear display
