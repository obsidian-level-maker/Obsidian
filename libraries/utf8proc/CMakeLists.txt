##########################################
# utf8proc
##########################################

add_library(
  utf8proc
  utf8proc.c
  utf8proc.h
  )

target_compile_definitions(utf8proc PRIVATE "UTF8PROC_STATIC")