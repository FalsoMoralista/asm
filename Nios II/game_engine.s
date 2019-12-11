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
	.equ upper_row, 0b00000010 # Address [0][0] 
	.equ last_up, 0x0F # Last column first row  [0][16]
	.equ down_row, 0x40 # Address '40' [1][0]
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
	.equ char, 0b00011010
	.equ zero, 0b00110000
	.equ nine, 0b00111001
	# Push button addresses:
	.equ control_btn, 0x3010 # colocar o endereço do botão # (Play/Pause/Start) control
#	.equ jump, 0x0000


# Reserved registers:
# - r5: First block address.


.global main
main: 

	addi r1, r0, 1

	call init
	call start_message
	call wait_start
	call clear_screen
	call draw_char
	call draw_block
	call loop

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
wait_start:
	addi r10, r0, control_btn
	ldw r10, 0(r10) # Read from the control push button
	bne r10, r1, wait_start	# Branches back if not equal to 1
	ret

############ Draw Functions #################
draw_block2:
		beq r7, r0, backToEnd
		br move_terrain
backToEnd:
		movia r7, end_screen

# Draw the block to the last bottom position of the screen.
draw_block:
	addi r10, r0, end_screen
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Move the cursor to [1][16]
	addi r14, r0, block
	custom 0, r3, r1, r14 # Draw the block
	add r5, r0, r10
	ret

# Draw the score on the up last position of the screen.
draw_score:
	addi r15, r0, zero
	custom 0, r3, r1, r15
	ret

# Updates the score.
update_score:
#	addi r14, r0, nine
#	beq r15, r14, draw_extra_number 
	addi r14, r0, last_up
	addi r14, r14, 0x80
	custom 0, r3, r0, r14 # Put the cursor on the position [0][16]
	addi r15, r15, 0b1 
	custom 0, r3, r1, r15
	ret

# This will be used to draw an extra digit to the score (when an overflow was caused).  
draw_extra_number:
	ret

draw_char:
	addi r10, r0, 0x40
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Put the cursor on [1][0]
	addi r14, r0, char
	custom 0, r3, r1, r14 # Put the character on the first bottom position of the scrren
	ret

#############################################
move_terrain:
#	addi r14, r0, down_row
#	bne r5, r14, move
	add r2, r0, r31
	call move
#	add r10, r0, r7
#	addi r3, r0, 0b10100000
#	custom 0, r3, r1, r3
#	addi r10, r10, 0x80
#	custom 0, r3, r0, r10 # Put the cursor on the last bottom position of the scrren
	#addi r14, r0, block
#	custom 0, r3, r1, r14
#	subi r7, r7, 1
#	addi r14, r14, 1
	add r31, r0, r2
	ret

move:
	custom 0, r3, r0, r5 # Put the cursor on the first block position

	addi r14, r0, blank
	custom 0, r3, r1, r14

	addi r10, r0, down_row
	addi r10, r10, 0x80
	beq r5, r10, set_last

	subi r5, r5, 1
	custom 0, r3, r0, r5
	
	addi r14, r0, block
	custom 0, r3, r1, r14
	ret

# Set cursor to [1][16] position.
set_last:
	addi r10, r0, end_screen
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Move the cursor to [1][16]
	add r5, r0, r10
	br loop

delay:
	addi r13, r13, 1
	bne r15, r13, delay
contadorDelay:
	addi r16, r16, 1
	addi r13, r0, 0
	bne r16, r17, delay
	br loop	

# Moves the terrain towards to the character (stay in loop untill user input).
loop:
	call move_terrain
	addi r15, r0, 32767
	addi r13, r0, 0
	addi r16, r0, 0
	addi r17, r0, 25
	call delay		
	br loop

draw_terrain:
	
# Read from push button, if equal to 1, exit.
read_btn:
	addi r10, r0, control_btn
	ldw r10, 0(r10) # Read from the control push button
	beq r10, r1, end	# Branches back if equal to 1
	ret

clear_screen:
	movia r14, clear
	custom 0, r3, r0, r14
	ret

end:
	br end