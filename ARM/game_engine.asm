.data
.equ fopen, 5
.equ ioctl, 54

lcd_driver: .asciz "/dev/lcd_1602"


// lcd api
.equ clear, 1
.text
.global main
main:
	b init_display
init_display: // Clear the display
	ldr r0, =lcd_driver
	mov r1, #0
	mov r2, #00700
	ldr r7, =fopen
	swi 0 // call for file opening

	ldr r7, =ioctl

	mov r5, r0 // file descriptor for lcd driver
	ldr r1, =clear
	
	swi 0 // call for clear display
end:

