cmake_minimum_required(VERSION 3.27)
project(Vlinterp)

verilate("${CMAKE_SOURCE_DIR}/design/linterp.sv" "${CMAKE_SOURCE_DIR}/test/linterp/tb.cpp")

