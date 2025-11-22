.section .note.GNU-stack,""
    .section .text
   .global dot_double_vec

    .global dot_single_vec

    .global map_poly_double_vec

    .global map_poly_single_vec


######################################
/*
arr1 = [1.0, 2.0, 3.0, 4.0]  
arr2 = [5.0, 6.0, 7.0, 8.0]
length = 4 (divisible by 4)

Expected Dot Product = 70.0
*/
######################################
dot_double_vec: # RDI = start of arr_1; RSI = start of arr_2; RDX = arr_length
    vpxor  %ymm2, %ymm2, %ymm2  # set accumulator = 0        
                                # ymm2 = [0.0, 0.0, 0.0, 0.0]
    mov $0, %rcx	#counter = 0

loop_dot_vec:
    cmp %rcx, %rdx # while counter < arr_length
    je RETURN_DOT_VEC

    vmovupd (%rdi, %rcx, 8), %ymm0   # load 4 doubles from arr1[i to i+3] 
                                    #       => ymm0 = [1.0, 2.0, 3.0, 4.0]
    vmovapd (%rsi,%rcx,8), %ymm1    # load 4 doubles from arr2[i..i+3]
                                    #       => ymm1 = [5.0, 6.0, 7.0, 8.0]

    vmulpd  %ymm1, %ymm0, %ymm0     # ymm0 = ymm0 * ymm1 (4 parallel multiplications)
                                    # ymm0 = [5.0, 12.0, 21.0, 32.0]

    vaddpd  %ymm0, %ymm2, %ymm2     # sum_vec += product_vec
                                    # ymm2 = [5.0, 12.0, 21.0, 32.0]
    add $4, %rcx            # counter += 4; move to next 4 elements
    jmp loop_dot_vec

RETURN_DOT_VEC: # ymm2 enter here as [5.0, 12.0, 21.0, 32.0] 
                # ymm2 contains 4-val can can be read in split using xmm1 && xmm2
                # xmm1 = first two num [5, 12];     xmm2 = last two num [21, 32]

    vextractf128 $1, %ymm2, %xmm1       # extract (first two num DENOTED BY $1) from ymm2 and                                 # store to xmm1 = high 128 bits => [5, 12] 

    vaddpd      %xmm1, %xmm2, %xmm2     # xmm2 = low + high -> [s0+s2, s1+s3]
    vhaddpd     %xmm2, %xmm2, %xmm0     # xmm0 = (s0+s2) + (s1+s3)

    ret

###################################
/*
arr1 = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
arr2 = [1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5]
length = 8 (divisible by 8)
*/
#Does the same as above but use float instructions instead => Purpose: test speed
dot_single_vec:  # RDI = arr1, RSI = arr2, RDX = length 
    vxorps  %ymm2, %ymm2, %ymm2   # sum = 0.0 (8 floats) => ymm2 = array of eight 0s
    mov $0, %rcx           # counter = 0

#NOTEE: vxorps is used for floats and visor is used for doubles when interpreting numbers in ymm0.  MUST NOT MIX THEM 

loop_dot_single_vec:
    cmp %rcx, %rdx
    je RETURN_DOT_SINGLE_VEC

    vmovaps (%rdi,%rcx,4), %ymm0   # load 8 floats from arr1
    vmovaps (%rsi,%rcx,4), %ymm1   # load 8 floats from arr2

    vmulps %ymm1, %ymm0, %ymm0     # add arr1 and arr2 element wise, the final answer is in arr1
    vaddps %ymm0, %ymm2, %ymm2     # sum += ymm0

    add $8, %rcx                   # Move to next 8 floats
    jmp loop_dot_single_vec

RETURN_DOT_SINGLE_VEC:
    vextractf128 $1, %ymm2, %xmm1   # xmm1 = high 128 bits  (last 4 floats f4 to f7)
    vaddps  %xmm1, %xmm2, %xmm2# xmm2 = low+high = [f0+f4,f1+f5,f2+f6,f3+f7]

    vhaddps %xmm2, %xmm2, %xmm2     # horizontal add: [f0+f4+f1+f5, f2+f6+f3+f7, ...]
    vhaddps %xmm2, %xmm2, %xmm0     # final scalar in xmm0

    ret

#NOTEE: Previously vextract $1 extracted the first two numbers (also high 128) for got_double_vec
#but this time it gets last four float numbers (also high 128)
###################################


map_poly_double_vec:
    # rdi = input array; rsi = output array
    # rdx = length

    xor     %rcx, %rcx            # counter = 0

    vbroadcastsd %xmm0, %ymm0        # a -> ymm0
    vbroadcastsd %xmm1, %ymm1        # b -> ymm1
    vbroadcastsd %xmm2, %ymm2        # c -> ymm2
    vbroadcastsd %xmm3, %ymm3        # d -> ymm3

loop_poly_vec:
    cmp     %rcx, %rdx            # while counter < length
    je     done_poly_vec               

    vmovapd (%rdi,%rcx,8), %ymm4     # load 4 doubles from input x[i]
    vmovapd %ymm4, %ymm5             # tmp = x

    # Calculating y = ((ax + b)x + c)x + d

    vmulpd %ymm0, %ymm5, %ymm5       # ax
    vaddpd %ymm1, %ymm5, %ymm5       # ax + b
    vmulpd %ymm4, %ymm5, %ymm5       # x(ax + b)
    vaddpd %ymm2, %ymm5, %ymm5       # x(ax + b) + c
    vmulpd %ymm4, %ymm5, %ymm5       # x(x(ax + b) + c)
    vaddpd %ymm3, %ymm5, %ymm5       # x(x(ax + b) + c) + d

    vmovapd %ymm5, (%rsi,%rcx,8)     # store result

    add $4, %rcx                      # increment counter by 4 doubles
    
    jmp loop_poly_vec

done_poly_vec:
    ret

###################################
#Does the same as above but changes the double instructions to use float instructions instead => Purpose: test speed
###################################
map_poly_single_vec: 
    # rdi = input array; rsi = output array 
    # rdx = length
    xor     %rcx, %rcx              # counter = 0

    vbroadcastss %xmm0, %ymm0         # a -> ymm0
    vbroadcastss %xmm1, %ymm1         # b -> ymm1
    vbroadcastss %xmm2, %ymm2         # c -> ymm2
    vbroadcastss %xmm3, %ymm3         # d -> ymm3


loop_poly_single_vec:
    cmp     %rcx, %rdx
    je      done_poly_single_vec

    vmovaps (%rdi,%rcx,4), %ymm4      # load 8 floats from input
    vmovaps %ymm4, %ymm5              # tmp = x

    # Horner's method: y = ((ax + b)x + c)x + d

    vmulps %ymm0, %ymm5, %ymm5        # ax
    vaddps %ymm1, %ymm5, %ymm5        # ax + b
    vmulps %ymm4, %ymm5, %ymm5        # x(ax + b)
    vaddps %ymm2, %ymm5, %ymm5        # x(ax + b) + c
    vmulps %ymm4, %ymm5, %ymm5        # x(x(ax + b) + c)
    vaddps %ymm3, %ymm5, %ymm5        # x(x(ax + b) + c) + d

    vmovaps %ymm5, (%rsi,%rcx,4)      # store result

    add $8, %rcx                       # increment counter by 8 floats
    
    jmp     loop_poly_single_vec

done_poly_single_vec:
    ret
###################################

