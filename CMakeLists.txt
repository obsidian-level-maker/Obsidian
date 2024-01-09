cmake_minimum_required(VERSION 3.12..3.20)

project(
  obsidian
  LANGUAGES C CXX
  VERSION 0.1.0
)

string(TIMESTAMP BUILD_TIMESTAMP "%Y.%m.%d" UTC)
add_compile_definitions(OBSIDIAN_TIMESTAMP="${BUILD_TIMESTAMP}")

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
  set(CLANG true)
else()
  set(CLANG false)
endif()

if(CONSOLE_ONLY OR HAIKU)
  add_compile_definitions(CONSOLE_ONLY=1)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
if(MSVC)
  # get the number of logical cores for parallel build
  cmake_host_system_information(RESULT LOGICAL_CORES QUERY NUMBER_OF_LOGICAL_CORES)
  math(EXPR COMPILE_CORES "${LOGICAL_CORES} - 1")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP${COMPILE_CORES}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHa /MP${COMPILE_CORES}")
  if(NOT CONSOLE_ONLY)
    set(CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:WINDOWS")
  endif()
endif()
if(MSYS OR MINGW)
  if(NOT CONSOLE_ONLY)
    set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows")
  else()
    set(CMAKE_EXE_LINKER_FLAGS "-static")
  endif()
endif()
if(APPLE OR ${CMAKE_SYSTEM} MATCHES "BSD")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I /usr/local/include")
endif()

set(OBSIDIAN_LIB_DIR "${CMAKE_SOURCE_DIR}/libraries")
set(OBSIDIAN_SOURCE_DIR "${CMAKE_SOURCE_DIR}/source_files")

if(NOT CONSOLE_ONLY)
  if (WIN32)
    set(SDL2_DIR "${OBSIDIAN_LIB_DIR}/sdl2")
  endif()
  find_package(SDL2 REQUIRED)
endif()

include_directories(libraries/minilua)

add_subdirectory(libraries)
add_subdirectory(source_files)