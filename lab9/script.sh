g++ -Wall -Wpedantic -std=c++17 -march=haswell -O3 sort.cpp -o test_o3
./test_o3 25000

g++ -Wall -Wpedantic -std=c++17 -march=haswell -O2 sort.cpp -o test_o2
./test_o2 25000

g++ -Wall -Wpedantic -std=c++17 -march=haswell -O1 -g sort.cpp
perf stat -e branch-misses,branches,br_inst_retired.not_taken ./a.out 20000
perf record -e branch-misses:pp,branches:pp,br_inst_retired.not_taken:pp ./a.out 20000
perf report
perf annotate
