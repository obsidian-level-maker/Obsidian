project(
  obsidian_slump
  LANGUAGES C CXX
  VERSION 0.1.0
)

add_library(obsidian_slump dump.cc slump.cc slump_main.cc)
target_compile_features(obsidian_slump PRIVATE cxx_std_17)
target_include_directories(obsidian_slump PRIVATE ${OBSIDIAN_SOURCE_DIR}/obsidian_main)
