project(
  obsidian_zdbsp
  LANGUAGES CXX
  VERSION 0.1.0
)

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
  rejectbuilder.cc
  rejectbuilder.h
  rejectbuilder_nogl.cc
  rejectbuilder_nogl.h
  sc_man.cc
  sc_man.h
  tarray.h
  templates.h
  vis.cc
  visflow.cc
  workdata.h
  xs_Float.h
  zdbsp.h
  zdmain.cc
  zdmain.h
  zdwad.cc
  zdwad.h
)

target_include_directories(obsidian_zdbsp PRIVATE ../zlib_src)
