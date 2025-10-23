gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 tests.c lab7c.c lab7.S -o test
gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 lab7c.c timing.c lab7.S -o timing03
gcc -Wall -Wpedantic -std=c17 -march=haswell lab7c.c timing.c lab7.S -o timing_reg

