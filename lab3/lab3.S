
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
   mov %rdi, %r12 #rdi -> arg1 (holds n)
   mov $0, %rsi #rsi -> arg2 (counter)
   mov $1, %rdx #rdx -> arg3 (sum)
   jmp loop

loop:

cmp %rsi, %r12
jl loop
jg loop_end

mov %rdx, %rdi
push %rsi
push %rdx
call print_uint64
pop %rdx
pop %rsi
add $1, %rsi # counter+= 1
add %rdx, %rdx
jmp loop

loop_end:
ret 

hailstone_length:
ret
