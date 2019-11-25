

main: 
	br start


# Starts the LCD Display
start:
	addi r1, r0, 1
	addi r2, r0, 2064 # Leds base address
	addi r3, r0, 0x00000850 # Dip[0] base address
	br wait_for_start

# 	addi r1, r0, 0b00111000
# 	addi r2, r0, 0
# 	addi r3, r0, 1

# 	custom 0, r2, r0, r1 # function set
# 	custom 0, r2, r0, r1 # function set
# 	addi r1, r0, 0b00010100 
#  	custom 0, r2, r0, r1 # osc freq
# 	addi r1, r0, 0b01011110 
#  	custom 0, r2, r0, r1 # power icon
# 	addi r1, r0, 0b01101101 
#  	custom 0, r2, r0, r1 # follower control
# 	addi r1, r0, 0b01110000 
#  	custom 0, r2, r0, r1 # contrast
# 	addi r1, r0, 0b00001100 
#  	custom 0, r2, r0, r1 # display on
# 	addi r1, r0, 0b00000110 
#  	custom 0, r2, r0, r1 # entry mode lr
# 	addi r1, r0, 0b00000001 
#  	custom 0, r2, r0, r1 #Cleaning the LCD


# In this label we will display a message and 
# wait for the user input in order to start the game
wait_for_start:
#	addi r1, r0, 0x0F # 0x0F = ASCII for "0"
#	custom 0, r2, r3, r1 #Send data to lcd
	ldw r4, 0(r3)
	beq r4, r1, game_loop  # If DIP[0] = 1
	br -12

game_loop:
	addi r5, r0, 1 # Character 
	addi r6, r0, 8 # Led counter
	addi r7, r0, 2 # Counter limit
	addi r8, r0, 0x00000850 # DIP[1] 

shift_scenario:
	bne r6,r1, 8 # If r6 != 1 
	ldw r8, 0(r8) # Gets dip level
	beq r8, r0, game_over # If DIP[1] == 0 => Game Over
	# Else: 
	beq r6, r1, game_loop # Check if the led is in the last position, if so, reset
	stw r6,0(r2)
	roli r6, r6, -1

delay:
	addi r20, r0, 550
	addi r21, r0, 0
	beq r21, r20, shift_scenario
	add r21, r21, r1
	br -12

game_over:
	stw r1, 0(r2)

