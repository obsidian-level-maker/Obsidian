# AJBSP CMake Script
cmake_minimum_required(VERSION 3.2.2)

project(ajbsp)

set(AJBSP_SOURCES
	src/bsp_level.cc
	src/bsp_node.cc
	src/bsp_util.cc
	src/lib_file.cc
	src/lib_util.cc
	src/main.cc
	src/w_wad.cc
)

add_executable(ajbsp
	${AJBSP_SOURCES}
)
