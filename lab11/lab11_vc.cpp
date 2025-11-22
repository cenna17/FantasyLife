#include "version2/vectorclass.h"
#include <cstdlib> // for size_t

//  Dot product double 
double dot_double_vc(double* arr1, double* arr2,uint64_t n) {
    
    /*
        arr1 = [1.0, 2.0, 3.0, 4.0]  
        arr2 = [5.0, 6.0, 7.0, 8.0]
    */
    Vec4d sum_vec(0.0); // 4 doubles vector initialized to zero

    for (size_t i = 0; i < n; i += 4) { //see class notes
        Vec4d v1 = Vec4d().load(arr1 + i); // reads 4 doubles denoted by Vec4d(); startign from arr1 + i
        // i = 0 in beginning => load 1st 4 doubles
        Vec4d v2 = Vec4d().load(arr2 + i);
        sum_vec += v1 * v2; //Muliply each 4 doubles elementally 
        // <a1 a2 a3 a4> DOT <b1 b2 b3 b4> to produce sum_vec = <ab1, ab2, ab3, ab4>
    }

    return horizontal_add(sum_vec); // Add all values inside <ab1, ab2, ab3, ab4> to a single final sum
}

//  Dot product float 
float dot_single_vc( float* arr1,  float* arr2, uint64_t n) { //Basically same as above but denote to use floats 
    Vec8f sum_vec(0.0f); // 8 floats vector initialized to zero

    for (size_t i = 0; i < n; i += 8) {
        Vec8f v1 = Vec8f().load(arr1 + i); // load 8 floats
        Vec8f v2 = Vec8f().load(arr2 + i);
        sum_vec += v1 * v2; // DOT the arrays  => sum_vec
    }

    return horizontal_add(sum_vec); // ADD the dots in sum_vec together
}

//  Map polynomial double: sum = x(x(ax + b) + c) + d
void map_poly_double_vc(double* input, double* output, uint64_t length, double a, double b, double c, double d) {
    Vec4d vec_a(a), vec_b(b), vec_c(c), vec_d(d); // Make 4 double vectors: Init vec_a = <a a a a> ... vec_d = <d d d d>

    for (size_t i = 0; i < length; i += 4) {
        Vec4d x = Vec4d().load(input + i);   // load 4 doubles
        Vec4d y = ((vec_a * x + vec_b) * x + vec_c) * x + vec_d; // x(x(ax + b) + c) + d => see Lab11_fig.1
        y.store(output + i);                 // store results
    }
}

//  Map polynomial float: sum = x(x(ax + b) + c) + d SAME IDEA as above but uses floats 
void map_poly_single_vc(float* input, float* output, uint64_t length,float a, float b, float c, float d) {
    Vec8f vec_a(a), vec_b(b), vec_c(c), vec_d(d); 

    for (size_t i = 0; i < length; i += 8) {
        Vec8f x = Vec8f().load(input + i);   // load 8 floats
        Vec8f y = ((vec_a * x + vec_b) * x + vec_c) * x + vec_d; // x(x(ax + b) + c) + d => see Lab11_fig.1
        y.store(output + i);                 // store results
    }
}
