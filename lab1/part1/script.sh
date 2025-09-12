as array_sum.S -o array_sum.o

gcc -Wall -Wpedantic -std=c17 -march=haswell -c array_sum_speed.c -o array_sum_speed.o
gcc array_sum.o array_sum_speed.o 
./a.out 1000000


