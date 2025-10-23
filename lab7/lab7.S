# lab7.S (Linux x86-64, System V ABI)
# RtlUniform Generator version (MUSL constants)
# seed = seed * 6364136223846793005 + 1
# return seed >> 33
.section .note.GNU-stack,""
.extern lab7
    .section .data
    .globl seed
seed:
    .quad 1                          # initial seed (64-bit)

    .section .text
    .globl randint
    .globl dot
    .globl fill_array
    .globl dot_struct
dot_struct: 
ret
dot: 
ret


fill_array:
    cmp $0, %rsi        # if n == 0, return immediately
    je RETURN_ARR

    movq %rdi, %rcx         # rcx is start addr of array
    push %r12
    movq %rsi, %r12         # save arr length
    mov $0, %rdx #counter = 0

loop:
cmp %rdx, %r12
je RETURN_ARR
call randint 	# get random number in RAX
and $0xff, %rax	# make the random num smaller in case its too big
sub $128, %rax            
movq %rax, (%rcx)       # store RAX into current array element
add $8, %rcx           # move pointer to next int64_t
add $1, %rdx               #  counter--
jmp loop

RETURN_ARR:
pop %r12
ret


randint:
    # Load current seed into RAX
    movq seed(%rip), %rax

    movabs $6364136223846793005, %r8 #IDK?? See lab7 instructions

    # Perform seed * multiplier
    imulq %r8, %rax

    add $1, %rax

    # Store updated seed back to memory
    movq %rax, seed(%rip)

    shrq $33, %rax    # shift right by 33 bits → return value now in %rax

    ret

