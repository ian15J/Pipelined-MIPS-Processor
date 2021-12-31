#
# Control flow test, depth 5
# Ian Johnson
#

# data section
.data

# code/instruction section
.text

main:

foo:
jal end
addi $sp, $sp, -8 #allocate stack frame
sw $ra, 0($sp)	#push $ra
end:
halt
