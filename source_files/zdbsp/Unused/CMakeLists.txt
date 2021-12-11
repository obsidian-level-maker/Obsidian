cmake_minimum_required(VERSION 2.4)
if(COMMAND cmake_policy)
  cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

include(CheckFunctionExists)
include(CheckCXXCompilerFlag)

project(ZDBSP)

if(NOT CMAKE_BUILD_TYPE)
  set(
    CMAKE_BUILD_TYPE
    Debug
    CACHE
    STRING
    "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
    FORCE
  )
endif(NOT CMAKE_BUILD_TYPE)

set(SSE_MATTERS NO)

# SSE only matters on 32-bit targets. We check compiler flags to know if we can
# do it.
if(CMAKE_SIZEOF_VOID_P MATCHES "4")
  check_cxx_compiler_flag("-msse2 -mfpmath=sse" CAN_DO_MFPMATH)
  check_cxx_compiler_flag(-arch:SSE2 CAN_DO_ARCHSSE2)
  if(CAN_DO_MFPMATH)
    set(SSE1_ENABLE "-msse -mfpmath=sse")
    set(SSE2_ENABLE "-msse2 -mfpmath=sse")
    set(SSE_MATTERS YES)
  elseif(CAN_DO_ARCHSSE2)
    set(SSE1_ENABLE -arch:SSE)
    set(SSE2_ENABLE -arch:SSE2)
    set(SSE_MATTERS YES)
  endif(CAN_DO_MFPMATH)
endif(CMAKE_SIZEOF_VOID_P MATCHES "4")

if(SSE_MATTERS)
  if(WIN32)
    set(
      BACKPATCH
      1
      CACHE BOOL "Enable backpatching."
    )
  else(WIN32)
    check_function_exists(mprotect HAVE_MPROTECT)
    if(HAVE_MPROTECT)
      set(
        BACKPATCH
        1
        CACHE BOOL "Enable backpatching."
      )
    else(HAVE_MPROTECT)
      set(BACKPATCH 0)
    endif(HAVE_MPROTECT)
  endif(WIN32)
  set(
    FULL_SSE2
    0
    CACHE BOOL "Use SSE2 math everywhere."
  )
  set(
    SSE
    1
    CACHE BOOL "Build SSE and SSE2 versions of key code."
  )
else(SSE_MATTERS)
  set(BACKPATCH 0)
endif(SSE_MATTERS)

if(CMAKE_COMPILER_IS_GNUCXX)
  set(
    GPROF
    0
    CACHE
    BOOL
    "Enable profiling with gprof for Debug and RelWithDebInfo build types."
  )
  set(
    PROFILE
    0
    CACHE INT "1=Generate profile coverage info, 2=Use it"
  )
endif(CMAKE_COMPILER_IS_GNUCXX)

find_package(ZLIB)

