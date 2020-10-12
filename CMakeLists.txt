cmake_minimum_required(VERSION 3.16)
# You can change the name of the project, but other things need to be changed
# INTERNAL NOTE: Don't change rev number (fourth one) for this template, but
# you can change it when generating from this template
project(fantastic_giggle VERSION 0.2.0.11)

# You can change the C++ standard too
set(CMAKE_CXX_STANDARD 17)

# First we configure the project
configure_file(include/config.in.txt ${PROJECT_SOURCE_DIR}/include/config.hpp)

# This should make it autoload the C++ root
add_executable(${PROJECT_NAME} src/${PROJECT_NAME}.cpp)

add_subdirectory(rtl_alu2)
add_subdirectory(rtl_barrelshifter16)
add_subdirectory(rtl_carry4_alu2)
add_subdirectory(rtl_lod4)
add_subdirectory(rtl_memory16)
add_subdirectory(rtl_registerfile16x8)
target_link_libraries(
    ${PROJECT_NAME}
    rtl_alu2
    rtl_barrelshifter16
    rtl_carry4_alu2
    rtl_lod4
    rtl_memory16
    rtl_registerfile16x8
)
