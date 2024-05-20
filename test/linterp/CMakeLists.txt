cmake_minimum_required(VERSION 3.27)
project(Vlinterp)

# add_custom_target(${PROJECT_NAME} ALL
#     DEPENDS "Vlinterp.h"
#         "${CMAKE_SOURCE_DIR}/design/linterp.sv"
# )

# # Add rust_example as a CMake target
# add_custom_command(
#     OUTPUT "Vlinterp.h"
#     COMMENT "Verilating linterp.sv"
#     COMMAND verilator -Wall --trace --cc ${CMAKE_SOURCE_DIR}/design/linterp.sv --Mdir . --exe ${CMAKE_SOURCE_DIR}/test/linterp/tb.cpp --build
#     # WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
# )

verilate("${CMAKE_SOURCE_DIR}/design/linterp.sv" "${CMAKE_SOURCE_DIR}/test/linterp/tb.cpp")

