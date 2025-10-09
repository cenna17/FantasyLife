gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 -c others.c lab5.S && gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 others.o lab5.o timing.c && ./a.out

