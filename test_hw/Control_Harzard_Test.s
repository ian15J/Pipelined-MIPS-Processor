.data


.text

main:
li $t0, 0 
li $t1, 0 
lui $1, 50
lui $ra, 50

ori $s0, $1, 0
addiu $s1, $0, 9
addiu $s2, $0, 10

loop1:
addiu $t1, $0, 0
addi $s2, $s2, -1 

add $t3, $0, $s0

loop2:
lw $s3, 0($t3) 

addi $t3, $t3, 4 

lw $s4, 0($t3) 
addi $t1, $t1, 1 

slt $t4, $s3, $s4    

bne $t4, $zero, loop2cond

loop4:         
sw $s3, 0($t3)
sw $s4, -4($t3)
lw $s4, 0($t3)

loop2cond:
bne $t1, $s2, loop2
addi $t0, $t0, 1  

bne $t0, $s1, loop1     

addi $s1, $s1, 1





exit:
halt
