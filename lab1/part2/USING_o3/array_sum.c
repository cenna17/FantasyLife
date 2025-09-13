#ifndef ARRAY_SUM_H
#define ARRAY_SUM_H
#include <stdint.h>

int32_t array_sum(int32_t *arr, uint32_t n){
	int index = 0; 
	int sum = 0;

	while (index < n){
		sum += arr[index];
		index++; 
	}
	return sum; 


}



#endif

