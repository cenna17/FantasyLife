gcc -Wall -Wpedantic -std=c17 -march=haswell -c tests.c \
&& as --warn -g lab4.S -o lab4.o \
&& gcc lab4.o tests.o \
&& ./a.out
