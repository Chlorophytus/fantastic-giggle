cmake_minimum_required(VERSION 3.16)
# You can change the name of the project, but other things need to be changed
# INTERNAL NOTE: Don't change rev number (fourth one) for this template, but
# you can change it when generating from this template
project(fantastic_giggle VERSION 0.1.0.2)

# You can change the C++ standard too
set(CMAKE_CXX_STANDARD 17)

# First we configure the project
configure_file(include/config.in.txt include/config.hpp)

# This should make it autoload the C++ root
add_executable(${PROJECT_NAME} src/${PROJECT_NAME}.cpp)

add_subdirectory(rtl_program_counter)
add_subdirectory(rtl_adder2)
add_subdirectory(rtl_carryadder8)
target_link_libraries(
    ${PROJECT_NAME}
    rtl_program_counter
    rtl_adder2
    rtl_carryadder8
)
