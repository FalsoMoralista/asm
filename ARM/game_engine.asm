.data
.equ fopen, 5
.equ ioctl, 54
.equ position, 40


line0: .word 2
lcd_driver: .asciz "/dev/lcd_1602"

// LCD api operation op codes
.equ clear, 1
.equ set_address, 9

.text
.global main
main:
	b init_display

init_display: // Clear the display, and places cursor on bottom
bl open_device_file
bl clear_display
mov r10, #0
bl set_cursor

b end

open_device_file: // Opens device file and saves the file descriptor over R6
ldr r0, =lcd_driver
mov r1, #0 // Flags
mov r2, #00700 // Operation flag
ldr r7, =fopen // Syscall no.
swi 0 // Call for file opening.
mov r6, r0 // Saves file descriptor over r6.
bx lr

clear_display: // Clears the LCD Display.
mov r0, r6 // Gets the device file descriptor
ldr r7, =ioctl // I/O control syscall
ldr r1, =clear // Arg1: device clear operation
swi 0
bx lr

set_cursor: // Sends the cursor to a position passed by parameter
ldr r5,=line0 // Gets the pointer to the "array" where x position value is stored
add r5, r5, #1 // Increment by 1
//mov r10, #1 // todo receive r10 as parameter
str r10, [r5] // Stores the value that contained on r10
ldr r2,=line0 // Loads the ptr back after storing the y position value
mov r0, r6 // Gets the device file descriptor (syscall arg)
ldr r7, =ioctl // I/O Control syscall (syscall arg)
ldr r1, =set_address // Set x_y lcd address operation (syscall arg)
swi 0
bx lr
end:
b end
