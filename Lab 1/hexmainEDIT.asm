  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	#li	$a0,0		# change this to test different values
        li	$a0,1
        
	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #

#ascii to hex 0 = 30 
#ascii A = 41
#need to print 0 to 9 then A to F 

hexasc:
add $a0, $0, $a0 # parameter only use 4 lsb the rest ignored (Incorrect and redundant)
#sll $a0, $a0, 28
#srl $a0, $a0, 28 or
#andi $a0, $a0, 0xf
addi $t1, $0, 10 # variable to check if x >= 10 or x < 10
slt $t0, $a0, $t1 # 1 if a0 < t1 or parameter < 10
beq $0, $t0, more # jump if more checks if 0 = $t0
addi $a0, $a0, 0x30 # add 30 hex to get correct ascii code
j less
more:
addi $a0, $a0, 0x37 # note it is in hec therefore 10 dec + 37 hex = 41 hex
less:
add $v0, $a0, $0 # put a0 into the return variable
jr $ra # jump back
