 .section .note.GNU-stack,""
 	.extern lab4
	.global is_prime
	.global largest_power_unsigned
	.global overflowing_subtract
	.global dumb

	.text

is_prime: // n in rdi << check if n is prime or not
mov %rdi, %r12 #preserve n
mov $2, %rdi # factor
jmp loop
loop: 

####### check n % factor
mov $0, %rdx # %rdx store remainder
mov %r12, %rax
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
largest_power_unsigned:
ret
overflowing_subtract:
ret 
dumb: 
ret

