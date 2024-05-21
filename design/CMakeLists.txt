cmake_minimum_required(VERSION 3.27)
project(design)

add_custom_target(ram_full ALL
    DEPENDS "ram_full.sv"
        "ram.sv"
        "${CMAKE_SOURCE_DIR}/scripts/wave_generator.py"
)

# Add rust_example as a CMake target
add_custom_command(
    OUTPUT "ram_full.sv"
    COMMENT "Filling Ram Cell ..."
    COMMAND ${CMAKE_SOURCE_DIR}/.venv/bin/python ${CMAKE_SOURCE_DIR}/scripts/wave_generator.py ${CMAKE_SOURCE_DIR}/design/ram.sv ram_full.sv
    DEPENDS
        "ram.sv"
        "${CMAKE_SOURCE_DIR}/scripts/wave_generator.py"
)