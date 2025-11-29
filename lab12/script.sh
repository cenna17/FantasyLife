gcc -std=c17 -march=haswell -O0 lab12c.c -o run_o0

gcc -std=c17 -march=haswell -O1 lab12c.c -o run_o1

gcc -std=c17 -march=haswell -O2 lab12c.c -o run_o2

gcc -std=c17 -march=haswell -O3 lab12c.c -o run_o3

# build optimized executables (unsafe math)
gcc -std=c17 -march=haswell -O3 -funsafe-math-optimizations lab12c.c -o map_o3_unsafe
gcc -std=c17 -march=haswell -O3 -funsafe-math-optimizations lab12c.c -o dot_o3_unsafe
