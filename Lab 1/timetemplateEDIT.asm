  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #

time2string:
addi $a0, $a0, 5 # start from right side and prime the target to the 6th byte of adrress
PUSH $ra
PUSH $a0
PUSH $t1
addi $a0, $0, 10 # adds null to remove rest of text
jal hexasc
POP $t1
POP $a0
POP $ra
sb $v0, 0($a0) # store return value to registry address 

addi $t2, $0, 4 # loop initializer 
addi $t3, $0, 2 # special case
addi $t5, $0, 0 # time digit shifter bit number
Loop:
addi $a0, $a0, -1 # move registry address so that they don't overwrite the previous one
PUSH $ra
PUSH $a0
PUSH $t1
PUSH $t2 # can save t3, t4, t5 as well to be sure
beq $t2, $t3, Colon # special case for colon
add $a0, $0, $a1 # loads the clock into argument a0
#sll $a0, $a0, 28 # one way
#srl $a0, $a0, 28
srlv $a0, $a0, $t5 # shift it right by multiples of 4 to load other numbers
andi $a0, $a0, 0xf # a way to only use the ls byte
jal hexasc
addi $t5, $t5, 4 # shift number right by one to load the rest of number
Continue:
POP $t2
POP $t1
POP $a0
POP $ra
sb $v0, 0($a0) # store return value to registry address 
slt $t4, $0, $t2 # loop checker
addi $t2, $t2, -1 # decrementer of initializer
bne $0, $t4, Loop # loop if still in loop

jr $ra

Colon: # special case for colon
add $a0, $0, 68
jal hexasc
j Continue

delay:
jr $ra
nop

hexasc:
addi $t1, $0, 10 # variable to check if x >= 10 or x < 10
slt $t0, $a0, $t1 # 1 if a0 < t1 or parameter < 10
beq $0, $t0, more # jump if more checks if 0 = $t0
addi $a0, $a0, 0x30 # add 30 hex to get correct ascii code
j less
more:
#addi $a0, $a0, 0x37 # note it is in hec therefore 10 dec + 37 hex = 41 hex
addi $t2, $a0, -10 # subtract 10 to get desired ascci
add $a0, $0, $t2
less:
add $v0, $a0, $0 # put a0 into the return variable
jr $ra # jump back
