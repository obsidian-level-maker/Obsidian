cmake_minimum_required(VERSION 3.14)

project(hedley LANGUAGES C)

add_library(hedley INTERFACE)
target_include_directories(hedley INTERFACE include)
add_library(hedley::hedley ALIAS hedley)
