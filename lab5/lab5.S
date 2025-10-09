.section .note.GNU-stack,""
.extern lab5
.text

.global polynomial1
.global polynomial2
.global polynomial3

.global is_odd1
.global is_odd2
.global is_odd3

.global mul1
.global mul2
.global mul3


polynomial1: ret

polynomial2: ret

polynomial3: ret


is_odd1: ret

is_odd2: ret

is_odd3: ret


mul1: ret

mul2: ret

mul3: ret


.global fibonacci
fibonacci: #rdi = n
mov %rdi, %rbx # save n
mov $0, %rax # sum = 0

#init x+y=next_fib_num {0,1}
mov $0, %rdi #init x = 0
mov $1, %rsi #init y = 1
push %rdi #save x
push %rsi #save y

mov $1, %rdx #counter = 1
jmp fib_RECURSIVE

fib_RECURSIVE:
pop %rsi #load y
pop %rdi #load x

cmp $0, %rbx 
je RETURN_ZERO
cmp $1, %rbx
je RETURN_ONE
cmp %rdx, %rbx
je RETURN_SUM

#SUM = x + y
add %rsi, %rax
add %rdi, %rax

add $1, %rdx #counter++
mov %rsi, %rdi
mov %rax, %rsi
push %rdi
push %rsi

RETURN_ZERO:
ret 
RETURN_ONE:
mov $1, %rax
ret 

RETURN_SUM:
ret 