if(MSVC)
  # Eliminate unreferenced functions and data Perform identical COMDAT folding
  set(REL_LINKER_FLAGS "/opt:ref /opt:icf /nodefaultlib:msvcrt")

  # String pooling Function-level linking Disable run-time type information
  set(ALL_C_FLAGS "/GF /Gy /GR-")

  # Avoid CRT DLL dependancies in release builds
  set(REL_C_FLAGS "/MT")

  # Disable warnings for unsecure CRT functions from VC8+
  if(MSVC_VERSION GREATER 1399)
    set(ALL_C_FLAGS "${ALL_C_FLAGS} /wd4996")
  endif(MSVC_VERSION GREATER 1399)

  # The CMake configurations set /GR and /MD by default, which conflict with our
  # settings.
  string(REPLACE "/MD " " " CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
  string(
    REPLACE "/MD " " " CMAKE_CXX_FLAGS_MINSIZEREL
    ${CMAKE_CXX_FLAGS_MINSIZEREL}
  )
  string(
    REPLACE "/MD " " " CMAKE_CXX_FLAGS_RELWITHDEBINFO
    ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}
  )
  string(REPLACE "/MD " " " CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE})
  string(
    REPLACE "/MD " " " CMAKE_C_FLAGS_MINSIZEREL
    ${CMAKE_C_FLAGS_MINSIZEREL}
  )
  string(
    REPLACE "/MD " " " CMAKE_C_FLAGS_RELWITHDEBINFO
    ${CMAKE_C_FLAGS_RELWITHDEBINFO}
  )
  string(REPLACE " /GR" " " CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
endif(MSVC)

if(CMAKE_COMPILER_IS_GNUCXX)
  set(ALL_C_FLAGS "${ALL_C_FLAGS} -ffast-math -pipe")
  if(GPROF)
    set(ALL_C_FLAGS "${ALL_C_FLAGS} -pg -g")
  else(GPROF)
    set(REL_C_FLAGS "${REL_C_FLAGS} -fomit-frame-pointer")
  endif(GPROF)
  if(PROFILE EQUAL 1)
    message(STATUS "Generating profile coverage information")
    set(ALL_C_FLAGS "${ALL_C_FLAGS} -fprofile-generate")
    set(PROF_LIB "gcov")
  elseif(PROFILE EQUAL 2)
    message(STATUS "Using profile coverage information")
    set(ALL_C_FLAGS "${ALL_C_FLAGS} -fprofile-use")
  endif(PROFILE EQUAL 1)
endif(CMAKE_COMPILER_IS_GNUCXX)

# if( WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" ) set( ALL_C_FLAGS
# "${ALL_C_FLAGS} -Wno-deprecated-declarations -Wno-format" ) endif( WIN32 AND
# "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" )

if(ZLIB_FOUND)
  message(STATUS "Using system zlib")
else(ZLIB_FOUND)
  message(STATUS "Using internal zlib")
  add_subdirectory(zlib)
  set(ZLIB_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/zlib)
  set(ZLIB_LIBRARIES z)
  set(ZLIB_LIBRARY z)
endif(ZLIB_FOUND)

if(BACKPATCH)
  add_definitions(-DBACKPATCH)
endif(BACKPATCH)

check_function_exists(stricmp STRICMP_EXISTS)
if(NOT STRICMP_EXISTS)
  add_definitions(-Dstricmp=strcasecmp)
endif(NOT STRICMP_EXISTS)

check_function_exists(strnicmp STRNICMP_EXISTS)
if(NOT STRNICMP_EXISTS)
  add_definitions(-Dstrnicmp=strncasecmp)
endif(NOT STRNICMP_EXISTS)

set(ZDBSP_LIBS "${ZLIB_LIBRARIES}")
set(
  SOURCES
  main.cpp
  getopt.c
  getopt1.c
  blockmapbuilder.cpp
  processor.cpp
  processor_udmf.cpp
  sc_man.cpp
  wad.cpp
  nodebuild.cpp
  nodebuild_events.cpp
  nodebuild_extract.cpp
  nodebuild_gl.cpp
  nodebuild_utility.cpp
  nodebuild_classify_nosse2.cpp
)
if(WIN32)
  set(SOURCES "${SOURCES}" view.cpp)
else(WIN32)
  add_definitions(-DNO_MAP_VIEWER)
endif(WIN32)

set(
  HEADERS
  blockmapbuilder.h
  doomdata.h
  getopt.h
  nodebuild.h
  processor.h
  resource.h
  sc_man.h
  tarray.h
  templates.h
  wad.h
  workdata.h
  zdbsp.h
  xs_Float.h
)

if(SSE_MATTERS)
  if(FULL_SSE2)
    message(STATUS "Using SSE2 math everywhere.")
    # Building everything with SSE2 is much like disabling it, in that we need
    # not check for its existance while running.
    set(ALL_C_FLAGS "${ALL_C_FLAGS} -DDISABLE_SSE ${SSE2_ENABLE}")
  else(FULL_SSE2)
    if(SSE)
      message(STATUS "Using SSE math for ClassifyLine only.")
      set(
        SOURCES ${SOURCES} nodebuild_classify_sse1.cpp
        nodebuild_classify_sse2.cpp
      )
      set_source_files_properties(nodebuild_classify_sse1.cpp PROPERTIES COMPILE_FLAGS "${SSE1_ENABLE}")
      set_source_files_properties(nodebuild_classify_sse2.cpp PROPERTIES COMPILE_FLAGS "${SSE2_ENABLE}")
    else(SSE)
      message(STATUS "SSE math is completely disabled.")
      set(ALL_C_FLAGS "${ALL_C_FLAGS} -DDISABLE_SSE")
    endif(SSE)
  endif(FULL_SSE2)
else(SSE_MATTERS)
  set(ALL_C_FLAGS "${ALL_C_FLAGS} -DDISABLE_SSE")
endif(SSE_MATTERS)

if(WIN32)
  set(ZDBSP_LIBS ${ZDBSP_LIBS} user32 gdi32)

  if(CMAKE_COMPILER_IS_GNUCXX)
    # CMake is not set up to compile and link rc files with GCC. :(
    add_custom_command(
      OUTPUT zdbsp-rc.o
      COMMAND ${CMAKE_RC_COMPILER} -o zdbsp-rc.o -i
      ${CMAKE_CURRENT_SOURCE_DIR}/resource.rc
      DEPENDS resource.rc
    )
    set(SOURCES ${SOURCES} zdbsp-rc.o)
  else(CMAKE_COMPILER_IS_GNUCXX)
    set(SOURCES ${SOURCES} resource.rc)
  endif(CMAKE_COMPILER_IS_GNUCXX)
endif(WIN32)

set(
  CMAKE_EXE_LINKER_FLAGS_RELEASE
  "${CMAKE_EXE_LINKER_FLAGS_RELEASE} ${REL_LINKER_FLAGS}"
)
set(
  CMAKE_EXE_LINKER_FLAGS_MINSIZEREL
  "${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL} ${REL_LINKER_FLAGS}"
)
set(
  CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO
  "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} ${REL_LINKER_FLAGS}"
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ALL_C_FLAGS}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${REL_C_FLAGS}")
set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${REL_C_FLAGS}")
set(
  CMAKE_C_FLAGS_RELWITHDEBINFO
  "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${REL_C_FLAGS}"
)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${DEB_C_FLAGS} -D_DEBUG")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ALL_C_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${REL_C_FLAGS}")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} ${REL_C_FLAGS}")
set(
  CMAKE_CXX_FLAGS_RELWITHDEBINFO
  "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${REL_C_FLAGS}"
)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${DEB_C_FLAGS} -D_DEBUG")

add_executable(zdbsp ${SOURCES} ${HEADERS})
target_link_libraries(zdbsp ${ZDBSP_LIBS} ${PROF_LIB})
include_directories("${ZLIB_INCLUDE_DIR}")

install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/zdbsp" DESTINATION bin)
