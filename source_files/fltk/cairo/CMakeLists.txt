include_directories(${PKG_CAIRO_INCLUDE_DIRS})

# source files for cairo
set(cairo_SRCS Fl_Cairo.cxx)

#######################################################################
fl_add_library(fltk_cairo STATIC "${cairo_SRCS}")

#######################################################################
if(OPTION_BUILD_SHARED_LIBS)
  #######################################################################
  fl_add_library(fltk_cairo SHARED "${cairo_SRCS}")

  #######################################################################
endif(OPTION_BUILD_SHARED_LIBS)
#######################################################################
