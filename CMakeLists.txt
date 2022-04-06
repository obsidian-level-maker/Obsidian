cmake_minimum_required(VERSION 3.12..3.20)

include(cmake/CPM.cmake)

option(USE_FLTK_14 "Build with FLTK 1.4" OFF)

add_subdirectory(source_files/filename_formatter)
if (USE_FLTK_14)
  add_subdirectory(source_files/fltk14)
else()
  add_subdirectory(source_files/fltk)
endif()
add_subdirectory(source_files/fmt)
add_subdirectory(source_files/lua)
add_subdirectory(source_files/miniz)
add_subdirectory(source_files/physfs)
add_subdirectory(source_files/qsavetex)
add_subdirectory(source_files/slump)
add_subdirectory(source_files/zdbsp)

project(
  obsidian
  LANGUAGES CXX
  VERSION 0.1.0
)

string(TIMESTAMP BUILD_TIMESTAMP "%Y.%m.%d" UTC)
add_compile_definitions(OBSIDIAN_TIMESTAMP="${BUILD_TIMESTAMP}")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
if(WIN32
   AND NOT MINGW
   AND NOT MSYS
)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHa")
  set(CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:WINDOWS")
endif()
if(MSYS)
  set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_CXX_CLANG_TIDY clang-tidy)
  file(GLOB ALL_SOURCES "source_files/obsidian_main/*.cc"
       "source_files/obsidian_main/*.h"
  )
  add_custom_target(
    clang-tidy COMMAND "${CMAKE_CXX_CLANG_TIDY}" -p "${CMAKE_BINARY_DIR}"
                       ${ALL_SOURCES}
  )
endif()

cpmaddpackage(
  NAME
  Format.cmake
  VERSION
  1.7.0
  GITHUB_REPOSITORY
  TheLartians/Format.cmake
  OPTIONS
  # set to "yes" to skip CMake formatting
  "FORMAT_SKIP_CMAKE NO"
  # path to exclude from formatting (optional + regex)
  "CMAKE_FORMAT_EXCLUDE cmake/CPM.cmake"
)

add_executable(
  obsidian
  cpp.hint
  source_files/obsidian_main/aj_map.cc
  source_files/obsidian_main/aj_poly.cc
  source_files/obsidian_main/aj_util.cc
  source_files/obsidian_main/aj_wad.cc
  source_files/obsidian_main/csg_bsp.cc
  source_files/obsidian_main/csg_clip.cc
  source_files/obsidian_main/csg_doom.cc
  source_files/obsidian_main/csg_main.cc
  source_files/obsidian_main/csg_nukem.cc
  source_files/obsidian_main/csg_quake.cc
  source_files/obsidian_main/csg_shade.cc
  source_files/obsidian_main/csg_spots.cc
  source_files/obsidian_main/dm_extra.cc
  source_files/obsidian_main/dm_prefab.cc
  source_files/obsidian_main/g_doom.cc
  source_files/obsidian_main/g_nukem.cc
  source_files/obsidian_main/g_quake.cc
  source_files/obsidian_main/g_quake2.cc
  source_files/obsidian_main/g_quake3.cc
  source_files/obsidian_main/lib_argv.cc
  source_files/obsidian_main/lib_crc.cc
  source_files/obsidian_main/lib_file.cc
  source_files/obsidian_main/lib_grp.cc
  source_files/obsidian_main/lib_pak.cc
  source_files/obsidian_main/lib_signal.cc
  source_files/obsidian_main/lib_tga.cc
  source_files/obsidian_main/lib_util.cc
  source_files/obsidian_main/lib_wad.cc
  source_files/obsidian_main/lib_zip.cc
  source_files/obsidian_main/m_about.cc
  source_files/obsidian_main/m_addons.cc
  source_files/obsidian_main/m_cookie.cc
  source_files/obsidian_main/m_dialog.cc
  source_files/obsidian_main/m_lua.cc
  source_files/obsidian_main/m_manage.cc
  source_files/obsidian_main/m_options.cc
  source_files/obsidian_main/m_theme.cc
  source_files/obsidian_main/m_trans.cc
  source_files/obsidian_main/m_tutorial.cc
  source_files/obsidian_main/main.cc
  source_files/obsidian_main/obsidian.rc
  source_files/obsidian_main/q_common.cc
  source_files/obsidian_main/q_light.cc
  source_files/obsidian_main/q_tjuncs.cc
  source_files/obsidian_main/q_vis.cc
  source_files/obsidian_main/sys_assert.cc
  source_files/obsidian_main/sys_debug.cc
  source_files/obsidian_main/sys_xoshiro.cc
  source_files/obsidian_main/tx_forge.cc
  source_files/obsidian_main/tx_skies.cc
  source_files/obsidian_main/ui_boxes.cc
  source_files/obsidian_main/ui_build.cc
  source_files/obsidian_main/ui_game.cc
  source_files/obsidian_main/ui_hyper.cc
  source_files/obsidian_main/ui_map.cc
  source_files/obsidian_main/ui_module.cc
  source_files/obsidian_main/ui_widgets.cc
  source_files/obsidian_main/ui_window.cc
  source_files/obsidian_main/vis_buffer.cc
  source_files/obsidian_main/vis_occlude.cc
  source_files/obsidian_main/zf_menu.cc
)

target_include_directories(obsidian PRIVATE source_files/filename_formatter)
if (USE_FLTK_14)
  target_include_directories(obsidian PRIVATE source_files/fltk14)
else ()
  target_include_directories(obsidian PRIVATE source_files/fltk)
endif ()
target_include_directories(obsidian PRIVATE source_files/gif-h)
target_include_directories(obsidian PRIVATE source_files/lua)
target_include_directories(obsidian PRIVATE source_files/miniz)
target_include_directories(obsidian PRIVATE source_files/physfs)
target_include_directories(obsidian PRIVATE source_files/slump)
target_include_directories(obsidian PRIVATE source_files/zdbsp)

if(MINGW
   OR WIN32
   OR MSYS
)
  target_compile_definitions(obsidian PRIVATE WIN32)
else()
  target_compile_definitions(obsidian PRIVATE UNIX)
endif()

if(UNIX)
  find_package(X11 REQUIRED)
  target_link_libraries(obsidian PRIVATE X11::Xft)
endif()

target_link_libraries(obsidian PRIVATE fmt::fmt-header-only)

# Copies executables to local install directory after build
add_custom_command(
  TARGET obsidian
  POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:obsidian>"
          "${CMAKE_CURRENT_LIST_DIR}"
  COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:qsavetex>"
          "${CMAKE_CURRENT_LIST_DIR}/tools"
)

add_dependencies(obsidian qsavetex)

if(UNIX)
  target_link_libraries(
    obsidian PRIVATE filename_formatter fltk fltk_images miniz obsidian_lua obsidian_physfs obsidian_zdbsp
                     obsidian_slump fontconfig
  )
else()
  target_link_libraries(
    obsidian PRIVATE filename_formatter fltk fltk_images miniz obsidian_lua obsidian_physfs obsidian_zdbsp
                     obsidian_slump
  )
endif()

install(TARGETS obsidian RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}
                                 CONFIGURATIONS Release
)
install(TARGETS qsavetex
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/tools
                CONFIGURATIONS Release
)
install(
  DIRECTORY addons
            data
            engines
            games
            language
            modules
            scripts
            theme
            tools
  DESTINATION ${CMAKE_INSTALL_PREFIX}
  CONFIGURATIONS Release
)
