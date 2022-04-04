project(
  obsidian_lua
  LANGUAGES C CXX
  VERSION 0.1.0
)

set(CMAKE_C_FLAGS "-DLUA_ANSI")

if(UNIX
   OR MINGW
   OR MSYS
)
  set(CMAKE_C_FLAGS "-DLUA_USE_MKSTEMP")
endif()

add_library(
  obsidian_lua STATIC
  lapi.c
  lauxlib.c
  lbaselib.c
  lcode.c
  lcorolib.c
  lctype.c
  ldblib.c
  ldebug.c
  ldo.c
  ldump.c
  lfunc.c
  lgc.c
  linit.c
  liolib.c
  llex.c
  lmathlib.c
  lmem.c
  loadlib.c
  lobject.c
  lopcodes.c
  loslib.c
  lparser.c
  lstate.c
  lstring.c
  lstrlib.c
  ltable.c
  ltablib.c
  ltm.c
  lundump.c
  lutf8lib.c
  lvm.c
  lzio.c
)
