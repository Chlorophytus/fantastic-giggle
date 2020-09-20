cmake_minimum_required(VERSION 3.16)
# This is an RTL dir and it'll be cmake'd. Name this whatever.
# I recommend prefixing with "rtl..." which turns into "librtl..."
# Also you can tweak version numbers and make more modular tweaks. Awesome.
project(rtl_test_example VERSION 0.1.0.1)

# You can change the C++ standard too
set(CMAKE_CXX_STANDARD 17)

# Find the Verilator package
find_package(verilator REQUIRED)
# Find Lua
find_package(Lua REQUIRED)

# Find its configuration file for CMake
include(/usr/share/verilator/verilator-config.cmake)

# Make a config file.
configure_file(config.in.txt ${PROJECT_SOURCE_DIR}/config.hpp)

# This is a static project.
add_library(${PROJECT_NAME} STATIC harness.cpp)

# Verilate here
verilate(${PROJECT_NAME} SOURCES dut.v)

# Link to Lua 5.3
target_link_libraries(${PROJECT_NAME} PRIVATE lua5.4)
