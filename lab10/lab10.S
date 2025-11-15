.section .note.GNU-stack,""
    .section .text
   .global dot_double
    .type dot_double, @function

    .global dot_single
    .type dot_single, @function

    .global map_poly_double
    .type map_poly_double, @function

    .global map_poly_single
    .type map_poly_single, @function

    .global sin_x87
    .type sin_x87, @function 
    


dot_double: # RDI = start of arr_1; RSI = start of arr_2; RDX = arr_length
    pxor    %xmm2, %xmm2 
    mov $0, %rcx	#counter = 0

loop_dot:
    cmp %rcx, %rdx # while counter < arr_length
    je RETURN_DOT

    movsd (%rdi, %rcx, 8), %xmm0      # load arr1[i] to double register
    mulsd (%rsi, %rcx, 8), %xmm0       # multiple it by element in other array

    addsd %xmm0, %xmm2        # sum += product
    add $1, %rcx            # counter++
    jmp loop_dot

RETURN_DOT:
movapd %xmm2, %xmm0
ret

###################################
#Does the same as above but changes the double instructions to use float instructions instead => Purpose: test speed
dot_single:  # RDI = arr1, RSI = arr2, RDX = length 
    pxor %xmm2, %xmm2       # sum = 0.0
    mov $0, %rcx           # counter = 0

loop_dot_single:
    cmp %rcx, %rdx
    je RETURN_DOT_SINGLE

    movss (%rdi,%rcx,4), %xmm0    # load arr1[i] (float os use 4)
    mulss (%rsi,%rcx,4), %xmm0    # multiply by arr2[i]
    addss %xmm0, %xmm2            # sum += product
    add $1, %rcx
    jmp loop_dot_single

RETURN_DOT_SINGLE:
    movaps  %xmm2, %xmm0            # move result to xmm0
    ret
###################################


map_poly_double:
    # rdi = input array; rsi = output array << MAYBE??? Ask prof.  NOt sure if they are in rdi:rsi or xmm0:xmm1
    # rdx = length
    # xmm0 = A  xmm1 = B  xmm2 = C  xmm3 = D

    xor     %rcx, %rcx            # counter = 0

loop_poly:
    cmp     %rcx, %rdx            # while counter < length
    je     done_poly               

    movsd (%rdi,%rcx,8), %xmm4  # load X at index i
    movapd %xmm4, %xmm5         # x
    mulsd %xmm0, %xmm5          # ax
    addsd %xmm1, %xmm5          # ax + b
    mulsd %xmm4, %xmm5          # x(ax + b)
    addsd %xmm2, %xmm5          # x(ax + b) + c
    mulsd %xmm4, %xmm5          # x(x(ax + b) + c)
    addsd %xmm3, %xmm5          # x(x(ax + b) + c) + d

    movsd   %xmm5, (%rsi,%rcx,8)  # store in output[i]

    add $1, %rcx
    jmp loop_poly

done_poly:
    ret

###################################
#Does the same as above but changes the double instructions to use float instructions instead => Purpose: test speed
###################################
map_poly_single: 
    # rdi = input array; rsi = output array << MAYBE??? Ask prof.  NOt sure if they are in rdi:rsi or xmm0:xmm1
    # rdx = length
    # xmm0 = A  xmm1 = B  xmm2 = C  xmm3 = D
    xor     %rcx, %rcx              # counter = 0

loop_poly_single:
    cmp     %rcx, %rdx
    je      done_poly_single

    movss   (%rdi,%rcx,4), %xmm4   # load x
    movaps  %xmm4, %xmm5           # xmm5 = x
    mulss   %xmm0, %xmm5           # ax
    addss   %xmm1, %xmm5           # ax + b
    mulss   %xmm4, %xmm5           # x(ax + b)
    addss   %xmm2, %xmm5           # x(ax + b) + c
    mulss   %xmm4, %xmm5           # x(x(ax + b) + c)
    addss   %xmm3, %xmm5           # x(x(ax + b) + c) + d

    movss   %xmm5, (%rsi,%rcx,4)   # store in output[i]

    add     $1, %rcx
    jmp     loop_poly_single

done_poly_single:
    ret
###################################

sin_x87:
    mov $0, %rcx
s87_loop:
    cmp %rdx, %rcx
    jae s87_ret
    fldl (%rdi, %rcx, 8)
    fsin
    fstpl (%rsi, %rcx, 8)
    inc %rcx
    jmp s87_loop
s87_ret:
    ret
