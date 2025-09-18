    .section .note.GNU-stack,""
    .global _start
    .text

do_something:	#Jenny W 301421441
    push %rbx
    mov $1, %rcx
    mov $0, %rbx
    
loop_top:
    add %rcx, %rbx
    #add $1, %rcx    
    cmp %rdi, %rbx
    jle loop_top
        
    mov %rbx, %rax
    pop %rbx
    ret

_start:
    mov $60, %rdi
    call do_something
        
    # exit
    mov $0, %rdi
    call syscall_exit
