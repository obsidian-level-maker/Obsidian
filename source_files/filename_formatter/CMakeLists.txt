cmake_minimum_required(VERSION 3.16)
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

project(
  filename_formatter
  VERSION 0.1.0
  LANGUAGES C CXX
)
add_library(${PROJECT_NAME} ${SOURCES} ff_main.cpp lex.yy.c)
# Workaround for cross-compiling until I do something more elegant. Still need
# flex installed - Dasho
if(!MINGW)
  find_package(FLEX REQUIRED)
  target_link_libraries(${PROJECT_NAME} PRIVATE ${FLEX_LIBRARIES})
endif()
