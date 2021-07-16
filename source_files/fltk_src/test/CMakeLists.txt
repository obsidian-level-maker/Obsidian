set(EXECUTABLE_OUTPUT_PATH ${FLTK_BINARY_DIR}/bin/examples)

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
endif(WIN32)

# ##############################################################################
include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

# ##############################################################################
if(APPLE AND NOT OPTION_APPLE_X11)
  add_definitions(-DUSING_XCODE)
endif(APPLE AND NOT OPTION_APPLE_X11)

# ##############################################################################
create_example(adjuster adjuster.cxx fltk)
create_example(arc arc.cxx fltk)
create_example(animated animated.cxx fltk)
create_example(ask ask.cxx fltk)
create_example(bitmap bitmap.cxx fltk)

set(BLOCKS_ICON
    "${CMAKE_CURRENT_SOURCE_DIR}/blocks.app/Contents/Resources/blocks.icns"
)
create_example(blocks "blocks.cxx;${BLOCKS_ICON}" "fltk;${AUDIOLIBS}")

create_example(boxtype boxtype.cxx fltk)
create_example(browser browser.cxx fltk)
create_example(button button.cxx fltk)
create_example(buttons buttons.cxx fltk)

set(CHECKERS_ICON
    "${CMAKE_CURRENT_SOURCE_DIR}/checkers.app/Contents/Resources/checkers.icns"
)
create_example(checkers "checkers.cxx;${CHECKERS_ICON}" fltk)

create_example(clock clock.cxx fltk)
create_example(colbrowser colbrowser.cxx "fltk;fltk_forms")
create_example(color_chooser color_chooser.cxx fltk)
create_example(cursor cursor.cxx fltk)
create_example(curve curve.cxx fltk)

create_example(demo "demo.cxx;demo.menu" fltk)
set_source_files_properties(
  demo.menu PROPERTIES MACOSX_PACKAGE_LOCATION Resources
)

create_example(device device.cxx fltk)
create_example(doublebuffer doublebuffer.cxx fltk)

create_example(editor editor.cxx fltk)
set_target_properties(
  editor PROPERTIES MACOSX_BUNDLE_INFO_PLIST
                    "${PROJECT_SOURCE_DIR}/ide/Xcode4/plists/editor-Info.plist"
)

create_example(fast_slow fast_slow.fl fltk)
create_example(file_chooser file_chooser.cxx "fltk;fltk_images")
create_example(fonts fonts.cxx fltk)
create_example(forms forms.cxx "fltk;fltk_forms")
create_example(hello hello.cxx fltk)
create_example(help help.cxx "fltk;fltk_images")
create_example(icon icon.cxx fltk)
create_example(iconize iconize.cxx fltk)
create_example(image image.cxx fltk)
create_example(inactive inactive.fl fltk)
create_example(input input.cxx fltk)
create_example(input_choice input_choice.cxx fltk)
create_example(keyboard "keyboard.cxx;keyboard_ui.fl" fltk)
create_example(label label.cxx "fltk;fltk_forms")
create_example(line_style line_style.cxx fltk)
create_example(list_visuals list_visuals.cxx fltk)
create_example(mandelbrot "mandelbrot_ui.fl;mandelbrot.cxx" fltk)
create_example(menubar menubar.cxx fltk)
create_example(message message.cxx fltk)
create_example(minimum minimum.cxx fltk)
create_example(native-filechooser native-filechooser.cxx "fltk;fltk_images")
create_example(navigation navigation.cxx fltk)
create_example(output output.cxx "fltk;fltk_forms")
create_example(overlay overlay.cxx fltk)
create_example(pack pack.cxx fltk)
create_example(pixmap pixmap.cxx fltk)
create_example(pixmap_browser pixmap_browser.cxx "fltk;fltk_images")
create_example(preferences preferences.fl fltk)
create_example(offscreen offscreen.cxx fltk)
create_example(radio radio.fl fltk)
create_example(resize resize.fl fltk)
create_example(resizebox resizebox.cxx fltk)
create_example(rotated_text rotated_text.cxx fltk)
create_example(scroll scroll.cxx fltk)
create_example(subwindow subwindow.cxx fltk)

set(SUDOKU_ICON
    "${CMAKE_CURRENT_SOURCE_DIR}/sudoku.app/Contents/Resources/sudoku.icns"
)
create_example(
  sudoku "sudoku.cxx;${SUDOKU_ICON}" "fltk;fltk_images;${AUDIOLIBS}"
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
create_example(unittests unittests.cxx fltk)
create_example(windowfocus windowfocus.cxx fltk)

create_example(fltk-versions ../examples/fltk-versions.cxx fltk)

# OpenGL demos...
if(OPENGL_FOUND)
  create_example(
    CubeView "CubeMain.cxx;CubeView.cxx;CubeViewUI.fl" "fltk;fltk_gl"
  )
  create_example(cube cube.cxx "fltk;fltk_gl;${OPENGL_LIBRARIES}")
  create_example(fractals "fractals.cxx;fracviewer.cxx" "fltk;fltk_gl")
  create_example(fullscreen fullscreen.cxx "fltk;fltk_gl")
  create_example(glpuzzle glpuzzle.cxx "fltk;fltk_gl;${OPENGL_LIBRARIES}")
  create_example(gl_overlay gl_overlay.cxx "fltk;fltk_gl;${OPENGL_LIBRARIES}")
  create_example(shape shape.cxx "fltk;fltk_gl;${OPENGL_LIBRARIES}")
endif(OPENGL_FOUND)

# Cairo demo
if(FLTK_HAVE_CAIRO)
  create_example(cairo_test cairo_test.cxx "fltk;fltk_cairo")
endif(FLTK_HAVE_CAIRO)

# We need some support files for the demo programs:

# Note: this is incomplete as of 11 Feb 2015 Todo: currently all files are
# copied, but some of them need configuration: - demo.menu: fluid can't be
# started (wrong path) - demo.menu: help (help-test.html) can't find its images
# (not copied) - maybe more ...

# prepare for a "better" test file installation path
set(TESTFILE_PATH ${EXECUTABLE_OUTPUT_PATH})

# *FIXME* *DEBUG* message ("test/CMakeLists.txt: EXECUTABLE_OUTPUT_PATH =
# '${EXECUTABLE_OUTPUT_PATH}'") message ("test/CMakeLists.txt: TESTFILE_PATH =
# '${TESTFILE_PATH}'")

# use a target filename to make sure the target directory gets created
configure_file(demo.menu ${TESTFILE_PATH}/demo.menu COPYONLY)

# use target directory only to avoid redundancy
configure_file(rgb.txt ${TESTFILE_PATH} COPYONLY)
configure_file(help-test.html ${TESTFILE_PATH} COPYONLY)
configure_file(browser.cxx ${TESTFILE_PATH} COPYONLY)
configure_file(editor.cxx ${TESTFILE_PATH} COPYONLY)
if(APPLE AND NOT OPTION_APPLE_X11)
  configure_file(
    browser.cxx "${TESTFILE_PATH}/browser.app/Contents/Resources/browser.cxx"
    COPYONLY
  )
  configure_file(
    rgb.txt ${TESTFILE_PATH}/colbrowser.app/Contents/Resources/rgb.txt COPYONLY
  )
  configure_file(
    help-test.html ${TESTFILE_PATH}/help.app/Contents/Resources/help-test.html
    COPYONLY
  )
endif(APPLE AND NOT OPTION_APPLE_X11)
