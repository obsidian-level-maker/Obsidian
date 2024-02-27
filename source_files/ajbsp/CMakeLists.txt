##########################################
# AJBSP
##########################################

if (NOT MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fwrapv")
endif()

add_library(ajbsp
	bsp_level.cc
	bsp_misc.cc
	bsp_node.cc
	bsp_utility.cc
	bsp_wad.cc
)

target_include_directories(ajbsp PRIVATE ${OBSIDIAN_LIB_DIR}/almostequals)
target_include_directories(ajbsp PRIVATE ${OBSIDIAN_SOURCE_DIR}/ajparse)
target_include_directories(ajbsp PRIVATE ${OBSIDIAN_SOURCE_DIR}/obsidian_main)
target_include_directories(ajbsp PRIVATE ${OBSIDIAN_LIB_DIR}/miniz)