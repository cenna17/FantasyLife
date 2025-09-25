
 .section .note.GNU-stack,""
 	.extern lab3
	.global abs_value
	.global power2
	.global hailstone_length

	.text

abs_value: 
neg %rdi
add $1, %rdi
mov %rdi, %rax

ret

power2: 
ret

hailstone_length:
ret

