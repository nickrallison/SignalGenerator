cmake_minimum_required(VERSION 3.27)
project(Vsignal_generator)

verilate("${CMAKE_SOURCE_DIR}/design/signal_generator.sv" "${CMAKE_SOURCE_DIR}/test/signal_generator/tb.cpp")
add_dependencies(Vsignal_generator
    ram_full
)