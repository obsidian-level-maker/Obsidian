project(steve)

file(GLOB_RECURSE SOURCES src/*.cpp src/*.h)

add_library(steve ${SOURCES})