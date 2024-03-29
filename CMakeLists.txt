cmake_minimum_required(VERSION 3.12..3.20)

include(cmake/CPM.cmake)

add_subdirectory(source_files/filename_formatter EXCLUDE_FROM_ALL)
if(NOT CONSOLE_ONLY AND NOT HAIKU)
  set(OPTION_USE_SYSTEM_ZLIB OFF)
  add_subdirectory(source_files/fltk EXCLUDE_FROM_ALL)
endif()
add_subdirectory(source_files/fmt EXCLUDE_FROM_ALL)
add_subdirectory(source_files/hedley EXCLUDE_FROM_ALL)
add_subdirectory(source_files/lua EXCLUDE_FROM_ALL)
add_subdirectory(source_files/miniz EXCLUDE_FROM_ALL)
add_subdirectory(source_files/physfs EXCLUDE_FROM_ALL)
add_subdirectory(source_files/qsavetex EXCLUDE_FROM_ALL)
add_subdirectory(source_files/slump EXCLUDE_FROM_ALL)
add_subdirectory(source_files/spdlog EXCLUDE_FROM_ALL)
add_subdirectory(source_files/zdbsp EXCLUDE_FROM_ALL)

project(
  obsidian
  LANGUAGES C CXX
  VERSION 0.1.0
)

string(TIMESTAMP BUILD_TIMESTAMP "%Y.%m.%d" UTC)
add_compile_definitions(OBSIDIAN_TIMESTAMP="${BUILD_TIMESTAMP}")

if(CONSOLE_ONLY OR HAIKU)
  add_compile_definitions(CONSOLE_ONLY=1)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
