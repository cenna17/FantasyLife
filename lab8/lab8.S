
 .section .note.GNU-stack,""
 	.extern lab8
	.global hailstone_length_cmov
	.global hailstone_length

	.text

hailstone_length_cmov:
    mov $0, %rcx #counter = 0
    jmp loop_cmov

loop_cmov:
    cmp $1, %rdi # check: n == 1 ??
    je ret_cmov_len

    mov %rdi, %rax # set rax = n
    mov %rdi, %r8 #set r8 = n

    shr $1, %r8 #r8 = n/2

    imul $3, %rax, %rax #rax = 3n
    add  $1, %rax #rax = 3n + 1

    test $1, %rdi # n && 1 => checks last bit to see if its 0 (even) or 1 (odd
    cmovnz %rax, %rdi # n = 3n+1 on odd
    cmovz  %r8, %rdi #n = n/2 on even

    add $1, %rcx
    jmp loop_cmov

ret_cmov_len:
    mov %rcx, %rax
    ret

hailstone_length: # Given integer n: IF EVEN => n = n/2; IF_ODD, n = 3n+1.
mov $0, %rsi #set length = 0

test $1, %rdi # BITWISE AND WITH N - 0 if even; 1 if odd

jnz odd # zero-flag output 1 if odd => jnz (jump if not zero) => DO IF ODD
jz even

even: #rdi - n    rsi = length
cmp $0, %rdi #BASE CASE
je return_length

shr $1, %rdi #Divide n by 2
add $1, %rsi

test $1, %rdi # BITWISE AND WITH N - 0 if even; 1 if odd

jnz odd # zero-flag output 1 if odd => jnz (jump if not zero) => DO IF ODD
jz even

odd: #receives odd # n in rdi
cmp $1, %rdi
je return_length

imul $3, %rdi
add $1, %rdi

add $1, %rsi

jmp even

return_length: 
mov %rsi, %rax
ret 

