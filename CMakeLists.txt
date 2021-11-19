cmake_minimum_required(VERSION 3.12..3.20)

include(cmake/CPM.cmake)

add_subdirectory(source_files/acc)
add_subdirectory(source_files/filename_formatter)
add_subdirectory(source_files/fmt)
add_subdirectory(source_files/lua)
add_subdirectory(source_files/physfs)
add_subdirectory(source_files/qsavetex)
add_subdirectory(source_files/slump)
add_subdirectory(source_files/zdbsp)
add_subdirectory(source_files/zlib)

project(
  obsidian
  LANGUAGES CXX
  VERSION 0.1.0
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "-O2 -Wall")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if(WIN32 AND NOT MINGW AND NOT MSYS)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHa")
  set(CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:WINDOWS")
endif()
if(MSYS)
  set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows -Isource_files/zlib/libzlibstatic.a")
endif()

if(false)
  set(CMAKE_CXX_CLANG_TIDY clang-tidy)
  file(GLOB ALL_SOURCES "source_files/obsidian/*.cc" "source_files/obsidian/*.hh")
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
  source_files/obsidian/aj_local.h
  source_files/obsidian/aj_map.cc
  source_files/obsidian/aj_map.h
  source_files/obsidian/aj_poly.cc
  source_files/obsidian/aj_poly.h
  source_files/obsidian/aj_structs.h
  source_files/obsidian/aj_util.cc
  source_files/obsidian/aj_util.h
  source_files/obsidian/aj_wad.cc
  source_files/obsidian/aj_wad.h
  source_files/obsidian/csg_bsp.cc
  source_files/obsidian/csg_clip.cc
  source_files/obsidian/csg_doom.cc
  source_files/obsidian/csg_local.h
  source_files/obsidian/csg_main.cc
  source_files/obsidian/csg_main.h
  source_files/obsidian/csg_nukem.cc
  source_files/obsidian/csg_quake.cc
  source_files/obsidian/csg_quake.h
  source_files/obsidian/csg_shade.cc
  source_files/obsidian/csg_spots.cc
  source_files/obsidian/dm_extra.cc
  source_files/obsidian/dm_extra.h
  source_files/obsidian/dm_prefab.cc
  source_files/obsidian/dm_prefab.h
  source_files/obsidian/g_doom.cc
  source_files/obsidian/g_doom.h
  source_files/obsidian/g_nukem.cc
  source_files/obsidian/g_nukem.h
  source_files/obsidian/g_quake.cc
  source_files/obsidian/g_quake2.cc
  source_files/obsidian/g_quake3.cc
  source_files/obsidian/hdr_fltk.h
  source_files/obsidian/hdr_lua.h
  source_files/obsidian/hdr_ui.h
  source_files/obsidian/headers.h
  source_files/obsidian/images.h
  source_files/obsidian/lib_argv.cc
  source_files/obsidian/lib_argv.h
  source_files/obsidian/lib_crc.cc
  source_files/obsidian/lib_crc.h
  source_files/obsidian/lib_file.cc
  source_files/obsidian/lib_file.h
  source_files/obsidian/lib_grp.cc
  source_files/obsidian/lib_grp.h
  source_files/obsidian/lib_pak.cc
  source_files/obsidian/lib_pak.h
  source_files/obsidian/lib_signal.cc
  source_files/obsidian/lib_signal.h
  source_files/obsidian/lib_tga.cc
  source_files/obsidian/lib_tga.h
  source_files/obsidian/lib_util.cc
  source_files/obsidian/lib_util.h
  source_files/obsidian/lib_wad.cc
  source_files/obsidian/lib_wad.h
  source_files/obsidian/lib_zip.cc
  source_files/obsidian/lib_zip.h
  source_files/obsidian/m_about.cc
  source_files/obsidian/m_addons.cc
  source_files/obsidian/m_addons.h
  source_files/obsidian/m_cookie.cc
  source_files/obsidian/m_cookie.h
  source_files/obsidian/m_dialog.cc
  source_files/obsidian/m_lua.cc
  source_files/obsidian/m_lua.h
  source_files/obsidian/m_manage.cc
  source_files/obsidian/m_options.cc
  source_files/obsidian/m_theme.cc
  source_files/obsidian/m_trans.cc
  source_files/obsidian/m_trans.h
  source_files/obsidian/main.cc
  source_files/obsidian/main.h
  source_files/obsidian/obsidian.rc
  source_files/obsidian/q1_structs.h
  source_files/obsidian/q2_structs.h
  source_files/obsidian/q3_structs.h
  source_files/obsidian/q_common.cc
  source_files/obsidian/q_common.h
  source_files/obsidian/q_light.cc
  source_files/obsidian/q_light.h
  source_files/obsidian/q_tjuncs.cc
  source_files/obsidian/q_vis.cc
  source_files/obsidian/q_vis.h
  source_files/obsidian/sys_assert.cc
  source_files/obsidian/sys_assert.h
  source_files/obsidian/sys_debug.cc
  source_files/obsidian/sys_debug.h
  source_files/obsidian/sys_endian.h
  source_files/obsidian/sys_macro.h
  source_files/obsidian/sys_type.h
  source_files/obsidian/sys_xoshiro.cc
  source_files/obsidian/sys_xoshiro.h
  source_files/obsidian/tx_forge.cc
  source_files/obsidian/tx_forge.h
  source_files/obsidian/tx_skies.cc
  source_files/obsidian/tx_skies.h
  source_files/obsidian/ui_build.cc
  source_files/obsidian/ui_build.h
  source_files/obsidian/ui_boxes.cc
  source_files/obsidian/ui_boxes.h
  source_files/obsidian/ui_game.cc
  source_files/obsidian/ui_game.h
  source_files/obsidian/ui_hyper.cc
  source_files/obsidian/ui_hyper.h
  source_files/obsidian/ui_map.cc
  source_files/obsidian/ui_map.h
  source_files/obsidian/ui_module.cc
  source_files/obsidian/ui_module.h
  source_files/obsidian/ui_widgets.cc
  source_files/obsidian/ui_widgets.h
  source_files/obsidian/ui_window.cc
  source_files/obsidian/ui_window.h
  source_files/obsidian/vis_buffer.cc
  source_files/obsidian/vis_buffer.h
  source_files/obsidian/vis_occlude.cc
  source_files/obsidian/vis_occlude.h
  source_files/obsidian/zf_menu.cc
  source_files/obsidian/zf_menu.h
  "source_files/obsidian/defines.h"
)

