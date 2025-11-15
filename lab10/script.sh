
gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 lab10.S lab10c.c tests.c -o lab10AS
./lab10AS

gcc -Wall -Wpedantic -std=c17 -march=haswell -O3 \
   lab10c.c lab10.S timing.c \
   -o time03

gcc -O3 -Wall -Wpedantic -std=c17 lab10c.c lab10.S sin.c -lm -o sin_test

