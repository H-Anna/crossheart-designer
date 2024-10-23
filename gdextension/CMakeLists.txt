cmake_minimum_required(VERSION 3.16)
project(PdfServer)

set(BUILD_SHARED_LIBS OFF)
add_subdirectory(libharu)

add_subdirectory(godot-cpp)
add_library(pdfServerGDExtension SHARED PdfServer.cpp RegisterExtension.cpp)
target_include_directories(pdfServerGDExtension PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(pdfServerGDExtension hpdf godot-cpp)
