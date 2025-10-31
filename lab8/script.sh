gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 timing.c lab8c.c lab8.S -o hail_time
gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 tests.c lab8c.c lab8.S -o hail
gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 array-2d.c -o array
