.data
values: .word 10,3,6,8,30,19,2,1,-33,22

.text

main:
li $t0, 0 # initialize i counter to 0
li $t1, 0 # initalize j counter to 0
lui $1, 4097
nop
nop
nop
nop
ori $s0, $1, 0
addiu $s1, $0, 9
addiu $s2, $0, 10
nop
nop
nop
loop1:
addiu $t1, $0, 0
addi $s2, $s2, -1 #Size of innter loop n-i-1
nop
nop
nop
nop
add $t3, $0, $s0
loop2:
lw $s3, 0($t3) #load values[j]
nop
nop
nop
nop
nop
addi $t3, $t3, 4 #increment address 
nop
nop
nop
nop
nop
lw $s4, 0($t3) #load values[j+1]
addi $t1, $t1, 1 #j++
nop
nop
slt $t4, $s3, $s4    # $t4 = 1 when s3 < s4, 0 otherwsie
nop
nop
nop
nop
nop
bne $t4, $zero, loop2cond

swapvals:           #Swaps the values of $s3 and $s4
sw $s3, 0($t3)
sw $s4, -4($t3)
 lw $s4, 0($t3)

loop2cond:
bne $t1, $s2, loop2
addi $t0, $t0, 1  # i++
nop
nop
nop
nop
bne $t0, $s1, loop1     
nop
nop
nop
nop
addi $s1, $s1, 1
exit:
halt


