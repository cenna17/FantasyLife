.section .note.GNU-stack, ""
.global multiply_add
.text

multiply_add:

mov %rdx, %rax # move c to accumulator
imul %rsi, %rax # x acc value by b
add  %rdi, %rax # add a to acc


ret 

