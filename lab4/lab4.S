 .section .note.GNU-stack,""
 	.extern lab4
	.global is_prime
	.global largest_power_unsigned
	.global overflowing_subtract
	.global dumb

	.text
largest_power_unsigned: #what is P st P = n^k does not cause overflow
push %r12
mov %rdi, %r12 #save n
jmp update_product

update_product: 
mov %rdi, %rax
mul %r12

jo return_Upower
mov %rax, %rdi
jmp update_product

return_Upower: 
mov %rdi, %rax
pop %r12
ret

is_prime: // n in rdi << check if n is prime or not
mov %rdi, %r12 #preserve n
mov $2, %rdi # factor
jmp loop
loop: 

####### check n % factor
mov $0, %rdx # %rdx store remainder
mov %r12, %rax # %rax stores quotient; as in Q*factor + R = num
div %rdi
######
cmp $0, %rdx
je isPrimeFALSE

add $1, %rdi
cmp %rdi, %r12
je isPrimeTRUE

jmp loop



ret 

isPrimeFALSE: 
mov $0, %rax
ret

isPrimeTRUE: 
mov $1, %rax
ret 
overflowing_subtract:
ret 
dumb: 
ret

