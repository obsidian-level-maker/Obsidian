if(NOT CONSOLE_ONLY AND NOT HAIKU)
  add_executable(
    obsidian
    bsp_level.cc
    bsp_misc.cc
    bsp_node.cc
    bsp_utility.cc
    bsp_wad.cc
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
    lib_parse.cc
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
    poly_map.cc
    poly.cc
    poly_util.cc
    poly_wad.cc
    q_common.cc
    q_light.cc
    q_tjuncs.cc
    q_vis.cc
    slump.cc
    slump_dump.cc
    slump_main.cc
    sys_debug.cc
    sys_xoshiro.cc
    tx_forge.cc
    tx_skies.cc
    vis_buffer.cc
  )
else()
  add_executable(
    obsidian
    bsp_level.cc
    bsp_misc.cc
    bsp_node.cc
    bsp_utility.cc
    bsp_wad.cc
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
    lib_parse.cc
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
    poly_map.cc
    poly.cc
    poly_util.cc
    poly_wad.cc
    q_common.cc
    q_light.cc
    q_tjuncs.cc
    q_vis.cc
    slump.cc
    slump_dump.cc
    slump_main.cc
    sys_debug.cc
    sys_xoshiro.cc
    tx_forge.cc
    tx_skies.cc
    vis_buffer.cc
  )
endif()

target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/almostequals)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/fastPRNG)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/gif-h)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/miniz)
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/physfs/src)
if(NOT CONSOLE_ONLY AND NOT HAIKU)
  target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/imgui)
  target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/sokol)
endif()
target_include_directories(obsidian PRIVATE ${OBSIDIAN_LIB_DIR}/utf8proc)

if(UNIX)
  target_compile_definitions(obsidian PRIVATE UNIX=1)
endif()
target_compile_definitions(obsidian PRIVATE OBSIDIAN_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}")

if(WIN32)
  target_link_libraries(
      obsidian
      PRIVATE imgui
              miniz
              physfs-static
              utf8proc
    )
elseif(NOT CONSOLE_ONLY AND NOT HAIKU)
  find_package(X11)
  if(X11_FOUND)
    set(XLIBS X11::X11 X11::Xi X11::Xcursor)
  endif()

  find_package(OpenGL REQUIRED)
  target_link_libraries(
    obsidian
    PRIVATE imgui
            miniz
            physfs-static
            ${XLIBS}
            OpenGL::OpenGL
            utf8proc
  )
else()
  target_link_libraries(
    obsidian PRIVATE miniz physfs-static
                      utf8proc
  )
endif()

set(COPY_FILES "")

set (DEST_DIR "${CMAKE_SOURCE_DIR}")
list(APPEND COPY_FILES "$<TARGET_FILE:obsidian>")

if (COPY_FILES)
  add_custom_command( TARGET obsidian POST_BUILD COMMAND_EXPAND_LISTS COMMAND ${CMAKE_COMMAND} -E copy_if_different ${COPY_FILES} ${DEST_DIR})
endif()
