project(
  obsidian_zdbsp
  LANGUAGES CXX
  VERSION 0.1.0
)

set(CMAKE_CXX_FLAGS "-DINLINE_G=inline")
if(WIN32
   AND NOT MINGW
   AND NOT MSYS
)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHa")
endif()

add_library(
  obsidian_zdbsp
  blockmapbuilder.cc
  nodebuild.cc
  nodebuild_classify_nosse2.cc
  nodebuild_events.cc
  nodebuild_extract.cc
  nodebuild_gl.cc
  nodebuild_utility.cc
  processor.cc
  processor_udmf.cc
  rejectbuilder_nogl.cc
  sc_man.cc
  zdmain.cc
  zdwad.cc
)

target_compile_features(obsidian_zdbsp PRIVATE cxx_std_17)
# FLTK includes are only needed to hook into Obsidian's progress bar update
# mechanism - Dasho
target_include_directories(obsidian_zdbsp PRIVATE ../fltk)
target_include_directories(obsidian_zdbsp PRIVATE ../obsidian_main)
target_include_directories(obsidian_zdbsp PRIVATE ../miniz)
target_link_libraries(obsidian_zdbsp PUBLIC miniz)
