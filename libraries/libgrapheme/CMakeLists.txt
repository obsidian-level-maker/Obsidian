##########################################
# libgrapheme
##########################################

project(
  libgrapheme
  LANGUAGES C
  VERSION 0.1.0
)

add_library(
  libgrapheme
  src/bidirectional.c
  src/case.c
  src/character.c
  src/line.c
  src/sentence.c
  src/utf8.c
  src/util.c
  src/word.c
  )
