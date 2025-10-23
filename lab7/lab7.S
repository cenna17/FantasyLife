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
    .type randint, @function
dot: 
ret

fill_array: 
ret

randint:
    # Load current seed into RAX
    movq seed(%rip), %rax

    # Load constant multiplier into R8 (requires movabs for 64-bit literal)
    movabs $6364136223846793005, %r8

    # Perform seed * multiplier
    imulq %r8, %rax

    # Add increment (1)
    addq $1, %rax

    # Store updated seed back to memory
    movq %rax, seed(%rip)

    # Return shifted version
    shrq $33, %rax    # shift right by 33 bits → return value now in %rax

    ret

