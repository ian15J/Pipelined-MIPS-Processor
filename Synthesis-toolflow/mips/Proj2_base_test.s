#Project 2 Base Test

.data


.text

main:
addi $t0, $t0, 50  #Set t0 to 50

add $t0, $t0, $t0 #Add $t0 to itself

addiu $t1, $t1, 75 #Add 75 to $t1

and $t2, $t0, $t1# And $t0 & $t1 = 64

andi $t3 $t1 11 #And $t1 & 11 = 11

lui $t4, 1001 #Load 1001 to the upper 16 bits x'03E9000' 

nor $t6, $t0, $t1# Nor $t0 nor $t1

xor $t1 $t0, $t6 #xor $t0 xor $t6 

xori $t2, $t1, 32 # $t1 xori 32

or $t1, $t1, $t2# $t1 or $t2

ori $t2, $t2, 24# $t2 ori 24 

slt $t7, $t1, $t2 # if $t1 < $t2, $t7 = 1, 0 otherwise

slti $t7, $t2, 1000 # if $t2 < 1000, $t7 = 1, 0 otherwise

sll $t2, $t2, 2# $t2 = $t2 * 2^2 

srl $t2, $t2 2 # $t2 = $t2 / 2 ^ 2 

sra $t2, $t2, 3# $t2 >> 3 

sw $t2, ($sp) #Store $t2 into memory
lw $t0,($sp)	#Load 4 bytes 

sub $t2, $t2, $0	 # 1011 - 0 = 1011

subu $t2, $t2, $0 # 1011 - 0 = 1011

repl.qb $t1, 16 # replicate the value 10010000 into all 32 bits

exit:
halt
