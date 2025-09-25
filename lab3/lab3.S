
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

power2: # %rdi is n => print 1, 2, 4, 2^n
# n is in %rdi
push %r14
mov $1, %r12 #init counter = 1
mov %rdi, %r13
mov $1, %r14 #init curr_sum
push %r12
push %r13
push %r14
jmp loop_start

loop_start:
pop %r12
pop %r14
cmp %r12, %r13 # if counter == n {return}
mov %r12, %rdi 
call print_uint64
mov %r13, %rdi 
call print_uint64
jg loop_end # IF-THEN

#ELSE
mov %r14, %rdi # curr_val = val_toBe_printed
call print_uint64
add $1, %r12 #counter ++ 
add %r14, %r14 # double num
push %r12
push %r14
jmp loop_start


loop_end: 
#pop %r14
pop %r13
#pop %r12
ret

hailstone_length:
#%rdi = n
mov %rdi, %r12
mov $0, %r13 #init len = 0
push %r12
push %r13

call while_start

while_start: 
cmp $1, %r12
je while_end 

add $1, %r13
shr $1, %r12
and 



while_end:
pop %r13
pop %r12
mov %r13, %rax
ret

