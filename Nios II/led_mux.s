.data
array: .word 1,0
.text

.global main
main:
	orhi r1, r0, 0
	addi r1, r1, 2064 # 2064 = endereço base dos leds

	orhi r4, r0, 0
	addi r4, r4, 16

	orhi r2, r0, 0
	addi r2, r2, 1
        
	orhi r5, r0, 0
	addi r5, r5, 1
               
	orhi r7, r0, 0
#	addi r7, r7, 0

	orhi r6, r0, 0
	addi r6, r6, 0x00000850
	
	orhi r8, r0, 0	 

leds:	
	ldw r8, 0(r6)
	stw r2, 0(r1) 
	muli r2, r2, 2
	beq r2, r4, reset
	br delay
		
reset:
	orhi r2, r0, 0
	addi r2, r2, 1
	br leds

delay:
	addi r7, r7, 1
	bne r7, r5, -8
	orhi r7, r0, 0
	br leds

#pause:
        
.end