  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30
loop:
	move	$a0,$s0		# copy from s0 to a0
	
	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window

	#addi	$s0,$s0,1	# what happens if the constant is changed?
	addi	$s0,$s0,3       # this is changed to add 3 in one go so to print every 3 letters
	
	#li	$t0,0x5b
	li	$t0,0x5d        #this is changed or else it would overshoot and cause the program to run on this is because z is 5a and when 3 is added it becomes 5d so that it would stop
	# as the program adds one more time after the print is done
	bne	$s0,$t0,loop
	nop			# delay slot filler (just in case)

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)

