cmake_minimum_required(VERSION 3.27)
project(signal_generator)

include(cmake/functions.cmake)

add_subdirectory(test/linterp)
add_subdirectory(test/signal_generator)

add_subdirectory(design)