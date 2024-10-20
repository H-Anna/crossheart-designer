cmake_minimum_required(VERSION 3.16)
project(libHaruTest)

set(BUILD_SHARED_LIBS OFF)
add_subdirectory(libharu)

add_executable(libHaruTest main.cpp)
target_link_libraries(libHaruTest hpdf)
