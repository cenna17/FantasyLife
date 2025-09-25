
 .section .note.GNU-stack,""
 	.extern lab3
	.global func_name

	.text

abs_value: 
neg %rdi
add $1 %rdi
mv %rdi, %rax

ret