if(WIN32
   AND NOT MINGW
   AND NOT MSYS
)
  if(OBSIDIAN_MSVC_DEBUG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MDd /EHa")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHa")
  endif()
  if(NOT CONSOLE_ONLY)
    set(CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:WINDOWS")
  endif()
endif()
if(MSYS OR MINGW)
  if(NOT CONSOLE_ONLY)
    set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows")
  else()
    set(CMAKE_EXE_LINKER_FLAGS "-static")
  endif()
endif()
if(APPLE OR ${CMAKE_SYSTEM} MATCHES "BSD")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I /usr/local/include")
endif()
if(${CMAKE_SYSTEM} MATCHES "OpenBSD")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I /usr/X11R6/include")
endif()

if(OBSIDIAN_TIDY)
  set(CMAKE_CXX_CLANG_TIDY clang-tidy)
  file(GLOB ALL_SOURCES "source_files/obsidian_main/*.cc"
       "source_files/obsidian_main/*.h"
  )
  add_custom_target(
    clang-tidy COMMAND "${CMAKE_CXX_CLANG_TIDY}" -p "${CMAKE_BINARY_DIR}"
                       ${ALL_SOURCES}
  )
endif()

configure_file(cmake/config.h.cmake-in obsidian-include/obsidian_config.h)

# cpmaddpackage( NAME Format.cmake VERSION 1.7.0 GITHUB_REPOSITORY
# TheLartians/Format.cmake OPTIONS set to "yes" to skip CMake formatting
# "FORMAT_SKIP_CMAKE NO" path to exclude from formatting (optional + regex)
# "CMAKE_FORMAT_EXCLUDE cmake/CPM.cmake" )

if(NOT CONSOLE_ONLY AND NOT HAIKU)
  add_executable(
    obsidian
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
    source_files/obsidian_main/g_wolf.cc
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
  )
else()
  add_executable(
    obsidian
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
    source_files/obsidian_main/g_wolf.cc
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
    source_files/obsidian_main/m_addons.cc
    source_files/obsidian_main/m_cookie.cc
    source_files/obsidian_main/m_lua.cc
    source_files/obsidian_main/m_options.cc
    source_files/obsidian_main/m_trans.cc
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
    source_files/obsidian_main/vis_buffer.cc
    source_files/obsidian_main/vis_occlude.cc
  )
endif()

target_include_directories(
  obsidian SYSTEM PRIVATE source_files/filename_formatter
                          ${CMAKE_CURRENT_BINARY_DIR}/obsidian-include
)
if(NOT CONSOLE_ONLY AND NOT HAIKU)
  target_include_directories(obsidian SYSTEM PRIVATE source_files/fltk)
  target_include_directories(
    obsidian SYSTEM PRIVATE "${PROJECT_BINARY_DIR}/source_files/fltk"
  ) # Hack for FLTK 1.4 (for now)
endif()
target_include_directories(obsidian SYSTEM PRIVATE source_files/gif-h)
target_include_directories(obsidian SYSTEM PRIVATE source_files/lua/src)
target_include_directories(obsidian SYSTEM PRIVATE source_files/miniz)
target_include_directories(obsidian SYSTEM PRIVATE source_files/physfs/src)
target_include_directories(obsidian SYSTEM PRIVATE source_files/slump)
target_include_directories(
  obsidian SYSTEM PRIVATE source_files/spdlog/include/spdlog
)
target_include_directories(obsidian SYSTEM PRIVATE source_files/zdbsp)

if(MINGW
   OR WIN32
   OR MSYS
)
  target_compile_definitions(obsidian PRIVATE WIN32)
  target_compile_definitions(obsidian PRIVATE NOMINMAX)
  target_compile_definitions(obsidian PRIVATE _CRT_SECURE_NO_WARNINGS)
else()
  target_compile_definitions(obsidian PRIVATE UNIX)
endif()

if(OBSIDIAN_SANITIZE)
  target_compile_options(obsidian PRIVATE -fsanitize=address,undefined)
  target_link_options(obsidian PRIVATE -fsanitize=address,undefined)
endif()

if(OBSIDIAN_WARNINGS)
  if(MSVC)
    target_compile_options(obsidian PRIVATE -W4 -WX)
  else()
    target_compile_options(obsidian PRIVATE -Wall -Wextra -Wpedantic -Werror)
  endif()
endif()

if(OBSIDIAN_STATIC)
  target_link_options(obsidian PRIVATE -static)
endif()

if(UNIX)
  if(NOT CONSOLE_ONLY
     AND NOT HAIKU
     AND NOT APPLE
  )
    if(OBSIDIAN_STATIC)
      find_package(PkgConfig REQUIRED)
      pkg_check_modules(FC fontconfig)
      set(FONTCONFIG ${FC_STATIC_LIBRARIES})
    else()
      find_package(Fontconfig REQUIRED)
      set(FONTCONFIG fontconfig)
    endif()
  endif()
endif()

target_link_libraries(
  obsidian PRIVATE fmt::fmt-header-only hedley::hedley
                   spdlog::spdlog_header_only
)

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
  if(APPLE)
    if(NOT CONSOLE_ONLY)
      target_link_libraries(
        obsidian
        PRIVATE filename_formatter
                fltk
                fltk_images
                miniz
                libluajit
                physfs-static
                obsidian_zdbsp
                obsidian_slump
                "-framework Cocoa"
                "-framework CoreGraphics"
                "-framework CoreText"
                "-framework QuartzCore"
      )
    else()
      target_link_libraries(
        obsidian PRIVATE filename_formatter miniz libluajit physfs-static
                         obsidian_zdbsp obsidian_slump
      )
    endif()
  elseif(${CMAKE_SYSTEM} MATCHES "BSD")
    if(NOT CONSOLE_ONLY)
      target_link_libraries(
        obsidian
        PRIVATE filename_formatter
                fltk
                fltk_images
                miniz
                libluajit
                physfs-static
                obsidian_zdbsp
                obsidian_slump
      )
    else()
      target_link_libraries(
        obsidian PRIVATE filename_formatter miniz libluajit physfs-static
                         obsidian_zdbsp obsidian_slump
      )
    endif()
  elseif(HAIKU)
    target_link_libraries(
      obsidian
      PRIVATE filename_formatter
              miniz
              libluajit
              physfs-static
              obsidian_zdbsp
              obsidian_slump
              pthread
              be
              root
    )
  else()
    if(NOT CONSOLE_ONLY)
      target_link_libraries(
        obsidian
        PRIVATE filename_formatter
                fltk
                fltk_images
                miniz
                libluajit
                physfs-static
                obsidian_zdbsp
                obsidian_slump
                ${FONTCONFIG}
                pthread
      )
    else()
      target_link_libraries(
        obsidian
        PRIVATE filename_formatter
                miniz
                libluajit
                physfs-static
                obsidian_zdbsp
                obsidian_slump
                pthread
      )
    endif()
  endif()
else()
  if(NOT CONSOLE_ONLY)
    target_link_libraries(
      obsidian
      PRIVATE filename_formatter
              fltk
              fltk_images
              miniz
              libluajit
              physfs-static
              obsidian_zdbsp
              obsidian_slump
    )
  else()
    target_link_libraries(
      obsidian PRIVATE filename_formatter miniz libluajit physfs-static
                       obsidian_zdbsp obsidian_slump
    )
  endif()
endif()

if(OBSIDIAN_INSTALL_STANDARD_LOCATION)
  set(INSTALL_BASEDIR "${CMAKE_INSTALL_PREFIX}/share/obsidian")
  install(FILES misc/obsidian.desktop
          DESTINATION "${CMAKE_INSTALL_PREFIX}/share/applications"
  )
else()
  set(INSTALL_BASEDIR "${CMAKE_INSTALL_PREFIX}")
endif()

install(TARGETS obsidian RUNTIME DESTINATION ${INSTALL_BASEDIR}
                                 CONFIGURATIONS Release
)
install(TARGETS qsavetex RUNTIME DESTINATION ${INSTALL_BASEDIR}/tools
                                 CONFIGURATIONS Release
)
install(
  DIRECTORY addons
            data
            engines
            games
            language
            modules
            ports
            scripts
            theme
            tools
  DESTINATION ${INSTALL_BASEDIR}
  CONFIGURATIONS Release
)
