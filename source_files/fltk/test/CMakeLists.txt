#
# CMakeLists.txt used to build test and demo apps by the CMake build system
#
# Copyright 2004-2021 by Bill Spitzak and others.
#
# This library is free software. Distribution and use rights are outlined in the
# file "COPYING" which should have been included with this file.  If this file
# is missing or damaged, see the license at:
#
# https://www.fltk.org/COPYING.php
#
# Please see the following page on how to report bugs and issues:
#
# https://www.fltk.org/bugs.php
#
# ##############################################################################

include(../CMake/FLTK-Functions.cmake)
include(../CMake/fl_create_example.cmake)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/../bin/test)
set(TESTFILE_PATH ${CMAKE_CURRENT_BINARY_DIR}/../data)

# create data and binary directory to copy scripts and data files

file(MAKE_DIRECTORY ${EXECUTABLE_OUTPUT_PATH})
file(MAKE_DIRECTORY ${TESTFILE_PATH})

# ##############################################################################
# audio libs for test apps
if(WIN32)
  set(AUDIOLIBS winmm)
elseif(APPLE)
  set(AUDIOLIBS "-framework CoreAudio")
elseif(HAVE_ALSA_ASOUNDLIB_H)
  find_library(LIB_asound asound)
  if(LIB_asound)
    set(AUDIOLIBS ${LIB_asound})
  endif(LIB_asound)
  mark_as_advanced(LIB_asound)
endif(WIN32)

# ##############################################################################
include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

# ##############################################################################
# Define additional example programs for testing, for instance: set (extra_tests
# issue-276 str-1895) Use the source file test/'name'.cxx for each additional
# program. These test programs will be built with image and GL libraries. Leave
# the variable 'extra_tests' empty to disable extra test programs.

set(extra_tests)

# ##############################################################################

create_example(adjuster adjuster.cxx fltk)
create_example(arc arc.cxx fltk)
create_example(animated animated.cxx fltk)
create_example(ask ask.cxx fltk)
create_example(bitmap bitmap.cxx fltk)
create_example(blocks "blocks.cxx;blocks.plist;blocks.icns" "fltk;${AUDIOLIBS}")
create_example(boxtype boxtype.cxx fltk)
create_example(browser browser.cxx fltk)
create_example(button button.cxx fltk)
create_example(buttons buttons.cxx fltk)
create_example(
  checkers "checkers.cxx;checkers_pieces.fl;checkers.icns" "fltk_images;fltk"
)
create_example(clipboard clipboard.cxx "fltk_images;fltk")
create_example(clock clock.cxx fltk)
create_example(colbrowser colbrowser.cxx fltk)
create_example(color_chooser color_chooser.cxx fltk)
create_example(coordinates coordinates.cxx fltk)
create_example(cursor cursor.cxx fltk)
create_example(curve curve.cxx fltk)
create_example(demo demo.cxx fltk)
create_example(device device.cxx "fltk_images;fltk")
create_example(doublebuffer doublebuffer.cxx fltk)
create_example(editor "editor.cxx;editor.plist" fltk)
create_example(fast_slow fast_slow.fl fltk)
create_example(file_chooser file_chooser.cxx "fltk_images;fltk")
create_example(flex_demo flex_demo.cxx fltk)
create_example(flex_login flex_login.cxx fltk)
create_example(fltk-versions fltk-versions.cxx fltk)
create_example(fonts fonts.cxx fltk)
create_example(forms forms.cxx "fltk_forms;fltk")
if(OPENGL_FOUND)
  create_example(handle_events handle_events.cxx "fltk_gl;fltk") # opt.
                                                                 # Fl_Gl_Window
else()
  create_example(handle_events handle_events.cxx fltk) # w/o Fl_Gl_Window
