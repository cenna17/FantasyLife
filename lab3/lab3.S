
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
   mov $1, %rdx #rdx -> arg3 (sum)
   jmp loop

loop:
cmp $0, %r12 # if n < 0
jl loop_end  # TRUE -> END 
mov %rdx, %rdi #ELSE -> RESUME FROM HERE
push %rdx # save sum in case print fcn changes it
call print_uint64 #print sum
pop %rdx #load sum
add %rdx, %rdx # double sum
sub $1, %r12 # countdown n
jmp loop

loop_end:
ret 

hailstone_length:
ret
