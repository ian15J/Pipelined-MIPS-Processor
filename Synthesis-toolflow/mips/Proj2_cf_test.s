#
# Control flow test, depth 5
# Ian Johnson
#

# data section
.data

# code/instruction section
.text

main:
li $a0, 6	#N = 6	
jal foo #foo(N)
j exit #exit

foo:
addi $sp, $sp, -8 #allocate stack frame
sw $ra, 0($sp)	#push $ra
sw $s0, 4($sp)	#push N

addi $s0, $a0, 0 #$s0 = $a0
addi $v0, $s0, 0 # else return N i.e (0)
beq $s0, $zero, return #if (N==0) return N

addi $a0, $s0, -1 #N-1
jal foo		  #foo(N-1)

add $v0, $v0, 1 # return foo(N-1) + 1

return:
lw $ra, 0($sp)	#pop $ra
lw $s0, 4($sp)	#pop $N
addi $sp, $sp, 8 #de-allocate stack frame
jr $ra

exit:
bne $v0, $v0, add1
bne $v0, $zero, end 

add1:
addi $v0, $v0, 1

end:
halt
