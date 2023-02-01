# AJBSP CMake Script
cmake_minimum_required(VERSION 3.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

project(ajparse)

add_library(ajparse
	aj_parse.cc
)
