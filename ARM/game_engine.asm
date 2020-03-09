.data
// SYSCALLS
.equ fopen, 5
.equ ioctl, 54
.equ nanosleep, 162


line0: .word 2
lcd_driver: .asciz "/dev/lcd_1602"
character: .ascii "{"
block: .ascii "#"
blank: .ascii " "
line1: .word 1
line3: .word 1
g: .ascii "G"
a: .ascii "a"
m: .ascii "m"
e: .ascii "e"
capital_o: .ascii "O"
v: .ascii "v"
r: .ascii "r"

halfp1sec:	.long 0
		.long 299999999
// LCD api operation op codes
.equ clear, 1
.equ set_address, 9
.equ send_char, 3

.text
.global main
// reserved: r4 (control loop) r13 (pc); r14 (link register), r8 (block current addr) ,r9 (current block length) TODO REVIEW
// Temporary: r10 (function args); r11 (saving return addresses)
main: // Config and start game
	bl init_display
	mov r8, #16
	mov r9, #1
	mov r4, #0
	b game_loop
	b end

pre_set:
	mov r4, #0
game_loop:
	cmp r9, r4
	beq pre_set
	bl move_terrain
	bl delay
	b game_loop

move_terrain:
	push {r14} // Save the current return address
	bl check_collision
	b move
move:
	cmp r9, r4
	beq return
	sub r8, #1
	mov r10, r8
	bl set_cursor
	ldr r10, =block
	bl send_character
	add r10, r8, r9
	bl set_cursor
	ldr r10, =blank
	bl send_character
	add r4, r4, #1
	b return
return:
	pop {r14}
	bx lr

check_collision:
	mov r10, #0
	cmp r8, r10
	beq game_over
	bx lr

game_over:
	bl display_message
	b end
display_message:
	push {r14}
	mov r10, #0
	bl set_cursor
	ldr r10, =blank
	bl send_character
	mov r10, #5
	bl set_cursor_y
	ldr r10, =g
	bl send_character
	ldr r10, =a
	bl send_character
	ldr r10, =m
	bl send_character
	ldr r10, =e
	bl send_character
	mov r10, #5
	bl set_cursor
	ldr r10, =capital_o
	bl send_character
	ldr r10, =v
	bl send_character
	ldr r10, =e
	bl send_character
	ldr r10, =r
	bl send_character
	pop {r14}
	bx lr

delay:
	ldr r7, =nanosleep
	ldr r0, =halfp1sec
	mov r1, #0
	swi 0
	bx lr

// todo commment
init_display: // Clear the display, and places cursor on bottom
	mov r11, r14
	bl open_device_file
	bl clear_display
	mov r10, #0
	bl set_cursor
	ldr r10, =character
	bl send_character
	mov r14, r11
	bx lr

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

set_cursor_y:
	ldr r5, =line1
	add r5, r5, #1
	str r10, [r5]
	ldr r2, =line1
	mov r0, r6
	ldr r7, =ioctl
	ldr r1, =set_address
	swi 0
	bx lr

set_cursor: // Sends the cursor to a position passed by parameter (r10)
	ldr r5,=line0 // Gets the pointer to the "array" where x position value is stored
	add r5, r5, #1 // Increment by 1
	str r10, [r5] // Stores the value that contained on r10
	ldr r2,=line0 // Loads the ptr back after storing the y position value
	mov r0, r6 // Gets the device file descriptor (syscall arg)
	ldr r7, =ioctl // I/O Control syscall (syscall arg)
	ldr r1, =set_address // Set x_y lcd address operation (syscall arg)
	swi 0
	bx lr

send_character: // Send a character passed by parameter (r10)
	mov r0, r6 // gets fd from device file
	ldr r7, =ioctl // ioctl operation
	ldr r1, =send_char // lcd driver opcode
	mov r2, r10 // gets character passed by parameter
	swi 0
	bx lr

end:
	b end
