cmake_minimum_required(VERSION 3.12..3.20)

add_subdirectory(source_files/lua_src)
add_subdirectory(source_files/acc_src)
add_subdirectory(source_files/ajpoly_src)
add_subdirectory(source_files/physfs_src)
add_subdirectory(source_files/zdbsp_src)
add_subdirectory(source_files/slump_src)

project(obsidian LANGUAGES CXX VERSION 0.1.0)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "-O2 -Wall")
set(CMAKE_CXX_CLANG_TIDY clang-tidy --config=)

add_executable(obsidian 
    source_files/gui/csg_bsp.cc
    source_files/gui/csg_clip.cc
    source_files/gui/csg_doom.cc
    source_files/gui/csg_local.h
    source_files/gui/csg_main.cc
    source_files/gui/csg_main.h
    source_files/gui/csg_nukem.cc
    source_files/gui/csg_quake.cc
    source_files/gui/csg_quake.h
    source_files/gui/csg_shade.cc
    source_files/gui/csg_spots.cc
    source_files/gui/dm_extra.cc
    source_files/gui/dm_extra.h
    source_files/gui/dm_prefab.cc
    source_files/gui/dm_prefab.h
    source_files/gui/g_doom.cc
    source_files/gui/g_doom.h
    source_files/gui/g_nukem.cc
    source_files/gui/g_nukem.h
    source_files/gui/g_quake.cc
    source_files/gui/g_quake2.cc
    source_files/gui/g_quake3.cc
    source_files/gui/g_wolf.cc
    source_files/gui/hdr_fltk.h
    source_files/gui/hdr_lua.h
    source_files/gui/hdr_ui.h
    source_files/gui/headers.h
    source_files/gui/img_all.h
    source_files/gui/img_bolt.cc
    source_files/gui/img_carve.cc
    source_files/gui/img_font1.cc
    source_files/gui/img_pill.cc
    source_files/gui/img_relief.cc
    source_files/gui/lib_argv.cc
    source_files/gui/lib_argv.h
    source_files/gui/lib_crc.cc
    source_files/gui/lib_crc.h
    source_files/gui/lib_file.cc
    source_files/gui/lib_file.h
    source_files/gui/lib_grp.cc
    source_files/gui/lib_grp.h
    source_files/gui/lib_pak.cc
    source_files/gui/lib_pak.h
    source_files/gui/lib_signal.cc
    source_files/gui/lib_signal.h
    source_files/gui/lib_tga.cc
    source_files/gui/lib_tga.h
    source_files/gui/lib_util.cc
    source_files/gui/lib_util.h
    source_files/gui/lib_wad.cc
    source_files/gui/lib_wad.h
    source_files/gui/lib_zip.cc
    source_files/gui/lib_zip.h
    source_files/gui/m_about.cc
    source_files/gui/m_addons.cc
    source_files/gui/m_addons.h
    source_files/gui/m_cookie.cc
    source_files/gui/m_cookie.h
    source_files/gui/m_dialog.cc
    source_files/gui/m_lua.cc
    source_files/gui/m_lua.h
    source_files/gui/m_manage.cc
    source_files/gui/m_options.cc
    source_files/gui/m_trans.cc
    source_files/gui/m_trans.h
    source_files/gui/main.cc
    source_files/gui/main.h
    source_files/gui/q1_structs.h
    source_files/gui/q2_structs.h
    source_files/gui/q3_structs.h
    source_files/gui/q_common.cc
    source_files/gui/q_common.h
    source_files/gui/q_light.cc
    source_files/gui/q_light.h
    source_files/gui/q_tjuncs.cc
    source_files/gui/q_vis.cc
    source_files/gui/q_vis.h
    source_files/gui/sys_assert.cc
    source_files/gui/sys_assert.h
    source_files/gui/sys_debug.cc
    source_files/gui/sys_debug.h
    source_files/gui/sys_endian.h
    source_files/gui/sys_macro.h
    source_files/gui/sys_type.h
    source_files/gui/twister.cc
    source_files/gui/twister.h
    source_files/gui/tx_forge.cc
    source_files/gui/tx_forge.h
    source_files/gui/tx_skies.cc
    source_files/gui/tx_skies.h
    source_files/gui/ui_build.cc
    source_files/gui/ui_build.h
    source_files/gui/ui_game.cc
    source_files/gui/ui_game.h
    source_files/gui/ui_hyper.cc
    source_files/gui/ui_hyper.h
    source_files/gui/ui_map.cc
    source_files/gui/ui_map.h
    source_files/gui/ui_module.cc
    source_files/gui/ui_module.h
    source_files/gui/ui_rchoice.cc
    source_files/gui/ui_rchoice.h
    source_files/gui/ui_window.cc
    source_files/gui/ui_window.h
    source_files/gui/vis_buffer.cc
    source_files/gui/vis_buffer.h
    source_files/gui/vis_occlude.cc
    source_files/gui/vis_occlude.h
    source_files/gui/zf_menu.cc
    source_files/gui/zf_menu.h
)

target_include_directories(obsidian PRIVATE source_files/physfs_src)
target_include_directories(obsidian PRIVATE source_files/ajpoly_src)
target_include_directories(obsidian PRIVATE source_files/zdbsp_src)
target_include_directories(obsidian PRIVATE source_files/lua_src)
target_include_directories(obsidian PRIVATE source_files/slump_src)

if(UNIX)
    target_compile_definitions(obsidian PRIVATE UNIX)
endif()

find_package(FLTK REQUIRED)

target_link_libraries(obsidian PRIVATE 
    ${FLTK_LIBRARIES} 
    z 
    obsidian_lua
    obsidian_physfs 
    obsidian_acc 
    obsidian_ajpoly 
    obsidian_zdbsp
    obsidian_slump
)
