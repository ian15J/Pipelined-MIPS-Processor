#Project 2 Base Test

.data


.text

main:
addi $t0, $t0, 50  

add $t1, $t1, $t1 

addiu $t2, $t2, 75 

and $t3, $0, $0

andi $t1 $t1 75

lui $t4, 1001 

nor $t6, $t0, $t1

xor $t2 $t2, $0

xori $t1, $t1, 32 

or $t3, $t4, $t5

ori $t6, $t6, 24

slt $t7, $t1, $t2

slti $t5, $t2, 1000 

sll $t0, $t4, 2

srl $t2, $t2 2  

sra $t1, $t1, 3

sw $t8, ($sp) 

lw $t9, ($sp)	

sub $t7, $t2, $0	 

subu $t1, $t2, $0 

repl.qb $t1, 16 

exit:
halt
