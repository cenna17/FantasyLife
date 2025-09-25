
 .section .note.GNU-stack,""
 	.extern lab3
	.global abs_value
	.global power2
	.global hailstone_length

	.text

abs_value: 
cmp $0, %rdi 
jl calculate_twos_comp
mov %rdi, %rax

ret 

calculate_twos_comp: 
neg %rdi
mov %rdi, %rax
ret

power2: 
mov $1 %rdx
mov %rdx, %rbx
call print_uint64
ret

hailstone_length:
ret

