#define _POSIX_C_SOURCE 199309L
#include <inttypes.h>
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>  

#define TIMING_RESULT(DESCR, CODE) do { \
    struct timespec start, end; \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start); \
    CODE; \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end); \
    double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9; \
    printf("%25s took %7.1f ms\n", DESCR, elapsed * 1000); \
} while(0)

#define ASSERT_PRINT(expr) do {                 \
    if ((expr)) {                               \
        printf("%s: PASSED \n", #expr);       \
    } else {                                    \
        printf("%s: FAILED \n", #expr);       \
    }                                           \
} while(0)

void sin_stdlib(double* input, double* output, uint64_t length) {
    for (uint64_t i = 0; i < length; i++) {
	    printf ("trying to sin(%f)\n", input[i]);
        output[i] = sin(input[i]);
    }
}

int main() {
    const uint64_t length = 16;
    double* input = create_array(length);
    if (!input) {
    fprintf(stderr, "ERROR: input array is NULL!\n");
    return;
}
else{
	printf("printing input array: \n");
for(int i = 0; i < length; i++){printf("input %i: %f\n", i, input[i]);}
}
    double* output_stdlib = (double*)malloc(length * sizeof(double));
    double* output_x87 = (double*)malloc(length * sizeof(double));
    assert(output_stdlib != NULL);
    assert(output_x87 != NULL);

    // Test correctness
    sin_stdlib(input, output_stdlib, length);
    sin_x87(input, output_x87, length);

    printf("Index | Input       | sin_stdlib  | sin_x87\n");
    printf("-----------------------------------------------\n");
    for (uint64_t i = 0; i < length; i++){
        printf("%5" PRIu64 " | %10.6f | %10.6f | %10.6f\n",
               i, input[i], output_stdlib[i], output_x87[i]);}

    // Timing very big array
    const uint64_t big_len = 100;
    double* big_input = create_array(big_len);
    double* big_output_stdlib = (double*)malloc(big_len * sizeof(double));
    double* big_output_x87 = (double*)malloc(big_len * sizeof(double));
    assert(big_output_stdlib != NULL);
    assert(big_output_x87 != NULL);

    TIMING_RESULT("sin_stdlib", sin_stdlib(big_input, big_output_stdlib, big_len));
    TIMING_RESULT("sin_x87", sin_x87(big_input, big_output_x87, big_len));

    // Free allocated memory
    free(input);
    free(output_stdlib);
    free(output_x87);
    free(big_input);
    free(big_output_stdlib);
    free(big_output_x87);

    return 0;
}
