addi $a0, $0, 10 # parameter ms = a0
addi $t1, $0, 5 # loop cap
addi $t2, $0, 0 # check while

while:
addi $t0, $0, 0 # int i = 0
addi $t3, $0, 0 # check for

for:
slt $t3, $t0, $t1 # 1 if t0 < t1, 0 if t0 => t1
nop
addi $t0, $t0, 1
bne $t3, $0, for 

slt $t2, $0, $a0 # 1 if 0 < a0, 0 if  0 => a0
addi $a0, $a0, -1 # ms - 1
bne $0, $t2, while 

#jr $ra