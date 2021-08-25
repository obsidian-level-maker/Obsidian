cmake_minimum_required(VERSION 3.12..3.20)

include(cmake/CPM.cmake)

add_subdirectory(source_files/lua_src)
add_subdirectory(source_files/acc_src)
add_subdirectory(source_files/ff_src)
add_subdirectory(source_files/physfs_src)
add_subdirectory(source_files/zdbsp_src)
add_subdirectory(source_files/slump_src)
add_subdirectory(source_files/zlib_src)
add_subdirectory(source_files/fmt_src)
add_subdirectory(source_files/whereami_src)

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
  set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows -Isource_files/zlib_src/libzlibstatic.a")
endif()

if(false)
  set(CMAKE_CXX_CLANG_TIDY clang-tidy)
  file(GLOB ALL_SOURCES "source_files/obsidian_src/*.cc" "source_files/obsidian_src/*.hh")
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
  source_files/obsidian_src/aj_local.h
  source_files/obsidian_src/aj_map.cc
  source_files/obsidian_src/aj_map.h
  source_files/obsidian_src/aj_poly.cc
  source_files/obsidian_src/aj_poly.h
  source_files/obsidian_src/aj_structs.h
  source_files/obsidian_src/aj_util.cc
  source_files/obsidian_src/aj_util.h
  source_files/obsidian_src/aj_wad.cc
  source_files/obsidian_src/aj_wad.h
  source_files/obsidian_src/csg_bsp.cc
  source_files/obsidian_src/csg_clip.cc
  source_files/obsidian_src/csg_doom.cc
  source_files/obsidian_src/csg_local.h
  source_files/obsidian_src/csg_main.cc
  source_files/obsidian_src/csg_main.h
  source_files/obsidian_src/csg_nukem.cc
  source_files/obsidian_src/csg_quake.cc
  source_files/obsidian_src/csg_quake.h
  source_files/obsidian_src/csg_shade.cc
  source_files/obsidian_src/csg_spots.cc
  source_files/obsidian_src/dm_extra.cc
  source_files/obsidian_src/dm_extra.h
  source_files/obsidian_src/dm_prefab.cc
  source_files/obsidian_src/dm_prefab.h
  source_files/obsidian_src/g_doom.cc
  source_files/obsidian_src/g_doom.h
  source_files/obsidian_src/g_nukem.cc
  source_files/obsidian_src/g_nukem.h
  source_files/obsidian_src/g_quake.cc
  source_files/obsidian_src/g_quake2.cc
  source_files/obsidian_src/g_quake3.cc
  source_files/obsidian_src/g_wolf.cc
  source_files/obsidian_src/hdr_fltk.h
  source_files/obsidian_src/hdr_lua.h
  source_files/obsidian_src/hdr_ui.h
  source_files/obsidian_src/headers.h
  source_files/obsidian_src/images.h
  source_files/obsidian_src/lib_argv.cc
  source_files/obsidian_src/lib_argv.h
  source_files/obsidian_src/lib_crc.cc
  source_files/obsidian_src/lib_crc.h
  source_files/obsidian_src/lib_file.cc
  source_files/obsidian_src/lib_file.h
  source_files/obsidian_src/lib_grp.cc
  source_files/obsidian_src/lib_grp.h
  source_files/obsidian_src/lib_pak.cc
  source_files/obsidian_src/lib_pak.h
  source_files/obsidian_src/lib_signal.cc
  source_files/obsidian_src/lib_signal.h
  source_files/obsidian_src/lib_tga.cc
  source_files/obsidian_src/lib_tga.h
  source_files/obsidian_src/lib_util.cc
  source_files/obsidian_src/lib_util.h
  source_files/obsidian_src/lib_wad.cc
  source_files/obsidian_src/lib_wad.h
  source_files/obsidian_src/lib_zip.cc
  source_files/obsidian_src/lib_zip.h
  source_files/obsidian_src/m_about.cc
  source_files/obsidian_src/m_addons.cc
  source_files/obsidian_src/m_addons.h
  source_files/obsidian_src/m_cookie.cc
  source_files/obsidian_src/m_cookie.h
  source_files/obsidian_src/m_dialog.cc
  source_files/obsidian_src/m_lua.cc
  source_files/obsidian_src/m_lua.h
  source_files/obsidian_src/m_manage.cc
  source_files/obsidian_src/m_options.cc
  source_files/obsidian_src/m_theme.cc
  source_files/obsidian_src/m_trans.cc
  source_files/obsidian_src/m_trans.h
  source_files/obsidian_src/main.cc
  source_files/obsidian_src/main.h
  source_files/obsidian_src/q1_structs.h
  source_files/obsidian_src/q2_structs.h
  source_files/obsidian_src/q3_structs.h
  source_files/obsidian_src/q_common.cc
  source_files/obsidian_src/q_common.h
  source_files/obsidian_src/q_light.cc
  source_files/obsidian_src/q_light.h
  source_files/obsidian_src/q_tjuncs.cc
  source_files/obsidian_src/q_vis.cc
  source_files/obsidian_src/q_vis.h
  source_files/obsidian_src/sys_assert.cc
  source_files/obsidian_src/sys_assert.h
  source_files/obsidian_src/sys_debug.cc
  source_files/obsidian_src/sys_debug.h
  source_files/obsidian_src/sys_endian.h
  source_files/obsidian_src/sys_macro.h
  source_files/obsidian_src/sys_type.h
  source_files/obsidian_src/sys_twister.cc
  source_files/obsidian_src/sys_twister.h
  source_files/obsidian_src/tx_forge.cc
  source_files/obsidian_src/tx_forge.h
  source_files/obsidian_src/tx_skies.cc
  source_files/obsidian_src/tx_skies.h
  source_files/obsidian_src/ui_build.cc
  source_files/obsidian_src/ui_build.h
  source_files/obsidian_src/ui_boxes.cc
  source_files/obsidian_src/ui_boxes.h
  source_files/obsidian_src/ui_game.cc
  source_files/obsidian_src/ui_game.h
  source_files/obsidian_src/ui_hyper.cc
  source_files/obsidian_src/ui_hyper.h
  source_files/obsidian_src/ui_map.cc
  source_files/obsidian_src/ui_map.h
  source_files/obsidian_src/ui_module.cc
  source_files/obsidian_src/ui_module.h
  source_files/obsidian_src/ui_widgets.cc
  source_files/obsidian_src/ui_widgets.h
  source_files/obsidian_src/ui_window.cc
  source_files/obsidian_src/ui_window.h
  source_files/obsidian_src/vis_buffer.cc
  source_files/obsidian_src/vis_buffer.h
  source_files/obsidian_src/vis_occlude.cc
  source_files/obsidian_src/vis_occlude.h
  source_files/obsidian_src/zf_menu.cc
  source_files/obsidian_src/zf_menu.h
  "source_files/obsidian_src/defines.h"
)

target_include_directories(obsidian PRIVATE source_files/physfs_src)
target_include_directories(obsidian PRIVATE source_files/zdbsp_src)
target_include_directories(obsidian PRIVATE source_files/lua_src)
target_include_directories(obsidian PRIVATE source_files/slump_src)
target_include_directories(obsidian PRIVATE source_files/whereami_src)
target_include_directories(obsidian PRIVATE source_files/zlib_src)
target_include_directories(obsidian PRIVATE source_files/gui)

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
  add_subdirectory(source_files/fltk_src)
  target_link_libraries(obsidian PRIVATE fltk fltk_images)
  target_include_directories(obsidian PRIVATE source_files/fltk_src)
endif()

if(WIN32 OR MSYS)
  add_subdirectory(source_files/wingetopt_src)
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
)

add_dependencies(obsidian filename_formatter)

if(UNIX)
  target_link_libraries(
    obsidian
    PRIVATE zlibstatic
            obsidian_lua
            obsidian_physfs
            obsidian_acc
            obsidian_zdbsp
            obsidian_slump
            obsidian_whereami
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
            obsidian_whereami
  )
endif()
