 .section .note.GNU-stack,""
 	.extern lab4
	.global is_prime
	.global largest_power_unsigned
	.global overflowing_subtract
	.global dumb

	.text
dumb: # %rdi = a; %rsi = b
mov $0, %rax
push %rdi #save a
push %rsi #save b

jmp recursive_dumb

recursive_dumb: 
pop %rsi
pop %rdi

cmp $0, %rdi #base: ?a == 0
je return_B_PLUS_ONE
cmp $0, %rsi #base: ?b == 0
je return_A

# add a+a+b to sum
add %rdi, %rax
add %rdi, %rax
add %rsi, %rax
sub $1, %rdi
sub $1, %rsi
push %rdi
push %rsi

jmp recursive_dumb

return_B_PLUS_ONE:
add $1, %rsi
add %rsi, %rax
ret 

return_A:
add %rdi, %rax
ret 

overflowing_subtract:# %rdi = a; %rsi = b => return a-b OR zero on overflow
sub %rsi, %rdi
jo returnZERO
mov %rdi, %rax
ret

returnZERO: 
mov $0, %rax
ret

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

isPrimeFALSE: 
mov $0, %rax
ret

isPrimeTRUE: 
mov $1, %rax
ret 
