cmake_minimum_required( VERSION 2.4 )

if( CMAKE_COMPILER_IS_GNUC )
	set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fomit-frame-pointer" )
endif( CMAKE_COMPILER_IS_GNUC )

add_library( z
    adler32.c
    compress.c
    crc32.c
    deflate.c
    trees.c
    zutil.c
    crc32.h
    deflate.h
    gzguts.h
    trees.h
    zconf.h
    zlib.h
    zutil.h )
target_link_libraries( z )
