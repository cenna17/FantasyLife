 .section .note.GNU-stack,""
 	.extern f

    .global _start
    .text

_calculate: #f(x,y) => rdi = 1st param AND rsi = 2nd param

###################################SETTING A
add $3 %rbx # x+3
mov %rbx, %rsi #set A as 2nd arg
mov %rsi, %rdx #remember A for later

###################################SETTING B
#RECALL A in RDX
# b = f(x,a) => want original x for 1st arg => x->pop->rdi && a->rsi
pop %rbx # get original X
mov %rbx, %rdi #get original X as 1st arg 
mov %rdx, %rsi #get A as 2nd arg 
push %rbx # store original A in stack for use later


#rdi and rsi are set, ready to call f(x,a)
call f #return stored to RAX
mov %rax, %rcx #store return value (B) to a free register - rdx
	      #(RDX happens to be non-preserved; thats okay, we don't need it to be preserved)

##################################SETTING C
#RECALL A in RDX && B in RCX
pop %rbx #get X value 
mov %rcx, %rdi #get B as 1st arg
mov %rbx, %rsi #get X as 2nd arg
call f #return stored to RAX
mov %rax %r8 #store return (C) to R8
push %rbx

##################################SETTING D
#RECALL A in RDX && B in RCX && C in R8
pop %rbx
mov %rbx, %rdi #get X as 1st arg
mov %R8, %rsi #get C as 2nd arg
call f
mov %rax, %r9 # store return (D) to R9

################################# RETURN SUM
### By prev, RAX currently equal D
add %rdx, %rax 
add %rcx, %rax
add %r8, %rax 
pop %rbx
ret


_start: 
mv $1 %rdi
push %rdi %rbx

call calculate
call syscall_exit
