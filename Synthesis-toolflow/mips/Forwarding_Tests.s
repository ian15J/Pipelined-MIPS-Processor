.data


.text

main:
addi $t0, $t0, 50  

add $t1, $t1, $t1 

addiu $t2, $t2, 75 

and $t3, $0, $0

andi $t1 $t1 75

nor $t6, $t0, $t1

xor $t2 $t2, $0

xori $t1, $t1, 32 

ori $t6, $t6, 24

sub $t7, $t2, $0	 

subu $t1, $t2, $0



exit:
halt
