 .section .note.GNU-stack,""
 	.extern f

    .global calculate
    .text

calculate: #f(x,y) => rdi = 1st param AND rsi = 2nd param
mov %rdi, %rbx	#set X to be preserved
push %rbx
###################################SETTING A
add $3, %rbx # x+3
mov %rbx, %rsi #set A as 2nd arg
mov %rbx, %r12#remember A for later

###################################SETTING B
#RECALL A in RDX
# b = f(x,a) => want original x for 1st arg => x->pop->rdi && a->rsi
pop %rbx # get origiinal X
mov %rbx, %rdi #get original X as 1st arg 
mov %r12, %rsi #get A as 2nd arg 

#rdi and rsi are set, ready to call f(x,a)
call f #return stored to RAX
mov %rax, %r13 #store return value (B) to a free register - rdx
	      #(RDX happens to be non-preserved; thats okay, we don't need it to be preserved)

##################################SETTING C
#RECALL A in RDX && B in RCX
mov %r13, %rdi #get B as 1st arg
mov %rbx, %rsi #get X as 2nd arg
call f #return stored to RAX
mov %rax, %r14 #store return (C) to R8

##################################SETTING D
#RECALL A in RDX && B in RCX && C in R8
mov %rbx, %rdi #get X as 1st arg
mov %r14, %rsi #get C as 2nd arg
call f

################################# RETURN SUM
### By prev, RAX currently equal D
add %r12, %rax 
add %r13, %rax
add %r14, %rax 
##############################################################
##############################################################
A side note; the values of A B C were stored in NON-PRESERVE registers 
before.  When calling f_function, should that funciton decide to use 
any one of the registers that were used to store A B C, then the values
for ABC will be overwritten by whatever the f_function gives it.

However, call preserved registers guarantees that no matter how register 
values are changed from other functions using them, it always resets
the value to what it is before the call was made.

In other words, an outside function I call may use the registers even if I do 
not pass them as parameters or modify them in my code.
##############################################################
##############################################################
##############################################################
ret
