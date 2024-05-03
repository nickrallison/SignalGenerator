#!/bin/bash

# CXX="g++ -std=c++23"

# TOP="linterp"
# verilator -Wall --trace --cc design/${TOP}.sv --Mdir build --exe test/${TOP}_tb.cpp
# make -C build -f V${TOP}.mk V${TOP}
# ./build/V${TOP}

TOP="multi_ram"
verilator -Wall --trace --cc design/${TOP}.sv --Mdir build --exe test/${TOP}_tb.cpp --unroll-count 1024
make -C build -f V${TOP}.mk V${TOP}
./build/V${TOP}  