endif()
create_example(hello hello.cxx fltk)
create_example(help_dialog help_dialog.cxx "fltk_images;fltk")
create_example(icon icon.cxx fltk)
create_example(iconize iconize.cxx fltk)
create_example(image image.cxx fltk)
create_example(inactive inactive.fl fltk)
create_example(input input.cxx fltk)
create_example(input_choice input_choice.cxx fltk)
create_example(keyboard "keyboard.cxx;keyboard_ui.fl" fltk)
create_example(label label.cxx fltk)
create_example(line_style line_style.cxx fltk)
create_example(list_visuals list_visuals.cxx fltk)
create_example(mandelbrot "mandelbrot_ui.fl;mandelbrot.cxx" fltk)
create_example(menubar menubar.cxx fltk)
create_example(message message.cxx fltk)
create_example(minimum minimum.cxx fltk)
create_example(native-filechooser native-filechooser.cxx "fltk_images;fltk")
create_example(navigation navigation.cxx fltk)
create_example(output output.cxx fltk)
create_example(overlay overlay.cxx fltk)
create_example(pack pack.cxx fltk)
create_example(pixmap pixmap.cxx fltk)
create_example(pixmap_browser pixmap_browser.cxx "fltk_images;fltk")
create_example(preferences preferences.fl fltk)
create_example(offscreen offscreen.cxx fltk)
create_example(radio radio.fl fltk)
create_example(resize resize.fl fltk)
create_example(resizebox resizebox.cxx fltk)
create_example(resize-example1 "resize-example1.cxx;resize-arrows.cxx" fltk)
create_example(resize-example2 "resize-example2.cxx;resize-arrows.cxx" fltk)
create_example(resize-example3a "resize-example3a.cxx;resize-arrows.cxx" fltk)
create_example(resize-example3b "resize-example3b.cxx;resize-arrows.cxx" fltk)
create_example(resize-example3c "resize-example3c.cxx;resize-arrows.cxx" fltk)
create_example(resize-example4a "resize-example4a.cxx;resize-arrows.cxx" fltk)
create_example(resize-example4b "resize-example4b.cxx;resize-arrows.cxx" fltk)
create_example(resize-example5a "resize-example5a.cxx;resize-arrows.cxx" fltk)
create_example(resize-example5b "resize-example5b.cxx;resize-arrows.cxx" fltk)
create_example(resize-example5c "resize-example5c.cxx;resize-arrows.cxx" fltk)
create_example(rotated_text rotated_text.cxx fltk)
create_example(scroll scroll.cxx fltk)
create_example(subwindow subwindow.cxx fltk)
create_example(
  sudoku "sudoku.cxx;sudoku.plist;sudoku.icns;sudoku.rc"
  "fltk_images;fltk;${AUDIOLIBS}"
)
create_example(symbols symbols.cxx fltk)
create_example(tabs tabs.fl fltk)
create_example(table table.cxx fltk)
create_example(threads threads.cxx fltk)
create_example(tile tile.cxx fltk)
create_example(tiled_image tiled_image.cxx fltk)
create_example(tree tree.fl fltk)
create_example(twowin twowin.cxx fltk)
create_example(utf8 utf8.cxx fltk)
create_example(valuators valuators.fl fltk)
create_example(windowfocus windowfocus.cxx fltk)
create_example(wizard wizard.cxx fltk)

# unittests uses multiple source files and can be built with or w/o OpenGL and
# "shared"

set(UNITTEST_SRCS
    unittests.cxx
    unittest_about.cxx
    unittest_points.cxx
    unittest_complex_shapes.cxx
    unittest_fast_shapes.cxx
    unittest_circles.cxx
    unittest_text.cxx
    unittest_symbol.cxx
    unittest_images.cxx
    unittest_viewport.cxx
    unittest_scrollbarsize.cxx
    unittest_schemes.cxx
    unittest_simple_terminal.cxx
)
if(OPENGL_FOUND)
  set(UNITTEST_LIBS fltk_gl fltk ${OPENGL_LIBRARIES})
  set(UNITTEST_LIBS_SHARED fltk_gl_SHARED fltk_SHARED ${OPENGL_LIBRARIES})
else()
  set(UNITTEST_LIBS fltk)
  set(UNITTEST_LIBS_SHARED fltk_SHARED)
endif()
create_example(unittests "${UNITTEST_SRCS}" "${UNITTEST_LIBS}")

# create additional test programs (used by developers for testing)

if(extra_tests)
  foreach(name ${extra_tests})
    create_example(${name} ${name}.cxx "fltk_images;fltk_gl;fltk")
  endforeach()
endif()

