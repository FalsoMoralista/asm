.data		

	# Other
	.equ clear, 0x01 #Clear display -> '00000001'
	cenario: .word, 0,0,0,1,0,0,0,1,1,0,0,0,1,1,1,1

	# LCD Initialization commands
	.equ init1, 0b00111000 # 38 function set 2 line
	.equ init2, 0b00111001 # 39 extendsion mode
	.equ init3, 0b00010100 # 14 OSC frequency
	.equ init4, 0b01011110 # 5e Icon display on booster circuit on
	.equ init5, 0b01101101 # 6a follower circuit on with 010=
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
	.equ control_btn, 0x3030 # colocar o endereço do botão # (Play/Pause/Start) control
	.equ jump_btn, 0x3020


# Reserved registers:
# - r5: First block address.
# - r11: Jump button
# - r12: Start/pause/resume.
# - r6: Number of blocks.
# - r8: Save r5
# - r9: Used in order to clear last block from screen
# - r20: Jump flag

.global main
main: 

	addi r1, r0, 1
	addi r11, r0, jump_btn
	addi r12, r0, control_btn
	addi r6, r0, 3
	addi r10, r0, end_screen
	addi r10, r10, 0x80
	add r5, r0, r10
	addi r9, r0, 2
	call init
	call start_message
	call wait_start
	call clear_screen
	call draw_char
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
	addi r17, r0, 0x80
	addi r17, r17, 0x40
	addi r8, r0, 3
	bne r5, r17, move
	beq r5, r17, clear_final
	ret

move:
	addi r14, r0, block
	subi r5, r5, 1

	custom 0, r3, r0, r5
	
	custom 0, r3, r1, r14 # Draw the block
	custom 0, r3, r1, r14 # Draw the block	
	custom 0, r3, r1, r14 # Draw the block
	addi r14, r0, blank
	custom 0, r3, r1, r14 # Clear the last position	
	ret

clear_final: 
	blt r9, r0, set_last
	add r10, r5, r9
	custom 0, r3, r0, r10 # Moves the cursor to (r5 + r9)
	addi r14, r0, blank
	custom 0, r3, r1, r14 # Clear the last position
	subi r9, r9, 1
	add r25, r0, r31
	call half_delay	
	add r31, r0, r25
	ret




# Set cursor to [1][16] position.
set_last:
	addi r9, r0, 2
	addi r10, r0, end_screen
	addi r10, r10, 0x80
	custom 0, r3, r0, r10 # Move the cursor to [1][16]
	add r5, r0, r10
	br loop

half_delay:
	addi r15, r0, 16383
	addi r13, r0, 0
	addi r16, r0, 0
	addi r17, r0, 25
	br delay
set_delay:
	addi r15, r0, 32767
	addi r13, r0, 0
	addi r16, r0, 0
	addi r17, r0, 25
delay:
	addi r13, r13, 1
	bne r15, r13, delay
contadorDelay:
	addi r16, r16, 1
	addi r13, r0, 0
	bne r16, r17, delay
	ret	

# Moves the terrain towards to the character (stay in loop untill user input).
loop:
	call read_jmp
	call move_terrain
	call set_delay
	call check_bottom_block
	br loop

read_jmp:
	beq r7, r1, return	
	ldw r4, 0(r11) # Read from the control push button
	beq r4, r1, jump	# Branches if equal to 1
	ret

return:
	ret	
jump:
	addi r7, r0, 1
	addi r14, r0, down_row
	addi r14, r14, 0x80

	custom 0, r3, r0, r14

	addi r14, r0, blank
	custom 0, r3, r1, r14

	addi r14, r0, 0x0	
	addi r14, r14, 0x80

	custom 0, r3, r0, r14

	addi r14, r0, char
	custom 0, r3, r1, r14	
	ret

down:
	addi r14, r0, 0x0
	addi r14, r14, 0x80

	custom 0, r3, r0, r14

	addi r14, r0, blank
	custom 0, r3, r1, r14

	addi r14, r0, down_row	
	addi r14, r14, 0x80

	custom 0, r3, r0, r14

	addi r14, r0, char
	custom 0, r3, r1, r14
	addi r7, r0, 0
	br loop

	
check_bottom_block:
	addi r14, r0, down_row
	addi r14, r14, 0x80
	bne r5, r14, down
	bne r7, r1, game_over
	br loop

game_over:
	br end

# Read from push button, if equal to 1, exit.
read_btn:
	addi r12, r0, control_btn
	ldw r12, 0(r12) # Read from the control push button
	beq r12, r1, end	# Branches back if equal to 1
	ret

clear_screen:
	movia r14, clear
	custom 0, r3, r0, r14
	ret

end:
	br end
