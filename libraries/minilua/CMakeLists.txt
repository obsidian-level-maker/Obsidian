##########################################
# minilua
##########################################

add_library(minilua minilua.cc)

target_include_directories(minilua PUBLIC ./)