# OpenGL demos...
if(OPENGL_FOUND)
  create_example(
    CubeView "CubeMain.cxx;CubeView.cxx;CubeViewUI.fl" "fltk_gl;fltk"
  )
  create_example(cube cube.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
  create_example(fractals "fractals.cxx;fracviewer.cxx" "fltk_gl;fltk")
  create_example(fullscreen fullscreen.cxx "fltk_gl;fltk")
  create_example(glpuzzle glpuzzle.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
  create_example(gl_overlay gl_overlay.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
  create_example(shape shape.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
endif(OPENGL_FOUND)

# Cairo demo - must also be built w/o Cairo (displays a message box)
if(FLTK_HAVE_CAIRO)
  create_example(cairo_test cairo_test.cxx "fltk_cairo;fltk;cairo")
else()
  create_example(cairo_test cairo_test.cxx fltk)
endif(FLTK_HAVE_CAIRO)

# /EXPERIMENTAL/ Build some of the demo programs linked against the shared
# lib(s)

if(OPTION_BUILD_SHARED_LIBS)

  if(MSVC) # MS Visual C++ aka. Visual Studio

    # We need to link with fl_call_main.c, but this must not be compiled with
    # macro FL_DLL, whereas the other source file(s) must be compiled with
    # FL_DLL to link against the shared libs.
    #
    # ;-)  I *love* Visual Studio (MSVC)  ;-)
    #
    # Trick: build an object library with just this one file and link the
    # executable against the shared library plus this object library. Another
    # way would be to add the extra source file fl_call_main.c to the source
    # files of all targets and set the FL_DLL compile_definition property only
    # on the main *source* files but this doesn't work since the same file must
    # be compiled for the "static" and the "shared" target, for instance
    # hello.cxx for "hello" and "hello-shared".

    add_library(CALL_MAIN OBJECT EXCLUDE_FROM_ALL ../src/fl_call_main.c)

    # define a list of shared targets so we can set COMPILE_DEFINITIONS in a
    # loop
    set(SHARED_TARGETS "")

    create_example(hello-shared hello.cxx "fltk_SHARED;CALL_MAIN")
    create_example(
      pixmap_browser-shared pixmap_browser.cxx "fltk_SHARED;CALL_MAIN"
    )
    create_example(
      unittests-shared "${UNITTEST_SRCS}" "${UNITTEST_LIBS_SHARED};CALL_MAIN"
    )

    list(APPEND SHARED_TARGETS hello pixmap_browser unittests)

    if(OPENGL_FOUND)
      create_example(
        glpuzzle-shared glpuzzle.cxx
        "fltk_SHARED;CALL_MAIN;${OPENGL_LIBRARIES}"
      )
      create_example(
        shape-shared shape.cxx "fltk_SHARED;CALL_MAIN;${OPENGL_LIBRARIES}"
      )

      list(APPEND SHARED_TARGETS glpuzzle shape)

    endif(OPENGL_FOUND)

    # apply property COMPILE_DEFINITIONS "-D FL_DLL" in a loop for all necessary
    # source files
    foreach(tgt ${SHARED_TARGETS})
      target_compile_definitions(${tgt}-shared PRIVATE "FL_DLL")
    endforeach()

  else() # not MSVC

    create_example(hello-shared hello.cxx fltk_SHARED)
    create_example(
      pixmap_browser-shared pixmap_browser.cxx "fltk_images_SHARED;fltk_SHARED"
    )
    create_example(
      unittests-shared "${UNITTEST_SRCS}" "${UNITTEST_LIBS_SHARED}"
    )

    if(OPENGL_FOUND)
      create_example(
        glpuzzle-shared glpuzzle.cxx
        "fltk_gl_SHARED;fltk_SHARED;${OPENGL_LIBRARIES}"
      )
      create_example(
        shape-shared shape.cxx "fltk_gl_SHARED;fltk_SHARED;${OPENGL_LIBRARIES}"
      )
    endif(OPENGL_FOUND)

    if(FLTK_HAVE_CAIRO)
      create_example(
        cairo_test-shared cairo_test.cxx "fltk_cairo_SHARED;fltk_SHARED;cairo"
      )
    endif()

  endif(MSVC) # (not MSVC)

endif(OPTION_BUILD_SHARED_LIBS)

# ##############################################################################
# We need some support files for the demo programs
# ##############################################################################

# copy the required test files

file(COPY demo.menu rgb.txt browser.cxx editor.cxx valuators.fl help_dialog.html
     DESTINATION ${TESTFILE_PATH}
)

# copy the image directory for help_dialog.html

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/images DESTINATION ${TESTFILE_PATH})

# The main test program 'demo' needs additional hints and configurations. Note:
# CMake defines "CMAKE_INTDIR" which is the build type folder (e.g. "Debug") for
# multi config builds (MSVC, Xcode)

target_compile_definitions(demo PRIVATE GENERATED_BY_CMAKE)
