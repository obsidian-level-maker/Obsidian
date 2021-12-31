# AJBSP CMake Script
cmake_minimum_required(VERSION 3.2.2)

project(miniz)

set(CMAKE_CC_FLAGS "-O2 -ffast-math -fno-strict-aliasing -DINLINE_G=inline -Wall")

add_library(
	miniz
	miniz.c
)
