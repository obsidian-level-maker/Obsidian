cmake_minimum_required(VERSION 3.12..3.20)

project(obsidian_lua LANGUAGES C CXX VERSION 0.1.0)

add_library(obsidian_lua STATIC
    source_files/lua_src/lapi.c
    source_files/lua_src/lapi.h
    source_files/lua_src/lauxlib.c
    source_files/lua_src/lauxlib.h
    source_files/lua_src/lbaselib.c
    source_files/lua_src/lcode.c
    source_files/lua_src/lcode.h
    source_files/lua_src/lcorolib.c
    source_files/lua_src/lctype.c
    source_files/lua_src/lctype.h
    source_files/lua_src/ldblib.c
    source_files/lua_src/ldebug.c
    source_files/lua_src/ldebug.h
    source_files/lua_src/ldo.c
    source_files/lua_src/ldo.h
    source_files/lua_src/ldump.c
    source_files/lua_src/lfunc.c
    source_files/lua_src/lfunc.h
    source_files/lua_src/lgc.c
    source_files/lua_src/lgc.h
    source_files/lua_src/linit.c
    source_files/lua_src/liolib.c
    source_files/lua_src/ljumptab.h
    source_files/lua_src/llex.c
    source_files/lua_src/llex.h
    source_files/lua_src/llimits.h
    source_files/lua_src/lmathlib.c
    source_files/lua_src/lmem.c
    source_files/lua_src/lmem.h
    source_files/lua_src/loadlib.c
    source_files/lua_src/lobject.c
    source_files/lua_src/lobject.h
    source_files/lua_src/lopcodes.c
    source_files/lua_src/lopcodes.h
    source_files/lua_src/lopnames.h
    source_files/lua_src/loslib.c
    source_files/lua_src/lparser.c
    source_files/lua_src/lparser.h
    source_files/lua_src/lprefix.h
    source_files/lua_src/lstate.c
    source_files/lua_src/lstate.h
    source_files/lua_src/lstring.c
    source_files/lua_src/lstring.h
    source_files/lua_src/lstrlib.c
    source_files/lua_src/ltable.c
    source_files/lua_src/ltable.h
    source_files/lua_src/ltablib.c
    source_files/lua_src/ltm.c
    source_files/lua_src/ltm.h
    source_files/lua_src/lua.hpp
    source_files/lua_src/luaconf.h
    source_files/lua_src/lualib.h
    source_files/lua_src/lundump.c
    source_files/lua_src/lundump.h
    source_files/lua_src/lutf8lib.c
    source_files/lua_src/lvm.c
    source_files/lua_src/lvm.h
    source_files/lua_src/lzio.c
    source_files/lua_src/lzio.h
)

project(obsidian_acc LANGUAGES C VERSION 0.1.0)

add_library(obsidian_acc
    source_files/acc_src/acc.c
    source_files/acc_src/common.h
    source_files/acc_src/error.c
    source_files/acc_src/error.h
    source_files/acc_src/misc.c
    source_files/acc_src/misc.h
    source_files/acc_src/parse.c
    source_files/acc_src/parse.h
    source_files/acc_src/pcode.c
    source_files/acc_src/pcode.h
    source_files/acc_src/strlist.c
    source_files/acc_src/strlist.h
    source_files/acc_src/symbol.c
    source_files/acc_src/symbol.h
    source_files/acc_src/token.c
    source_files/acc_src/token.h
)

project(obsidian_ajpoly LANGUAGES CXX VERSION 0.1.0)

add_library(obsidian_ajpoly
    source_files/ajpoly_src/ajpoly.h
    source_files/ajpoly_src/pl_endian.h
    source_files/ajpoly_src/pl_local.h
    source_files/ajpoly_src/pl_map.cc
    source_files/ajpoly_src/pl_map.h
    source_files/ajpoly_src/pl_poly.cc
    source_files/ajpoly_src/pl_structs.h
    source_files/ajpoly_src/pl_util.cc
    source_files/ajpoly_src/pl_util.h
    source_files/ajpoly_src/pl_wad.cc
    source_files/ajpoly_src/pl_wad.h
)
target_include_directories(obsidian_ajpoly PRIVATE source_files/physfs_src)

project(obsidian_physfs LANGUAGES CXX VERSION 0.1.0)

