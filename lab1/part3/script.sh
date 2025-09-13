as multiply_add.S -o multiply_add.o
gcc -c multiply_add_test.c -o multiply_add_test.o
gcc multiply_add_test.o multiply_add.o
./a.out
