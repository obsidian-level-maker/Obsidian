project(
  obsidian_slump
  LANGUAGES CXX
  VERSION 0.1.0
)

add_library(obsidian_slump dump.cc slump.cc slump.h slump_main.cc slump_main.h)
target_compile_features(obsidian_slump PRIVATE cxx_std_17)
target_include_directories(obsidian_slump PRIVATE ../obsidian_main)