add_library(obsidian_physfs
    source_files/physfs_src/physfs.cc
    source_files/physfs_src/physfs.h
    source_files/physfs_src/physfs_archiver_7z.cc
    source_files/physfs_src/physfs_archiver_dir.cc
    source_files/physfs_src/physfs_archiver_grp.cc
    source_files/physfs_src/physfs_archiver_hog.cc
    source_files/physfs_src/physfs_archiver_iso9660.cc
    source_files/physfs_src/physfs_archiver_mvl.cc
    source_files/physfs_src/physfs_archiver_qpak.cc
    source_files/physfs_src/physfs_archiver_slb.cc
    source_files/physfs_src/physfs_archiver_unpacked.cc
    source_files/physfs_src/physfs_archiver_vdf.cc
    source_files/physfs_src/physfs_archiver_wad.cc
    source_files/physfs_src/physfs_archiver_zip.cc
    source_files/physfs_src/physfs_byteorder.cc
    source_files/physfs_src/physfs_casefolding.h
    source_files/physfs_src/physfs_internal.h
    source_files/physfs_src/physfs_lzmasdk.h
    source_files/physfs_src/physfs_miniz.h
    source_files/physfs_src/physfs_platform_apple.m
    source_files/physfs_src/physfs_platform_os2.cc
    source_files/physfs_src/physfs_platform_posix.cc
    source_files/physfs_src/physfs_platform_qnx.cc
    source_files/physfs_src/physfs_platform_unix.cc
    source_files/physfs_src/physfs_platform_windows.cc
    source_files/physfs_src/physfs_platforms.h
    source_files/physfs_src/physfs_unicode.cc
)

project(obsidian_zdbsp LANGUAGES CXX VERSION 0.1.0)

add_library(obsidian_zdbsp
    source_files/zdbsp_src/blockmapbuilder.cc
    source_files/zdbsp_src/blockmapbuilder.h
    source_files/zdbsp_src/doomdata.h
    source_files/zdbsp_src/nodebuild.cc
    source_files/zdbsp_src/nodebuild.h
    source_files/zdbsp_src/nodebuild_classify_nosse2.cc
    source_files/zdbsp_src/nodebuild_events.cc
    source_files/zdbsp_src/nodebuild_extract.cc
    source_files/zdbsp_src/nodebuild_gl.cc
    source_files/zdbsp_src/nodebuild_utility.cc
    source_files/zdbsp_src/processor.cc
    source_files/zdbsp_src/processor.h
    source_files/zdbsp_src/processor_udmf.cc
    source_files/zdbsp_src/rejectbuilder.cc
    source_files/zdbsp_src/rejectbuilder.h
    source_files/zdbsp_src/rejectbuilder_nogl.cc
    source_files/zdbsp_src/rejectbuilder_nogl.h
    source_files/zdbsp_src/sc_man.cc
    source_files/zdbsp_src/sc_man.h
    source_files/zdbsp_src/tarray.h
    source_files/zdbsp_src/templates.h
    source_files/zdbsp_src/vis.cc
    source_files/zdbsp_src/visflow.cc
    source_files/zdbsp_src/workdata.h
    source_files/zdbsp_src/xs_Float.h
    source_files/zdbsp_src/zdbsp.h
    source_files/zdbsp_src/zdmain.cc
    source_files/zdbsp_src/zdmain.h
    source_files/zdbsp_src/zdwad.cc
    source_files/zdbsp_src/zdwad.h
    source_files/zdbsp_src/zlib/crc32.h
    source_files/zdbsp_src/zlib/deflate.h
    source_files/zdbsp_src/zlib/gzguts.h
    source_files/zdbsp_src/zlib/trees.h
    source_files/zdbsp_src/zlib/zconf.h
    source_files/zdbsp_src/zlib/zlib.h
    source_files/zdbsp_src/zlib/zutil.h
)

project(obsidian LANGUAGES CXX VERSION 0.1.0)

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

if(UNIX)
    target_compile_definitions(obsidian PRIVATE UNIX)
endif()

find_package(FLTK REQUIRED)
find_package(Lua REQUIRED)

target_link_libraries(obsidian PRIVATE 
    ${FLTK_LIBRARIES} 
    ${LUA_LIBRARIES}
    z 
    obsidian_lua
    obsidian_physfs 
    obsidian_acc 
    obsidian_ajpoly 
    obsidian_zdbsp
)
