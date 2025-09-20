 .section .note.GNU-stack,""
 	.extern f

    .global calculate
    .text

calculate: #f(x,y) => rdi = 1st param AND rsi = 2nd param
########### We push these registers we will use to preserve values
########### for now.  The registers internal value will be modified to ABCD
########### respectively.  Since they are preserve registers, we must restore
########### their values after use in this function.  
########### Therefore, we must push them into the stack first.
mov %rdi, %rbx	#set X to be preserved
push %rbx #preserve x
push %r12 #preserve A
push %r13 #preserve B
push %r14 #preserve C
###################################SETTING A
mov %rbx, %rax
add $3, %rax # x+3
mov %rax, %r12#remember A for later

###################################SETTING B
#RECALL A in RDX
# b = f(x,a) => want original x for 1st arg => x->pop->rdi && a->rsi
mov %r12, %rsi #set A as 2nd arg
mov %rbx, %rdi #get original X as 1st arg 

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

################################# SUM A+B+C+D
### By prev, RAX currently equal D
add %r12, %rax 
add %r13, %rax
add %r14, %rax
################################# RESTORE PRESERVE REGISTERS VALUES
pop %r14
pop %r13
pop %r12
pop %rbx
################################# RETURN SUM
ret
##############################################################
##############################################################
#A side notee; the values of A B C were stored in NON-PRESERVE registers 
#before.  When calling f_function, should that funciton decide to use 
#any one of the registers that were used to store A B C, then the values
#for ABC will be overwritten by whatever the f_function gives it.

#However, call preserved registers guarantees that no matter how register 
#values are changed from other functions using them, it always resets
#the value to what it is before the call was made.

#In other words, an outside function I call may use the registers even if I do 
#not pass them as parameters or modify them in my code.
##############################################################
##############################################################
##############################################################
