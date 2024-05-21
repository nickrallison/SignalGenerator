cmake_minimum_required(VERSION 3.27)
project(Vram)

verilate("${CMAKE_SOURCE_DIR}/design/ram.sv" "${CMAKE_SOURCE_DIR}/test/ram/tb.cpp")