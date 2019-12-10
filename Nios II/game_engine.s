.data		

	# Other
	.equ clear, 0x01 #Clear display -> '00000001'
	

	# LCD Initialization commands
	.equ init1, 0b00111000 # 38 function set 2 line
	.equ init2, 0b00111001 # 39 extendsion mode
	.equ init3, 0b00010100 # 14 OSC frequency
	.equ init4, 0b01011110 # 5e Icon display on booster circuit on
	.equ init5, 0b01101101 # 6a follower circuit on with 010
	.equ init6, 0b01110000 # 78 Contrast set for 1000
	.equ init7, 0b00001100 # c display on cursor off
	.equ init8, 0b00000110 # 6 Entry mode L/R
	.equ init9, 0b00000001 # 1 Clear

	# LCD DDRAM
	.equ upper_row, 0b00000010 # Address '00' 
	.equ down_row, 0b11000000 # Address '40'
	.equ end_screen, 0x4F

	#LCD Characters
	.equ blank, 0b10100000
	.equ capital_p, 0b01010000
	.equ r, 0b01110010
	.equ s, 0b01110011
	.equ i, 0b01101001
	.equ o, 0b01101111
	.equ n, 0b01101110
	.equ e, 0b01100101
	.equ capital_s, 0b01010011
	.equ t, 0b01110100
	.equ a, 0b01100001
	.equ block, 0b00100011
	.equ char, 0b00011111
	# Push button addresses:
	.equ control_btn, 0x3010 # colocar o endereço do botão # (Play/Pause/Start) control
#	.equ jump, 0x0000

.global main
main: 
	
	addi r1, r0, 1

	call init
	call start_message
	call wait_input

	movia r14, clear
	custom 0, r3, r0, r14

	call draw_block
	call draw_char
	br end
	
init:
		movia r14, init1
		custom 0, r3, r0, r14 #Limpar Busy Flag
		custom 0, r3, r0, r14 #
		movia r14, init2
		custom 0, r3, r0, r14
		movia r14, init3
		custom 0, r3, r0, r14
		movia r14, init4
		custom 0, r3, r0, r14
		movia r14, init5
		custom 0, r3, r0, r14
		movia r14, init6
		custom 0, r3, r0, r14
		movia r14, init7
		custom 0, r3, r0, r14
		movia r14, init8
		custom 0, r3, r0, r14
		movia r14, init9
		custom 0, r3, r0, r14
		movia r14, clear
		custom 0, r3, r0, r14

		ret # Retorna para a main	

# Writes a starting message and waits the user input to start the game.

start_message:

	# Write the first word to the upper row.
	addi r10, r0, 0x04
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Put the cursor on the 4th upper column

	addi r14, r0, capital_p
	custom 0, r3, r1, r14 # Writes down P over the 4th upper column

	addi r14, r0, r
	custom 0, r3, r1, r14 # Writes down r on the LCD

	addi r14, r0, e
	custom 0, r3, r1, r14 # Writes down e on the LCD

	addi r14, r0, s
	custom 0, r3, r1, r14 # Writes down s on the LCD

	addi r14, r0, s
	custom 0, r3, r1, r14 # Writes down s on the LCD

	addi r14, r0, i
	custom 0, r3, r1, r14 # Writes down i on the LCD

	addi r14, r0, o
	custom 0, r3, r1, r14 # Writes down o on the LCD

	addi r14, r0, n
	custom 0, r3, r1, r14 # Writes down s on the LCD
		
	addi r14, r0, e
	custom 0, r3, r1, r14 # Writes down e on the LCD

	# Writes down the second word

	addi r10, r0, 0x45	
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Put the cursor on the 6th down column
	
	addi r14, r0, capital_s
	custom 0, r3, r1, r14 # Writes down S over the 4th upper column

	addi r14, r0, t
	custom 0, r3, r1, r14 # Writes down t on the LCD

	addi r14, r0, a
	custom 0, r3, r1, r14 # Writes down a on the LCD

	addi r14, r0, r
	custom 0, r3, r1, r14 # Writes down t on the LCD

	addi r14, r0, t
	custom 0, r3, r1, r14 # Writes down t on the LCD
	ret

# Waits for the user to press the pushbutton.
wait_input:
	addi r10, r0, control_btn
	ldw r10, 0(r10) # Read from the control push button
	bne r10, r1, wait_input	# Branches back if not equal to 1
	ret

draw_block:
	addi r10, r0, end_screen
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Put the cursor on the last bottom position of the scrren
	addi r14, r0, block
	custom 0, r3, r1, r14
	ret

draw_char:
	addi r10, r0, 0x41
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Put the character on the first bottom position of the scrren
	addi r14, r0, block
	custom 0, r3, r1, r14
	ret



move_terrain:
	ret


delay:

	ret

# Moves the terrain towards to the character (stay in loop untill user input).
loop: 
	ldw r10, 0(r10) # Read from the control push button
		bne r10, r1, wait_input	# Branches back if not equal to 1


# Read from push button, if equal to 1, exit.
read_btn:
	addi r10, r0, control_btn
	ldw r10, 0(r10) # Read from the control push button
	beq r10, r1, end	# Branches back if equal to 1
	ret
end:
	br end