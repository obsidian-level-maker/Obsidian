if(NOT CONSOLE_ONLY AND NOT HAIKU)
  add_executable(
    obsidian
    aj_map.cc
    aj_poly.cc
    aj_util.cc
    aj_wad.cc
    csg_bsp.cc
    csg_clip.cc
    csg_doom.cc
    csg_main.cc
    csg_nukem.cc
    csg_quake.cc
    csg_shade.cc
    csg_spots.cc
    dm_extra.cc
    dm_prefab.cc
    g_doom.cc
    g_nukem.cc
    g_quake.cc
    g_quake2.cc
    g_wolf.cc
    lib_argv.cc
    lib_grp.cc
    lib_pak.cc
    lib_tga.cc
    lib_util.cc
    lib_wad.cc
    lib_zip.cc
    m_addons.cc
    m_cookie.cc
    m_lua.cc
    m_options.cc
    m_trans.cc
    main.cc
    obsidian.rc
    q_common.cc
    q_light.cc
    q_tjuncs.cc
    q_vis.cc
    sys_assert.cc
    sys_debug.cc
    sys_xoshiro.cc
    tx_forge.cc
    tx_skies.cc
    vis_buffer.cc
  )
else()
  add_executable(
    obsidian
    aj_map.cc
    aj_poly.cc
    aj_util.cc
    aj_wad.cc
    csg_bsp.cc
    csg_clip.cc
    csg_doom.cc
    csg_main.cc
    csg_nukem.cc
    csg_quake.cc
    csg_shade.cc
    csg_spots.cc
    dm_extra.cc
    dm_prefab.cc
    g_doom.cc
    g_nukem.cc
    g_quake.cc
    g_quake2.cc
    g_wolf.cc
    lib_argv.cc
    lib_grp.cc
    lib_pak.cc
    lib_tga.cc
    lib_util.cc
    lib_wad.cc
    lib_zip.cc
    m_addons.cc
    m_cookie.cc
    m_lua.cc
    m_options.cc
    m_trans.cc
    main.cc
    obsidian.rc
    q_common.cc
    q_light.cc
    q_tjuncs.cc
    q_vis.cc
    sys_assert.cc
    sys_debug.cc
    sys_xoshiro.cc
    tx_forge.cc
    tx_skies.cc
    vis_buffer.cc
  )
endif()

target_include_directories(obsidian PRIVATE ${OBSIDIAN_SOURCE_DIR}/ajbsp)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_SOURCE_DIR}/ajparse)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/gif-h)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/miniz)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/physfs/src)
if((WIN32 AND (MSVC OR CLANG)) AND NOT CONSOLE_ONLY)
  target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/sdl2/include)
endif()
target_include_directories(obsidian PRIVATE ${OBSIDIAN_SOURCE_DIR}/slump)

if(NOT CONSOLE_ONLY)
  target_link_libraries(
    obsidian
    PRIVATE ajbsp
            ajparse
            ${SDL2_LIBRARIES}
            miniz
            physfs-static
            obsidian_slump
  )
else()
  target_link_libraries(
    obsidian PRIVATE ajbsp ajparse miniz physfs-static
                      obsidian_slump
  )
endif()

set(COPY_FILES "")

set (DEST_DIR "${CMAKE_SOURCE_DIR}")
list(APPEND COPY_FILES "$<TARGET_FILE:obsidian>")

# Copy appropriate SDL2.dll to local install directory when built with MSVC/Clang
if (WIN32 AND NOT CONSOLE_ONLY)
  if(MSVC OR CLANG)
    if (${CMAKE_SIZEOF_VOID_P} MATCHES 8)
      list(APPEND COPY_FILES "${CMAKE_SOURCE_DIR}/libraries/sdl2/lib/x64/SDL2.dll")
    else ()
      list(APPEND COPY_FILES "${CMAKE_SOURCE_DIR}/libraries/sdl2/lib/x86/SDL2.dll")
    endif ()
  endif()
endif()

if (COPY_FILES)
  add_custom_command( TARGET obsidian POST_BUILD COMMAND_EXPAND_LISTS COMMAND ${CMAKE_COMMAND} -E copy_if_different ${COPY_FILES} ${DEST_DIR})
endif()