target_include_directories(obsidian PRIVATE source_files/fastPRNG)
target_include_directories(obsidian PRIVATE source_files/lua)
target_include_directories(obsidian PRIVATE source_files/physfs)
target_include_directories(obsidian PRIVATE source_files/slump)
target_include_directories(obsidian PRIVATE source_files/zdbsp)
target_include_directories(obsidian PRIVATE source_files/zlib)

if(MINGW OR WIN32 OR MSYS)
  target_compile_definitions(obsidian PRIVATE WIN32)
else()
  target_compile_definitions(obsidian PRIVATE UNIX)
endif()

if(UNIX)
  find_package(FLTK 1.3)
endif()

if(FLTK_FOUND AND NOT MSYS)
  target_link_libraries(obsidian PRIVATE ${FLTK_LIBRARIES})
else()
  # use vendored version
  add_subdirectory(source_files/fltk)
  target_link_libraries(obsidian PRIVATE fltk fltk_images)
  target_include_directories(obsidian PRIVATE source_files/fltk)
endif()

if(WIN32 OR MSYS)
  add_subdirectory(source_files/wingetopt)
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
  COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:filename_formatter>"
          "${CMAKE_CURRENT_LIST_DIR}/tools"
  COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:qsavetex>"
          "${CMAKE_CURRENT_LIST_DIR}/tools"
)

add_dependencies(obsidian filename_formatter qsavetex)

if(UNIX)
  target_link_libraries(
    obsidian
    PRIVATE zlibstatic
            obsidian_lua
            obsidian_physfs
            obsidian_acc
            obsidian_zdbsp
            obsidian_slump
            fontconfig
  )
else()
  target_link_libraries(
    obsidian
    PRIVATE zlibstatic
            obsidian_lua
            obsidian_physfs
            obsidian_acc
            obsidian_zdbsp
            obsidian_slump
  )
endif()
