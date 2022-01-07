project(
  obsidian_zdbsp
  LANGUAGES CXX
  VERSION 0.1.0
)

set(CMAKE_CXX_FLAGS "-DINLINE_G=inline")

add_library(
  obsidian_zdbsp
  blockmapbuilder.cc
  blockmapbuilder.h
  doomdata.h
  nodebuild.cc
  nodebuild.h
  nodebuild_classify_nosse2.cc
  nodebuild_events.cc
  nodebuild_extract.cc
  nodebuild_gl.cc
  nodebuild_utility.cc
  processor.cc
  processor.h
  processor_udmf.cc
  rejectbuilder_nogl.cc
  rejectbuilder_nogl.h
  sc_man.cc
  sc_man.h
  tarray.h
  templates.h
  workdata.h
  xs_Float.h
  zdbsp.h
  zdmain.cc
  zdmain.h
  zdwad.cc
  zdwad.h
)

target_compile_features(obsidian_zdbsp PRIVATE cxx_std_17)
# FLTK includes are only needed to hook into Obsidian's progress bar update
# mechanism - Dasho
target_include_directories(obsidian_zdbsp PRIVATE ../fltk)
target_include_directories(obsidian_zdbsp PRIVATE ../obsidian_main)
target_include_directories(obsidian_zdbsp PRIVATE ../miniz)
target_link_libraries(obsidian_zdbsp PUBLIC miniz)
