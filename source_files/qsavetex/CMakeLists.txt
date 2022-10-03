cmake_minimum_required(VERSION 3.16)

project(
  qsavetex
  VERSION 0.1.0
  LANGUAGES CXX
)

if(OBSIDIAN_MSVC_DEBUG)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MDd /EHa")
endif()

add_executable(
  ${PROJECT_NAME} ${SOURCES} main.cc im_tex.cc pakfile.cc u_file.cc u_util.cc
)
target_compile_features(qsavetex PRIVATE cxx_std_17)

if(MSYS)
  set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows")
endif()
