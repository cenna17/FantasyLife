.section .note.GNU-stack,""
.extern lab7
    .section .data
    .globl seed
seed:
    .quad 1                          # initial seed (64-bit)

    .section .text
    .globl randint
    .globl dot
    .globl dot_struct
    .globl fill_array

dot_struct: # RDI = arr of pairs {[a,b] ... [x,y]}; RSI = len
push %r12
    mov $0, %rax        # sum = 0
    cmp $0, %rsi       # if n == 0, return 0
    je RETURN_DOT_STRUCT
    mov %rsi, %r12 # save arr_length
    mov $0, %r9	#counter = 0
    jmp LOOP_DOT_STRUCT

LOOP_DOT_STRUCT: #NOTEE: RDI holds the pointer to start address of arr 1
cmp %r9, %r12
je RETURN_DOT_STRUCT
    movq (%rdi), %rcx      # load arr[i].a
    movq 8(%rdi), %r8      # load arr[i].b
    imulq %r8, %rcx        # multiply a*b
    addq %rcx, %rax        # sum += a*b

    addq $16, %rdi         # move pointer to next pair64_t
    add $1, %r9
    jmp LOOP_DOT_STRUCT
RETURN_DOT_STRUCT:
	pop %r12
	ret
dot: # RDI = arr_1; RSI = arr_2; RDX = arr_3
    cmp $0, %rdx
    je RETURN_DOT
    push %r12
    mov %rdx, %r12 # save arr_length
    mov $0, %r9	#counter = 0
    mov $0, %rax #sum = 0

loop_dot:
    cmp %r9, %r12
    je RETURN_DOT

# notee: in the beginning rdi and rsi point to start of arr1 and arr2
    movq (%rdi), %rcx      # load arr1[i] 
    movq (%rsi), %r8       # load arr2[i]

    imulq %r8, %rcx        # RCX = arr1[i] * arr2[i]
    addq %rcx, %rax        # sum += product
    addq $8, %rdi          # move to next arr1 element
    addq $8, %rsi          # move to next arr2 element
    add $1, %r9            # counter++
    jmp loop_dot

RETURN_DOT:
pop %r12
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
movq seed(%rip), %rax	# Load current seed into RAX
movabs $6364136223846793005, %r8 #IDK?? See lab7 instructions
imulq %r8, %rax 	# seed * multiplier
add $1, %rax
movq %rax, seed(%rip)	# Store updated seed back to memory
shrq $33, %rax    # shift right by 33 bits; return val in RAX

ret

