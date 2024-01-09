# AJBSP CMake Script
cmake_minimum_required(VERSION 3.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

project(ajbsp)

add_library(ajbsp
	ajbsp.cc
	level.cc
	node.cc
	misc.cc
	utility.cc
	wad.cc
)

target_include_directories(ajbsp PRIVATE ${OBSIDIAN_SOURCE_DIR}/ajparse)
target_include_directories(ajbsp PRIVATE ${OBSIDIAN_LIB_DIR}/miniz)