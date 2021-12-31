#
# Control flow test, depth 5
# Ian Johnson
#

# data section
.data
fibs:.word   0 : 19         # "array" of words to contain fib values
size: .word  19             # size of "array" (agrees with array declaration)

# code/instruction section
.text

main:
la   $s0, fibs
li   $s2, 1
sw   $s2, 0($s0)      
sw   $s2, 4($s0)     
lw   $s3, 0($s0)
lw   $s4, 4($s0)
beq $s4, $s3, end

add:
add $0, $0, $0
end:
halt
