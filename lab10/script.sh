g++ -Wall -Wpedantic -std=c++17 -march=haswell -O3 lab10.S -o lab10AS
./lab10AS

g++ -Wall -Wpedantic -std=c++17 -march=haswell -O3 \
    lab10c.c lab10.S timing.c \
    -o time03

gcc -O3 -Wall -Wpedantic -std=c11 lab10c.c lab10.S sin.c -lm -o sin_test
