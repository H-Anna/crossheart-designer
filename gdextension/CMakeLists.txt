cmake_minimum_required(VERSION 3.16)
project(libHaruTest)

set(BUILD_SHARED_LIBS OFF)
add_subdirectory(libharu)

#add_executable(libHaruTest main.cpp)
#target_link_libraries(libHaruTest hpdf)

add_subdirectory(godot-cpp)
add_library(haruExtensionTest SHARED HaruClass.cpp RegisterExtension.cpp)
target_include_directories(haruExtensionTest PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(haruExtensionTest hpdf godot-cpp)
