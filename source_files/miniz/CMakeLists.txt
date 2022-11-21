# AJBSP CMake Script
cmake_minimum_required(VERSION 3.2.2)

project(
  miniz
  LANGUAGES C
  VERSION 0.1.0
)

set(CMAKE_CC_FLAGS
    "-O2 -ffast-math -fno-strict-aliasing -DINLINE_G=inline -Wall"
)

add_library(miniz miniz.c)
