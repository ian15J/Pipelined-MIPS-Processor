.data
values: .word 10,3,6,8,30,19,2,1,-33,22

.text

main:
li $t0, 0 # initialize i counter to 0
li $t1, 0 # initalize j counter to 0
la $s0, values #Load address of array of numbers
li $s1, 9 #n - 1
li $s2, 10 #n to be iterated on 

loop1:
li $t1, 0 #Reinitalize j = 0 
addi $s2, $s2, -1 #Size of innter loop n-i-1
add $t3, $0, $s0 # reset
loop2:
lw $s3, 0($t3) #load values[j]

addi $t3, $t3, 4 #increment address 
lw $s4, 0($t3) #load values[j+1]
addi $t1, $t1, 1 #j++
slt $t4, $s3, $s4    # $t4 = 1 when s3 < s4, 0 otherwsie
bne $t4, $zero, loop2cond
swapvals:           #Swaps the values of $s3 and $s4
sw $s3, 0($t3)
sw $s4, -4($t3)

 lw $s4, 0($t3)
loop2cond:
bne $t1, $s2, loop2
addi $t0, $t0, 1  # i++
bne $t0, $s1, loop1     

li $t0, 0
addi $s1, $s1, 1

exit:
halt
