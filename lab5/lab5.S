.section .note.GNU-stack,""
.extern lab5
.text

.global fibonacci
.global polynomial1
.global polynomial2

.global is_odd1
.global is_odd2

.global mul1
.global mul2

fibonacci: #rdi = n
push %r12
mov %rdi, %r12 # save n

#init x+y=next_fib_num {0,1}
mov $0, %rcx
mov $0, %rdi #init x = 0
mov $1, %rsi #init y = 0
mov $1, %rdx #counter = 1

jmp fib_RECURSIVE

fib_RECURSIVE:
cmp $0, %r12 
je RETURN_ZERO
cmp $1, %r12
je RETURN_ONE
cmp %rdx, %r12
je RETURN_SUM

#SUM = x + y
push %rcx
add %rdi, %rcx
add %rsi, %rcx

mov %rsi, %rdi
mov %rcx, %rsi
pop %rcx
add $1, %rdx #counter++
jmp fib_RECURSIVE

RETURN_ZERO:
mov $0, %rax
pop %r12
ret 
RETURN_ONE:
pop %r12
mov $1, %rax
ret 

RETURN_SUM:
pop %r12
mov %rsi, %rax
ret 


#x=rdi a=rsi b=rdx c=rcx d=r8
polynomial1:
push %rbx
push %r12
mov %rdx, %r12
mov $0, %rbx

############## CALCULATE ax^3			x=rdi a=rsi b=rdx c=rcx d=r8
mov $1, %rax #curr = 1
mul %rdi #curr = x
mul %rdi #curr = x^2
mul %rdi #curr = x^3
mul %rsi #curr = ax^3
add %rax, %rbx #sum = ax^3

############### CALCULATE bx^2			x=rdi a=rsi b=rdx c=rcx d=r8
mov $1, %rax #curr = 1
mul %rdi #curr = x
mul %rdi #curr = x^2
mul %r12 #curr = bx^2
add %rax, %rbx #sum = ax^3 + bx^2

############## CALCULATE cx + d			x=rdi a=rsi b=rdx c=rcx d=r8
mov $1, %rax #curr = 1
mul %rdi #curr = x
mul %rcx #curr = cx
add %r8, %rax  #curr = cx + d
add %rax, %rbx #sum = ax^3 + bx^2 + cx + d
mov %rbx, %rax
pop %r12
pop %rbx
ret
polynomial2:
push %r12
mov %rdx, %r12
############### CALCULATE x(x(ax+b) + c) + d	x=rdi a=rsi b=rdx c=rcx d=r8
mov $1, %rax #curr = 1
mul %rdi #curr = x
mul %rsi #curr = ax
add %r12, %rax #curr = ax+b
mul %rdi #curr = x(ax+b)
add %rcx, %rax #curr = x(ax+b) + c
mul %rdi #curr = x(x(ax+b) + c)
add %r8, %rax  #curr = x(x(ax+b) + c) + d
pop %r12
ret

RETURN_EVEN: 
mov $0, %rax
ret

RETURN_ODD:
mov $1, %rax
ret

is_odd1:
mov $2, %r8
mov $0, %rdx #remainder
mov %rdi, %rax
idiv %r8

cmp $0, %rdx
je RETURN_EVEN
jmp RETURN_ODD

is_odd2:
and $1, %rdi
cmp $0, %rdi
je RETURN_EVEN
jmp RETURN_ODD

mul1:
push %rdx
mov %rdi, %rax
mov $65537, %rsi
mul %rsi
pop %rdx
ret

mul2: #123 x 65537 = 123 x (2^16 + 1) = 123 x 2^16 + 123
mov %rdi, %rsi 
shl $16, %rdi
add %rsi, %rdi

mov %rdi, %rax
ret


