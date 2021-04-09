project(obsidian_ajpoly LANGUAGES CXX VERSION 0.1.0)

add_library(obsidian_ajpoly
    ajpoly.h
    pl_endian.h
    pl_local.h
    pl_map.cc
    pl_map.h
    pl_poly.cc
    pl_structs.h
    pl_util.cc
    pl_util.h
    pl_wad.cc
    pl_wad.h
)
target_include_directories(obsidian_ajpoly PRIVATE ../physfs_src)
