#
# CMakeLists.txt used to build test and demo apps by the CMake build system
#
# Copyright 2004-2021 by Bill Spitzak and others.
#
# This library is free software. Distribution and use rights are outlined in
# the file "COPYING" which should have been included with this file.  If this
# file is missing or damaged, see the license at:
#
#     https://www.fltk.org/COPYING.php
#
# Please see the following page on how to report bugs and issues:
#
#     https://www.fltk.org/bugs.php
#
#######################################################################

include(../CMake/FLTK-Functions.cmake)
include(../CMake/fl_create_example.cmake)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/../bin/test)
set(TESTFILE_PATH ${CMAKE_CURRENT_BINARY_DIR}/../data)

# create data and binary directory to copy scripts and data files

file(MAKE_DIRECTORY ${EXECUTABLE_OUTPUT_PATH})
file(MAKE_DIRECTORY ${TESTFILE_PATH})

#######################################################################
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

#######################################################################
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
)

#######################################################################

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
create_example(checkers "checkers.cxx;checkers.plist;checkers.icns" fltk)
create_example(clock clock.cxx fltk)
create_example(colbrowser colbrowser.cxx fltk)
create_example(color_chooser color_chooser.cxx fltk)
create_example(cursor cursor.cxx fltk)
create_example(curve curve.cxx fltk)
create_example(demo demo.cxx fltk)
create_example(device device.cxx fltk)
create_example(doublebuffer doublebuffer.cxx fltk)
create_example(editor "editor.cxx;editor.plist" fltk)
create_example(fast_slow fast_slow.fl fltk)
create_example(file_chooser file_chooser.cxx "fltk_images;fltk")
create_example(fltk-versions fltk-versions.cxx fltk)
create_example(fonts fonts.cxx fltk)
create_example(forms forms.cxx "fltk_forms;fltk")
create_example(hello hello.cxx fltk)
create_example(help_dialog help.cxx "fltk_images;fltk")
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
create_example(rotated_text rotated_text.cxx fltk)
create_example(scroll scroll.cxx fltk)
create_example(subwindow subwindow.cxx fltk)
create_example(sudoku "sudoku.cxx;sudoku.plist;sudoku.icns;sudoku.rc" "fltk_images;fltk;${AUDIOLIBS}")
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
create_example(unittests unittests.cxx fltk)
create_example(windowfocus windowfocus.cxx fltk)

# OpenGL demos...
if(OPENGL_FOUND)
  create_example(CubeView "CubeMain.cxx;CubeView.cxx;CubeViewUI.fl" "fltk_gl;fltk")
  create_example(cube cube.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
  create_example(fractals "fractals.cxx;fracviewer.cxx" "fltk_gl;fltk")
  create_example(fullscreen fullscreen.cxx "fltk_gl;fltk")
  create_example(glpuzzle glpuzzle.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
  create_example(gl_overlay gl_overlay.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
  create_example(shape shape.cxx "fltk_gl;fltk;${OPENGL_LIBRARIES}")
endif(OPENGL_FOUND)

# Cairo demo - must also be built w/o Cairo (displays a message box)
if(FLTK_HAVE_CAIRO)
  create_example(cairo_test cairo_test.cxx "fltk_cairo;fltk")
else()
  create_example(cairo_test cairo_test.cxx fltk)
endif(FLTK_HAVE_CAIRO)

#####################################################
# We need some support files for the demo programs
#####################################################

# copy the required test files

file(
  COPY
  rgb.txt browser.cxx editor.cxx valuators.fl
  help_dialog.html
  DESTINATION ${TESTFILE_PATH}
)

# copy and modify test/demo.menu (replace "help" with "help_dialog")

file(READ demo.menu menu_in)
string(REPLACE "HelpDialog:help " "HelpDialog:help_dialog " menu_out ${menu_in})
file(WRITE ${TESTFILE_PATH}/demo.menu ${menu_out})

# copy the image directory for help_dialog.html

file(
  COPY
  ${CMAKE_CURRENT_SOURCE_DIR}/images
  DESTINATION ${TESTFILE_PATH}
)

# The main test program 'demo' needs additional hints and configurations.
# Note: CMake defines "CMAKE_INTDIR" which is the build type folder (e.g. "Debug")
# for multi config builds (MSVC, Xcode)

target_compile_definitions(demo PRIVATE GENERATED_BY_CMAKE)
